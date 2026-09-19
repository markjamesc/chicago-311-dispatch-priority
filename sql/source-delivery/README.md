# SQL Source Delivery (Stage 4 Method B)

**Status:** Scripts authored; PC execution required for Source Gate PASS.

## Mechanical envelope
`STATUS = 'Open'` only — nonjudgmental volume bound (~245,193 rows per source-manifest). **No age filter. No judged columns.**

## Files
| File | Role |
|---|---|
| `01_source_extract_open_envelope.sql` | SELECT all 39 raw columns for Open rows |
| `run_source_delivery.ps1` | PC export → `data/source_open_envelope.tsv` + lineage JSON |
| `../validation/source-gate/` | Source Gate SQL + report |

## Forbidden in SQL outputs
`is_open`, `is_eligible`, `open_age_days`, `action`, `selected`, urgency, ranking.

## PC run
```powershell
cd "C:\Users\Mark\Documents\R Working Directory\chicago311"
# sync this folder from repo, then:
powershell -File .\sql\source-delivery\run_source_delivery.ps1
# then Source Gate:
# mysql --login-path=chicago311 < validation\source-gate\source_gate_checks.sql
```
