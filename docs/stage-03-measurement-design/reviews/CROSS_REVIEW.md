# Stage 3 Cross-Review — Chicago 311 Dispatch Priority
**Role:** Coordinator synthesis after three independent first passes  
**Status:** Analytical synthesis only — not owner lock  
**Date (CT):** 2026-09-19  
**Sources used:** `AI1_DESIGN_A.md`, `AI2_DESIGN_B.md`, `AI3_DATA_RISK_DOSSIER.md`, `SHARED_INPUT_PACKET.md`, review metas; locked `stage1_decision.json` / `stage2_framing.json` (repo).  
**Constraint:** No new designs invented beyond reconciliation of A/B + dossier bounds. Prior coordinator `MEASUREMENT_DESIGN.md` is superseded scratch.

---

## 1. Independence attestation

| Pass | Model / mode | What they saw | What they did **not** see | Meta note |
|------|--------------|---------------|---------------------------|-----------|
| **AI1 Design A** | ChatGPT Chat + highest reasoning | Shared Stage 3 packet only (locked Start, Framing CQ-F02, source manifest excerpt, Method B constraints) | Design B; AI3 dossier; coordinator MEASUREMENT_DESIGN; other AIs' outputs | Independent Design A from shared packet only (CT ~2026-09-19 04:57) |
| **AI2 Design B** | **Grok plain Auto** (Comprehensive **not** available in picker this run) | Same shared packet only | Design A; AI3 dossier; coordinator MEASUREMENT_DESIGN | Independent Design B blind to Design A (CT ~2026-09-19 05:12). **Note for Design Gate: Grok used Auto, not Comprehensive.** |
| **AI3 Data Risk Dossier** | DeepSeek DeepThink ON | Same shared packet only | Design A; Design B; coordinator MEASUREMENT_DESIGN | Independent dossier blind to A/B (CT ~2026-09-19 05:19) |

All three first passes were run under controlled blindness. This cross-review is the first document that juxtaposes them.

Locked Start (2026-09-18 21:07 CT) and Framing CQ-F02 (2026-09-18 22:17 CT) remain authoritative. Deferred items (exact window, open/eligible formulas, urgency/evidence rules, capacity/ranking) stay Stage 3 owner decisions — not silently closed by this synthesis.

---

## 2. Side-by-side: Design A vs Design B

