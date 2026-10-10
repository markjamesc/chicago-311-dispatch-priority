# C40 POST-PROTOCOL RESULTS (mechanical; generated 2026-10-03 12:48:00 CDT)

**Mechanical predicate result: NOT TRIGGERED (cap never reached; no verdict; no Builder/Validator/Adjudicator chats)**

Outcome class: NOT_TRIGGERED. Incumbent first PASS: 2. Fresh first PASS: NA. Diverged: FALSE.


## Predicate conditions
| condition | met |
|---|---|
| 1. variant valid build: the fresh builder passes the gate within its cap (2 failed rounds) | n/a |
| 2. no later: variant active time from divergence <= baseline active time from divergence (baseline without a valid build by r6 = infinite) | n/a |
| 3. no defect escapes: the variant's valid build passes the hidden depth check (ruling-41A depth gate, never shown to builders) | n/a |

## Rounds
| arm | round | gate | rb_exit | fixtures | classifications_equal | hidden_depth_gate | reply_min | gate_min | round_active_min | code_sha256 |
|---|---|---|---|---|---|---|---|---|---|---|
| INC | 1 | FAIL | 1 | 14/14 | FALSE | not run (gate FAIL) | 7.12 | 0.05 | 7.17 | 0cd186b31311d1b9 |
| INC | 2 | PASS | 0 | 14/14 | TRUE | PASS | 0.73 | 0.46 | 1.19 | 72d49def1fbd7043 |

## STATE_LOG.txt
```
2026-10-03 12:24:30 CDT wrote C40/C40-INC/r2/MESSAGE.txt
2026-10-03 12:46:31 CDT INC r2 PASS -> NOT_TRIGGERED (valid build within the cap; regimes identical; no fresh builder; no B/V/G chats)
```

