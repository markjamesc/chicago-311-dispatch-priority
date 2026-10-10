# C41 — Ablation specification (FROZEN)

**Ablation ID:** C41 (Addendum 01, candidate #41 "Fixture depth over count")
**Batch:** N13 batch 5 (controls C41, C47, C53, C48; the four of the owner's batch-01 rulings that run on the frozen pack without a design chat; #42 waits for the owner's answer sheet `OWNER_42_SHEET.md`)
**Owner rulings (operational definitions, constitution §9):** Owner rulings batch 01: `ablation_plan/OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba` (questions file `OWNER_RULINGS_BATCH_01.md` SHA-256 `bcd23877be27e047c49bb0fbd0e4bda15031dad9e85b1df3b523badf0ee1b6dc`, not edited). Ruled 2026-10-03 09:58 CT: `41A 42A 47A 48A 53A`.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 fixture gate (hardening)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b5/run_batch_v5.ps1`, evaluator `runner_b5/eval_b5.R`; R only, no MySQL)

## Control under test (hardening)
Rule as it stands: the fixture gate passes when N/N locked fixtures pass (`rb_score_fixtures`, 14 rows F01–F13 + F14 rollup). All 14 fixtures are synthetic data frames with pre-parsed timestamps that go straight to the judge (`rb_judge_rows`), so a defect in file reading or parsing (`10_io_parse`: `rb_read_csv_flex`, `rb_normalize_open`, `rb_normalize_peers`) can never fail them. PricePoint evidence: R-B r3–r5 integer trust flag and 4 no-op stub fixtures passed the count gate (Addendum 01 #41).

## Verdict convention (hardening, Addendum 01)
**KEEP = the depth rule (ruling 41A) is adopted for the fixture gate. REVERT = the depth rule is not adopted (it misses a defect the count rule caught, or costs more than allowed).** HALT as in constitution §9.

## Exact change being tested (ruling 41A)
- **Count gate (baseline):** `fixdepth.R count` = the frozen `rb_score_fixtures()`; PASS iff 14/14 rows pass.
- **Depth gate (variant):** `fixdepth.R depth` = the SAME 14 rows of `rb_build_fixture_pack()` written as text in the production source layout (tab-separated; the frozen `src_open_candidates.csv` and `src_peer_stats.csv` header lines; MySQL-style `created_ts`/`mod_ts`/`closed_ts` = `YYYY-mm-dd HH:MM:SS.000000` or `NULL`; raw-style `*_DATE` = `mm/dd/YYYY hh:mm:ss AM`; DUPLICATE/LEGACY as `true`/`false`), read back through `rb_read_csv_flex` → `rb_normalize_open` / `rb_normalize_peers`, then `rb_judge_rows`, scored against the locked expectations (unchanged). PASS iff 14/14 pass, no read/parse error, and no stub: a stub probe replaces `rb_judge_rows` with a poison judge (every label `POISON`) and reruns `rb_score_fixtures()`; any fixture that still passes is a stub and fails the gate.
- Each arm also runs the production `run_RB.R all` on the frozen extract, to show the real effect of each planted defect (reported; clean B's 4 R-B outputs must equal the frozen hashes).
- Cost = gate wall time (runner-measured seconds) plus extra chats (none: both gates are mechanical).

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, now confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C41 does not reconcile R-A vs R-B; clean arm B's R-B outputs are compared byte-for-byte with the frozen R-B outputs, which already embed N1, so N1 cannot cause a C41 mismatch.

## Arms (runner v5, `seeds/C41/FIXDEPTH`; ARMS.tsv and diffs in the packet)
- **B**: frozen R-B code.
- **P_DUPINT** (`10_io_parse.R`): the DUPLICATE yes/no flag is read as a number (`true`/`false` → NA). Ruled target "a yes/no flag read as a number".
- **P_DATESWAP** (`10_io_parse.R`): the first timestamp format has day and month swapped (`%Y-%d-%m`). Ruled target "a date-parse error".
- **STUB_F11** (`40_fixtures.R`): F11's observed label is hard-coded. Ruled target "a test case that always passes".
- **JUDGE_P50** (`20_integrity_and_classify.R`): κ threshold uses peer P50 instead of P75. A judge defect the count rule catches (superset control).
- **P_TZUTC** (`10_io_parse.R`): wall clocks read as UTC. INFO probe only (not in P1).

## Operational benefit predicate P1 (ruling 41A, made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. superset: every seeded arm the count gate catches is also caught by the depth gate;
2. ruled targets: the depth gate catches P_DUPINT, P_DATESWAP and STUB_F11;
3. clean arm B: count gate PASS and depth gate PASS (no false flag), and B's 4 R-B key outputs (classifications, fixture results, portfolio counts, κ grid) equal the frozen hashes;
4. cost: clean arm B depth-gate wall time ≤ count-gate wall time + 60 s; no extra chats (by construction).
REVERT side: any of 1–4 fails. P_TZUTC is reported, not scored. "Caught" = gate FAIL (including a crash of the gate script).

## Regression / HALT rules
- HALT if a run exit record is missing, if clean arm B's production run fails, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 (exact reconciliation) for clean arm B = byte equality of its 4 R-B key outputs with the frozen R-B outputs; condition 5 (mandatory fixtures) = its count-gate result (all 14 must pass) and the frozen `RB_fixture_results.csv` hash; conditions 6–7: the frozen pack is only read (preflight hashes).
- Timing is measured while another worker's MySQL batch (b4 C52, then C24) runs on the same PC; both gates of an arm run back to back, so contention affects both similarly. Disclosed.

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
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
**Runner-side files for this control (frozen list `runner_b5/SEEDS_b5.sha256`; preflight gating):**
- `runner_b5/seeds/C41/ARMS.tsv` SHA-256 `f4b056059bf732dba1f355261abcccf83a54c92b2983c092f107a7122028e344`
- `runner_b5/seeds/C41/FIXDEPTH` SHA-256 `95a108c0c1890a0b22b538a5af927679ef001291e637ea8f24c226082e7394ac`
- `runner_b5/seeds/C41/RB_JUDGE_P50__20_integrity_and_classify.R` SHA-256 `d11c2d2c146c240bbc8eeaf56b85fecfaa57673b932894d0c0628db110dbbabc`
- `runner_b5/seeds/C41/RB_P_DATESWAP__10_io_parse.R` SHA-256 `87513149cc081c2c433a90aacafda727277270c7177a00260023a25e636c0af6`
- `runner_b5/seeds/C41/RB_P_DUPINT__10_io_parse.R` SHA-256 `e55902b4bb29a77bc1a96bd405a64406ae043584f82ddece3675ca70029ab3e3`
- `runner_b5/seeds/C41/RB_P_TZUTC__10_io_parse.R` SHA-256 `33065838749ddf7013753deffe08963dc7aaffeb70bc3cd8cb5760e86f51263c`
- `runner_b5/seeds/C41/RB_STUB_F11__40_fixtures.R` SHA-256 `0961a79bf1b451b72450aac141290444514248e59abd88d9e5a6b699f968bca3`
- `runner_b5/seeds/C41/fixdepth.R` SHA-256 `5aa0cb96037b2616a26d4e68565be26393e5669f450b56783a70239e585696bd`
- `runner_b5/run_batch_v5.ps1` SHA-256 `e51e70e8050aa5582dca497d799c0b0c9fa1db7f3c6a2c1dc797d915970cd810`
- `runner_b5/eval_b5.R` SHA-256 `49742ad3ead70fe6b73121e61b0c774b1f94c4edc36f7241ef99456ef0cb3966`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; owner rulings file as above. This spec is hashed in `SPEC_FREEZE_b5.sha256` before the reporting run.
**Condition 4 for arm B = the 4 frozen R-B key outputs listed above under `RB_`.**
## Pre-execution check (disclosed)
The predicate text (`eval_b5.R`, SHA-256 in `SEEDS_b5.sha256`) was hashed before any execution. The complete runner was then exercised once on the PC in a scratch folder (`N13\_preflight_b5`, non-reporting, `NON_REPORTING.txt`): 2026-10-03 10:17–10:27 CT, runner tar `N13_runner_b5_v1.tar` SHA-256 0add2b9b37fc0d7af48c20eb2c5ebda550b3f0e2d2b5904fa82be3970e3d6e6e; preflight PASS; every run exit 0; summarize exit 0. Scratch outcome: count gate caught JUDGE_P50 only; depth gate caught P_DUPINT (F07), P_DATESWAP (F03/F05/F10/F14), STUB_F11 (stub probe: F11) and JUDGE_P50; clean B PASS on both gates (count 0.7 s, depth 1.7 s) and 4/4 R-B outputs equal frozen; mechanical result P1 MET. The scratch result was therefore known before this spec was frozen; the reporting run repeats every arm from scratch. No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
