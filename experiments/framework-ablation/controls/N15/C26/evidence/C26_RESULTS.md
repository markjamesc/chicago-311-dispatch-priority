# C26 RESULTS — Frozen Source Package (catalog #26) ablation (runner output, mechanical facts only)

Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).
In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.

## Mechanical facts
- H1 arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2
- H3 seeded arms with every run recorded: 6/6
- H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): {S_STALE24,S_PEER10,S_ONEROW}
- H5 caught without the control [crash, recon key/label mismatch, or fixture failure on any path (no source checksum check)]: {S_STALE24,S_PEER10}
- H6 H minus caught-without-control: {S_ONEROW}
- H7 arms with no locked-field change: {S_LF,S_REVERSE,S_BOOLCASE}
- H8 caught with the control [crash, source-file SHA-256 differs from the frozen source, recon key/label mismatch, or fixture failure on any path]: {S_STALE24,S_PEER10,S_ONEROW,S_LF,S_REVERSE,S_BOOLCASE}
- H9 caught with the control but no locked-field change: {S_LF,S_REVERSE,S_BOOLCASE}

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
| S_STALE24 | RB | R-B reads a stale snapshot: rows with created_ts >= 2026-09-11 23:59:59 removed | RB=0 | 14/14 | 14/14 | 773 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=773 label=0 dormant=0 open_age=0 | 773 | 773 | TRUE | data\source\src_open_candidates.csv | TRUE | TRUE |
| S_PEER10 | RB | R-B reads peer stats with peer_p75_h of the most frequent open type_key x1.10 | RB=0 | 14/14 | 14/14 | 0 | 0 | 269 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=269 dormant=0 open_age=0 | 269 | 269 | TRUE | data\source\src_peer_stats.csv | TRUE | TRUE |
| S_ONEROW | RB | R-B source: one in-set row's mod_ts/LAST_MODIFIED_DATE moved 30 days earlier | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 2 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=1 open_age=0 | 1 | 0 | TRUE | data\source\src_open_candidates.csv | TRUE | FALSE |
| S_LF | RB | R-B source re-saved with LF line endings (bytes differ, content identical) | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 0 | 0 | FALSE | data\source\src_open_candidates.csv | TRUE | FALSE |
| S_REVERSE | RB | R-B source with data rows in reverse order (bytes differ, same rows) | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 0 | 0 | FALSE | data\source\src_open_candidates.csv | TRUE | FALSE |
| S_BOOLCASE | RB | R-B source with DUPLICATE/LEGACY_RECORD true/false written as TRUE/FALSE | RB=0 | 14/14 | 14/14 | 0 | 0 | 0 | 1 | 2 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | only_x=0 only_B=0 label=0 dormant=0 open_age=0 | 0 | 0 | FALSE | data\source\src_open_candidates.csv | TRUE | FALSE |

