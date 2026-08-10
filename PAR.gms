* ==============================================================================
* PAR.gms
* 파라미터 선언 + GTAP GDX 로드 + 외생가격 (원본 L189-531)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================

*==============================================================================
* 2 Declaration of parameters and benchmark variables
*==============================================================================
PARAMETER
*==============================================================================
* 2.1 Model Parameters (CES/CET/Leontief)
*==============================================================================
 A_K(z)              Scale parameter (price of new capital)
 aij(i,j,z)          Input-output coefficient for non-energy intermediates
 aij2(i,j,z)         Input-output coefficient for energy intermediates
 B_KD(j,z)           Scale parameter for composite capital (CES)
 B_LD(j,z)           Scale parameter for composite labor (CES)
 B_M1(i,z)           Scale parameter for composite commodity (CES)
 B_M2(i,z)           Scale parameter for composite import (CES)
 B_VA(j,z)           Scale parameter for value added (CES)
 B_KLE(j,z)          Scale parameter for KLE composite (CES)
 B_ENER(j,z)         Scale parameter for energy composite (CES)
 B_X1(i,z)           Scale parameter for total output transformation (CET)
 B_X2(i,z)           Scale parameter for composite export transformation (CET)
 B_X3(i,z)           Scale parameter for industry-commodity output (CES)
 B_X4(z)             Scale parameter for aggregated electricity (CES)
 beta_D_X1(i,z)      Share parameter (CET - total output - local sales)
 beta_EX_X1(i,z)     Share parameter (CET - total output - export)
 beta_X2(i,z,zj)     Share parameter (CET - composite export)
 beta_X3(j,i,z)      Share parameter (CES - top level)
 beta_X4(power, z)   Share parameter (CES - Aggregated Electricity)
 beta_KD(k,j,z)      Share parameter (CES - composite capital)
 beta_LD(l,j,z)      Share parameter (CES - composite labor)
 beta_M1(i,z)        Share parameter (CES - composite commodity)
 beta_M2(i,zj,z)     Share parameter (CES - composite import)
 beta_VA(j,z)        Share parameter (CES - value added)
 beta_KLE(j,z)       Share parameter (CES - KLE composite)
 beta_ENER(ene,j,z)  Share parameter (CES - ENER composite)
 delta(z)            Depreciation rate of capital
 eta                 Price elasticity of indexed transfers
 frisch(z)           Frisch parameter (Linear Expenditure System)
 gamma_GVT(i,z)      Share of commodity i in public expenditures
 gamma_INV(i,z)      Share of commodity i in total investment
 gamma_LES(i,z)      Marginal budget share in household consumption
 io(j,z)             Technical coefficient for total intermediate consumption
 io2(j,z)            Technical coefficient for total energy intermediate consumption
 v(j,z)              Value added coefficient (Leontief)
 v2(j,z)             KLE composite coefficient (Leontief)
 kmob                Capital mobility flag 
 RES                 Scaling factor for GTAP data
 rho_KD(j,z)         Elasticity parameter (CES - composite capital)
 rho_LD(j,z)         Elasticity parameter (CES - composite labor)
 rho_M1(i,z)         Elasticity parameter (CES - composite commodity)
 rho_M2(i,z)         Elasticity parameter (CES - composite import)
 rho_VA(j,z)         Elasticity parameter (CES - value added)
 rho_KLE(j,z)        Elasticity parameter (CES - KLE)
 rho_ENER(j,z)       Elasticity parameter (CES - ENER)
 rho_X1(i,z)         Elasticity parameter (CET - composite export)
 rho_X2(i,z)         Elasticity parameter (CET - composite export)
 rho_X3(i,z)         Elasticity parameter (CES - top level)
 rho_X4(z)           Elasticity parameter (CES - Aggregated Electricity)
 sigma_KD(j,z)       Substitution elasticity between capital types
 sigma_LD(j,z)       Substitution elasticity between labor types
 sigma_M1(i,z)       Substitution elasticity (Armington: domestic vs import)
 sigma_M2(i,z)       Substitution elasticity between import sources
 sigma_VA(j,z)       Substitution elasticity between labor and capital
 sigma_KLE(j,z)      Substitution elasticity between value-added and energy
 sigma_ENER(j,z)     Substitution elasticity within energy bundle
 sigma_X0(j,z)       Elasticity (CET - exports and local sales)
 sigma_X1(i,z)       Transformation elasticity (CET: local vs export)
 sigma_X2(i,z)       Transformation elasticity between export destinations
 sigma_X3(i,z)       Elasticity (CES - top level)
 sigma_X4(z)         Elasticity (CES - Aggregated Electricity)
 sigma_Y(i,z)        Income elasticity of household consumption
 tmrg(i,ij,zj,z)     Transport margin rate
 TnDShare(z)         Transmission & Distribution share in electricity
 PowerShare(z)       Generation share in electricity
 theta2(j,i,z)       Initial share of industry j in commodity i output

