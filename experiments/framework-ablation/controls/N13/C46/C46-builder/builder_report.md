## 1. Role attestation and ablation ID.

I am acting **only as Builder** for **C46 — Addendum 02, candidate #46, “Design-time numerical determinism.”** I am making an independent first pass and am blind to the Validator’s first-pass output. I am not issuing a terminal disposition. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.  [source: C46_1_BUILDER_ChatGPT]

C46 targets **Stage 3 design / Stage 4 reconciliation**. Its proposed control is to declare four numerical-determinism items at design time: solver tolerance, canonical design-matrix column order, exact tie semantics, and rounding-derived reconciliation rules. The frozen Chicago 311 pack is read-only; the iterative model itself is seeded because the pack contains no iterative fit.  [source: C46_1_BUILDER_ChatGPT]

The coordinator’s disclosed **N1 / OF-1** is outside the C46 numerical path: three clean R-A/R-B rows have exactly 1.000 h feature differences while their classifications agree, but C46 consumes the frozen R-B classifications/features and does not rerun either clean path. Therefore N1 contributes to none of the C46 reported numbers.  [source: C46_1_BUILDER_ChatGPT]

---

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C46 removes **undeclared numerical degrees of freedom** rather than removing a workflow stage or analytical safeguard. The baseline permits two legitimate implementations to use different design-matrix column orders and the ordinary solver threshold, while still demanding exact equality on derived rounded values and binary flags. The proposed declaration instead fixes the numerical implementation choices before Stage 4 reconciliation.

| Surface | Baseline regime | Declared regime | Ambiguity removed |
| --- | --- | --- | --- |
| Solver tolerance | `1e-7` | `1e-12` | Solver stopping tolerance |
| Design-matrix order | R-A `natural`; R-B `reversed` | both `canonical` | Column-order dependence |
| Tie semantics | Seed computes flag as `p >= 0.5` | explicitly declared `p >= 0.5` | Equality-at-threshold ambiguity |
| Probability reconciliation | `abs(dp) <= 0.05` | `abs(dp) <= 1e-6` | Numerical agreement standard |
| `p_pct1` reconciliation | exact | difference up to `0.1` allowed only when `abs(dp) <= 1e-6` | Legitimate rounding-straddle handling |
| Flag reconciliation | exact | exact | unchanged exact decision requirement |

The **SEED DIFFS consist entirely of new runner-side C46 files**; they do not edit the frozen Chicago 311 analytical code.

**`seeds/C46/fit_path.R` — new, 4,407 bytes.** It reads only `R-B/outputs/RB_classifications.csv` and `data/source/src_open_candidates.csv`; joins on `SR_NUMBER`; defines `y = as.integer(classification == "ESCALATE")`; converts the required numeric features; removes incomplete rows; and sorts by `SR_NUMBER`. It constructs five continuous/base features plus day-of-week one-hots, top-eight `ORIGIN` indicators plus `origin_other`, and top-ten `OWNER_DEPARTMENT` indicators plus `dept_other`. The resulting clean design has **32 columns**, arithmetically `5 + 7 + 9 + 11 = 32`.

Column order is selected exactly by:

`natural = names(X)`  
`reversed = rev(names(X))`  
`canonical = sort(names(X), method = "radix")`

The defect injection is also exact: when `DROP != "-"`, the named feature is removed before the matrix is ordered. The seeded real defect is R-B dropping `x_log_peer_p75`, taking that path from 32 to 31 columns.

The fit itself is a binomial `glmnet` with `alpha = 1`, `standardize = FALSE`, a fixed 30-value path

`exp(seq(log(0.02), log(2e-4), length.out = 30))`

and prediction at the final/smallest lambda. The requested threshold `TH` is passed through `control = list(thresh = TH, maxit = 1e5)` when supported, otherwise through the older arguments.

Outputs are defined exactly as:

`p = sprintf("%.17g", pv)`  
`p_pct1 = sprintf("%.1f", round(100 * pv, 1))`  
`flag = as.integer(pv >= 0.5)`

Thus the tie rule is concretely encoded in every seeded fit path.

**`seeds/C46/recon_c46.R` — new, 1,774 bytes.** It requires identical `SR_NUMBER` ordering across paths, calculates `dp = abs(x$p - y$p)` and `dpp = abs(x$p_pct1 - y$p_pct1)`, and sets the probability tolerance to `0.05` for baseline or `1e-6` for declared.

The baseline rounded-field failure is:

`dpp > 1e-9`

The declared rounded-field failure is:

`dpp > 1e-9 & !(dp <= 1e-6 & dpp <= 0.1 + 1e-9)`

Flag failure remains:

`x$flag != y$flag`

One comparator field containing at least one failing row produces one reconciliation event, implemented exactly as the sum of three Boolean `any(...)` terms for `p`, `p_pct1`, and `flag`.

**`seeds/C46/ARMS.tsv` — new, 871 bytes.** It defines six paired-path reporting arms: BASE, DECL, THRESH_ONLY, ORDER_ONLY, DEFECT_DECL, and DEFECT_BASE. **`seeds/C46/DETFIT` — new, 82 bytes** defines the additional single-path REF as canonical order with `thresh=1e-14`. These exact seed definitions implement the frozen arm structure.  [source: C46_1_BUILDER_ChatGPT]

---

## 3. Hard mechanical facts table.

The generic Builder instruction mentions identities such as `n_agree + n_disagree = n_inner` and portfolio deltas. **C46 contains no `n_agree`, `n_disagree`, `n_inner`, or portfolio-result evidence table**, so no values for those examples can legitimately be manufactured. The applicable C46 analogues are row-count identities, failed-field D-sets, reconciliation-event identities, rebuild deltas, feature-count deltas, and cross-arm hash equalities.

Let

**D(arm) = {reconciliation fields having at least one failing row}.**

Then by the frozen seed code, `events = |D(arm)|`.

