# A02 Validator — Grok (INDEPENDENT FIRST PASS)

**Ablation ID:** A02  
**Constitution version:** 1.0 (as supplied; not re-derived)  
**Role:** Validator  
**Model:** Grok  
**Pass type:** Independent first pass (blind to Builder pack)  
**Mode:** Comprehensive  
**When written:** 2026-09-19 15:51 CDT  
**Terminal decision:** NONE (this pack does not return KEEP / REVERT / HALT)

---

## 1. Role attestation

- Assigned role is **Validator** only. Builder is specified as DeepSeek. Adjudicator is specified as ChatGPT. This pack does not assume any other role.
- This pass is **blind to the Builder report**. No Builder artifact, SHA, or narrative was present in the workspace or in the supplied prompt beyond the frozen SPEC / CONSTITUTION / EVIDENCE block.
- Workspace at validation time contained no baseline tree, no `BASELINE_FRAMEWORK.sha256`, no R-A/R-B source, no fixture JSON/CSV originals, and no raw stdout. Evaluation is therefore confined to the **pasted evidence pack** treated as the candidate frozen surface.
- Information barrier: Validator did not receive Builder first-pass text. Adjudicator is not addressed and is not given a terminal recommendation.
- Independence constraint honored: no attempt to repair code, rerun builders, rewrite fixtures, or invent missing hashes.
- Constitution §1 and §10 limits accepted as binding on this pack.

Mode selection: **Comprehensive** (preferred). Expert/Auto not used.

---

## 2. Independent test plan

The proposed change is process-order and gate-strength, not a scoring-rule change:

> Remove or make optional the requirement that a frozen known-case Fixture Gate must PASS before R-A/R-B production builders run (allow production-first; fixtures optional/post-hoc).

Validator tests are therefore about **what each control actually detected**, **whether those detections are substitutable**, and **whether optional/post-hoc fixtures preserve construct lock**.

### 2.1 Questions this pass must answer from frozen evidence only

1. Do the predeclared hard mechanical facts in the SPEC match the EVIDENCE tables/reports?
2. Did the Fixture Gate detect the Chicago production clock-skew (104-row disagree)?
3. Did exact recon detect that defect, and after which repair?
4. Is F03→STANDARD a construct-boundary sign-off that lives in fixtures rather than in production recon?
5. If Fixture Gate is optional/post-hoc, what common-mode failure would recon miss?
6. Does the pack show any rewriting of fixtures after a fail to match code (locked regression)?
7. Is P1 checkable without asking Builder what it meant?
8. Are required raw artifacts (hashes, stdout, manifests, fixture source files) present or absent?

### 2.2 Planned checks (executed as desk review; no live rerun)

| ID | Check | Method | Gate it informs |
|----|--------|--------|-----------------|
| T1 | Count fixture IDs and pass bits on R-A and R-B tables | Row audit of supplied CSVs | Hard mechanical facts; §7.5 |
| T2 | Confirm F03 expected=observed=STANDARD on both paths; record dormant_h, peer_p75_h, implied κ·p75 | Arithmetic on supplied rows | Construct lock / P1 fail clause |
| T3 | Cross-walk R-A vs R-B fixture *inputs* (not only labels) | Field-by-field compare | Semantic protection §5; silent drift |
| T4 | Record first-production disagree count and post-fix disagree count | EXACT_RECON narrative | P1 clock-skew clause |
| T5 | Record stated fixture clock source (in-process vs CSV parse path) | SPEC critical facts + EXACT_RECON cause | Coverage equality |
| T6 | Ask whether any production row is identified as an F03 analogue | Search EXACT_RECON / STRUCTURAL | Substitutability of recon for F03 |
| T7 | Inventory expected-unchanged surfaces claimed vs evidenced | SPEC “Expected unchanged” vs pack | Scope creep |
| T8 | Inventory missing constitutionally required raw artifacts | §2 Frozen inputs, §3 Evidence | Completeness (Adjudicator later) |
| T9 | Test P1 as written, conjuncts separately | Benefit predicate §6 | P1 assessment |
| T10 | Test regression rule: fixture rewrite after fail | Presence/absence in pack | §7.7 / SPEC Regression |

No live SQL/R execution was possible. Absence of a rerun is recorded under Missing evidence, not treated as a silent pass.

---

## 3. Hard mechanical facts

