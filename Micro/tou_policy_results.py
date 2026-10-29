"""Read the REN-HH policy grid written by Scenario/Run_Policy.gms."""
from pathlib import Path
import io
import subprocess
import numpy as np
import pandas as pd

def read_gdx(gdx_file,gams_dir,symbol):
    result=subprocess.run([str(Path(gams_dir)/'gdxdump.exe'),str(gdx_file),
        'symb='+symbol,'format=csv'],check=True,capture_output=True)
    d=pd.read_csv(io.StringIO(result.stdout.decode('utf-8-sig')))
    d.columns=d.columns.str.lower()
    return d.rename(columns={'rr':'rate','aa':'mix','sce':'scenario','z':'region',
        'j':'industry','power':'industry','b':'block','val':'value'})

def load_policy_results(gdx_file,gams_dir):
    def read(symbol):return read_gdx(gdx_file,gams_dir,symbol)
    def members(symbol):return read(symbol).iloc[:,0].tolist()
    levels={'rate':members('rr'),'mix':members('aa'),'scenario':members('base_sce'),
        'region':members('z'),'industry':members('j'),'block':members('b'),
        'macro_item':members('macro_item'),'emission_component':members('emission_component')}
    powers=members('power')
    def full(symbol,dims,power=False):
        values=[powers if power and x=='industry' else levels[x] for x in dims]
        ix=pd.MultiIndex.from_product(values,names=dims)
        return read(symbol).set_index(dims).value.reindex(ix,fill_value=0).rename('value').reset_index()
    r=read('recycle_rate').rename(columns={'value':'recycling_fraction'})
    a=read('ren_share').rename(columns={'value':'ren_fraction'})
    # Zero-valued grid endpoints are omitted by GAMS, so restore them from sets.
    r=r.set_index('rate').reindex(levels['rate'],fill_value=0).reset_index()
    a=a.set_index('mix').reindex(levels['mix'],fill_value=0).reset_index()
    grid=r.merge(a,how='cross')
    grid['policy_id']=grid.rate+'_'+grid.mix
    grid['scenario']=np.select([grid.recycling_fraction.eq(0),grid.ren_fraction.eq(0),grid.ren_fraction.eq(1)],
        ['TOU','TOU_HH','TOU_REN'],default='TOU_REN_HH')
    def enrich(d):return d.merge(grid,on=['rate','mix'])
    def combine(base_symbol,policy_symbol,dims,power=False):
        base=full(base_symbol,['scenario']+dims,power=power)
        base['rate']='base';base['mix']='base';base['policy_id']=base.scenario
        base['recycling_fraction']=0.;base['ren_fraction']=np.nan
        policy=enrich(full(policy_symbol,['rate','mix']+dims,power=power))
        return pd.concat([base,policy],ignore_index=True)
    macro=combine('results_macro','results_policy',['macro_item','region'])
    generation=combine('generation_output','generation_policy',['industry','region'],power=True)
    loads=combine('block_quantity','block_quantity_policy',['block','region'])
    emissions=combine('emissions_sector','emissions_policy',['emission_component','industry','region'])
    for frame,dims in [(macro,['macro_item','region']),(generation,['industry','region']),
                       (loads,['block','region']),(emissions,['emission_component','industry','region'])]:
        ref=frame.loc[frame.policy_id.eq('BAU'),dims+['value']].rename(columns={'value':'bau_value'})
        merged=frame.merge(ref,on=dims)
        frame['bau_value']=merged.bau_value.to_numpy()
        frame['change']=frame.value-frame.bau_value
        frame['change_pct']=frame.change/frame.bau_value.where(frame.bau_value.abs().gt(1e-12))*100
    generation['index_bau100']=100+generation.change_pct
    budgets=grid.merge(pd.DataFrame({'region':levels['region']}),how='cross')
    for symbol in ['budget_total','budget_hh','budget_ren','ren_support_actual','reference_retained','fiscal_residual_policy']:
        budgets=budgets.merge(full(symbol,['rate','mix','region']).rename(columns={'value':symbol}),on=['rate','mix','region'])
    prices=read('block_price_change').query("scenario in ['BAU','TOU']")
    prices_policy=enrich(full('block_price_change_policy',['rate','mix','block','region']))
    p0=full('block_price',['scenario','block','region']).query("scenario=='BAU'")
    q0=loads.loc[loads.policy_id.eq('BAU')]
    expenditure=p0.merge(q0[['block','region','value']],on=['block','region'],suffixes=('_price','_quantity'))
    expenditure['expenditure']=expenditure.value_price*expenditure.value_quantity
    expenditure=expenditure.groupby('region').expenditure.sum()
    return dict(macro=macro,generation=generation,loads=loads,emissions=emissions,budgets=budgets,
        grid=grid,prices_base=prices,prices_policy=prices_policy,bau_electricity_expenditure=expenditure,
        money_to_billion_usd=float(read('model_money_to_billion_usd').value.iloc[0]))
