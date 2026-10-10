# C40 RESULTS (mechanical; generated 2026-10-03 11:34:22 CDT)

**Mechanical predicate result: PARTIAL: pre-chat conditions evaluated; conditions marked PENDING are evaluated after the extra chats (see SPEC)**

## Predicate conditions
| condition | met |
|---|---|
| 0. gate validity (pre-chat): the frozen module passes the gate and the hidden depth check; every seeded module fails the gate | MET |
| 1. variant valid build within the cap | PENDING |
| 2. variant valid build no later than baseline (active minutes from divergence) | PENDING |
| 3. no defect escapes (hidden depth check on the variant's valid build) | PENDING |

## Arms
| arm | expected_gate | rb_exit | gate | fixtures | classifications_equal | hidden_depth_gate |
|---|---|---|---|---|---|---|
| REF | PASS | 0 | PASS | 14/14 | TRUE | PASS |
| SEED_TZUTC | FAIL | 0 | FAIL | 14/14 | FALSE | not run |
| SEED_CLOCKLATE | FAIL | 0 | FAIL | 14/14 | FALSE | not run |
| SEED_DUPINT | FAIL | 0 | FAIL | 14/14 | FALSE | not run |

## REF: GATE_REPORT.md (what a builder would receive)
# C40 gate report — REF r0 — PASS

- Production run `Rscript R-B/run_RB.R all`: exit 0 (25.6 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | YES |
| RB_fixture_results.csv | YES |
| RB_portfolio_counts.csv | YES |
| RB_kappa_grid_counts.csv | YES |


## SEED_TZUTC: GATE_REPORT.md (what a builder would receive)
# C40 gate report — SEED_TZUTC r0 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 0 (22.4 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | NO |
| RB_fixture_results.csv | YES |
| RB_portfolio_counts.csv | NO |
| RB_kappa_grid_counts.csv | NO |

RB_classifications.csv: reference 222002 rows, 13 columns; yours 222002 rows, 13 columns.
SR_NUMBER only in reference: 0; only in yours: 0.

| column | rows that differ (matched SR_NUMBER) |
|---|---|
| type_key | 0 |
| classification | 104 |
| evidence_reason | 215625 |
| dormant_h | 222002 |
| open_age_h | 222002 |
| peer_n | 0 |
| peer_p75_h | 0 |
| peer_p50_h | 0 |
| kappa | 0 |
| integrity_clause | 0 |
| rule_version | 0 |
| design_version | 0 |

First differing rows (up to 5 per column):

| SR_NUMBER | column | reference | yours |
|---|---|---|---|
| SR21-00793000 | classification | STANDARD | ESCALATE |
| SR21-00917343 | classification | STANDARD | ESCALATE |
| SR21-00957712 | classification | STANDARD | ESCALATE |
| SR21-01134530 | classification | STANDARD | ESCALATE |
| SR21-01144917 | classification | STANDARD | ESCALATE |
| SR18-00191995 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | E_dormant_ge_kappa_p75 (dormant_h=57683.2694, kappa=2.00, peer_p75_h=2250.0000) |
| SR18-00192008 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | E_dormant_ge_kappa_p75 (dormant_h=57683.2694, kappa=2.00, peer_p75_h=2250.0000) |
| SR18-00192021 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | E_dormant_ge_kappa_p75 (dormant_h=57683.2694, kappa=2.00, peer_p75_h=2250.0000) |
| SR18-00192151 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2689, kappa=2.00, peer_p75_h=2250.0000) | E_dormant_ge_kappa_p75 (dormant_h=57683.2689, kappa=2.00, peer_p75_h=2250.0000) |
| SR18-00192236 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2689, kappa=2.00, peer_p75_h=2250.0000) | E_dormant_ge_kappa_p75 (dormant_h=57683.2689, kappa=2.00, peer_p75_h=2250.0000) |
| SR18-00191995 | dormant_h | 57677.26944444444 | 57683.26944444444 |
| SR18-00192008 | dormant_h | 57677.26944444444 | 57683.26944444444 |
| SR18-00192021 | dormant_h | 57677.26944444444 | 57683.26944444444 |
| SR18-00192151 | dormant_h | 57677.26888888889 | 57683.26888888889 |
| SR18-00192236 | dormant_h | 57677.26888888889 | 57683.26888888889 |
| SR18-00191995 | open_age_h | 67813.21722222223 | 67819.21722222223 |
| SR18-00192008 | open_age_h | 67813.1725 | 67819.1725 |
| SR18-00192021 | open_age_h | 67813.1236111111 | 67819.1236111111 |
| SR18-00192151 | open_age_h | 67812.64888888889 | 67818.64888888889 |
| SR18-00192236 | open_age_h | 67812.3938888889 | 67818.3938888889 |

