* [Z1] Structural-zero fix adapted from researcher CBAM CAL/Model uploads
* dated 2026-10-26 (pasted markdown 5 and 2(2)). Active benchmark industries
* only; zero-output nuclear generation remains zero, with no entry margin.
* No epsilon output and no imputed elasticity for inactive activities.
* [P2] TOU rebate is non-taxable: added in EQ13, deducted once in EQ32.
* Household tax base YH is unchanged by the direct rebate itself.
* Indirect equilibrium effects on income, tax and savings remain endogenous.
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
* ==============================================================================
* Model.gms
* 변수·방정식 선언 및 정의 (원본 L1222-1916)
*  CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================
*  5.1 Variable declarations
*==============================================================================
VARIABLES
*==============================================================================
*   5.1.1 Volume variables
*==============================================================================
C(i,z)             Consumption of commodity i by households in region z
 CABX(z)            Current account balance of region z in terms of the international currency
 CG(i,z)            Public consumption of commodity i in region z
 CI(j,z)            Total intermediate consumption of industry j in region z
 CE(j,z)            Total intermediate consumption of industry j in region z
 CMIN(i,z)          Minimum consumption of commodity i by households in region z
 CTH_REAL(z)        Real household consumption in region z
 DD(i,z)            Domestic demand for commodity i produced locally in region z
 DI(i,j,z)          Intermediate consumption of commodity i by industry j in region z
 DE(i,j,z)          Intermediate energy consumption of commodity i by industry j in region z
 DIT(i,z)           Total intermediate demand of commodity i in region z
 DS(j,i,z)          Supply of commodity i by sector j to the domestic market
 DS_I(i,z)          Supply of commodity i to the domestic market of region z
 EX(i,z,zj)         Quantity of product i exported by country z to country zj
 EXT(i,z)           Supply of composite commodity i by region z to the export market
 EXTT(j,i,z)        Supply of activity j to the export market i of region z
 G_REAL(z)          Current real government expenditures on goods and services in region z
 GDP_BP_REAL(z)     Real GDP at basic prices
 GDP_BP_W_REAL      Real world GDP at basic prices
 GDP_MP_REAL(z)     Real GDP at market prices
 IM(i,zj,z)         Quantity of product i imported by country z from country zj
 IMT(i,z)           Quantity demanded of composite imports of commodity i by region z
 INV(i,z)           Final demand of commodity i for investment purposes (GFCF) in region z
 IT_REAL(z)         Real gross fixed capital formation
 KD(k,j,z)          Demand for type k capital by industry j in region z
 KDC(j,z)           Demand for composite capital by industry j in region z
 KS(k,z)            Supply of type k capital in region z
 LD(l,j,z)          Demand for type l labor by industry j in region z
 LDC(j,z)           Demand for composite labor by industry j in region z
 LS(l,z)            Supply of type l labor in region z
 MRGN(i,z)          Domestic production of commodity i in region z exported as international margin services
 Q(i,z)             Quantity demanded of composite commodity i in region z
 VA(j,z)            Value added of industry j in region z
 KLE(j,z)           KLE of industry j in region z
 XS(j,i,z)          Total output of industry j by commodity in region z
 XS_I(i,z)          Total output of commodity i in region z
 XST(j,z)           Total aggregate output of industry j in region z
 POWERQ(z)          Total power output in region z
 EE(product,j,z)    Industry energy consumption in region z ktoe
 NE(product,j,z)    Industry non energy consumption in region z ktoe
 EH(product,z)      Household energy consumption in region z ktoe
 CO2I(product,j,z)  Industry CO2 emission in region z ktCO2
 CO2H(product,z)    Household CO2 emission in region z ktCO2
 CH4I(product,j,z)  Industry CH4 emission in region z tCO2eq
 CH4H(product,z)    Household CH4 emission in region z tCO2eq
 N2OI(product,j,z)  Industry N2O emission in region z tCO2eq
 N2OH(product,z)    Household N2O emission in region z tCO2eq
 TCO2I(product,j,z) Total Industry CO2 emission in region z ktCO2
*==============================================================================
*   5.1.2 Price variables
*==============================================================================
 e(z)               Exchange rate (price of international currency in terms of region z local currency)
 P(i,z)             Basic price of commodity i in region z
 P2(j,i,z)          Basic price of industry js production of commodity i
 P3(i,j,z)          Basic price of power industry js production of commodity i
 P4(ene,j,z)        Basic energy commodity price of industry js production of commodity i
 PPOWER(z)          Basic price of composite power commodity in region z
 PI(i,z)            Basic price of composite activity commodity in region z
 PT(j,z)            Basic price of industry js output
 PC(i,z)            Purchaser price of composite commodity i (including all taxes and margins) in region z
 PCI(j,z)           Intermediate consumption price index of industry j in region z
 PCE(j,z)           Intermediate energy consumption price index of industry j in region z
 PD(i,z)            Price of local product i sold on region z domestic market (including all taxes)
 PE(i,z,zj)         Price received for commodity i exported to region zj by region z (excluding export taxes)
 PET(i,z)           Border price of composite commodity i exported by region z
 PIXCON(z)          Consumer price index in region z
 PIXGDP(z)          GDP deflator in region z
 PIXGDP_W           World GDP deflator
 PIXGVT(z)          Public expenditures price index in region z
 PIXINV(z)          Investment price index in region z
 PK(z)              Price of new capital in region z
 PL(i,z)            Price of local product i (excluding all taxes on products) in region z
 PM(i,zj,z)         Price of commodity i imported by region z from region zj (including all taxes duties and margins)
 PMT(i,z)           Price of composite commodity i imported by region z (including all taxes duties and margins)
 PP(j,z)            Unit cost of industry j in region z including taxes directly related to the use of capital and labor but excluding other taxes on production
 PVA(j,z)           Price of industry j value added in region z (including taxes on production directly related to the use of capital and labor)
 PKLE(j,z)          Price of industry j KLE in region z
 PWM(i,zj,z)        World price of commodity i imported from country zj by region z (expressed in international currency)
 PWMG(i)            World price of margin i (expressed in international currency)
 PWX(i,z,zj)        World price of commodity i exported to country zj by region z (expressed in international currency)
 R(k,j,z)           Rental rate of type k capital in industry j of region z
 RC(j,z)            Rental rate of industry j composite capital in region z
 RK(k,z)            Rental rate of type k capital in region z
 RTI(k,j,z)         Rental rate paid by industry j for type k capital in region z including capital taxes
 W(l,z)             Wage rate of type l labor in region z
 WC(j,z)            Wage rate of industry j composite labor in region z
 WTI(l,j,z)         Wage rate paid z by industry j for type l labor in region including payroll taxes
 CTAX(Z)            Carbon tax in region z
 CP(z)              Carbon price disparity with EU