| Hard fact | Value | Status | Independent arithmetic / cross-check |
| --- | --- | --- | --- |
| Paired reporting arms | 6 | **Recomputed** | BASE, DECL, THRESH_ONLY, ORDER_ONLY, DEFECT_DECL, DEFECT_BASE |
| Reference arms | 1 | **Recomputed** | REF |
| Fit executions | 13 | **Recomputed** | `6 × 2 + 1 = 13` |
| Reconciliation executions | 6 | **Recomputed** | one for each paired arm |
| Total logged execution steps | 19 | **Recomputed** | `13 + 6 = 19` |
| Successful process exits | 19 | **Recomputed** | every fit/recon exit record has exit code 0 |
| Timeouts | 0 | **Recomputed** | every exit record has timeout flag 0 |
| Fit `jerr != 0` count | 0 of 13 | **Recomputed** | all fit-info `jerr` values are 0 |
| Common analysis `n` | 215,687 | **Quoted**, cross-checked | appears in every fit and every RECON row |
| Clean feature columns | 32 | **Recomputed** | `5 + 7 + 9 + 11 = 32`, agrees with clean fit-info rows |
| Defective R-B feature columns | 31 | **Recomputed** | `32 − 1 = 31` after dropping `x_log_peer_p75` |
| BASE `max_abs_dp` | 0.008446989841342178 | **Quoted** | raw BASE RECON |
| BASE probability tolerance | 0.05 | **Quoted** | raw BASE RECON |
| BASE margin below probability tolerance | 0.041553010158657824 | **Recomputed** | `0.05 − 0.008446989841342178` |
| BASE `fail_p` | 0 | **Quoted**, mechanically consistent | maximum probability gap is below 0.05 |
| BASE `fail_p_pct1` | 17,564 | **Quoted** | raw BASE RECON |
| BASE `fail_flag` | 11 | **Quoted** | raw BASE RECON |
| BASE D-set | `{p_pct1, flag}` | **Recomputed** | exactly the two failure counts are nonzero |
| BASE events | 2 | **Recomputed** | ` |
| BASE extra rebuilds | 2 | **Quoted** | C46 arms result |
| DECL `max_abs_dp`, paired paths | 0 | **Quoted** | raw DECL RECON |
| DECL failures | `0, 0, 0` | **Quoted** | `fail_p`, `fail_p_pct1`, `fail_flag` |
| DECL D-set | `∅` | **Recomputed** | no failing comparator field |
| DECL events | 0 | **Recomputed** | ` |
| DECL extra rebuilds | 0 | **Quoted** | C46 arms result |
| BASE→DECL reconciliation-event delta | −2 | **Recomputed** | `0 − 2 = −2` |
| BASE→DECL extra-rebuild delta | −2 | **Recomputed** | `0 − 2 = −2` |
| THRESH_ONLY `max_abs_dp` | 9.44668978275498e-6 | **Quoted** | raw THRESH_ONLY RECON |
| THRESH_ONLY `fail_p_pct1` | 30 | **Quoted** | raw THRESH_ONLY RECON |
| THRESH_ONLY D-set | `{p_pct1}` | **Recomputed** | only rounded field has failures |
| THRESH_ONLY events | 1 | **Recomputed** | D-set cardinality 1 |
| ORDER_ONLY `max_abs_dp` | 0 | **Quoted** | raw ORDER_ONLY RECON |
| ORDER_ONLY D-set | `∅` | **Recomputed** | all three failure counts are zero |
| ORDER_ONLY events | 0 | **Recomputed** | D-set cardinality 0 |
| THRESH_ONLY event reduction vs BASE | −1 | **Recomputed** | `1 − 2 = −1` |
| ORDER_ONLY event reduction vs BASE | −2 | **Recomputed** | `0 − 2 = −2` |
| DEFECT_DECL `max_abs_dp` | 0.766791177978111 | **Quoted** | raw DEFECT_DECL RECON |
| DEFECT_DECL failed rows: `p` | 193,060 | **Quoted** | raw RECON |
| DEFECT_DECL failed rows: `p_pct1` | 111,789 | **Quoted** | raw RECON |
| DEFECT_DECL failed rows: `flag` | 2,070 | **Quoted** | raw RECON |
| DEFECT_DECL D-set | `{p, p_pct1, flag}` | **Recomputed** | all three counts are nonzero |
| DEFECT_DECL events | 3 | **Recomputed** | D-set cardinality 3 |
| DEFECT_BASE `max_abs_dp` | 0.7656221672416856 | **Quoted** | raw DEFECT_BASE RECON |
| DEFECT_BASE failed rows: `p` | 12,890 | **Quoted** | raw RECON |
| DEFECT_BASE failed rows: `p_pct1` | 111,885 | **Quoted** | raw RECON |
| DEFECT_BASE failed rows: `flag` | 2,082 | **Quoted** | raw RECON |
| DEFECT_BASE D-set | `{p, p_pct1, flag}` | **Recomputed** | all three counts are nonzero |
| DEFECT_BASE events | 3 | **Recomputed** | D-set cardinality 3 |
| Total reconciliation events over six paired arms | 9 | **Recomputed** | `2+0+1+0+3+3 = 9` |
| Total extra rebuilds over six paired arms | 9 | **Recomputed** | same armwise sequence `2+0+1+0+3+3` |
| Arms where `events = extra_rebuilds` | 6 of 6 | **Recomputed** | equality holds arm by arm |
| BASE rows with exactly equal `p` | 50 | **Recomputed** | `215,687 − 215,637 = 50` |
| THRESH_ONLY rows with exactly equal `p` | 1,689 | **Recomputed** | `215,687 − 213,998 = 1,689` |
| DECL rows with exactly equal `p` | 215,687 | **Recomputed** | `215,687 − 0` |
| ORDER_ONLY rows with exactly equal `p` | 215,687 | **Recomputed** | `215,687 − 0` |
| DEFECT_DECL rows with exactly equal `p` | 0 | **Recomputed** | `215,687 − 215,687` |
| DEFECT_BASE rows with exactly equal `p` | 0 | **Recomputed** | same identity |
| DECL-vs-REF `max_abs_dp` | 5.33069e-05 | **Quoted** | separate evaluator comparison |
| DECL-vs-REF flag differences | 0 | **Quoted** | separate evaluator comparison |
| DECL-vs-REF tolerance multiple | 53.3069× | **Recomputed** | `5.33069e-05 / 1e-6` |
| DECL-vs-REF excess over limit | 5.23069e-05 | **Recomputed** | `5.33069e-05 − 1e-6` |
| P1 clauses satisfied | 4 of 5 | **Recomputed** | clauses 1,2,3,5 true; clause 4 false |

The raw arm table supporting the central reconciliation counts reports BASE `2` events, DECL `0`, THRESH_ONLY `1`, ORDER_ONLY `0`, and both defect arms `3`.  [source: C46_1_BUILDER_ChatGPT]

### Hash equalities across arms

The manifests add stronger byte-level checks.

