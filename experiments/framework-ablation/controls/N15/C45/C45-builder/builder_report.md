# C45 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as Builder** for **C45 — Addendum 02, candidate #45, “Parallel R-A/R-B runs.”** I am performing an independent first pass and am blind to the Validator. I do not issue an adjudicative terminal state. The frozen role assignment is Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok.

Ablation ID: **C45**.  
Target stage: **Stage 4 execution scheduling**.  
Frozen constitution version: **1.0**.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The control under test is discretionary **serialization** of the independent R-A and R-B executions. The ablation replaces that scheduling constraint with concurrent launch of both paths on the same frozen arm copy, after a declared physical-memory check. The analytical paths themselves, their fixtures, and their pipelines remain otherwise frozen.

The exact seeded code change is **none**. The SEED DIFFS explicitly state “no code seeds”; the source-variant section also states that **no source variants were used**. Therefore the analytical-code diff and source-data diff are both empty. The experimental treatment is runner-level scheduling: PAR arms launch R-A and R-B concurrently, whereas B/SER arms launch R-A and then R-B.

The runner-side control artifacts are `ARMS.tsv` and the `PARALLEL` marker/configuration artifact; they do not alter the frozen R-A/R-B analytical implementation.

## 3. Hard mechanical facts table.

| ID | Hard mechanical fact | Result | Basis |
| --- | --- | --- | --- |
| H1 | Arms executed | 6 total: 3 serial, 3 concurrent | **Recomputed** from B, PAR_1, SER_2, PAR_2, SER_3, PAR_3 |
| H2 | Path executions | 12 total | **Recomputed:** 6 arms × 2 paths |
| H3 | Non-zero exits | 0/12 | **Recomputed** from all `ra_exit` and `rb_exit` values |
| H4 | Serial wall-clock observations | 36.4, 37.8, 37.8 s | **Quoted** from raw arm table |
| H5 | Serial median wall-clock | 37.8 s | **Recomputed** as median(36.4, 37.8, 37.8) |
| H6 | Concurrent wall-clock observations | 29.4, 27.1, 26.6 s | **Quoted** from raw arm table |
| H7 | Concurrent median wall-clock | 27.1 s | **Recomputed** as median(29.4, 27.1, 26.6) |
| H8 | Concurrent/serial median ratio | 0.716931… ≈ **0.717** | **Recomputed:** 27.1 / 37.8 |
| H9 | Median wall-clock reduction | **10.7 s**, or **28.31%** | **Recomputed:** 37.8 − 27.1; 1 − 27.1/37.8 |
| H10 | Serial R-A median duration | 11.3 s | **Recomputed** from 10.7, 11.3, 11.5 |
| H11 | Concurrent R-A median duration | 12.1 s | **Recomputed** from 13.4, 12.1, 11.9 |
| H12 | Serial R-B median duration | 25.7 s | **Recomputed** from 25.0, 26.0, 25.7 |
| H13 | Concurrent R-B median duration | 26.9 s | **Recomputed** from 28.5, 26.9, 26.4 |
| H14 | Serial maximum peak working set | 718 MB | **Recomputed** from 718, 714, 718 |
| H15 | Concurrent maximum peak working set | 1,011 MB | **Recomputed** from 1,011, 1,006, 997 |
| H16 | Maximum-memory increase | **293 MB / 40.81%** | **Recomputed:** 1,011 − 718; 1,011/718 − 1 |
| H17 | Declared memory requirement | **3,484 MB** | **Recomputed:** 2 × 718 + 2,048 |
| H18 | Free memory used by pre-run memory check | 15,399 MB | **Quoted** |
| H19 | Memory-check headroom | **11,915 MB** | **Recomputed:** 15,399 − 3,484 |
| H20 | Free-memory / requirement ratio | **4.420×** | **Recomputed:** 15,399 / 3,484 |
| H21 | Fixture executions | **168** | **Recomputed:** 6 arms × 2 paths × 14 fixtures |
| H22 | Passing fixture executions | **168/168** | **Recomputed** from all raw fixture rows |
| H23 | Per-arm/per-path fixture result | **14/14 for all 12 arm/path pairs** | **Recomputed** from raw fixture rows |
| H24 | Seven key output files across arms | Each key path has **6 instances and exactly 1 unique SHA-256** | **Recomputed** from arm manifests |
| H25 | Concurrent-vs-serial key-output file D-set | **∅ for all seven key outputs** | **Recomputed:** byte-identical SHA-256 per corresponding file across all arms |
| H26 | Input-file invariance | **9 input files; each has 6 instances and exactly 1 unique SHA-256** | **Recomputed** from arm manifests |
| H27 | Runner-reported equality to frozen outputs | **7/7 in every arm** | **Quoted** from `C45_arms.csv` |
| H28 | Frozen classification hash equality independently checkable | **2/2 classification outputs match the explicitly listed frozen hashes** | **Recomputed** by comparing PREFLIGHT frozen hashes with arm-manifest hashes |
| H29 | Remaining five key-output comparisons to frozen references | **Not independently hash-recomputable from displayed raw frozen hashes** | Frozen reference hashes for the five non-classification outputs are not separately printed; their 7/7 frozen equality is runner-reported |
| H30 | R-A portfolio concurrent-vs-serial delta | **0 at byte/file level** | **Recomputed:** `RA_portfolio_counts.csv` has one SHA-256 across all six arms |
| H31 | R-B portfolio concurrent-vs-serial delta | **0 at byte/file level** | **Recomputed:** `RB_portfolio_counts.csv` has one SHA-256 across all six arms |
| H32 | Portfolio metric-value deltas | **Not separately recomputable** | Actual portfolio-count rows are not printed; byte identity establishes no arm-to-arm change but does not expose the component values |
| H33 | Frozen reconciliation key/classification D-set | **only-RA = ∅; only-RB = ∅; classification disagreements = ∅** | **Quoted** from Coordinator Note N1’s frozen reconciliation definition |
| H34 | Full-field `dormant_h` mismatch set | `{SR22-01936870}`, size **1** | **Quoted**, size recomputed from listed IDs |
| H35 | Full-field `open_age_h` mismatch set | `{SR25-02017553, SR25-02017556}`, size **2** | **Quoted**, size recomputed from listed IDs |
| H36 | Full-field clock-mismatch union | size **3** | **Recomputed:** 1 + 2 = 3; three distinct listed IDs |
| H37 | Size of each clock discrepancy | exactly **1.000 h** | **Quoted** |
| H38 | Classification effect of the three clock discrepancies | **0 label disagreements** | **Quoted:** all three labels agree |
| H39 | `n_agree + n_disagree = n_inner` identity | **Not independently recomputable from this packet** | `n_agree`, `n_disagree`, and `n_inner` values are not printed in the supplied evidence |
| H40 | Source COUNT preflight | `src_open_candidates = 245,193`; `src_peer_stats = 104` | **Quoted** from preflight |
| H41 | Code seeds | **0** | **Quoted** from SEED DIFFS |
| H42 | Source variants | **0** | **Quoted** from SOURCE VARIANTS section |

