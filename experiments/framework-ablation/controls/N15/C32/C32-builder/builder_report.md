# C32 Builder Report

## 1. Role attestation and ablation ID

I attest that I am acting **only as the Builder** for this independent first pass, blind to the Validator output. The ablation is **C32**, Remaining Ablation Program catalog #32, **“Freeze Before Stage 5,”** in N15 batch 3 of 3. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Constitution version is 1.0. The target is the **Stage 4→5 boundary**, where validated outputs are normally sealed before deeper analysis.

The frozen baseline framework hashes are `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c` for `three-ai-measurement-design-framework.md` and `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e` for `three-ai-validation-and-analysis-framework.md`. Those values recur identically in the separate baseline-framework-hash section.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS

The control normally freezes the validated outputs before deeper analysis and requires a pre-Stage-5 comparison between the actual Stage-5 inputs and the validation freeze. **C32 removes that seal check.** Stage 5 therefore reads whatever happens to occupy the validated-output paths at execution time. Stage 5’s own independent count checks remain intact. The seeded PRE edits occur after the validation freeze and before Stage 5.

| Seed | File changed | Exact seeded code operation |
| --- | --- | --- |
| **FB_KGRID** | `R-B/outputs/RB_kappa_grid_counts.csv` | Selects the unique `kappa == 3` row, then executes `g$n_ESCALATE[i] <- g$n_ESCALATE[i] + 1500L; g$n_STANDARD[i] <- g$n_STANDARD[i] - 1500L`. Thus 1,500 cases are shifted from STANDARD to ESCALATE at κ=3 while preserving their sum. |
| **FB_TF24** | `R-A/outputs/RA_classifications.csv` | Executes `ra$dormant_h <- ra$dormant_h + 24; ra$open_age_h <- ra$open_age_h + 24`. Classification labels are not edited. |
| **FB_CLAUSE** | `R-A/outputs/RA_classifications.csv` | Selects rows where `classification == "INCONCLUSIVE"` and `peer_n` is missing or `< 30`, asserts that at least one exists, then executes `ra$integrity_clause[i] <- "missing_or_sub30_peer"`. |
| **FB_ROUND** | `R-A/outputs/RA_classifications.csv` | Executes `ra$dormant_h <- round(ra$dormant_h)`. |
| **FB_RECLASS** | `R-A/outputs/RA_classifications.csv` | Takes the first 10 rows with `classification == "INCONCLUSIVE"` and executes `ra$classification[i] <- "ESCALATE"`. |
| **FB_VALSORT** | `outputs/validated_action_list.csv` | Rewrites the same validated rows as `arrange(v, desc(dormant_h))`; this is an ordering-only mutation. |

No R-A/R-B implementation code is seeded, no source variant is used, and every seeded arm uses the same Stage-5 harness hash `a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94`.

## 3. Hard mechanical facts table

**Basis notation:** **R** = independently recomputed from raw rows/manifests in the packet. **Q** = quoted because the underlying row-level data needed for an independent numerical recomputation is not supplied.

### Arm-level recomputation

| Arm | Stage-5 input changed vs B | Input byte delta vs B | S5 exit | Standard Stage-5 outputs vs B | H | Caught with freeze check | D_abl | Basis |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **B** | none; frozen inputs match 3/3 | 0 | 0 | **8/8 equal** to frozen outputs | N/A | FALSE | FALSE | R |
| **FB_KGRID** | `RB_kappa_grid_counts.csv` | **0 bytes**: 164→164, hash changed | 0 | **7/8 equal; 1/8 differs:** `kappa_sensitivity.csv` | TRUE | TRUE | FALSE | R |
| **FB_TF24** | `RA_classifications.csv` | **+38,477 bytes**: 22,271,481→22,309,958 | 0 | **7/8 equal; 1/8 differs:** `escalate_dormancy_summary.csv` | TRUE | TRUE | FALSE | R |
| **FB_CLAUSE** | `RA_classifications.csv` | **−25,368 bytes**: 22,271,481→22,246,113 | 0 | **7/8 equal; 1/8 differs:** `inconclusive_by_clause.csv` | TRUE | TRUE | FALSE | R |
| **FB_ROUND** | `RA_classifications.csv` | **−1,491,395 bytes**: 22,271,481→20,780,086 | 0 | **7/8 equal; 1/8 differs:** `escalate_dormancy_summary.csv` | TRUE | TRUE | FALSE | R |
| **FB_RECLASS** | `RA_classifications.csv` | **−40 bytes**: 22,271,481→22,271,441 | 1 | `independent_checks_critical_counts.csv` emitted with a different hash; the other **7/8** standard outputs are absent because execution stopped | FALSE | TRUE | TRUE | R |
| **FB_VALSORT** | `validated_action_list.csv` | **0 bytes**: 13,625,648→13,625,648, hash changed | 0 | **8/8 equal** | FALSE | TRUE | FALSE | R |

