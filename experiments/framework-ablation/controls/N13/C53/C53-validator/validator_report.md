# C53 Validator Report

## 1. Role attestation and ablation ID

I am DeepSeek, acting only as Validator for this first pass. DeepThink is on. I am blind to the Builder; I have not seen and have not asked for the Builder’s output. I have not returned and do not return KEEP, REVERT or HALT.

Ablation ID: **C53** — Addendum 02, candidate #53, “Design-time output-field completeness”. Batch N13 batch 5. Target stage: Stage 3 design gate / Stage 4 reconciliation (proposed addition). Roles per frozen spec: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

## 2. Independent test plan: what I checked, and how

I checked the following from the packet only, without tools or attachments:

- Read the frozen SPEC, CONSTITUTION, PREFLIGHT, RUN LOG, C53_RESULTS.md, C53_arms.csv, raw per-arm files, ARM MANIFESTS, SEED DIFFS, and C53_EVIDENCE.sha256.
- Recomputed arithmetic identities from the reported counts:

  - decision-row totals;
  - ESCALATE / INCONCLUSIVE / STANDARD sums at kappa=2;
  - kappa-grid sums at kappa=1, 1.5, 2, 3;
  - T5a and T5b row-checked totals;
  - T1b+T1c and T2b+T2c row-checked totals;
  - FROZEN_RA total violations.
- Recomputed portfolio deltas and D-sets:

  - clean B baseline recon mismatch set;
  - new mismatch rows per seeded arm relative to clean B;
  - removed clean-B mismatch rows per seeded arm;
  - table-check violation counts per seeded arm.
- Checked cross-arm hash equalities from the manifests:

  - fixture results;
  - kappa grid counts;
  - portfolio counts;
  - classifications;
  - table-check outputs for B vs FROZEN_RB vs FROZEN_RA.
- Checked seed validity claims:

  - labels equal frozen;
  - portfolio grid and fixture results equal frozen;
  - classifications differ only where expected.
- Checked P1 conditions mechanically against the frozen predicate text.
- Looked for internal inconsistencies in the runner output and raw evidence.

## 3. Independently recomputed hard facts

### 3.1 Row, portfolio and grid identities

| Fact | Recomputed value | Evidence |
| --- | --- | --- |
| Classification rows checked by table | 222,002 | TABLE_CHECK.csv, all arms |
| kappa=2 n_decision | 222,002 | RB_portfolio_counts.csv |
| kappa=2 n_ESCALATE | 131,968 | RB_portfolio_counts.csv |
| kappa=2 n_INCONCLUSIVE | 6,377 | RB_portfolio_counts.csv |
| kappa=2 n_STANDARD | 83,657 | RB_portfolio_counts.csv |
| ESC+INC+STD at kappa=2 | 131,968 + 6,377 + 83,657 = 222,002 | arithmetic |
| kappa=2 n_out_of_set | 23,191 | RB_portfolio_counts.csv |
| implied total including out_of_set | 222,002 + 23,191 = 245,193 | arithmetic |
| kappa=1 sum | 152,292 + 6,377 + 63,333 = 222,002 | RB_kappa_grid_counts.csv |
| kappa=1.5 sum | 140,340 + 6,377 + 75,285 = 222,002 | RB_kappa_grid_counts.csv |
| kappa=2 sum | 131,968 + 6,377 + 83,657 = 222,002 | RB_kappa_grid_counts.csv |
| kappa=3 sum | 118,246 + 6,377 + 97,379 = 222,002 | RB_kappa_grid_counts.csv |
| T5a rows_checked | 131,968 + 83,657 = 215,625 | TABLE_CHECK.csv |
| T5b rows_checked | 6,377 | TABLE_CHECK.csv |
| T5a + T5b | 215,625 + 6,377 = 222,002 | arithmetic |
| B T1b+T1c rows_checked | 222,001 + 1 = 222,002 | TABLE_CHECK.csv |
| B T2b+T2c rows_checked | 222,000 + 2 = 222,002 | TABLE_CHECK.csv |
| FROZEN_RA total violations | 1 + 2 + 215,625 = 215,628 | TABLE_RESULT.txt / TABLE_CHECK.csv |
| FROZEN_RB total violations | 0 | TABLE_RESULT.txt |
| B table violations | 0 | TABLE_RESULT.txt |

