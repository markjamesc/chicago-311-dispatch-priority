<!-- SUPERSEDED 2026-09-19 CT: superseded scratch — authoritative lock is MEASUREMENT_DESIGN_LOCKED.md / stage3-v1-tcd-ig (B-leaning hybrid κ). -->
> **SUPERSEDED:** This file is prior coordinator scratch (open_age_days_threshold). Authoritative Stage 3 lock: `MEASUREMENT_DESIGN_LOCKED.md` (`stage3-v1-tcd-ig`).

# MEASUREMENT_DESIGN — Chicago 311 Dispatch Priority (Stage 3)

**Design version:** `stage3-v0.1-PENDING`  
**Generated:** 2026-09-19 04:35 CT  
**Status:** `PROPOSED — READY_FOR_OWNER` Design Gate (**NOT LOCKED**)  
**Machine-readable twin:** `stage3_locked_design.PENDING.json` (`status: PENDING_OWNER`)  
**Stop line:** Design Gate only. **Stage 4 not started** (no production SQL builders; no Source Gate execution; no R-A / R-B).

## Authority chain

| Layer | Artifact | Status |
|---|---|---|
| Stage 1 Start | `docs/stage-01-02-start-framing/stage1_decision.json` | **LOCKED** 2026-09-18 21:07 CT |
| Stage 2 Framing | `docs/stage-01-02-start-framing/stage2_framing.json` (**CQ-F02**) | **LOCKED** 2026-09-18 22:17 CT |
| Stage 3 Design | this document + pending JSON | **PENDING_OWNER** |
| Stage 4 Execution | Method B: controlled SQL → Source Gate → R-A / R-B | **NOT STARTED** |

## Locked Start (do not redefine)
Among open eligible 311 requests in a frozen decision window, assign exactly one of **ESCALATE**, **INCONCLUSIVE**, or **STANDARD** (one row per request). Portfolio simulation only — not live City dispatch; not employee scoring; **do not invent official City SLA**.

## Locked Framing CQ-F02 (verbatim)
> Among open eligible 311 requests in the frozen decision window, which requests should Dana Brooks assign ESCALATE, which INCONCLUSIVE, and which STANDARD (one row per request) so limited shift attention can focus on unresolved requests that warrant elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, and without inventing an official City SLA)? Exact window dates, open/eligible formulas, urgency and evidence rules, and any capacity ranking if ESCALATE volume exceeds attention remain measurement-design open items and are not part of this question.

---

## 0. Working-assumption banner (OWNER MUST CONFIRM)

Owner did **not** pre-answer window/knob overnight. Items marked **WORKING ASSUMPTION** are portfolio proposals for Design Gate confirm — **not** City rules and **not LOCKED** until owner approval.

| ID | Topic | Working assumption | Owner confirm |
|---|---|---|---|
| WA-W1 | Window / freeze | Open set = `STATUS='Open'` rows in the frozen snapshot (source-manifest max `CREATED_DATE` **2026-09-12 15:39:45**). Proposed analytical freeze `T_freeze` = **2026-09-12 23:59:59 America/Chicago**. | Confirm calendar freeze |
| WA-O1 | Open | `STATUS = 'Open'` (exact string) at freeze | Confirm |
| WA-E1 | Eligible | In-scope service requests; exclude pure info-only when field-backed; duplicate/legacy rules in §5 | Confirm |
| WA-K1 | One locked knob | `open_age_days_threshold = 14` for ESCALATE path — **portfolio rule, NOT City SLA** | Confirm or substitute |
| WA-I1 | INCONCLUSIVE | Missing critical dates/type **or** contradictory duplicate/parent evidence | Confirm |
| WA-S1 | STANDARD | Open eligible ∧ not ESCALATE ∧ not INCONCLUSIVE | Confirm |
| WA-C1 | Capacity / ranking | **Not** in action rule; Stage 5 note only | Confirm deferral |

---

## 1. Decision alignment
- **Simulation decision owner:** Dana Brooks / human owner approval.
- **Actions:** ESCALATE | INCONCLUSIVE | STANDARD (exactly one per eligible open request).
- **Outcome:** Focus limited shift attention on unresolved requests that warrant elevation; hold uncertain cases separately.
- **Out of scope:** live City dispatch; employee scoring; invented City SLA; ward ranking as the decision; capacity shortlist inside the action rule.

