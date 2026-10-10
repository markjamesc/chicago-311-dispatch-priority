1. Role attestation.

I am Grok, acting as Adjudicator only for C27 (catalog #27, “Fixtures on Both Paths”). Constitution version 1.0. Frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. This is a terminal decision only. I did not rerun the ablation, repair code, create a criterion, relax a gate, or prefer one side’s mechanical result over the other’s.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 04:18:01 CDT) identifies the authoritative packs as C27/C27-builder/builder_report.md (17,478 bytes, SHA-256 040e6c2e035f6b3eed8a5ae1bfe355af860021a49871122a6b899c82be8bfd53, verdict_token_leak: false) and C27/C27-validator/validator_report.md (11,517 bytes, SHA-256 084f9c762f341be0d3f5030aff01bc356adf7853864c52215eb08aafe1eafccd, verdict_token_leak: false). The reports in this packet are those frozen files, presented verbatim. I did not recompute file bytes from the message embedding. Each pack is complete and ends on its required line: Builder on END C27 BUILDER REPORT, Validator on END C27 VALIDATOR REPORT. Neither pack emits KEEP, REVERT, or HALT. Baseline framework hashes in the freeze record match the SPEC and the quoted baseline block: measurement-design 70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c, validation-and-analysis 24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e. Runner evidence is identified by C27_EVIDENCE.sha256 and freeze field runner_evidence_sha256_file 6141017d4f093701a212cf1c871a6615f9452c5cad579576394c5348855c7cad. C27_RESULTS.md is present and is the mechanical source both packs recompute.

3. Hard-fact agreement table.

Notation: agree = Builder, Validator, and runner RESULTS state the same value. No row is a disagreement.

| Fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| Clean R-A / R-B exit | 0 / 0 | 0 / 0 | H1: 0 / 0 | agree |
| Clean R-A / R-B fixtures | 14/14 / 14/14 | 14/14 / 14/14 | H1: 14/14 / 14/14 | agree |
| Clean repro vs frozen RA and RB | 222002/222002, all diffs 0 | same | repro table, all 0 | agree |
| Clean recon n_ra, n_rb, n_inner, only_ra, only_rb, agree, disagree | 222002, 222002, 222002, 0, 0, 222002, 0 | same | clean recon row | agree |
| H2 frozen-label repro and recon 0/0/0 | TRUE | TRUE | H2 TRUE | agree |
| Mutant runs present, all exit 0 | 9/9, exit 0 | 9/9, exit 0 | H3 TRUE; M01–M09 exit 0 | agree |
| D_fix | {M01,M02,M04,M05,M06,M07,M08} | same | H4 same | agree |
| D_abl | {M01,M04,M05,M06} | same | H5 same | agree |
| D_fix \ D_abl | {M02,M07,M08} | same | H6 same | agree |
| Caught by neither | {M03,M09} | same | H7 same | agree |
| M01 fixtures / fail / disagree / prod Δ | 12/14, F03;F10, 16973, 16973 | same | M01 row | agree |
| M02 fixtures / fail / recon / prod Δ | 13/14, F04, 0/0/0, 0 | same | M02 row | agree |
| M03 fixtures / recon / prod Δ | 14/14, 0/0/0, 0 | same | M03 row | agree |
| M04 fixtures / fail / disagree / prod Δ | 13/14, F06, 6377, 6377 | same | M04 row | agree |
| M05 fixtures / fail / n_rb / only_rb / prod Δ | 13/14, F07, 245014, 23012, 23012 | same | M05 row | agree |
| M06 fixtures / fail / n_rb / only_rb / prod Δ | 13/14, F08, 222176, 174, 174 | same | M06 row | agree |
| M07 fixtures / fail / recon / prod Δ | 13/14, F09, 0/0/0, 0 | same | M07 row | agree |
| M08 fixtures / fail / recon / prod Δ | 13/14, F12, 0/0/0, 0 | same | M08 row | agree |
| M09 fixtures / recon / prod Δ | 14/14, 0/0/0, 0 | same | M09 row | agree |
| R-B output hash vs clean | equal {M02,M03,M07,M08,M09}; differ {M01,M04,M05,M06} | same | cited from arm manifests by both | agree |
| P1 | failed; difference non-empty | failed; difference non-empty | H6 non-empty | agree |

Identity checks also agree: M05 222002 + 23012 = 245014; M06 222002 + 174 = 222176; M01 and M04 production deltas equal disagreements; only_ra is 0 on every mutant. Source preflight 245,193 / 104 and hash ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9 agree. No hard number in C27_RESULTS.md is disputed.

4. The nine KEEP conditions (constitution §7).

All nine are conjunctive.

1. Evidence packs complete and frozen. PASS. Freeze record names both packs, both end on their END lines, and verdict_token_leak is false. Runner RESULTS, evidence hash list, and manifests are the frozen mechanical record.
2. Role separation valid. PASS. Three distinct models; each pack attests a single role; neither first pass returns a terminal state (constitution §1; freeze roles).
3. Builder and Validator agree on hard mechanical facts. PASS. Section 3; constitution §4. No conflict on fixture counts, recon fields, D-sets, exits, or output-hash partition.
4. Exact reconciliation passes where required. PASS for the locked regression surface. Clean arm recon is 0/0/0 (C27_RESULTS.md clean recon row; H2 TRUE). This is not a claim that mutant recon is clean.
5. Every mandatory fixture passes. PASS for the locked regression surface. Clean R-A and R-B are 14/14 (H1). Mutant fixture failures are the seeded detection instrument, not a clean-arm regression.
6. No undeclared semantic change detected on the frozen unchanged surfaces. PASS as a clean-arm freeze check. Clean classifications match frozen RA/RB at 222,002 with zero label, only-row, dormant, and open-age diffs; source hash is stable. The detection gap below is the predeclared P1 result, not an undeclared clean-arm mutation.
7. No locked regression introduced. PASS. SPEC regression rule: clean arm B reproduces the frozen pack, recon 0/0/0, fixtures 14/14 on both paths (H1, H2, repro table, recon table).
8. Predeclared benefit predicate satisfied. FAIL. SPEC P1 is satisfied only if D_fix ⊆ D_abl, and failed if D_fix \ D_abl is non-empty. Both packs and H4–H6 give D_fix \ D_abl = {M02, M07, M08}. M03 and M09 are caught by neither and do not count for or against P1.
9. No blocking objection remains supported by the frozen evidence. FAIL. The Validator’s detection-gap objection is the same fact as condition 8 and is supported by the mutant table: M02, M07, and M08 each fail one R-B fixture and still reconcile 0/0/0 with zero production-row change. That objection is not removed by the evidence.

KEEP is unavailable because conditions 8 and 9 fail.

5. HALT conditions (constitution §9).

- Hard mechanical results conflict. Absent. Section 3; both packs match H1–H7 and the mutant table.
- Required raw evidence missing. Absent under this packet’s rule. Runner RESULTS, manifests, recon summary, mutant table, evidence hashes, and logs are present. The instruction forbids HALT solely for missing historical stdout. The Validator’s row-level-CSV objection is noted in section 6 and does not create a Builder/Validator number conflict.
- Hashes or frozen versions mismatch. Absent. Framework hashes match the freeze record and SPEC. Clean output hashes are reported equal to frozen RA/RB classifications by both packs. No pack claims a freeze-file mismatch.
- Baseline or constitution changed mid-run. Absent. Constitution 1.0 and the two baseline hashes are the same in SPEC, freeze record, and both reports.
- Role separation violated. Absent. Freeze roles and both attestations assign one role each.
- Information barrier breached before first-pass freeze. Absent. Both packs state blindness; freeze records verdict_token_leak: false for both.
- Benefit predicate not operationally defined before execution. Absent. SPEC defines D_fix, D_abl, and the subset test before the runner, and both packs apply that definition without restating it.
- Adjudicator cannot tell which pack is authoritative. Absent. Freeze record names both files and their hashes; both are present and complete.

No §9 condition is present. SPEC HALT gates are also absent: clean arm reproduces the frozen pack, all nine mutant runs are present, and Builder and Validator do not disagree on a hard number in C27_RESULTS.md.

6. Blocking objections and the evidence.

Objection 1, missing raw per-fixture actuals, full recon CSVs, row-level classifications, and stdout. The packet does not include those file bodies. It does include C27_RESULTS.md, C27_EVIDENCE.sha256 (including C27_baseline_recon.csv, C27_mutants.csv, C27_repro.csv, C27_ARM_MANIFESTS.txt), and the freeze pointer to the runner evidence hash. The governing instruction says raw evidence is present and that missing historical stdout is not a HALT. The summaries are internally consistent across both packs, so this objection does not authorize HALT and does not erase the agreed D-sets.

Objection 2, M03 and M09 named as fixture-protected deletions (F05, F13) but both 14/14, recon 0/0/0, production delta 0, and output-hash equal to clean R-B. Supported. Both packs record it. SPEC says mutants caught by neither regime do not count for or against P1. It is a coverage gap in the locked suite, not a mechanical disagreement and not a reason to drop M02, M07, or M08 from the difference set.

Objection 3, run_RA.R / run_RB.R listed under output manifests by a case-insensitive filter. Supported as a categorization defect. Both packs say the hashes match the frozen inputs, so it is not an observed code mutation and not a hard-fact conflict.

The objection that remains decisive is the agreed single-sided disparity: M02 (I01 Open+CLOSED_DATE clause deleted, fails F04), M07 (I05 parent clause deleted, fails F09), and M08 (not-Open exclusion deleted, fails F12) are detected only by the second-path fixture run. Each exits 0, has only_ra = only_rb = disagree = 0, changes 0 production rows, and has an R-B output hash equal to clean R-B.

7. Verdict rationale.

Removing the control materially changes detection on the frozen pack. Baseline regime catches seven of nine seeds by R-B fixtures short of 14/14: M01, M02, M04, M05, M06, M07, M08. Ablated regime, R-A fixtures plus exact recon against R-A, catches only M01 (16,973 disagreements), M04 (6,377 disagreements), M05 (23,012 only_rb), and M06 (174 only_rb). The difference {M02, M07, M08} is non-empty, so P1 fails. Those three defects are dormant on this production population: exact reconciliation would trust them. M03 and M09 escape both regimes and are excluded from the predicate, as frozen. Clean arm B is not the failure: it reproduces the frozen labels and recon 0/0/0 with 14/14 on both paths. Mechanics are coherent, no HALT condition holds, and the predeclared benefit is not established. Constitution §8 and the SPEC default therefore require REVERT. The control stays: both paths must pass the locked fixtures before production is trusted.

TERMINAL_STATE: REVERT
END C27 ADJUDICATION
