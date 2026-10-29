*==============================================================================*
*                                                                              *
*           Except where otherwise noted, this work is licensed under          *
*               http://creativecommons.org/licenses/by-nc-sa/3.0/              *
*                                                                              *
*                                                                              *
*  You are free to share, to copy, distribute and transmit the work under      *
*  the following conditions:                                                   *
*                                                                              *
*  - Attribution:         You must attribute the work to:                      *
*                         Veronique Robichaud, Andre Lemelin,                  *
*                         Helene Maisonnave and Bernard Decaluwe.              *
*  - Noncommercial:       You may not use this work for commercial purposes.   *
*  - Share Alike:         If you alter, transform, or build upon this work,    *
*                         you may distribute the resulting work only under     *
*                         the same or similar license to this one.             *
*                                                                              *
*==============================================================================*
$title GTAP12 data aggregation
* Input: 11 regions and 73 detailed activities/commodities.
* Output: 11 regions, 28 industries, 23 commodities.
* eWind + eSolar + eHydro + eOther -> 23_eRenewables.
* Existing GDX inputs; absolute paths are written directly at each I/O statement.

* 1. Model sets. Industry numbers after electricity differ from commodity numbers.
SETS
J "All industries"
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
 22_eNUC
 23_eREN
 24_CONSTRUC
 25_LTRP
 26_WTRP
 27_ATRP
 28_SER
/
I "All commodities including agriculture"
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
 18_ELEC
 19_CONSTRUC
 20_LTRP
 21_WTRP
 22_ATRP
 23_SER
/
I1(I) "All commodities except agriculture"
/
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
 18_ELEC
 19_CONSTRUC
 20_LTRP
 21_WTRP
 22_ATRP
 23_SER
/
BUS(J) "Private industries - original convention retained"
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
 22_eNUC
 23_eREN
 24_CONSTRUC
 25_LTRP
 26_WTRP
 27_ATRP
/
PUB(J) "Public industry - original convention retained"
/
 28_SER
/
TRP(J) "Transport industries"
/
 25_LTRP
 26_WTRP
 27_ATRP
/
F "Production factors"
/
 slab
 ulab
 cap
 land
 natr
/
L(F) "Labor categories"
/
 slab
 ulab
/
K(F) "Capital categories"
/
 cap
 land
 natr
/
Z "Regions"
/
 01_KOR
 02_CHN
 03_JPN
 04_IND
 05_RUS
 06_US
 07_EU
 08_OHI
 09_OUMIC
 10_OLMIC
 11_OLI
/
Z1(Z) "All regions except reference region"
/
 01_KOR
 02_CHN
 03_JPN
 04_IND
 05_RUS
 07_EU
 08_OHI
 09_OUMIC
 10_OLMIC
 11_OLI
/
ZR(Z) "Reference region"
/
 06_US
/
Zrich(Z) "Unassigned policy group - set explicitly in the model if used"
Zother(Z) "Unassigned policy group - set explicitly in the model if used"
GlobalSet(*) "All raw GDX labels"
endw(GlobalSet) "Raw factors"
acts(GlobalSet) "Raw activities"
comm(GlobalSet) "Raw commodities"
reg(GlobalSet) "Raw regions"
marg(comm) "Raw margin commodities"
;
$gdxin "Input_w-1\GTAP12_basedata.gdx"
$load GlobalSet
$loadDC reg endw acts comm marg

* 2. Explicit raw-label dictionaries. GAMS labels are case-insensitive.
* Raw regions are the 11 user-supplied aggregates; USA maps to model 06_US.
* Raw activities and commodities retain the 73 detailed codes supplied by the user.
* As in the original attached code: gas+gdt -> GAS; omf -> OTHERIND;
* wtr (water supply) -> SER; wtp (water transport) -> WTRP.
SETS
z2reg(Z,reg) "Region mapping"
/
 01_KOR.KOR
 02_CHN.CHN
 03_JPN.JPN
 04_IND.IND
 05_RUS.RUS
 06_US.USA
 07_EU.EU
 08_OHI.OHI
 09_OUMIC.OUMIC
 10_OLMIC.OLMIC
 11_OLI.OLI
