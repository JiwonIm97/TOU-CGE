* ==============================================================================
* Declare_Results.gms
* 리포팅 파라미터 val* 선언 (원본 L1062-1221)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================



*Reporting
PARAMETER
 ElecTDI(z)                   Total electricity consumption in region z by all industries
 ElecRI(j,z)                  Share of electricity used by industry j in total electricity consumption in region z
 valCO2INDI(product,j,z,sim)  Indirect CO2 emission by product for energy use industry j in region z (KtCO2 per $1)
 valCO2INDNE(product,j,z,sim) Indirect CO2 emission by product for non energy use industry j in region z
 valCO2INDI2(j,z,sim)         Indirect CO2 emission for energy use industry j in region z
 valCO2INDNE2(j,z,sim)        Indirect CO2 emission for non energy use industry j in region z
 valTCO2INDI(z,sim)           Indirect CO2 emission for energy use industry in region z
 valTCO2INDNE(z,sim)          Indirect CO2 emission for non energy use industry in region z
 valCO2C(j,z,sim)             Carbon content of industry j in region z  
 valTFC_com(product,z,sim)    Total final consumption by energy commodities
 valTFC_ind(j,z,sim)          Total final consumption by industry
 valTFC(z,sim)                Total final consumption in region z
 valEE(product,j,z,sim)       Reporting variable for Industry energy consumption
 valNE(product,j,z,sim)       Reporting variable for Industry non energy consumption
 valEH(product,z,sim)         Reporting variable for Household energy consumption
 valCO2I(product,j,z,sim)     Reporting variable for Industry CO2 emission
 valCO2NE(product,j,z,sim)    Reporting variable for Industry CO2 non-energy emission
 valCO2H(product,z,sim)       Reporting variable for Household CO2 emission
 valCH4I(product,j,z,sim)     Reporting variable for Industry CH4 emission
 valCH4H(product,z,sim)       Reporting variable for Household CH4 emission
 valN2OI(product,j,z,sim)     Reporting variable for Industry N2O emission
 valN2OH(product,z,sim)       Reporting variable for Household N2O emission
 valCO2I2(j,z,sim)            Reporting variable for Total industry CO2 emission
 valCO2NE2(j,z,sim)           Reporting variable for Total industry CO2 non-energy emission
 valTCO2I(z,sim)              Reporting variable for Total regional industry CO2
 valTCO2NE(z,sim)             Reporting variable for Total regional industry CO2 non-energy
 valTCO2H(z,sim)              Reporting variable for Total regional household CO2
 valTCO2(z,sim)               Reporting variable for Total regional CO2
 valGDP_BP(z,sim)             Reporting variable for GDP basic prices
 valGDP_BP_REAL(z,sim)        Real GDP at basic prices
 valPIXGDP(z,sim)             GDP deflator in region z
 valCTAX(z,sim)               Reporting variable for carbon tax
 valCP(z,sim)                 Reporting variable for carbon price disparity
 valTCTAX(z,sim)              Reporting variable for total carbon tax
 valPC(i,z,sim)               Purchaser price of composite commodity i (including all taxes and margins) in region z
 valSH(z,sim)                 Household savings in region z
 valPOWER(power,i,z,sim)      Reporting variable for power output
 valKOR_TFC(product,sim)      Reporting variable for Korea Total Final Consumption
 valKLE(j,z,sim)              Value added of industry j in region z
 valTCO22(j,z,sim)            Reporting variable for aggregate CO2
 valTCBAM(z,sim)              Reporting variable for total CBAM
 valC(i,z,sim)                Consumption of commodity i by households in region z
 valCAB(z,sim)                Current account balance of region z
 valCABX(z,sim)               Current account balance of region z in terms of the international currency
 valCG(i,z,sim)               Public consumption of commodity i in region z
 valCI(j,z,sim)               Total intermediate consumption of industry j in region z
 valCE(j,z,sim)               Total intermediate energy consumption of industry j in region z
 valCMIN(i,z,sim)             Minimum consumption of commodity i by households in region z
 valCTH(z,sim)                Consumption budget of households in region z
 valCTH_REAL(z,sim)           Real household consumption in region z
 valDD(i,z,sim)               Domestic demand for commodity i produced locally in region z
 valDEP(z,sim)                Amount of depreciation (capital consumption allowance) in region z
 valDI(nene,j,z,sim)          Intermediate consumption of commodity i by industry j in region z
 valDE(ene,j,z,sim)           Intermediate energy consumption of commodity i by industry j in region z
 valDIT(i,z,sim)              Total intermediate demand of commodity i in region z
 valDS(j,i,z,sim)             Supply of commodity i by sector j to the domestic market in region z
 valDS_I(i,z,sim)             Supply of commodity i to the domestic market of region z
 vale(z,sim)                  Exchange rate (price of international currency in terms of region z local currency)
 valEX(i,z,zj,sim)            Quantity of product i exported by country z to country zj
 valEXT(i,z,sim)              Supply of composite commodity i by region z to the export market
 valG(z,sim)                  Current government expenditures on goods and services in region z
 valG_REAL(z,sim)             Current real government expenditures on goods and services in region z
 valGDP_BP_W(sim)             World GDP at basic prices
 valGDP_BP_W_REAL(sim)        Real world GDP at basic prices
 valGDP_FD(z,sim)             Region z GDP at purchasers prices from the perspective of final demand
 valGDP_IB(z,sim)             Region z GDP at market prices (income-based)
 valGDP_MP(z,sim)             Region z GDP at market prices
 valGDP_MP_REAL(z,sim)        Real GDP at market prices
 valIM(i,zj,z,sim)            Quantity of product i imported by country z from country zj
 valIMT(i,z,sim)              Quantity demanded of composite imports of commodity i by region z
 valINV(i,z,sim)              Final demand of commodity i for investment purposes (GFCF) in region z
 valIT(z,sim)                 Total investment expenditures in region z
 valIT_REAL(z,sim)            Real gross fixed capital formation
 valKD(k,j,z,sim)             Demand for type k capital by industry j in region z
 valKDC(j,z,sim)              Demand for composite capital by industry j in region z
 valKS(k,z,sim)               Supply of type k capital in region z
 valLD(l,j,z,sim)             Demand for type l labor by industry j in region z
 valLDC(j,z,sim)              Demand for composite labor by industry j in region z
 valLS(l,z,sim)               Supply of type l labor in region z
 valMRGN(i,z,sim)             Domestic production of commodity i in region z exported as international margin services
 valP(i,z,sim)                Basic price of commodity i production in region z
 valPT(j,z,sim)               Basic price of industry j production in region z
 valP2(j,i,z,sim)             Basic price of industry j's production of commodity i
 valP4(ene,j,z,sim)           Intermediate energy price by industry j in region z
 valPCI(j,z,sim)              Intermediate consumption price index of industry j in region z
 valPCE(j,z,sim)              Intermediate energy consumption price index of industry j in region z
 valPD(i,z,sim)               Price of local product i sold on region z domestic market (including all taxes)
 valPE(i,z,zj,sim)            Price received for commodity i exported to region zj by region z (excluding export taxes)
 valPET(i,z,sim)              Border price of composite commodity i exported by region z
 valPIXCON(z,sim)             Consumer price index in region z
 valPIXGDP_W(sim)             World GDP deflator
 valPIXGVT(z,sim)             Public expenditures price index in region z
 valPIXINV(z,sim)             Investment price index in region z
 valPK(z,sim)                 Price of new capital in region z
 valPL(i,z,sim)               Price of local product i (excluding all taxes on products) in region z
 valPM(i,zj,z,sim)            Price of commodity i imported by region z from region zj (including all taxes duties and margins)
 valPMT(i,z,sim)              Price of composite commodity i imported by region z (including all taxes duties and margins)
 valPP(j,z,sim)               Unit cost of industry j in region z including taxes directly related to the use of capital and labor but excluding other taxes on production
 valPVA(j,z,sim)              Price of industry j value added in region z (including taxes on production directly related to the use of capital and labor)
 valPKLE(j,z,sim)             Price of industry j KLE in region z 
 valPWM(i,zj,z,sim)           World price of commodity i imported from country zj by region z (expressed in international currency)
 valPWMG(i,sim)               World price of margin i (expressed in international currency)
 valPWX(i,z,zj,sim)           World price of commodity i exported to country zj by region z (expressed in international currency)
 valQ(i,z,sim)                Quantity demanded of composite commodity i in region z
 valR(k,j,z,sim)              Rental rate of type k capital in industry j of region z
 valRC(j,z,sim)               Rental rate of industry j composite capital in region z
 valRK(k,z,sim)               Rental rate of type k capital in region z
 valRTI(k,j,z,sim)            Rental rate paid by industry j for type k capital in region z including capital taxes
 valSG(z,sim)                 Government savings in region z
 valsh0(z,sim)                Intercept (household savings)
 valsh1(z,sim)                Slope (household savings)
 valSROW(z,sim)               Rest-of-the-world savings with respect to region z
 valTDH(z,sim)                Household income taxes in region z
 valTIC(i,z,sim)              Government revenue from indirect taxes on commodity i in region z
 valTICT(z,sim)               Total government receipts of indirect taxes on commodities in region z
 valTIK(k,j,z,sim)            Government revenue from taxes on type k capital used by industry j in region z
 valTIKT(z,sim)               Total government revenue from from taxes on capital in region z
 valTIM(i,zj,z,sim)           Government revenue from duties on commodity i imported from region zj by region z
 valTIMT(z,sim)               Total government revenue from import duties in region z
 valTIP(j,z,sim)              Government revenue from taxes on industry j production in region z (excluding taxes directly related to the use of capital and labor)
 valTIPT(z,sim)               Total government revenue from production taxes in region z (excluding taxes directly related to the use of capital and labor)
 valTIW(l,j,z,sim)            Government revenue from payroll taxes on type l labor in industry j of region z
 valTIWT(z,sim)               Total government revenue from payroll taxes in region z
 valTIX(i,z,zj,sim)           Government revenue from export taxes on commodity i exported by region z to region zj
 valTIXT(z,sim)               Total government revenue from export taxes in region z
 valTPRCTS(z,sim)             Total government revenue from taxes on products and imports in region z
 valTPRODN(z,sim)             Total government revenue from other taxes on production in region z
 valttdh0(z,sim)              Intercept (household income tax)
 valttdh1(z,sim)              Slope (household income tax)
 valttic(i,z,sim)             Tax rate on commodity i
 valttik(k,j,z,sim)           Tax rate on capital k used in industry j
 valttim(i,zj,z,sim)          Rate of taxes and duties on imports of commodity i from country zj
 valttip(j,z,sim)             Tax rate on the production of industry j
 valttiw(l,j,z,sim)           Tax rate on type l worker compensation in industry j
 valttix(i,z,zj,sim)          Export tax rate on exported commodity i
 valVA(j,z,sim)               Value added of industry j in region z
 valW(l,z,sim)                Wage rate of type l labor in region z
 valWC(j,z,sim)               Wage rate of industry j composite labor in region z
 valWTI(l,j,z,sim)            Wage rate paid z by industry j for type l labor in region including payroll taxes
 valXS(j,i,z,sim)             Total output of industry j by commodity i in region z
 valXS_I(i,z,sim)             Total output of commodity i in region z
 valXST(j,z,sim)              Total output of industry j in region z
 valYDH(z,sim)                Household disposable income in region z
 valYG(z,sim)                 Total government income in region z
 valYH(z,sim)                 Household total income in region z
 valYHK(z,sim)                Household capital income in region z
 valYHL(z,sim)                Household labor income in region z
 valYROW(z,sim)               Rest-of-the-world total income from region z
 valEV(z,sim)                 Equivalent variation of region z
 valgamma_LES(i,z,sim)        Reporting variable for gamma_LES
 valLEON(z,sim)               Reporting variable for Walras law verification (LEON)
