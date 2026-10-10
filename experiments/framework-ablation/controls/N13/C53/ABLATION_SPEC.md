# C53 — Ablation specification (FROZEN)

**Ablation ID:** C53 (Addendum 02, candidate #53 "Design-time output-field completeness")
**Batch:** N13 batch 5 (controls C41, C47, C53, C48; the four of the owner's batch-01 rulings that run on the frozen pack without a design chat; #42 waits for the owner's answer sheet `OWNER_42_SHEET.md`)
**Owner rulings (operational definitions, constitution §9):** Owner rulings batch 01: `ablation_plan/OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba` (questions file `OWNER_RULINGS_BATCH_01.md` SHA-256 `bcd23877be27e047c49bb0fbd0e4bda15031dad9e85b1df3b523badf0ee1b6dc`, not edited). Ruled 2026-10-03 09:58 CT: `41A 42A 47A 48A 53A`.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 3 design gate / Stage 4 reconciliation (proposed addition)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b5/run_batch_v5.ps1`, evaluator `runner_b5/eval_b5.R`; R only, no MySQL)

## Control under test (proposed addition, Addendum 02 #53)
Require, at the Design Gate, the value of every output field for every outcome. Ruling 53A approved the appendix table of `OWNER_RULINGS_BATCH_01.md` as written, including the ★ cells and the clock rule (a wall time in the repeated fall-back hour is the first occurrence, daylight time, on both paths). PricePoint evidence: R1–R7 specification-gap rulings and the r9 repair round (≈ 29 min).

## Verdict convention (hardening/addition, Addendum 02)
**KEEP = the field × outcome table is adopted as a Design Gate requirement. REVERT = the addition is not shown to help.** HALT as in constitution §9.

## Exact change being tested
- **Variant:** `table_check.R` checks an R-B classifications file against the approved table, cell by cell: T0 labels/uniqueness; T1a–T1c dormant_h presence, value and clock rule; T2a–T2c open_age_h; T3 peer_n non-negative integer (0 if no peers); T4 peer_p75_h present iff peer_n ≥ 1; T5a/T5b integrity_clause; T6 evidence_reason (R-B only). Expected clocks are recomputed from the frozen source text under the clock rule (tolerance 2e-6 h); the script aborts if the clock-rule self-test fails on the R build. A violation = a builder defect, settled by the table, no ruling.
- **Baseline:** no table. A cell defect is visible only if the two paths disagree: `recon_c53.R` does a full-field reconciliation of the arm's R-B output against the frozen R-A output on key, classification, dormant_h, open_age_h (C39 full-field set, 1e-6) plus peer_n and peer_p75_h. A seeded arm whose mismatch set has new rows beyond clean B's (B already carries the 3 N1 rows) "surfaces" and needs an owner ruling (no table says which path is right); otherwise it "escapes".
- Seeds change only table cells (never a label, count or fixture); seed validity is checked.
- Not measured: design-time minutes (no Stage 3 chat; Addendum 02's cost metric). The Adjudicator must not treat it as measured.

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, now confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. In C53, N1 is in scope: clean arm B (= frozen R-B) must have 0 table violations; the 3 N1 rows appear in B's baseline recon and are subtracted from every seeded arm's recon. The table check on frozen R-A is reported as INFO (expected T1c/T2c violations on the 3 rows, T5a because R-A writes a clause on every row, T6 absent).

## Arms (runner v5, `seeds/C53/TABLECHK`; each arm runs R-B `all`, then the table check, then the baseline recon)
- **B**: frozen R-B code.
- **U_DORMINC** (`run_RB.R`): dormant_h written blank on every INCONCLUSIVE row (table T1a: a number whenever both clocks parse).
- **U_P75THIN** (`run_RB.R`): peer_p75_h written blank for thin types (1 ≤ peer_n < 50) (table T4).
- **U_PEERNBLANK** (`run_RB.R`): peer_n written blank for types with no peers (table T3: 0).
- **U_CLOCKLATE** (`10_io_parse.R`): a repeated-hour wall time read as the second occurrence (CST) (table clock rule).
- INFO check-only arms: **FROZEN_RB** and **FROZEN_RA** (table check on the frozen outputs).

## Operational benefit predicate P1 (ruling 53A, made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. variant: every seeded arm is flagged by the table check (0 rulings needed, 0 escapes);
2. baseline: at least one seeded arm cannot be settled without the table (it surfaces and needs an owner ruling, or it escapes);
3. no new defect: clean arm B has 0 table violations and its 4 R-B key outputs equal the frozen hashes;
4. seed validity: every seeded arm's labels, portfolio counts, κ grid and fixture results equal the frozen R-B ones.
REVERT side: 1, 2 or 3 fails. If 4 fails: HALT (harness defect).

## Regression / HALT rules
- HALT if a run, table check or recon fails or is missing, if seed validity fails, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 for clean arm B = byte equality of its 4 R-B key outputs with the frozen ones; condition 5 = its fixture results (inside `run_RB.R all`; must equal the frozen hash).

## Allowed source/data scope
Frozen PC pack, read only, copied into the work folder. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`
- `R-B/run_RB.R` SHA-256 `6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd`
- `R-B/R/00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`
- `R-B/R/10_io_parse.R` SHA-256 `40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a`
- `R-B/R/20_integrity_and_classify.R` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`
- `R-B/R/40_fixtures.R` SHA-256 `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`
- `R-A/outputs/RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
**Runner-side files for this control (frozen list `runner_b5/SEEDS_b5.sha256`; preflight gating):**
- `runner_b5/seeds/C53/ARMS.tsv` SHA-256 `478144088be5d82902de0e5cbb9a749300a07d3ee4b73b24c4647269cadb954b`
- `runner_b5/seeds/C53/RB_U_CLOCKLATE__10_io_parse.R` SHA-256 `e2233fb7d7bafb03e788c25f0bcf75327eaf19561d794a7edf5a96a84e627528`
- `runner_b5/seeds/C53/RB_U_DORMINC__run_RB.R` SHA-256 `5da344a4218687b000c2df674a6d69f00dd921169d7615208c71b23c22ddc784`
- `runner_b5/seeds/C53/RB_U_P75THIN__run_RB.R` SHA-256 `d3351d6fb90603124432d63afa09c7fadb078cbe980a5732b3cbe224a6dc717a`
- `runner_b5/seeds/C53/RB_U_PEERNBLANK__run_RB.R` SHA-256 `82735a70bdc6dcf676cc30b274e7053cbeda0144208b4939f5445e091ce9e9ed`
- `runner_b5/seeds/C53/TABLECHK` SHA-256 `5e3fa83043a2c2a3e2d854811fbe9fc428bff118254a2add80b7823fd9b0f420`
- `runner_b5/seeds/C53/recon_c53.R` SHA-256 `e908302a5d2759275632da479d5df89c99ab40f623adb417dc2770d9a0bcabf1`
- `runner_b5/seeds/C53/table_check.R` SHA-256 `90a5104b4fa8264ba4ce82cd27fe055a8c1ee24dd1ac39a90dc640224d02dd97`
- `runner_b5/run_batch_v5.ps1` SHA-256 `e51e70e8050aa5582dca497d799c0b0c9fa1db7f3c6a2c1dc797d915970cd810`
- `runner_b5/eval_b5.R` SHA-256 `49742ad3ead70fe6b73121e61b0c774b1f94c4edc36f7241ef99456ef0cb3966`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; owner rulings file as above. This spec is hashed in `SPEC_FREEZE_b5.sha256` before the reporting run.
**Baseline recon reference:** frozen `R-A/outputs/RA_classifications.csv` (above). **Approved table:** appendix of `OWNER_RULINGS_BATCH_01.md` (hash above).
## Pre-execution check (disclosed)
The predicate text (`eval_b5.R`, SHA-256 in `SEEDS_b5.sha256`) was hashed before any execution. The complete runner was then exercised once on the PC in a scratch folder (`N13\_preflight_b5`, non-reporting, `NON_REPORTING.txt`): 2026-10-03 10:17–10:27 CT, runner tar `N13_runner_b5_v1.tar` SHA-256 0add2b9b37fc0d7af48c20eb2c5ebda550b3f0e2d2b5904fa82be3970e3d6e6e; preflight PASS; every run exit 0; summarize exit 0. Scratch outcome: clean B 0 table violations, 4/4 outputs equal frozen; every seed flagged by the table (U_DORMINC 6,377 T1a, U_P75THIN 62 T4, U_PEERNBLANK 6,315 T3, U_CLOCKLATE 3 T1c/T2c); baseline: three seeds surface as new R-A/R-B mismatches, U_CLOCKLATE escapes (it removes the 3 N1 mismatches instead); FROZEN_RA INFO: T1c 1, T2c 2, T5a 215,625, T6 absent; mechanical result P1 MET. The scratch result was known before this spec was frozen. No arm, threshold, seed or predicate was changed after that check (one harness change was made before the scratch run, not after it: `recon_c53.R` gained the RECON_IDS.csv output so the baseline rule could subtract clean B's mismatch rows; the earlier seed set is kept unexecuted in `runner_b5/_superseded_v0/`).

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
