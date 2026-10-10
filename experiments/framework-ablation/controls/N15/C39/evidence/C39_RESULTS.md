# C39 RESULTS — Reconciliation scope & tolerance (addendum #39) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 4/4
- H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): {R_ROUND1,R_OPENAGE,R_NOTHIN}
- H5 caught without the control [crash, decision-field recon mismatch (key set, classification only), or fixture failure]: {R_NOTHIN}
- H6 H minus caught-without-control: {R_ROUND1,R_OPENAGE}
- H7 arms with no locked-field change: {R_GT}
- H8 caught with the control [crash, full-field recon mismatch (key set, classification, dormant_h, open_age_h; |d| > 1e-6), or fixture failure]: {R_ROUND1,R_OPENAGE,R_GT,R_NOTHIN}
- H9 caught with the control but no locked-field change: {R_GT}

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
| R_ROUND1 | RB | R-B reports dormant_h rounded to 0.1 h (labels computed before rounding) | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 221457 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=221457 open_age=0 | 221457 | 0 | TRUE | R-B\R\20_integrity_and_classify.R | TRUE | FALSE |
| R_OPENAGE | RB | R-B reports open_age_h from mod_ts instead of created_ts (not a decision input) | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 221986 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=221986 | 221986 | 0 | TRUE | R-B\R\20_integrity_and_classify.R | TRUE | FALSE |
| R_GT | RB | R-B kappa threshold uses > instead of >= (boundary rows only) | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 0 | 0 | FALSE | R-B\R\20_integrity_and_classify.R | TRUE | FALSE |
| R_NOTHIN | RB | R-B I04 thin-peer integrity clause removed (decision defect) | RB=0 | 14/14 | 13/14 (F06) | 0 | 0 | 6377 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=6377 dormant=0 open_age=0 | 6377 | 6377 | TRUE | R-B\R\20_integrity_and_classify.R | TRUE | TRUE |

