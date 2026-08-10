* ==============================================================================
* Init_Closure.gms
* 변수 초기값·자본이동성·클로저 (원본 L1917-2141)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================

 PC_HS.L(z) = PC_HSO(z);
 C_S.L(z)   = C_SO(z);

 PC_HS.LO(z)$PC_HSO(z) = 0.000001*PC_HSO(z);
 C_S.LO(z)$C_SO(z)     = 0.000001*C_SO(z);
 
*==============================================================================
* 6 Numerical resolution
*==============================================================================
*  6.1 Variable initialisation
*==============================================================================
*   6.1.1 Volume variables
*==============================================================================
 CABX.L(z)        = CABXO(z);
 C.L(i,z)         = CO(i,z);
 CG.L(i,z)        = CGO(i,z);
 CI.L(j,z)        = CIO(j,z);
 CE.L(j,z)        = CEO(j,z);
 CMIN.L(i,z)      = CMINO(i,z);
 CTH_REAL.L(z)    = CTH_REALO(z);
 DI.L(nene,j,z)   = DIO(nene,j,z);
 DE.L(ene,j,z)    = DEO(ene,j,z);
 DIT.L(i,z)       = DITO(i,z);
 DD.L(i,z)        = DDO(i,z);
 DS.L(j,i,z)      = DSO(j,i,z);
 DS_I.L(i,z)      = DSO_I(i,z);
 DS.L(j,i,z)      = DSO(j,i,z);
 EX.L(i,z,zj)     = EXO(i,z,zj);
 EXT.L(i,z)       = EXTO(i,z);
 EXTT.L(j,i,z)    = EXTTO(j,i,z);
 G_REAL.L(z)      = G_REALO(z);
 GDP_BP_REAL.l(z) = GDP_BP_REALO(z);
 GDP_MP_REAL.l(z) = GDP_MP_REALO(z);
 GDP_BP_W_REAL.l  = GDP_BP_W_REALO;
 IM.L(i,zj,z)     = IMO(i,zj,z);
 IMT.L(i,z)       = IMTO(i,z);
 INV.L(i,z)       = INVO(i,z);
 IT_REAL.l(z)     = IT_REALO(z);
 KD.L(k,j,z)      = KDO(k,j,z);
 KDC.L(j,z)       = KDCO(j,z);
 KS.L(k,z)        = KSO(k,z);
 LD.L(l,j,z)      = LDO(l,j,z);
 LDC.L(j,z)       = LDCO(j,z);
 LS.L(l,z)        = LSO(l,z);
 MRGN.L(i,z)      = MRGNO(i,z);
 Q.L(i,z)         = QO(i,z);
 VA.L(j,z)        = VAO(j,z);
 KLE.L(j,z)       = KLEO(j,z);
 XS.L(j,i,z)      = XSO(j,i,z);
 XS_I.L(i,z)      = XSO_I(i,z);
 XST.L(j,z)       = XSTO(j,z);
 POWERQ.L(z)      = POWERQO(z);
 EE.L(product,j,z) = EEO(product,j,z);
 NE.L(product,j,z) = NEO(product,j,z);
 EH.L(product,z)   = EHO(product,z);
 CO2I.L(product,j,z) = CO2IO(product,j,z);
 CO2H.L(product,z)   = CO2HO(product,z);

*==============================================================================
*   6.1.2 Price variables
*==============================================================================
 e.L(z)           = eO(z);
 P.L(i,z)         = PO(i,z);
 P2.L(j,i,z)      = PO2(j,i,z);
 P4.L(ene,j,z)    = PO4(ene,j,z);
 PPOWER.L(z)      = PPOWERO(z);
 PI.l(i,z)        = PO(i,z);
 PT.L(j,z)        = PTO(j,z);
 PP.L(j,z)        = PPO(j,z);
 PC.L(i,z)        = PCO(i,z);
 PCI.L(j,z)       = PCIO(j,z);
 PCE.L(j,z)       = PCEO(j,z);
 PD.L(i,z)        = PDO(i,z);
 PE.L(i,z,zj)     = PEO(i,z,zj);
 PET.L(i,z)       = PETO(i,z);
 PIXCON.L(z)      = PIXCONO(z);
 PIXGDP.L(z)      = PIXGDPO(z);
 PIXGDP_W.L       = PIXGDP_WO;
 PIXGVT.L(z)      = PIXGVTO(z);
 PIXINV.L(z)      = PIXINVO(z);
 PK.L(z)          = PKO(z);
 PL.L(i,z)        = PLO(i,z);
 PM.L(i,zj,z)     = PMO(i,zj,z);
 PMT.L(i,z)       = PMTO(i,z);
 PP.L(j,z)        = PPO(j,z);
 PVA.L(j,Z)       = PVAO(j,Z);
 PKLE.L(j,Z)      = PKLEO(j,Z);
 PWM.L(i,zj,z)    = PWMO(i,zj,z);
 PWMG.L(i)        = PWMGO(i);
 PWX.L(i,z,zj)    = PWXO(i,z,zj);
 R.L(k,j,z)       = RO(k,j,z);
 RC.L(j,z)        = RCO(j,z);
 RK.L(k,z)        = RKO(k,z);
 RTI.L(k,j,z)     = RTIO(k,j,z);
 W.L(l,z)         = WO(l,z);
 WC.L(j,z)        = WCO(j,z);
 WTI.L(l,j,z)     = WTIO(l,j,z);

