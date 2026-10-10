# C48 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for **C48 — Addendum 02, candidate #48, “No second final audit after verified revisions.”** This is an independent first pass. I have not seen the Validator’s first-pass output and make no terminal disposition. The frozen core role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The separately frozen AI2/AI3 second-audit conversations are evidence for this ablation, not my Builder output.

The control under test is whether the standing Stage-5 rule requiring another AI2/AI3 audit after interpretation revisions can be replaced, when specified conditions hold, by a mechanical revision checklist that checks exact replacement/deletion and numerical-token preservation.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The **baseline process** is: Stage-5 interpretation is revised, then AI2 and AI3 independently audit the revised interpretation again against the evidence. The **C48 variant** removes those second audit chats from the operational path and substitutes `rev_check.R`, which mechanically verifies every predeclared revision. The frozen second audits are retained here only to measure whether that substitution loses detection coverage.

The seeded files implement that comparison exactly:

| Seeded artifact | Exact change/function |
| --- | --- |
| `AI1_ORIGINAL.md` | Frozen copy of the original Stage-5 AI1 interpretation; no revision applied. |
| `REVISIONS.json` | Six required revisions, V-1 through V-6: five substantive and one presentational. V-1 changes capacity return from “Plausible” to “Required”; V-2 eliminates row-level piloting in favor of WCA2/SED/SKA type-level monitoring; V-3 adds WCA2 concentration with `64,922` and `49.2%`; V-4 narrows reconciliation wording to **label disagreements** and discloses that lineage SHA values are not inline; V-5 makes the capacity Framing return part of the recommendation; V-6 deletes the chat-interface artifact. |
| `REVISED_CLEAN.md` | Applies all six requested changes. The unified diff shows the V-4 reconciliation qualification, V-3 WCA2 sentence, V-1/V-2 option changes, V-5 recommendation change, and V-6 deletion. |
| `REVISED_SEED.md` | Differs from CLEAN by exactly the planted V-3 numerical mis-application: `49.2%` is replaced by `42.9%`; count `64,922` and surrounding text remain unchanged. |
| `rev_check.R` | Reads original/revised/revision JSON; normalizes CRLF; performs fixed-string occurrence counts; extracts numerical tokens; requires each nonempty replacement exactly once; requires each superseded target to be absent unless contained inside its replacement; computes the expected numeric multiset as `original − target numbers + replacement numbers`; compares it with the revised-text numeric multiset; writes `CHECK.csv` and `NUMDIFF.csv`; returns `FLAG` if any text condition fails or any numerical count differs. |
| `ARMS.tsv` | Declares CLEAN as all six revisions correctly applied and SEED as the V-3 `42.9%` mis-application. |
| `REVCHK` | Declares the C48 revision-checklist runner-v5 arm set. |

Thus, the ablation does **not** alter the Stage-3/4 analytical implementation, frozen dataset, classification logic, evidence calculations, or original Stage-5 interpretation. It changes the **post-revision verification mechanism**.

## 3. Hard mechanical facts table.

