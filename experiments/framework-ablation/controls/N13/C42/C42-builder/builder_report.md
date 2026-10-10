# C42 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting solely as **Builder** for **C42**, Addendum 01 control #42, “Batched owner rulings.” This is an independent first pass; I am blind to the Validator’s first-pass output and am not acting as Validator or Adjudicator. The assigned roles in the frozen specification are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

C42 tests whether owner questions that otherwise surface piecemeal can instead be collected into a pre-reconciliation batch for Q1–Q3, with a second post-run batch for Q4–Q5 when those questions cannot exist before execution. The measured quantities are interruptions, repair rounds, unresolved gating questions, equality of final outputs, and validity of the switched-but-unswitched R0 arm.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C42 removes **piecemeal owner interruption as the default timing model**. Under the baseline model, every arising question interrupts the owner independently, and every separately arriving gating answer produces a repair round. Under the variant, Q1–Q3 are consolidated into round A before reconciliation and Q4–Q5 into round B after execution. It does not eliminate the later round for questions that are definitionally post-run.

| Seeded surface | Exact seeded change |
| --- | --- |
| `RB_RULED__20_integrity_and_classify.R` | Reads comma-separated switches from environment variable `C42_RULINGS`; no switches is intended to preserve frozen behavior byte-for-byte. |
| Q1B | When no earlier integrity clause exists and `peer_p75 == 0`, assigns `I07_zero_peer_p75`. This changes the frozen default from reaching the κ rule and becoming ESCALATE to becoming INCONCLUSIVE. |
| Q2A | Defines `open_like <- startsWith(tolower(status_norm), "open") & !is_open`; when Q2A is active, assigns `I08_open_like_status` and admits those open-like records into `in_decision`. |
| Q3A | No executable semantic change is added: existing `rb_truthy()` already interprets blank as false/not-duplicate. |
| Decision membership | Changes `in_decision <- is_open & !dup_flag & !leg_flag` to include `open_like` when Q2A is active. |
| `q_probe.R` | New read-only probe for whether Q1–Q5 arise, including Q4 dominance and Q5 R-A↔R-B reason-code correspondence. |
| `ARMS.tsv` | Defines R0, PM_1, PM_12, PM_123, and BATCH, with PM_123 and BATCH as the two final regimes. |
| `SEEDFILE` | Maps the ruled classification file onto `R-B\R\20_integrity_and_classify.R`. |
| `PLAYBACK.json` | Freezes answers `1B 2A 3A 4A 5A`, question surfaces, the two batching rounds, builder defaults, comparison arms, and report-only treatment for Q4/Q5. |
| `dom_check.R` | New read-only #47 dominance check: eligible type share `>1/3`, with total ESCALATE ≥1000 and type count ≥30; a flag is reported/routed but does not remove or alter rows. |

The executable classification diff is exactly the switch parsing, Q1B integrity clause, Q2A `open_like` clause, and Q2A decision-set inclusion shown above; Q3A is explicitly documented as requiring no code change. The remaining new runner-side seed files are the probe, arm definition, seed mapping, playback declaration, and dominance checker.

## 3. Hard mechanical facts table.

