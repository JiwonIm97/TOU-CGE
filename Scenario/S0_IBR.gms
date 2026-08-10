* ==============================================================================
* Scenario/S0_IBR.gms   ->  Output_w-1/0_IBR.gdx
* 기준선. 현행 주택용 누진요금제(IBR).
* tth_B_raw = 0 이므로 해는 벤치마크와 동일해야 하며,
* 블록별 수요 C_B 와 물리량 CE_PHYS 만 추가로 보고된다.
* ==============================================================================

* 충격 없음. Reset_Policy.gms 가 이미 tth_B_raw = 0, e2_expost = 0 으로 초기화.

$include "Scenario/Apply_Policy.gms"

loop(sim,
    SOLVE TOU USING CNS;
$include "Results_format/CGE_Results.gms"
);
