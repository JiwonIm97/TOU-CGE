* [Z1] Structural-zero fix adapted from researcher CBAM CAL/Model uploads
* dated 2026-10-26 (pasted markdown 5 and 2(2)). Active benchmark industries
* only; zero-output nuclear generation remains zero, with no entry margin.
* No epsilon output and no imputed elasticity for inactive activities.
* ============================================================================
* TOU revision 2026-10-26: upper Leontief / lower peak-off CES.
* Footnotes (source versus assumption deliberately distinguished):
* [T1] Rutherford (1995), Constant Elasticity of Substitution Functions,
*      GAMS documentation, calibrated shares and conditional demand:
*      https://www.gams.com/latest/docs/UG_MPSGE_CES.html
* [T2] RESEARCH ASSUMPTION approved by researcher: mid versus peak/off
*      composite has zero substitution elasticity; peak/off may substitute.
*      This fixes composite proportions, NOT absolute mid consumption.
* [T3] INPUT PROVENANCE: supplied CAL block shares (A7-based legacy inputs).
*      Retained values are not newly verified national kWh-weighted estimates.
*      A8 remaining minimum peak share is a micro constraint, NOT elasticity.
*      No choice-experiment estimates are used in this implementation.
* [T4] SENSITIVITY ASSUMPTION: inherited lower elasticity 0.15, not an
*      estimate from A7/A8. Equal upper/lower elasticities recover flat CES.
* [T5] SUPPLY ASSUMPTION: inherited delta values 0.06/0.07/-0.12 are
*      exploratory cost coefficients, NOT verified marginal-cost estimates.

*      LSF is a reduced-form productivity channel, NOT dispatch optimization.
* [T6] ACCOUNTING ASSUMPTION: household wedges accrue to government here.
*      Utility tariff receipts are not automatically tax revenue. Fiscal
*      ownership and financing must be resolved before recycling experiments.
* [T7] SCOPE: aggregate CGE demand remains endogenous. Survey micro analysis
*      with fixed total kWh is a separate conditional simulation; use block
*      price changes and NEW rebates only, and report net bills, not micro EV.
*      BAU here is the aggregate benchmark, not an explicit nonlinear IBR.
* Integration: keep existing Init_Closure and scenario reset logic. Any later
* override of sigma_ToU1/2, e2_expost, price bounds or policy wedges prevails.
* Compilation/solve not performed: GAMS runtime and full inputs unavailable.
* ============================================================================
* Delivery: CAL.gms, 2026-10-26
* Base: TOU-CGE/CAL.gms, GitHub blob 929f52fe59f8cdc51073d33852fc7817cb690f2e
* Requires updated GTAP12 Sets/PAR and Input_WEB/DATA_WEB_2023.gms.
* WEB is included here; keep its J/I/Z declarations inactive.
* Requires BS/BM in Sets, and theta_BS/theta_MID/theta_S,
* sigma_ToU1/sigma_ToU2/PC_HSO/C_SO plus PC_HS/C_S in PAR.
* sigma_X4 must be assigned in PAR (existing value: 2).
* CE_PHYS remains in model quantity units; multiply by EHI_ELEC for ktoe.
* No new economic parameter values; CET equations retained unchanged.
* GAMS compile/solve not performed in the delivery environment.
* ==============================================================================
* CAL.gms
* 벤치마크 보정: 소득·세율·CES/CET/LES·CO2 (원본 L532-1061)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================
* 4.1 Calculation of income and savings related variables and parameters
*==============================================================================
* [Z1] Determine activity before any division by industry output.
XSTO(j,z)=sum(i,XSO(j,i,z));
ACTIVE_J(j,z)=yes$(XSTO(j,z)>0);
ACTIVE_POWER(j,z)=yes$(POWER(j) and ACTIVE_J(j,z)
                           and XSO(j,'18_ELEC',z)>0);
SET zero_conflict(j,z) "Zero output but nonzero GTAP production inputs";
zero_conflict(j,z)=yes$(not ACTIVE_J(j,z) and
 (sum(i,abs(DIO(i,j,z)))+sum(l,abs(LDO(l,j,z)))
 +sum(k,abs(RKDO(k,j,z)))+abs(TIPO(j,z))
 +sum(l,abs(TIWO(l,j,z)))+sum(k,abs(TIKO(k,j,z))))>1e-10);
abort$(card(zero_conflict)>0) "Inactive-output data inconsistency",zero_conflict;
abort$(smin(z,sum(j$ACTIVE_POWER(j,z),1))=0)
 "No active electricity generation in a region";
* Invalid active-nest elasticities must be corrected at source, not imputed.
sigma_VA('10_PETROLCOAL',z)=1.260;
SET invalid_prod_sigma(j,z);
invalid_prod_sigma(j,z)=yes$(ACTIVE_J(j,z) and
 (sigma_KD(j,z)<=0 or sigma_LD(j,z)<=0 or sigma_VA(j,z)<=0
 or abs(sigma_KD(j,z)-1)<1e-10 or abs(sigma_LD(j,z)-1)<1e-10
 or abs(sigma_VA(j,z)-1)<1e-10
 or sigma_ENER(j,z)<=0 or abs(sigma_ENER(j,z)-1)<1e-10
 or (J2(j) and (sigma_KLE(j,z)<=0 or abs(sigma_KLE(j,z)-1)<1e-10))));
