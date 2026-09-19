**HOLD:** Do not execute until parent clears Stage 3 three-AI Design pass.

# R-A (sequential mutate)

Independent Stage 4 judged implementation. Construction: sequential `dplyr::mutate` / `case_when`.

```bash
# From repo root (fixture gate):
Rscript R/r-a/r_a_judge.R fixtures
# Production (after Source Gate PASS):
Rscript R/r-a/r_a_judge.R production data/source_open_envelope.tsv outputs/r_a_judged.csv
```

Do not share judged helpers or ID lists with R-B.
