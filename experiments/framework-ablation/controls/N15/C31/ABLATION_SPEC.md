# C31 — Ablation specification (FROZEN)

**Ablation ID:** C31 (owner Remaining Ablation Program, catalog #31 "Lineage Attestation")
**Batch:** N15 batch 1 of 3 (controls C26, C31, C39, C30, C29)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (provenance of data and code versions)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Before outputs are trusted, the run attests explicit source/data version and snapshot identity: a manifest of the SHA-256 of every input (source files and code) is checked against the frozen record.

## Exact change being tested (ablation)
There is no lineage attestation. An undocumented change can reach both paths identically. Trust rests on exit 0, fixtures on both paths, and exact recon R-A vs R-B (key set + classification).
**Caught without the control (D_abl):** crash, recon key/label mismatch, or a fixture failure on any path.
**Caught with the control:** the above, or any input-file SHA-256 that differs from the frozen record.

## Seeded undocumented changes (frozen before execution; applied to both paths)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b1.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b1.txt`. Source variants are built deterministically on the PC by `runner/source_variants.R`, which stops unless an identity rebuild reproduces the frozen SHA-256. Their hashes are in `_variants/VARIANTS.tsv`.
- **L_STALE24** (paths run: RA+RB): Both paths read the stale snapshot (undocumented snapshot change).
  - source variant `V_STALE24/src_open_candidates.csv` SHA-256 `8268fb549b3a2def31922f8ae4d0e204b8edcc697ee7b858fc74edfbbe800e58`, 118267409 bytes
  - source variant `V_STALE24/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: rows dropped: 848 (created_ts >= 2026-09-11 23:59:59)
- **L_PEER10** (paths run: RA+RB): Both paths read the altered peer stats (undocumented).
  - source variant `V_PEER10/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`, 118671837 bytes (unchanged, equals the frozen file)
  - source variant `V_PEER10/src_peer_stats.csv` SHA-256 `573b41327866314392c72176162c93d8d27b1cf4ae7f77c1b84baa1f13aa69b8`, 16276 bytes
  - variant note: type_key WCA2: peer_p75_h 2250 -> 2475 (n in-set rows of this type: 72732)
- **L_TF24** (paths run: RA+RB): Both paths' T_freeze moved +24 h (undocumented config change).
  - code seed `seeds/C31/RA_TF24__run_RA.R` → `R-A\run_RA.R`, SHA-256 `4694d22d2bc81220bbb0326971e12782de5a88e5a9065291062c6f492e175bcd`
  - code seed `seeds/C31/RB_TF24__00_config.R` → `R-B\R\00_config.R`, SHA-256 `3484c86e27dbe704f8017bc76606ff7ec95dec97aa6d8768e2f485a8bfe03daf`
- **L_K25** (paths run: RA+RB): Both paths' kappa 2.0 -> 2.5 (undocumented knob change).
  - code seed `seeds/C31/RA_K25__run_RA.R` → `R-A\run_RA.R`, SHA-256 `7b3e23dc17b242353b552febde9c7fbd4447fd200ac5d0996e25435a18a44051`
  - code seed `seeds/C31/RB_K25__00_config.R` → `R-B\R\00_config.R`, SHA-256 `401d894c5cac7d6ae226758ba9bf0303f3e404a382796ffa89197505934a5c90`
- **L_COMMENT** (paths run: RA+RB): Comment-only edit in both paths (bytes differ, no semantic change).
  - code seed `seeds/C31/RA_COMMENT__run_RA.R` → `R-A\run_RA.R`, SHA-256 `51a47bd1c613d8570f2a8f52436b5b7580a40cc924fe89ccb15a980baad80be9`
  - code seed `seeds/C31/RB_COMMENT__00_config.R` → `R-B\R\00_config.R`, SHA-256 `bdf1f3cb821d3ed8798e6698b59be2094681f0632637f4fff68d0260a150a5e2`
## Operational benefit predicate P1
Owner threshold: "Pass: No ambiguity in data/code versions. Fail: Undocumented changes found (keep rule)."
Definitions:
- **H:** harm set (above).
- **D_abl:** seeded arms caught without the control (definition above).
Outcomes:
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1. L_COMMENT (comment-only) shows whether attestation alarms on a benign change.

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
