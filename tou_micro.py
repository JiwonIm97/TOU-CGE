"""
tou_micro.py -- Essay 2 ToU 마이크로시뮬레이션 (aggregation-consistent behavioural top-down)

CGE(GAMS)가 산출한 전달 벡터를 받아
  (1) 가구별 소득등급 대체탄력성 sigma_h 로 부하를 재배분하고
  (2) 가구별 EV 와 분배지표를 계산하며
  (3) CGE 대표가계의 sigma_ToU* 를 마이크로 총량과 일치하도록 역산한다.

(3)이 핵심이다. CES 수요는 sigma 에 비선형이므로 sigma_ToU = mean(sigma_h) 로 두면
CGE 총 부하이전량과 마이크로 합계가 어긋난다. 스칼라 하나에 대한 1차원 문제이므로
반복 없이 풀리며, one-way 구조를 유지한 채 집계 불일치만 제거한다.

실행:
    python tou_micro.py                 # 합성 데이터로 즉시 동작 확인
    python tou_micro.py --data hh.csv --link link.json

의존: numpy, pandas, scipy
"""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass, field

import numpy as np
import pandas as pd
from scipy.optimize import brentq

BLOCKS = ["peak", "mid", "off"]
RNG = np.random.default_rng(20260728)


# =============================================================================
# 1. CGE 전달 벡터
# =============================================================================
@dataclass
class LinkVector:
    """GAMS E2_Results.gms 가 내보내는 전달 벡터.

    dp_block   : 블록별 가계 전력가격 변화율      <- E2_LINK_PB
    dp_other   : 비전력 소비자물가 변화율(가중평균) <- E2_LINK_PNE
    dw         : 노동유형별 임금 변화율            <- E2_LINK_W
    dr         : 자본수익률 변화율                 <- E2_LINK_R
    transfer   : 가계 총 이전액 (모형단위)         <- E2_LINK_TR
    cpi        : 소비자물가지수                    <- E2_LINK_CPI
    eps_total  : 전력 총수요 가격탄력성 (LES 함의, sigma_Y/frisch)
    """

    dp_block: dict[str, float]
    dp_other: float = 0.0
    dw: dict[str, float] = field(default_factory=lambda: {"slab": 0.0, "ulab": 0.0})
    dr: float = 0.0
    transfer: float = 0.0
    cpi: float = 1.0
    eps_total: float = -0.35

    @classmethod
    def from_json(cls, path: str) -> "LinkVector":
        with open(path, encoding="utf-8") as fh:
            return cls(**json.load(fh))

    @property
    def price_ratio(self) -> np.ndarray:
        """블록별 가격비 p1/p0."""
        return np.array([1.0 + self.dp_block[b] for b in BLOCKS])


# =============================================================================
# 2. 가구 마이크로데이터
# =============================================================================
def synthetic_households(n: int = 2638) -> pd.DataFrame:
    """가계동향조사 + KEPCO 설문을 모사한 합성 표본.

    실제 분석에서는 이 함수를 실데이터 로더로 교체한다. 필요한 열:
      hid, weight, income, elec_kwh, theta_peak, theta_mid, theta_off,
      sigma_h, share_labor, share_capital, share_transfer, spend_other
    """
    income = np.exp(RNG.normal(np.log(4.2e7), 0.55, n))  # 연소득(원)
    decile = pd.qcut(income, 10, labels=False) + 1

    # 전력소비: 소득에 대해 비탄력적
    elec_kwh = 3200 * (income / np.median(income)) ** 0.35 * np.exp(RNG.normal(0, 0.28, n))

    # 피크비중: 소득과 약한 정(+) 상관 + 큰 개인차 (수평적 불평등의 원천)
    theta_peak = np.clip(0.26 + 0.035 * (decile - 5.5) / 4.5 + RNG.normal(0, 0.07, n), 0.05, 0.60)
    theta_off = np.clip(0.30 - 0.020 * (decile - 5.5) / 4.5 + RNG.normal(0, 0.07, n), 0.05, 0.60)
    theta_mid = 1.0 - theta_peak - theta_off

    # sigma_h: 능력(소득+) 과 시간유연성(소득-) 이 상쇄. 여기서는 약한 정(+) 기울기.
    sigma_h = np.clip(0.30 + 0.030 * (decile - 5.5) / 4.5 + RNG.normal(0, 0.10, n), 0.02, 1.20)
    sigma_h = np.where(np.isclose(sigma_h, 1.0), 0.99, sigma_h)

    share_labor = np.clip(0.72 - 0.02 * (decile - 5.5) / 4.5 + RNG.normal(0, 0.10, n), 0.0, 1.0)
    share_capital = np.clip(0.12 + 0.05 * (decile - 5.5) / 4.5 + RNG.normal(0, 0.06, n), 0.0, 1.0)
    share_transfer = np.clip(1.0 - share_labor - share_capital, 0.0, 1.0)

    return pd.DataFrame(
        {
            "hid": np.arange(n),
            "weight": np.ones(n),
            "income": income,
            "decile": decile,
            "elec_kwh": elec_kwh,
            "theta_peak": theta_peak,
            "theta_mid": theta_mid,
            "theta_off": theta_off,
            "sigma_h": sigma_h,
            "share_labor": share_labor,
            "share_capital": share_capital,
            "share_transfer": share_transfer,
        }
    )


