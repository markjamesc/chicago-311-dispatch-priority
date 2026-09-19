# SOURCE_DELIVERY_CONTRACT — Stage 3 → Stage 4 (Method B)
**Design version:** `stage3-v0.1-PENDING`  
**Status:** PROPOSED (pending Design Gate)  
**Architecture:** controlled SQL source (nonjudgmental) → SQL Source Gate → independent R-A / R-B

## Authoritative source
| Item | Value |
|---|---|
| Login | `--login-path=chicago311` |
| Schema.table | `chicago311.raw_311_requests` |
| Columns | 39 varchar (see `../../data-documentation/README.md` + source-manifest) |
| Snapshot | Frozen local import; max `CREATED_DATE` 2026-09-12 15:39:45; Open ≈ 245,193 |
| Row ID | `SR_NUMBER` unique in this snapshot (re-verify on refresh) |

## What SQL must deliver
- Request-grain rows with **raw-ish source columns** (prefer all 39).
- Critical minimum: `SR_NUMBER, SR_TYPE, STATUS, CREATED_DATE, LAST_MODIFIED_DATE, CLOSED_DATE, DUPLICATE, LEGACY_RECORD, LEGACY_SR_NUMBER, PARENT_SR_NUMBER, COMMUNITY_AREA, WARD`.
- Lineage: snapshot_id / manifest reference / extract timestamp / rowcount / distinct SR_NUMBER.

## Optional mechanical envelope
```sql
-- CONCEPT ONLY (not production builder SQL)
-- WHERE STATUS = 'Open'
```
Allowed as **mechanical source equality** to bound volume. Must remain wider than judged eligibility. **No age filter in SQL.**

## What SQL must NOT precompute
Judged equivalents of: `is_open`, `is_eligible`, `is_in_window`, `open_age_days`, urgency, `action`, `selected`, priority rank, final membership.

## SQL Source Gate requirements (Stage 4 executes)
1. Envelope rowcount vs raw under same predicate  
2. Distinct `SR_NUMBER` = rowcount  
3. Critical-field equality / multiset checks  
4. Null/blank profiles for dates, type, duplicate/parent  
5. `CREATED_DATE` min/max + parseability spot-checks  
6. STATUS domain check if envelope used  
7. Lineage equality to freeze record  

“Close” is not a pass.

## R handoff
Identical verified package to R-A and R-B. Judged logic only in R.