*==============================================================================
* 2.2 Benchmark Variables (Post-fixed with 'O' for Original)
*==============================================================================
* 2.2.1 Volume variables
*==============================================================================
 CABXO(z)            Current account balance of region z in terms of the international currency (pseudo-volume variable)
 CO(i,z)             Consumption of commodity i by households in region z
 CGO(i,z)            Public consumption of commodity i in region z
 CIO(j,z)            Total intermediate consumption of industry j in region z
 CEO(j,z)            Total energy intermediate consumption of industry j in region z
 CMINO(i,z)          Minimum consumption of commodity i by households in region z
 CTH_REALO(z)        Real household consumption in region z
 DDO(i,z)            Domestic demand for commodity i produced locally in region z
 DIO(i,j,z)          Intermediate consumption of commodity i by industry j in region z
 DEO(ene,j,z)        Intermediate energy consumption of commodity i by industry j in region z
 DITO(i,z)           Total intermediate demand of commodity i in region z
 DSO(j,i,z)          Supply of commodity i by sector j to the domestic market
 DSO_I(i,z)          Supply of commodity i to the domestic market of region z
 DSO_J(j,z)          Supply of activity j to the domestic market of region z
 EXO(i,z,zj)         Quantity of product i exported by country z to country zj
 EXTO(i,z)           Supply of composite commodity i by region z to the export market
 EXTTO(j,i,z)        Supply of activity j to the export market i of region z
 G_REALO(z)          Current real government expenditures on goods and services in region z
 GDP_BP_REALO(z)     Real GDP at basic prices
 GDP_MP_REALO(z)     Real GDP at market prices
 GDP_BP_W_REALO      Real World GDP at basic prices
 IMO(i,zj,z)         Quantity of product i imported by country z from country zj
 IMO2(zj,z)          Quantity of product i imported by country z from country zj
 IMTO(i,z)           Quantity demanded of composite imports of commodity i by region z
 INVO(i,z)           Final demand of commodity i for investment purposes (GFCF) in region z
 IT_REALO(z)         Real gross fixed capital formation
 KDO(k,j,z)          Demand for type k capital by industry j in region z
 KDCO(j,z)           Demand for composite capital by industry j in region z
 KSO(k,z)            Supply of type k capital in region z
 KSTO(z)             Total supply of capital in region z
 LDO(l,j,z)          Demand for type l labor by industry j in region z  
 LDCO(j,z)           Demand for composite labor by industry j in region z
 LSO(l,z)            Supply of type l labor in region z
 MRGNO(i,z)          Domestic production of commodity i in region z exported as international margin services
 POPO(z)             Population in 2019
 QO(i,z)             Quantity demanded of composite commodity i in region z
 VAO(j,z)            Value added of industry j in region z
 KLEO(j,z)           KLE of industry j in region z
 XSO_I(i,z)          Commodity i total production
 XSO(j,i,z)          Total output of industry j in region z
 XSTO(j,z)           Total output of industry j
 POWERQO(z)          Total power output in region z

