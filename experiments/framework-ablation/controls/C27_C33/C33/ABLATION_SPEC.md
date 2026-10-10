# C33 — Ablation specification (FROZEN)

**Ablation ID:** C33 (owner Remaining Ablation Program, catalog #33 "Naive Clock Contract")
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58` (104 types).
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 03:32 CT)
**Target stage:** Stage 4 (export clock contract)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Naive SQL export clocks (`created_ts`, `mod_ts`, `closed_ts`, `CREATED_DATE`, `LAST_MODIFIED_DATE`, `CLOSED_DATE`) must be read as character and parsed as America/Chicago wall time. No readr POSIXct shortcut, no `force_tz`.

## Exact change being tested (ablation)
Remove the contract. Each R path parses the naive clocks however its builder chose. Three arms run on identical frozen inputs:
- **B (contract ON):** frozen R-A + frozen R-B. This is the truth reference and the reproduction check against the frozen pack.
- **X1 (contract OFF on R-B):** frozen R-A + the historical pre-contract R-B parser. This is `10_io_parse.R` SHA-256 `8df344f5…0c4866` from `R-B_bundle.tgz`, the code that ran at 12:56 CT on 2026-09-19. It is genuine pre-contract code, not a synthetic seed.
- **X2 (contract OFF on both):** R-A seeded with the same readr-POSIXct shortcut, plus the X1 R-B. Seed: `seeds/C33/X2_RA_run_RA.R` SHA-256 `65772bee…31f03`. Two edits are allowed: the clock col_types are reduced to `col_guess`, and the POSIXct branch of the parser keeps readr's instant. It tests a common-mode clock error.
Seed diffs are in `runner/SEED_DIFFS.txt`.

## Fixture suite
`fixtures-v1-tcd-ig`, F01–F14, run on every R execution, on both paths.

## Critical reconciliation fields (hard mechanical)
SR_NUMBER key set; n_ra, n_rb, n_inner, n_only_ra, n_only_rb, n_agree, n_disagree; row-level classification; portfolio ESCALATE/INCONCLUSIVE/STANDARD; plus `dormant_h` and `open_age_h` deltas against arm B.

## Allowed source/data scope
Frozen PC pack `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only and copied into the new work folder `...\ablation-runs\C27_C33`. No new MySQL extract (MySQL is used only for a read-only COUNT preflight). No rewrite of frozen labels.

## Expected unchanged surfaces
SQL extract and Source Gate; TCD-IG rules; κ; fixture expecteds; SR_NUMBER grain; the frozen Chicago 311 Stage 4 pack.

## Operational benefit predicate P1 (owner doc #33 thresholds, operationalized)
Owner doc thresholds: "Pass: No timezone misinterpretation occurred. Fail: Ambiguity in timing found (keep rule)."
- **P1 satisfied:** In X1 and X2, every ablated path's labels equal arm B's labels for all SR_NUMBERs (0 label flips), and no row has |Δdormant_h| > 1e-6 h.
- **P1 failed:** Any ablated path has ≥ 1 label flip or ≥ 1 row with a clock-derived shift.
Detection by recon and by fixtures in X1/X2 is reported as supporting evidence. It is not the predicate.

## Regression / HALT rules
- HALT if arm B does not reproduce the frozen pack: label diffs ≠ 0 or only-rows ≠ 0 vs frozen RA/RB classifications, or recon n_disagree ≠ 0.
- HALT if any run is missing or exits non-zero, or if Builder and Validator disagree on any hard number in `C33_RESULTS.md`.
- Byte-hash equality of the outputs with the 2026-09-19 run is INFO only. R 4.6.1 vs the original 4.5.1 may change formatting; label-level equality is the gate.
- RAW evidence present (runner logs, manifests, CSVs) → do not HALT for missing historical stdout. If P1 fails and no HALT condition holds → REVERT.

## Builder task
Make an independent first pass from the frozen packet: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
