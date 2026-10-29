* BAU, no-recycling TOU, and one REN-HH policy family.
* r=0 reuses TOU; a=0 is HH, a=1 is REN. Micro U/I/IC/C do not
* create separate representative-household equilibria.
SET sce / BAU, TOU, TOU_REN_HH /;
SET base_sce(sce) / BAU, TOU /;
SET macro_item
    / TIC_HH, SG, IT, YDH, GDP_REAL, CE_PHYS, LSF,
      EV, EV_PCT_CTH, CTH, CPI, CTH_DEFLATED, HH_ELEC_KTOE, HH_ELEC_GWH,
      CO2_INDUSTRY_COMB_KT, CO2_NONENERGY_KT, CO2_HH_DIRECT_KT,
      CO2_TOTAL_KT, CO2_POWER_COMB_KT /;
SET emission_component / COMBUSTION, NONENERGY /;
SET report_fuel_map(product,ene);
report_fuel_map(p_coal,'02_COAL')=yes;
report_fuel_map(p_oil,'03_OIL')=yes;
report_fuel_map(p_gas,'04_GAS')=yes;
report_fuel_map(p_oilproduct,'10_PETROLCOAL')=yes;
PARAMETERS
    block_price(sce,b,z), block_price_change(sce,b,z), block_quantity(sce,b,z)
    results_macro(sce,macro_item,z), run_status(sce,*)
    generation_output(sce,power,z), emissions_sector(sce,emission_component,j,z)
    block_price_policy(rr,aa,b,z), block_price_change_policy(rr,aa,b,z)
    block_quantity_policy(rr,aa,b,z), results_policy(rr,aa,macro_item,z)
    generation_policy(rr,aa,power,z), emissions_policy(rr,aa,emission_component,j,z)
    run_status_policy(rr,aa,*)
    budget_total(rr,aa,z), budget_hh(rr,aa,z), budget_ren(rr,aa,z)
    ren_support_actual(rr,aa,z), reference_retained(rr,aa,z), fiscal_residual_policy(rr,aa,z)
    production_tax_policy(rr,aa,j,z)
    macro_current(macro_item,z), generation_current(power,z)
    emissions_current(emission_component,j,z), report_co2_factor(product)
    generation_benchmark(power,z), household_benchmark_expenditure(z)
    model_money_to_billion_usd
;
report_co2_factor(product)=41.868*GHGsEF(product,'CO2EF')*(44/12)*.001*GWP('CO2EF');
generation_benchmark(power,z)=XSO(power,'18_ELEC',z);
household_benchmark_expenditure(z)=CTHO(z);
model_money_to_billion_usd=RES/1000;

loop(sce$base_sce(sce),
$include "Scenario/Reset_TOU.gms"
    if(sameas(sce,'TOU'),
        tth_B_raw(b,ZE2)=tou_tariff(b,ZE2)/bau_unit_price(ZE2)-1;
    );
    solve TOU using CNS;
    run_status(sce,'modelstat')=TOU.modelstat;
    run_status(sce,'solvestat')=TOU.solvestat;
    block_price(sce,b,z)=PC_HB.l(b,z);
    block_price_change(sce,b,z)=PC_HB.l(b,z)/block_price('BAU',b,z);
    block_quantity(sce,b,z)=C_B.l(b,z);
$include "Results_format/TOU_Macro_Current.gms"
    results_macro(sce,macro_item,z)=macro_current(macro_item,z);
    generation_output(sce,power,z)=generation_current(power,z);
    emissions_sector(sce,emission_component,j,z)=emissions_current(emission_component,j,z);
);
TOU_REVENUE_BASE(ZE2)=results_macro('TOU','TIC_HH',ZE2);
TOU_REBATE_BASE(ZE2)=max(0,TOU_REVENUE_BASE(ZE2));

