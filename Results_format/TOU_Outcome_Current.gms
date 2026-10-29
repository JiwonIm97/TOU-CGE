* Reporting only: no equations, policy changes, or additional abort checks.
* CO2 factor: ktoe * 41.868 TJ/ktoe * tC/TJ * 44/12 / 1000 = ktCO2.
emissions_current('COMBUSTION',j,z)
    = sum((product,ene)$report_fuel_map(product,ene),
          EEI(product,j,z)*DE.l(ene,j,z)*report_co2_factor(product));
emissions_current('NONENERGY',j,z)
    = sum((product,ene)$report_fuel_map(product,ene),
          NEI(product,j,z)*DE.l(ene,j,z)*report_co2_factor(product)
          *(1-GHGsEF(product,'Stored_rate')));

generation_current(power,z) = XS.l(power,'18_ELEC',z);

* Exact Stone-Geary EV for fixed CMIN and household purchaser prices.
* Supply-cost effects already enter equilibrium: do not add them to EV again.
macro_current('EV',z)
    = (CTH.l(z)-sum(i,PC_HH.l(i,z)*CMINO(i,z)))
      *exp(sum(i$gamma_LES(i,z),gamma_LES(i,z)
          *(log(PC_HHO(i,z))-log(PC_HH.l(i,z)))))
      -(CTHO(z)-sum(i,PC_HHO(i,z)*CMINO(i,z)));
macro_current('EV_PCT_CTH',z) = 100*macro_current('EV',z)/CTHO(z);
macro_current('CTH',z) = CTH.l(z);
macro_current('CPI',z) = PIXCON.l(z);
macro_current('CTH_DEFLATED',z) = CTH.l(z)/PIXCON.l(z);
macro_current('HH_ELEC_KTOE',z) = EHI_ELEC(z)*CE_PHYS.l(z);
macro_current('HH_ELEC_GWH',z) = 11.63*macro_current('HH_ELEC_KTOE',z);
macro_current('CO2_INDUSTRY_COMB_KT',z) = sum(j,emissions_current('COMBUSTION',j,z));
macro_current('CO2_NONENERGY_KT',z) = sum(j,emissions_current('NONENERGY',j,z));
macro_current('CO2_HH_DIRECT_KT',z)
    = sum((product,ene)$report_fuel_map(product,ene),
          EHI(product,z)*C.l(ene,z)*report_co2_factor(product));
macro_current('CO2_TOTAL_KT',z)
    = macro_current('CO2_INDUSTRY_COMB_KT',z)
      +macro_current('CO2_NONENERGY_KT',z)+macro_current('CO2_HH_DIRECT_KT',z);
* Subset of industry combustion; never add this again to total CO2.
macro_current('CO2_POWER_COMB_KT',z)
    = sum(power,emissions_current('COMBUSTION',power,z));
