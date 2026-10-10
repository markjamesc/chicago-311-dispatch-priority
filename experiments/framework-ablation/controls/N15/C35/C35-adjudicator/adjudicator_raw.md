1. Role attestation.

I am the Adjudicator only for C35, Remaining Ablation Program catalog #35, “Freeze Validated Pack,” N15 batch 3 of 3. Builder is ChatGPT. Validator is DeepSeek. I hold no other role. I did not rerun the ablation, repair code, create a criterion, or relax a gate. This decision uses only the frozen packet: SPEC, constitution 1.0, coordinator note N1, preflight, run log, C35_RESULTS.md, C35_arms.csv, arm manifests, seed diffs, FREEZE RECORD, and the two frozen reports.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 07:04:59 CDT, constitution 1.0) identifies the packs as:

- Builder: C35/C35-builder/builder_report.md, 16,334 bytes, SHA-256 e98a8616f2f49322a839fdbbbd1c5529ef4b60dd59a93d9a987907712954a5ce, verdict_token_leak: false
- Validator: C35/C35-validator/validator_report.md, 9,868 bytes, SHA-256 6f875d5e2855e7ab0e030888d496855b1853b9d485178755c3d9f63c7c33c806, verdict_token_leak: false

The reports in this packet are those frozen files, presented verbatim. Each is complete. The Builder report ends with END C35 BUILDER REPORT. The Validator report ends with END C35 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Roles in the record match the SPEC (Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok). Baseline hashes in the record match the SPEC baselines (70a14831… and 24aec49c…). No hash or frozen-version mismatch is shown against the FREEZE RECORD.

3. Hard-fact agreement table.

| Fact | Builder | Validator | Runner RESULTS / raw | Agreement |
| --- | --- | --- | --- | --- |
| Arms | 7 = B + 6 seeds | 7 rows recomputed | C35_arms.csv has 7 rows | agree |
| Arm B Stage 5 exit | 0 | 0 | run log B S5 exit=0; RESULTS “Stage 5 exit 0” | agree |
| Arm B 8/8 deeper outputs equal frozen | yes | yes, hash-by-hash | RESULTS “YES (8/8)”; B manifest hashes match SPEC stage-05/deeper hashes | agree |
| Arm B with-control check | clean; FRZ_POST changed 0 | FRZ_PRE = FRZ_POST = 81ad52…; clean | run log B FRZ_POST changed=0 | agree |
| FRZ_PRE clean on every arm | 0/7 modified | all FRZ_PRE.txt = 81ad52…; run log changed=0 | run log every FRZ_PRE changed=0 | agree |
| H | {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY} | same set | RESULTS H set; arms CSV in_H=TRUE on those five | agree |
| Caught with the control | those same 5 | those same 5 | RESULTS caught-with set | agree |
| D_abl (S5 exit ≠ 0) | {FV_EARLY} | {FV_EARLY} | RESULTS D_abl; only FV_EARLY has s5_exit=1 | agree |
| H \ D_abl | {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}, size 4 | same set, nonempty | RESULTS “P1 failed” with that set | agree |
| H \ caught-with | empty | empty | RESULTS {} | agree |
| Flagged with control but not in H | empty | empty | RESULTS {} | agree |
| FV_BENIGN in H | no; diagnostic only | no; adds diag_type_by_class.csv only | RESULTS in_H FALSE; FRZ_POST changed=0 | agree |
| FV_VALSORT changed file | validated_action_list.csv, same 13,625,648 bytes, new hash | same | arms CSV; VALSORT manifest hash 0de2eb…, 13,625,648 bytes | agree |
| FV_ADDRANK changed file | RA_classifications.csv, +1,442,923 bytes | same (0efb2f…, 23,714,404) | arms CSV; ADDRANK manifest | agree |
| FV_ROUND changed file | RA_classifications.csv, −1,112,982 bytes | same (cc6491…, 21,158,499) | arms CSV; ROUND manifest | agree |
| FV_DROPTHIN changed file | validated_action_list.csv, −402 bytes | same (adc8b7…, 13,625,246) | arms CSV; DROPTHIN manifest | agree |
| FV_EARLY changed file and exit | action list −105 bytes; S5 exit 1 | action list ae5317…, 13,625,543; exit 1; stderr 52 bytes | run log exit=1, FRZ_POST changed=1 | agree |
| RB kappa grid unchanged | 0/7 arms | identical 7a18… on all arms | manifests | agree |
| P1 | failed; H \ D_abl ≠ ∅ | failed; same | RESULTS “P1 failed” | agree |
| Fixture rows | 0 | header only | fixture table is header only | agree |
| N1 clock mismatches | 1 dormant_h + 2 open_age_h, labels agree, pre-existing | disclosed; not recomputed at row level | coordinator note N1; SPEC known open finding | agree |