abort$(card(invalid_prod_sigma)>0)
 "Active production CES requires positive non-unit elasticity in existing form",
 invalid_prod_sigma;
 YHKO(z)         = SUM[(k,j),RKDO(k,j,z)];
 YHLO(z)         = SUM[(l,j),LDO(l,j,z)];
 YHO(z)          = YHLO(z)+YHKO(z);
 YDHO(z)         = YHO(z)-TDHO(z);
 CTHO(z)         = SUM[i,CO(i,z)];
 SHO(z)          = YDHO(z)-CTHO(z);
 TICTO(z)        = SUM[i,TICO(i,z)];
 TIMTO(z)        = SUM[(i,zj),TIMO(i,zj,z)];
 TIWTO(z)        = SUM[(l,j),TIWO(l,j,z)];
 TIKTO(z)        = SUM[(k,j),TIKO(k,j,z)];
 TIPTO(z)        = SUM[j,TIPO(j,z)];
 TIXTO(z)        = SUM[(i,zj),TIXO(i,z,zj)];
 TPRODNO(z)      = TIKTO(z)+TIWTO(z)+TIPTO(z);
 TPRCTSO(z)      = TICTO(z)+TIMTO(z)+TIXTO(z);
 YGO(z)          = TDHO(z)+TPRCTSO(z)+TPRODNO(z);
 GO(z)           = SUM[i,CGO(i,z)];
 SGO(z)          = YGO(z)-GO(z);
 YROWO(z)        = SUM[(i,zj),IMO(i,zj,z)]+SUM[(i,ij,zj),tmrg(i,ij,zj,z)];
 SROWO(z)        = YROWO(z)-SUM[(i,zj),EXO(i,z,zj)]-SUM[i,MRGNO(i,z)];
 CABO(z)         = -SROWO(z);
 ITO(z)          = SHO(z)+SGO(z)+SROWO(z);
*==============================================================================
* 4.2 Calibration of parameters and other variables
*==============================================================================
* 4.2.1 Calibration of investment and government spending shares
*==============================================================================
 gamma_GVT(i,z)  = CGO(i,z)/SUM[ij,CGO(ij,z)];
 gamma_INV(i,z)  = INVO(i,z)/SUM[ij,INVO(ij,z)] ;
*==============================================================================
* 4.2.2 Calibration of other prices and revised volumes (part 1)
*==============================================================================
 LDO(l,j,z)      = LDO(l,j,z)/WO(l,z);
 LDCO(j,z)       = SUM[l,LDO(l,j,z)];
* [Z2] Benchmark labor aggregation must follow loaded factor payments.
* [Z2] Removed hard-coded 1.629: retain LDCO=sum(l,LDO) for GTAP12 accounting.
 LSO(l,z)        = SUM[j,LDO(l,j,z)];
 EXO(i,z,zj)     = [EXO(i,z,zj)-TIXO(i,z,zj)]/PEO(i,z,zj);
 EXTO(i,z)       = SUM[zj,EXO(i,z,zj)];
 PWXO(i,z,zj)$EXO(i,z,zj)
                 = {[PEO(i,z,zj)*EXO(i,z,zj)+TIXO(i,z,zj)]/EXO(i,z,zj)}/eO(z);
 PETO(i,z)       = SUM[zj,PEO(i,z,zj)*EXO(i,z,zj)]/EXTO(i,z);
 PWMO(i,z,zj)    = PWXO(i,z,zj);
 IMO(i,zj,z)     = EXO(i,zj,z);
 IMTO(i,z)       = SUM[zj,IMO(i,zj,z)];
 DSO(j,i,z)      = DSO(j,i,z)/PLO(i,z);
 DSO_I(i,z)      = SUM(j,DSO(j,i,z));
 DSO_J(j,z)      = SUM(i,DSO(j,i,z));
 QO(i,z)         = IMTO(i,z)+DDO(i,z);
 MRGNO(i,z)$MRGNO(i,z)
                 = MRGNO(i,z)/[eO(z)*PWMGO(i)];
 XSO_I(i,z)      = EXTO(i,z)+DDO(i,z)+MRGNO(i,z);
 XSTO(j,z)       = sum(i, XSO(j,i,z));
 IMO2(zj,z)      = sum(i,IMO(i,zj,z));
 PO(i,z)         = [PETO(i,z)*EXTO(i,z)+PLO(i,z)*DSO_I(i,z)
                  +eO(z)*PWMGO(i)*MRGNO(i,z)]/XSO_I(i,z);
 PO2(j,i,z)$XSO(j,i,z) = 1;
 PO3(i,j,z)$XSO(j,i,z) = 1;
 PIO(i,z)        = SUM[j$XSO(j,i,z),PO2(J,I,z)*XSO(j,i,z)]/XSO_I(i,z);

 PTO(j,z) = 1;
 PTO(j,z)$(ACTIVE_J(j,z)) = SUM[i$XSO(j,i,z),PO2(j,i,z)*XSO(j,i,z)]/XSTO(j,z);

 PPO(j,z) = 1;
 PPO(j,z)$(ACTIVE_J(j,z)) = [SUM[l,TIWO(l,j,z)+WO(l,z)*LDO(l,j,z)]
                  +SUM[k,TIKO(k,j,z)+RKDO(k,j,z)]
                  +SUM[nene,DIO(nene,j,z)]+SUM[ene,DIO(ene,j,z)]]/XSTO(j,z);
 theta2(j,i,z)   = DSO(j,i,z)/sum(jj, DSO(jj,i,z));
 EXTTO(j,i,z)$DSO(j,i,z) = theta2(j,i,z)*EXTO(i,z);
