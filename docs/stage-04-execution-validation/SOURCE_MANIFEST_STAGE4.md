# SOURCE_MANIFEST_STAGE4 — Chicago 311 Method B
**When (CT):** 2026-09-19 05:28:19 CT  
**Authority:** Design Gate PASS 2026-09-19 CT (B-leaning TCD-IG); Fixture Gate PASS (fixtures-v1-tcd-ig, F01–F14 incl. F03→STANDARD at κ=2)  
**Scope this artifact covers:** SQL source delivery + Source Gate scripts only. **R-A/R-B not started.**

## Freeze / constants (documented in SQL; not judged labels)
| Item | Value |
|---|---|
| Snapshot id | `chicago311-raw-frozen-2026-09-12` |
| Source | `chicago311.raw_311_requests` via `mysql --login-path=chicago311` |
| T_freeze | `2026-09-12 23:59:59` America/Chicago |
| Envelope A | `STATUS = 'Open'` → table `src_open_candidates` |
| Envelope B | Completed non-dup non-legacy peers, created in [T−365d, T] → `src_peer_stats` |
| Peer grain | `type_key` = coalesce(trim(SR_SHORT_CODE), trim(SR_TYPE)) |
| Peer metrics | `peer_n`, `peer_p50_h`, `peer_p75_h` (hours; nearest-rank CEIL(P·n)); labeled empirical_not_city_sla |
| Knob κ | **R-only** (default 2.0) — SQL must not apply |
| n_min / W | method constants for R (50 / 365d); SQL only uses W for peer window |

## SQL must NOT emit
ESCALATE / INCONCLUSIVE / STANDARD, is_eligible, dormant_h thresholds, κ comparisons, action, selected.

## Box paths (authored this run)
| Artifact | Path |
|---|---|
| Extract SQL | `/workspace/chicago-311-run/stage-04/sql/01_source_extract.sql` |
| Gate SQL | `/workspace/chicago-311-run/stage-04/sql/02_source_gate_checks.sql` |
| PC runner | `/workspace/chicago-311-run/stage-04/scripts/run_stage4_source.ps1` |
| Gate report | `/workspace/chicago-311-run/stage-04/docs/stage-04-validation/SOURCE_GATE_REPORT.md` |
| This manifest | `/workspace/chicago-311-run/stage-04/SOURCE_MANIFEST_STAGE4.md` |
| Mirror copies | `/workspace/chicago-311-dispatch-priority/sql/01_source_extract.sql` (+ gate + ps1) |

## Intended PC paths (after parent CopyFromBox)
| Artifact | Path |
|---|---|
| Work root | `C:\Users\Mark\Documents\R Working Directory\chicago311\` |
| Extract SQL | `...\chicago311\sql\01_source_extract.sql` |
| Gate SQL | `...\chicago311\sql\02_source_gate_checks.sql` |
| Runner | `...\chicago311\sql\run_stage4_source.ps1` (or scripts\) |
| Gate raw TSV | `...\chicago311\docs\stage-04-validation\source_gate_raw.tsv` |
| Lineage TSV | `...\chicago311\data\source\src_extract_lineage.tsv` |
| Peer TSV | `...\chicago311\data\source\src_peer_stats.tsv` |
| MySQL tables | `chicago311.src_open_candidates`, `src_peer_stats`, `src_extract_lineage`, `src_gate_results` |

## Expected counts (source-manifest; verify live)
Open ≈ **245,193**; raw physical rows 14,635,395; distinct SR_NUMBER unique in snapshot.

## Execution status
**MySQL extract + gate: NOT EXECUTED on DESKTOP-RPECRM9 from this executor** (box-scoped; no machineId Shell / ListMachines / CopyFromBox). See SOURCE_GATE_REPORT.md.
