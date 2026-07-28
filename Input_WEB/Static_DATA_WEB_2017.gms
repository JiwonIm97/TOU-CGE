$ontext
set z
/
 01_KOR   
 02_CHN   
 03_JPN   
 04_IND   
 05_RUS    
 06_USA    
 07_EU    
 08_OHI   
 09_OUMIC 
 10_OLMIC 
 11_OLI 
/

;

Set

j
/
 01_AGRICULT
 02_COAL
 03_OIL
 04_GAS
 05_MINING
 06_FOODPRO
 07_TEXTILES
 08_WOODPRO
 09_PAPERPRO
 10_PETROLCOAL
 11_CHEMICAL
 12_NONMET
 13_IRONSTL
 14_NONFERR
 15_MACHINE
 16_TRANSEQ
 17_OTHERIND
 18_TnD
 19_eCoal
 20_eGas
 21_eOil
 22_eNFs
 23_CONSTRUC
 24_LTRP
 25_WTRP
 26_ATRP
 27_SER
/
;
$offtext

Set flow, commodity

flow flow
/
f1_INDPROD      Production
f2_IMPORTS      Imports
f3_EXPORTS      Exports
f5_MARBUNK      International marine bunkers
f4_AVBUNK       International aviation bunkers
f6_STOCKCHA     Stock changes
f7_TES          Total energy supply
f8_TRANSFER     Transfers
f9_STATDIFF     Statistical differences
f10_TOTTRANF    Transformation process
f11_MAINELEC    Main activity producer electricity plants
f12_AUTOELEC    Autoproducer electricity plants
f13_MAINCHP     Main activity producer CHP plants
f14_AUTOCHP     Autoproducer CHP plants
f15_MAINHEAT    Main activity producer heat plants
f16_AUTOHEAT    Autoproducer heat plants
f17_THEAT       Heat pumps
f19_TBOILER     Electric boilers
f18_TELE        Chemical heat for electricity production
f20_TBLASTFUR   Blast furances
f21_TGASWKS     Gas works
f22_TCOKEOVS    Coke ovens
f23_TPATFUEL    Patent fuel plants
f24_TBKB        BKB peat briquettes
f25_TREFINER    Oil refineries
f26_TPETCHEM    Petrochemical plants
f27_TCOALLIQ    Coal liquefaction
f28_TGTL        Gas-to-liquids plants
f29_TBLENDGAS   For blened natural gas
f30_TCHARCOAL   Charocal production plants
f31_TNONSPEC    Non-specific transformation
f32_TOTENGY     Energy industry own use
f33_EMINES      Coal mines
f34_EOILGASEX   Oil and gas extraction
f35_EBLASTFUR   Blast furances
f36_EGASWKS     Gas works
f37_EBIOGAS     Gasfication plants for biogases
f38_ECOKEOVS    Coke ovens
f39_EPATFUEL    Patent fuel plants
f40_EBKB        BKB peat briquettes
f41_EREFINER    Oil refineries
f42_ECOALLIQ    Coal liquefaction plants
f43_ELNG        Liqefaction regasification plants
f44_EGTL        Gas to liquids plants
f45_EPOWERPLT   Own use in electricity CHP and heat plants
f46_EPUMPST     Pumped storage plants
f47_ENUC        Nuclear industry
f48_ECHARCOAL   Charcoal production plants
f49_ENONSPEC    Non specified
f50_DISTLOSS    Losses
f51_TFC         Total final consumption
f52_AGRICULT    Agriculture forestry
f53_FISHING     Fishing
f54_MINING      Mining and quarrying
f55_FOODPRO     Food and tobacco
f56_TEXTILES    Textile and leather
f57_WOODPRO     Wood and wood products
f58_PAPERPRO    Paper pulp and print
f59_CHEMICAL    Chemical and petrochemical
f60_NONMET      Non metallic minerals
f61_IRONSTL     Iron and steel
f62_NONFERR     Non ferrous metals
f63_MACHINE     Machinery
f64_TRANSEQ     Transport equipment
f65_INONSPEC    Industry not elsewhere specified
f66_CONSTRUC    Construction
f67_COMMPUB     Commerical and public services
f68_ONONSPEC    Final consumption not elsewhere specified
f69_RESIDENT    Residential
f70_ROAD        Road
f71_RAIL        Rail
f72_DOMESAIR    Domestic aviation
f73_DOMESNAV    Domestic navigation
f74_PIPELINE    Pipeline transport
f75_TRNONSPE    Transport not elsewhere
f76_NEMINING    Non energy use in mining and quarrying
f77_NEFOODPRO   Non energy use in food beverages tobacco
f78_NETEXTILES  Non energy use in textiles and leather
f79_NEWOODPRO   Non energy use in wood and wood products
f80_NEPAPERPRO  Non energy use in paper pulp and printing
f81_NECHEM      Non energy use in chemical petrochemical
f82_NENONMET    Non energy use in non metallic minerals
f83_NEIRONSTL   Non energy use in iron and steel
f84_NENONFERR   Non energy use in non ferrous metals
f85_NEMACHINE   Non energy use in machinery
f86_NETRANSEQ   Non energy use in transport equipment
f87_NEINONSPEC  Non energy use in non specified industry
f88_NECONSTRUC  Non energy use in construction
f89_NEOTHER     Non energy use in other residential commerical public services agriculture forestry and fishing
f90_NETRANS     Non energy use in transport
f91_TOTIND      Industry
f92_MANUFACT    Mnaufacturing
f93_TOTTRANS    Transport
f94_NONENUSE    Non energy use
f95_NEINTREN    Non energy use industry transformation energy
f96_NEIND       Non energy use in industry
f97_WORLDAV     World aviation bunkers
f98_WORLDMAR    World marine bunkers
f99_ELOUTPUT    Electrictiy output GWh
f100_ELMAINE    Electrictiy output GWh main activity producer electrictiy plants
f101_ELAUTOE    Electrictiy output GWh autoproducer electricity plants
f102_ELMAINC    Electrictiy output GWh main activty producer CHP plants
f103_ELAUTOC    Electrictiy output GWh autoproducer CHP plants
f104_HEATOUT    Heat output
f105_HEMAINC    Heat output main activity producer CHP plants
f106_HEAUTOC    Heat output autoproducer CHP plants
f107_HEMAINH    Heat output main activity producer heat plants
f108_HEAUTOH    Heat output autoproducer heat plants
/

product energy product
/
p1_HARDCOAL      Hard coal
p2_BROWN         Brown coal
p3_ANTCOAL       Anthracite
p4_COKCOAL       Coking coal
p5_BITCOAL       Other bittuminous coal
p6_SUBCOAL       Sub-bituminous coal
p7_LIGNITE       Lignite
p8_PATFUEL       Patent fuel
p9_OVENCOKE      Coke oven coke
p10_GASCOKE      Gas coke
p11_COALTAR      Coal tar
p12_BKB          Brown coal briquettes
p13_GASWKSGS     Gas works gas
p14_COKEOVGS     Coke oven gas
p15_BLFURGS      Blast furnace gas
p16_OGASES       Other recovered gases
p17_PEAT         Peat
p18_PEATPROD     Peat products
p19_OILSHALE     Oil shale and oil sands
p20_NATGAS       Natural gas
p21_CRNGFEED     Crude NGL feedstock
p22_CRUDEOIL     Curde oil
p23_NGL          Natural gas liquids
p24_REFFEEDS     Refinery feedstocks
p25_ADDITIVE     Addtitives blending components
p26_NONCRUDE     Other hydrocarbons
p27_REFINGAS     Refinery gas
p28_ETHANE       Ethane
p29_LPG          Liquefied petroleum gases(LPG)
p30_NONBIOGASO   Motor gasoline (excl. biofuels)
p31_AVGAS        Aviation gasoline
p32_JETGAS       Jet fuel Gasoline tpye
p33_NONBIOJETK   Jet fuel Kerosene type (excl. biofuels)
p34_OTHKERO      Kerosene
p35_NONBIODIES   Diesel oil (excl. biofuels)
p36_RESFUEL      Fuel oil
p37_NAPHTHA      Naphtha
p38_WHITESP      Solvent (White spirit and industrial sprit SBP)
p39_LUBRIC       Lubricants
p40_BITUMEN      Bitumen (Asphalt)
p41_PARWAX       Paraffin waxes
p42_PETCOKE      Petroleum coke
p43_ONONSPEC     Other oil products
p44_INDWASTE     Industrial waste
p45_MUNWASTER    Municipal waste(renewable)
p46_MUNWASTEN    Municipal waste(non-renewable)
p47_PRIMSBIO     Primary solid biofuels
p48_BIOGASES     Biogases
p49_BIOGASOL     Biogasoline
p50_BIODIESEL    Biodiesels
p51_BIOJETKERO   Bio jet kerosene
p52_OBIOLIQ      Other liquid biofuels
p53_RENEWNS      Non-specified primary biofuels and waste
p54_CHARCOAL     Charcoal
p55_NUCLEAR      Nuclear
p56_HYDRO        Hydro
p57_GEOTHERM     Geothermal
p58_SOLARPV      Solar photovaltaics
p59_SOLARTH      Solar thermal
p60_TIDE         Tide wave and ocean
p61_WIND         Wind
p62_OTHER        Other sources includes production not included elsewhere such as fuel cells
p63_ELECTR       Electricity
p64_HEAT         Heat
p65_HEATNS       Heat output from non-specified combustible fuels
p66_TOTAL        Total
p67_MANGAS       Elec heat output from non-specified manufactured gases
p68_MRENEW       Memo Renewable
/

