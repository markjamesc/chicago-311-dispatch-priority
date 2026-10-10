## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for this independent first pass, blind to the Validator, and that I am not issuing an adjudicative terminal state. The ablation is **C26 — Frozen Source Package**, catalog #26, N15 batch 1 of 3. The packet assigns Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok, with Stage 4 source identity as the target.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

The frozen frameworks are:

| Artifact | Frozen SHA-256 |
| --- | --- |
| `three-ai-measurement-design-framework.md` | `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c` |
| `three-ai-validation-and-analysis-framework.md` | `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e` |

The frozen source package contains `src_open_candidates.csv` with **245,193 rows** and frozen SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`, plus `src_peer_stats.csv` with frozen SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.  [source: C26_1_BUILDER_ChatGPT]

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The frozen control requires both R-A and R-B to use the **identical verified source package**. Before either execution path runs, the SHA-256 of both source files is checked against the frozen record. C26 removes that source-checksum gate. Under the ablated regime, R-B can therefore read source bytes different from R-A's source and can still pass the frozen downstream regime if the run exits successfully, fixtures pass, and the frozen key/classification reconciliation is clean.  [source: C26_1_BUILDER_ChatGPT]

The **exact seeded code diff is empty**. `SEED DIFFS` states: **“(no code seeds; source variants only)”**. Thus C26 is not testing altered R logic; it is testing whether downstream execution, fixtures, and frozen reconciliation make the source-file identity check redundant.  [source: C26_1_BUILDER_ChatGPT]

The exact source mutations are:

| Arm | Exact seeded source change |
| --- | --- |
| `S_STALE24` | R-B's `src_open_candidates.csv` removes rows with `created_ts >= 2026-09-11 23:59:59`; **848 rows** removed. Variant SHA-256 `8268fb549b3a2def31922f8ae4d0e204b8edcc697ee7b858fc74edfbbe800e58`. `src_peer_stats.csv` remains frozen-hash-identical. |
| `S_PEER10` | `src_peer_stats.csv`: WCA2 `peer_p75_h` changes **2250 → 2475**, affecting a type with **72,732 in-set rows**. Variant peer hash `573b41327866314392c72176162c93d8d27b1cf4ae7f77c1b84baa1f13aa69b8`; open-candidate source remains frozen-hash-identical. |
| `S_ONEROW` | For `SR18-00191995`, `mod_ts` changes from `2020-02-13 17:43:49` to `2020-01-14 17:43:49`, with the corresponding `LAST_MODIFIED_DATE` moved 30 days earlier. Open-candidate variant hash `64b660283b781bc9c6057220df5b09be53a9bd330e6761573cc48a3a000b93df`. |
| `S_LF` | `src_open_candidates.csv` is re-saved from CRLF to LF. Data content is stated to be identical, but byte hash changes to `37f6de07df7324c790150986bc397348086b10619a3ce12d1e81bbdbcf13c7d0`. |
| `S_REVERSE` | Same open-candidate rows, but data rows are reversed. Hash becomes `a441b14eb120c50c64df4cd92dc4769c6cd799012689fbe478d8b649e6dce558`. |
| `S_BOOLCASE` | `DUPLICATE` and `LEGACY_RECORD` textual values change from `true/false` to `TRUE/FALSE`. Hash becomes `cf4ed65fe419eef300251e2fed955d246d839c8982de6d7a5858c5979bca041d`. |

These transformations and hashes were frozen before execution and re-verified immediately before the arms ran.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

## 3. Hard mechanical facts table.

Notation: **R = independently recomputed from the supplied evidence rows/hashes; Q = quoted because the underlying artifact needed to recompute the value itself is not present in the packet.**

| Hard mechanical fact | Result | Status |
| --- | --- | --- |
| Number of seeded arms in `C26_arms.csv` | **6** | R |
| Seeded arms with an execution record | **6/6** | R |
| Seeded RB executions with exit code 0 | **6/6** | R |
| Baseline executions with exit code 0 | RA **0**, RB **0** | Q |
| Raw baseline fixture rows | **28** = 14 RA + 14 RB | R |
| Raw seeded fixture rows | **84** = 6 × 14 RB | R |
| Total raw executed fixture rows | **112** | R |
| Total raw fixture passes | **112/112** | R |
| B RA fixtures | **14/14** | R |
| B RB fixtures | **14/14** | R |
| Each seeded RB fixture suite | **14/14**, 6/6 arms | R |
| B RA vs frozen RA: key/label/dormant/open-age differences | **0/0/0/0** | Q |
| B RB vs frozen RB: key/label/dormant/open-age differences | **0/0/0/0** | Q |
| B `n_ra` | **222,002** | Q |
| B `n_rb` | **222,002** | Q |
| B `n_inner` | **222,002** | Q |
| B `n_disagree` | **0** | Q |
| B `n_agree = n_inner − n_disagree` | **222,002** | R |
| B identity `n_agree + n_disagree = n_inner` | **222,002 + 0 = 222,002** | R |
| B `n_only_ra / n_only_rb / n_disagree` | **0/0/0** | Q |
| B RA↔RB dormant mismatch | **1** | Q |
| B RA↔RB open-age mismatch | **2** | Q |
| `S_STALE24` derived RB row count | **221,229 = 222,002 − 773** | R |
| `S_STALE24` derived `n_inner` | **221,229** | R |
| `S_STALE24` `n_agree + n_disagree = n_inner` | **221,229 + 0 = 221,229** | R |
| `S_STALE24` source rows removed | **848** | Q |
| `S_STALE24` removed source rows not represented as lost output keys | **75 = 848 − 773** | R |
| `S_STALE24` locked-field changes vs B | **773** | R |
| `S_STALE24` decision changes vs B | **773** | R |
| `S_PEER10` derived `n_inner` | **222,002** | R |
| `S_PEER10` classification agreements | **221,733 = 222,002 − 269** | R |
| `S_PEER10` identity | **221,733 + 269 = 222,002** | R |
| `S_PEER10` locked-field changes vs B | **269** | R |
| `S_PEER10` decision changes vs B | **269** | R |
| `S_ONEROW` derived `n_inner` | **222,002** | R |
| `S_ONEROW` identity | **222,002 + 0 = 222,002** | R |
| `S_ONEROW` locked-field changes vs B | **1** | R |
| `S_ONEROW` decision changes vs B | **0** | R |
| `S_LF` locked-field / decision changes | **0 / 0** | R |
| `S_REVERSE` locked-field / decision changes | **0 / 0** | R |
| `S_BOOLCASE` locked-field / decision changes | **0 / 0** | R |
| Sum of locked-field changes across seeded arms | **1,043 = 773 + 269 + 1** | R |
| Sum of decision changes across seeded arms | **1,042 = 773 + 269** | R |
| Locked-field changes not accompanied by a decision change | **1** | R |
| Harm set `H` | **{S_STALE24, S_PEER10, S_ONEROW}**, size **3** | R |
| `D_abl`, caught without checksum control | **{S_STALE24, S_PEER10}**, size **2** | R |
| `H ∩ D_abl` | **{S_STALE24, S_PEER10}**, size **2** | R |
| `D_abl \ H` | **∅**, size **0** | R |
| `H \ D_abl` | **{S_ONEROW}**, size **1** | R |
| Caught with checksum control | all **6/6** seeded arms | R |
| Harmful arms caught with checksum control | **3/3** | R |
| Non-harm arms caught with checksum control | **3/3** | R |
| Total detection-count delta, with vs without checksum | **+4 arms = 6 − 2** | R |
| Harmful-arm detection delta, with vs without checksum | **+1 arm = 3 − 2** | R |
| Additional no-locked-change catches due to checksum | **3 arms** | R |
| Seed arms whose `src_open_candidates.csv` hash equals B | **1/6** (`S_PEER10`) | R |
| Seed arms whose `src_peer_stats.csv` hash equals B | **5/6** (all except `S_PEER10`) | R |
| Seed arms with exactly one of the two principal source hashes changed | **6/6** | R |
| Seed arms with lineage hash equal to B | **6/6** | R |
| Listed R-B code-hash comparisons equal to B | **18/18** = 6 arms × 3 listed code files | R |
| Seed RB fixture-result output hashes equal to B fixture-result hash | **6/6** | R |
| Seed RB classification output hashes equal byte-for-byte to B | **2/6** (`S_LF`, `S_BOOLCASE`) | R |
| Seed arms with no locked-field change | **3/6** (`S_LF`, `S_REVERSE`, `S_BOOLCASE`) | R |
| No-change arm with a classification CSV byte hash different from B | **1/3** (`S_REVERSE`) | R |

The raw arm rows independently reproduce the reported set structure: `S_STALE24` has **773** RA-only keys; `S_PEER10` has **269** classification disagreements; `S_ONEROW` has neither key nor classification disagreement but changes one RB dormant value relative to B; the remaining three arms have zero locked-field changes.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

The baseline counts independently satisfy the requested identity. From `n_inner=222002` and `n_disagree=0`, `n_agree=222002`; therefore `222002 + 0 = 222002`. For `S_PEER10`, the same reconstruction gives `221733 + 269 = 222002`; for `S_STALE24`, `221229 + 0 = 221229`.  [source: C26_1_BUILDER_ChatGPT]

The hash comparisons are also mechanically informative. All six seeded R-B fixture-result files have exactly the B fixture-result hash `0d72245...`; `S_LF` and `S_BOOLCASE` also reproduce the exact B R-B classification-file hash `a0e42b...`. `S_REVERSE`, despite zero locked-field changes, has a different classification-file byte hash, consistent with the changed output ordering being byte-visible while the locked values remain equivalent.  [source: C26_1_BUILDER_ChatGPT]

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate is explicit:

**P1 is satisfied iff `H ⊆ D_abl`.**

The independently reconstructed sets are:

`H = {S_STALE24, S_PEER10, S_ONEROW}`

`D_abl = {S_STALE24, S_PEER10}`

Therefore:

`H \ D_abl = {S_ONEROW}`

and hence:

`H ⊆ D_abl = FALSE`.

Under the SPEC's frozen definition, **P1 is not satisfied**. The specific counterexample is `S_ONEROW`: it changes a locked field (`dormant_h`) relative to arm B but has exit 0, fixtures 14/14, zero key-set discrepancy, and zero classification disagreement, so it passes the defined no-check detection regime. The checksum-enabled regime catches it because its `src_open_candidates.csv` SHA-256 differs from the frozen source.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

The three no-harm variants do not enter the P1 inclusion test. `S_LF`, `S_REVERSE`, and `S_BOOLCASE` have zero locked-field changes, although the checksum control detects all three because their source bytes differ from the frozen package. This is exactly the separate byte-identity behavior the frozen SPEC says those variants are intended to expose.  [source: C26_1_BUILDER_ChatGPT]

## 5. Fixture and reconciliation implications.

The fixture suite supplies **no detection of any of the six source variants** in this experiment. Every executed seeded R-B path passes F01–F14, and all six seeded fixture-result output files are byte-identical to the baseline R-B fixture-result file. This includes all three harmed arms. Therefore, within this frozen test design, fixture success does not establish source identity and does not establish absence of locked-field divergence.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

The frozen key/classification reconciliation does catch two materially divergent source variants. `S_STALE24` produces **773 RA-only keys**, so the key-set reconciliation detects it. `S_PEER10` preserves the key set but produces **269 classification disagreements**, so classification reconciliation detects it.  [source: C26_1_BUILDER_ChatGPT]

`S_ONEROW` exposes the narrower coverage of that reconciliation. Its RB output differs from B on **one `dormant_h` value**, but there are **0 RA-only keys, 0 RB-only keys, and 0 classification disagreements**. Its RA↔RB dormant mismatch count is **2**, compared with baseline B's **1**, but the frozen `D_abl` definition does not treat dormant/open-age numeric reconciliation mismatches as a catch; it is defined using crash, key/label mismatch, or fixture failure. Thus the extra numeric divergence is observable in the supplied full-field diagnostics but does not enter the frozen no-check catch set.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

Arm B itself is mechanically stable against its frozen path-specific outputs: both B paths reproduce their corresponding frozen classifications with zero key, label, dormant, or open-age differences. At the same time, B's RA-vs-RB comparison contains one dormant and two open-age numeric mismatches. Those two facts are compatible: each current B path reproduces its own frozen reference, while the two independently implemented paths are not byte/numeric-identical on every full-field value. The frozen required B reconciliation gate is the reported **0/0/0 key/key/classification result**.  [source: C26_1_BUILDER_ChatGPT]

## 6. Semantic/regression risks and unchanged surfaces.

The primary semantic risk demonstrated by the ablation is **silent locked-field drift beneath successful execution, green fixtures, and clean key/classification reconciliation**. `S_ONEROW` is the concrete case: one source timestamp is moved 30 days earlier; the resulting RB classification file changes in a locked `dormant_h` field; the decision classification does not change; all fixtures remain green; and the frozen key/label reconciliation remains clean. Without source identity verification, those frozen downstream checks do not expose that source divergence.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

A second, opposite operational characteristic is that SHA-256 source identity is deliberately **stricter than semantic-output identity**. `S_LF`, `S_REVERSE`, and `S_BOOLCASE` have no locked-field changes, yet all are detected by the source check. `S_LF` changes only line endings; `S_REVERSE` preserves the same row set in a different order; `S_BOOLCASE` changes textual Boolean capitalization that the pipeline evidently normalizes without altering locked outputs. Thus a frozen byte-hash contract detects source-package reserialization and representational changes even when the specified analytical locked fields are invariant.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

`S_REVERSE` further shows why output-file SHA equality and locked-field semantic equality must not be conflated. Its locked-field delta is zero, but its R-B classification output hash differs from B. The altered row order is therefore visible at the file-byte level even though the locked comparison is unchanged. By contrast, `S_LF` and `S_BOOLCASE` reproduce the exact baseline R-B classification-output hash.  [source: C26_1_BUILDER_ChatGPT]

The unchanged surfaces supported by the evidence are substantial. There are no seeded code changes; all six seeded arms preserve the listed R-B hashes for `00_config.R`, `20_integrity_and_classify.R`, and `run_RB.R`; all six preserve the source-lineage hash; all six seeded executions exit 0; every executed fixture passes; and arm B reproduces both frozen path-specific classification packs. The preflight additionally reports the frozen source/code checks and read-only COUNT preflight as passing before execution.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT]

Accordingly, the observed C26 differences are isolated to the deliberately substituted source variants and their consequences. The evidence does not show a concurrent seeded implementation/code change.

## 7. Claim → evidence map.

| Claim | Frozen evidence location |
| --- | --- |
| C26 removes the pre-run source SHA-256 identity check and otherwise relies on exit, fixtures, and frozen reconciliation. | **SPEC → “Control under test” / “Exact change being tested”**, lines 34–40.  [source: C26_1_BUILDER_ChatGPT] |
| There are no seeded code changes. | **SEED DIFFS**, row `(no code seeds; source variants only)`, lines 552–553.  [source: C26_1_BUILDER_ChatGPT] |
| All six seeded runs were recorded and exited 0. | **RUN LOG**, rows `S_STALE24` through `S_BOOLCASE`, lines 305–314; **C26_RESULTS H3**, line 326.  [source: C26_1_BUILDER_ChatGPT] |
| Arm B reproduces each frozen path-specific output with zero locked-field differences and has key/key/classification recon 0/0/0. | **C26_RESULTS H2** and **Arm B repro / Arm B recon** rows, lines 323–343.  [source: C26_1_BUILDER_ChatGPT] |
| Harm set is `{S_STALE24,S_PEER10,S_ONEROW}`. | **C26_RESULTS H4**, line 327; **Seeded arms** rows `S_STALE24`, `S_PEER10`, `S_ONEROW`, lines 348–350.  [source: C26_1_BUILDER_ChatGPT] |
| No-check catch set is `{S_STALE24,S_PEER10}`. | **C26_RESULTS H5**, line 328; **C26_arms.csv** rows `S_STALE24` and `S_PEER10`, lines 359–360.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT] |
| `S_ONEROW` is the single member of `H \ D_abl`. | **C26_RESULTS H6**, line 329; **C26_arms.csv** row `S_ONEROW`, line 361.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT] |
| `S_ONEROW` changes one locked field but zero decisions and is not caught without the checksum control. | **Seeded arms** row `S_ONEROW`, line 350; raw **C26_arms.csv** row, line 361.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT] |
| `S_LF`, `S_REVERSE`, and `S_BOOLCASE` have zero locked-field changes. | **C26_RESULTS H7** and seeded-arm rows, lines 330–353.  [source: C26_1_BUILDER_ChatGPT] |
| The checksum-enabled regime detects all six seeded source variants, including the three with no locked-field changes. | **C26_RESULTS H8–H9**, lines 331–332; seeded-arm `caught_with_control` column, lines 348–353.  [source: C26_1_BUILDER_ChatGPT] |
| Every executed fixture passes. | **FIXTURE RESULTS**, B RA/RB and six seeded RB blocks, lines 367–480.  [source: C26_1_BUILDER_ChatGPT] |
| Seeded fixture output hashes are identical to B's fixture-output hash. | **ARM MANIFESTS**, B fixture hash and seeded fixture hashes, lines 498–549.  [source: C26_1_BUILDER_ChatGPT] |
| All listed seeded R-B code hashes remain equal to B. | **ARM MANIFESTS**, `00_config.R`, `20_integrity_and_classify.R`, `run_RB.R` rows for B and each seeded arm, lines 491–549.  [source: C26_1_BUILDER_ChatGPT] |
| Formal P1 condition is `H ⊆ D_abl`; arms with no locked-field change are excluded from the predicate. | **SPEC → Operational benefit predicate P1**, lines 71–79.  [source: C26_1_BUILDER_ChatGPT] |
| The reconstructed sets make `H ⊆ D_abl` false because `S_ONEROW ∈ H \ D_abl`. | Derived from **C26_RESULTS H4–H6** and raw **C26_arms.csv** rows.  [source: C26_1_BUILDER_ChatGPT]  [source: C26_1_BUILDER_ChatGPT] |

END C26 BUILDER REPORT
