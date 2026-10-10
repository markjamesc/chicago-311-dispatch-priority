1. Role attestation.

I am acting only as Adjudicator for C14, Remaining Ablation Program catalog #14, “Explicit Semantics (Open/Elig.),” N15 batch 2 of 3, Constitution v1.0. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT; FREEZE RECORD roles). This adjudication uses only the frozen packet. I did not rerun code, repair artifacts, create a criterion, relax a gate, or prefer one side’s mechanical result over the other’s.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 07:04:47 CDT, constitution 1.0) identifies the Builder pack as C14/C14-builder/builder_report.md, 18371 bytes, SHA-256 23f091a28c3dbaa1f86b97bccb5da1bd0afe1a3481ecc3aee30afd020b5d1505, verdict_token_leak: false, and the Validator pack as C14/C14-validator/validator_report.md, 7603 bytes, SHA-256 8ebff3eec8c938c51e334be089d5c0ad23381be5807451c3b489ba605a0092c6, verdict_token_leak: false. The packet supplies those two reports as the frozen verbatim packs. Each is complete and ends with its required END line: “END C14 BUILDER REPORT” and “END C14 VALIDATOR REPORT.” Neither report emits a terminal KEEP, REVERT, or HALT, which matches verdict_token_leak: false. Runner evidence is identified by runner_evidence_sha256_file 24a290669b3c53d08a0d096453356e947000891a77cf7bc4d5805ba1746e5fd9, and the in-packet evidence file C14_EVIDENCE.sha256 hashes C14_ARM_MANIFESTS.txt, C14_arms.csv, and C14_RESULTS.md. Baseline framework hashes in the FREEZE RECORD match the BASELINE FRAMEWORK HASHES block. Preflight reports frozen source, frozen code, and C14 seed hashes OK. I treat the included reports as the freeze-record files. No hash or frozen-version mismatch is stated in the packet.

3. Hard-fact agreement table.

Builder and Validator both recompute from the runner RESULTS, C14_arms.csv, fixture rows, and manifests. They agree with each other and with the runner on every predeclared hard fact.

| Fact | Runner RESULTS | Builder | Validator | Mark |
| --- | --- | --- | --- | --- |
| Arm B exits | R-A 0, R-B 0 | 0 / 0 | 0 / 0 | agree |
| Arm B fixtures | 14/14, 14/14 | 14/14 both | 14/14 both | agree |
| B vs frozen pack | 0 key/label/dormant/open_age on both paths | 0 on both paths | 0 on both paths | agree |
| B recon (frozen definition) | 0/0/0 | 0/0/0 | 0/0/0 | agree |
| B full-field dormant_h / open_age_h | 1 / 2 | 1 / 2 | 1 / 2 | agree |
| Seeded arms with runs recorded | 6/6 | 6/6 | 6/6 | agree |
| H | DUPKEEP_RB, DUPKEEP_CM, NOPEER_RB, NOPEER_CM, LEGACYIN_CM | same five | same five | agree |
| D_abl (caught without control) | DUPKEEP_RB, DUPKEEP_CM, NOPEER_RB, LEGACYIN_CM | same four | same four | agree |
| H \ D_abl | {SEM_NOPEER_CM} | {SEM_NOPEER_CM} | {SEM_NOPEER_CM} | agree |
| No locked-field change | {SEM_OPENEXACT_CM} | {SEM_OPENEXACT_CM} | {SEM_OPENEXACT_CM} | agree |
| DUPKEEP_RB locked changes | 23012; recon only_rb 23012; F07 fail | 23012; F07 fail | 23012; F07 fail | agree |
| DUPKEEP_CM locked changes | 46024; recon 0/0/0; F07 fail both | 46024; F07 both | 46024; F07 both | agree |
| NOPEER_RB locked changes | 6315; recon only_ra 6315; fixtures 14/14 | 6315; recon catch | 6315; recon catch | agree |
| NOPEER_CM locked changes | 12630; recon 0/0/0; fixtures 14/14 both; caught_without_control FALSE | 12630; not caught | 12630; not caught | agree |
| LEGACYIN_CM locked changes | 348; recon 0/0/0; F08 fail both | 348; F08 both | 348; F08 both | agree |
| OPENEXACT_CM locked changes | 0; recon 0/0/0; fixtures 14/14; harm FALSE | 0; not in H | 0; not in H | agree |
| Source arithmetic | 245193; dup 23017; legacy 179; no-peer 6443 | overlap 5; dup-only 23012; legacy-only 174; no-peer surviving 6315 | same identities | agree |
| P1 | H6 nonempty | P1 failed condition met | P1 failed condition met | agree |

