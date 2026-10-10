# C29 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting as **Builder only**, making an **independent first pass** without access to any Validator first-pass output. The ablation is **C29**, owner Remaining Ablation Program catalog **#29, “Reconciliation Investigation,”** N15 batch 1 of 3, Constitution version 1.0, targeting **Stage 4 handling of R-A/R-B mismatches**. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

The frozen control requires that an R-A/R-B mismatch be **investigated and the affected path rerun with the defect removed**, with no averaging and no copying of IDs or labels from one side. C29 tests removing that behavior and replacing it with automatic shortcut resolution.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The ablation removes two linked safeguards: **investigation of why R-A and R-B disagree**, and **rerunning the defective path after correcting the defect**. In their place it freezes three automatic rules: `copy_RA`, `copy_RB`, and `max_severity`. `copy_RA` takes R-A's keys and labels; `copy_RB` takes R-B's; `max_severity` unions the keys and, for shared keys, chooses `ESCALATE > INCONCLUSIVE > STANDARD`.

The four seeded changes are exact one-line semantic mutations:

| Seed | Frozen code | Seeded code | Semantic effect |
| --- | --- | --- | --- |
| `X_RB_NODUP` | `in_decision <- is_open & !dup_flag & !leg_flag` | `in_decision <- is_open & !leg_flag` | R-B stops excluding DUPLICATE rows. |
| `X_RA_NODUP` | `exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open` | `exclude <- is_true_like(leg) | !in_envelope_open` | R-A stops excluding DUPLICATE rows. |
| `X_RB_NOTHIN` | `p_thin <- peer_n < RB_N_MIN` | `p_thin <- rep(FALSE, n)` | R-B disables the thin-peer condition. |
| `X_RA_NOTHIN` | `check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")` | `check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")` | R-A disables the thin/missing-peer check. |

These are the complete seeded code diffs shown in the packet.

Their frozen seed hashes are respectively `4f1d8422...f73ec69`, `94aef544...0e1421`, `487b769c...639ff`, and `65e90bf8...0f98b`, each distinct from its corresponding frozen path code hash.

## 3. Hard mechanical facts table.

For this table, define **D** as the set of frozen scenario×rule resolutions whose resulting **key set or classification differs from arm B truth**. Record-level SR_NUMBER memberships of the difference sets cannot be reconstructed from the packet because only counts, not differing IDs, are supplied.

