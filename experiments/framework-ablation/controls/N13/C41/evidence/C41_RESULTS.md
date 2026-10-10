# C41 RESULTS (mechanical; generated 2026-10-03 10:39:08 CDT)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. superset: every seeded arm the count gate catches is also caught by the depth gate | MET |
| 2. ruled targets: the depth gate catches P_DUPINT (flag read as a number), P_DATESWAP (date-parse error) and STUB_F11 (always-pass test case) | MET |
| 3. clean arm B: count gate PASS, depth gate PASS (no false flag), and B's 4 R-B key outputs equal the frozen hashes | MET |
| 4. cost: clean arm B depth-gate wall time <= count-gate wall time + 60 s (no extra chats by construction) | MET |

## Arms
| arm | count_exit | count_s | count_gate | count_n_pass | depth_exit | depth_s | depth_gate | depth_n_pass | depth_stubs | depth_error | rb_all_exit | rb_all_s | rb_outputs_equal_frozen | caught_count | caught_depth | real_effect |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | 0 | 0.5 | PASS | 14 | 0 | 1.2 | PASS | 14 | none |  | 0 | 25.2 | 4/4 | FALSE | FALSE | - |
| P_DUPINT | 0 | 0.8 | PASS | 14 | 0 | 1.4 | FAIL | 13 | none |  | 0 | 25.2 | 1/4 | FALSE | TRUE | production outputs differ from frozen |
| P_DATESWAP | 0 | 0.6 | PASS | 14 | 0 | 1.6 | FAIL | 10 | none |  | 0 | 24.9 | 1/4 | FALSE | TRUE | production outputs differ from frozen |
| STUB_F11 | 0 | 0.4 | PASS | 14 | 0 | 1.3 | FAIL | 14 | F11 |  | 0 | 26.3 | 4/4 | FALSE | TRUE | none (production outputs = frozen) |
| JUDGE_P50 | 0 | 0.8 | FAIL | 12 | 0 | 1.5 | FAIL | 12 | none |  | 0 | 26.4 | 0/4 | TRUE | TRUE | production outputs differ from frozen |
| P_TZUTC | 0 | 1.2 | PASS | 14 | 0 | 2.2 | PASS | 14 | none |  | 0 | 27.4 | 1/4 | FALSE | FALSE | production outputs differ from frozen |

## Failing fixtures per arm and gate
| arm | count_failing | depth_failing |
|---|---|---|
| B |  |  |
| P_DUPINT |  | F07 |
| P_DATESWAP |  | F03/F05/F10/F14 |
| STUB_F11 |  |  |
| JUDGE_P50 | F03/F10 | F03/F10 |
| P_TZUTC |  |  |

## Counts
- seeded arms caught by the count gate: JUDGE_P50
- seeded arms caught by the depth gate: P_DUPINT, P_DATESWAP, STUB_F11, JUDGE_P50
- INFO probe P_TZUTC: count gate PASS, depth gate PASS, real effect: production outputs differ from frozen

## Arm B R-B outputs vs frozen
| file | frozen | arm_B |
|---|---|---|
| R-B/outputs/RB_classifications.csv | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 |
| R-B/outputs/RB_fixture_results.csv | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 |
| R-B/outputs/RB_portfolio_counts.csv | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c |
| R-B/outputs/RB_kappa_grid_counts.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a |