| Dimension | Design A (AI1) | Design B (AI2) |
|-----------|----------------|----------------|
| **Name / claim** | Evidence-confidence classification architecture | **Type-Conditional Dormancy with Integrity Gate (TCD-IG)** — escalate only if coherent open row has been dormant longer than κ × type peer P75 closure cycle, not merely raw calendar age |
| **Hypothesis** | Open requests differ in age, continued unresolved state, modification history, category, geography; structured rules can separate elevated vs standard vs insufficient evidence | Construct matching CQ-F02 is **forgotten-relative-to-type**, not raw open age. Calendar age mixes long-cycle types, actively touched tickets, and silent tickets; type-conditional dormancy separates silence |
| **Falsifiability** | Stated qualitatively (age may not correlate; status may be administrative; unstable under spec changes) | Explicit: historical as-of backcast — ESCALATE should show longer remaining time-to-close / higher still-open rates than STANDARD of same type; κ-sweep must be monotone |
| **Population** | All 311 requests in frozen window meeting approved open + eligibility | One row per SR_NUMBER in open-eligible set at frozen as-of **T**; T and eligible predicate are Framing-open inputs |
| **Open definition** | Provisional: `STATUS = 'Open'` within frozen snapshot | `STATUS` parses to Open (case/whitespace-normalized); Completed/Canceled/Closed out of decision set |
| **Eligible skeleton** | Inside window + open + sufficient required evidence fields (SR_NUMBER, SR_TYPE, CREATED_DATE, STATUS, LAST_MODIFIED_DATE; geo optional) | Open + not duplicate (true-like) + not legacy (default exclude) + CREATED_DATE ≤ T + non-blank type_key; contradictory rows → INCONCLUSIVE or dropped |
| **Exclusions** | Missing SR_NUMBER, invalid create ts, outside window; **do not** exclude by type/geo/age | Dup/legacy default out; integrity failures stay in set as INCONCLUSIVE when open-like |
| **Grain** | One classification per SR_NUMBER | Same; parent/child **not** collapsed (would change grain / become ranking). Orphan child → INCONCLUSIVE |
| **Evidence construct** | **Age-forward:** persistence (age since CREATED_DATE; absence of CLOSED_DATE) + activity (LAST_MODIFIED vs create) + context (type/geo). Confidence must exceed threshold for ESCALATE | **Dormancy-forward:** primary statistic `dormant_h = T − mod_ts`; compare to `κ · peer_p75_h` of Completed non-dup non-legacy peers of same type_key. `open_age_h` is **diagnostic only** |
| **INCONCLUSIVE rules** | Possible attention need but insufficient or conflicting signals; prevents forced decisions | **Integrity gate first:** Open+CLOSED_DATE contradiction; unparseable/inverted clocks; future create; blank type; thin_type (peer_n < 50); unparseable DUPLICATE; orphan parent; unmapped Open-like tokens |
| **STANDARD / ESCALATE** | ESCALATE if open + elevated-need evidence + above confidence threshold; STANDARD if open + sufficient evidence of no elevated need | After integrity pass: ESCALATE iff `dormant_h ≥ κ · peer_p75_h`; else STANDARD |
| **Single knob** | `confidence_threshold` (how much evidence before ESCALATE; higher → fewer ESCALATE / more INCONCLUSIVE) | **κ** dormancy multiplier on type P75; grid {1.0, 1.5, 2.0, 3.0}, default **2.0**. W=365d and n_min=50 are **method constants**, not knobs |
| **What is not a knob** | Multiple urgency weights, geo adjustments, employee factors, hidden SLA, capacity ranking | Same + n_min, W, ESCALATE count cap |
| **SQL vs R split** | SQL: extract/joins/type-safe nonjudgmental fields; **no** labels/scores/thresholds. R: parse, features, evidence, classification, validation | Method B aligned: SQL emits typed columns + **peer aggregate table** (peer_n, peer_p50/p75) without CASE labels. R-A applies integrity + κ; R-B sensitivity on κ grid / P50 diagnostic |
| **Fixtures** | Four categories: clear ESCALATE, clear STANDARD, ambiguous → INCONCLUSIVE, boundary near threshold | **F01–F14** field-realistic relative to T (incl. F03 long-cycle STANDARD vs naive age; F04 contradiction; F06 thin type; F07–F09 dup/legacy/orphan; F10–F11 new-but-dormant) |
| **Capacity / Framing** | Confirm capacity discussion deferred | **RANKING_NOT_IN_SCOPE.** If ESCALATE volume exceeds attention, **return to Framing** with new CQ; do not add secondary sort inside this design; lowering κ is not a capacity tool |
| **Self-assessment** | Gates 1–10 PASS; Gate 11 PASS WITH OPEN ITEMS | CONDITIONAL GO; REVISE if owner wants raw calendar age as the elevate construct, or capped shortlist without Framing rewrite |

### Material construct contrast (not a vote)

- **A** operationalizes “warrants elevation” via **age + activity + confidence** (global-ish evidence strength).
- **B** operationalizes it as **type-conditional silence** and treats INCONCLUSIVE as a **hard integrity gate**, not a residual bin.
- F03 is the litmus: B says long-cycle type dormant 100d with peer_p75=90d at κ=2 → **STANDARD**; a naive age cutoff would escalate. If the owner’s known cases want F03 → ESCALATE, **B is the wrong construct** and Framing/measurement must reopen on “old in days.”

---

## 3. AI3 dossier confront: A and B supportability

Dossier verdict: **Supportable-with-bounds**. Snapshot-open row-level assignment with unique SR_NUMBER is feasible after rules lock. Historical as-of open without status history, hour-level age without timezone, conceptual dedupe without dup/legacy/parent rules, capacity/ranking, and exact R-A/R-B recon **before** locks are **not** supportable now.

