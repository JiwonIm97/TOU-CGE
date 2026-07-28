* ==============================================================================
* Scenario/S2_TOU_RCY.gms   ->  Output_w-1/2_TOU_RCY.gdx
* ToU 전환 + wedge 수입의 가계 정액환급.
* ------------------------------------------------------------------------------
* e2_expost = 0 인 이유: 사후 세수중립을 걸면 TIC_HH = 0 이 되어
* 환류할 재원 자체가 없어진다. 이 시나리오는 평균단가 인상을 동반한다.
* ==============================================================================

PARAMETER p_ToU(b), p_bar;

 p_ToU('peak') = 180 ;
 p_ToU('mid' ) = 120 ;
 p_ToU('off' ) =  70 ;
 p_bar         = 125 ;

 tth_B_raw(b,'01_KOR') = p_ToU(b)/p_bar - 1;
 e2_expost('01_KOR')   = 0;

*==============================================================================
* 환류 설정: 한국이 징수하여 한국 가계에 전액 정액환급
*==============================================================================
 rcy_share('01_KOR','01_KOR') = 1;
 rcy_hh('01_KOR')             = 1;

 display p_ToU, p_bar, tth_B_raw, e2_expost, rcy_share, rcy_hh;

$include "Scenario/Apply_Policy.gms"

loop(sim,
    SOLVE TOU USING CNS;
$include "Results_format/CGE_Results.gms"
$include "Results_format/E2_Results.gms"
);
