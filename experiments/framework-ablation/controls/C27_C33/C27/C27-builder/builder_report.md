## 1. Role attestation and ablation ID.

I am acting as **Builder only** for **C27, catalog #27 “Fixtures on Both Paths.”** This is an independent first pass, blind to the Validator. I am not acting as Validator or Adjudicator and provide no adjudication state. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; Constitution version 1.0; target stage is Stage 4.  [source: C27_1_BUILDER_ChatGPT]

The frozen baseline framework hashes are:

| Artifact | SHA-256 | Status |
| --- | --- | --- |
| `three-ai-measurement-design-framework.md` | `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c` | Quoted |
| `three-ai-validation-and-analysis-framework.md` | `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e` | Quoted |

The frozen data pack is Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.  [source: C27_1_BUILDER_ChatGPT]

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The baseline control requires **both R-A and R-B to pass all 14 locked fixtures before production is trusted**. C27 removes the R-B fixture result from the trust gate: R-A still must pass its fixtures, but R-B production is trusted when the run exits 0 and exact reconciliation against R-A has `n_only_ra = n_only_rb = n_disagree = 0`. Thus the ablation tests whether second-path fixtures supply detection that exact production reconciliation does not.  [source: C27_1_BUILDER_ChatGPT]

The nine seeded R-B mutations are exactly:

| Mutant | Exact seeded code change from `SEED_DIFFS` |
| --- | --- |
| M01 | `thresh <- kappa * peer_p75` → `thresh <- kappa * joined$peer_p50_h` |
| M02 | `p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))` → `p_closed_contra <- rep(FALSE, n)` |
| M03 | Removes `(!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts)` from `p_bad_clock`; missing-created, missing-modified, and future-created checks remain. |
| M04 | `p_thin <- peer_n < RB_N_MIN` → `p_thin <- rep(FALSE, n)` |
| M05 | `in_decision <- is_open & !dup_flag & !leg_flag` → `in_decision <- is_open & !leg_flag`, deleting the DUPLICATE exclusion. |
| M06 | `in_decision <- is_open & !dup_flag & !leg_flag` → `in_decision <- is_open & !dup_flag`, deleting the LEGACY_RECORD exclusion. |
| M07 | `p_parent <- parent_nonblank` → `p_parent <- rep(FALSE, n)` |
| M08 | `is_open <- tolower(status_norm) == "open"` → `is_open <- rep(TRUE, n)` |
| M09 | Removes `is.na(created_ts)` from `p_bad_clock`; missing-modified, mod-before-created, and future-created checks remain. |

These are the only changes represented by the frozen seed diffs.  [source: C27_1_BUILDER_ChatGPT]

## 3. Hard mechanical facts table.

Notation: **Q = quoted directly from the frozen evidence; R = independently recomputed from quoted values.**

### Clean arm and portfolio-level facts

| Fact | Result |
| --- | --- |
| `src_open_candidates.csv` frozen rows | 245,193 (Q) |
| MySQL COUNT for `src_open_candidates` | 245,193 (Q) |
| Source-row count delta | 0 (R: 245,193 − 245,193) |
| `src_peer_stats.csv` expected rows | 104 (Q) |
| MySQL COUNT for `src_peer_stats` | 104 (Q) |
| Peer-row count delta | 0 (R: 104 − 104) |
| Clean R-A exit | 0 (Q) |
| Clean R-B exit | 0 (Q) |
| Clean R-A fixtures | 14/14 (Q) |
| Clean R-B fixtures | 14/14 (Q) |
| Clean R-A reproduction: `n_x`, `n_truth` | 222,002 / 222,002 (Q) |
| Clean R-A reproduction row delta | 0 (R) |
| Clean R-B reproduction: `n_x`, `n_truth` | 222,002 / 222,002 (Q) |
| Clean R-B reproduction row delta | 0 (R) |
| Clean R-A label/only-row/dormant/open-age differences | all 0 (Q) |
| Clean R-B label/only-row/dormant/open-age differences | all 0 (Q) |
| Clean recon `n_ra` | 222,002 (Q) |
| Clean recon `n_rb` | 222,002 (Q) |
| Clean recon `n_inner` | 222,002 (Q) |
| Clean `n_only_ra`, `n_only_rb` | 0 / 0 (Q) |
| Clean `n_agree`, `n_disagree` | 222,002 / 0 (Q) |
| Identity `n_agree + n_disagree = n_inner` | 222,002 + 0 = 222,002 (R) |
| Identity `n_inner + n_only_ra = n_ra` | 222,002 + 0 = 222,002 (R) |
| Identity `n_inner + n_only_rb = n_rb` | 222,002 + 0 = 222,002 (R) |
| Mutant runs present | 9/9 (Q) |
| Mutant runs with exit 0 | 9/9 (R from all nine rows) |
| Mutant fixture passes summed | 118/126 (R) |
| Mutant fixture failures summed | 8 (R: 126 − 118) |
| Production changed-row events summed across mutant runs | 46,536 (R) |
| Reconciliation disagreements summed across mutant runs | 23,350 (R) |
| `only_rb` rows summed across mutant runs | 23,186 (R) |
| `only_ra` rows summed across mutant runs | 0 (R) |
| Recon anomaly events | 46,536 (R: 23,350 + 23,186 + 0) |
| Changed-row events − recon anomaly events | 0 (R) |

