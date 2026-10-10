# C30 — Ablation specification (FROZEN)

**Ablation ID:** C30 (owner Remaining Ablation Program, catalog #30 "Structural Cross-Review")
**Batch:** N15 batch 1 of 3 (controls C26, C31, C39, C30, C29)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (post-reconciliation logic review)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
After exact reconciliation, a structural (logic) cross-check of the two implementations is done, to catch common-mode errors that matching totals miss.

## Exact change being tested (ablation)
There is no structural review. Matching totals (exact recon R-A vs R-B), exit 0 and fixtures on both paths are accepted as sufficient.
**Caught without the control (D_abl):** crash, recon key/label mismatch, or a fixture failure on any path.
Disclosure: the structural review itself is a reading of both implementations and is not simulated by the runner. The test measures only whether the remaining mechanical checks catch identical (common-mode) errors.

## Seeded common-mode errors (frozen before execution; the same rule change in both paths)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b1.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b1.txt`. Source variants are built deterministically on the PC by `runner/source_variants.R`, which stops unless an identity rebuild reproduces the frozen SHA-256. Their hashes are in `_variants/VARIANTS.tsv`.
- **CM_GT** (paths run: RA+RB): Common-mode: both paths use > instead of >= at the kappa threshold.
  - code seed `seeds/C30/RA_GT__run_RA.R` → `R-A\run_RA.R`, SHA-256 `9a4b718a685030793c43be6a6441338cf5f02d64dbfcd70918a0b7b65ff2f9a8`
  - code seed `seeds/C30/RB_GT__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `484db21bbd924040b990afdca785e4fafa6d7dabe967b19e8fe94b45cf07fb8f`
- **CM_NODUP** (paths run: RA+RB): Common-mode: both paths drop the DUPLICATE exclusion.
  - code seed `seeds/C30/RA_NODUP__run_RA.R` → `R-A\run_RA.R`, SHA-256 `94aef54437d5be9536da5ee608e6ef24ba7b2c2f861b036afd652fdd1a0e1421`
  - code seed `seeds/C30/RB_NODUP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `4f1d8422f4dbe7fad83c5ad737a5bd36f4f50494dc6453f00e8761870f73ec69`
- **CM_NOPARENT** (paths run: RA+RB): Common-mode: both paths drop the I05 parent clause.
  - code seed `seeds/C30/RA_NOPARENT__run_RA.R` → `R-A\run_RA.R`, SHA-256 `ce20b9f3907134ccd932e9792fe555c8a1512bfcce948ed3e4b4e8dea849aa74`
  - code seed `seeds/C30/RB_NOPARENT__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `4a68398b7506336818243d60e100c6c0e2e59520c4bc444f48a9ad1b1ff6784e`
- **CM_NOTHIN** (paths run: RA+RB): Common-mode: both paths drop the I04 thin-peer clause.
  - code seed `seeds/C30/RA_NOTHIN__run_RA.R` → `R-A\run_RA.R`, SHA-256 `65e90bf81cb2f573f744636947175fb3531b9053d76ee90fed1b003212c1f98b`
  - code seed `seeds/C30/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
- **CM_NOI01** (paths run: RA+RB): Common-mode: both paths drop the I01 open+closed-date clause.
  - code seed `seeds/C30/RA_NOI01__run_RA.R` → `R-A\run_RA.R`, SHA-256 `496bbd80dbdf034160eab47a86b33f1ec6b3e0f565856f20010fb08253116769`
  - code seed `seeds/C30/RB_NOI01__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `e6974fff186c13dae13386cb9ebc19b375362070783b316d02b4a903f0443f6d`
## Operational benefit predicate P1
Owner threshold: "Pass: Matching totals was sufficient (no hidden error). Fail: Review finds a flaw despite equal sums (keep rule)."
Definitions:
- **H:** harm set (above).
- **D_abl:** seeded arms caught without the control (definition above).
Outcomes:
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1.

## Fixture suite
`fixtures-v1-tcd-ig`, F01–F14, on every path that runs.

## Allowed source/data scope
Frozen PC pack, read only and copied into the work folder `...\ablation-runs\N15`. No new extract; MySQL is used only for a read-only COUNT preflight. No rewrite of frozen labels or fixtures. Seeded source variants are derived from the frozen source only.

## Regression / HALT rules
- HALT if arm B does not reproduce the frozen pack (any key/label/dormant/open_age difference vs the frozen RA/RB classifications), if B recon is not 0/0/0, or if B fixtures are not 14/14 on both paths.
- HALT if any seeded run is missing (no exit recorded), or if Builder and Validator disagree on a hard number in the RESULTS file.
- A seeded arm that crashes (exit ≠ 0 or no output) counts as caught in every regime. It is not a HALT.
- RAW evidence present → do not HALT for missing historical stdout. If P1 fails and no HALT condition holds → REVERT.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
