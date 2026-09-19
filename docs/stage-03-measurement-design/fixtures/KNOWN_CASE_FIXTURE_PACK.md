# KNOWN_CASE_FIXTURE_PACK — Stage 3 Chicago 311
**Fixture version:** `fixtures-v0.1-PENDING`  
**Status:** `DRAFT_FOR_DESIGN_GATE` — freezes to authoritative only when Design Gate locks (before any R builder).  
**Authority:** Stage 3 §7 decision rules + §3–§5 population rules in `MEASUREMENT_DESIGN.md`.  
**Synthetic OK:** cases below are synthetic illustrations (not live SR numbers).

## Freeze / no-greenwash rules
1. Freeze path + content hash before R-A / R-B implementation or execution.
2. On Fail: repair implementation toward locked Stage 3; **do not** rewrite expected outcomes to force green.
3. Owner-authorized fixture correction ⇒ new fixture version + rerun.

## Assumed constants for expected labels
- `T_freeze` = 2026-09-12 23:59:59 America/Chicago (**WA-W1**)
- `open_age_days_threshold` = 14 (**WA-K1**)

## Case index

| ID | Intent | Expected universe | Expected action | Must-fail-if-omitted |
|---|---|---|---|---|
| F01 | Open eligible young → STANDARD | eligible | STANDARD | Age gate inverted / threshold ignored |
| F02 | Open eligible old → ESCALATE (exact knob boundary) | eligible | ESCALATE | Off-by-one on `>= 14` |
| F03 | Open eligible exactly 13 days → STANDARD | eligible | STANDARD | Treating `>` instead of `>=` incorrectly in reverse |
| F04 | Closed / not Open → out of open set | excluded | (no action) | Treating Completed as open |
| F05 | Info-only Open → ineligible | excluded (`info_only`) | (no action) | Dropping info-only exclusion |
| F06 | Missing CREATED_DATE → ineligible or INCONCLUSIVE | excluded or INCONCLUSIVE | INCONCLUSIVE if kept | Forcing STANDARD/ESCALATE |
| F07 | Blank SR_TYPE → ineligible/INCONCLUSIVE | excluded or INCONCLUSIVE | INCONCLUSIVE if kept | Forcing action |
| F08 | Duplicate-child clean → excluded | excluded (`duplicate_child`) | (no action) | Counting children as eligible STANDARD/ESCALATE |
| F09 | Contradictory DUPLICATE without PARENT → INCONCLUSIVE | eligible | INCONCLUSIVE | Excluding or forcing ESCALATE/STANDARD |
| F10 | CREATED_DATE after T_freeze → INCONCLUSIVE | eligible | INCONCLUSIVE | Ignoring clock anomaly |
| F11 | Legacy truthy → excluded (if WA legacy-exclude stands) | excluded (`legacy`) | (no action) | Dropping legacy rule |
| F12 | Knob boundary twin: age 14 → ESCALATE | eligible | ESCALATE | Same as F02; guards threshold translation |

## Case records
See individual JSON files in this folder (`F01_....json` …). Each file is the minimal synthetic source row + expected judged fields.
fixture_pack_content_hash_sha256: 55cc3add50c2e49b06cad8f380fdd13a12f198dfd1bbc7a8228730b04cf4640e
