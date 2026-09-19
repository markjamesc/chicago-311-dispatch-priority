# SOURCE_GATE_REPORT — Chicago 311 Stage 4 Method B
**Overall:** **PASS**
**When (CT):** 2026-09-19 ~07:30 CT (extract started ~05:34 CT; ~1h56m)
**Authority:** Design Gate PASS; Fixture Gate PASS (`fixtures-v1-tcd-ig`, F01–F14, F03→STANDARD at κ=2)
**R-A/R-B:** UNBLOCKED — may start independent judged builds

## Counts (live)
| Metric | Value |
|---|---|
| extract Open n | 245,193 |
| raw Open n | 245,193 |
| distinct SR_NUMBER | 245,193 |
| peer type_key n | 104 |
| peer row sum | 1,881,338 |
| Source Gate overall | **PASS** (15 PASS, 0 FAIL, 2 INFO) |

## Check results
| Check | Result |
|---|---|
| A_open_count_match | PASS |
| B_distinct_sr_equals_rows | PASS |
| C_id_extra / C_id_missing | PASS |
| D_field_mismatch_critical | PASS |
| E_status_domain_open_only | PASS |
| F_created_date_range | PASS |
| G_null_profile_created_status | PASS |
| G_null_closed_date_info | INFO (expected ~all Open blank CLOSED_DATE) |
| H_sr_checksum_match | PASS |
| I_peer_stats_present / p75 / type_key | PASS |
| J_no_judged_columns | PASS |
| K_lineage_open_matches_raw / t_freeze | PASS |
| L_raw_status_dist_info | INFO |

## Deliverables
- MySQL `chicago311.src_open_candidates`
- MySQL `chicago311.src_peer_stats`
- MySQL `chicago311.src_extract_lineage`
- Scripts: `sql/01_source_extract.sql`, `sql/02_source_gate_checks.sql`

## Note
Shell wrapper exit_code 1 was only from a post-gate `SELECT` against non-table `src_gate_overall`; gate script itself exited 0 with `SOURCE_GATE_PASS`.
