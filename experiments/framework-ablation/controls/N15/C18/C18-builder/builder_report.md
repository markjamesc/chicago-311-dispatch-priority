# C18 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as Builder** for an **independent first pass**, blind to the Validator. I am not performing the Validator or Adjudicator role and do not state a terminal disposition.

**Ablation ID:** C18, catalog #18, **“No Fixture Rewrite on Fail.”** Batch N15, batch 2 of 3. Constitution version 1.0. Target stage: Stage 4 fixture failures. The frozen control requires a failed fixture to remain unchanged; fixing the code or introducing a new versioned fixture is required instead. The ablation allows the failed fixture expectation to be changed to the observed result and rerun.

The truth reference is clean arm B using the frozen R-A and R-B implementations and frozen source data. Locked comparison fields are SR_NUMBER key set, classification, `dormant_h`, and `open_age_h`.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C18 removes the protection that a failing fixture remains an immutable test of previously frozen behavior. Under the control, a fixture failure remains visible until the implementation is corrected. Under the ablation, the fixture expectation can be changed to match the defective implementation's observed result, so a subsequent fixture run may become green without correcting the seeded defect. The frozen P1 definition specifically tests whether a harmful locked-output change can escape detection after that rewrite.

| Seed family | Exact production-code change | Exact RW fixture change |
| --- | --- | --- |
| **NOTHIN / I04** | R-A changes `check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")` to `check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")`. R-B changes `p_thin <- peer_n < RB_N_MIN` to `p_thin <- rep(FALSE, n)`. This disables the thin-peer integrity condition on both paths. | R-A F06 changes expected `INCONCLUSIVE` → `ESCALATE`; R-B F06 likewise changes expected classification `INCONCLUSIVE` → `ESCALATE`. |
| **NODUP** | R-A removes `is_true_like(dup)` from the exclusion expression. R-B removes `!dup_flag` from `in_decision`. DUPLICATE records therefore cease to be excluded by these clauses. | R-A F07 changes `expected = "OUT_OF_SET", in_set = FALSE` to `expected = "ESCALATE", in_set = TRUE`; R-B F07 changes expected `OUT_OF_SET` → `ESCALATE`. Thus the R-A RW seed changes **two fixture fields**, not merely the expected label. |
| **NOI01 / open+closed-date** | R-A removes the `open_with_closed_date` check. R-B replaces `p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))` with `p_closed_contra <- rep(FALSE, n)`. | R-A F04 changes expected `INCONCLUSIVE` → `STANDARD`; R-B F04 likewise changes expected `INCONCLUSIVE` → `STANDARD`. `in_set` remains TRUE. |
| **RB_NOTHIN** | Uses the same R-B NOTHIN production seed as the common-mode NOTHIN arms; R-A is not seeded and is taken from B. | Uses the same R-B F06 rewrite as RW_CM_NOTHIN. |

One exact-diff qualification matters: the frozen SPEC describes the ablation as rewriting the **expected label**, but `RA_NODUP_RW__run_RA.R` also changes F07's `in_set` field from FALSE to TRUE. That additional fixture-field mutation is explicit in the frozen SEED DIFFS and therefore must be carried forward as part of the actual implemented seed, rather than silently describing the seed as label-only.

## 3. Hard mechanical facts table.

Notation: **R = recomputed** from the raw evidence in the packet; **Q = quoted** directly from a frozen evidence row. Where an equality uses quoted hashes or counts but I independently compare or perform the arithmetic, it is marked **R**.