*==============================================================================
*   5.1.3 Nominal (value) variables
*==============================================================================
 CAB(z)             Current account balance of region z
 CTH(z)             Consumption budget of households in region z
 DEP(z)             Amount of depreciation (capital consumption allowance) in region z
 G(z)               Current government expenditures on goods and services in region z
 GDP_BP(z)          Region z GDP at basic prices
 GDP_BP_W           World GDP at basic prices
 GDP_FD(z)          Region z GDP at purchasers prices from the perspective of final demand (지출)
 GDP_MP(z)          Region z GDP at market prices (생산)
 GDP_IB(z)          Region z GDP at market prices (income-based)(소득)
 IT(z)              Total investment expenditures in region z
 SG(z)              Government savings in region z
 SH(z)              Household savings in region z
 SROW(z)            Rest-of-the-world savings with respect to region z
 TDH(z)             Household income taxes in region z
 TCTAX(z)           Government revenue from Carbon tax
 TIC(i,z)           Government revenue from indirect taxes on commodity i in region z
 TICT(z)            Total government receipts of indirect taxes on commodities in region z
 TIK(k,j,z)         Government revenue from taxes on type k capital used by industry j in region z
 TIKT(z)            Total government revenue from from taxes on capital in region z
 TIM(i,zj,z)        Government revenue from duties on commodity i imported from region zj by region z
 TIMT(z)            Total government revenue from import duties in region z
 TIP(j,z)           Government revenue from taxes on industry j production in region z (excluding taxes directly related to the use of capital and labor)
 TIPT(z)            Total government revenue from production taxes in region z (excluding taxes directly related to the use of capital and labor)
 TIW(l,j,z)         Government revenue from payroll taxes on type l labor in industry j of region z
 TIWT(z)            Total government revenue from payroll taxes in region z
 TIX(i,z,zj)        Government revenue from export taxes on commodity i exported by region z to region zj
 TIXT(z)            Total government revenue from export taxes in region z
 TPRCTS(z)          Total government revenue from taxes on products and imports in region z
 TPRODN(z)          Total government revenue from other taxes on production in region z
 YDH(z)             Household disposable income in region z
 YG(z)              Total government income in region z
 YH(z)              Household total income in region z
 YHK(z)             Household capital income in region z
 YHL(z)             Household labor income in region z
 YROW(z)            Rest-of-the-world total income from region z
 TCBAM(z)           CBAM revenue in region z
*==============================================================================
*   5.1.4 Rates and intercepts
*==============================================================================
 sh0(z)             Intercept (household savings)
 sh1(z)             Slope (household savings)
 ttdh0(z)           Intercept (household income tax)
 ttdh1(z)           Slope (household income tax)
 ttic(i,z)          Tax rate on commodity i
 ttik(k,j,z)        Tax rate on capital k used in industry j
 ttim(i,zj,z)       Rate of taxes and duties on imports of commodity i from country zj
 ttip(j,z)          Tax rate on the production of industry j
 ttiw(l,j,z)        Tax rate on type l worker compensation in industry j
 ttix(i,z,zj)       Export tax rate on exported commodity i
*==============================================================================
*   5.1.5 Other variables
*==============================================================================
 LEON(z)            Excess supply on the last market in region z
* OBJ                Objective variable
*==============================================================================
*   5.1.6 CBAM revenue-recycling instruments  [refactor]
*==============================================================================
 deltattip(j,z)     Production tax reduction financed by recycled CBAM revenue
 ttip_share(j,z)    Output share of industry j within the subsidised set
 deltattiw(l,j,z)   Labor tax reduction financed by recycled CBAM revenue
 ttiw_share(l,j,z)  Wage bill share of (l j) within the subsidised set
*==============================================================================
*  5.2 Equation declarations
*==============================================================================
EQUATIONS
EQ1(j,z)           Leontief - demand for value added(Energy Industries)
 EQ1_1(j,z)         Leontief - demand for KLE(Industries)
 EQ2(j,z)           Leontief - demand for intermediate consumption
 EQ2_1(j,z)         Leontief - demand for intermediate energy consumption(Energy Industries)
 EQ3(j,z)           CES - combination of labor and capital
 EQ3_1(j,z)         CES - combination of composite energy and value added
 EQ4(j,z)           CES - demand for composite labor
 EQ4_1(j,z)         Demand for value added relative to composite energy
 EQ5(j,z)           CES between labor categories
 EQ6(l,j,z)         Demand for labor
 EQ7(j,z)           CES between capital categories
 EQ8(k,j,z)         Demand for capital
 EQ9(i,j,z)         Leontief - demand for commodity i by sector j
 EQ9_1(i,j,z)       Leontief - demand for commodity i by sector j
 EQ9_2(i,j,z)       Leontief - demand for commodity i by sector j
* EQ9_2(j,z)         CES between energy commodities categories
 EQ10(z)            Household total income (incl. recycled CBAM revenue)
 EQ11(z)            Household labor income
 EQ12(z)            Household capital income
 EQ13(z)            Household disposable income
 EQ14(z)            Household consumption budget
 EQ15(z)            Household savings
 EQ16(z)            Government total income
 EQ16_1(z)          Government revenue from Ctax
 EQ16_4(z)          CBAM revenue collected in region z
 EQ17(z)            Total government receipts of taxes on production
 EQ18(z)            Government receipts of indirect taxes on wages
 EQ19(z)            Government receipts of indirect taxes on capital
 EQ20(z)            Government receipts of indirect taxes on production
 EQ21(z)            Total government receipts of taxes on products and imports
 EQ22(z)            Government receipts of indirect taxes on consumption
 EQ23(z)            Government receipts of indirect taxes on imports
 EQ24(z)            Government receipts of indirect taxes on exports
 EQ25(z)            Household h income taxes
 EQ26(l,j,z)        Government receipts of indirect taxes on wages
 EQ27(k,j,z)        Government receipts of indirect taxes on capital
 EQ28(j,z)          Government receipts of indirect taxes on production of industry j
 EQ29(i,z)          Government receipts of indirect taxes on commodity i
 EQ30(i,zj,z)       Government receipts of indirect taxes on imports of commodity i
 EQ31(i,z,zj)       Government receipts of indirect taxes on exports of commodity i
 EQ32(z)            Government savings
 EQ33(z)            Rest of the world total income
 EQ34(z)            Rest of the world savings
*--- CBAM revenue-recycling instruments [refactor] ---
 EQ96(j,z)          Output share within subsidised non-fossil generation
 EQ97(j,z)          Production tax rate after recycling
 EQ98(j,z)          Production tax reduction financed by recycled revenue
 EQ99(l,j,z)        Wage bill share within subsidised CBAM industries
 EQ100(l,j,z)       Labor tax rate after recycling
 EQ101(l,j,z)       Labor tax reduction financed by recycled revenue
 EQ35(z)            Equivalence between current account balance and savings
 EQ36(i,z)          Household consumption of commodity i
 EQ37(i,z)          Final demand of commodity i for investment purposes
 EQ38(i,z)          Public final consumption of commodity i
 EQ39(i,z)          Total intermediate consumption of commodity i
 EQ39_1(i,z)        Total intermediate consumption of commodity i
