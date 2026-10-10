# C36 RESULTS — No Re-Judging of Validation Labels (catalog #36) ablation (runner output, mechanical facts only)

Every arm starts from the frozen validated state (RA_classifications.csv, RB_kappa_grid_counts.csv, validated_action_list.csv copied from the frozen pack) and records VALIDATION_FREEZE.sha256 before anything else runs.
Arm B runs the frozen-path Stage-5 harness with no edit and is the truth reference. Seeded arms apply the listed edit (PRE step) or Stage-5 variant.

## Definitions (frozen in the spec)
- Harm set H: Stage 5 completes and a label-derived output (portfolio_summary, escalate_by_type(_top25), inconclusive_by_clause, escalate_dormancy_summary) differs from arm B, or an added output's SR-level labels or class totals disagree with the validated labels
- Caught with the control: the label-consistency check (same definition as H, applied before release) fails
- Caught without the control (D_abl): Stage 5 exits non-zero (its own independent count checks)

## Arm B
- Stage 5 exit 0; outputs equal frozen stage-05/deeper: YES (8/8); with-control check on B: clean

## Arms (C36_arms.csv)
| arm | pre_exit | s5_exit | frz_pre_changed | frz_post_changed | s5_outputs_differ_vs_B | s5_added_files | label_check_fail | action_set_differs | rank_or_priority_cols | in_H | caught_with | caught_without |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | NA | 0 |  |  |  |  |  |  |  | NA | FALSE | FALSE |
| RJ_INC2ESC | NA | 0 |  |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;inconclusive_by_clause.csv;escalate_dormancy_summary.csv |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;inconclusive_by_clause.csv;escalate_dormancy_summary.csv |  |  | TRUE | TRUE | FALSE |
| RJ_KAPPA3 | NA | 0 |  |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;escalate_dormancy_summary.csv |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;escalate_dormancy_summary.csv |  |  | TRUE | TRUE | FALSE |
| RJ_OPENAGE | NA | 0 |  |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;escalate_dormancy_summary.csv |  | portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;escalate_dormancy_summary.csv |  |  | TRUE | TRUE | FALSE |
| RJ_PRECHECK | NA | 1 |  |  |  |  |  |  |  | FALSE | FALSE | TRUE |
| RJ_BENIGN | NA | 0 |  |  |  | escalate_by_peer_n_bin.csv |  |  |  | FALSE | FALSE | FALSE |

## Sets
- H = {RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}
- caught with the control = {RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}
- D_abl (caught without) = {RJ_PRECHECK}
- H \ D_abl (escapes once the control is removed) = {RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}
- H \ caught-with (missed even with the control) = {}
- flagged with the control but not in H (control cost / over-blocking) = {}

## Predicate P1 (frozen)
KEEP-side requires arm B clean and H \ D_abl = {} (removing the control lets no harm through). Otherwise the control stays.
P1 failed: H \ D_abl = {RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}