# =============================================================================
# 3. CES 부하 재배분
# =============================================================================
def ces_reallocate(theta: np.ndarray, sigma: np.ndarray, pr: np.ndarray, eps_total: float):
    """가구별 CES 재배분.

    theta : (n, 3) 벤치마크 블록 비중
    sigma : (n,)   시간대 간 대체탄력성
    pr    : (3,)   블록별 가격비 p1/p0
    eps_total : 전력 총수요 가격탄력성 (음수)

    반환 (P_ratio, q_ratio_block, Q_ratio)
      P_ratio       : (n,)    가구별 전력 합성가격 상승률
      q_ratio_block : (n, 3)  블록별 수요 배분 비율 (총량 1 기준)
      Q_ratio       : (n,)    총 전력수요 변화 비율
    """
    s = sigma[:, None]
    # CES 가격지수 (벤치마크 가격 = 1 정규화)
    P_ratio = (theta * pr[None, :] ** (1.0 - s)).sum(axis=1) ** (1.0 / (1.0 - sigma))
    # 블록 배분
    q_share = theta * (pr[None, :] / P_ratio[:, None]) ** (-s)
    # 총량 반응
    Q_ratio = P_ratio ** eps_total
    return P_ratio, q_share, Q_ratio


def run_micro(hh: pd.DataFrame, link: LinkVector) -> pd.DataFrame:
    theta = hh[["theta_peak", "theta_mid", "theta_off"]].to_numpy()
    sigma = hh["sigma_h"].to_numpy()
    pr = link.price_ratio

    P_ratio, q_share, Q_ratio = ces_reallocate(theta, sigma, pr, link.eps_total)

    q0 = hh["elec_kwh"].to_numpy()[:, None] * theta
    q1 = hh["elec_kwh"].to_numpy()[:, None] * Q_ratio[:, None] * q_share

    out = hh.copy()
    for j, b in enumerate(BLOCKS):
        out[f"q0_{b}"] = q0[:, j]
        out[f"q1_{b}"] = q1[:, j]
    out["Q0"] = q0.sum(axis=1)
    out["Q1"] = q1.sum(axis=1)
    out["P_ratio"] = P_ratio

    # ---- 요금 지출 (벤치마크 단가 = 1 정규화, 실제 원 단위는 p_bar 로 스케일) ----
    out["bill0"] = out["Q0"]
    out["bill1"] = (q1 * pr[None, :]).sum(axis=1)

    # ---- 후생 분해 -----------------------------------------------------------
    e = link.eps_total
    # (a) 전력 가격변화의 소비자잉여 변화 (불변탄력성 수요 하 정확)
    out["ev_elec"] = -(out["bill0"] / (1.0 - e)) * (out["P_ratio"] ** (1.0 - e) - 1.0)

    # (b) 간접 물가 채널: 비전력 지출에 대한 물가 상승
    spend_other = out["income"] * 0.75 - out["bill0"]
    out["ev_price_other"] = -link.dp_other * spend_other.clip(lower=0)

    # (c) 소득 채널 (source-side)
    dw = 0.5 * (link.dw.get("slab", 0.0) + link.dw.get("ulab", 0.0))
    out["ev_income"] = out["income"] * (
        out["share_labor"] * dw + out["share_capital"] * link.dr
    )

    # (d) 이전
    w = out["weight"]
    out["ev_transfer"] = link.transfer * w / w.sum() if link.transfer else 0.0

    out["EV"] = out[["ev_elec", "ev_price_other", "ev_income", "ev_transfer"]].sum(axis=1)
    out["EV_rel"] = out["EV"] / out["income"]

    # 전력채널만 분리. Q3(sigma_h 임계 판정)의 대상은 이쪽이다.
    # 간접물가·소득 채널은 소득에 거의 비례하므로 분위 간 기울기를 만들지 않는다.
    out["EV_elec_rel"] = (out["ev_elec"] + out["ev_transfer"]) / out["income"]
    return out


