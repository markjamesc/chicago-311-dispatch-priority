# SPEC_TO_BUILDER_PACKET — Stage 3 Chicago 311
**Design version:** `stage3-v0.1-PENDING`  
**Fixture version:** `fixtures-v0.1-PENDING`  
**Status:** PROPOSED — complete for Design Gate review; Stage 4 builders must not start until LOCKED.

## Technology roles
> SQL gets the data. The SQL Source Gate verifies delivery. R-A and R-B independently wrangle/analyze. Exact reconciliation tests R agreement.

## Gate-class map

| Gate class | Used? | Clause cite | Fixture map | R-A / R-B attestation |
|---|---|---|---|---|
| Open definition | YES | MEASUREMENT_DESIGN §3.3 | F04 | Implement `STATUS=="Open"` exactly |
| Eligibility + exclusions | YES | §3.4, §5 | F05,F06,F07,F08,F11 | Emit exclusion_reason; no silent drops |
| Duplicate/parent contradiction | YES | §5.2 | F09 | INCONCLUSIVE; do not force ESCALATE/STANDARD |
| Open age metric | YES | §6.1 | F01–F03,F12 | floor-day age vs T_freeze; timezone Chicago |
| Action rule order | YES | §7 A→B→C | F02,F03,F09,F10 | INCONCLUSIVE before ESCALATE before STANDARD |
| One locked knob | YES | §7 / WA-K1 | F02,F03,F12 | `open_age_days_threshold=14` only |
| Selected flag | YES | §7 | F01,F02 | `selected <=> action==ESCALATE` |
| Capacity / ranking | **N/A** | §11 WA-C1 | — | Must NOT invent rank/shortlist |
| Half-window persistence | **N/A** | design-cited unused | — | N/A |
| Dual-clock / twin | **N/A** | unused | — | N/A |
| Membership-first + capacity + no-pad | **N/A** | capacity deferred | — | N/A |
| Lineage mapping | YES | §10.1–10.3 | — | snapshot_id / design_version / fixture_version on outputs |
| Simulation labels | YES | Start constraints | — | Outputs labeled portfolio simulation / not live dispatch |

## Forbidden builder behaviors
- Precomputing judged fields in SQL
- Sharing judged code or action lists between R-A and R-B
- Rewriting fixtures after Fail
- Calling 14-day threshold a City SLA
- Adding capacity ranking inside action assignment

## Required Stage 4 outputs (after lock)
R-A judged output; R-B judged output; fixture results both paths; exact reconciliation table; structural cross-review; validated action list.