*==============================================================================
*   6.1.3 Nominal (value) variables
*==============================================================================
 CAB.L(z)         = CABO(z);
 CTH.L(z)         = CTHO(z);
 DEP.L(z)         = DEPO(z);
 G.L(z)           = GO(z);
 GDP_BP.L(z)      = GDP_BPO(z);
 GDP_BP_W.L       = SUM[z,GDP_BPO(z)];
 GDP_FD.L(z)      = GDP_FDO(z);
 GDP_IB.L(z)      = GDP_IBO(z);
 GDP_MP.L(z)      = GDP_MPO(z);
 IT.L(z)          = ITO(z);
 SG.L(z)          = SGO(z);
 SH.L(z)          = SHO(z);
 SROW.L(z)        = SROWO(z);
 TCTAX.L(Z)       = TCTAX0(Z);
 TDH.L(z)         = TDHO(z);
 TIC.L(i,z)       = TICO(i,z);
 TICT.L(z)        = TICTO(z);
 TIK.L(k,j,z)     = TIKO(k,j,z);
 TIKT.L(z)        = TIKTO(z);
 TIM.L(i,zj,z)    = TIMO(i,zj,z);
 TIMT.L(z)        = TIMTO(z);
 TIP.L(j,z)       = TIPO(j,z);
 TIPT.L(z)        = TIPTO(z);
 TIW.L(l,j,z)     = TIWO(l,j,z);
 TIWT.L(z)        = TIWTO(z);
 TIX.L(i,z,zj)    = TIXO(i,z,zj);
 TIXT.L(z)        = TIXTO(z);
 TPRODN.l(z)      = TPRODNO(z);
 TPRCTS.l(z)      = TPRCTSO(z);
 YDH.L(z)         = YDHO(z);
 YG.L(z)          = YGO(z);
 YH.L(z)          = YHO(z);
 YHK.L(z)         = YHKO(z);
 YHL.L(z)         = YHLO(z);
 YROW.L(z)        = YROWO(z);
 CP.L(z)          = CP0(z);

*==============================================================================
* Objective Variable
*==============================================================================
* OBJ.L  = 1 ;
*==============================================================================
*   6.1.4 Lower bounds on some variables
*============================================================================== 
*$ontext
 LD.LO(l,j,z)   = 0.000001*LD.l(l,j,z);
 LDC.LO(j,z)    = 0.000001*LDC.l(j,z);
 KD.LO(k,j,z)   = 0.000001*KD.l(k,j,z);
 KDC.LO(j,z)    = 0.000001*KDC.l(j,z);
 KLE.LO(j,z)    = 0.000001*KLE.l(j,z);  
 CE.LO(j,z)     = 0.000001*CE.l(j,z);
 WTI.LO(l,j,z)  = 0.000001*WTI.l(l,j,z); 
 WC.LO(j,z)     = 0.000001*WC.l(j,z);
 RC.LO(j,z)     = 0.000001*RC.l(j,z);
 R.LO(k,j,z)    = 0.000001*R.l(k,j,z);
 RTI.LO(k,j,z)  = 0.000001*RTI.l(k,j,z);
 DS_I.LO(i,z)   = 0.000001*DS_I.l(i,z);
 EXT.LO(i,z)    = 0.000001*EXT.l(i,z);
 EX.LO(i,z,zj)  = 0.000001*EX.l(i,z,zj);
 IM.LO(i,zj,z)  = 0.000001*IM.l(i,zj,z);
 IMT.LO(i,z)    = 0.000001*IMT.l(i,z);
 VA.LO(j,z)     = 0.000001*VA.L(j,z);
 XS.LO(j,i,z)   = 0.000001*XS.L(j,i,z);
 XS_I.LO(i,z)   = 0.000001*XS_I.L(i,z);
 XST.LO(j,z)    = 0.000001*XST.L(j,z);
 PE.LO(i,z,zj)  = 0.000001*PE.L(i,z,zj);
 PET.LO(i,z)    = 0.000001*PET.L(i,z);
 PK.LO(z)       = 0.000001*PK.L(z);
 PL.LO(i,z)     = 0.000001*PL.L(i,z);
 PM.LO(i,zj,z)  = 0.000001*PM.L(i,zj,z);
 PMT.LO(i,z)    = 0.000001*PMT.L(i,z);
 PP.LO(j,z)     = 0.000001*PP.L(j,z);
 PVA.LO(j,z)    = 0.000001*PVA.L(j,z);
 PWM.LO(i,zj,z) = 0.000001*PWM.L(i,zj,z);
 PWMG.LO(i)     = 0.000001*PWMG.L(i);
 PWX.LO(i,z,zj) = 0.000001*PWX.L(i,z,zj);
 PCE.LO(j,z)    = 0.000001*PCE.l(j,z);