*==============================================================================
* 4.3 Calibration of tax rates, margins, prices and volumes
*==============================================================================
* 4.3.1 Margin rates and tax rates
*==============================================================================
 ttixO(i,z,zj)   = [eO(z)*PWXO(i,z,zj)/PEO(i,z,zj)]-1;
 tticO(i,z)      = TICO(i,z)/{PLO(i,z)*DDO(i,z)
                   +SUM[zj,IMO(i,zj,z)*eO(z)*PWMO(i,zj,z)
                   +TIMO(i,zj,z)+SUM[ij,tmrg(ij,i,zj,z)]]};
 tmrg(i,ij,zj,z)$IMO(ij,zj,z)
                 = tmrg(i,ij,zj,z)/(PWMGO(i)*eO(z)*IMO(ij,zj,z));
 ttimO(i,zj,z)$IMO(i,zj,z)
                 = TIMO(i,zj,z)/{IMO(i,zj,z)*eO(z)*(PWMO(i,zj,z)
                  +SUM[ij,PWMGO(ij)*tmrg(ij,i,zj,z)])};
 ttiwO(l,j,z)$LDO(l,j,z)
                 = TIWO(l,j,z)/[WO(l,z)*LDO(l,j,z)];
 ttikO(k,j,z)$RKDO(k,j,z)
                 = TIKO(k,j,z)/RKDO(k,j,z);
 ttipO(j,z)      = [PTO(j,z)/PPO(j,z)]-1;
 ttdh1O(z)       = [TDHO(z)-ttdh0O(z)]/YHO(z);
*==============================================================================
* 4.9 CO2 emission
*==============================================================================
$INCLUDE Input_WEB/DATA_WEB_2023.gms
Parameter
CO2IO(product,j,z) ktCO2 emission for industry j sector
 CO2HO(product,z)   ktCO2 direct emission for residendital sector
 TCO2IO(j,z)        ktCO2 total emission for industry sector j in region z
 CO2ICO(i,zj)       carbon content for commodity i in region z (tCO2 per$)
 CO2IDFactor(i,zj)  indirect carbon content for commodity i in region z (tCO2 per$)
 TCO2IO2(i,zj)      Total CO2 emissions for commodity i in region zj
 XSTO2(i,zj)        Total output for commodity i in region zj
 CP0(z)             CBAM carbon price per ton CO2 ($ per tCO2)
 GWP(type)          Global Warming Potential (100-year AR5)
 ;
 GWP('CO2EF') = 1;
 GWP('CH4EF') = 28;
 GWP('N2OEF') = 265;
