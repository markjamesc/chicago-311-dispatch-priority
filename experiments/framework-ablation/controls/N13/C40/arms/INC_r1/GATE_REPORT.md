# C40 gate report — INC r1 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 1 (2.5 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | NO |
| RB_fixture_results.csv | YES |
| RB_portfolio_counts.csv | NO |
| RB_kappa_grid_counts.csv | NO |

Last 15 lines of stderr:
```
[R-B] fixtures pass 14/14 | F03 observed=STANDARD expected=STANDARD
[R-B] F03→STANDARD OK at kappa=2
[R-B] source CSVs present
[R-B] loading open candidates...
Error: Open source missing required column(s): SR_NUMBER, STATUS, SR_TYPE, SR_SHORT_CODE, CREATED_DATE, LAST_MODIFIED_DATE, CLOSED_DATE, DUPLICATE, LEGACY_RECORD, PARENT_SR_NUMBER
In addition: Warning messages:
1: One or more parsing issues, call `problems()` on your data frame for details,
e.g.:
  dat <- vroom(...)
  problems(dat) 
2: One or more parsing issues, call `problems()` on your data frame for details,
e.g.:
  dat <- vroom(...)
  problems(dat) 
Execution halted
```

