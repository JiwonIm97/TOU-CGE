* No CBAM shock or CBAM recycling in these TOU experiments.
rcy_share(z,zj)=0; rcy_hh(z)=0; rcy_gov(z)=0;
rcy_lab(z)=0; rcy_prd(z)=0;
CP.FX(z)=0; CTAX.FX(z)=CTAX0(z);
ttip.FX(j,z)=ttipO(j,z); ttiw.FX(l,j,z)=ttiwO(l,j,z);
tou_rebate_on(z)=0;
tth.FX(i,z)=tth0(i,z);
tth_B_raw(b,z)=0; e2_expost(z)=0;
* Release any previous fixed wedges; price equations enforce positive prices.
tth_B.LO(b,z)=-inf; tth_B.UP(b,z)=inf;
tou_shift.LO(z)=-inf; tou_shift.UP(z)=inf;
tth_B.L(b,z)=0; tou_shift.L(z)=0;
* B_TOU intentionally retained across scenarios after the basic TOU run.

B_TOU(z)=0; B_TOU_REN(z)=0; tou_ren_on(z)=0;