# =============================================================================
# 4. 집계 일관성 보정  (핵심)
# =============================================================================
def calibrate_sigma_tou(hh: pd.DataFrame, link: LinkVector,
                        lo: float = 0.01, hi: float = 3.0) -> float:
    """CGE 대표가계 sigma_ToU* 를 마이크로 총량과 정합하도록 역산.

    목표: 대표가계 CES 가 만들어내는 블록 배분이 가구별 sigma_h 로 계산한
          집계 배분과 일치. 피크 블록 비중을 정합 조건으로 삼는다.
    """
    res = run_micro(hh, link)
    w = res["weight"].to_numpy()

    micro_peak = np.average(res["q1_peak"], weights=w) * w.sum()
    micro_tot = np.average(res["Q1"], weights=w) * w.sum()
    target = micro_peak / micro_tot

    theta_agg = np.array(
        [np.average(res[f"q0_{b}"], weights=w) for b in BLOCKS]
    )
    theta_agg = theta_agg / theta_agg.sum()
    pr = link.price_ratio

    def gap(s: float) -> float:
        if abs(s - 1.0) < 1e-8:
            s = 1.0 + 1e-6
        P = (theta_agg * pr ** (1.0 - s)).sum() ** (1.0 / (1.0 - s))
        share = theta_agg * (pr / P) ** (-s)
        return share[0] / share.sum() - target

    if gap(lo) * gap(hi) > 0:
        return float(np.average(res["sigma_h"], weights=w))
    return float(brentq(gap, lo, hi, xtol=1e-8))


# =============================================================================
# 5. 분배지표
# =============================================================================
def suits_index(income: np.ndarray, burden: np.ndarray, w: np.ndarray) -> float:
    """Suits 지수. 양수면 누진, 음수면 역진."""
    order = np.argsort(income)
    inc, bur, ww = income[order], burden[order], w[order]
    ci = np.cumsum(inc * ww) / np.sum(inc * ww)
    cb = np.cumsum(bur * ww) / np.sum(bur * ww)
    ci = np.concatenate([[0.0], ci])
    cb = np.concatenate([[0.0], cb])
    area = np.trapezoid(cb, ci)
    return float(1.0 - 2.0 * area)


def concentration_index(x: np.ndarray, rank_by: np.ndarray, w: np.ndarray) -> float:
    order = np.argsort(rank_by)
    xs, ws = x[order], w[order]
    p = np.cumsum(ws) / np.sum(ws)
    mu = np.sum(xs * ws) / np.sum(ws)
    return float(2.0 * np.sum(ws * (xs - mu) * (p - 0.5)) / (np.sum(ws) * mu))


def kakwani_index(income: np.ndarray, burden: np.ndarray, w: np.ndarray) -> float:
    """Kakwani = C(burden) - Gini(income). 양수면 누진."""
    return concentration_index(burden, income, w) - concentration_index(income, income, w)


