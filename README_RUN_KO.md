# TOU 가계 환류·REN 생산지원 실행 안내

GAMS Studio에서 Run_Master.gms를 열고 F9로 실행합니다.
기준균형만 풀려면 --RUN_POLICY=0을 사용합니다.

실행 경로: Run_Master.gms → Policy/TOU_Inputs.gms → Scenario/Run_Policy.gms.
경제 시나리오는 BAU, TOU, TOU_REN_HH 세 가지입니다.
TOU_REN_HH의 a=0은 TOU_HH, a=1은 TOU_REN 끝점입니다.

Policy/TOU_Inputs.gms의 recycle_rate(rr)는 r, ren_share(aa)는 a입니다.
두 변수는 모두 0~1을 0.1 간격으로 계산합니다.
환류 없는 TOU의 양수 추가 wedge 수입을 고정 기준재원 F0로 두고,
전체 지원예산 r*F0를 HH에 (1-a), REN에 a 비율로 배분합니다.
미사용 기준재원 (1-r)*F0는 별도 지원에 사용하지 않고 기존 재정계정에 남습니다.
현재 재원은 정부 소비 wedge 수입이며 한전의 실제 영업이익·적정이윤·부채상환액이 아닙니다.
한전 수익·부채 목표를 새로 추정하거나 임의 유보율을 강제하지 않습니다.

r=0의 11개 a 조합은 같은 TOU 해를 재사용합니다.
BAU·TOU 2회+양의 r 10개×a 11개=정책 112회이며,
최초 기준균형을 포함해 실제 풀이 횟수는 113회입니다.
결과 격자에는 중복인 r=0도 남겨 r–a 표를 쉽게 확인할 수 있습니다.

REN은 23_eREN(모형의 재생·기타 발전)만 지원하며 원자력·화석발전은 제외합니다.
현재 집계자료로 재생에너지와 기타 발전을 더 분리하지 않습니다.
정태적 생산세 감면이며 신규 설비투자·건설 기간·장기 자본축적을 뜻하지 않습니다.
지원액에 맞춰 생산세율이 내생적으로 조정되며 세율이 음수가 될 수도 있습니다.
비용은 생산세 수입 감소에 이미 반영하므로 정부저축에서 다시 차감하지 않습니다.

결과 GDX: 프로젝트 루트의 TOU_recycling_results.gdx.
- results_macro: BAU/TOU 결과.
- results_policy(rr,aa,macro_item,z): 혼합 정책군의 거시 결과.
- budget_hh, budget_ren, budget_total: 예산 배분.
- ren_support_actual: 생산세 감소로 집계한 실제 REN 지원액.
- reference_retained: 미사용 기준재원.
- fiscal_residual_policy: 사후 wedge 수입−HH−REN. 수입이 내생적으로 변하므로 음수일 수 있습니다.
- generation_policy, emissions_policy: 발전원별 생산·산업별 배출.

GAMS 실행 후 주피터에서 아래 순서로 Run All 합니다.
1. Micro/jeju_tou_calibration.ipynb: 공통 표본의 고정소비 IBT–TOU 청구식 비교.
2. Micro/TOU_CGE_outcomes.ipynb: r–a 격자의 EV·배출·발전·재원 사용.
3. Micro/TOU_CGE_microsimulation.ipynb: 각 정책점 HH 몫의 U·I·IC 배분.
C 단독은 appendix_C 파일로 분리합니다. REN의 가격효과는 CGE 가격배율에 포함되어 있습니다.

공통 설정: Micro/micro_common_config.json, 표본 생성: Micro/micro_common.py.
GDX 읽기: Micro/tou_policy_results.py. 이 파일들을 노트북과 함께 두세요.
가구별 가격 적용은 기존 비례 전가 방식이며 직접 TOU 청구식 효과를 중복 합산하지 않습니다.
수요·소득 전체의 가구별 반응이나 미시 EV를 추정하는 것은 아닙니다.

새 결과는 Micro/policy_analysis/cge와 Micro/policy_analysis/micro_other_apartmentHV에 저장됩니다.
미시 전체 격자는 요약표로, 가구별 상세는 설정한 (SELECTED_RATE,SELECTED_MIX)와 BAU·TOU만 저장합니다.
선택점 변경 후 다시 실행하면 상세 파일은 갱신됩니다.
발전량은 GWh 기준자료가 없어 BAU 대비 변화율이며 가계 부하는 기존 계수로 GWh 환산합니다.
배출은 산업 연소+비에너지 사용+가계 직접연소이며 발전 배출을 총량에 중복 합산하지 않습니다.

기존 요금·탄력성·기본 폐쇄조건은 유지했습니다. 추가 오류 검증 코드는 넣지 않았습니다.