| Hash equality | Result | Status |
| --- | --- | --- |
| `fit_path.R` in all seven arm roots | same SHA-256 `d681aff9…147f238` | **Recomputed from manifest equality** |
| `recon_c46.R` in all seven arm roots | same SHA-256 `9cd9fe12…150867` | **Recomputed from manifest equality** |
| DECL RA `pred.csv` = DECL RB `pred.csv` | both `fd47d91e…f43e50` | **Recomputed from hashes** |
| ORDER_ONLY RA `pred.csv` = ORDER_ONLY RB `pred.csv` | both `ff4b93fe…3e281f` | **Recomputed from hashes** |
| BASE RA `pred.csv` = DEFECT_BASE RA `pred.csv` | both `c641eada…5854ea` | **Recomputed from hashes** |
| DECL RA `pred.csv` = DEFECT_DECL RA `pred.csv` | both `fd47d91e…f43e50` | **Recomputed from hashes** |
| DECL RA = DECL RB = DEFECT_DECL RA | one common prediction hash | **Recomputed from hashes** |
| Empty stderr files | 19, all SHA-256 `e3b0c442…b855` | **Recomputed from manifests** |

The BASE/DEFECT_BASE RA equality and DECL/DEFECT_DECL RA equality are expected from the seed design because the seeded defect is applied **only to R-B**.

The frozen operational reference hashes also cross-check: the two fit inputs and all six explicitly listed C46 runner files in the SPEC match the gating preflight values, i.e. **8 of 8 listed operational hashes agree**. The preflight itself reports `PASS`.  [source: C46_1_BUILDER_ChatGPT]

---

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 is conjunctive: all five conditions must hold.  [source: C46_1_BUILDER_ChatGPT]

| P1 condition | Mechanical evidence | Assessment |
| --- | --- | --- |
| 1. BASE has at least one reconciliation event | BASE events = **2** | **Met** |
| 2. DECL has zero reconciliation events | DECL events = **0** | **Met** |
| 3. DEFECT_DECL reconciliation fails on the seeded real defect | DEFECT_DECL has **3** events; `fail_p=193,060`, `fail_p_pct1=111,789`, `fail_flag=2,070` | **Met** |
| 4. DECL R-A vs REF has `max|Δp| <= 1e-6` and identical flags | flags differ on **0** rows, but `max|Δp| = 5.33069e-05` | **Not met** |
| 5. Extra rebuilds: BASE ≥1 and DECL=0 | BASE **2**, DECL **0** | **Met** |

Thus **4 of the 5 frozen P1 conditions are met, while condition 4 is not**. Because P1 requires all five, the mechanical predicate as a conjunction is **not satisfied**.

The condition-4 failure is numerical, not a flag disagreement: the flags are identical, but `5.33069e-05` is **53.3069 times** the allowed `1e-6`, exceeding it by `5.23069e-05`. The evaluator reports this separately from DECL’s internal R-A/R-B reconciliation.  [source: C46_1_BUILDER_ChatGPT]

That distinction matters:

- **DECL R-A vs DECL R-B:** `max_abs_dp = 0`.
- **DECL R-A vs tighter REF:** `max_abs_dp = 5.33069e-05`.

There is therefore no contradiction between DECL achieving byte-identical paired outputs and condition 4 failing against the tighter convergence reference.

The disclosed cost limitation remains: actual Stage 3 design-chat minutes were not measured because doing so would require a design chat. The only operationalized cost-side measure is the rebuild count. That limitation cannot be converted into a measured design-time saving.

---

## 5. Fixture and reconciliation implications.

The frozen specification states in advance that the **seeded fit has no fixture harness and therefore no mandatory seeded-fit fixture applies**. The original Chicago 311 fixture artifacts remain frozen and are hash-verified during preflight, but C46 does not rerun the clean R-A/R-B analytical pipelines. This distinction is important: C46 supplies reconciliation evidence for its seeded numerical fit, not new behavioral-fixture execution for that fit.  [source: C46_1_BUILDER_ChatGPT]

The reconciliation evidence has four direct implications.

First, **the baseline produces reconciliation work even though its primary probability tolerance itself never fails**. BASE has `max_abs_dp = 0.008446989841342178`, comfortably below its `0.05` probability tolerance, so `fail_p=0`; nevertheless 17,564 rounded-field mismatches and 11 flag mismatches create two field-level events. This demonstrates the particular baseline inconsistency C46 was designed to expose: a comparatively broad probability tolerance coexists with exact reconciliation of outputs derived from those probabilities.

Second, **DECL eliminates the paired-path discrepancy completely on this seed**. Its two prediction files are byte-identical, all three failure counts are zero, its D-set is empty, and no rebuild event is generated. That is stronger than merely falling within the declared `1e-6` comparator.

Third, **the real defect remains mechanically visible under the declared comparator**. Dropping `x_log_peer_p75` from R-B changes the R-B feature count from 32 to 31 and produces failures in all three comparator fields. The declared numerical tolerance therefore does not absorb the seeded implementation defect.