def welfare_gradient(res: pd.DataFrame, col: str = "EV_elec_rel",
                     n_boot: int = 400) -> dict:
    """EV_rel 을 log(소득)에 가중회귀한 기울기와 부트스트랩 신뢰구간.

    Suits/Kakwani 는 부담의 부호가 섞이면 해석이 무너진다(수입중립 개편에서는
    모든 가구가 소폭 이득일 수 있다). 기울기는 부호에 무관하게 정의되므로
    Q3 의 주 통계량으로 이쪽을 쓴다.
      기울기 < 0  : 고소득일수록 이득이 작다 -> 누진
      기울기 > 0  : 고소득일수록 이득이 크다 -> 역진
    """
    y = res[col].to_numpy()
    x = np.log(res["income"].to_numpy())
    w = res["weight"].to_numpy()

    def wls(yy, xx, ww):
        xm = np.average(xx, weights=ww)
        ym = np.average(yy, weights=ww)
        return float(np.sum(ww * (xx - xm) * (yy - ym)) / np.sum(ww * (xx - xm) ** 2))

    beta = wls(y, x, w)
    n = len(y)
    draws = np.empty(n_boot)
    for b in range(n_boot):
        idx = RNG.integers(0, n, n)
        draws[b] = wls(y[idx], x[idx], w[idx])
    lo, hi = np.percentile(draws, [2.5, 97.5])
    return {"beta": beta, "ci": (float(lo), float(hi)),
            "p_same_sign": float(np.mean(np.sign(draws) == np.sign(beta)))}


def distributional_report(res: pd.DataFrame) -> dict:
    w = res["weight"].to_numpy()
    inc = res["income"].to_numpy()
    burden = (-res["EV"]).to_numpy()          # 손실을 양(+)의 부담으로

    burden_e = (-res["ev_elec"] - res["ev_transfer"]).to_numpy()

    by_dec = res.groupby("decile").apply(
        lambda g: pd.Series(
            {
                "EV_rel_mean": np.average(g["EV_rel"], weights=g["weight"]),
                "EVelec_mean": np.average(g["EV_elec_rel"], weights=g["weight"]),
                "EVelec_sd": np.sqrt(np.average(
                    (g["EV_elec_rel"] - np.average(g["EV_elec_rel"], weights=g["weight"])) ** 2,
                    weights=g["weight"])),
                "loser_elec": np.average((g["ev_elec"] + g["ev_transfer"] < 0).astype(float),
                                         weights=g["weight"]),
                "peak_share": np.average(g["theta_peak"], weights=g["weight"]),
                "sigma_h": np.average(g["sigma_h"], weights=g["weight"]),
            }
        ),
        include_groups=False,
    )

    within = np.average(
        res.groupby("decile")["EV_elec_rel"].transform(lambda s: (s - s.mean()) ** 2), weights=w
    )
    total = np.average((res["EV_elec_rel"] - np.average(res["EV_elec_rel"], weights=w)) ** 2,
                       weights=w)

    return {
        "by_decile": by_dec,
        "suits": suits_index(inc, burden, w),
        "suits_elec": suits_index(inc, burden_e, w),
        "kakwani_elec": kakwani_index(inc, burden_e, w),
        "within_share": float(within / total) if total > 0 else np.nan,
        "loser_share": float(np.average((burden_e > 0).astype(float), weights=w)),
    }


