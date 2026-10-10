# C15 RESULTS — Ranking/Capacity Framing-Only (catalog #15) ablation (runner output, mechanical facts only)

Every arm starts from the frozen validated state (RA_classifications.csv, RB_kappa_grid_counts.csv, validated_action_list.csv copied from the frozen pack) and records VALIDATION_FREEZE.sha256 before anything else runs.
Arm B runs the frozen-path Stage-5 harness with no edit and is the truth reference. Seeded arms apply the listed edit (PRE step) or Stage-5 variant.

## Definitions (frozen in the spec)
- Harm set H: Stage 5 completes and writes an SR-level action output whose SR set differs from the validated (unordered) ESCALATE set
- Caught with the control: the framing-scope check fails: Stage 3 capacity flag is RANKING_NOT_IN_SCOPE, so any Stage-5 SR-level output whose set differs from the validated set, or any rank/priority column, is blocked
- Caught without the control (D_abl): Stage 5 exits non-zero (its own independent count checks)

## Arm B
- Stage 5 exit 0; outputs equal frozen stage-05/deeper: YES (8/8); with-control check on B: clean

## Arms (C15_arms.csv)
| arm | pre_exit | s5_exit | frz_pre_changed | frz_post_changed | s5_outputs_differ_vs_B | s5_added_files | label_check_fail | action_set_differs | rank_or_priority_cols | in_H | caught_with | caught_without |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | NA | 0 |  |  |  |  |  |  |  | NA | FALSE | FALSE |
| RK_CAP200 | NA | 0 |  |  |  | final_action_list.csv |  | final_action_list.csv | final_action_list.csv | TRUE | TRUE | FALSE |
| RK_TYPECAP | NA | 0 |  |  |  | final_action_list.csv |  | final_action_list.csv |  | TRUE | TRUE | FALSE |
| RK_KAPPACAP | NA | 0 |  |  |  | final_action_list.csv |  | final_action_list.csv |  | TRUE | TRUE | FALSE |
| RK_RANKONLY | NA | 0 |  |  |  | final_action_list.csv |  |  | final_action_list.csv | FALSE | TRUE | FALSE |
| RK_PRECAP | NA | 1 |  |  |  |  |  |  |  | FALSE | FALSE | TRUE |
| RK_BENIGN | NA | 0 |  |  | capacity_coverage_note.csv |  |  |  |  | FALSE | FALSE | FALSE |

## Sets
- H = {RK_CAP200,RK_TYPECAP,RK_KAPPACAP}
- caught with the control = {RK_CAP200,RK_TYPECAP,RK_KAPPACAP,RK_RANKONLY}
- D_abl (caught without) = {RK_PRECAP}
- H \ D_abl (escapes once the control is removed) = {RK_CAP200,RK_TYPECAP,RK_KAPPACAP}
- H \ caught-with (missed even with the control) = {}
- flagged with the control but not in H (control cost / over-blocking) = {RK_RANKONLY}

## Predicate P1 (frozen)
KEEP-side requires arm B clean and H \ D_abl = {} (removing the control lets no harm through). Otherwise the control stays.
P1 failed: H \ D_abl = {RK_CAP200,RK_TYPECAP,RK_KAPPACAP}
