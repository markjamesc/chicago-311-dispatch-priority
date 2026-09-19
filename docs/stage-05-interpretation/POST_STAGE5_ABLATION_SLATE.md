# Post–Stage 5 Ablation Slate — Chicago 311 / Method B

**Status:** BATCH A01–A08 COMPLETE (2026-09-19 CT)  
**Band:** 8 (A01–A08)  
**Deferred:** A09–A10  
**Protocol:** Builder / Validator / Adjudicator → KEEP / REVERT / HALT  
**Rule:** Ablations update canonical Stage 3/4 frameworks in `ai-augmented-analyst-workflow`; they do **not** rewrite the frozen Chicago 311 Stage 4 pack.  
**Batch result:** **0 KEEP · 7 REVERT · 1 HALT** → **no Stage 3/4 framework edits.**

| ID | Control to ablate | Failure mode / bloat question | Terminal |
|----|-------------------|-------------------------------|----------|
| A01 | Dual-path independence (no shared judged code) | Would a shared helper have silently coupled R-A/R-B? | **REVERT** |
| A02 | Known-case Fixture Gate before builders | Would skipping fixtures have shipped the clock bug unnoticed longer? | **HALT** (Fixture Gate remains) |
| A03 | SQL nonjudgment bright line | Did SQL stay label-free under pressure? | **REVERT** |
| A04 | SQL Source Gate vs raw | Is Source Gate earning its keep vs trusting extract? | **REVERT** |
| A05 | Single owner knob only (κ) | Did extra “constants” act as hidden knobs? | **REVERT** |
| A06 | Integrity-gate INCONCLUSIVE (vs soft residual) | Soft residual vs hard INCONCLUSIVE — which fails safer? | **REVERT** |
| A07 | TCD-IG vs raw age construct | Would open_age_days≥14 have answered CQ-F02 better/worse? | **REVERT** |
| A08 | Exact recon critical-field set | Too many / too few recon fields? | **REVERT** |
| A09 | Capacity/ranking Framing-only | 59% ESCALATE — was Framing-only the right deferral? | **DEFERRED** |
| A10 | ML Mode None/A/B declaration | Even Mode None — does blank mode create later confusion? | **DEFERRED** |

See [BATCH_A01_A08_SCORECARD.md](BATCH_A01_A08_SCORECARD.md).