*==============================================================================
*  6.2 Choice of mobile or sector-specific capital
*==============================================================================
*  If kmob=1, capital is mobile, if kmob=0, it is sector-specific
* kmob             = 0;
 kmob             = 1;
*자본이동은 장기적으로 발생
 KD.fx(k,j,z)$(kmob eq 0)
                  = KDO(k,j,z);
                  
 KS.fx(k,z)$kmob  = KSO(k,z);
 
*==============================================================================
*  6.3 Closures
*==============================================================================
*  6.3.1 Choice between closures FE and FP
*==============================================================================
$ontext
* CLOSURE FE : fixed exchange rates; numeraire is PIXGDP of reference region
 PIXGDP.FX(zr)   = PIXGDPO(zr);
 e.FX(z)         = eO(z);
$offtext

*$ontext
* CLOSURE FP : fixed PIXGDPs; numeraire is exchange rate of reference region
* The exchange rates are endogenous, except for the reference region.
 e.FX(zr)        = eO(zr);
 PIXGDP.FX(z)    = PIXGDPO(z);
*$offtext

*==============================================================================
*  6.3.2 Other closure rules
*==============================================================================
 CMIN.FX(i,z)     = CMINO(i,z);
 CABX.FX(z1)      = CABXO(z1);
 LS.FX(l,z)       = LSO(l,z);
 G_REAL.FX(z)     = G_REALO(z);
 sh0.FX(z)        = sh0O(z);
 sh1.FX(z)        = sh1O(z);
 ttdh0.FX(z)      = ttdh0O(z);
 ttdh1.FX(z)      = ttdh1O(z);
 ttic.FX(i,z)     = tticO(i,z);
 ttik.FX(k,j,z)   = ttikO(k,j,z);
 ttim.FX(i,zj,z)  = ttimO(i,zj,z);
 ttiw.FX(l,j,z)   = ttiwO(l,j,z);
 ttip.FX(j,z)     = ttipO(j,z);
 ttix.FX(i,z,zj)  = ttixO(i,z,zj);
 CTAX.FX(z)       = CTAX0(Z);
 CP.FX(z)         = 0;

*==============================================================================

* ==============================================================================
* E2_Init.gms  -- Essay 2 변수 초기화 및 폐쇄규칙
* Init_Closure.gms 직후에 include
* ==============================================================================
 LSF.L(z)  = LSFO(z);
 LSF.LO(z) = 0.5;
 LSF.UP(z) = 2.0;
*==============================================================================
* 1. 초기값
*==============================================================================
 PC_HH.L(i,z)    = PC_HHO(i,z);
 PC_HB.L(b,z)    = PC_HBO(b,z);
 C_B.L(b,z)      = C_BO(b,z);
 CE_PHYS.L(z)    = CE_PHYSO(z);
 TIC_HH.L(z)     = 0;
 RCY_POOL.L(z)   = 0;

*==============================================================================
* 2. 하한 (CONOPT 수렴 안정화)
*==============================================================================
 PC_HH.LO(i,z)$PC_HHO(i,z)   = 0.000001*PC_HHO(i,z);
 PC_HB.LO(b,z)$PC_HBO(b,z)   = 0.000001*PC_HBO(b,z);
 C_B.LO(b,z)$C_BO(b,z)       = 0.000001*C_BO(b,z);
 CE_PHYS.LO(z)$CE_PHYSO(z)   = 0.000001*CE_PHYSO(z);

*==============================================================================
* 3. 폐쇄규칙 : 가계 wedge 는 기본적으로 고정(=0)
*    시나리오 파일에서 tth_B 를 설정하여 정책충격 부과
*==============================================================================
 tth.FX(i,z)     = tth0(i,z);

* tth_B 와 tou_shift 는 EQ_E2_8 / EQ_E2_9 가 결정하므로 비고정
* 정책충격은 파라미터 tth_B_raw 와 스위치 e2_expost 로 설정
 tth_B.L(b,z)    = tth_B0(b,z);
 tou_shift.L(z)  = 0;
