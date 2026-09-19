# Framing Gate Package — Chicago 311 Dispatch Priority
**Generated:** 2026-09-18 21:16 CT  
**Status:** `READY_FOR_OWNER` + `PENDING_INDEPENDENT_AI_FRAMING_REVIEWS` + `BLOCKED_NO_COMPUTERUSE_ON_EXECUTOR`  
**Not:** `LOCKED` — do **not** write `stage2_framing.json` with status LOCKED until the human owner approves Framing Gate after real AI 2 / AI 3 Framing reviews.

## Locked Start (input — already owner-locked)
See `stage1_decision.json` (LOCKED 2026-09-18 21:07 CT).  
Decision class must not be redefined. Capacity/ranking remains an open later item.

## Candidate analytical question CQ-F01 (Dana-confirmed T016)

> Among open eligible 311 requests in the frozen decision window, which requests should receive ESCALATE, which INCONCLUSIVE, and which STANDARD dispatch priority so limited shift attention can focus on unresolved requests that deserve elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, and without inventing an official City SLA)?

## Decision linkage
Answering CQ-F01 assigns each open eligible request in the frozen window to exactly one of the three locked Start actions, supporting Dana’s portfolio attention decision without forcing uncertain cases.

## Framing Gate checklist

| Requirement | Status | Evidence |
|---|---|---|
| One primary analytical question | Met (CQ-F01) | T015–T016 |
| Decision owner identifiable | Met — Dana Brooks (simulation) | Locked Start; T010 |
| Action / resource choice clear | Met — ESCALATE / INCONCLUSIVE / STANDARD | T010, T014, CQ-F01 |
| Unit / target bounded | Met — open eligible requests; one row/request | T010, T012 |
| Intended outcome explicit | Met — focus limited attention; hold uncertain | T015–T016 |
| Time scope defined (principle) | Met — frozen decision window; dates → Stage 3 | T006 |
| Material capacity / policy constraint represented | Met in question (limited attention + simulation constraints); ranking if over-capacity **open later** | T014; owner Start note |
| Required exceptions recorded | Met — INCONCLUSIVE | T004, T010 |
| Not leading / not causal overclaim | Pending AI 3 Framing audit | Packet ready |
| Answerable through analysis | Met in principle; Stage 3 defines rules | CQ-F01 |
| Different answers → different actions | Met | Three-way menu |
| Stakeholder (Dana) confirmation | Met | T016 |
| AI 1 Builder (ChatGPT high reasoning) | **PENDING computerUse** | `packets/AI1_FRAMING_BUILDER_PROMPT.md` |
| AI 2 Framing decision-fit (Grok Comprehensive) | **PENDING computerUse** | `packets/AI2_FRAMING_REVIEW_PROMPT.md` |
| AI 3 Framing red-team (DeepSeek DeepThink) | **PENDING computerUse** | `packets/AI3_FRAMING_REVIEW_PROMPT.md` |
| Human-owner Framing approval | **PENDING_OWNER** | Do not fabricate |

## Explicit non-locks (Stage 3 / open notes)
- Exact decision-window calendar dates / snapshot cutoff semantics  
- Exact open and eligibility formulas  
- Urgency / lateness / portfolio evidence thresholds  
- Capacity ranking / shortlist if ESCALATE exceeds attention (open Framing→Stage 3 note; not a Start reopen)  
- SQL, R, fixtures, Source Gate  

## Coordinator attestation
- Start was not redefined; capacity/ranking recorded as open later per owner + Dana T014.  
- Full Dana secret brief was **not** pasted into public packets.  
- No Stage 3 measurement design, SQL, or R started.  
- Independent Framing AI reviews were **not invented**.  
- `stage2_framing.json` LOCKED was **not** written.

## Next human / parent step
1. Parent dispatches **computerUse** (this executor has no Task/computerUse):  
   - AI1 = ChatGPT Chat (highest reasoning) ← `packets/AI1_FRAMING_BUILDER_PROMPT.md`  
   - AI2 = Grok Comprehensive (blind) ← `packets/AI2_FRAMING_REVIEW_PROMPT.md`  
   - AI3 = DeepSeek DeepThink (blind; do not show AI2 reply first) ← `packets/AI3_FRAMING_REVIEW_PROMPT.md`  
2. Save reviews under `reviews/` (`ai1_framing_builder.md`, `ai2_framing_review_pass1.md`, `ai3_framing_review_pass1.md`).  
3. Reconcile into this package.  
4. **Owner** approves or revises Framing Gate (`PENDING_OWNER`).  
5. Only then write `stage2_framing.json` with `status: LOCKED`.  
6. Stage 3 remains forbidden until Framing is LOCKED.