***Direct emissions
 CO2IO(p_coal,j,z)$Coal_DIO(p_coal,j,z) = Coal_DIO(p_coal,j,z)*41.868*GHGsEF(p_coal,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 CO2IO(p_gas,j,z)$Gas_DIO(p_gas,j,z)  = Gas_DIO(p_gas,j,z)*41.868*GHGsEF(p_gas,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 CO2IO(p_oilproduct,j,z)$Oilp_DIO(p_oilproduct,j,z)  = Oilp_DIO(p_oilproduct,j,z)*41.868*GHGsEF(p_oilproduct,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 CO2HO(p_coal,z)$Coal_CO(p_coal,z) = Coal_CO(p_coal,z)*41.868*GHGsEF(p_coal,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 CO2HO(p_gas,z)$Gas_CO(p_gas,z) = Gas_CO(p_gas,z)*41.868*GHGsEF(p_gas,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 CO2HO(p_oilproduct,z)$Oilp_CO(p_oilproduct,z) = Oilp_CO(p_oilproduct,z)*41.868*GHGsEF(p_oilproduct,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
***Indirect emissions
 CO2IO(p_elec,j,z) = {sum((p_coal,elec),CO2IO(p_coal,elec,z))+sum((p_oilproduct,elec),CO2IO(p_oilproduct,elec,z))+sum((p_gas,elec),CO2IO(p_gas,elec,z))}*{sum(p_elecheat,Elec_DIO(p_elecheat,j,z))/sum((p_elecheat,jj),Elec_DIO(p_elecheat,jj,z))};
***Total emissions
 TCO2IO(j,z)  = sum(product, CO2IO(product,j,z));
***carbon content
 XSTO2(i,zj)   = sum(j$(INDtoCOM(j,i)),XSTO(j,zj));
 TCO2IO2(i,z)  = sum(j$(INDtoCOM(j,i)),TCO2IO(j,z));
 CO2IDFACTOR(i,zj)  = TCO2IO2(i,zj)/XSTO2(i,zj)*1e-7;
 CO2IDFACTOR(i3,zj) = 0 ;
 CP0(z)=0;
*==============================================================================
* 4.3.2 Calibration of other prices and revised volumes (part 2)
*==============================================================================
 PDO(i,z)        = PLO(i,z)*(1+tticO(i,z));
 PMO(i,zj,z)     = eO(z)*(1+tticO(i,z))*(1+ttimO(i,zj,z))
                   *(PWMO(i,zj,z)+SUM[ij,PWMGO(ij)*tmrg(ij,i,zj,z)]+CP0(zj)*CO2IDFACTOR(i,zj)*eO(z)*PWMO(i,zj,z));
 PMTO(i,z)       = SUM[zj,PMO(i,zj,z)*IMO(i,zj,z)]/IMTO(i,z);
 PCO(i,z)        = [PMTO(i,z)*IMTO(i,z)+PDO(i,z)*DDO(i,z)]/QO(i,z);
 CO(i,z)         = CO(i,z)/PCO(i,z);
 CGO(i,z)        = CGO(i,z)/PCO(i,z);
 DIO(nene,j,z)   = DIO(nene,j,z)/PCO(nene,z);
 DEO(ene,j,z)    = DIO(ene,j,z)/PCO(ene,z);
 INVO(i,z)       = INVO(i,z)/PCO(i,z);
 CIO(j,z)        = SUM[nene,DIO(nene,j,z)];
 CEO(j,z)        = SUM[ene,DEO(ene,j,z)];
 DITO(nene,z)     = SUM[j,DIO(nene,j,z)];
 DITO(ene,z)      = SUM[j,DEO(ene,j,z)];
 PO4(ene,j,z)    = PCO(ene,z);

 PCIO(j,z) = 1;
 PCIO(j,z)$(ACTIVE_J(j,z) and CIO(j,z)>0) = SUM[nene,PCO(nene,z)*DIO(nene,j,z)]/CIO(j,z);

 PCEO(j,z) = 1;
 PCEO(j,z)$(ACTIVE_J(j,z) and CEO(j,z)>0) = SUM[ene,PCO(ene,z)*DEO(ene,j,z)]/CEO(j,z) ;
 WTIO(l,j,z)     = WO(l,z)*(1+ttiwO(l,j,z));
 WCO(j,z)$LDCO(j,z)
                 = SUM[l,WTIO(l,j,z)*LDO(l,j,z)]/LDCO(j,z);
*==============================================================================
* 4.3.3 Calibration of other prices and revised volumes (part 3)
*==============================================================================
* The price of capital is arbitrary:
 PKO(z) = 1;
* From GTAP, we know KSTO.
 KSTO(z)         = KSTO(z)/PKO(z);
* Assuming a uniform depreciation rate for all types of capital and all industries:
 delta(z)        = DEPO(z)/[PKO(z)*KSTO(z)];
* Assuming a uniform rental rate R for all types of capital and all industries:
 RKO(k,z)        = 1;
 RO(k,j,z)$RKDO(k,j,z)
                 = RKO(k,z);
* Then from the GTAP value of income paid to capital RKD we calibrate KDO:
 KDO(k,j,z)$RKDO(k,j,z)
                 = RKDO(k,j,z)/RO(k,j,z);
* The supply of capital is equal to demand:
 KSO(k,z)        = SUM[j,KDO(k,j,z)];
 A_K(z)          = 1/PKO(z)*{PROD[i$gamma_INV(i,z),(PCO(i,Z)/gamma_INV(i,z))
                   **gamma_INV(i,z)]};
 KDCO(j,z)       = SUM[k,KDO(k,j,z)];
 RTIO(k,j,z)     = RO(k,j,z)*(1+ttikO(k,j,z));
 RCO(j,z)$KDCO(j,z)
                 = SUM[k,RTIO(k,j,z)*KDO(k,j,z)]/KDCO(j,z);
*==============================================================================
* 4.3.4 Calibration of other prices and revised volumes (part 4)
*==============================================================================
 VAO(j,z)        = LDCO(j,z)+KDCO(j,z);

 PVAO(j,z) = 1;
 PVAO(j,z)$(ACTIVE_J(j,z) and VAO(j,z)>0) = [WCO(j,z)*LDCO(j,z)+RCO(j,z)*KDCO(j,z)]/VAO(j,z);
 PIXGDPO(z)      = 1;
 PIXGDP_WO       = 1;
 PIXCONO(z)      = 1;
 PIXINVO(z)      = 1;
 PIXGVTO(z)      = 1;
*==============================================================================
* 4.4 Calibration of function parameters
*==============================================================================
* 4.4.1 Leontief functions
*==============================================================================

 io(j,z)$(ACTIVE_J(j,z)) = CIO(j,z)/XSTO(j,z) ;

 io2(j,z)$(ACTIVE_J(j,z)) = CEO(j,z)/XSTO(j,z) ;

 v(j,z)$(ACTIVE_J(j,z)) = VAO(j,z)/XSTO(j,z) ;

 v2(j,z)$(ACTIVE_J(j,z)) = (CEO(j,z)+VAO(j,z))/XSTO(j,z) ;

 aij(nene,j,z)$(ACTIVE_J(j,z) and CIO(j,z)>0) = DIO(nene,j,z)/CIO(j,z);

 aij2(ene,j,z)$(ACTIVE_J(j,z) and CEO(j,z)>0) = DEO(ene,j,z)/CEO(j,z);
*==============================================================================
* 4.4.2 Calibration of CET parameters
*==============================================================================
* 4.4.2.1 CET between total exports, domestic supply and margins
*==============================================================================
 rho_X1(i,z)     = (1+sigma_X1(i,z))/sigma_X1(i,z);
 beta_EX_X1(i,z)$MRGNO(i,z)
                 = [PETO(i,z)*EXTO(i,z)$EXTO(i,z)**(1-rho_X1(i,z))]/
                   [PETO(i,z)*EXTO(i,z)$EXTO(i,z)**(1-rho_X1(i,z))+
                   PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))+
                   eO(z)*PWMGO(i)*MRGNO(i,z)$MRGNO(i,z)**(1-rho_X1(i,z))+Tiny];
 beta_EX_X1(i,z)$(MRGNO(i,z) eq 0)
                 = [PETO(i,z)*EXTO(i,z)$EXTO(i,z)**(1-rho_X1(i,z))]/
                   [PETO(i,z)*EXTO(i,z)$EXTO(i,z)**(1-rho_X1(i,z))+
                   PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))+Tiny];
 beta_D_X1(i,z)$MRGNO(i,z)
                 = [PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))]/
                   [PETO(i,z)*EXTO(i,z)**(1-rho_X1(i,z))+
                   PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))+
                   eO(z)*PWMGO(i)*MRGNO(i,z)**(1-rho_X1(i,z))];
 beta_D_X1(i,z)$(MRGNO(i,z) eq 0)
                 = [PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))]/
                   [PETO(i,z)*EXTO(i,z)**(1-rho_X1(i,z))+
                   PLO(i,z)*DSO_I(i,z)**(1-rho_X1(i,z))];
 B_X1(i,z)       = XSO_I(i,z)/[beta_EX_X1(i,z)*EXTO(i,z)**rho_X1(i,z)
                  +beta_D_X1(i,z)*DSO_I(i,z)**rho_X1(i,z)+(1-beta_EX_X1(i,z)
                  -beta_D_X1(i,z))*MRGNO(i,z)**rho_X1(i,z)]**(1/rho_X1(i,z));
*==============================================================================
* 4.4.2.2 CET between exports to different trading partners
*==============================================================================
 rho_X2(i,z)     = (1+sigma_X2(i,z))/sigma_X2(i,z);
 beta_X2(i,z,zj)$EXO(i,z,zj)
                 = [PEO(i,z,zj)*EXO(i,z,zj)**(1-rho_X2(i,z))]/
