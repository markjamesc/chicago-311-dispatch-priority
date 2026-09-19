# A07 — Ablation specification (FROZEN)

**Ablation ID:** A07  
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok  
**Target:** Stage 3 measurement / Stage 4 age implementation  
**Constitution:** 1.0  
**Frozen at CT:** 2026-09-19

## Exact change being tested

**Proposed change:** Use raw open age instead of the TCD-IG age construction: compute `open_age_days`/`open_age_h` directly from `T_freeze - CREATED_DATE` and remove the type-conditional dormancy construction from the age metric, or simplify the age metric only if the simplification is mechanically equivalent and explicitly documented. This is a counterfactual analysis; do not rewrite the locked Chicago 311 Stage 4 pack.

## Benefit predicate P1

Raw open age (or an equivalent simpler age metric) improves interpretability and reduces construction complexity without materially changing Stage 4 PASS status or locked fixture semantics.

P1 **fails** if TCD-IG age was necessary for the locked Design Gate metric (`open_age_days >= 14` with `T_freeze`), for the TCD-IG decision construct, or for the locked fixture expecteds (including F03 → STANDARD).

## Frozen surfaces and regression rules

- Locked baseline: `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, `T_freeze=2026-09-12 23:59:59 America/Chicago`, κ=2.
- Expected unchanged surfaces: SQL nonjudgment boundary, integrity-first ordering, exact recon controls, SR_NUMBER grain, fixture IDs/expecteds, and the frozen Chicago 311 Stage 4 pack.
- Any semantic change to ESCALATE / INCONCLUSIVE / STANDARD not declared by this ablation is a regression.
- Do not treat age as a City SLA or dispatch order; capacity/ranking remains out of scope.

## Critical age and reconciliation checks

- `T_freeze` and timezone treatment; raw `CREATED_DATE` parse success and `created_ts <= T_freeze`.
- Locked age/dormancy fields and thresholds relevant to the candidate, including F03 and the `open_age_days >= 14` Design Gate check.
- Exact recon fields: SR_NUMBER set, n_decision, n_inner, n_only_ra, n_only_rb, n_agree, n_disagree, classification/action labels, integrity clauses, and portfolio counts.

## Allowed evidence scope

Read-only use of frozen artifacts under `/workspace/chicago-311-run` and `/workspace/chicago-311-dispatch-priority`. No new extract, no browser AI, and no rewrite of locked labels or fixtures.

## Adjudicator note

RAW MANIFEST present → do not HALT for missing historical R stdout; REVERT when P1 fails.

## Builder task

Make an independent first pass from this frozen packet. Describe the conceptual diff, hard facts, age/fixture implications, unchanged surfaces, risks, and claim→evidence map. Withhold any KEEP/REVERT/HALT decision.

## Validator task

The Validator independently recomputes the same hard facts after the Builder first pass remains blind. Withhold any KEEP/REVERT/HALT decision.