| Design element | Supportable | Supportable-with-bounds | Blocked until owner lock / Framing |
|----------------|-------------|-------------------------|-------------------------------------|
| **A: STATUS='Open' as open proxy** | ✓ (row-level) | Must reconcile ~24-row gap: Open ~245,193 vs CLOSED_DATE missing ~245,217 | Treating Open ≡ CLOSED_DATE IS NULL as identical |
| **A: age from CREATED_DATE** | | Date-level age if parse + window locked | Hour/DST age without timezone rule |
| **A: activity via LAST_MODIFIED** | | Field exists (0 missing in packet); semantics must be locked | Using mod after window (leakage); undefined “attention” |
| **A: confidence_threshold knob** | | Conceptually fits “one knob” | Exact score formula not specified — not implementable until evidence→score map locked |
| **A: optional geo segments** | Diagnostic OK | | Using geo as decision rule (second policy) |
| **B: type-conditional peer P75** | | Feasible mechanically from Completed peers in lookback W | Misreading peer P75 as City SLA (must label “empirical, not SLA”); seasonality of W; chronically slow types lower bar |
| **B: dormant_h primary statistic** | | Supportable if T and parse locked; LAST_MODIFIED ≠ field work named | Historical window with post-window mod leakage |
| **B: integrity → INCONCLUSIVE** | Strongly aligned with dossier | Open+CLOSED_DATE contradiction, parse fails | — |
| **B: exclude dup/legacy default** | | Fields exist | Distributions unknown; inventing exclude without Dana lock is methodology invention (dossier: blocked until locked) |
| **B: thin_type n_min=50, W=365** | | Method constants OK if labeled | Changing them silently = second knobs / design change |
| **B: κ knob** | ✓ clearest single tunable | Default 2.0 provisional | Cap on ESCALATE count as alternate knob → Framing |
| **Both: SQL extract / R judge** | ✓ Method B | Peer aggregates in SQL OK if nonjudgmental | SQL writing ESCALATE/INCONCLUSIVE/STANDARD |
| **Both: capacity ranking** | | | If needed → **return to Framing** (dossier blocking gap; Start deferred) |
| **Both: frozen window / as-of T** | | If window = snapshot, bounded feasibility | Historical as-of without status history (major leakage) |
| **Both: exact R-A/R-B recon** | | After all locks | Before window, open/eligible, parse/tz, dup/legacy/parent, activity, evidence/knob, fixtures |

**Dossier-favored pieces of A:** explicit STATUS proxy; diagnostic segments; DQ plan (identity, timestamps, status distribution, missingness); SQL nonjudgment.

**Dossier-favored pieces of B:** integrity-first INCONCLUSIVE; explicit Open vs CLOSED_DATE contradiction; dup/legacy/parent as lockable eligibility; type-conditional statistic avoiding fake global SLA day cutoff; RANKING_NOT_IN_SCOPE; fixture litmus F03; mechanical envelope (~245k candidates, not 14.6M in R).

**Blocked from both until owner:** exact T/window; Open token list; dup/legacy/parent include-exclude; parse expression + timezone; activity definition; single knob value/grid; fixture sign-off; capacity path.

---

## 4. Material disagreements (evidence-based, not majority vote)

1. **Primary evidence statistic — age/confidence (A) vs type-conditional dormancy (B).**  
   Evidence: A lists age as Domain 1 persistence; B states calendar age mixes long-cycle / active / silent and uses dormant_h vs peer P75. F03 is the disagreement test case.

2. **Specificity of the single knob — vague confidence_threshold (A) vs operational κ (B).**  
   Evidence: A does not define how evidence maps to a numeric confidence; B gives dormant_h ≥ κ·peer_p75_h and a discrete grid. Dossier requires one locked knob for R-A/R-B recon feasibility.

3. **INCONCLUSIVE as soft residual (A) vs hard integrity gate (B).**  
   Evidence: A — insufficient/conflicting signals; B — ordered Step 1 integrity_fail before any elevation, including thin_type and date contradictions. Dossier flags Open/CLOSED_DATE gap and parse/tz as blocking — closer to B’s gate.

4. **Eligibility surface — minimal fields (A) vs dup/legacy/type/created≤T skeleton (B).**  
   Evidence: A required fields table; B working eligible skeleton. Dossier: eligibility not feasible until rules locked; provisional safe assumption is one row per SR_NUMBER without inventing dedupe.

5. **Fixture depth — 4 categories (A) vs F01–F14 with construct litmus (B).**  
   Evidence: A categories vs B table; B explicitly says owner disagreement on F03 means wrong design / Framing reopen.

6. **Capacity handling — soft deferral (A) vs hard RANKING_NOT_IN_SCOPE + Framing return (B).**  
   Evidence: Start/Framing both defer capacity/ranking; B forbids silent shortlist in Stage 3 design. Dossier: capacity/ranking blocked; return to Framing if required.

