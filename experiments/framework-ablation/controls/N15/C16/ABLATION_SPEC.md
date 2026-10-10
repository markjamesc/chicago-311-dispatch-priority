# C16 — Ablation specification (FROZEN)

**Ablation ID:** C16 (owner Remaining Ablation Program, catalog #16 "Spec→Builder Packet Complete")
**Batch:** N15 batch 2 of 3 (controls C14, C11, C34, C16, C18)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`; `R-B/R/40_fixtures.R` `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 3→4 (translation of locked rules into builder requirements)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Every Stage-3 rule is translated into an explicit implementation requirement in the builder packet.

## Exact change being tested (ablation)
A locked rule is missing from the builder packet, so the builder does not implement it. Both builders receive the same packet, so an omission is common-mode by default. One arm omits the rule from R-B's packet only.
**Caught without the control (D_abl):** crash, recon key/label mismatch (n_only_ra + n_only_rb + n_disagree > 0), or a fixture failure on any path.
With the control, the packet is complete, which is arm B by construction.
Disclosure: `SPEC_TO_BUILDER_PACKET.md` in the frozen pack is the v0.1-PENDING version. It is not used here. Each seed removes one locked §3/§5 rule from code that otherwise follows the LOCKED design.

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. As a result, arm B's full-field recon (R-A vs R-B) shows dormant_h 1 and open_age_h 2 in every control. These mismatches are present in the frozen pack itself. The HALT rule "B recon 0/0/0" uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h.

## Data profile used to choose seeds (frozen source, read-only, computed before the specs were frozen)
STATUS = "Open" on all 245,193 rows. DUPLICATE: false 222,176 / true 23,017. LEGACY_RECORD: false 245,014 / true 179. PARENT_SR_NUMBER non-blank: 23,014. CLOSED_DATE non-blank: 0. Blank type_key: 0. Unparseable created/mod: 0. mod < created: 0. created > T: 0. Open rows by peer_n: no peer stats 6,443; 1–29: 27; 30–49: 35; 50–74: 14; 75–99: 19; ≥100: 238,655.

## Seeded omissions (frozen before execution)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b2.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b2.txt`. No source variants are used in batch 2.
- **OM_LEGACY_CM** (paths run: RA+RB): LEGACY exclusion omitted from the builder packet: both paths lack it.
  - code seed `seeds/C16/RA_OM_LEGACY__run_RA.R` → `R-A\run_RA.R`, SHA-256 `3e676987b2410ed2a9baa6d81742a68eace6e31b341b5f3302f7c5286ccbbab4`
  - code seed `seeds/C16/RB_OM_LEGACY__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `63658d64ea981ebdca41e5bda89d5ad11c6b9f6d23dd6aee5ef79eac43e40c6d`
- **OM_LEGACY_RB** (paths run: RB): LEGACY exclusion omitted from R-B's packet only.
  - code seed `seeds/C16/RB_OM_LEGACY__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `63658d64ea981ebdca41e5bda89d5ad11c6b9f6d23dd6aee5ef79eac43e40c6d`
- **OM_CLOCKS_CM** (paths run: RA+RB): Clock-order (mod < created) and created > T clauses omitted: both paths lack them.
  - code seed `seeds/C16/RA_OM_CLOCKS__run_RA.R` → `R-A\run_RA.R`, SHA-256 `0dd8eb4443b2d6e324d8581ee159d94b0d8d911795de68ac2a8a5aea6f3aba0a`
  - code seed `seeds/C16/RB_OM_CLOCKS__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `c5c52ab683ea31a85aeee67e518241a5c4b309ea663f3cc1640f488838e50b41`
- **OM_BLANKTYPE_CM** (paths run: RA+RB): Blank type_key clause omitted: both paths lack it.
  - code seed `seeds/C16/RA_OM_BLANKTYPE__run_RA.R` → `R-A\run_RA.R`, SHA-256 `98d3205e4cd510100c915500c574d6d959893cdfe3d3de59911121f7388e24fa`
  - code seed `seeds/C16/RB_OM_BLANKTYPE__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `f1189e7804dec4e9bb2419e6e68a64ad0170419d373e5081a6ac74e4bc764475`
- **OM_UNPARSE_CM** (paths run: RA+RB): Unparseable CREATED_DATE clause omitted: both paths lack it.
  - code seed `seeds/C16/RA_OM_UNPARSE__run_RA.R` → `R-A\run_RA.R`, SHA-256 `ff207de79fdc0e306b6748290c6cf3f4f99b01e84069763b1c6f7ad5f0461b1f`
  - code seed `seeds/C16/RB_OM_UNPARSE__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `89ee3837833e6910dc38c7d7c78bbf2707b783ebbc2a5657924246b6f6c4b3a1`
## Operational benefit predicate P1
Owner threshold: "Pass: Translating automatically preserved outputs. Fail: Missing rules cause divergence (keep rule)."
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1.

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
