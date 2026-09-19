# Stage 3 Measurement Design — LOCKED
**Project:** Chicago 311 Dispatch Priority Simulation  
**Status:** **LOCKED**  
**design_version:** `stage3-v1-tcd-ig`  
**locked_at:** 2026-09-19 05:23:53 CDT  
**Construct:** TCD-IG B-leaning hybrid (type-conditional dormancy + integrity gate; Design A diagnostics retained)  
**Owner-tunable knob:** κ default **2.0** (grid 1.0 / 1.5 / 2.0 / 3.0); method constants W=365d, n_min=50  
**Owner approval (2026-09-19 CT):** "Approve Design Gate: B-leaning hybrid with κ; accept checklist items 1–15; accept Grok Auto for this pass"  
**AI2 this pass:** Grok Auto accepted (Comprehensive unavailable)  
**Authority:** Locked Stage 1 Start + Stage 2 Framing CQ-F02; this document is the Stage 3 lock  
**Supersedes:** Prior coordinator scratch `MEASUREMENT_DESIGN.md` (superseded scratch — not authoritative)  
**Promoted from:** `stage3_reconciled_design_DRAFT.md`  
**Date (CT):** 2026-09-19  
**No production SQL/R code in this document.**

---

## 0. Working assumptions (LOCKED)

1. Portfolio simulation only — not live City dispatch, not employee scoring, no invented official City SLA.  
2. Decision set evaluated at a single frozen as-of timestamp **T** supplied by owner with the window.  
3. First-pass bounded feasibility: **T aligns with the frozen snapshot** (historical as-of open without status history is out of scope).  
4. Row key: `SR_NUMBER` (unique in snapshot: 14,635,395 = distinct IDs).  
5. Open proxy: STATUS in owner-locked Open-token list (working default: `Open`).  
6. Primary elevate construct: **type-conditional dormancy**, not global calendar age.  
7. Exactly one owner-tunable decision knob: **κ**.  
8. Capacity/ranking deferred; if needed after simulation, return to Framing — do not add ranking here.  
9. Method B: SQL nonjudgmental delivery; R judges labels.  
10. Peer P75 is an **empirical** Completed-peer statistic — never labeled or used as a City SLA.

---

## 1. Decision context (locked)

Among open eligible 311 requests in a frozen decision window, assign exactly one of:

- **ESCALATE**
- **INCONCLUSIVE**
- **STANDARD**

One row per request (`SR_NUMBER`). Intended use: portfolio simulation so limited shift attention can focus on unresolved requests that warrant elevation while uncertain cases are held separately.

---

## 2. Hypothesis (reconciled)

**Business:** When shift attention is limited, open eligible requests can be separated into those with stronger evidence of needing elevated attention, those with insufficient/untrustworthy evidence, and those suitable for standard handling.

**Mechanism (B-leaning):** The construct that matches “unresolved requests that warrant elevation” is **forgotten-relative-to-type work** — coherent open rows whose silence (`dormant_h`) exceeds κ times the type’s own empirical Completed peer P75 closure cycle — not merely raw open age from CREATED_DATE.

Calendar age mixes (i) long-cycle types that are supposed to stay open longer, (ii) tickets crews are actively touching, and (iii) tickets that have gone silent. Type-conditional dormancy targets (iii).

**Falsifiable prediction:** In a historical as-of backcast (if later authorized), ESCALATE rows should show longer remaining time-to-close / higher still-open rates than STANDARD of the same type. κ-sweep must move ESCALATE counts monotonically (higher κ → fewer ESCALATE).

**Counterevidence:** If LAST_MODIFIED is mostly non-field ETL; if ESCALATE and STANDARD remaining-time distributions are indistinguishable; if owner known-cases require raw age elevation (e.g., F03 → ESCALATE) — then this construct fails and Framing/measurement must reopen.

---

## 3. Population, open, eligible, grain

### Population
One row per `SR_NUMBER` in the **open-eligible** set at frozen **T**. First-pass window locked to snapshot as-of T (checklist item 4); T_freeze working from snapshot max CREATED ~2026-09-12 America/Chicago.

