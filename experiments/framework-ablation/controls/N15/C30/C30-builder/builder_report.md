# C30 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting as **Builder only**, independently and blind to the Validator. I am not performing validation or adjudication and issue no terminal disposition.

**Ablation ID:** C30 — catalog #30, “Structural Cross-Review.”  
**Batch:** N15 batch 1 of 3.  
**Constitution:** version 1.0.  
**Target:** Stage 4, post-reconciliation logic review.  
**Frozen role assignment:** Builder = ChatGPT; Validator = DeepSeek; Adjudicator = Grok.

---

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The control under test is a **structural/logic cross-review of the two independent implementations after exact reconciliation**, intended specifically to expose common-mode logic errors that matching outputs can miss. The ablation removes that structural reading. Under the ablated regime, successful execution, accepted R-A/R-B reconciliation, and the fixture suite constitute the remaining mechanical protection. The runner does **not** simulate the structural review itself; it tests whether the remaining checks detect the frozen common-mode seeds.

| Seed | Conceptual mutation | Exact R-A change | Exact R-B change |
| --- | --- | --- | --- |
| **CM_GT** | Replace inclusive κ threshold with strict threshold. | `base$dormant_h[remain] >= thr` → `base$dormant_h[remain] > thr` | `dormant_h >= thresh` → `dormant_h > thresh` |
| **CM_NODUP** | Remove DUPLICATE exclusion from the decision-set definition. | `exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open` → `exclude <- is_true_like(leg) | !in_envelope_open` | `in_decision <- is_open & !dup_flag & !leg_flag` → `in_decision <- is_open & !leg_flag` |
| **CM_NOPARENT** | Remove I05 nonblank-parent integrity clause. | `check(base$parent_nonblank, "orphan_parent_nonblank")` is replaced by `# [seed] I05 parent clause removed` | `p_parent <- parent_nonblank` → `p_parent <- rep(FALSE, n)` |
| **CM_NOTHIN** | Remove I04 thin/missing-peer integrity clause. | `check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")` → `check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")` | `p_thin <- peer_n < RB_N_MIN` → `p_thin <- rep(FALSE, n)` |
| **CM_NOI01** | Remove I01 open-plus-closed-date contradiction clause. | `check(!is.na(base$closed_ts), "open_with_closed_date")` is replaced by `# [seed] I01 open+closed-date clause removed` | `p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))` → `p_closed_contra <- rep(FALSE, n)` |

The exact CM_GT and CM_NODUP hunks are in the frozen seed diffs. The exact CM_NOPARENT and CM_NOTHIN hunks follow. The CM_NOI01 hunk closes the seed set.

---

## 3. Hard mechanical facts table.

Notation: **[R] = independently recomputed from raw evidence in the packet; [Q] = directly quoted from a frozen evidence table/log.** Where a row contains both, every numerical quantity is marked separately.

