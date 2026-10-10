# C40R gate report — INC r1 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 0 (29.9 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | NO |
| RB_fixture_results.csv | NO |
| RB_portfolio_counts.csv | NO |
| RB_kappa_grid_counts.csv | YES |

RB_classifications.csv: reference 222002 rows, 13 columns; yours 222002 rows, 13 columns.
SR_NUMBER only in reference: 0; only in yours: 0.

| column | rows that differ (matched SR_NUMBER) |
|---|---|
| type_key | 0 |
| classification | 0 |
| evidence_reason | 222002 |
| dormant_h | 0 |
| open_age_h | 0 |
| peer_n | 6315 |
| peer_p75_h | 0 |
| peer_p50_h | 0 |
| kappa | 0 |
| integrity_clause | 6377 |
| rule_version | 0 |
| design_version | 0 |

First differing rows (up to 5 per column):

| SR_NUMBER | column | reference | yours |
|---|---|---|---|
| SR18-00191995 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | dormant_h=57677.269444 >= kappa*peer_p75_h=4500.000000 (kappa=2; peer_p75_h=2250.000000) |
| SR18-00192008 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | dormant_h=57677.269444 >= kappa*peer_p75_h=4500.000000 (kappa=2; peer_p75_h=2250.000000) |
| SR18-00192021 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2694, kappa=2.00, peer_p75_h=2250.0000) | dormant_h=57677.269444 >= kappa*peer_p75_h=4500.000000 (kappa=2; peer_p75_h=2250.000000) |
| SR18-00192151 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2689, kappa=2.00, peer_p75_h=2250.0000) | dormant_h=57677.268889 >= kappa*peer_p75_h=4500.000000 (kappa=2; peer_p75_h=2250.000000) |
| SR18-00192236 | evidence_reason | E_dormant_ge_kappa_p75 (dormant_h=57677.2689, kappa=2.00, peer_p75_h=2250.0000) | dormant_h=57677.268889 >= kappa*peer_p75_h=4500.000000 (kappa=2; peer_p75_h=2250.000000) |
| SR20-03279926 | peer_n | 0 |  |
| SR22-00047020 | peer_n | 0 |  |
| SR23-00037006 | peer_n | 0 |  |
| SR23-00037009 | peer_n | 0 |  |
| SR23-00037010 | peer_n | 0 |  |
| SR20-03279926 | integrity_clause | I04_thin_peer_n | I13_PEER_MISSING |
| SR22-00047020 | integrity_clause | I04_thin_peer_n | I13_PEER_MISSING |
| SR23-00037006 | integrity_clause | I04_thin_peer_n | I13_PEER_MISSING |
| SR23-00037009 | integrity_clause | I04_thin_peer_n | I13_PEER_MISSING |
| SR23-00037010 | integrity_clause | I04_thin_peer_n | I13_PEER_MISSING |

RB_fixture_results.csv (yours):
```
SR_NUMBER,fixture_id,expected_classification,observed_classification,dormant_h,peer_p75_h,peer_n,integrity_clause,evidence_reason,pass,kappa,fixture_version
SYN-F01,F01,ESCALATE,ESCALATE,480,168,500,,dormant_h=480.000000 >= kappa*peer_p75_h=336.000000 (kappa=2; peer_p75_h=168.000000),TRUE,2,fixtures-v1-tcd-ig
SYN-F02,F02,STANDARD,STANDARD,24,168,500,,dormant_h=24.000000 < kappa*peer_p75_h=336.000000 (kappa=2; peer_p75_h=168.000000),TRUE,2,fixtures-v1-tcd-ig
SYN-F03,F03,STANDARD,STANDARD,2400,2160,200,,dormant_h=2400.000000 < kappa*peer_p75_h=4320.000000 (kappa=2; peer_p75_h=2160.000000),TRUE,2,fixtures-v1-tcd-ig
SYN-F04,F04,INCONCLUSIVE,INCONCLUSIVE,240,168,500,I02_OPEN_CLOSED,integrity=I02_OPEN_CLOSED,TRUE,2,fixtures-v1-tcd-ig
SYN-F05,F05,INCONCLUSIVE,INCONCLUSIVE,480,168,500,I06_MOD_BEFORE_CREATED,integrity=I06_MOD_BEFORE_CREATED,TRUE,2,fixtures-v1-tcd-ig
SYN-F06,F06,INCONCLUSIVE,INCONCLUSIVE,720,96,8,I14_THIN_TYPE,integrity=I14_THIN_TYPE,TRUE,2,fixtures-v1-tcd-ig
SYN-F07,F07,OUT_OF_SET,OUT_OF_SET,9600,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F08,F08,OUT_OF_SET,OUT_OF_SET,480,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F09,F09,INCONCLUSIVE,INCONCLUSIVE,360,168,500,I11_ORPHAN_PARENT,integrity=I11_ORPHAN_PARENT,TRUE,2,fixtures-v1-tcd-ig
SYN-F10,F10,STANDARD,STANDARD,96,72,120,,dormant_h=96.000000 < kappa*peer_p75_h=144.000000 (kappa=2; peer_p75_h=72.000000),TRUE,2,fixtures-v1-tcd-ig
SYN-F11,F11,ESCALATE,ESCALATE,192,72,120,,dormant_h=192.000000 >= kappa*peer_p75_h=144.000000 (kappa=2; peer_p75_h=72.000000),TRUE,2,fixtures-v1-tcd-ig
SYN-F12,F12,OUT_OF_SET,OUT_OF_SET,120,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F13,F13,INCONCLUSIVE,INCONCLUSIVE,120,168,500,I03_CREATED_PARSE,integrity=I03_CREATED_PARSE,TRUE,2,fixtures-v1-tcd-ig
SYN-F14A|SYN-F14B,F14,STANDARD|STANDARD,STANDARD|STANDARD,,,,,grain=SR_NUMBER two independent labels,TRUE,2,fixtures-v1-tcd-ig
```

RB_portfolio_counts.csv (yours):
```
kappa,n_decision,n_ESCALATE,n_INCONCLUSIVE,n_STANDARD
2,222002,131968,6377,83657
```