Fourth, the two attribution probes isolate the observed paired-path effect:

| Probe | Result | Implication within this seed |
| --- | --- | --- |
| THRESH_ONLY: `1e-12`, natural vs reversed | 30 rounded-field failures; 1 event | tighter solver threshold alone does **not** remove the order-dependent reconciliation event |
| ORDER_ONLY: canonical/canonical, `1e-7` | zero differences; 0 events | canonical column ordering alone is sufficient to make the two paired paths identical at the baseline solver threshold |

Accordingly, for the seeded Chicago 311 fit, **column-order canonicalization is the component directly associated with eliminating the clean paired-path mismatch**. Tightening the solver threshold greatly reduces the numerical gap—from `0.008446989841342178` to `9.44668978275498e-6`, a reduction of about **99.888%**—but does not by itself eliminate every exact rounded-field mismatch.

At the same time, the tighter solver setting is independently implicated by the REF check: the declared `1e-12` solution remains farther than the frozen `1e-6` reference-distance criterion from the `1e-14` solve. Therefore the internal reconciliation result and the convergence-reference result answer different questions.

---

## 6. Semantic/regression risks and unchanged surfaces.

**Unchanged surfaces.** The frozen Chicago 311 source pack remains read-only. The preflight re-verifies the source, R-A/R-B scripts and outputs, fixture results, portfolio-count outputs, κ-grid output, SQL source/extract checks, and C46 runner seeds before execution. C46 does not alter the baseline framework documents, does not rerun the clean R-A/R-B classifications, does not pull new data, and does not alter N1 / OF-1. The same `fit_path.R` and `recon_c46.R` bytes are used in every C46 arm.

**Execution integrity.** All 13 fits have `jerr=0`; all 19 logged fit/reconciliation processes exit with code 0; no timeout occurs; the manifests contain the expected outputs; and every recorded stderr file is empty. There is therefore no execution-error explanation for condition 4.

**Reference-convergence risk.** Internal paired-path determinism is not the same as convergence to the tighter reference. DECL’s two paths are identical, but that identical result remains `5.33069e-05` away from REF at the largest row-level difference. The declared solver threshold of `1e-12` therefore does not meet the frozen `1e-6` proximity requirement against the `1e-14` reference on this seed.

**Component-attribution limitation.** C46 bundles four design declarations, but not every component receives an independently contrastive arm. THRESH_ONLY and ORDER_ONLY isolate solver threshold and order. By contrast, `flag = p >= 0.5` is encoded identically by `fit_path.R` in all seeded arms, so no alternative tie convention is tested. The evidence therefore demonstrates the behavior of the declared tie rule but does not independently estimate the effect of replacing a competing tie rule.

**Rounding-rule coverage limitation.** DECL itself has `n_p_pct1_diff=0`. Consequently, its special allowance for a one-decimal rounding straddle when `dp <= 1e-6` is present in the code but is not exercised by a clean DECL straddle case. The defect arm also has `n_p_pct1_diff = fail_p_pct1 = 111,789`, so none of those differences are rescued by the rounding exception. The rule is mechanically implemented, but this execution does not provide a positive fixture-like example in which the exception accepts a real half-step straddle.

**Seed external-validity limitation.** The Chicago 311 frozen pack contains no iterative model, so the glmnet fit is deliberately seeded for C46. Results establish behavior for this frozen seeded construction—215,687 rows, 32 clean columns, glmnet 5.1, the specified lambda path, and the tested machine/runtime. They do not by themselves establish identical numerical behavior for other solvers, model classes, BLAS implementations, operating systems, or hardware.

**Design-time cost limitation.** The stated Stage 3 minute-cost comparison is unmeasured. Only rebuild counts are available. BASE has two extra rebuild triggers and DECL zero, but those counts cannot be converted into actual design-time minutes from this packet.

**Pre-execution exercise.** The packet discloses that the seed scripts were exercised before the specification was frozen, including natural/reversed checks at `1e-7` and `1e-12`. It also states that after that check no arm parameter, threshold, or rule was changed. The final THRESH_ONLY maximum difference of `9.44668978275498e-6` is consistent with the disclosed preliminary approximation of `9.4e-6`.  [source: C46_1_BUILDER_ChatGPT]

**N1 / OF-1 remains orthogonal.** The three known one-hour clean-pair feature differences concern the underlying frozen R-A/R-B pack. C46 reads the frozen R-B classification path as its label/features source and never compares those original clean A/B hourly values. There is no mechanical route by which the three rows enter the C46 arm-difference counts as an A/B clock discrepancy.

