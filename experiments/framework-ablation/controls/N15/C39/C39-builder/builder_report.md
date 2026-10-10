## 1. Role attestation and ablation ID.

I am acting **only as the Builder** for an **independent first pass**, blind to the Validator. I am not performing terminal adjudication.

**Ablation:** C39 — Addendum 01, control #39, **“Reconciliation scope & tolerance.”**  
**Batch:** N15 batch 1 of 3.  
**Target:** Stage 4 reconciliation-field scope.  
**Builder:** ChatGPT.  
**Validator:** DeepSeek.  
**Adjudicator:** Grok.  
**Constitution:** version 1.0.  [source: C39_1_BUILDER_ChatGPT]

The frozen control requires R-A and R-B to reconcile the locked key set, `classification`, `dormant_h`, and `open_age_h`, with non-prediction numeric differences counted when `|d| > 1e-6`. The ablation removes `dormant_h` and `open_age_h` from gating: they remain reported, but only the key set and `classification` gate reconciliation. This pack contains no prediction fields.  [source: C39_1_BUILDER_ChatGPT]

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

### Conceptual diff

The control under test is the requirement that reconciliation protect **all four locked output surfaces**:

`SR_NUMBER key set` + `classification` + `dormant_h` + `open_age_h`.

The ablated regime removes the two reported numeric fields from the gating predicate. Under the ablation:

`SR_NUMBER key set` + `classification`

remain gating fields, whereas:

`dormant_h` + `open_age_h`

are still produced but no longer determine whether reconciliation catches an arm. This is explicitly narrower than the control and matches the frozen 2026-09-19 reconciliation practice described in the specification.  [source: C39_1_BUILDER_ChatGPT]

### Exact seeded changes

| Seed | Exact code change | Semantic target |
| --- | --- | --- |
| `R_ROUND1` | `dormant_h = dormant_h` → `dormant_h = round(dormant_h, 1)` | Changes the reported `dormant_h` precision after labels have already been computed. |
| `R_OPENAGE` | `open_age_h[has_created] <- rb_hours_diff(t_freeze, created_ts[has_created])` → `open_age_h[has_mod] <- rb_hours_diff(t_freeze, mod_ts[has_mod])` | Changes reported open age from elapsed time since creation to elapsed time since modification. |
| `R_GT` | `(dormant_h >= thresh)` → `(dormant_h > thresh)` | Changes the κ boundary comparison from inclusive to strict. |
| `R_NOTHIN` | `p_thin <- peer_n < RB_N_MIN` → `p_thin <- rep(FALSE, n)` | Eliminates the thin-peer integrity predicate from R-B. |

These are the only declared seed edits shown in the unified diffs.  [source: C39_1_BUILDER_ChatGPT]

## 3. Hard mechanical facts table.

