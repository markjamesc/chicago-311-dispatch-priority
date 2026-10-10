# C24 RESULTS (mechanical; generated 2026-10-10 12:10:34 CDT)

**Mechanical predicate result: P1 NOT MET**

## Predicate conditions
| condition | met |
|---|---|
| SQL counts: full-extract data rows = SQL total rows, and separated-extract data rows = SQL envelope count (STATUS = 'Open') | MET |
| COLLAPSED: R-A and R-B exit 0 (no error, timeout or memory kill) | MET |
| COLLAPSED: all 7 key outputs byte-identical to arm B's (same analytic set and counts) | NOT MET |
| COLLAPSED: every fixture passes on both paths | MET |

## SQL query counts vs final analytic set
| quantity | value |
|---|---|
| total | 14635395 |
| status=Canceled |   212654 |
| status=Closed |        1 |
| status=Completed | 14177547 |
| status=Open |   245193 |
| envelope_open |   245193 |
| separated extract data rows (arm B) | 245193 |
| full extract data rows (arm COLLAPSED) | 14635395 |
| R decision rows B RA | 222002 |
| R decision rows B RB | 222002 |
| R decision rows COLLAPSED RA | 222002 |
| R decision rows COLLAPSED RB | 222002 |

Note: COLLAPSED arm R-A/R-B ran CHUNKED (spec v3, run_RA_chunked.R/run_RB_chunked.R); B arm results and SQL/extract/checksum evidence are carried unchanged from C24V2 (N18).

## Extracts (kept in place on the PC)
| arm | sha256 | bytes | data_rows |
|---|---|---|---|
| B | 9dabac4fae30f2db386ec23703a2a48f3e31c9cd9fed3261590c85b2f7c17fa2 |  118672055 |   245193 |
| COLLAPSED | 8ef6df6f0694696122d92bc36410fcf2bee1b198d2221c4562bc5bb59b557ebe | 8167123771 | 14635395 |

## SQL steps
| step | exit | secs | end | err_bytes |
|---|---|---|---|---|
| CK_PRE | 0 | 1001.7 | 2026-10-10T04:53:40-05:00 | 0 |
| Q_COUNTS | 0 |  558.0 | 2026-10-10T05:03:03-05:00 | 0 |
| X_SEP | 0 |  272.1 | 2026-10-10T05:07:36-05:00 | 0 |
| X_FULL | 0 | 2027.0 | 2026-10-10T05:41:23-05:00 | 0 |
| CK_POST | 0 |  272.0 | 2026-10-10T05:45:55-05:00 | 0 |

## R runs
| arm | path | exit | secs | min_free_MB | peak_R_MB | decision_rows | fixtures_pass | fixtures_n |
|---|---|---|---|---|---|---|---|---|
| B | RA | 0 | 19.9 | 20803 | 519 | 222002 | 14 | 14 |
| B | RB | 0 | 24.9 | 20452 | 720 | 222002 | 14 | 14 |
| COLLAPSED | RA | 0 | 346.9 | 13346 | 6412 | 222002 | 14 | 14 |
| COLLAPSED | RB | 0 | 1132.5 | 13702 | 8346 | 222002 | 14 | 14 |

## 7 key outputs: COLLAPSED vs B (gating) and B vs frozen pack (INFO only; the fresh export differs from the frozen export method, see SPEC)
| file | frozen | B | COLLAPSED | COLLAPSED_eq_B | B_eq_frozen_INFO |
|---|---|---|---|---|---|
| R-A/outputs/RA_classifications.csv | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | TRUE | TRUE |
| R-B/outputs/RB_classifications.csv | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | TRUE | TRUE |
| R-A/outputs/RA_fixture_results.csv | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | TRUE | TRUE |
| R-B/outputs/RB_fixture_results.csv | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | TRUE | TRUE |
| R-A/outputs/RA_portfolio_counts.csv | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | TRUE | TRUE |
| R-B/outputs/RB_portfolio_counts.csv | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | 9f0f050a19c5131660bd7ae9b58b6ef6babb63cffea88577d3948851012b15ea | FALSE | TRUE |
| R-B/outputs/RB_kappa_grid_counts.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | TRUE | TRUE |

CHECKSUM bracket PRE: chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591
CHECKSUM bracket POST: chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591