| Mechanical fact | Recalculation / evidence | Result | Status |
| --- | --- | --- | --- |
| Frozen source row count from DUPLICATE values | 222,176 false + 23,017 true | **245,193** | **Recomputed** |
| STATUS population | Probe reports `Open=245193` | **245,193** | Quoted |
| R0 decision partition identity | 131,968 ESCALATE + 6,377 INCONCLUSIVE + 83,657 STANDARD | **222,002** | **Recomputed** |
| Ruled decision partition identity | 131,939 + 6,406 + 83,657 | **222,002** | **Recomputed** |
| R0 full source partition | 222,002 decision + 23,191 out-of-set | **245,193** | **Recomputed** |
| Ruled full source partition | 222,002 + 23,191 | **245,193** | **Recomputed** |
| Portfolio Δ, ruled − R0 | decision 0; ESCALATE 131,939−131,968; INCONCLUSIVE 6,406−6,377; STANDARD 0; out-of-set 0 | **0, −29, +29, 0, 0** | **Recomputed** |
| κ=1 identity, R0 | 152,292 + 6,377 + 63,333 | **222,002** | **Recomputed** |
| κ=1 identity, ruled | 152,263 + 6,406 + 63,333 | **222,002** | **Recomputed** |
| κ=1.5 identity, R0 / ruled | 140,340+6,377+75,285; 140,311+6,406+75,285 | **222,002 / 222,002** | **Recomputed** |
| κ=2 identity, R0 / ruled | 131,968+6,377+83,657; 131,939+6,406+83,657 | **222,002 / 222,002** | **Recomputed** |
| κ=3 identity, R0 / ruled | 118,246+6,377+97,379; 118,217+6,406+97,379 | **222,002 / 222,002** | **Recomputed** |
| κ-grid semantic delta at every κ ∈ {1,1.5,2,3} | Ruled minus R0 | **ESCALATE −29; INCONCLUSIVE +29; STANDARD 0** | **Recomputed** |
| Q1 arises / change set | 29 SEF rows are ESCALATE under R0 and changed under Q1B | **|D(R0,PM_1)|=29** | Recomputed from probe + arm delta |
| Q2 change set | PM_1 and PM_12 classification hashes equal; probe has 0 qualifying rows | **|D(PM_1,PM_12)|=0** | **Recomputed** |
| Q3 change set | PM_12 and PM_123 classification hashes equal; probe has 0 qualifying rows | **|D(PM_12,PM_123)|=0** | **Recomputed** |
| Round-A change set | R0→BATCH has the same −29/+29 portfolio movement as Q1 | **|D(R0,BATCH)|=29** | **Recomputed** |
| Final-regime change set | PM_123 and BATCH have identical four key-output hashes | **D(PM_123,BATCH)=∅** | **Recomputed** |
| Q1 labels changed | Output rows changed=29 and labels changed=29 | **29** | Quoted |
| Q2/Q3 output changes | 0 and 0 | **0 / 0** | Quoted |
| Q4 answer-induced output changes | Probe/report-only field | **0** | Quoted |
| Q5 answer-induced output changes | One-to-one code map leaves no out-of-correspondence rows | **0** | **Recomputed/quoted** |
| Q5 code-pair population | 131,968 + 6,377 + 83,657 | **222,002** | **Recomputed** |
| Q5 correspondence | Three observed R-A→R-B code pairs, each unique in both directions | **one-to-one over 222,002 rows** | **Recomputed** |
| Arising questions | Q1, Q4, Q5 arise; Q2, Q3 do not | **3 of 5** | **Recomputed** |
| Gating questions | Only Q1 changes a written output row | **1 of 5** | **Recomputed** |
| Piecemeal interruptions | one for each arising Q: Q1+Q4+Q5 | **3** | **Recomputed** |
| Batched interruptions | round A contains Q1; round B contains Q4/Q5 | **2** | **Recomputed** |
| Piecemeal repair rounds | only arising+gating Q1 creates one | **1** | **Recomputed** |
| Batched repair rounds | only round A contains a gating answer | **1** | **Recomputed** |
| Unresolved gating questions, batched final | Q1 applied; no other gating Q exists | **0** | **Recomputed** |
| R0 key-output equality to frozen | classification, fixtures, κ grid, portfolio hashes all equal frozen references | **4/4** | **Recomputed from hashes** |
| Ruled-arm equality to frozen | fixture hash equal; classification/grid/portfolio hashes differ | **1/4** | **Recomputed from hashes** |
| Candidate-arm classification hash equality | PM_1=PM_12=PM_123=BATCH=`5e4140…f3b4a` | **4/4 equal** | **Recomputed from hashes** |
| Candidate-arm fixture hash equality | all four=`0d7224…e9e9`, also frozen R-B fixture hash | **4/4 candidate equal; frozen equal** | **Recomputed from hashes** |
| Candidate-arm κ-grid hash equality | all four=`189e80…066d` | **4/4 equal** | **Recomputed from hashes** |
| Candidate-arm portfolio hash equality | all four=`abe261…eb4e` | **4/4 equal** | **Recomputed from hashes** |
| Q4 R0 top share | 64,922 / 131,968 | **0.491952595 ≈ 0.491953** | **Recomputed** |
| Q4 ruled top share | 64,922 / 131,939 | **0.492060725 ≈ 0.492061** | **Recomputed** |
| Q4 share Δ | 0.492060725−0.491952595 | **+0.000108130** | **Recomputed** |
| ESCALATE type count | R0 81; ruled 80 | **−1** | **Recomputed** |
| Reporting executions | 5 R-B + 5 dominance + 1 probe | **11 executions; 11 exit=0** | **Recomputed** |
| Mandatory fixture rows per arm | F01 through F14 | **14** | **Recomputed** |
| Fixture-result observations across five R-B arms | 14 × 5 | **70** | **Recomputed** |
| `n_agree+n_disagree=n_inner` | Those named fields are not present in the supplied C42 evidence. No substitute values are invented. The available analogous Q5 identity is the 222,002-row code-pair partition above. | **Not supplied as C42 fields** | Source limitation |

