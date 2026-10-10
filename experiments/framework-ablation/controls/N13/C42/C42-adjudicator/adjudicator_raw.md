1. Role attestation.

I attest that I am acting solely as Adjudicator for C42 (Addendum 01 control #42, “Batched owner rulings”), Expert mode, as in A01–A08. Assigned roles in the frozen specification and FREEZE RECORD are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I hold no other role. I have not rerun any arm, repaired code, created a criterion, relaxed a gate, or preferred one side’s mechanical result over the other’s. The terminal state below is taken only from the frozen packet.

2. Freeze check.

The FREEZE RECORD (EVIDENCE_FREEZE.json, frozen_at_ct 2026-10-03 11:21:14 CDT) names the Builder pack as C42/C42-builder/builder_report.md, 16993 bytes, SHA-256 df3d01067dbe266d4c93ec66d46f0a1151357f2e85efcf66aa99e2d43f0147a1, verdict_token_leak: false, and the Validator pack as C42/C42-validator/validator_report.md, 9846 bytes, SHA-256 90dc977a01c878b83169d4e8b8a51df1cb5c77dcbefccb4fdc7f71e7d32a3fae, verdict_token_leak: false. The reports reproduced in this packet are those freeze-record files. Each is complete and ends with its END line: END C42 BUILDER REPORT and END C42 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Constitution SHA-256 e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9 matches the SPEC. Baseline framework hashes match the BASELINE FRAMEWORK HASHES block. Runner preflight is PASS on every frozen-pack and seed hash listed in the SPEC’s FROZEN REFERENCE HASHES. Spec freeze N13/SPEC_FREEZE_C42.sha256 was written 2026-10-03 11:01 CDT before the reporting run (11:01:16–11:04:05). I do not recompute file hashes from packet text; the freeze record, preflight lines, and arm manifests are the authoritative hash evidence, and they agree with one another.

3. Hard-fact agreement table.

Builder and Validator agree on every predeclared hard mechanical fact that the RESULTS file and raw arms support. No row is a disagreement.

| Fact | Builder | Validator | Runner RESULTS / raw arms | Mark |
| --- | --- | --- | --- | --- |
| Source rows | 245,193 (222,176 false + 23,017 true) | 245,193 (Open=245193; false=222176, true=23017) | Q_FACTS Q2/Q3 | agree |
| R0 portfolio κ=2 | 131968 / 6377 / 83657, out-of-set 23191, decision 222002 | same | arms.csv R0; R0 portfolio file | agree |
| Ruled portfolio (PM_1, PM_12, PM_123, BATCH) | 131939 / 6406 / 83657, out-of-set 23191, decision 222002 | same | arms.csv; raw portfolio files | agree |
| Portfolio delta ruled − R0 | ESCALATE −29, INCONCLUSIVE +29, STANDARD 0 | same | raw portfolios | agree |
| κ-grid delta at 1, 1.5, 2, 3 | ESCALATE −29, INCONCLUSIVE +29, STANDARD 0; each row sums to 222002 | same | raw κ-grid files | agree |
| Q1 arises / gating | TRUE, 29 SEF ESCALATE rows, 29 output rows and 29 labels changed, gating TRUE | same | RESULTS playback; Q_FACTS | agree |
| Q2 arises / change | FALSE, 0 rows, gating FALSE | same | RESULTS; Q_FACTS; PM_1 hash = PM_12 hash | agree |
| Q3 arises / change | FALSE, 0 rows, gating FALSE | same | RESULTS; Q_FACTS; PM_12 hash = PM_123 hash | agree |
| Q4 arises / gating | TRUE, 64922 WCA2, change rows 0, gating FALSE | same | RESULTS; Q_FACTS; DOM FLAG WCA2 | agree |
| Q5 arises / gating | TRUE, 222002, one-to-one, change rows 0, gating FALSE | same | Q5_CODE_PAIRS 131968+6377+83657=222002 | agree |
| Piecemeal interruptions / repair rounds | 3 / 1 | 3 / 1 | RESULTS Counts | agree |
| Batched interruptions / repair rounds | 2 / 1 | 2 / 1 | RESULTS Counts | agree |
| Unresolved gating, both regimes | 0 | 0 | RESULTS condition 3 | agree |
| Final-regime byte identity | PM_123 = BATCH on 4 key outputs (5e4140…, 0d7224…, 189e80…, abe261…) | same | manifests | agree |
| R0 = frozen R-B | 4/4 (a0e42b…, 0d7224…, 7a18fc…, eb677b…) | same | arms.csv R0; frozen reference hashes | agree |
| Fixtures | F01–F14 pass=TRUE; hash 0d72245c…e9e9 on all five arms = frozen | same | raw fixture files; manifests | agree |
| Executions | 5 R-B + 5 DOM + 1 PROBE, all exit 0 | no contrary fact | RUN LOG; RUN_*.exit | agree |
| P1 | NOT MET; condition 2 false; 1, 3, 4, 5 true | same | RESULTS “P1 NOT MET” | agree |
| Dominance | R0: 131968 ESCALATE, 81 types, WCA2 64922 share 0.491953 FLAG; ruled: 131939, 80 types, WCA2 64922 share 0.492061 FLAG | same | DOM_RESULT.csv | agree |

OF-1 (three repeated-hour 1.000 h clock differences, labels agreeing) is disclosed and outside Q5; every C42 comparison is R-B against R-B. Neither side treats it as a C42 count change. Agree.

4. The nine KEEP conditions of constitution §7.
5. Evidence packs complete and frozen: PASS. FREEZE RECORD names both packs with hashes and verdict_token_leak: false; both reports end with their END lines; runner RESULTS, arms.csv, raw per-arm files, manifests, logs, preflight, and frozen reference hashes are present (constitution §3; instruction that missing historical stdout is not by itself a HALT).
6. Role separation valid: PASS. Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; each model one role; both first-pass reports attest blindness; freeze record records no verdict-token leak (constitution §1).
7. Builder and Validator agree on hard mechanical facts: PASS. Section 3 has no disagree row, including the RESULTS hard numbers (constitution §4).
8. Exact reconciliation passes where required: PASS. Constitution §7 condition 4 is, for this control, byte identity of the piecemeal and batched final outputs (P1 condition 4) and R0 equal to the frozen R-B outputs 4/4 (P1 condition 5). PM_123 and BATCH share 5e4140dabac2472464ff37ce215a1c44b6b7d71a6b375a83e2e742f84f8f3b4a, 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9, 189e8009dcc43c6754c76b14daaa72e4980df4a5624c573f4b982d1b1cf0066d, abe261e723311b0b4553b398c1dd5f82a0ffb78f2f0a27edbea6ae8fb6fbeb4e. R0 matches the four frozen R-B hashes.
9. Every mandatory fixture passes: PASS. Constitution §7 condition 5 is the fixture results inside each run_RB.R all; R0’s RB_fixture_results.csv hash equals the frozen hash 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9, and the same hash and F01–F14 pass=TRUE hold on PM_1, PM_12, PM_123, and BATCH.
10. No undeclared semantic change detected: PASS. The only classification movement is the declared Q1B playback (29 SEF rows ESCALATE → INCONCLUSIVE). Q2A and Q3A change 0 rows on this pack. Q4 answer A and Q5 answer A change 0 rows. The two regimes’ final outputs are byte-identical. The seeded switch file with no switch set reproduces frozen R-B 4/4.
11. No locked regression introduced: PASS. Constitution §7 conditions 6–7 are the frozen pack read-only: preflight gating PASS on every listed frozen hash; arm input manifests repeat those source and R-B hashes; fixtures remain the frozen fixture hash. DOM flags and routes WCA2 without dropping a row, as the #47 check declares.
12. Predeclared benefit predicate satisfied: FAIL. P1 is conjunctive. Condition 1 is met (batched 2 < piecemeal 3). Condition 2 is not met (batched 1 < piecemeal 1 is false). Conditions 3, 4, and 5 are met. RESULTS states “Mechanical predicate result: P1 NOT MET”. SPEC: “go down” is strictly lower for both counts; the alternative reading is INFO only and is not scored. SPEC also notes, before execution, that condition 2 can be met only if two or more of Q1–Q5 change output rows in the same round; only Q1 is gating, so one repair round on each side is the declared arithmetic.
13. No blocking objection remains supported by the frozen evidence: PASS. Validator §6: “None.” No harness, seed, predicate, or evidence defect in the packet supports a blocking objection (see section 6).

The nine conditions are conjunctive. Condition 8 fails, so KEEP is not available.

5. HALT conditions of §9.

- Hard mechanical disagreement between Builder and Validator: absent. Section 3 agrees, including RESULTS hard numbers (constitution §4, §9).
- Required raw evidence missing: absent. Runner RESULTS, raw per-arm files, manifests, logs, and frozen reference hashes are in the packet. Instruction: do not HALT only because historical stdout is missing. Validator’s inability to re-hash packet text or re-execute from source is a packet-scope limit, not a missing artifact.
- Hash or frozen-version mismatch against the FREEZE RECORD or FROZEN REFERENCE HASHES: absent. Preflight “frozen OK” / “seed OK” on every listed hash; R0 output hashes equal the frozen R-B key hashes.
- Baseline or constitution changed mid-run: absent. Constitution and baseline hashes match the freeze and SPEC freeze blocks.
- Role separation violated: absent. Freeze record roles match the SPEC.
- Information barrier breached before first-pass freeze: absent. Both reports attest blindness; verdict_token_leak: false on both packs.
- Predicate not defined before execution: absent. SPEC freezes P1 before the reporting run; eval_c42.R SHA-256 c0e9df0b73deca7a2bd72509d670e8e8161160f0e10f8468719233f8d2fb0012 is in the seed preflight and is stated unchanged from before scratch 2. Scratch 2 disclosed the same arithmetic before spec freeze; the packet states no arm, threshold, rule, or predicate was changed after scratch 2. That disclosure is not a §9 HALT condition.
- Adjudicator cannot tell which frozen pack is authoritative: absent. FREEZE RECORD names one Builder pack and one Validator pack.

6. Blocking objections raised by the Validator and how the evidence bears on them.

Validator §6 raises none. The evidence does not support one that the Validator omitted.

The repair-round tie is a failed predicate condition, not a harness defect: only Q1 is gating (29 rows; PM_1 hash departs from R0 and then PM_12, PM_123, and BATCH stay on 5e4140…), so each regime has exactly one repair round, which is what the SPEC predicted when at most one gating answer sits in a round. Q2 and Q3 do not arise (STATUS only Open; DUPLICATE only false/true), so they add neither an interruption nor a repair. Q4 and Q5 arise and are not gating (change rows 0), so they add interruptions only. Nothing gating is unresolved: BATCH applies Q1B, and its four key outputs match PM_123.

OF-1 is disclosed, settled by ruling 53A, outside Q5 (numbers, not reason wording), and cannot move a C42 count because every arm is R-B versus R-B. The WCA2 share shift 0.491953 → 0.492061 and the ESCALATE type count 81 → 80 are downstream of the 29-row Q1B move, not a Q4 answer effect; both arms still FLAG WCA2 and drop nothing. Empty RUN_RB.stdout.txt (hash e3b0c442…) with non-empty stderr and exit 0 is the recorded runner shape on every arm, not a missing-results HALT under the packet instruction. Items the SPEC marks not measured (owner minutes, brief-writing minutes, real builder behaviour, PricePoint-scale costs) are not evidence either way.

7. Verdict rationale.

The change under test is batched owner rulings (Addendum 01 #42; ruling 42A playback): one round before reconciliation for Q1–Q3, plus one round after the run for questions that can only arise then. On the frozen pack it did not materially change the classification outcome relative to piecemeal. The same answer is applied either way: PM_123 and BATCH are byte-identical on the four R-B key outputs, unresolved gating is 0, and R0 reproduces frozen R-B 4/4. Interruptions fall from 3 to 2. Repair rounds do not fall: both regimes take 1, because only Q1 changes a written row and it is the only gating answer in round A. SPEC reads “go down” as strictly lower for both counts and scores the non-strict alternative as INFO only. P1 is therefore not met. Mechanics are coherent, Builder and Validator agree, and no §9 HALT condition is present. Constitution §8 and the packet instruction make REVERT the conservative default when P1 fails and HALT is absent. Piecemeal owner rulings stay.

TERMINAL_STATE: REVERT
END C42 ADJUDICATION