| Hard mechanical fact | Result | Status | Recalculation / basis |
| --- | --- | --- | --- |
| Frozen `src_open_candidates.csv` rows | 245,193 | **Quoted** | Preflight reports 245,193. |
| Frozen `src_peer_stats.csv` rows | 104 | **Quoted** | Preflight reports 104. |
| Arm B R-A fixture passes | 14/14 | **Recomputed** | Counted 14 `TRUE` rows F01–F14 in raw fixture table. |
| Arm B R-B fixture passes | 14/14 | **Recomputed** | Counted 14 `TRUE` rows F01–F14. |
| B `n_ra` | 222,002 | **Quoted** | B reconciliation table. |
| B `n_rb` | 222,002 | **Quoted** | B reconciliation table. |
| B `n_inner` | 222,002 | **Quoted** | B reconciliation table. |
| B `n_only_ra` | 0 | **Quoted** | B reconciliation table. |
| B `n_only_rb` | 0 | **Quoted** | B reconciliation table. |
| B classification disagreements | 0 | **Quoted** | B reconciliation table. |
| B classification agreements | 222,002 | **Recomputed** | `222,002 - 0 = 222,002`; therefore `n_agree + n_disagree = 222,002 + 0 = n_inner`. |
| B `dormant_h` cross-path mismatches | 1 | **Quoted** | B full-field reconciliation. |
| B `open_age_h` cross-path mismatches | 2 | **Quoted** | B full-field reconciliation. |
| B R-A differences vs frozen R-A | key 0; label 0; dormant 0; open age 0 | **Quoted** | Arm-B reproduction table. |
| B R-B differences vs frozen R-B | key 0; label 0; dormant 0; open age 0 | **Quoted** | Arm-B reproduction table. |
| Seeded runs recorded | 4/4 | **Recomputed** | Four declared seeded arms each have an exit record: `R_ROUND1`, `R_OPENAGE`, `R_GT`, `R_NOTHIN`. |
| Seeded crashes | 0/4 | **Recomputed** | All four R-B runs have exit 0. |
| `R_ROUND1` fixtures | 14/14 | **Recomputed** | All F01–F14 raw fixture rows pass. |
| `R_OPENAGE` fixtures | 14/14 | **Recomputed** | All F01–F14 pass. |
| `R_GT` fixtures | 14/14 | **Recomputed** | All F01–F14 pass. |
| `R_NOTHIN` fixtures | 13/14 | **Recomputed** | Only F06 is `FALSE`; 13 other rows pass. |
| `R_ROUND1` locked-field changed rows vs B | 221,457 | **Recomputed** | R-B vs B has `dormant=221457`, all other compared changes 0. |
| `R_ROUND1` decision changes vs B | 0 | **Recomputed** | Key set and label deltas are both zero. |
| `R_ROUND1` changed share of 222,002 rows | 99.7545% | **Recomputed** | `221,457 / 222,002`. |
| `R_ROUND1` unchanged `dormant_h` rows | 545 | **Recomputed** | `222,002 - 221,457`. |
| `R_OPENAGE` locked-field changed rows vs B | 221,986 | **Recomputed** | R-B vs B has `open_age=221986`, all other compared changes 0. |
| `R_OPENAGE` decision changes vs B | 0 | **Recomputed** | Key set and label deltas are zero. |
| `R_OPENAGE` changed share of 222,002 rows | 99.9928% | **Recomputed** | `221,986 / 222,002`. |
| `R_OPENAGE` unchanged `open_age_h` rows | 16 | **Recomputed** | `222,002 - 221,986`. |
| `R_GT` locked-field changed rows vs B | 0 | **Recomputed** | R-B vs B shows zero key, label, dormant, and open-age changes. |
| `R_GT` decision changes vs B | 0 | **Recomputed** | Same comparison. |
| `R_NOTHIN` locked-field changed rows vs B | 6,377 | **Recomputed** | Exactly 6,377 label differences and zero other locked-field differences. |
| `R_NOTHIN` decision changes vs B | 6,377 | **Recomputed** | All 6,377 locked-field changes are classification changes. |
| `R_NOTHIN` decision-change share | 2.8725% | **Recomputed** | `6,377 / 222,002`. |
| `R_NOTHIN` classification agreements | 215,625 | **Recomputed** | `222,002 - 6,377`. |
| Harm set `H` | `{R_ROUND1, R_OPENAGE, R_NOTHIN}` | **Recomputed** | These and only these arms have a nonzero change on at least one locked field. |
| ` | H | ` | 3 |
| Arms with no locked-field change | `{R_GT}` | **Recomputed** | Its four locked-field deltas are all zero. |
| Reduced-regime detection set `D_abl` | `{R_NOTHIN}` | **Recomputed** | No crashes; only `R_NOTHIN` has a decision-field reconciliation difference and fixture failure. |
| ` | D_abl | ` | 1 |
| `H ∩ D_abl` | `{R_NOTHIN}` | **Recomputed** | Set intersection. |
| `H \ D_abl` | `{R_ROUND1, R_OPENAGE}` | **Recomputed** | Harmful locked-output changes not caught by reduced gating. |
| ` | H \ D_abl | ` | 2 |
| Full-control caught set | `{R_ROUND1, R_OPENAGE, R_GT, R_NOTHIN}` | **Recomputed** | Every seeded arm has at least one full-field R-A/R-B mismatch; `R_NOTHIN` additionally has classification and fixture failures. |
| Full-control caught count | 4 | **Recomputed** | Cardinality. |
| Full-control harmful catches | 3/3 | **Recomputed** | Intersection of full-control set with H equals all three H members. |
| Reduced-regime harmful catches | 1/3 | **Recomputed** | Only `R_NOTHIN`. |
| Incremental harmful catches supplied by full-field control | +2 | **Recomputed** | `3 - 1`. |
| Incremental total seeded catches supplied by full-field control | +3 | **Recomputed** | `4 - 1`; includes `R_GT`, which has no locked-field change vs B. |
| `R_GT` R-B classification output hash equals B | TRUE | **Recomputed** | Both are `a0e42b...e193`. |
| `R_GT` fixture-output hash equals B | TRUE | **Recomputed** | Both are `0d7224...e9e9`. |
| `R_ROUND1` classification hash equals B | FALSE | **Recomputed** | `08ab59...4609` vs `a0e42b...e193`. |
| `R_ROUND1` fixture hash equals B | TRUE | **Recomputed** | Both `0d7224...e9e9`. |
| `R_OPENAGE` classification hash equals B | FALSE | **Recomputed** | `58a44c...15f5` vs `a0e42b...e193`. |
| `R_OPENAGE` fixture hash equals B | TRUE | **Recomputed** | Both `0d7224...e9e9`. |
| `R_NOTHIN` classification hash equals B | FALSE | **Recomputed** | `f6611d...19f8` vs `a0e42b...e193`. |
| `R_NOTHIN` fixture hash equals B | FALSE | **Recomputed** | `22638d...21bb` vs `0d7224...e9e9`. |
| Frozen source/extract-lineage hashes equal across B and all four seeded arms | TRUE | **Recomputed** | Each common manifest entry repeats the same hash in all five arms. |
| `R-B/R/00_config.R` hash equal across B and all seeded arms | TRUE | **Recomputed** | All five use `6c9b0e...450b`. |
| `R-B/run_RB.R` hash equal across B and all seeded arms | TRUE | **Recomputed** | All five use `6786fc...efd`. |
| Seeded `20_integrity_and_classify.R` hash differs from B in each seeded arm | TRUE | **Recomputed** | All four seed hashes differ from B's `72ac5d...d99` and from one another. |

