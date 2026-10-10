# C11 RESULTS — Method Constants vs Knobs (catalog #11) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 4/4
- H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): {K_NMIN30_CM,K_NMIN75_CM,K_NMIN100_CM,K_NMIN30_RB}
- H5 caught without the control [crash, recon key/label mismatch, or fixture failure on any path (n_min treated as a tunable knob)]: {K_NMIN100_CM,K_NMIN30_RB}
- H6 H minus caught-without-control: {K_NMIN30_CM,K_NMIN75_CM}
- H7 arms with no locked-field change: {}
- H8 caught with the control [crash, a method constant (n_min) in the run code differs from the locked value 50, recon key/label mismatch, or fixture failure]: {K_NMIN30_CM,K_NMIN75_CM,K_NMIN100_CM,K_NMIN30_RB}
- H9 caught with the control but no locked-field change: {}

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
| K_NMIN30_CM | RA+RB | Method constant n_min retuned 50 -> 30 on both paths (treated as a knob) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=35 dormant=0 open_age=0 | only_x=0 only_B=0 label=35 dormant=0 open_age=0 | 70 | 70 | TRUE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | FALSE |
| K_NMIN75_CM | RA+RB | Method constant n_min retuned 50 -> 75 on both paths | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=14 dormant=0 open_age=0 | only_x=0 only_B=0 label=14 dormant=0 open_age=0 | 28 | 28 | TRUE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | FALSE |
| K_NMIN100_CM | RA+RB | Method constant n_min retuned 50 -> 100 on both paths | RA=0 RB=0 | 14/14 | 13/14 (F14) | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=33 dormant=0 open_age=0 | only_x=0 only_B=0 label=33 dormant=0 open_age=0 | 66 | 66 | TRUE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | TRUE |
| K_NMIN30_RB | RB | Method constant n_min retuned 50 -> 30 on R-B only | RB=0 | 14/14 | 14/14 | 0 | 0 | 35 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=35 dormant=0 open_age=0 | 35 | 35 | TRUE | R-B\R\00_config.R | TRUE | TRUE |