| ID | Hard fact | Recalculation / check | Result | Status |
| --- | --- | --- | --- | --- |
| HF-01 | κ=2 portfolio total | `131,968 + 6,377 + 83,657` | **222,002** | **Recomputed** from portfolio rows. |
| HF-02 | ESCALATE share | `131,968 / 222,002 × 100` | **59.4445% → 59.4%** | **Recomputed**; agrees with quoted 59.4%. |
| HF-03 | INCONCLUSIVE share | `6,377 / 222,002 × 100` | **2.8725% → 2.9%** | **Recomputed**; agrees with quoted 2.9%. |
| HF-04 | STANDARD share | `83,657 / 222,002 × 100` | **37.6830% → 37.7%** | **Recomputed**; agrees with quoted 37.7%. |
| HF-05 | Rounded portfolio shares | `59.4 + 2.9 + 37.7` | **100.0%** | **Recomputed**. |
| HF-06 | WCA2 share of ESCALATE | `64,922 / 131,968 × 100` | **49.195259% = 49.1953% → 49.2%** | **Recomputed**; matches requested V-3 and both second audits. |
| HF-07 | Seeded WCA2 percentage error | `42.9% − 49.2%` | **−6.3 percentage points** | **Recomputed**. The seed understates the requested rounded share by 6.3 pp. |
| HF-08 | κ 1.0→1.5 ESCALATE delta | `140,340 − 152,292` | **−11,952** | **Recomputed** from sensitivity table. |
| HF-09 | κ 1.5→2.0 ESCALATE delta | `131,968 − 140,340` | **−8,372** | **Recomputed**. |
| HF-10 | κ 2.0→3.0 ESCALATE delta | `118,246 − 131,968` | **−13,722** | **Recomputed**. |
| HF-11 | κ 1.0→3.0 ESCALATE delta | `118,246 − 152,292` | **−34,046** | **Recomputed**. |
| HF-12 | Revision count | V-1…V-6 | **6 = 5 substantive + 1 presentational** | **Recomputed** from `REVISIONS.json` and CHECK rows. |
| HF-13 | CLEAN flagged-revision D-set | Six CLEAN rows have `flag=FALSE` | **D_revision(CLEAN)=∅; cardinality 0** | **Recomputed**. |
| HF-14 | SEED flagged-revision D-set | Only V-3 has `flag=TRUE` | **D_revision(SEED)={V-3}; cardinality 1** | **Recomputed**. |
| HF-15 | CLEAN numerical D-set | `NUMDIFF.csv` has no data rows | **D_num(CLEAN)=∅; cardinality 0** | **Recomputed**. |
| HF-16 | SEED numerical D-set | Rows are `42.9: expected 0, found 1`; `49.2: expected 1, found 0` | **D_num(SEED)={42.9,49.2}; cardinality 2** | **Recomputed**. |
| HF-17 | Net differing numeric-token count | Unexpected count `+1`; missing count `−1` | **Net token count 0, but multiset inequality on two values** | **Recomputed**; demonstrates why simple count equality would be insufficient. |
| HF-18 | CLEAN outcome | Arm row and raw result | **exit 0; PASS; no flagged revision; no unexplained number** | **Quoted and cross-checked** between summary and raw evidence. |
| HF-19 | SEED outcome | Arm row and raw result | **exit 0; FLAG; V-3; two numerical differences** | **Quoted and cross-checked**. |
| HF-20 | Checklist execution time | `4.9 + 4.8` | **9.7 s total** | **Recomputed** from raw run records. CLEAN is **0.1 s** slower than SEED. |
| HF-21 | Cross-arm original hash equality | CLEAN and SEED `AI1_ORIGINAL.md` hashes | **equal:** `73f448…d7932` | **Recomputed by direct string equality** from manifests. |
| HF-22 | Cross-arm checker hash equality | CLEAN and SEED `rev_check.R` hashes | **equal:** `6cc4ea…97156` | **Recomputed by direct string equality**. |
| HF-23 | Cross-arm revision-contract hash equality | CLEAN and SEED `REVISIONS.json` hashes | **equal:** `970bac…ce0b4` | **Recomputed by direct string equality**. |
| HF-24 | Revised-arm file equality | Both revised files are **8,215 bytes**, but SHA-256 differs: CLEAN `d92e…278c`, SEED `c1ac…0b63` | **same bytes-length, unequal content hash** | **Recomputed/quoted** from manifests; consistent with the one-number planted text change. |
| HF-25 | stderr equality across arms | Both stderr files are zero bytes and SHA-256 `e3b0c442…b855` | **equal, empty stderr** | **Recomputed by direct string equality**. |
| HF-26 | Audit packet freeze equality | AI2 packet SHA in spec freeze vs `AUDIT_FREEZE`: `9b21…68e1e`; AI3: `dab6…eb96` | **both pairs equal** | **Recomputed by direct string equality**. |
| HF-27 | Frozen second-audit payload size | `4,078 + 3,053` | **7,131 bytes** | **Recomputed** from `AUDIT_FREEZE.json`. |
| HF-28 | AI2 scored findings | Findings table contains one finding | **1 MATERIAL finding, V-3 only** | **Recomputed/quoted**; “none otherwise.” |
| HF-29 | AI3 scored findings | Findings table contains one finding | **1 BLOCKING finding, V-3 only** | **Recomputed/quoted**. |
| HF-30 | Unflagged high-severity findings across both second audits | AI2 high-severity set `{V-3}`; AI3 high-severity set `{V-3}`; checklist set `{V-3}` | **set difference = ∅** | **Recomputed** under the frozen P1 scoring rule. |
| HF-31 | Audit completeness | AI2 and AI3 replies both terminate with their required END lines | **2/2 complete** | **Quoted/recomputed**. |
| HF-32 | Constitution hashes across batch controls | C41, C47, C53, C48 all list `e6c3…dae9` | **4/4 identical** | **Recomputed by hash comparison**. |
| HF-33 | `n_agree + n_disagree = n_inner` identity | No `n_agree`, `n_disagree`, or `n_inner` table is supplied for C48 | **Not applicable / not recomputable from this packet** | **Source-limited fact; no values invented.** |
| HF-34 | Second-audit wall-clock saving | Spec says the two audit chats’ wall-clock time is to be reported from capture times | **Not recomputable from supplied audit freeze**, which provides freeze time, bytes and hashes but not both audit start/end durations | **Source-limited fact.** |

