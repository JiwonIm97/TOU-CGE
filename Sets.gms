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
* ==============================================================================
* Sets.gms
* 집합 선언 및 CBAM 지역/부문 매핑 (원본 L1-188)
* CBAM - modular refactor of 1_Static_Model_GTAP11b_BASE.gms
* ==============================================================================

$TITLE    TOU-CGE GTAP12 / WEB2023
$STITLE   World wide model, static version, April 2026
*==============================================================================*
* *
* Except where otherwise noted, this work is licensed under                   *
* http://creativecommons.org/licenses/by-nc-sa/3.0/                           *
* *
* You are free to share, to copy, distribute and transmit the work under      *
* the following conditions:                                                   *
* *
* - Attribution:         You must attribute the work to:                      *
* Veronique Robichaud, Andre Lemelin,                  *
* Helene Maisonnave and Bernard Decaluwe.              * * *
* - Modified and Developed by: Jiwon Im and Jintae Kim                        *
* *
* - Noncommercial:       You may not use this work for commercial purposes.   *
* - Share Alike:         If you alter, transform, or build upon this work,    *
* you may distribute the resulting work only under     *
* the same or similar license to this one.             *
* *
*==============================================================================*

*==============================================================================
* 1 Set definition
*==============================================================================

SET
 J               All industries
 I               All commodities
 I1(I)           All commodities except agriculture (agr)
 BUS(J)          Private industries
 PUB(J)          Public industries
 F               Production factors
 L(F)            Labor categories
 K(F)            Capital categories
 Z               Regions
 ZR(Z)           Reference country (USA) 
 Z1(Z)           All regions except reference region
 Zrich(Z)        Rich regions
 Zother(Z)       Non-rich regions
 sim             Simulation loop index
 ;
 
$GDXIN Input_w-1/DATA_AGG_GTAP12.gdx
$LOAD J I F Z
$LOADDC I1 BUS PUB L K ZR Z1 Zrich Zother
$GDXIN

SET
 TND(J) Transmission and Distribution
 / 18_TnD /

 POWER(J) Power industries aggregated
 / 19_eCoal       Coal generation
   20_eGas        Gas generation
   21_eOil        Oil generation
   22_eNUC        Nuclear generation
   23_eREN        Renewable and other generation /

 I2(I) Non-electricity commodities
 / 01_AGRICULT    Agricultural forest and fishery goods
   02_COAL        Coal
   03_OIL         Crude petroleum
   04_GAS         Natural gas Gas distribution
   05_MINING      Mined and quarried goods
   06_FOODPRO     Food beverages and tobacco products
   07_TEXTILES    Textile and leather products
   08_WOODPRO     Wood products
   09_PAPERPRO    Paper products
   10_PETROLCOAL  Petroleum and coal products
   11_CHEMICAL    Chemical products
   12_NONMET      Non-metallic mineral products
   13_IRONSTL     Primary iron and steel products 
   14_NONFERR     Non-ferrous metal products
   15_MACHINE     Fabricated metal products electronics and machinery
   16_TRANSEQ     Motor vehicles and transport equipment
   17_OTHERIND    Other manufactured products and water supply
   19_CONSTRUC    Construction
   20_LTRP        Land transport service (road rail)
   21_WTRP        Water transport service
   22_ATRP        Air transport service
   23_SER         Service /

 I3(I) Non-CBAM commodities
 / 01_AGRICULT, 02_COAL, 03_OIL, 04_GAS, 05_MINING, 06_FOODPRO, 
   07_TEXTILES, 08_WOODPRO, 09_PAPERPRO, 10_PETROLCOAL,
   15_MACHINE, 16_TRANSEQ, 17_OTHERIND, 18_ELEC, 19_CONSTRUC, 
   20_LTRP, 21_WTRP, 22_ATRP, 23_SER /
 
 I4(I) CBAM commodities
 / 11_CHEMICAL, 12_NONMET, 13_IRONSTL, 14_NONFERR /

 ENE(I) Energy commodities
 / 02_COAL, 03_OIL, 04_GAS, 10_PETROLCOAL, 18_ELEC /

 NENE(I) Non-energy commodities
 / 01_AGRICULT, 05_MINING, 06_FOODPRO, 07_TEXTILES, 08_WOODPRO, 
   09_PAPERPRO, 11_CHEMICAL, 12_NONMET, 13_IRONSTL, 14_NONFERR, 
   15_MACHINE, 16_TRANSEQ, 17_OTHERIND, 19_CONSTRUC, 20_LTRP, 
   21_WTRP, 22_ATRP, 23_SER /

 J2(J) General Industries
 / 07_TEXTILES, 08_WOODPRO, 09_PAPERPRO, 11_CHEMICAL, 14_NONFERR, 
   15_MACHINE, 16_TRANSEQ, 24_CONSTRUC, 26_WTRP, 27_ATRP, 28_SER /

 J3(J) Energy and Energy-Intensive Industries
 / 01_AGRICULT, 02_COAL, 03_OIL, 04_GAS, 05_MINING, 06_FOODPRO, 
   10_PETROLCOAL, 12_NONMET, 13_IRONSTL, 17_OTHERIND, 18_TnD, 
   19_eCoal, 20_eGas, 21_eOil, 22_eNUC, 23_eREN, 25_LTRP /

 J4(J) Energy Transformation Industries
 / 10_PETROLCOAL, 19_eCoal, 20_eGas, 21_eOil, 22_eNUC, 23_eREN /

 J5(J) Industries
 / 01_AGRICULT, 02_COAL, 03_OIL, 04_GAS, 05_MINING, 06_FOODPRO, 
   07_TEXTILES, 08_WOODPRO, 09_PAPERPRO, 11_CHEMICAL, 12_NONMET, 
   13_IRONSTL, 14_NONFERR, 15_MACHINE, 16_TRANSEQ, 17_OTHERIND, 
   24_CONSTRUC, 25_LTRP, 26_WTRP, 27_ATRP, 28_SER /

 J6(J) Agriculture
 / 01_AGRICULT /

 J7(J) Aggregated Energy Industry 
 / 02_COAL, 03_OIL, 04_GAS, 19_eCoal, 20_eGas, 21_eOil /

 J8(J) Aggregated Manufacturing
 / 05_MINING, 06_FOODPRO, 07_TEXTILES, 08_WOODPRO, 09_PAPERPRO, 10_PETROLCOAL, 
   11_CHEMICAL, 12_NONMET, 13_IRONSTL, 14_NONFERR, 15_MACHINE, 16_TRANSEQ, 
   17_OTHERIND, 24_CONSTRUC /

 J9(J) Aggregated Transportation
 / 25_LTRP, 26_WTRP, 27_ATRP /

 J10(J) Aggregated Building 
 / 28_SER /

 J11(J) CBAM target industries
 / 11_CHEMICAL, 12_NONMET, 13_IRONSTL, 14_NONFERR /

 Z2(Z) Asian regions
 / 01_KOR, 02_CHN, 03_JPN, 04_IND, 05_RUS /

 Elec(J) Electricity Generation Industries
 / 19_eCoal, 20_eGas, 21_eOil, 22_eNUC, 23_eREN /

 eNFs(j) Nuclear plus renewable and other generation
 / 22_eNUC, 23_eREN /