RB_portfolio_counts.csv (yours):
```
kappa,n_decision,n_ESCALATE,n_INCONCLUSIVE,n_STANDARD,n_out_of_set
2,222002,132072,6377,83553,23191
```

RB_kappa_grid_counts.csv (yours):
```
kappa,n_decision,n_ESCALATE,n_INCONCLUSIVE,n_STANDARD
1,222002,152503,6377,63122
1.5,222002,140512,6377,75113
2,222002,132072,6377,83553
3,222002,118328,6377,97297
```


## SEED_CLOCKLATE: GATE_REPORT.md (what a builder would receive)
# C40 gate report — SEED_CLOCKLATE r0 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 0 (32.4 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | NO |
| RB_fixture_results.csv | YES |
| RB_portfolio_counts.csv | YES |
| RB_kappa_grid_counts.csv | YES |

RB_classifications.csv: reference 222002 rows, 13 columns; yours 222002 rows, 13 columns.
SR_NUMBER only in reference: 0; only in yours: 0.

| column | rows that differ (matched SR_NUMBER) |
|---|---|
| type_key | 0 |
| classification | 0 |
| evidence_reason | 1 |
| dormant_h | 1 |
| open_age_h | 2 |
| peer_n | 0 |
| peer_p75_h | 0 |
| peer_p50_h | 0 |
| kappa | 0 |
| integrity_clause | 0 |
| rule_version | 0 |
| design_version | 0 |

First differing rows (up to 5 per column):

| SR_NUMBER | column | reference | yours |
|---|---|---|---|
| SR22-01936870 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=33766.9997, kappa=2.00, peer_p75_h=42.0000) | E_dormant_ge_kappa_p75 (dormant_h=33765.9997, kappa=2.00, peer_p75_h=42.0000) |
| SR22-01936870 | dormant_h | 33766.99972222222 | 33765.99972222222 |
| SR25-02017553 | open_age_h | 7558.669722222222 | 7557.669722222222 |
| SR25-02017556 | open_age_h | 7558.637222222223 | 7557.637222222223 |


## SEED_DUPINT: GATE_REPORT.md (what a builder would receive)
# C40 gate report — SEED_DUPINT r0 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 0 (24.7 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | NO |
| RB_fixture_results.csv | YES |
| RB_portfolio_counts.csv | NO |
| RB_kappa_grid_counts.csv | NO |

RB_classifications.csv: reference 222002 rows, 13 columns; yours 245014 rows, 13 columns.
SR_NUMBER only in reference: 0; only in yours: 23012.

| column | rows that differ (matched SR_NUMBER) |
|---|---|
| type_key | 0 |
| classification | 0 |
| evidence_reason | 0 |
| dormant_h | 0 |
| open_age_h | 0 |
| peer_n | 0 |
| peer_p75_h | 0 |
| peer_p50_h | 0 |
| kappa | 0 |
| integrity_clause | 0 |
| rule_version | 0 |
| design_version | 0 |

RB_portfolio_counts.csv (yours):
```
kappa,n_decision,n_ESCALATE,n_INCONCLUSIVE,n_STANDARD,n_out_of_set
2,245014,131968,29389,83657,179
```

RB_kappa_grid_counts.csv (yours):
```
kappa,n_decision,n_ESCALATE,n_INCONCLUSIVE,n_STANDARD
1,245014,152292,29389,63333
1.5,245014,140340,29389,75285
2,245014,131968,29389,83657
3,245014,118246,29389,97379
```