Facts below are read off the supplied pack. They are **Validator-observed**, not Builder-asserted. Agreement with Builder is deferred (Builder pack unseen).

### 3.1 Fixture label results (as tabulated)

| Path | IDs executed | Pass bits | F03 |
|------|--------------|-----------|-----|
| R-A | F01–F14 (14 rows) | 14/14 TRUE | expected STANDARD, observed STANDARD |
| R-B | SYN-F01–SYN-F13 + SYN-F14A\|SYN-F14B mapped to F01–F14 | 14/14 TRUE | expected STANDARD, observed STANDARD |

F14 is a two-grain case (FIX-F14A / FIX-F14B or SYN-F14A\|SYN-F14B) with both labels STANDARD. Both tables mark the combined fixture PASS.

This matches the SPEC critical fact: “Fixture results: R-A 14/14, R-B 14/14, F03STANDARD”.

### 3.2 F03 construct arithmetic (from both tables)

- dormant_h = 2400
- peer_p75_h = 2160
- κ stated on R-B row = 2
- κ · peer_p75_h = 2 × 2160 = **4320**
- 2400 < 4320 → clause `S_dormant_lt_kappa_p75` / `within_type_dormancy` → **STANDARD**
- STRUCTURAL text: “F03 STANDARD at =2 locked”

F03 is therefore a **known-case lock that STANDARD remains STANDARD when dormancy is large in absolute hours but still below κ·p75**. It is not a near-threshold production row.

### 3.3 Exact recon

From EXACT_RECON:

- Decision set after repair: **222,002** rows, identical SR_NUMBER sets
- Post-fix disagree: **0**
- Post-fix agree: **222,002 / 222,002**
- Portfolio κ=2 identical: ESCALATE 131,968 · INCONCLUSIVE 6,377 · STANDARD 83,657
- First production run: **104** disagrees, all STANDARD (R-A) vs ESCALATE (R-B)
- Systematic dormant_h offset ~**5.0 hours** (America/Chicago)
- All 104 sat within 5h of the κ×p75 threshold
- Cause attributed to naive SQL wall clocks tagged UTC by readr; R-B POSIXct shortcut vs R-A `force_tz`
- Locked repair rule stated: always character → parse as `America/Chicago` wall
- Fix files named: `R-A/run_RA.R`; `R-B/R/10_io_parse.R`

This matches SPEC: “Production first recon: 104 disagrees; post-fix: 0”.

### 3.4 Fixture clock source

SPEC critical fact: “Fixtures use in-process clocks (did not catch CSV tz bug).”

EXACT_RECON and STRUCTURAL corroborate: the 104-row defect was an **I/O parse / tz tagging** defect on production CSV columns, not a mis-implementation of the dormant≥κ·p75 predicate on already-parsed instants. Fixture tables carry pre-baked `dormant_h` / `peer_p75_h` numbers; they do not exercise `readr` POSIXct or TSV clock columns.

### 3.5 Dual-path / unchanged surfaces (claimed, not independently hashed)

Pack *claims*:

- Chicago frozen pack unchanged
- κ / T_freeze locked
- SQL nonjudgment (Source Gate checks absence of label columns; peer aggregates only)
- Dual-path retained (A01 REVERT already kept)
- design_version `stage3-v1-tcd-ig`
- fixture_version `fixtures-v1-tcd-ig`

No SHA-256 of baseline framework, Chicago pack, fixture suite, or builder trees is in this pack. Those claims are **narrative**, not mechanically verified here.

### 3.6 Structural review status (as written)

STRUCTURAL verdict: **PASS** after repair, ~2026-09-19 14:00 CT. Independence attestation: separate trees, no shared judged helpers, first judged outputs compared only at recon. Residual: parent-SR clause vocabulary differs (`I05_parent_sr_present` vs design “orphan”); production labels still matched.

---

## 4. Fixture / recon notes

### 4.1 What fixtures covered

Label-level known cases on both paths:

- ESCALATE: F01, F11 (dormant ≥ κ·p75)
- STANDARD: F02, F03, F10, F14 pair
- INCONCLUSIVE: F04, F05, F06, F09, F13 (integrity / clocks / thin peer / parent / unparseable)
- OUT_OF_SET: F07, F08, F12

F03 is the explicit large-dormancy-still-STANDARD construct lock.

### 4.2 What fixtures did **not** cover

The production clock-skew. In-process / synthetic clocks skip:

- CSV/TSV column types
- readr POSIXct UTC tagging of naive ISO wall strings
- asymmetric `force_tz` vs instant-preserving parse
- America/Chicago offset on `created_ts` / `mod_ts`

That is a **coverage hole in the fixture harness relative to production I/O**, not a proof that fixtures are redundant for construct lock.

### 4.3 R-A vs R-B fixture *input* discrepancies (labels still match)

Both paths report the same expected/observed **labels**. The baked numeric and clause fields are **not identical**:

| ID | Field | R-A | R-B | Same? |
|----|--------|-----|-----|-------|
| F04 | dormant_h | 120 | 240 | NO |
| F04 | clause | open_with_closed_date | I01_open_closed_date | vocab only |
| F05 | dormant_h | 240 | (empty) | NO |
| F05 | clause | inverted_clocks | I02_bad_clocks | related, not string-equal |
| F06 | dormant_h | 480 | 720 | NO |
| F06 | peer_p75_h | 240 | 96 | NO |
| F06 | peer_n | (absent) | 8 | R-B only |
| F09 | dormant_h | 480 | 360 | NO |
| F09 | clause | orphan_parent_nonblank | I05_parent_sr_present | vocab |
| F12 | dormant_h | 48 | 120 | NO |
| F13 | dormant_h | 120 | (empty) | NO |

F01, F02, F03, F07, F08, F10, F11 label-and-magnitude fields align.

Interpretation for this ablation (not a KEEP/REVERT call):

- Label agreement on independently constructed fixtures is consistent with dual-path design.
- Input-parameter disagreement means the two tables are **not a single frozen fixture vector**. If Fixture Gate is defined as “execute the frozen known-case suite,” it is unclear which numeric vector is the frozen suite.
- STRUCTURAL already treats clause-string vocabulary as audit text, not a recon-critical field. Numeric dormant_h / p75 drift is a different class: it can hide that paths are not executing the same known case.
- This is a **fixture-identity** observation. It does not by itself prove the proposed process change safe or unsafe, but it weakens any claim that “the Fixture Gate” is a single mechanical object.

### 4.4 Recon vs fixtures: different oracles

```
Fixture Gate  = known-case oracle against DESIGN (expected labels frozen before code)
Exact recon   = agreement oracle of PATH A vs PATH B on PRODUCTION rows
```

These are not interchangeable:

- Recon **did** catch a path-asymmetric I/O bug (104 near-threshold flips).
- Recon **cannot** catch a common-mode construct error (both paths implement the same wrong threshold or the same wrong F03 rule). After repair, recon is 0 disagrees; that is agreement, not design-correctness.
- Fixtures **did** lock F03→STANDARD on both paths.
- Fixtures **did not** catch the I/O bug.

Production-first + recon-only is therefore a different detection profile from Fixture-Gate-then-builders. P1 asserts the profiles are equal. The pack shows they are **complementary**, not equal.

### 4.5 Order of events as narrated (timestamps incomplete)

- First production recon: 104 disagrees (time not given)
- Repair of parse helpers
- Exact recon PASS at 2026-09-19 13:46 CT (0 disagrees)
- Structural PASS ~14:00 CT
- Fixture tables presented as 14/14 on both paths; **no timestamp of fixture freeze vs first production run**
- STRUCTURAL “Next”: Validation Gate freeze, then Stage 5; “Do not start Stage 5 until Validation Gate PASS + R Workflow Gate PASS”

The pack describes a run that **already executed production-first recon**, found the tz bug, repaired, then froze. That is historical sequence, not a controlled ablation of “mandatory pre-builder Fixture Gate ON vs OFF.”

### 4.6 Regression rule surface

SPEC Regression: “Must not authorize rewriting fixtures after fail to match code.”

No fixture-rewrite diff is supplied. Both tables show PASS with expected=observed. There is no evidence in this pack that anyone changed F03 (or any other expected) after a fail. There is also no evidence that the proposed optional/post-hoc rule includes a mechanical prohibition stronger than the sentence in the SPEC.

Making fixtures post-hoc **increases the opportunity** for rewrite-to-match-code even if this particular run did not do it.

---

## 5. P1 assessment

### 5.1 Predicate restated as checkable conjuncts

P1 (SPEC):

