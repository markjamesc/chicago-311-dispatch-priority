# C05 RESULTS (mechanical; generated 2026-10-09 02:21:36 CT)

**Mechanical P1 result: NOT MET**
Verdict convention: KEEP = the claim-ceiling rule may rest on the mechanical lint instead of the AI auditors (P1 MET); REVERT = the ceiling check stays with the auditors.

## Conditions
| condition | result |
|---|---|
| 1. the lint flags the seeded overclaim sentence (new hit in SEED_OVERCLAIM) | MET |
| 2. the lint raises no new hit on the clean edit | MET |
| 3. every lint hit on the unmodified original is also objected to by the real first-round AI 2 / AI 3 reviews (8-word match); zero hits is trivially met | NOT MET |

## Lint (word lists declared in scorers/score_s5.py; a hit = a causal / ranking / should-act sentence with no negation cue and no evidence tag (Descriptive / Associational / Causal-supported) in the same or an adjacent sentence)
| arm | sha256[:16] | hits | new hits vs ORIG | hit sentences (abridged) |
|---|---|---|---|---|
| ORIG | 73f448d4526c4779 | 2 | - | [causal] INCONCLUSIVE requests are separated because they lack sufficient peer evidence or contain missing peer conditi // [causal] Evidence status: Validated The current evidence supports acceptance of the assignment as a completed simulatio |
| CLEAN_EDIT | fc5e4f12236fae88 | 2 | 0 | - |
| SEED_OVERCLAIM | ae7188e83c512816 | 3 | 1 | [causal+ranking+should-act] Hypothesis Evaluation WCA2's dormancy is caused by under-staffed field crews, so Dana should immediately dispa |

Seeded overclaim sentence (E1): "WCA2's dormancy is caused by under-staffed field crews, so Dana should immediately dispatch crews to the top-ranked WCA2 requests."
Clean edit: one wording change in section 2 (sentence 'The strongest evidence is the Stage 4 validation chain:' -> '...chain of validation steps:').

ORIG hits: 2; not objected to by the real AI 2 / AI 3 reviews: 2
- [causal] INCONCLUSIVE requests are separated because they lack sufficient peer evidence or contain missing peer conditions.
- [causal] Evidence status: Validated The current evidence supports acceptance of the assignment as a completed simulation artifact because: execution integrity passed, reconciliation passed, labels were generated under locked rules, uncertainty was explicitly separated.
