# Start Gate Package — Chicago 311 Dispatch Priority
**Generated:** 2026-09-18 20:22 CT  
**Status:** `READY_FOR_OWNER` + `PENDING_INDEPENDENT_AI_REVIEWS` + `BLOCKED_NO_COMPUTERUSE_ON_EXECUTOR`  
**Not:** `LOCKED` (do not create stage1_decision.json with LOCKED until owner approves and AI 2/AI 3 Start reviews exist)

## Decision statement (Dana-confirmed T010)

Dana Brooks (311 Ops Duty Manager, portfolio simulation) must decide which open eligible 311 requests in a frozen decision window should receive **ESCALATE**, **INCONCLUSIVE**, or **STANDARD** dispatch priority, in order to focus limited shift attention on unresolved requests that deserve elevation without forcing uncertain cases into either bucket, subject to treating results as a portfolio simulation (not live City dispatch and not employee scoring) and without inventing an official City SLA. Exact window dates and urgency formulas are deferred to measurement design. Output: **one row per request**.

## Start Gate checklist

| Requirement | Status | Evidence |
|---|---|---|
| Decision owner | Met (Dana); owner approval pending | T000, T010 |
| Action or choice | Met — ESCALATE / INCONCLUSIVE / STANDARD | T004, T010 |
| Alternatives | Met — three-way menu, no fourth | T004, T010 |
| Outcome | Met — focus limited attention; protect uncertain cases | T009–T010 |
| Constraint | Met — capacity; simulation; no employee scores; no fake City SLA | T008, T010 |
| Time scope | Principle met — frozen window; dates → Stage 3 | T006 |
| Analytical relevance | Met — different classifications → different actions | T002, T004 |
| Stakeholder (Dana) confirmation | Met | T010 |
| AI 2 independent Start review | **BLOCKED** | Executor lacks Task/computerUse; packet ready; not invented |
| AI 3 independent Start review | **BLOCKED** | Executor lacks Task/computerUse; packet ready; not invented |
| Human-owner approval | **PENDING_OWNER** | Owner must approve — do not fabricate |

## Explicit non-locks (Stage 3)

- Exact decision-window calendar dates / snapshot cutoff semantics  
- Eligible-universe definition details  
- Open definition formula  
- Urgency / lateness / portfolio threshold formulas  
- SQL, R, fixtures, Source Gate  

## Coordinator attestation

- Dialogue discovered the destination decision class; it was not handed to AI 1 on turn 1.  
- Full Dana secret brief was **not** pasted into analyst-facing turns.  
- No Stage 3 measurement design started.  
- Independent AI reviews were **not invented**.  

## Next human / parent step

1. ~~Finish three-AI access verification~~ — owner confirmed ChatGPT / Grok / DeepSeek accessible.  
2. Parent must dispatch **computerUse** (executor cannot): AI2=Grok then AI3=DeepSeek Start reviews using prepared packets.  
3. Reconcile reviews into this package.  
4. **Owner** approves or revises this Start Gate package (`PENDING_OWNER`).  
5. Only then write `stage1_decision.json` with `status: LOCKED` (or keep PENDING files).  
6. Framing lock only after owner Start approval. Stage 3 forbidden until Framing locked.  
