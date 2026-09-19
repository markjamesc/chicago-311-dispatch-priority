# Start Gate Package — Chicago 311 Dispatch Priority
**Updated:** 2026-09-18 21:00 CT  
**Status:** `READY_FOR_OWNER` (independent AI reviews complete)  
**Not:** `LOCKED` until human owner approves

## Decision statement (Dana-confirmed T010)

Dana Brooks (311 Ops Duty Manager, portfolio simulation) must decide which open eligible 311 requests in a frozen decision window should receive **ESCALATE**, **INCONCLUSIVE**, or **STANDARD** dispatch priority, in order to focus limited shift attention on unresolved requests that deserve elevation without forcing uncertain cases into either bucket, subject to treating results as a portfolio simulation (not live City dispatch and not employee scoring) and without inventing an official City SLA. Exact window dates and urgency formulas are deferred to measurement design. Output: **one row per request**.

## Independent Start reviews

| Role | Model / mode | Verdict |
|---|---|---|
| AI 2 Decision reconstruction | Grok **Comprehensive** (verified) | **Pass** |
| AI 3 Ambiguity red team | DeepSeek **DeepThink** | **Revise** |

### AI 2 (Pass) — gist
Owner, three actions, request-level unit, frozen window, outcome, and simulation constraints are confirmed. Deferred items (dates, eligibility detail, urgency) do not block naming the decision. Watch item for Framing: define “open eligible.”

### AI 3 (Revise) — gist
May confuse **output format** (label every row) with the **decision** (where to put scarce attention). If many rows are ESCALATE, capacity/ranking is missing. Strongest falsifier: if more ESCALATE than Dana can handle, is the decision still a complete three-way label for every row, or a ranked shortlist/subset?

## Coordinator reconciliation (not owner approval)

Both reviews are coherent. AI 3’s capacity concern is real for Framing/Stage 3, but Dana already locked the three-way request-level menu and rejected force-fit / ward / policy frames. Recommendation for owner:

- **Approve Start** if the locked decision is the three-way classification list (as Dana T010 and project lock), and treat capacity/ranking as Framing or Stage 3 open items.
- **Revise Start** if you want the decision itself redefined as ranked shortlist / subset selection before Framing.

## Start Gate checklist

| Requirement | Status |
|---|---|
| Decision owner | Met (Dana); human-owner approval **this step** |
| Action or choice | Met — ESCALATE / INCONCLUSIVE / STANDARD |
| Alternatives | Met — three-way; no fourth |
| Outcome | Met |
| Constraint | Met — simulation; no employee scores; no fake City SLA |
| Time scope | Principle met — frozen window; dates later |
| Analytical relevance | Met |
| Stakeholder (Dana) confirmation | Met (T010) |
| AI 2 Start review | Complete — Pass |
| AI 3 Start review | Complete — Revise (capacity/ranking) |
| Human-owner approval | **PENDING_OWNER** |

## Explicit non-locks (Stage 3)

Exact window dates; open/eligible definitions; urgency formulas; capacity/ranking rules; SQL; R; fixtures.

## Next

Owner approves or revises. Only then write `stage1_decision.json` LOCKED and begin Framing. Stage 3 still forbidden until Framing Gate passes.