The baseline and seeded-arm reconciliation numbers are given in the runner result and raw-arm table.  [source: C39_1_BUILDER_ChatGPT] The raw arm rows independently expose each seed's locked-field delta, decision delta, fixture result, and detection flags.  [source: C39_1_BUILDER_ChatGPT]

The fixture recomputations come directly from the F01–F14 rows. Arm B passes every fixture on both paths; `R_ROUND1`, `R_OPENAGE`, and `R_GT` pass all R-B fixtures; `R_NOTHIN` fails only F06, where expected `INCONCLUSIVE` becomes `ESCALATE`.  [source: C39_1_BUILDER_ChatGPT]

The manifest hash comparisons show that source files, configuration, and `run_RB.R` are invariant across the arms, while each seed replaces `20_integrity_and_classify.R`; they also establish the output-hash equalities and differences above.  [source: C39_1_BUILDER_ChatGPT]

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate defines:

- `H` as seeded arms whose output differs from arm B on any locked field.
- `D_abl` as seeded arms caught without the full-field control: crash, decision-field reconciliation mismatch on key set/classification, or fixture failure.
- P1 is satisfied exactly when `H ⊆ D_abl`.
- P1 fails when `H \ D_abl` is non-empty.  [source: C39_1_BUILDER_ChatGPT]

From the raw arm evidence:

`H = {R_ROUND1, R_OPENAGE, R_NOTHIN}`

and

`D_abl = {R_NOTHIN}`.

Therefore:

`H \ D_abl = {R_ROUND1, R_OPENAGE}`

with cardinality 2.

Accordingly, **P1 is not satisfied** under its frozen definition. Two seeded arms change locked reported results while producing neither a crash, a decision-field reconciliation mismatch, nor a fixture failure.

`R_ROUND1` alters `dormant_h` on 221,457 rows while leaving classifications unchanged; `R_OPENAGE` alters `open_age_h` on 221,986 rows while leaving classifications unchanged. Both therefore belong to H under the frozen definition of a reported result, but neither belongs to `D_abl`.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

No terminal state is supplied here.

