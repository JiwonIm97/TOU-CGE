$TITLE    TOU-CGE
$STITLE   Residential IBR -> ToU tariff reform, world static CGE
* ==============================================================================
* Run_Master.gms : 실행 진입점
* ==============================================================================

* ------------------------------------------------------------------------------
* [1] 제어 스위치 (1 = Run, 0 = Skip)
* ------------------------------------------------------------------------------
$setglobal RUN_BENCHMARK    0
$setglobal RUN_S0_IBR       0
$setglobal RUN_S1_TOU       0
$setglobal RUN_S2_TOU_RCY   1

* RUN_BENCHMARK   보정 직후 벤치마크 재현 solve 및 진단 (Walras 잔차 포함)
* RUN_S0_IBR      기준선. 현행 누진요금제. tth_B = 0
* RUN_S1_TOU      ToU 전환. wedge 수입 정부 보유
* RUN_S2_TOU_RCY  ToU 전환 + wedge 수입의 가계 정액환급

* ------------------------------------------------------------------------------
* [2] 모형 엔진 로드
* ------------------------------------------------------------------------------
$include "Sets.gms"
$include "PAR.gms"
$include "CAL.gms"
$include "Policy/Recycling.gms"
$include "Model.gms"
$include "Results_format/Declare_Results.gms"
$include "Init_Closure.gms"

* ------------------------------------------------------------------------------
* [3] 모형 선언 및 솔버 옵션
* ------------------------------------------------------------------------------
option cns = conopt4;
option limrow = 0, limcol = 0, solprint = off;
$Offlisting
$OffSymList
$Offinclude

MODEL TOU  Residential ToU tariff model /all/ ;
 TOU.holdfixed = 1;
 TOU.solvelink = 5;

* ------------------------------------------------------------------------------
* [4] 벤치마크 재현 점검
* ------------------------------------------------------------------------------
$ifthen %RUN_BENCHMARK% == 1
$log ### BENCHMARK REPLICATION CHECK ###
    SOLVE TOU USING CNS;

PARAMETER chk_bench(*,*)  Benchmark replication diagnostics;
    chk_bench('LEON','max_abs')    = SMAX(z, ABS(LEON.l(z)));
    chk_bench('PC_HH','max_dev')   = SMAX((i,z)$PCO(i,z), ABS(PC_HH.l(i,z)/PCO(i,z)-1));
    chk_bench('CE_PHYS','max_dev') = SMAX(z$CE_PHYSO(z), ABS(CE_PHYS.l(z)/CE_PHYSO(z)-1));
    chk_bench('C_B','max_dev')     = SMAX((b,z)$C_BO(b,z), ABS(C_B.l(b,z)/C_BO(b,z)-1));
    chk_bench('TIC_HH','max_abs')  = SMAX(z, ABS(TIC_HH.l(z)));
    chk_bench('tou_shift','max_abs') = SMAX(z, ABS(tou_shift.l(z)));
    chk_bench('CESGAP','max_abs')  = SMAX(z, ABS(C.l('18_ELEC',z)-CE_PHYS.l(z)));
    display chk_bench;

    ABORT$(chk_bench('LEON','max_abs') > 1e-6)
        "BENCHMARK FAIL: Walras residual. 방정식-변수 개수를 확인할 것.";
    ABORT$(chk_bench('PC_HH','max_dev') > 1e-6)
        "BENCHMARK FAIL: PC_HH != PC at tth=0. Model.gms 교체 지점을 확인할 것.";
    ABORT$(chk_bench('TIC_HH','max_abs') > 1e-6)
        "BENCHMARK FAIL: TIC_HH != 0 at tth=0.";
$log ### BENCHMARK OK ###
$endif

* ------------------------------------------------------------------------------
* [5] 시나리오 실행
* ------------------------------------------------------------------------------
$include "Scenario/ScenarioList.gms"
