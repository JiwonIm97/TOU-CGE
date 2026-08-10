* ==============================================================================
* CGE_Results.gms
* sim 루프 내부 결과 적재 (원본 L2193-2350)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================

*==============================================================================
* Reporting
*==============================================================================
 valgamma_LES(i,z,sim)          = gamma_LES(i,z);
* valTCBAM(z,sim)                = TCBAM.l(z);
 valGDP_BP(z,sim)               = GDP_BP.l(z);
 valGDP_BP_REAL(z,sim)          = GDP_BP_REAL.l(z);
 valPIXGDP(z,sim)               = PIXGDP.l(z);
 valCTAX(z,sim)                 = CTAX.L(z);
* valCP(z,sim)                   = CP.L(z);
 valTCTAX(z,sim)                = TCTAX.L(z);
 valSH(z,sim)                   = SH.l(z);
 valKLE(j,z,sim)                = KLE.l(j,z);
 valPC(i,z,sim)                 = PC.l(i,z);
 valPOWER(power,i,z,sim)        = XS.L(power,i,z);
 valC(i,z,sim)                  = C.l(i,z);
 valCAB(z,sim)                  = CAB.l(z);
 valCABX(z,sim)                 = CABX.l(z);
 valCG(i,z,sim)                 = CG.l(i,z);
 valCI(j,z,sim)                 = CI.l(j,z);
 valCE(j,z,sim)                 = CE.l(j,z);
 valCMIN(i,z,sim)               = CMIN.l(i,z);
 valCTH(z,sim)                  = CTH.l(z);
 valCTH_REAL(z,sim)             = CTH_REAL.l(z);
 valDD(i,z,sim)                 = DD.l(i,z);
 valDEP(z,sim)                  = DEP.l(z);
 valDI(nene,j,z,sim)            = DI.l(nene,j,z);
 valDE(ene,j,z,sim)             = DE.l(ene,j,z);
 valDIT(i,z,sim)                = DIT.l(i,z);
 valDS(j,i,z,sim)               = DS.l(j,i,z);
 valDS_I(i,z,sim)               = DS_I.l(i,z);
 vale(z,sim)                    = e.l(z);
 valEX(i,z,zj,sim)              = EX.l(i,z,zj);
 valEXT(i,z,sim)                = EXT.l(i,z);
 valG(z,sim)                    = G.l(z);
 valG_REAL(z,sim)               = G_REAL.l(z);
 valGDP_BP(z,sim)               = GDP_BP.l(z);
 valGDP_BP_REAL(z,sim)          = GDP_BP_REAL.l(z);
 valGDP_BP_W(sim)               = GDP_BP_W.l;
 valGDP_BP_W_REAL(sim)          = GDP_BP_W_REAL.l;
 valGDP_FD(z,sim)               = GDP_FD.l(z);
 valGDP_IB(z,sim)               = GDP_IB.l(z);
 valGDP_MP(z,sim)               = GDP_MP.l(z);
 valGDP_MP_REAL(z,sim)          = GDP_MP_REAL.l(z);
 valIM(i,zj,z,sim)              = IM.l(i,zj,z);
 valIMT(i,z,sim)                = IMT.l(i,z);
 valINV(i,z,sim)                = INV.l(i,z);
 valIT(z,sim)                   = IT.l(z);
 valIT_REAL(z,sim)              = IT_REAL.l(z);
 valKD(k,j,z,sim)               = KD.l(k,j,z);
 valKDC(j,z,sim)                = KDC.l(j,z);
 valKS(k,z,sim)                 = KS.l(k,z);
 valLD(l,j,z,sim)               = LD.l(l,j,z);
 valLDC(j,z,sim)                = LDC.l(j,z);
 valLS(l,z,sim)                 = LS.l(l,z);
 valMRGN(i,z,sim)               = MRGN.l(i,z);
 valP(i,z,sim)                  = P.l(i,z);
 valPT(j,z,sim)                 = PT.l(j,z);
 valP2(j,i,z,sim)               = P2.l(j,i,z);
 valP4(ene,j,z,sim)             = P4.l(ene,j,z);
 valPC(i,z,sim)                 = PC.l(i,z);
 valPCI(j,z,sim)                = PCI.l(j,z);
 valPCE(j,z,sim)                = PCE.l(j,z);
 valPD(i,z,sim)                 = PD.l(i,z);
 valPE(i,z,zj,sim)              = PE.l(i,z,zj);
 valPET(i,z,sim)                = PET.l(i,z);
 valPIXCON(z,sim)               = PIXCON.l(z);
 valPIXGDP(z,sim)               = PIXGDP.l(z);
 valPIXGDP_W(sim)               = PIXGDP_W.l;
 valPIXGVT(z,sim)               = PIXGVT.l(z);
 valPIXINV(z,sim)               = PIXINV.l(z);
 valPK(z,sim)                   = PK.l(z);
 valPL(i,z,sim)                 = PL.l(i,z);
 valPM(i,zj,z,sim)              = PM.l(i,zj,z);
 valPMT(i,z,sim)                = PMT.l(i,z);
 valPP(j,z,sim)                 = PP.l(j,z);
 valPVA(j,z,sim)                = PVA.l(j,z);
 valPKLE(j,z,sim)               = PKLE.l(j,z);
 valPWM(i,zj,z,sim)             = PWM.l(i,zj,z);
 valPWMG(i,sim)                 = PWMG.l(i);
 valPWX(i,z,zj,sim)             = PWX.l(i,z,zj);
 valQ(i,z,sim)                  = Q.l(i,z);
 valR(k,j,z,sim)                = R.l(k,j,z);
 valRC(j,z,sim)                 = RC.l(j,z);
 valRK(k,z,sim)                 = RK.l(k,z);
 valRTI(k,j,z,sim)              = RTI.l(k,j,z);
 valSG(z,sim)                   = SG.l(z);
 valSH(z,sim)                   = SH.l(z);
 valsh0(z,sim)                  = sh0.l(z);
 valsh1(z,sim)                  = sh1.l(z);
 valSROW(z,sim)                 = SROW.l(z);
 valTCTAX(z,sim)                = TCTAX.l(z);
 valTDH(z,sim)                  = TDH.l(z);
 valTIC(i,z,sim)                = TIC.l(i,z);
 valTICT(z,sim)                 = TICT.l(z);
 valTIK(k,j,z,sim)              = TIK.l(k,j,z);
 valTIKT(z,sim)                 = TIKT.l(z);
 valTIM(i,zj,z,sim)             = TIM.l(i,zj,z);
 valTIMT(z,sim)                 = TIMT.l(z);
 valTIP(j,z,sim)                = TIP.l(j,z);
 valTIPT(z,sim)                 = TIPT.l(z);
 valTIW(l,j,z,sim)              = TIW.l(l,j,z);
 valTIWT(z,sim)                 = TIWT.l(z);
 valTIX(i,z,zj,sim)             = TIX.l(i,z,zj);
 valTIXT(z,sim)                 = TIXT.l(z);
 valTPRCTS(z,sim)               = TPRCTS.l(z);
 valTPRODN(z,sim)               = TPRODN.l(z);
 valttdh0(z,sim)                = ttdh0.l(z);
 valttdh1(z,sim)                = ttdh1.l(z);
 valttic(i,z,sim)               = ttic.l(i,z);
 valttik(k,j,z,sim)             = ttik.l(k,j,z);
 valttim(i,zj,z,sim)            = ttim.l(i,zj,z);
 valttip(j,z,sim)               = ttip.l(j,z);
 valttiw(l,j,z,sim)             = ttiw.l(l,j,z);
 valttix(i,z,zj,sim)            = ttix.l(i,z,zj);
 valVA(j,z,sim)                 = VA.l(j,z);
 valKLE(j,z,sim)                = KLE.l(j,z);
 valW(l,z,sim)                  = W.l(l,z);
 valWC(j,z,sim)                 = WC.l(j,z);
 valWTI(l,j,z,sim)              = WTI.l(l,j,z);
 valXS(j,i,z,sim)               = XS.l(j,i,z);
 valXS_I(i,z,sim)               = XS_I.l(i,z);
 valYDH(z,sim)                  = YDH.l(z);
 valYG(z,sim)                   = YG.l(z);
 valYH(z,sim)                   = YH.l(z);
 valYHK(z,sim)                  = YHK.l(z);
 valYHL(z,sim)                  = YHL.l(z);
 valYROW(z,sim)                 = YROW.l(z);
 valEV(z,sim)                   = (valCTH(z,sim) - sum(i, valPC(i,z,sim)*CMINO(i,z)))*exp(sum(i, gamma_LES(i,z)*(log(PCO(i,z)) - log(valPC(i,z,sim))))) - (CTHO(z) - sum(i, PCO(i,z)*valCMIN(i,z,sim)));
 valLEON(z,sim)                 = LEON.L(z);
 valEE(p_coal,j,z,sim)          = EEI(p_coal,j,z)*DE.L('02_COAL',j,z);
 valEE(p_oil,j,z,sim)           = EEI(p_oil,j,z)*DE.L('03_OIL',j,z);
 valEE(p_gas,j,z,sim)           = EEI(p_gas,j,z)*DE.L('04_GAS',j,z);
 valEE(p_oilproduct,j,z,sim)    = EEI(p_oilproduct,j,z)*DE.L('10_PETROLCOAL',j,z);
 valEE(p_elec,j,z,sim)          = EEI(p_elec,j,z)*DE.L('18_ELEC',j,z);
 valNE(p_coal,j,z,sim)          = NEI(p_coal,j,z)*DE.L('02_COAL',j,z);
 valNE(p_oil,j,z,sim)           = NEI(p_oil,j,z)*DE.L('03_OIL',j,z);
 valNE(p_gas,j,z,sim)           = NEI(p_gas,j,z)*DE.L('04_GAS',j,z);
 valNE(p_oilproduct,j,z,sim)    = NEI(p_oilproduct,j,z)*DE.L('10_PETROLCOAL',j,z);
 valNE(p_elec,j,z,sim)          = NEI(p_elec,j,z)*DE.L('18_ELEC',j,z);
 valEH(p_coal,z,sim)            = EHI(p_coal,z)*C.L('02_COAL',z);
 valEH(p_oil,z,sim)             = EHI(p_oil,z)*C.L('03_OIL',z);
 valEH(p_gas,z,sim)             = EHI(p_gas,z)*C.L('04_GAS',z); 
 valEH(p_oilproduct,z,sim)      = EHI(p_oilproduct,z)*C.L('10_PETROLCOAL',z);
