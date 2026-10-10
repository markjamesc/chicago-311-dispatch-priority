# C32 RESULTS — Freeze Before Stage 5 (catalog #32) ablation (runner output, mechanical facts only)

Every arm starts from the frozen validated state (RA_classifications.csv, RB_kappa_grid_counts.csv, validated_action_list.csv copied from the frozen pack) and records VALIDATION_FREEZE.sha256 before anything else runs.
Arm B runs the frozen-path Stage-5 harness with no edit and is the truth reference. Seeded arms apply the listed edit (PRE step) or Stage-5 variant.

## Definitions (frozen in the spec)
- Harm set H: Stage 5 completes (exit 0) and at least one of its 8 standard outputs differs from arm B (CSV content, numbers to 1e-9)
- Caught with the control: the pre-Stage-5 freeze check finds a Stage-5 input whose SHA-256 differs from the validation freeze (FRZ_PRE)
- Caught without the control (D_abl): Stage 5 exits non-zero (its own independent count checks)

## Arm B
- Stage 5 exit 0; outputs equal frozen stage-05/deeper: YES (8/8); with-control check on B: clean

## Arms (C32_arms.csv)
| arm | pre_exit | s5_exit | frz_pre_changed | frz_post_changed | s5_outputs_differ_vs_B | s5_added_files | label_check_fail | action_set_differs | rank_or_priority_cols | in_H | caught_with | caught_without |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | NA | 0 |  |  |  |  |  |  |  | NA | FALSE | FALSE |
| FB_KGRID | 0 | 0 | R-B\outputs\RB_kappa_grid_counts.csv | R-B\outputs\RB_kappa_grid_counts.csv | kappa_sensitivity.csv |  |  |  |  | TRUE | TRUE | FALSE |
| FB_TF24 | 0 | 0 | R-A\outputs\RA_classifications.csv | R-A\outputs\RA_classifications.csv | escalate_dormancy_summary.csv |  | escalate_dormancy_summary.csv |  |  | TRUE | TRUE | FALSE |
| FB_CLAUSE | 0 | 0 | R-A\outputs\RA_classifications.csv | R-A\outputs\RA_classifications.csv | inconclusive_by_clause.csv |  | inconclusive_by_clause.csv |  |  | TRUE | TRUE | FALSE |
| FB_ROUND | 0 | 0 | R-A\outputs\RA_classifications.csv | R-A\outputs\RA_classifications.csv | escalate_dormancy_summary.csv |  | escalate_dormancy_summary.csv |  |  | TRUE | TRUE | FALSE |
| FB_RECLASS | 0 | 1 | R-A\outputs\RA_classifications.csv | R-A\outputs\RA_classifications.csv |  |  |  |  |  | FALSE | TRUE | TRUE |
| FB_VALSORT | 0 | 0 | outputs\validated_action_list.csv | outputs\validated_action_list.csv |  |  |  |  |  | FALSE | TRUE | FALSE |

## Sets
- H = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND}
- caught with the control = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND,FB_RECLASS,FB_VALSORT}
- D_abl (caught without) = {FB_RECLASS}
- H \ D_abl (escapes once the control is removed) = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND}
- H \ caught-with (missed even with the control) = {}
- flagged with the control but not in H (control cost / over-blocking) = {FB_RECLASS,FB_VALSORT}

## Predicate P1 (frozen)
KEEP-side requires arm B clean and H \ D_abl = {} (removing the control lets no harm through). Otherwise the control stays.
P1 failed: H \ D_abl = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND}