*===========================Products Mapping====================================
p_coal(product)
/
p1_HARDCOAL      Hard coal
p2_BROWN         Brown coal
p3_ANTCOAL       Anthracite
p4_COKCOAL       Coking coal
p5_BITCOAL       Other bittuminous coal
p6_SUBCOAL       Sub-bituminous coal
p7_LIGNITE       Lignite
p8_PATFUEL       Patent fuel
*p9_OVENCOKE      Coke oven coke
*p10_GASCOKE      Gas coke
p11_COALTAR      Coal tar
p12_BKB          Brown coal briquettes
*p13_GASWKSGS     Gas works gas
*p14_COKEOVGS     Coke oven gas
p15_BLFURGS      Blast furnace gas
p16_OGASES       Other recovered gases
/

p_coal3(product)
/
p1_HARDCOAL      Hard coal
p2_BROWN         Brown coal
p3_ANTCOAL       Anthracite
p4_COKCOAL       Coking coal
p5_BITCOAL       Other bittuminous coal
p6_SUBCOAL       Sub-bituminous coal
p7_LIGNITE       Lignite
p8_PATFUEL       Patent fuel
p9_OVENCOKE      Coke oven coke
p10_GASCOKE      Gas coke
p11_COALTAR      Coal tar
p12_BKB          Brown coal briquettes
p13_GASWKSGS     Gas works gas
p14_COKEOVGS     Coke oven gas
p15_BLFURGS      Blast furnace gas
p16_OGASES       Other recovered gases
/

p_oil(product)
/
p22_CRUDEOIL     Curde oil
/

p_gasoil(product)
/
p20_NATGAS       Natural gas
p22_CRUDEOIL     Curde oil
/

p_gas(product)
/
p13_GASWKSGS     Gas works gas
p20_NATGAS       Natural gas
p23_NGL          Natural gas liquids
/

p_oilproduct(product)
/
p9_OVENCOKE      Coke oven coke
p10_GASCOKE      Gas coke
p14_COKEOVGS     Coke oven gas
p24_REFFEEDS     Refinery feedstocks
p27_REFINGAS     Refinery gas
p28_ETHANE       Ethane
p29_LPG          Liquefied petroleum gases(LPG)
p30_NONBIOGASO   Motor gasoline (excl. biofuels)
p31_AVGAS        Aviation gasoline
p32_JETGAS       Jet fuel Gasoline tpye
p33_NONBIOJETK   Jet fuel Kerosene type (excl. biofuels)
p34_OTHKERO      Kerosene
p35_NONBIODIES   Diesel oil (excl. biofuels)
p36_RESFUEL      Fuel oil
p37_NAPHTHA      Naphtha
p38_WHITESP      Solvent (White spirit and industrial sprit SBP)
p39_LUBRIC       Lubricants
p40_BITUMEN      Bitumen (Asphalt)
p41_PARWAX       Paraffin waxes
p42_PETCOKE      Petroleum coke
p43_ONONSPEC     Other oil products
/

p_liquid(p_oilproduct)
/
p29_LPG          Liquefied petroleum gases(LPG)
p30_NONBIOGASO   Motor gasoline (excl. biofuels)
p31_AVGAS        Aviation gasoline
p32_JETGAS       Jet fuel Gasoline tpye
p33_NONBIOJETK   Jet fuel Kerosene type (excl. biofuels)
p34_OTHKERO      Kerosene
p35_NONBIODIES   Diesel oil (excl. biofuels)
p36_RESFUEL      Fuel oil
/

p_oilproduct_feed(product)
/
p37_NAPHTHA      Naphtha
p38_WHITESP      Solvent (White spirit and industrial sprit SBP)
p39_LUBRIC       Lubricants
p40_BITUMEN      Bitumen (Asphalt)
p41_PARWAX       Paraffin waxes
p42_PETCOKE      Petroleum coke
p43_ONONSPEC     Other oil products
/

p_nuclear(product)
/
p55_NUCLEAR      Nuclear
/

p_solar(product)
/
p58_SOLARPV      Solar photovaltaics
p61_WIND      Solar thermal
/

p_wind(product)
/
p61_WIND         Wind
/

p_hydro(product)
/
p56_HYDRO        Hydro
/

p_elecother(product)
/
p44_INDWASTE     Industrial waste
p45_MUNWASTER    Municipal waste(renewable)
p46_MUNWASTEN    Municipal waste(non-renewable)
p47_PRIMSBIO     Primary solid biofuels
p48_BIOGASES     Biogases
p49_BIOGASOL     Biogasoline
p50_BIODIESEL    Biodiesels
p51_BIOJETKERO   Bio jet kerosene
p52_OBIOLIQ      Other liquid biofuels
p57_GEOTHERM     Geothermal
p60_TIDE         Tide wave and ocean
p62_OTHER        Other sources includes production not included elsewhere such as fuel cells
/

p_elecheat(product)
/
p63_ELECTR    Electricity
p64_HEAT      Heat
/

p_elec(product)
/
p63_ELECTR    Electricity
/

p_heat(product)
/
p64_HEAT      Heat
/

p_ftotal(product)
/
p1_HARDCOAL      Hard coal
p2_BROWN         Brown coal
p3_ANTCOAL       Anthracite
p4_COKCOAL       Coking coal
p5_BITCOAL       Other bittuminous coal
p6_SUBCOAL       Sub-bituminous coal
p7_LIGNITE       Lignite
p8_PATFUEL       Patent fuel
*p9_OVENCOKE      Coke oven coke
*p10_GASCOKE      Gas coke
*p11_COALTAR      Coal tar
p12_BKB          Brown coal briquettes
*p13_GASWKSGS     Gas works gas
*p14_COKEOVGS     Coke oven gas
*p15_BLFURGS      Blast furnace gas
*p16_OGASES       Other recovered gases

p13_GASWKSGS     Gas works gas
p20_NATGAS       Natural gas
p23_NGL          Natural gas liquids

p29_LPG          Liquefied petroleum gases(LPG)
p30_NONBIOGASO   Motor gasoline (excl. biofuels)
p31_AVGAS        Aviation gasoline
p32_JETGAS       Jet fuel Gasoline tpye
p33_NONBIOJETK   Jet fuel Kerosene type (excl. biofuels)
p34_OTHKERO      Kerosene
p35_NONBIODIES   Diesel oil (excl. biofuels)
p36_RESFUEL      Fuel oil

p63_ELECTR    Electricity
p64_HEAT      Heat

/

p_coal_agg(product)
/p3_ANTCOAL
p4_COKCOAL
p5_BITCOAL
p6_SUBCOAL
p7_LIGNITE
p8_PATFUEL
p9_OVENCOKE
p10_GASCOKE
p11_COALTAR
p12_BKB
p13_GASWKSGS
p14_COKEOVGS
p15_BLFURGS
p16_OGASES
/

p_natgas(product)
/p20_NATGAS
/