The raw arm rows independently reproduce the exit states, changed-file sets and output-difference sets. The B manifest reproduces all eight frozen output hashes exactly. The per-arm manifest comparisons establish the single-output differences for FB_CLAUSE, FB_KGRID, FB_ROUND and FB_TF24, the unchanged eight outputs for FB_VALSORT, and the early-stop output state for FB_RECLASS.

### Cross-arm identities and set arithmetic

| Mechanical fact | Recomputed result | Basis |
| --- | --- | --- |
| Frozen source COUNT preflight | `src_open_candidates = 245,193`; `src_peer_stats = 104` | Q — packet reports observed counts matching expectations. |
| Baseline framework hash identities | **2/2** spec hashes equal the separate baseline-hash entries | R |
| Seed PRE-script hash identities | **6/6** seed hashes in the specification equal the preflight/runner-side hashes | R |
| B frozen Stage-5 input identities | **3/3** B input hashes equal the frozen validation hashes | R |
| B frozen Stage-5 output identities | **8/8** B output hashes equal the frozen `stage-05/deeper` hashes | R |
| Seed PRE exits | **6/6 = 0** | R |
| Seed Stage-5 exits | **5/6 = 0**, **1/6 = non-zero** | R |
| Seed FRZ_PRE detection | **6/6** seeded arms have exactly one changed validated input; B has **0** changed inputs | R |
| FRZ_PRE vs FRZ_POST report-file hashes | **7/7 arms equal within arm** | R |
| Harm set H | `{FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}`; ** | H | = 4** | R |
| Caught with freeze control | all six seeded arms; **6/6** | R |
| D_abl | `{FB_RECLASS}`; ** | D_abl | = 1** | R |
| `H ∩ D_abl` | `∅`; **0/4 harms** are caught by Stage 5’s surviving checks | R |
| `H \ D_abl` | `{FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}`; **4** | R |
| `H \ caught-with` | `∅`; **0** | R |
| `caught-with \ H` | `{FB_RECLASS, FB_VALSORT}`; **2** | R |
| Successful seeded arms with unchanged `portfolio_summary.csv` | **5/5** | R |
| Numerical portfolio delta | No field-level values are printed, so field-by-field arithmetic is unavailable; however the complete `portfolio_summary.csv` SHA-256 and byte length are identical to B in all **5/5** seeded arms that complete Stage 5 | R for file equality; field values not separately recomputable |
| N1 timing mismatches | `1 dormant_h + 2 open_age_h = 3` total rows, each exactly `1.000 h`; labels agree | total **3** R from quoted component counts; component counts and magnitude Q |
| Per-arm fixture-result rows in C32 evidence | **0** data rows; header only | R |
| `n_agree + n_disagree = n_inner` | Not recomputable: the packet supplies no `n_agree`, `n_disagree`, or `n_inner` values | Not available |

The recomputed set arithmetic agrees with the runner’s published sets: H has four arms, the freeze check flags all six seeded arms, D_abl contains only FB_RECLASS, and all four members of H remain in `H \ D_abl`.

Hash propagation is also exact. In FB_KGRID, the changed R-B grid hash `12ea0619…` is also the changed `kappa_sensitivity.csv` hash. In FB_CLAUSE only `inconclusive_by_clause.csv` changes among the eight outputs. In FB_ROUND and FB_TF24 only `escalate_dormancy_summary.csv` changes. FB_VALSORT changes the validated-list input hash while all eight Stage-5 output hashes remain identical to B.