## 5. Fixture and reconciliation implications.

The fixtures and reconciliation channels protect different surfaces in this experiment.

`R_NOTHIN` demonstrates overlap between them. Removing the thin-peer integrity clause changes 6,377 classifications, produces 6,377 R-A/R-B classification disagreements, and causes F06 to change from expected `INCONCLUSIVE` to observed `ESCALATE`. Thus this decision defect is independently visible through both decision-field reconciliation and the behavioral fixture suite.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

By contrast, `R_ROUND1` and `R_OPENAGE` demonstrate a coverage gap in the fixture suite for the two reported numeric outputs. Each passes all 14 fixtures and preserves the entire classification key/label surface, yet changes a locked reported field on 221,457 and 221,986 rows respectively. Their output hashes also differ from B. Reduced reconciliation therefore supplies no detection channel for those two seeded reported-result defects.

`R_GT` behaves differently. Its seeded source code changes `>=` to `>`, but its R-B classification output and fixture-result files are byte-for-byte identical to B according to the manifest hashes, and all locked-field changes versus B are zero. It is consequently outside H. Nevertheless its R-A/R-B full-field reconciliation reports the same 1 `dormant_h` and 2 `open_age_h` mismatches seen on clean arm B, which causes the strict-control detection rule to flag it.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

The clean B pair itself is therefore important: key sets and classifications reconcile at 0/0/0, but full-field comparison is not numerically identical—there is 1 `dormant_h` mismatch and 2 `open_age_h` mismatches. The specification explicitly requires those full-field results to be reported in order to show whether the stricter regime raises an alarm on the clean pair.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk of the ablation is not loss of classification-defect detection in the supplied seeds; it is loss of protection for **reported locked numeric results**. In the frozen experiment, both `R_ROUND1` and `R_OPENAGE` establish that a large report-level corruption can leave the key set, classification, and fixtures unchanged. The ablated gate therefore cannot distinguish those altered reported outputs from an acceptable run.

There is also an observed cost on the stricter side: clean arm B contains 1 cross-implementation `dormant_h` difference and 2 `open_age_h` differences, despite reproducing each path's own frozen output exactly. Thus full-field cross-path exactness is stricter than frozen-path reproducibility. `R_GT` exposes the resulting behavior particularly clearly: its seeded R-B outputs are hash-identical to B, yet it inherits the clean-pair full-field discrepancies and is marked caught under the full-field rule.  [source: C39_1_BUILDER_ChatGPT]

The following surfaces remain unchanged across all seeded arms according to the manifests: frozen source extract lineage, `src_open_candidates.csv`, `src_peer_stats.csv`, `R-B/R/00_config.R`, and `R-B/run_RB.R`. No source variants were used. The only declared seeded input file is `R-B/R/20_integrity_and_classify.R`.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

All seeded executions completed with exit 0. Arm B reproduced each frozen R-A/R-B output on its own path with zero key, classification, dormant, or open-age differences, and both B paths passed 14/14 fixtures. The seeded execution therefore isolates the declared code variants rather than a changed source pack or an execution crash.  [source: C39_1_BUILDER_ChatGPT]  [source: C39_1_BUILDER_ChatGPT]

## 7. Claim → evidence map.

