# C14 — Ablation specification (FROZEN)

**Ablation ID:** C14 (owner Remaining Ablation Program, catalog #14 "Explicit Semantics (Open/Elig.)")
**Batch:** N15 batch 2 of 3 (controls C14, C11, C34, C16, C18)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`; `R-B/R/40_fixtures.R` `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 3→4 (meaning of open, eligible, duplicate, legacy)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
The semantic definitions of "open", "eligibility", "duplicates" and "legacy" are locked in the Stage-3 design (`MEASUREMENT_DESIGN_LOCKED.md` §3, §5). Both builders implement the locked definitions.

## Exact change being tested (ablation)
The definitions are not locked. Each builder applies its own plausible plain-language reading. Each seeded reading below is either named as an alternative in the design text, or follows from the unlocked term. A reading can be taken by one builder (single path) or by both (shared reading).
**Caught without the control (D_abl):** crash, recon key/label mismatch (n_only_ra + n_only_rb + n_disagree > 0), or a fixture failure on any path.
With the control, the locked definition is applied on both paths, which is arm B by construction.
Disclosure: the frozen fixtures encode the locked definitions (F07 duplicate out of set, F08 legacy out of set). They are kept in every arm.

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. As a result, arm B's full-field recon (R-A vs R-B) shows dormant_h 1 and open_age_h 2 in every control. These mismatches are present in the frozen pack itself. The HALT rule "B recon 0/0/0" uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h.

## Data profile used to choose seeds (frozen source, read-only, computed before the specs were frozen)
STATUS = "Open" on all 245,193 rows. DUPLICATE: false 222,176 / true 23,017. LEGACY_RECORD: false 245,014 / true 179. PARENT_SR_NUMBER non-blank: 23,014. CLOSED_DATE non-blank: 0. Blank type_key: 0. Unparseable created/mod: 0. mod < created: 0. created > T: 0. Open rows by peer_n: no peer stats 6,443; 1–29: 27; 30–49: 35; 50–74: 14; 75–99: 19; ≥100: 238,655.

## Seeded readings (frozen before execution)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b2.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b2.txt`. No source variants are used in batch 2.
- **SEM_DUPKEEP_RB** (paths run: RB): R-B alone reads 'duplicate' as 'keep and hold INCONCLUSIVE' (the F07 alternative named in the design).
  - code seed `seeds/C14/RB_SEM_DUPKEEP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `3fed6c826f3ac091eb7f6b7a087208a70c0edaad60cf0f753a0191768c63af48`
- **SEM_DUPKEEP_CM** (paths run: RA+RB): Both paths read 'duplicate' as 'keep and hold INCONCLUSIVE'.
  - code seed `seeds/C14/RA_SEM_DUPKEEP__run_RA.R` → `R-A\run_RA.R`, SHA-256 `382cdc1ec4dd929b81e352310efce823e0e0542513f70c3196df4a9dbcb2ed2c`
  - code seed `seeds/C14/RB_SEM_DUPKEEP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `3fed6c826f3ac091eb7f6b7a087208a70c0edaad60cf0f753a0191768c63af48`
- **SEM_NOPEER_RB** (paths run: RB): R-B alone reads 'eligible' as 'has peer statistics' (rows with no peer stats excluded, not INCONCLUSIVE).
  - code seed `seeds/C14/RB_SEM_NOPEER__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `22a595002896081a1bb23f2214317bcf2b3c2fdb93f1ffe6f88a8cd38e3f5b4c`
- **SEM_NOPEER_CM** (paths run: RA+RB): Both paths read 'eligible' as 'has peer statistics'.
  - code seed `seeds/C14/RA_SEM_NOPEER__run_RA.R` → `R-A\run_RA.R`, SHA-256 `6e3284064f415877466806e4f1ee9ddabc0f33cf41a1b6da1ae6476ab6085237`
  - code seed `seeds/C14/RB_SEM_NOPEER__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `22a595002896081a1bb23f2214317bcf2b3c2fdb93f1ffe6f88a8cd38e3f5b4c`
- **SEM_LEGACYIN_CM** (paths run: RA+RB): Both paths read LEGACY_RECORD rows as eligible (no legacy exclusion).
  - code seed `seeds/C14/RA_SEM_LEGACYIN__run_RA.R` → `R-A\run_RA.R`, SHA-256 `63fd48501746154fa467b19b3ea6aa9007a29d976303429a68cd535ea02950c0`
  - code seed `seeds/C14/RB_SEM_LEGACYIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `9c624554e023cff2b64e12a5bfff3d41e6818f1a4d5f81fe296cff69b6630bd3`
- **SEM_OPENEXACT_CM** (paths run: RA+RB): Both paths read 'open' as the exact token STATUS == "Open" (no case/space normalization).
  - code seed `seeds/C14/RA_SEM_OPENEXACT__run_RA.R` → `R-A\run_RA.R`, SHA-256 `a16dc9b879faa4efc1f083c06f80658f05d16bcdaa229a17d5be85553d6a1261`
  - code seed `seeds/C14/RB_SEM_OPENEXACT__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `0619a1990ae6d4725c565f4e661b31e8984c068abd41638e8a195d8fc0c6edee`
## Operational benefit predicate P1
Owner threshold: "Pass: No semantic ambiguity arises without lock. Fail: Differing interpretations occur (keep rule)."
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1. A single-path reading that recon catches still needs a ruling on the meaning before the outputs can be trusted. This test does not score that ruling.

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
