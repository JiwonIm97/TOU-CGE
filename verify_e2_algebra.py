"""
verify_e2_algebra.py -- E2 블록 방정식의 대수 검증

GAMS 를 돌리기 전에, E2_Model.gms 의 다섯 방정식이 만족해야 할 항등식을
numpy 로 재현하여 확인한다. 여기서 실패하면 GAMS 에서도 반드시 실패하므로,
CONOPT 수렴 실패의 원인을 방정식 오류와 수치 문제로 분리할 수 있다.

검증 항목
  A. 벤치마크 재현      tth_B=0  ->  PC_HH=PC, C_B=theta*C, CE_PHYS=C, TIC_HH=0
  B. 지출 항등식        PC_HH*C  =  SUM_b PC_HB*C_B            (Walras 전제)
  C. wedge 분해 항등식  PC_HH*C  =  PC*CE_PHYS + TIC_HH        (정부수입 정합)
  D. CES 괴리 부호      C - CE_PHYS
  E. 수입중립 정규화    SUM_b theta_b * tth_B ~ 0

실행:  python verify_e2_algebra.py
"""

from __future__ import annotations

import numpy as np

BLOCKS = ["peak", "mid", "off"]
TOL = 1e-10


# =============================================================================
# E2_Model.gms 의 방정식을 그대로 옮긴 것
# =============================================================================
def e2_block(PC: float, theta: np.ndarray, sigma: float,
             tth_B: np.ndarray, C: float) -> dict:
    """EQ_E2_2 ~ EQ_E2_6 를 순서대로 푼다."""
    if abs(sigma - 1.0) < 1e-12:
        raise ValueError("sigma_ToU must not equal 1 (EQ_E2_3 degenerates)")

    # EQ_E2_2
    PC_HB = (1.0 + tth_B) * PC
    # EQ_E2_3
    PC_HH = (np.sum(theta * PC_HB ** (1.0 - sigma))) ** (1.0 / (1.0 - sigma))
    # EQ_E2_4
    C_B = C * theta * (PC_HB / PC_HH) ** (-sigma)
    # EQ_E2_5
    CE_PHYS = C_B.sum()
    # EQ_E2_6
    TIC_HH = np.sum(tth_B * PC * C_B)

    return {"PC_HB": PC_HB, "PC_HH": PC_HH, "C_B": C_B,
            "CE_PHYS": CE_PHYS, "TIC_HH": TIC_HH}


def normalise_revenue_neutral(tth_raw: np.ndarray, theta: np.ndarray) -> np.ndarray:
    """E2_S1_TOU.gms 의 수입중립 정규화."""
    wbar = np.sum(theta * tth_raw)
    return (1.0 + tth_raw) / (1.0 + wbar) - 1.0


# =============================================================================
# 검증
# =============================================================================
def check(name: str, ok: bool, detail: str = "") -> bool:
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"   {detail}" if detail else ""))
    return ok


def run_case(label: str, PC: float, theta: np.ndarray, sigma: float,
             tth_B: np.ndarray, C: float) -> bool:
    print(f"\n--- {label} ---")
    print(f"  sigma={sigma:.3f}  theta={np.round(theta,3)}  tth_B={np.round(tth_B,4)}")
    r = e2_block(PC, theta, sigma, tth_B, C)

    ok = True
    # B. 지출 항등식
    lhs, rhs = r["PC_HH"] * C, float(np.sum(r["PC_HB"] * r["C_B"]))
    ok &= check("B  지출 항등식  PC_HH*C = SUM PC_HB*C_B",
                abs(lhs - rhs) <= TOL * max(1.0, abs(lhs)),
                f"|diff| = {abs(lhs-rhs):.3e}")

    # C. wedge 분해
    rhs2 = PC * r["CE_PHYS"] + r["TIC_HH"]
    ok &= check("C  wedge 분해   PC_HH*C = PC*CE_PHYS + TIC_HH",
                abs(lhs - rhs2) <= TOL * max(1.0, abs(lhs)),
                f"|diff| = {abs(lhs-rhs2):.3e}")

    # D. 진단
    gap = C - r["CE_PHYS"]
    wbar_ex_ante = float(np.sum(theta * tth_B))
    wbar_ex_post = float(r["TIC_HH"] / (PC * r["CE_PHYS"])) if r["CE_PHYS"] else 0.0
    print(f"  [INFO] PC_HH/PC        = {r['PC_HH']/PC:.6f}")
    print(f"  [INFO] CES 괴리 C-CE   = {gap:+.6e}"
          f"   (음수 = 동일 효용에 물리적 kWh 가 더 필요)")
    print(f"  [INFO] 물리량 변화율   = {r['CE_PHYS']/C-1:+.4%}  (C 고정 기준)")
    print(f"  [INFO] 블록 비중       = {np.round(r['C_B']/r['CE_PHYS'], 4)}")
    print(f"  [INFO] TIC_HH          = {r['TIC_HH']:+.6e}")
    print(f"  [INFO] 평균 wedge      = 사전 {wbar_ex_ante:+.5f} / 사후 {wbar_ex_post:+.5f}")
    if abs(wbar_ex_ante) < 1e-10 and abs(wbar_ex_post) > 1e-6:
        print("         !! 사전 세수중립이 사후 세수중립을 의미하지 않는다."
              " 아래 ex_post_neutral_shift 참조.")
    return ok


