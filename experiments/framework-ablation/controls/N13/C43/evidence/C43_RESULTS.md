# C43 RESULTS (mechanical; generated 2026-10-03 11:34:22 CDT)

**Mechanical predicate result: P1 NOT MET**

## Predicate conditions
| condition | met |
|---|---|
| 1. no intermediate (class I) artifact is cited by SHA-256 in an audit or reconstruction record (citations whose hash also belongs to a gate-feeding artifact excluded) | NOT MET |
| 2. no intermediate artifact is cited by path or unique file name, and no intermediate directory is cited, in an audit or reconstruction record | NOT MET |
| 3. harness validity: the auditor self-test passes (planted citation found; citation of a hash with a gate-feeding copy not counted; class rules give the declared classes) | MET |

## Arms
| arm | exit | secs | selftest | needed_by_hash | needed_by_path_or_name | needed_by_directory | status | trail_index_sha256 |
|---|---|---|---|---|---|---|---|---|
| AUDIT | 0 | 35.7 | PASS | 10 | 2 | 3 | INTERMEDIATE_NEEDED | 0fcc3b64ac8d464a |

## SUMMARY.txt
```
trail_files=7804
hash_list_files=598
hash_records=16261
unparsed_hash_lines=0
distinct_hashed_artifacts=14095
unresolved_paths=6868
class_G=8130
class_I=5965
by_rule: I1_scratch=1650 I2_superseded=62 I3_bundle=3 I4_page_asset=4210 I5_assembly=40 G0_gate=8130
class_I_bytes_known=500660758
hash_records_class_I=6380
records_scanned=21
records_excluded_class_I=3
intermediate_dirs=_interim_b4|_superseded_v0|_smoke_b3|evidence_first_0500
citations_total=11214
citations_hash_with_G_copy=11198
needed_by_hash=10
needed_by_path_or_name=2
needed_by_directory=3
trail_files_not_in_any_hash_list=598
```

## NEEDED.csv (every intermediate artifact or directory that an audit/reconstruction record cites; full file)
| artifact | sha256 | rule | kind | n_citing_lines | records |
|---|---|---|---|---|---|
| (directory) _interim_b4 |  | I1_scratch | directory | 2 | N13/pc_run/b4/C46/INTERIM.txt/N13/pc_run/b4/C51/INTERIM.txt |
| (directory) _superseded_v0 |  | I2_superseded | directory | 1 | N13/runner_b5/PRECHECK_b5.json |
| N15/pc_run_b2.tgz | db734301fb914fb16cbd4dea00547fc48d410672e2c34569000a12e9d741ff31 | I3_bundle | path | 1 | N15/RESULTS_N15.md |
| N15/pc_run_b3.tgz | 23e0467649521c0c1d93fc7825b1dbc9571b01c9ba8d67798a38237175ad0b44 | I3_bundle | path | 1 | N15/RESULTS_N15.md |
| (directory) _smoke_b3 |  | I1_scratch | directory | 1 | N15/RESULTS_N15.md |
| N15/C26/packets/C26_3_ADJUDICATOR_Grok.HEAD.txt | a83f3dfd26174a3184547a8cbd309d182756d5ca28c7be6d8e65e8bf71fe32f2 | I5_assembly | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C26/packets/C26_3_ADJUDICATOR_Grok.HEAD.v1.txt | a83f3dfd26174a3184547a8cbd309d182756d5ca28c7be6d8e65e8bf71fe32f2 | I2_superseded | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C31/packets/C31_3_ADJUDICATOR_Grok.HEAD.txt | 4322e60a10a67e5863350bc32c3deea845f9b1eddfa09b0777b8d0328dd240bf | I5_assembly | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C31/packets/C31_3_ADJUDICATOR_Grok.HEAD.v1.txt | 4322e60a10a67e5863350bc32c3deea845f9b1eddfa09b0777b8d0328dd240bf | I2_superseded | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C39/packets/C39_3_ADJUDICATOR_Grok.HEAD.txt | 927807b6d718eb38bb0fb7aacd31620ee801a80700e2e6bd40408dc3cac1ca79 | I5_assembly | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C39/packets/C39_3_ADJUDICATOR_Grok.HEAD.v1.txt | 927807b6d718eb38bb0fb7aacd31620ee801a80700e2e6bd40408dc3cac1ca79 | I2_superseded | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C30/packets/C30_3_ADJUDICATOR_Grok.HEAD.txt | 312c5643b1f0f58c1eeef4f41e67b5f86ed2ad6e9aaafda94a39487b8a7053ec | I5_assembly | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C30/packets/C30_3_ADJUDICATOR_Grok.HEAD.v1.txt | 312c5643b1f0f58c1eeef4f41e67b5f86ed2ad6e9aaafda94a39487b8a7053ec | I2_superseded | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C29/packets/C29_3_ADJUDICATOR_Grok.HEAD.txt | 9091862ab7155487cfa05812412d32a8762d30e11390e8a9ae08f285c5387dc9 | I5_assembly | hash | 1 | N15/TOOLS_PATCH_LOG.txt |
| N15/C29/packets/C29_3_ADJUDICATOR_Grok.HEAD.v1.txt | 9091862ab7155487cfa05812412d32a8762d30e11390e8a9ae08f285c5387dc9 | I2_superseded | hash | 1 | N15/TOOLS_PATCH_LOG.txt |