| Mechanical fact | Result | Status |
| --- | --- | --- |
| Arm B R-A rows | 222,002 | Q |
| Arm B R-B rows | 222,002 | Q |
| Arm B inner rows | 222,002 | Q |
| Arm B key-only differences, RA/RB | 0 / 0 | Q |
| Arm B classification disagreements | 0 | Q |
| Arm B agreement count = `222,002 − 0` | **222,002** | R |
| Identity `n_agree + n_disagree = n_inner` for B | `222,002 + 0 = 222,002` | R |
| Arm B reproduction differences vs frozen R-A: key-x/key-truth/label/dormant/open_age | 0 / 0 / 0 / 0 / 0 | Q |
| Arm B reproduction differences vs frozen R-B: same five fields | 0 / 0 / 0 / 0 / 0 | Q |
| Known full-field R-A/R-B clock mismatches | dormant **1**, open_age **2** | Q |
| Seeded arms represented | 8 / 8 | Q; verified R |
| Seeded executable path runs | **14** | R |
| Seeded executable path runs with exit 0 | **14 / 14** | R |
| Clean-B fixture executions | 28 total; **28 passed, 0 failed** | R |
| Frozen-fixture FX executions | 7 paths × 14 = **98**; **91 passed, 7 failed** | R |
| Rewritten-fixture RW executions | 7 paths × 14 = **98**; **98 passed, 0 failed** | R |
| Total fixture rows represented including B | **224** | R |
| Total passes including B | **217** | R |
| Total fixture failures including B | **7** | R |
| Harm set size | **6 arms** | R |
| Harmful RW-arm count, ` | H_RW | ` | **3** | R |
| Applicable frozen-fixture caught set size | **4 FX arms** | R |
| Applicable rewritten-fixture caught set size, ` | D_abl | ` | **1 RW arm** | R |
| ` | H_RW \ D_abl | ` | **2** | R |
| Framework-hash strings agreeing between SPEC and baseline-hash block | **2 / 2** | R |
| Named seed-file hashes in the SPEC agreeing with the preflight seed hashes | **12 / 12** | R |
| Frozen source files whose listed hashes are invariant across all 9 arm manifests | **3 / 3** | R |

The arm-level arithmetic is:

| Arm | n_RA | n_RB | n_inner | n_agree | n_disagree | Row-count Δ vs B, RA/RB | Locked-field changes vs B | Fixture result | Harm | Applicable catch |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FX_CM_NOTHIN | 222,002 | 222,002 | 222,002 | 222,002 | 0 | 0 / 0 | 12,754 = 6,377 + 6,377 | RA 13/14; RB 13/14 | yes | yes |
| RW_CM_NOTHIN | 222,002 | 222,002 | 222,002 | 222,002 | 0 | 0 / 0 | 12,754 = 6,377 + 6,377 | RA 14/14; RB 14/14 | yes | **no** |
| FX_CM_NODUP | 245,014 | 245,014 | 245,014 | 245,014 | 0 | +23,012 / +23,012 | 46,024 = 23,012 + 23,012 | RA 13/14; RB 13/14 | yes | yes |
| RW_CM_NODUP | 245,014 | 245,014 | 245,014 | 245,014 | 0 | +23,012 / +23,012 | 46,024 = 23,012 + 23,012 | RA 14/14; RB 14/14 | yes | **no** |
| FX_CM_NOI01 | 222,002 | 222,002 | 222,002 | 222,002 | 0 | 0 / 0 | 0 | RA 13/14; RB 13/14 | no | yes |
| RW_CM_NOI01 | 222,002 | 222,002 | 222,002 | 222,002 | 0 | 0 / 0 | 0 | RA 14/14; RB 14/14 | no | no |
| FX_RB_NOTHIN | 222,002 | 222,002 | 222,002 | **215,625** | 6,377 | 0 / 0 | 6,377 | RA inherited B 14/14; RB 13/14 | yes | yes |
| RW_RB_NOTHIN | 222,002 | 222,002 | 222,002 | **215,625** | 6,377 | 0 / 0 | 6,377 | RA inherited B 14/14; RB 14/14 | yes | yes |

Every number in this arm table is **R**, except the raw component counts used in the arithmetic. For the RB-only arms, the reconciliation identity is `215,625 + 6,377 = 222,002`. For NODUP, `222,002 + 23,012 = 245,014`. For common-mode NOTHIN, each path has exactly 6,377 classification changes and no key-count change, yielding `6,377 × 2 = 12,754` locked-field changes. For common-mode NODUP, each path introduces 23,012 keys, yielding `23,012 × 2 = 46,024` locked-field changes. These recomputations agree with the frozen seeded-arm rows.