* EQ40_1(j,z)       CET between different commodities produced by industry j
* EQ40_2(j,i,z)     Industry j production of commodity i (CET)
 EQ40_3(i,z)        Domestic supply by commdities
 EQ40_4(j,z)        Total supply by commdities
 EQ40_5(i,z)        CET function between exports local production and margins
 EQ41(i,z)          Supply of composite exports
 EQ42(i,z)          Supply of margins
 EQ43(i,z)          CET function between exports by trading partner
 EQ44(i,z,zj)       Supply of exports by trading partner
 EQ45(i,z)          CES function between composite imports and local production
 EQ46(i,z)          Demand for composite imports
 EQ47(i,z)          CES function between imports by origin
 EQ48(i,zj,z)       Demand for imports by origin
 EQ49(j,z)          Producer price in energy industries j after production taxes
 EQ49_1(j,z)        Producer price in industry j after production taxes
* EQ49(j,z)         Producer price in industry j after production taxes
* EQ49_2(j,i,z)     Total producer price is equal to P if there is only one product
* EQ49_3(j,i,z)     Basic price of industry j's production of commodity i
 EQ50(j,z)          Basic price of industry j production
 EQ51(j,z)          Price index of industry j intermediate consumption
 EQ51_1(j,z)        Price index of industry j intermediate energy consumption
 EQ52(j,z)          Value added price
 EQ52_1(j,z)        KLE price
* EQ53(j,z)         Price of composite labor in industry j (redundant)
 EQ54(l,j,z)        Wages including taxes
 EQ54_1(ene,j,z)    energy commodity prices
* EQ55(j,z)         Price of composite capital in industry j (redundant)
 EQ56(k,j,z)        Rental rate including taxes
 EQ57(k,j,z)        Rate of remuneration of capital k (capital mobile)
 EQ58(i,z)          Producer price is a weighted sum of PE and PL
* EQ59(i,z)         Price of composite export i (redundant)
 EQ60(i,z,zj)       Border price of exported commodity i
 EQ61(i,z)          Price of local product i (including all taxes and margins)
 EQ62(i,zj,z)       Price of imported commodity i (including all taxes and duties)
* EQ63(i,z)         Price of composite import i (redundant)
 EQ64(i,z)          Consumer price is a weighted sum of PD and PM
 EQ65(z)            Aggregate price of capital
 EQ66(z)            GDP deflator (Fischer index)
 EQ67               World GDP deflator (Fischer index)
 EQ68(z)            Consumer price index (Laspeyres)
 EQ69(z)            Investment price index (derived from investment function)
 EQ70(z)            Public expenditure price index
 EQ71(i1,z)         Domestic absorbtion
 EQ72(l,z)          Labor supply equals labor demand
 EQ73(k,z)          Capital supply equals capital demand
 EQ74(z)            Total investment equals total savings
 EQ75(z)            Depreciation
 EQ76(i,z)          Supply of domestic production equals demand
 EQ77(i,z,zj)       Exports supply equals imports demand
 EQ78(i,z,zj)       Exports price equals imports price
 EQ79(i)            World demand for margins equals world supply
* EQ80              Sum of foreign savings equals zero (redundant)
 EQ81(z)            GDP at basic prices
 EQ82(z)            GDP at market prices
 EQ83(z)            GDP at market prices (income-based)
 EQ84(z)            GDP at market prices (expenditure-based)
 EQ85               World GDP
 EQ86(z)            Real consumption budget of type h households
 EQ87(z)            Real current government expenditures on goods and services
 EQ88(z)            Real GDP at basic prices
 EQ89               Real world GDP at basic prices
 EQ90(z)            Real GDP at market prices
 EQ91(z)            Real gross fixed capital formation
 EQ92(z)            Current account balance of region z in terms of the reference currency
 WALRAS(z)          Walras law verification
* EQ93               fictitious OBJ. fuction
 EQA_1(z)           Top Nest - Leontief function Aggregated-Electricity
 EQA_2(Z)           Top Nest - Leontief function Aggregated-Electricity
 EQA_3(z)           Second Nest - CES function - Aggregated-Electricity
 EQA_4(power,i,z)   Second Nest - CES function - Aggregated-Electricity
 EQB_1(i2,z)        Industry j production of commodity i (CES)
 EQB_3(j,i,z)       Total producer price is equal to P if there is only one product
 EQB_4(j,i,z)       Basic price of industry js production of commodity i
 EQB_5(j,i,z)       Supply of exports for compsite activity
;
*==============================================================================
*  5.3 Equations
*==============================================================================
*   5.3.1 Production
*==============================================================================
* EQ1(j3,z)..     VA(j3,z) =e= v(j3,z)*XST(j3,z);

 EQ1_1(j2,z)$(ACTIVE_J(j2,z))..   KLE(j2,z) =e= v2(j2,z)*XST(j2,z);
