1. Role attestation

I am acting only as Adjudicator for ablation C18 (catalog #18, “No Fixture Rewrite on Fail”), batch N15 batch 2 of 3, constitution 1.0. Builder is ChatGPT; Validator is DeepSeek; Adjudicator is Grok, as assigned in the SPEC and the FREEZE RECORD. I did not rerun anything, repair code, create a criterion, relax a gate, or prefer one side’s mechanical result over the other’s. This reply states exactly one terminal state.

2. Freeze check

The FREEZE RECORD (frozen_at_ct 2026-10-03 07:04:55 CDT, constitution 1.0, roles Builder=ChatGPT / Validator=DeepSeek / Adjudicator=Grok) identifies the packs that are embedded in this message as frozen and verbatim:

- Builder: C18/C18-builder/builder_report.md, 18987 bytes, SHA-256 6022f163c6a9849180fe86554a5af17fcdca07625470703c9e32aba2dc7966aa, verdict_token_leak: false.
- Validator: C18/C18-validator/validator_report.md, 13346 bytes, SHA-256 b717421854891c0889bb7aa6a982c510c0bf877b1342b0b3510b03fa72e0478d, verdict_token_leak: false.
- Runner evidence file hash recorded as 6daf6bf562091c5babac7b9bcb945ff6c98e6dd1477308a1b1c1b897313cc76e. The packet also gives C18_EVIDENCE.sha256 for C18_ARM_MANIFESTS.txt, C18_arms.csv, and C18_RESULTS.md.

Both reports are complete. The Builder report ends with END C18 BUILDER REPORT. The Validator report ends with END C18 VALIDATOR REPORT. Neither report states KEEP, REVERT, or HALT. Baseline framework hashes in the FREEZE RECORD match the BASELINE FRAMEWORK HASHES block and the SPEC. I treat these as the authoritative frozen packs. No hash or frozen-version mismatch is shown in the packet.

3. Hard-fact agreement table

Facts below are the predeclared mechanical facts. Builder and Validator both recomputed them from C18_RESULTS.md, C18_arms.csv, the raw fixture rows, the manifests, the run log, and the seed diffs. “Agree” means Builder, Validator, and runner RESULTS state the same value.

| Fact | Runner RESULTS | Builder | Validator | Mark |
| --- | --- | --- | --- | --- |
| Arm B exits | RA 0, RB 0 | same | same | agree |
| Arm B fixtures | 14/14, 14/14 | 28/28 pass | 14/14 both paths | agree |
| Arm B vs frozen pack | 0/0/0/0/0 on both paths | same | same; output hashes match frozen RA/RB classifications | agree |
| B recon (frozen definition: only-RA, only-RB, classification) | 0/0/0 | 0/0/0; n=222002 | 0/0/0; n=222002 | agree |
| B full-field clock mismatches (N1) | dormant_h 1, open_age_h 2 | same | same | agree |
| Seeded arms recorded | 8/8 | 8/8; 14/14 path exits 0 | 8/8; no missing run; no crash | agree |
| H | {FX_CM_NOTHIN, RW_CM_NOTHIN, FX_CM_NODUP, RW_CM_NODUP, FX_RB_NOTHIN, RW_RB_NOTHIN} | same, size 6 | same, size 6 | agree |
| H_RW | the three RW arms in H | {RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN} | same | agree |
| D_abl (RW caught after rewrite) | {RW_RB_NOTHIN} (H5) | same | same | agree |
| H_RW \ D_abl | {RW_CM_NOTHIN, RW_CM_NODUP} (H6) | same, size 2 | same, size 2 | agree |
| No locked-field change | {FX_CM_NOI01, RW_CM_NOI01} (H7) | same | same | agree |
| Caught with control | {FX_CM_NOTHIN, FX_CM_NODUP, FX_CM_NOI01, FX_RB_NOTHIN} (H8) | same | same | agree |
| FX arms in H not caught | {} (H9) | same | same | agree |
| NOTHIN locked changes | 12754 = 6377+6377 labels | same | same | agree |
| NODUP locked changes | 46024 = 23012+23012 only_x | same | same | agree |
| RB-only NOTHIN | 6377 label changes; recon_disagree 6377 | same; n_agree 215625 | same | agree |
| NOI01 locked changes | 0; F04 fails under FX, passes under RW | same; production hashes equal B | same | agree |
| FX fail / RW pass | F06, F07, F04 fail on FX; corresponding RW rows pass | same, from raw rows | same, from raw rows | agree |
| P1 subset H_RW ⊆ D_abl | not met (H6 non-empty) | not met | not met | agree |

Non-conflicts, recorded so they are not mistaken for hard disagreement: both sides note that C18_arms.csv puts a TRUE in caught_without_control on some FX rows, while H5 and the SPEC restrict D_abl to RW arms. Both recomputed catch status from exits, recon, and raw fixture rows and got H5/H8. The Builder notes that RA_NODUP_RW also flips F07 in_set from FALSE to TRUE; that mutation is in the frozen SEED DIFFS, and FX_CM_NODUP and RW_CM_NODUP production classification and portfolio hashes are identical, so it does not change the locked-field counts. The Validator notes F14’s path-specific expected label (TWO_INDEPENDENT_LABELS on RA, STANDARD|STANDARD on RB); both B paths still pass F14, and B recon remains 0/0/0. None of these is a disagreement on a hard number in the RESULTS file.

4. The nine KEEP conditions (constitution §7)

Conditions 4–7 are applied to clean arm B. Seeded-arm effects are applied through P1 (conditions 8–9), as instructed.

1. Evidence packs complete and frozen: PASS. FREEZE RECORD names both packs, both end with their END lines, verdict_token_leak is false, and the packet contains runner RESULTS, C18_arms.csv, raw fixture rows, manifests, run log, preflight, and seed diffs.
2. Role separation valid: PASS. Three distinct roles in the SPEC and FREEZE RECORD; each report attests a single blind first-pass role and states no terminal state.
3. Builder and Validator agree on hard mechanical facts: PASS. Section 3; every RESULTS hard fact H1–H9 is agreed, including H6 = {RW_CM_NOTHIN, RW_CM_NODUP}.
4. Exact reconciliation passes where required: PASS for arm B. RESULTS repro table is 0/0/0/0/0 against frozen RA and RB classifications; B recon is 0/0/0. The dormant_h 1 and open_age_h 2 mismatches are disclosed open finding N1 and are outside the frozen recon definition (SPEC “Known open finding N1”; coordinator note).
5. Every mandatory fixture passes: PASS for arm B. RESULTS H1 and the raw B fixture rows are 14/14 on both paths.
6. No undeclared semantic change on the clean arm: PASS. Arm B inputs are the frozen code and frozen source (manifest hashes match the preflight frozen OK lines); B outputs match the frozen classification hashes. The fixture rewrites exist only on the declared RW seeds.
7. No locked regression on the clean arm: PASS. Arm B has 0 key, label, dormant_h, and open_age_h differences versus the frozen pack (RESULTS repro table).
8. Predeclared benefit predicate satisfied: FAIL. SPEC P1 is H_RW ⊆ D_abl, with failure defined as a non-empty H_RW \ D_abl: a defect that changes a locked output field and still passes after its fixture is rewritten. H_RW = {RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN}; D_abl = {RW_RB_NOTHIN}; H_RW \ D_abl = {RW_CM_NOTHIN, RW_CM_NODUP}. RW_CM_NOTHIN has 12754 locked label changes and 14/14 rewritten fixtures with recon 0/0/0. RW_CM_NODUP has 46024 locked key-set changes and 14/14 rewritten fixtures with recon 0/0/0. Owner threshold text: “Fail: Changing fixtures was required (keep rule).”
9. No blocking objection remains supported by the frozen evidence: PASS. Validator §6: “No blocking objection is supported by the frozen packet under the frozen definitions.” The three open findings it lists are expressly not blocking, and the evidence agrees (section 6 below). The P1 failure is condition 8, not a residual blocking objection.

The nine conditions are conjunctive. Condition 8 fails, so KEEP is not available.

5. HALT conditions (constitution §9)

- Hard mechanical results conflict: absent. Section 3; Builder and Validator agree on every RESULTS hard number, including H4–H9.
- Required raw evidence missing: absent. Runner results, raw fixture rows, C18_arms.csv, manifests, run log, preflight, and seed diffs are in the packet. Stdout bodies are not pasted; only hashes, byte counts, and the run-log exits are. The adjudication instruction says raw evidence is present and not to HALT only because historical stdout is missing.
- Hashes or frozen versions mismatch: absent. Preflight frozen OK lines match the SPEC hashes for source, frozen code, and all C18 seeds; baseline hashes match the FREEZE RECORD; B output hashes match the frozen classification hashes.
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the same baseline hashes appear in the SPEC, the baseline block, and the FREEZE RECORD.
- Role separation violated: absent. One model per role; no verdict token in either pack.
- Information barrier breached before first-pass freeze: absent. Both reports attest blindness; FREEZE RECORD records verdict_token_leak: false for both.
- Benefit predicate not operationally defined before execution: absent. P1, H_RW, D_abl, and the owner pass/fail sentence are in the SPEC, frozen before the runner (SPEC “Frozen at CT: 2026-10-03, before the runner executed”).
- Adjudicator cannot tell which pack is authoritative: absent. FREEZE RECORD names one Builder pack and one Validator pack, and both are the reports in this message.

No HALT condition is present. The instruction then requires REVERT when P1 fails.

6. Blocking objections raised by the Validator

The Validator raised no blocking objection. Three open findings, and how the evidence bears on them:

- N1. B full-field recon is dormant_h 1 and open_age_h 2, on SR22-01936870 and SR25-02017553 / SR25-02017556, labels agreeing. This was disclosed before execution, is present on clean B and every seeded recon row, and is excluded from the frozen “B recon 0/0/0” definition. It is not a seeded effect and not a harness conflict. It does not support a blocking objection.
- F14 path-specific expectation. Raw rows show B RA F14 TWO_INDEPENDENT_LABELS and B RB F14 STANDARD|STANDARD, both passing. B recon key/label is still 0/0/0. The packet has no external rule that the two paths must share one expected string. This does not support a blocking objection.
- Raw caught_without_control column. The CSV puts TRUE on some FX rows, while SPEC D_abl and RESULTS H5 are RW-only. Both sides recomputed from exits, recon, and fixture rows and matched H5 = {RW_RB_NOTHIN} and H8. This is a column-label quirk, not a hard-number conflict, and does not support a blocking objection.

The Builder’s in_set note is likewise not a blocking objection: the extra F07 field change is in the frozen seed diff, and it does not alter the locked production outputs relative to the FX twin.

7. Verdict rationale

Removing the control materially changed the outcome on the frozen pack. With the control, frozen fixtures caught every FX arm: F06 failed on both paths of FX_CM_NOTHIN and on RB of FX_RB_NOTHIN; F07 failed on both paths of FX_CM_NODUP; F04 failed on both paths of FX_CM_NOI01. After the declared rewrite, those same defects passed 14/14.

Two of the rewritten arms are the P1 counterexamples. RW_CM_NOTHIN still changes 6377 classifications on each path (12754 locked-field changes) and is not caught, because both paths carry the same defect, so recon stays 0/0/0, and rewritten F06 is green. RW_CM_NODUP still adds 23012 keys on each path (46024 locked-field changes) and is not caught for the same common-mode reason after F07 is rewritten. Production classification and portfolio hashes are identical between each FX arm and its RW twin, so the rewrite hid the defect rather than removing it. RW_RB_NOTHIN remains caught only because the unseeded RA path still disagrees on 6377 labels; that overlap does not cover the common-mode case. NOI01 shows the fixture can fire with zero locked-field change on this pack; under the frozen predicate those arms do not count for or against P1.

The mechanics are coherent, the packs agree, and no HALT condition holds. P1 fails. The conservative rule in the packet and constitution §8 is REVERT: the control stays, and catalog #18 is not removed.

TERMINAL_STATE: REVERT
END C18 ADJUDICATION
