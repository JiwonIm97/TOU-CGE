#!/usr/bin/env python3
"""
strip_cbam.py -- Essay 1(CBAM) 요소를 제거하여 ToU 전용 모형으로 정리

CBAM-CGE 저장소를 입력받아, CBAM 고유 요소를 제거한 사본을 만든다.
기계적·재현 가능하게 수행하고, 마지막에 잔류 참조를 검사한다.

실행:
    python strip_cbam.py --src /path/to/CBAM-CGE --dst /path/to/TOU-CGE

제거 대상
    TCBAM, CP, CO2IDFACTOR, EQ16_4          CBAM 관세수입
    z3 z4 z5, I3 I4, J11                    CBAM 지역·부문 매핑
    EQ96~EQ101                              CBAM 세수환류 도구 (생산세·노동세 감면)
    deltattip ttip_share deltattiw ttiw_share
    rcy_lab rcy_prd                         해당 환류 수단
    Scenario/S0~S4, _CarbonPrice_Path       CBAM 시나리오

유지 대상 (CBAM 처럼 보이나 구조적)
    CTAX TCTAX CO2FACTOR                    탄소세. PEP 표준이며 환경축에 필요
    rcy_share rcy_hh rcy_gov, RCY_IN 매크로 Essay2 S2 환류에 필요
    frisch                                  z3/z4/z5 의존을 지역별 명시 할당으로 대체
"""

from __future__ import annotations

import argparse
import re
import shutil
from pathlib import Path

# =============================================================================
# frisch 재할당  (z3/z4/z5 의 원값을 그대로 보존)
#   z3 = {07_EU}                                            -> -1.1
#   z4 = {01_KOR,02_CHN,03_JPN,05_RUS,06_USA,08_OHI,09_OUMIC}-> -1.3
#   z5 = {04_IND,10_OLMIC,11_OLI}                            -> -1.5
# =============================================================================
FRISCH_NEW = """*------------------------------------------------------------------------------
* LES parameters - Frisch
* [ToU refactor] CBAM 지역집합(z3/z4/z5) 의존을 제거하고 지역별로 명시 할당.
*   원 코드의 값을 그대로 보존한다. 한국은 -1.3.
* !! Essay 2 에서는 frisch 가 가계 전력수요 탄력성을 지배한다.
*    함의 탄력성 eps_elec ~ sigma_Y(elec)/frisch 를 확인하고 필요시 재보정할 것.
 frisch('07_EU')    = -1.1;
 frisch('01_KOR')   = -1.3;
 frisch('02_CHN')   = -1.3;
 frisch('03_JPN')   = -1.3;
 frisch('05_RUS')   = -1.3;
 frisch('06_USA')   = -1.3;
 frisch('08_OHI')   = -1.3;
 frisch('09_OUMIC') = -1.3;
 frisch('04_IND')   = -1.5;
 frisch('10_OLMIC') = -1.5;
 frisch('11_OLI')   = -1.5;

 ABORT$(SMIN(z, ABS(frisch(z))) < 1e-8)
     "frisch is zero for some region: CMINO would divide by zero", frisch;
"""


RECYCLING_TOU = """* ==============================================================================
* Policy/Recycling.gms   [ToU]
* 요금 wedge 수입의 환류 스위치. Model.gms 보다 먼저 include.
* ------------------------------------------------------------------------------
*  "누가 징수하는가"  : wedge 를 부과한 지역
*  "누구에게 가는가"  : rcy_share(징수지역, 수령지역)
*  "무엇에 쓰는가"    : rcy_hh (가계 정액이전) / rcy_gov (정부 보유)
* ==============================================================================

PARAMETER
 rcy_share(z,zj)   Revenue share transferred from collecting region z to region zj
 rcy_hh(z)         1 if revenue received by z is transferred lump-sum to households
 rcy_gov(z)        1 if revenue received by z accrues to the general government budget
 rcy_chk(z)        Row sum of rcy_share (must be 0 or 1)
;

 rcy_share(z,zj) = 0;
 rcy_hh(z)  = 0;
 rcy_gov(z) = 0;

$macro RCY_IN(zz)   [SUM(zjj, rcy_share(zjj,zz)*RCY_POOL(zjj))]
$macro RCY_INF(zz)  [SUM(zjj$(NOT SAMEAS(zjj,zz)), rcy_share(zjj,zz)*RCY_POOL(zjj))]
$macro RCY_OUTF(zz) [RCY_POOL(zz)*SUM(zjj$(NOT SAMEAS(zjj,zz)), rcy_share(zz,zjj))]
"""