---

## 2. Hypothesis contract

### 2.1 Business hypothesis
A material subset of currently open eligible 311 requests has been unresolved long enough (by a disclosed portfolio age threshold) that labeling them **ESCALATE** is a useful attention signal for Dana’s shift triage; other open eligible requests remain **STANDARD**; requests with missing or contradictory evidence are held as **INCONCLUSIVE** rather than forced.

### 2.2 Mechanism (non-causal)
Age since `CREATED_DATE` relative to `T_freeze` is a transparent, field-backed attention proxy. It does **not** claim older tickets are more severe, more solvable, or City-SLA-breaching.

### 2.3 Observable implication
ESCALATE = non-empty inspectable subset with `open_age_days >= knob`; STANDARD = younger remainder with clean evidence; INCONCLUSIVE = evidence failures; exclusion audits explain non-members.

### 2.4 Counterevidence
- Near-zero ESCALATE → knob too high / open ages short.
- Near-all ESCALATE → knob too low; Stage 5 capacity note becomes urgent (**without** inventing ranking in Stage 3/4).
- Large INCONCLUSIVE share → data-quality / definition problem; reopen design.

### 2.5 Hierarchy
- **Primary:** three-way request-level classification.
- **Secondary / diagnostic:** type mix, geography mix, duplicate-flag rates (descriptive).
- **Exploratory:** sensitivity at knob ∈ {7, 14, 30} after primary freeze only.
- **Forbidden:** causal claims that labels change resolution time.

---

## 3. Population and eligibility

### 3.1 Target vs observable
| | Definition |
|---|---|
| Target | Open eligible 311 requests Dana might triage in the frozen window |
| Observable | Rows in frozen `chicago311.raw_311_requests` (~14,635,395 rows; Open = 245,193 per `../source-manifest.md`) |

### 3.2 Decision window (**WORKING ASSUMPTION WA-W1**)
- **Snapshot:** frozen local import in `../source-manifest.md`.
- **Open membership:** `STATUS = 'Open'` in that snapshot.
- **`T_freeze` (proposed):** `2026-09-12 23:59:59` America/Chicago (calendar day of snapshot max `CREATED_DATE` `2026-09-12 15:39:45`).
- **Boundary:** inclusive of all Open rows in the snapshot; no live ticker; no mid-analysis refresh.
- Owner must confirm calendar freeze before LOCKED.

### 3.3 Open definition (**WORKING ASSUMPTION WA-O1**)
```text
is_open_source := (STATUS == "Open")   # exact string on source varchar
```
Primary judged `is_open` follows this equality. Do **not** invent open from null `CLOSED_DATE` alone (diagnostic only). Manifest: missing `CLOSED_DATE` = 245,217 vs Open = 245,193 — near alignment, not identity.

### 3.4 Eligibility (**WORKING ASSUMPTION WA-E1**)
Eligible iff all hold:
1. `is_open_source`.
2. `SR_NUMBER` non-blank.
3. `SR_TYPE` non-blank.
4. `CREATED_DATE` present and parseable to timestamp ≤ `T_freeze`.
5. **Not** pure info-only: `SR_TYPE` ∉ info-only set.  
   **Proposed field-backed set:** `{"311 INFORMATION ONLY CALL"}` (extend only with profile evidence + owner confirm).
6. Passes duplicate/legacy rules in §5 (exclude clean duplicate-children; keep contradictions as INCONCLUSIVE).
7. **Legacy (**WORKING ASSUMPTION**):** exclude when `LEGACY_RECORD` is truthy (string-tolerant: true/True/1/YES/Y). Owner may flip to keep-legacy-open at Design Gate.

**Ineligible open rows** stay auditable (reason codes) but outside the judged action universe. Judged output = eligible open universe (one row per eligible request) + separate exclusion audit.