/
j2acts(J,acts) "Detailed GTAP12 activities to model industries"
/
 01_AGRICULT.(pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk, wol, frs, fsh)
 02_COAL.(coa)
 03_OIL.(oil)
 04_GAS.(gas, gdt)
 05_MINING.(oxt)
 06_FOODPRO.(cmt, omt, vol, mil, pcr, sgr, ofd, b_t)
 07_TEXTILES.(tex, wap, lea)
 08_WOODPRO.(lum)
 09_PAPERPRO.(ppp)
 10_PETROLCOAL.(p_c)
 11_CHEMICAL.(chm, bph, rpp)
 12_NONMET.(nmm)
 13_IRONSTL.(i_s)
 14_NONFERR.(nfm)
 15_MACHINE.(fmp, ele, eeq, ome)
 16_TRANSEQ.(mvh, otn)
 17_OTHERIND.(omf)
 18_TnD.(TnD)
 19_eCoal.(eCoal)
 20_eGas.(eGas)
 21_eOil.(eOil)
 22_eNUC.(eNuclear)
 23_eREN.(eWind, eSolar, eHydro, eOther)
 24_CONSTRUC.(cns)
 25_LTRP.(otp)
 26_WTRP.(wtp)
 27_ATRP.(atp)
 28_SER.(trd, afs, whs, cmn, ofi, ins, rsa, obs, ros, dwe, osg, edu, hht, wtr)
/
i2comm(I,comm) "Detailed GTAP12 commodities to model commodities"
/
 01_AGRICULT.(pdr, wht, gro, v_f, osd, c_b, pfb, ocr, ctl, oap, rmk, wol, frs, fsh)
 02_COAL.(coa)
 03_OIL.(oil)
 04_GAS.(gas, gdt)
 05_MINING.(oxt)
 06_FOODPRO.(cmt, omt, vol, mil, pcr, sgr, ofd, b_t)
 07_TEXTILES.(tex, wap, lea)
 08_WOODPRO.(lum)
 09_PAPERPRO.(ppp)
 10_PETROLCOAL.(p_c)
 11_CHEMICAL.(chm, bph, rpp)
 12_NONMET.(nmm)
 13_IRONSTL.(i_s)
 14_NONFERR.(nfm)
 15_MACHINE.(fmp, ele, eeq, ome)
 16_TRANSEQ.(mvh, otn)
 17_OTHERIND.(omf)
 18_ELEC.(TnD, eNuclear, eCoal, eGas, eOil, eWind, eSolar, eHydro, eOther)
 19_CONSTRUC.(cns)
 20_LTRP.(otp)
 21_WTRP.(wtp)
 22_ATRP.(atp)
 23_SER.(trd, afs, whs, cmn, ofi, ins, rsa, obs, ros, dwe, osg, edu, hht, wtr)
/
COMtoIND(J,I) "Industry to model commodity"
/
 01_AGRICULT.01_AGRICULT
 02_COAL.02_COAL
 03_OIL.03_OIL
 04_GAS.04_GAS
 05_MINING.05_MINING
 06_FOODPRO.06_FOODPRO
 07_TEXTILES.07_TEXTILES
 08_WOODPRO.08_WOODPRO
 09_PAPERPRO.09_PAPERPRO
 10_PETROLCOAL.10_PETROLCOAL
 11_CHEMICAL.11_CHEMICAL
 12_NONMET.12_NONMET
 13_IRONSTL.13_IRONSTL
 14_NONFERR.14_NONFERR
 15_MACHINE.15_MACHINE
 16_TRANSEQ.16_TRANSEQ
 17_OTHERIND.17_OTHERIND
 18_TnD.18_ELEC
 19_eCoal.18_ELEC
 20_eGas.18_ELEC
 21_eOil.18_ELEC
 22_eNUC.18_ELEC
 23_eREN.18_ELEC
 24_CONSTRUC.19_CONSTRUC
 25_LTRP.20_LTRP
 26_WTRP.21_WTRP
 27_ATRP.22_ATRP
 28_SER.23_SER
/
f2endw(F,endw) "Factor mapping"
/
 slab.SkLab
 ulab.UnSkLab
 cap.Capital
 land.Land
 natr.NatRes