p_crudeoil(product)
/p22_CRUDEOIL
/

p_oilproduct_agg(product)
/
p23_NGL
p27_REFINGAS
p28_ETHANE
p29_LPG
p30_NONBIOGASO
p31_AVGAS
p33_NONBIOJETK
p34_OTHKERO
p35_NONBIODIES
p36_RESFUEL
p37_NAPHTHA
p38_WHITESP
p39_LUBRIC
p40_BITUMEN
p42_PETCOKE
p43_ONONSPEC
/




*===========================Flows Mapping====================================
f_balstfur(flow)
/
f20_TBLASTFUR   Blast furances
/

f_cokeoven(flow)
/
f22_TCOKEOVS    Coke ovens
/

f_eblastcoke(flow)
/
f35_EBLASTFUR   Blast furances
f38_ECOKEOVS    Coke ovens
/

f_tpetrochem(flow)
/
f26_TPETCHEM    Petrochemical plants
/

f_prod(flow)
/
f1_INDPROD      Production
/

f_agri(flow)
/
f52_AGRICULT    Agriculture forestry
f53_FISHING     Fishing
/

f_coa(flow)
/
f33_EMINES      Coal mines
/

f_oil(flow)
/
f34_EOILGASEX   Oil and gas extraction
/

f_gas(flow)
/
f21_TGASWKS     Gas works
f34_EOILGASEX   Oil and gas extraction
f36_EGASWKS     Gas works
/

f_mining(flow)
/
f54_MINING      Mining and quarrying
/

f_foodpro(flow)
/
f55_FOODPRO     Food and tobacco
/

f_textiles(flow)
/
f56_TEXTILES    Textile and leather
/

f_woodpro(flow)
/
f57_WOODPRO     Wood and wood products
/

f_paperpro(flow)
/
f58_PAPERPRO    Paper pulp and print
/

f_petrolcoal(flow)
/
*f20_TBLASTFUR   Blast furances
*f22_TCOKEOVS    Coke ovens
*f23_TPATFUEL    Patent fuel plants
*f24_TBKB        BKB peat briquettes
*f25_TREFINER    Oil refineries
*f26_TPETCHEM    Petrochemical plants
*f27_TCOALLIQ    Coal liquefaction
*f28_TGTL        Gas-to-liquids plants

*f33_EMINES      Coal mines
*f34_EOILGASEX   Oil and gas extraction
*f35_EBLASTFUR   Blast furances
*f36_EGASWKS     Gas works
*f37_EBIOGAS     Gasfication plants for biogases
*f38_ECOKEOVS    Coke ovens
*f39_EPATFUEL    Patent fuel plants
*f40_EBKB        BKB peat briquettes
f41_EREFINER    Oil refineries
f42_ECOALLIQ    Coal liquefaction plants
*f43_ELNG        Liqefaction regasification plants
*f44_EGTL        Gas to liquids plants
*f45_EPOWERPLT   Own use in electricity CHP and heat plants
*f46_EPUMPST     Pumped storage plants
*f47_ENUC        Nuclear industry
*f48_ECHARCOAL   Charcoal production plants
*f49_ENONSPEC    Non specified
*f50_DISTLOSS    Losses
/

*https://www.gtap.agecon.purdue.edu/databases/contribute/concordinfo.asp
*p_c Petroleum & Coke: manufacture of coke and refined petroleum products
*1910 Manufacture of coke oven products
*1920 Manufacture of refined petroleum products

f_chemical(flow)
/
f59_CHEMICAL    Chemical and petrochemical
/

f_nonmet(flow)
/
f60_NONMET      Non metallic minerals
/

f_ironstl(flow)
/
f61_IRONSTL     Iron and steel
/

f_nonferr(flow)
/
f62_NONFERR     Non ferrous metals
/

f_machine(flow)
/
f63_MACHINE     Machinery
/

f_transeq(flow)
/
f64_TRANSEQ     Transport equipment
/

f_otherind(flow)
/
f65_INONSPEC    Industry not elsewhere specified
/

f_elec(flow)
/
f11_MAINELEC    Main activity producer electricity plants
*f12_AUTOELEC    Autoproducer electricity plants
f13_MAINCHP     Main activity producer CHP plants
*f14_AUTOCHP     Autoproducer CHP plants
f15_MAINHEAT    Main activity producer heat plants
*f16_AUTOHEAT    Autoproducer heat plants
*f17_THEAT       Heat pumps
*f19_TBOILER     Electric boilers
*f45_EPOWERPLT   Own use in electricity CHP and heat plants
*f46_EPUMPST     Pumped storage plants
/

f_construc(flow)
/
f66_CONSTRUC    Construction
/

f_ser(flow)
/
f67_COMMPUB     Commerical and public services
f68_ONONSPEC    Final consumption not elsewhere specified
/

f_household(flow)
/
f69_RESIDENT    Residential
/

f_roadrail(flow)
/
f70_ROAD        Road
f71_RAIL        Rail
f74_PIPELINE    Pipeline transport
f75_TRNONSPE    Transport not elsewhere
/

f_domeair(flow)
/
f72_DOMESAIR    Domestic aviation
/

f_domewater(flow)
/
f73_DOMESNAV    Domestic navigation
/

*Non-energy
f_nemining(flow)
/
f76_NEMINING    Non energy use in mining and quarrying
/

f_nefoodpro(flow)
/
f77_NEFOODPRO   Non energy use in food beverages tobacco
/

f_netextiles(flow)
/
f78_NETEXTILES  Non energy use in textiles and leather
/

f_newoodpro(flow)
/
f79_NEWOODPRO   Non energy use in wood and wood products
/

f_nepaperpro(flow)
/
f80_NEPAPERPRO  Non energy use in paper pulp and printing
/

f_nechemical(flow)
/
f81_NECHEM      Non energy use in chemical petrochemical
/

f_nenonmet(flow)
/
f82_NENONMET    Non energy use in non metallic minerals
/

f_neironstl(flow)
/
f83_NEIRONSTL   Non energy use in iron and steel
/

f_nenonferr(flow)
/
f84_NENONFERR   Non energy use in non ferrous metals
/

f_nemachine(flow)
/
f85_NEMACHINE   Non energy use in machinery
/

f_netranseq(flow)
/
f86_NETRANSEQ   Non energy use in transport equipment
/

f_neotherind(flow)
/
f87_NEINONSPEC  Non energy use in non specified industry
/

f_neconstruc(flow)
/
f88_NECONSTRUC  Non energy use in construction
/

f_netransport(flow)
/
f90_NETRANS     Non energy use in transport
/

f_neother(flow)
/
f89_NEOTHER     Non energy use in other residential commerical public services agriculture forestry and fishing
/

f_elecoutput(flow)
/
f99_ELOUTPUT    Electrictiy output GWh
/

type
/
CO2EF,
CH4EF,
N2OEF,
Stored_rate
/

punit
/
physical
/


;

Alias(p_coal, p_coal2);
Alias(p_coal3, p_coal4);
Alias(p_gas, p_gas2);
Alias(p_oil, p_oil2);
Alias(p_oilproduct, p_oilproduct2);
Alias(p_elecheat, p_elecheat2);

*=== Import from Excel using GDX utilities
*Unit 2017 ktoe
Parameter
WEB_KOR(flow,product),
WEB_CHN(flow,product),
WEB_JPN(flow,product),
WEB_IND(flow,product),
WEB_RUS(flow,product),
WEB_USA(flow,product),
WEB_EU(flow,product),
WEB_OHI(flow,product),
WEB_OUMIC(flow,product),
WEB_OLMIC(flow,product),
WEB_OLI(flow,product),
GHGsEF(product,type) kgC per TJ,
physical_unit(product,punit)
;


$onText
$onEcho > Input_WEB/WEB_2017_250805.txt
par=WEB_KOR        rng=r1_KOR!A1:BQ109
par=WEB_CHN        rng=r2_CHN!A1:BQ109
par=WEB_JPN        rng=r3_JPN!A1:BQ109
par=WEB_IND        rng=r4_IND!A1:BQ109
par=WEB_RUS        rng=r5_RUS!A1:BQ109
par=WEB_USA        rng=r6_US!A1:BQ109
par=WEB_EU         rng=r7_EU!A1:BQ109
par=WEB_OHI        rng=r8_OHI!A1:BQ109
par=WEB_OUMIC      rng=r9_OUMIC!A1:BQ109
par=WEB_OLMIC      rng=r10_OLMIC!A1:BQ109
par=WEB_OLI        rng=r11_OLI!A1:BQ109
par=GHGsEF         rng=EF!A1:E69
par=physical_unit  rng=Physical_Unit!A1:B69
$offEcho
$offText