# =============================================================================
# 6. sigma_h 소득기울기의 임계값
# =============================================================================
def critical_sigma_slope(res: pd.DataFrame, link: LinkVector) -> dict:
    """누진/역진 판정이 뒤집히는 d(sigma)/d(income) 임계값.

    Q3 의 핵심 산출물. sigma 기울기를 좌우로 움직이며 Suits 지수의 부호가
    바뀌는 지점을 찾는다. sigma 수준이 불확실해도 임계선은 상대적으로 견고하다.
    """
    hh = res.copy()
    base = hh["sigma_h"].to_numpy()
    dec_c = (hh["decile"].to_numpy() - 5.5) / 4.5

    def suits_at(slope: float) -> float:
        h2 = hh.copy()
        s = np.clip(base + slope * dec_c, 0.02, 3.0)
        h2["sigma_h"] = np.where(np.isclose(s, 1.0), 0.99, s)
        r2 = run_micro(h2, link)
        return welfare_gradient(r2, n_boot=1)["beta"]

    grid = np.linspace(-1.5, 1.5, 31)
    vals = np.array([suits_at(g) for g in grid])

    crit = np.nan
    sign = np.sign(vals)
    idx = np.where(np.diff(sign) != 0)[0]
    if len(idx):
        i = idx[0]
        try:
            crit = float(brentq(suits_at, grid[i], grid[i + 1], xtol=1e-4))
        except ValueError:
            pass

    return {"grid": grid, "suits": vals, "critical_slope": crit}


# =============================================================================
# 7. 실행
# =============================================================================
def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", help="가구 마이크로데이터 CSV")
    ap.add_argument("--link", help="CGE 전달 벡터 JSON")
    ap.add_argument("--out", default="micro_results.csv")
    args = ap.parse_args()

    hh = pd.read_csv(args.data) if args.data else synthetic_households()

    if args.link:
        link = LinkVector.from_json(args.link)
    else:
        # 수입중립 ToU 예시: 피크 +44%, 중간 -4%, 심야 -44%
        link = LinkVector(
            dp_block={"peak": 0.44, "mid": -0.04, "off": -0.44},
            dp_other=0.001,
            dw={"slab": -0.0004, "ulab": -0.0006},
            dr=-0.0008,
            transfer=0.0,
            eps_total=-0.35,
        )

    res = run_micro(hh, link)
    rep = distributional_report(res)
    sig_star = calibrate_sigma_tou(hh, link)
    crit = critical_sigma_slope(hh, link)

    w = res["weight"].to_numpy()
    print("=" * 74)
    print("ToU 마이크로시뮬레이션 결과")
    print("=" * 74)
    print(f"가구 수                       : {len(res):,}")
    print(f"블록 가격변화                 : {link.dp_block}")
    print(f"가구 평균 sigma_h             : {np.average(res['sigma_h'], weights=w):.3f}")
    print(f"CGE 정합 sigma_ToU*           : {sig_star:.4f}   <- E2_CAL.gms 에 입력")
    print()
    print("분위별 결과   EV_rel=전체 / EVelec=전력채널 (소득 대비)")
    print(rep["by_decile"].round(6).to_string())
    print()
    grad = welfare_gradient(res)
    print(f"후생기울기 beta  : {grad['beta']:+.3e}   "
          f"95% CI [{grad['ci'][0]:+.2e}, {grad['ci'][1]:+.2e}]")
    print(f"   부호 일치 비율: {grad['p_same_sign']:.1%}   "
          "(beta<0 이면 누진, beta>0 이면 역진)")
    print(f"Suits (전력채널) : {rep['suits_elec']:+.4f}  "
          "(부담 부호가 섞이면 해석 주의)")
    print(f"손실가구 비중    : {rep['loser_share']:.1%}")
    print(f"분위 내 분산 비중 : {rep['within_share']:.1%}")
    print("  -> 이 값이 크면 수평적 불평등이 수직적 불평등보다 크다는 뜻")
    print()
    cs, sv = crit["critical_slope"], crit["suits"]
    if np.isfinite(cs):
        print(f"sigma 소득기울기 임계값 : {cs:+.4f}")
        print("  추정된 기울기가 이 값의 어느 쪽에 있는지가 Q3 의 답.")
    else:
        print("sigma 소득기울기 임계값 : 탐색범위 [-1.5, +1.5] 내 부호전환 없음")
        print(f"  beta 범위 [{sv.min():+.2e}, {sv.max():+.2e}] — 전 구간 동일 부호.")
        print("  즉 판정이 sigma 기울기에 대해 강건하다. 이것도 보고할 결과다.")
    print("=" * 74)

    res.to_csv(args.out, index=False)
    print(f"\n가구별 결과 저장 -> {args.out}")


if __name__ == "__main__":
    main()
