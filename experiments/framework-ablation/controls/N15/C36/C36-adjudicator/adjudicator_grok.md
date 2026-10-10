1. Role attestation.

I am acting only as Adjudicator for C36, Remaining Ablation Program catalog #36, “No Re-Judging Validation Labels.” Frozen roles are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I did not rerun the ablation, repair code, create a criterion, or relax a gate. This decision uses only the frozen packet: constitution 1.0, the C36 spec, the runner RESULTS and raw C36_arms.csv, arm manifests, seed diffs, the FREEZE RECORD, and the two first-pass reports. No terminal state is taken from either report.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 07:04:57 CDT) names the authoritative packs: Builder C36/C36-builder/builder_report.md, 23,559 bytes, SHA-256 cfd69ccb2e43d9f48cf62ea1ad9fdc0ff7fc8e025bd6e409203ba3127884f8bf, verdict_token_leak: false; Validator C36/C36-validator/validator_report.md, 13,642 bytes, SHA-256 cb74d9b6869a98f2b7f4cccbc23952da00c86c74c49593b3ca83b2f1aa344809, verdict_token_leak: false. The packet presents those two reports as the frozen verbatim files. Each is complete and ends with its END line (END C36 BUILDER REPORT; END C36 VALIDATOR REPORT). Neither report emits a KEEP, REVERT, or HALT token. Baseline framework hashes in the FREEZE RECORD match the BASELINE FRAMEWORK HASHES section and the spec. No hash or frozen-version mismatch against the FREEZE RECORD is present in the packet.

3. Hard-fact agreement table.

| Fact | Builder | Validator | Runner RESULTS | Agreement |
| --- | --- | --- | --- | --- |
| Arm count | 6 (B + 5 seeds) | 6 | 6 rows in C36_arms.csv | agree |
| B Stage-5 exit | 0 | 0 | 0 | agree |
| B outputs vs frozen stage-05/deeper | 8/8 hash match | 8/8 hash match | YES (8/8) | agree |
| B with-control check | clean | clean | clean | agree |
| FRZ_PRE / FRZ_POST | changed=0 on all 6 arms (log and manifests; 81ad521a…ae98f) | same | log changed=0; RESULTS cells blank | agree on the fact (0); blank cells are formatting, not a number conflict |
| Frozen validation artifacts unchanged on every arm | RA_classifications.csv c099e092…ae0d9, RB_kappa_grid_counts.csv 7a18fcb1…52c8a, validated_action_list.csv 2bffa38b…61954a | same three hashes | log changed=0 | agree |
| RJ_INC2ESC | exit 0; 5 label-derived files differ; in_H TRUE; caught_with TRUE; caught_without FALSE | same | same | agree |
| RJ_KAPPA3 | exit 0; 4 label-derived files differ; in_H TRUE; caught_with TRUE; caught_without FALSE | same | same | agree |
| RJ_OPENAGE | exit 0; 4 label-derived files differ; in_H TRUE; caught_with TRUE; caught_without FALSE | same | same | agree |
| RJ_PRECHECK | exit 1; in_H FALSE; caught_with FALSE; caught_without TRUE | same; also notes independent_checks_critical_counts.csv hash differs (e6105c60…) | exit 1; caught_without TRUE; differ-list blank | agree on H membership and exit; check-file difference is outside the H list |
| RJ_BENIGN | exit 0; 0 standard diffs; 1 added file; not in H; not flagged | same; added file hash 09b6590a… | same | agree |
| H | {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE} | same | same | agree |
| caught_with | same three | same | same | agree |
| D_abl | {RJ_PRECHECK} | same | same | agree |
| H \ D_abl | those three; cardinality 3 | same | same | agree |
| H \ caught-with | ∅ | ∅ | ∅ | agree |
| flagged-with but not in H | ∅ | ∅ | ∅ | agree |
| P1 | failed; H \ D_abl nonempty | failed; same set | “P1 failed: H \ D_abl = {RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}” | agree |
| Source preflight | 245,193 and 104 | same hashes and counts | preflight PASS | agree |
| Seed hashes | 5/5 match preflight | 5/5 match SPEC | preflight seed OK | agree |
| Fixture rows in packet | 0 data rows | 0 data rows; no fixture files in manifests | header only | agree |
| N1 | 1 dormant_h + 2 open_age_h; labels agree; outside frozen 0/0/0 recon | same; not treated as blocking | coordinator note: disclosed, not a seeded effect | agree |

No row is a hard-number disagreement on the RESULTS file. Both sides recompute the same exits, sets, and set differences from C36_arms.csv and the manifests.