The raw arm portfolios independently show R0 at `131968/6377/83657` and every ruled arm at `131939/6406/83657`, with the decision population and out-of-set population unchanged. The R0 κ grid supplies the four baseline rows used above, while the ruled grid supplies the corresponding −29/+29 changes at each κ.

The Q5 frequencies independently sum to the complete 222,002-row decision population: 131,968 + 6,377 + 83,657 = 222,002. The packet does not enumerate all 29 Q1 IDs; it gives the set size and only the first ten IDs, so exact membership beyond those printed IDs cannot be reconstructed from the supplied textual evidence.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 predicate is conjunctive: batched interruptions must be strictly lower, batched repair rounds must be strictly lower, unresolved gating questions must be zero, the two final regimes must have four byte-identical R-B key outputs, and R0 must reproduce the four frozen R-B outputs.

| P1 condition | Independent assessment |
| --- | --- |
| 1. Batched interruptions < piecemeal interruptions | **True:** 2 < 3. |
| 2. Batched repair rounds < piecemeal repair rounds | **False:** 1 < 1 is false. |
| 3. Zero unresolved gating questions in batched final | **True:** 0. |
| 4. Same final answer either way | **True:** PM_123 and BATCH have byte-identical classification, fixture, κ-grid, and portfolio hashes. |
| 5. R0 reproduces frozen R-B outputs | **True:** 4/4 hashes match. |

Thus the condition vector is **[True, False, True, True, True]**. Because the frozen definition requires all five conditions simultaneously, the P1 conjunction is **false solely because condition 2 is false**. The packet’s unscored alternative interpretation—neither count increases and at least one decreases—evaluates true because interruptions fall 3→2 while repairs remain 1→1.

## 5. Fixture and reconciliation implications.

The fixture evidence is stable. The BATCH output lists F01–F14 with `pass=TRUE`; the fixture file has SHA-256 `0d72245c…e9e9`, and that same hash appears in R0, PM_1, PM_12, PM_123, BATCH, and the frozen R-B reference. Therefore the locked fixture artifact is byte-identical across all five R-B arms even though 29 real-pack classifications move under Q1B.

Final-regime reconciliation is exact at the four declared R-B key outputs. PM_123 and BATCH share the full classification hash `5e4140da…f3b4a`, fixture hash `0d72245c…e9e9`, κ-grid hash `189e8009…066d`, and portfolio hash `abe261e7…eb4e`. In fact, PM_1, PM_12, PM_123, and BATCH all share those four hashes, mechanically confirming that Q2A and Q3A add no effect on this frozen pack after Q1B has been applied.

The Q5 cross-path reason reconciliation is also mechanically coherent for the decision population: the probe finds exactly three R-A→R-B reason-code pairings whose frequencies sum to 222,002 and reports a one-to-one mapping, so Q5’s frozen answer produces zero change rows.

The known OF-1 clock discrepancy does not contaminate this reconciliation. It concerns three 1.000-hour numerical clock differences on rows whose labels agree; Q5 is restricted to reason wording, and every C42 arm comparison is R-B against R-B. The packet therefore places those three rows outside the C42 question/change counts.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic change is narrow but real: Q1B reclassifies exactly 29 SEF rows from ESCALATE to INCONCLUSIVE. Because the locked fixture output remains byte-identical, the current fixture suite does **not** exercise this zero-peer-P75 production-data case. The semantic movement is declared rather than accidental, but fixture invariance by itself cannot validate that particular newly ruled branch.

Q2A is a latent branch on this pack. The source contains 245,193 records whose distinct STATUS value is only `Open`, so no open-like/non-exact-open case exists. Q3A is likewise unexercised because DUPLICATE contains only `false` and `true`; there are no blank/`NULL` cases, and the seed itself adds no Q3 executable change. Accordingly, C42 demonstrates no empirical behavior for those two hypothetical data situations beyond confirming that activating their switches does not change this frozen dataset.

