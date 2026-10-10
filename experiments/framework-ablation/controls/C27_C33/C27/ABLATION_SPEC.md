# C27 — Ablation specification (FROZEN)

**Ablation ID:** C27 (owner Remaining Ablation Program, catalog #27 "Fixtures on Both Paths")
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 03:32 CT)
**Target stage:** Stage 4 (fixture execution before production is trusted)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Both R-A and R-B must pass all 14 locked fixtures before their production outputs are trusted.

## Exact change being tested (ablation)
Only R-A must pass fixtures. R-B's fixture result is ignored, and R-B production is trusted if exact recon against R-A is clean (n_only_ra = n_only_rb = n_disagree = 0) and the run exits 0.

## Seeded defects (frozen before execution)
There are 9 single-rule deletions in R-B `20_integrity_and_classify.R`, one per fixture-protected rule. They were chosen by rule coverage, not by production impact:
- M01 κ rule uses p50 instead of p75
- M02 I01 deleted
- M03 I02 mod<created deleted
- M04 I04 thin peer deleted
- M05 DUPLICATE exclusion deleted
- M06 LEGACY exclusion deleted
- M07 I05 parent deleted
- M08 not-Open exclusion deleted
- M09 I02 missing-CREATED deleted
Files and SHA-256 are in `runner/SEEDS.sha256`; diffs are in `runner/SEED_DIFFS.txt`. A clean arm B (frozen R-A + frozen R-B) is the reference. Each mutant R-B is run in full: fixtures plus production.

## Fixture suite
`fixtures-v1-tcd-ig`, F01–F14.

## Critical reconciliation fields (hard mechanical)
SR_NUMBER key set; n_ra, n_rb, n_inner, n_only_ra, n_only_rb, n_agree, n_disagree; row-level classification; per-mutant R-B fixture pass count and failed IDs; exit codes.

## Allowed source/data scope
Frozen PC pack, read only and copied into the new work folder `...\ablation-runs\C27_C33`. No new extract; MySQL is used only for a read-only COUNT preflight. No rewrite of frozen labels or fixtures.

## Expected unchanged surfaces
SQL/Source Gate; TCD-IG rules; fixture expecteds; R-A code; SR_NUMBER grain; the frozen Chicago 311 pack.

## Operational benefit predicate P1 (owner doc #27 thresholds, operationalized)
Owner doc thresholds: "Pass: All fixtures passed on both. Fail: A disparity or single-sided fix occurs (keep rule)."
Definitions:
- **D_fix:** mutants detected under the baseline regime (R-B fixtures < 14/14, or a crash).
- **D_abl:** mutants detected under the ablated regime (recon only/disagree > 0, or a crash).
Outcomes:
- **P1 satisfied:** D_fix ⊆ D_abl. Skipping the second path's fixtures loses no detection on this pack.
- **P1 failed:** D_fix \ D_abl is non-empty. At least one defect is visible only to the second path's fixtures, a single-sided disparity that the ablated regime would trust.
Mutants caught by neither regime are reported. They do not count for or against P1.

## Regression / HALT rules
- HALT if clean arm B does not reproduce the frozen pack: label diffs or only-rows ≠ 0 vs the frozen RA/RB classifications, recon not 0/0/0, or fixtures not 14/14 on both paths.
- HALT if any mutant run is missing, or if Builder and Validator disagree on a hard number in `C27_RESULTS.md`.
- Byte-hash equality with the 2026-09-19 outputs is INFO only (R 4.6.1 vs 4.5.1).
- RAW evidence present → do not HALT for missing historical stdout. If P1 fails and no HALT condition holds → REVERT.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