7. **Peer aggregates in SQL (B) vs pure raw columns (A).**  
   Evidence: B allows peer_n/p75 in SQL without labels; A lists raw columns only. Dossier allows SQL to compute age/activity deltas and flags under locked rules — peer aggregates are mechanical if nonjudgmental; labels remain R-only.

**Non-disagreements (both align with locked Start):** three-way labels; one row per SR_NUMBER; portfolio simulation; no employee scoring; no invented City SLA; Method B SQL extract / R judge; one owner knob; fixtures before builders; no production SQL/R in Stage 3.

---

## 5. Recommended reconciled direction for Design Gate

### Recommendation: **B-leaning hybrid**

**Lock candidate construct:** Type-Conditional Dormancy with Integrity Gate (from B), with A’s documentation strengths grafted on (diagnostic segments, DQ checklist, explicit non-exclusions for type/geo/age as cleaning criteria).

**Why B-leaning (tradeoffs):**

| Keep from B | Why | Tradeoff / cost |
|-------------|-----|-----------------|
| dormant_h vs κ·peer_p75_h | Matches “warrants elevation” without a global day cutoff that reads as fake SLA; falsifiable; F03 protects long-cycle types | LAST_MODIFIED may be ETL heartbeat (false STANDARD); slow historical types lower P75 bar; thin types park in INCONCLUSIVE |
| Integrity-first INCONCLUSIVE | Aligns dossier contradictions / parse fails / Open–CLOSED gap | INCONCLUSIVE pile can be large |
| κ as sole knob; W & n_min method constants | Implementable; recon-friendly | Owner cannot tune n_min/W without design return |
| RANKING_NOT_IN_SCOPE | Honors locked Start deferral | If shift attention < ESCALATE volume, must reopen Framing — no silent shortlist |
| F01–F14 fixture outline | Construct check before warehouse | Owner must sign F03 litmus |

| Keep from A | Why | Tradeoff |
|-------------|-----|----------|
| Diagnostic segments (type, age bands, geography) for **evaluation only** | Detect uneven classification without becoming rules | Must not sneak into decision |
| Data-quality plan (identity, timestamp, status dist, missingness) | Matches Source Gate needs in dossier | — |
| Explicit “STATUS alone does not escalate” | Prevents open→escalate collapse | — |
| Builder output columns: classification, evidence_reason, rule_version | Clear Stage 4 handoff | Merge with B’s dormant_h, peer_*, κ, integrity_clause |

| Reject / do not carry | Reason |
|----------------------|--------|
| A’s undefined confidence score as the production knob | Not implementable; would invent a multi-factor urgency formula |
| Global open-age day cutoff as primary trigger | Invents SLA-like threshold; fails F03; contradicted by B hypothesis |
| Silent capacity ranking inside Stage 3 | Violates Start/Framing; AI3 blocking |

### What must return to Framing (not silent Stage 3)

- Any **hard cap C** or **ranking among ESCALATE** if volume exceeds attention.
- Any change of construct to **raw calendar age** as the elevate criterion (would reject TCD-IG / F03).
- Historical **as-of open** simulation requiring status history the source does not provide (dossier: major leakage) — if owner demands historical T ≠ snapshot, Framing/measurement must address as-of status.

---

## 6. Open owner decisions (approve / deny style)

Exact items for Dana Brooks (simulation owner). Each is **Approve** or **Deny/revise**; Stage 3 does not lock without responses.