The pre-existing OF-1 clock issue remains exactly three ESCALATE rows with a 1.000-hour R-A/R-B clock difference and matching labels. The SPEC explicitly states that C48 reruns no R path and that these values do not enter any C48 number.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate contains three conjunctive conditions. Condition 1 requires the SEED checklist to flag V-3; condition 2 requires CLEAN to pass without a false flag; condition 3 requires that neither second auditor identify a BLOCKING/MATERIAL V-1…V-6 or NEW finding that the checklist failed to flag. The frozen rule explicitly states that a V-3 audit finding counts as already flagged by the checklist.

**Condition 1:** met mechanically. The SEED arm exited 0, returned `FLAG`, and its sole flagged revision was V-3. Its numerical diff was precisely one unexpected `42.9` and one missing `49.2`.

**Condition 2:** met mechanically. CLEAN exited 0, returned `PASS`, had zero flagged revisions and an empty `NUMDIFF.csv`.

**Condition 3:** the frozen audits show no qualifying issue outside the checklist’s V-3 flag. AI2 reports exactly one MATERIAL finding and relates it to V-3; it explicitly says there are no other findings. AI3 reports exactly one BLOCKING finding and also relates it to V-3. Both quote the same `42.9%` sentence and prescribe `49.2%`.

Setwise, the checklist’s scored detection set is `{V-3}`; the union of second-audit BLOCKING/MATERIAL revision/NEW finding targets is also `{V-3}`. Therefore the frozen-audit set minus the checklist set is **∅**. There is no evidence in either frozen audit of a qualifying V-1, V-2, V-4, V-5, V-6, or NEW issue missed by the checklist.

The runner originally marked condition 3 `PENDING` because the runner itself did not interpret the frozen chat replies. The supplied frozen replies resolve the factual question that was pending in that mechanical output.

## 5. Fixture and reconciliation implications.

C48 has **no separate fixture harness**. The SPEC explicitly declares its known-answer cases to be the CLEAN and SEED arms: CLEAN must pass exact revision verification, and SEED must detect the planted V-3 defect. Both behaved as declared.

The underlying frozen Stage-4 evidence quoted by the Stage-5 interpretation says **14/14 fixtures passed in both paths** and reports **222,002 rows**. C48 does not rerun those R paths, so those are inherited frozen evidence rather than fresh C48 computations.

V-4 is important for the meaning of reconciliation: the revision deliberately changes the broader phrase “0 disagreements across 222,002 rows” to **“0 label disagreements across 222,002 rows”** and adds that the SHA-256 lineage values live in `LINEAGE_ATTESTATION.md`, rather than implying that every possible field was reconciled in this Stage-5 text.

OF-1 therefore remains an acknowledged frozen Stage-4 issue rather than a C48 regression: three clock values differ by 1.000 hour during repeated fall-back hours, their labels agree, the Stage-5 evidence predates those clock-value findings, and C48 never executes or modifies either R path.

## 6. Semantic/regression risks and unchanged surfaces.

The central semantic limitation of the mechanical variant is its **scope**. `rev_check.R` can establish that specified replacement text was inserted exactly as instructed, that superseded text disappeared under its rule, and that the resulting numerical-token multiset equals the mathematically expected multiset. It does **not independently establish that the revision request itself is semantically correct, that an unchanged sentence is substantively justified, or that a newly introduced semantic problem preserving the required strings and number multiset is impossible**. That limitation follows directly from what the checker computes.

Within this particular frozen test, however, the second audits did not expose an additional such semantic regression. AI2 states that V-1, V-2, V-4, V-5 and V-6 match the request and identifies no new recommendation, causal claim, capacity claim, or rival. AI3 likewise accepts those five revisions exactly and raises only V-3.

The audits differ in **severity label** for the same defect—AI2 calls V-3 MATERIAL; AI3 calls V-3 BLOCKING—but they agree on the affected revision, quoted text, arithmetic and correction. Under C48’s frozen condition-3 rule, both severities belong to the scored class, and both point to the checklist’s already-flagged V-3.

The cross-arm unchanged surfaces are mechanically strong. `AI1_ORIGINAL.md`, `rev_check.R`, and `REVISIONS.json` have identical SHA-256 hashes in CLEAN and SEED; both stderr artifacts are the identical zero-byte SHA-256 value; the revised files are the same byte length but have different hashes. The SEED DIFF identifies the substantive arm difference as the single `49.2% → 42.9%` change.