4. The nine KEEP conditions of constitution §7.
5. Evidence packs complete and frozen: PASS. FREEZE RECORD names both packs, both leak flags are false, and both reports end with their END lines. Runner evidence is the RESULTS file, raw C36_arms.csv, manifests, run log, and seed diffs.
6. Role separation valid: PASS. Distinct models; both reports attest blindness and return no terminal state; FREEZE RECORD verdict_token_leak: false.
7. Builder and Validator agree on hard mechanical facts: PASS. Section 3. The blank freeze columns and the PRECHECK check-file note are recorded by both and do not change any RESULTS hard number.
8. Exact reconciliation passes where required: PASS for clean arm B. This is Stage-5-only. It does not rerun R-A or R-B. Under the frozen recon definition (only-RA, only-RB, classification disagreement), coordinator N1 records B as 0/0/0. The disclosed 1.000 h full-field mismatches (SR22-01936870 dormant_h; SR25-02017553 and SR25-02017556 open_age_h) are outside that definition, labels agree, and every arm’s FRZ_PRE/FRZ_POST is unchanged.
9. Every mandatory fixture passes: PASS for this control. The spec declares a Stage-5-only design and lists no fixture IDs. The fixture table is header-only, and manifests contain no *_fixture_results.csv. That is the expected surface, not a failed fixture. Arm B’s required surface is the frozen Stage-5 reproduction, which is 8/8.
10. No undeclared semantic change: PASS on clean arm B. B’s eight Stage-5 outputs match the frozen stage-05/deeper hashes. The label mutations are the predeclared seeds, scored through P1, not an undeclared change on the clean path. RJ_BENIGN adds one insight file and leaves the eight standard outputs identical to B.
11. No locked regression: PASS on clean arm B. B exits 0, freeze files unchanged, and 8/8 outputs equal the frozen deeper outputs. Spec HALT rule for a non-zero B exit or an 8-output mismatch is not triggered.
12. Predeclared benefit predicate satisfied: FAIL. Spec P1 requires clean B and H \ D_abl = ∅. B is clean, but H \ D_abl = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}. Those three complete with exit 0 and change label-derived outputs. Only RJ_PRECHECK, which re-judges before the input-count checks, exits 1 and is in D_abl. Runner RESULTS states the same failure.
13. No blocking objection remains supported by the frozen evidence: PASS. The Validator’s fixture-gap objection is not supported as blocking: the spec does not mandate a fixture suite for this Stage-5-only control, and the empty table is agreed. The other Validator notes (blank freeze cells, PRECHECK column naming, path-only harness hash a2868ef5… vs frozen script ed869427…) are disclosed or non-blocking and do not conflict with the RESULTS numbers. N1 is a pre-execution open finding, not a seeded effect.

KEEP requires all nine. Condition 8 fails.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3; both packs match the RESULTS sets and exits.
- Required raw evidence missing: absent. RESULTS, raw arms CSV, manifests, run log, seed diffs, and freeze hashes are present. Historical stdout text is not required. Empty fixture rows match the Stage-5-only design.
- Hashes or frozen versions mismatch against the FREEZE RECORD: absent. Baseline hashes match. Both packs are the named frozen reports. Arm-start validation hashes match the spec on every arm.
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the two baseline hashes are stable from spec through FREEZE RECORD.
- Role separation violated: absent. One model per role; reports attest a single role.
- Information barrier breached before first-pass freeze: absent. Both attest blindness; leak flags false.
- Benefit predicate not defined before execution: absent. P1 is in the spec, frozen before the runner.
- Adjudicator cannot tell which pack is authoritative: absent. FREEZE RECORD names both packs and the runner evidence hash.

No HALT condition is present. Spec rule: if P1 fails and no HALT condition holds, REVERT.

6. Blocking objections raised by the Validator, and how the evidence bears on them.

The Validator lists one potential blocking objection: the fixture-results table is empty and no fixture-result files appear in the manifests, so a mandatory fixture suite under constitution §5 cannot be verified. The evidence does not support that as blocking. The spec’s Stage-5-only design does not list fixture IDs, does not rerun R-A or R-B, and starts every arm from the frozen validated state. Builder independently records zero fixture data rows and treats that as design, not a failed suite. Coordinator notes apply §7 conditions 4–7 to clean arm B, and B reproduces the frozen deeper outputs 8/8 with freeze unchanged. An empty fixture table is therefore not missing raw evidence of a required C36 artifact.

The remaining Validator notes are expressly non-blocking and are confirmed as such. Blank frz_pre_changed / frz_post_changed cells disagree with neither the run log nor the manifests, which show changed=0 and a shared FRZ hash. RJ_PRECHECK’s differing independent_checks_critical_counts.csv (e6105c60…, 192 bytes, versus B 4aca9c33…, 190 bytes) is real, but that file is not in the H label-derived list, Stage 5 exited 1, and both packs still place RJ_PRECHECK in D_abl only. The path-only harness hash difference is stated in the spec. N1 is disclosed before execution, labels agree, and it is outside the frozen 0/0/0 recon definition. None of these notes creates a hard-fact conflict or a HALT condition.

7. Verdict rationale.

Removing the control materially changes detection on the frozen pack. With the label-consistency check, the three completed re-judging arms are caught: RJ_INC2ESC promotes long-dormant INCONCLUSIVE to ESCALATE after the input-count stopifnot and changes five label-derived outputs; RJ_KAPPA3 demotes ESCALATE under a κ=3 rule and reports κ=3, changing four outputs; RJ_OPENAGE demotes ESCALATE on diagnostic-only open_age_h < 720, changing four outputs. Without the control, D_abl is only non-zero Stage-5 exit. Those three arms exit 0, so H \ D_abl has three members. The placement contrast confirms the mechanism: the same INC2ESC mutation placed before the count checks (RJ_PRECHECK) exits 1 and is caught without the control; placed after them, it is not. RJ_BENIGN shows the control does not false-flag an added peer-bin table when labels are unchanged, so the control’s over-blocking set on this pack is empty. That does not satisfy P1. P1 requires that removing the check let no harm through. Clean arm B is regression-free, but the ablation does not preserve detection. The control stays.

TERMINAL_STATE: REVERT
END C36 ADJUDICATION