### Open (LOCKED)
- STATUS parses to Open (case/whitespace-normalized) per locked Open-token list.  
- Completed / Canceled / Closed are **out of the decision set** (no label).

### Eligible skeleton (LOCKED)
Include only if all hold:

1. Open per above.  
2. DUPLICATE is not true-like (`true` / `Y` / `1` / `yes`) — default **exclude**.  
3. LEGACY_RECORD is not true-like — default **exclude** (unless owner explicitly includes legacy).  
4. CREATED_DATE parses and `created_ts ≤ T`.  
5. `type_key = coalesce(trim(SR_SHORT_CODE), trim(SR_TYPE))` non-blank.

Rows that are open-like but fail integrity (below) remain in the decision set as **INCONCLUSIVE**, not forced STANDARD/ESCALATE.

### Explicit non-exclusions (from Design A)
Do **not** exclude for cleaning based solely on request type, geography, age, or workload difficulty — those are signals/diagnostics, not scrub criteria.

### Grain
Exactly one classification per `SR_NUMBER`. Do **not** collapse parent/child clusters into a super-row (that changes grain and becomes ranking/capacity design).

---

## 4. Evidence construct and metrics

| Metric | Definition | Role |
|--------|------------|------|
| `created_ts` | Parsed CREATED_DATE | Clock start |
| `mod_ts` | Parsed LAST_MODIFIED_DATE; missing/unparseable → integrity fail | Activity clock |
| `closed_ts` | Parsed CLOSED_DATE | Integrity on open rows |
| `open_age_h` | T − created_ts (hours) | **Diagnostic only** — not decision statistic |
| `dormant_h` | T − mod_ts (hours); require mod_ts ≥ created_ts | **Primary decision statistic** |
| `type_key` | coalesce(SR_SHORT_CODE, SR_TYPE) after trim | Peer group |
| `peer_n` | Count of Completed, non-dup, non-legacy historical peers same type_key with parseable created/closed, closed ≥ created, created in lookback **W** ending at T | Sample-size gate |
| `peer_p50_h`, `peer_p75_h` | Median / 75th pct of (closed − created) hours on peers | Type-conditional cycle |
| `thin_type` | peer_n < **n_min** | Integrity / uncertainty |
| `integrity_fail` | See §5 | Gate |

**Method constants (not knobs):** W = **365 days**; n_min = **50**. Changing them is a design change, not owner tuning of κ.

---

## 5. INCONCLUSIVE rules (integrity gate first)

A row in the open-eligible candidate set is **INCONCLUSIVE** if any of:

1. STATUS Open-like but `closed_ts` parseable and non-null (contradiction; covers Open vs CLOSED_DATE discrepancy class).  
2. `created_ts` or `mod_ts` unparseable, or `mod_ts < created_ts`.  
3. `created_ts > T` (future create / clock error).  
4. `type_key` blank.  
5. `thin_type` (peer_n < n_min).  
6. DUPLICATE unparseable (not clearly true or false) **if** row was retained for adjudication.  
7. PARENT_SR_NUMBER populated and parent cannot be resolved in extract to a single SR_NUMBER with known STATUS (orphan child).  
8. STATUS string Open-like but not in locked Open-token list.

INCONCLUSIVE is a first-class output of the locked question (“uncertain cases held separately”), not a residual bin for model failure.

---

## 6. Decision rules (exactly one label)

Apply in order:

0. **Not in decision set** → emit no label.  
1. **INCONCLUSIVE** if integrity_fail.  
2. **ESCALATE** if not integrity_fail and `dormant_h ≥ κ · peer_p75_h`.  
3. **STANDARD** otherwise (open, eligible, coherent, not dormant-relative-to-type at current κ).

No tie-break ranking inside ESCALATE. Output is an unordered three-way partition.

**Deliberately does not use:** open_age_h as trigger; WARD/COMMUNITY_AREA equity weights; ORIGIN / OWNER_DEPARTMENT / CREATED_DEPARTMENT as priority; public CHI311 average completion times or OIG SLAs as thresholds.