$call  gdxxrw Input_WEB/WEB_250805.xlsx @Input_WEB/WEB_2017_250805.txt trace=0 output=Input_WEB/WEB_250805.gdx
$gdxIn Input_WEB/WEB_250805.gdx
$load  WEB_KOR, WEB_CHN, WEB_JPN, WEB_IND, WEB_RUS, WEB_USA, WEB_EU, WEB_OHI, WEB_OUMIC, WEB_OLMIC, WEB_OLI, GHGsEF, physical_unit



Parameter WEB(flow,product,z);

WEB(flow,product,'01_KOR') =  WEB_KOR(flow,product);
WEB(flow,product,'02_CHN') =  WEB_CHN(flow,product);
WEB(flow,product,'03_JPN') =  WEB_JPN(flow,product);
WEB(flow,product,'04_IND') =  WEB_IND(flow,product);
WEB(flow,product,'05_RUS') =  WEB_RUS(flow,product);
WEB(flow,product,'06_USA') =  WEB_USA(flow,product);
WEB(flow,product,'07_EU')  =  WEB_EU(flow,product);
WEB(flow,product,'08_OHI') =  WEB_OHI(flow,product);
WEB(flow,product,'09_OUMIC') =  WEB_OUMIC(flow,product);
WEB(flow,product,'10_OLMIC') =  WEB_OLMIC(flow,product);
WEB(flow,product,'11_OLI')   =  WEB_OLI(flow,product);


execute_unload 'Input_WEB/DATA_WEB_250805.gdx';

*$exit

Parameter
 TCoke_Share(f_cokeoven,product,z)
 TBlast_Share(f_balstfur,product,z)
;



Parameter
 Coal_DIO(p_coal,j,z)            Intermediate consumption of coal products by industry j in region z
 Coal_CO(p_coal,z)               Household consumption of coal products in region z
 CoalR_DIO(p_coal,j,z)           Intermediate consumption ratio of coal products by industry j in region z
 CoalR_CO(p_coal,z)              Household consumption ratio of coal products in region z

 Gas_DIO(p_gas,j,z)              Intermediate consumption of gas products by industry j in region z
 Gas_CO(p_gas,z)                 Household consumption of gas products in region z
 GasR_DIO(p_gas,j,z)             Intermediate consumption ratio of gas products by industry j in region z
 GasR_CO(p_gas,z)                Household consumption ratio of gas products in region z

 Oil_DIO(p_oil,j,z)              Intermediate consumption of crudeoil by industry j in region z
 Oil_CO(p_oil,z)                 Household consumption of crudeoil in region z
 OilR_DIO(p_oil,j,z)             Intermediate consumption ratio of crudeoil by industry j in region z

 Oilp_DIO(p_oilproduct,j,z)      Intermediate consumption of petrolcoal by industry j in region z
 Oilp_CO(p_oilproduct,z)         Household consumption of petrolcoal products in region z
 OilpR_DIO(p_oilproduct,j,z)     Intermediate consumption ratio of petrolcoal products by industry j in region z
 OilpR_CO(p_oilproduct,z)        Household consumption ratio of petrolcoal products in region z

 Elec_DIO(p_elecheat,j,z)        Intermediate consumption of electricity by industry j in region z
 Elec_CO(p_elecheat,z)           Household consumption of electricity in region z
 ElecR_DIO(p_elecheat,j,z)       Intermediate consumption ratio of electricity by industry j in region z
 ElecR_CO(p_elecheat,z)          Household consumption ratio of electricity in region z

 NCoal_DIO(p_coal,j,z)           Intermediate consumption of non energy coal products by industry j in region z
 NCoalR_DIO(p_coal,j,z)          Intermediate consumption ratio of non energy coal products by industry j in region z

 NGas_DIO(p_gas,j,z)             Intermediate consumption of non energy gas products by industry j in region z
 NGasR_DIO(p_gas,j,z)            Intermediate consumption ratio of non energy gas products by industry j in region z

 NOil_DIO(p_oil,j,z)             Intermediate consumption of non energy oil by industry j in region z
 NOilR_DIO(p_oil,j,z)            Intermediate consumption ratio of non-energy oil by industry j in region z

 NOilp_DIO(p_oilproduct,j,z)     Intermediate consumption of non energy oilproducts by industry j in region z
 NOilpR_DIO(p_oilproduct,j,z)    Intermediate consumption ratio of non energy oilproducts by industry j in region z

 Coal_Total(p_coal,z)
 Gas_Total(p_gas,z)
 Oilp_Total(p_oilproduct,z)
 ELec_Total(p_elecheat,z)
 NCoal_Total(p_coal,z)
 NGas_Total(p_gas,z)
 NOilp_Total(p_oilproduct,z)


 ElecCoalGWh(j,z)    Coal Output GWh 
 ElecGasGWh(j,z)     Gas Output GWh 
 ElecOilGWh(j,z)     Oil Output GWh 
 ElecNFsGWh(j,z)
 
;
*

*f_balstfur(flow)
*f_cokeoven(flow)
* WEB(f_balstfur, 'p4_COKCOAL', z) = WEB(f_cokeoven, 'p66_TOTAL', z) ;
* WEB(f_cokeoven, 'p4_COKCOAL', z) = WEB(f_cokeoven, 'p66_TOTAL', z) ;

 TCoke_Share(f_cokeoven,p_coal,z)$(WEB(f_cokeoven, p_coal, z) lt 0)  = WEB(f_cokeoven, p_coal, z)$(WEB(f_cokeoven, p_coal, z) lt 0)/sum(p_coal2, WEB(f_cokeoven, p_coal2, z)$(WEB(f_cokeoven, p_coal2, z) lt 0)) ;
 TBlast_Share(f_balstfur,p_coal,z)$(WEB(f_balstfur, p_coal, z) lt 0) = WEB(f_balstfur, p_coal, z)$(WEB(f_balstfur, p_coal, z) lt 0)/sum(p_coal2, WEB(f_balstfur, p_coal2, z)$(WEB(f_balstfur, p_coal2, z) lt 0)) ;

display TCoke_Share, TBlast_Share ;

*Coal
 Coal_DIO(p_coal,'01_AGRICULT',z) = sum((f_agri), WEB(f_agri, p_coal, z));
 Coal_DIO(p_coal,'02_COAL',z) = -1*sum((f_coa), WEB(f_coa, p_coal, z));
 Coal_DIO(p_coal,'03_OIL',z) = -1*sum((f_oil), WEB(f_oil, p_coal, z));
 Coal_DIO(p_coal,'04_GAS',z) = -1*sum((f_gas), WEB(f_gas, p_coal, z));
 Coal_DIO(p_coal,'05_MINING',z) = sum((f_mining), WEB(f_mining, p_coal, z));
 Coal_DIO(p_coal,'06_FOODPRO',z) = sum((f_foodpro), WEB(f_foodpro, p_coal, z));
 Coal_DIO(p_coal,'07_TEXTILES',z) = sum((f_textiles), WEB(f_textiles, p_coal, z));
 Coal_DIO(p_coal,'08_WOODPRO',z) = sum((f_woodpro), WEB(f_woodpro, p_coal, z));
 Coal_DIO(p_coal,'09_PAPERPRO',z) = sum((f_paperpro), WEB(f_paperpro, p_coal, z));
 Coal_DIO(p_coal,'10_PETROLCOAL',z) = -1*sum((f_petrolcoal), WEB(f_petrolcoal, p_coal, z));
 Coal_DIO(p_coal,'11_CHEMICAL',z) = sum((f_chemical), WEB(f_chemical, p_coal, z));
 Coal_DIO(p_coal,'12_NONMET',z) = sum((f_nonmet), WEB(f_nonmet, p_coal, z));
 Coal_DIO(p_coal,'13_IRONSTL',z) = sum((f_ironstl), WEB(f_ironstl, p_coal, z))
 + sum(f_cokeoven, -1*TCoke_Share(f_cokeoven,p_coal,z)*WEB(f_cokeoven, 'p66_TOTAL', z))
 + sum(f_balstfur, -1*TBlast_Share(f_balstfur,p_coal,z)*WEB(f_balstfur, 'p66_TOTAL', z))
 + sum((f_Eblastcoke), -1*WEB(f_Eblastcoke, p_coal, z)) 
