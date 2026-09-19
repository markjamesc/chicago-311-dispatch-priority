# Stage 3 Handoff Inputs — Chicago 311 Dispatch Priority
**Generated:** 2026-09-18 21:16 CT  
**Status:** `INPUTS_ONLY` — Framing Gate not yet owner-locked.  
**Forbidden:** Do not begin Stage 3 measurement design, SQL, or R from this file until Framing is LOCKED.

## Locked content (available now)
| Item | Value |
|---|---|
| Original request | T000 — help figuring which unresolved 311 requests need attention this period |
| Approved decision (Start LOCKED) | Among open eligible 311 requests in a frozen decision window, assign ESCALATE / INCONCLUSIVE / STANDARD (one row per request) |
| Decision owner | Dana Brooks (synthetic 311 Ops Duty Manager) / human owner approval |
| Possible actions | ESCALATE, INCONCLUSIVE, STANDARD |
| Intended outcome | Focus limited shift attention on unresolved requests that deserve elevation; hold uncertain cases |
| Unit / target | Individual open eligible request; one row per request |
| Time scope | Frozen decision window (exact dates not locked) |
| Constraints | Portfolio simulation only; not live City dispatch; no employee scoring; do not invent official City SLA |
| Exceptions | INCONCLUSIVE for cannot-classify-with-confidence |
| Output form | Request-level classification list |
| Stakeholder Start confirmation | T010 |
| Owner Start approval | stage1_decision.json LOCKED 2026-09-18 21:07 CT |

## Framing candidate (NOT owner-locked yet)
| Item | Value |
|---|---|
| CQ-F01 | See FRAMING_GATE_PACKAGE.md |
| Dana Framing confirmation | T016 |
| AI Framing reviews | PENDING computerUse |
| Owner Framing approval | PENDING_OWNER |
| stage2_framing.json | **Not LOCKED** — see `stage2_framing.PENDING.md` |

## Open design work for Stage 3 (when Framing locks)
Stage 3 must still define (inputs only listed here — do not design yet):
- Formal hypothesis  
- Exact population and exclusions (open/eligible formulas)  
- Analytical grain confirmation  
- KPI / evidence rules / urgency formulas (portfolio rules — not fake City SLA)  
- Comparison groups / segments / confounders as needed  
- Thresholds and decision rules mapping evidence → ESCALATE / INCONCLUSIVE / STANDARD  
- Capacity/ranking treatment if ESCALATE volume exceeds attention (open note from Start/Framing)  
- Validation criteria and known limitations  
- Exact frozen-window calendar dates / snapshot semantics  

## Authority
- Start/Framing frameworks under `/workspace/chicago-311-run/`  
- Master prompt: one dataset = one decision; simulation only  

## Stop line
**Do not start Stage 3 design until Framing Gate is owner-LOCKED.**