| Mechanical fact | Recomputed result | Status / derivation |
| --- | --- | --- |
| Baseline framework hash comparisons | **2/2 equal** | **Recomputed** by string equality between the two SPEC hashes and the two baseline-hash rows. |
| Explicit frozen source/code hashes from SPEC reproduced in preflight | **5/5 equal** | **Recomputed** for `src_open_candidates`, `src_peer_stats`, R-A `run_RA.R`, R-B `00_config.R`, and R-B `20_integrity_and_classify.R`. |
| Arm B sizes | R-A **222,002**; R-B **222,002**; inner **222,002** | **Quoted** from B reconciliation. |
| Arm B agreement identity | `n_agree = 222,002 − 0 = 222,002`; `222,002 + 0 = 222,002` | **Recomputed** from `n_inner=222002`, `n_disagree=0`. |
| Arm B key union | **222,002** | **Recomputed:** `222002 + 0 + 0`. |
| Arm B fixtures | **28/28** combined | **Recomputed:** R-A 14/14 + R-B 14/14. Raw fixture rows independently contain 28 passing B rows. |
| Arm B reproduction vs frozen classifications | **10/10 comparison cells are zero** | **Recomputed:** two paths × five diff columns; every entry is 0. |
| Arm B key/label reconciliation | only-R-A **0**, only-R-B **0**, label-disagree **0** | **Quoted**. |
| Arm B full-field cross-path numeric reconciliation | dormant **1**, open-age **2**, total **3** | First two **quoted**; total **recomputed** as `1+2`. |
| Recorded path executions | **6/6 exit 0** total; **4/4 seeded runs recorded** | **Recomputed** from two B runs plus four seeded runs in the run log. |
| `X_RB_NODUP` path sizes | R-A **222,002**, R-B **245,014**, inner **222,002** | **Recomputed:** defective R-B = `222002+23012=245014`; R-A is B. |
| `X_RA_NODUP` path sizes | R-A **245,014**, R-B **222,002**, inner **222,002** | **Recomputed** symmetrically. |
| NODUP decision-set/portfolio delta | **+23,012 rows**, or **+10.3657%** versus 222,002 | **Recomputed:** `23012 / 222002 × 100`. Raw arm rows report 23,012 one-sided keys. |
| NODUP shared-key agreement identity | `n_agree=222,002`; `222,002 + 0 = 222,002` | **Recomputed** because `n_disagree=0` on the 222,002-key intersection. |
| `X_RB_NOTHIN` sizes | R-A **222,002**, R-B **222,002**, inner **222,002** | **Recomputed** from zero one-sided keys. |
| `X_RA_NOTHIN` sizes | R-A **222,002**, R-B **222,002**, inner **222,002** | **Recomputed** from zero one-sided keys. |
| NOTHIN agreement identity | `n_agree = 222,002 − 6,377 = 215,625`; `215,625 + 6,377 = 222,002` | **Recomputed** for each NOTHIN arm. |
| NOTHIN classification delta | **6,377 labels**, or **2.8725%** of the 222,002-key portfolio | Count **quoted**; percentage **recomputed**. |
| Seeded-path fixtures | **52/56 pass**, **4/56 fail** | **Recomputed:** four seeded paths ×14 fixtures, each 13/14. |
| All raw fixture executions, including B | **80/84 pass** | **Recomputed:** B contributes 28/28 and seeded paths 52/56. |
| Fixture failure distribution | F07: **2** failures; F06: **2** failures | **Recomputed:** F07 fails in both NODUP paths; F06 in both NOTHIN paths. |
| Harm set H | **4/4 arms:** `{X_RB_NODUP, X_RA_NODUP, X_RB_NOTHIN, X_RA_NOTHIN}` | **Recomputed** from every arm having `locked_field_changes_vs_B > 0`; matches H4. |
| Mismatch-visible set | **4/4**, same four arms | **Recomputed** from key/label reconciliation and fixture failures; matches H5. |
| `H − mismatch-visible` | **∅**, cardinality **0** | **Recomputed** set difference. |
| Arms with zero locked-field change | **∅**, cardinality **0** | **Recomputed** from the four raw arm rows. |
| Shortcut equality with truth | **4/12 equal**, **8/12 differ** | **Recomputed** from twelve raw resolution rows. This is **33.3333%** equal and **66.6667%** different. |
| `D_copy_RA` | `{X_RA_NODUP, X_RA_NOTHIN}`; **2/4** scenarios differ | **Recomputed** from `equals_truth=FALSE`. |
| `D_copy_RB` | `{X_RB_NODUP, X_RB_NOTHIN}`; **2/4** scenarios differ | **Recomputed**. |
| `D_max_severity` | all four seeded scenarios; **4/4** differ | **Recomputed**. |
| Full D set | **8 scenario×rule pairs** | **Recomputed:** 2 copy-R-A + 2 copy-R-B + 4 max-severity. |
| NODUP shortcut error cardinality when the defective side is propagated | **23,012** extra keys | **Quoted/recomputed** from each applicable resolution row. |
| NOTHIN defective-side copy error | **6,377** wrong labels | **Quoted** from the relevant `copy_RA`/`copy_RB` resolution rows. |
| NOTHIN `max_severity` residual error | **24** wrong labels per arm | **Quoted**; relative to 6,377 original disagreements, `6377−24=6,353` no longer differ from truth after the rule. |
| Cross-arm source-hash equality | **12/12 seeded-to-B comparisons equal** across the three common source inputs | **Recomputed:** four seeded arms × `src_extract_lineage`, `src_open_candidates`, `src_peer_stats`; manifest strings are identical. |
| Source variants used | **0** | **Quoted:** “no source variants used.” |
| Unseeded R-B code hash comparisons in R-B seed arms | **4/4 equal to B** | **Recomputed:** `00_config.R` and `run_RB.R` each remain identical in both R-B seed arms. |
| Seeded code comparison to B | **4/4 seeded code files differ** | **Recomputed:** two R-A `run_RA.R` hashes and two R-B `20_integrity_and_classify.R` hashes differ from the B versions. |
| Seeded-path output hashes vs corresponding B output | **8/8 differ** | **Recomputed:** classification + fixture output for each of four seeded path runs all have hashes different from the corresponding B file. |
| Read-only source preflight counts | open candidates **245,193**; peer stats **104** | **Quoted** from runner preflight. |