No hard-fact row is marked disagree. The persistent 1/2 full-field mismatches are the disclosed N1 finding on every arm, including B, and are outside the frozen recon definition (COORDINATOR NOTE N1; SPEC “Known open finding N1”; RESULTS H2).

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are complete and frozen: FREEZE RECORD names both packs with hashes and verdict_token_leak: false; both reports end with their END lines; runner RESULTS, C14_arms.csv, fixture rows, arm manifests, seed diffs, preflight, and C14_EVIDENCE.sha256 are in the packet (Constitution §3, §7.1; FREEZE RECORD).
6. PASS. Role separation is valid. Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; each model holds one role. Both first-pass reports attest blindness and return no terminal state (Constitution §1; SPEC Roles; FREEZE RECORD).
7. PASS. Builder and Validator agree on the hard mechanical facts in section 3, including H, D_abl, H \ D_abl, arm-B recon 0/0/0, fixture summaries, and locked-field counts (Constitution §4, §7.3; RESULTS H1–H7; both reports §3).
8. PASS. Exact reconciliation passes where required on clean arm B: B vs frozen RA and frozen RB is 0/0/0/0/0 on key, label, dormant_h, and open_age_h; B recon under the frozen definition is 0/0/0 (RESULTS “Arm B repro” and “Arm B recon”; SPEC HALT rule; N1 excludes dormant_h and open_age_h from that rule). Constitution §7 conditions 4–7 apply to clean arm B.
9. PASS. Every mandatory fixture passes on clean arm B: F01–F14 TRUE on R-A and on R-B (FIXTURE RESULTS arm B; RESULTS H1). Seeded fixture failures are the intended detection events, not a clean-arm failure.
10. PASS. No undeclared semantic change is detected on clean arm B. B inputs are the frozen source and frozen code; B outputs match the frozen classification hashes in the preflight (c099e092… RA, a0e42b86… RB). Seeded semantic edits are declared in the SPEC and SEED DIFFS and appear only on seeded arms (ARM MANIFESTS; Constitution §5, §7.6).
11. PASS. No locked regression is introduced on clean arm B. B reproduces the frozen pack on key, label, dormant_h, and open_age_h, and B fixtures are 14/14 on both paths (RESULTS H2, H1). The 1/2 full-field mismatches are the predeclared N1 pack property, not a regression from this ablation.
12. FAIL. The predeclared benefit predicate is not satisfied. SPEC P1: satisfied only if H ⊆ D_abl; failed if H \ D_abl is non-empty. RESULTS H4–H6 and both independent recomputations give H \ D_abl = {SEM_NOPEER_CM}. That arm changes locked fields (6315 keys dropped on each path, 12630 locked-field changes), exits 0, recon 0/0/0, and fixtures 14/14 on both paths, so caught_without_control is FALSE (RESULTS seeded-arm row; C14_arms.csv; Builder §4; Validator §5). SEM_OPENEXACT_CM has no locked-field change and does not count for or against P1.
13. PASS. No blocking objection remains supported by the frozen evidence. The Validator lists none. The SEM_NOPEER_CM miss is the P1 result under the frozen predicate, not a harness defect (Validator §6). N1 is disclosed, frozen, and excluded from the recon HALT rule.