SUM[zjj$EXO(i,z,zjj),PEO(i,z,zjj)*EXO(i,z,zjj)
                   **(1-rho_X2(i,z))];
 B_X2(i,z)       = EXTO(i,z)/{SUM[zj,beta_X2(i,z,zj)*EXO(i,z,zj)**rho_X2(i,z)]
                   **(1/rho_X2(i,z))};
*==============================================================================
* 4.4.3 Calibration of CES parameters
*==============================================================================
* 4.4.3.0 Composite output
*==============================================================================
 rho_X3(i,z)   = (1-sigma_X3(i,z))/sigma_X3(i,z);
 beta_X3(j,i,z)$XSO(j,i,z)
               = [PO2(j,i,z)*XSO(j,i,z)**(1+rho_X3(i,z))]/
SUM[jj$XSO(jj,i,z),PO2(jj,i,z)*XSO(jj,i,z)**(1+rho_X3(i,z))];
 B_X3(i,z)     = XSO_I(i,z)
                  /SUM[jj$XSO(jj,i,z),beta_X3(jj,i,z)*XSO(jj,i,z)**(-rho_X3(i,z))
                  ]**(-1/rho_X3(i,z));
 POWERQO(z) = SUM(power$ACTIVE_POWER(power,z),XSO(power,'18_ELEC',z));
 rho_X4(z)   = (1-sigma_X4(z))/sigma_X4(z);
 beta_X4(power,z)=0;
 beta_X4(power,z)$ACTIVE_POWER(power,z)
               = [PO2(power,'18_ELEC',z)*XSO(power,'18_ELEC',z)**(1+rho_X4(z))]/
SUM[power2$ACTIVE_POWER(power2,z),PO2(power2,'18_ELEC',z)*XSO(power2,'18_ELEC',z)**(1+rho_X4(z))];
 B_X4(z)     = POWERQO(Z)
                  /SUM[power2$ACTIVE_POWER(power2,z),beta_X4(power2,z)*XSO(power2,'18_ELEC',z)**(-rho_X4(z))
                  ]**(-1/rho_X4(z));
 TnDShare(z) = XSO('18_TnD','18_ELEC',z) / XSO_I('18_ELEC',z);
 PPOWERO(z) = 1;
*==============================================================================
* 4.4.3.1 Composite good
*==============================================================================
 rho_M1(i,z)     = (1-sigma_m1(i,z))/sigma_m1(i,z);
 beta_M1(i,z)    = PMTO(i,z)*IMTO(i,z)**(rho_M1(i,z)+1)/
                  {PDO(i,z)*DDO(i,z)**(rho_M1(i,z)+1)
                  +PMTO(i,z)*IMTO(i,z)**(rho_M1(i,z)+1)};
 B_M1(i,z)       = QO(i,z)/{beta_M1(i,z)*IMTO(i,z)**(-rho_M1(i,z))
                  +(1-beta_M1(i,z))*DDO(i,z)**(-rho_M1(i,z))}**(-1/rho_M1(i,z));
*==============================================================================
* 4.4.3.2 CES between imports from different trading partners
*==============================================================================
 rho_M2(i,z)     = (1-sigma_M2(i,z))/sigma_M2(i,z);
 beta_M2(i,zj,z)$IMO(i,zj,z)
                 = [PMO(i,zj,z)*IMO(i,zj,z)**(rho_M2(i,z)+1)]/
SUM[zjj$IMO(i,zjj,z),PMO(i,zjj,z)*IMO(i,zjj,z)
                    **(rho_M2(i,z)+1)];
 B_M2(i,z)       = IMTO(i,z)/{SUM[zj$IMO(i,zj,z),beta_M2(i,zj,z)*IMO(i,zj,z)
                   **(-rho_M2(i,z))]**(-1/rho_M2(i,z))};
*==============================================================================
* 4.4.3.3 Composite capital
*==============================================================================

 rho_KD(j,z) = 1;
 rho_KD(j,z)$(ACTIVE_J(j,z)) = (1-sigma_KD(j,z))/sigma_KD(j,z);
 beta_KD(k,j,z)$KDO(k,j,z)
                 = [RTIO(k,j,z)*KDO(k,j,z)**(1+rho_KD(j,z))]/
SUM[kj$KDO(kj,j,z),RTIO(kj,j,z)*KDO(kj,j,z)**(1+rho_KD(j,z))];
 B_KD(j,z)$KDCO(j,z)
                 = KDCO(j,z)/{SUM[k$KDO(k,j,z),beta_KD(k,j,z)*KDO(k,j,z)
                   **(-rho_KD(j,z))]**(-1/rho_KD(j,z))};
*==============================================================================
* 4.4.3.4 Composite labor
*==============================================================================

 rho_LD(j,z) = 1;
 rho_LD(j,z)$(ACTIVE_J(j,z)) = (1-sigma_LD(j,z))/sigma_LD(j,z);
 beta_LD(l,j,z)$LDO(l,j,z)  = [WTIO(l,j,z)*LDO(l,j,z)**(1+rho_LD(j,z))]/
SUM[lj$LDO(lj,j,z),WTIO(lj,j,z)*LDO(lj,j,z)
                   **(1+rho_LD(j,z))];
 B_LD(j,z)$LDCO(j,z)
                 = LDCO(j,z)/{SUM[l$LDO(l,j,z),beta_LD(l,j,z)*LDO(l,j,z)
                   **(-rho_LD(j,z))]**(-1/rho_LD(j,z))};
*===============================================================================
* Composite E
*===============================================================================

 rho_ENER(j,z) = 1;
 rho_ENER(j,z)$(ACTIVE_J(j,z)) = (1-sigma_ENER(j,z))/sigma_ENER(j,z);
 beta_ENER(ene,j,z)$DEO(ene,j,z)
                 = [PO4(ene,j,z)*DEO(ene,j,z)**(1+rho_ENER(j,z))]/