| Claim | Evidence section | Exact table / row evidence |
| --- | --- | --- |
| C39 removes `dormant_h` and `open_age_h` from gating while retaining key set and classification | SPEC → “Exact change being tested (ablation)” | Lines describing decision-driving fields and reported-but-nongating numeric fields.  [source: C39_1_BUILDER_ChatGPT] |
| `R_ROUND1` changes reporting precision only | SEED DIFFS | `dormant_h = dormant_h` → `round(dormant_h, 1)`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_OPENAGE` changes the basis of reported open age | SEED DIFFS | `created_ts`/`has_created` → `mod_ts`/`has_mod`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_GT` changes threshold inclusivity | SEED DIFFS | `>= thresh` → `> thresh`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_NOTHIN` disables the thin-peer predicate | SEED DIFFS | `peer_n < RB_N_MIN` → `rep(FALSE, n)`.  [source: C39_1_BUILDER_ChatGPT] |
| Arm B has 222,002 common keys and zero classification disagreements | C39_RESULTS → Arm B recon | Row with `n_ra=222002`, `n_rb=222002`, `n_inner=222002`, `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`.  [source: C39_1_BUILDER_ChatGPT] |
| Clean B has 1 dormant and 2 open-age full-field mismatches | C39_RESULTS → Arm B recon | Same row: `n_dormant_mismatch=1`, `n_open_age_mismatch=2`.  [source: C39_1_BUILDER_ChatGPT] |
| Arm B reproduces each frozen path output exactly | C39_RESULTS → Arm B repro | Both R-A and R-B comparison rows contain six zeros.  [source: C39_1_BUILDER_ChatGPT] |
| `R_ROUND1` changes 221,457 locked reported values but zero decisions | C39_arms.csv | `R_ROUND1` row: dormant=221457, `locked_field_changes_vs_B=221457`, `decision_changes_vs_B=0`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_OPENAGE` changes 221,986 locked reported values but zero decisions | C39_arms.csv | `R_OPENAGE` row: open_age=221986, `locked_field_changes_vs_B=221986`, `decision_changes_vs_B=0`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_GT` produces no locked-field or decision change | C39_arms.csv | `R_GT` row: all B-comparison deltas zero; locked and decision changes both zero.  [source: C39_1_BUILDER_ChatGPT] |
| `R_NOTHIN` changes 6,377 classifications | C39_arms.csv | `label=6377`, locked changes=6377, decision changes=6377.  [source: C39_1_BUILDER_ChatGPT] |
| `R_NOTHIN` is the sole seeded fixture failure | Fixture results | F06 expected `INCONCLUSIVE`, observed `ESCALATE`, pass=`FALSE`; its other fixture rows pass.  [source: C39_1_BUILDER_ChatGPT] |
| Other seeded R-B paths pass 14/14 fixtures | Fixture results | All F01–F14 rows for `R_ROUND1`, `R_OPENAGE`, and `R_GT` are TRUE.  [source: C39_1_BUILDER_ChatGPT] |
| `H={R_ROUND1,R_OPENAGE,R_NOTHIN}` | C39_RESULTS mechanical facts + recomputation from raw arm rows | H4 and nonzero locked-field deltas in the corresponding raw rows.  [source: C39_1_BUILDER_ChatGPT] |
| `D_abl={R_NOTHIN}` | C39_RESULTS mechanical facts + raw arm rows | H5 and `caught_without_control` column.  [source: C39_1_BUILDER_ChatGPT] |
| `H \ D_abl={R_ROUND1,R_OPENAGE}` | C39_RESULTS mechanical facts + set subtraction | H6.  [source: C39_1_BUILDER_ChatGPT] |
| P1 is not satisfied | SPEC P1 definition + recomputed H and D sets | Frozen rule says failure occurs when `H \ D_abl` is non-empty; the observed difference contains two arms.  [source: C39_1_BUILDER_ChatGPT] |
| `R_GT` classification and fixture files are hash-identical to B | ARM MANIFESTS | B hashes at output rows and identical `R_GT` hashes.  [source: C39_1_BUILDER_ChatGPT] |
| `R_ROUND1` and `R_OPENAGE` classification hashes differ from B while fixture hashes equal B | ARM MANIFESTS | Their classification hashes differ; both fixture hashes equal B's `0d7224...e9e9`.  [source: C39_1_BUILDER_ChatGPT] |
| `R_NOTHIN` classification and fixture hashes both differ from B | ARM MANIFESTS | `f6611d...` and `22638d...` versus B output hashes.  [source: C39_1_BUILDER_ChatGPT] |
| Source/config/runner surfaces are unchanged across the arms | ARM MANIFESTS | Same source, config, and `run_RB.R` hashes repeated in B and all seeded-arm manifests.  [source: C39_1_BUILDER_ChatGPT] |
| No source variants were used | SOURCE VARIANTS | Explicit `(no source variants used)`.  [source: C39_1_BUILDER_ChatGPT] |
| All four seeded runs completed | RUN LOG | Four seeded R-B executions, each exit=0.  [source: C39_1_BUILDER_ChatGPT] |

END C39 BUILDER REPORT
