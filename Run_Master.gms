$title TOU master runner
* Set RUN_POLICY to 1 after completing Policy/TOU_Inputs.gms.
* Command-line --RUN_POLICY=1 also enables the TOU REN-HH recycling experiments.
$if not set RUN_POLICY $setglobal RUN_POLICY 1
* Run from this project root.
* RUN_POLICY=0: benchmark only. RUN_POLICY=1: benchmark + policy experiments.
$include "Sets.gms"
$include "PAR.gms"
$include "CAL.gms"
$include "Policy/Recycling.gms"
$include "Model.gms"
$include "Init_Closure.gms"
option cns=conopt4;
model TOU /all/;
TOU.holdfixed=1;
$include "Scaling.gms"
TOU.scaleopt=1;
* 1. Benchmark policy: no TOU shock and no new rebate
tth_B_raw(b,z) = 0;
e2_expost(z)   = 0;
tou_rebate_on(z) = 0;
B_TOU(z)        = 0;
B_TOU_REN(z)    = 0;
tou_ren_on(z)   = 0;

* Compact output; essential status and accounting checks remain active.
option limrow=0, limcol=0, solprint=off;

solve TOU using CNS;

display TOU.solvestat, TOU.modelstat;

abort$(TOU.solvestat <> 1
    or (TOU.modelstat <> 15 and TOU.modelstat <> 16))
    "Benchmark solve failed";

* 3. Check benchmark replication and accounting
parameter check_bau(*);

check_bau('C_rel') =
    smax((i,z), abs(C.l(i,z)-CO(i,z))/(1+abs(CO(i,z))));

check_bau('XST_rel') =
    smax((j,z), abs(XST.l(j,z)-XSTO(j,z))/(1+abs(XSTO(j,z))));

check_bau('PC_HH_rel') =
    smax((i,z), abs(PC_HH.l(i,z)-PC_HHO(i,z))
              /(1+abs(PC_HHO(i,z))));

check_bau('C_B_rel') =
    smax((b,z), abs(C_B.l(b,z)-C_BO(b,z))
              /(1+abs(C_BO(b,z))));

check_bau('LSF_dev') =
    smax(z, abs(LSF.l(z)-1));

check_bau('TIC_HH_abs') =
    smax(z, abs(TIC_HH.l(z)));

check_bau('Walras_abs') =
    smax(z, abs(LEON.l(z)));

check_bau('CES_exp_rel') =
    smax(z,
        abs(PC_HH.l('18_ELEC',z)*C.l('18_ELEC',z)
          - sum(b,PC_HB.l(b,z)*C_B.l(b,z)))
        /(1+abs(PC_HH.l('18_ELEC',z)*C.l('18_ELEC',z))));

display check_bau;


$ifthen %RUN_POLICY%==1
$include "Policy/TOU_Inputs.gms"
$include "Scenario/Run_Policy.gms"
$else
put_utility 'log' / 'Run_Master: benchmark passed. Policy scenarios disabled (RUN_POLICY=0).';
$endif
