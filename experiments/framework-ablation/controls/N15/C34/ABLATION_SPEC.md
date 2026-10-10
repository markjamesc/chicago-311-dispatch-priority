# C34 — Ablation specification (FROZEN)

**Ablation ID:** C34 (owner Remaining Ablation Program, catalog #34 "Deterministic Workflow Gate")
**Batch:** N15 batch 2 of 3 (controls C14, C11, C34, C16, C18)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`; `R-B/R/40_fixtures.R` `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4→5 (gate before interpretation)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Stage 5 may start only if the deterministic workflow gate (`validation/workflow-gate/workflow_gate.R`) returns PASS on the stage receipts.

## Exact change being tested (ablation)
There is no workflow gate. Stage 5 (`run_deeper_analysis.R`) runs on whatever Stage 4 produced. It keeps its own built-in independent count checks, a `stopifnot` on n_decision/ESCALATE/INCONCLUSIVE/STANDARD/validated-list counts.
**Per-arm pipeline** (runner v2, run for arm B and for every seeded arm):
1. R-A and R-B run (seeded).
2. The validated action list is built from R-A.
3. A Stage-4 receipt is written from that arm's mechanical results by `stage45_receipt.R`:
   - r_a/r_b_status: exit 0 and output present.
   - r_a/r_b_fixtures: all fixture rows pass.
   - reconciliation: key set + classification, the frozen recon practice.
   - sql_source_gate, structural_cross_review and lineage_attestation are copied as PASS from the frozen receipt, not re-run.
   - validation_gate is PASS only if all mechanical fields pass.
4. The frozen workflow gate runs on the receipt. Its result is recorded.
5. Stage 5 runs anyway, and its exit code and outputs are recorded.

The harness scripts are path-only substitutions of the frozen scripts (diffs in `runner/SEED_DIFFS_b2.txt`). Stage 1–3 receipts are copied verbatim from the pack:
- `stage45/build_validated_action_list.R` SHA-256 `0d7256e38a04b6a429d9ceb36d3f9073674a06dcaf72213654395bcc2669b5c6`
- `stage45/run_deeper_analysis.R` SHA-256 `a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94`
- `stage45/stage1_decision.json` SHA-256 `a74389affbdafbb37d6d591b778af6abcd78ecb4fac8d23db91e455b6cdec430`
- `stage45/stage2_framing.json` SHA-256 `4f56449811e5d7d76c843bf3e503829a06f23d4060689e9a8dec48b150dd1e4a`
- `stage45/stage3_locked_design.json` SHA-256 `ff5651d89d276728d50f317d59270e779fec2c3f96022bf9b92e63cd2128f114`
- `stage45/stage45_receipt.R` SHA-256 `8c2644405d052194b2f46d089dd04eeca67b631058ecbfd09b9c63c906e9d711`
- `stage45/workflow_gate.R` SHA-256 `27a6e83c3ff2780aeb50c0a681d46b07590fe011ec45e6eb8bc87f28ca36c193`
**Stage-5 harm set H:** seeded arms where Stage 5 completes (exit 0) and at least one of its 8 outputs differs from arm B's Stage-5 output. CSV content is compared, numbers to 1e-9.
**Caught with the control:** gate result FAIL, or Stage 5 exits non-zero.
**Caught without the control (D_abl):** Stage 5 exits non-zero, from its own count checks or a missing input.
Disclosure: the receipts are written truthfully from mechanical results. A receipt that falsely claims PASS is outside this test.

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. As a result, arm B's full-field recon (R-A vs R-B) shows dormant_h 1 and open_age_h 2 in every control. These mismatches are present in the frozen pack itself. The HALT rule "B recon 0/0/0" uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h.

## Seeded Stage-4 states (frozen before execution; every arm runs both paths)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b2.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b2.txt`. No source variants are used in batch 2.
- **W_RA_NOTHIN** (paths run: RA+RB): Stage-4 failure: R-A drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs.
  - code seed `seeds/C34/RA_NOTHIN__run_RA.R` → `R-A\run_RA.R`, SHA-256 `65e90bf81cb2f573f744636947175fb3531b9053d76ee90fed1b003212c1f98b`
- **W_RB_NOTHIN** (paths run: RA+RB): Stage-4 failure: R-B drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs.
  - code seed `seeds/C34/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
- **W_RB_K25** (paths run: RA+RB): Stage-4 failure: R-B production kappa 2.5 (recon fails); Stage 5 then runs.
  - code seed `seeds/C34/RB_K25__00_config.R` → `R-B\R\00_config.R`, SHA-256 `401d894c5cac7d6ae226758ba9bf0303f3e404a382796ffa89197505934a5c90`
- **W_RB_CRASH** (paths run: RA+RB): Stage-4 failure: R-B exits non-zero with no outputs; Stage 5 then runs.
  - code seed `seeds/C34/RB_CRASH__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `d0bc0daccd1c7ebc0d5dc906d8f46ffd637a7954e0fa55b80190d3608f04f6ad`
- **W_RA_ROUND1** (paths run: RA+RB): R-A reports dormant_h rounded to 0.1 h (labels unchanged; the frozen key+label recon passes); Stage 5 then runs.
  - code seed `seeds/C34/RA_ROUND1__run_RA.R` → `R-A\run_RA.R`, SHA-256 `29071d305d5d74f203e9eafc58568ff81ac6c642bc233125a3f348cbb4aa45fd`
## Operational benefit predicate P1
Owner threshold: "Pass: No changes when skipping gate. Fail: Skipping gate allows errors (keep rule)."
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1. Here H is the Stage-5 harm set. Arms where the gate fails but Stage 5's outputs are unchanged are reported separately. Classification-level changes are reported for context.

Additional HALT rule: HALT if arm B's gate result is not PASS, or if arm B's Stage-5 outputs differ from the frozen `stage-05/deeper` outputs.

## Fixture suite
`fixtures-v1-tcd-ig`, F01–F14, on every path that runs (as frozen unless an arm's seed states a fixture rewrite).

## Allowed source/data scope
Frozen PC pack, read only and copied into the work folder `...\ablation-runs\N15`. No new extract; MySQL is used only for a read-only COUNT preflight. No rewrite of frozen labels or fixtures in the pack.

## Regression / HALT rules
- HALT if arm B does not reproduce the frozen pack (any key/label/dormant/open_age difference vs the frozen RA/RB classifications), if B recon (key set + classification, the frozen definition; see N1) is not 0/0/0, or if B fixtures are not 14/14 on both paths.
- HALT if any seeded run is missing (no exit recorded), or if Builder and Validator disagree on a hard number in the RESULTS file.
- A seeded arm that crashes (exit ≠ 0 or no output) counts as caught in every regime. It is not a HALT.
- RAW evidence present → do not HALT for missing historical stdout. If P1 fails and no HALT condition holds → REVERT.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
