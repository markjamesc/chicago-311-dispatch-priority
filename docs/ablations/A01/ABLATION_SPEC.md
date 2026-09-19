# A01 — Ablation specification (FROZEN)

**Ablation ID:** A01  
**Constitution version:** 1.0  
**Baseline frameworks:**  
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`  
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`  
**Role assignment (canonical rotation):** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok  
**Target stage(s):** Stage 4 (primary); Stage 3 only if independence lock text lives there  
**Frozen at CT:** 2026-09-19 ~14:46

## Exact change being tested

**Proposed canonical change:** Weaken Method B Stage 4 so independent R-A/R-B may share judged helper modules / a common judged library (dual-path independence no longer mandatory for judged labels).

**Surfaces expected to change if KEEP:** Stage 4 validation framework sections on R-A/R-B independence and “no shared judged helpers.”

**Expected unchanged surfaces:** Stage 1/2; Chicago 311 frozen Stage 4 pack (never rewritten); fixture expected labels F01–F14; κ/T_freeze locks.

## Named evidence / fixture suite

Chicago 311 Dataset 2 frozen evidence (post clock-parse fix):
- Exact recon: 222002/222002 agree after fix; earlier run 104 STANDARD↔ESCALATE disagrees
- Fixtures: 14/14 both paths (fixtures-v1-tcd-ig)
- Validation Gate PASS; workflow gate PASS
- Structural cross-review notes tz/force_tz asymmetry between independent paths

## Critical reconciliation fields (hard mechanical)

From stage3-v1-tcd-ig: SR_NUMBER, classification/action agreement counts:
- n_decision, n_agree, n_disagree, n_only_ra, n_only_rb
- Portfolio ESCALATE/INCONCLUSIVE/STANDARD at κ=2

## Allowed source/data scope

Read-only use of frozen Chicago artifacts under `/workspace/chicago-311-dispatch-priority` and `/workspace/chicago-311-run`. No new MySQL extract. No rewrite of frozen labels.

## Operational benefit predicate (predeclared)

**P1:** If dual-path independence were dropped (shared judged helpers allowed), the framework would still have caught the production 104-row near-threshold ESCALATE/STANDARD disagreement (or an equivalent seeded path-asymmetry defect) with equal or better detection coverage, while reducing duplicated judged implementation cost.

Benefit is **satisfied** only if evidence shows detection coverage is preserved without dual-path.  
Benefit is **failed** if evidence shows dual-path (or independent parse implementations) was necessary to surface the 104-row defect.

## Regression rules

- Must not authorize rewriting Chicago frozen pack.
- Must not remove Fixture Gate or exact recon requirements in the same ablation (those are A02/A08).
- Undeclared semantic change to ESCALATE/INCONCLUSIVE/STANDARD definitions → REVERT.

## Builder task

Using only frozen evidence + baseline Stage 4 text, produce an evidence pack arguing what happens under the proposed weakening. Include mechanical facts from recon/fixture files (raw numbers). Do **not** output KEEP/REVERT/HALT.

## Validator task

Independently recompute the same hard mechanical facts from frozen artifacts; list blocking objections to the proposed weakening. Do **not** see Builder pack before first pass. Do **not** output KEEP/REVERT/HALT.