| Mechanical fact | Result | Recalculation / evidence status |
| --- | --- | --- |
| Baseline row counts | `n_ra = 222,002 [Q]`, `n_rb = 222,002 [Q]`, `n_inner = 222,002 [Q]` | Arm B reconciliation row. |
| Baseline agreement identity | `n_disagree = 0 [Q]`; therefore `n_agree = 222,002 [R]`; `222,002 [R] + 0 [Q] = 222,002 [Q]` | Recomputed as `n_inner − n_disagree`. |
| Baseline key-set identities | `n_only_ra = 0 [Q]`, `n_only_rb = 0 [Q]`; `n_inner + n_only_ra = 222,002 [R] = n_ra`; `n_inner + n_only_rb = 222,002 [R] = n_rb` | Recomputed from Arm B row. |
| Baseline frozen-pack reproduction | R-A: `0 [Q]` only-x, `0 [Q]` only-truth, `0 [Q]` label, `0 [Q]` dormant, `0 [Q]` open-age. R-B: same five zeros. Total reported baseline-vs-frozen difference incidences = `0 [R]`. | Sum of both reproduction rows. |
| Baseline full-field R-A/R-B mismatches | `1 [Q]` dormant mismatch + `2 [Q]` open-age mismatches = `3 [R]` field-mismatch incidences | These are not key/label disagreements and are already present in B. |
| Run completeness | `6 [R]` arms × `2 [R]` paths = `12 [R]` run records; `12/12 [R]` exits are zero. Seeded portion = `5 [R]` arms × `2 [R]` paths = `10/10 [R]` recorded seeded path runs. | Recomputed from run log. |
| Baseline fixtures | R-A `14/14 [Q]`; R-B `14/14 [Q]`; combined `28/28 [R]`. | Sum of raw B fixture rows. |
| CM_GT fixtures | R-A `14/14 [Q]` + R-B `14/14 [Q]` = `28/28 [R]`; failures `0 [R]`. | Raw fixture rows. |
| CM_NODUP fixtures | `13/14 [Q]` per path = `26/28 [R]`; failures `2 [R]`, both F07. | Raw fixture rows. |
| CM_NOPARENT fixtures | `13/14 [Q]` per path = `26/28 [R]`; failures `2 [R]`, both F09. | Raw fixture rows. |
| CM_NOTHIN fixtures | `13/14 [Q]` per path = `26/28 [R]`; failures `2 [R]`, both F06. | Raw fixture rows. |
| CM_NOI01 fixtures | `13/14 [Q]` per path = `26/28 [R]`; failures `2 [R]`, both F04. | Raw fixture rows. |
| Seeded fixture portfolio | `132/140 [R]` passes; `8 [R]` failures. | `28 + 26 + 26 + 26 + 26 = 132 [R]` passes across `140 [R]` executions. |
| Whole-run fixture portfolio | `160/168 [R]` passes and `8 [R]` failures. | Baseline `28 [R]` plus seeded `132 [R]`. |
| Seeded key/label reconciliation | All `5 [R]` seeded arms have `recon_only_ra=0 [Q]`, `recon_only_rb=0 [Q]`, `recon_disagree=0 [Q]`. | Direct comparison of all five Seeded-arms rows. |
| Seeded numeric reconciliation pattern | Every seeded arm has `1 [Q]` dormant mismatch and `2 [Q]` open-age mismatches, identical to B. Across the five seeded arms this is `5 [R]` dormant and `10 [R]` open-age field-mismatch incidences. | Recomputed across Seeded-arms rows. |
| Harm set H | `{CM_NODUP, CM_NOTHIN} [R]`; cardinality `2/5 [R]`. | Exactly the rows with `locked_field_changes_vs_B > 0`. |
| Detection set D_abl | `{CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01} [R]`; cardinality `4/5 [R]`. | Exactly the rows with `caught_without_control=TRUE`. |
| Harm not detected by remaining checks | `H \ D_abl = ∅ [R]`; `0/2 [R]` harmful seeded arms are outside D_abl. | Direct set subtraction. |
| Detected but non-harmful under locked fields | `D_abl \ H = {CM_NOPARENT, CM_NOI01} [R]`; cardinality `2 [R]`. | Set subtraction. |
| No locked-field-change set | `{CM_GT, CM_NOPARENT, CM_NOI01} [R]`; cardinality `3/5 [R]`. | Rows with locked-field delta `0`. |
| CM_NODUP portfolio delta | R-A adds `23,012 [Q]` keys and R-B adds `23,012 [Q]` keys; path-summed locked-field change incidences = `46,024 [R]`; decision-change incidences = `46,024 [Q]`. | `23,012 + 23,012 = 46,024 [R]`. |
| CM_NOTHIN portfolio delta | R-A has `6,377 [Q]` label changes and R-B has `6,377 [Q]`; path-summed locked-field change incidences = `12,754 [R]`; decision-change incidences = `12,754 [Q]`. | `6,377 + 6,377 = 12,754 [R]`. |
| Total seeded locked-field portfolio delta | `46,024 [Q] + 12,754 [Q] = 58,778 [R]` path-level change incidences. | Not a deduplicated count of unique SR_NUMBERs across arms. |
| Total seeded decision-change portfolio delta | `46,024 [Q] + 12,754 [Q] = 58,778 [R]` path-level decision-change incidences. | Same qualification as above. |
| Source-hash equality across seeded arms | `3 [R]` source files × `5 [R]` seeded arms = `15/15 [R]` seeded-vs-B hash comparisons equal. | `src_extract_lineage.csv`, `src_open_candidates.csv`, and `src_peer_stats.csv`. |
| Unseeded R-B support-file equality | `2 [R]` unchanged files × `5 [R]` seeded arms = `10/10 [R]` seeded-vs-B hash comparisons equal. | `R-B/R/00_config.R` and `R-B/run_RB.R`. |
| Seed implementation hashes | `10/10 [R]` arm-manifest seeded implementation hashes agree with the declared seed hashes: `2 [R]` seeded files × `5 [R]` arms. | Comparison of SPEC/preflight declarations with arm manifests. |
| Key-manifest equality count vs B: CM_GT | `9/11 [R]` hashes equal B; only the `2/11 [R]` deliberately seeded implementation files differ. | All four listed output hashes equal B. |
| Key-manifest equality count vs B: CM_NODUP | `5/11 [R]` equal; `6/11 [R]` differ. | The `2 [R]` seeded implementation files plus all `4 [R]` listed outputs differ. |
| Key-manifest equality count vs B: CM_NOPARENT | `7/11 [R]` equal; `4/11 [R]` differ. | Classification hashes equal B on both paths; both fixture hashes differ, as do the two seeded code hashes. |
| Key-manifest equality count vs B: CM_NOTHIN | `5/11 [R]` equal; `6/11 [R]` differ. | Both classification hashes, both fixture hashes, and both seeded code hashes differ. |
| Key-manifest equality count vs B: CM_NOI01 | `7/11 [R]` equal; `4/11 [R]` differ. | Classification hashes equal B on both paths; fixture and seeded-code hashes differ. |
| CM_GT output-byte deltas vs B | RA class `0 [R]`; RA fixture `0 [R]`; RB class `0 [R]`; RB fixture `0 [R]`. | Recomputed from manifest byte counts. |
| CM_NODUP output-byte deltas vs B | RA class `+2,350,526 [R]`; RA fixture `+16 [R]`; RB class `+3,589,053 [R]`; RB fixture `+78 [R]`. | Recomputed from manifest byte counts. |
| CM_NOPARENT output-byte deltas vs B | RA class `0 [R]`; RA fixture `0 [R]`; RB class `0 [R]`; RB fixture `+33 [R]`. | Recomputed from manifest byte counts; equal byte size does not imply equal hash for the RA fixture file. |
| CM_NOTHIN output-byte deltas vs B | RA class `−57,273 [R]`; RA fixture `−3 [R]`; RB class `+253,330 [R]`; RB fixture `+44 [R]`. | Recomputed from manifest byte counts. |
| CM_NOI01 output-byte deltas vs B | RA class `0 [R]`; RA fixture `−4 [R]`; RB class `0 [R]`; RB fixture `+35 [R]`. | Recomputed from manifest byte counts. |