The exact recomputed full D set is:

`{X_RB_NODUP:copy_RB, X_RB_NODUP:max_severity, X_RA_NODUP:copy_RA, X_RA_NODUP:max_severity, X_RB_NOTHIN:copy_RB, X_RB_NOTHIN:max_severity, X_RA_NOTHIN:copy_RA, X_RA_NOTHIN:max_severity}`.

This independently reproduces the eight pairs listed mechanically by the runner.

## 4. P1 assessment against the frozen predicate in the SPEC.

The frozen P1 condition is explicit: **all 4 scenarios × all 3 shortcut rules = 12 resolutions must equal arm B in key set and classification**. A single differing resolution is sufficient for the alternative P1 condition.

The observed resolution matrix contains exactly **4 truth-equal results and 8 truth-different results**. The four truth-equal pairs are `X_RB_NODUP:copy_RA`, `X_RA_NODUP:copy_RB`, `X_RB_NOTHIN:copy_RA`, and `X_RA_NOTHIN:copy_RB`. In every case, the successful copy rule happens to copy the **unseeded/B side**. `max_severity` equals truth in **0/4** scenarios.

Therefore the observed matrix is **4/12 rather than the frozen requirement of 12/12**. The P1 condition specified at lines 61–62 is consequently not satisfied by the observed resolutions. No broader terminal disposition is made here.

## 5. Fixture and reconciliation implications.

The two seed families are mechanically distinct. Dropping DUPLICATE exclusion changes **set membership**: the defective path gains **23,012 keys**, while classifications on the 222,002 shared keys still agree. The corresponding semantic fixture is **F07**, which changes from expected `OUT_OF_SET` to observed `ESCALATE` on both seeded implementations.

Dropping the thin-peer clause leaves the key population unchanged but produces **6,377 classification disagreements**. Its semantic fixture is **F06**, which changes from expected `INCONCLUSIVE` to observed `ESCALATE` in both implementations.

Thus every seeded semantic defect is visible before shortcut resolution: the two NODUP arms expose a **23,012-key reconciliation mismatch plus F07 failure**, and the two NOTHIN arms expose a **6,377-label reconciliation mismatch plus F06 failure**. All four seeded executions nevertheless exit **0**, so none is represented by a process crash. The remaining checks therefore identify all four seeded defects mechanically.

A separate reconciliation fact must not be conflated with the seeds: clean arm B has exact key/classification reconciliation but already has **1** `dormant_h` **mismatch and 2** `open_age_h` **mismatches** between R-A and R-B. Those same counts, **1 and 2**, appear in every seeded arm. They are therefore unchanged cross-path numerical differences, not induced by any C29 seed.

The frozen P1 comparison itself is narrower than the full locked-field harm definition: P1 judges shortcut resolution against **arm B R-A key set and classification**, whereas the harm set also includes `dormant_h` and `open_age_h`.

## 6. Semantic/regression risks and unchanged surfaces.