*==============================================================================
* 2.2.2 Price variables
*==============================================================================
 eO(z)               Exchange rate (price of international currency in terms of region z local currency)
 PO(i,z)             Basic price of commodity i in region z
 PO2(j,i,z)          Basic price of industry j production of commodity i
 PO3(i,j,z)          Basic price of power industry j's production of commodity i
 PO4(i,j,z)          Basic energy commodity price of industry j's production of commodity i
 PPOWERO(z)          Basic price of composite power commodity in region z
 PIO(i,z)            Basic price of commodity i's output
 PTO(j,z)            Basic price of industry j's output
 PCO(i,z)            Purchaser price of composite commodity i (including all taxes and margins) in region z
 PCIO(j,z)           Intermediate consumption price index of industry j in region z
 PCEO(j,z)           Intermediate energy consumption price index of industry j in region z
 PDO(i,z)            Price of local product i sold on region z domestic market (including all taxes)
 PEO(i,z,zj)         Price received for commodity i exported to region zj by region z (excluding export taxes)
 PETO(i,z)           Border price of composite commodity i exported by region z
 PIXCONO(z)          Consumer price index in region z
 PIXGDPO(z)          GDP deflator in region z
 PIXGDP_WO           World GDP deflator
 PIXGVTO(z)          Public expenditures price index in region z
 PIXINVO(z)          Investment price index in region z
 PKO(z)              Price of new capital in region z
 PLO(i,z)            Price of local product i (excluding all taxes on products) in region z
 PMO(i,zj,z)         Price of commodity i imported by region z from region zj (including all taxes duties and margins)
 PMTO(i,z)           Price of composite commodity i imported by region z (including all taxes duties and margins)
 PPO(j,z)            Unit cost of industry j in region z including taxes directly related to the use of capital and labor but excluding other taxes on production
 PVAO(j,Z)           Price of industry j value added in region z (including taxes on production directly related to the use of capital and labor)
 PKLEO(j,z)          Price of industry j KLE in region z
 PWMO(i,zj,z)        World price of commodity i imported from country zj by region z (expressed in international currency)
 PWMGO(i)            World price of margin i (expressed in international currency)
 PWXO(i,z,zj)        World price of commodity i exported to country zj by region z (expressed in international currency)
 RO(k,j,z)           Rental rate of type k capital in industry j of region z
 RCO(j,z)            Rental rate of industry j composite capital in region z
 RKO(k,z)            Rental rate of type k capital in region z
 RTIO(k,j,z)         Rental rate paid by industry j for type k capital in region z including capital taxes
 WO(l,z)             Wage rate of type l labor in region z
 WCO(j,z)            Wage rate of industry j composite labor in region z
 WTIO(l,j,z)         Wage rate paid by industry j for type l labor in region including payroll taxes

*==============================================================================
* 2.2.3 Nominal (value) variables
*==============================================================================
 CABO(z)             Current account balance of region z
 CTHO(z)             Consumption budget of households in region z
 DEPO(z)             Amount of depreciation (capital consumption allowance) in region z
 GO(z)               Current government expenditures on goods and services in region z
 GDP_BPO(z)          Region z GDP at basic prices
 GDP_BP_WO           World GDP at basic prices
 GDP_FDO(z)          Region z GDP at purchasers prices from the perspective of final demand (expenditure)
 GDP_IBO(z)          Region z GDP at market prices (income-based)
 GDP_MPO(z)          Region z GDP at market prices (production)
 ITO(z)              Total investment expenditures in region z
 RKDO(k,j,z)         Type k capital income in industry j in region z
 SGO(z)              Government savings in region z
 SHO(z)              Household savings in region z
 SROWO(z)            Rest-of-the-world savings with respect to region z
 TDHO(z)             Household income taxes in region z
 TICO(i,z)           Government revenue from indirect taxes on commodity i in region z
 TICTO(z)            Total government receipts of indirect taxes on commodities in region z
 TIKO(k,j,z)         Government revenue from taxes on type k capital used by industry j in region z
 TIKTO(z)            Total government revenue from from taxes on capital in region z
 TIMO(i,zj,z)        Government revenue from duties on commodity i imported from region zj by region z
 TIMTO(z)            Total government revenue from import duties in region z
 TIPO(j,z)           Government revenue from taxes on industry j production in region z (excluding taxes directly related to the use of capital and labor)
 TIPTO(z)            Total government revenue from production taxes in region z (excluding taxes directly related to the use of capital and labor)
 TIWO(l,j,z)         Government revenue from payroll taxes on type l labor in industry j of region z
 TIWTO(z)            Total government revenue from payroll taxes in region z
 TIXO(i,z,zj)        Government revenue from export taxes on commodity i exported by region z to region zj
 TIXTO(z)            Total government revenue from export taxes in region z
 TPRCTSO(z)          Total government revenue from taxes on products and imports in region z
 TPRODNO(z)          Total government revenue from other taxes on production in region z
 YDHO(z)             Household disposable income in region z
 YGO(z)              Total government income in region z
 YHO(z)              Household total income in region z
 YHKO(z)             Household capital income in region z
 YHLO(z)             Household labor income in region z
 YROWO(z)            Rest-of-the-world total income from region z

*==============================================================================
* 2.2.4 Rates and intercepts
*==============================================================================
 sh0O(z)             Intercept (household savings)
 sh1O(z)             Slope (household savings)
 ttdh0O(z)           Intercept (household income tax)
 ttdh1O(z)           Slope (household income tax)
 tticO(i,z)          Tax rate on commodity i
 ttikO(k,j,z)        Tax rate on capital k used in industry j
 ttimO(i,zj,z)       Rate of taxes and duties on imports of commodity i from country zj
 ttipO(j,z)          Tax rate on the production of industry j
 ttiwO(l,j,z)        Tax rate on type l worker compensation in industry j
 ttixO(i,z,zj)       Export tax rate on exported commodity i
      