## 4. P1 assessment against the frozen predicate in the SPEC

The frozen P1 predicate requires both conditions: **arm B must be clean**, and `H \ D_abl` **must be empty**.

The first condition is established mechanically. B exits Stage 5 with code 0; its three validated Stage-5 input hashes match the frozen versions; and its eight standard Stage-5 output hashes match the frozen `stage-05/deeper` hashes **8/8**. The run log also records B `FRZ_PRE changed=0` and `FRZ_POST changed=0`.

The second condition is not established: recomputation gives

`H = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}`

and

`D_abl = {FB_RECLASS}`,

therefore

`H \ D_abl = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}`,

with cardinality **4**, not 0. All four harm arms complete Stage 5 successfully despite producing a changed standard Stage-5 output.

Accordingly, **P1 is failed by the frozen predicate**. This statement is limited to the predicate result; no terminal disposition is issued.

## 5. Fixture and reconciliation implications

The `FIXTURE RESULTS per arm and path` evidence contains its column header and **zero result rows**. Therefore C32 itself supplies no new per-arm fixture expected/observed/pass results to recompute. This is consistent with the frozen Stage-5-only design: these controls begin from the frozen validated state and **do not rerun R-A or R-B**. The packet also states that no R-A/R-B code seeds and no source variants are used.

The reconciliation implication is central to C32. The PRE mutations occur **after validation/reconciliation has already produced the frozen validated state**. Consequently, there is no fresh R-A/R-B reconciliation between PRE and Stage 5. FB_TF24, FB_CLAUSE, FB_ROUND and FB_RECLASS can therefore alter the R-A classification artifact after validation; FB_KGRID can alter the R-B κ-grid after validation; FB_VALSORT can alter the validated action-list serialization after validation. The freeze comparison is the mechanism designed to detect those post-validation mutations before Stage 5 consumes them.

The known N1 discrepancy must remain separate from the seeded effects. In the frozen clean pair there is **1** `dormant_h` mismatch and **2** `open_age_h` mismatches, totaling **3 distinct rows**, and every mismatch is exactly **1.000 h** while classification labels agree. The packet records daylight-saving ambiguity only as a likely, unconfirmed explanation. The frozen reconciliation definition used for the clean-arm rule concerns only key-set differences and classification disagreements; it excludes `dormant_h` and `open_age_h`. Thus the N1 differences are pre-existing frozen-pack facts, not effects created by any C32 seed.

## 6. Semantic/regression risks and unchanged surfaces

The demonstrated semantic risk of removing the freeze is broader than classification-count corruption. Four different post-validation edits survive Stage 5’s retained count checks and change downstream analytical output: κ-grid composition changes `kappa_sensitivity.csv`; a +24-hour re-derivation changes `escalate_dormancy_summary.csv`; an integrity-clause relabel changes `inconclusive_by_clause.csv`; and rounding `dormant_h` changes `escalate_dormancy_summary.csv`. Each finishes with exit 0. The raw arm table establishes those four one-output divergences directly.

The retained Stage-5 checks are effective against the particular FB_RECLASS mutation: changing 10 INCONCLUSIVE labels to ESCALATE causes Stage 5 to exit non-zero. They do **not**, however, detect any of the four members of H. Thus the evidence distinguishes a count-sensitive guard from an integrity seal: the former responds to a label-count change, while the latter also detects timing, clause, κ-grid and serialization changes.

There is also measurable blocking cost. FB_VALSORT changes only row order in the validated action list, completes Stage 5, and produces **8/8** outputs identical to B; nevertheless the freeze comparison flags it because the input SHA-256 changes. FB_RECLASS is likewise flagged by the freeze comparison even though Stage 5’s own check independently prevents completion. Hence the recomputed flagged-but-not-H set is `{FB_RECLASS, FB_VALSORT}`, cardinality **2**.

The unchanged surfaces are strong and localized. There are **no source variants**. The `VALIDATION_FREEZE.sha256` file has the same hash `65b91043…` in every arm manifest. Every completing seeded arm retains the B hash for `portfolio_summary.csv`, `capacity_coverage_note.csv`, `independent_checks_critical_counts.csv`, and all other standard outputs except the single output specifically affected by that seed. FB_VALSORT retains all eight.