SUM[ene2$DEO(ene2,j,z),
                       PO4(ene2,j,z)*DEO(ene2,j,z)**(1+rho_ENER(j,z))];
 B_ENER(j,z)$CEO(j,z)    = CEO(j,z)/{SUM[ene$DEO(ene,j,z),beta_ENER(ene,j,z)*DEO(ene,j,z)
                   **(-rho_ENER(j,z))]**(-1/rho_ENER(j,z))};
*==============================================================================
* 4.4.3.5 Value added
*==============================================================================


 rho_VA(j,z) = 1;
 rho_VA(j,z)$(ACTIVE_J(j,z)) = (1-sigma_VA(j,z))/sigma_VA(j,z);
 beta_VA(j,z)$KDCO(j,z)
                 = WCO(j,z)*LDCO(j,z)**(rho_VA(j,z)+1)/
                  {WCO(j,z)*LDCO(j,z)**(rho_VA(j,z)+1)+
                   RCO(j,z)*KDCO(j,z)**(rho_VA(j,z)+1)};
 B_VA(j,z)$KDCO(j,z)
                 = VAO(j,z)
                   /{[[beta_VA(j,z)*LDCO(j,z)**(-rho_VA(j,z))]$LDCO(j,z)+
                   [(1-beta_VA(j,z))*KDCO(j,z)**(-rho_VA(j,z))]$KDCO(j,z)
                   ]**(-1/rho_VA(j,z))};
*==============================================================================
* Composite KLE
*==============================================================================
 KLEO(j,z)       = CEO(j,z) + VAO(j,z) ;

 PKLEO(j,z) = 1;
 PKLEO(j,z)$(ACTIVE_J(j,z) and KLEO(j,z)>0) = [PCEO(j,z)*CEO(j,z)+PVAO(j,z)*VAO(j,z)]/KLEO(j,z);

 rho_KLE(j,z) = 1;
 rho_KLE(j,z)$(ACTIVE_J(j,z) and J2(j)) = (1-sigma_KLE(j,z))/sigma_KLE(j,z);
 beta_KLE(j,z)$(ACTIVE_J(j,z) and J2(j) and KLEO(j,z)>0)
                 = PVAO(j,z)*VAO(j,z)**(rho_KLE(j,z)+1)/
                  {PVAO(j,z)*VAO(j,z)**(rho_KLE(j,z)+1)+
                   PCEO(j,z)*CEO(j,z)**(rho_KLE(j,z)+1)};
 B_KLE(j,z)$(ACTIVE_J(j,z) and J2(j) and KLEO(j,z)>0)
                 = KLEO(j,z)
                   /{[[beta_KLE(j,z)*VAO(j,z)**(-rho_KLE(j,z))]$VAO(j,z)+
                   [(1-beta_KLE(j,z))*CEO(j,z)**(-rho_KLE(j,z))]$CEO(j,z)
                   ]**(-1/rho_KLE(j,z))};
*==============================================================================
* 4.4.4 Calibration of LES parameters
*==============================================================================
 sigma_Y(i,z)    = sigma_Y(i,z)/{SUM[ij,sigma_Y(ij,z)*PCO(ij,z)*CO(ij,z)]
                   /CTHO(z)};
* Existing LES electricity-income-elasticity adjustment retained.
* eps_target is a calibration input, not an exact own-price elasticity.
* Existing application to all regions is retained.
SCALAR eps_target / 0.25 /;
 sigma_Y('18_ELEC',z) = eps_target*ABS(frisch(z));
 gamma_LES(i,z)  = PCO(i,z)*CO(i,z)*sigma_Y(i,z)/CTHO(z);
*--- 한계예산몫 합: 1 (전력 외 재화로 잔차 배분)
 gamma_LES(i,z)$(NOT IELEC(i))
     = gamma_LES(i,z)*[1-SUM(ii$IELEC(ii), gamma_LES(ii,z))]
       /SUM(ii$(NOT IELEC(ii)), gamma_LES(ii,z));
 CMINO(i,z)      = CO(i,z)+gamma_LES(i,z)*CTHO(z)/{PCO(i,z)*frisch(z)};
*==============================================================================
* 4.5 Calibration of gross domestic products
*==============================================================================
 GDP_BPO(z)      = SUM[j,PVAO(j,z)*VAO(j,z)]+TIPTO(z);
 GDP_MPO(z)      = GDP_BPO(z)+TPRCTSO(z);
 GDP_IBO(z)      = SUM[(l,j),WO(l,z)*LDO(l,j,z)]+SUM[(k,j),RO(k,j,z)*KDO(k,j,z)]
                   +TPRODNO(z)+TPRCTSO(z);
 GDP_FDO(z)      = SUM[i,PCO(i,z)*(CO(i,z)+CGO(i,z)+INVO(i,z))]
                  +eO(z)*SUM[(i,zj),PWXO(i,z,zj)*EXO(i,z,zj)]
                  +eO(z)*SUM[i,PWMGO(i)*MRGNO(i,z)]
                  -eO(z)*SUM[(i,zj),IMO(i,zj,z)*(PWMO(i,zj,z)
                  +SUM{ij,PWMGO(ij)*tmrg(ij,i,zj,z)})];
 GDP_BP_WO       = SUM[z,GDP_BPO(z)/eO(z)];
*==============================================================================
* 4.6 Calibration of real (volume) variables computed from price indices
*==============================================================================
 CABXO(z)        = CABO(z)/[PIXGDP_WO*eO(z)];
 CTH_REALO(z)    = CTHO(z)/PIXCONO(z);
 G_REALO(z)      = GO(z)/PIXGVTO(z);
 GDP_BP_REALO(z) = GDP_BPO(z)/PIXGDPO(z);
 GDP_BP_W_REALO  = GDP_BP_WO/PIXGDP_WO;
 GDP_MP_REALO(z) = GDP_MPO(z)/PIXCONO(z);
 IT_REALO(z)     = ITO(z)/PIXINVO(z);
