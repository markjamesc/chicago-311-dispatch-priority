# C26 — Ablation specification (FROZEN)

**Ablation ID:** C26 (owner Remaining Ablation Program, catalog #26 "Frozen Source Package")
**Batch:** N15 batch 1 of 3 (controls C26, C31, C39, C30, C29)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
Frozen code: `R-A/run_RA.R` `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`; `R-B/R/00_config.R` `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`; `R-B/R/20_integrity_and_classify.R` `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 (source identity of the two execution paths)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Both R-A and R-B must use the identical verified source. Before either path runs, the SHA-256 of `src_open_candidates.csv` and `src_peer_stats.csv` is checked against the frozen record.

## Exact change being tested (ablation)
There is no source checksum check. R-B may read a source copy that differs from R-A's. R-B is trusted if it exits 0, its fixtures pass, and exact recon against R-A (key set + classification, the frozen recon) is clean.
**Caught without the control (D_abl):** crash, recon key/label mismatch (n_only_ra + n_only_rb + n_disagree > 0), or a fixture failure on any path.
**Caught with the control:** the above, or any source-file SHA-256 that differs from the frozen source.

## Seeded divergences (frozen before execution; R-B reads the variant, R-A reads the frozen source)
A clean arm B (frozen R-A + frozen R-B, frozen source) is the truth reference. In a seeded arm, a path that is not run is taken from arm B.
**Locked fields** compared against arm B: SR_NUMBER key set, classification, dormant_h, open_age_h (|d| > 1e-6 counts as a change).
**Harm set H:** seeded arms whose output differs from arm B on any locked field, on any path.
Seed files and SHA-256 are in `runner/SEEDS_b1.sha256`. Code diffs vs the frozen code are in `runner/SEED_DIFFS_b1.txt`. Source variants are built deterministically on the PC by `runner/source_variants.R`, which stops unless an identity rebuild reproduces the frozen SHA-256. Their hashes are in `_variants/VARIANTS.tsv`.
- **S_STALE24** (paths run: RB): R-B reads a stale snapshot: rows with created_ts >= 2026-09-11 23:59:59 removed.
  - source variant `V_STALE24/src_open_candidates.csv` SHA-256 `8268fb549b3a2def31922f8ae4d0e204b8edcc697ee7b858fc74edfbbe800e58`, 118267409 bytes
  - source variant `V_STALE24/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: rows dropped: 848 (created_ts >= 2026-09-11 23:59:59)
- **S_PEER10** (paths run: RB): R-B reads peer stats with peer_p75_h of the most frequent open type_key x1.10.
  - source variant `V_PEER10/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`, 118671837 bytes (unchanged, equals the frozen file)
  - source variant `V_PEER10/src_peer_stats.csv` SHA-256 `573b41327866314392c72176162c93d8d27b1cf4ae7f77c1b84baa1f13aa69b8`, 16276 bytes
  - variant note: type_key WCA2: peer_p75_h 2250 -> 2475 (n in-set rows of this type: 72732)
- **S_ONEROW** (paths run: RB): R-B source: one in-set row's mod_ts/LAST_MODIFIED_DATE moved 30 days earlier.
  - source variant `V_ONEROW/src_open_candidates.csv` SHA-256 `64b660283b781bc9c6057220df5b09be53a9bd330e6761573cc48a3a000b93df`, 118671837 bytes
  - source variant `V_ONEROW/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: SR_NUMBER SR18-00191995: mod_ts 2020-02-13 17:43:49.000000 -> 2020-01-14 17:43:49.000000; LAST_MODIFIED_DATE 02/13/2020 05:43:49 PM -> 01/14/2020 05:43:49 PM
- **S_LF** (paths run: RB): R-B source re-saved with LF line endings (bytes differ, content identical).
  - source variant `V_LF/src_open_candidates.csv` SHA-256 `37f6de07df7324c790150986bc397348086b10619a3ce12d1e81bbdbcf13c7d0`, 118426643 bytes
  - source variant `V_LF/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: line endings CRLF -> LF; content identical
- **S_REVERSE** (paths run: RB): R-B source with data rows in reverse order (bytes differ, same rows).
  - source variant `V_REVERSE/src_open_candidates.csv` SHA-256 `a441b14eb120c50c64df4cd92dc4769c6cd799012689fbe478d8b649e6dce558`, 118671837 bytes
  - source variant `V_REVERSE/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: data rows reversed; same row set
- **S_BOOLCASE** (paths run: RB): R-B source with DUPLICATE/LEGACY_RECORD true/false written as TRUE/FALSE.
  - source variant `V_BOOLCASE/src_open_candidates.csv` SHA-256 `cf4ed65fe419eef300251e2fed955d246d839c8982de6d7a5858c5979bca041d`, 118671837 bytes
  - source variant `V_BOOLCASE/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 16276 bytes (unchanged, equals the frozen file)
  - variant note: DUPLICATE and LEGACY_RECORD values upper-cased (true/false -> TRUE/FALSE)
## Operational benefit predicate P1
Owner threshold: "Pass: Two sources were identical by default. Fail: Divergence detected when differing (keep rule)."
Definitions:
- **H:** harm set (above).
- **D_abl:** seeded arms caught without the control (definition above).
Outcomes:
- **P1 satisfied:** H ⊆ D_abl. Every seeded change that alters a locked output field is still caught without the control.
- **P1 failed:** H \ D_abl is non-empty. At least one change that alters a locked output field passes undetected without the control.
Arms with no locked-field change are reported. They do not count for or against P1. Byte-only variants (S_LF, S_REVERSE) show whether the checksum control raises alarms on content-identical copies.

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