Blank frz_pre_changed / clean frz_post_changed cells in C35_arms.csv, and the blank s5_outputs_differ_vs_B on FV_EARLY, are reporting gaps both sides notice. They are not a hard-number conflict: the run log and manifests give the same 0/1 pattern and the same set membership. No row is disagree.

4. The nine KEEP conditions of constitution §7.
5. Evidence packs complete and frozen: PASS. FREEZE RECORD names both packs, both verdict_token_leak: false, and both reports end with their END lines. Runner evidence is present: run log, C35_RESULTS.md, C35_arms.csv, manifests, seed diffs, preflight.
6. Role separation valid: PASS. SPEC and FREEZE RECORD assign Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Each first-pass report attests a single role and blindness. No verdict token in either pack.
7. Builder and Validator agree on hard mechanical facts: PASS. Section 3. Both recompute H, D_abl, H \ D_abl, caught-with, and the B-clean result from the same raw rows and manifests.
8. Exact reconciliation passes where required: PASS for clean arm B. This is a Stage-5-only control; it does not rerun R-A or R-B (SPEC, “Stage-5-only arm design”). Coordinator note: “B recon is 0/0/0” under the frozen recon definition (only-RA, only-RB, classification disagreements). The dormant_h 1 and open_age_h 2 full-field mismatches are disclosed open finding N1, pre-existing on the frozen pack, labels agreeing, and outside that definition. B FRZ_PRE and FRZ_POST are both unchanged.
9. Every mandatory fixture passes: PASS. No R-A/R-B fixtures are in scope. The fixture table is header-only, which matches the SPEC statement that batch 3 uses no R-A/R-B code seeds and no source variants. No failing fixture row is present.
10. No undeclared semantic change on clean arm B: PASS. B Stage 5 exit 0, 8/8 deeper outputs match the frozen stage-05/deeper hashes, and the three validated files retain the frozen hashes (c099e092…, 7a18fcb1…, 2bffa38b…). Seeded mutations are the declared harm set, not an undeclared change on B.
11. No locked regression on clean arm B: PASS. B FRZ_PRE changed=0, S5 exit=0, FRZ_POST changed=0 (run log and RESULTS). Spec HALT rule for a non-zero B exit or an 8-output mismatch is not triggered.
12. Predeclared benefit predicate satisfied: FAIL. SPEC P1 KEEP-side requires arm B clean and H \ D_abl = ∅. B is clean. H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN} in RESULTS, recomputed by both reports. P1 failed.
13. No blocking objection remains supported by the frozen evidence: PASS. Validator §6: none that blocks recomputation of H, D_abl, or P1. The blank CSV fields, the preflight omission of two validated-file lines, and the empty fixture table are noted defects; they do not contradict the manifests or the run log on the P1 sets.

Conditions are conjunctive. Condition 8 fails.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3; both sides and RESULTS agree on H, D_abl, and P1.
- Required raw evidence missing: absent. Run log, arms CSV, RESULTS, manifests, seed diffs, and both reports are in the packet. Empty fixture rows are the Stage-5-only design, not a missing required artifact. Historical stdout gaps are not a HALT ground under the adjudicator instruction.
- Hashes or frozen versions mismatch: absent. FREEZE RECORD matches the presented packs and baseline hashes. Seed hashes in preflight match the SPEC seed list. B output hashes match the frozen validated and stage-05/deeper hashes.
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the two baseline hashes are stable from SPEC through FREEZE RECORD.
- Role separation violated: absent. Three distinct roles; no dual-role hold.
- Information barrier breached before first-pass freeze: absent. Both reports attest blindness; FREEZE RECORD records verdict_token_leak: false on both packs.
- Benefit predicate not defined before execution: absent. P1 is in the frozen SPEC (H \ D_abl = ∅, with B clean), frozen before the runner.
- Adjudicator cannot tell which pack is authoritative: absent. FREEZE RECORD names one Builder pack and one Validator pack, and both are present and complete.

