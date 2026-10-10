# C40 — Ablation specification (FROZEN)

**Ablation ID:** C40 (Addendum 01b, candidate #40 "Repair-round cap")
**Batch:** N13 batch 6 (controls C43, C49, C44, C40; owner approval 2026-10-03 10:52 CT; built the way batch b5 was built)
**Definitions and approval (operational definitions, constitution §9):** Definitions: `ablation_plan/ADDENDUM_01_control_39.md` SHA-256 `a3bf8f6a6b27a670c8a3dde85e7fe51a53febfff298d2e70b2f3511e82de5b4f` (#40, #43) and `ablation_plan/ADDENDUM_02_pricepoint_candidates.md` SHA-256 `5d8756efbed04f168f3d53e2d8fab8064503752bd04f8c61b670cf81f9c757a6` (#44, #49; #40 evidence). Owner approval of #43, #49, #44, #40: 2026-10-03 10:52 CT (blockers in `N13/SELECTION_N13.md` SHA-256 `f6fd85c5137f27710a1b38e24836b3b473a720b5f221f57a38c43b8f11547c8f`). Owner rulings batch 01 (`OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba`) apply where cited (41A depth gate, 48A, 53A clock rule).
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Extra chats: 1 or 2** — builder chats on ChatGPT: **INC** (incumbent builder, one chat, rounds are messages) always; **FRESH** (a new ChatGPT chat) only if INC's first two builds both fail the gate. No Grok chat. The builder chats are blind to this ablation and are frozen round by round.
**Usage priority (owner):** SuperGrok usage is the scarcest resource; extra chats are kept to the smallest number the test validly allows, and no extra chat uses Grok.
**Target stage:** Stage 4 build repair rounds (hardening)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b6/run_batch_v6.ps1`, evaluator `runner_b6/eval_b6.R`; R only, no MySQL, no git)

## Control under test (Addendum 01b #40)
Rule as it stands: unlimited repair rounds for one builder (PricePoint R-B reached r10; evidence table in Addendum 02). Variant: after 2 failed rounds, swap in a fresh builder (or escalate to the owner after the fresh builder's own cap).

## Verdict convention (Addendum 01b)
**KEEP = adopt the cap (a valid build arrives no later and no defect escapes). REVERT otherwise. HALT if evidence is incomplete.**

## Exact change being tested
- **Build task (identical for every builder):** write `R-B/R/10_io_parse.R` (I/O and clock/type parsing helpers) for the frozen R-B path; every other R-B file, the locked design documents, the source sample lines, the function contracts (including the America/Chicago wall clock and ruling 53A, repeated hour = first occurrence) and the reference output hashes are in the packet verbatim. The frozen module itself is never shown.
- **Gate (valid build), `c40_gate.R`:** the frozen R-B tree with only `10_io_parse.R` replaced; `Rscript R-B/run_RB.R all` on the frozen extract exits 0, fixtures 14/14, and the 4 R-B key outputs are byte-identical to the frozen ones. A failed gate produces `GATE_REPORT.md` (exit status, failing fixtures, which outputs differ, per column how many rows differ, up to 5 example rows; no frozen code), sent to the builder as the next repair message.
- **Hidden escape check:** on every gate-passing build, the b5 C41 depth gate (`fixdepth.R depth`, ruling 41A; hash below), never shown to builders. "No defect escapes" = the variant's valid build passes it.
- **Regimes (`c40_next.R` state machine):** INC r1 → gate. If PASS at r1 or r2: the cap never triggers and the two regimes are identical → outcome **NOT_TRIGGERED** (no verdict; no Builder/Validator/Adjudicator chats; disclosed). If INC r1 and r2 both FAIL, the regimes diverge: **variant** = FRESH chat with the original packet plus INC's r1–r2 gate reports (no code), cap 2 failed rounds, then escalation; **baseline** = INC continues repairing, experiment stop at r6 (usage). If neither arm reaches a valid build → **BOTH_CENSORED** (HALT-incomplete; no B/V/G chats).
- **Time:** active minutes from divergence = Σ over rounds after r2 of (reply minutes from `TIMES.txt` + runner-measured gate minutes); a baseline with no valid build by r6 counts as infinite. Timing records: the operator writes `TIMES.txt` beside each saved reply, two lines `sent=YYYY-mm-dd HH:MM:SS` (when the message was sent) and `reply_complete=YYYY-mm-dd HH:MM:SS` (when the reply finished streaming), America/Chicago wall clock, from the operator's clock. Minutes are operator-logged, not tool-measured (disclosed).

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C40 is the module that decides N1. The gate compares with the frozen R-B outputs, which embed R-B's first-occurrence reading; a build that reads the repeated hour as CST (the R-A reading) fails the gate on the 3 N1 rows, which is correct under ruling 53A (validation arm SEED_CLOCKLATE checks this). The N1 note is in every builder packet.

## Arms
- Runner v6 (`seeds/C40/REPAIRCAP`), gate validation before any chat (expected): **REF** = frozen module (gate PASS, hidden PASS); **SEED_TZUTC** = wall clocks read as UTC (b5 C41 seed; FAIL); **SEED_CLOCKLATE** = repeated hour read as CST (b5 C53 seed; FAIL); **SEED_DUPINT** = DUPLICATE flag read as a number (b5 C41 seed; FAIL).
- Builder rounds (operator; `seeds/C40/c40_round.ps1 -Arm INC|FRESH -Round k` after saving `C40/C40-<arm>/r<k>/reply.md` and `TIMES.txt`; it extracts the code (refuses without the END line), runs the gate and the hidden check, logs `C40/ROUNDS_LOG.tsv`, and writes the next message or the FRESH packet):
- `C40/packets/C40_1_INC_BUILDER_ChatGPT.txt` SHA-256 `e140717693b1bf86a0ab1cad9f0575a40b8289e291145de8ce7e5772765021a4` (62095 bytes)
- `C40/packets/C40_2_FRESH_BUILDER_ChatGPT.TEMPLATE.txt` SHA-256 `6a7c477a0d034c992bbcb3544600e455b7e0b217c9d77a125a6acdf575c86bfc` (62195 bytes)
- Post-protocol evaluator: `seeds/C40/c40_eval.R <N13 root>` → `C40/post/`.

## Operational benefit predicate P1 (made mechanical before execution)
Evaluated only if the regimes diverged. **P1 satisfied (KEEP side)** when all hold:
0. (validity) gate validation: REF PASS with hidden PASS; every seeded module FAIL;
1. the variant (FRESH) reaches a valid build within its cap (2 failed rounds);
2. no later: the variant's active minutes from divergence ≤ the baseline's (baseline without a valid build by r6 = infinite);
3. no defect escapes: the variant's valid build passes the hidden check.
REVERT side: 1, 2 or 3 fails. HALT if 0 fails or a round record is missing. NOT_TRIGGERED and BOTH_CENSORED are reported as such (no verdict).
Disclosed limits: n = 1 build task and one builder model; a FRESH builder that passes may simply have benefited from the handover reports (that is the variant as defined); the hidden check is not shown to discriminate between gate-passing modules (all seeded modules already fail the gate).

## Regression / HALT rules
- HALT if a gate run or exit record is missing, if gate validation fails, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 = byte equality of the 4 R-B key outputs (the gate itself); condition 5 = fixtures 14/14 (inside the gate).

## Allowed source/data scope
Frozen PC pack, read only, copied into each arm folder. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`
- `R-B/run_RB.R` SHA-256 `6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd`
- `R-B/R/00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`
- `R-B/R/10_io_parse.R` SHA-256 `40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a`
- `R-B/R/20_integrity_and_classify.R` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`
- `R-B/R/40_fixtures.R` SHA-256 `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
**Runner-side files for this control (frozen list `runner_b6/SEEDS_b6.sha256`; preflight gating):**
- `runner_b6/seeds/C40/ARMS.tsv` SHA-256 `529eebeaf5c493085d0f53ba71b218f62e6e6c82d47a793a14d2187c81c987a1`
- `runner_b6/seeds/C40/REPAIRCAP` SHA-256 `66f8fb4044f5c18a3c1a5c1e45a90bd15d6c9cb0e97677fb1594164e9e54ac2d`
- `runner_b6/seeds/C40/SEED_CLOCKLATE__10_io_parse.R` SHA-256 `e2233fb7d7bafb03e788c25f0bcf75327eaf19561d794a7edf5a96a84e627528`
- `runner_b6/seeds/C40/SEED_DUPINT__10_io_parse.R` SHA-256 `e55902b4bb29a77bc1a96bd405a64406ae043584f82ddece3675ca70029ab3e3`
- `runner_b6/seeds/C40/SEED_TZUTC__10_io_parse.R` SHA-256 `33065838749ddf7013753deffe08963dc7aaffeb70bc3cd8cb5760e86f51263c`
- `runner_b6/seeds/C40/c40_eval.R` SHA-256 `90d459884d4656990db7f2bba0efd0977de203d82aec693f76eca126ecc9f2a7`
- `runner_b6/seeds/C40/c40_extract.R` SHA-256 `b77f0adbfafefeab5209bd4327894814452c1184c9bd2d2264cabf860ee37132`
- `runner_b6/seeds/C40/c40_gate.R` SHA-256 `d7e3bb70cbdf7ecb2ce835cf39b6c3cb1c08238f9317fbdaa2d1f8034fe8f602`
- `runner_b6/seeds/C40/c40_next.R` SHA-256 `9fbc37ab02eded4e6658a85040733d5ff82c32592b5c23b053a7ec8dc7813847`
- `runner_b6/seeds/C40/c40_round.ps1` SHA-256 `4ec194c8d2b82d81fa16c24aaa014e3dfec3c81ea67ab8b104ecd56788de10dc`
- `runner_b6/seeds/C40/fixdepth.R` SHA-256 `5aa0cb96037b2616a26d4e68565be26393e5669f450b56783a70239e585696bd`
- `runner_b6/eval_b6.R` SHA-256 `6f5f25181d1033b7162a393b8dc0fd1e2a65cee094cbddf9d9244f707526bb1a`
- `runner_b6/run_batch_v6.ps1` SHA-256 `5b97cd2a0520f6ea88f4bf220b3fca0756292ff352eebf28991e52d9d21254fb` (the runner; carries the preflight list above)
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; definitions files as above. This spec is hashed in `SPEC_FREEZE_b6.sha256` before the reporting run.
**Gate references:** the 4 frozen R-B key outputs listed above under `RB_`. **Hidden check:** `seeds/C40/fixdepth.R` (byte-identical to `runner_b5/seeds/C41/fixdepth.R`).
## Pre-execution check (disclosed)
The predicate text (`eval_b6.R`) and every harness script were hashed in `SEEDS_b6.sha256` before any PC execution. The complete runner was exercised on the PC in scratch folders (non-reporting, NON_REPORTING.txt in each): `N13\_preflight_b6` (runner tar v1) stopped at the preflight because the C49 marker file `seeds/C49/DELIVERY` collided with the folder `seeds/C49/delivery/` on Windows (case-insensitive paths); nothing executed. The marker was renamed `DELIVCHK` (runner and evaluator updated; first builds kept in `runner_b6/_superseded_v0` and `_superseded_v1` with README). `N13\_preflight_b6_2` (runner tar v2) was killed during the C43 audit when the remote session dropped (no result). `N13\_preflight_b6_3` (runner tar v2, SHA-256 7e4dac855c3a640f311856928c9666e50ce8d464a57273f645a4a337d978e7fc, started detached) ran to completion at 11:27:46 PC time (4.18 min, preflight PASS). Before that, the R scripts were dry-run on the box (R 4.5) with synthetic replies for the post-chat scorers; a Q-answer parsing bug in c49_score.R was fixed then. C40 in the scratch run: REF gate PASS (14/14, 4/4 outputs byte-identical) and hidden depth check PASS; SEED_TZUTC, SEED_CLOCKLATE and SEED_DUPINT gate FAIL (SEED_CLOCKLATE differs on exactly 1 dormant_h and 2 open_age_h rows, the N1 rows). No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
