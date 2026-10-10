# C29 — Ablation specification (FROZEN)

**Ablation ID:** C29 (owner Remaining Ablation Program, catalog #29 "Reconciliation Investigation")
**Batch:** N15 batch 1 of 3 (controls C26, C31, C39, C30, C29)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (handling of R-A/R-B mismatches)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
If R-A and R-B mismatch, the mismatch must be investigated and the path rerun with the defect removed. No averaging and no copying of IDs or labels from one side.

## Exact change being tested (ablation)
A mismatch is auto-resolved by a shortcut rule, with no investigation and no rerun. The owner doc names no specific shortcut, so three rules are frozen here:
- **copy_RA:** take R-A's key set and labels.
- **copy_RB:** take R-B's key set and labels.
- **max_severity:** union of keys. On shared keys take the more severe label (ESCALATE > INCONCLUSIVE > STANDARD), the conservative ordinal stand-in for averaging.
**With the control:** investigation and rerun on frozen code reproduces arm B, by construction. The seeded defect is the only difference from arm B.

## Seeded mismatch scenarios (frozen before execution; one defective path, the other = arm B)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b1.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b1.txt`. Source variants are built deterministically on the PC by `runner/source_variants.R`, which stops unless an identity rebuild reproduces the frozen SHA-256. Their hashes are in `_variants/VARIANTS.tsv`.
- **X_RB_NODUP** (paths run: RB): Mismatch from an R-B defect: DUPLICATE exclusion dropped (extra R-B keys).
  - code seed `seeds/C29/RB_NODUP__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `4f1d8422f4dbe7fad83c5ad737a5bd36f4f50494dc6453f00e8761870f73ec69`
- **X_RA_NODUP** (paths run: RA): Mismatch from an R-A defect: DUPLICATE exclusion dropped (extra R-A keys).
  - code seed `seeds/C29/RA_NODUP__run_RA.R` → `R-A\run_RA.R`, SHA-256 `94aef54437d5be9536da5ee608e6ef24ba7b2c2f861b036afd652fdd1a0e1421`
- **X_RB_NOTHIN** (paths run: RB): Mismatch from an R-B defect: I04 thin-peer clause dropped (label disagreements).
  - code seed `seeds/C29/RB_NOTHIN__20_integrity_and_classify.R` → `R-B\R\20_integrity_and_classify.R`, SHA-256 `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`
- **X_RA_NOTHIN** (paths run: RA): Mismatch from an R-A defect: I04 thin-peer clause dropped (label disagreements).
  - code seed `seeds/C29/RA_NOTHIN__run_RA.R` → `R-A\run_RA.R`, SHA-256 `65e90bf81cb2f573f744636947175fb3531b9053d76ee90fed1b003212c1f98b`

## Operational benefit predicate P1
Owner threshold: "Pass: Automatically resolving mismatch yields no difference. Fail: Unresolved mismatch or improper shortcut (keep rule)."
Outcomes:
- **P1 satisfied:** every scenario × rule resolution (4 × 3 = 12) equals arm B (R-A labels; key set and classification).
- **P1 failed:** at least one resolution differs from arm B.
The harm set H and the arms caught without the control are also reported, for context.

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
