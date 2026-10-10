# C34 RESULTS — Deterministic Workflow Gate (catalog #34) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 5/5
- H2b arm B Stage 4->5: receipt PASS, gate PASS (exit 0), Stage 5 exit 0; Stage 5 files differing from the frozen stage-05/deeper: none
- H4 Stage-5 harm set H (Stage 5 completed with exit 0 and at least one Stage-5 output differs from arm B): {W_RB_NOTHIN,W_RA_ROUND1}
- H4b arms with any classification locked-field change vs arm B (context): {W_RA_NOTHIN,W_RB_NOTHIN,W_RB_K25,W_RA_ROUND1}
- H5 caught without the control [Stage 5 exits non-zero (its own independent count checks or a missing input); the gate result is ignored]: {W_RA_NOTHIN,W_RB_CRASH}
- H6 H minus caught-without-control: {W_RB_NOTHIN,W_RA_ROUND1}
- H7 arms with Stage 5 exit 0 and no Stage-5 output difference: {W_RB_K25}
- H8 caught with the control [workflow gate result FAIL, or Stage 5 exits non-zero]: {W_RA_NOTHIN,W_RB_NOTHIN,W_RB_K25,W_RB_CRASH}
- H9 gate FAIL, Stage 5 exit 0, no Stage-5 output difference: {W_RB_K25}

## Arm B repro vs frozen pack
| cmp | n_only_x | n_only_truth | n_label_diff | n_dormant_diff | n_open_age_diff |
|---|---|---|---|---|---|
| B R-A vs frozen RA_classifications | 0 | 0 | 0 | 0 | 0 |
| B R-B vs frozen RB_classifications | 0 | 0 | 0 | 0 | 0 |

## Arm B recon (R-A vs R-B)
| n_ra | n_rb | n_inner | n_only_ra | n_only_rb | n_disagree | n_dormant_mismatch | n_open_age_mismatch |
|---|---|---|---|---|---|---|---|
| 222002 | 222002 | 222002 | 0 | 0 | 0 | 1 | 2 |

## Seeded arms
| arm | paths_run | change | exit | fx_RA | fx_RB | recon_only_ra | recon_only_rb | recon_disagree | recon_dormant_mismatch | recon_open_age_mismatch | RA_vs_B | RB_vs_B | locked_field_changes_vs_B | decision_changes_vs_B | harm | inputs_differing_from_B | caught_with_control | caught_without_control |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| W_RA_NOTHIN | RA+RB | Stage-4 failure: R-A drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs | RA=0 RB=0 | 13/14 (F06) | 14/14 | 0 | 0 | 6377 | 1 | 2 | only_x=0 only_B=0 label=6377 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 6377 | 6377 | TRUE | R-A\run_RA.R | NA | TRUE |
| W_RB_NOTHIN | RA+RB | Stage-4 failure: R-B drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs | RA=0 RB=0 | 14/14 | 13/14 (F06) | 0 | 0 | 6377 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=6377 dormant=0 open_age=0 | 6377 | 6377 | TRUE | R-B\R\20_integrity_and_classify.R | NA | TRUE |
| W_RB_K25 | RA+RB | Stage-4 failure: R-B production kappa 2.5 (recon fails); Stage 5 then runs | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 6893 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=6893 dormant=0 open_age=0 | 6893 | 6893 | TRUE | R-B\R\00_config.R | NA | TRUE |
| W_RB_CRASH | RA+RB | Stage-4 failure: R-B exits non-zero with no outputs; Stage 5 then runs | RA=0 RB=1 | 14/14 | NA/NA (MISSING_FILE) | NA | NA | NA | NA | NA | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=NA only_B=NA label=NA dormant=NA open_age=NA | 0 | 0 | FALSE | R-B\R\20_integrity_and_classify.R | NA | TRUE |
| W_RA_ROUND1 | RA+RB | R-A reports dormant_h rounded to 0.1 h (labels unchanged; the frozen key+label recon passes); Stage 5 then runs | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 221457 | 2 | only_x=0 only_B=0 label=0 dormant=221457 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 221457 | 0 | TRUE | R-A\run_RA.R | NA | FALSE |

## Stage 4 -> gate -> Stage 5 per arm (C34_stage45.csv)
| arm | receipt_status | receipt_unresolved | receipt_fail_fields | gate_exit | gate_result | validated_list_exit | stage5_exit | stage5_files_differing_from_B | n_stage5_files_differing |
|---|---|---|---|---|---|---|---|---|---|
| B | PASS | 0 |  | 0 | PASS | 0 | 0 |  | 0 |
| W_RA_NOTHIN | FAIL | 2 | r_a_fixtures;reconciliation | 1 | FAIL | 0 | 1 | independent_checks_critical_counts.csv;portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;inconclusive_by_clause.csv;escalate_dormancy_summary.csv;kappa_sensitivity.csv;capacity_coverage_note.csv | 8 |
| W_RB_NOTHIN | FAIL | 2 | r_b_fixtures;reconciliation | 1 | FAIL | 0 | 0 | kappa_sensitivity.csv | 1 |
| W_RB_K25 | FAIL | 1 | reconciliation | 1 | FAIL | 0 | 0 |  | 0 |
| W_RB_CRASH | FAIL | 3 | r_b_status;r_b_fixtures;reconciliation | 1 | FAIL | 0 | 1 | independent_checks_critical_counts.csv;portfolio_summary.csv;escalate_by_type.csv;escalate_by_type_top25.csv;inconclusive_by_clause.csv;escalate_dormancy_summary.csv;kappa_sensitivity.csv;capacity_coverage_note.csv | 8 |
| W_RA_ROUND1 | PASS | 0 |  | 0 | PASS | 0 | 0 | escalate_dormancy_summary.csv | 1 |

