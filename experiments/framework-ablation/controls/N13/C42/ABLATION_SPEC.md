# C42 — Ablation specification (FROZEN)

**Ablation ID:** C42 (Addendum 01, control #42 "Batched owner rulings"; PricePoint evidence links in Addendum 02)
**Batch:** N13 b5 follow-on (C42 alone; run after C41, C47, C53, C48 with runner `runner_c42/run_c42.ps1`, R only, no MySQL)
**Owner rulings (operational definitions, constitution §9):** ruling 42A in `ablation_plan/OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba` (ruled 2026-10-03 09:58 CT). Answer sheet `ablation_plan/OWNER_42_SHEET.md` SHA-256 `37acd34e2a76793bb5942c100f703b2a4045b6161c5ba4f76295b4322bd642c9`. **Owner answers 2026-10-03 10:49 CT: `1B 2A 3A 4A 5A`** in `ablation_plan/OWNER_42_ANSWERS.md` SHA-256 `a368b908804f8915a603241edf555891fc31857a3c9e36f4486e0198747e894f`, frozen in `ablation_plan/OWNER_42_ANSWERS.sha256` (SHA-256 `d0fac1d07c102c37416689edcdb613d2bf2f8af069e9b3ed0f3c4beb81167193`, written 10:51 CT) before any C42 file was built.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 owner-ruling handling (cut/relax of piecemeal interruptions)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_c42/run_c42.ps1`, evaluator `runner_c42/eval_c42.R`)

## Control under test (Addendum 01 #42)
Rule as it stands: interpretive questions go to the owner piecemeal, as they surface (PricePoint: 9 interruptions on Oct 2; R1–R6 already batched in one round; R7, CC-S4-01, R9 and R11 depended on outputs that did not yet exist). Change: collect every builder or design question into one ruling round before reconciliation. Metric: owner interruptions, repair rounds, and any question left unresolved.

## Verdict convention (Addendum 01)
**KEEP = batched owner rulings are adopted (one round before reconciliation, plus one round after the run for questions that can only arise then). REVERT = piecemeal stays.** Addendum 01: "KEEP if interruptions and rounds go down with nothing unresolved. REVERT if a gating question is missed." HALT as in constitution §9.

## Exact change being tested (ruling 42A playback)
The owner answered five planted questions once (sheet). The run plays the frozen answers back two ways on the frozen pack. Declared timeline (sheet coordinator note): Q1–Q3 surface during the build; Q4–Q5 can only arise after a run.
- **Builder defaults** (read from the frozen code of both paths before this spec; identical on R-A and R-B): Q1 κ·0 = 0 → ESCALATE (= option A); Q2 only the exact status "open" is in the set, others out (= option C); Q3 blank DUPLICATE → not a duplicate (= option A); Q4 nothing reported; Q5 no rule.
- **Arises:** a question arises if its situation exists on the frozen pack (`q_probe.R`): Q1 a decision row reaches the κ rule with peer_p75_h = 0; Q2 a source STATUS starts with "open" (trimmed, any case) but is not exactly "open"; Q3 a source DUPLICATE is blank (empty or the text NULL); Q4 the ruled #47 check flags a type; Q5 R-A and R-B word the reason column differently on a row with the same label.
- **Change (gating):** a question is gating if its frozen answer changes at least one written output row relative to the builders' defaults. Q1–Q3: measured by R-B `all` runs with the answers switched on (`RB_RULED__20_integrity_and_classify.R`, switches `C42_RULINGS`; with no switch set it must reproduce the frozen R-B outputs byte for byte). Q1 = PM_1 vs R0, Q2 = PM_12 vs PM_1, Q3 = PM_123 vs PM_12. Q4 answer A changes nothing by its own wording (report the caveat). Q5 answer A changes nothing if the R-A and R-B reason codes correspond one-to-one; rows outside a one-to-one correspondence count as Q5 change rows.
- **Piecemeal (baseline):** each arising question is one owner interruption at the point it surfaces. The builders continue on their defaults meanwhile (as with PricePoint R-B's r1 questions at ~03:05, ruled at 09:57), so each gating answer arrives separately and costs one repair round (both-path rebuild and rerun).
- **Batched (variant):** round A = Q1–Q3 in one ruling round before reconciliation; round B = Q4–Q5 in one round after the run (ruling 42A: a question that can only arise after a run may come later; it counts as an interruption, not as "missed"). Each round with ≥ 1 arising question = one interruption; each round with ≥ 1 gating answer = one repair round.
- **Unresolved:** a gating question whose answer is not applied in the regime's final output (every change row of that question must appear unchanged in the final output: PM_123 for piecemeal, BATCH for batched).
- Not measured: owner minutes per round, brief-writing minutes, real builder behaviour (ruling 42A tests the counting and the nothing-missed check on planted questions, not live builders).

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, confirmed on the PC (R 4.6.1, 2026-10-03): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), R-A's lubridate parse as the second (CST; 1762068600). Open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). Owner ruling 53A (clock rule: first occurrence, daylight time) makes R-B the conforming path. In C42: the 3 rows are a numbers difference, not a reason-wording difference, so they are outside Q5 (which is about reason text only); they were settled by ruling 53A and are not counted as a C42 question. All C42 arms are R-B runs compared with R-B, so N1 cannot change a C42 count.

## Arms (runner `run_c42.ps1`, `seeds/C42/ARMS.tsv`)
- **R0**: switched judge file, no switch (builders' defaults); must equal the frozen R-B outputs 4/4.
- **PM_1** (Q1B), **PM_12** (Q1B,Q2A), **PM_123** (Q1B,Q2A,Q3A): the piecemeal repair sequence; PM_123 = piecemeal final output.
- **BATCH** (Q1B,Q2A,Q3A at once): batched round A = batched final output.
- Every arm also runs the #47 dominance check on its output (Q4 context). **PROBE**: `q_probe.R` on the frozen source, frozen R-A and frozen R-B (arises facts, Q5 code pairs).

## Operational benefit predicate P1 (made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. owner interruptions go down: batched < piecemeal;
2. repair rounds go down: batched < piecemeal;
3. nothing unresolved: 0 gating questions unanswered in the batched final output;
4. same answer either way: the piecemeal and batched final outputs (4 R-B key outputs) are byte-identical;
5. validity: R0 equals the frozen R-B outputs 4/4 (else HALT).
REVERT side: any of 1–4 fails (Addendum 01 wording "go down" is read as strictly lower for both counts). The alternative reading "neither goes up and at least one goes down" is computed and reported as INFO only, not scored. Note, declared before execution: under this model batched repair rounds equal piecemeal ones whenever each round holds at most one gating answer, so condition 2 can only be met if two or more of Q1–Q5 change output rows in the same round.

## Regression / HALT rules
- HALT if an R-B run, dominance check or the probe fails or is missing; if R0 differs from the frozen R-B outputs (harness defect); or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 = byte identity of the two regimes' final outputs (condition 4 of P1) and R0 = frozen; condition 5 = the fixture results inside each `run_RB.R all` (R0 must equal the frozen RB_fixture_results.csv hash); conditions 6–7: the frozen pack is only read (preflight hashes).

## Allowed source/data scope
Frozen PC pack, read only, copied into the work folder. No MySQL (another batch holds the database), no internet, no new data.

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
**Runner-side files (frozen list `runner_c42/SEEDS_C42.sha256`; preflight gating):**
- `runner_c42/eval_c42.R` SHA-256 `c0e9df0b73deca7a2bd72509d670e8e8161160f0e10f8468719233f8d2fb0012`
- `runner_c42/run_c42.ps1` SHA-256 `57de245c6d3f7f14bcf4c70e35f14600215dc018d26bb2ce76e2e4d64f1d4c32`
- `runner_c42/seeds/C42/ARMS.tsv` SHA-256 `e88d84eb48ef31737eb46b6d3372b81087ca13ee9b6a1e5c0179a1c0b4733a10`
- `runner_c42/seeds/C42/PLAYBACK.json` SHA-256 `b55d22785b2ea4416883b2358ab165832bf2a8ebdff9d186567bf685f5032f0a`
- `runner_c42/seeds/C42/RB_RULED__20_integrity_and_classify.R` SHA-256 `f43c4abec68274bde4f4e3c30e41f8e30beffbf5d7f4b4d02afffa363ab41fcd`
- `runner_c42/seeds/C42/SEEDFILE` SHA-256 `1135254f6dfdee01dc9eda4ef9ee7c7aa7cae199d5b8891cf36e96b99b485a5a`
- `runner_c42/seeds/C42/dom_check.R` SHA-256 `582cb7822b44ef187282c981fbd7efa1d4dea8cec9014878e2b98a92a4355145`
- `runner_c42/seeds/C42/q_probe.R` SHA-256 `a70189af575adcee6ac27d6acb64fc4cbf4d5a1aa5ea1cfc1e68ad4bab41617c`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; owner rulings, sheet and answers as above. This spec is hashed in `SPEC_FREEZE_C42.sha256` before the reporting run.
**Condition 5 for R0 = the 4 frozen R-B key outputs listed above under `RB_`.**

## Pre-execution check (disclosed)
The predicate text (`eval_c42.R`, SHA-256 in `SEEDS_C42.sha256`) was hashed before any execution. The complete runner was then exercised twice on the PC in scratch folders (non-reporting, `NON_REPORTING.txt`). Scratch 1 (`N13\_preflight_c42`, 10:56 CT, tar `N13_runner_c42_v1.tar` SHA-256 007a2c3b8b9ccd8d85ab053bc7eb4a12c6c40d8a0bc94a7c2fbe80392fbab985) stopped at arm setup on a harness bug (PowerShell indexed a one-line file as a character: `(Get-Content SEEDFILE)[0]`); it was fixed to `@(Get-Content SEEDFILE)[0]` in `run_c42.ps1`, the seeds were regenerated (the earlier set is kept unexecuted in `runner_c42/_superseded_v0/`), and `eval_c42.R` (the predicate) is unchanged (same SHA-256 before and after). Scratch 2 (`N13\_preflight_c42_2`, 10:56–11:00 CT, tar `N13_runner_c42_v2.tar` SHA-256 25d4893771e86d7c5f73e3793d3198df38c49cacf3dd94ea1bb2f103865ff400): preflight PASS, every run exit 0. Scratch outcome: Q1 arises (29 ESCALATE rows of type SEF with peer_p75_h = 0; answer B changes all 29 to INCONCLUSIVE); Q2 and Q3 do not arise (source STATUS is only 'Open'; DUPLICATE only 'true'/'false'); Q4 arises (WCA2 flagged), Q5 arises (reason codes one-to-one, 0 change rows); piecemeal 3 interruptions / 1 repair round, batched 2 / 1; final outputs identical; R0 = frozen 4/4; mechanical result P1 NOT MET (condition 2), INFO alternative reading met. The scratch result was therefore known before this spec was frozen. No arm, threshold, rule or predicate was changed after scratch 2; the reporting run repeats every arm from scratch.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
