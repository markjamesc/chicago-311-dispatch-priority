# C27 RESULTS — Fixtures on Both Paths ablation (runner output, mechanical facts only)

Baseline regime: both R-A and R-B must pass the 14 fixtures before production is trusted. Ablated regime: only R-A's fixtures run; R-B is trusted if exact recon vs R-A is clean.
Seeds: 9 single-rule deletions in R-B 20_integrity_and_classify.R, one per fixture-protected rule (frozen before the run; see seed diffs).

## Mechanical facts
- H1 clean arm B: R-A exit 0, R-B exit 0; fixtures R-A 14/14, R-B 14/14
- H2 clean arm reproduces frozen labels and recon 0/0/0: TRUE
- H3 all 9 mutant runs present (exit recorded): TRUE
- H4 D_fix (caught by R-B's own fixtures = baseline regime): {M01,M02,M04,M05,M06,M07,M08}
- H5 D_abl (caught with R-B fixtures skipped: R-A fixtures + exact recon vs R-A, or crash): {M01,M04,M05,M06}
- H6 D_fix minus D_abl (defects only the second-path fixture run catches): {M02,M07,M08}
- H7 caught by neither regime: {M03,M09}

## Clean arm repro vs frozen pack
| cmp | n_x | n_truth | n_only_x | n_only_truth | n_label_diff | n_dormant_diff | max_abs_d_dormant_h | max_abs_d_open_age_h |
|---|---|---|---|---|---|---|---|---|
| B R-A vs frozen RA_classifications | 222002 | 222002 | 0 | 0 | 0 | 0 | 0 | 0 |
| B R-B vs frozen RB_classifications | 222002 | 222002 | 0 | 0 | 0 | 0 | 0 | 0 |

## Clean arm recon
| n_ra | n_rb | n_inner | n_only_ra | n_only_rb | n_agree | n_disagree |
|---|---|---|---|---|---|---|
| 222002 | 222002 | 222002 | 0 | 0 | 222002 | 0 |

## Mutants
| mutant | rule_removed | exit | rb_fixtures | rb_fixtures_failed | recon_n_rb | recon_only_ra | recon_only_rb | recon_disagree | prod_rows_changed_vs_clean_RB | detected_baseline_regime | detected_ablated_regime |
|---|---|---|---|---|---|---|---|---|---|---|---|
| M01 | kappa rule uses peer p50 instead of p75 (F01-F03,F10,F11) | 0 | 12/14 | F03;F10 | 222002 | 0 | 0 | 16973 | 16973 | TRUE | TRUE |
| M02 | I01 Open+CLOSED_DATE contradiction deleted (F04) | 0 | 13/14 | F04 | 222002 | 0 | 0 | 0 | 0 | TRUE | FALSE |
| M03 | I02 mod<created sub-clause deleted (F05) | 0 | 14/14 |  | 222002 | 0 | 0 | 0 | 0 | FALSE | FALSE |
| M04 | I04 thin peer_n<n_min deleted (F06) | 0 | 13/14 | F06 | 222002 | 0 | 0 | 6377 | 6377 | TRUE | TRUE |
| M05 | DUPLICATE exclusion deleted (F07) | 0 | 13/14 | F07 | 245014 | 0 | 23012 | 0 | 23012 | TRUE | TRUE |
| M06 | LEGACY_RECORD exclusion deleted (F08) | 0 | 13/14 | F08 | 222176 | 0 | 174 | 0 | 174 | TRUE | TRUE |
| M07 | I05 PARENT_SR_NUMBER clause deleted (F09) | 0 | 13/14 | F09 | 222002 | 0 | 0 | 0 | 0 | TRUE | FALSE |
| M08 | not-Open exclusion deleted (F12) | 0 | 13/14 | F12 | 222002 | 0 | 0 | 0 | 0 | TRUE | FALSE |
| M09 | I02 unparseable/missing CREATED sub-clause deleted (F13) | 0 | 14/14 |  | 222002 | 0 | 0 | 0 | 0 | FALSE | FALSE |

