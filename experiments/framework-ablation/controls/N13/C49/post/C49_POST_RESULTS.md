# C49 POST-CHAT RESULTS (mechanical; generated 2026-10-03 12:47:03 CDT)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. variant access: DS_FILES and GPT_FILES each prove access to every evidence file (FIRST and LAST lines match) | MET |
| 2. inventory hashes: in DS_FILES and GPT_FILES every evidence file is listed with the SHA-256 in SHA256SUMS | MET |
| 3. delay no worse: DS_FILES time to a usable first pass <= DS_ZIP time to a usable first pass + 2 min (DS_ZIP not usable = met) | MET |

## Arms
| arm | model | delivery | reply_sha256 | end_line | files_listed | files_opened_proven | n_files | files_said_opened | sha_match | facts_answered | facts_correct | usable | minutes | time_to_usable_min |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DS_ZIP | DeepSeek | ZIP | 434ead16128d6b32346a6a5febc0f944477c1d8c15a5a2b6156e75fc67157ca6 | TRUE | 9 | 0 | 9 | 0 | 0 | 3 | 1 | FALSE | 0.65 |  Inf |
| DS_FILES | DeepSeek | FILES (PD-3 rerun: FILES_PD3, SHA256SUMS.txt) | f6e0a1f79a95ad566df9511366f5d5a021947d0e59cd11ca5218b22f663b074f | TRUE | 9 | 9 | 9 | 9 | 9 | 5 | 5 | TRUE | 0.83 | 0.83 |
| GPT_FILES | ChatGPT | FILES | 94cab4c78cb7760d3a557179579def0409d1ef6faf0c0c45294c31dac2aff740 | TRUE | 9 | 9 | 9 | 9 | 9 | 5 | 5 | TRUE | 5.00 | 5.00 |

## INVENTORY_DS_ZIP.csv
| file | listed | sha_match | first_ok | last_ok | said_opened | opened_proven |
|---|---|---|---|---|---|---|
| STAGE5_EVIDENCE_PACKAGE.md | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| STAGE5_DEEPER_FINDINGS.md | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| capacity_coverage_note.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| escalate_by_type_top25.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| inconclusive_by_clause.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| independent_checks_critical_counts.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| kappa_sensitivity.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| portfolio_summary.csv | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |
| AI1_INTERPRETATION.md | TRUE | FALSE | FALSE | FALSE | FALSE | FALSE |

## FACTS_DS_ZIP.csv
| q | expected | reply | correct |
|---|---|---|---|
| Q1 | 131968 | NA | FALSE |
| Q2 | 64922 | 25. | FALSE |
| Q3 | 49.2 | 25. | FALSE |
| Q4 | 25 | 25. | TRUE |
| Q5 | 118246 | NA | FALSE |

## INVENTORY_DS_FILES.csv
| file | listed | sha_match | first_ok | last_ok | said_opened | opened_proven |
|---|---|---|---|---|---|---|
| STAGE5_EVIDENCE_PACKAGE.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| STAGE5_DEEPER_FINDINGS.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| capacity_coverage_note.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| escalate_by_type_top25.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| inconclusive_by_clause.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| independent_checks_critical_counts.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| kappa_sensitivity.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| portfolio_summary.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| AI1_INTERPRETATION.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |

## FACTS_DS_FILES.csv
| q | expected | reply | correct |
|---|---|---|---|
| Q1 | 131968 | 131968 | TRUE |
| Q2 | 64922 | 64922 | TRUE |
| Q3 | 49.2 | 49.2 | TRUE |
| Q4 | 25 | 25 | TRUE |
| Q5 | 118246 | 118246 | TRUE |

## INVENTORY_GPT_FILES.csv
| file | listed | sha_match | first_ok | last_ok | said_opened | opened_proven |
|---|---|---|---|---|---|---|
| STAGE5_EVIDENCE_PACKAGE.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| STAGE5_DEEPER_FINDINGS.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| capacity_coverage_note.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| escalate_by_type_top25.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| inconclusive_by_clause.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| independent_checks_critical_counts.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| kappa_sensitivity.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| portfolio_summary.csv | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |
| AI1_INTERPRETATION.md | TRUE | TRUE | TRUE | TRUE | TRUE | TRUE |

## FACTS_GPT_FILES.csv
| q | expected | reply | correct |
|---|---|---|---|
| Q1 | 131968 | 131968 | TRUE |
| Q2 | 64922 | 64922 | TRUE |
| Q3 | 49.2 | 49.2 | TRUE |
| Q4 | 25 | 25 | TRUE |
| Q5 | 118246 | 118246 | TRUE |