RESET_TOU = """* ==============================================================================
* Scenario/Reset_Policy.gms   [ToU]
* 시나리오 간 오염 방지. 매 시나리오 solve 파일 앞에서 호출.
* ==============================================================================
 rcy_share(z,zj) = 0;
 rcy_hh(z)  = 0;
 rcy_gov(z) = 0;

 CTAX.FX(z) = CTAX0(z);

 tth.FX(i,z)     = tth0(i,z);
 tth_B_raw(b,z)  = 0;
 e2_expost(z)    = 0;
"""

APPLY_TOU = """* ==============================================================================
* Scenario/Apply_Policy.gms   [ToU]
* 스위치 정합성 검증. 시나리오 파일에서 스위치 설정 직후, solve 이전에 호출.
* ==============================================================================
 rcy_chk(z) = SUM(zj, rcy_share(z,zj));
 ABORT$(SMAX(z, ABS(rcy_chk(z))*ABS(rcy_chk(z)-1)) > 1e-8)
     "rcy_share: collecting-region shares must sum to 0 or 1", rcy_chk;

 ABORT$(SMAX(z, rcy_hh(z)+rcy_gov(z)) > 1)
     "only one recycling instrument per region is allowed";

 ABORT$(SMAX(z, ABS(SUM(b,theta_B(b,z))-1)) > 1e-8)
     "theta_B must sum to 1", theta_B;
"""


def drop_block(text: str, start_pat: str, end_pat: str, label: str,
               log: list[str]) -> str:
    """start_pat 부터 end_pat 직전까지 삭제."""
    m0 = re.search(start_pat, text, re.M)
    if not m0:
        log.append(f"  SKIP  {label} (시작 앵커 없음)")
        return text
    m1 = re.search(end_pat, text[m0.end():], re.M)
    if not m1:
        log.append(f"  SKIP  {label} (종료 앵커 없음)")
        return text
    end = m0.end() + m1.start()
    log.append(f"  DROP  {label}  ({text[m0.start():end].count(chr(10))} lines)")
    return text[:m0.start()] + text[end:]


def drop_lines(text: str, pattern: str, label: str, log: list[str]) -> str:
    """pattern 이 포함된 줄을 삭제."""
    lines = text.split("\n")
    keep = [ln for ln in lines if not re.search(pattern, ln)]
    n = len(lines) - len(keep)
    log.append(f"  DROP  {label}  ({n} lines)")
    return "\n".join(keep)