Finally, FRZ_PRE and FRZ_POST have identical hashes **within all 7 arms**, while each seeded arm’s changed input remains changed after Stage 5. Mechanically, the evidence therefore localizes the mutation to the PRE step rather than showing an additional Stage-5 mutation of the sealed-input files.

## 7. Claim → evidence map

| Claim | Frozen evidence section / table row | Evidence |
| --- | --- | --- |
| C32 removes the pre-Stage-5 seal comparison while retaining Stage 5’s independent count checks. | **SPEC → Exact change being tested** | Lines 37–42. |
| The six PRE seeds are exactly κ=3 +1500/−1500, +24 h timing, INCONCLUSIVE clause split, `dormant_h` rounding, first 10 INCONCLUSIVE→ESCALATE, and descending-`dormant_h` re-sort. | **SEED DIFFS → FB_KGRID / FB_TF24 / FB_CLAUSE / FB_ROUND / FB_RECLASS / FB_VALSORT blocks** | Exact executable mutations at lines 579–625. |
| B is a clean reference with Stage-5 exit 0 and frozen outputs reproduced 8/8. | **C32_RESULTS → Arm B**; **ARM MANIFESTS → B out rows** | Runner result and eight output hashes. |
| FB_KGRID is in H and changes only `kappa_sensitivity.csv`. | **C32_arms.csv → FB_KGRID row**; **ARM MANIFESTS → FB_KGRID output rows** | Exit 0, differing output named; 7 other standard hashes equal B. |
| FB_TF24 is in H and changes only `escalate_dormancy_summary.csv`. | **C32_arms.csv → FB_TF24 row**; **ARM MANIFESTS → FB_TF24 output rows** | Exit 0 and one differing standard output. |
| FB_CLAUSE is in H and changes only `inconclusive_by_clause.csv`. | **C32_arms.csv → FB_CLAUSE row**; **ARM MANIFESTS → FB_CLAUSE output rows** | Exit 0 and one differing standard output. |
| FB_ROUND is in H and changes only `escalate_dormancy_summary.csv`. | **C32_arms.csv → FB_ROUND row**; **ARM MANIFESTS → FB_ROUND output rows** | Exit 0 and one differing standard output. |
| FB_RECLASS is detected without the freeze control because Stage 5 exits non-zero. | **C32_arms.csv → FB_RECLASS row** | `s5_exit=1`, `caught_without=TRUE`. |
| FB_VALSORT is detected by the freeze comparison but leaves all eight Stage-5 outputs unchanged. | **C32_arms.csv → FB_VALSORT row**; **ARM MANIFESTS → FB_VALSORT output rows** | Changed validated-list input, exit 0, no output differences; all eight hashes equal B. |
| H contains four arms, D_abl contains one different arm, so `H \ D_abl` contains all four harms. | **C32_RESULTS → Sets** | Explicit sets independently reproduced from raw arm rows. |
| Therefore the frozen P1 predicate is not satisfied. | **SPEC → Operational benefit predicate** plus **C32_RESULTS → Predicate P1** | P1 requires `H \ D_abl = ∅`; observed difference set has four members. |
| No per-arm fixture outcomes were produced in the C32 evidence table. | **FIXTURE RESULTS per arm and path** | Header is present with zero data rows. |
| The clean frozen pair contains three known 1-hour timing mismatches, with labels agreeing, and they are not seeded C32 effects. | **COORDINATOR NOTE N1** | One `dormant_h` plus two `open_age_h` discrepancies; all exactly 1.000 h. |
| No source variant contributes to the result. | **SOURCE VARIANTS used by this control** | Explicitly records `(no source variants used)`. |
| `portfolio_summary.csv` is unchanged in every seeded arm that completes Stage 5. | **ARM MANIFESTS → B, FB_CLAUSE, FB_KGRID, FB_ROUND, FB_TF24, FB_VALSORT portfolio rows** | Each has SHA-256 `b58fc40f…`, 183 bytes. |

END C32 BUILDER REPORT