## Counted citing lines (CITATIONS.csv rows of kind hash / path / file_name / directory; the rows of kind 'hash_but_G_copy_exists' are not counted and are listed in full only in outputs/CITATIONS.csv)
rows of kind hash_but_G_copy_exists (not counted): 11198

| artifact | kind | record | line | text |
|---|---|---|---|---|
| (directory) _interim_b4 | directory | N13/pc_run/b4/C46/INTERIM.txt | 1 | Evaluation note: the batch runner evaluates all controls only after the last one (C52, several hours of SQL). So that the C46 chats can start, the coordinator ran the same frozen evaluator (runner/eval_b4.R, hash in the PREFLIGHT) on a byte-copy of the finished C46 arm folders at 2026-10-03 09:41 CD |
| (directory) _interim_b4 | directory | N13/pc_run/b4/C51/INTERIM.txt | 1 | Evaluation note: the batch runner evaluates all controls only after the last one (C52, several hours of SQL). So that the C51 chats can start, the coordinator ran the same frozen evaluator (runner/eval_b4.R, hash in the PREFLIGHT) on a byte-copy of the finished C51 arm folders at 2026-10-03 09:41 CD |
| (directory) _superseded_v0 | directory | N13/runner_b5/PRECHECK_b5.json | 12 | "chg": " (one harness change was made before the scratch run, not after it: `recon_c53.R` gained the RECON_IDS.csv output so the baseline rule could subtract clean B's mismatch rows; the earlier seed set is kept unexecuted in `runner_b5/_superseded_v0/`)" |
| N15/pc_run_b2.tgz | path | N15/RESULTS_N15.md | 91 | - Evidence: `pc_run_b2.tgz`, extracted to `pc_run/b2/`. `tools_verify_run_b.py b2`: RUN VERIFY PASS. |
| N15/pc_run_b3.tgz | path | N15/RESULTS_N15.md | 120 | - Evidence: `pc_run_b3.tgz` → `pc_run/b3/`. RUN VERIFY PASS. |
| (directory) _smoke_b3 | directory | N15/RESULTS_N15.md | 109 | - Two smoke runs on the PC: `_smoke_b3` (05:58–06:04 CDT; it overlapped the tail of the b2 run, so its C45 timings are not used) and `_smoke_b3b` (06:07–06:09 CDT). |
| N15/C26/packets/C26_3_ADJUDICATOR_Grok.HEAD.txt | hash | N15/TOOLS_PATCH_LOG.txt | 3 | 2026-10-03 05:17:54 CDT C26 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=a83f3dfd26174a3184547a8cbd309d182756d5ca28c7be6d8e65e8bf71fe32f2 new=da61dd169825e6940b6d9f4d31216df6e56e30a31a7737bb224b498a988211e3 |
| N15/C26/packets/C26_3_ADJUDICATOR_Grok.HEAD.v1.txt | hash | N15/TOOLS_PATCH_LOG.txt | 3 | 2026-10-03 05:17:54 CDT C26 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=a83f3dfd26174a3184547a8cbd309d182756d5ca28c7be6d8e65e8bf71fe32f2 new=da61dd169825e6940b6d9f4d31216df6e56e30a31a7737bb224b498a988211e3 |
| N15/C31/packets/C31_3_ADJUDICATOR_Grok.HEAD.txt | hash | N15/TOOLS_PATCH_LOG.txt | 4 | 2026-10-03 05:17:54 CDT C31 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=4322e60a10a67e5863350bc32c3deea845f9b1eddfa09b0777b8d0328dd240bf new=0ae64be47cd4a3ec049203ba0225530375748244455d679e65428d45c952826f |
| N15/C31/packets/C31_3_ADJUDICATOR_Grok.HEAD.v1.txt | hash | N15/TOOLS_PATCH_LOG.txt | 4 | 2026-10-03 05:17:54 CDT C31 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=4322e60a10a67e5863350bc32c3deea845f9b1eddfa09b0777b8d0328dd240bf new=0ae64be47cd4a3ec049203ba0225530375748244455d679e65428d45c952826f |
| N15/C39/packets/C39_3_ADJUDICATOR_Grok.HEAD.txt | hash | N15/TOOLS_PATCH_LOG.txt | 5 | 2026-10-03 05:17:54 CDT C39 Grok HEAD: coordinator notes N1 (+C39 note) inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=927807b6d718eb38bb0fb7aacd31620ee801a80700e2e6bd40408dc3cac1ca79 new=3aa8ccf5b76b9f6165b57deb5064fd347537ac37a75dc57596fccb68531782e5 |
| N15/C39/packets/C39_3_ADJUDICATOR_Grok.HEAD.v1.txt | hash | N15/TOOLS_PATCH_LOG.txt | 5 | 2026-10-03 05:17:54 CDT C39 Grok HEAD: coordinator notes N1 (+C39 note) inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=927807b6d718eb38bb0fb7aacd31620ee801a80700e2e6bd40408dc3cac1ca79 new=3aa8ccf5b76b9f6165b57deb5064fd347537ac37a75dc57596fccb68531782e5 |
| N15/C30/packets/C30_3_ADJUDICATOR_Grok.HEAD.txt | hash | N15/TOOLS_PATCH_LOG.txt | 6 | 2026-10-03 05:17:54 CDT C30 Grok HEAD: coordinator notes N1+N2 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=312c5643b1f0f58c1eeef4f41e67b5f86ed2ad6e9aaafda94a39487b8a7053ec new=54e2ecadc5f3809e38a4d2e84d9475aee0e6be95af193463573f227fa74447ce |
| N15/C30/packets/C30_3_ADJUDICATOR_Grok.HEAD.v1.txt | hash | N15/TOOLS_PATCH_LOG.txt | 6 | 2026-10-03 05:17:54 CDT C30 Grok HEAD: coordinator notes N1+N2 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=312c5643b1f0f58c1eeef4f41e67b5f86ed2ad6e9aaafda94a39487b8a7053ec new=54e2ecadc5f3809e38a4d2e84d9475aee0e6be95af193463573f227fa74447ce |
| N15/C29/packets/C29_3_ADJUDICATOR_Grok.HEAD.txt | hash | N15/TOOLS_PATCH_LOG.txt | 7 | 2026-10-03 05:17:54 CDT C29 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=9091862ab7155487cfa05812412d32a8762d30e11390e8a9ae08f285c5387dc9 new=d404045578b2faae55337124bf24be4c579ddde5e561eb3ea36cbec1138741b2 |
| N15/C29/packets/C29_3_ADJUDICATOR_Grok.HEAD.v1.txt | hash | N15/TOOLS_PATCH_LOG.txt | 7 | 2026-10-03 05:17:54 CDT C29 Grok HEAD: coordinator notes N1 inserted before # SPEC (parent decision 05:08 CT); v1 kept as .HEAD.v1.txt old=9091862ab7155487cfa05812412d32a8762d30e11390e8a9ae08f285c5387dc9 new=d404045578b2faae55337124bf24be4c579ddde5e561eb3ea36cbec1138741b2 |

## Hashed artifacts by class and rule
| class | rule | Freq |
|---|---|---|
| G | G0_gate | 8130 |
| I | I1_scratch | 1650 |
| I | I2_superseded |   62 |
| I | I3_bundle |    3 |
| I | I4_page_asset | 4210 |
| I | I5_assembly |   40 |