/
;
ALIAS (reg,regj);
ALIAS (comm,commi);
ALIAS (acts,actsj);
ALIAS (J,jj);
ALIAS (I,ij);
ALIAS (L,lj);
ALIAS (K,kj);
ALIAS (Z,zj,zjj);

Parameter
*==============================================================================
*  2.1 Variables in GTAP12
*==============================================================================
* These are the variables from GTAP12 used in the calibration process.
* Population data is in million while all other data are expressed in millions
* of USD
 EVOS(endw,acts,reg)            Endowments at agents prices
 FBEP(endw,acts,reg)            Factor-based subsidies
 FTRV(endw,acts,reg)            Taxes - Factor Employment Tax Revenue
 MFRV(comm,reg,reg)             Protection MFA export subsidy equivalent
 POP(reg)                       Population
 TFRV(comm,reg,reg)             Protection Ordinary Import Duty
 VDEP(reg)                      Capital Stock Value of Depreciation
 VDFP(comm,acts,reg)            Intermed Firms Dom Purchases at Agent Prices
 VDFB(comm,acts,reg)            Intermed Firms Dom Purchases at Mkt Prices
 VMFP(comm,acts,reg)            Intermed Firms Imp Purchases at Agent Prices
 VMFB(comm,acts,reg)            Intermed Firms Imp Purchases at Mkt Prices
 VDGP(comm,reg)                 Government Dom Purchases at Agents Prices
 VDGB(comm,reg)                 Government Dom Purchases at Market Prices
 VDPP(comm,reg)                 Private Hhold Dom Purchases at Agents Prices
 VDPB(comm,reg)                 Private Hhold Dom Purchases at Market Prices
 EVFB(endw,acts,reg)            Endowments Firms Purchases at Market Prices
 VMGP(comm,reg)                 Government Imports at Agents Prices
 VMGB(comm,reg)                 Government Imports at Market Prices
 VMSB(comm,reg,reg)             Trade Bilateral Imports at Market Prices
 VMPP(comm,reg)                 Private Households Imports at Agents Prices
 VMPB(comm,reg)                 Private Households Imports at Market Prices
 VCIF(comm,reg,reg)             Trade Bilateral Imports at World Prices
 VKB(reg)                       Capital Stock Value at Beginning-of-Period
 VST(marg,reg)                  Trade Exports Internatl Trans Mkt Prices
 VTWR(marg,comm,reg,reg)      Trade Margins Internatl Trans World Prices
 VXSB(comm,reg,reg)             Trade Bilateral Exports at Market Prices
 VFOB(comm,reg,reg)             Trade Bilateral Exports at World Prices
 XTRV(comm,reg,reg)             Protection Ordinary Export Subsidy
 VDIP(comm,reg)                 Investment expenditure on dom. c in r at producer prices
 VMIP(comm,reg)                 Investment expenditure on imp. c in r at producer prices
 VDIB(comm,reg)                 Investment expenditure on dom. c in r at basic prices
 VMIB(comm,reg)                 Investment expenditure on imp. c in r at basic prices
 MAKS(comm,acts,reg)           Make matrix valued at suppliers prices
 MAKB(comm,acts,reg)           Make matrix valued at basic prices