KEEP requires all nine. Condition 8 fails, so KEEP is not available.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3 is agree on every row (Constitution §4, §9; both reports).
- Required raw evidence missing: absent. Runner RESULTS, raw C14_arms.csv, fixture rows, manifests, seed diffs, run log, and preflight are present. Historical stdout text is not required; hashes and sizes of RUN_*.stdout/stderr are in the manifests (packet rule; Constitution §3).
- Hashes or frozen versions mismatch: absent. Preflight frozen OK on source, code, and seeds; baseline hashes match the FREEZE RECORD; reports are the freeze-record packs (PREFLIGHT; FREEZE RECORD).
- Baseline or constitution changed mid-run: absent. Constitution version 1.0 is the frozen version; baseline hashes are the A01–A08 hashes (SPEC; FREEZE RECORD).
- Role separation violated: absent. Three distinct roles; no model holds more than one (SPEC Roles; Constitution §1).
- Information barriers breached before first-pass freeze: absent. Both reports attest an independent blind first pass; freeze record marks verdict_token_leak: false for both packs.
- Benefit predicate not operationally defined before execution: absent. P1 is frozen in the SPEC before execution, with an owner threshold and a checkable H ⊆ D_abl rule (SPEC “Operational benefit predicate P1”; Constitution §6).
- Adjudicator cannot determine which frozen evidence pack is authoritative: absent. One FREEZE RECORD names one Builder pack and one Validator pack; runner evidence is the RESULTS / arms / fixture / manifest set.

No §9 HALT condition is present. The packet rule applies: if P1 fails and no HALT condition holds, return REVERT.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no blocking objection (Validator §6). It treats N1 as disclosed and excluded from the frozen recon definition, treats all six seeded exits as recorded, and treats visible hashes as matching. It expressly classifies the SEM_NOPEER_CM miss as a P1 result, not a harness defect.

That reading is supported. SEM_NOPEER_CM is a declared common-mode seed: both paths read “eligible” as “has peer statistics” (SPEC seeded readings; SEED DIFFS). Against arm B it drops 6315 keys on each path (RESULTS; overlap arithmetic: 6443 no-peer source rows minus 128 already outside B). Reconciliation stays 0/0/0 because both paths drop the same keys. F01–F14 pass on both paths (FIXTURE RESULTS). D_abl is crash, recon key/label mismatch, or fixture failure; none of those fire. Duplicate and legacy common-mode seeds are still caught by F07 and F08. The no-peer reading is not. That is the operational failure of the ablation, not a disagreement about a hard number and not a reason to HALT.

7. Verdict rationale.

Removing the control materially changes the outcome on the frozen pack, and the change is not fully caught. With the lock, arm B applies the locked open / eligibility / duplicate / legacy definitions, reproduces the frozen pack, reconciles 0/0/0 under the frozen definition, and passes 14/14 on both paths. Without the lock, five seeded readings change locked fields. Four are caught: DUPKEEP_RB by recon and F07, DUPKEEP_CM by F07 on both paths, NOPEER_RB by recon key mismatch, LEGACYIN_CM by F08 on both paths. SEM_NOPEER_CM is not caught: 12630 locked-field changes, recon 0/0/0, fixtures 14/14, exits 0. SEM_OPENEXACT_CM changes no locked field on this pack because every source STATUS is already the exact token “Open”; it is outside H and does not rescue P1. The owner predicate is “Pass: No semantic ambiguity arises without lock. Fail: Differing interpretations occur (keep rule).” The frozen operationalization of that predicate fails because H \ D_abl is non-empty. Mechanics are coherent, HALT conditions are absent, and KEEP condition 8 is not established. Constitution §8 and the packet default therefore require REVERT. The control stays. Explicit Semantics, Open/Eligibility (catalog #14) is not removed.

TERMINAL_STATE: REVERT
END C14 ADJUDICATION
