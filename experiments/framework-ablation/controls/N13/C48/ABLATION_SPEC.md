# C48 — Ablation specification (FROZEN)

**Ablation ID:** C48 (Addendum 02, candidate #48 "No second final audit after verified revisions")
**Batch:** N13 batch 5 (controls C41, C47, C53, C48; the four of the owner's batch-01 rulings that run on the frozen pack without a design chat; #42 waits for the owner's answer sheet `OWNER_42_SHEET.md`)
**Owner rulings (operational definitions, constitution §9):** Owner rulings batch 01: `ablation_plan/OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba` (questions file `OWNER_RULINGS_BATCH_01.md` SHA-256 `bcd23877be27e047c49bb0fbd0e4bda15031dad9e85b1df3b523badf0ee1b6dc`, not edited). Ruled 2026-10-03 09:58 CT: `41A 42A 47A 48A 53A`.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Extra chats (ruling 48A; disclosed):** a second AI 2 audit (Grok, decision/method critic) and a second AI 3 audit (DeepSeek, claim/evidence auditor), as in the Chicago Stage 5 roles. Role overlap: Grok is also the Adjudicator and DeepSeek also the Validator; the audit chats are separate conversations, blind to this ablation, and are frozen (hashed) before the Builder/Validator packets are built.
**Target stage:** Stage 5 interpretation audit (cut/relax candidate)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b5/run_batch_v5.ps1`, evaluator `runner_b5/eval_b5.R`; R only, no MySQL)

## Control under test (cut/relax candidate, Addendum 02 #48)
Ruling 48A: the F5 diagram is the standing rule ("Revision required → Revise interpretation and re-audit"): a second AI 2 / AI 3 audit is required after revisions. The test is whether it can be dropped when a mechanical checklist verifies every revision. PricePoint followed the text reading (A10 §5: no second audit) and verified revisions by coordinator checklist only.

## Verdict convention (cut/relax candidate)
**KEEP = the second audit can be dropped when the mechanical revision checklist passes (quote match + number diff). REVERT = the second audit stays required.** HALT as in constitution §9.

## Exact change being tested
- Input: the frozen Chicago Stage 5 AI 1 interpretation (`AI1_ORIGINAL.md`, SHA-256 in SEEDS_b5) and a revision request V-1..V-6 (`REVISIONS.json`; each with a quote of the affected language, the exact replacement and its source in the Stage 5 evidence; V-6 deletes a chat-UI artifact line). The coordinator applies the revisions (no constructor chat): `REVISED_CLEAN.md` applies all six exactly; `REVISED_SEED.md` mis-applies V-3 (the WCA2 share is written 42.9% instead of the requested 49.2%; one number changed).
- **Variant (checklist only):** `rev_check.R`: for each revision (a) the replacement appears verbatim exactly once (deletion: the target is absent), (b) the target quote is gone; (c) the multiset of numbers in the revised text equals original − numbers(targets) + numbers(replacements). Any failure = FLAG.
- **Baseline (second audit):** the AI 2 and AI 3 second-audit chats receive the Stage 5 evidence package and deeper CSVs, the original AI 1 text, the revision request and `REVISED_SEED.md`, all with hashes. They are blind to the ablation (not told a revision was planted). Each returns a per-revision verification table, then findings `id | BLOCKING/MATERIAL/MINOR | relates_to V-n/NEW/PRE | quote | correction`, then an overall verdict, ending with its END line.
- Time saved (the two audit chats' wall-clock) is reported from the capture times; not the predicate.

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, now confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C48 reads only Stage 5 text and frozen Stage 5 evidence; it reruns no R path, so N1 does not enter any C48 number. (The Stage 5 evidence package itself predates and does not use the 3 N1 rows' clock values.)

## Arms (runner v5, `seeds/C48/REVCHK`) and audit chats
- **CLEAN**: checklist on `REVISED_CLEAN.md` (must PASS).
- **SEED**: checklist on `REVISED_SEED.md` (must FLAG V-3).
- **AI2 second audit** and **AI3 second audit** on `REVISED_SEED.md` (packets `C48/packets/C48_A2_SECOND_AUDIT_Grok.txt`, `C48/packets/C48_A3_SECOND_AUDIT_DeepSeek.txt`; hashes in the packet's freeze record).

## Operational benefit predicate P1 (ruling 48A, made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. the checklist catches the planted mis-applied revision: SEED status FLAG with V-3 flagged;
2. no false flag: CLEAN status PASS;
3. the frozen second-audit replies (AI 2 and AI 3) contain no finding graded BLOCKING or MATERIAL with relates_to V-1..V-6 or NEW that the checklist did not flag on SEED. A finding on V-3 counts as flagged by the checklist (it is the planted one). Findings marked PRE (about the original AI 1 text, outside the revisions) are reported only, not scored. A finding that cites no quote from the revised text is reported, not scored.
REVERT side: any of 1–3 fails. Condition 3 is assessed by the Builder, Validator and Adjudicator from the frozen audit replies, which are in their packets verbatim with hashes (`AUDIT_FREEZE.json`).

## Regression / HALT rules
- HALT if a checklist run fails or is missing; if an audit reply is missing, incomplete (no END line) or changed after its freeze; or if Builder and Validator disagree on a hard number or on the classification of an audit finding.
- Constitution §7 condition 4 = the CLEAN checklist PASS (exact text match); condition 5: the checklist has no fixture harness; its known-answer cases are CLEAN and SEED (declared now).

## Allowed source/data scope
Frozen Chicago Stage 5 documents and evidence (box `chicago-311-dispatch-priority/docs/stage-05-interpretation/`, `chicago-311-run/stage-05/`), copied verbatim into the seeds. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
**Runner-side files for this control (frozen list `runner_b5/SEEDS_b5.sha256`; preflight gating):**
- `runner_b5/seeds/C48/AI1_ORIGINAL.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
- `runner_b5/seeds/C48/ARMS.tsv` SHA-256 `5d228c54043896574feacd72a025a7c6c0dda5094402debf632f6d079f230b29`
- `runner_b5/seeds/C48/REVCHK` SHA-256 `a271c99e3c9deab96e553503c037aa15bd6d24195b4cb40036eac131e846d1cf`
- `runner_b5/seeds/C48/REVISED_CLEAN.md` SHA-256 `d92e480b9531d5018ca02e6dbd116dbaaa3a2df53981e690e48eff13eb00278c`
- `runner_b5/seeds/C48/REVISED_SEED.md` SHA-256 `c1ac310a7c77ab4228ac14ebb6c56e58b408e4e64cdf74fae8f1f68b9a720b63`
- `runner_b5/seeds/C48/REVISIONS.json` SHA-256 `970bac860ea65fcf4658cbb932d11e666f2609de4a8708161ac0b7df824ce0b4`
- `runner_b5/seeds/C48/rev_check.R` SHA-256 `6cc4ea649d67c1d22a90bfcbcbf3756a69837d900f26943940f0b6bb57297156`
- `runner_b5/run_batch_v5.ps1` SHA-256 `e51e70e8050aa5582dca497d799c0b0c9fa1db7f3c6a2c1dc797d915970cd810`
- `runner_b5/eval_b5.R` SHA-256 `49742ad3ead70fe6b73121e61b0c774b1f94c4edc36f7241ef99456ef0cb3966`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; owner rulings file as above. This spec is hashed in `SPEC_FREEZE_b5.sha256` before the reporting run.
**Stage 5 inputs:** `seeds/C48/AI1_ORIGINAL.md` is byte-identical to the frozen AI 1 Stage 5 reply (SHA-256 above, same as the Chicago repo copy). The evidence package and deeper CSV hashes are listed in the audit packets.
## Pre-execution check (disclosed)
The predicate text (`eval_b5.R`, SHA-256 in `SEEDS_b5.sha256`) was hashed before any execution. The complete runner was then exercised once on the PC in a scratch folder (`N13\_preflight_b5`, non-reporting, `NON_REPORTING.txt`): 2026-10-03 10:17–10:27 CT, runner tar `N13_runner_b5_v1.tar` SHA-256 0add2b9b37fc0d7af48c20eb2c5ebda550b3f0e2d2b5904fa82be3970e3d6e6e; preflight PASS; every run exit 0; summarize exit 0. Scratch outcome: CLEAN PASS; SEED FLAG on V-3 with number diff 42.9 (expected 0, found 1) / 49.2 (expected 1, found 0); condition 3 PENDING (audit chats not run in scratch). The scratch result was known before this spec was frozen. No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
