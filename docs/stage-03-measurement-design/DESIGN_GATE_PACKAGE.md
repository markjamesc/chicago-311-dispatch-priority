# DESIGN_GATE_PACKAGE — Chicago 311 Stage 3
**Generated:** 2026-09-19 04:35 CT  
**Status:** `READY_FOR_OWNER` + `PENDING_INDEPENDENT_AI_STAGE3_REVIEWS` + `NO_COMPUTERUSE_ON_EXECUTOR`  
**Not:** `LOCKED` — do **not** write `stage3_locked_design.json` with status LOCKED until human owner approves after real AI1/AI2/AI3 Stage 3 reviews (or explicit owner waiver).

## What is ready
| Deliverable | Path | State |
|---|---|---|
| Measurement design | `MEASUREMENT_DESIGN.md` | PROPOSED complete contract |
| Fixtures | `fixtures/KNOWN_CASE_FIXTURE_PACK.md` + F01–F12 | DRAFT_FOR_DESIGN_GATE |
| Source delivery contract | `SOURCE_DELIVERY_CONTRACT.md` | PROPOSED |
| Spec→builder packet | `SPEC_TO_BUILDER_PACKET.md` | PROPOSED |
| Pending machine contract | `stage3_locked_design.PENDING.json` | PENDING_OWNER (not LOCKED) |
| Three-AI packets | `packets/AI1_*.md`, `AI2_*.md`, `AI3_*.md` | READY for parent computerUse |
| Warrant ledger | `docs/warrant-ledger.md` | Updated with Stage 3 proposals |

## Working assumptions awaiting owner (must confirm or revise)
1. **WA-W1** `T_freeze` = 2026-09-12 23:59:59 America/Chicago  
2. **WA-O1** Open = `STATUS='Open'`  
3. **WA-E1** Eligibility + info-only `311 INFORMATION ONLY CALL` + legacy exclude  
4. **WA-K1** Knob `open_age_days_threshold = 14` (portfolio, **not** City SLA)  
5. **WA-I1 / WA-S1** INCONCLUSIVE / STANDARD rules as written  
6. **WA-C1** Capacity/ranking deferred (Stage 5 note only)

## Design Gate checklist (11 gates)

| # | Gate | Status | Notes |
|---|---|---|---|
| 1 | Decision alignment | Met (proposed) | CQ-F02 / Start preserved; 3 actions; capacity deferred |
| 2 | Hypothesis | Met (proposed) | §2 with counterevidence |
| 3 | Population | Met (proposed) | Open/eligible/exclusions + audits; freeze WA |
| 4 | Grain / joins | Met (proposed) | One row / SR_NUMBER; no joins |
| 5 | Metrics | Met (proposed) | open_age_days contracted; non-SLA labeled |
| 6 | Comparisons / segments | Met (proposed) | Diagnostic segments; no ward ranking decision |
| 7 | Confounders / ceiling | Met (proposed) | Descriptive ceiling |
| 8 | DQ / uncertainty | Met (proposed) | Varchar dates; sensitivities |
| 9 | Decision rules | Met (proposed) | A→B→C; one knob; selected; capacity N/A |
| 10 | Stage 4 SQL→R contract | Met (proposed) | Source + Source Gate + Spec→builder + fixtures; **no production SQL/R** |
| 11 | Review / ownership | **PENDING** | Packets ready; AI reviews not executed here; owner lock required |

## Three-AI review status (honest)
| Role | Mode | Status |
|---|---|---|
| AI 1 Primary design | ChatGPT Chat (high reasoning) | **PACKET READY** — not executed (no computerUse on this executor) |
| AI 2 Counter-design / methods | Grok Comprehensive | **PACKET READY** — not executed |
| AI 3 Data/feasibility audit | DeepSeek DeepThink | **PACKET READY** — not executed |

Coordinator did **not** invent AI review verdicts. Parent must run computerUse **or** owner may review the complete proposed design directly at Design Gate with packets available.

## Hard stops
- **Do not** start Stage 4 production SQL builders.
- **Do not** run R-A / R-B.
- **Do not** mark `stage3_locked_design.json` LOCKED without owner approval.
- **Do not** call the 14-day threshold a City SLA.

## Next steps for owner / parent
1. (Optional) Parent computerUse: AI1 → AI2 → AI3 using `packets/`; save under `reviews/`.
2. Reconcile required revisions into MEASUREMENT_DESIGN if any.
3. **Owner** confirms or revises WA-* items and approves Design Gate.
4. Only then: write LOCKED JSON, freeze fixture hash, authorize Stage 4 Method B.
