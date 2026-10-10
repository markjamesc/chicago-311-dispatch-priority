1. Role attestation.

I am acting only as Adjudicator for C43 (Addendum 01b, candidate #43, “Freeze scope”), N13 batch b6. Frozen roles: Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. Constitution 1.0, SHA-256 e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9. I do not rerun the audit, repair code, create criteria, relax a gate, or prefer one side’s mechanical result over the other. “Needed” is applied as the SPEC’s mechanical citation rule (hash with no class-G copy; path or unique file name; intermediate-folder name). OF-1 / N1 is disclosed and out of scope: C43 reads no clock and reruns no R path.

2. Freeze check.

The FREEZE RECORD (EVIDENCE_FREEZE.json, frozen_at_ct 2026-10-03 12:24:23 CDT) names the two packs and binds them by path, bytes, and SHA-256, with verdict_token_leak: false on both:

- Builder: C43/C43-builder/builder_report.md, 19649 bytes, SHA-256 445f74af883d77fca26b1124db37fa460acd0fc00093f050c2046ba104b4701c.
- Validator: C43/C43-validator/validator_report.md, 11261 bytes, SHA-256 4148f956fdbc4adfa519df5d88250d61b0cba06de70a99f50aea5fb87f9b17f4.

The reports in this packet are those frozen packs, presented verbatim. Each is complete and ends with its END line (END C43 BUILDER REPORT; END C43 VALIDATOR REPORT). Neither report contains a KEEP, REVERT, or HALT token. Runner evidence is bound by C43_EVIDENCE.sha256 (C43_RESULTS.md 575ccb49…f5fc, C43_arms.csv 5615083e…81a3, C43_ARM_MANIFESTS.txt 16a70ce4…8110) and by the arm-output manifests. Preflight gating result is PASS; trail index 0fcc3b64ac8d464abec4cdaa33315d7c3009111a9cf5c54a1967897e1fb4c9c9 matches the frozen reference and the AUDIT input manifest. The 16-hex 0fcc3b64ac8d464a in C43_arms.csv is a reporting prefix of that hash, not a mismatch.

3. Hard-fact agreement table.

Runner RESULTS are the authority for the measured numbers. Builder and Validator recomputed the same identities. No row disagrees.

| Fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| Arm | one arm, AUDIT | one arm, AUDIT | AUDIT only | agree |
| Exit / secs | 0 / 35.7 | 0 / 35.7 | exit 0, 35.7 s (11:32:05) | agree |
| Self-test | PASS (3/3) | PASS | selftest=PASS; SELFTEST.txt all three TRUE | agree |
| needed_by_hash | 10 | 10 | 10 | agree |
| needed_by_path_or_name | 2 (both path) | 2 | 2 | agree |
| needed_by_directory | 3 | 3 | 3 | agree |
| Status | INTERMEDIATE_NEEDED | INTERMEDIATE_NEEDED | INTERMEDIATE_NEEDED | agree |
| Distinct hashed artifacts | 14095 | 14095 | 14095 (G 8130 + I 5965) | agree |
| Class-I by rule | 1650+62+3+4210+40=5965 | same | same | agree |
| class_I_bytes_known | 500660758 | 500660758 | 500660758 | agree |
| unresolved_paths | 6868 | 6868 | 6868 | agree |
| citations_total | 11214 | 11214 | 11214 | agree |
| hash_but_G_copy_exists | 11198 (not counted) | 11198 | 11198 | agree |
| Counted citing lines | 16 | 16 | 16 | agree |
| NEEDED.csv identities | 15 rows = 10 hash + 2 path + 3 directory | same | same rows | agree |
| Hash-needed unique SHAs | 5 pairs (HEAD + HEAD.v1) | 10 rows, same five controls | same ten rows | agree |
| Trail files / hash lists / unparsed | 7804 / 598 / 0 | 7804 / 598 / 0 | same | agree |
| Records scanned / excluded | 21 / 3 | 21 / 3 (not re-derived from raw list) | 21 / 3 | agree |
| Trail-index hash | full hash; prefix match | full hash; truncation noted, not a mismatch | prefix 0fcc3b64ac8d464a of frozen 0fcc3b64…c9c9 | agree |
| P1 conditions | 1 fail, 2 fail, 3 met | 1 NOT MET, 2 NOT MET, 3 MET | P1 NOT MET | agree |
| Preflight | PASS | PASS | preflight gating result: PASS | agree |
| OF-1 effect on C43 | none | none | disclosed; C43 reads no clock | agree |

The ten hash hits are the C26, C31, C39, C30, and C29 .HEAD.txt / .HEAD.v1.txt pairs cited by SHA in N15/TOOLS_PATCH_LOG.txt (I5 assembly and I2 superseded; no class-G copy of those SHAs). The two path hits are N15/pc_run_b2.tgz and N15/pc_run_b3.tgz in N15/RESULTS_N15.md. The three directory hits are _interim_b4, _superseded_v0, and _smoke_b3. Builder-only derived ratios (byte share, artifact share) are not contradicted and are not predicate inputs.

4. The nine KEEP conditions of constitution §7.
5. PASS. Both packs are present, bound in the FREEZE RECORD, complete, and closed by their END lines; runner results, raw per-arm files, manifests, logs, and frozen reference hashes are in the packet. (FREEZE RECORD; C43_RESULTS.md; arm manifests.)
6. PASS. Roles are the frozen assignment. Builder and Validator each attest a blind first pass and emit no terminal state. FREEZE RECORD records verdict_token_leak: false for both. (FREEZE RECORD; both report §1.)
7. PASS. No hard-mechanical disagreement. Every predicate count and class identity above is shared. (Agreement table; C43_arms.csv; SUMMARY.txt; NEEDED.csv.)
8. PASS. Where reconciliation is required, it passed: the auditor re-hashes every index copy against INVENTORY and aborts on mismatch; AUDIT exited 0 with no mismatch. The R-A/R-B analytical reconciliation is not a C43 requirement; C43 reads none of that pack. Preflight re-hash of the frozen pack is PASS. (c43_audit.R real-run check; RUN_AUDIT.exit; PREFLIGHT.)
9. PASS. The mandatory known-answer fixture is the self-test declared in the SPEC (planted intermediate hash found; hash with a class-G copy not counted; six paths get the declared classes). SELFTEST.txt: selftest=PASS seed_cite_detected=TRUE clean_not_flagged_with_G_copy=TRUE class_rules=TRUE. (SPEC P1 condition 3; SELFTEST.txt.)
10. PASS. No undeclared semantic change. The tested change is the declared class-I exclusion. The auditor writes only under its output directory and writes nothing into a pipeline. OF-1 is not a C43 semantic delta. (SPEC “Exact change”; constitution §7 conditions 4–5 note in the adjudicator brief.)
11. PASS. No locked regression of a pipeline surface. The arm is read-only on the frozen trail index. Regression/HALT rules in the SPEC (missing run, index mismatch, Builder/Validator hard-number disagreement) are not triggered. Loss of cited intermediates is the benefit predicate, scored in condition 8, not a separate locked-regression failure. (SPEC regression rules; RUN LOG.)
12. FAIL. P1 is the predeclared benefit predicate and is a conjunction. Condition 1 fails (needed_by_hash=10). Condition 2 fails (needed_by_path_or_name=2 and needed_by_directory=3). Condition 3 holds. The conjunction is not met. Runner label: P1 NOT MET. Cost, reported and not scored: 5965 class-I artifacts, 500660758 known bytes. (SPEC P1; C43_RESULTS.md predicate table; NEEDED.csv.)
13. PASS. The Validator’s blocking-objection list is empty. The citation hits are predicate evidence against KEEP, not a defect that blocks adjudication. Disclosed limits of the citation proxy (upper bound; silent use invisible) are in the SPEC and are not a supported blocking objection. (Validator §6.)

All nine are conjunctive. Condition 8 fails, so KEEP is not available.

5. HALT conditions of §9.

- Hard mechanical conflict: absent. Builder, Validator, and runner RESULTS agree on every predicate count. (Agreement table.)
- Required raw evidence missing: absent. Runner results, raw per-arm files (AUDIT_RESULT.txt, NEEDED.csv, counted CITATIONS rows, SELFTEST.txt, SUMMARY.txt, exit file), manifests, logs, and frozen reference hashes are present. The unreproduced body of SEED_DIFFS_b6.txt (hash frozen as 729ed8ca…e2d) is not required raw evidence for P1; the C43 harness files are reproduced and their hashes match preflight. Historical stdout beyond the quoted run log is not a HALT under the adjudicator brief. (C43_RESULTS.md; arm manifests; brief.)
- Hash or frozen-version mismatch: absent. Preflight is PASS. Seed hashes, constitution hash, baseline framework hashes, key-7 pack hashes, and the trail-index hash match the frozen references. The 16-hex trail-index field is a prefix, not a mismatch. (PREFLIGHT; FROZEN REFERENCE HASHES; arm input manifest.)
- Baseline or constitution changed mid-run: absent. Constitution and baseline hashes are the frozen pre-hardening values in SPEC_FREEZE_b6 and the FREEZE RECORD. (SPEC_FREEZE_b6.sha256; FREEZE RECORD.)
- Role separation violated: absent. Three distinct roles; no model holds two. (FREEZE RECORD; both attestations.)
- Information barrier breached before first-pass freeze: absent. Both attest blindness; both leak flags are false; neither report states a terminal state. (FREEZE RECORD.)
- Benefit predicate not defined before execution: absent. “Needed” and P1 are fixed in the frozen SPEC; seeds and eval_b6.R were hashed in SEEDS_b6.sha256 before the reporting run; the scratch check is disclosed as non-reporting. (SPEC P1; pre-execution check.)
- Authoritative pack indeterminate: absent. The FREEZE RECORD names both packs with hashes, and both are the reports in this message. (FREEZE RECORD.)

No HALT condition is present. A failed self-test would have been a HALT; the self-test passed.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises none. Non-blocking observations, and how the evidence bears on them:

- Citation is an upper-bound proxy and silent use is invisible. That limit is declared in the SPEC before execution. It does not license a judgment that the counted citations were not needed. Under the mechanical rule they count. The ten hash rows, two path rows, and three directory rows are enough for P1 conditions 1 and 2 to fail even if some mentions were not causal.
- I5 HEAD files are counted because no class-G artifact has the same SHA, although the SPEC says their text is inside an assembled packet. That is the rule as written (rule a excludes a hit only when a class-G copy has the same SHA). The HEAD.v1 rows are I2 superseded copies of those same historical hashes, also cited in TOOLS_PATCH_LOG.txt. Both classes fail condition 1. I do not reclassify them.
- Trail-index truncation in the arm CSV is a display prefix of 0fcc3b64ac8d464abec4cdaa33315d7c3009111a9cf5c54a1967897e1fb4c9c9. Not a mismatch.
- OF-1 does not enter any C43 number. Not a blocking objection.

The Builder’s note that SEED_DIFFS_b6.txt is hashed but not quoted is a packaging limit, not a Validator blocking objection, and not a HALT: the operational P1 evidence and the C43 seed texts are in the packet.

7. Verdict rationale.

The change under test is narrowing the freeze: hash class G only, and stop hashing class I (scratch, superseded, bundles, page assets, assembly inputs). KEEP requires that no audit or reconstruction record needed a class-I artifact under the predeclared rule. On the frozen trail (N15+N13, mtime cut 2026-10-03 10:52:00 CT, index 0fcc3b64…c9c9), the reporting AUDIT arm found that records did cite class-I artifacts: 10 by hash with no class-G copy, 2 by path, and 3 intermediate directories. P1 is therefore not met. The self-test passed, so this is not a harness HALT. Builder and Validator agree on those counts, so this is not a disagreement HALT.

The proposed narrowing would materially change the hash trail relative to what the frozen records cite. TOOLS_PATCH_LOG.txt cites five historical adjudicator-HEAD hashes that exist only as class-I assembly inputs and superseded copies. RESULTS_N15.md cites the b2 and b3 transfer bundles and the _smoke_b3 scratch directory. Disclosure records cite _interim_b4 and _superseded_v0. Dropping those from the hash scope would leave those citations without a hashed intermediate. That is the REVERT side of the SPEC’s verdict convention. The large uncited mass (I4 page assets are 487189756 of the 500660758 known class-I bytes, and none of the counted rows is I4) does not repair the failed conjunction: one needed intermediate is enough, and fifteen distinct needed identities were found.

The analytical frozen pack is unchanged by this control. OF-1 remains a disclosed one-hour clock difference on three ESCALATE rows and is not a C43 result. Cost of the full scope is reported only: 5965 class-I hashed artifacts and 500660758 known bytes would have been dropped. That cost is not scored.

Mechanics are coherent, HALT conditions are absent, and KEEP condition 8 is not established. Constitution §8: REVERT is the conservative default. The full freeze scope stays.

TERMINAL_STATE: REVERT
END C43 ADJUDICATION