### 3.5 Required exclusion / branch audits
`open_source_n`, `excluded_info_only_n`, `excluded_duplicate_child_n`, `excluded_legacy_n`, `excluded_bad_created_n`, `excluded_blank_type_or_id_n`, `eligible_open_n`, `escalate_n`, `inconclusive_n`, `standard_n`.

---

## 4. Analytical grain

| Layer | Grain |
|---|---|
| Source | One physical row in `raw_311_requests` |
| SQL delivery | Same request-level rows (optional mechanical envelope) |
| Eligibility / decision | One row per `SR_NUMBER` |
| Request ID | `SR_NUMBER` (unique in this snapshot — verified; re-test on refresh) |

**Joins:** none for primary path. **Cardinality:** 1:1 `SR_NUMBER` → physical row in this snapshot.

---

## 5. Duplicate / legacy / parent treatment (**WORKING ASSUMPTION**)

Physical uniqueness: 0 duplicate `SR_NUMBER` (source-manifest).

Semantic fields: `DUPLICATE`, `PARENT_SR_NUMBER`, `LEGACY_RECORD`, `LEGACY_SR_NUMBER`.

1. **Duplicate-child exclusion:** If `DUPLICATE` truthy **OR** `PARENT_SR_NUMBER` non-blank → exclude from eligible (`duplicate_child`), unless rule 2.
2. **Contradiction → INCONCLUSIVE (stay eligible):**  
   - `DUPLICATE` truthy **AND** `PARENT_SR_NUMBER` blank, **OR**  
   - `PARENT_SR_NUMBER` non-blank **AND** `DUPLICATE` falsy/blank, **OR**  
   - `PARENT_SR_NUMBER` equals own `SR_NUMBER`  
   → keep in eligible universe; assign **INCONCLUSIVE** (`contradictory_duplicate_parent`).
3. **Legacy:** §3.4 item 7.
4. No parent open/closed join required for child exclusion. No invented SQL join expansion.

Truthy parsing for varchar flags must be validated in Stage 4 against actual stored forms.

---

## 6. Measurement / evidence

### 6.1 Primary evidence metric (not a City SLA)
**Name:** `open_age_days`  
```text
open_age_days = floor( (T_freeze - parse_timestamp(CREATED_DATE)) / 86400 seconds )
```
- Interpret timestamps as America/Chicago wall time unless offsets are present (then convert).
- Higher → more attention pressure under this portfolio rule.
- Missing/unparseable `CREATED_DATE` → fail eligibility (or INCONCLUSIVE if still present).

### 6.2 Diagnostics (not action drivers)
INCONCLUSIVE share; `SR_TYPE` mix within ESCALATE vs STANDARD; ward/community mix; duplicate-flag rates; exploratory knob sensitivity {7,14,30} after primary freeze.

### 6.3 Explicit non-SLA warrant
`open_age_days >= 14` is a **portfolio working assumption** (methodological / stakeholder-tunable). It is **not** source-backed as an official City SLA and must never be labeled as one (`docs/warrant-ledger.md`).

---

## 7. Decision rules (**WA-K1 / WA-I1 / WA-S1**)

Apply only to **eligible open** requests. Order mandatory:

### A — INCONCLUSIVE
If any: critical parse failure on `CREATED_DATE`; blank `SR_TYPE`/`SR_NUMBER` if still in set; contradictory duplicate/parent (§5.2); `CREATED_DATE` > `T_freeze`.

### B — ESCALATE
Else if `open_age_days >= open_age_days_threshold` with **`open_age_days_threshold = 14`** (**WA-K1**, portfolio, not City SLA) → **ESCALATE**.

### C — STANDARD
Else → **STANDARD**.

### Selected
```text
selected := (action == "ESCALATE")
```
Attention-candidate flag only. **No capacity cap, rank, or shortlist** in this rule (**WA-C1**).

### Exactly one owner-tunable knob
| Knob | Proposed value | Domain |
|---|---|---|
| `open_age_days_threshold` | 14 | positive integer days |

---

## 8. Segments, confounders, ceiling

**Segments (diagnostic):** `SR_TYPE` (top-N; min n=30 else OTHER); `WARD` / `COMMUNITY_AREA`; duplicate-child excluded vs contradictory INCONCLUSIVE.

