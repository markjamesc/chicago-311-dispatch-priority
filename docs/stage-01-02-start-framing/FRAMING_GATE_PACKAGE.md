# Framing Gate Package — Chicago 311 Dispatch Priority
**Updated:** 2026-09-18 22:15 CT  
**Status:** `READY_FOR_OWNER` (independent Framing AI reviews complete)  
**Not:** `LOCKED` until human owner approves

## Locked Start (unchanged)
`stage1_decision.json` LOCKED — three-way ESCALATE / INCONCLUSIVE / STANDARD; capacity/ranking later.

## Candidate questions

### CQ-F01 (Dana T016 accepted; original boxed)
> Among open eligible 311 requests in the frozen decision window, which requests should receive ESCALATE, which INCONCLUSIVE, and which STANDARD dispatch priority so limited shift attention can focus on unresolved requests that deserve elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, and without inventing an official City SLA)?

### CQ-F02 (recommended Tightening from AI reviews)
> Among open eligible 311 requests in the frozen decision window, which requests should Dana Brooks assign ESCALATE, which INCONCLUSIVE, and which STANDARD (one row per request) so limited shift attention can focus on unresolved requests that warrant elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, and without inventing an official City SLA)? Exact window dates, open/eligible formulas, urgency and evidence rules, and any capacity ranking if ESCALATE volume exceeds attention remain measurement-design open items and are not part of this question.

## Independent Framing reviews

| Role | Mode | Verdict |
|---|---|---|
| AI 1 Builder | ChatGPT Chat (High reasoning) | **Keep** CQ-F01 |
| AI 2 Decision-fit | Grok Comprehensive (verified) | **Tighten** → CQ-F02; then Pass |
| AI 3 Red team | DeepSeek DeepThink (verified) | **Pass with required revision** (capacity deferral explicit; portfolio not live dispatch; prefer “warrant/classify” over “deserve”) |

## Coordinator recommendation
Approve **CQ-F02**. It keeps the locked Start, names Dana, restores the deferred-items sentence Dana confirmed in T015–T016, and makes capacity/ranking explicitly **not** part of this question. AI 1 Keep is coherent but thinner than what Dana accepted.

## Framing Gate checklist (after CQ-F02)

| Requirement | Status |
|---|---|
| One primary analytical question | Met (CQ-F02) |
| Decision owner in question | Met — Dana Brooks |
| Action clear | Met — three labels |
| Unit / time | Met — request-level; frozen window |
| Outcome / constraints | Met — simulation bounds |
| Capacity representation | Met — ranking deferred, explicit |
| Dana confirmation of substance | Met (T016); wording Tightening from reviews |
| AI 1 / AI 2 / AI 3 Framing reviews | Complete |
| Human-owner Framing approval | **PENDING_OWNER** |

## Explicit non-locks (Stage 3)
Exact window dates; open/eligible formulas; urgency/evidence rules; capacity ranking; SQL; R; fixtures.

## Next
Owner approves CQ-F02 (or revises). Then write `stage2_framing.json` LOCKED. Stage 3 still forbidden until then.