No HALT condition is present.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no objection it treats as blocking H, D_abl, or P1. The noted defects, and how the evidence bears on them:

- Blank frz_pre_changed (all arms) and blank clean frz_post_changed (B, FV_BENIGN) in C35_arms.csv / RESULTS. The run log records FRZ_PRE changed=0 on all seven arms and FRZ_POST changed=0 on B and FV_BENIGN. All seven FRZ_PRE.txt hashes are 81ad521a…. B and FV_BENIGN FRZ_POST.txt match that hash. The blanks are a reporting omission, not a conflicting measurement.
- FV_EARLY s5_outputs_differ_vs_B is blank, while its manifest has only independent_checks_critical_counts.csv (8fe938…, 191 bytes vs frozen 4aca9c…, 190 bytes) and lacks the other seven deeper outputs. That confirms EARLY did not reproduce B. It does not move EARLY out of H or D_abl: s5_exit=1 and the action-list hash changed. A non-zero Stage 5 exit counts as caught in every regime under the SPEC regression rule.
- Preflight lists RB_classifications.csv and does not print the validated-action-list or kappa-grid lines. Arm B’s output manifest still carries the three frozen validated hashes. This does not unset the FRZ_PRE/FRZ_POST comparison.
- Fixture table is header-only. Expected for this Stage-5-only control. Not a failed fixture.
- VALIDATION_FREEZE.sha256 body is not shown; its hash 65b91043…, 335 bytes, is identical on every arm. Enough to show a common freeze anchor; not enough to reopen P1.
- FV_BENIGN RUN_S5.exit is 33 bytes vs 31 bytes on other exit-0 arms. Exit code in the run log and arms CSV is still 0, and FRZ_POST is clean. Not a harm and not a B defect.

None of these is a supported blocking objection. They do not empty H \ D_abl.

7. Verdict rationale.

Removing the control materially changes the outcome on the frozen pack.

The control under test is a separate archived freeze of the validated files, checked after Stage 5. The ablation removes that archive and that post-analysis check. Stage 5’s own count checks remain. Harm H is a post-Stage-5 byte change in RA_classifications.csv, RB_kappa_grid_counts.csv, or validated_action_list.csv. Caught-with is the FRZ_POST comparison. Caught-without (D_abl) is a non-zero Stage 5 exit.

Arm B is clean: exit 0, 8/8 deeper outputs equal the frozen stage-05/deeper files, FRZ_POST unchanged. FV_BENIGN writes only stage-05/deeper/diag_type_by_class.csv and is correctly outside H. The control does not over-block (flagged-but-not-in-H is empty) and does not miss a harm (H \ caught-with is empty).

Four seeded harms are caught only with the freeze comparison, and Stage 5 exits 0 on each:

- FV_VALSORT re-sorts validated_action_list.csv after the checks. Size stays 13,625,648 bytes; hash changes (2bffa38b… to 0de2eb…).
- FV_ADDRANK adds priority_rank to RA_classifications.csv (+1,442,923 bytes) after the checks.
- FV_ROUND writes rounded dormant_h back into RA_classifications.csv (−1,112,982 bytes) after the checks.
- FV_DROPTHIN overwrites the action list with peer_n >= 100 (−402 bytes) after the checks.

Seed diffs place those four writes after the independent checks. Only FV_EARLY drops a row before the checks, so only FV_EARLY exits 1 and lands in D_abl. Standard deeper outputs on the four exit-0 harm arms still match B. Stage 5 count reproducibility is not validated-pack immutability.

P1 therefore fails: H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}. Mechanics are coherent, HALT conditions are absent, and KEEP condition 8 is not established. Constitution §8 and the adjudicator instruction make REVERT the required state. Catalog #35 stays.

TERMINAL_STATE: REVERT
END C35 ADJUDICATION
