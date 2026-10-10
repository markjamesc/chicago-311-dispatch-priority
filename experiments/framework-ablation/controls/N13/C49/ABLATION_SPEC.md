# C49 — Ablation specification (FROZEN)

**Ablation ID:** C49 (Addendum 02, candidate #49 "Individual-file evidence delivery")
**Batch:** N13 batch 6 (controls C43, C49, C44, C40; owner approval 2026-10-03 10:52 CT; built the way batch b5 was built)
**Definitions and approval (operational definitions, constitution §9):** Definitions: `ablation_plan/ADDENDUM_01_control_39.md` SHA-256 `a3bf8f6a6b27a670c8a3dde85e7fe51a53febfff298d2e70b2f3511e82de5b4f` (#40, #43) and `ablation_plan/ADDENDUM_02_pricepoint_candidates.md` SHA-256 `5d8756efbed04f168f3d53e2d8fab8064503752bd04f8c61b670cf81f9c757a6` (#44, #49; #40 evidence). Owner approval of #43, #49, #44, #40: 2026-10-03 10:52 CT (blockers in `N13/SELECTION_N13.md` SHA-256 `f6fd85c5137f27710a1b38e24836b3b473a720b5f221f57a38c43b8f11547c8f`). Owner rulings batch 01 (`OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba`) apply where cited (41A depth gate, 48A, 53A clock rule).
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Extra chats: 3** (reviewer first passes, all blind to this ablation, each frozen before the Builder/Validator packets are built): **DS_ZIP** (DeepSeek, one zip), **DS_FILES** (DeepSeek, 10 individual files), **GPT_FILES** (ChatGPT, 10 individual files). No Grok arm (SuperGrok usage); DeepSeek is the model that failed in PricePoint and receives each format once, as the addendum asks. Role overlap: DeepSeek is also the Validator and ChatGPT also the Builder; the reviewer chats are separate conversations.
**Usage priority (owner):** SuperGrok usage is the scarcest resource; extra chats are kept to the smallest number the test validly allows, and no extra chat uses Grok.
**Target stage:** Stage 5 first-pass evidence delivery (proposed addition)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b6/run_batch_v6.ps1`, evaluator `runner_b6/eval_b6.R`; R only, no MySQL, no git)

## Control under test (Addendum 02 #49)
Rule as it stands: no rule; PricePoint sent one zip to the Stage 5 first passes and AI 3 (DeepSeek) r1 could not open it and recomputed nothing (re-issue r2, delay ≤ ~14 min). Variant: individual files plus SHA256SUMS, with a mandatory first-section file inventory with hashes.

## Verdict convention (proposed addition, Addendum 02)
**KEEP = deliver evidence as individual files plus SHA256SUMS with the inventory requirement. REVERT = the addition is not shown to help.** HALT as in constitution §9.

## Exact change being tested
- **Evidence (identical in all arms):** the 9 frozen Chicago Stage 5 files used by the b5 C48 audits — `STAGE5_EVIDENCE_PACKAGE.md`, `STAGE5_DEEPER_FINDINGS.md`, the 6 deeper CSVs, and the AI 1 interpretation (`AI1_INTERPRETATION.md`, byte-identical to `AI1_ORIGINAL.md`) — plus `SHA256SUMS`. `seeds/C49/delivery/FILES/` holds the 10 files; `seeds/C49/delivery/ZIP/evidence_pkg.zip` holds byte-identical copies (deterministic zip; checked by `c49_check.R` before any chat).
- **Prompt (identical except the delivery sentence and the mode line):** AI 3 first pass on AI 1's interpretation. Part 1 = a FILE INVENTORY block per file (`FILE / SHA256 / OPENED / LINES / FIRST / LAST`), part 2 = five hard facts `Q1..Q5` recomputed from the files, part 3 = findings; END line `END C49 FIRST PASS`. The inventory requirement is held constant in both formats so that the arms differ in delivery only (disclosed: the addendum's variant bundles both; this test isolates the delivery format).
- **Access proof (mechanical):** a file counts as accessed when the reply's FIRST and LAST lines equal the file's first and last non-empty lines (whitespace-normalized). A model cannot produce them without opening the file. **Usable first pass** = END line present + all 9 files proven + all 5 facts answered. Fact correctness against `KNOWN_ANSWERS.csv` (Q1 131968, Q2 64922, Q3 49.2, Q4 25, Q5 118246) is reported, not scored (PricePoint: the format fixed access, not accuracy).
- **Time to a usable first pass** = `reply_complete − sent` from `TIMES.txt` (unusable = infinite). Timing records: the operator writes `TIMES.txt` beside each saved reply, two lines `sent=YYYY-mm-dd HH:MM:SS` (when the message was sent) and `reply_complete=YYYY-mm-dd HH:MM:SS` (when the reply finished streaming), America/Chicago wall clock, from the operator's clock. Minutes are operator-logged, not tool-measured (disclosed).

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C49 delivers frozen Stage 5 text and CSVs only; no R path is rerun. The N1 note is included, identically, in every reviewer prompt (so it cannot differ between arms).

## Arms
- Runner v6 (`seeds/C49/DELIVCHK`): **CHECK** = `c49_check.R` on the delivery sets (pre-chat validity; HALT if FAIL).
- Reviewer chats (operator; packets frozen before sending):
- `C49/packets/C49_R_DS_ZIP.txt` SHA-256 `158713b3193b8541f0a1f94b26267689a956ec8e11bdf1f759634f9099d4abe1` (2843 bytes)
- `C49/packets/C49_R_DS_FILES.txt` SHA-256 `9fa6cc58745d144a5c53a371f0b41db69d0503b212c2b1ce08a33eb84998f7a2` (2808 bytes)
- `C49/packets/C49_R_GPT_FILES.txt` SHA-256 `bf2f3ac4b7f82e0090852200be6c6906b1cd190fb6533a9ba8075cf04f6c27e2` (2821 bytes)
- Post-chat scorer: `seeds/C49/c49_score.R <N13 root>` → `C49/post/` (replies `C49/C49-<arm>/reply.md`, times `C49/C49-<arm>/TIMES.txt`).

## Operational benefit predicate P1 (made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
0. (validity) the delivery sets pass `c49_check.R`;
1. variant access: DS_FILES and GPT_FILES each prove access to all 9 evidence files;
2. inventory hashes: in DS_FILES and GPT_FILES every evidence file is listed with the SHA-256 in SHA256SUMS;
3. delay no worse: DS_FILES time to a usable first pass ≤ DS_ZIP time to a usable first pass + 2 min (DS_ZIP not usable = met).
REVERT side: 1, 2 or 3 fails. HALT if 0 fails, or if a reply or its TIMES.txt is missing or a reply lacks its END line. DS_ZIP's access result is the baseline observation (reported); it does not decide P1 by itself.
Disclosed limits: one chat per arm (n = 1 per model × format); ChatGPT's zip handling is not tested (no GPT_ZIP arm, to save usage); Grok is not tested.

## Regression / HALT rules
- HALT if the delivery check fails, if a reviewer reply is missing, incomplete or changed after its freeze, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4: delivery changes no result (byte-identical evidence across arms, checked); condition 5: the check's known-answer cases are the zip/file identity and SHA256SUMS (declared now).

## Allowed source/data scope
Frozen Chicago Stage 5 documents and evidence (box `chicago-311-dispatch-priority/docs/stage-05-interpretation/`, `chicago-311-run/stage-05/`), copied verbatim into the seeds. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
**Runner-side files for this control (frozen list `runner_b6/SEEDS_b6.sha256`; preflight gating):**
- `runner_b6/seeds/C49/ARMS.tsv` SHA-256 `edc8a02618014eb9e370ae01f605303630874d465917f3785b7fa5518d3ddeea`
- `runner_b6/seeds/C49/DELIVCHK` SHA-256 `0d355b20e2fcd5c9919546c26d92506826769042a463ed05693fc7c36f110b30`
- `runner_b6/seeds/C49/KNOWN_ANSWERS.csv` SHA-256 `13d57bb9d40392186ba8f423482c20d9121b56796c5b35c61494b3ee1b4303c2`
- `runner_b6/seeds/C49/c49_check.R` SHA-256 `4f6cc57234f784bc84e5a9823f9549713db024e04e32036bd440aa202efd485e`
- `runner_b6/seeds/C49/c49_score.R` SHA-256 `ce2a6a24168e71ac82b6808f6ed15c51511eb2c7ccd14a5224674da49597632d`
- `runner_b6/seeds/C49/delivery/FILES/AI1_INTERPRETATION.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
- `runner_b6/seeds/C49/delivery/FILES/SHA256SUMS` SHA-256 `1f2aad88d78e4c4a582e39d0745af8d710d1fcdedb69a35982e245b213ddec75`
- `runner_b6/seeds/C49/delivery/FILES/STAGE5_DEEPER_FINDINGS.md` SHA-256 `49ab09c26c86e4a0abcd2031745e0c4bc786dffc8fe6cf4066e9c3afa93c70e6`
- `runner_b6/seeds/C49/delivery/FILES/STAGE5_EVIDENCE_PACKAGE.md` SHA-256 `c8e191d861a71097b4bc2ebaaab2626633617350e39f130e1c7d148a3379bfb7`
- `runner_b6/seeds/C49/delivery/FILES/capacity_coverage_note.csv` SHA-256 `4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609`
- `runner_b6/seeds/C49/delivery/FILES/escalate_by_type_top25.csv` SHA-256 `6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176`
- `runner_b6/seeds/C49/delivery/FILES/inconclusive_by_clause.csv` SHA-256 `f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d`
- `runner_b6/seeds/C49/delivery/FILES/independent_checks_critical_counts.csv` SHA-256 `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146`
- `runner_b6/seeds/C49/delivery/FILES/kappa_sensitivity.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
- `runner_b6/seeds/C49/delivery/FILES/portfolio_summary.csv` SHA-256 `b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167`
- `runner_b6/seeds/C49/delivery/ZIP/evidence_pkg.zip` SHA-256 `ea8ff49d164e41dcd442590dbec6c7d9ffb2c83a9baa5a5e6193d79c6cde5f9d`
- `runner_b6/eval_b6.R` SHA-256 `6f5f25181d1033b7162a393b8dc0fd1e2a65cee094cbddf9d9244f707526bb1a`
- `runner_b6/run_batch_v6.ps1` SHA-256 `5b97cd2a0520f6ea88f4bf220b3fca0756292ff352eebf28991e52d9d21254fb` (the runner; carries the preflight list above)
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; definitions files as above. This spec is hashed in `SPEC_FREEZE_b6.sha256` before the reporting run.
**Evidence files:** the 10 delivery files and the zip are in the seed list above.
## Pre-execution check (disclosed)
The predicate text (`eval_b6.R`) and every harness script were hashed in `SEEDS_b6.sha256` before any PC execution. The complete runner was exercised on the PC in scratch folders (non-reporting, NON_REPORTING.txt in each): `N13\_preflight_b6` (runner tar v1) stopped at the preflight because the C49 marker file `seeds/C49/DELIVERY` collided with the folder `seeds/C49/delivery/` on Windows (case-insensitive paths); nothing executed. The marker was renamed `DELIVCHK` (runner and evaluator updated; first builds kept in `runner_b6/_superseded_v0` and `_superseded_v1` with README). `N13\_preflight_b6_2` (runner tar v2) was killed during the C43 audit when the remote session dropped (no result). `N13\_preflight_b6_3` (runner tar v2, SHA-256 7e4dac855c3a640f311856928c9666e50ce8d464a57273f645a4a337d978e7fc, started detached) ran to completion at 11:27:46 PC time (4.18 min, preflight PASS). Before that, the R scripts were dry-run on the box (R 4.5) with synthetic replies for the post-chat scorers; a Q-answer parsing bug in c49_score.R was fixed then. C49 in the scratch run: delivery check PASS (9 files + SHA256SUMS; zip 10 entries, byte-identical). No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
