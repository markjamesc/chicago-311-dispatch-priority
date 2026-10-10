# C35 RESULTS — Freeze Validated Pack (catalog #35) ablation (runner output, mechanical facts only)

Every arm starts from the frozen validated state (RA_classifications.csv, RB_kappa_grid_counts.csv, validated_action_list.csv copied from the frozen pack) and records VALIDATION_FREEZE.sha256 before anything else runs.
Arm B runs the frozen-path Stage-5 harness with no edit and is the truth reference. Seeded arms apply the listed edit (PRE step) or Stage-5 variant.

## Definitions (frozen in the spec)
- Harm set H: after Stage 5, at least one validated file (RA_classifications, RB_kappa_grid_counts, validated_action_list) differs from the validation freeze (FRZ_POST)
- Caught with the control: the archived validation freeze is compared after Stage 5 (FRZ_POST check) and any changed validated file is reported
- Caught without the control (D_abl): Stage 5 exits non-zero (its own independent count checks)

## Arm B
- Stage 5 exit 0; outputs equal frozen stage-05/deeper: YES (8/8); with-control check on B: clean

## Arms (C35_arms.csv)
| arm | pre_exit | s5_exit | frz_pre_changed | frz_post_changed | s5_outputs_differ_vs_B | s5_added_files | label_check_fail | action_set_differs | rank_or_priority_cols | in_H | caught_with | caught_without |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | NA | 0 |  |  |  |  |  |  |  | NA | FALSE | FALSE |
| FV_VALSORT | NA | 0 |  | outputs\validated_action_list.csv |  |  |  |  |  | TRUE | TRUE | FALSE |
| FV_ADDRANK | NA | 0 |  | R-A\outputs\RA_classifications.csv |  |  |  |  |  | TRUE | TRUE | FALSE |
| FV_ROUND | NA | 0 |  | R-A\outputs\RA_classifications.csv |  |  |  |  |  | TRUE | TRUE | FALSE |
| FV_DROPTHIN | NA | 0 |  | outputs\validated_action_list.csv |  |  |  |  |  | TRUE | TRUE | FALSE |
| FV_EARLY | NA | 1 |  | outputs\validated_action_list.csv |  |  |  |  |  | TRUE | TRUE | TRUE |
| FV_BENIGN | NA | 0 |  |  |  | diag_type_by_class.csv |  |  |  | FALSE | FALSE | FALSE |

## Sets
- H = {FV_VALSORT,FV_ADDRANK,FV_ROUND,FV_DROPTHIN,FV_EARLY}
- caught with the control = {FV_VALSORT,FV_ADDRANK,FV_ROUND,FV_DROPTHIN,FV_EARLY}
- D_abl (caught without) = {FV_EARLY}
- H \ D_abl (escapes once the control is removed) = {FV_VALSORT,FV_ADDRANK,FV_ROUND,FV_DROPTHIN}
- H \ caught-with (missed even with the control) = {}
- flagged with the control but not in H (control cost / over-blocking) = {}

## Predicate P1 (frozen)
KEEP-side requires arm B clean and H \ D_abl = {} (removing the control lets no harm through). Otherwise the control stays.
P1 failed: H \ D_abl = {FV_VALSORT,FV_ADDRANK,FV_ROUND,FV_DROPTHIN}
