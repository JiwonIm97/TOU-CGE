* ==============================================================================
* Scenario/ScenarioList.gms
* 시나리오 실행 목록. 새 시나리오는 Scenario/ 에 solve 파일 하나 추가하고
* 아래에 한 줄 추가. 모형 본체(Model.gms)는 수정하지 않음.
* ==============================================================================
$batinclude "Scenario/RunScenario.gms" %RUN_S0_IBR%      S0_IBR.gms      0_IBR
$batinclude "Scenario/RunScenario.gms" %RUN_S1_TOU%      S1_TOU.gms      1_TOU
$batinclude "Scenario/RunScenario.gms" %RUN_S2_TOU_RCY%  S2_TOU_RCY.gms  2_TOU_RCY
