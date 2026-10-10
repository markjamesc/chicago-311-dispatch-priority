# C39 — Ablation specification (FROZEN)

**Ablation ID:** C39 (ablation Addendum 01, control #39 "Reconciliation scope & tolerance")
**Batch:** N15 batch 1 of 3 (controls C26, C31, C39, C30, C29)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (reconciliation field scope)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
R-A vs R-B must match on the full locked field list, exact on non-prediction fields, with no tolerance waiver. For this pack the comparable locked fields in both outputs are the key set, classification, dormant_h and open_age_h. Exact means |d| ≤ 1e-6, because R-A writes 6 decimals.

## Exact change being tested (ablation)
Reconcile only the decision-driving fields: the key set and classification. dormant_h and open_age_h are reported but do not gate. This pack has no prediction fields, so no prediction tolerance applies.
Disclosure: the frozen 2026-09-19 recon (`recon/run_recon.R`) compares classification only. The ablated variant therefore equals the frozen pack's own recon practice, and the control is the stricter full-field match.
**Caught with the control:** crash, a full-field recon mismatch, or a fixture failure.
**Caught without the control (D_abl):** crash, a decision-field recon mismatch (key set + classification), or a fixture failure.
Arm B's full-field recon (R-A vs R-B) is reported, to show whether the strict regime raises an alarm on the clean pair.

## Seeded defects (frozen before execution; R-B only, R-A = arm B)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b1.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b1.txt`. Source variants are built deterministically on the PC by `runner/source_variants.R`, which stops unless an identity rebuild reproduces the frozen SHA-256. Their hashes are in `_variants/VARIANTS.tsv`.
- **R_ROUND1** (paths run: RB): R-B reports dormant_h rounded to 0.1 h (labels computed before rounding).
  - code seed `seeds/C39/RB_ROUND1__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `c7080cecaea56428b1544b0d9a366f7b17adf315bf31f26720cc86c169506bfd`
- **R_OPENAGE** (paths run: RB): R-B reports open_age_h from mod_ts instead of created_ts (not a decision input).
  - code seed `seeds/C39/RB_OPENAGE__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `9be2b7e928124cc96bf0e1e85bcab326a55533f65702906be4e27ad4a15e1ac5`
- **R_GT** (paths run: RB): R-B kappa threshold uses > instead of >= (boundary rows only).
  - code seed `seeds/C39/RB_GT__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `484db21bbd924040b990afdca785e4fafa6d7dabe967b19e8fe94b45cf07fb8f`
- **R_NOTHIN** (paths run: RB): R-B I04 thin-peer integrity clause removed (decision defect).
  - code seed `seeds/C39/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
## Operational benefit predicate P1
Owner threshold: Addendum 01: "KEEP (relax the control) if the reduced regime catches every defect that changes a decision or a reported result. REVERT (keep full exact match) if it lets through a defect that changes either."
Definitions:
- **H:** harm set (above).
- **D_abl:** seeded arms caught without the control (definition above).
Outcomes:
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1. A reported result = a locked field of the classification output.

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
