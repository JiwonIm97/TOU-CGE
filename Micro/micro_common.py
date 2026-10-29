"""두 TOU 노트북이 함께 사용하는 표본·역산·균등화소득 정의."""
from pathlib import Path
import hashlib
import json
import numpy as np
import pandas as pd

BLOCKS = ['peak', 'mid', 'off']
BASE = {0: np.array([910.,1600.,7300.]), 1: np.array([730.,1260.,6060.])}
RATE = {0: np.array([120.,214.6,307.3]), 1: np.array([105.,174.,242.3])}
SUPER = {0:736.2, 1:601.3}

def load_config(path):
    return json.loads(Path(path).read_text(encoding='utf-8-sig'))

def months_for(config):
    return {'other':[3], 'summer':[7,8], 'annual_flat':list(range(1,13))}[config['profile']]

def profile_tag(config):
    voltage={'apartment-proxy':'apartmentHV','all-low':'allLV','all-high':'allHV'}[config['voltage']]
    return f"{config['profile']}_{voltage}"

def gross_factor(month, config):
    fund=config['annual_fund_first_half'] if config['profile']=='annual_flat' and month<=6 else config['fund']
    return 1+config['vat']+fund

def ibt_components(q,hv,month):
    q=np.asarray(q,dtype=float)
    a,b=(300.,450.) if month in (7,8) else (200.,400.)
    r=RATE[hv]
    basic=np.where(q<=a,BASE[hv][0],np.where(q<=b,BASE[hv][1],BASE[hv][2]))
    energy=r[0]*np.minimum(q,a)+r[1]*np.clip(q-a,0,b-a)+r[2]*np.maximum(q-b,0)
    if month in (1,2,7,8,12):
        energy+=(SUPER[hv]-r[2])*np.maximum(q-1000,0)
    return basic,energy

def ibt_bill(q,hv,config):
    return np.mean([(sum(ibt_components(q,hv,m))+config['climate_fuel_won_kwh']*q)*gross_factor(m,config)
                    for m in months_for(config)],axis=0)

def invert_bill(bill,hv,config):
    bill=np.asarray(bill,dtype=float)
    lo,hi=np.zeros_like(bill),np.maximum(bill/50,2000.)
    for _ in range(70):
        mid=(lo+hi)/2
        below=ibt_bill(mid,hv,config)<bill
        lo,hi=np.where(below,mid,lo),np.where(below,hi,mid)
    return np.where(abs(ibt_bill(hi,hv,config)-bill)<abs(ibt_bill(lo,hv,config)-bill),hi,lo)

def weighted_mean(frame,column):
    use=frame[column].notna()
    return np.average(frame.loc[use,column],weights=frame.loc[use,'weight']) if use.any() else np.nan

