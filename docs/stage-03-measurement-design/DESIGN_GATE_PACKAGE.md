# Stage 3 Design Gate Package — Chicago 311 Dispatch Priority
**Owner-facing** · Dana Brooks simulation / human owner approval  
**Date (CT):** 2026-09-19  
**Status:** **Design Gate PASS** — locked 2026-09-19 05:23:53 CDT; design_version `stage3-v1-tcd-ig`. Stage 4 may begin.

---

## What finished (independent first passes)

| Deliverable | Who | Blindness | Outcome |
|-------------|-----|-----------|---------|
| **Design A** | AI1 — ChatGPT Chat (highest reasoning) | Shared packet only | Primary architecture: age/activity/context evidence + `confidence_threshold` knob |
| **Design B** | AI2 — **Grok Auto** (Comprehensive unavailable this run) | Shared packet only; blind to A | Counter-design **TCD-IG**: type-conditional dormancy vs peer P75 + integrity-gate INCONCLUSIVE + knob **κ** |
| **Data Risk Dossier** | AI3 — DeepSeek DeepThink | Shared packet only; blind to A/B | Verdict: **Supportable-with-bounds**; blocking gaps listed (window, open/eligible, parse/tz, dup/legacy/parent, activity, knob, fixtures, capacity→Framing) |

Coordinator synthesis: `stage-03/reviews/CROSS_REVIEW.md`  
Locked design: `stage-03/MEASUREMENT_DESIGN_LOCKED.md` (promoted from reconciled draft)

**Note:** Prior coordinator scratch `stage-03/MEASUREMENT_DESIGN.md` (and early companion package files from before the three independent passes) is **superseded** and is **not** the lock candidate.

---

## Recommended lock candidate (1-page summary)

**Direction: B-leaning hybrid**

**Construct:** Among open eligible requests at frozen as-of **T**, assign exactly one of ESCALATE / INCONCLUSIVE / STANDARD using:

1. **Integrity gate** → INCONCLUSIVE if clocks/status/type/dup flags/parent resolution fail or type peer sample is thin.  
2. Else **ESCALATE** if `dormant_h ≥ κ × peer_p75_h` (silence vs empirical Completed peer cycle for same type_key).  
3. Else **STANDARD**.

**Not used as escalate trigger:** global calendar age from CREATED_DATE (reported as diagnostic `open_age_h` only).  
**Single owner knob:** **κ** (default 2.0; grid 1.0 / 1.5 / 2.0 / 3.0). Lookback W=365d and n_min=50 are method constants, not knobs.  
**Grain:** one label per SR_NUMBER; no parent/child collapse; no ranked shortlist.  
**SQL / R:** Method B — SQL nonjudgmental extract + peer aggregates; R judges labels. No production SQL/R in Stage 3.  
**Capacity:** if ESCALATE volume exceeds attention → **return to Framing**; do not add ranking inside this design.  
**Fixtures:** F01–F14 outline (construct litmus: long-cycle F03 stays STANDARD at κ=2).  
**Bounds (from AI3):** Prefer window = snapshot for first pass; reconcile Open vs CLOSED_DATE ~24-row gap via integrity; no invented City SLA; peer P75 labeled empirical-only.

**Why not pure A:** A’s confidence knob is not yet an implementable formula and leans on age in a way that risks a fake global day cutoff.  
**Why not pure B unchanged:** Hybrid keeps A’s diagnostic segments + DQ checklist for Source Gate / evaluation.

---

## Required owner approvals (checklist)

Respond **Approve** or **Deny/revise** to each:

- [x] **1.** Lock candidate = B-leaning hybrid (TCD-IG); not Design A confidence-age as primary  
- [x] **2.** Single knob = **κ**; default **2.0**; grid {1.0, 1.5, 2.0, 3.0}  
- [x] **3.** Method constants W=365d, n_min=50 (not knobs)  
- [x] **4.** First-pass window = snapshot as-of **T** (historical as-of without status history out of scope)  
- [x] **5.** Open = locked Open-token list (default `Open`); other statuses out of decision set  
- [x] **6.** Open + parseable CLOSED_DATE → INCONCLUSIVE (~24-row class)  
- [x] **7.** Default exclude DUPLICATE true-like and LEGACY_RECORD true-like; require type_key; CREATED_DATE ≤ T  
- [x] **8.** Unresolved PARENT_SR_NUMBER → INCONCLUSIVE; no cluster collapse  
- [x] **9.** Lock date-parse + timezone rule (date-level OK; hour-level deferred until tz locked)  
- [x] **10.** `open_age_h` diagnostic only — not escalate trigger  
- [x] **11.** Peer P75 labeled **empirical, not City SLA** on all outputs  
- [x] **12.** Fixture outline F01–F14 (esp. F03) as construct sign-off  
- [x] **13.** Capacity/ranking **out of Stage 3**; excess ESCALATE → return to Framing  
- [x] **14.** SQL may emit peer aggregates; SQL must not emit labels  
- [x] **15.** Prior coordinator MEASUREMENT_DESIGN = **superseded scratch**  
- [x] **16.** Accept AI2 produced under **Grok Auto** (not Comprehensive) for this pass, **or** require Comprehensive re-run before lock  

---

## Explicit stage boundary

**Stage 4 (SQL extract / Source Gate / R-A / R-B) does not start until Design Gate PASS.**

Design Gate **PASS** (owner 2026-09-19 CT). See `DESIGN_GATE_RECEIPT.md` and `MEASUREMENT_DESIGN_LOCKED.md`.

---

## Pointers

| Artifact | Path |
|----------|------|
| Cross-review | `stage-03/reviews/CROSS_REVIEW.md` |
| Design A | `stage-03/reviews/AI1_DESIGN_A.md` |
| Design B | `stage-03/reviews/AI2_DESIGN_B.md` |
| AI3 dossier | `stage-03/reviews/AI3_DATA_RISK_DOSSIER.md` |
| Locked design | `stage-03/MEASUREMENT_DESIGN_LOCKED.md` |
| Design Gate receipt | `stage-03/DESIGN_GATE_RECEIPT.md` |
| Locked Start / Framing | repo `docs/stage-01-02-start-framing/stage1_decision.json`, `stage2_framing.json` |

*End of DESIGN_GATE_PACKAGE.*
