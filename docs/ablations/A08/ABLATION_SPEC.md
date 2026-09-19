# A08 — Ablation specification (FROZEN)

**Ablation ID:** A08  
**Roles:** Builder=DeepSeek · Validator=Grok · Adjudicator=ChatGPT  
**Target:** Stage 4 exact reconciliation / critical field set  
**Constitution:** 1.0  
**Frozen at CT:** 2026-09-19

## Exact change being tested

**Proposed change:** Shrink or loosen the critical reconciliation field list: replace the full exact SR_NUMBER-level and decision-field recon with a reduced/loosened check based only on aggregate decision counts and a smaller label summary. This is a counterfactual analysis; do not rewrite the locked Chicago 311 Stage 4 pack.

The full locked check includes the SR_NUMBER set and row-level decision agreement (`n_inner`, `n_only_ra`, `n_only_rb`, `n_agree`, `n_disagree`), classification/action labels, integrity clauses, age/dormancy and peer fields used to explain decisions, plus portfolio counts. The candidate reduction must state exactly which fields are removed or relaxed.

## Benefit predicate P1

A shorter or looser recon is faster/cheaper while still detecting material path defects and semantic disagreements.

P1 **fails** if the full critical list was necessary to catch the production 104-row clock-skew incident or the resulting label disagreements, including the 104 `STANDARD` (R-A) versus `ESCALATE` (R-B) rows.

## Frozen surfaces and regression rules

- Locked baseline: `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, `T_freeze=2026-09-12 23:59:59 America/Chicago`, κ=2.
- Expected unchanged surfaces: SQL nonjudgment boundary, TCD-IG rules, exact fixture expecteds, SR_NUMBER grain, and the frozen Chicago 311 Stage 4 pack.
- Any undeclared semantic change, missed row-set disagreement, missed label disagreement, or fixture/recon regression is a failure of the candidate.
- Do not replace exact recon with a majority vote or aggregate-only assertion without documenting the lost detection coverage.

## Critical reconciliation fields and checks

Full locked list: SR_NUMBER key-set equality; n_decision; n_inner; n_only_ra; n_only_rb; n_agree; n_disagree; row-level classification/action labels; integrity clauses; `dormant_h`, `open_age_h`, `peer_n`, and `peer_p75_h` where present for diagnosis; and portfolio counts for ESCALATE/INCONCLUSIVE/STANDARD. Also check the fixture IDs and expected/observed results for both paths.

## Allowed evidence scope

Read-only use of frozen artifacts under `/workspace/chicago-311-run` and `/workspace/chicago-311-dispatch-priority`. No new extract, no browser AI, and no rewrite of locked labels or fixtures.

## Adjudicator note

RAW MANIFEST present → do not HALT for missing historical R stdout; REVERT when P1 fails.

## Builder task

Make an independent first pass from this frozen packet. Describe the conceptual recon diff, hard facts, what the reduced list would and would not detect, fixture implications, unchanged surfaces, risks, and claim→evidence map. Withhold any KEEP/REVERT/HALT decision.

## Validator task

The Validator independently recomputes the same hard facts after the Builder first pass remains blind. Withhold any KEEP/REVERT/HALT decision.
