# C24 RESULTS (mechanical; generated 2026-10-09 02:44:16 CDT)

**Mechanical predicate result: HALT**

HALT reasons:
- arm B (separated envelope) failed

## Predicate conditions
| condition | met |
|---|---|
| SQL counts: full-extract data rows = SQL total rows, and separated-extract data rows = SQL envelope count (STATUS = 'Open') | MET |
| COLLAPSED: R-A and R-B exit 0 (no error, timeout or memory kill) | NOT MET |
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
| R decision rows B RB | NA |
| R decision rows COLLAPSED RA | NA |
| R decision rows COLLAPSED RB | NA |

## Extracts (kept in place on the PC)
| arm | sha256 | bytes | data_rows |
|---|---|---|---|
| B | 13d8a1c3e9fe1af9e8b36a3b1039f9f5a893c2ae2b015bae9deb38ace3bcbb1c |  118671762 |   245193 |
| COLLAPSED | 375242241237caf1d759efb835f18a10dc495043b9919acc1da017b75750ed16 | 8167050350 | 14635395 |

## SQL steps
| step | exit | secs | end | err_bytes |
|---|---|---|---|---|
| CK_PRE | 0 |  275.2 | 2026-10-09T01:34:14-05:00 | 0 |
| Q_COUNTS | 0 |  559.8 | 2026-10-09T01:43:34-05:00 | 0 |
| X_SEP | 0 |  276.0 | 2026-10-09T01:48:10-05:00 | 0 |
| X_FULL | 0 | 2337.2 | 2026-10-09T02:27:07-05:00 | 0 |
| CK_POST | 0 |  211.3 | 2026-10-09T02:30:38-05:00 | 0 |

## R runs
| arm | path | exit | secs | min_free_MB | peak_R_MB | decision_rows | fixtures_pass | fixtures_n |
|---|---|---|---|---|---|---|---|---|
| B | RA | 0 | 25.7 | 16808 | 551 | 222002 | 14 | 14 |
| B | RB | 1 | 14.8 | 16748 | 442 | NA | 14 | 14 |
| COLLAPSED | RA | MEMKILL | 91.3 | 2038 | 15297 | NA | 14 | 14 |
| COLLAPSED | RB | MEMKILL | 470.4 | 1528 | 17242 | NA | 14 | 14 |

## 7 key outputs: COLLAPSED vs B (gating) and B vs frozen pack (INFO only; the fresh export differs from the frozen export method, see SPEC)
| file | frozen | B | COLLAPSED | COLLAPSED_eq_B | B_eq_frozen_INFO |
|---|---|---|---|---|---|
| R-A/outputs/RA_classifications.csv | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | MISSING | FALSE | TRUE |
| R-B/outputs/RB_classifications.csv | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | MISSING | MISSING | FALSE | FALSE |
| R-A/outputs/RA_fixture_results.csv | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | TRUE | TRUE |
| R-B/outputs/RB_fixture_results.csv | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | TRUE | TRUE |
| R-A/outputs/RA_portfolio_counts.csv | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | MISSING | FALSE | TRUE |
| R-B/outputs/RB_portfolio_counts.csv | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | MISSING | MISSING | FALSE | FALSE |
| R-B/outputs/RB_kappa_grid_counts.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | MISSING | MISSING | FALSE | FALSE |

CHECKSUM bracket PRE: chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591
CHECKSUM bracket POST: chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591
