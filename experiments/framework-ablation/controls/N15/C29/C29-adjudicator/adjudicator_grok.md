1. Role attestation.

I am acting as Adjudicator only for ablation C29 (catalog #29, Reconciliation Investigation), N15 batch 1 of 3, Constitution 1.0. Frozen roles are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I did not rerun code, repair artifacts, add a criterion, or relax a gate. Terminal disposition is made only from the frozen packet.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 05:33:53 CDT) names the Builder pack C29/C29-builder/builder_report.md, 15738 bytes, SHA-256 758ba55dea01af2e2500089a3a808c547cec857b85477e308b27c67de57f7165, verdict_token_leak: false, and the Validator pack C29/C29-validator/validator_report.md, 13564 bytes, SHA-256 e687b9917e83e700170ac6479bb87a36e86b42b2b517a47baa2465ad7daf92bd, verdict_token_leak: false. The reports in this message are those packs, presented verbatim. Each is complete and ends with its END line: END C29 BUILDER REPORT and END C29 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Runner evidence file hash in the freeze record is f655dc91fcf421d64e5b981e61cf877b986b4a00afe1c150d19d6a0e906fc41b; C29_EVIDENCE.sha256 hashes C29_RESULTS.md as 42a152c0d099eccef53e2553ad0a7e0ead6da2ef07f8b5ddda26c006d0638d5e. No hash or frozen-version contradiction is stated in the packet.

3. Hard-fact agreement table.

| Fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| Arm B exits | RA 0, RB 0 | RA 0, RB 0 | H1: both 0 | agree |
| Arm B fixtures | 14/14 and 14/14 (28/28) | 14/14 and 14/14 | H1: 14/14, 14/14 | agree |
| Arm B vs frozen classifications | all five cells 0 on both paths | all five cells 0 on both paths | repro table all 0 | agree |
| Arm B key/label recon | only-RA 0, only-RB 0, disagree 0 | same | recon row 0 / 0 / 0 | agree |
| Arm B full-field recon | dormant 1, open_age 2 | dormant 1, open_age 2 | H2 and recon row: 1 and 2 | agree |
| H2 “B recon is 0/0/0: TRUE” | quoted as key/label identity, with 1/2 stated separately | flagged as ambiguous if 0/0/0 includes dormant/open_age; table values identical | H2 asserts TRUE and, in the same line, reports dormant_h 1, open_age_h 2 | agree on numbers; wording dispute only |
| Seeded runs recorded | 4/4, all exit 0 | 4/4, all exit 0 | H3: 4/4 | agree |
| NODUP locked change | 23012 extra keys each arm; F07 fail on seeded path | same | arm rows 23012; fx 13/14 (F07) | agree |
| NOTHIN locked change | 6377 label diffs each arm; F06 fail on seeded path | same | arm rows 6377; fx 13/14 (F06) | agree |
| Harm set H | all four arms | all four arms | H4: all four | agree |
| Mismatch-visible | all four; H minus visible empty | all four; H6 {} | H5 all four; H6 {} | agree |
| Auto-resolution equals arm B | 4/12 | 4/12 | H8: 4/12 | agree |
| Differing scenario×rule pairs | the same eight pairs | the same eight pairs | H9: the same eight pairs | agree |
| Equal pairs | the four unseeded-side copies | the same four | resolution table: those four TRUE | agree |
| max_severity | differs in 4/4; NOTHIN residual 24 labels | differs in 4/4; 24 not re-derivable from aggregates alone | resolution rows: 23012 / 23012 / 24 / 24, all FALSE | agree on reported counts |
| P1 | not satisfied (4/12, not 12/12) | not satisfied (4/12, not 12/12) | H8/H9 | agree |
| Seed diffs | four one-line defects as specified | four diffs match SPEC | SPEC seed hashes cited by both | agree |

No hard numerical conflict. Both packs reproduce H8, H9, the 23012/6377/24 counts, and the arm-B 0/0/0 key-label row with dormant 1 and open_age 2.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are the freeze-record files, complete, ending at their END lines, leak flags false. Runner RESULTS, resolution CSV, arm CSV, and manifests are hashed in C29_EVIDENCE.sha256.
6. PASS. Roles are three distinct models; both first-pass reports attest blindness; freeze record verdict_token_leak: false on both packs (constitution §1).
7. PASS. Builder and Validator agree on every predeclared hard number in the table above, including H1–H9 and the twelve-row resolution matrix (constitution §4).
8. PASS on the reconciliation the SPEC halt line requires. H2 asserts “B recon is 0/0/0: TRUE”; the recon table is only-RA 0, only-RB 0, disagree 0; the repro table is 0 on key, label, dormant_h, and open_age_h against each path’s own frozen classification. The cross-path dormant_h 1 and open_age_h 2 are the same counts in B and every seed, and coordinator N1 identifies them as a latent frozen-pack baseline (three ESCALATE rows, labels agree, |d| = 1.000 h), not an ablation-induced recon failure. Conditions 4–7 are applied to clean arm B, as instructed.
9. PASS. Clean arm B fixtures are 14/14 on R-A and 14/14 on R-B (H1; both packs). Seeded F06/F07 failures are seeded-arm effects and are scored through P1, not as a clean-arm fixture fail.
10. PASS. Declared change is the three shortcut rules in place of investigation and rerun (SPEC, Exact change). Clean arm B reproduces the frozen pack on every locked field versus frozen RA and RB classifications. No undeclared semantic change on arm B.
11. PASS. No locked regression on clean arm B: repro table all zeros; fixtures 14/14; exits 0. The 1/2 hour mismatches are baseline cross-path, present before the ablation (coordinator N1; H2).
12. FAIL. P1 requires every scenario × rule resolution (4 × 3 = 12) to equal arm B on key set and classification (SPEC, Operational benefit predicate P1). RESULTS H8 is 4/12; H9 lists eight differing pairs. Both packs recompute 4 TRUE and 8 FALSE. The four TRUE rows are only copies of the unseeded side.
13. PASS. No Validator objection remains supported as a block once the frozen evidence is read. See section 6. P1 failure is condition 8, not an open mechanical conflict.

KEEP requires all nine. Condition 8 fails. KEEP is not available.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Both packs and RESULTS agree on H1–H9, 23012, 6377, 24, and the eight differing pairs (section 3). The 0/0/0 wording dispute is not a numerical conflict.
- Required raw evidence missing: absent for adjudication. The packet supplies runner RESULTS, C29_arms.csv, C29_resolution.csv, fixture rows, manifests, preflight, and logs. Owner instruction: raw evidence is present; do not HALT only because historical stdout is missing. Row-level ID lists are not in the packet; both sides still agree on the aggregates those lists would sum to.
- Hashes or frozen versions mismatch: absent. Freeze record, baseline hashes, preflight frozen-OK lines, and seed hashes are cited consistently; no contrary hash is in the packet.
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the two baseline SHA-256 values are the frozen SPEC values; coordinator note states nothing in the spec, predicate, or numbers changed.
- Role separation violated: absent. Three roles; leak flags false; both reports attest a single role and blindness.
- Information barrier breached before first-pass freeze: absent. Both reports attest no access to the other first pass; freeze record records leak false.
- Benefit predicate not defined before execution: absent. P1 is in the SPEC frozen before the runner (SPEC lines on P1 outcomes; freeze at 2026-10-03 before execution).
- Adjudicator cannot tell which pack is authoritative: absent. One Builder pack and one Validator pack, each named and hashed in the FREEZE RECORD, both ending at their END lines.

SPEC regression text (“HALT if … B recon is not 0/0/0”) is not triggered: H2 asserts that predicate TRUE, and both packs accept the underlying 0/0/0 key-label counts. The disclosed full-field 1/2 counts are baseline, not a mid-run change.

6. Blocking objections raised by the Validator and how the evidence bears on them.

B recon “0/0/0” versus dormant 1 / open_age 2. Not supported as a halt or as a hard disagreement. H2 states both facts in one line. The recon table both packs quote is only-RA 0, only-RB 0, disagree 0, dormant_mismatch 1, open_age_mismatch 2. The repro table is all zeros against frozen classifications, so each path matches its own frozen artifact on dormant_h and open_age_h. Coordinator N1 names the three rows (SR22-01936870 dormant_h; SR25-02017553 and SR25-02017556 open_age_h), labels agree, difference exactly 1.000 h, latent in the frozen pack. The same 1 and 2 appear on every seeded arm, so the seeds did not create them. Builder and Validator report the same counts.

Missing row-level files for the 23012 and 6377 sets, the three hour rows, and the max_severity residual of 24. Not a halt under the owner evidence rule. Aggregates are in RESULTS, C29_arms.csv, and C29_resolution.csv, and both packs recompute the same aggregates. The 24 cannot be re-derived from recon_disagree=6377 alone; it is still the reported resolution count, and both packs treat it as a difference from arm B, which is enough for P1.

caught_with_control = NA. Not a supported block. SPEC says the control regime reproduces arm B by construction (investigation and rerun on frozen code). H5 already records all four seeded arms as mismatch-visible (key/label recon or fixture failure). A crash is not required; all seeded exits are 0.

7. Verdict rationale.

Removing Reconciliation Investigation materially changes the outcome on the frozen pack. With the control, a mismatch is investigated and the defective path is rerun, which the SPEC defines as reproducing arm B. Without it, the three frozen shortcuts auto-resolve. Of 12 scenario × rule resolutions, 8 differ from arm B key set and classification (H8 4/12; H9). Copying the defective side keeps 23012 extra keys (NODUP) or 6377 wrong labels (NOTHIN). max_severity equals arm B in 0/4 scenarios: it retains the 23012 extra keys, and on NOTHIN it still leaves 24 labels different from arm B. The four matches are only copies of the unseeded side; the shortcut has no fact that identifies which side is defective. All four seeds are in the harm set and are visible to the remaining checks, so the failure is not hidden detection; it is truth divergence after shortcut resolution. P1 fails. No HALT condition holds. The conservative default is REVERT: the control stays.

TERMINAL_STATE: REVERT
END C29 ADJUDICATION
