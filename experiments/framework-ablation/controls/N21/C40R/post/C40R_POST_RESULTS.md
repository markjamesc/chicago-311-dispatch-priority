# C40R POST-PROTOCOL RESULTS (mechanical; generated 2026-10-10 16:01:18)

**Mechanical predicate result: HALT**

HALT reasons:
- a TIMES.txt record is missing for a post-divergence round

Outcome class: BOTH_CENSORED. Incumbent first PASS: None. Fresh first PASS: None. Diverged: True.

## Predicate conditions
| condition | met |
|---|---|
| 1. variant valid build: the fresh builder passes the gate within its cap (2 failed rounds) | n/a |
| 2. no later: variant active time from divergence <= baseline active time from divergence (baseline without a valid build by r6 = infinite) | n/a |
| 3. no defect escapes: the variant's valid build passes the hidden depth check (ruling-41A depth gate, never shown to builders) | n/a |

## Rounds
| arm | round | gate | rb_exit | fixtures | classifications_equal | hidden_depth_gate | reply_min | gate_min | round_active_min | code_sha256 |
|---|---|---|---|---|---|---|---|---|---|---|
| INC | 1 | FAIL | 0 | 14/14 | FALSE | not run (gate FAIL) | 3.48 | 0.59 | 4.08 | MISSING |
| INC | 2 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 12.03 | 0.52 | 12.55 | MISSING |
| INC | 3 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | None | 0.53 | None | MISSING |
| INC | 4 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 9.82 | 0.53 | 10.34 | MISSING |
| INC | 5 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 7.97 | 0.54 | 8.51 | MISSING |
| INC | 6 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 4.87 | 0.6 | 5.47 | 197aea5662b6ca8f |
| FRESH | 1 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 4.02 | 0.43 | 4.45 | MISSING |
| FRESH | 2 | FAIL | 0 | 14/14 | TRUE | not run (gate FAIL) | 6.23 | 0.7 | 6.93 | MISSING |

## STATE_LOG.txt
```
2026-10-10 14:05:57 CDT wrote C40R/C40R-INC/r2/MESSAGE.txt
2026-10-10 14:21:36 CDT wrote C40R/packets/C40R_2_FRESH_BUILDER_ChatGPT.txt
2026-10-10 14:21:36 CDT DIVERGED after INC r2 FAIL: variant = fresh builder (packet C40R/packets/C40R_2_FRESH_BUILDER_ChatGPT.txt, new chat); baseline = INC continues
2026-10-10 14:21:36 CDT wrote C40R/C40R-INC/r3/MESSAGE.txt
2026-10-10 15:13:43 CDT wrote C40R/C40R-FRESH/r2/MESSAGE.txt
2026-10-10 15:16:58 CDT wrote C40R/C40R-INC/r4/MESSAGE.txt
2026-10-10 15:25:12 CDT FRESH r2 FAIL -> FRESH_ESCALATED (cap reached again; escalate to the owner)
2026-10-10 15:36:31 CDT wrote C40R/C40R-INC/r5/MESSAGE.txt
2026-10-10 15:51:31 CDT wrote C40R/C40R-INC/r6/MESSAGE.txt
2026-10-10 16:00:01 CDT INC r6 FAIL at the experiment stop -> INC_CENSORED (no valid build by r6)
```