> Removing mandatory pre-builder Fixture Gate reduces steps while detection coverage remains equal: Chicago’s production clock-skew defect (104-row disagree) and construct boundaries (F03→STANDARD) would still have been caught by exact recon / other controls alone, with no increase in shipped wrong labels.

Benefit **fails** if:

- Fixture Gate was necessary for construct sign-off (e.g. F03), **or**
- optional fixtures would have allowed greenwash / silent design drift.

Checkable conjuncts:

| Conjunct | What would satisfy it | Pack finding |
|----------|------------------------|--------------|
| P1.A Steps reduced | Pre-builder Fixture Gate is a real extra step that can be removed without dropping another required gate | **Not mechanically shown.** No step inventory, no gate DAG, no timing of Fixture Gate as a blocking job. Narrative only. |
| P1.B Coverage equal for clock-skew | Same defect still detected by recon / other controls | **Supported for this defect.** Fixtures did not catch it; recon did. Optional fixtures would not have removed the recon signal that found the 104 rows. |
| P1.C Coverage equal for F03 construct | F03 (or equivalent) still caught by recon / other controls *alone* | **Not supported.** No production row is identified as an F03 analogue. F03 numbers (2400 / 2160) are synthetic. Recon compares path labels, not labels-to-design. STRUCTURAL itself treats F03 STANDARD at κ=2 as a **locked fixture fact**. |
| P1.D No increase in shipped wrong labels | Production-first + optional fixtures would not have shipped the 104 or a wrong construct | **Partially supported for the 104; unsupported for construct.** The 104 were caught by recon *before* the pack’s freeze language. A common-mode wrong construct would have reconcilled 222,002/222,002 and looked shippable if fixtures were optional or rewritten post-hoc. |
| P1.E Fail clause — Fixture Gate necessary for F03 sign-off | Evidence that F03 lock lives in fixtures | **This fail clause is triggered by the pack.** F03 is a fixture-native construct lock. |
| P1.F Fail clause — greenwash / silent drift | Optional/post-hoc fixtures enable matching code after the fact or skipping known-case review | **Risk is live in the proposed change text itself** (“fixtures optional/post-hoc”). Pack does not show that this run greenwashed. Pack also does not show a remaining mechanical lock that would forbid post-hoc expected-label edits if the gate is no longer mandatory. R-A/R-B fixture input drift is a mild existing drift signal. |

### 5.2 Clock-skew arm (P1.B) — detailed

The 104-row event is the cleanest fact in the pack:

- Asymmetric parse → dormant_h off by ~5h
- Only rows within 5h of κ·p75 flipped
- Peer n / p75 / κ matched; clocks did not
- Fixtures used in-process clocks → green while production was wrong
- Exact recon on full decision set caught it
- Repair + rerun → 0 disagrees

Conclusion on this arm: **mandatory pre-builder Fixture Gate was not the detector of this defect.** Production-first recon was. Removing a *pre-builder* fixture *requirement* would not, on this evidence, have hidden the 104-row event **provided exact recon remains mandatory and blocking**.

Caveats on this arm:

- Recon is path-vs-path. If both paths had shared the same readr POSIXct mistake, recon would have been 0 disagrees and **104 would have been 0**. STRUCTURAL independence attestation says distinct I/O construction; that independence, not fixtures, is what made the bug visible.
- A01 already kept dual-path. P1 “other controls alone” therefore leans on dual-path + recon, which are declared expected-unchanged. That is coherent **only if** those controls stay mandatory. The proposed change must not be read as weakening recon.
- “Shipped wrong labels”: pack says first run disagreed, then fix, then PASS. It does not exhibit a shipped production snapshot of the 104. So “no increase in shipped wrong labels” for this defect is historically true in this run, not a general proof.

### 5.3 Construct arm (P1.C / P1.E) — detailed

F03 is the SPEC’s own example of the fail clause.

Why recon does not substitute:

1. F03 is not claimed to exist in the 222,002-row Chicago decision set. No SR_NUMBER, no “production row with dormant_h=2400 and p75=2160,” no nearest-neighbor list.
2. Even if some production rows have dormant << κ·p75 at large absolute hours, recon only says R-A label == R-B label. It does not say the label matches the frozen design.
3. Common-mode misspecification of the inequality (`>` vs `>=`), of κ, or of “within_type_dormancy vs escalate-if-old” would pass recon and fail F03. The fixture exists precisely because that class is not visible in A-vs-B agreement.
4. STRUCTURAL §10.6 “Boundary errors … F03 STANDARD at =2 locked” treats the fixture as the lock, not recon.