The timing, exit, memory, and `outputs_equal_*` source rows are the raw six-arm table. The fixture table contains six arms × two paths × fourteen fixtures, all marked `TRUE`. The manifests show the same seven protected output hashes and the same frozen analytical-input hashes in every arm.

The seven independently cross-arm-invariant key-output hashes are:

| Key output | Unique SHA-256 across all six arms |
| --- | --- |
| `R-A/outputs/RA_classifications.csv` | `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9` |
| `R-A/outputs/RA_fixture_results.csv` | `33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110` |
| `R-A/outputs/RA_portfolio_counts.csv` | `b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3` |
| `R-B/outputs/RB_classifications.csv` | `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` |
| `R-B/outputs/RB_fixture_results.csv` | `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9` |
| `R-B/outputs/RB_portfolio_counts.csv` | `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c` |
| `R-B/outputs/RB_kappa_grid_counts.csv` | `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` |

Thus concurrency produced no byte-level difference in any protected output relative to the serial arms. The raw `PERF.csv`, exit-record, and stderr hashes are not invariant, which is expected because they contain run-specific operational information; they are not among the seven protected analytical outputs.

## 4. P1 assessment against the frozen predicate in the SPEC.

The frozen P1 requires three mechanical facts: every arm must exit zero on both paths; every concurrent arm's seven key outputs must be byte-identical to serial and frozen outputs; and the concurrent median wall-clock must be below the serial median.

**Exit clause:** all twelve path executions have exit code 0. There are no missing exit records in the arm table.

