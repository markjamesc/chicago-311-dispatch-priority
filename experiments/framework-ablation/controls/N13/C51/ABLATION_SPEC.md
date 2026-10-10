# C51 — Ablation specification (FROZEN)

**Ablation ID:** C51 (Addendum 02, candidate #51 "Reduced-scale real-data smoke run before the full pipeline")
**Batch:** N13 batch 4 (controls C51, C46, C52; the only three of the 25 open controls that qualified under the owner's 2026-10-03 rules: no new data pulls, no design chat, no owner ruling, mechanical threshold)
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 execution (proposed addition)
**Frozen at CT:** 2026-10-03, before the runner executed (runner `run_batch_v4.ps1`, evaluator `eval_b4.R`)

## Control under test (proposed addition)
Rule as it stands: preflight and the synthetic fixture harness pass, then the full pipeline runs. Proposed addition: a declared end-to-end smoke run on a fixed small subset of the frozen extract, before the full run. PricePoint evidence: R-B r2 (O(n²) loop, 43 min 43 s), r3 (renamed column at step 10, 22 min 13 s), r4 (object not found at output writing, 22 min 17 s) = 88 min 13 s of full runs.

## Verdict convention (proposed addition)
**KEEP = the smoke run is adopted as a required step before the full run. REVERT = it is not adopted; the framework stays as is.** HALT as in constitution §9.

## Exact change being tested
Variant = fixtures (inside `run_*.R all`), then a smoke run at 1/16 scale, then at 1/4 scale, then the full run. Baseline = the full run only.
- **Declared subset rule** (`runner/seeds/common/make_subset.R`): header + every k-th data line of the frozen `src_open_candidates.csv` (data lines 1, 1+k, …; file order = SR_NUMBER order). k = 16 (15,325 rows) and k = 4. `src_peer_stats.csv` and `src_extract_lineage.csv` are copied unchanged.
- Smoke roots live under `<CID>/smoke/<arm>_<path>_k<k>`, outside every arm root, and each carries `NON_REPORTING.txt`. **Smoke runs are real-data, non-reporting runs: they are never reconciled, never used as results and never enter a receipt.**
- **Smoke failure (detection) rule:** k16 exits non-zero or hits its cap → detected at k16; else k4 exits non-zero, hits its cap, or t(k4)/t(k16) > 6 (more than 1.5× the linear 4× ratio) → detected at k4; else not detected.
- Caps: smoke 600 s each; full run 1800 s (killed with `taskkill /T /F`; the capped time is used). All three runs are executed for every unit so both regimes can be costed from one execution.

## Known open finding N1 / OF-1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). C51 does not reconcile R-A vs R-B; clean arm B is instead compared byte-for-byte with the 7 frozen key outputs, which already embed N1.

## Arms (runner v4, `seeds/C51/SMOKE`)
- **B**: frozen code, both paths (R-A, R-B): smoke k16, smoke k4, full.
- **SM_QUADLOOP** (R-B): O(n²) full-frame subset loop after loading (PricePoint r2 analogue).
- **SM_MIDCRASH** (R-B): selects a renamed column `.dormant_h` when writing classifications, after judging (r3 analogue).
- **SM_OUTCRASH** (R-B): writes an undefined object `grid_out_final` at the last output, the kappa grid (r4 analogue).
- **SM_RARECRASH** (R-B, outside H): stops on SR_SHORT_CODE = ODM (6 rows, none in either smoke subset). Subset-bias probe; counted in the time sum.
Seeded arms run R-B only; diffs vs frozen `run_RB.R` are in the packet.

## Time accounting (declared; seconds measured by the runner)
- Baseline per seeded unit = seeded full run (or its cap) + clean full run (arm B, same path) as the rerun after the fix.
- Variant per seeded unit = smoke time up to detection (k16; or k16 + k4) + clean smoke k16 + k4 + clean full run (arm B); if not detected: k16 + k4 + seeded full run + clean smoke + clean full run.
- Arm B (clean code) per path: baseline = full run; variant = k16 + k4 + full (the smoke overhead is charged).

## Operational benefit predicate P1 (Addendum 02 #51 success metric, made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. smoke detects SM_QUADLOOP, SM_MIDCRASH and SM_OUTCRASH (each at k16 or k4, i.e. before its full run);
2. no false smoke flag on clean arm B (R-A and R-B);
3. the summed time over all units (B R-A, B R-B, the four seeded arms) is lower under the variant than under the baseline;
4. arm B's full-run 7 key outputs equal the frozen hashes below and no full-run manifest references a smoke path (no smoke output in any receipt).
REVERT side: any of 1–4 fails. Disclosed limitation: the baseline cost of SM_QUADLOOP is bounded by the 1800 s cap, so the saving reported is a lower bound for that unit.

## Regression / HALT rules
- HALT if a run exit record is missing, if arm B's full run fails, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 conditions 4–7 apply to clean arm B: exact reconciliation = byte equality of its 7 key outputs with the frozen outputs; mandatory fixtures = its R-A and R-B fixture results (all must pass; they run inside `run_*.R all`).

## Allowed source/data scope
Frozen PC pack, read only, copied into the work folder. MySQL only for a read-only COUNT preflight. No internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`
- `R-A/run_RA.R` SHA-256 `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`
- `R-B/run_RB.R` SHA-256 `6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd`
- `R-B/R/00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`
- `R-B/R/10_io_parse.R` SHA-256 `40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a`
- `R-B/R/20_integrity_and_classify.R` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`
- `R-B/R/40_fixtures.R` SHA-256 `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`
- `R-A/outputs/RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-A/outputs/RA_fixture_results.csv` SHA-256 `33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-A/outputs/RA_portfolio_counts.csv` SHA-256 `b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
- `sql/01_source_extract.sql` SHA-256 `f365e84a7e5d95f39a5fc19133d068e53a3aa5898f619e39db4dc6e0ba3a57b5`
- `sql/02_source_gate_checks.sql` SHA-256 `ae26edb6af074a1a61e92d241fffef0730c893fef0c8c7ae6929d3f2d50aef59`
**Runner-side files for this control (frozen list `runner/SEEDS_b4.sha256`; preflight gating):**
- `runner/seeds/C51/ARMS.tsv` SHA-256 `73965b209e03978243dd910b916976d2a883012653003d4ebd12b4b549de03b8`
- `runner/seeds/C51/RB_SM_MIDCRASH__run_RB.R` SHA-256 `f36a9b5dcf9144c9a1c251499c90f1134079948c30661272f435a2bced9fc1a1`
- `runner/seeds/C51/RB_SM_OUTCRASH__run_RB.R` SHA-256 `87ec66e12aa7473e46203fd961b2714e6f8722c2db9f246e4893d1ba838ae89d`
- `runner/seeds/C51/RB_SM_QUADLOOP__run_RB.R` SHA-256 `7832b7176bb1520baa1da896614ef96290400746bca8d84a48c49c936a81fa23`
- `runner/seeds/C51/RB_SM_RARECRASH__run_RB.R` SHA-256 `8afb11ce4f7af87b5cf5c4712cef52ca63b3c02f724952c6ecdcb958611a10b6`
- `runner/seeds/C51/SMOKE` SHA-256 `ad911cfd289a54744ec4a112e7ac75df752a58d45d7c049fa0c1c5f9735c7198`
- `runner/seeds/common/make_subset.R` SHA-256 `fac8f1dd0f3f08af6e9bb964102a6fd5d15be5ece105cafee7eaa2eeeb8008fe`
- `runner/run_batch_v4.ps1` SHA-256 `6b857ef067967e9bec04e8cab7009b69e056c08245f520816f1ffd979b087d7e`
- `runner/eval_b4.R` SHA-256 `cd5ec767a4d2158830ccd2ba679a0619f668bf5d3f354d9e7a54648e1dab9396`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above. This spec is hashed in `SPEC_FREEZE_b4.sha256` before execution.
**Condition 4 (exact reconciliation) for arm B = these 7 frozen key outputs:** RA/RB classifications, RA/RB fixture results, RA/RB portfolio counts, RB kappa grid (listed above under `outputs`).

## Pre-execution check (disclosed)
Before this spec was frozen the runner pieces were exercised once on the PC in a scratch folder (`N13\_preflight_smoketest`, non-reporting): at k16, clean R-B exit 0 in 3.4 s; SM_MIDCRASH and SM_OUTCRASH exit 1; SM_RARECRASH exit 0; SM_QUADLOOP exit 0 in 20.1 s. No arm parameter, cap or rule was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
