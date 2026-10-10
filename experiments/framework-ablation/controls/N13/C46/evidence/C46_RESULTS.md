# C46 RESULTS (mechanical; generated 2026-10-03 09:41:54 CDT)

**Mechanical predicate result: P1 NOT MET**

## Predicate conditions
| condition | met |
|---|---|
| BASE: >= 1 reconciliation event (baseline regime produces spurious mismatch) | MET |
| DECL: 0 reconciliation events | MET |
| DEFECT_DECL: recon FAIL (declared regime still catches a real defect) | MET |
| DECL R-A vs REF (canonical, thresh 1e-14): max|dp| <= 1e-6 and identical flags | NOT MET |
| extra rebuilds: BASE >= 1 and DECL = 0 | MET |

## Arms
| arm | regime | ra_order | rb_order | thresh | rb_drop | jerr_RA | jerr_RB | recon | events | max_abs_dp | fail_p | fail_p_pct1 | fail_flag | extra_rebuilds |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| BASE | baseline | natural | reversed | 1e-7 | - | 0 | 0 | FAIL | 2 | 0.008446989841342178 | 0 | 17564 | 11 | 2 |
| DECL | declared | canonical | canonical | 1e-12 | - | 0 | 0 | PASS | 0 | 0 | 0 | 0 | 0 | 0 |
| THRESH_ONLY | baseline | natural | reversed | 1e-12 | - | 0 | 0 | FAIL | 1 | 9.44668978275498e-6 | 0 | 30 | 0 | 1 |
| ORDER_ONLY | baseline | canonical | canonical | 1e-7 | - | 0 | 0 | PASS | 0 | 0 | 0 | 0 | 0 | 0 |
| DEFECT_DECL | declared | canonical | canonical | 1e-12 | x_log_peer_p75 | 0 | 0 | FAIL | 3 | 0.766791177978111 | 193060 | 111789 | 2070 | 3 |
| DEFECT_BASE | baseline | natural | reversed | 1e-7 | x_log_peer_p75 | 0 | 0 | FAIL | 3 | 0.7656221672416856 | 12890 | 111885 | 2082 | 3 |

## DECL vs REF
- max|dp| = 5.33069e-05 ; flag differences = 0

## Fit info
| arm | path | order | thresh | drop | n | p_cols | npasses | jerr | dev_ratio_last | secs |
|---|---|---|---|---|---|---|---|---|---|---|
| REF | RA | canonical | 1e-14 | - | 215687 | 32 | 16386 | 0 | 0.8356498569181723 | 48.5 |
| BASE | RA | natural | 1e-7 | - | 215687 | 32 | 1220 | 0 | 0.8356434248182028 | 12.8 |
| BASE | RB | reversed | 1e-7 | - | 215687 | 32 | 1223 | 0 | 0.8356412282097697 | 12.9 |
| DECL | RA | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 33.3 |
| DECL | RB | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 34.3 |
| THRESH_ONLY | RA | natural | 1e-12 | - | 215687 | 32 | 8088 | 0 | 0.8356498304330563 | 27 |
| THRESH_ONLY | RB | reversed | 1e-12 | - | 215687 | 32 | 8682 | 0 | 0.8356498321830208 | 28.7 |
| ORDER_ONLY | RA | canonical | 1e-7 | - | 215687 | 32 | 1500 | 0 | 0.8356432205347253 | 12.4 |
| ORDER_ONLY | RB | canonical | 1e-7 | - | 215687 | 32 | 1500 | 0 | 0.8356432205347253 | 12.6 |
| DEFECT_DECL | RA | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 32.5 |
| DEFECT_DECL | RB | canonical | 1e-12 | x_log_peer_p75 | 215687 | 31 | 2136 | 0 | 0.8294719972850374 | 14.9 |
| DEFECT_BASE | RA | natural | 1e-7 | - | 215687 | 32 | 1220 | 0 | 0.8356434248182028 | 12.6 |
| DEFECT_BASE | RB | reversed | 1e-7 | x_log_peer_p75 | 215687 | 31 | 533 | 0 | 0.8294668664093228 | 11.2 |
