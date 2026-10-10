# C31 RESULTS — Lineage Attestation (catalog #31) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 5/5
- H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): {L_STALE24,L_PEER10,L_TF24,L_K25}
- H5 caught without the control [crash, recon key/label mismatch, or fixture failure on any path (no lineage/manifest attestation)]: {}
- H6 H minus caught-without-control: {L_STALE24,L_PEER10,L_TF24,L_K25}
- H7 arms with no locked-field change: {L_COMMENT}
- H8 caught with the control [crash, any input file SHA-256 (source or code) differs from the frozen record, recon key/label mismatch, or fixture failure]: {L_STALE24,L_PEER10,L_TF24,L_K25,L_COMMENT}
- H9 caught with the control but no locked-field change: {L_COMMENT}

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
| L_STALE24 | RA+RB | Both paths read the stale snapshot (undocumented snapshot change) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=773 label=0 dormant=0 open_age=0 | only_x=0 only_B=773 label=0 dormant=0 open_age=0 | 1546 | 1546 | TRUE | data\source\src_open_candidates.csv | TRUE | FALSE |
| L_PEER10 | RA+RB | Both paths read the altered peer stats (undocumented) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=269 dormant=0 open_age=0 | only_x=0 only_B=0 label=269 dormant=0 open_age=0 | 538 | 538 | TRUE | data\source\src_peer_stats.csv | TRUE | FALSE |
| L_TF24 | RA+RB | Both paths' T_freeze moved +24 h (undocumented config change) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=573 dormant=222002 open_age=222002 | only_x=0 only_B=0 label=573 dormant=222002 open_age=222002 | 889154 | 1146 | TRUE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | FALSE |
| L_K25 | RA+RB | Both paths' kappa 2.0 -> 2.5 (undocumented knob change) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=6893 dormant=0 open_age=0 | only_x=0 only_B=0 label=6893 dormant=0 open_age=0 | 13786 | 13786 | TRUE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | FALSE |
| L_COMMENT | RA+RB | Comment-only edit in both paths (bytes differ, no semantic change) | RA=0 RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 0 | 0 | FALSE | R-A\run_RA.R; R-B\R\00_config.R | TRUE | FALSE |

