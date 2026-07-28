* ==============================================================================
* Scenario/RunScenario.gms
*   %1 = 실행 스위치 (1=run, 0=skip)
*   %2 = 시나리오 solve 파일명
*   %3 = 결과 GDX 파일명 (= CurrentSce)
* ==============================================================================
$ifthen %1 == 1
$log ### RUNNING SCENARIO: %3 ###
$include "Scenario/Reset_Policy.gms"
$setglobal CurrentSce "%3"
$include "Scenario/%2"
$batinclude "Results_format/Unload.gms" %3
$endif