The baseline and seeded-arm numerical source for the reconciliation and locked-field calculations is the frozen Results table. The fixture recomputations come from the complete raw F01–F14 rows. The cross-arm hash and byte recomputations use the arm manifests.

---

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate defines success as:

`H ⊆ D_abl`

and defines failure as:

`H \ D_abl ≠ ∅`.

From the raw seeded-arm evidence:

`H = {CM_NODUP, CM_NOTHIN}`

`D_abl = {CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01}`

Therefore:

`H \ D_abl = ∅`

and:

`H ⊆ D_abl`.

Accordingly, **P1 is satisfied under the frozen operational predicate**: both seeded arms that altered a locked production-output field were detected by the mechanical checks remaining after structural review was removed. CM_GT, CM_NOPARENT, and CM_NOI01 produced no locked-field production change and therefore do not count for or against P1.

---

## 5. Fixture and reconciliation implications.

The raw evidence separates the role of exact reconciliation from the role of the fixture suite.

**Exact key/label reconciliation did not expose any of the five common-mode seeds.** Every seeded arm remained at `recon_only_ra=0`, `recon_only_rb=0`, and `recon_disagree=0`. This includes the two harmful arms: CM_NODUP changed the key-set output on each implementation by 23,012 records, while CM_NOTHIN changed 6,377 classifications on each implementation. Because the same rule defect was seeded into both paths, the two implementations continued to agree with one another even while jointly differing from arm B.