;

 Coal_DIO(p_coal,'14_NONFERR',z) = sum((f_nonferr), WEB(f_nonferr, p_coal, z));
 Coal_DIO(p_coal,'15_MACHINE',z) = sum((f_machine), WEB(f_machine, p_coal, z));
 Coal_DIO(p_coal,'16_TRANSEQ',z) = sum((f_transeq), WEB(f_transeq, p_coal, z));
 Coal_DIO(p_coal,'17_OTHERIND',z) = sum((f_otherind), WEB(f_otherind, p_coal, z));
 Coal_DIO(p_coal,'18_TnD',z) = 0 ;
 Coal_DIO(p_coal,'19_eCoal',z) = -1*sum((f_elec), WEB(f_elec, p_coal, z));
 Coal_DIO(p_coal,'20_eGas',z) = 0 ;
 Coal_DIO(p_coal,'21_eOil',z) = 0 ;
 Coal_DIO(p_coal,'22_eNFs',z) = 0 ;
 Coal_DIO(p_coal,'23_CONSTRUC',z) = sum((f_construc), WEB(f_construc, p_coal, z));
 Coal_DIO(p_coal,'24_LTRP',z) = sum((f_roadrail), WEB(f_roadrail, p_coal, z));
 Coal_DIO(p_coal,'25_WTRP',z) = sum((f_domewater), WEB(f_domewater, p_coal, z));
 Coal_DIO(p_coal,'26_ATRP',z) = sum((f_domeair), WEB(f_domeair, p_coal, z));
 Coal_DIO(p_coal,'27_SER',z) = sum((f_ser), WEB(f_ser, p_coal, z));
 Coal_CO(p_coal,z) = sum((f_household), WEB(f_household, p_coal, z));

*Ratio
Loop(j,
    CoalR_DIO(p_coal,j,z)$(Coal_DIO(p_coal,j,z) gt 0)
         = Coal_DIO(p_coal,j,z)/sum(p_coal2, Coal_DIO(p_coal2,j,z));
     );

 CoalR_CO(p_coal,z)$(Coal_CO(p_coal,z) gt 0)  = Coal_CO(p_coal,z)/ sum(p_coal2, Coal_CO(p_coal2,z));

display Coal_DIO, CoalR_DIO, CoalR_CO ;

*Gas
 Gas_DIO(p_gas,'01_AGRICULT',z) = sum((f_agri), WEB(f_agri, p_gas, z));
 Gas_DIO(p_gas,'02_COAL',z) = -1*sum((f_coa), WEB(f_coa, p_gas, z));
 Gas_DIO(p_gas,'03_OIL',z) = -1*sum((f_oil), WEB(f_oil, p_gas, z));
 Gas_DIO(p_gas,'04_GAS',z) = -1*sum((f_gas), WEB(f_gas, p_gas, z));
 Gas_DIO(p_gas,'05_MINING',z) = sum((f_mining), WEB(f_mining, p_gas, z));
 Gas_DIO(p_gas,'06_FOODPRO',z) = sum((f_foodpro), WEB(f_foodpro, p_gas, z));
 Gas_DIO(p_gas,'07_TEXTILES',z) = sum((f_textiles), WEB(f_textiles, p_gas, z));
 Gas_DIO(p_gas,'08_WOODPRO',z) = sum((f_woodpro), WEB(f_woodpro, p_gas, z));
 Gas_DIO(p_gas,'09_PAPERPRO',z) = sum((f_paperpro), WEB(f_paperpro, p_gas, z));
 Gas_DIO(p_gas,'10_PETROLCOAL',z) = -1*sum((f_petrolcoal), WEB(f_petrolcoal, p_gas, z));
 Gas_DIO(p_gas,'11_CHEMICAL',z) = sum((f_chemical), WEB(f_chemical, p_gas, z));
 Gas_DIO(p_gas,'12_NONMET',z) = sum((f_nonmet), WEB(f_nonmet, p_gas, z));
 Gas_DIO(p_gas,'13_IRONSTL',z) = sum((f_ironstl), WEB(f_ironstl, p_gas, z));
 Gas_DIO(p_gas,'14_NONFERR',z) = sum((f_nonferr), WEB(f_nonferr, p_gas, z));
 Gas_DIO(p_gas,'15_MACHINE',z) = sum((f_machine), WEB(f_machine, p_gas, z));
 Gas_DIO(p_gas,'16_TRANSEQ',z) = sum((f_transeq), WEB(f_transeq, p_gas, z));
 Gas_DIO(p_gas,'17_OTHERIND',z) = sum((f_otherind), WEB(f_otherind, p_gas, z));
 Gas_DIO(p_gas,'18_TnD',z) = 0 ;
 Gas_DIO(p_gas,'19_eCoal',z) = 0;
 Gas_DIO(p_gas,'20_eGas',z) = -1*sum((f_elec), WEB(f_elec, p_gas, z)) ;
 Gas_DIO(p_gas,'21_eOil',z) = 0 ;
 Gas_DIO(p_gas,'22_eNFs',z) = 0 ;
 Gas_DIO(p_gas,'23_CONSTRUC',z) = sum((f_construc), WEB(f_construc, p_gas, z));
 Gas_DIO(p_gas,'24_LTRP',z) = sum((f_roadrail), WEB(f_roadrail, p_gas, z));
 Gas_DIO(p_gas,'25_WTRP',z) = sum((f_domewater), WEB(f_domewater, p_gas, z));
 Gas_DIO(p_gas,'26_ATRP',z) = sum((f_domeair), WEB(f_domeair, p_gas, z));
 Gas_DIO(p_gas,'27_SER',z) = sum((f_ser), WEB(f_ser, p_gas, z));
 Gas_CO(p_gas,z) = sum((f_household), WEB(f_household, p_gas, z));

*Ratio
Loop(j,
    GasR_DIO(p_gas,j,z)$(Gas_DIO(p_gas,j,z) gt 0)
         = Gas_DIO(p_gas,j,z)/sum(p_gas2, Gas_DIO(p_gas2,j,z));
     );

 GasR_CO(p_gas,z)$(Gas_CO(p_gas,z) gt 0)  = Gas_CO(p_gas,z)/ sum(p_gas2, Gas_CO(p_gas2,z));


display Gas_DIO, GasR_DIO, GasR_CO ;

