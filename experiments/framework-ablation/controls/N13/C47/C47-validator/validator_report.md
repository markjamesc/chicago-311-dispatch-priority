1. Role attestation and ablation ID.  
   I am DeepSeek, acting as Validator for this ablation. I attest that I have not seen the Builder output, have not asked for it, and am using only the packet in this message. Ablation ID: C47 (Addendum 02, candidate #47). Batch: N13 batch 5. Frozen spec timestamp: 2026-10-03 10:28 CDT, before the reporting run. Roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I return no terminal state.
2. Independent test plan: what I checked, and how.

- Checked role separation and frozen IDs against SPEC, constitution, and preflight.
- Checked preflight PASS and the frozen/seed hash lines against the SPEC reference hashes.
- Reconstructed each arm’s ESCALATE counts from the per-arm DOM_TABLE.csv files and compared them to DOM_RESULT.csv `n_escalate_total`.
- Recomputed share, eligibility, flag, and status from the frozen `dom_check.R` logic: total ESCALATE ≥ 1000; eligible type has ≥30 ESCALATE rows; FLAG if eligible and share > 1/3.
- Compared flagged-type sets against P1 conditions.
- Checked before/after input hashes for every arm and real-input equality to frozen classification hashes.
- Checked cross-arm hash equality, especially REAL_RB vs REAL_RA DOM_TABLE.csv.
- Checked exit codes, stderr emptiness, and manifest hashes/sizes.
- Checked N1 disclosure against C47’s label-only counting.
- Checked internal consistency among C47_RESULTS.md, C47_arms.csv, per-arm DOM_RESULT.csv, DOM_TABLE.csv, INPUT_HASH files, RUN_DOM.exit, and manifests.

3. Independently recomputed hard facts.

Frozen identity/hash checks:

- Preflight reports `R-A/outputs/RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`; matches SPEC and REAL_RA INPUT_HASH before/after.
- Preflight reports `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`; matches SPEC and REAL_RB INPUT_HASH before/after.
- Seed hashes in preflight match SEEDS_b5 reference hashes for `ARMS.tsv`, `DOMCHK`, `SYN_BAL.csv`, `SYN_DOM60.csv`, `SYN_SMALLN.csv`, `dom_check.R`, `run_batch_v5.ps1`, `eval_b5.R`.
- Constitution hash in SPEC and preflight matches `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`.
- Owner rulings file hash in SPEC matches `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba`.

Arm-level recomputation:

| arm | n_rows | recomputed sum of DOM_TABLE n_escalate | DOM_RESULT n_escalate_total | top_type | top_n | recomputed top_share | recomputed flagged set | status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| REAL_RB | 222002 | 131968 | 131968 | WCA2 | 64922 | 64922/131968 = 0.4919525945683802 | {WCA2} | FLAG |
| REAL_RA | 222002 | 131968 | 131968 | WCA2 | 64922 | 64922/131968 = 0.4919525945683802 | {WCA2} | FLAG |
| SEED_DOM60 | 13000 | 10000 | 10000 | T01 | 6000 | 6000/10000 = 0.600000 | {T01} | FLAG |
| CLEAN_BAL | 13000 | 10000 | 10000 | T01 | 1900 | 1900/10000 = 0.190000 | ∅ | NO_FLAG |
| SMALL_N | 1200 | 900 | 900 | T01 | 540 | 540/900 = 0.600000 | ∅ | NOT_APPLICABLE_BELOW_MIN_TOTAL |

Eligibility recomputation:

- REAL: 81 types total; 54 types have n_escalate ≥ 30; WCA2 is the only eligible type with share > 1/3.
- SEED_DOM60: 10 types total; all 10 have n_escalate ≥ 30; T01 is the only type with share > 1/3.
- CLEAN_BAL: 10 types total; all 10 have n_escalate ≥ 30; no type has share > 1/3.
- SMALL_N: total ESCALATE = 900 < 1000, so the check does not apply; DOM_TABLE marks all `eligible = FALSE`, consistent with `dom_check.R`.

Synthetic n_rows identities from seed summaries:

- SEED_DOM60: T01 6000 ESCALATE + 300 STANDARD; T02–T09 8×445 ESCALATE + 8×300 STANDARD; T10 440 ESCALATE + 300 STANDARD. Total rows = 13000.
- CLEAN_BAL: ESCALATE counts 1900+1500+1200+1100+1000+900+800+700+500+400 = 10000; plus 10×300 STANDARD = 3000; total rows = 13000.
- SMALL_N: ESCALATE counts 540 + 9×40 = 900; plus 10×30 STANDARD = 300; total rows = 1200.

Cross-arm hash equalities:

- REAL_RB and REAL_RA DOM_TABLE.csv both have SHA-256 `b5a46c63d017be7e8a19162e3fafaac6bdde9082ebd828725bab539eda83a182` and size 3330 bytes. The two tables are identical.
- REAL_RB and REAL_RA DOM_RESULT.csv differ in `input` basename and therefore file hash; this is expected and does not violate P1 condition 4, which requires identical DOM_TABLE.csv.
- SEED_DOM60 DOM_TABLE.csv SHA-256 `04f12e81e239654053c0c2d3bfc3b9856317520543166eacc1b1f2fab94febd0`; matches C47_arms.csv truncated hash `04f12e81e2396540` and manifest.
- CLEAN_BAL DOM_TABLE.csv SHA-256 `c413e66b0bca12cc0ac0fd2d17e6c88072f87f7524ff6f2f591c107063123f52`; matches C47_arms.csv truncated hash `c413e66b0bca12cc` and manifest.
- SMALL_N DOM_TABLE.csv SHA-256 `d579d57c895cab605040bc2f8f251c78b295efd3cc16f1fb8b778761aefd5b4e`; matches C47_arms.csv truncated hash `d579d57c895cab60` and manifest.
- Every arm’s INPUT_HASH_before.txt equals its INPUT_HASH_after.txt.
- `dom_check.R` SHA-256 `582cb7822b44ef187282c981fbd7efa1d4dea8cec9014878e2b98a92a4355145` appears in every arm input manifest and in preflight.
- Every arm RUN_DOM.stderr.txt has SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`, the empty-file hash.
- Every RUN_DOM.exit shows exit `0`; timestamps and durations match the run log.

D-sets / flagged sets:

- REAL_RB: {WCA2}
- REAL_RA: {WCA2}
- SEED_DOM60: {T01}
- CLEAN_BAL: ∅
- SMALL_N: ∅

Portfolio deltas:

- No portfolio-count deltas are part of C47 evidence. The only real-data totals are decision set `222002` and ESCALATE `131968`, both matching the SPEC.

Internal inconsistency check:

- No internal inconsistency found among the provided runner outputs.
- C47_RESULTS.md arm table matches C47_arms.csv for the listed fields.
- DOM_RESULT top_share rounded to six decimals matches the full-precision DOM_TABLE shares.
- REAL_RB/REAL_RA DOM_RESULT files differ only by input basename and file hash; DOM_TABLE files are identical. This is expected.
- Run log timestamps and RUN_DOM.exit timestamps are consistent.

4. Facts that cannot be recomputed from this packet.

- Full SHA-256 preimages cannot be recomputed from excerpts alone; I can only check provided hashes for equality and truncation consistency.
- Full row-level real classifications and all labels are not present; I cannot independently verify every label agreement between R-A and R-B, only the ESCALATE type counts and the packet’s N1 statement.
- REAL `n_rows = 222002` cannot be recomputed from DOM_TABLE alone; it is taken from DOM_RESULT and matches SPEC.
- The N1 repeated-hour clock rows and their exact timestamps/labels are not independently verifiable from this packet beyond the disclosure.
- `make_seeds_b5.py` is not included in this packet, so seed-generation logic cannot be independently inspected beyond seed summaries and hashes.
- `eval_b5.R` is not included in this packet, so the full mechanical predicate application code cannot be inspected beyond `dom_check.R` and the reported outputs.
- Full stdout/stderr contents are not included; only hashes, sizes, exit files, and summaries are available.
- No portfolio-count files for C47 are used or included; portfolio deltas are not recomputable for this control.

5. P1 assessment against the frozen predicate in the SPEC. Facts only, no terminal state.

- Condition 1: SEED_DOM60 status FLAG with flagged types exactly T01. Evidence: DOM_RESULT status `FLAG`, `flagged_types = T01`; DOM_TABLE shows T01 6000/10000 = 0.6, eligible TRUE, flag TRUE, and all other types flag FALSE. Supported.
- Condition 2: CLEAN_BAL status NO_FLAG. Evidence: DOM_RESULT status `NO_FLAG`; DOM_TABLE max T01 = 1900/10000 = 0.19, below 1/3; no flags. Supported.
- Condition 3: SMALL_N status NOT_APPLICABLE_BELOW_MIN_TOTAL. Evidence: DOM_RESULT status `NOT_APPLICABLE_BELOW_MIN_TOTAL`; total ESCALATE = 900 < 1000. Supported.
- Condition 4: REAL_RB and REAL_RA both FLAG exactly WCA2 with identical DOM_TABLE.csv. Evidence: both DOM_RESULT status `FLAG`, `flagged_types = WCA2`; both DOM_TABLE SHA-256 `b5a46c63d017be7e8a19162e3fafaac6bdde9082ebd828725bab539eda83a182`; recomputed WCA2 share = 64922/131968 = 0.4919525945683802 > 1/3; no other type flagged. Supported.
- Condition 5: no change to any locked result; every input hash unchanged across the check; real inputs equal frozen hashes. Evidence: every INPUT_HASH_before equals INPUT_HASH_after; REAL_RB matches `a0e42b8667b38baf...`, REAL_RA matches `c099e092feb237c8...`; seed hashes match preflight/SEEDS_b5; routing says report only, result unchanged, nothing dropped. Supported.
- The runner reports `P1 MET`. My independent recomputation from the provided evidence is consistent with all five P1 conditions having supporting facts.

6. Blocking objections.  
   None supported by this packet. N1/OF-1 is disclosed and cannot change any C47 number because C47 counts labels only, and the packet states the three N1 rows carry the same label on both paths. The scratch preflight is disclosed; no evidence in the packet shows any post-check change to arms, thresholds, seeds, or predicate.
7. Claim → evidence map.

| Claim | Evidence |
| --- | --- |
| Role separation is valid | SPEC roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; Validator attestation above. |
| Frozen real inputs were used | Preflight `frozen OK` lines for RA/RB classifications; REAL_RA/REAL_RB INPUT_HASH before/after match `c099e092...` and `a0e42b8667...`. |
| SEED_DOM60 flags T01 only | DOM_RESULT status FLAG, flagged_types T01; DOM_TABLE T01 6000/10000 = 0.6, others flag FALSE. |
| CLEAN_BAL does not flag | DOM_RESULT status NO_FLAG; DOM_TABLE max T01 = 0.19, no flags. |
| SMALL_N below minimum | DOM_RESULT status NOT_APPLICABLE_BELOW_MIN_TOTAL; n_escalate_total 900 < 1000. |
| REAL_RB and REAL_RA both flag WCA2 | DOM_RESULT both FLAG, flagged_types WCA2; DOM_TABLE both show WCA2 64922/131968 = 0.4919525945683802. |
| REAL_RB and REAL_RA DOM_TABLE identical | Both DOM_TABLE SHA-256 `b5a46c63d017be7e8a19162e3fafaac6bdde9082ebd828725bab539eda83a182`. |
| No input changed across check | Every INPUT_HASH_before equals INPUT_HASH_after; real inputs equal frozen hashes. |
| No row dropped or changed | Routing text states report only, result unchanged, nothing dropped; statuses only flag/route. |
| N1 cannot affect C47 | N1 note says three rows have same label on both paths; C47 counts labels only. |
| P1 conditions 1–5 are supported | Recomputed arm tables, DOM_RESULTs, DOM_TABLEs, input hashes, and cross-arm hash equality above. |

END C47 VALIDATOR REPORT
