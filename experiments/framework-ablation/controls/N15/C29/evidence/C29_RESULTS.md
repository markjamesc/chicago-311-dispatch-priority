# C29 RESULTS — Reconciliation Investigation (catalog #29) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 4/4
- H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): {X_RB_NODUP,X_RA_NODUP,X_RB_NOTHIN,X_RA_NOTHIN}
- H5 mismatch visible to the remaining checks (the ablated regime then auto-resolves it instead of rerunning) [crash, recon key/label mismatch, or fixture failure on any path]: {X_RB_NODUP,X_RA_NODUP,X_RB_NOTHIN,X_RA_NOTHIN}
- H6 H minus mismatch-visible: {}
- H7 arms with no locked-field change: {}
- H8 auto-resolution results equal to arm B (key set and classification): 4/12
- H9 scenario x rule pairs whose resolution differs from arm B: {X_RB_NODUP:copy_RB,X_RB_NODUP:max_severity,X_RA_NODUP:copy_RA,X_RA_NODUP:max_severity,X_RB_NOTHIN:copy_RB,X_RB_NOTHIN:max_severity,X_RA_NOTHIN:copy_RA,X_RA_NOTHIN:max_severity}

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
| X_RB_NODUP | RB | Mismatch from an R-B defect: DUPLICATE exclusion dropped (extra R-B keys) | RB=0 | 14/14 | 13/14 (F07) | 0 | 23012 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=23012 only_B=0 label=0 dormant=0 open_age=0 | 23012 | 23012 | TRUE | R-B\R\20_integrity_and_classify.R | NA | TRUE |
| X_RA_NODUP | RA | Mismatch from an R-A defect: DUPLICATE exclusion dropped (extra R-A keys) | RA=0 | 13/14 (F07) | 14/14 | 23012 | 0 | 0 | 1 | 2 | only_x=23012 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 23012 | 23012 | TRUE | R-A\run_RA.R | NA | TRUE |
| X_RB_NOTHIN | RB | Mismatch from an R-B defect: I04 thin-peer clause dropped (label disagreements) | RB=0 | 14/14 | 13/14 (F06) | 0 | 0 | 6377 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=6377 dormant=0 open_age=0 | 6377 | 6377 | TRUE | R-B\R\20_integrity_and_classify.R | NA | TRUE |
| X_RA_NOTHIN | RA | Mismatch from an R-A defect: I04 thin-peer clause dropped (label disagreements) | RA=0 | 13/14 (F06) | 14/14 | 0 | 0 | 6377 | 1 | 2 | only_x=0 only_B=0 label=6377 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 6377 | 6377 | TRUE | R-A\run_RA.R | NA | TRUE |

## Auto-resolution (rules frozen in the SPEC; truth = arm B R-A labels)
| scenario | rule | n_only_resolved | n_only_truth | n_label_diff | equals_truth |
|---|---|---|---|---|---|
| X_RB_NODUP | copy_RA | 0 | 0 | 0 | TRUE |
| X_RB_NODUP | copy_RB | 23012 | 0 | 0 | FALSE |
| X_RB_NODUP | max_severity | 23012 | 0 | 0 | FALSE |
| X_RA_NODUP | copy_RA | 23012 | 0 | 0 | FALSE |
| X_RA_NODUP | copy_RB | 0 | 0 | 0 | TRUE |
| X_RA_NODUP | max_severity | 23012 | 0 | 0 | FALSE |
| X_RB_NOTHIN | copy_RA | 0 | 0 | 0 | TRUE |
| X_RB_NOTHIN | copy_RB | 0 | 0 | 6377 | FALSE |
| X_RB_NOTHIN | max_severity | 0 | 0 | 24 | FALSE |
| X_RA_NOTHIN | copy_RA | 0 | 0 | 6377 | FALSE |
| X_RA_NOTHIN | copy_RB | 0 | 0 | 0 | TRUE |
| X_RA_NOTHIN | max_severity | 0 | 0 | 24 | FALSE |