| Surface | Evidence-based implication |
| --- | --- |
| Side-copy shortcut | The correctness of `copy_RA` versus `copy_RB` depends entirely on which side contains the defect. In the R-B-seeded cases, `copy_RA` is exact and `copy_RB` propagates the defect; in the R-A-seeded cases the relation reverses. The shortcut itself supplies no evidence identifying the defective side. |
| NODUP semantic risk | Copying the defective side or taking the union via `max_severity` retains all **23,012** erroneous extra keys. Thus severity ordering cannot repair a membership error. |
| NOTHIN semantic risk | Copying the defective side preserves **6,377** wrong classifications. `max_severity` reduces the difference to **24** labels but does not make the result identical to truth. |
| Fixture interaction | Every seed that produces a harmful output also produces an explicit semantic fixture failure—F07 for NODUP or F06 for NOTHIN. Automatic resolution without correction/rerun can therefore produce a truth-different resolved output even though the defect was already mechanically visible. |
| Crash surface | Unchanged: all six actual path runs exit 0. These are semantic defects rather than execution failures. |
| Source/data surface | Unchanged: no source variant is used, and all three common source-file hashes are identical across B and every seeded arm. |
| Seed scope | Each seeded arm changes only its declared defective R path: R-A `run_RA.R` for the two R-A seeds or R-B `20_integrity_and_classify.R` for the two R-B seeds. The nonseed R-B config and runner hashes remain identical where present. |
| Frozen baseline surface | B reproduces both frozen classification outputs with zero key, label, dormant, and open-age differences against each path's own frozen artifact. |
| Existing cross-path numeric differences | Unchanged: the **1 dormant / 2 open-age** R-A-vs-R-B differences occur in B and every seed. No C29 evidence attributes them to the ablation. |
| Remaining-check visibility | Unchanged detection coverage for these four seeds: all four belong to the mismatch-visible set and `H − mismatch-visible = ∅`. The observed risk is therefore not failure to expose these defects; it is the truth divergence produced by shortcut resolution after exposure. |

## 7. Claim → evidence map.

| Claim | Frozen evidence section and table row |
| --- | --- |
| C29 tests automatic shortcut resolution in place of investigation and rerun. | **SPEC → Control under test / Exact change being tested**, lines 34–42. |
| The four seeds are exactly removal of DUPLICATE exclusion or disabling of the thin-peer clause in one R path. | **SEED DIFFS**, hunks `RB_NODUP`, `RA_NODUP`, `RB_NOTHIN`, `RA_NOTHIN`, lines 509–550. |
| B has 222,002 rows on each path, no key/label disagreement, and 1/2 dormant/open-age mismatches. | **C29_RESULTS.md → Arm B recon**, row `222002 / 222002 / 222002 / 0 / 0 / 0 / 1 / 2`. |
| B reproduces each frozen path output exactly on all five comparison dimensions. | **C29_RESULTS.md → Arm B repro vs frozen pack**, rows `B R-A vs frozen RA_classifications` and `B R-B vs frozen RB_classifications`. |
| Each NODUP seed creates 23,012 extra keys and each NOTHIN seed creates 6,377 label differences. | **C29_RESULTS.md → Seeded arms**, rows `X_RB_NODUP`, `X_RA_NODUP`, `X_RB_NOTHIN`, `X_RA_NOTHIN`. |
| All four seeded arms are harmful and visible to the remaining checks. | **C29_RESULTS.md → Mechanical facts**, H4–H6. |
| NODUP breaks F07 and NOTHIN breaks F06 on both implementations. | **FIXTURE RESULTS**, rows `X_RB_NODUP/RB/F07`, `X_RA_NODUP/RA/F07`, `X_RB_NOTHIN/RB/F06`, `X_RA_NOTHIN/RA/F06`. |
| Exactly four of twelve automatic resolutions equal truth. | **C29_resolution.csv**, all twelve scenario×rule rows; recomputed TRUE count = 4 and FALSE count = 8. |
| `max_severity` differs from truth in every scenario. | **C29_resolution.csv**, the four `max_severity` rows: two with 23,012 extra keys and two with 24 label differences. |
| P1 requires all twelve resolutions to equal arm B. | **SPEC → Operational benefit predicate P1**, outcome definition at lines 58–63. |
| Sources are unchanged across arms and no source variant is used. | **SOURCE VARIANTS**, “no source variants used”; **ARM MANIFESTS**, identical source hashes in B and all four seeded arms. |
| The seeded code hashes differ while declared nonseed inputs remain unchanged. | **ARM MANIFESTS**, B and seeded input rows; **SPEC → Seeded mismatch scenarios** for declared seed hashes. |

END C29 BUILDER REPORT
