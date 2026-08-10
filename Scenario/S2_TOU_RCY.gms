* ==============================================================================
* Scenario/S2_TOU_RCY.gms
* S1 과 동일한 요금표 구조에 첨두 할증만 mult 배 확대.
* p_bar 는 S1 기준(확대 전)으로 고정하므로 초과 세수가 발생하고,
* 이를 가계에 정액환급한다. S1 대비 차이는 '차등폭 확대 + 환류' 하나.
* ==============================================================================
SCALAR mult Peak surcharge multiplier / 1.5 /;

 p_ToU('peak','01_KOR') = 200.5;
 p_ToU('mid' ,'01_KOR') = 171.8;
 p_ToU('off' ,'01_KOR') = 133.3;

*--- p_bar 는 확대 전 요금표의 theta 가중평균 (S1 과 동일)
 p_bar(z)$SUM(b, p_ToU(b,z)) = SUM(b, theta_B(b,z)*p_ToU(b,z));

*--- 첨두만 확대
 p_ToU('peak',z)$p_bar(z) = p_bar(z)*(1 + mult*(p_ToU('peak',z)/p_bar(z) - 1));

 tth_B_raw(b,z)$p_bar(z) = p_ToU(b,z)/p_bar(z) - 1;
 e2_expost('01_KOR') = 0;

*--- 한국 징수 -> 한국 가계 정액환급
 rcy_share('01_KOR','01_KOR') = 1;
 rcy_hh('01_KOR')             = 1;

 display p_ToU, p_bar, tth_B_raw;

$include "Scenario/Apply_Policy.gms"

loop(sim,
    SOLVE TOU USING CNS;
    ABORT$(TOU.modelstat > 16) "solve failed", TOU.modelstat;
$include "Results_format/CGE_Results.gms"
);