---

## 7. Claim → evidence map.

| Claim | Evidence section and exact row/artifact |
| --- | --- |
| C46 is the design-time numerical-determinism control and ChatGPT is Builder | **SPEC header**, Ablation ID / Roles / Target stage rows, lines 25–34.  [source: C46_1_BUILDER_ChatGPT] |
| Four declarations are solver tolerance, canonical order, tie semantics, and rounding-derived reconciliation | **SPEC → Control under test**, line 37; **Exact change being tested**, lines 42–46.  [source: C46_1_BUILDER_ChatGPT] |
| Seeded model has 215,687 rows and 32 clean columns | **SPEC → Exact change being tested**, row describing seeded glmnet; **C46 RESULTS → Fit info**, all clean arm rows 409–418 |
| BASE has two events | **C46 RESULTS → Arms → BASE row**, line 396; **RAW PER-ARM FILES → BASE/RECON.csv**, line 448 |
| BASE failures are 0 probability, 17,564 rounded, 11 flag | **RAW PER-ARM FILES → BASE/RECON.csv**, line 448 |
| DECL has zero paired-path differences and zero events | **C46 RESULTS → Arms → DECL row**, line 397; **RAW PER-ARM FILES → DECL/RECON.csv**, line 472 |
| THRESH_ONLY leaves 30 rounded-field failures | **C46 RESULTS → Arms → THRESH_ONLY row**, line 398; **RAW → THRESH_ONLY/RECON.csv**, line 578 |
| ORDER_ONLY produces zero differences | **C46 RESULTS → Arms → ORDER_ONLY row**, line 399; **RAW → ORDER_ONLY/RECON.csv**, line 544 |
| Seeded defect is omission of `x_log_peer_p75` on R-B | **SPEC → Arms → DEFECT_DECL/DEFECT_BASE definitions**, lines 51–55; **Fit info → DEFECT_DECL RB**, line 419 |
| DEFECT_DECL produces failures in all three fields | **C46 RESULTS → Arms → DEFECT_DECL row**, line 400; **RAW → DEFECT_DECL/RECON.csv**, line 520 |
| DEFECT_DECL R-B has 31 rather than 32 columns | **C46 RESULTS → Fit info**, DEFECT_DECL RA/RB rows 418–419 |
| DECL-vs-REF has `max | dp |
| Frozen condition-4 threshold is `1e-6` plus identical flags | **SPEC → Operational benefit predicate P1**, condition 4, line 62.  [source: C46_1_BUILDER_ChatGPT] |
| Four P1 clauses are met and condition 4 is not | **C46 RESULTS → Predicate conditions**, rows 387–391.  [source: C46_1_BUILDER_ChatGPT] |
| Seeded fit has no mandatory fixture harness | **SPEC → Regression rules**, condition-5 sentence, line 69 |
| Original frozen pack is hash-gated before execution | **PREFLIGHT**, frozen/seed hash rows and final gating result, lines 271–297.  [source: C46_1_BUILDER_ChatGPT] |
| Same fit/reconciliation code is used across arm roots | **ARM MANIFESTS**, each arm input row for `fit_path.R` and `recon_c46.R`, lines 599–708 |
| DECL RA/RB predictions are byte-identical | **ARM MANIFESTS → DECL outputs**, RA and RB `pred.csv` share SHA-256 `fd47d91e…f43e50` |
| ORDER_ONLY RA/RB predictions are byte-identical | **ARM MANIFESTS → ORDER_ONLY outputs**, RA and RB `pred.csv` share SHA-256 `ff4b93fe…3e281f` |
| The seed explicitly implements `flag = p >= 0.5` | **SEED DIFFS → `fit_path.R`**, output-construction statement |
| Declared rounding exception is `dp <= 1e-6` and `dpp <= 0.1 + 1e-9` | **SEED DIFFS → `recon_c46.R`**, declared `f_pct` expression |
| N1 / OF-1 is known, not seeded, and does not enter C46 numbers | **Coordinator Note N1 / OF-1**, lines 18–20; **SPEC → Known open finding**, lines 48–49.  [source: C46_1_BUILDER_ChatGPT] |
| Actual Stage 3 design-time minutes are not measured | **SPEC → P1 disclosed limitation**, line 65 |
| No arm rule was changed after the disclosed scratch check | **SPEC → Pre-execution check**, lines 88–90.  [source: C46_1_BUILDER_ChatGPT] |

END C46 BUILDER REPORT
