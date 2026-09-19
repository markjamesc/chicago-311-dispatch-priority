# A04 Validator — DeepSeek DeepThink (Independent First Pass)

## 1. Role attestation

I am acting only as Validator for ablation A04. I am blind to the Builder's first-pass output. I will not issue a KEEP / REVERT / HALT decision. I assess evidence, state hard facts, identify blocking objections, and note evidence that is not independently visible. DeepThink is ON.

The frozen inputs named in the SPEC and Constitution are controlling. The RAW MANIFEST is treated as present; the files listed there are therefore not missing merely because their contents are not reproduced in the prompt. Where I assess a file's content, I rely only on the frozen pack text provided.

## 2. Test plan

The ablation tests whether removing or making optional the SQL Source Gate versus raw extraction preserves the Source Gate's protective function:

- nonjudgmental delivery and completeness versus raw;
- detection of extract and delivery defects;
- equal coverage from Chicago's dual R reconciliation plus fixtures alone.

P1 requires that skipping Source Gate reduces steps while dual R reconciliation plus fixtures would still catch extract/delivery defects with equal coverage. P1 fails if Source Gate was necessary to prove nonjudgmental delivery/completeness versus raw, or if skipping it leaves silent extract bugs undetectable by reconciliation alone.

The Validator checks whether Source Gate checks are mechanically evidenced; whether dual R reconciliation and fixture results cover the same defect classes; whether any silent extract bug class remains undetectable by reconciliation alone; whether hard mechanical facts are agreed and frozen; and whether RAW MANIFEST artifacts are sufficient for the claim.

## 3. Hard facts

### 3.1 RAW MANIFEST

The RAW MANIFEST contains SHA-256 hashes for BASELINE_FRAMEWORK.sha256, EXACT_RECON_REPORT.md, LINEAGE_ATTESTATION.md, MANIFEST.sha256, RA_portfolio_counts.csv, RB_portfolio_counts.csv, RECON_DISAGREE_IDS.csv, RECON_SUMMARY.csv, SOURCE_GATE_REPORT.md, r_a_fixture_results.csv, r_b_fixture_results.csv, stage4_validation_status.json, structural_cross_review.md, three-ai-measurement-design-framework.md, three-ai-validation-and-analysis-framework.md, and workflow_gate_status.json.

The adjudicator note says that when packs agree and the RAW MANIFEST is present, missing historical MySQL stdout is not by itself a HALT condition, and that P1 failure is handled under the frozen adjudication rule.

### 3.2 SOURCE_GATE_REPORT

The provided report states:

- Overall: PASS.
- Authority: Design Gate PASS and Fixture Gate PASS (`fixtures-v1-tcd-ig`, F01–F14, F03→STANDARD at kappa=2).
- R-A/R-B: UNBLOCKED.
- Extract Open n = 245,193; raw Open n = 245,193.
- Distinct SR_NUMBER = 245,193; peer type_key n = 104; peer row sum = 1,881,338.
- Source Gate overall: 15 PASS, 0 FAIL, 2 INFO.

The checks reported PASS are A_open_count_match, B_distinct_sr_equals_rows, C_id_extra/C_id_missing, D_field_mismatch_critical, E_status_domain_open_only, F_created_date_range, G_null_profile_created_status, H_sr_checksum_match, I_peer_stats_present/p75/type_key, J_no_judged_columns, and K_lineage_open_matches_raw/t_freeze. G_null_closed_date_info and L_raw_status_dist are INFO. Deliverables include `chicago311.src_open_candidates`, `chicago311.src_peer_stats`, `chicago311.src_extract_lineage`, `sql/01_source_extract.sql`, and `sql/02_source_gate_checks.sql`.

The report notes that wrapper exit_code 1 came only from a post-gate SELECT against non-table `src_gate_overall`; the gate script itself exited 0 with `SOURCE_GATE_PASS`.

### 3.3 RECON_SUMMARY.csv

The provided summary states: n_ra = 222,002; n_rb = 222,002; n_inner = 222,002; n_only_ra = 0; n_only_rb = 0; n_agree = 222,002; n_disagree = 0.

### 3.4 Other manifest artifacts

The artifacts are present by hash in the RAW MANIFEST, but their contents are not reproduced in the provided pack. Thus they are not treated as missing for the adjudicator's manifest rule, although their contents cannot be independently inspected from this prompt.

## 4. Source Gate notes

The Source Gate is the exact change target. The proposal is to trust the extract and skip formal Source Gate PASS before the R builders. The report shows a formal PASS with 15 PASS, 0 FAIL, and 2 INFO; the INFO items are described as expected or informational.

Several checks directly compare extract versus raw: A_open_count_match, B_distinct_sr_equals_rows, C_id_extra/C_id_missing, D_field_mismatch_critical, E_status_domain_open_only, F_created_date_range, G_null_profile_created_status, H_sr_checksum_match, and K_lineage_open_matches_raw/t_freeze. These are the checks that establish nonjudgmental delivery/completeness versus raw and can catch extract or delivery defects.

The dual R summary is strong evidence of R-A/R-B agreement on the reconciled field set, but it does not show whether the field set covers all critical extract fields, whether both builders could agree on a missing raw row, whether a systematic extract bug affects both identically, whether a raw-to-extract count mismatch is detected, or whether a stale/different extract was consumed. The Source Gate's A, B, C, D, H, and K checks compare against raw; the recon summary does not visibly reproduce those comparisons.

