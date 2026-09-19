**HOLD:** Do not execute until parent clears Stage 3 three-AI Design pass.

# R-B (rule-table join)

Independent Stage 4 judged implementation. Construction: predicate feature table + exclusion/action rule-table joins.

```bash
Rscript R/r-b/r_b_judge.R fixtures
Rscript R/r-b/r_b_judge.R production data/source_open_envelope.tsv outputs/r_b_judged.csv
```

Do not share judged helpers or ID lists with R-A.
