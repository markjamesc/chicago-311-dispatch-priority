1. Role attestation

I am acting only as Adjudicator for ablation C32 (Remaining Ablation Program catalog #32, “Freeze Before Stage 5”), N15 batch 3 of 3. Constitution version 1.0. Frozen roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I issue exactly one terminal state. I do not rerun, repair, add criteria, relax a gate, or prefer one side’s mechanical result over the other.

The ablation removes the pre-Stage-5 seal check. Stage 5 reads whatever occupies the validated-output paths; its independent count checks remain. Seeded PRE edits run after the validation freeze and before Stage 5. KEEP would drop the control from the canonical framework. REVERT keeps it.

2. Freeze check

The FREEZE RECORD (frozen_at_ct 2026-10-03 07:05:01 CDT) names the authoritative packs:

- Builder: C32/C32-builder/builder_report.md, 15998 bytes, SHA-256 2ac81653d7e6a73fed016c0786ab655066acdc4368d9c4c835389bc48c552f31, verdict_token_leak: false.
- Validator: C32/C32-validator/validator_report.md, 12237 bytes, SHA-256 9c3c5fed92db4087d316a72c7c8ac325b33d9312c544eec55eafc9c15f23b60b, verdict_token_leak: false.

The reports in this message are those frozen packs, supplied verbatim. Each is complete and ends on its END line: Builder “END C32 BUILDER REPORT”; Validator “END C32 VALIDATOR REPORT”. Neither issues KEEP, REVERT, or HALT. Baseline hashes in the FREEZE RECORD match the baseline-hash block (70a14831… measurement-design; 24aec49c… validation-and-analysis). Constitution version is 1.0 throughout. I do not re-hash.

3. Hard-fact agreement table

Runner RESULTS, C32_arms.csv, and the arm manifests are the mechanical source. Builder and Validator both recompute from those artifacts.

| Fact | Runner RESULTS | Builder | Validator | Mark |
| --- | --- | --- | --- | --- |
| Arm B S5 exit | 0 | 0 | 0 | agree |
| Arm B outputs vs frozen stage-05/deeper | 8/8 equal | 8/8 equal | 8/8 equal | agree |
| Arm B FRZ_PRE / with-control | changed=0; clean | FALSE / clean | FALSE / clean | agree |
| FB_KGRID S5 exit; differ vs B; in H; caught_with; caught_without | 0; kappa_sensitivity.csv; TRUE; TRUE; FALSE | same | same | agree |
| FB_TF24 | 0; escalate_dormancy_summary.csv; TRUE; TRUE; FALSE | same | same | agree |
| FB_CLAUSE | 0; inconclusive_by_clause.csv; TRUE; TRUE; FALSE | same | same | agree |
| FB_ROUND | 0; escalate_dormancy_summary.csv; TRUE; TRUE; FALSE | same | same | agree |
| FB_RECLASS S5 exit; in H; caught_with; caught_without | 1; FALSE; TRUE; TRUE | same | same | agree |
| FB_VALSORT S5 exit; outputs vs B; in H; caught_with; caught_without | 0; 8/8 equal; FALSE; TRUE; FALSE | same | same | agree |
| H | {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND} | same, |H|=4 | same | agree |
| caught with control | all six seeded arms | 6/6 | same set | agree |
| D_abl | {FB_RECLASS} | same, |D_abl|=1 | same | agree |
| H \ D_abl | {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND} | same, cardinality 4 | same, nonempty | agree |
| H \ caught-with | {} | ∅ | {} | agree |
| flagged with control, not in H | {FB_RECLASS, FB_VALSORT} | same, cardinality 2 | same | agree |
| P1 | failed | failed | failed | agree |
| Source variants | none | none | none | agree |
| Fixture result rows | header only, 0 rows | 0 data rows | header only | agree |
| Preflight counts | 245193 / 104 | quoted match | 245193 / 104 | agree |
| Seed PRE exits | log: 6/6 = 0 | 6/6 = 0 | table pre_exit 0 | agree |

No hard-number disagreement. Two presentation notes are shared and do not split a RESULTS number. FB_RECLASS emits a changed independent_checks_critical_counts.csv (2c3258e6…, 192 bytes vs B 4aca9c33…, 190 bytes) while s5_outputs_differ_vs_B is blank; both sides still classify the arm as not in H because S5 exit is 1. The runner harness a2868ef5… (3439 bytes) differs from frozen stage-05/run_deeper_analysis.R ed869427… (3443 bytes); the SPEC itself records both and calls the harness a path-only copy. N1 (1 dormant_h + 2 open_age_h, labels agree) is disclosed before execution and is outside the frozen recon definition; it is not a seeded effect and not a Builder/Validator split.

4. The nine KEEP conditions (constitution §7)

All nine are conjunctive. Conditions 4–7 are applied to clean arm B, as instructed.

1. Evidence packs complete and frozen — PASS. FREEZE RECORD names both packs, both verdict_token_leak: false; both reports are present and end on their END lines. Runner evidence is in the packet (C32_RESULTS.md, C32_arms.csv, manifests, run log, seed diffs, C32_EVIDENCE.sha256).
2. Role separation valid — PASS. Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; each attests a single role; freeze record records no verdict-token leak.
3. Builder and Validator agree on hard mechanical facts — PASS. Section 3; every RESULTS set and exit agrees.
4. Exact reconciliation passes where required — PASS on clean arm B under the frozen recon definition. Coordinator note: “B recon is 0/0/0” means only-RA, only-RB, and classification disagreements. The 1/2 full-field hour mismatches are open finding N1 (OF-1), disclosed before execution, not a seeded effect, and excluded from that definition. Stage-5-only arms do not rerun R-A or R-B.
5. Every mandatory fixture passes — PASS for this control’s design. The fixture table is header-only, matching the Stage-5-only rule: no R-A/R-B rerun, no source variants, start from the frozen validated state. Arm B reproduces the frozen stage-05/deeper outputs 8/8.
6. No undeclared semantic change on clean arm B — PASS. Arm B is no-edit plus the declared harness; S5 exit 0; 8/8 outputs equal the frozen deeper files; FRZ_PRE and FRZ_POST changed=0. Seeded semantic effects are scored only through P1.
7. No locked regression on clean arm B — PASS. Run log: B S5 exit=0, FRZ_PRE changed=0, FRZ_POST changed=0. Manifest hashes match the SPEC frozen deeper hashes.
8. Predeclared benefit predicate satisfied — FAIL. SPEC P1 requires arm B clean and H \ D_abl = ∅. Arm B is clean. H \ D_abl = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND} ≠ ∅. Runner RESULTS: “P1 failed.” Both packs recompute the same nonempty difference.
9. No blocking objection remains supported by the frozen evidence — PASS. Validator §6: “None established by the frozen packet as a blocking objection.” The noted inconsistencies do not change H, D_abl, H \ D_abl, or P1 under the frozen definitions.