**Output-identity clause:** cross-arm manifest comparison independently shows that each of the seven protected output paths has one and only one SHA-256 across B, the two additional serial arms, and all three concurrent arms. Therefore the serial-versus-concurrent difference set for the seven protected files is empty. The arm table additionally records `outputs_equal_frozen = 7/7` for every arm and `outputs_equal_serial = TRUE` for every arm. For the two classification outputs, equality to the explicitly printed frozen reference hashes is directly independently reproducible from the packet. For the other five key outputs, the packet gives the runner's 7/7 frozen comparison but does not separately print the five frozen-reference hashes, so that portion is quoted rather than independently re-derived from two raw hash lists.

**Timing clause:** serial wall times are 36.4, 37.8, and 37.8 seconds, giving a recomputed median of 37.8 seconds. Concurrent wall times are 29.4, 27.1, and 26.6 seconds, giving a recomputed median of 27.1 seconds. Therefore 27.1 < 37.8. The recomputed ratio is 0.716931…, reported as 0.717, corresponding to a 10.7-second or 28.31% reduction in median wall-clock.

**Memory prerequisite:** the declared requirement recomputes to 3,484 MB from `2 × 718 + 2,048`. The measured free memory before the first concurrent arm was 15,399 MB, leaving 11,915 MB of headroom. The prerequisite therefore evaluated true before concurrent execution. The actual observed concurrent maximum peak working set was 1,011 MB.

Accordingly, the evidence records all mechanical P1 clauses as true for this execution, subject to the distinction above between independently recomputed cross-arm hashes and the runner-reported five non-classification comparisons against frozen reference files.

## 5. Fixture and reconciliation implications.

The fixture evidence is completely invariant with respect to scheduling. Each of the six arms executes fourteen R-A fixtures and fourteen R-B fixtures. All **168 observed fixture rows equal their path-specific expected value and all 168** `pass` **fields are** `TRUE`. This independently recomputes to 14/14 for every arm/path pair.

F14 remains intentionally path-specific: R-A expects and observes `TWO_INDEPENDENT_LABELS`, while R-B expects and observes `STANDARD|STANDARD`. This is not an arm-induced discrepancy; the same path-specific fixture result recurs in every serial and concurrent arm.

At the frozen reconciliation level, Coordinator Note N1 states that the operative reconciliation is key-set equality plus classification disagreement. That reconciliation is 0/0/0: no R-A-only keys, no R-B-only keys, and no classification disagreements. The separate full-field comparison contains the already-known three one-hour clock discrepancies: one `dormant_h` row and two `open_age_h` rows. Their three service-request IDs are fixed, and all three classification labels agree.

Because each arm's R-A classifications file is byte-identical to B's R-A classifications file and each arm's R-B classifications file is byte-identical to B's R-B classifications file, scheduling cannot have introduced a new row, removed a row, or altered a classification relative to the serial reference. The known 1/2 full-field clock pattern is therefore an unchanged frozen-pack characteristic rather than an observed concurrency effect.

The packet does not print `n_inner`, `n_agree`, or `n_disagree`, so the requested arithmetic identity involving those quantities cannot be independently recomputed. Likewise, the internal portfolio-count rows are not reproduced, so individual portfolio components cannot be arithmetically differenced; their corresponding files are nevertheless byte-identical across every arm, which establishes zero arm-to-arm portfolio-file change.

## 6. Semantic/regression risks and unchanged surfaces.

The principal unchanged surfaces are strong. All nine manifested analytical/source inputs have one hash each across all six arms; no source variant was used; no analytical code seed was introduced; all seven protected outputs have one hash each across all arms; and all 168 fixtures pass. The two classification outputs also reproduce the explicitly listed frozen classification hashes. Thus the tested variation is isolated to scheduling rather than data or analytical logic.

The principal operational tradeoff is memory. Maximum observed R-process working set rises from 718 MB in serial execution to 1,011 MB in concurrent execution, a recomputed increase of 293 MB or 40.81%. On the tested machine this remained far below the declared memory allowance, but this is a real changed resource surface even though analytical outputs are unchanged.

Individual paths also run somewhat longer under concurrency: the R-A median rises from 11.3 to 12.1 seconds and the R-B median from 25.7 to 26.9 seconds. The total wall-clock still falls because the paths overlap. This is consistent with modest resource contention that is more than offset by parallel execution in the observed runs.

Timing evidence consists of three serial and three concurrent measurements on the same PC. The arms were interleaved to reduce machine-drift confounding, which is preferable to running all serial observations followed by all concurrent observations, but the evidence does not establish performance on other machines, under other concurrent workloads, or under materially different future R memory requirements.