The recomputed sets are:

`H = {FX_CM_NOTHIN, RW_CM_NOTHIN, FX_CM_NODUP, RW_CM_NODUP, FX_RB_NOTHIN, RW_RB_NOTHIN}`.

`H_RW = {RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN}`.

`D_control = {FX_CM_NOTHIN, FX_CM_NODUP, FX_CM_NOI01, FX_RB_NOTHIN}`.

`D_abl = {RW_RB_NOTHIN}`.

Therefore:

`H_RW \ D_abl = {RW_CM_NOTHIN, RW_CM_NODUP}`.

These sets independently reproduce H4–H9 in the mechanical-results summary when catch status is derived from the frozen definitions using exits, reconciliation and raw fixture outcomes.

The raw fixture rows independently reproduce the fixture counts: F06 fails on both paths in FX_CM_NOTHIN and on R-B in FX_RB_NOTHIN; F07 fails on both paths in FX_CM_NODUP; F04 fails on both paths in FX_CM_NOI01. Their corresponding RW fixtures all pass after the seeded fixture changes.

The production-output hash equalities are also mechanically informative:

| Output surface | Recomputed hash equality |
| --- | --- |
| R-A classifications and portfolio counts, NOI01 | **B = FX_CM_NOI01 = RW_CM_NOI01** |
| R-B classifications, kappa counts and portfolio counts, NOI01 | **B = FX_CM_NOI01 = RW_CM_NOI01** |
| R-A classifications and portfolio counts, NOTHIN | **FX_CM_NOTHIN = RW_CM_NOTHIN** |
| R-B classifications, kappa counts and portfolio counts, NOTHIN | **FX_CM_NOTHIN = RW_CM_NOTHIN = FX_RB_NOTHIN = RW_RB_NOTHIN** |
| R-A classifications and portfolio counts, NODUP | **FX_CM_NODUP = RW_CM_NODUP** |
| R-B classifications, kappa counts and portfolio counts, NODUP | **FX_CM_NODUP = RW_CM_NODUP** |

These are **R equality comparisons of Q SHA-256 strings**. Thus the fixture rewrite changes fixture-result artifacts but does not change the associated production classification/portfolio artifacts relative to the same seeded defect. The manifests also show the same frozen source hashes in B and every seeded arm.

A category-by-category numeric portfolio-count delta cannot be reconstructed from the packet because the packet provides SHA-256 and byte size for the `*_portfolio_counts.csv` files rather than their row contents. What is mechanically available is the total classification-row delta above plus exact portfolio-file hash equality/difference. I do not infer unexposed category counts.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate defines `H_RW` as rewritten-fixture arms whose outputs differ from B on a locked field, and `D_abl` as rewritten-fixture arms still caught by crash, reconciliation key/label mismatch, or a fixture failure remaining after rewrite. The predicate condition is `H_RW ⊆ D_abl`; a non-empty `H_RW \ D_abl` is the specified counterexample condition.

From the raw arm evidence:

`H_RW = {RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN}`.

`D_abl = {RW_RB_NOTHIN}`.

`H_RW \ D_abl = {RW_CM_NOTHIN, RW_CM_NODUP}`.

Accordingly, **the frozen subset condition** `H_RW ⊆ D_abl` **is not met**. Two rewritten-fixture arms change locked production outputs relative to B yet are not caught after their fixtures are rewritten:

| Arm | Harmful change | Why it is outside D_abl |
| --- | --- | --- |
| RW_CM_NOTHIN | 6,377 label changes on R-A plus 6,377 on R-B; 12,754 locked-field changes total | Both paths implement the same defect, reconciliation remains 0/0/0 on key/classification, and rewritten F06 passes 14/14 on both paths. |
| RW_CM_NODUP | +23,012 keys on R-A plus +23,012 on R-B; 46,024 locked-field changes total | Both paths implement the same defect, reconciliation remains 0/0/0 on key/classification, and rewritten F07 passes 14/14 on both paths. |