Therefore: **Fixture Gate (or some other known-case-vs-design oracle) is necessary for F03 construct sign-off.** Exact recon is not that oracle.

P1’s phrase “would still have been caught by exact recon / other controls alone” bundles two different defects under one “alone.” The pack splits them. The construct half of P1 is not established.

### 5.4 Greenwash / silent drift arm (P1.F)

Proposed change language: “allow production-first; fixtures optional/post-hoc.”

Risks that follow from that wording, independent of Builder intent:

- Optional = production can freeze with fixtures unrun.
- Post-hoc = expected labels or fixture inputs can be aligned to whatever production already emitted.
- SPEC Regression forbids rewrite-after-fail, but the change under test is exactly the process that makes rewrite easier to perform unnoticed.
- R-A vs R-B numeric fixture drift already shows two “14/14 PASS” tables that are not the same vector. Optional suites make that divergence cheaper.

The pack does **not** contain a demonstrated greenwash event. Under Constitution §6 / §8, absence of demonstrated greenwash is not the same as P1 being satisfied. P1 requires equal coverage *and* no increase in shipped wrong labels *and* not hitting the stated fail clauses.

### 5.5 Step-reduction arm (P1.A)

No frozen artifact lists:

- current ordered stages with Fixture Gate as a blocking predecessor of builders
- candidate ordered stages after A02
- wall-clock or review-step counts
- whether fixtures still run later as a Validation Gate item (STRUCTURAL still requires Validation Gate before Stage 5)

If fixtures remain mandatory later (Validation Gate) and only the *pre-builder* slot is removed, step reduction may be real and small. If “optional/post-hoc” means they can be skipped entirely, step reduction is real and coverage is not equal. The SPEC text includes both “optional” and “post-hoc,” which is the stronger (coverage-reducing) reading.

### 5.6 P1 verdict for this pack (non-terminal)

P1 is **not established** on the frozen evidence as written.

- Clock-skew half is empirically supported **conditional on dual-path exact recon remaining mandatory**.
- Construct half (F03) is not supported; the SPEC’s own fail clause is activated.
- Equal-coverage claim is false if taken as “fixtures and recon detect the same set.” They detected **disjoint** defect classes in this run.
- Step reduction is unmeasured.
- Greenwash is a live process risk of the proposed change, not a demonstrated incident.

This is a P1 assessment, not a KEEP/REVERT/HALT.

---

## 6. Blocking objections

Objections below are **supported enough by this pack to remain live for the Adjudicator**. They are not a Validator terminal call.

**BO-1 — P1 construct clause fails on F03.**  
Evidence: F03 is a synthetic known-case; recon has no F03 production analogue; STRUCTURAL cites F03 as locked fixture fact. Removing a mandatory known-case gate removes the only control in the pack that signs off that boundary against design.

**BO-2 — “Coverage remains equal” is contradicted by the pack’s own complementary-control story.**  
Fixtures missed tz/I/O; recon missed (would miss) common-mode construct error. Equality is not shown.

**BO-3 — Proposed change text authorizes the exact process the regression rule exists to prevent.**  
“Optional/post-hoc fixtures” plus “must not rewrite fixtures after fail” are in tension. No mechanical remaining lock (hash-pinned expected file + fail-closed gate) is exhibited that would survive making the gate optional.

**BO-4 — Fixture suite identity is not a single frozen vector.**  
R-A and R-B tables disagree on dormant_h / p75 / clause strings for F04, F05, F06, F09, F12, F13. A Fixture Gate that “must PASS” is ill-defined if two PASSes are not the same cases. This matters more if the gate becomes optional/post-hoc rather than if a single frozen suite is hash-pinned before builders.

**BO-5 — This run is not a controlled ON-vs-OFF ablation of the gate.**  
The narrative is: production-first happened, bug found by recon, parse fixed, fixtures 14/14, recon 0. That does not isolate “what would have shipped if Fixture Gate had been optional.” It also does not show that a mandatory *pre-builder* Fixture Gate caused extra cost that can be removed. Historical coincidence ≠ predicate satisfaction.

**BO-6 — Frozen-input / raw-evidence holes (constitutional, not semantic).**  
See §7. These do not prove the *change* is wrong; they limit how far any later KEEP could go. Listed as objections because Constitution §2 and §3 treat missing frozen inputs / raw artifacts as HALT-class for the experiment, which the Adjudicator must weigh. Validator does not issue HALT.