### 3.2 Baseline recon D-sets

Clean B baseline recon vs frozen R-A:

| field | mismatches | IDs |
| --- | --- | --- |
| only_ra | 0 | NA |
| only_rb | 0 | NA |
| classification | 0 | NA |
| dormant_h | 1 | SR22-01936870 |
| open_age_h | 2 | SR25-02017553, SR25-02017556 |
| peer_n | 0 | NA |
| peer_p75_h | 0 | NA |

Clean B baseline mismatch set size = 3 rows, exactly the N1 / OF-1 rows disclosed in the coordinator note and SPEC.

### 3.3 Seeded-arm D-sets and deltas

| Arm | Table violations | cells_violated | New recon mismatches vs clean B | New mismatch fields | Clean mismatches removed | Baseline outcome |
| --- | --- | --- | --- | --- | --- | --- |
| U_DORMINC | 6,377 | T1a | TRUE | dormant_h:+6377 | none | surfaces as new R-A/R-B mismatch; needs owner ruling |
| U_P75THIN | 62 | T4 | TRUE | peer_p75_h:+62 | none | surfaces as new R-A/R-B mismatch; needs owner ruling |
| U_PEERNBLANK | 6,315 | T3 | TRUE | peer_n:+6315 | none | surfaces as new R-A/R-B mismatch; needs owner ruling |
| U_CLOCKLATE | 3 | T1c/T2c | FALSE | none | dormant_h:-1, open_age_h:-2 | escapes; removes the 3 N1 mismatches |

Recomputed D-set arithmetic:

- U_DORMINC dormant_h mismatches = 6,378 total. Clean B dormant_h = 1. New = 6,378 − 1 = 6,377. Table T1a = 6,377. Consistent.
- U_P75THIN peer_p75_h mismatches = 62. Clean B peer_p75_h = 0. New = 62. Table T4 = 62. Consistent.
- U_PEERNBLANK peer_n mismatches = 6,315. Clean B peer_n = 0. New = 6,315. Table T3 = 6,315. Consistent.
- U_CLOCKLATE dormant_h = 0 and open_age_h = 0. Clean B had dormant_h = 1 and open_age_h = 2. Removed = 3. Table T1c/T2c = 1 + 2 = 3. Consistent.
- FROZEN_RA table violations = T1c 1 + T2c 2 + T5a 215,625 = 215,628. Consistent.
- FROZEN_RB table violations = 0. Consistent with clean arm B = 0.

### 3.4 Cross-arm hash equalities

From ARM MANIFESTS:

| Output | B | U_DORMINC | U_P75THIN | U_PEERNBLANK | U_CLOCKLATE | Frozen R-B |
| --- | --- | --- | --- | --- | --- | --- |
| RB_fixture_results.csv | 0d72245c... | 0d72245c... | 0d72245c... | 0d72245c... | 0d72245c... | 0d72245c... |
| RB_kappa_grid_counts.csv | 7a18fcb1... | 7a18fcb1... | 7a18fcb1... | 7a18fcb1... | 7a18fcb1... | 7a18fcb1... |
| RB_portfolio_counts.csv | eb677bc1... | eb677bc1... | eb677bc1... | eb677bc1... | eb677bc1... | eb677bc1... |
| RB_classifications.csv | a0e42b86... | f2959ab6... | 44ad3b59... | 12f8a852... | f490a0e6... | a0e42b86... |

Additional equalities:

- B TABLE_CHECK.csv = FROZEN_RB TABLE_CHECK.csv = `96f2b67011fdf79d0bbd23cab572ef3f4d58534def280aff79975f2c027e9f08`.
- B TABLE_RESULT.txt = FROZEN_RB TABLE_RESULT.txt = `a011210390b377ae7a5e5e9cb927c088a0145e29446582f8b037c117573bea24`.
- FROZEN_RA TABLE_CHECK.csv = `14c86c6fc7737a466c1565cfebf8ab63ca0c077726c10bd5c6b5dff07b45a720`.
- FROZEN_RA TABLE_RESULT.txt = `89ac00e59198a6f7261d90d5293843f1cee456553e9d6773d9618140937cdb3e`.
- All seeded arms share the same frozen fixture, kappa-grid and portfolio hashes as B and frozen R-B. This matches seed-validity condition 4.

### 3.5 Internal inconsistencies flagged

I found no arithmetic inconsistency in the runner output. The reported counts, deltas, D-sets, and hash equalities are internally consistent.

Two non-blocking observations:

1. The R-B stderr in every arm contains the warning: “The following named parsers don't match the column names: created_ts, mod_ts, closed_ts, CREATED_DATE, LAST_MODIFIED_DATE, CLOSED_DATE”. This warning is present for clean B as well as seeded arms, does not cause a non-zero exit, and does not change the frozen-output hashes for B. It is therefore a non-blocking harness observation, not a defect that blocks a verdict.
2. U_P75THIN seeds blank `peer_p75_h` for thin types in the classifications output, but the fixture row SYN-F06 has `peer_n=8` and `peer_p75_h=96` unchanged. This is consistent with the frozen requirement that fixture results equal the frozen R-B fixture results and that seeds touch table cells in the classifications output, not the locked fixture suite. It is a boundary to note, not an arithmetic inconsistency.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the packet alone:

- The actual per-row content of `data/source/src_open_candidates.csv` and `data/source/src_peer_stats.csv` is not included; only hashes and summary outputs are present. Therefore I cannot recompute the exact 6,377 / 62 / 6,315 / 3 row sets from raw source.
- The exact per-row classifications in `RA_classifications.csv` and `RB_classifications.csv` are not included, only hashes and summaries. I cannot recompute the full classification table cell by cell.
- The SHA-256 values themselves cannot be independently verified without the underlying files; I can only compare reported hashes across the packet.
- The exact source-text parsing and expected-clock recomputation inside `table_check.R` cannot be re-executed from the packet because the source CSV content is absent.
- The exact content of `OWNER_RULINGS_BATCH_01.md`, its appendix table, and the owner rulings file cannot be verified beyond the quoted hash and the SPEC’s description.
- The exact content of `CONSTITUTION_v1.md` and the baseline framework documents cannot be verified beyond the quoted hashes.
- The scratch preflight outcome is reported but cannot be independently reproduced from this packet.
- The internal code of `run_batch_v5.ps1` and `eval_b5.R` is not included, so I cannot independently audit the predicate application beyond the reported results and seed diffs.
- The R build’s timezone behavior is attested by the table-check self-test and the exit-0 runs, but the self-test source and environment cannot be independently re-run from the packet.

## 5. P1 assessment against the frozen predicate

The frozen P1 predicate has four conditions. Using the reported evidence:

| P1 condition | Evidence | Assessment |
| --- | --- | --- |
| 1. variant: every seeded arm is flagged by the table check; 0 rulings needed, 0 escapes | U_DORMINC: 6,377 T1a; U_P75THIN: 62 T4; U_PEERNBLANK: 6,315 T3; U_CLOCKLATE: 3 T1c/T2c. All four seeded arms have non-zero table violations and variant_outcome = “table check flags an R-B defect: no ruling needed”. | MET |
| 2. baseline: at least one seeded arm cannot be settled without the table | U_DORMINC, U_P75THIN and U_PEERNBLANK surface as new R-A/R-B mismatches needing an owner ruling; U_CLOCKLATE escapes by removing the 3 N1 mismatches. At least one seeded arm cannot be settled without the table. | MET |
| 3. no new defect: clean arm B has 0 table violations and its 4 R-B key outputs equal the frozen hashes | B table_violations = 0. B RB_classifications = a0e42b86…, RB_fixture_results = 0d72245c…, RB_portfolio_counts = eb677bc1…, RB_kappa_grid_counts = 7a18fcb1…, all equal to the frozen R-B hashes. | MET |
| 4. seed validity: every seeded arm’s labels, portfolio counts, kappa grid and fixture results equal the frozen R-B ones | All seeded arms have labels_equal_frozen = TRUE and portfolio_grid_fixtures_equal_frozen = TRUE. Classifications differ as expected for table-cell seeds. | MET |