*==============================================================================
* 2.2.5 Utility Variable
*==============================================================================
 UUO(z)              Utility of region z
 epO(z)              Expenditure function of region z
 sigma_w(i,z)        Share parameter in utility function

*==============================================================================
* 2.2.6 Tax rebate 
*==============================================================================
 ttip_shareO(j,z)    Industry output share
 deltattipO(j,z)     Production tax reduction due to subsidies in industry j
 ttiw_shareO(l,j,z)  Labor share
 deltattiwO(l,j,z)   Labor tax reduction due to subsidies in industry j

*==============================================================================
* 2.2.7 CBAM 
*==============================================================================
 TCBAMO(z)           Total CBAM imposition of destination region z
 TMO(z)              Total taxes and duties on imports of destination region z
 ;

* ==============================================================================
* E2_Declare.gms  -- Essay 2 파라미터 및 변수 선언
* ==============================================================================

PARAMETERS
* --- 보정 파라미터 -------------------------------------------------------------
 theta_B(b,z)      Benchmark share of block b in household electricity
 sigma_ToU(z)      Elasticity of substitution across ToU load blocks
 tth_B0(b,z)       Benchmark household electricity wedge by block (=0)
 tth0(i,z)         Benchmark household consumption wedge (=0)
 tth_B_raw(b,z)    ToU wedge schedule before normalisation (exogenous shock)
 e2_expost(z)      1 if ex-post revenue neutrality is imposed on the ToU reform
 p_ToU(b,z)        ToU tariff schedule by block (won per kWh)
 p_bar(z)          Quantity-weighted mean of the ToU schedul
* --- 벤치마크 값 ---------------------------------------------------------------
 PC_HHO(i,z)       Benchmark household purchaser price of commodity i
 PC_HBO(b,z)       Benchmark household purchaser price of electricity block b
 C_BO(b,z)         Benchmark household electricity consumption by block
 CE_PHYSO(z)       Benchmark physical household electricity consumption

* --- 물리량 환산 ---------------------------------------------------------------
 EHI_ELEC(z)       ktoe of household electricity per unit of CGE value
 PKWH_O(z)         Benchmark implied household electricity price (value per ktoe)
;

VARIABLES
 PC_HH(i,z)        Household purchaser price of commodity i (incl. household wedge)
 PC_HB(b,z)        Household purchaser price of electricity in block b
 C_B(b,z)          Household electricity consumption in block b
 CE_PHYS(z)        Physical household electricity consumption (sum over blocks)
 tth(i,z)          Household consumption wedge on non-electricity commodity i
 tth_B(b,z)        Household consumption wedge on electricity block b
 TIC_HH(z)         Government revenue from the household consumption wedge
 RCY_POOL(z)       Total recyclable revenue pool in region z
 tou_shift(z)      Proportional shift applied to the ToU wedge schedule
;

PARAMETER
 theta_BS(b,z)     Share of block b within the lower (shiftable) nest
 theta_MID(z)      Share of the non-shiftable block in household electricity
 theta_S(z)        Share of the shiftable composite in household electricity
 sigma_ToU1(z)     Substitution elasticity within the lower nest (peak vs off)
 sigma_ToU2(z)     Substitution elasticity of the upper nest (mid vs composite)
 PC_HSO(z)         Benchmark price index of the shiftable composite
 C_SO(z)           Benchmark quantity of the shiftable composite
 delta_b(b,z)      Marginal supply cost premium of block b (relative to mean)
;

POSITIVE VARIABLES
 PC_HS(z)          CES price index of the shiftable electricity composite
 C_S(z)            CES quantity index of the shiftable electricity composite
;

POSITIVE VARIABLES PC_HH, PC_HB, C_B, CE_PHYS;

PARAMETER
 delta_b(b,z)      Marginal supply cost premium of block b (relative to mean)
 LSFO(z)           Benchmark load-shape cost factor (=1)
;

VARIABLES
 LSF(z)            Load-shape cost factor for electricity supplying industries
;
POSITIVE VARIABLE LSF;

Scalar
 Tiny small figure to avoid division by zero / 0.000000000001/ ;