*==============================================================================
*  2.2 Variables in the aggregated model
*==============================================================================
 CO(i,z)         Household consumption of commodity I
 CGO(i,z)        Public final consumption of commodity i
 INVO(i,z)       Final demand of commodity i for investment purposes
 DDO(i,z)        Demand for domestic production of commodity i
 DEPO(z)         Depreciation
 DIO(i,j,z)      Intermediate consumption of commodity i by industry j
 DSO(j,i,z)      Supply of commodity i by sector j to the domestic market
 EXO(i,z,zj)     Exports supply of commodity i from country z to country zj
 EXTO(i,z)       Total Export
 IMO(i,zj,z)     Imports of commodity m by country z from country zj
 RKDO(k,j,z)     Type k capital income in industry j
 KSTO(z)         Total capital stock in region z
 LDO(l,j,z)      Industry j demand for labour l
 MRGNO(i,z)      Demand for commodity i as a margin
 POPO(z)         Population
 TDHO(z)         Household income taxes
 DTAX(f,z)       Direct taxes
 TICO(i,z)       Government receipts of indirect taxes on commodity i
 TIKO(k,j,z)     Government receipts of indirect taxes on capital k of industry j
 TIMO(i,zj,z)    Government receipts of indirect taxes on imports of commodity i
 TIPO(j,z)       Government receipts of indirect taxes on production of industry j
 TIWO(l,j,z)     Government receipts of indirect taxes on wages and salaries of industry j
 TIXO(i,z,zj)    Government receipts of indirect taxes on exports of commodity i
 tmrg(i,ij,zj,z) Rate of commodity i margin applied to import m from country zj
 XSO_I(i,z)      total production by commodity
 XSO(j,i,z)      Industry j production of commodity i
 XSTO(j,z)       Total aggregate output of industry j
 tssm(i,j,z)     Intermediate tax by source import
 tssd(i,j,z)     Intermediate tax by source domestic
 MAKE(j,i,z)     Make matrix valued at basic prices
 DSO_I(i,z)      Supplys of domestic production of commodity i
 DDO_Matrix(i,ij,z)
;
*==============================================================================
*  2.3 Loading parameters from GTAP database
*==============================================================================
$LOADDC EVOS FBEP FTRV MFRV POP TFRV VDEP VDFP VDFB VDGP VDGB VMFP VMFB MAKS MAKB
$LOADDC VDPP VDPB EVFB VDIP VDIB VMIP VMIB VMGP VMGB VMPP VMPB VMSB VCIF VKB VST
$LOADDC VTWR VXSB VFOB XTRV
$GDXIN
*==============================================================================
* 2.4 Mapping between variables in the model and GTAP
*==============================================================================
* NOTE: In GTAP parlance, "agents' prices" are prices paid by buyers, and
*       "market prices" are prices received by sellers.
* A - Agent Price
* P - Producer Price
* B - Basic Price
*==============================================================================
* 2.4.1 Households consumption
*==============================================================================
* Households consumption is given by the sum of domestic purchases at
* agents prices (VDPP) and private household imports at agents prices (VMPP).
 CO(i,z)         = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                       VDPP(comm,reg)+VMPP(comm,reg)};
*==============================================================================
* 2.4.2 Public final consumption
*==============================================================================
* Public final consumption is given by the sum of domestic purchases at
* agents prices (VDGP) and public final imports at agents prices (VMGP).
 CGO(i,z)        = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                       VDGP(comm,reg)+VMGP(comm,reg)};
*==============================================================================
* 2.4.3 Demand for investment purposes
*=============================================================================
* Investment uses the separate domestic/import investment arrays VDIP/VMIP.
 INVO(i,z)       = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                      VDIP(comm,reg)+VMIP(comm,reg)};
*==============================================================================
* 2.4.4 Intermediate demand
*==============================================================================
* Intermediate consumption is given by the sum of domestic purchases at
* agents prices (VDFP) and imported intermediate inputs at agents prices (VMFP).
 DIO(i,j,z)      = SUM[(comm,acts,reg)$[i2comm(i,comm)
                      $j2acts(j,acts)$z2reg(z,reg)],
                      VDFP(comm,acts,reg)
                     +VMFP(comm,acts,reg)];
 tssm(i,j,z)    = SUM[(comm,acts,reg)$[i2comm(i,comm)
                      $j2acts(j,acts)$z2reg(z,reg)],
                      VMFP(comm,acts,reg)-VMFB(comm,acts,reg)];
 tssd(i,j,z)    = SUM[(comm,acts,reg)$[i2comm(i,comm)
                      $j2acts(j,acts)$z2reg(z,reg)],
                      VDFP(comm,acts,reg)-VDFB(comm,acts,reg)];
