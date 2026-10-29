# 공통 표본과 새 정책군 안내

공통 표본·균등화소득 설정은 micro_common_config.json 한 곳에서 변경합니다.
기본 표본은 기타계절·아파트 고압·50~1000kWh이며 현재 2499가구입니다.
소득=가구 월소득/√가구원 수. 참고 분위별 평균은 경곗값으로 쓰지 않습니다.

jeju_tou_calibration.ipynb는 소비 고정 IBT–TOU 청구식 비교입니다.
TOU_CGE_outcomes.ipynb와 TOU_CGE_microsimulation.ipynb는 새 REN–HH 격자를 읽습니다.
거시 시나리오에 U/I/C/IC를 추가하지 않습니다. HH 몫만 미시에서 배분합니다.
U/I/IC는 본문 결과, C는 부록 결과입니다.

GDX 읽기에 tou_policy_results.py가 필요합니다. 기존 micro_common.py와 JSON도 함께 둡니다.
새 결과는 policy_analysis 아래에 저장합니다.
노트북의 선택점은 SELECTED_RATE, SELECTED_MIX로 바꿀 수 있습니다.
현재 기본 선택점은 r=100%, REN=50%입니다.
기존 정부 재정계정의 잔여 수입을 한전 영업이익이나 적자 개선액으로 해석하지 않습니다.
자세한 실행 안내는 프로젝트 루트 README_RUN_KO.md를 참고하세요.