---

## 7. Single owner-tunable knob

**Knob κ** — dormancy multiplier on type peer P75.

- Domain: grid `{1.0, 1.5, 2.0, 3.0}` for simulation; continuous κ ≥ 1 allowed if owner wants a slider.  
- **Default first pass: κ = 2.0.**  
- Meaning: how many type-cycles of silence count as warranting elevation.  
- Higher κ → fewer ESCALATE, more STANDARD (among coherent rows).  
- **Not knobs:** n_min, W, ESCALATE count cap, geo weights, multi-factor confidence scores.

---

## 8. SQL source-delivery contract (Method B)

**SQL may:**

- Extract/project needed columns from `chicago311.raw_311_requests`.  
- Parse-or-null timestamps under a **locked** parse expression (do not drop parse failures — R must see them).  
- Flag missingness, duplicate, legacy, parent presence.  
- Build **peer aggregate** table: per type_key → peer_n, peer_p50_h, peer_p75_h from Completed non-dup non-legacy rows in lookback W.  
- Emit decision-candidate rows (Open-like) joined to peer stats.  
- Produce counts/hashes for Source Gate; fixture extracts.  
- Narrow mechanical envelope: do **not** ship full 14.6M rows to R — target open-scale candidates (~245k before eligibility cuts).

**SQL must not:**

- Assign ESCALATE / INCONCLUSIVE / STANDARD.  
- Apply κ or urgency scores.  
- Invent City SLA thresholds.

**Minimum delivery columns (illustrative contract):**  
SR_NUMBER, STATUS, CREATED_DATE / created_ts, LAST_MODIFIED_DATE / mod_ts, CLOSED_DATE / closed_ts, SR_TYPE, SR_SHORT_CODE, type_key, DUPLICATE, LEGACY_RECORD, PARENT_SR_NUMBER, COMMUNITY_AREA, WARD, peer_n, peer_p50_h, peer_p75_h, (optional diagnostic OWNER_DEPARTMENT).

---

## 9. R judged logic contract

**R owns:**

- Integrity predicates and INCONCLUSIVE assignment.  
- Application of κ rule → ESCALATE / STANDARD.  
- Reason codes (integrity clause id, dormant_h, peer_p75_h, κ).  
- Portfolio counts; fixture pass/fail.  
- R-A labels; R-B sensitivity on κ grid (and optional P50 leave-one-constant **diagnostic**, not a second production knob).  
- Documentation of every transformation, threshold, exclusion, classification reason.

**R must not:** re-query a moving source; invent SLA; score employees; rank ESCALATE into a shortlist without Framing rewrite.

**Output row (LOCKED):**  
SR_NUMBER, type_key, classification, evidence_reason / reason_code, dormant_h, peer_n, peer_p75_h, kappa, open_age_h, integrity_clause, rule_version  

Plus portfolio counts: n_decision, n_ESCALATE, n_INCONCLUSIVE, n_STANDARD, and κ-grid count table.

---

## 10. Diagnostic segments (from Design A — evaluation only)

Not decision rules:

- **Request type** — concentration of labels by SR_TYPE / type_key.  
- **Age bands** — newer / medium / older `open_age_h` (cutoffs provisional analytical only — not City SLAs).  
- **Geography** — WARD / COMMUNITY_AREA for uneven classification detection.

---

## 11. Data quality plan (pre-classification)

- **Identity:** SR_NUMBER unique on extract.  
- **Timestamps:** parse failures, impossible ordering, missing required clocks.  
- **Status:** distribution Open / Completed / Canceled / Closed; Open vs CLOSED_DATE null discrepancy count.  
- **Missingness:** profile LAST_MODIFIED (expected 0), geo, dup/legacy/parent flags.  
- **Source Gate counts:** total rows, status dist, open count, date min/max, nulls, candidate-window counts, row hashes for R-A/R-B recon.

---

## 12. Fixture list outline (required before builders)

Synthetic, field-realistic, dates relative to T. Owner sign-off is the construct check.