*==============================================================================
* 2.4.5 Imports
*==============================================================================
* Imports are defined in GTAP at world prices (VCIF) and at market prices
* (VMSB). Data on bilateral flows also include margins on imports (VTWR) and
* import duties (TFRV). On the export side, the database includes exports at
* market prices (VXSB), at world prices (VFOB) and subsidies on exports (MFRV
* and XTRV).
* The relationships between those variables is the following:
*       VMSB = VCIF + TFRV
*       VCIF = VFOB + VTWR
*       VXSB = VFOB - MFRV - XTRV
*
* Imports are evaluated at world prices (VCIF) less transport margins (VTWR).

 IMO(i,zj,z)     = SUM{(comm,regj,reg)$[i2comm(i,comm)
                       $z2reg(zj,regj)$z2reg(z,reg)],
                       VCIF(comm,regj,reg)- SUM[marg,VTWR(marg,comm,regj,reg)]};
* IMO(i,zj,z)$sameas(zj,z) = 0 ;
* Retain all bilateral flows, including intra-aggregate-region trade.

*==============================================================================
* 2.4.6 Exports
*==============================================================================
*  To limit the sources of potential desequilibrium, exports are simply set
*  equal to imports.
 EXO(i,zj,z)     = IMO(i,zj,z);
 EXTO(i,z)       = sum(zj, EXO(i,z,zj));
*==============================================================================
* 2.4.7 Margins
*==============================================================================
* Map the margin-commodity dimension as well as the traded commodity.
* tmrg(i,ij,zj,z)$(NOT sameas(zj,z))
*      = SUM[(marg,comm,regj,reg)$[i2comm(i,marg) AND i2comm(ij,comm)
*              AND z2reg(zj,regj) AND z2reg(z,reg)], VTWR(marg,comm,regj,reg)];
 tmrg(i,ij,zj,z)
      = SUM[(marg,comm,regj,reg)$[i2comm(i,marg) AND i2comm(ij,comm)
              AND z2reg(zj,regj) AND z2reg(z,reg)], VTWR(marg,comm,regj,reg)];
* Supply of transport margin are given by the variable VST
 MRGNO(i,z)      = SUM{(marg,reg)$[i2comm(i,marg)$z2reg(z,reg)],
                       VST(marg,reg)};
*==============================================================================
* 2.4.8 Import duties
*==============================================================================
*  Import duties are given by the variable TFRV
* TIMO(i,zj,z)$(NOT sameas(zj,z))
*                 = SUM{(comm,regj,reg)$[i2comm(i,comm)
*                       $z2reg(zj,regj)$z2reg(z,reg)],
*                       TFRV(comm,regj,reg)};
 TIMO(i,zj,z)
                 = SUM{(comm,regj,reg)$[i2comm(i,comm)
                       $z2reg(zj,regj)$z2reg(z,reg)],
                       TFRV(comm,regj,reg)};
*==============================================================================
* 2.4.9 Taxes on exports
*==============================================================================
*  Taxes on exports are given by the sum of MRRV and XTRV
* TIXO(i,z,zj)$(NOT sameas(z,zj))
*                 = SUM{(comm,reg,regj)$[i2comm(i,comm)
*                       $z2reg(z,reg)$z2reg(zj,regj)],
*                       MFRV(comm,reg,regj)+XTRV(comm,reg,regj)};
 TIXO(i,z,zj)
                 = SUM{(comm,reg,regj)$[i2comm(i,comm)
                       $z2reg(z,reg)$z2reg(zj,regj)],
                       MFRV(comm,reg,regj)+XTRV(comm,reg,regj)};
*==============================================================================
* 2.4.10 Taxes on factors of production
*==============================================================================
* Preserve the supplied source convention FTRV + FBEP.
* Confirm the FBEP sign convention against the actual GTAP12 export.
 TIWO(l,j,z)     = SUM{(endw,acts,reg)$[f2endw(l,endw)
                       $j2acts(j,acts)$z2reg(z,reg)],
                       FTRV(endw,acts,reg)+
                       FBEP(endw,acts,reg)};
 TIKO(k,j,z)     = SUM{(endw,acts,reg)$[f2endw(k,endw)
                       $j2acts(j,acts)$z2reg(z,reg)],
                       FTRV(endw,acts,reg)+
                       FBEP(endw,acts,reg)};
