# C18 — Ablation specification (FROZEN)

**Ablation ID:** C18 (owner Remaining Ablation Program, catalog #18 "No Fixture Rewrite on Fail")
**Batch:** N15 batch 2 of 3 (controls C14, C11, C34, C16, C18)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`; `R-B/R/40_fixtures.R` `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (fixture failures)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
A failed fixture may not be rewritten. Only a new, versioned fixture is allowed, with a note on the reason. A fixture failure therefore stops the run until the code is fixed.
**With the control (FX_ arms):** each defect runs against the frozen fixtures. Caught = crash, recon key/label mismatch, or fixture failure.

## Exact change being tested (ablation)
When a fixture fails, its expected label is rewritten to the observed label, and the rerun passes. **RW_ arms** carry the same defect plus that rewrite (in `R-A/run_RA.R` and/or `R-B/R/40_fixtures.R`). The rewritten labels were fixed before execution, from the fixture inputs.
**Caught without the control (D_abl, RW_ arms):** crash, recon key/label mismatch, or a fixture failure that remains after the rewrite.

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. As a result, arm B's full-field recon (R-A vs R-B) shows dormant_h 1 and open_age_h 2 in every control. These mismatches are present in the frozen pack itself. The HALT rule "B recon 0/0/0" uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h.

## Seeded defects and rewrites (frozen before execution)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b2.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b2.txt`. No source variants are used in batch 2.
- **FX_CM_NOTHIN** (paths run: RA+RB): Both paths drop the I04 thin-peer clause; fixtures as frozen (no rewrite).
  - code seed `seeds/C18/RA_NOTHIN__run_RA.R` → `R-A\run_RA.R`, SHA-256 `65e90bf81cb2f573f744636947175fb3531b9053d76ee90fed1b003212c1f98b`
  - code seed `seeds/C18/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
- **RW_CM_NOTHIN** (paths run: RA+RB): Same defect; F06 expected rewritten to the observed label on both paths.
  - code seed `seeds/C18/RA_NOTHIN_RW__run_RA.R` → `R-A\run_RA.R`, SHA-256 `af36ec01b7298d9483425baca16c6e43f4ed6801dfffb06a4c9558b9956c9156`
  - code seed `seeds/C18/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
  - code seed `seeds/C18/RB_FX_F06_RW__40_fixtures.R` → `R-B\R\40_fixtures.R`, SHA-256 `7063ae8b452a95e87ed1f8236c8ff07522cae0c0c1bbaca168d2e9e502d4d0ec`
- **FX_CM_NODUP** (paths run: RA+RB): Both paths drop the DUPLICATE exclusion; fixtures as frozen.
  - code seed `seeds/C18/RA_NODUP__run_RA.R` → `R-A\run_RA.R`, SHA-256 `94aef54437d5be9536da5ee608e6ef24ba7b2c2f861b036afd652fdd1a0e1421`
  - code seed `seeds/C18/RB_NODUP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `4f1d8422f4dbe7fad83c5ad737a5bd36f4f50494dc6453f00e8761870f73ec69`
- **RW_CM_NODUP** (paths run: RA+RB): Same defect; F07 expected rewritten to the observed label on both paths.
  - code seed `seeds/C18/RA_NODUP_RW__run_RA.R` → `R-A\run_RA.R`, SHA-256 `3f12582247be727c312fa82d13acd060caa8fdb5067a729a9ed59c0adac99935`
  - code seed `seeds/C18/RB_NODUP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `4f1d8422f4dbe7fad83c5ad737a5bd36f4f50494dc6453f00e8761870f73ec69`
  - code seed `seeds/C18/RB_FX_F07_RW__40_fixtures.R` → `R-B\R\40_fixtures.R`, SHA-256 `ef23dc09e0c2d897cb9d38f86acbb0fa79e89bc20955d2028d24bdac8bd738eb`
- **FX_CM_NOI01** (paths run: RA+RB): Both paths drop the I01 open+closed-date clause; fixtures as frozen.
  - code seed `seeds/C18/RA_NOI01__run_RA.R` → `R-A\run_RA.R`, SHA-256 `496bbd80dbdf034160eab47a86b33f1ec6b3e0f565856f20010fb08253116769`
  - code seed `seeds/C18/RB_NOI01__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `e6974fff186c13dae13386cb9ebc19b375362070783b316d02b4a903f0443f6d`
- **RW_CM_NOI01** (paths run: RA+RB): Same defect; F04 expected rewritten to the observed label on both paths.
  - code seed `seeds/C18/RA_NOI01_RW__run_RA.R` → `R-A\run_RA.R`, SHA-256 `80ef8ebce22616f32b3ceaba40ae57672fe5e08598b75ff9982e5325134dbe27`
  - code seed `seeds/C18/RB_NOI01__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `e6974fff186c13dae13386cb9ebc19b375362070783b316d02b4a903f0443f6d`
  - code seed `seeds/C18/RB_FX_F04_RW__40_fixtures.R` → `R-B\R\40_fixtures.R`, SHA-256 `2cfb8cdceb8862becd2794491854aebab72e24db0d97f9d4ab76516dfbe39f83`
- **FX_RB_NOTHIN** (paths run: RB): R-B alone drops the I04 thin-peer clause; fixtures as frozen.
  - code seed `seeds/C18/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
- **RW_RB_NOTHIN** (paths run: RB): Same R-B defect; R-B's F06 expected rewritten to the observed label.
  - code seed `seeds/C18/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
  - code seed `seeds/C18/RB_FX_F06_RW__40_fixtures.R` → `R-B\R\40_fixtures.R`, SHA-256 `7063ae8b452a95e87ed1f8236c8ff07522cae0c0c1bbaca168d2e9e502d4d0ec`

## Operational benefit predicate P1
Owner threshold: "Pass: No hidden changes needed to pass fixtures. Fail: Changing fixtures was required (keep rule)."
- **H_RW:** RW_ arms whose output differs from arm B on any locked field. **D_abl:** RW_ arms caught without the control.
- **P1 satisfied:** H_RW ⊆ D_abl. **P1 failed:** H_RW \ D_abl is non-empty: a defect that changes a locked output field passes once its fixture is rewritten.
FX_ arms show what the frozen fixtures catch with the control. Arms with no locked-field change do not count for or against P1.

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
