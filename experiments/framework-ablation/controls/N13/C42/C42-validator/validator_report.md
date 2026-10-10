1. Role attestation and ablation ID

- Role: Validator only. I am DeepSeek, operating blind to the Builder. I have not seen and will not ask for Builder output.
- Ablation ID: C42 (Addendum 01, control #42 “Batched owner rulings”).
- I do not return a terminal state in this report.

2. Independent test plan: what I checked, and how

- Checked frozen hashes against the runner preflight and against the arm manifests.
- Reconstructed the arm-level outputs from the raw per-arm files and manifests: portfolio counts, kappa-grid counts, fixture results, dominance outputs, Q-probe facts, and Q5 code pairs.
- Recomputed identities and deltas from the raw counts:

  - total decision rows and sums by classification;
  - R0 vs non-R0 portfolio deltas;
  - kappa-grid deltas across kappa = 1, 1.5, 2, 3;
  - dominance D-set totals, type counts, top type, top share, and flags.
- Checked cross-arm hash equalities for the four R-B key outputs and the fixture results.
- Checked P1 conditions 1–5 against the frozen predicate text and the runner output.
- Checked internal consistency of the runner output, raw per-arm files, and manifests.

3. Independently recomputed hard facts  
   Identities and portfolio deltas

- All arms have n_decision = 222002.
- R0 portfolio: ESCALATE = 131968, INCONCLUSIVE = 6377, STANDARD = 83657, out_of_set = 23191.

  - Sum: 131968 + 6377 + 83657 = 222002.
- Non-R0 arms PM_1, PM_12, PM_123, BATCH portfolio: ESCALATE = 131939, INCONCLUSIVE = 6406, STANDARD = 83657, out_of_set = 23191.

  - Sum: 131939 + 6406 + 83657 = 222002.
- Delta from R0 to every non-R0 arm: ESCALATE −29, INCONCLUSIVE +29, STANDARD 0, n_decision 0, out_of_set 0.
- This delta is exactly the Q1B effect: 29 ESCALATE rows moved to INCONCLUSIVE.

Kappa-grid deltas

- R0 kappa grid:

  - kappa 1: ESCALATE 152292, INCONCLUSIVE 6377, STANDARD 63333.
  - kappa 1.5: ESCALATE 140340, INCONCLUSIVE 6377, STANDARD 75285.
  - kappa 2: ESCALATE 131968, INCONCLUSIVE 6377, STANDARD 83657.
  - kappa 3: ESCALATE 118246, INCONCLUSIVE 6377, STANDARD 97379.
- Non-R0 kappa grid:

  - kappa 1: ESCALATE 152263, INCONCLUSIVE 6406, STANDARD 63333.
  - kappa 1.5: ESCALATE 140311, INCONCLUSIVE 6406, STANDARD 75285.
  - kappa 2: ESCALATE 131939, INCONCLUSIVE 6406, STANDARD 83657.
  - kappa 3: ESCALATE 118217, INCONCLUSIVE 6406, STANDARD 97379.
- Delta at every kappa: ESCALATE −29, INCONCLUSIVE +29, STANDARD 0.
- Each kappa row sums to 222002.

D-sets / dominance

- R0 dominance:

  - n_escalate_total = 131968.
  - n_types_escalate = 81.
  - top_type = WCA2, top_n = 64922, top_share = 0.491953.
  - flagged_types = WCA2, status = FLAG.
- Non-R0 dominance:

  - n_escalate_total = 131939.
  - n_types_escalate = 80.
  - top_type = WCA2, top_n = 64922, top_share = 0.492061.
  - flagged_types = WCA2, status = FLAG.
- Reconciliation:

  - Top type and top_n are unchanged. The denominator drops by 29, so top_share rises slightly.
  - n_types_escalate drops by 1 because the SEF type had exactly 29 ESCALATE rows in R0 and drops out of the ESCALATE type table after Q1B.
  - This is consistent with Q1 probe detail: types: SEF; labels: ESCALATE=29.

Fixture results

- All arms have 14 fixture rows.
- All fixture rows have pass = TRUE.
- The fixture-results hash in all arms is 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9, matching the frozen RB_fixture_results.csv hash.

Cross-arm hash equalities

- R0 equals frozen R-B 4/4:

  - RB_classifications.csv: a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193 = frozen.
  - RB_fixture_results.csv: 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 = frozen.
  - RB_kappa_grid_counts.csv: 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a = frozen.
  - RB_portfolio_counts.csv: eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c = frozen.
- PM_1, PM_12, PM_123, BATCH classifications hash: 5e4140dabac2472464ff37ce215a1c44b6b7d71a6b375a83e2e742f84f8f3b4a for all four.
- PM_1, PM_12, PM_123, BATCH fixture-results hash: 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9 for all four.
- PM_1, PM_12, PM_123, BATCH kappa-grid hash: 189e8009dcc43c6754c76b14daaa72e4980df4a5624c573f4b982d1b1cf0066d for all four.
- PM_1, PM_12, PM_123, BATCH portfolio hash: abe261e723311b0b4553b398c1dd5f82a0ffb78f2f0a27edbea6ae8fb6fbeb4e for all four.
- Therefore PM_123 and BATCH are byte-identical for the four R-B key outputs.

Q-probe facts

- Q1: arises TRUE, rows 29, detail types SEF; labels ESCALATE=29.
- Q2: arises FALSE, rows 0, detail distinct source STATUS values: Open=245193.
- Q3: arises FALSE, rows 0, detail DUPLICATE values: false=222176, true=23017.
- Q4: arises TRUE, rows 64922, detail flagged WCA2; top share 0.491953 of 131968; ruled_answer_change_rows_report_only = 0.
- Q5: arises TRUE, rows 222002, detail code pairs:

  - dormant_ge_kappa_peer_p75 -> E_dormant_ge_kappa_p75: 131968
  - thin_type_or_missing_peer -> I04_thin_peer_n: 6377
  - within_type_dormancy -> S_dormant_lt_kappa_p75: 83657
  - one-to-one: TRUE; ruled_answer_change_rows_report_only = 0.
- Q5 pair frequencies sum to 131968 + 6377 + 83657 = 222002.

Internal inconsistency flags

- None found. The Q4 top share 0.491953 appears in the Q-probe against frozen R-B/R0, while non-R0 dominance shows 0.492061. These are consistent: the probe uses the frozen R0 denominator 131968, while non-R0 arms have denominator 131939 after the 29-row Q1B shift.

4. Facts that cannot be recomputed from this packet

- Full byte content of the large classifications CSVs is not included, so I cannot independently recompute every row-level change, every Q1 changed SR number, or every Q5 row-level wording difference.
- Full source text of eval_c42.R and run_c42.ps1 is not included, only their SHA-256 hashes. I cannot re-execute the predicate or runner logic from source.
- I cannot recompute the actual SHA-256 of the provided text blocks C42_RESULTS.md, C42_arms.csv, or C42_ARM_MANIFESTS.txt because encoding and line endings are not guaranteed from the packet; I can only compare the listed hashes against the frozen references.
- I cannot independently recompute the PC preflight, R package versions, wall-clock timings, or file LastWriteTime values.
- I cannot independently recompute the owner-answer, sheet, decisions, spec-freeze, or constitution hashes from raw files; only the listed hashes are available.

5. P1 assessment against the frozen predicate in the SPEC

- Condition 1: owner interruptions go down: batched < piecemeal.

  - Piecemeal interruptions = 3: Q1, Q4, Q5 arise.
  - Batched interruptions = 2: round A Q1–Q3, round B Q4–Q5.
  - 2 < 3. MET.
- Condition 2: repair rounds go down: batched < piecemeal.

  - Gating questions: only Q1 is gating. Q1 answer B changes 29 output rows.
  - Piecemeal repair rounds = 1.
  - Batched repair rounds = 1.
  - 1 < 1 is false. NOT MET.
- Condition 3: nothing unresolved: 0 gating questions unanswered in the batched final output.

  - Gating questions = Q1 only.
  - Batched final output BATCH includes Q1B; Q1 change rows appear in BATCH vs R0.
  - Unresolved count = 0. MET.
- Condition 4: same answer either way: piecemeal and batched final outputs (4 R-B key outputs) are byte-identical.

  - PM_123 and BATCH hashes match for RB_classifications.csv, RB_fixture_results.csv, RB_kappa_grid_counts.csv, RB_portfolio_counts.csv.
  - MET.
- Condition 5: validity: R0 equals the frozen R-B outputs 4/4.

  - R0 matches frozen RB_classifications.csv, RB_fixture_results.csv, RB_kappa_grid_counts.csv, RB_portfolio_counts.csv.
  - MET.
- Overall mechanical predicate result in the runner output: P1 NOT MET, due to condition 2. INFO alternative reading “neither goes up and at least one goes down” is reported as met. No terminal state assigned.

6. Blocking objections

- None. I found no defect in the harness, seed, predicate application, or evidence that should block a verdict.

7. Claim → evidence map  
   | Claim | Evidence |  
   |---|---|  
   | R0 equals frozen R-B outputs 4/4. | C42_arms.csv row R0; R0 manifest hashes a0e42…, 0d722…, 7a18…, eb677… matching frozen reference hashes. |  
   | Q1 arises on 29 ESCALATE SEF rows. | Q_FACTS.csv Q1 TRUE, rows 29, detail types SEF; labels ESCALATE=29. |  
   | Q1B is gating and changes 29 rows. | PM_1 vs R0 portfolio delta: ESCALATE −29, INCONCLUSIVE +29; Q1 output_rows_changed_by_ruling = 29. |  
   | Q2 does not arise. | Q_FACTS.csv Q2 FALSE, rows 0, distinct STATUS Open=245193; PM_12 vs PM_1 outputs identical. |  
   | Q3 does not arise. | Q_FACTS.csv Q3 FALSE, rows 0, DUPLICATE values false/true only; PM_123 vs PM_12 outputs identical. |  
   | Q4 arises but is not gating. | Q_FACTS.csv Q4 TRUE, rows 64922, flagged WCA2; ruled_answer_change_rows_report_only = 0; dom_check FLAG WCA2 on all arms. |  
   | Q5 arises but is not gating. | Q_FACTS.csv Q5 TRUE, rows 222002; Q5_CODE_PAIRS one-to-one TRUE; ruled_answer_change_rows_report_only = 0. |  
   | Piecemeal and batched final outputs are byte-identical. | PM_123 and BATCH share hashes 5e4140…, 0d722…, 189e8009…, abe261… for the four R-B key outputs. |  
   | Condition 1 MET. | Piecemeal 3 interruptions, batched 2; C42_RESULTS condition 1 MET. |  
   | Condition 2 NOT MET. | Piecemeal 1 repair round, batched 1 repair round; C42_RESULTS condition 2 NOT MET. |  
   | Condition 3 MET. | Batched 0 gating questions unanswered; Q1B applied in BATCH; C42_RESULTS condition 3 MET. |  
   | Condition 4 MET. | PM_123 and BATCH 4 R-B key output hashes identical; C42_RESULTS condition 4 MET. |  
   | Condition 5 MET. | R0 4/4 frozen; C42_RESULTS condition 5 MET. |  
   | No blocking objection found. | Internal cross-checks of counts, hashes, deltas, D-sets, Q-probe, and manifests are coherent. |

END C42 VALIDATOR REPORT