| ID | Sketch | Expected | Why |
|----|--------|----------|-----|
| F01 | Open pothole-like; peer_p75=7d; last modify 20d ago; κ=2 | ESCALATE | Silent > 2× type P75 |
| F02 | Same type; created 40d ago; modified 1d ago | STANDARD | Age large; dormancy not |
| F03 | Building-like; peer_p75=90d; dormant 100d; κ=2 | STANDARD | 100 < 180; naive age would escalate |
| F04 | Open + CLOSED_DATE populated | INCONCLUSIVE | Contradiction |
| F05 | LAST_MODIFIED before CREATED | INCONCLUSIVE | Clock fail |
| F06 | Rare type; peer_n=8 | INCONCLUSIVE | Thin type |
| F07 | DUPLICATE=true, Open, dormant 400d | Out of set (or INCONCLUSIVE if dups kept) | Not the work item |
| F08 | LEGACY_RECORD true, else F01-like | Out of set under default | Different generating process |
| F09 | PARENT_SR_NUMBER set; parent unresolved | INCONCLUSIVE | Orphan child |
| F10 | peer_p75=3d; created 4d ago; never modified after create; dormant 4d; κ=2 | STANDARD | 4 < 6 |
| F11 | Same as F10; dormant 8d | ESCALATE | Crossed κ×P75 without large calendar age |
| F12 | Canceled or Completed | No label | Outside decision set |
| F13 | Unparseable CREATED_DATE, STATUS Open | INCONCLUSIVE | Cannot compute clocks |
| F14 | Two open non-dup rows same address/type | Two independent labels | Grain = SR_NUMBER |

If owner requires F03 → ESCALATE, **deny this locked construct** and return to Framing/measurement on “old in days.”

---

## 13. Capacity / Framing return rule

Locked Start defers “capacity/ranking if ESCALATE volume exceeds attention.”

- This design emits an **unordered** ESCALATE set.  
- If simulation at default κ produces more ESCALATE than a shift can review: **do not** add secondary sort (age, ward, harm) here.  
- **Return to Framing** with a new candidate question (hard cap C + ranking statistic).  
- Lowering κ is **not** a capacity tool — it changes the forgottenness construct.

Flag: **RANKING_NOT_IN_SCOPE**.

---

## 14. Limitations (honest)

- No work-order grain; one SR may hide many jobs.  
- LAST_MODIFIED ≠ field work (ETL/geocode can reset dormancy → false STANDARD).  
- Peer P75 confounds “forgotten” with “department generally slow.”  
- Fixed W can mis-scale seasonal types.  
- Types that rarely close → thin_type → permanent INCONCLUSIVE park.  
- Unflagged multi-reports → parallel ESCALATE rows (grain accepts; capacity panic is Framing).  
- Survivor open stock (unworkable address, etc.) looks dormant.  
- String dates; parse rules are measurement and must be fixture-locked.  
- Portfolio labels are not dispatch orders or performance scores.

---

## 15. Builder readiness inputs / outputs

**Required inputs before Stage 4:** frozen T + window; approved open tokens; approved eligibility (dup/legacy/parent); approved parse/tz; approved κ default/grid; approved fixtures F01–F14; Design Gate PASS.

**Required outputs:** classification table per §9; portfolio counts; fixture pass/fail; no ranked index; no department scorecard.

---

## 16. Design Gate self-check (LOCKED)

| Gate | Locked |
|------|-------|
| 1 Decision Alignment | Pass |
| 2 Population | Pass |
| 3 Grain | Pass |
| 4 Measurement Validity | Pass |
| 5 Comparisons | Pass |
| 6 Confounders | Pass |
| 7 Data Quality | Pass |
| 8 Decision Rules | Pass |
| 9 Single Knob | Pass |
| 10 SQL/R Separation | Pass |
| 11 Builder Readiness | Pass |

**Overall: LOCKED — Design Gate PASS. Stage 4 may begin.**

---

*End of MEASUREMENT_DESIGN_LOCKED.md*
