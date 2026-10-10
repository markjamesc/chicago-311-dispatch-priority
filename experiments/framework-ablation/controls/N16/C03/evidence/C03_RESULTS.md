# C03 RESULTS (mechanical replay; generated 2026-10-09 02:21:35 CT)

**Mechanical P1 result: NOT MET**

Frozen inputs: AI1_DESIGN_A.md sha256 7e0e2c4c403e9871, AI2_DESIGN_B.md sha256 8153ad4fb16001c1, AI3_DATA_RISK_DOSSIER.md sha256 7f4fc3ee3995e2d2, CROSS_REVIEW.md sha256 9f3ea0a7f3e92ab4, MEASUREMENT_DESIGN_LOCKED.md sha256 7297cf3ef25bbf12, DESIGN_GATE_PACKAGE.md sha256 0ec361b591cc3373

## Conditions
| condition | result |
|---|---|
| 1. every design item 1-14 is decidable from the pre-review documents (none synthesis-only, none missing) | NOT MET |
| 2. every distinct design token of the locked design appears in at least one pre-review document (cross-review adds no design token) | MET |
| 3. the cross-review's section-4 list of material disagreements among the pre-review designs is empty (a gate before it would have approved one design without a reconciliation) | NOT MET |

## Design Gate checklist items 1-14: where each is first decidable (regex key terms, declared in scorers/score_c03.py; judgement items are for B/V/G)
| item | checklist text (abridged) | found in (A/B/D) | all key terms in pre-review union | key terms in CROSS_REVIEW | class |
|---|---|---|---|---|---|
| 1 | lock candidate = B-leaning hybrid (TCD-IG) | - | NO | yes | SYNTHESIS-ONLY |
| 2 | single knob kappa, default 2.0, grid 1/1.5/2/3 | B | yes | yes | pre-review |
| 3 | method constants W=365d, n_min=50 | B | yes | yes | pre-review |
| 4 | first-pass window = snapshot as-of T | ABD | yes | yes | pre-review |
| 5 | Open = locked Open-token list | ABD | yes | yes | pre-review |
| 6 | Open + parseable CLOSED_DATE -> INCONCLUSIVE | ABD | yes | yes | pre-review |
| 7 | exclude DUPLICATE / LEGACY_RECORD true-like; type_key; CREATED_DATE <= T | BD | yes | yes | pre-review |
| 8 | unresolved PARENT_SR_NUMBER -> INCONCLUSIVE | BD | yes | yes | pre-review |
| 9 | lock date-parse + timezone rule | D | yes | yes | pre-review |
| 10 | open_age_h diagnostic only | B | yes | yes | pre-review |
| 11 | peer P75 labelled empirical, not City SLA | B | yes | yes | pre-review |
| 12 | fixture outline F01-F14 (esp. F03) | B | yes | yes | pre-review |
| 13 | capacity/ranking out of Stage 3; excess ESCALATE returns to Framing | ABD | yes | yes | pre-review |
| 14 | SQL may emit peer aggregates; SQL must not emit labels | B | yes | yes | pre-review |

Items 15 (prior scratch MEASUREMENT_DESIGN = superseded) and 16 (accept Grok Auto for AI 2) are process items and exist only at the gate itself; not scored.

## Locked-design tokens (47 distinct): in Design A 7, in Design B 45
- tokens in the locked design that appear ONLY in CROSS_REVIEW (not in A, B or the dossier): 0: (none)
- tokens in the locked design that appear in no review document at all (introduced at lock): 0: (none)

## Cross-review section 4: 7 material disagreements between Design A and Design B (verbatim headings)
1. Primary evidence statistic — age/confidence (A) vs type-conditional dormancy (B).
2. Specificity of the single knob — vague confidence_threshold (A) vs operational κ (B).
3. INCONCLUSIVE as soft residual (A) vs hard integrity gate (B).
4. Eligibility surface — minimal fields (A) vs dup/legacy/type/created≤T skeleton (B).
5. Fixture depth — 4 categories (A) vs F01–F14 with construct litmus (B).
6. Capacity handling — soft deferral (A) vs hard RANKING_NOT_IN_SCOPE + Framing return (B).
7. Peer aggregates in SQL (B) vs pure raw columns (A).

## Reading for the judges
The gate before the cross-review would face two unreconciled designs. P1 asks whether that gate could still pass, and whether the later review adds a decision-relevant item the pre-gate would have missed. The scorer counts; it does not decide.
