# C46 — Ablation specification (FROZEN)

**Ablation ID:** C46 (Addendum 02, candidate #46 "Design-time numerical determinism")
**Batch:** N13 batch 4 (controls C51, C46, C52; the only three of the 25 open controls that qualified under the owner's 2026-10-03 rules: no new data pulls, no design chat, no owner ruling, mechanical threshold)
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 3 design / Stage 4 reconciliation (proposed addition)
**Frozen at CT:** 2026-10-03, before the runner executed (runner `run_batch_v4.ps1`, evaluator `eval_b4.R`)

## Control under test (proposed addition)
Declare four determinism items at design: (1) solver tolerance, (2) order invariance (canonical design-matrix column order), (3) exact tie semantics, (4) rounding-derived reconciliation rules. PricePoint: CC-S4-01 (glmnet default thresh 1e-7, column order, max 0.0715, 11 items > 0.05) and CC-S4-02 (half-cent straddles); combined attributable span ≈ 2 h 33 min (upper bound). Workflow PR #10 folded both in as owner text, not as an ablation result; the ablation baseline predates it.

## Verdict convention (proposed addition)
**KEEP = the four design-time determinism declarations are adopted. REVERT = they are not adopted.** HALT as in constitution §9.

## Exact change being tested
The Chicago 311 pack has no iterative fit, so one is **seeded** (Addendum 02 #46 test design) in `runner/seeds/C46/fit_path.R`: binomial glmnet (alpha 1, standardize = FALSE, fixed 30-value lambda path 0.02 → 2e-4, prediction at the smallest lambda) of y = (frozen R-B classification == ESCALATE) on a fixed feature set from the frozen pack (log open age, log peer n/p75/p50, created hour, day-of-week one-hot, top-8 ORIGIN + other, top-10 OWNER_DEPARTMENT + other; 215,687 rows, 32 columns). Each path writes p (17 significant digits), the rounding-derived field p_pct1 = round(100·p, 1), and the tie rule flag = p ≥ 0.5.
- **Baseline regime:** default thresh 1e-7; R-A uses natural column order, R-B reversed (both legitimate); comparator: |Δp| ≤ 0.05, p_pct1 exact, flag exact.
- **Declared regime:** thresh 1e-12; canonical (sorted) column order on both paths; tie rule p ≥ 0.5; comparator: |Δp| ≤ 1e-6, p_pct1 may differ by ≤ 0.1 only where |Δp| ≤ 1e-6 (rounding straddle), flag exact.
- A comparator field with ≥ 1 failing row = one reconciliation event = one change-control / both-path rebuild trigger (`recon_c46.R`).

## Known open finding N1 / OF-1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). C46 reads the frozen R-B classifications only as labels and features; it does not rerun R-A or R-B, so N1 does not enter any C46 number.

## Arms (runner v4, `seeds/C46/DETFIT`; ARMS.tsv in the packet)
- **REF**: R-A only, canonical order, thresh 1e-14 (convergence reference).
- **BASE**: baseline regime. **DECL**: declared regime.
- **THRESH_ONLY**, **ORDER_ONLY**: attribution probes (one declaration each, baseline comparator; reported, not in P1).
- **DEFECT_DECL**: declared regime, R-B omits feature x_log_peer_p75 (a real defect; must still fail recon). **DEFECT_BASE**: same defect under baseline (reported).

## Operational benefit predicate P1 (made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. BASE: ≥ 1 reconciliation event;
2. DECL: 0 reconciliation events;
3. DEFECT_DECL: recon FAIL (the declared tolerance does not hide a real defect);
4. DECL R-A vs REF: max|Δp| ≤ 1e-6 and identical flags (the declared tolerance is met against a tighter solve);
5. extra rebuilds: BASE ≥ 1 and DECL = 0.
REVERT side: any of 1–5 fails.
**Disclosed limitation (OF-2 candidate):** the addendum's second metric, "design-time cost (logged Stage 3 minutes) below the baseline's rebuild minutes", cannot be measured without a design chat; it is **not measured**. The cost side is operationalised only as rebuild counts. The Adjudicator must not treat it as measured.

## Regression / HALT rules
- HALT if any fit has jerr ≠ 0, a fit or RECON output is missing, or Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 (exact reconciliation where required) = the declared-regime comparator on DECL; condition 5 (mandatory fixtures): the seeded fit has no fixture harness, so no mandatory fixture applies (declared now, before execution); conditions 6–7: the frozen pack is only read (its hashes are re-verified by the preflight).

## Allowed source/data scope
Frozen PC pack, read only. No internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
**Runner-side files for this control (frozen list `runner/SEEDS_b4.sha256`; preflight gating):**
- `runner/seeds/C46/ARMS.tsv` SHA-256 `d75c3c524b02440976382eecde5a5671c46639cbebbb53a855c9fed4b3b3c5af`
- `runner/seeds/C46/DETFIT` SHA-256 `6757df6441349d11adab1c808386b13a1251610fcdce529e4bc2613908973fd2`
- `runner/seeds/C46/fit_path.R` SHA-256 `d681aff97febf1045c003bf0fba6715ab80d4660d1d2f36d10e63a904147f238`
- `runner/seeds/C46/recon_c46.R` SHA-256 `9cd9fe1248985db26bbaf334dfc6bfbcf9d60e21f342b7388c25c5e10e150867`
- `runner/run_batch_v4.ps1` SHA-256 `6b857ef067967e9bec04e8cab7009b69e056c08245f520816f1ffd979b087d7e`
- `runner/eval_b4.R` SHA-256 `cd5ec767a4d2158830ccd2ba679a0619f668bf5d3f354d9e7a54648e1dab9396`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above. This spec is hashed in `SPEC_FREEZE_b4.sha256` before execution.
**Inputs actually read by the fit:** `R-B/outputs/RB_classifications.csv` and `data/source/src_open_candidates.csv` (above).

## Pre-execution check (disclosed)
Before this spec was frozen, `fit_path.R` and `recon_c46.R` were exercised on the PC in a scratch folder (non-reporting). The first attempt failed on an output-formatting bug (a column reused after formatting) and a deprecated-argument warning; both were fixed (glmnet solver settings now go through `control=` when available) before any result was produced. A second check (natural vs reversed order): thresh 1e-7 → max|Δp| 0.00845, 11 flag differences; thresh 1e-12 → max|Δp| 9.4e-6, 0 flag differences. No arm parameter, threshold or rule was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