*==============================================================================
* 2.4.11 Taxes on production
*==============================================================================
* Net output tax = basic-price MAKE minus suppliers-price MAKE.
* This retains the raw activity dimension, including when all power industries
* produce the single commodity ELEC. Do not map a commodity tax to each of the
* six power industries: that would duplicate it. Positive = tax, negative = subsidy.
 TIPO(j,z) = SUM[(comm,acts,reg)$[j2acts(j,acts) AND z2reg(z,reg)],
                    MAKB(comm,acts,reg)-MAKS(comm,acts,reg)];
*==============================================================================
* 2.4.12 Domestic taxes on commodities
*==============================================================================
* Domestic taxes on commodities are evaluated as the difference between
* demand at agent prices and demand at market prices.
 TICO(i,z)       = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                      VDPP(comm,reg)-VDPB(comm,reg)
                     +VMPP(comm,reg)-VMPB(comm,reg)
                     +VDGP(comm,reg)-VDGB(comm,reg)
                     +VMGP(comm,reg)-VMGB(comm,reg)
                     +VDIP(comm,reg)-VDIB(comm,reg)
                     +VMIP(comm,reg)-VMIB(comm,reg)
                     +SUM[acts,VDFP(comm,acts,reg)
                          +VMFP(comm,acts,reg)]
                     -SUM[acts,VDFB(comm,acts,reg)
                           +VMFB(comm,acts,reg)]};
*==============================================================================
* 2.4.13 Direct taxes
*==============================================================================
* Direct taxes is given by the difference between factor payment at
* market prices (EVFB) and endowment at agent prices (EVOS)
 TDHO(z)            = SUM{reg$z2reg(z,reg),
SUM[endw,SUM(acts,EVFB(endw,acts,reg))
                       -SUM(acts,EVOS(endw, acts, reg))]};
 DTAX(f,z)          = SUM{(endw,reg)$[f2endw(f,endw)$z2reg(z,reg)],
SUM[acts,EVFB(endw,acts,reg)] -
SUM[acts,EVOS(endw,acts, reg)]} ;
*==============================================================================
* 2.4.14 Factors of production
*==============================================================================
* Remuneration of the production factors is evaluated at market prices,
* that is before taxes (EVFB).
 LDO(l,j,z)      = SUM{(endw,acts,reg)$[f2endw(l,endw)
                       $j2acts(j,acts)$z2reg(z,reg)],
                       EVFB(endw,acts,reg)};
 RKDO(k,j,z)      = SUM{(endw,acts,reg)$[f2endw(k,endw)
                       $j2acts(j,acts)$z2reg(z,reg)],
                       EVFB(endw,acts,reg)};
* Total capital stock at the beginning of the period
 KSTO(z)         = SUM{reg$z2reg(z,reg),VKB(reg)};
*==============================================================================
* 2.4.15 Depreciation
*==============================================================================
* Depreciation is given by the variable VDEP
 DEPO(z)         = SUM{reg$z2reg(z,reg),VDEP(reg)};
*==============================================================================
* 2.4.16 Population
*==============================================================================
*  Population by region
 POPO(z)         = SUM{reg$z2reg(z,reg),POP(reg)};
*==============================================================================
* 2.4.17 Domestic demand
*==============================================================================
* Once again, to avoid descrepencies, domestic purchases are calculated
* by substracting imports, transport margins and indirect taxes from total
* domestic absorption.
 DDO(i,z)        = CO(i,z)+CGO(i,z)+INVO(i,z)+SUM[j,DIO(i,j,z)]-TICO(i,z)
                   -SUM[zj,TIMO(i,zj,z)]-SUM[zj,IMO(i,zj,z)]
                   -SUM[(ij,zj),tmrg(ij,i,zj,z)];
*==============================================================================
* 2.4.18 MAKE Matrix
*==============================================================================
 MAKE(j,i,z) = SUM[(acts,comm,reg)$[i2comm(i,comm)
                      $j2acts(j,acts)$z2reg(z,reg)],
                      MAKB(comm,acts,reg)];
*==============================================================================
* 2.5 Equilibrate data
*==============================================================================
*  2.5.1 Equilibrium on the world margin market
*==============================================================================
*  The first step would be to equilibrate international markets. As there is a
*  small difference between supply of margins and demand, we chose to adjust
*  the supply side by increasing or reducing each region's production
*  proportionately.
 MRGNO(i,z)$MRGNO(i,z)
                 = MRGNO(i,z)*SUM[(ij,zj,zjj),tmrg(i,ij,zj,zjj)]
                  /SUM[zjj,MRGNO(i,zjj)];