* EQ2(j,z)..      CI(j,z) =e= io(j,z)*XST(j,z);
* EQ2_1(j3,z)..   CE(j3,z) =e= io2(j3,z)*XST(j3,z);
*--- 교체식 : 전력공급 산업에만 LSF 를 곱한다. 그 외는 [ ] 안이 1.

 EQ1(j3,z)$(ACTIVE_J(j3,z))..     VA(j3,z)  =e= v(j3,z)  *XST(j3,z)*[1+(LSF(z)-1)$JPOW(j3)];

 EQ2(j,z)$(ACTIVE_J(j,z))..      CI(j,z)   =e= io(j,z)  *XST(j,z) *[1+(LSF(z)-1)$JPOW(j)];

 EQ2_1(j3,z)$(ACTIVE_J(j3,z))..   CE(j3,z)  =e= io2(j3,z)*XST(j3,z)*[1+(LSF(z)-1)$JPOW(j3)];

 EQ3(j,z)$(ACTIVE_J(j,z) AND VAO(j,z)>0)..      VA(j,z) =e= B_VA(j,z)*{
                    [beta_VA(j,z)*LDC(j,z)**(-rho_VA(j,z))]$LDCO(j,z)
                   +[(1-beta_VA(j,z))*KDC(j,z)**(-rho_VA(j,z))]$KDCO(j,z)
                                                   }**(-1/rho_VA(j,z));

 EQ3_1(j2,z)$(ACTIVE_J(j2,z) AND KLEO(j2,z)>0)..     KLE(j2,z) =e= B_KLE(j2,z)*{
                    [beta_KLE(j2,z)*VA(j2,z)**(-rho_KLE(j2,z))]$VAO(j2,z)
                   +[(1-beta_KLE(j2,z))*CE(j2,z)**(-rho_KLE(j2,z))]$CEO(j2,z)
                                                   }**(-1/rho_KLE(j2,z));

 EQ4(j,z)$(ACTIVE_J(j,z) AND LDCO(j,z)>0 AND KDCO(j,z)>0)..
                 LDC(j,z) =e= {[beta_VA(j,z)/(1-beta_VA(j,z))]
                              *[RC(j,z)/WC(j,z)]}**sigma_VA(j,z)*KDC(j,z);

 EQ4_1(j2,z)$(ACTIVE_J(j2,z) AND VAO(j2,z)>0 AND CEO(j2,z)>0)..
                 VA(j2,z) =e= {[beta_KLE(j2,z)/(1-beta_KLE(j2,z))]
                              *[PCE(j2,z)/PVA(j2,z)]}**sigma_KLE(j2,z)*CE(j2,z);

 EQ5(j,z)$(ACTIVE_J(j,z) AND LDCO(j,z)>0)..
                 LDC(j,z) =e= B_LD(j,z)*SUM[l$LDO(l,j,z),beta_LD(l,j,z)
                                *LD(l,j,z)**(-rho_LD(j,z))]**(-1/rho_LD(j,z));

 EQ6(l,j,z)$(ACTIVE_J(j,z) AND LDO(l,j,z)>0)..
                 LD(l,j,z) =e= [beta_LD(l,j,z)*WC(j,z)/WTI(l,j,z)]
                               **sigma_LD(j,z)*B_LD(j,z)**(sigma_LD(j,z)-1)
                               *LDC(j,z);

 EQ7(j,z)$(ACTIVE_J(j,z) AND KDCO(j,z)>0)..
                 KDC(j,z) =e= B_KD(j,z)*SUM[k$KDO(k,j,z),beta_KD(k,j,z)
                                *KD(k,j,z)**(-rho_KD(j,z))]**(-1/rho_KD(j,z));

 EQ8(k,j,z)$(ACTIVE_J(j,z) AND KDO(k,j,z)>0)..
                 KD(k,j,z) =e= [beta_KD(k,j,z)*RC(j,z)/RTI(k,j,z)]
                                 **sigma_KD(j,z)*B_KD(j,z)**(sigma_KD(j,z)-1)
                                 *KDC(j,z);

 EQ9(nene,j,z)$(ACTIVE_J(j,z))..   DI(nene,j,z) =e= aij(nene,j,z)*CI(j,z) ;

 EQ9_1(ene,j3,z)$(ACTIVE_J(j3,z)).. DE(ene,j3,z) =e= aij2(ene,j3,z)*CE(j3,z) ;

 EQ9_2(ene,j2,z)$(ACTIVE_J(j2,z) AND DEO(ene,j2,z)>0).. DE(ene,j2,z) =e= [beta_ENER(ene,j2,z)*PCE(j2,z)/((P4(ene,j2,z)+CTAX(Z)*CO2FACTOR(ene,j2,z)))]
                                   **sigma_ENER(j2,z)*B_ENER(j2,z)**(sigma_ENER(j2,z)-1)
                                   *CE(j2,z);
*==============================================================================
*   5.3.2 Income and savings
*==============================================================================
*    5.3.2.1 Households
*==============================================================================
*--- [refactor] 환류 목적지는 rcy_share / rcy_hh 로 통제 (원래 EQ10 EQ10_1 EQ10_2 통합)
 EQ10(z)..       YH(z) =e= YHL(z)+YHK(z)+TCTAX(z) + rcy_hh(z)*RCY_IN(z);
 EQ11(z)..       YHL(z) =e= SUM[(l,j)$LDO(l,j,z),W(l,z)*LD(l,j,z)];
 EQ12(z)..       YHK(z) =e= SUM[(k,j)$KDO(k,j,z),R(k,j,z)*KD(k,j,z)];
 EQ13(z)..       YDH(z) =e= YH(z)-TDH(z) + TOU_TRANSFER(z);
 EQ14(z)..       CTH(z) =e= YDH(z)-SH(z);
 EQ15(z)..       SH(z) =e= PIXCON(z)**eta*sh0(z)+sh1(z)*YDH(z);
*==============================================================================
*    5.3.2.2 Government
*==============================================================================
*--- [refactor] CBAM 징수는 z3 에서만 발생 (원래 EQ16_3 EQ16_4 EQ16_6 통합)
 EQ16_4(z)..     TCBAM(z) =e= [sum((i,zj), CP(zj)*CO2IDFACTOR(i,zj)*e(z)*IM(i,zj,z)*PWM(i,zj,z))]$z3(z);
*--- [refactor] 총액 규약: 자국 징수분 전액 + 해외로부터의 이전수입을 YG 에 계상
 EQ16(z)..       YG(z) =e= TDH(z)+TPRODN(z)+TPRCTS(z)+TCTAX(z) + TCBAM(z) + RCY_INF(z);
 EQ16_1(z)..     TCTAX(z)  =e= sum((ene,j), PC(ene,z)*CTAX(z)*CO2FACTOR(ene,j,z)*DE(ene,j,z));
 EQ17(z)..       TPRODN(z) =e= TIWT(z)+TIKT(z)+TIPT(z);
 EQ18(z)..       TIWT(z) =e= SUM[(l,j)$LDO(l,j,z),TIW(l,j,z)];
 EQ19(z)..       TIKT(z) =e= SUM[(k,j)$KDO(k,j,z),TIK(k,j,z)];
 EQ20(z)..       TIPT(z) =e= SUM[j,TIP(j,z)];
 EQ21(z)..       TPRCTS(z) =e= TICT(z)+TIMT(z)+TIXT(z)+TIC_HH(z);
 EQ22(z)..       TICT(z) =e= SUM[i,TIC(i,z)];
 EQ23(z)..       TIMT(z) =e= SUM[(i,zj)$IMO(i,zj,z),TIM(i,zj,z)];
 EQ24(z)..       TIXT(z) =e= SUM[(i,zj)$EXO(i,z,zj),TIX(i,z,zj)];
 EQ25(z)..       TDH(z) =e= PIXCON(z)**eta*ttdh0(z)+ttdh1(z)*YH(z);

 EQ26(l,j,z)$(ACTIVE_J(j,z) AND LDO(l,j,z)>0)..
                 TIW(l,j,z) =e= ttiw(l,j,z)*W(l,z)*LD(l,j,z);

 EQ27(k,j,z)$(ACTIVE_J(j,z) AND KDO(k,j,z)>0)..
                 TIK(k,j,z) =e= ttik(k,j,z)*R(k,j,z)*KD(k,j,z);

 EQ28(j,z)$(ACTIVE_J(j,z))..     TIP(j,z) =e= ttip(j,z)*PP(j,z)*XST(j,z);
 EQ29(i,z)..     TIC(i,z) =e= ttic(i,z)*{[PL(i,z)*DD(i,z)]$DDO(i,z)
                 +[SUM[zj$IMO(i,zj,z),(1+ttim(i,zj,z))*IM(i,zj,z)*e(z)
                  *(PWM(i,zj,z)+SUM(ij,PWMG(ij)*tmrg(ij,i,zj,z)))]]};
 EQ30(i,zj,z)$IMO(i,zj,z)..
                 TIM(i,zj,z) =e= ttim(i,zj,z)*IM(i,zj,z)*e(z)*(PWM(i,zj,z)
                                +SUM[ij,PWMG(ij)*tmrg(ij,i,zj,z)]);
 EQ31(i,z,zj)$EXO(i,z,zj)..
                 TIX(i,z,zj) =e= ttix(i,z,zj)*PE(i,z,zj)*EX(i,z,zj);