*==============================================================================
* 3 Data
*==============================================================================
* 3.1 Data input from GTAP8.1
*==============================================================================
* 3.1.1 Reading data aggregated with DATA_AGG-2007.gms
*==============================================================================
$GDXIN Input_w-1\DATA_AGG_250804.gdx
$LOAD CO, CGO, DDO, DEPO, DIO, DSO, DSO_I, EXO, IMO, INVO, KSTO, LDO, MRGNO, XSO, XSO_I, XSTO, RKDO
$LOAD POPO, TDHO, TICO, TIKO, TIMO, TIPO, TIWO, TIXO, tmrg
$LOAD sigma_M1, sigma_M2, sigma_VA

display sigma_M1, sigma_M2, sigma_VA ;

sigma_M1('04_GAS',Z) = 6;

*==============================================================================
* 3.1.2 Rescaling the variables
*==============================================================================
* GTAP 8.1 data are in millions of (2004 and 2007) US dollars
* With RES = 10000, model results are in tens of billions (10G$)
RES = 10000;

* NOTE: In GTAP parlance, "agents' prices" are prices paid by buyers, and
* "market prices" are prices received by sellers.

CO(i,z)          = CO(i,z)/RES;
CGO(i,z)         = CGO(i,z)/RES;
DDO(i,z)         = DDO(i,z)/RES;
DEPO(z)          = DEPO(z)/RES;
DIO(i,j,z)       = DIO(i,j,z)/RES;
DSO(j,i,z)       = DSO(j,i,z)/RES;
DSO_I(i,z)       = DSO_I(i,z)/RES;
EXO(i,z,zj)      = EXO(i,z,zj)/RES;
IMO(i,z,zj)      = IMO(i,z,zj)/RES;
INVO(i,z)        = INVO(i,z)/RES;
KSTO(z)          = KSTO(z)/RES;
LDO(l,j,z)       = LDO(l,j,z)/RES;
MRGNO(i,z)       = MRGNO(i,z)/RES;
RKDO(k,j,z)      = RKDO(k,j,z)/RES;
TDHO(z)          = TDHO(z)/RES;
TICO(i,z)        = TICO(i,z)/RES;
TIKO(k,j,z)      = TIKO(k,j,z)/RES;
TIMO(i,z,zj)     = TIMO(i,z,zj)/RES;
TIPO(j,z)        = TIPO(j,z)/RES;
TIWO(l,j,z)      = TIWO(l,j,z)/RES;
TIXO(i,z,zj)     = TIXO(i,z,zj)/RES;
tmrg(i,ij,z,zj)  = tmrg(i,ij,z,zj)/RES;
XSO_I(i,z)       = XSO_I(i,z)/RES;
XSO(j,i,z)       = XSO(j,i,z)/RES;
XSTO(j,z)        = XSTO(j,z)/RES;

*==============================================================================
* 3.3 Exogenous prices and parameters
*==============================================================================
* Price elasticity (should be equal to one to verify homogeneity)
eta = 1;

*==============================================================================
* CES and CET elasticities
*==============================================================================
PARAMETER
 PARZ Parameter array for storing external parameter values;

*$CALL gdxxrw Input_w-1\VAL_PAR_250805.xls @Input_w-1\VAL_PAR_250805.txt trace=0 output=Input_w-1\VAL_PAR_250805.gdx
$GDXIN Input_w-1\VAL_PAR_250805.gdx
$LOAD sigma_KD, sigma_LD, sigma_KLE, sigma_X1, sigma_X2, sigma_X3, sigma_X0, sigma_y, PARZ

*------------------------------------------------------------------------------
 sigma_KD(j,z)   = 2*sigma_VA(j,z);
 sigma_M1('04_GAS',Z) = 6;
 sigma_M2('03_OIL',Z) = 2;
 sigma_M2('04_GAS',Z) = 2;
 sigma_X2(i,Z)  = 2;
 sigma_X4(z)    = 2;
 sigma_LD(j,z)   = 2*sigma_VA(j,z);

*------------------------------------------------------------------------------
* CES - composite KLE, KE, ENER
 sigma_KLE('10_PETROLCOAL',z)  = 0.9 ;
 sigma_ENER(j,z) = 0.9 ;

*------------------------------------------------------------------------------
* LES parameters - Frisch (선진국 기준으로 설정)
 frisch(Z) = -1.3;

*------------------------------------------------------------------------------
* Slopes of taxation functions
 ttdh0O(z)       = 0;

*------------------------------------------------------------------------------
* Exogenous Prices assigned to 1
 eO(z)           = 1;
 PEO(i,z,zj)     = 1;
 PLO(i,z)        = 1;
 PWMGO(i)        = 1;
 WO(l,z)         = 1;

*==============================================================================
* 4 Calibration
*==============================================================================