loop((rr,aa),
    budget_total(rr,aa,ZE2)=recycle_rate(rr)*TOU_REBATE_BASE(ZE2);
    budget_hh(rr,aa,z)=(1-ren_share(aa))*budget_total(rr,aa,z);
    budget_ren(rr,aa,z)=ren_share(aa)*budget_total(rr,aa,z);
    reference_retained(rr,aa,ZE2)=(1-recycle_rate(rr))*TOU_REBATE_BASE(ZE2);
    if(recycle_rate(rr)=0,
        block_price_policy(rr,aa,b,z)=block_price('TOU',b,z);
        block_price_change_policy(rr,aa,b,z)=block_price_change('TOU',b,z);
        block_quantity_policy(rr,aa,b,z)=block_quantity('TOU',b,z);
        results_policy(rr,aa,macro_item,z)=results_macro('TOU',macro_item,z);
        generation_policy(rr,aa,power,z)=generation_output('TOU',power,z);
        emissions_policy(rr,aa,emission_component,j,z)=emissions_sector('TOU',emission_component,j,z);
        run_status_policy(rr,aa,'modelstat')=run_status('TOU','modelstat');
        run_status_policy(rr,aa,'solvestat')=run_status('TOU','solvestat');
        production_tax_policy(rr,aa,j,z)=ttipO(j,z);
    else
$include "Scenario/Reset_TOU.gms"
        tth_B_raw(b,ZE2)=tou_tariff(b,ZE2)/bau_unit_price(ZE2)-1;
        B_TOU(z)=budget_hh(rr,aa,z);
        B_TOU_REN(z)=budget_ren(rr,aa,z);
        tou_rebate_on(z)=1$(B_TOU(z)>0);
        tou_ren_on(z)=1$(B_TOU_REN(z)>0);
        ttip.lo(j,z)$(tou_ren_target(j) and ACTIVE_J(j,z) and tou_ren_on(z))=-inf;
        ttip.up(j,z)$(tou_ren_target(j) and ACTIVE_J(j,z) and tou_ren_on(z))=inf;
        solve TOU using CNS;
        run_status_policy(rr,aa,'modelstat')=TOU.modelstat;
        run_status_policy(rr,aa,'solvestat')=TOU.solvestat;
        block_price_policy(rr,aa,b,z)=PC_HB.l(b,z);
        block_price_change_policy(rr,aa,b,z)=PC_HB.l(b,z)/block_price('BAU',b,z);
        block_quantity_policy(rr,aa,b,z)=C_B.l(b,z);
$include "Results_format/TOU_Macro_Current.gms"
        results_policy(rr,aa,macro_item,z)=macro_current(macro_item,z);
        generation_policy(rr,aa,power,z)=generation_current(power,z);
        emissions_policy(rr,aa,emission_component,j,z)=emissions_current(emission_component,j,z);
        production_tax_policy(rr,aa,j,z)=ttip.l(j,z);
        ren_support_actual(rr,aa,z)=sum(j$tou_ren_target(j),
            (ttipO(j,z)-ttip.l(j,z))*PP.l(j,z)*XST.l(j,z));
    );
    fiscal_residual_policy(rr,aa,z)=results_policy(rr,aa,'TIC_HH',z)
        -budget_hh(rr,aa,z)-budget_ren(rr,aa,z);
);
$if not set RESULTS_GDX $setglobal RESULTS_GDX TOU_recycling_results.gdx
execute_unload '%RESULTS_GDX%',
    sce,base_sce,rr,aa,recycle_rate,ren_share,macro_item,z,j,power,b,
    emission_component,tou_ren_target,TOU_REVENUE_BASE,TOU_REBATE_BASE,
    block_price,block_price_change,block_quantity,results_macro,run_status,
    generation_output,emissions_sector,generation_benchmark,household_benchmark_expenditure,
    block_price_policy,block_price_change_policy,block_quantity_policy,results_policy,
    generation_policy,emissions_policy,run_status_policy,budget_total,budget_hh,budget_ren,
    ren_support_actual,reference_retained,fiscal_residual_policy,production_tax_policy,
    model_money_to_billion_usd;