*--- [refactor] 해외 송금과 가계이전분 차감
 EQ32(z)..       SG(z) =e= YG(z)-G(z)-TCTAX(z)
                           - rcy_hh(z)*RCY_IN(z) - RCY_OUTF(z) - TOU_TRANSFER(z);
*==============================================================================
*    5.3.2.4 Rest of the world
*==============================================================================
 EQ33(z)..       YROW(z) =e= e(z)*SUM{(i,zj)$IMO(i,zj,z),IM(i,zj,z)*
                           [PWM(i,zj,z)+SUM(ij,PWMG(ij)*tmrg(ij,i,zj,z))]}
                           + RCY_OUTF(z);
 EQ34(z)..       SROW(z) =e= YROW(z)-e(z)*SUM[(i,zj)$EXO(i,z,zj),
                               EX(i,z,zj)*PWX(i,z,zj)]-e(z)
                               *SUM[i$MRGNO(i,z),MRGN(i,z)*PWMG(i)]
                               - RCY_INF(z);
 EQ35(z)..       SROW(z) =e= -CAB(z);
*==============================================================================
*   5.3.3 Demand
*==============================================================================
 EQ36(i,z)..     PC_HH(i,z)*C(i,z) =e= PC_HH(i,z)*CMIN(i,z)+gamma_LES(i,z)
                                *{CTH(z)-SUM[ij,PC_HH(ij,z)*CMIN(ij,z)]};
 EQ37(i,z)..     PC(i,z)*INV(i,z) =e= gamma_INV(i,z)*IT(z);
 EQ38(i,z)..     PC(i,z)*CG(i,z) =e= gamma_GVT(i,z)*G(z);
 EQ39(nene,z)..  DIT(nene,z) =e= SUM[j,DI(nene,j,z)];
 EQ39_1(ene,z).. DIT(ene,z) =e= SUM[j,DE(ene,j,z)];
*==============================================================================
*   5.3.4 International trade
*==============================================================================
* Aggregate Power Sector
*[Top Nest - Leontief function]
 EQA_1(z)..  XS('18_TnD','18_ELEC',z) =e= TnDShare(z)*XS_I('18_ELEC',z);
 EQA_2(z)..  XS_I('18_ELEC',z) =e= XS('18_TnD','18_ELEC',z) + POWERQ(z);
*[Second Nest - CES function]

EQA_3(z)..
    POWERQ(z) =e= B_X4(z)
        *SUM(power$ACTIVE_POWER(power,z),
            beta_X4(power,z)*XS(power,'18_ELEC',z)**(-rho_X4(z)))
        **(-1/rho_X4(z));

 EQA_4(power,'18_ELEC',z)$ACTIVE_POWER(power,z)..  XS(POWER,'18_ELEC',z) =e= POWERQ(z)/B_X4(z)**(1-sigma_X4(z))*
                               [beta_X4(power,z)*PPOWER(z)/P2(POWER,'18_ELEC',z)]
                               **sigma_X4(z);
* exclude electiricity
 EQB_1(i2,z)..   XS_I(i2,z) =e= B_X3(i2,z)*SUM[j$XSO(j,i2,z),beta_X3(j,i2,z)
                                *XS(j,i2,z)**(-rho_X3(i2,z))]**(-1/rho_X3(i2,z));

 EQB_3(j,i,z)$(ACTIVE_J(j,z) AND DSO(j,i,z)>0)..   P2(j,i,z) =e= PT(j,z);

 EQB_4(j,i,z)$(ACTIVE_J(j,z) AND DSO(j,i,z)>0)..
                 P2(j,i,z)*XS(j,i,z) =e= [PET(i,z)*EXTT(j,i,z)]$EXTTO(j,i,z)
                                        +[e(z)*MRGN(i,z)*PWMG(i)]$MRGNO(i,z)
                                        +[PL(i,z)*DS(j,i,z)]$DSO(j,i,z);

 EQB_5(j,i,z)$(ACTIVE_J(j,z) AND DSO(j,i,z)>0)..  EXTT(j,i,z)  =e= theta2(j,i,z)*EXT(i,z);
 EQ40_3(i,z)..   DS_I(i,z) =e= sum(j,DS(j,i,z)$DSO(j,i,z));

 EQ40_4(j,z)$(ACTIVE_J(j,z))..   XST(j,z)  =e= sum(i,XS(j,i,z)$XSO(j,i,z));
 EQ40_5(i,z)..   XS_I(i,z) =e= B_X1(i,z)*{
                 [beta_EX_X1(i,z)*EXT(i,z)**rho_X1(i,z)]$EXTO(i,z)
                +[beta_D_X1(i,z)*DS_I(i,z)**rho_X1(i,z)]$DSO_I(i,z)
                +[(1-beta_EX_X1(i,z)-beta_D_X1(i,z))*MRGN(i,z)**rho_X1(i,z)]$MRGNO(i,z)
                                          }**(1/rho_X1(i,z));
 EQ41(i,z)$[EXTO(i,z) and DSO_I(i,z)]..
                 EXT(i,z) =e= {[beta_D_X1(i,z)/beta_EX_X1(i,z)]*[PET(i,z)/PL(i,z)]}
                              **sigma_X1(i,z)*DS_I(i,z);
 EQ42(i,z)$[MRGNO(i,z) and DSO_I(i,z)]..
                 MRGN(i,z) =e= {[beta_D_X1(i,z)/(1-beta_EX_X1(i,z)
                                 -beta_D_X1(i,z))]*[e(z)*PWMG(i)/PL(i,z)]}
                                 **sigma_X1(i,z)*DS_I(i,z);
 EQ43(i,z)$EXTO(i,z)..
                 EXT(i,z) =e= B_X2(i,z)*SUM[zj$EXO(i,z,zj),beta_X2(i,z,zj)
                                *EX(i,z,zj)**rho_X2(i,z)]**(1/rho_X2(i,z));
 EQ44(i,z,zj)$EXO(i,z,zj)..
                 EX(i,z,zj) =e= EXT(i,z)/B_X2(i,z)**(1+sigma_X2(i,z))*
                                  [PE(i,z,zj)/(beta_X2(i,z,zj)*PET(i,z))]
                                  **sigma_X2(i,z);
 EQ45(i,z)..     Q(i,z) =e= B_M1(i,z)*{
                    [beta_M1(i,z)*IMT(i,z)**(-rho_M1(i,z))]$IMTO(i,z)
                   +[(1-beta_M1(i,z))*DD(i,z)**(-rho_M1(i,z))]$DDO(i,z)
                                        }**(-1/rho_M1(i,z));
 EQ46(i,z)$[IMTO(i,z) and DDO(i,z)]..
                 IMT(i,z) =e= {[beta_M1(i,z)/(1-beta_M1(i,z))]*[PD(i,z)
                                /PMT(i,z)]}**sigma_m1(i,z)*DD(i,z);
 EQ47(i,z)$IMTO(i,z)..
                 IMT(i,z) =e= B_M2(i,z)*SUM[zj$IMO(i,zj,z),beta_M2(i,zj,z)*
                                IM(i,zj,z)**(-rho_M2(i,z))]**(-1/rho_M2(i,z));
 EQ48(i,zj,z)$IMO(i,zj,z)..
                 IM(i,zj,z) =e= IMT(i,z)/B_M2(i,z)**(1-sigma_M2(i,z))*
                                  [beta_M2(i,zj,z)*PMT(i,z)/PM(i,zj,z)]
                                  **sigma_M2(i,z);
