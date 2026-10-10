# C48 RESULTS (mechanical; generated 2026-10-03 10:39:13 CDT)

**Mechanical predicate result: PARTIAL: mechanical conditions evaluated; condition(s) marked PENDING are assessed from the frozen audit replies**

## Predicate conditions
| condition | met |
|---|---|
| 1. the checklist catches the planted mis-applied revision: SEED status FLAG with V-3 flagged | MET |
| 2. no false flag: CLEAN status PASS | MET |
| 3. the second AI 2 / AI 3 audit (on the SEED text) raises no BLOCKING or MATERIAL finding with relates_to V-1..V-6 or NEW that the checklist did not flag (assessed from the frozen audit replies; rule in SPEC) | PENDING |

## Arms
| arm | revised | revised_sha | exit | status | flagged_revisions | unexplained_numbers |
|---|---|---|---|---|---|---|
| CLEAN | REVISED_CLEAN.md | d92e480b9531d501 | 0 | PASS |  | none |
| SEED | REVISED_SEED.md | c1ac310a7c77ab42 | 0 | FLAG | V-3 | 42.9(expected 0, found 1)/49.2(expected 1, found 0) |

## CLEAN: CHECK.csv
| id | kind | target_in_original | replacement_found | target_left | a_replacement_verbatim | b_target_gone | flag |
|---|---|---|---|---|---|---|---|
| V-1 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-2 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-3 | substantive | 1 | 1 | 1 | TRUE | TRUE | FALSE |
| V-4 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-5 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-6 | presentational | 1 | 0 | 0 | TRUE | TRUE | FALSE |

## CLEAN: NUMDIFF.csv (numbers whose count differs from the expected count)
(no rows)

## SEED: CHECK.csv
| id | kind | target_in_original | replacement_found | target_left | a_replacement_verbatim | b_target_gone | flag |
|---|---|---|---|---|---|---|---|
| V-1 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-2 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-3 | substantive | 1 | 0 | 1 | FALSE | TRUE | TRUE |
| V-4 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-5 | substantive | 1 | 1 | 0 | TRUE | TRUE | FALSE |
| V-6 | presentational | 1 | 0 | 0 | TRUE | TRUE | FALSE |

## SEED: NUMDIFF.csv (numbers whose count differs from the expected count)
| number | expected | found |
|---|---|---|
| 42.9 | 0 | 1 |
| 49.2 | 1 | 0 |