* valEH(p_elec,z,sim)            = EHI(p_elec,z)*C.L('18_ELEC',z);
 valEH(p_elec,z,sim)            = EHI(p_elec,z)*CE_PHYS.L(z);
 valTFC_com(product,z,sim)      = valEH(product,z,sim) + sum(j5,valEE(product,j5,z,sim))+sum(j,valNE(product,j,z,sim));
 valTFC_ind(j,z,sim)            = sum(product,valEE(product,j,z,sim)+valNE(product,j,z,sim));   
 valTFC(z,sim)                  = sum(product, valTFC_com(product,z,sim));
 valCO2I(product,j,z,sim)       = valEE(product,j,z,sim)*41.868*GHGsEF(product,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF') ;
 valCO2NE(product,j,z,sim)      = valNE(product,j,z,sim)*41.868*GHGsEF(product,'CO2EF')*1*(44/12)*0.001*GWP('CO2EF')*(1-GHGsEF(product,'Stored_rate')) ;
 valCO2I2(j,z,sim)              = sum(product,valCO2I(product,j,z,sim));
 valCO2NE2(j,z,sim)             = sum(product,valCO2NE(product,j,z,sim));
 valTCO22(j,z,sim)              = valCO2I2(j,z,sim)+valCO2NE2(j,z,sim);
 valTCO2I(z,sim)                = sum((product,j),valCO2I(product,j,z,sim));
 valTCO2NE(z,sim)               = sum((product,j),valCO2NE(product,j,z,sim));
 valTCO2(z,sim)                 = valTCO2I(z,sim) + valTCO2NE(z,sim);
 valKOR_TFC(product,sim)        = valEH(product,'01_KOR',sim) + Sum(j5,valEE(product,j5,'01_KOR',sim))+Sum(j,valNE(product,j,'01_KOR',sim));
 
* ==============================================================================
* Results_format/E2_Results.gms
* Essay 2 결과 적재. sim 루프 내부, CGE_Results.gms 직후에 include.
* ==============================================================================

*==============================================================================
* 1. 원시 결과
*==============================================================================
 valPC_HH(i,z,sim)     = PC_HH.l(i,z);
 valPC_HB(b,z,sim)     = PC_HB.l(b,z);
 valC_B(b,z,sim)       = C_B.l(b,z);
 valCE_PHYS(z,sim)     = CE_PHYS.l(z);
 valTIC_HH(z,sim)      = TIC_HH.l(z);
 valRCY_POOL(z,sim)    = RCY_POOL.l(z);
 valtth_B(b,z,sim)     = tth_B.l(b,z);
 valtou_shift(z,sim)   = tou_shift.l(z);
*==============================================================================
* 2. 물리량 (ktoe). GWh 로 보려면 x 11.63
*==============================================================================
 E2_LOAD(b,z,sim)      = EHI_ELEC(z)*C_B.l(b,z);
 E2_LOAD_TOT(z,sim)    = EHI_ELEC(z)*CE_PHYS.l(z);

 E2_SHARE(b,z,sim)$CE_PHYS.l(z)
                       = C_B.l(b,z)/CE_PHYS.l(z);

 E2_SHIFT(b,z,sim)     = EHI_ELEC(z)*(C_B.l(b,z)-C_BO(b,z));

*==============================================================================
* 3. 진단: CES 수량지수와 물리량의 괴리
*    C - CE_PHYS <= 0. 절댓값은 동일 전력서비스를 유지하기 위해 추가로
*    소비한 물리적 전력량이며, 부하이전의 자원비용으로 해석. 벤치마크에서 0.
*==============================================================================
 E2_CESGAP(z,sim)      = C.l('18_ELEC',z) - CE_PHYS.l(z);

*==============================================================================
* 4. 가계 전기요금 지출 (구매자가격 기준)
*==============================================================================
 E2_BILL(z,sim)        = SUM(b, PC_HB.l(b,z)*C_B.l(b,z));

*==============================================================================
* 5. 후생 (Stone-Geary EV, 가계 구매자가격 기준)
*    기존 valEV 는 PC 를 쓰므로 wedge 를 반영하지 못한다. E2_EV 를 사용할 것.
*==============================================================================
 E2_EV(z,sim) =
     ( CTH.l(z) - SUM(i, PC_HH.l(i,z)*CMINO(i,z)) )
     * exp( SUM(i$gamma_LES(i,z),
              gamma_LES(i,z)*( log(PC_HHO(i,z)) - log(PC_HH.l(i,z)) )) )
   - ( CTHO(z) - SUM(i, PC_HHO(i,z)*CMINO(i,z)) );
*==============================================================================
* 5-2. 공급측 자원비용 변화
*    CGE 는 전력을 단일 가격 PC 로만 청산하므로 시간대별 비용차가 누락
*    delta_b 는 그 누락분이며, 첨두 감축이 자원을 절약하는 경로를 포착
*    부호 : 양(+)이면 부하이전으로 발전 자원비용이 절감된 것.
*==============================================================================
 E2_RESCOST(z,sim) = -SUM(b, delta_b(b,z)*PC.l('18_ELEC',z)
                              *(C_B.l(b,z)-C_BO(b,z)));
 E2_LSF(z,sim)     = LSF.l(z);
 E2_PELEC(z,sim)   = PC.l('18_ELEC',z)/PCO('18_ELEC',z) - 1;

 E2_WELF(z,sim)    = E2_EV(z,sim);

*==============================================================================
* 6. 마이크로시뮬레이션 전달 벡터
*    micro/tou_micro.py 가 이 파라미터들을 읽는다.
*==============================================================================
 E2_LINK_PB(b,z,sim)$PC_HBO(b,z)
                       = PC_HB.l(b,z)/PC_HBO(b,z) - 1;

 E2_LINK_PNE(i,z,sim)$(PCO(i,z) and (NOT IELEC(i)))
                       = PC_HH.l(i,z)/PCO(i,z) - 1;

 E2_LINK_W(l,z,sim)$WO(l,z)
                       = W.l(l,z)/WO(l,z) - 1;

 E2_LINK_R(k,z,sim)$RKO(k,z)
                       = RK.l(k,z)/RKO(k,z) - 1;

 E2_LINK_TR(z,sim)     = rcy_hh(z)*SUM(zjj, rcy_share(zjj,z)*RCY_POOL.l(zjj));

 E2_LINK_CPI(z,sim)    = PIXCON.l(z);
 
display valtth_B, tth_B_raw, res, p_TOU, p_bar, valtou_shift, E2_bill;