# C53 RESULTS (mechanical; generated 2026-10-03 10:39:13 CDT)

**Mechanical predicate result: P1 MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. variant: every seeded arm is flagged by the table check (0 rulings needed, 0 escapes) | MET |
| 2. baseline: at least one seeded arm cannot be settled without the table (needs an owner ruling or escapes) | MET |
| 3. no new defect: clean arm B has 0 table violations and its 4 R-B key outputs equal the frozen hashes | MET |
| 4. seed validity: every seeded arm's labels, portfolio, kappa grid and fixture results equal the frozen R-B ones (seeds touch table cells only) | MET |

## Arms
| arm | rb_exit | rb_s | table_exit | recon_exit | labels_equal_frozen | portfolio_grid_fixtures_equal_frozen | classifications_equal_frozen | table_violations | cells_violated | new_recon_mismatches_vs_clean | new_mismatch_fields | clean_mismatches_removed | baseline_outcome | variant_outcome |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| B | 0 | 27.2 | 0 | 0 | TRUE | TRUE | TRUE |    0 |  | FALSE |  |  | - | - |
| U_DORMINC | 0 | 25.5 | 0 | 0 | TRUE | TRUE | FALSE | 6377 | T1a | TRUE | dormant_h:+6377 |  | surfaces as a new R-A/R-B mismatch with no table to say which path is right: needs an owner ruling | table check flags an R-B defect: no ruling needed |
| U_P75THIN | 0 | 25.3 | 0 | 0 | TRUE | TRUE | FALSE |   62 | T4 | TRUE | peer_p75_h:+62 |  | surfaces as a new R-A/R-B mismatch with no table to say which path is right: needs an owner ruling | table check flags an R-B defect: no ruling needed |
| U_PEERNBLANK | 0 | 25.4 | 0 | 0 | TRUE | TRUE | FALSE | 6315 | T3 | TRUE | peer_n:+6315 |  | surfaces as a new R-A/R-B mismatch with no table to say which path is right: needs an owner ruling | table check flags an R-B defect: no ruling needed |
| U_CLOCKLATE | 0 | 32.7 | 0 | 0 | TRUE | TRUE | FALSE |    3 | T1c/T2c | FALSE |  | dormant_h:-1/open_age_h:-2 | escapes: no new recon mismatch, labels and fixtures unchanged | table check flags an R-B defect: no ruling needed |

## Per-arm table check (TABLE_CHECK.csv)
### B
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 0 | NA |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 0 | NA |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

### U_DORMINC
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 6377 | SR20-03279926/SR22-00047020/SR23-00037006/SR23-00037009/SR23-00037010 |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 215624 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 0 | NA |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 0 | NA |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

### U_P75THIN
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 0 | NA |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 0 | NA |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 62 | SR23-01902437/SR24-00180436/SR24-00354087/SR24-00446919/SR24-00458404 |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

### U_PEERNBLANK
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 0 | NA |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 0 | NA |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 6315 | SR20-03279926/SR22-00047020/SR23-00037006/SR23-00037009/SR23-00037010 |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

### U_CLOCKLATE
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 1 | SR22-01936870 |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 2 | SR25-02017553/SR25-02017556 |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

## Per-arm baseline recon vs frozen R-A (RECON_BASE.csv)
### B
| field | mismatches | ids_sorted | ids_sha256 |
|---|---|---|---|
| only_ra | 0 | NA | NA |
| only_rb | 0 | NA | NA |
| classification | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| dormant_h | 1 | SR22-01936870 | 24a771a05fd1b6ef58b98224e6cdc80cbf7eacccf122ed654ffae7488a04c94f |
| open_age_h | 2 | SR25-02017553/SR25-02017556 | aa4a50446c8fd775480093611abb0737f603a89838793fd297c7ab28a87d4773 |
| peer_n | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| peer_p75_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |

### U_DORMINC
| field | mismatches | ids_sorted | ids_sha256 |
|---|---|---|---|
| only_ra | 0 | NA | NA |
| only_rb | 0 | NA | NA |
| classification | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| dormant_h | 6378 | SR20-03279926/SR22-00047020/SR22-01936870/SR23-00037006/SR23-00037009/SR23-00037010/SR23-00037012/SR23-00037023/SR23-00037028/SR23-00037032/SR23-00037034/SR23-00037035/SR23-00037037/SR23-00037041/SR23-00037042/SR23-00037049/SR23-00037051/SR23-00037052/SR23-00037054/SR23-00037057/...(6378) | d78d23e6f0974ead4ac4d838cd96b902d21ca34e49cd3b6e141bdb5bf4f8917c |
| open_age_h | 2 | SR25-02017553/SR25-02017556 | aa4a50446c8fd775480093611abb0737f603a89838793fd297c7ab28a87d4773 |
| peer_n | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| peer_p75_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |

### U_P75THIN
| field | mismatches | ids_sorted | ids_sha256 |
|---|---|---|---|
| only_ra | 0 | NA | NA |
| only_rb | 0 | NA | NA |
| classification | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| dormant_h | 1 | SR22-01936870 | 24a771a05fd1b6ef58b98224e6cdc80cbf7eacccf122ed654ffae7488a04c94f |
| open_age_h | 2 | SR25-02017553/SR25-02017556 | aa4a50446c8fd775480093611abb0737f603a89838793fd297c7ab28a87d4773 |
| peer_n | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| peer_p75_h | 62 | SR23-01902437/SR24-00180436/SR24-00354087/SR24-00446919/SR24-00458404/SR25-00161751/SR25-01159139/SR25-01237125/SR25-01297186/SR25-01388709/SR25-01411072/SR25-01609218/SR25-01619002/SR25-01671934/SR25-01674865/SR25-01976591/SR25-02098413/SR25-02130313/SR26-00188056/SR26-00453697/...(62) | 8529a837eef840a497b7936fff88034f142227263a580772e2688fce2675a8bf |

### U_PEERNBLANK
| field | mismatches | ids_sorted | ids_sha256 |
|---|---|---|---|
| only_ra | 0 | NA | NA |
| only_rb | 0 | NA | NA |
| classification | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| dormant_h | 1 | SR22-01936870 | 24a771a05fd1b6ef58b98224e6cdc80cbf7eacccf122ed654ffae7488a04c94f |
| open_age_h | 2 | SR25-02017553/SR25-02017556 | aa4a50446c8fd775480093611abb0737f603a89838793fd297c7ab28a87d4773 |
| peer_n | 6315 | SR20-03279926/SR22-00047020/SR23-00037006/SR23-00037009/SR23-00037010/SR23-00037012/SR23-00037023/SR23-00037028/SR23-00037032/SR23-00037034/SR23-00037035/SR23-00037037/SR23-00037041/SR23-00037042/SR23-00037049/SR23-00037051/SR23-00037052/SR23-00037054/SR23-00037057/SR23-00037059/...(6315) | 10bb0f859f8d5c3199d2db8092fbcd1913a0796ea98b1875f169d351a59dc025 |
| peer_p75_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |

### U_CLOCKLATE
| field | mismatches | ids_sorted | ids_sha256 |
|---|---|---|---|
| only_ra | 0 | NA | NA |
| only_rb | 0 | NA | NA |
| classification | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| dormant_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| open_age_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| peer_n | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| peer_p75_h | 0 | NA | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |

## INFO (not in P1): table check on the frozen outputs
### FROZEN_RB
input=RB_classifications.csv rows=222002 total_violations=0 cells_violated= evidence_reason_column=TRUE rows with a clock in the repeated fall-back hour: 3 :: SR22-01936870|SR25-02017553|SR25-02017556
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 0 | NA |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 0 | NA |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 0 | NA |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason: ESC 'E_dormant_ge_kappa_p75 (...)', STD 'S_dormant_lt_kappa_p75 (...)', INC = integrity_clause | 222002 | 0 | NA |

### FROZEN_RA (built before the table existed)
input=RA_classifications.csv rows=222002 total_violations=215628 cells_violated=T1c|T2c|T5a evidence_reason_column=FALSE rows with a clock in the repeated fall-back hour: 3 :: SR22-01936870|SR25-02017553|SR25-02017556
| cell | rows_checked | violations | example_ids |
|---|---|---|---|
| T0 classification in {ESCALATE,STANDARD,INCONCLUSIVE}; no OUT_OF_SET row; SR_NUMBER unique | 222002 | 0 | NA |
| T1a dormant_h present iff computable (ESC/STD/INC: number if both clocks parse, mod>=created, created<=T; else blank) | 222002 | 0 | NA |
| T1b dormant_h value = T - mod_ts (rows outside the repeated fall-back hour) | 222001 | 0 | NA |
| T1c dormant_h clock rule: mod_ts in the repeated fall-back hour read as first occurrence (CDT) | 1 | 1 | SR22-01936870 |
| T2a open_age_h present iff created parses and created<=T | 222002 | 0 | NA |
| T2b open_age_h value = T - created_ts (rows outside the repeated fall-back hour) | 222000 | 0 | NA |
| T2c open_age_h clock rule: created_ts in the repeated fall-back hour read as first occurrence (CDT) | 2 | 2 | SR25-02017553/SR25-02017556 |
| T3 peer_n is a non-negative integer on every row (0 if the type has no peers; type_key never blank in this pack) | 222002 | 0 | NA |
| T4 peer_p75_h present iff peer_n >= 1 | 222002 | 0 | NA |
| T5a integrity_clause blank on ESCALATE/STANDARD | 215625 | 215625 | SR18-00191995/SR18-00192008/SR18-00192021/SR18-00192151/SR18-00192236 |
| T5b integrity_clause on INCONCLUSIVE = exactly one clause (lowest-numbered failing clause only) | 6377 | 0 | NA |
| T6 evidence_reason | 0 | NA | COLUMN ABSENT |