1. **Approve / Deny:** Reconciled lock candidate = **B-leaning hybrid (TCD-IG)**: primary statistic = type-conditional dormancy; not Design A confidence-age as primary.
2. **Approve / Deny:** Single owner-tunable knob = **κ** (dormancy multiplier on type peer P75); default simulation κ = **2.0**; grid {1.0, 1.5, 2.0, 3.0}.
3. **Approve / Deny:** Method constants (not knobs): lookback **W = 365 days**, **n_min = 50** for thin_type → INCONCLUSIVE.
4. **Approve / Deny:** Frozen decision window equals **current snapshot as-of T** (bounded feasibility); historical as-of without status history **out of scope** for first pass.
5. **Approve / Deny:** Open definition = STATUS parses to locked Open-token list (default token: `Open`); Completed/Canceled/Closed out of decision set.
6. **Approve / Deny:** Reconcile Open vs CLOSED_DATE missing discrepancy (~24 rows) via integrity: Open + parseable CLOSED_DATE → **INCONCLUSIVE** (not forced ESCALATE/STANDARD).
7. **Approve / Deny:** Eligibility default: exclude **DUPLICATE** true-like; exclude **LEGACY_RECORD** true-like; require non-blank type_key; CREATED_DATE ≤ T.
8. **Approve / Deny:** Orphan / unresolved PARENT_SR_NUMBER → **INCONCLUSIVE**; do **not** collapse parent/child clusters (grain stays SR_NUMBER).
9. **Approve / Deny:** Date parse rule + timezone for Stage 4 (date-level wall-clock acceptable; hour-level claims denied until tz locked).
10. **Approve / Deny:** `open_age_h` diagnostic only — **not** the escalate trigger.
11. **Approve / Deny:** Peer P75 labeled in all outputs as **empirical peer statistic, not a City SLA**.
12. **Approve / Deny:** Fixture pack outline F01–F14 (esp. **F03** long-cycle → STANDARD at κ=2) as construct sign-off.
13. **Approve / Deny:** Capacity/ranking remains **out of Stage 3**; if ESCALATE exceeds attention, **return to Framing** (no secondary sort inside this design).
14. **Approve / Deny:** SQL may emit peer aggregates (peer_n, peer_p50_h, peer_p75_h) and typed clocks; SQL must **not** emit ESCALATE/INCONCLUSIVE/STANDARD.
15. **Approve / Deny:** Prior coordinator `stage-03/MEASUREMENT_DESIGN.md` (and related early package) is **superseded scratch** — not the lock candidate.
16. **Approve / Deny:** Note on record that AI2 (Design B) was produced with **Grok Auto**, not Comprehensive — accept for this Stage 3 pass or request a Comprehensive re-run before lock.

---

## 7. Design Gate Gates 1–11 — draft scores for RECONCILED candidate

Scoring the **B-leaning hybrid**, not raw A or raw B alone.

| Gate | Draft score | Notes |
|------|-------------|-------|
| **1 — Decision Alignment** | **Pass** | Three-way ESCALATE/INCONCLUSIVE/STANDARD; one row per SR_NUMBER; portfolio simulation; constraints honored |
| **2 — Population Definition** | **Open** | Skeleton stated; exact T, Open tokens, dup/legacy/parent await owner approve/deny |
| **3 — Grain Integrity** | **Pass** | SR_NUMBER grain; no cluster collapse; orphan → INCONCLUSIVE |
| **4 — Measurement Validity** | **Pass** | Dormancy construct explicit; peer P75 not claimed as City SLA; F03 litmus; dossier bounds named |
| **5 — Comparison Integrity** | **Pass** | Type/age/geo segments diagnostic only (from A); not decision inputs |
| **6 — Confounder Awareness** | **Pass** | LAST_MODIFIED≠field work; slow-type P75; seasonality of W; survivor open stock; named, not “adjusted away” |
| **7 — Data Quality Controls** | **Open** | DQ plan present; Open–CLOSED ~24-row recon and parse/tz still owner-locked |
| **8 — Decision Rule Completeness** | **Pass** | Ordered: not in set → integrity INCONCLUSIVE → κ ESCALATE → else STANDARD |
| **9 — Knob Governance** | **Pass** | Exactly one tunable: κ; W/n_min constants; no capacity knob |
| **10 — SQL/R Separation** | **Pass** | Method B; peer stats mechanical in SQL; labels in R only |
| **11 — Implementation Readiness** | **Open** | Architecture ready after owner checklist; fixtures not yet signed; no Stage 4 until Design Gate **PASS** |

**Draft Design Gate posture:** **CONDITIONAL — not PASS.** Multiple Gates Open pending §6 owner decisions. Stage 4 must not start until Design Gate PASS.

---

## 8. Synthesis close

Independent first passes produced a clear construct fork (age/confidence vs type-conditional dormancy). The dossier bounds favor an implementable, integrity-gated, SLA-avoiding statistic. **Recommended Design Gate candidate: B-leaning hybrid (TCD-IG + A documentation).** Owner must clear the approve/deny list; capacity remains Framing-only if needed.

*End of CROSS_REVIEW.*