KEEP fails because condition 8 fails.

5. HALT conditions (constitution §9)

- Hard mechanical results conflict — absent. Section 3; Builder, Validator, and RESULTS agree on exits, sets, and P1.
- Required raw evidence missing — absent. Arms CSV, manifests, run log, seed diffs, freeze hashes, and RESULTS are present. Instruction: do not HALT only because historical stdout is missing; raw evidence is present.
- Hashes or frozen versions mismatch against the FREEZE RECORD — absent. Baseline hashes match. Packs are the named freeze files. The harness/frozen-script hash difference is declared in the SPEC before execution (path-only copy, both hashes listed) and is the script every arm ran; it is not an undeclared mid-run change.
- Baseline or constitution changed mid-run — absent. Constitution 1.0; baseline hashes unchanged in the FREEZE RECORD.
- Role separation violated — absent. Three distinct roles; freeze record verdict_token_leak: false.
- Information barriers breached before first-pass freeze — absent. Both attest blindness; no verdict token in either pack.
- Benefit predicate not operationally defined before execution — absent. SPEC freezes P1 (arm B clean and H \ D_abl = ∅) before the runner.
- Adjudicator cannot determine which frozen evidence pack is authoritative — absent. FREEZE RECORD identifies both packs; both are in this message and complete.

No HALT condition is present.

6. Blocking objections raised by the Validator

Validator §6 states none established as blocking. Three non-blocking notes, and how the evidence bears on them:

- FB_RECLASS independent_checks_critical_counts.csv differs (2c3258e6…, 192 bytes) while s5_outputs_differ_vs_B is blank. Harm H requires S5 exit 0 and a differing standard output. FB_RECLASS S5 exit is 1 (run log 06:11:17; arms CSV; stderr hash non-empty). It is in D_abl and caught_with, not in H. The blank cell is a presentation gap, not a set disagreement.
- Runner harness hash a2868ef5… (3439 bytes) ≠ frozen stage-05/run_deeper_analysis.R ed869427… (3443 bytes). SPEC states the harness is a path-only copy and records the harness hash. Arm B still matches frozen deeper outputs 8/8, so the path-only copy did not change the clean-arm result.
- Fixture table has no rows. Consistent with the Stage-5-only design (no R-A/R-B rerun). Not a missing mandatory fixture result for this control.

None of these is a hard mechanical disagreement, a missing raw artifact, or a freeze-record mismatch. They do not support HALT.

7. Verdict rationale

Removing the control materially changes the outcome on the frozen pack.

With the seal check, FRZ_PRE flags every seeded post-validation edit: all six arms have a changed Stage-5 input (kappa grid, R-A classifications, or validated list). H \ caught-with = ∅.

Without the seal check, detection falls to Stage 5’s own count checks (D_abl = non-zero S5 exit). Only FB_RECLASS is caught that way (10 INCONCLUSIVE labels rewritten to ESCALATE; S5 exit 1). Four harms complete with exit 0 and change a standard Stage-5 output versus arm B:

- FB_KGRID: κ=3 row moves 1,500 rows; kappa_sensitivity.csv hash becomes 12ea0619… (same as the edited grid).
- FB_TF24: timing fields +24 h, labels kept; escalate_dormancy_summary.csv becomes fa12c9be….
- FB_CLAUSE: integrity-clause relabel; inconclusive_by_clause.csv becomes a22d7de5… (58 → 121 bytes).
- FB_ROUND: dormant_h rounded; escalate_dormancy_summary.csv becomes cbdc7804… (138 → 114 bytes).

That is H \ D_abl ≠ ∅. Owner threshold in the SPEC: Fail = post-hoc edits would alter conclusions (keep rule). Arm B itself is clean, so the failure is not a harness defect on the truth reference. Over-blocking cost ({FB_RECLASS, FB_VALSORT}) is reported and not part of P1; FB_VALSORT changes order only and leaves 8/8 outputs equal to B, but that cost does not offset the four escapes.

P1 fails. No HALT condition holds. Constitution §8 and the packet rule: if P1 fails and no HALT condition holds, return REVERT. The control stays. Freeze Before Stage 5 (catalog #32) is not removed.

TERMINAL_STATE: REVERT
END C32 ADJUDICATION