RW_RB_NOTHIN is harmful but remains in `D_abl` because R-A stays at B while R-B contains 6,377 changed classifications, producing 6,377 reconciliation disagreements even though rewritten F06 itself is 14/14. RW_CM_NOI01 has no locked-field output change and therefore is outside `H_RW` by definition.

## 5. Fixture and reconciliation implications.

The frozen fixtures and reconciliation mechanisms protect different failure modes.

For **common-mode NOTHIN**, frozen F06 catches the defect independently on R-A and R-B: expected INCONCLUSIVE, observed ESCALATE. Because both production paths contain the same defect, their key sets and classifications still reconcile exactly. After both F06 expectations are rewritten to ESCALATE, the fixture signal disappears while 6,377 classifications per path remain changed against B. Thus cross-path reconciliation cannot substitute for the frozen semantic fixture in the common-mode case.

For **common-mode NODUP**, frozen F07 likewise catches the defect independently on both paths: expected OUT_OF_SET, observed ESCALATE. Both defective paths add the same 23,012 production keys, so they still agree with each other. After F07 is rewritten, both fixture suites are 14/14 and the cross-path key/classification reconciliation remains clean even though the production portfolio contains 23,012 additional rows on each path.

For **NOI01**, frozen F04 detects the removal of the open+closed-date integrity rule even though this particular frozen source pack produces no locked production-output difference. The fixture therefore exercises a semantic condition not activated by the production sample. Rewriting F04 makes that regression invisible in the fixture suite, although it does not enter P1's harm set because the frozen locked outputs are unchanged.

For **RB-only NOTHIN**, the two safeguards overlap rather than fail together. Frozen F06 catches R-B before rewrite. After F06 is rewritten, the independent unchanged R-A path still exposes 6,377 classification disagreements against seeded R-B. This explains why RW_RB_NOTHIN remains caught while RW_CM_NOTHIN does not.

The known `dormant_h = 1` and `open_age_h = 2` full-field mismatches are present in clean B and persist in every seeded reconciliation row. They do not create key-set or classification disagreement and are disclosed as a pre-existing frozen-pack finding rather than a seeded C18 effect. The packet identifies the likely cause as an ambiguous daylight-saving-hour read but explicitly says that cause is unconfirmed.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk demonstrated by the evidence is **common-mode fixture accommodation**: when both independent implementations share a defect, R-A/R-B agreement cannot reveal it, and rewriting the fixture to the defective observed result removes the remaining semantic tripwire. RW_CM_NOTHIN and RW_CM_NODUP are direct frozen examples.

A second risk is **fixture-scope drift**. The SPEC characterizes the tested change as rewriting a failed fixture's expected label, but the R-A NODUP RW seed also changes F07 `in_set = FALSE` to `in_set = TRUE`. That is a second fixture-input mutation. The production hashes show that FX_CM_NODUP and RW_CM_NODUP nevertheless produce identical classifications and portfolio counts for each production path, so the additional `in_set` mutation is confined to fixture behavior in the observed evidence; it remains a broader seeded fixture change than the prose description alone suggests.

A third risk is demonstrated by NOI01: absence of a production-sample locked-field delta does not make a semantic fixture redundant. The frozen data simply did not activate that defect in the production outputs, while F04 did activate it.

There is also a reporting-schema issue in `C18_arms.csv` / the seeded-arms table. The final columns are headed `caught_with_control` and `caught_without_control`, yet FX rows contain `NA` followed by the applicable TRUE value. Because those labels do not directly line up with the SPEC's FX/RW regime terminology, I did **not** derive the catch sets from those field names. I recomputed the applicable catch status from exit codes, reconciliation values and fixture results, which reproduces the summary H5/H8 sets.