The fixture suite supplied the actual detection for four seeds:

| Arm | Raw failing fixture on R-A | Raw failing fixture on R-B | Production locked-field effect |
| --- | --- | --- | --- |
| CM_GT | none | none | none |
| CM_NODUP | F07: expected `OUT_OF_SET`, observed `ESCALATE` | F07: expected `OUT_OF_SET`, observed `ESCALATE` | 23,012 added keys per path |
| CM_NOPARENT | F09: expected `INCONCLUSIVE`, observed `ESCALATE` | F09: expected `INCONCLUSIVE`, observed `ESCALATE` | none on frozen production pack |
| CM_NOTHIN | F06: expected `INCONCLUSIVE`, observed `ESCALATE` | F06: expected `INCONCLUSIVE`, observed `ESCALATE` | 6,377 changed labels per path |
| CM_NOI01 | F04: expected `INCONCLUSIVE`, observed `STANDARD` | F04: expected `INCONCLUSIVE`, observed `STANDARD` | none on frozen production pack |

The F07 failure for CM_NODUP is shown independently on both paths. The F09 failure for CM_NOPARENT is likewise duplicated across R-A and R-B. CM_NOTHIN fails F06 on both paths. CM_NOI01 fails F04 on both paths.

Thus, for the two harmful frozen seeds, **matching R-A/R-B key and label outputs alone would not have detected the defect; the retained fixtures did detect it**. That distinction matters because D_abl is operationally defined to include fixture failure, not merely cross-path reconciliation.

The persistent `dormant_h=1` and `open_age_h=2` cross-path mismatch pattern is unchanged from B through every seeded arm. It therefore provides no discrimination among these seeds and is not a seed-induced regression in this experiment.

---

## 6. Semantic/regression risks and unchanged surfaces.

**Semantic/regression risks.** First, the experiment establishes coverage only for the five frozen common-mode mutations. It does not establish that every possible shared logic error would be represented by F01–F14. In particular, CM_GT altered the implementation on both paths but changed neither the frozen production locked fields nor any fixture outcome, so that mutation is mechanically invisible in this particular pack.

Second, the structural review itself is explicitly **not executed or simulated by the runner**. Consequently, the `caught_with_control` field is `NA` throughout the seeded-arm table. The experiment directly tests the remaining mechanical regime; it does not empirically measure how often a human/model structural reading would identify these same seeds.

Third, the owner-language description refers to “matching totals” being sufficient, while the frozen D_abl operationalization is broader: a seed is counted as caught for a crash, a reconciliation key/label mismatch, **or a fixture failure**. The evidence therefore supports the exact frozen predicate involving the whole retained mechanical regime. It does not show that matching totals **by themselves** catch CM_NODUP or CM_NOTHIN; they do not.

Fourth, the harm definition is restricted to the frozen locked fields: SR_NUMBER key set, classification, dormant_h, and open_age_h. A seed that changes another semantic output but leaves those fields invariant would not enter H in this experiment.

Fifth, the baseline itself contains one dormant_h and two open_age_h R-A/R-B mismatches even though the accepted baseline key/label reconciliation is 0/0/0. Those discrepancies are frozen and invariant across arms, so they are not regressions attributable to the seeds; however, they demonstrate that “exact reconciliation” in the operational gate is narrower than literal equality over every reported numeric field.

**Unchanged surfaces.** The frozen source is unchanged: no source variants are used, and the source hashes for lineage, open candidates, and peer statistics are identical in B and all five seeded arms. The R-B configuration file and `run_RB.R` are also hash-identical throughout; only the declared seeded R-A implementation and R-B classification implementation are changed per arm.

All twelve recorded path executions exit zero. Arm B reproduces both frozen classification packs with zero key, label, dormant, and open-age differences versus their respective frozen references, and the baseline fixture suite is 14/14 on each implementation.

At the output-hash level, CM_GT is completely identical to B for all four listed outputs. CM_NOPARENT and CM_NOI01 retain B-identical production-classification hashes on both paths but change their fixture-result hashes. CM_NODUP and CM_NOTHIN change both production-classification hashes and both fixture-result hashes. Those hash relationships independently mirror the Results table's distinction between production-output harm and fixture-only detection.