*Oil
 Oil_DIO(p_oil,'01_AGRICULT',z) = sum((f_agri), WEB(f_agri, p_oil, z));
 Oil_DIO(p_oil,'02_COAL',z) = -1*sum((f_coa), WEB(f_coa, p_oil, z));
 Oil_DIO(p_oil,'03_OIL',z) = -1*sum((f_oil), WEB(f_oil, p_oil, z));
 Oil_DIO(p_oil,'04_GAS',z) = -1*sum((f_gas), WEB(f_gas, p_oil, z));
 Oil_DIO(p_oil,'05_MINING',z) = sum((f_mining), WEB(f_mining, p_oil, z));
 Oil_DIO(p_oil,'06_FOODPRO',z) = sum((f_foodpro), WEB(f_foodpro, p_oil, z));
 Oil_DIO(p_oil,'07_TEXTILES',z) = sum((f_textiles), WEB(f_textiles, p_oil, z));
 Oil_DIO(p_oil,'08_WOODPRO',z) = sum((f_woodpro), WEB(f_woodpro, p_oil, z));
 Oil_DIO(p_oil,'09_PAPERPRO',z) = sum((f_paperpro), WEB(f_paperpro, p_oil, z));
 Oil_DIO(p_oil,'10_PETROLCOAL',z) = -1*sum((f_petrolcoal), WEB(f_petrolcoal, p_oil, z));
 Oil_DIO(p_oil,'11_CHEMICAL',z) = sum((f_chemical), WEB(f_chemical, p_oil, z));
 Oil_DIO(p_oil,'12_NONMET',z) = sum((f_nonmet), WEB(f_nonmet, p_oil, z));
 Oil_DIO(p_oil,'13_IRONSTL',z) = sum((f_ironstl), WEB(f_ironstl, p_oil, z));
 Oil_DIO(p_oil,'14_NONFERR',z) = sum((f_nonferr), WEB(f_nonferr, p_oil, z));
 Oil_DIO(p_oil,'15_MACHINE',z) = sum((f_machine), WEB(f_machine, p_oil, z));
 Oil_DIO(p_oil,'16_TRANSEQ',z) = sum((f_transeq), WEB(f_transeq, p_oil, z));
 Oil_DIO(p_oil,'17_OTHERIND',z) = sum((f_otherind), WEB(f_otherind, p_oil, z));
 Oil_DIO(p_oil,'18_TnD',z) = 0 ;
 Oil_DIO(p_oil,'19_eCoal',z) = 0 ;
 Oil_DIO(p_oil,'20_eGas',z) = 0 ;
 Oil_DIO(p_oil,'21_eOil',z) = 0 ;
 Oil_DIO(p_oil,'22_eNFs',z) = 0 ;
 Oil_DIO(p_oil,'23_CONSTRUC',z) = sum((f_construc), WEB(f_construc, p_oil, z));
 Oil_DIO(p_oil,'24_LTRP',z) = sum((f_roadrail), WEB(f_roadrail, p_oil, z));
 Oil_DIO(p_oil,'25_WTRP',z) = sum((f_domewater), WEB(f_domewater, p_oil, z));
 Oil_DIO(p_oil,'26_ATRP',z) = sum((f_domeair), WEB(f_domeair, p_oil, z));
 Oil_DIO(p_oil,'27_SER',z) = sum((f_ser), WEB(f_ser, p_oil, z));
 Oil_CO(p_oil,z) = sum((f_household), WEB(f_household, p_oil, z));

*Ratio
Loop(j,
    OilR_DIO(p_oil,j,z)$(Oil_DIO(p_oil,j,z) gt 0)
         = Oil_DIO(p_oil,j,z)/sum(p_oil2, Oil_DIO(p_oil2,j,z));
     );

display Oil_DIO, OilR_DIO ;

