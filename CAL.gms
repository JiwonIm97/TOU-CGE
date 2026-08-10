* ==============================================================================
* CAL.gms
* 벤치마크 보정: 소득·세율·CES/CET/LES·CO2 (원본 L532-1061)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================

* 4.1 Calculation of income and savings related variables and parameters
*==============================================================================
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
 LDCO('01_AGRICULT','01_KOR')       = 1.629;
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
 PTO(j,z)        = SUM[i$XSO(j,i,z),PO2(j,i,z)*XSO(j,i,z)]/XSTO(j,z);

 PPO(j,z)        = [SUM[l,TIWO(l,j,z)+WO(l,z)*LDO(l,j,z)]
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
$INCLUDE Input_WEB\Static_DATA_WEB_2017.gms

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

 PCIO(j,z)       = SUM[nene,PCO(nene,z)*DIO(nene,j,z)]/CIO(j,z);
 PCEO(j,z)       = SUM[ene,PCO(ene,z)*DEO(ene,j,z)]/CEO(j,z) ; 

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

 PVAO(j,z)       = [WCO(j,z)*LDCO(j,z)+RCO(j,z)*KDCO(j,z)]/VAO(j,z);

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
 io(j,z)         = CIO(j,z)/XSTO(j,z) ;
 io2(j,z)        = CEO(j,z)/XSTO(j,z) ;
 v(j,z)          = VAO(j,z)/XSTO(j,z) ;
 v2(j,z)         = (CEO(j,z)+VAO(j,z))/XSTO(j,z) ;
 aij(nene,j,z)   = DIO(nene,j,z)/CIO(j,z);
 aij2(ene,j,z)   = DEO(ene,j,z)/CEO(j,z);

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

 POWERQO(Z) = SUM(POWER, XSO(power,'18_ELEC',z));

 sigma_X4(z) = 2;

 rho_X4(z)   = (1-sigma_X4(z))/sigma_X4(z);

 beta_X4(power,z)
               = [PO2(power,'18_ELEC',z)*XSO(power,'18_ELEC',z)**(1+rho_X4(z))]/
                   SUM[power2$XSO(power2,'18_ELEC',z),PO2(power2,'18_ELEC',z)*XSO(power2,'18_ELEC',z)**(1+rho_X4(z))];

 B_X4(z)     = POWERQO(Z)
                  /SUM[power2$XSO(power2,'18_ELEC',z),beta_X4(power2,z)*XSO(power2,'18_ELEC',z)**(-rho_X4(z))
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
 rho_KD(j,z)     = (1-sigma_KD(j,z))/sigma_KD(j,z);

 beta_KD(k,j,z)$KDO(k,j,z)
                 = [RTIO(k,j,z)*KDO(k,j,z)**(1+rho_KD(j,z))]/
                   SUM[kj$KDO(kj,j,z),RTIO(kj,j,z)*KDO(kj,j,z)**(1+rho_KD(j,z))];
                   
 B_KD(j,z)$KDCO(j,z)
                 = KDCO(j,z)/{SUM[k$KDO(k,j,z),beta_KD(k,j,z)*KDO(k,j,z)
                   **(-rho_KD(j,z))]**(-1/rho_KD(j,z))};

*==============================================================================
* 4.4.3.4 Composite labor
*==============================================================================
 rho_LD(j,z)     = (1-sigma_LD(j,z))/sigma_LD(j,z);
 
 beta_LD(l,j,z)$LDO(l,j,z)  = [WTIO(l,j,z)*LDO(l,j,z)**(1+rho_LD(j,z))]/
                  SUM[lj$LDO(lj,j,z),WTIO(lj,j,z)*LDO(lj,j,z)
                   **(1+rho_LD(j,z))];
 B_LD(j,z)$LDCO(j,z)
                 = LDCO(j,z)/{SUM[l$LDO(l,j,z),beta_LD(l,j,z)*LDO(l,j,z)
                   **(-rho_LD(j,z))]**(-1/rho_LD(j,z))};

*===============================================================================
* Composite E
*===============================================================================
 rho_ENER(j,z)   = (1-sigma_ENER(j,z))/sigma_ENER(j,z);

 beta_ENER(ene,j,z)$DEO(ene,j,z)
                 = [PO4(ene,j,z)*DEO(ene,j,z)**(1+rho_ENER(j,z))]/
                   SUM[ene2$DIO(ene,j,z),DEO(ene2,j,z)**(1+rho_ENER(j,z))];

 B_ENER(j,z)$CEO(j,z)    = CEO(j,z)/{SUM[ene$DEO(ene,j,z),beta_ENER(ene,j,z)*DEO(ene,j,z)
                   **(-rho_ENER(j,z))]**(-1/rho_ENER(j,z))};

*==============================================================================
* 4.4.3.5 Value added
*==============================================================================
 sigma_VA('10_PETROLCOAL',z) = 1.260;
 rho_VA(j,z)     = (1-sigma_VA(j,z))/sigma_VA(j,z);

 beta_VA(j,z)$KDCO(j,z)
                 = WCO(j,z)*LDCO(j,z)**(rho_VA(j,z)+1)/
                  {WCO(j,z)*LDCO(j,z)**(rho_VA(j,z)+1)+
                   RCO(j,z)*KDCO(j,z)**(rho_VA(j,z)+1)};

 B_VA(j,z)$KDCO(j,z)
                 = VAO(j,z)
                   /{[beta_VA(j,z)*LDCO(j,z)**(-rho_VA(j,z))+
                   (1-beta_VA(j,z))*KDCO(j,z)**(-rho_VA(j,z))
                   ]**(-1/rho_VA(j,z))};

*==============================================================================
* Composite KLE
*==============================================================================
 KLEO(j,z)       = CEO(j,z) + VAO(j,z) ; 
 PKLEO(j,z)      = [PCEO(j,z)*CEO(j,z)+PVAO(j,z)*VAO(j,z)]/KLEO(j,z);
 rho_KLE(j,z)    = (1-sigma_KLE(j,z))/sigma_KLE(j,z);

 beta_KLE(j,z)$KLEO(j,z)
                 = PVAO(j,z)*VAO(j,z)**(rho_KLE(j,z)+1)/
                  {PVAO(j,z)*VAO(j,z)**(rho_KLE(j,z)+1)+
                   PCEO(j,z)*CEO(j,z)**(rho_KLE(j,z)+1)};
 B_KLE(j,z)$KLEO(j,z)
                 = KLEO(j,z)
                   /{[beta_KLE(j,z)*VAO(j,z)**(-rho_KLE(j,z))+
                   (1-beta_KLE(j,z))*CEO(j,z)**(-rho_KLE(j,z))
                   ]**(-1/rho_KLE(j,z))};

*==============================================================================
* 4.4.4 Calibration of LES parameters
*==============================================================================
 sigma_Y(i,z)    = sigma_Y(i,z)/{SUM[ij,sigma_Y(ij,z)*PCO(ij,z)*CO(ij,z)]
                   /CTHO(z)};
*--- [E2] 전력 sigma_Y 재보정
*    GTAP11 값 0.987 은 석탄·가스·건설과 동일한 잔차 자리표시값.
*    탄력성 0.987/(-1.3) = -0.76 으로 한국 문헌(-0.16~-0.38) 대비 과대. 0.325로 보정
SCALAR eps_target / 0.25 /;

 sigma_Y('18_ELEC',z) = eps_target*ABS(frisch(z));
 gamma_LES(i,z)  = PCO(i,z)*CO(i,z)*sigma_Y(i,z)/CTHO(z);
*--- 한계예산몫 합: 1 (전력 외 재화로 잔차 배분)
 gamma_LES(i,z)$(NOT IELEC(i))
     = gamma_LES(i,z)*[1-SUM(ii$IELEC(ii), gamma_LES(ii,z))]
       /SUM(ii$(NOT IELEC(ii)), gamma_LES(ii,z));

 ABORT$(SMAX(z, ABS(SUM(i,gamma_LES(i,z))-1)) > 1e-8)
     "gamma_LES must sum to 1", gamma_LES;

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


* ==============================================================================
* E2_CAL.gms  -- Essay 2 블록 구조 보정
* ------------------------------------------------------------------------------
* 설계 원칙
*  - 벤치마크에서 tth = tth_B = 0  ->  PC_HH = PC, C_B = theta_B*C, CE_PHYS = C
*    따라서 GTAP 벤치마크를 재보정 없이 그대로 재현.
*  - IBR 요금 수준은 이미 GTAP 구매자가격 안에 있으므로 별도 부과하지 않음.
*    ToU 전환은 블록별 wedge 편차 tth_B 로만 구현.
* ==============================================================================

*==============================================================================
* 1. 블록 비중 theta_B
*==============================================================================
* 기본값: 균등 (ToU 미적용 지역은 어떤 값이든 결과에 영향 없음)
 theta_B(b,z) = 1/card(b);

* --- KEPCO 설문 A7 (시간대별 소비 비중)--------------------
 theta_B('mid' ,'01_KOR') = 0.2628;
 theta_B('peak','01_KOR') = 0.4631;
 theta_B('off' ,'01_KOR') = 0.2741;
 ABORT$(SMAX(z, ABS(SUM(b,theta_B(b,z))-1)) > 1e-8)
     "theta_B must sum to 1", theta_B;

*==============================================================================
* 2. 시간대 간 대체탄력성 sigma_ToU
*==============================================================================
*--- nest 
 theta_MID(z)   = SUM(BM, theta_B(BM,z));
 theta_S(z)     = SUM(BS, theta_B(BS,z));
 theta_BS(BS,z) = theta_B(BS,z)/theta_S(z);

 ABORT$(SMIN(z, theta_S(z)) < 1e-6)
     "theta_S is zero: lower nest is empty", theta_S;
 ABORT$(SMAX(z, ABS(SUM(BS,theta_BS(BS,z))-1)) > 1e-8)
     "theta_BS must sum to 1 within the lower nest", theta_BS;

*--- 대체탄력성
*    sigma_ToU1 : peak vs off. Faruqui-Sergici 계열 TOU 실험 CES 추정치.
*                 보조기술 없는 주택용 기준. 민감도 0.05 / 0.15 / 0.30
*    sigma_ToU2 : mid vs 나머지. A8 에서 mid 무반응 -> 0 (Leontief)
 sigma_ToU1(z) = 0;
 sigma_ToU2(z) = 0;
 sigma_ToU1('01_KOR') = 0.15;
* sigma_ToU1('01_KOR') = 0.5;
 
 ABORT$(SMIN(z, ABS(sigma_ToU1(z)-1)) < 1e-6)
     "sigma_ToU1 = 1 is a Cobb-Douglas singularity: use 0.999 or 1.001";
 ABORT$(SMIN(z, ABS(sigma_ToU2(z)-1)) < 1e-6)
     "sigma_ToU2 = 1 is a Cobb-Douglas singularity";
*------------------------------------------------------------------------------
* 3. 시간대별 공급 한계비용 프리미엄 delta_b
*    출처 : EPSIS 시간별SMP(육지) / 가중평균SMP, 2025년 365일 평균
*    원자료는 계통부하 가중평균을 분모로 하므로 계통 부하형상 중심.
*    가계 부하형상(theta_B)은 계통보다 첨두 편중이 강하므로 재정규화 필요.
*------------------------------------------------------------------------------
 delta_b(b,z) = 0;
 delta_b('mid' ,'01_KOR') =  0.06;
 delta_b('peak','01_KOR') =  0.07;
 delta_b('off' ,'01_KOR') = -0.12;

*--- 계통부하 중심 -> 가계부하 중심. 벤치마크에서 E2_RESCOST = 0 이 되도록.
 delta_b(b,z) = delta_b(b,z) - SUM(bb, theta_B(bb,z)*delta_b(bb,z));

 ABORT$(SMAX(z, ABS(SUM(b, theta_B(b,z)*delta_b(b,z)))) > 1e-8)
     "delta_b must be mean-zero at benchmark quantities", delta_b;
 
 LSFO(z) = 1;

 display delta_b;



*--- 벤치마크 : 모든 블록 가격이 동일하므로 두 둥지 모두 항등적으로 붕괴
 PC_HBO(b,z) = PCO('18_ELEC',z);
 PC_HSO(z)   = PCO('18_ELEC',z);
 PC_HHO(i,z) = PCO(i,z);
 C_SO(z)     = theta_S(z)*CO('18_ELEC',z);
 C_BO(b,z)   = theta_B(b,z)*CO('18_ELEC',z);
 CE_PHYSO(z) = CO('18_ELEC',z);
*==============================================================================
* 3. 벤치마크 값
*==============================================================================
 tth0(i,z)       = 0;
 tth_B0(b,z)     = 0;
 tth_B_raw(b,z)  = 0;
 e2_expost(z)    = 0;

 PC_HHO(i,z)    = PCO(i,z);
 PC_HBO(b,z)    = PCO('18_ELEC',z);
 C_BO(b,z)      = theta_B(b,z)*CO('18_ELEC',z);
 CE_PHYSO(z)    = CO('18_ELEC',z);

*==============================================================================
* 4. 물리량 환산 (IEA WEB 기반)
*==============================================================================
* EHI(p_elec,z) 는 CAL.gms 에서 이미 계산됨: ktoe per unit of CGE value
 EHI_ELEC(z)               = SUM(p_elec, EHI(p_elec,z));
 PKWH_O(z)$EHI_ELEC(z)     = PCO('18_ELEC',z)/EHI_ELEC(z);

* PKWH_O(z) 는 벤치마크 가계 전력가격을 "모형단위 / ktoe" 로 표현한 값.
* 한국 요금표(원/kWh)를 tth_B 로 환산할 때의 앵커로 사용.
*   1 ktoe = 11 630 MWh = 11 630 000 kWh
* display theta_B, sigma_ToU, EHI_ELEC, PKWH_O;



execute_unload 'Calibration';
