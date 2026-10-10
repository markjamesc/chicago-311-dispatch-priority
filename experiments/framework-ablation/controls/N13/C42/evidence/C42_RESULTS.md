# C42 RESULTS (mechanical; generated 2026-10-03 11:04:19 CDT)

**Mechanical predicate result: P1 NOT MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. owner interruptions go down: batched 2 < piecemeal 3 | MET |
| 2. repair rounds go down: batched 1 < piecemeal 1 | NOT MET |
| 3. nothing unresolved: 0 gating questions left unanswered in the batched final output (batched 0, piecemeal 0) | MET |
| 4. same answer either way: piecemeal and batched final outputs (4 R-B key outputs) are byte-identical | MET |
| 5. validity: arm R0 (switched code, no switch set) equals the frozen R-B outputs 4/4 | MET |

## Playback per question (answers 1B 2A 3A 4A 5A)
| q | answer | surfaces | arises | arise_rows | output_rows_changed_by_ruling | labels_changed | gating | piecemeal_interruption | piecemeal_repair_round |
|---|---|---|---|---|---|---|---|---|---|
| Q1 | B | build | TRUE | 29 | 29 | 29 | TRUE | TRUE | TRUE |
| Q2 | A | build | FALSE | 0 |  0 |  0 | FALSE | FALSE | FALSE |
| Q3 | A | build | FALSE | 0 |  0 |  0 | FALSE | FALSE | FALSE |
| Q4 | A | after_run | TRUE | 64922 |  0 |  0 | FALSE | TRUE | FALSE |
| Q5 | A | after_run | TRUE | 222002 |  0 |  0 | FALSE | TRUE | FALSE |

## Counts
- piecemeal: 3 interruptions, 1 repair rounds (one per arising question; one per arising question whose answer changes an output row)
- batched: 2 interruptions (round A = Q1-Q3 before reconciliation: TRUE; round B = Q4-Q5 after the run: TRUE), 1 repair rounds
- batched round A changes 29 output rows (29 labels, 0 rows added, 0 removed) vs R0; first ids: SR23-01580128|SR23-01673698|SR23-01674828|SR23-01675615|SR23-01805283|SR23-01928666|SR23-01992885|SR23-02109730|SR24-00395772|SR24-00395829
- Q1 change ids (first 10): SR23-01580128|SR23-01673698|SR23-01674828|SR23-01675615|SR23-01805283|SR23-01928666|SR23-01992885|SR23-02109730|SR24-00395772|SR24-00395829
- Q2 change ids (first 10): 
- Q3 change ids (first 10): 
- final classifications sha (first 16): piecemeal 5e4140dabac24724, batched 5e4140dabac24724
- INFO, not scored (alternative reading 'neither count goes up and at least one goes down'): would be met

## Question probe (Q_FACTS.csv)
| q | arises | rows | detail | ruled_answer_change_rows_report_only |
|---|---|---|---|---|
| Q1 | TRUE | 29 | types: SEF; labels: ESCALATE=29 | NA |
| Q2 | FALSE | 0 | distinct source STATUS values: Open=245193 | NA |
| Q3 | FALSE | 0 | DUPLICATE values: false=222176/true=23017 | NA |
| Q4 | TRUE | 64922 | flagged: WCA2; top share 0.491953 of 131968 | 0 |
| Q5 | TRUE | 222002 | code pairs (R-A -> R-B): dormant_ge_kappa_peer_p75 -> E_dormant_ge_kappa_p75 -> 131968 / thin_type_or_missing_peer -> I04_thin_peer_n -> 6377 / within_type_dormancy -> S_dormant_lt_kappa_p75 -> 83657; one-to-one: TRUE | 0 |

## Arms
| arm | rulings | regime | rb_exit | rb_s | classifications_sha | outputs_equal_frozen | fixtures_equal_frozen | portfolio | dom_exit | dom_status | dom_flagged |
|---|---|---|---|---|---|---|---|---|---|---|---|
| R0 | - | both | 0 | 26.5 | a0e42b8667b38baf | 4/4 | TRUE | 2,222002,131968,6377,83657,23191 | 0 | FLAG | WCA2 |
| PM_1 | Q1B | piecemeal | 0 | 27.1 | 5e4140dabac24724 | 1/4 | TRUE | 2,222002,131939,6406,83657,23191 | 0 | FLAG | WCA2 |
| PM_12 | Q1B,Q2A | piecemeal | 0 | 26.9 | 5e4140dabac24724 | 1/4 | TRUE | 2,222002,131939,6406,83657,23191 | 0 | FLAG | WCA2 |
| PM_123 | Q1B,Q2A,Q3A | piecemeal | 0 | 26.4 | 5e4140dabac24724 | 1/4 | TRUE | 2,222002,131939,6406,83657,23191 | 0 | FLAG | WCA2 |
| BATCH | Q1B,Q2A,Q3A | batched | 0 | 26.7 | 5e4140dabac24724 | 1/4 | TRUE | 2,222002,131939,6406,83657,23191 | 0 | FLAG | WCA2 |

