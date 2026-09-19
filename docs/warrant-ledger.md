# Chicago 311 Warrant Ledger
**Updated:** 2026-09-19 04:35 CT (Stage 3 Design Gate proposals — not LOCKED)

Allowed basis labels: **source-backed** | **stakeholder-locked portfolio requirement** | **methodological judgment** | **unresolved/open**

| Item | Rule / cutoff | Basis | Evidence / rationale | Status |
|---|---|---|---|---|
| Decision class | ESCALATE / INCONCLUSIVE / STANDARD | stakeholder-locked portfolio requirement | Locked Start | Locked |
| Final grain | One row per request (`SR_NUMBER`) | stakeholder-locked portfolio requirement | Start + CQ-F02 | Locked |
| Decision window / T_freeze | Proposed 2026-09-12 23:59:59 America/Chicago; open set = STATUS Open in frozen snapshot (max CREATED_DATE 2026-09-12 15:39:45) | methodological judgment + source-backed snapshot facts | WA-W1 pending owner | **Proposed — Design Gate** |
| Open definition | STATUS == 'Open' | stakeholder-locked portfolio requirement (principle) + methodological judgment (exact string) | WA-O1; Dana T012 principle | **Proposed — Design Gate** |
| Eligibility | Open + nonblank id/type + parseable CREATED_DATE ≤ T_freeze + not info-only + duplicate/legacy rules | methodological judgment | WA-E1; field-backed info-only candidate | **Proposed — Design Gate** |
| Info-only exclusion | SR_TYPE == '311 INFORMATION ONLY CALL' | methodological judgment (field-backed candidate) | Portal/type vocabulary; not City policy claim | **Proposed — Design Gate** |
| Duplicate-child exclusion | DUPLICATE truthy OR PARENT_SR_NUMBER nonblank (unless contradiction) | methodological judgment | Semantic duplicate fields | **Proposed — Design Gate** |
| Contradiction → INCONCLUSIVE | Duplicate/parent disagreement or self-parent | methodological judgment | Missing/contradictory evidence path | **Proposed — Design Gate** |
| Urgency / lateness | open_age_days vs threshold | methodological judgment | Portfolio attention proxy | **Proposed — Design Gate** |
| Owner-tunable knob | open_age_days_threshold = **14** | stakeholder-locked portfolio requirement (one knob) + methodological judgment (value) | **NOT City SLA** | **Proposed — Design Gate** |
| Action rule | INCONCLUSIVE → ESCALATE if age≥knob → else STANDARD | methodological judgment | Maps to locked actions | **Proposed — Design Gate** |
| Selected | selected := (action == ESCALATE); no capacity cap | methodological judgment | Capacity deferred WA-C1 | **Proposed — Design Gate** |
| Capacity / ranking | Not in action rule; Stage 5 note only | stakeholder-locked portfolio requirement (deferred) | Start/Framing open note | Deferred |
| Source-delivery envelope | Optional STATUS='Open' mechanical filter; raw columns; no judged fields in SQL | methodological judgment | Method B | **Proposed — Design Gate** |

Do not silently change basis after seeing Stage 4 results. Owner Design Gate confirm promotes Proposed → Locked (or revises).