Fixture evidence is present by hash and the fixture gate is asserted PASS, but the fixture result contents are not reproduced. The Validator therefore cannot independently confirm from the provided text that fixture coverage includes the extract/delivery defect classes covered by the Source Gate. `stage4_validation_status.json` and `workflow_gate_status.json` are likewise present by hash but not reproduced.

## 5. P1 assessment

### 5.1 Equal coverage

The provided evidence does not establish equal coverage. The Source Gate report lists explicit extract-versus-raw checks for counts, IDs, critical fields, checksums, and lineage. The recon summary shows only that R-A and R-B agree on 222,002 rows with zero disagreements. It does not show that either builder was compared against raw on the same critical fields. If both builders consume the same extract, an extract defect can propagate identically and still produce recon agreement. The fixture PASS assertion is not enough to demonstrate equivalent coverage because the fixture contents are not reproduced.

Therefore the evidence does not establish that dual R reconciliation plus fixtures would have caught extract/delivery defects with equal coverage. The first P1 failure condition is supported: the Source Gate was necessary to prove nonjudgmental delivery/completeness versus raw, while the recon summary alone does not prove that.

### 5.2 Silent extract bugs undetectable by recon alone

The following classes can remain silent when both R builders consume the same extract:

- missing extract rows that are absent from both R outputs;
- critical fields corrupted consistently in the extract;
- extra or missing extract IDs versus raw;
- checksum mismatch versus raw;
- lineage or freeze mismatch versus raw.

The Source Gate checks A/B, D, C, H, and K directly address these classes. The recon summary does not visibly do so. The second P1 failure condition is therefore supported: skipping Source Gate can leave silent extract bugs undetectable by reconciliation alone.

### 5.3 P1 conclusion

From the provided frozen evidence, P1 is not established. The evidence shows R-A/R-B agreement, but not equal coverage against raw. The Source Gate report documents extract-versus-raw checks that the recon summary does not replicate, and fixture coverage of those defect classes cannot be independently confirmed from the provided text. This is a P1 assessment only; the Validator does not issue KEEP / REVERT / HALT.

## 6. Blocking objections

**BO-1 — Recon summary does not prove nonjudgmental delivery/completeness versus raw.** The summary shows R-A/R-B agreement on 222,002 rows and zero disagreements, but not extract-versus-raw count match, ID extra/missing, critical-field mismatch, checksum match, or lineage/freeze match. The Source Gate report shows those checks PASS. This directly bears on P1 failure condition 1.

**BO-2 — Silent extract bug classes remain undetectable by recon alone.** A defect identical in R-A and R-B can yield recon agreement because both consume the same extract. Source Gate checks A, B, C, D, H, and K are designed to detect those defects against raw. This directly bears on P1 failure condition 2.

**BO-3 — Fixture coverage is not independently verifiable from the provided text.** Fixture gate PASS is asserted, but the result files are only present by hash. Equal coverage with Source Gate checks A–L cannot be confirmed.

**BO-4 — Hard mechanical facts are not fully visible for Validator agreement.** Visible facts include Source Gate counts and statuses, RECON_SUMMARY counts, and RAW MANIFEST hashes. The contents of EXACT_RECON_REPORT.md, both fixture result CSVs, stage4_validation_status.json, workflow_gate_status.json, RECON_DISAGREE_IDS.csv, and both portfolio count files are not visible. The manifest rule means they are not missing, but it does not give the Validator enough content to independently confirm every hard fact.

**BO-5 — Wrapper exit code 1 needs careful reading.** The report attributes it to a post-gate SELECT against a non-table and states the gate script exited 0 with `SOURCE_GATE_PASS`. This does not by itself invalidate the gate, but it should be reconciled against any Builder hard-mechanical exit-code claim.

## 7. Missing evidence

Per the adjudicator note, the RAW MANIFEST is present, so the listed files are not missing for HALT purposes. For independent Validator assessment, their contents are not reproduced. The Validator cannot confirm exact fixture actuals and expecteds, exact fixture IDs executed, fixture coverage of extract-versus-raw defect classes, baseline/candidate version hashes beyond the manifest listing, the declared changed-file set, the exact recon critical-field list, consistency of PASS/FAIL states in the two status JSON files, or whether RECON_DISAGREE_IDS.csv is empty and consistent with n_disagree = 0. These are not missing in the adjudicator-note sense; they are not independently visible in the provided text.

## 8. Summary

The frozen evidence shows a present RAW MANIFEST, a Source Gate PASS with 15 PASS/0 FAIL/2 INFO, direct extract-versus-raw checks A–L, and R-A/R-B agreement of 222,002 rows with zero disagreements. Fixture gate PASS is asserted but its result contents are not reproduced. The recon summary alone does not prove nonjudgmental delivery/completeness versus raw and would not detect extract defects identical in both builders. P1 is not established from the provided evidence. Blocking objections BO-1 through BO-5 are supported, especially BO-1 and BO-2. No KEEP / REVERT / HALT decision is issued by the Validator; the Validator's role is to assess and report.