*==============================================================================
* 4.7 Parameters of the household savings function
*==============================================================================
 sh1O(z)         = [SHO(z)+SGO(z)]/GDP_IBO(z);
 sh0O(z)         = SHO(z)-sh1O(z)*YDHO(z);
*==============================================================================
* 4.8 Calibration of indexed transfers and parameters
*==============================================================================
 ttdh0O(z)       = ttdh0O(z)/PIXCONO(z)**eta;
 sh0O(z)         = sh0O(z)/PIXCONO(z)**eta;
*==============================================================================
* 4.10 Energy
*==============================================================================
Parameter
EEI(product,j,z)  Energy intensity by industry sector ktoe per 10 billion $
 NEI(product,j,z)  Non-Energy intensity by production sectos ktoe per 10 billion $
 EHI(product,z)    Energy intensity by household ktoe per 10 billion $
 EEO(product,j,z)  Initial Industry energy consumption in region z ktoe
 NEO(product,j,z)  Initial Industry non energy consumption in region z ktoe
 EHO(product,z)    Initial Household energy consumption in region z ktoe
;
 EEI(p_coal,j,z)$(DEO('02_COAL',j,z) gt 0)               = Coal_DIO(p_coal,j,z)/DEO('02_COAL',j,z);
 EEI(p_oil,j,z)$(DEO('03_OIL',j,z) gt 0)                 = Oil_DIO(p_oil,j,z)/DEO('03_OIL',j,z);
 EEI(p_gas,j,z)$(DEO('04_GAS',j,z) gt 0)                 = Gas_DIO(p_gas,j,z)/DEO('04_GAS',j,z);
 EEI(p_oilproduct,j,z)$(DEO('10_PETROLCOAL',j,z) gt 0)   = Oilp_DIO(p_oilproduct,j,z)/DEO('10_PETROLCOAL',j,z);
 EEI(p_elecheat,j,z)$(DEO('18_ELEC',j,z) gt 0)           = Elec_DIO(p_elecheat,j,z)/DEO('18_ELEC',j,z);
 NEI(p_coal,j,z)$(DEO('02_COAL',j,z) gt 0)               = NCoal_DIO(p_coal,j,z)/DEO('02_COAL',j,z);
 NEI(p_oil,j,z)$(DEO('03_OIL',j,z) gt 0)                 = NOil_DIO(p_oil,j,z)/DEO('03_OIL',j,z);
 NEI(p_gas,j,z)$(DEO('04_GAS',j,z) gt 0)                 = NGas_DIO(p_gas,j,z)/DEO('04_GAS',j,z);
 NEI(p_oilproduct,j,z)$(DEO('10_PETROLCOAL',j,z) gt 0)   = NOilp_DIO(p_oilproduct,j,z)/DEO('10_PETROLCOAL',j,z);
 EHI(p_coal,z)$(CO('02_COAL',z) gt 0)                    = Coal_CO(p_coal,z)/CO('02_COAL',z);
 EHI(p_oil,z)$(CO('03_OIL',z) gt 0)                      = Oil_CO(p_oil,z)/CO('03_OIL',z);
 EHI(p_gas,z)$(CO('04_GAS',z) gt 0)                      = Gas_CO(p_gas,z)/CO('04_GAS',z);
 EHI(p_oilproduct,z)$(CO('10_PETROLCOAL',z) gt 0)        = Oilp_CO(p_oilproduct,z)/CO('10_PETROLCOAL',z);
 EHI(p_elecheat,z)$(CO('18_ELEC',z) gt 0)                = Elec_CO(p_elecheat,z)/CO('18_ELEC',z);
 EEO(p_coal,j,z)       = Coal_DIO(p_coal,j,z) ;
 EEO(p_gas,j,z)        = Gas_DIO(p_gas,j,z) ;
 EEO(p_oil,j,z)        = Oil_DIO(p_oil,j,z) ;
 EEO(p_oilproduct,j,z) = Oilp_DIO(p_oilproduct,j,z) ;
 EEO(p_elecheat,j,z)   = Elec_DIO(p_elecheat,j,z) ;
 NEO(p_coal,j,z)       = NCoal_DIO(p_coal,j,z) ;
 NEO(p_gas,j,z)        = NGas_DIO(p_gas,j,z) ;
 NEO(p_oilproduct,j,z) = NOilp_DIO(p_oilproduct,j,z) ;
 EHO(p_coal,z)         = Coal_CO(p_coal,z) ;
 EHO(p_gas,z)          = Gas_CO(p_gas,z) ;
 EHO(p_oil,z)          = Oil_CO(p_oil,z) ;
 EHO(p_oilproduct,z)   = Oilp_CO(p_oilproduct,z) ;
 EHO(p_elecheat,z)     = Elec_CO(p_elecheat,z) ;
*==============================================================================
* 4.11 CO2FACTOR and CTAX
*==============================================================================
Parameters
CO2FACTOR(ene,j,z)     CO2 emissions factor (tCO2 per 100$)
 CTAX0(z)               initial Carbon tax 100$ per ton CO2
 TCTAX0(z)              initial Government Revenue from Carbon tax
