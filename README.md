# TOU-CGE and household microsimulation

Final source code for Korea's residential time-of-use electricity tariff reform, renewable electricity production support, and household revenue recycling.

## Contents

- `Run_Master.gms`: main GAMS entry point.
- `Policy/TOU_Inputs.gms`: common tariff parameters and recycling/allocation grids.
- `Scenario/Run_Policy.gms`: BAU, TOU and the REN–HH policy family.
- `Micro/jeju_tou_calibration.ipynb`: fixed-consumption IBT-to-TOU bill comparison.
- `Micro/TOU_CGE_outcomes.ipynb`: aggregate welfare, emissions, generation and fiscal outcomes.
- `Micro/TOU_CGE_microsimulation.ipynb`: conditional household bill incidence under U, I and IC transfers; constraint-only allocation is an appendix.
- `Figure/Overall_outcomes_figures.ipynb`: overall-outcomes figures and representative-policy table.
- `Figure/Sections_2_4/Sections_2_4_figures.ipynb`: environmental, equity and economic figures and tables.
- `Figure/Sections_2_4/data/`: aggregate snapshots used by both figure notebooks; no household records.

Only the active model source and final notebooks are retained. Notebook outputs are cleared. Earlier scenario runners, checkpoints and generated model results are excluded from the current tree.

## Local inputs (not distributed)

Full model execution requires the following locally supplied files:

| Location | Required input |
| --- | --- |
| `Input_w-1/DATA_AGG_GTAP12.gdx` | Prepared aggregated benchmark database |
| `Input_w-1/PAR.gdx` | Prepared elasticity and parameter data |
| `Input_WEB/DATA_WEB_2023_raw.gdx` | Prepared energy balance and emissions-factor input |
| `Micro/survey_data.xlsx` | Household survey required for calibration and microsimulation |

The raw GTAP databases, source spreadsheets, survey responses and household-level derived files are not distributed. The two figure notebooks run from the included aggregate snapshots without these inputs.

For input preparation, `Input_w-1/DATA_AGG_GTAP12.gms` reads locally supplied `GTAP12_basedata.gdx` and `GTAP12_parameters.gdx`. `Input_w-1/PAR.txt` and `Input_WEB/DATA_WEB_2023_read.txt` are GDXXRW import specifications for the corresponding local spreadsheets. `Input_WEB/DATA_WEB_2023.gms` is included by `CAL.gms`; it is not a separate main model runner.

## Run the model

Run commands from the repository root. The development environment used GAMS 40 and CONOPT4; a suitable GAMS licence is required.

```powershell
& 'C:\GAMS\40\gams.exe' Run_Master.gms
```

The output is `TOU_recycling_results.gdx`. To run the benchmark only:

```powershell
& 'C:\GAMS\40\gams.exe' Run_Master.gms --RUN_POLICY=0
```

Install the Python dependencies and launch Jupyter:

```powershell
python -m pip install -r requirements.txt
jupyter lab
```

Run the three `Micro` notebooks in the order listed above. Set `GAMS_DIR` in the two CGE-linked notebooks if GAMS is installed elsewhere. Notebooks locate the repository from the working directory, so start Jupyter inside the repository. The figure notebooks reproduce the included snapshot results independently of GAMS. PNG exports in the sections 2–4 notebook additionally require Poppler's `pdftoppm` on PATH; PDF/SVG exports do not.

## Interpretation

The recycling share and REN allocation share range from zero to one in 0.1 increments. Revenue budgets use positive no-recycling TOU wedge receipts as a fixed reference. Government savings are not utility profit or debt repayment. REN support is static production tax relief for the model's renewable and other generation sector, excluding direct fossil and nuclear support.

The CGE-to-micro linkage is one-way. The microsimulation holds household electricity use and load shares fixed and applies equilibrium time-block price ratios. U, I and IC exhaust the same household budget at each policy point. These are conditional bill-incidence estimates, not household-specific equivalent variation or nationally weighted totals.

The figure snapshots document the current results. After rerunning the analysis, update the files in `Figure/Sections_2_4/data/` to draw figures from the new results; the figure notebooks do not update those snapshots automatically.

See `README_RUN_KO.md` and `Micro/README_COMMON_SAMPLE_KO.md` for the Korean execution notes. Existing source attribution and licence notices are preserved.