Clean reproduction and reconciliation values come directly from the runner output.  [source: C27_1_BUILDER_ChatGPT]

### Per-mutant recomputation

For every mutant, `n_inner` is independently recoverable as `recon_n_rb − recon_only_rb`; since `recon_only_ra = 0` throughout, implied R-A cardinality is also 222,002. `n_agree` is recomputed as `n_inner − recon_disagree`.

| Mutant | Exit | Fixtures | Failed count | `n_rb` | `only_ra` | `only_rb` | `disagree` | `n_inner` | `n_agree` | Δ `n_rb` vs clean | Production rows changed |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| M01 | 0 Q | 12/14 Q | 2 R | 222,002 Q | 0 Q | 0 Q | 16,973 Q | 222,002 R | 205,029 R | 0 R | 16,973 Q |
| M02 | 0 Q | 13/14 Q | 1 R | 222,002 Q | 0 Q | 0 Q | 0 Q | 222,002 R | 222,002 R | 0 R | 0 Q |
| M03 | 0 Q | 14/14 Q | 0 R | 222,002 Q | 0 Q | 0 Q | 0 Q | 222,002 R | 222,002 R | 0 R | 0 Q |
| M04 | 0 Q | 13/14 Q | 1 R | 222,002 Q | 0 Q | 0 Q | 6,377 Q | 222,002 R | 215,625 R | 0 R | 6,377 Q |
| M05 | 0 Q | 13/14 Q | 1 R | 245,014 Q | 0 Q | 23,012 Q | 0 Q | 222,002 R | 222,002 R | +23,012 R | 23,012 Q |
| M06 | 0 Q | 13/14 Q | 1 R | 222,176 Q | 0 Q | 174 Q | 0 Q | 222,002 R | 222,002 R | +174 R | 174 Q |
| M07 | 0 Q | 13/14 Q | 1 R | 222,002 Q | 0 Q | 0 Q | 0 Q | 222,002 R | 222,002 R | 0 R | 0 Q |
| M08 | 0 Q | 13/14 Q | 1 R | 222,002 Q | 0 Q | 0 Q | 0 Q | 222,002 R | 222,002 R | 0 R | 0 Q |
| M09 | 0 Q | 14/14 Q | 0 R | 222,002 Q | 0 Q | 0 Q | 0 Q | 222,002 R | 222,002 R | 0 R | 0 Q |

The underlying mutant rows are frozen in the runner table.  [source: C27_1_BUILDER_ChatGPT]

The row-level equalities also recompute exactly: M01 has 16,973 changed production rows and 16,973 disagreements; M04 has 6,377 and 6,377; M05 has 23,012 changed rows and 23,012 `only_rb`; M06 has 174 and 174. M02, M03, M07, M08, and M09 each have zero production-row changes and zero reconciliation anomalies.

### Detection sets and portfolio deltas

From the frozen definitions, because every mutant exits 0:

`D_fix = {mutants with R-B fixtures <14/14}`

= **{M01, M02, M04, M05, M06, M07, M08} (R)**.

`D_abl = {mutants with only-row/disagreement recon anomaly}`

= **{M01, M04, M05, M06} (R)**.

Therefore:

| Derived portfolio fact | Result |
| --- | --- |
| ` | D_fix |
| ` | D_abl |
| `D_fix ∩ D_abl` | {M01,M04,M05,M06} (R) |
| `D_fix \ D_abl` | {M02,M07,M08} (R) |
| ` | D_fix \ D_abl |
| `D_abl \ D_fix` | ∅ (R) |
| Caught by neither | {M03,M09} (R) |
| Baseline detection rate over nine seeds | 7/9 = 77.78% (R) |
| Ablated detection rate over nine seeds | 4/9 = 44.44% (R) |
| Detection-rate delta | −3/9 = −33.33 percentage points (R) |
| Baseline-detected defects retained by ablated regime | 4/7 = 57.14% (R) |
| Baseline-detected defects lost | 3/7 = 42.86% (R) |

These independently reproduce H4–H7 in the runner summary.  [source: C27_1_BUILDER_ChatGPT]

### Hash equalities across arms

The clean B R-A classification hash is `c099e092...d63ae0d9`, identical to the frozen preflight R-A classification hash; the clean B R-B classification hash is `a0e42b86...fe6fe193`, identical to the frozen preflight R-B hash. Both equalities are recomputed by literal hash comparison.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT]

| R-B arm | Output hash relation to clean B | Status |
| --- | --- | --- |
| M01 | unequal | R |
| M02 | equal | R |
| M03 | equal | R |
| M04 | unequal | R |
| M05 | unequal | R |
| M06 | unequal | R |
| M07 | equal | R |
| M08 | equal | R |
| M09 | equal | R |

Thus **5/9 mutant R-B outputs are byte-identical to clean R-B and 4/9 differ (R)**. The equality set is `{M02,M03,M07,M08,M09}`; the inequality set is `{M01,M04,M05,M06}`. That partition exactly matches `prod_rows_changed_vs_clean_RB = 0` versus `>0`.  [source: C27_1_BUILDER_ChatGPT]

The manifest also shows the same `src_open_candidates.csv` hash `ba089f...d81b9` and the same `10_io_parse.R` hash `40e67d...2154a` for B and all nine mutant arms: **10/10 shown arms equal for each of those two artifacts (R)**. Each mutant instead has its own seeded `20_integrity_and_classify.R` hash.  [source: C27_1_BUILDER_ChatGPT]

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate defines P1 as satisfied exactly when `D_fix ⊆ D_abl`; it defines P1 as failed when `D_fix \ D_abl` is non-empty.  [source: C27_1_BUILDER_ChatGPT]

The independently recomputed sets are:

`D_fix = {M01,M02,M04,M05,M06,M07,M08}`

`D_abl = {M01,M04,M05,M06}`

`D_fix \ D_abl = {M02,M07,M08}`

The difference contains **3 mutants**, so `D_fix ⊄ D_abl`. Accordingly, the frozen **P1-failed condition is met**. M02, M07, and M08 are defects detected by R-B's fixtures but not by the ablated regime's production reconciliation. M03 and M09 are caught by neither regime and, per the frozen definition, do not count for or against P1.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT]

## 5. Fixture and reconciliation implications.

The evidence separates the nine mutants into three mechanically distinct groups.

**M01, M04, M05, and M06 are detectable by both mechanisms.** M01 and M04 preserve the production key set but generate 16,973 and 6,377 classification disagreements respectively. M05 and M06 generate 23,012 and 174 R-B-only rows respectively. Their own R-B fixture runs also fail. Thus exact production reconciliation independently exposes these four defects.  [source: C27_1_BUILDER_ChatGPT]

**M02, M07, and M08 are detectable by fixtures but invisible to production reconciliation on the frozen pack.** Each exits 0, fails exactly one R-B fixture—F04, F09, and F12 respectively—and nevertheless has `only_ra=0`, `only_rb=0`, `disagree=0`, and `prod_rows_changed_vs_clean_RB=0`. Their R-B classification files are additionally byte-identical to clean R-B. These are direct examples in which behavioral fixture execution detects a seeded semantic defect that exact reconciliation on the observed production population does not.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT]

**M03 and M09 are detected by neither mechanism.** Both run 14/14 R-B fixtures, have zero reconciliation anomalies, zero production rows changed, and produce the same R-B output hash as the clean arm. The run therefore demonstrates that the existing locked fixture suite itself does not expose these two seeded deletions on the supplied fixture cases. No stronger causal explanation for why they escape detection is established by the packet.  [source: C27_1_BUILDER_ChatGPT]

Consequently, exact R-A/R-B production reconciliation and second-path behavioral fixtures are not mechanically interchangeable on this frozen experiment. Reconciliation detects realized differences on the frozen production population; the R-B fixture suite additionally exercises at least three seeded semantics that are dormant with respect to that population's final output.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk is **dormant-rule equivalence**: two implementations can reconcile exactly over the current production population while implementing different rules. M02, M07, and M08 establish this concretely because their production classifications are byte-identical to clean R-B while their targeted fixture cases fail. This is precisely the kind of semantic difference that schema equality or a clean production comparison alone cannot establish away. The Constitution separately states that schema equality alone does not prove semantic equality and requires deterministic diffing plus locked behavioral fixtures.  [source: C27_1_BUILDER_ChatGPT]

A second risk is **fixture incompleteness already present in the baseline suite**. M03 and M09 alter integrity logic but remain 14/14 and production-identical. The evidence establishes the detection gap, although it does not establish whether the appropriate remedy would be a stronger fixture, a different seed, or another control.

The frozen expected unchanged surfaces are the SQL/Source Gate, TCD-IG rules, fixture expecteds, R-A code, SR_NUMBER grain, and frozen Chicago 311 pack.  [source: C27_1_BUILDER_ChatGPT] The provided mechanical evidence supports important portions of that freeze: source hashes pass preflight; clean R-A/R-B reproduce 222,002 frozen classifications with zero label or only-row differences; the source file and R-B parsing module retain identical hashes across every shown arm; and the declared mutations are confined to R-B `20_integrity_and_classify.R`.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT]

No clean-arm production regression is exposed by the supplied evidence: clean fixtures are 14/14 on both paths, both processes exit 0, reproduction against the frozen labels is exact on the reported fields, and clean reconciliation is 0/0/0. All nine mutant runs are present with recorded exits. Builder/Validator hard-number agreement is not assessable in this independent Builder first pass because the Validator output is intentionally outside the Builder's information barrier.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT]

## 7. Claim → evidence map. Cite the section and the table row for each claim.

| Claim | Frozen evidence location |
| --- | --- |
| Clean B passed 14/14 fixtures on R-A and R-B and both exited 0. | `C27_RESULTS.md` §Mechanical facts, row H1; run log B rows.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| Clean B exactly reproduces the frozen 222,002-row classifications with zero reported label/only-row differences and clean recon 0/0/0. | `C27_RESULTS.md` §Clean arm repro rows “B R-A vs frozen…” and “B R-B vs frozen…”; §Clean arm recon row.  [source: C27_1_BUILDER_ChatGPT] |
| All nine mutant runs are present and exit 0. | `C27_RESULTS.md` §Mechanical facts H3 plus §Mutants rows M01–M09; run log M01–M09.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| `D_fix={M01,M02,M04,M05,M06,M07,M08}`. | `C27_RESULTS.md` §Mechanical facts H4; independently reproduced from §Mutants `rb_fixtures` rows M01–M09.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| `D_abl={M01,M04,M05,M06}`. | `C27_RESULTS.md` §Mechanical facts H5; independently reproduced from §Mutants reconciliation columns.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| `D_fix \ D_abl={M02,M07,M08}`, containing three second-path-fixture-only detections. | `C27_RESULTS.md` §Mechanical facts H6; §Mutants rows M02, M07, M08.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| M02, M07, and M08 each fail one fixture but have zero production changes and 0/0/0 recon. | `C27_RESULTS.md` §Mutants rows M02, M07, M08.  [source: C27_1_BUILDER_ChatGPT] |
| M02, M07, and M08 produce the same R-B output SHA-256 as clean B. | §ARM MANIFESTS rows B R-B output, M02 output, M07 output, M08 output.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| M03 and M09 are caught by neither regime. | `C27_RESULTS.md` §Mechanical facts H7 and §Mutants rows M03/M09.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| M01 and M04 are reconciliatory classification disagreements totaling 23,350 rows. | `C27_RESULTS.md` §Mutants rows M01/M04: 16,973 + 6,377 = 23,350 recomputed.  [source: C27_1_BUILDER_ChatGPT] |
| M05 and M06 add 23,186 R-B-only rows in aggregate. | `C27_RESULTS.md` §Mutants rows M05/M06: 23,012 + 174 = 23,186 recomputed.  [source: C27_1_BUILDER_ChatGPT] |
| Total changed-row events across the nine mutant runs are 46,536, exactly equal to total reconciliation anomaly events. | `C27_RESULTS.md` §Mutants rows M01–M09: 16,973 + 6,377 + 23,012 + 174 = 46,536; disagreements 23,350 + `only_rb` 23,186 = 46,536.  [source: C27_1_BUILDER_ChatGPT] |
| Frozen P1 requires `D_fix ⊆ D_abl`; its failure condition is non-empty `D_fix \ D_abl`. | SPEC §Operational benefit predicate P1, outcome definitions.  [source: C27_1_BUILDER_ChatGPT] |
| The P1-failed condition is met because the recomputed difference is `{M02,M07,M08}`. | SPEC §P1 outcome rule plus `C27_RESULTS.md` H4–H6.  [source: C27_1_BUILDER_ChatGPT]  [source: C27_1_BUILDER_ChatGPT] |
| Source and parsing inputs are hash-stable across the ten shown B/M01–M09 arms, while each mutant substitutes the seeded integrity/classification file. | §ARM MANIFESTS B and M01–M09 rows.  [source: C27_1_BUILDER_ChatGPT] |
| The nine described mutations correspond to the frozen seeded edits. | §SEED DIFFS, M01–M09 diff blocks.  [source: C27_1_BUILDER_ChatGPT] |

END C27 BUILDER REPORT
