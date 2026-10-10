# C40R gate report — INC r6 — FAILED

- Production run `Rscript R-B/run_RB.R all`: exit 0 (31.8 s).
- Fixtures: 14/14 pass.

| output | byte-identical to frozen reference |
|---|---|
| RB_classifications.csv | YES |
| RB_fixture_results.csv | NO |
| RB_portfolio_counts.csv | YES |
| RB_kappa_grid_counts.csv | YES |

RB_fixture_results.csv (yours):
```
SR_NUMBER,fixture_id,expected_classification,observed_classification,dormant_h,peer_p75_h,peer_n,integrity_clause,evidence_reason,pass,kappa,fixture_version
SYN-F01,F01,ESCALATE,ESCALATE,480,168,500,,"E_dormant_ge_kappa_p75 (dormant_h=480.0000, kappa=2.00, peer_p75_h=168.0000)",TRUE,2,fixtures-v1-tcd-ig
SYN-F02,F02,STANDARD,STANDARD,24,168,500,,"S_dormant_lt_kappa_p75 (dormant_h=24.0000, kappa=2.00, peer_p75_h=168.0000)",TRUE,2,fixtures-v1-tcd-ig
SYN-F03,F03,STANDARD,STANDARD,2400,2160,200,,"S_dormant_lt_kappa_p75 (dormant_h=2400.0000, kappa=2.00, peer_p75_h=2160.0000)",TRUE,2,fixtures-v1-tcd-ig
SYN-F04,F04,INCONCLUSIVE,INCONCLUSIVE,240,168,500,I01_open_closed_date,I01_open_closed_date,TRUE,2,fixtures-v1-tcd-ig
SYN-F05,F05,INCONCLUSIVE,INCONCLUSIVE,480,168,500,I02_bad_clock,I02_bad_clock,TRUE,2,fixtures-v1-tcd-ig
SYN-F06,F06,INCONCLUSIVE,INCONCLUSIVE,720,96,8,I04_thin_peer_n,I04_thin_peer_n,TRUE,2,fixtures-v1-tcd-ig
SYN-F07,F07,OUT_OF_SET,OUT_OF_SET,9600,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F08,F08,OUT_OF_SET,OUT_OF_SET,480,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F09,F09,INCONCLUSIVE,INCONCLUSIVE,360,168,500,I05_unresolved_parent,I05_unresolved_parent,TRUE,2,fixtures-v1-tcd-ig
SYN-F10,F10,STANDARD,STANDARD,96,72,120,,"S_dormant_lt_kappa_p75 (dormant_h=96.0000, kappa=2.00, peer_p75_h=72.0000)",TRUE,2,fixtures-v1-tcd-ig
SYN-F11,F11,ESCALATE,ESCALATE,192,72,120,,"E_dormant_ge_kappa_p75 (dormant_h=192.0000, kappa=2.00, peer_p75_h=72.0000)",TRUE,2,fixtures-v1-tcd-ig
SYN-F12,F12,OUT_OF_SET,OUT_OF_SET,120,168,500,,,TRUE,2,fixtures-v1-tcd-ig
SYN-F13,F13,INCONCLUSIVE,INCONCLUSIVE,120,168,500,I02_bad_clock,I02_bad_clock,TRUE,2,fixtures-v1-tcd-ig
SYN-F14A|SYN-F14B,F14,STANDARD|STANDARD,STANDARD|STANDARD,,,,,grain=SR_NUMBER two independent labels,TRUE,2,fixtures-v1-tcd-ig
```