Q4’s substantive flag/routing is unchanged, but its diagnostic output is not numerically invariant after Q1B. WCA2 remains the top and flagged type with 64,922 ESCALATE rows, yet the ESCALATE denominator falls from 131,968 to 131,939, so its share rises from 0.491953 to 0.492061; the number of represented ESCALATE types falls from 81 to 80. Those changes are downstream consequences of Q1’s 29-row movement, not output changes caused by the Q4 owner answer itself.

The principal unchanged surfaces are the source row universe (245,193), decision population (222,002), STANDARD population (83,657), out-of-set population (23,191), all mandatory fixture results, the WCA2 flag/routing conclusion, and the four final outputs between PM_123 and BATCH. R0 also reproduces all four frozen key outputs exactly. The preflight separately reverified the frozen source, R-B runtime/config/parse/fixture files, runner-side seeds, and reported a passing gating preflight before the reporting arms executed.

A process-level limitation is explicitly disclosed in the packet: scratch run 2 exposed the same substantive outcome before the final specification file was frozen. The mitigation recorded in the packet is that the evaluation predicate had already been hashed, remained unchanged through the harness fix, and no arm, threshold, rule, or predicate was altered after scratch 2; the reporting run then repeated every arm from scratch. This does not alter the reported arithmetic, but it is relevant when judging how strongly the exercise demonstrates outcome-blind experimental design.

## 7. Claim → evidence map.

| Claim | Packet section | Exact evidence row / artifact |
| --- | --- | --- |
| C42 is the batched-owner-rulings control with Builder=ChatGPT | SPEC | Ablation ID / Roles rows. |
| Baseline is piecemeal; variant batches Q1–Q3 before reconciliation and Q4–Q5 after execution | SPEC → Exact change being tested | “Piecemeal (baseline)” and “Batched (variant)” rows. |
| Q1B adds zero-peer-P75 integrity handling and Q2A adds open-like handling | SEED DIFFS | `RB_RULED__20_integrity_and_classify.R` diff rows. |
| Q1 is the only gating question | C42_RESULTS.md → Playback per question | Q1 row: 29 changed/29 labels/gating TRUE; Q2–Q5 rows: gating FALSE. |
| Piecemeal interruptions=3, batched interruptions=2, repair rounds=1 vs 1 | C42_RESULTS.md → Counts | Piecemeal and batched count rows. |
| Q2 and Q3 do not arise; Q4 and Q5 do arise | C42_RESULTS.md → Question probe | Q2–Q5 rows. |
| R0 portfolio is 131,968 / 6,377 / 83,657; ruled arms are 131,939 / 6,406 / 83,657 | C42_RESULTS.md → Arms | R0, PM_1, PM_12, PM_123, BATCH rows. |
| Q1 produces the −29 ESCALATE / +29 INCONCLUSIVE delta | Raw per-arm portfolio tables | R0 and BATCH κ=2 portfolio rows; arithmetic recomputed in §3. |
| The same −29/+29 movement occurs at κ=1, 1.5, 2, and 3 | Raw κ-grid tables | R0 grid and BATCH grid rows. |
| Q5’s three code-pair frequencies sum to 222,002 and are one-to-one | PROBE → `Q5_CODE_PAIRS.csv` and `Q_FACTS.csv` | 131,968 / 6,377 / 83,657 pair rows and Q5 probe row. |
| PM_123 and BATCH final key outputs are byte-identical | ARM MANIFESTS | BATCH four output hashes and PM_123 four output hashes. |
| R0 reproduces the frozen four R-B key outputs | Frozen reference hashes / R0 manifest | Frozen hashes and R0 output hashes. |
| Fixtures remain byte-identical despite Q1’s 29 real-row changes | Raw fixture output / manifests | BATCH F01–F14 all pass; same fixture hash across candidate and R0/frozen. |
| P1 conditions 1,3,4,5 are true and condition 2 is false | SPEC → P1; C42_RESULTS → Predicate conditions | Frozen five-condition definition and observed condition rows. |
| OF-1 cannot alter a C42 count under the declared comparison design | Coordinator Note N1 / OF-1 | Three repeated-hour numerical differences; all C42 arms compare R-B with R-B. |
| Scratch 2 exposed the outcome before final spec freeze, while the predicate and declared rules were held fixed afterward | SPEC → Pre-execution check | Scratch-1 fix, scratch-2 result, and “no arm, threshold, rule or predicate was changed after scratch 2.” |

END C42 BUILDER REPORT