*==============================================================================
*   5.3.5 Prices
*==============================================================================

 EQ49(j2,z)$(ACTIVE_J(j2,z))..    PP(j2,z)*XST(j2,z) =e= PKLE(j2,z)*KLE(j2,z)+PCI(j2,z)*CI(j2,z);

 EQ49_1(j3,z)$(ACTIVE_J(j3,z))..  PP(j3,z)*XST(j3,z) =e= PVA(j3,z)*VA(j3,z)+PCI(j3,z)*CI(j3,z)+PCE(j3,z)*CE(j3,z);

 EQ50(j,z)$(ACTIVE_J(j,z))..     PT(j,z) =e= (1+ttip(j,z))*PP(j,z);

 EQ51(j,z)$(ACTIVE_J(j,z))..     PCI(j,z)*CI(j,z) =e= SUM[nene,PC(nene,z)*DI(nene,j,z)];

 EQ51_1(j,z)$(ACTIVE_J(j,z))..   PCE(j,z)*CE(j,z) =e= SUM[ene,PC(ene,z)*DE(ene,j,z) + PC(ene,z)*CTAX(Z)*CO2FACTOR(ene,j,z)*DE(ene,j,z)];

 EQ52(j,z)$(ACTIVE_J(j,z))..      PVA(j,z)*VA(j,z) =e= [WC(j,z)*LDC(j,z)]$LDCO(j,z)
                                     +[RC(j,z)*KDC(j,z)]$KDCO(j,z);

 EQ52_1(j2,z)$(ACTIVE_J(j2,z))..   PKLE(j2,z)*KLE(j2,z) =e= [PVA(j2,z)*VA(j2,z)]$VAO(j2,z) + [PCE(j2,z)*CE(j2,z)]$CEO(j2,z);
* Given equations 5 and 6, equation 53 is redundant
* EQ53(j,z)..     WC(j,z)*LDC(j,z) =e= SUM[l$LDO(l,j,z),WTI(l,j,z)*LD(l,j,z)];

 EQ54(l,j,z)$(ACTIVE_J(j,z) AND LDO(l,j,z)>0)..
                 WTI(l,j,z) =e= W(l,z)*(1+ttiw(l,j,z));

 EQ54_1(ene,j,z)$(ACTIVE_J(j,z) AND DEO(ene,j,z)>0)..
                 P4(ene,j,z) =e= PC(ene,z);
* Given equations 7 and 8, equation 55 is redundant
* EQ55(j,z)$(kmob and KDCO(j,z))..
*                 RC(j,z)*KDC(j,z) =e= SUM[k$KDO(k,j,z),RTI(k,j,z)*KD(k,j,z)];

 EQ56(k,j,z)$(ACTIVE_J(j,z) AND KDO(k,j,z)>0)..
                 RTI(k,j,z) =e= R(k,j,z)*(1+ttik(k,j,z));

 EQ57(k,j,z)$(ACTIVE_J(j,z) AND kmob AND KDO(k,j,z)>0)..
                 R(k,j,z) =e= RK(k,z);
 EQ58(i,z)..     P(i,z)*XS_I(i,z) =e= [PL(i,z)*DS_I(i,z)]$DSO_I(i,z)
                                     +[PET(i,z)*EXT(i,z)]$EXTO(i,z)
                                     +[e(z)*PWMG(i)*MRGN(i,z)]$MRGNO(i,z);