---

## 7. Claim → evidence map.

| Claim | Frozen evidence location |
| --- | --- |
| ChatGPT's frozen role is Builder, with DeepSeek as Validator and Grok as Adjudicator; target is Stage 4 post-reconciliation review. | **SPEC → header / Roles / Target stage**, especially the role and target declarations. |
| C30 removes the structural cross-review and leaves successful execution, reconciliation, and fixtures as the operational mechanical regime. | **SPEC → Control under test; Exact change being tested.** |
| The five seeds are paired common-mode R-A/R-B rule changes. | **SPEC → Seeded common-mode errors**, CM_GT through CM_NOI01 declarations. |
| CM_GT changes `>=` to `>` in both implementations. | **SEED DIFFS → RA_GT and RB_GT hunks.** |
| CM_NODUP removes the duplicate exclusion in both implementations. | **SEED DIFFS → RA_NODUP and RB_NODUP hunks.** |
| CM_NOPARENT disables the I05 parent clause in both implementations. | **SEED DIFFS → RA_NOPARENT and RB_NOPARENT hunks.** |
| CM_NOTHIN disables the I04 thin-peer clause in both implementations. | **SEED DIFFS → RA_NOTHIN and RB_NOTHIN hunks.** |
| CM_NOI01 disables the open-plus-closed-date clause in both implementations. | **SEED DIFFS → RA_NOI01 and RB_NOI01 hunks.** |
| Arm B reproduces the frozen R-A and R-B packs with zero differences on every frozen-reference comparison field. | **C30_RESULTS.md → Arm B repro vs frozen pack → rows “B R-A vs frozen RA_classifications” and “B R-B vs frozen RB_classifications.”** |
| Baseline R-A/R-B reconciliation has 222,002 rows on each path, 222,002 inner rows, zero key-only and label disagreements, one dormant mismatch, and two open-age mismatches. | **C30_RESULTS.md → Arm B recon → sole data row.** |
| H is exactly `{CM_NODUP, CM_NOTHIN}`. | **C30_RESULTS.md → Seeded arms → CM_NODUP and CM_NOTHIN rows**, which are the only rows with nonzero locked-field changes and `harm=TRUE`. |
| D_abl is exactly `{CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01}`. | **C30_RESULTS.md → Seeded arms →** `caught_without_control` **column** for all five rows. |
| `H \ D_abl` is empty and therefore H is a subset of D_abl. | **SPEC → Operational benefit predicate P1**, combined with **C30_RESULTS.md → Mechanical facts H4–H6 / Seeded arms**. |
| CM_NODUP is detected by F07 on both paths. | **FIXTURE RESULTS → CM_NODUP RA F07 and RB F07 rows.** |
| CM_NOPARENT is detected by F09 on both paths. | **FIXTURE RESULTS → CM_NOPARENT RA F09 and RB F09 rows.** |
| CM_NOTHIN is detected by F06 on both paths. | **FIXTURE RESULTS → CM_NOTHIN RA F06 and RB F06 rows.** |
| CM_NOI01 is detected by F04 on both paths. | **FIXTURE RESULTS → CM_NOI01 RA F04 and RB F04 rows.** |
| CM_GT changes code but has no locked-field delta and no fixture failure in this pack. | **C30_RESULTS.md → Seeded arms → CM_GT row**, plus **FIXTURE RESULTS → CM_GT rows**. |
| Source hashes are constant across B and all seeded arms, and the only intended implementation-input differences are the paired seed files. | **ARM MANIFESTS → B, CM_GT, CM_NODUP, CM_NOI01, CM_NOPARENT, CM_NOTHIN input rows.** |
| CM_GT's four listed output hashes are identical to B; CM_NOPARENT and CM_NOI01 retain B-identical classification hashes; CM_NODUP and CM_NOTHIN change both classification outputs. | **ARM MANIFESTS → output rows for B and each seeded arm.** |
| The structural review itself is not simulated by the runner, so the experiment measures whether the remaining mechanical checks catch the common-mode mutations. | **SPEC → Exact change being tested / disclosure**, corroborated by **Seeded arms →** `caught_with_control=NA`. |

END C30 BUILDER REPORT