**==============================================================================
* 2.5.2 Equilibrium in each region
*==============================================================================
*  As exports have already been set equal to imports, the remaining differences
*  would appear in the national data. Total production is first set equal to
*  the sum of production for the domestic market (DSO), adjusted production
*  of margins (MRGNO) and exports.
 DSO_I(i,z)        = DDO(i,z) ;
 XSO_I(i,z)        = DDO(i,z)+MRGNO(i,z)+SUM[zj,EXO(i,z,zj)-TIXO(i,z,zj)];
 XSO(j,i,z)$SUM(jj,MAKE(jj,i,z))
                   = XSO_I(i,z)*MAKE(j,i,z)/SUM(jj,MAKE(jj,i,z));
 XSTO(j,z)         = SUM(i, XSO(j,i,z));
 EXTO(i,z)         = SUM[zj,EXO(i,z,zj)];
 DSO(j,i,z)$SUM(jj,MAKE(jj,i,z))
                   = DDO(i,z)*MAKE(j,i,z)/SUM(jj,MAKE(jj,i,z));
*  The operating surplus is the variable that was used to equilibrate the
*  regional data. As all other variables (income, savings and so on) will
*  be calculated based on the variables described in these steps, there
*  should not be any other descrepency.
* Retain the original capital-residual balancing calculation.
RKDO('cap',j,z)  = XSTO(j,z)-SUM[i,DIO(i,j,z)]-SUM[l,LDO(l,j,z)+TIWO(l,j,z)]
                  -TIPO(j,z)-SUM[k,TIKO(k,j,z)]-RKDO('land',j,z) -RKDO('natr',j,z);
* Legacy convention: KSTO is reset to factor-income total, NOT observed stock.
KSTO(z)  = sum((k,j),RKDO(k,j,z));
*==============================================================================
* 3. CES elasticities
*==============================================================================
* 3.1 Definition of GTAP parameters
*==============================================================================
PARAMETER
 ESBD(comm, reg)  Elasticity of substitution between domestic product and imports
 ESBM(comm, reg)  Elasticity of substitution between imports from different regions
 EFVE(acts, reg)  Elasticity of substitution between primary factors in the production of value added
*==============================================================================
* 3.2 Definition in PEP w
*==============================================================================
 sigma_M1(i,z)   Elasticity (CES - composite commodity)
 sigma_M2(i,z)   Elasticity (CES - composite import)
 sigma_VA(j,z)   Elasticity (CES - value added)
*==============================================================================
* 3.3 Temporary variables
*==============================================================================
 IM_GTAP(comm,z) Total imports using the GTAP commodity sets
 Q_GTAP(comm,z)  Composite commodity using the GTAP commodity sets
 SH_IM(comm,i,z) Share of each import TRAD_COM in aggregation i for region z
 SH_Q(comm,i,z)  Share of each composite commodity TRAD_COM in aggregation i for region z
 SH_VA(acts,j,z) Share of each sector TRAD_COM in aggregation j for region z
 VA_GTAP(acts,z) Value added using the GTAP sectors
;
*==============================================================================
* 3.4 Load the GTAP file which includes the parameters
*==============================================================================
$GDXIN "Input_w-1\GTAP12_parameters.gdx"
$LOADDC ESBD ESBM EFVE
$GDXIN
*==============================================================================
*  3.5 sigma_M1
*==============================================================================
* Elasticities of substitution between domestic product and imports are
* aggregated acording to the share of each commodity (QO) TRAD_COMM in total I
 Q_GTAP(comm,z)
                 = SUM{reg$z2reg(z,reg),
                   VDPP(comm,reg)+VMPP(comm,reg)+
                   VDGP(comm,reg)+VMGP(comm,reg)+
                   VDIP(comm,reg)+VMIP(comm,reg)+
SUM[acts,VDFP(comm,acts,reg)+
                       VMFP(comm,acts,reg)]};
 SH_Q(comm,i,z)$(i2comm(i,comm) AND SUM(commi$i2comm(i,commi),Q_GTAP(commi,z))>0)
                 = Q_GTAP(comm,z)/