The following surfaces remain mechanically unchanged where expected. All nine arm manifests use identical hashes for `src_extract_lineage.csv`, `src_open_candidates.csv`, and `src_peer_stats.csv`; there are no source variants. `R-B/R/00_config.R`, `R-B/R/10_io_parse.R`, and `R-B/run_RB.R` retain the same hashes across the arms. Arm B reproduces both frozen classification files with zero key, label, dormant or open-age differences. For each defect family, the FX and corresponding RW production-classification and portfolio hashes are identical; only the fixture-definition/result artifacts distinguish the rewrite treatment from the frozen-fixture treatment. NOI01 production classifications and portfolio-count hashes are exactly B's on both paths.

## 7. Claim → evidence map.

| Claim | Frozen evidence |
| --- | --- |
| C18 is the Builder-only “No Fixture Rewrite on Fail” ablation and the control forbids rewriting a failed fixture. | **SPEC → Ablation ID / Control under test**, lines 25–43. |
| The ablation rewrites failed fixture expectations to the observed label. | **SPEC → Exact change being tested**, lines 42–44. |
| The locked fields are key set, classification, dormant_h and open_age_h. | **SPEC → Seeded defects and rewrites**, lines 49–53. |
| Clean B is 222,002/222,002 with key/classification reconciliation 0/0/0 and known full-field mismatches 1 dormant + 2 open-age. | **C18_RESULTS → Arm B recon**, row at line 373; **Mechanical facts H2**. |
| All 8 seeded arms have run records. | **C18_RESULTS → Mechanical fact H3**, line 356; corroborated by the run log. |
| Harm set contains six arms. | **C18_RESULTS → Mechanical fact H4** and **Seeded arms** rows. |
| Frozen fixtures catch all four FX arms; only three of those four are locked-output harmful. | **Mechanical facts H7–H9** plus raw fixture rows F06/F07/F04. |
| `H_RW = {RW_CM_NOTHIN,RW_CM_NODUP,RW_RB_NOTHIN}` and `D_abl = {RW_RB_NOTHIN}`. | **SPEC → P1 definitions** plus **C18_RESULTS H4–H6 / seeded-arm rows**. |
| `H_RW \ D_abl = {RW_CM_NOTHIN,RW_CM_NODUP}` and is non-empty. | **C18_RESULTS → H6**, line 359, independently recomputed from rows RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN. |
| Common-mode NOTHIN changes 6,377 labels on each path, 12,754 locked changes total. | **Seeded arms → FX/RW_CM_NOTHIN rows**, lines 378–379. |
| Common-mode NODUP adds 23,012 keys on each path, 46,024 locked changes total. | **Seeded arms → FX/RW_CM_NODUP rows**, lines 380–381. |
| RB-only NOTHIN produces 6,377 R-A/R-B classification disagreements. | **Seeded arms → FX/RW_RB_NOTHIN rows**, lines 384–385. |
| NOI01 changes the fixture behavior but produces zero locked-field changes on the frozen source. | **Seeded arms → FX/RW_CM_NOI01 rows**, lines 382–383; raw F04 rows. |
| F06, F07 and F04 frozen expectations fail exactly as seeded; their RW counterparts pass after rewrite. | **FIXTURE RESULTS**, corresponding raw fixture rows. |
| FX and RW versions of a given defect have identical production classification/portfolio hashes even though their fixture-result hashes differ. | **ARM MANIFESTS**, defect-family output rows. |
| NOI01 production outputs hash-identically to B. | **ARM MANIFESTS → B, FX_CM_NOI01, RW_CM_NOI01 output rows**. |
| R-A F07 RW changes `in_set` as well as the expected label. | **SEED DIFFS → RA_NODUP_RW F07**, lines 913–922. |
| The three source inputs are hash-identical across all arms and no source variants are used. | **SOURCE VARIANTS / ARM MANIFESTS**, common source-input rows throughout the manifests. |
| The 1 dormant and 2 open-age R-A/R-B mismatches are pre-existing frozen-pack findings, not seeded C18 effects. | **Coordinator Note N1 / SPEC Known open finding N1**. |

END C18 BUILDER REPORT
