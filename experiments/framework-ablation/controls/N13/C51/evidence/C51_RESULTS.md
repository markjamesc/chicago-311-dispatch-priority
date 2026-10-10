# C51 RESULTS (mechanical; generated 2026-10-03 09:41:54 CDT)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| smoke catches SM_QUADLOOP, SM_MIDCRASH, SM_OUTCRASH (each detected at k16 or k4, i.e. before its full run) | MET |
| no false smoke flag on clean arm B (R-A and R-B) | MET |
| summed time over all arms (incl. B and SM_RARECRASH) lower under the variant | MET |
| B full-run 7 key outputs equal the frozen hashes and no full-run manifest references a smoke path | MET |

## Arms
| arm | path | k16_exit | k16_s | k4_exit | k4_s | ratio_k4_k16 | full_exit | full_s | full_timeout | smoke_detects | baseline_s | variant_s |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | RA | 0 |  2.4 | 0 |   4.4 |  1.83 | 0 |   11.0 | FALSE | none |   11.0 |  17.8 |
| B | RB | 0 |  3.1 | 0 |   7.8 |  2.52 | 0 |   25.0 | FALSE | none |   25.0 |  35.9 |
| SM_QUADLOOP | RB | 0 | 19.4 | 0 | 357.7 | 18.44 | TIMEOUT | 1800.4 | TRUE | k4 | 1825.4 | 413.0 |
| SM_MIDCRASH | RB | 1 |  2.4 | 1 |   6.4 | NA | 1 |   18.5 | FALSE | k16 |   43.5 |  38.3 |
| SM_OUTCRASH | RB | 1 |  3.4 | 1 |   8.2 | NA | 1 |   25.6 | FALSE | k16 |   50.6 |  39.3 |
| SM_RARECRASH | RB | 0 |  2.9 | 0 |   7.9 |  2.72 | 1 |    5.8 | FALSE | none |   30.8 |  52.5 |

## Totals
- baseline (no smoke) summed seconds: 1986.3
- variant (smoke first) summed seconds: 596.8
- SM_RARECRASH (outside H, subset-bias probe): smoke_detects=none, full_exit=1

## B full-run key outputs vs frozen
| file | frozen | arm_B | equal |
|---|---|---|---|
| R-A/outputs/RA_classifications.csv | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9 | TRUE |
| R-B/outputs/RB_classifications.csv | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 | TRUE |
| R-A/outputs/RA_fixture_results.csv | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | 33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110 | TRUE |
| R-B/outputs/RB_fixture_results.csv | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 | TRUE |
| R-A/outputs/RA_portfolio_counts.csv | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3 | TRUE |
| R-B/outputs/RB_portfolio_counts.csv | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c | TRUE |
| R-B/outputs/RB_kappa_grid_counts.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | TRUE |