def prepare_common_sample(path,config):
    path=Path(path)
    d=pd.read_excel(path,sheet_name=0)
    d.columns=d.columns.str.strip().str.lower()
    for c in ['a1','dq4','dq5','dq6','a7','a7_n2','a7_n3','a8']:
        d[c]=pd.to_numeric(d[c],errors='coerce')
    d['household_id']=d['pid'] if 'pid' in d else np.arange(len(d))
    wc=config['weight_column']
    d['weight']=1. if wc is None else pd.to_numeric(d[wc],errors='coerce')
    v=config['voltage']
    d['hv_assumed']=d['dq6'].eq(1).astype(int) if v=='apartment-proxy' else int(v=='all-high')
    d['bill_valid']=d['a1'].ge(config['min_bill_won'])&d['dq6'].between(1,6)
    for c in ['kwh','bill_reconstructed','basic_net_monthly','energy_net_monthly','energy_gross_monthly']:
        d[c]=np.nan
    months=months_for(config)
    for hv in [0,1]:
        ix=d['bill_valid']&d['hv_assumed'].eq(hv)
        q=invert_bill(d.loc[ix,'a1'].to_numpy(),hv,config)
        parts=[ibt_components(q,hv,m) for m in months]
        energy=np.array([x[1] for x in parts])
        d.loc[ix,'kwh']=q
        d.loc[ix,'bill_reconstructed']=ibt_bill(q,hv,config)
        d.loc[ix,'basic_net_monthly']=np.mean([x[0] for x in parts],axis=0)
        d.loc[ix,'energy_net_monthly']=energy.mean(axis=0)
        d.loc[ix,'energy_gross_monthly']=np.mean(energy*np.array([gross_factor(m,config) for m in months])[:,None],axis=0)
    d['inversion_residual_won']=d['bill_reconstructed']-d['a1']
    d['inversion_gap']=abs(d['inversion_residual_won']).gt(config['inversion_tolerance_won'])
    for b,c in zip(BLOCKS,['a7_n2','a7','a7_n3']):d[f's_{b}']=d[c]/100
    shares=d[[f's_{b}' for b in BLOCKS]]
    d['shares_valid']=shares.notna().all(axis=1)&shares.ge(0).all(axis=1)&shares.le(1).all(axis=1)&np.isclose(shares.sum(axis=1),1)
    d['peak_min_share']=d['a8']/100
    d['constraint_valid']=d['peak_min_share'].between(0,d['s_peak'])
    d['peak_shift_cap_share']=d['s_peak']-d['peak_min_share']
    d['constraint_score']=np.divide(d['peak_min_share'],d['s_peak'],out=np.zeros(len(d)),where=d['s_peak'].gt(0))
    d['income_monthly_won']=d['dq5']*10000
    d['eq_income_monthly_won']=d['income_monthly_won']/np.sqrt(d['dq4'].where(d['dq4'].gt(0)))
    stages=[('input',pd.Series(True,index=d.index)),
        ('bill_and_dwelling',d['bill_valid']),('exact_bill_inverse',~d['inversion_gap']),
        ('kwh_range',d['kwh'].between(config['min_kwh'],config['max_kwh'])),
        ('load_shares',d['shares_valid']),('a8_constraint',d['constraint_valid']),
        ('income_and_household_size',d['dq4'].ge(1)&d['dq5'].ge(0)&np.isfinite(d['eq_income_monthly_won'])),
        ('positive_weight',d['weight'].gt(0)&np.isfinite(d['weight']))]
    kept=pd.Series(True,index=d.index)
    flow=[]
    previous=len(d)
    for name,condition in stages:
        kept &= condition
        n=int(kept.sum())
        flow.append(dict(stage=name,n_kept=n,n_excluded_at_stage=previous-n))
        previous=n
    d['analysis_sample']=kept
    h=d.loc[kept].copy()
    dist=h.groupby('eq_income_monthly_won',sort=True)['weight'].sum()
    cdf=dist.cumsum()/dist.sum()
    cuts=np.array([cdf.index[np.searchsorted(cdf.to_numpy(),p)] for p in [.2,.4,.6,.8]])
    d['income_quintile']=np.nan
    d.loc[kept,'income_quintile']=np.searchsorted(cuts,h['eq_income_monthly_won'],side='left')+1
    # 기존 요금 노트북에서 사용하는 열 이름을 같은 값으로 제공.
    d['kwh_est']=d['kwh']
    d['bill_ibt_reconstructed']=d['bill_reconstructed']
    d['ibt_basic_net']=d['basic_net_monthly']
    d['ibt_variable_net']=d['energy_net_monthly']+config['climate_fuel_won_kwh']*d['kwh']
    d['bill_in_gap']=d['inversion_gap']
    d['est_sample']=d['analysis_sample']
    d['income_won']=d['income_monthly_won']
    h=d.loc[kept].copy().reset_index(drop=True)
    h['income_quintile']=h['income_quintile'].astype(int)
    h['low_income']=h['income_quintile'].isin(config['low_income_quintiles'])
    h['score_TOU_U']=1.
    h['score_TOU_I']=h['low_income'].astype(float)
    h['score_TOU_C']=h['constraint_score']
    h['score_TOU_IC']=h['low_income']*h['constraint_score']
    comparison=[]
    for q,g in h.groupby('income_quintile'):
        average=weighted_mean(g,'eq_income_monthly_won')/10000
        average*=12 if config['reference_period']=='annual' else 1
        comparison.append(dict(quintile=q,households=len(g),weighted_share=g.weight.sum()/h.weight.sum(),
            sample_eq_mean_manwon=average,reference_eq_mean_manwon=config['reference_means_manwon'][str(q)]))
    metadata=dict(config=config,input_file=str(path),input_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
        n_input=len(d),n_common=len(h),income_cutoffs_monthly_eq_won=cuts.tolist(),
        household_ids_sha256=hashlib.sha256('\n'.join(h.household_id.astype(str)).encode()).hexdigest(),
        income_definition='monthly household income KRW / sqrt(household size)',
        quintile_method='weighted household quantiles in common sample; equal incomes stay together',
        reference_means_are_cutoffs=False)
    return d,h,pd.DataFrame(flow),pd.DataFrame(comparison),metadata

def export_common_sample(root,config,d,h,flow,income_summary,metadata):
    out=Path(root)/('common_sample_'+profile_tag(config))
    out.mkdir(parents=True,exist_ok=True)
    for name,table in [('survey_prepared',d),('analysis_households',h),('sample_flow',flow),
                       ('income_reference_comparison',income_summary)]:
        table.to_csv(out/(name+'.csv'),index=False,encoding='utf-8-sig')
    (out/'common_sample_metadata.json').write_text(json.dumps(metadata,ensure_ascii=False,indent=2),encoding='utf-8')
    return out
