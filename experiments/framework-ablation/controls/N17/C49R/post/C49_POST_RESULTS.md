# C49 POST-CHAT RESULTS (mechanical; generated 2026-10-09 07:18:45 by c49_port.py)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. variant access: DS_FILES and GPT_FILES each prove access to every evidence file (FIRST and LAST lines match) | MET |
| 2. inventory hashes: in DS_FILES and GPT_FILES every evidence file is listed with the SHA-256 in SHA256SUMS.txt | MET |
| 3. delay no worse: DS_FILES time to a usable first pass <= DS_ZIP time to a usable first pass + 2 min (DS_ZIP not usable = met) | MET |

## Arms
| arm | model | delivery | reply_sha256 | end_line | files_listed | files_opened_proven | n_files | files_said_opened | sha_match | facts_answered | facts_correct | usable | minutes | time_to_usable_min |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DS_ZIP | DeepSeek | ZIP | 1aa2a0c98488786cb7dbbdb87c53551d30a495e6f085d55e18df2bf1d36391e9 | TRUE | 9 | 0 | 9 | 0 | 0 | 0 | 0 | FALSE | 0.42 | Inf |
| DS_FILES | DeepSeek | FILES (SHA256SUMS.txt) | ee4234668a87a386990a978c2c53afa2d9e4509057e94db4cca2eff906482688 | TRUE | 9 | 9 | 9 | 9 | 9 | 5 | 5 | TRUE | 1.93 | 1.93 |
| GPT_FILES | ChatGPT | FILES (SHA256SUMS.txt) | 0f93bb24fcbc44487c08f970ad32d91160681ff3cfee813dbb5261a908508d29 | TRUE | 9 | 9 | 9 | 9 | 9 | 5 | 5 | TRUE | 1.70 | 1.70 |

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
| Q2 | 64922 | NA | FALSE |
| Q3 | 49.2 | NA | FALSE |
| Q4 | 25 | NA | FALSE |
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