;
*$EXIT

* ==============================================================================
* Results_format/E2_Declare_Results.gms
* Essay 2 리포팅 파라미터 선언
* Results_format/Declare_Results.gms 직후에 include
* ==============================================================================

PARAMETER
* --- 원시 결과 ----------------------------------------------------------------
 valPC_HH(i,z,sim)      Household purchaser price of commodity i
 valPC_HB(b,z,sim)      Household purchaser price of electricity block b
 valC_B(b,z,sim)        Household electricity consumption by block
 valCE_PHYS(z,sim)      Physical household electricity consumption
 valTIC_HH(z,sim)       Household consumption wedge revenue
 valRCY_POOL(z,sim)     Recyclable revenue pool
 valtth_B(b,z,sim)      Household electricity wedge by block
 valTIC_HH(z,sim)
 valtou_shift(z,sim)

* --- 파생 지표 ----------------------------------------------------------------
 E2_LOAD(b,z,sim)       Household electricity load by block in ktoe
 E2_LOAD_TOT(z,sim)     Total household electricity load in ktoe
 E2_SHARE(b,z,sim)      Block share of household electricity load
 E2_SHIFT(b,z,sim)      Change in block load versus benchmark in ktoe
 E2_CESGAP(z,sim)       CES index minus physical load (demand-side resource saving)
 E2_BILL(z,sim)         Household electricity bill (purchaser value)
 E2_EV(z,sim)           Equivalent variation based on household purchaser prices
 E2_RESCOST(z,sim)      Change in supply-side resource cost from load shifting
 E2_WELF(z,sim)         Total welfare change (EV + resource cost)
 E2_LSF(z,sim)     
 E2_PELEC(z,sim)  

* --- CGE-micro 연계 전달 벡터 (마이크로시뮬레이션 입력) -------------------------
 E2_LINK_PB(b,z,sim)    Relative price change of block b versus benchmark
 E2_LINK_PNE(i,z,sim)   Relative price change of non-electricity commodity i
 E2_LINK_W(l,z,sim)     Relative change in wage of labor category l
 E2_LINK_R(k,z,sim)     Relative change in return to capital k
 E2_LINK_TR(z,sim)      Lump-sum transfer received by households
 E2_LINK_CPI(z,sim)     Consumer price index
;