Mechanical predicate result reported by the runner: **P1 MET**. My independent recomputation of the hard facts is consistent with that mechanical result. I am not returning a terminal state.

## 6. Blocking objections

None. I found no defect in the harness, seed, predicate application or evidence that should block a verdict on the frozen record as presented.

Non-blocking observations are listed in §3.5; they do not meet the threshold for a blocking objection.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Ablation ID is C53; roles are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok | SPEC header and roles line |
| Frozen preflight gating passed | PREFLIGHT section: all frozen and seed lines OK; preflight gating result PASS |
| All reporting runs exited 0 with no timeouts | RUN LOG; C53_arms.csv; per-arm RUN_*.exit files |
| Clean arm B has 0 table violations | arms/B/outputs/table/TABLE_RESULT.txt; C53_RESULTS.md |
| Clean arm B’s 4 R-B key outputs equal frozen hashes | ARM MANIFESTS: B classifications a0e42…, fixture 0d722…, portfolio eb677…, kappa 7a18… |
| FROZEN_RB table check equals B table check | ARM MANIFESTS: both TABLE_CHECK.csv = 96f2b670…; both TABLE_RESULT.txt = a0112103… |
| FROZEN_RA table check is INFO and differs | FROZEN_RA TABLE_RESULT.txt: total_violations=215628, cells T1c|T2c|T5a, evidence_reason_column=FALSE |
| U_DORMINC flags 6,377 T1a violations | arms/U_DORMINC/outputs/table/TABLE_RESULT.txt; TABLE_CHECK.csv |
| U_P75THIN flags 62 T4 violations | arms/U_P75THIN/outputs/table/TABLE_RESULT.txt; TABLE_CHECK.csv |
| U_PEERNBLANK flags 6,315 T3 violations | arms/U_PEERNBLANK/outputs/table/TABLE_RESULT.txt; TABLE_CHECK.csv |
| U_CLOCKLATE flags 3 T1c/T2c violations | arms/U_CLOCKLATE/outputs/table/TABLE_RESULT.txt; TABLE_CHECK.csv |
| Clean B baseline recon has exactly the 3 N1 rows | arms/B/outputs/recon/RECON_BASE.csv; RECON_IDS.csv |
| U_DORMINC new mismatches = 6,377 dormant_h | arms/U_DORMINC/outputs/recon/RECON_BASE.csv; C53_arms.csv |
| U_P75THIN new mismatches = 62 peer_p75_h | arms/U_P75THIN/outputs/recon/RECON_BASE.csv; C53_arms.csv |
| U_PEERNBLANK new mismatches = 6,315 peer_n | arms/U_PEERNBLANK/outputs/recon/RECON_BASE.csv; C53_arms.csv |
| U_CLOCKLATE removes the 3 N1 mismatches and escapes baseline | arms/U_CLOCKLATE/outputs/recon/RECON_BASE.csv; C53_arms.csv |
| Seed validity holds for all seeded arms | C53_RESULTS.md; C53_arms.csv: labels_equal_frozen TRUE, portfolio_grid_fixtures_equal_frozen TRUE for all seeded arms |
| P1 condition 1 is met | All four seeded arms have non-zero table violations and variant_outcome flags them |
| P1 condition 2 is met | Three seeds surface, one escapes; at least one cannot be settled without the table |
| P1 condition 3 is met | B has 0 table violations and all four key output hashes equal frozen |
| P1 condition 4 is met | All seeded arms’ labels, portfolio, kappa grid and fixture results equal frozen R-B |
| No blocking harness/seed/predicate defect found | Arithmetic, D-set, hash and seed-validity checks are internally consistent; non-blocking observations only |

END C53 VALIDATOR REPORT