* Given equations 43 and 44, equation 59 is redundant
* EQ59(i,z)$EXTO(i,z)..
*                 PET(i,z)*EXT(i,z) =e= SUM[zj$EXO(i,z,zj),
*                                           PE(i,z,zj)*EX(i,z,zj);
 EQ60(i,z,zj)$EXO(i,z,zj)..
                 PE(i,z,zj)*(1+ttix(i,z,zj)) =e= e(z)*PWX(i,z,zj);
 EQ61(i,z)$DDO(i,z)..
                 PD(i,z) =e= (1+ttic(i,z))*PL(i,z);
 EQ62(i,zj,z)$IMO(i,zj,z)..
                PM(i,zj,z) =e=
                    e(z)*(1+ttic(i,z))*(1+ttim(i,zj,z))*(PWM(i,zj,z) + SUM[ij,PWMG(ij)*tmrg(ij,i,zj,z)])
                    + [CP(zj)*CO2IDFACTOR(i,zj)*e(z)*PWM(i,zj,z)]$z3(z) ;
* Given equations 47 and 48, equation 63 is redundant
* EQ63(i,z)$IMTO(i,z)..
*                 PMT(i,z)*IMT(i,z) =e= SUM[zj$IMO(i,zj,z),
*                                           PM(i,zj,z)*IM(i,zj,z);
 EQ64(i,z)..     PC(i,z)*Q(i,z) =e= [PD(i,z)*DD(i,z)]$DDO(i,z)+
                                    [PMT(i,z)*IMT(i,z)]$IMTO(i,z);
 EQ65(z)..       PK(z) =e= 1/A_K(z)*PROD[i$gamma_INV(i,z),(PC(i,z)
                               /gamma_INV(i,z))**gamma_INV(i,z)];

EQ66(z)..
    PIXGDP(z) =e=
    { SUM(j$(ACTIVE_J(j,z) AND VAO(j,z)>0),
          (PVA(j,z)+TIP(j,z)/VA(j,z))*VAO(j,z))
      /SUM(j$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           PVAO(j,z)*VAO(j,z)+TIPO(j,z))
      *SUM(j$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           PVA(j,z)*VA(j,z)+TIP(j,z))
      /SUM(j$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           (PVAO(j,z)+TIPO(j,z)/VAO(j,z))*VA(j,z))
    }**0.5;

EQ67..
    PIXGDP_W =e=
    { SUM((j,z)$(ACTIVE_J(j,z) AND VAO(j,z)>0),
          (PVA(j,z)+TIP(j,z)/VA(j,z))*VAO(j,z)/e(z))
      /SUM((j,z)$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           (PVAO(j,z)*VAO(j,z)+TIPO(j,z))/eO(z))
      *SUM((j,z)$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           (PVA(j,z)*VA(j,z)+TIP(j,z))/e(z))
      /SUM((j,z)$(ACTIVE_J(j,z) AND VAO(j,z)>0),
           (PVAO(j,z)+TIPO(j,z)/VAO(j,z))*VA(j,z)/eO(z))
    }**0.5;
 EQ68(z)..       PIXCON(z) =e= SUM[i,PC_HH(i,z)*CO(i,z)]/SUM[i,PCO(i,z)*CO(i,z)];
 EQ69(z)..       PIXINV(z) =e= PROD[i$gamma_INV(i,z),(PC(i,z)/PCO(i,z))
                                 **gamma_INV(i,z)];
 EQ70(z)..       PIXGVT(z) =e= PROD[i$gamma_GVT(i,z),(PC(i,z)/PCO(i,z))
                                 **gamma_GVT(i,z)];
*==============================================================================
*   5.3.6 Equilibrium
*==============================================================================
 EQ71(i1,z)..    Q(i1,z) =e=  C(i1,z) + [CE_PHYS(z)-C(i1,z)]$IELEC(i1)
                            + CG(i1,z)+INV(i1,z)+DIT(i1,z);
 EQ72(l,z)..     LS(l,z) =e= SUM[j$LDO(l,j,z),LD(l,j,z)];
 EQ73(k,z)$KSO(k,z)..
                 KS(k,z) =e= SUM[j$KDO(k,j,z),KD(k,j,z)];
 EQ74(z)..       IT(z) =e= SH(z)+SG(z)-CAB(z);
 EQ75(z)..       DEP(z) =e= PK(z)*delta(z)*SUM[k$KSO(k,z),KS(k,z)];
 EQ76(i,z)$DDO(i,z)..
SUM[j$DSO(j,i,z),DS(j,i,z)] =e= DD(i,z);
 EQ77(i,z,zj)$EXO(i,z,zj)..
                 EX(i,z,zj) =e= IM(i,z,zj);
 EQ78(i,z,zj)$EXO(i,z,zj)..
                 PWX(i,z,zj) =e= PWM(i,z,zj);
 EQ79(i)..       SUM[z$MRGNO(i,z),MRGN(i,z)] =e= SUM[(z,zj,ij)$IMO(ij,zj,z),
                                                 tmrg(i,ij,zj,z)*IM(ij,zj,z)];
* Given equations 33, 34 and 77, equation 80 is redundant
* EQ80..          SUM[z,SROW(z)/e(z)] =e= 0;
*==============================================================================
*   5.3.7 Gross domestic product
*==============================================================================
 EQ81(z)..       GDP_BP(z) =e= SUM[j,PVA(j,z)*VA(j,z)]+TIPT(z);
 EQ82(z)..       GDP_MP(z) =e= GDP_BP(z)+TPRCTS(z)+TCTAX(z)+TCBAM(z)$z3(z);
 EQ83(z)..       GDP_IB(z) =e= SUM[(l,j)$LDO(l,j,z),W(l,z)*LD(l,j,z)]
                              +SUM[(k,j)$KDO(k,j,z),R(k,j,z)*KD(k,j,z)]
                              +TPRCTS(z)+TCTAX(z)+TPRODN(z)+TCBAM(z)$z3(z);
 EQ84(z)..       GDP_FD(z) =e= SUM[i,PC_HH(i,z)*C(i,z)]
                +SUM[i,PC(i,z)*(CG(i,z)+INV(i,z))]
                +SUM[(i,zj)$EXO(i,z,zj),e(z)*PWX(i,z,zj)*EX(i,z,zj)]
                +SUM[i$MRGNO(i,z),e(z)*PWMG(i)*MRGN(i,z)]
                -SUM[(i,zj)$IMO(i,zj,z),e(z)*IM(i,zj,z)
                    *(PWM(i,zj,z)+SUM[ij,PWMG(ij)*tmrg(ij,i,zj,z)])];
 EQ85..          GDP_BP_W =e= SUM[z,GDP_BP(z)/e(z)];
*==============================================================================
*  5.3.8 Real (volume) variables computed from price indices
*==============================================================================
 EQ86(z)..       CTH_REAL(z) =e= CTH(z)/PIXCON(z);
 EQ87(z)..       G_REAL(z) =e= G(z)/PIXGVT(z);
 EQ88(z)..       GDP_BP_REAL(z) =e= GDP_BP(z)/PIXGDP(z);
 EQ89..          GDP_BP_W_REAL =e= GDP_BP_W/PIXGDP_W;
 EQ90(z)..       GDP_MP_REAL(z) =e= GDP_MP(z)/PIXCON(z);
 EQ91(z)..       IT_REAL(z) =e= IT(z)/PIXINV(z);
 EQ92(z)..       CABX(z) =e= CAB(z)/[PIXGDP_W*e(z)];
*==============================================================================
*   5.3.9 Other
*==============================================================================
 WALRAS(z)..     LEON(z) =e= Q('01_AGRICULT',z)-C('01_AGRICULT',z)-CG('01_AGRICULT',z)-INV('01_AGRICULT',z)
                            -DIT('01_AGRICULT',z);
*==============================================================================
*  5.4 CBAM revenue-recycling instruments                            [refactor]
*------------------------------------------------------------------------------
*  아래 방정식은 rcy_prd(z) / rcy_lab(z) 가 1인 지역에서만 생성됨.
*  비활성 영역의 도구변수는 Scenario/Reset_Policy.gms 에서 .FX 로 고정되므로
*  CNS 정방시스템(방정식 수 = 자유변수 수)이 시나리오와 무관하게 유지됨.
*
*  [원본 대비 수정 2건]
*   (a) EQ99  분모: SUM((lj,jj),LD(l,jj,z)) -> 제어인덱스를 실제로 사용하고
*             보조 대상집합(J11) 내부로 정규화. 원본은 분모가 card(l)*sum(jj,LD(l,jj,z))
*             이 되어 지분 합이 1이 되지 않았음. --> 수정
*   (b) EQ101 괄호: .../W(l,z)*LD(l,j,z) -> .../(W(l,z)*LD(l,j,z))
*             원본은 연산자 우선순위상 (rev/W)*LD 로 계산되어 차원이 맞지 않았음. --> 수정
*==============================================================================
*    5.4.1 Production tax reduction for non-fossil generation (rcy_prd)
*==============================================================================
 EQ96(j,z)$(eNFs(j) and ACTIVE_J(j,z) and rcy_prd(z))..
                 ttip_share(j,z) =e= XST(j,z)*PP(j,z)
                                     / SUM[jj$(eNFs(jj) and ACTIVE_J(jj,z)), XST(jj,z)*PP(jj,z)];
 EQ97(j,z)$(eNFs(j) and ACTIVE_J(j,z) and rcy_prd(z))..
                 ttip(j,z)       =e= ttipO(j,z) + deltattip(j,z);
 EQ98(j,z)$(eNFs(j) and ACTIVE_J(j,z) and rcy_prd(z))..
                 deltattip(j,z)  =e= -ttip_share(j,z)*RCY_IN(z)
                                     / [XST(j,z)*PP(j,z)];
*==============================================================================
*    5.4.2 Labor tax reduction for CBAM-exposed industries (rcy_lab)
*==============================================================================
 EQ99(l,j,z)$(J11(j) and ACTIVE_J(j,z) and LDO(l,j,z)>0 and rcy_lab(z))..
                 ttiw_share(l,j,z) =e= W(l,z)*LD(l,j,z)
                                       / SUM[(lj,jj)$(J11(jj) and ACTIVE_J(jj,z) and LDO(lj,jj,z)>0), W(lj,z)*LD(lj,jj,z)];
 EQ100(l,j,z)$(J11(j) and ACTIVE_J(j,z) and LDO(l,j,z)>0 and rcy_lab(z))..
                 ttiw(l,j,z)       =e= ttiwO(l,j,z) + deltattiw(l,j,z);
 EQ101(l,j,z)$(J11(j) and ACTIVE_J(j,z) and LDO(l,j,z)>0 and rcy_lab(z))..
                 deltattiw(l,j,z)  =e= -ttiw_share(l,j,z)*RCY_IN(z)
                                       / [W(l,z)*LD(l,j,z)];
* ============================================================================
* Residential TOU nested demand [T1,T2]. One price equation per nest/region.
* Exact sigma=1 branch avoids the degenerate identity p**0 = 1.
EQUATIONS
 EQ_E2_1(i,z)   Non-electric household prices
 EQ_E2_2(b,z)   Block electricity prices
 EQ_E2_3a(z)    Lower CES price index
 EQ_E2_3a_CD(z) Lower Cobb-Douglas price index
 EQ_E2_3(z)     Upper CES price index
 EQ_E2_3_CD(z)  Upper Cobb-Douglas price index
 EQ_E2_4a(z)    Peak-off composite demand
 EQ_E2_4b(b,z)  Mid demand
 EQ_E2_4(b,z)   Peak and off demand
 EQ_E2_5(z)     Sum of physical block quantities
 EQ_E2_6(z)     Household wedge revenue
 EQ_E2_7(z)     Signed wedge revenue pool
 EQ_E2_8(b,z)   Multiplicative wedge adjustment
 EQ_E2_9(z)     Optional neutrality closure
 EQ_E2_10(z)    Assumed supply-cost factor
;
EQ_E2_1(i,z)$(not IELEC(i))..
 PC_HH(i,z) =e= (1+tth(i,z))*PC(i,z);
EQ_E2_2(b,z)..
 PC_HB(b,z) =e= (1+tth_B(b,z))*PC('18_ELEC',z);
* [T1] Dual CES cost index; at upper sigma=0 this is linear unit cost.
EQ_E2_3a(z)$(sigma_ToU1(z) <> 1)..
 PC_HS(z)**(1-sigma_ToU1(z)) =e=
 sum(BS,theta_BS(BS,z)*PC_HB(BS,z)**(1-sigma_ToU1(z)));
EQ_E2_3a_CD(z)$(sigma_ToU1(z) = 1)..
 log(PC_HS(z)) =e= sum(BS,theta_BS(BS,z)*log(PC_HB(BS,z)));
EQ_E2_3(z)$(sigma_ToU2(z) <> 1)..
 PC_HH('18_ELEC',z)**(1-sigma_ToU2(z)) =e=
 sum(BM,theta_MID(z)*PC_HB(BM,z)**(1-sigma_ToU2(z)))
 + theta_S(z)*PC_HS(z)**(1-sigma_ToU2(z));
EQ_E2_3_CD(z)$(sigma_ToU2(z) = 1)..
 log(PC_HH('18_ELEC',z)) =e=
 sum(BM,theta_MID(z)*log(PC_HB(BM,z))) + theta_S(z)*log(PC_HS(z));
* [T1,T2] Shephard demands. Total CGE electricity composite is endogenous.
EQ_E2_4a(z)..
 C_S(z) =e= C('18_ELEC',z)*theta_S(z)
 *(PC_HS(z)/PC_HH('18_ELEC',z))**(-sigma_ToU2(z));
EQ_E2_4b(BM,z)..
 C_B(BM,z) =e= C('18_ELEC',z)*theta_MID(z)
 *(PC_HB(BM,z)/PC_HH('18_ELEC',z))**(-sigma_ToU2(z));
EQ_E2_4(BS,z)..
 C_B(BS,z) =e= C_S(z)*theta_BS(BS,z)
 *(PC_HB(BS,z)/PC_HS(z))**(-sigma_ToU1(z));
* [T7] Quantity index C and physical sum differ: their difference is NOT EV
* or a separately identified engineering energy saving.
EQ_E2_5(z).. CE_PHYS(z) =e= sum(b,C_B(b,z));
* [T6] Signed revenue; negative values imply funding needs, not rebates.
* With non-electric wedges zero: PC_HH(elec)*C(elec)=PC(elec)*CE_PHYS+TIC_HH.
EQ_E2_6(z)..
 TIC_HH(z) =e= sum(b,tth_B(b,z)*PC('18_ELEC',z)*C_B(b,z))
 + sum(i$(not IELEC(i)),tth(i,z)*PC(i,z)*C(i,z));
EQ_E2_7(z).. RCY_POOL(z) =e= TIC_HH(z);
* This pool is NOT automatically routed to inherited CBAM RCY_IN.
* Equal-budget U/I/IC scenarios require explicit scenario financing/linkage.
EQ_E2_8(b,z)..
 tth_B(b,z) =e= (1+tth_B_raw(b,z))*(1+tou_shift(z))-1;
* [T6] Main specification e2_expost=0 fixes shift to zero.
EQ_E2_9(z)..
 e2_expost(z)*TIC_HH(z)+(1-e2_expost(z))*tou_shift(z) =e= 0;
* [T5] Reduced-form cost feedback retained; disable using TOU_COST_SCALE=0.
EQ_E2_10(z)..
 LSF(z) =e= 1+sum(b,delta_b(b,z)*(C_B(b,z)-C_BO(b,z)))
 /XSO_I('18_ELEC',z);
* Positive domains for fractional powers, divisions and logarithms [T1].

* TOU-only REN production-tax support. Released ttip is determined by this
* equation; the government cost is already recorded through lower TIP (EQ28).
* Do NOT subtract B_TOU_REN again from government savings.
EQUATION EQ_TOU_REN(j,z);
EQ_TOU_REN(j,z)$(tou_ren_target(j) and ACTIVE_J(j,z) and tou_ren_on(z))..
    (ttipO(j,z)-ttip(j,z))*PP(j,z)*XST(j,z)
    =e= tou_ren_share(j,z)*B_TOU_REN(z);