def process(src: Path, dst: Path) -> None:
    log: list[str] = []

    if dst.exists():
        shutil.rmtree(dst)
    shutil.copytree(src, dst, ignore=shutil.ignore_patterns(
        ".git", "*.gdx", "*.lst", "*.lxi", "*.log", "Output_w-1", "Verify"))
    (dst / "Output_w-1").mkdir(exist_ok=True)
    (dst / "Verify").mkdir(exist_ok=True)

    # 입력 GDX 는 필요하므로 되살린다
    for sub in ("Input_w-1", "Input_WEB"):
        s = src / sub
        if s.exists():
            shutil.copytree(s, dst / sub, dirs_exist_ok=True)

    # -------------------------------------------------------------- Sets.gms
    log.append("Sets.gms")
    p = dst / "Sets.gms"
    t = p.read_text(encoding="utf-8")
    t = drop_block(t, r"^ I3\(I\) Non-CBAM commodities", r"^ ENE\(I\)", "I3 / I4", log)
    t = drop_block(t, r"^ J11\(J\) CBAM target industries", r"^ Z2\(Z\)", "J11", log)
    t = drop_block(t, r"^\*\*\* Mapping for CBAM", r"^ INDtoCOM", "z3 / z4 / z5", log)
    t = t.replace("$LOAD J, I, I1, BUS, PUB, F, L, K, Z, ZR, Z1, Zrich, Zother",
                  "$LOAD J, I, I1, BUS, PUB, F, L, K, Z, ZR, Z1, Zrich, Zother")
    t = t.replace("$TITLE    CBAM model", "$TITLE    TOU model")
    t = t.replace("CBAM 지역/부문 매핑", "지역/부문 매핑")
    t = t.replace("set sim /1*12/;", "set sim /1*1/;")
    p.write_text(t, encoding="utf-8")

    # --------------------------------------------------------------- PAR.gms
    log.append("PAR.gms")
    p = dst / "PAR.gms"
    t = p.read_text(encoding="utf-8")
    t = drop_block(t,
                   r"^\*-+\n\* LES parameters - Frisch",
                   r"^\*-+\n\* Slopes of taxation functions",
                   "frisch (z3/z4/z5 기반)", log)
    t = t.replace("*------------------------------------------------------------------------------\n"
                  "* Slopes of taxation functions",
                  FRISCH_NEW +
                  "\n*------------------------------------------------------------------------------\n"
                  "* Slopes of taxation functions", 1)
    t = drop_lines(t, r"\bTCBAM\(|deltattip\(|deltattiw\(|ttip_share\(|ttiw_share\(",
                   "CBAM 환류 도구 선언", log)
    p.write_text(t, encoding="utf-8")

    # --------------------------------------------------------------- CAL.gms
    log.append("CAL.gms")
    p = dst / "CAL.gms"
    t = p.read_text(encoding="utf-8")
    t = drop_lines(t, r"CO2IDFACTOR|TCBAMO?\s*\(|deltattip|deltattiw|ttip_shareO?\s*\(|ttiw_shareO?\s*\(",
                   "CBAM 보정", log)
    p.write_text(t, encoding="utf-8")

    # ------------------------------------------------------------- Model.gms
    log.append("Model.gms")
    p = dst / "Model.gms"
    t = p.read_text(encoding="utf-8")

    # (1) 블록 본문 먼저 — 라인 삭제가 앵커를 지우기 전에
    t = drop_block(t, r"^ EQ16_4\(z\)\.\.", r"^ EQ16\(z\)\.\.", "EQ16_4 (CBAM 관세수입)", log)
    i = t.find("*  5.4 CBAM revenue-recycling instruments")
    if i >= 0:
        j = t.rfind("*====", 0, i)          # 직전 구분선까지 포함해 파일 끝까지 삭제
        j = j if j >= 0 else i
        log.append(f"  DROP  EQ96~EQ101 (CBAM 환류도구)  ({t[j:].count(chr(10))} lines, to EOF)")
        t = t[:j].rstrip() + "\n"
    else:
        log.append("  SKIP  EQ96~EQ101 (앵커 없음)")

    # (2) 변수·방정식 선언
    t = drop_lines(t, r"^\s*(CP|TCBAM)\(z\)\s+|deltattip\(j,z\)|ttip_share\(j,z\)"
                      r"|deltattiw\(l,j,z\)|ttiw_share\(l,j,z\)"
                      r"|^\s*EQ(96|97|98|99|100|101)\(|^\s*EQ16_4\(z\)\s+"
                      r"|CBAM revenue-recycling instruments",
                   "CBAM 변수·방정식 선언", log)

    # 개별 항 제거
    subs = [
        (r"YG\(z\) =e= TDH\(z\)\+TPRODN\(z\)\+TPRCTS\(z\)\+TCTAX\(z\) \+ TCBAM\(z\) \+ RCY_INF\(z\);",
         "YG(z) =e= TDH(z)+TPRODN(z)+TPRCTS(z)+TCTAX(z) + RCY_INF(z);"),
        (r"\s*\+ \[CP\(zj\)\*CO2IDFACTOR\(i,zj\)\*e\(z\)\*PWM\(i,zj,z\)\]\$z3\(z\)", ""),
        (r"\+TCBAM\(z\)\$z3\(z\)", ""),
    ]
    for pat, rep in subs:
        t2 = re.sub(pat, rep, t)
        log.append(f"  SUBST {pat[:44]}...  ({'ok' if t2 != t else 'no match'})")
        t = t2
    t = t.replace("$TITLE    CBAM model", "$TITLE    TOU model")
    p.write_text(t, encoding="utf-8")

    # ------------------------------------------------- Init_Closure / Results
    for name, pat, label in [
        ("Init_Closure.gms", r"\bCP\.FX|TCBAM|deltatti|tti._share", "CBAM 폐쇄"),
        ("Results_format/Declare_Results.gms", r"valTCBAM|valCP\b", "CBAM 리포팅 선언"),
        ("Results_format/CGE_Results.gms", r"valTCBAM|valCP\(", "CBAM 리포팅 적재"),
    ]:
        log.append(name)
        p = dst / name
        t = p.read_text(encoding="utf-8")
        t = drop_lines(t, pat, label, log)
        p.write_text(t, encoding="utf-8")

    log.append("Results_format/Unload.gms")
    p = dst / "Results_format/Unload.gms"
    t = p.read_text(encoding="utf-8")
    for sym in ("valTCBAM, ", "valCP, "):
        t = t.replace(sym, "")
    p.write_text(t, encoding="utf-8")
    log.append("  DROP  valTCBAM, valCP")

    # ------------------------------------------------------------- Scenario/
    log.append("Scenario/")
    for f in ("S0_BASE.gms", "S1_CBAM_EU.gms", "S2_CBAM_RENEW.gms",
              "S3_CBAM_LAB.gms", "S4_CBAM_HH.gms", "_CarbonPrice_Path.gms"):
        q = dst / "Scenario" / f
        if q.exists():
            q.unlink()
            log.append(f"  DROP  Scenario/{f}")

    (dst / "Policy/Recycling.gms").write_text(RECYCLING_TOU, encoding="utf-8")
    (dst / "Scenario/Reset_Policy.gms").write_text(RESET_TOU, encoding="utf-8")
    (dst / "Scenario/Apply_Policy.gms").write_text(APPLY_TOU, encoding="utf-8")
    log.append("  WRITE Policy/Recycling.gms, Scenario/Reset_Policy.gms, Apply_Policy.gms (ToU 전용)")

    # ------------------------------------------------------------ 잔류 검사
    print("\n".join(log))
    print("\n" + "=" * 68)
    print("잔류 CBAM 참조 검사")
    print("=" * 68)
    bad = ["TCBAM", "CO2IDFACTOR", "deltattip", "deltattiw",
           "ttip_share", "ttiw_share", "rcy_lab", "rcy_prd",
           "EQ16_4", "EQ96", "EQ97", "EQ98", "EQ99", "EQ100", "EQ101"]
    found = 0
    for f in sorted(dst.rglob("*.gms")):
        txt = f.read_text(encoding="utf-8", errors="replace")
        for ln_no, ln in enumerate(txt.split("\n"), 1):
            if ln.lstrip().startswith("*"):
                continue
            for s in bad:
                if re.search(rf"\b{s}\b", ln):
                    print(f"  {f.relative_to(dst)}:{ln_no}  {s}  ->  {ln.strip()[:60]}")
                    found += 1
    for s in ("z3(", "z4(", "z5(", " z3", " z5"):
        for f in sorted(dst.rglob("*.gms")):
            txt = f.read_text(encoding="utf-8", errors="replace")
            for ln_no, ln in enumerate(txt.split("\n"), 1):
                if ln.lstrip().startswith("*") or "$" in ln:
                    continue
                if s in ln:
                    print(f"  {f.relative_to(dst)}:{ln_no}  {s.strip()}  ->  {ln.strip()[:60]}")
                    found += 1
    print(f"\n잔류 참조: {found} 건" + ("  <- 0 이어야 함" if found else "  OK"))


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", required=True)
    ap.add_argument("--dst", required=True)
    a = ap.parse_args()
    process(Path(a.src), Path(a.dst))


if __name__ == "__main__":
    main()
