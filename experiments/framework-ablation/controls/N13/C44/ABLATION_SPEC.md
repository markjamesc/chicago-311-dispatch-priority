# C44 — Ablation specification (FROZEN)

**Ablation ID:** C44 (Addendum 02, candidate #44 "Changed-files-only re-review")
**Batch:** N13 batch 6 (controls C43, C49, C44, C40; owner approval 2026-10-03 10:52 CT; built the way batch b5 was built)
**Definitions and approval (operational definitions, constitution §9):** Definitions: `ablation_plan/ADDENDUM_01_control_39.md` SHA-256 `a3bf8f6a6b27a670c8a3dde85e7fe51a53febfff298d2e70b2f3511e82de5b4f` (#40, #43) and `ablation_plan/ADDENDUM_02_pricepoint_candidates.md` SHA-256 `5d8756efbed04f168f3d53e2d8fab8064503752bd04f8c61b670cf81f9c757a6` (#44, #49; #40 evidence). Owner approval of #43, #49, #44, #40: 2026-10-03 10:52 CT (blockers in `N13/SELECTION_N13.md` SHA-256 `f6fd85c5137f27710a1b38e24836b3b473a720b5f221f57a38c43b8f11547c8f`). Owner rulings batch 01 (`OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba`) apply where cited (41A depth gate, 48A, 53A clock rule).
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Extra chats: 1** — a DeepSeek AI 3 re-review limited to the changed artifacts (DELTA). The FULL-scope arm is the frozen b5 C48 AI 3 second audit (DeepSeek, same role, same revised text, same reply format), reused read-only, so no second full-scope chat is spent. Role overlap: DeepSeek is also the Validator; the re-review chat is a separate conversation, blind to this ablation, frozen before the Builder/Validator packets are built.
**Usage priority (owner):** SuperGrok usage is the scarcest resource; extra chats are kept to the smallest number the test validly allows, and no extra chat uses Grok.
**Target stage:** Stage 5 re-review round after revisions (cut/relax candidate)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b6/run_batch_v6.ps1`, evaluator `runner_b6/eval_b6.R`; R only, no MySQL, no git)

## Control under test (Addendum 02 #44)
Rule as it stands: validation framework §9 step 4 ("A different AI verifies the correction") has no scope rule, so a re-review round re-sends the whole scope. Variant: once an artifact has had a full cross-review in the stage, a later round receives only the changed artifacts, their diff, and the hashes of the unchanged inputs.

## Verdict convention (cut/relax candidate)
**KEEP = re-review rounds may be limited to changed artifacts + diff + hashes of the unchanged inputs. REVERT = re-review rounds keep the full scope.** HALT as in constitution §9.

## Exact change being tested
- **Same frozen first round, same revised text:** both arms review `REVISED_SEED.md` (b5 C48; SHA-256 in the seed list), which mis-applies revision V-3 (WCA2 share 42.9% instead of the requested 49.2%) — the **changed-file seed**.
- **FULL arm (baseline):** `C48/packets/C48_A3_SECOND_AUDIT_DeepSeek.txt` (the evidence package, the 6 deeper CSVs, the 4 first-round review files, the AI 1 original, the revision request and the revised text, all verbatim) and its frozen reply `C48/C48-audit-ai3/ai3_second_audit.md` (hash-checked against `C48/AUDIT_FREEZE.json`).
- **DELTA arm (variant):** `C44/packets/C44_A3_DELTA_REREVIEW_DeepSeek.txt`: the same role, job and reply format; the inventory lists the 13 unchanged inputs by SHA-256 (byte-identical to the full packet's inventory; checked by `c44_static.R`); the revision request and the revised text verbatim; a unified diff original → revised. No unchanged body is re-sent. END line `END C44 AI3 DELTA RE-REVIEW`.
- **Deviations (disclosed):** (1) the unchanged-file seed of the addendum (a defect in an unchanged file whose behaviour depends on the changed one) is **not planted**: the FULL arm is a frozen reply that predates this test, and planting it would need a second new full-scope chat; it is reported as **not measured**. This is the addendum's main risk (PricePoint XR-01/02/04/06: material findings in long-unchanged artifacts), so a KEEP here covers the changed-artifact case only. (2) The N1 note is left out of the DELTA packet so that the two arms' prompts differ in scope only (the frozen FULL packet carries no N1 note); the Builder/Validator/Adjudicator packets carry it. (3) The round is run by the AI 3 role chat, not by the Builder and Validator as the addendum sketches; the Builder and Validator judge the finding sets.
- **Cost:** wall-clock of each arm's chat if both are logged (`C44/TIMES_FULL.txt` for the b5 chat, if the coordinator has it; `C44/C44-rereview-delta/TIMES.txt`); otherwise the declared proxy **packet bytes** (full 58,214 B vs delta). Timing records: the operator writes `TIMES.txt` beside each saved reply, two lines `sent=YYYY-mm-dd HH:MM:SS` (when the message was sent) and `reply_complete=YYYY-mm-dd HH:MM:SS` (when the reply finished streaming), America/Chicago wall clock, from the operator's clock. Minutes are operator-logged, not tool-measured (disclosed).

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C44 reads only Stage 5 text and frozen Stage 5 evidence; it reruns no R path, so N1 does not enter any C44 number.

## Arms
- Runner v6 (`seeds/C44/RESCOPE`): **STATIC** = `c44_static.R` (full packet vs delta packet vs REVISED_SEED.md; pre-chat validity; HALT if FAIL).
- Re-review chat (operator; packet frozen before sending):
- `C44/packets/C44_A3_DELTA_REREVIEW_DeepSeek.txt` SHA-256 `a3c359dc253fd91224b811df2e1f0f14cde5827418da7166e0c8f628256508bb` (18691 bytes)
- Post-chat scorer: `seeds/C44/c44_score.R <N13 root>` → `C44/post/` (reply `C44/C44-rereview-delta/delta_rereview.md`).

## Operational benefit predicate P1 (made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
0. (validity) the static scope check passes;
1. no lost findings: every finding the FULL reply grades BLOCKING or MATERIAL is also raised by the DELTA reply (finding level, judged by the Builder, Validator and Adjudicator from both frozen replies; the scorer's key-level comparison on relates_to keys is an aid only);
2. the DELTA reply catches the changed-file seed: V-3 marked not applied exactly (NO/PARTIAL), or a BLOCKING/MATERIAL finding relates to V-3;
3. cost falls by ≥ 30% (wall-clock if both arms are logged; else packet bytes, declared proxy).
REVERT side: 1, 2 or 3 fails. HALT if 0 fails, or if a reply is missing, incomplete (no END line) or changed after its freeze, or if the FULL reply is not frozen yet when the packets are built.

## Regression / HALT rules
- HALT as above, or if Builder and Validator disagree on a hard number or on whether a FULL finding is matched in DELTA.
- Constitution §7 condition 4: the scope rule changes no result (the revised text is byte-identical in both arms); condition 5: the static check's known-answer cases (13 unchanged hashes, verbatim revised text) are declared now.

## Allowed source/data scope
Frozen Chicago Stage 5 documents and evidence and the frozen b5 C48 packets and replies. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
**Runner-side files for this control (frozen list `runner_b6/SEEDS_b6.sha256`; preflight gating):**
- `runner_b6/seeds/C44/ARMS.tsv` SHA-256 `35813967c08599b3afcaa251e0073510e479c4f3011402c89e70998f47078ea2`
- `runner_b6/seeds/C44/RESCOPE` SHA-256 `464eb8c283021dba2909e763779412c8e6f4e039456d37365f770c86894907a6`
- `runner_b6/seeds/C44/c44_score.R` SHA-256 `5a1fa9a224e819c898b39a8c7e43d8686d48291c9d2ac3390b1b425ed7475f5d`
- `runner_b6/seeds/C44/c44_static.R` SHA-256 `2f81b20747a828abe54f67498a4bcb890ec7dc1bb0b7bfc5fbab0326818ebcee`
- `runner_b6/eval_b6.R` SHA-256 `6f5f25181d1033b7162a393b8dc0fd1e2a65cee094cbddf9d9244f707526bb1a`
- `C48/packets/C48_A3_SECOND_AUDIT_DeepSeek.txt` SHA-256 `dab6e55f63eb67f6628ab05b3d5c3d52ab1301e804e8892ba22113735f6aeb96`
- `C44/packets/C44_A3_DELTA_REREVIEW_DeepSeek.txt` SHA-256 `a3c359dc253fd91224b811df2e1f0f14cde5827418da7166e0c8f628256508bb`
- `runner_b5/seeds/C48/REVISED_SEED.md` SHA-256 `c1ac310a7c77ab4228ac14ebb6c56e58b408e4e64cdf74fae8f1f68b9a720b63`
- `runner_b6/run_batch_v6.ps1` SHA-256 `5b97cd2a0520f6ea88f4bf220b3fca0756292ff352eebf28991e52d9d21254fb` (the runner; carries the preflight list above)
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; definitions files as above. This spec is hashed in `SPEC_FREEZE_b6.sha256` before the reporting run.
**Packets compared:** the FULL packet, the DELTA packet and REVISED_SEED.md are in the preflight list (`@W/` entries) above.
## Pre-execution check (disclosed)
The predicate text (`eval_b6.R`) and every harness script were hashed in `SEEDS_b6.sha256` before any PC execution. The complete runner was exercised on the PC in scratch folders (non-reporting, NON_REPORTING.txt in each): `N13\_preflight_b6` (runner tar v1) stopped at the preflight because the C49 marker file `seeds/C49/DELIVERY` collided with the folder `seeds/C49/delivery/` on Windows (case-insensitive paths); nothing executed. The marker was renamed `DELIVCHK` (runner and evaluator updated; first builds kept in `runner_b6/_superseded_v0` and `_superseded_v1` with README). `N13\_preflight_b6_2` (runner tar v2) was killed during the C43 audit when the remote session dropped (no result). `N13\_preflight_b6_3` (runner tar v2, SHA-256 7e4dac855c3a640f311856928c9666e50ce8d464a57273f645a4a337d978e7fc, started detached) ran to completion at 11:27:46 PC time (4.18 min, preflight PASS). Before that, the R scripts were dry-run on the box (R 4.5) with synthetic replies for the post-chat scorers; a Q-answer parsing bug in c49_score.R was fixed then. C44 in the scratch run: static scope check PASS (delta packet 18,691 B = 32.1% of the full packet's 58,214 B; 13/13 unchanged inputs listed by hash; revised text verbatim). No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
