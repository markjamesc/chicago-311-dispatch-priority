# PC Run Checklist (DESKTOP-RPECRM9)

machineId: `dc602624-137d-44ac-bac6-1c25377a1912`  
Workdir: `C:\Users\Mark\Documents\R Working Directory\chicago311`  
Rscript: `C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe`  
MySQL: `--login-path=chicago311`

1. Sync repo `sql/`, `R/`, `validation/`, `docs/stage-03-measurement-design/fixtures/` into workdir.
2. Run `sql/source-delivery/run_source_delivery.ps1` (or equivalent Open TSV export).
3. Materialize `source_open_envelope`; run `validation/source-gate/source_gate_checks.sql`.
4. Fill `validation/source-gate/SOURCE_GATE_REPORT.md` — **FAIL stops here**.
5. Freeze path + SHA-256 of source package for both R builders.
6. `Rscript R/r-a/r_a_judge.R fixtures` then production.
7. `Rscript R/r-b/r_b_judge.R fixtures` then production (independent).
8. `Rscript validation/reconciliation/reconcile_ra_rb.R outputs/r_a_judged.csv outputs/r_b_judged.csv`
9. Complete cross-review; write `stage4_validation_status.json`.
10. `Rscript validation/workflow-gate/workflow_gate.R .` — Stage 5 only if PASS + owner.
