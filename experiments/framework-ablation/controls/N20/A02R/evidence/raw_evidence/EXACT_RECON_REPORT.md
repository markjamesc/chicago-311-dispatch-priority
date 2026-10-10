# Exact recon report — R-A vs R-B

**Status:** PASS (after clock-parse fix)  
**When:** 2026-09-19 13:46 CT  
**Decision set:** 222,002 rows (identical SR_NUMBER sets)

## Portfolio (κ = 2)

| Path | ESCALATE | INCONCLUSIVE | STANDARD |
|------|----------|--------------|----------|
| R-A  | 131,968  | 6,377        | 83,657   |
| R-B  | 131,968  | 6,377        | 83,657   |

## Label agreement

- Agree: **222,002 / 222,002**
- Disagree: **0**
- Only-RA / Only-RB: 0 / 0

Fixtures: both paths **14/14 PASS** (F03 → STANDARD).

## Prior mismatch (diagnosed, then fixed)

First production run disagreed on **104** rows, all `STANDARD` (R-A) vs `ESCALATE` (R-B).  
Peer `n` / `p75` / κ matched; `dormant_h` differed by a systematic **~5.0 hours** (America/Chicago offset). All 104 sat within 5h of the κ×p75 threshold.

**Cause:** naive SQL wall clocks (`created_ts` / `mod_ts`) were tagged as UTC by `readr`. R-B’s POSIXct shortcut kept the wrong instant; R-A’s `force_tz` happened to recover Chicago wall digits. Locked rule now: **always character → parse as `America/Chicago` wall**; never `force_tz` / never trust readr POSIXct for these columns.

**Fix files:** `R-A/run_RA.R` (`parse_ts_chicago` + `clock_col_types`); `R-B/R/10_io_parse.R` (`rb_parse_ts` / `rb_normalize_open` / TSV + character cols).

## Next

Structural cross-review + Validation Gate freeze (owner), then Stage 5.