Non-objections (explicitly dropped):

- Dual-path itself: declared expected-unchanged; A01 REVERT already kept; not in scope to reopen.
- SQL nonjudgment: STRUCTURAL checklist PASS; no contrary raw SQL in pack, but also no contradiction.
- Post-fix recon 0 and identical portfolios: accepted as stated.
- F03 arithmetic 2400 < 4320 → STANDARD: internally consistent on both tables.

---

## 7. Missing evidence

Required by Constitution §2–§3 and by a checkable P1, but **absent from this pack and from the workspace**:

1. `BASELINE_FRAMEWORK.sha256` and any candidate-framework SHA (SPEC points at it; file not supplied).
2. SHA-256 of frozen fixture suite source (not the printed result tables).
3. SHA-256 of Chicago frozen pack, T_freeze artifact, κ lock file.
4. File manifests for R-A / R-B trees and declared changed-file set for A02 (A02 is a process-gate change; if no code change, that fact still needs a manifest saying so).
5. Raw stdout/stderr of fixture runners (R-A `run_RA.R` fixture branch; R-B `R/40_fixtures.R`).
6. Raw exact-recon tool output for the 104-row run **and** the 0-row run (only a markdown summary is present). The 104 SR_NUMBERs themselves are not listed.
7. Fixture source definitions (JSON/CSV/R objects) that would explain R-A vs R-B input drift.
8. Timestamped proof that fixtures were frozen **before** first production builder run — or proof they were not. P1 is about that order.
9. Gate DAG / stage checklist showing Fixture Gate as a mandatory predecessor of builders in the baseline constitution of the *framework* (distinct from this Ablation Constitution).
10. Any production row that instantiates F03 (needed if P1 claims recon would have caught F03).
11. Hash-pinned “expected” column that would remain immutable if fixtures become post-hoc.
12. Builder pack (correctly unseen here; Adjudicator will need both packs).
13. Diff of `parse_ts_chicago` / `rb_parse_ts` vs baseline (repair is described, not exhibited).
14. Source Gate SQL output proving absence of label columns (claimed, not attached).

Under Constitution §3: “If a required raw artifact is unavailable, return HALT.” That rule is for the experiment’s terminal posture. This Validator pack **records the absences** and does not issue the token.

Also missing but not constitutionally listed: measurement of “reduces steps” (P1.A).

---

## 8. Summary (no terminal decision)

**Role / mode.** Validator only; Comprehensive; blind to Builder; no KEEP / REVERT / HALT.

**Mechanics as stated.** R-A 14/14, R-B 14/14, F03→STANDARD on both; first production recon 104 disagrees (STANDARD vs ESCALATE, ~5h Chicago offset, near κ·p75); post-fix recon 0/222,002 with identical κ=2 portfolios. Fixtures used in-process clocks and did not see the CSV tz bug. Those facts are internally consistent with the SPEC’s “critical mechanical facts” *as narratives*. They are not hash-backed.

**Controls are complementary, not substitutes.**  
- Exact recon caught an asymmetric I/O/tz bug that fixtures missed.  
- Fixtures locked a design construct (F03 STANDARD at large dormant_h still below κ·p75) that recon cannot lock unless that case exists in production **and** one path implements it differently.

**P1.** Not established. Clock-skew detection-by-recon is supported; construct detection-by-recon-alone is not; the SPEC’s own fail example (F03 sign-off) is exactly the unsupported arm; “coverage remains equal” overclaims; step reduction is unmeasured; optional/post-hoc fixtures reopen rewrite-to-match-code even though this run does not exhibit a rewrite.

**Live objections for Adjudicator:** BO-1 through BO-6 above, especially F03 substitutability and missing frozen hashes/raw runs.

**Expected-unchanged surfaces.** Claimed (Chicago pack, κ/T_freeze, SQL nonjudgment, dual-path). Not independently hashed in this pack.

**What this pass is not.** It is not an adjudication. It does not prefer production-first as policy. It does not deny that a *later* mandatory Validation Gate could still run fixtures; it only notes that the change under test is removal/optionality of the **pre-builder** Fixture Gate, and that P1 as written is broader than “move the same gate later.”

---

*End of Independent First Pass. No terminal token.*
