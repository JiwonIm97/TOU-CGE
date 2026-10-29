* Same tariff shock for TOU and all REN-HH mixes.
* Tariff values retained from the previous accepted model inputs.
PARAMETERS tou_tariff(b,z) "TOU marginal rates KRW/kWh"
           bau_unit_price(z) "BAU unit-price anchor on the same basis";
bau_unit_price('01_KOR') = 156.7642201472;
tou_tariff('peak','01_KOR') = 214.4583333333;
tou_tariff('mid','01_KOR') = 185.8250000000;
tou_tariff('off','01_KOR') = 147.3250000000;

SET rr "Recycling share grid" / r00, r10, r20, r30, r40, r50, r60, r70, r80, r90, r100 /;
PARAMETER recycle_rate(rr) / r00 0, r10 .1, r20 .2, r30 .3, r40 .4, r50 .5,
    r60 .6, r70 .7, r80 .8, r90 .9, r100 1 /;
SET aa "REN allocation share grid" / a00, a10, a20, a30, a40, a50, a60, a70, a80, a90, a100 /;
PARAMETER ren_share(aa) / a00 0, a10 .1, a20 .2, a30 .3, a40 .4, a50 .5,
    a60 .6, a70 .7, a80 .8, a90 .9, a100 1 /;
PARAMETERS TOU_REVENUE_BASE(z) "Frozen signed no-recycling TOU revenue"
           TOU_REBATE_BASE(z) "Positive reference TOU receipts; not utility profit";
TOU_REVENUE_BASE(z)=0; TOU_REBATE_BASE(z)=0;
