# Design Gate Package — Chicago 311 Dispatch Priority
**Status:** `LOCKED` (human owner approved 2026-09-19 ~04:33 CT)

## Owner approval
Approve Stage 3 Design Gate with WA working assumptions as locked.

## Locked substance (summary)
- Freeze: Open set = `STATUS='Open'` at **2026-09-12 23:59:59 America/Chicago**
- Open / eligible / INCONCLUSIVE / STANDARD / ESCALATE per MEASUREMENT_DESIGN.md
- **One knob:** `open_age_days_threshold = 14` (portfolio rule, **not** City SLA)
- Capacity/ranking: Stage 5 note only
- Method B: thin nonjudgmental SQL delivery; judged logic in R-A/R-B only
- Fixtures: `fixtures/KNOWN_CASE_FIXTURE_PACK.md` (SHA recorded in stage3_locked_design.json)

## Machine-readable receipt
`docs/stage-03-measurement-design/stage3_locked_design.json` — status **LOCKED**

## Hard stop
**Stage 4 is NOT authorized** until the owner explicitly says to begin Method B (SQL Source Gate → R-A/R-B → recon → workflow gate).