*Oilproducts
 Oilp_DIO(p_oilproduct,'01_AGRICULT',z) = sum((f_agri), WEB(f_agri, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'02_COAL',z) = -1*sum((f_coa), WEB(f_coa, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'03_OIL',z) = -1*sum((f_oil), WEB(f_oil, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'04_GAS',z) = -1*sum((f_gas), WEB(f_gas, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'05_MINING',z) = sum((f_mining), WEB(f_mining, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'06_FOODPRO',z) = sum((f_foodpro), WEB(f_foodpro, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'07_TEXTILES',z) = sum((f_textiles), WEB(f_textiles, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'08_WOODPRO',z) = sum((f_woodpro), WEB(f_woodpro, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'09_PAPERPRO',z) = sum((f_paperpro), WEB(f_paperpro, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'10_PETROLCOAL',z) = -1*sum((f_petrolcoal), WEB(f_petrolcoal, p_oilproduct, z));

 Oilp_DIO(p_oilproduct,'11_CHEMICAL',z) = sum((f_chemical), WEB(f_chemical, p_oilproduct, z))
* + sum(f_tpetrochem, -1*WEB(f_tpetrochem, p_oilproduct, z)$(WEB(f_tpetrochem, p_oilproduct, z) lt 0))
 ;

 Oilp_DIO(p_oilproduct,'12_NONMET',z) = sum((f_nonmet), WEB(f_nonmet, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'13_IRONSTL',z) = sum((f_ironstl), WEB(f_ironstl, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'14_NONFERR',z) = sum((f_nonferr), WEB(f_nonferr, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'15_MACHINE',z) = sum((f_machine), WEB(f_machine, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'16_TRANSEQ',z) = sum((f_transeq), WEB(f_transeq, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'17_OTHERIND',z) = sum((f_otherind), WEB(f_otherind, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'18_TnD',z) = 0 ;
 Oilp_DIO(p_oilproduct,'19_eCoal',z) = 0 ;
 Oilp_DIO(p_oilproduct,'20_eGas',z) = 0 ;
 Oilp_DIO(p_oilproduct,'21_eOil',z) = -1*sum((f_elec), WEB(f_elec, p_oilproduct, z)) ;
 Oilp_DIO(p_oilproduct,'22_eNFs',z) = 0 ;
 Oilp_DIO(p_oilproduct,'23_CONSTRUC',z) = sum((f_construc), WEB(f_construc, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'24_LTRP',z) = sum((f_roadrail), WEB(f_roadrail, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'25_WTRP',z) = sum((f_domewater), WEB(f_domewater, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'26_ATRP',z) = sum((f_domeair), WEB(f_domeair, p_oilproduct, z));
 Oilp_DIO(p_oilproduct,'27_SER',z) = sum((f_ser), WEB(f_ser, p_oilproduct, z));
 Oilp_CO(p_oilproduct,z) = sum((f_household), WEB(f_household, p_oilproduct, z));

*Ratio
Loop(j,
    OilpR_DIO(p_oilproduct,j,z)$(Oilp_DIO(p_oilproduct,j,z) gt 0)
         = Oilp_DIO(p_oilproduct,j,z)/sum(p_oilproduct2, Oilp_DIO(p_oilproduct2,j,z));
     );

 OilpR_CO(p_oilproduct,z)$(Oilp_CO(p_oilproduct,z) gt 0)  = Oilp_CO(p_oilproduct,z)/ sum(p_oilproduct2, Oilp_CO(p_oilproduct2,z));


display Oilp_DIO, Oilp_CO, OilpR_DIO, OilpR_CO ;

*Electricity/Heat
 Elec_DIO(p_elecheat,'01_AGRICULT',z) = sum((f_agri), WEB(f_agri, p_elecheat, z));
 Elec_DIO(p_elecheat,'02_COAL',z) = -1*sum((f_coa), WEB(f_coa, p_elecheat, z));
 Elec_DIO(p_elecheat,'03_OIL',z) = -1*sum((f_oil), WEB(f_oil, p_elecheat, z));
 Elec_DIO(p_elecheat,'04_GAS',z) = -1*sum((f_gas), WEB(f_gas, p_elecheat, z));
 Elec_DIO(p_elecheat,'05_MINING',z) = sum((f_mining), WEB(f_mining, p_elecheat, z));
 Elec_DIO(p_elecheat,'06_FOODPRO',z) = sum((f_foodpro), WEB(f_foodpro, p_elecheat, z));
 Elec_DIO(p_elecheat,'07_TEXTILES',z) = sum((f_textiles), WEB(f_textiles, p_elecheat, z));
 Elec_DIO(p_elecheat,'08_WOODPRO',z) = sum((f_woodpro), WEB(f_woodpro, p_elecheat, z));
 Elec_DIO(p_elecheat,'09_PAPERPRO',z) = sum((f_paperpro), WEB(f_paperpro, p_elecheat, z));
 Elec_DIO(p_elecheat,'10_PETROLCOAL',z) = -1*sum((f_petrolcoal), WEB(f_petrolcoal, p_elecheat, z));
 Elec_DIO(p_elecheat,'11_CHEMICAL',z) = sum((f_chemical), WEB(f_chemical, p_elecheat, z));
 Elec_DIO(p_elecheat,'12_NONMET',z) = sum((f_nonmet), WEB(f_nonmet, p_elecheat, z));
 Elec_DIO(p_elecheat,'13_IRONSTL',z) = sum((f_ironstl), WEB(f_ironstl, p_elecheat, z));
 Elec_DIO(p_elecheat,'14_NONFERR',z) = sum((f_nonferr), WEB(f_nonferr, p_elecheat, z));
 Elec_DIO(p_elecheat,'15_MACHINE',z) = sum((f_machine), WEB(f_machine, p_elecheat, z));
 Elec_DIO(p_elecheat,'16_TRANSEQ',z) = sum((f_transeq), WEB(f_transeq, p_elecheat, z));
 Elec_DIO(p_elecheat,'17_OTHERIND',z) = sum((f_otherind), WEB(f_otherind, p_elecheat, z));
 Elec_DIO(p_elecheat,'18_TnD',z) = 0 ;
 Elec_DIO(p_elecheat,'19_eCoal',z) = 0;
 Elec_DIO(p_elecheat,'20_eGas',z) = 0 ;
 Elec_DIO(p_elecheat,'21_eOil',z) = 0 ;
 Elec_DIO(p_elecheat,'22_eNFs',z) = 0 ;
 Elec_DIO(p_elecheat,'23_CONSTRUC',z) = sum((f_construc), WEB(f_construc, p_elecheat, z));
 Elec_DIO(p_elecheat,'24_LTRP',z) = sum((f_roadrail), WEB(f_roadrail, p_elecheat, z));
 Elec_DIO(p_elecheat,'25_WTRP',z) = sum((f_domewater), WEB(f_domewater, p_elecheat, z));
 Elec_DIO(p_elecheat,'26_ATRP',z) = sum((f_domeair), WEB(f_domeair, p_elecheat, z));
 Elec_DIO(p_elecheat,'27_SER',z) = sum((f_ser), WEB(f_ser, p_elecheat, z));
 Elec_CO(p_elecheat,z) = sum((f_household), WEB(f_household, p_elecheat, z));

*Ratio
Loop(j,
    ElecR_DIO(p_elecheat,j,z)$(Elec_DIO(p_elecheat,j,z) gt 0)
         = Elec_DIO(p_elecheat,j,z)/sum(p_elecheat2, Elec_DIO(p_elecheat2,j,z));
     );

 ElecR_CO(p_elecheat,z)$(Elec_CO(p_elecheat,z) gt 0)  = Elec_CO(p_elecheat,z)/ sum(p_elecheat2, Elec_CO(p_elecheat2,z));

display Elec_DIO, Elec_CO, ElecR_DIO, ElecR_CO ;

*Coal non-energy
 NCoal_DIO(p_coal,'05_MINING',z) = sum(f_nemining, WEB(f_nemining, p_coal, z));
 NCoal_DIO(p_coal,'06_FOODPRO',z) = sum(f_nefoodpro, WEB(f_nefoodpro, p_coal, z));
 NCoal_DIO(p_coal,'07_TEXTILES',z) = sum(f_netextiles, WEB(f_netextiles, p_coal, z));
 NCoal_DIO(p_coal,'08_WOODPRO',z) = sum(f_newoodpro, WEB(f_newoodpro, p_coal, z));
 NCoal_DIO(p_coal,'09_PAPERPRO',z) = sum(f_nepaperpro, WEB(f_nepaperpro, p_coal, z));
 NCoal_DIO(p_coal,'11_CHEMICAL',z) = sum(f_nechemical, WEB(f_nechemical, p_coal, z));
 NCoal_DIO(p_coal,'12_NONMET',z) = sum(f_nenonmet, WEB(f_nenonmet, p_coal, z));
 NCoal_DIO(p_coal,'13_IRONSTL',z) = sum(f_neironstl, WEB(f_neironstl, p_coal, z));
 NCoal_DIO(p_coal,'14_NONFERR',z) = sum(f_nenonferr, WEB(f_nenonferr, p_coal, z));
 NCoal_DIO(p_coal,'15_MACHINE',z) = sum(f_nemachine, WEB(f_nemachine, p_coal, z));
 NCoal_DIO(p_coal,'16_TRANSEQ',z) = sum(f_netranseq, WEB(f_netranseq, p_coal, z));
 NCoal_DIO(p_coal,'17_OTHERIND',z) = sum(f_neotherind, WEB(f_neotherind, p_coal, z));
 NCoal_DIO(p_coal,'23_CONSTRUC',z) = sum(f_neconstruc, WEB(f_neconstruc, p_coal, z));
 NCoal_DIO(p_coal,'24_LTRP',z) = sum(f_netransport, WEB(f_netransport, p_coal, z));
* NEC_DIO(p_coal,'29_WTRP',z) = sum((f_domewater), domewater_fne_coal(f_domewater, p_coal, z));
* NEC_DIO(p_coal,'30_ATRP',z) = sum((f_domeair), domeair_fne_coal(f_domeair, p_coal, z));
 NCoal_DIO(p_coal,'27_SER',z) = sum(f_neother, WEB(f_neother, p_coal, z));
* NEC_CO(p_coal,z) = sum((f_household), household_fne_coal(f_household, p_coal, z));

*Ratio
Loop(j,
    NCoalR_DIO(p_coal,j,z)$(NCoal_DIO(p_coal,j,z) gt 0)
         = NCoal_DIO(p_coal,j,z)/sum(p_coal2, NCoal_DIO(p_coal2,j,z));
     );

display NCoal_DIO, NCoalR_DIO ;

*Gas non-energy
 NGas_DIO(p_gas,'05_MINING',z) = sum(f_nemining, WEB(f_nemining, p_gas, z));
 NGas_DIO(p_gas,'06_FOODPRO',z) = sum(f_nefoodpro, WEB(f_nefoodpro, p_gas, z));
 NGas_DIO(p_gas,'07_TEXTILES',z) = sum(f_netextiles, WEB(f_netextiles, p_gas, z));
 NGas_DIO(p_gas,'08_WOODPRO',z) = sum(f_newoodpro, WEB(f_newoodpro, p_gas, z));
 NGas_DIO(p_gas,'09_PAPERPRO',z) = sum(f_nepaperpro, WEB(f_nepaperpro, p_gas, z));
 NGas_DIO(p_gas,'11_CHEMICAL',z) = sum(f_nechemical, WEB(f_nechemical, p_gas, z));
 NGas_DIO(p_gas,'12_NONMET',z) = sum(f_nenonmet, WEB(f_nenonmet, p_gas, z));
 NGas_DIO(p_gas,'13_IRONSTL',z) = sum(f_neironstl, WEB(f_neironstl, p_gas, z));
 NGas_DIO(p_gas,'14_NONFERR',z) = sum(f_nenonferr, WEB(f_nenonferr, p_gas, z));
 NGas_DIO(p_gas,'15_MACHINE',z) = sum(f_nemachine, WEB(f_nemachine, p_gas, z));
 NGas_DIO(p_gas,'16_TRANSEQ',z) = sum(f_netranseq, WEB(f_netranseq, p_gas, z));
 NGas_DIO(p_gas,'17_OTHERIND',z) = sum(f_neotherind, WEB(f_neotherind, p_gas, z));
 NGas_DIO(p_gas,'23_CONSTRUC',z) = sum(f_neconstruc, WEB(f_neconstruc, p_gas, z));
 NGas_DIO(p_gas,'24_LTRP',z) = sum(f_netransport, WEB(f_netransport, p_gas, z));
* NEG_DIO(p_gas,'29_WTRP',z) = sum((f_domewater), domewater_fne_gas(f_domewater, p_gas, z));
* NEG_DIO(p_gas,'30_ATRP',z) = sum((f_domeair), domeair_fne_gas(f_domeair, p_gas, z));
 NGas_DIO(p_gas,'27_SER',z) = sum(f_neother, WEB(f_neother, p_gas, z));
* NEG_CO(p_gas,z) = sum((f_household), household_fne_gas(f_household, p_gas, z));

*Ratio
Loop(j,
    NGasR_DIO(p_gas,j,z)$(NGas_DIO(p_gas,j,z) gt 0)
         = NGas_DIO(p_gas,j,z)/sum(p_gas2, NGas_DIO(p_gas2,j,z));
     );

display NGas_DIO, NGasR_DIO ;

*Oil non-energy
 NOil_DIO(p_oil,'05_MINING',z) = sum(f_nemining, WEB(f_nemining, p_oil, z));
 NOil_DIO(p_oil,'06_FOODPRO',z) = sum(f_nefoodpro, WEB(f_nefoodpro, p_oil, z));
 NOil_DIO(p_oil,'07_TEXTILES',z) = sum(f_netextiles, WEB(f_netextiles, p_oil, z));
 NOil_DIO(p_oil,'08_WOODPRO',z) = sum(f_newoodpro, WEB(f_newoodpro, p_oil, z));
 NOil_DIO(p_oil,'09_PAPERPRO',z) = sum(f_nepaperpro, WEB(f_nepaperpro, p_oil, z));
 NOil_DIO(p_oil,'11_CHEMICAL',z) = sum(f_nechemical, WEB(f_nechemical, p_oil, z));
 NOil_DIO(p_oil,'12_NONMET',z) = sum(f_nenonmet, WEB(f_nenonmet, p_oil, z));
 NOil_DIO(p_oil,'13_IRONSTL',z) = sum(f_neironstl, WEB(f_neironstl, p_oil, z));
 NOil_DIO(p_oil,'14_NONFERR',z) = sum(f_nenonferr, WEB(f_nenonferr, p_oil, z));
 NOil_DIO(p_oil,'15_MACHINE',z) = sum(f_nemachine, WEB(f_nemachine, p_oil, z));
 NOil_DIO(p_oil,'16_TRANSEQ',z) = sum(f_netranseq, WEB(f_netranseq, p_oil, z));
 NOil_DIO(p_oil,'17_OTHERIND',z) = sum(f_neotherind, WEB(f_neotherind, p_oil, z));
 NOil_DIO(p_oil,'23_CONSTRUC',z) = sum(f_neconstruc, WEB(f_neconstruc, p_oil, z));
 NOil_DIO(p_oil,'24_LTRP',z) = sum(f_netransport, WEB(f_netransport, p_oil, z));
* NEP_DIO(p_oil,'29_WTRP',z) = sum((f_domewater), domewater_fne_oilproduct(f_domewater, p_oilproduct, z));
* NEP_DIO(p_oil,'30_ATRP',z) = sum((f_domeair), domeair_fne_oilproduct(f_domeair, p_oilproduct, z));
 NOil_DIO(p_oil,'27_SER',z) = sum(f_neother, WEB(f_neother, p_oil, z) );
* NEP_CO(p_oillz) = sum((f_household), household_fne_oilproduct(f_household, p_oilproduct, z));

*Ratio
Loop(j,
    NOilR_DIO(p_oil,j,z)$(NOil_DIO(p_oil,j,z) gt 0)
         = NOil_DIO(p_oil,j,z)/sum(p_oil2, NOil_DIO(p_oil2,j,z));
     );

display NOil_DIO, NOilR_DIO ;

*Oilproducts non-energy
 NOilp_DIO(p_oilproduct,'05_MINING',z) = sum(f_nemining, WEB(f_nemining, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'06_FOODPRO',z) = sum(f_nefoodpro, WEB(f_nefoodpro, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'07_TEXTILES',z) = sum(f_netextiles, WEB(f_netextiles, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'08_WOODPRO',z) = sum(f_newoodpro, WEB(f_newoodpro, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'09_PAPERPRO',z) = sum(f_nepaperpro, WEB(f_nepaperpro, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'11_CHEMICAL',z) = sum(f_nechemical, WEB(f_nechemical, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'12_NONMET',z) = sum(f_nenonmet, WEB(f_nenonmet, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'13_IRONSTL',z) = sum(f_neironstl, WEB(f_neironstl, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'14_NONFERR',z) = sum(f_nenonferr, WEB(f_nenonferr, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'15_MACHINE',z) = sum(f_nemachine, WEB(f_nemachine, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'16_TRANSEQ',z) = sum(f_netranseq, WEB(f_netranseq, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'17_OTHERIND',z) = sum(f_neotherind, WEB(f_neotherind, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'23_CONSTRUC',z) = sum(f_neconstruc, WEB(f_neconstruc, p_oilproduct, z));
 NOilp_DIO(p_oilproduct,'24_LTRP',z) = sum(f_netransport, WEB(f_netransport, p_oilproduct, z));
* NEP_DIO(p_oilproduct,'29_WTRP',z) = sum((f_domewater), domewater_fne_oilproduct(f_domewater, p_oilproductproduct, z));
* NEP_DIO(p_oilproduct,'30_ATRP',z) = sum((f_domeair), domeair_fne_oilproduct(f_domeair, p_oilproductproduct, z));
 NOilp_DIO(p_oilproduct,'27_SER',z) = sum(f_neother, WEB(f_neother, p_oilproduct, z) );
* NEP_CO(p_oilproductlz) = sum((f_household), household_fne_oilproduct(f_household, p_oilproductproduct, z));

*Ratio
Loop(j,
    NOilpR_DIO(p_oilproduct,j,z)$(NOilp_DIO(p_oilproduct,j,z) gt 0)
         = NOilp_DIO(p_oilproduct,j,z)/sum(p_oilproduct2, NOilp_DIO(p_oilproduct2,j,z));
     );

display NOilp_DIO, NOilpR_DIO ;


 Coal_Total(p_coal,z) = sum(j,Coal_DIO(p_coal,j,z)) + Coal_CO(p_coal,z) ;
 Gas_Total(p_gas,z) = sum(j, Gas_DIO(p_gas,j,z)) + Gas_CO(p_gas,z) ;
 Oilp_Total(p_oilproduct,z) = sum(j, Oilp_DIO(p_oilproduct,j,z)) + Oilp_CO(p_oilproduct,z) ;
 ELec_Total(p_elecheat,z) = sum(j, ELec_DIO(p_elecheat,j,z)) + ELec_CO(p_elecheat,z) ;
 NCoal_Total(p_coal,z) = sum(j, NCoal_DIO(p_coal,j,z)) ;
 NGas_Total(p_gas,z) = sum(j, NGas_DIO(p_gas,j,z)) ;
 NOilp_Total(p_oilproduct,z) = sum(j, NOilp_DIO(p_oilproduct,j,z)) ;

*=============================Eelectricity============================================================

 ElecCoalGWh('19_eCoal',z)    = sum((f_elecoutput, p_coal), WEB(f_elecoutput, p_coal,z)); 
 ElecGasGWh('20_eGas',z)      = sum((f_elecoutput, p_gas), WEB(f_elecoutput, p_gas,z));             
 ElecOilGWh('21_eOil',z)      = sum((f_elecoutput, p_oilproduct), WEB(f_elecoutput, p_oilproduct,z));           
 ElecNFsGWh('22_eNFs',z)      = sum((f_elecoutput, p_nuclear), WEB(f_elecoutput, p_nuclear,z)) + sum((f_elecoutput, p_wind), WEB(f_elecoutput, p_wind,z))+ sum((f_elecoutput, p_solar), WEB(f_elecoutput, p_solar,z)) + sum((f_elecoutput, p_hydro), WEB(f_elecoutput, p_Hydro,z)) +  sum((f_elecoutput, p_elecother), WEB(f_elecoutput, p_elecother,z)); 


execute_unload 'Input_WEB/DATA_WEB_250805_2.gdx',
*Sets
product, p_coal, p_oil, p_oilproduct, p_gas, p_elecheat, flow, f_elec,  f_agri, f_mining, f_foodpro, f_textiles, f_woodpro,f_paperpro,
f_chemical, f_nonmet, f_ironstl, f_nonferr, f_machine, f_transeq, f_otherind,
f_construc, f_ser, f_household, f_roadrail, f_domeair,  f_domewater,
f_nemining, f_nefoodpro, f_netextiles, f_newoodpro, f_nepaperpro,
f_nechemical,f_nenonmet, f_neironstl, f_nenonferr, f_nemachine,
f_netranseq, f_neotherind, f_neconstruc, f_netransport, f_neother,

*WEB
WEB,
Coal_DIO, Coal_CO, CoalR_DIO, CoalR_CO,
Gas_DIO, Gas_CO, GasR_DIO, GasR_CO,
Oil_DIO, Oil_CO, OilR_DIO,
Oilp_DIO, Oilp_CO, OilpR_DIO, OilpR_CO,
Elec_DIO, Elec_CO, ElecR_DIO,ElecR_CO,
NCoal_DIO, NCoalR_DIO, NGas_DIO, NGasR_DIO,
NOil_DIO, NOilR_DIO, NOilp_DIO, NOilpR_DIO,

Coal_Total, Gas_Total, Oilp_Total, Elec_Total, NCoal_Total, NGas_Total, NOilp_Total,

ElecCoalGWh, ElecGasGWh, ElecOilGWh, ElecNFsGWh
;
*$exit

