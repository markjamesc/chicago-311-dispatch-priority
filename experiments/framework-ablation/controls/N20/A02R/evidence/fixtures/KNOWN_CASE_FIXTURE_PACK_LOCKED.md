# Known-Case Fixture Pack — LOCKED
**fixture_version:** fixtures-v1-tcd-ig
**status:** LOCKED
**locked_at:** 2026-09-19 10:26:37 CT
**κ:** 2.0
**T:** 2026-09-12 23:59:59 America/Chicago (snapshot as-of)

| ID | Sketch | Expected | Why |
|----|--------|----------|-----|
| F01 | Open pothole-like; peer_p75=7d; last modify 20d ago; κ=2 | ESCALATE | Silent > 2× type P75 |
| F02 | Same type; created 40d ago; modified 1d ago | STANDARD | Age large; dormancy not |
| F03 | Building-like; peer_p75=90d; dormant 100d; κ=2 | STANDARD | 100 < 180; naive age would escalate |
| F04 | Open + CLOSED_DATE populated | INCONCLUSIVE | Contradiction |
| F05 | LAST_MODIFIED before CREATED | INCONCLUSIVE | Clock fail |
| F06 | Rare type; peer_n=8 | INCONCLUSIVE | Thin type |
| F07 | DUPLICATE=true, Open, dormant 400d | Out of set | Not the work item |
| F08 | LEGACY_RECORD true, else F01-like | Out of set | Different generating process |
| F09 | PARENT_SR_NUMBER set; parent unresolved | INCONCLUSIVE | Orphan child |
| F10 | peer_p75=3d; created 4d ago; never modified after create; dormant 4d; κ=2 | STANDARD | 4 < 6 |
| F11 | Same as F10; dormant 8d | ESCALATE | Crossed κ×P75 without large calendar age |
| F12 | Canceled or Completed | No label | Outside decision set |
| F13 | Unparseable CREATED_DATE, STATUS Open | INCONCLUSIVE | Cannot compute clocks |
| F14 | Two open non-dup rows same address/type | Two independent labels | Grain = SR_NUMBER |

A failed fixture is evidence against an implementation. Do not rewrite the fixture to make the code pass.