*** Mapping for CBAM
 z3(z) CBAM importing regions 
 / 07_EU /

 z4(z) CBAM exporting regions
 / 01_KOR, 02_CHN, 03_JPN, 05_RUS, 06_US, 08_OHI, 09_OUMIC /

 z5(z) Recipients of CBAM revenue recycling
 / 04_IND, 10_OLMIC, 11_OLI /

* Preserve supplied mapping: T&D intentionally excluded.
 INDtoCOM(j,i) Industry to commodity mapping
 / 01_AGRICULT.   (01_AGRICULT)
   02_COAL.       (02_COAL)
   03_OIL.        (03_OIL)
   04_GAS.        (04_GAS)
   05_MINING.     (05_MINING)
   06_FOODPRO.    (06_FOODPRO)
   07_TEXTILES.   (07_TEXTILES)
   08_WOODPRO.    (08_WOODPRO)
   09_PAPERPRO.   (09_PAPERPRO)
   10_PETROLCOAL. (10_PETROLCOAL)
   11_CHEMICAL.   (11_CHEMICAL)
   12_NONMET.     (12_NONMET)
   13_IRONSTL.    (13_IRONSTL)
   14_NONFERR.    (14_NONFERR)
   15_MACHINE.    (15_MACHINE)
   16_TRANSEQ.    (16_TRANSEQ)
   17_OTHERIND.   (17_OTHERIND)
   19_eCoal.      (18_ELEC)
   20_eGas.       (18_ELEC)
   21_eOil.       (18_ELEC)
   22_eNUC.       (18_ELEC)
   23_eREN.       (18_ELEC)
   24_CONSTRUC.   (19_CONSTRUC)
   25_LTRP.       (20_LTRP)
   26_WTRP.       (21_WTRP)
   27_ATRP.       (22_ATRP)
   28_SER.        (23_SER) /
;

* ==============================================================================
* E2_Sets.gms   -- Essay 2 (IBR -> ToU) 추가 집합
* ==============================================================================

SET
 B               Time-of-use load blocks
 / peak          Peak hours
   mid           Mid-peak hours
   off           Off-peak hours /

 IELEC(I)        Household (resdiential) electricity commodity 
 / 18_ELEC /

;

set ZE2(z) /01_KOR/;

* [T2] Partition approved for residential TOU; not an empirical test.
SET BS(b) Lower-nest blocks  / peak, off /;
SET BM(b) Upper-nest block   / mid /;

* [T5] Includes T&D under inherited supply-cost specification.
SET JPOW(J) Electricity supplying industries (generation + T&D)
 / 18_TnD, 19_eCoal, 20_eGas, 21_eOil, 22_eNUC, 23_eREN /;

ABORT$(CARD(JPOW) <> CARD(POWER)+CARD(TND))
     "JPOW must equal POWER + TND";

ABORT$(CARD(BS)+CARD(BM) <> CARD(b))
     "BS and BM must partition b";

ALIAS (j,jj), (i,ii,ij), (l,lj), (k,kj), (z,zj,zjj), (power, power2), (ENE,ENE2), (Elec, Elecc), (B,BB);



set sim /1/;


ABORT$(SUM(b$(BS(b) and BM(b)),1)>0) "BS/BM overlap";

* [Z1] Membership assigned in CAL from loaded GTAP benchmark output.
SETS ACTIVE_J(j,z) "Positive benchmark industry output"
     ACTIVE_POWER(j,z) "Positive benchmark electricity generation";
