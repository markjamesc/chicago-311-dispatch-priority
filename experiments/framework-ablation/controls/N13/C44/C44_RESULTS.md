# C44 RESULTS (mechanical; generated 2026-10-03 11:34:22 CDT)

**Mechanical predicate result: PARTIAL: pre-chat conditions evaluated; conditions marked PENDING are evaluated after the extra chats (see SPEC)**

## Predicate conditions
| condition | met |
|---|---|
| 0. delta scope valid (pre-chat): changed artifact sent verbatim, every unchanged input listed by its SHA-256, no unchanged body re-sent | MET |
| 1. every BLOCKING/MATERIAL finding of the FULL re-review is also raised by the DELTA re-review (judged from the frozen replies) | PENDING |
| 2. the DELTA re-review catches the changed-file seed (V-3) | PENDING |
| 3. round cost falls by >= 30% (wall-clock if both logged; declared proxy otherwise) | PENDING |

## Arms
| arm | exit | status | full_packet_bytes | delta_packet_bytes | delta_over_full | unchanged_inputs | unchanged_listed_by_hash | revised_text_verbatim |
|---|---|---|---|---|---|---|---|---|
| STATIC | 0 | PASS | 58214 | 18691 | 0.3211 | 13 | 13 | TRUE |

## UNCHANGED_HASH_LIST_CHECK.csv
| input | sha256 | listed_by_hash_in_delta |
|---|---|---|
| STAGE5_EVIDENCE_PACKAGE.md | c8e191d861a71097b4bc2ebaaab2626633617350e39f130e1c7d148a3379bfb7 | TRUE |
| deeper/STAGE5_DEEPER_FINDINGS.md | 49ab09c26c86e4a0abcd2031745e0c4bc786dffc8fe6cf4066e9c3afa93c70e6 | TRUE |
| deeper/capacity_coverage_note.csv | 4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609 | TRUE |
| deeper/escalate_by_type_top25.csv | 6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176 | TRUE |
| deeper/inconclusive_by_clause.csv | f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d | TRUE |
| deeper/independent_checks_critical_counts.csv | 4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146 | TRUE |
| deeper/kappa_sensitivity.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a | TRUE |
| deeper/portfolio_summary.csv | b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167 | TRUE |
| reviews/AI2_DECISION_METHOD_CRITIC.md | ca9376b2adeb2ecc276f29c81dc0f10e3b3cc32513f2f916f42dc7bb1418049a | TRUE |
| reviews/AI3_CLAIM_EVIDENCE_AUDITOR.md | 9e4848407a5ae85bf350a150a8ed1f05b25a58821339b802c6429c405401b5b1 | TRUE |
| reviews/CROSS_REVIEW.md | 9431125a9380c897f4b883bbef2b1c440371679e0ec59a10520733bdd8bff457 | TRUE |
| reviews/INTERPRETATION_RECONCILIATION.md | 80402e93b1fb023c09db016473a80f0feac56b187542f0d205dfe5193d647462 | TRUE |
| AI1_INTERPRETATION (original, before revision) | 73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932 | TRUE |