;
 CO2FACTOR(ene,j,z) = 0 ;
 CO2FACTOR('02_COAL',j,z)$DEO('02_COAL',j,z) = [sum(p_coal,CO2IO(p_coal,j,z))/DEO('02_COAL',j,z)]*(1000/(10**8));
 CO2FACTOR('04_GAS',j,z)$DEO('04_GAS',j,z) = [sum(p_gas,CO2IO(p_gas,j,z))/DEO('04_GAS',j,z)]*(1000/(10**8));
 CO2FACTOR('10_PETROLCOAL',j,z)$DEO('10_PETROLCOAL',j,z) = [sum(p_oilproduct,CO2IO(p_oilproduct,j,z))/DEO('10_PETROLCOAL',j,z)]*(1000/(10**8));
 CO2FACTOR('10_PETROLCOAL','10_PETROLCOAL',z) = 0;
 CTAX0(z) = 0;
 TCTAX0(z) = 0;
 TCBAMO(z3) = sum((i,zj), CP0(zj)*CO2IDFACTOR(i,zj)*IMO(i,zj,z3)*PWMO(i,zj,z3));
*--- [refactor] 지분 정규화 오류 수정: sum(jj,XSTO(j,z)) 는 제어인덱스 jj 를 쓰지 않아
*    card(j)*XSTO(j,z) 가 되었음. 보조 대상집합(eNFs) 내부 금액지분으로 재정의.
 ttip_shareO(j,z)$(eNFs(j) and sum(jj$eNFs(jj), XSTO(jj,z)*PPO(jj,z)))
                  = XSTO(j,z)*PPO(j,z)/sum(jj$eNFs(jj), XSTO(jj,z)*PPO(jj,z));
 deltattipO(j,z)$(XSTO(j,z)*PPO(j,z))
                  = -ttip_shareO(j,z)*TCBAMO(z)/(XSTO(j,z)*PPO(j,z));
*--- [refactor] 위와 동일한 지분 오류 + 연산자 우선순위 오류 수정
*    (원본: /WO*LDO -> (rev/W)*LD 로 계산되어 차원 불일치)
 ttiw_shareO(l,j,z)$(J11(j) and SUM[(lj,jj)$J11(jj), WO(lj,z)*LDO(lj,jj,z)])
                  = WO(l,z)*LDO(l,j,z)/SUM[(lj,jj)$J11(jj), WO(lj,z)*LDO(lj,jj,z)];
 deltattiwO(l,j,z)$(WO(l,z)*LDO(l,j,z))
                  = -ttiw_shareO(l,j,z)*TCBAMO(z)/(WO(l,z)*LDO(l,j,z));
* ============================================================================
* Residential TOU calibration [T1-T7]
* Command-line overrides, e.g. --TOU_SIGMA_PO=0.15 --TOU_SIGMA_UP=0.15
* give flat CES sensitivity. Default upper zero is the main specification.
$if not set TOU_SIGMA_PO $setglobal TOU_SIGMA_PO 0.15
$if not set TOU_SIGMA_UP $setglobal TOU_SIGMA_UP 0
$if not set TOU_COST_SCALE $setglobal TOU_COST_SCALE 1
* Set TOU_COST_SCALE=0 to disable the unverified supply-cost channel [T5].
theta_B(b,z) = 1/card(b);
* [T3] Legacy A7-based calibration retained pending survey aggregation audit.
theta_B('mid','01_KOR') = 0.2650;
theta_B('peak','01_KOR') = 0.4600;
theta_B('off','01_KOR') = 0.2750;
abort$(smin((b,z),theta_B(b,z)) <= 0) "TOU shares must be positive";
abort$(smax(z,abs(sum(b,theta_B(b,z))-1)) > 1e-8) "TOU shares must sum to one";
theta_MID(z) = sum(BM,theta_B(BM,z));
theta_S(z) = sum(BS,theta_B(BS,z));
theta_BS(b,z) = 0;
theta_BS(BS,z) = theta_B(BS,z)/theta_S(z);
* [T2,T4] Zero elasticities outside policy region; no survey estimation.
sigma_ToU1(z) = 0;
sigma_ToU2(z) = 0;
sigma_ToU1(ZE2) = %TOU_SIGMA_PO%;
sigma_ToU2(ZE2) = %TOU_SIGMA_UP%;
abort$(smin(z,min(sigma_ToU1(z),sigma_ToU2(z))) < 0) "Negative CES elasticity";
* [T5] Inherited coefficients; weighted centering preserves benchmark LSF.
delta_b(b,z) = 0;
delta_b('mid','01_KOR') = 0.06;
delta_b('peak','01_KOR') = 0.07;
delta_b('off','01_KOR') = -0.12;
parameter delta_mean(z);
delta_mean(z) = sum(b,theta_B(b,z)*delta_b(b,z));
delta_b(b,z) = %TOU_COST_SCALE%*(delta_b(b,z)-delta_mean(z));
LSFO(z) = 1;
* [T6] Basic TOU does not impose ex-post revenue neutrality.
tth0(i,z) = 0;
tth_B0(b,z) = 0;
tth_B_raw(b,z) = 0;
e2_expost(z) = 0;
* [T1] Equal benchmark block prices make quantity and expenditure shares equal.
PC_HHO(i,z) = PCO(i,z);
PC_HBO(b,z) = PCO('18_ELEC',z);
PC_HSO(z) = PCO('18_ELEC',z);
C_BO(b,z) = theta_B(b,z)*CO('18_ELEC',z);
C_SO(z) = theta_S(z)*CO('18_ELEC',z);
CE_PHYSO(z) = sum(b,C_BO(b,z));
abort$(smin(z,PCO('18_ELEC',z)) <= 0) "Nonpositive benchmark electricity price";
abort$(smin(z,XSO_I('18_ELEC',z)) <= 0) "Nonpositive electricity output denominator";
* [T7] CE_PHYS is in model quantity units, not kWh; EHI_ELEC converts to ktoe.
EHI_ELEC(z) = sum(p_elec,EHI(p_elec,z));
PKWH_O(z) = 0;
PKWH_O(z)$EHI_ELEC(z) = PCO('18_ELEC',z)/EHI_ELEC(z);
* PKWH_O is model monetary units per ktoe, despite the inherited symbol name.