The broader frozen surfaces are also unchanged: baseline framework hashes, constitution, frozen Chicago data pack, R-A/R-B files and outputs, and Stage-3/4 locks are inputs rather than C48-modified code. This batch is R-only for the checklist and uses no MySQL or new data.

One generalization risk remains: C48 contains one deliberately simple revision defect—a wrong number in one specified replacement. The evidence demonstrates checklist coverage for that frozen case; it does not by itself demonstrate coverage for every possible semantic revision failure.

## 7. Claim → evidence map.

| Claim | Evidence location and table row |
| --- | --- |
| C48 tests removal of the post-revision second AI2/AI3 audit in favor of mechanical verification. | **SPEC → Control under test / Exact change being tested**, especially lines 38–48. |
| Six revisions are prescribed: five substantive and one presentational. | **SEED DIFFS →** `REVISIONS.json`**, V-1…V-6 rows**. |
| CLEAN contains the requested `49.2%`; SEED changes only that planted value to `42.9%`. | **SEED DIFFS →** `REVISED_CLEAN.md` **vs** `REVISED_SEED.md`**, V-3 diff row**. |
| Correct WCA2 share is 49.2%. | **REVISIONS.json → V-3 source row**, plus **AI2 Findings → F-1** and **AI3 Findings → F-1**; independently recomputed in HF-06. |
| Portfolio counts sum to 222,002 and published rounded shares are arithmetically consistent. | **AI1 original → Frozen portfolio assignment table, ESCALATE/INCONCLUSIVE/STANDARD rows**; recomputed in HF-01–HF-05. |
| CLEAN has no checklist or numeric difference. | **C48_RESULTS → Arms row CLEAN; CLEAN CHECK V-1…V-6; CLEAN NUMDIFF** and raw `CHECK_RESULT`. |
| SEED flags exactly V-3. | **C48_RESULTS → Arms row SEED; SEED CHECK row V-3** and raw `CHECK_RESULT`. |
| SEED numerical difference set is exactly `{42.9, 49.2}`. | **C48_RESULTS → SEED NUMDIFF rows 42.9 and 49.2**; raw NUMDIFF repeats the same rows. |
| The core checker inputs are hash-identical across CLEAN and SEED. | **ARM MANIFESTS → CLEAN/SEED input rows for** `AI1_ORIGINAL.md`**,** `rev_check.R`**,** `REVISIONS.json`. |
| The revised CLEAN and SEED files are each 8,215 bytes but have unequal hashes. | **ARM MANIFESTS →** `REVISED_CLEAN.md` **and** `REVISED_SEED.md` **rows**. |
| Both checklist runs exited 0. | **RAW PER-ARM FILES → CLEAN** `RUN_CHECK.exit` **and SEED** `RUN_CHECK.exit`. |
| Frozen audit packet hashes agree with the earlier spec-freeze packet hashes. | **Spec freeze rows AI2/AI3 packets** vs `AUDIT_FREEZE.json` **AI2/AI3 rows**. |
| AI2 raises one scored finding, MATERIAL V-3, and explicitly reports none otherwise. | **AI2 second audit → Findings row F-1 and following “none otherwise” statement**. |
| AI3 raises one scored finding, BLOCKING V-3. | **AI3 second audit → Findings row F-1**. |
| No scored second-audit finding lies outside the checklist’s `{V-3}` detection set. | **SPEC → P1 condition 3 scoring rule**, **SEED CHECK row V-3**, **AI2 F-1**, and **AI3 F-1**. |
| Both frozen second-audit replies are complete. | **AI2 final END row** and **AI3 final END row**. |
| C48 has no independent fixture harness; CLEAN and SEED are its declared known-answer cases. | **SPEC → Regression rules**, second bullet. |
| Stage-4 fixture/reconciliation evidence is inherited, not rerun by C48. | **AI1 original → Stage-4 validation chain** plus **SPEC → N1/OF-1 scope statement**. |
| OF-1 does not contribute to any C48 result. | **SPEC → Known open finding N1/OF-1**. |
| No `n_agree`, `n_disagree`, or `n_inner` values are supplied for C48. | No such evidence table exists in the supplied C48 packet; consequently no identity using those fields is asserted or fabricated. |
| Audit-chat time saving cannot be recomputed from this packet. | **SPEC → Exact change being tested** states the intended time measure; **AUDIT_FREEZE.json** supplies hashes/bytes/freeze timestamp but not separate wall-clock start/end intervals. |

END C48 BUILDER REPORT
