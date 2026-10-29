* ==============================================================================
* Policy/Recycling.gms
* CBAM 세수 환류 스위치 선언 및 매크로 정의
* !! Model.gms 보다 반드시 먼저 include 되어야 함.
* ==============================================================================
* 설계 원칙
*  - "누가 징수하는가"는 집합 z3 가 결정.
*  - "누구에게 얼마가 가는가"는 rcy_share(징수지역, 수령지역) 이 결정.
*  - "수령지역이 그 돈을 무엇에 쓰는가"는 rcy_hh / rcy_gov / rcy_lab / rcy_prd 가 결정.
*  원본 코드에서 'EU'와 'card(z5) 균등분배'가 방정식에 하드코딩되어 있던 것을
*  전부 파라미터로 수정함. 시나리오 파일만 고치면 지역·수단을 바꿀 수 있음.
* ==============================================================================

PARAMETER
 rcy_share(z,zj)   CBAM revenue share transferred from collecting region z to region zj
 rcy_hh(z)         1 if revenue received by z is transferred lump-sum to households
 rcy_gov(z)        1 if revenue received by z accrues to the general government budget
 rcy_lab(z)        1 if revenue received by z finances labor tax cuts in CBAM industries
 rcy_prd(z)        1 if revenue received by z finances non-fossil generation subsidies
 rcy_chk(z)        Row sum of rcy_share (must be 0 or 1)
;

 rcy_share(z,zj) = 0;
 rcy_hh(z)  = 0;
 rcy_gov(z) = 0;
 rcy_lab(z) = 0;
 rcy_prd(z) = 0;

* ------------------------------------------------------------------------------
* 매크로: 방정식 안에서 반복되는 환류 집계항
*  RCY_IN   : 지역 zz 가 받는 총 CBAM 환류액 (국내 유보분 포함)
*  RCY_INF  : 그중 해외로부터 받은 몫       -> 국제수지에 계상
*  RCY_OUTF : 지역 zz 가 해외로 내보내는 몫 -> 국제수지에 계상
* ------------------------------------------------------------------------------
$macro RCY_IN(zz)   [SUM(zjj, rcy_share(zjj,zz)*TCBAM(zjj))]
$macro RCY_INF(zz)  [SUM(zjj$(NOT SAMEAS(zjj,zz)), rcy_share(zjj,zz)*TCBAM(zjj))]
$macro RCY_OUTF(zz) [TCBAM(zz)*SUM(zjj$(NOT SAMEAS(zjj,zz)), rcy_share(zz,zjj))]

* [P1] TOU national transfers are separate from CBAM cross-border transfers.
* B_TOU is the HH part of a frozen TOU recycling budget; model money units.
* [P2] Assumption: non-taxable lump-sum rebate added AFTER direct income tax.
* Government savings absorb the financing difference; real G is fixed.
PARAMETERS B_TOU(z) "Common TOU rebate budget in model money units"
           tou_rebate_on(z) "One when the TOU policy includes household transfers";
B_TOU(z)=0;
tou_rebate_on(z)=0;
$macro TOU_TRANSFER(zz) [tou_rebate_on(zz)*B_TOU(zz)]

* TOU supply support is independent of CBAM RCY_IN.
* Model aggregation: REN is renewable AND OTHER generation; nuclear excluded.
SET tou_ren_target(j) / 23_eREN /;
PARAMETERS B_TOU_REN(z) "TOU budget for REN production-tax support"
           tou_ren_on(z) "Activate dedicated TOU REN equation"
           tou_ren_share(j,z) "Benchmark production-value shares within target";
B_TOU_REN(z)=0;
tou_ren_on(z)=0;
tou_ren_share(j,z)=0;
tou_ren_share(j,z)$(tou_ren_target(j) and ACTIVE_J(j,z))
    = XSTO(j,z)*PPO(j,z)
      /sum(jj$(tou_ren_target(jj) and ACTIVE_J(jj,z)),XSTO(jj,z)*PPO(jj,z));