**Rivals:** type mix; stale Open / data lag; duplicate inflation; seasonal creation; geography/equity concentration — disclose; do not silently optimize.

**Causal ceiling:** descriptive classification only.

---

## 9. Data quality / uncertainty
- Dates are **varchar** — defensive parse; record fail counts.
- Prefer filtered/LIMIT profiles; avoid slow full-table COUNT when possible.
- Empty ESCALATE is valid counterevidence.
- Large action churn across sensitivity knobs → disclose; do not retune without owner.

---

## 10. Stage 4 SQL→R contract (design only — **no production code**)

### 10.1 Controlled SQL source (Method B)
- **Source:** `chicago311.raw_311_requests` via `--login-path=chicago311`
- **Grain:** one source row per delivered `SR_NUMBER`
- **Deliver raw-ish columns** (prefer all 39 varchar columns if size allows). Minimum critical set:  
  `SR_NUMBER, SR_TYPE, STATUS, CREATED_DATE, LAST_MODIFIED_DATE, CLOSED_DATE, DUPLICATE, LEGACY_RECORD, LEGACY_SR_NUMBER, PARENT_SR_NUMBER, COMMUNITY_AREA, WARD` (+ other source columns as needed for audit).
- **Optional mechanical envelope:** `WHERE STATUS = 'Open'` (source equality) to bound ~245k rows. Envelope must be **wider than** judged eligibility. **Do not** filter on age in SQL.
- **Forbidden in SQL:** judged `is_open` / `is_eligible` / `is_in_window` / `open_age_days` / `action` / `selected` / rank / final membership as outputs.
- **Lineage:** snapshot_id, source_manifest reference, extraction timestamp, rowcount, distinct `SR_NUMBER`.

### 10.2 SQL Source Gate handoff (Stage 4 executes)
Prove vs authoritative raw under same envelope: rowcount; distinct `SR_NUMBER` = rowcount; critical-field equality; STATUS domain if enveloped; `CREATED_DATE` min/max & parse spot-checks; DUPLICATE/PARENT null profiles; lineage. Failure ⇒ no R judged run.

### 10.3 R-A / R-B judged outputs
Both independently produce at least:  
`SR_NUMBER, is_open, is_eligible, exclusion_reason, open_age_days, action, selected, evidence_notes, snapshot_id, design_version, fixture_version`  
One row per `SR_NUMBER` in judged eligible universe.

### 10.4 Reconciliation-critical fields
`SR_NUMBER, is_open, is_eligible, action, selected` (+ `open_age_days`, `exclusion_reason` audit-critical). Exact equality — no “close enough.”

### 10.5 Spec→builder / fixtures
See `SPEC_TO_BUILDER_PACKET.md` and `fixtures/KNOWN_CASE_FIXTURE_PACK.md`. Fixture version `fixtures-v0.1-PENDING` freezes at owner Design Gate lock, **before** any R builder.

### 10.6 Independence
R-A and R-B must not share judged code, judged ID lists, or action tables as build inputs. Shared Stage 3 + verified SQL package + fixtures only.

---

## 11. Capacity / ranking (**WA-C1**)
**Not part of action rule.** Stage 5 may note if `escalate_n` exceeds practical attention; any ranking design would be a **new** measurement decision.

---

## 12. Known limitations
Portfolio simulation only; age ≠ severity ≠ official SLA; snapshot Open may lag field state; info-only depends on `SR_TYPE` string stability; varchar flag truthiness needs Stage 4 confirmation; three-AI Stage 3 reviews **packets prepared, not executed** on this executor (no computerUse) — see Design Gate package.

---

## 13. Design Gate self-audit
Gates 1–10 addressed in §§1–10. Gate 11 (independent AI reviews + human lock): **PENDING** — packets ready; owner confirm required. **No production SQL or R written in Stage 3.**

## 14. What LOCKED would authorize
1. Freeze this Markdown + write `stage3_locked_design.json` with `status: LOCKED`.
2. Freeze fixture pack identity (hash).
3. Only then Stage 4 Method B may start.

Until then: **Stage 4 forbidden.**