The known full-field clock discrepancy remains semantically relevant outside the frozen reconciliation definition. Three frozen rows differ by exactly one hour between R-A and R-B while their labels agree. The probable daylight-saving explanation is explicitly unconfirmed. C45 neither repairs nor amplifies that pre-existing issue; it only demonstrates that the issue is unchanged under the tested execution schedule.

A further regression risk is future shared mutable state. These runs show no collision or nondeterministic output when the current R-A and R-B implementations execute concurrently on the same arm copy. If future code introduces common temporary filenames, shared writable state, competing external connections, or materially larger memory footprints, the concurrency property would need renewed verification; C45 mechanically establishes the behavior of the frozen implementation, not all possible future implementations.

Finally, the packet's raw manifests allow independent cross-arm comparison of all seven protected hashes, but only the two classification frozen-reference hashes are explicitly exposed as separate frozen hashes. Therefore the five other `7/7` comparisons against frozen outputs rely on the runner's recorded frozen-comparison field rather than an independently repeatable hash-string comparison within this packet. That distinction does not affect the independently established serial-versus-concurrent byte identity.

## 7. Claim → evidence map.

| Claim | Evidence section | Exact table/row evidence |
| --- | --- | --- |
| C45 changes scheduling from serialized to concurrent R-A/R-B execution | SPEC — “Control under test” / “Exact change being tested” | B/SER described as sequential; PAR arms described as concurrent; memory check declared before concurrent execution. |
| No analytical code seed is introduced | SEED DIFFS | `(no code seeds; source variants only)`; SOURCE VARIANTS separately records none used. |
| All twelve R executions exit zero | `C45_arms.csv` | Rows B, PAR_1, SER_2, PAR_2, SER_3, PAR_3: both exit columns are 0. |
| Serial median is 37.8 s | `C45_arms.csv` | B = 36.4, SER_2 = 37.8, SER_3 = 37.8; recomputed median = 37.8. |
| Concurrent median is 27.1 s | `C45_arms.csv` | PAR_1 = 29.4, PAR_2 = 27.1, PAR_3 = 26.6; recomputed median = 27.1. |
| Concurrent/serial median ratio is approximately 0.717 | `C45_arms.csv` | Recomputed `27.1 / 37.8 = 0.716931…`; RESULTS H3 reports 0.717. |
| Memory requirement is 3,484 MB and available memory is 15,399 MB | RUN LOG / RESULTS memory check | `serial_peak=718`, `need=3484`, `free=15399`. |
| Concurrent maximum peak working set is 1,011 MB versus serial maximum 718 MB | `C45_arms.csv` | Peak rows: serial 718/714/718; concurrent 1011/1006/997. |
| All fixtures pass in all arms | FIXTURE RESULTS | B through PAR_3, both paths, F01–F14: every `pass=TRUE`; recomputed 168/168. |
| The seven protected outputs are byte-identical across all six arms | ARM MANIFESTS | The same seven per-path output SHA-256 values recur under B, PAR_1, PAR_2, PAR_3, SER_2, SER_3. |
| Concurrent-vs-serial portfolio delta is zero at file level | ARM MANIFESTS | `RA_portfolio_counts.csv` always `b5888d…`; `RB_portfolio_counts.csv` always `eb677b…`. |
| All manifested analytical/source inputs are invariant across arms | ARM MANIFESTS | Nine input paths repeat with one hash apiece in B and every SER/PAR arm. |
| Runner records all seven protected outputs equal to frozen in every arm | `C45_arms.csv` | `outputs_equal_frozen = 7/7` in every row. |
| R-A and R-B classification outputs directly reproduce their explicit frozen hashes | PREFLIGHT + ARM MANIFESTS | Frozen RA hash `c099e0…`, frozen RB hash `a0e42b…`; the same hashes occur in every arm manifest. |
| Frozen key/classification reconciliation has no differences | Coordinator Note N1 / SPEC Known open finding N1 | Frozen definition is only-RA, only-RB, classification disagreements; note states clean reconciliation is 0/0/0. |
| Full-field reconciliation retains three known one-hour differences | Coordinator Note N1 | `dormant_h`: SR22-01936870; `open_age_h`: SR25-02017553 and SR25-02017556; labels agree. |
| C45 does not expose raw values needed for `n_agree + n_disagree = n_inner` or component-level portfolio arithmetic | Evidence supplied in packet | Fixture, arm, and manifest tables are supplied, but no `n_inner/n_agree/n_disagree` table and no portfolio-count contents are printed; those quantities therefore remain uncomputed rather than inferred. |

END C45 BUILDER REPORT