def ex_post_neutral_shift(PC: float, theta: np.ndarray, sigma: float,
                          tth_raw: np.ndarray, C: float) -> float:
    """행태반응 이후 TIC_HH = 0 이 되도록 하는 평행이동 계수 s.

    tth_B(b) = (1+tth_raw_b)*(1+s) - 1
    GAMS 에서는 스칼라 변수 tou_shift 와 방정식 TIC_HH('01_KOR')=0 으로 내생화한다.
    """
    from scipy.optimize import brentq

    def f(s: float) -> float:
        t = (1.0 + tth_raw) * (1.0 + s) - 1.0
        return e2_block(PC, theta, sigma, t, C)["TIC_HH"]

    return float(brentq(f, -0.9, 2.0, xtol=1e-12))


def main() -> None:
    PC, C = 1.0, 100.0
    theta = np.array([0.30, 0.42, 0.28])
    all_ok = True

    print("=" * 72)
    print("E2 블록 방정식 대수 검증")
    print("=" * 72)

    # ---- A. 벤치마크 -------------------------------------------------------
    print("\n--- A. 벤치마크 재현 (tth_B = 0) ---")
    for sig in (0.0, 0.3, 0.8, 2.0):
        r = e2_block(PC, theta, sig, np.zeros(3), C)
        ok = (abs(r["PC_HH"] - PC) <= TOL
              and np.allclose(r["C_B"], theta * C, atol=TOL)
              and abs(r["CE_PHYS"] - C) <= TOL
              and abs(r["TIC_HH"]) <= TOL)
        all_ok &= check(f"sigma={sig}: PC_HH=PC, C_B=theta*C, CE_PHYS=C, TIC_HH=0", ok)

    # ---- E. 수입중립 정규화 -------------------------------------------------
    print("\n--- E. 수입중립 정규화 ---")
    p_tou = np.array([180.0, 120.0, 70.0])
    p_bar = 125.0
    tth_raw = p_tou / p_bar - 1.0
    tth_rn = normalise_revenue_neutral(tth_raw, theta)
    all_ok &= check("SUM theta*tth_B = 0", abs(np.sum(theta * tth_rn)) <= 1e-12,
                    f"= {np.sum(theta*tth_rn):.3e}")
    print(f"  [INFO] 원 요금표 wedge  = {np.round(tth_raw,4)}")
    print(f"  [INFO] 정규화 후 wedge  = {np.round(tth_rn,4)}")

    # ---- B/C/D. 정책 충격 --------------------------------------------------
    for sig in (0.15, 0.30, 0.60):
        all_ok &= run_case(f"수입중립 ToU, sigma={sig}", PC, theta, sig, tth_rn, C)

    all_ok &= run_case("비중립 ToU (평균단가 인상 동반)", PC, theta, 0.30, tth_raw, C)

    # ---- 경계 조건 ---------------------------------------------------------
    print("\n--- 사후 세수중립 평행이동 계수 ---")
    for sig in (0.15, 0.30, 0.60):
        s = ex_post_neutral_shift(PC, theta, sig, tth_rn, C)
        t = (1.0 + tth_rn) * (1.0 + s) - 1.0
        chk = e2_block(PC, theta, sig, t, C)["TIC_HH"]
        print(f"  sigma={sig:.2f}  s={s:+.6f}  ->  tth_B={np.round(t,4)}"
              f"   TIC_HH={chk:+.2e}")
    print("  s 는 sigma 에 의존한다. GAMS 에서 스칼라 변수로 내생화할 것.")

    print("\n--- 경계 조건 ---")
    try:
        e2_block(PC, theta, 1.0, tth_rn, C)
        all_ok &= check("sigma=1 에서 오류 발생", False, "예외가 발생해야 함")
    except ValueError:
        all_ok &= check("sigma=1 에서 오류 발생 (E2_CAL.gms 의 ABORT 와 대응)", True)

    all_ok &= check("theta 합 = 1", abs(theta.sum() - 1.0) <= TOL)

    print("\n" + "=" * 72)
    print("전체 결과:", "PASS — GAMS 로 진행하십시오." if all_ok
          else "FAIL — 방정식을 수정한 뒤 다시 실행하십시오.")
    print("=" * 72)


if __name__ == "__main__":
    main()
