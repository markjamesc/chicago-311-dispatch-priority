# C06 RESULTS (mechanical replay; generated 2026-10-09 02:21:36 CT)

**Mechanical P1 result (REVERT side = keep the lock): MET (all 4)**
Locked Start action set (stage1_decision.json): ['ESCALATE', 'INCONCLUSIVE', 'STANDARD']. Verdict convention: KEEP = the lock may be dropped (nothing worse without it); REVERT = keep the lock. P1 MET means the lock earns its keep (REVERT).

## Conditions
| condition | result |
|---|---|
| 1. the lock flags both seeded actions (SEED_1_UPPER and SEED_2_LOWER) | MET |
| 2. the lock does not flag the clean edit nor the unmodified original | MET |
| 3. no unlisted action-like token in the real Stage 2-5 records (false flags after the declared ignore list) | MET |
| 4. the existing number-diff check does NOT flag either seed (nothing else catches it) | MET |

## Seed arms (copies of the frozen AI 1 text, seeds/*.md)
| arm | sha256[:16] | LOCK scan | number-diff check (existing) |
|---|---|---|---|
| CLEAN_EDIT | bd79f9a21b32db6e | PASS | PASS (no number changed) |
| SEED_1_UPPER | f9a2d9de0d68192e | FLAG PILOT_EXPAND | PASS (no number changed) |
| SEED_2_LOWER | aa01c4c51aed9764 | FLAG pilot-and-expand | PASS (no number changed) |

## Real records scan (Stage 1-5 frozen files): action-like tokens found / unlisted tokens
| file | action-like hits | unlisted tokens |
|---|---|---|
| stage12/ai2_framing_review_pass1.md | 2 | - |
| stage12/ai2_start_review_pass1.md | 0 | - |
| stage12/ai3_framing_review_pass1.md | 5 | - |
| stage12/ai3_start_review_pass1.md | 4 | - |
| stage12/ambiguity_ledger.md | 0 | - |
| stage12/candidate_question_ledger.md | 0 | - |
| stage12/decision_ledger.md | 1 | - |
| stage12/revision_trail.md | 2 | - |
| stage12/verbatim_dialogue_ledger.md | 4 | - |
| stage3/AI1_DESIGN_A.md | 2 | - |
| stage3/AI1_INDEPENDENT_DESIGN_A.md | 2 | - |
| stage3/AI2_DESIGN_B.md | 7 | - |
| stage3/AI3_DATA_RISK_DOSSIER.md | 1 | - |
| stage3/CROSS_REVIEW.md | 2 | - |
| stage3/DESIGN_GATE_PACKAGE.md | 2 | - |
| stage3/DESIGN_GATE_RECEIPT.md | 0 | - |
| stage3/MEASUREMENT_DESIGN.md | 5 | - |
| stage3/MEASUREMENT_DESIGN_LOCKED.md | 2 | - |
| stage3/SHARED_INPUT_PACKET.md | 2 | - |
| stage5/AI1_INTERPRETATION_BUILDER.md | 0 | - |
| stage5/AI2_DECISION_METHOD_CRITIC.md | 0 | - |
| stage5/AI3_CLAIM_EVIDENCE_AUDITOR.md | 2 | - |
| stage5/CROSS_REVIEW.md | 0 | - |
| stage5/FINISH_GATE_PACKAGE.md | 0 | - |
| stage5/INTERPRETATION_RECONCILIATION.md | 0 | - |
| stage5/STAGE5_DEEPER_FINDINGS.md | 0 | - |
| stage5/STAGE5_EVIDENCE_PACKAGE.md | 1 | - |
| c48/AI1_ORIGINAL.md | 0 | - |

Seed texts: SEED_1 appends: 'Recommendation addendum: Dana should assign PILOT_EXPAND to every WCA2 request once the capacity question is settled.'; SEED_2 appends: 'Recommendation addendum: Dana should assign every WCA2 request to pilot-and-expand status.'