SUM{commi$i2comm(i,commi),
                       Q_GTAP(commi,z)};
 sigma_M1(i,z)   = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                   ESBD(comm,reg)*SH_Q(comm,i,z)};
*==============================================================================
*  3.6 sigma_M2
*==============================================================================
* Elasticities of substitution between imports from different partners are
* aggregated acording to the share of total import (IMTO) TRAD_COMM in total I
* IM_GTAP(comm,z)
*                 = SUM[(regj,reg)$[z2reg(z,reg) AND NOT z2reg(z,regj)],VCIF(comm,regj,reg)];

 IM_GTAP(comm,z) = SUM((regj,reg)$z2reg(z,reg),VCIF(comm,regj,reg));

 SH_IM(comm,i,z)$(i2comm(i,comm) AND SUM(commi$i2comm(i,commi),IM_GTAP(commi,z))>0)
                 = IM_GTAP(comm,z)/
 SUM{commi$i2comm(i,commi),
                       IM_GTAP(commi,z)};
 sigma_M2(i,z)   = SUM{(comm,reg)$[i2comm(i,comm)$z2reg(z,reg)],
                   ESBM(comm,reg)*SH_IM(comm,i,z)};
*==============================================================================
*  3.7 sigma_VA
*==============================================================================
* Elasticities of substitution between factors of production are aggregated
* acording to the share of each sector (VA) TRAD_COMM in total I
 VA_GTAP(acts,z)
                 = SUM{endw,
SUM[reg$z2reg(z,reg),EVFB(endw,acts,reg)]};
 SH_VA(acts,j,z)$(j2acts(j,acts) AND SUM(actsj$j2acts(j,actsj),VA_GTAP(actsj,z))>0)
                 = VA_GTAP(acts,z)/
SUM{actsj$j2acts(j,actsj),
                       VA_GTAP(actsj,z)};
 sigma_VA(j,z)   = SUM{(acts,reg)$[j2acts(j,acts)$z2reg(z,reg)],
                   EFVE(acts,reg)*SH_VA(acts,j,z)};

* For absent base-year flows, retain a finite arithmetic-mean elasticity.
* These values do not create any base-year activity or flow.
sigma_M1(i,z)$(SUM(comm$i2comm(i,comm),Q_GTAP(comm,z))=0)
 = SUM((comm,reg)$[i2comm(i,comm) AND z2reg(z,reg)],ESBD(comm,reg))/SUM(comm$i2comm(i,comm),1);
sigma_M2(i,z)$(SUM(comm$i2comm(i,comm),IM_GTAP(comm,z))=0)
 = SUM((comm,reg)$[i2comm(i,comm) AND z2reg(z,reg)],ESBM(comm,reg))/SUM(comm$i2comm(i,comm),1);
sigma_VA(j,z)$(SUM(acts$j2acts(j,acts),VA_GTAP(acts,z))=0)
 = SUM((acts,reg)$[j2acts(j,acts) AND z2reg(z,reg)],EFVE(acts,reg))/SUM(acts$j2acts(j,acts),1);

* 4. Save the aggregated model data.
execute_unload 'Input_w-1\DATA_AGG_GTAP12.gdx',
 J,I,I1,BUS,PUB,TRP,F,L,K,Z,ZR,Z1,Zrich,Zother,COMtoIND,
 CO,CGO,DDO,DEPO,DIO,DSO,DSO_I,EXO,IMO,INVO,KSTO,LDO,MRGNO,POPO,RKDO,
 TDHO,DTAX,TICO,TIKO,TIMO,TIPO,TIWO,TIXO,tssm,tssd,tmrg,XSO,XSO_I,XSTO,EXTO,
 sigma_M1,sigma_M2,sigma_VA,Q_GTAP,SH_Q,SH_IM,SH_VA,ESBD,ESBM,EFVE,DDO_Matrix,
 GlobalSet,reg,acts,comm,endw,marg,z2reg,j2acts,i2comm,f2endw,MAKE;
