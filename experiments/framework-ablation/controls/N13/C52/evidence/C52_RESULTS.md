# C52 RESULTS (mechanical; generated 2026-10-03 13:40:42 CDT)

**Mechanical predicate result: P1 NOT MET**

## Predicate conditions
| condition | met |
|---|---|
| all chain exits 0 in every arm (and empty .err files) | MET |
| 17 gate rows, 15 PASS / 0 FAIL / 2 INFO, byte-identical G output across arms | MET |
| E1 and E2 outputs byte-identical across arms | MET |
| median PAR wall <= 0.80 x median SER wall | NOT MET |

## Arms
| arm | mode | exits_E1_E2_G | err_bytes | wall_s | E1_sha | E2_sha | G_sha | gate_rows | gate_pass | gate_fail | gate_info | ck_pre | ck_post |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SER_1 | SER | 0/0/0 | 0 | 3677.3 | 65bf0d9ae5bff494 | 95dc8cab2e82009f | ec26cd171c4617eb | 17 | 15 | 0 | 2 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 |
| PAR_1 | PAR | 0/0/0 | 0 | 3246.8 | 65bf0d9ae5bff494 | 95dc8cab2e82009f | ec26cd171c4617eb | 17 | 15 | 0 | 2 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 |
| SER_2 | SER | 0/0/0 | 0 | 3137.4 | 65bf0d9ae5bff494 | 95dc8cab2e82009f | ec26cd171c4617eb | 17 | 15 | 0 | 2 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 |
| PAR_2 | PAR | 0/0/0 | 0 | 2911.8 | 65bf0d9ae5bff494 | 95dc8cab2e82009f | ec26cd171c4617eb | 17 | 15 | 0 | 2 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 | chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591 |

## Timing
- median SER wall 3407.4 s; median PAR wall 3079.3 s; ratio 0.904

## INFO (not gating): gate rows vs frozen stage4_extract_run.log (all non-note fields found on a log line naming the check)
| check | result | in_frozen_log |
|---|---|---|
| A_open_count_match | PASS | FALSE |
| B_distinct_sr_equals_rows | PASS | FALSE |
| C_id_missing_in_extract | PASS | FALSE |
| C_id_extra_in_extract | PASS | FALSE |
| D_field_mismatch_critical | PASS | FALSE |
| E_status_domain_open_only | PASS | FALSE |
| F_created_date_range | PASS | FALSE |
| G_null_profile_created_status | PASS | FALSE |
| G_null_closed_date_info | INFO | FALSE |
| H_sr_checksum_match | PASS | FALSE |
| I_peer_stats_present | PASS | FALSE |
| I_peer_no_null_type_key | PASS | FALSE |
| I_peer_p75_nonneg_when_n | PASS | FALSE |
| J_no_judged_columns | PASS | FALSE |
| K_lineage_open_matches_raw | PASS | FALSE |
| K_lineage_t_freeze | PASS | FALSE |
| L_raw_status_dist_info | INFO | FALSE |

## INFO (not gating): extract outputs vs frozen source CSV data rows (header dropped; line-normalised digest)
- E1 vs src_open_candidates.csv: FALSE
- E2 vs src_peer_stats.csv: TRUE

CHECKSUM bracket (all arms, pre and post): chicago311.raw_311_requests	727006061 | chicago311.src_open_candidates	1392669554 | chicago311.src_peer_stats	791123155 | chicago311.src_extract_lineage	2028659591
