# C47 RESULTS (mechanical; generated 2026-10-03 10:39:08 CDT)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. planted dominant unit: SEED_DOM60 status FLAG with flagged types exactly T01 | MET |
| 2. clean case: CLEAN_BAL status NO_FLAG (no false flag) | MET |
| 3. minimum denominator: SMALL_N status NOT_APPLICABLE_BELOW_MIN_TOTAL (no flag below 1,000 ESCALATE rows) | MET |
| 4. real data: REAL_RB and REAL_RA both FLAG exactly WCA2 (ruled a true flag) with identical DOM_TABLE.csv | MET |
| 5. nothing changed: every input hash unchanged across the check, and the real inputs equal the frozen hashes (routing = report only) | MET |

## Arms
| arm | exit | input_sha | input_unchanged | n_escalate_total | top_type | top_share | flagged_types | status | dom_table_sha |
|---|---|---|---|---|---|---|---|---|---|
| REAL_RB | 0 | a0e42b8667b38baf | TRUE | 131968 | WCA2 | 0.491953 | WCA2 | FLAG | b5a46c63d017be7e |
| REAL_RA | 0 | c099e092feb237c8 | TRUE | 131968 | WCA2 | 0.491953 | WCA2 | FLAG | b5a46c63d017be7e |
| SEED_DOM60 | 0 | eba07ed92dc93966 | TRUE | 10000 | T01 | 0.600000 | T01 | FLAG | 04f12e81e2396540 |
| CLEAN_BAL | 0 | 89c3d85f6e8c76ef | TRUE | 10000 | T01 | 0.190000 |  | NO_FLAG | c413e66b0bca12cc |
| SMALL_N | 0 | d846fe7b17694f7a | TRUE | 900 | T01 | 0.600000 |  | NOT_APPLICABLE_BELOW_MIN_TOTAL | d579d57c895cab60 |

Baseline regime (no check): no arm is flagged by construction; the planted dominant unit and the real WCA2 concentration go unreported at Stage 4.

## REAL_RB: DOM_TABLE.csv (top 6 of 81 types)
| type_key | n_escalate | share | eligible | flag |
|---|---|---|---|---|
| WCA2 | 64922 | 0.4919525945683802 | TRUE | TRUE |
| SED | 17254 | 0.1307438166828322 | TRUE | FALSE |
| SKA | 7316 | 0.05543768186226964 | TRUE | FALSE |
| PBD | 3937 | 0.0298329898157129 | TRUE | FALSE |
| PHF | 3371 | 0.0255440712900097 | TRUE | FALSE |
| BBD | 3298 | 0.024990906886517943 | TRUE | FALSE |

## REAL_RA: DOM_TABLE.csv (top 6 of 81 types)
| type_key | n_escalate | share | eligible | flag |
|---|---|---|---|---|
| WCA2 | 64922 | 0.4919525945683802 | TRUE | TRUE |
| SED | 17254 | 0.1307438166828322 | TRUE | FALSE |
| SKA | 7316 | 0.05543768186226964 | TRUE | FALSE |
| PBD | 3937 | 0.0298329898157129 | TRUE | FALSE |
| PHF | 3371 | 0.0255440712900097 | TRUE | FALSE |
| BBD | 3298 | 0.024990906886517943 | TRUE | FALSE |

## SEED_DOM60: DOM_TABLE.csv (top 6 of 10 types)
| type_key | n_escalate | share | eligible | flag |
|---|---|---|---|---|
| T01 | 6000 | 0.6 | TRUE | TRUE |
| T02 | 445 | 0.0445 | TRUE | FALSE |
| T03 | 445 | 0.0445 | TRUE | FALSE |
| T04 | 445 | 0.0445 | TRUE | FALSE |
| T05 | 445 | 0.0445 | TRUE | FALSE |
| T06 | 445 | 0.0445 | TRUE | FALSE |

## CLEAN_BAL: DOM_TABLE.csv (top 6 of 10 types)
| type_key | n_escalate | share | eligible | flag |
|---|---|---|---|---|
| T01 | 1900 | 0.19 | TRUE | FALSE |
| T02 | 1500 | 0.15 | TRUE | FALSE |
| T03 | 1200 | 0.12 | TRUE | FALSE |
| T04 | 1100 | 0.11 | TRUE | FALSE |
| T05 | 1000 | 0.1 | TRUE | FALSE |
| T06 | 900 | 0.09 | TRUE | FALSE |

## SMALL_N: DOM_TABLE.csv (top 6 of 10 types)
| type_key | n_escalate | share | eligible | flag |
|---|---|---|---|---|
| T01 | 540 | 0.6 | FALSE | FALSE |
| T02 | 40 | 0.044444444444444446 | FALSE | FALSE |
| T03 | 40 | 0.044444444444444446 | FALSE | FALSE |
| T04 | 40 | 0.044444444444444446 | FALSE | FALSE |
| T05 | 40 | 0.044444444444444446 | FALSE | FALSE |
| T06 | 40 | 0.044444444444444446 | FALSE | FALSE |

