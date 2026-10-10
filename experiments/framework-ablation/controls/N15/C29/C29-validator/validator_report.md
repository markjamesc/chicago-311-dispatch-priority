# C29 VALIDATOR REPORT

## 1. Role attestation and ablation ID

I am DeepSeek, acting only as Validator for ablation **C29**. I am blind to the Builder and have not seen, requested, or used any Builder output. The frozen role assignment in the SPEC is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Constitution version 1.0. Ablation ID: **C29**, batch N15 batch 1 of 3, target Stage 4 handling of R-A/R-B mismatches. I do not return a terminal state.

## 2. Independent test plan

I checked the packet by:

- Comparing SPEC-frozen hashes against the preflight and ARM MANIFESTS for frameworks, frozen code, frozen classifications, seeds, and source files.
- Recomputing source row-count claims from the preflight MySQL summary.
- Checking run completeness, exit codes, and recorded run durations from the RUN LOG.
- Recomputing arm B fixture counts from the raw fixture rows.
- Recomputing arm B reproduction and reconciliation counts from the arm B recon table.
- Recomputing each seeded arm’s fixture failures, reconciliation deltas, locked-field changes, decision changes, harm flag, and input diff from `C29_arms.csv` and the fixture table.
- Recomputing the harm set H, mismatch-visible set, H-minus-mismatch-visible, no-locked-field-change set, and auto-resolution equality counts from `C29_RESULTS.md` and `C29_resolution.csv`.
- Checking the SEED DIFFS against the SPEC descriptions of the four seeded defects.
- Checking SHA-256 equalities and non-equalities for arm B and seeded arm outputs.
- Flagging places where the packet lacks row-level evidence needed to independently recompute an aggregate.

## 3. Independently recomputed hard facts

### Frozen input checks

- Baseline framework hashes in the packet match the SPEC:

  - `70a14831...600c4c` measurement framework.
  - `24aec49c...cdb2e` validation framework.
- Frozen source hashes match the SPEC and preflight:

  - `src_open_candidates.csv` `ba089fcc...d81b9`.
  - `src_peer_stats.csv` `cb78ae21...eb58`.
- Frozen code hashes match the SPEC and preflight:

  - `R-A/run_RA.R` `f4e8993c...8587`.
  - `R-B/R/00_config.R` `6c9b0e31...450b`.
  - `R-B/R/20_integrity_and_classify.R` `72ac5def...1d99`.
- Seed hashes match the SPEC and preflight:

  - `RA_NODUP__run_RA.R` `94aef544...1421`.
  - `RA_NOTHIN__run_RA.R` `65e90bf8...f98b`.
  - `RB_NODUP__20_integrity_and_classify.R` `4f1d8422...ec69`.
  - `RB_NOTHIN__20_integrity_and_classify.R` `487b769c...39ff`.
- Source row counts: preflight reports `src_open_candidates=245193`, `src_peer_stats=104`; this matches the SPEC row count for `src_open_candidates`.
- Source variants used: `(no source variants used)`, consistent with the SPEC allowed scope.

### Run completeness

- RUN LOG records six runs: B RA, B RB, X_RB_NODUP RB, X_RA_NODUP RA, X_RB_NOTHIN RB, X_RA_NOTHIN RA.
- All recorded exits are 0.
- Seeded arms with every run recorded: **4/4**. H3 is consistent.

### Arm B

- B RA exit=0, B RB exit=0.
- B fixtures: RA 14/14, RB 14/14. I recomputed this from the fixture rows.
- B reproduction vs frozen pack table:

  - B R-A vs frozen RA_classifications: only_x=0, only_truth=0, label_diff=0, dormant_diff=0, open_age_diff=0.
  - B R-B vs frozen RB_classifications: only_x=0, only_truth=0, label_diff=0, dormant_diff=0, open_age_diff=0.
- B output hashes match the preflight frozen classification hashes:

  - B RA `c099e092...ae0d9`.
  - B RB `a0e42b86...e193`.
- B recon table:

  - n_ra=222002, n_rb=222002, n_inner=222002.
  - only_ra=0, only_rb=0, disagree=0.
  - dormant_mismatch=1, open_age_mismatch=2.
- Internal inconsistency flagged: H2 states “B recon is 0/0/0: TRUE” and also states “B full-field recon mismatches: dormant_h 1, open_age_h 2.” The B recon table confirms `n_dormant_mismatch=1` and `n_open_age_mismatch=2`. If “0/0/0” means only key/label/disagree, then it is consistent with the table but ambiguous. If it means all reconciliation fields including dormant/open_age, it directly contradicts the table and the SPEC halt condition.

### Seeded arm recomputation

- **X_RB_NODUP**

  - Paths run: RB; exit RB=0.
  - Fixtures: RA 14/14; RB 13/14, F07 expected OUT_OF_SET, observed ESCALATE.
  - Recon: only_ra=0, only_rb=23012, disagree=0, dormant=1, open_age=2.
  - RA_vs_B: all zero. RB_vs_B: only_x=23012, only_B=0, label=0, dormant=0, open_age=0.
  - Locked_field_changes_vs_B=23012; decision_changes_vs_B=23012; harm=TRUE.
  - Input differing from B: `R-B\R\20_integrity_and_classify.R`.
- **X_RA_NODUP**

  - Paths run: RA; exit RA=0.
  - Fixtures: RA 13/14, F07 expected OUT_OF_SET, observed ESCALATE; RB 14/14.
  - Recon: only_ra=23012, only_rb=0, disagree=0, dormant=1, open_age=2.
  - RA_vs_B: only_x=23012, only_B=0, label=0, dormant=0, open_age=0. RB_vs_B: all zero.
  - Locked_field_changes_vs_B=23012; decision_changes_vs_B=23012; harm=TRUE.
  - Input differing from B: `R-A\run_RA.R`.
- **X_RB_NOTHIN**

  - Paths run: RB; exit RB=0.
  - Fixtures: RA 14/14; RB 13/14, F06 expected INCONCLUSIVE, observed ESCALATE.
  - Recon: only_ra=0, only_rb=0, disagree=6377, dormant=1, open_age=2.
  - RA_vs_B: all zero. RB_vs_B: only_x=0, only_B=0, label=6377, dormant=0, open_age=0.
  - Locked_field_changes_vs_B=6377; decision_changes_vs_B=6377; harm=TRUE.
  - Input differing from B: `R-B\R\20_integrity_and_classify.R`.
- **X_RA_NOTHIN**

  - Paths run: RA; exit RA=0.
  - Fixtures: RA 13/14, F06 expected INCONCLUSIVE, observed ESCALATE; RB 14/14.
  - Recon: only_ra=0, only_rb=0, disagree=6377, dormant=1, open_age=2.
  - RA_vs_B: only_x=0, only_B=0, label=6377, dormant=0, open_age=0. RB_vs_B: all zero.
  - Locked_field_changes_vs_B=6377; decision_changes_vs_B=6377; harm=TRUE.
  - Input differing from B: `R-A\run_RA.R`.

### D-sets and sets

- H4 harm set H = `{X_RB_NODUP, X_RA_NODUP, X_RB_NOTHIN, X_RA_NOTHIN}`. Recomputed from locked_field_changes_vs_B > 0 for all four.
- H5 mismatch-visible set = same four. Recomputed from fixture failure and/or recon key/label mismatch for each seeded arm.
- H6 H minus mismatch-visible = `{}`. Consistent.
- H7 arms with no locked-field change = `{}`. Consistent.
- H8 auto-resolution results equal to arm B: **4/12**. Recomputed from `equals_truth=TRUE` rows.
- H9 differing scenario × rule pairs: **8/12**:

  - X_RB_NODUP:copy_RB, X_RB_NODUP:max_severity
  - X_RA_NODUP:copy_RA, X_RA_NODUP:max_severity
  - X_RB_NOTHIN:copy_RB, X_RB_NOTHIN:max_severity
  - X_RA_NOTHIN:copy_RA, X_RA_NOTHIN:max_severity
- Auto-resolution equal-to-truth TRUE rows are exactly:

  - X_RB_NODUP:copy_RA
  - X_RA_NODUP:copy_RB
  - X_RB_NOTHIN:copy_RA
  - X_RA_NOTHIN:copy_RB

### Cross-arm hash equalities

- B outputs match frozen classifications:

  - B RA `c099e092...ae0d9` equals preflight frozen `RA_classifications.csv`.
  - B RB `a0e42b86...e193` equals preflight frozen `RB_classifications.csv`.
- Seeded run-path outputs do not equal the corresponding arm B output:

  - X_RA_NODUP RA output `eb28be6b...9e64` ≠ B RA `c099e092...ae0d9`.
  - X_RA_NOTHIN RA output `40c85fac...bfa5` ≠ B RA `c099e092...ae0d9`.
  - X_RB_NODUP RB output `ca411fca...8fab` ≠ B RB `a0e42b86...e193`.
  - X_RB_NOTHIN RB output `f6611d8d...19f8` ≠ B RB `a0e42b86...e193`.
- Non-run path outputs for seeded arms are not present in the seeded arm manifests. The packet states the non-run path is taken from arm B, and the runner’s `RA_vs_B`/`RB_vs_B` columns show zero for the non-run path, but this cannot be independently recomputed from the listed seeded arm manifests.

### Seed diffs

The four SEED DIFFS match the SPEC descriptions:

- RB_NODUP removes `!dup_flag` from `in_decision`.
- RA_NODUP removes `is_true_like(dup)` from `exclude`.
- RB_NOTHIN replaces `p_thin <- peer_n < RB_N_MIN` with `p_thin <- rep(FALSE, n)`.
- RA_NOTHIN replaces the thin-peer check with `check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")`.

### Other internal consistency checks

- Fixture failures match the seeded defects:

  - NODUP arms fail F07 on the seeded path.
  - NOTHIN arms fail F06 on the seeded path.
- The `caught_with_control` column is `NA` for all four seeded arms in `C29_arms.csv`. This does not allow independent recomputation of the control-regime catch status, although H5 says the mismatches are visible to the remaining checks.
- The `max_severity` rows for X_RB_NOTHIN and X_RA_NOTHIN report `n_label_diff=24`. This cannot be independently derived from the provided aggregate `recon_disagree=6377` without row-level label data. It is not necessarily inconsistent, because max-severity can resolve some disagreements in favor of the truth reference, but the packet does not contain the underlying rows.

## 4. Facts that cannot be recomputed from this packet

- The exact row-level key sets and label sets behind the 23012 and 6377 deltas.
- The identities of the `dormant_h 1` and `open_age_h 2` B recon mismatches.
- The derivation of `max_severity n_label_diff=24` for X_RB_NOTHIN and X_RA_NOTHIN.
- The non-run path outputs for each seeded arm, since seeded arm manifests contain only the path(s) that arm runs.
- Full stdout/stderr beyond the RUN LOG exit codes and timings.
- Raw reconciliation output files or row-level diff files; only aggregate CSV tables and runner summaries are present.
- The basis for `caught_with_control=NA` in `C29_arms.csv`.

## 5. P1 assessment against the frozen predicate in the SPEC

The frozen P1 predicate is: P1 satisfied iff every scenario × rule resolution (4 × 3 = 12) equals arm B on R-A labels, key set, and classification. P1 failed if at least one resolution differs from arm B.

From the provided evidence:

- Auto-resolution equal to arm B: **4/12**.
- Auto-resolution differing from arm B: **8/12**.
- The 8 differing pairs are all `max_severity` rows plus the wrong-side `copy_RA`/`copy_RB` rows:

  - X_RB_NODUP:copy_RB, X_RB_NODUP:max_severity
  - X_RA_NODUP:copy_RA, X_RA_NODUP:max_severity
  - X_RB_NOTHIN:copy_RB, X_RB_NOTHIN:max_severity
  - X_RA_NOTHIN:copy_RA, X_RA_NOTHIN:max_severity
- The harm set H contains all four seeded arms.
- The mismatch-visible set contains all four seeded arms.
- H minus mismatch-visible is empty; there are no hidden harmed arms in this packet.
- No seeded arm has zero locked-field change.

Therefore, on the frozen predicate as written, P1 is **not satisfied** by the provided evidence. I state this as a factual assessment only and do not return a terminal state.

## 6. Blocking objections

- **B recon inconsistency/ambiguity:** H2 states “B recon is 0/0/0: TRUE” while the same results section reports “B full-field recon mismatches: dormant_h 1, open_age_h 2.” The B recon table confirms `n_dormant_mismatch=1` and `n_open_age_mismatch=2`. Under the SPEC, if B recon is required to be 0/0/0 including dormant and open_age, this is a blocking defect. If 0/0/0 means only key/label/disagree, the text is ambiguous and prevents independent confirmation of the halt condition.
- **Missing row-level evidence for hard facts:** The packet provides aggregate tables and hashes but not raw reconciliation/diff outputs or row-level classification files. That prevents independent recomputation of the exact 23012/6377 D-sets, the B recon 1/2 mismatches, and the `max_severity n_label_diff=24` values. Constitution evidence requirements may make this a blocking gap.
- **Control-regime catch status missing:** `caught_with_control` is `NA` for all four seeded arms even though the column exists. The packet does not report the control-regime catch result independently.
- Otherwise, the seed diffs match the SPEC descriptions, the recorded exits are all 0, the fixture failures align with the seeded defects, and the auto-resolution equality counts recompute consistently from the provided tables.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Frozen framework hashes match SPEC | Packet baseline framework hashes vs SPEC hashes |
| Frozen source hashes and row counts match SPEC | Preflight lines; SPEC source hashes; MySQL summary 245193/104 |
| Frozen code hashes match SPEC | Preflight frozen OK lines; SPEC frozen code hashes |
| Seed hashes match SPEC | Preflight seed OK lines; SPEC seed hashes |
| Arm B exits 0 and fixtures 14/14 | RUN LOG; C29_RESULTS H1; fixture rows |
| Arm B reproduces frozen pack | B repro table all zeros; B output hashes `c099e092...` and `a0e42b86...` |
| B recon key/label/disagree are zero | B recon table: only_ra=0, only_rb=0, disagree=0 |
| B recon dormant/open_age are nonzero | B recon table: dormant=1, open_age=2; H2 full-field text |
| Seeded arms complete | RUN LOG; H3 4/4 |
| Harm set H is all four seeded arms | `C29_arms.csv` locked_field_changes_vs_B > 0 for all four |
| Mismatch-visible set is all four | Fixture failures F07/F06 and recon only/label mismatches |
| H minus mismatch-visible is empty | H4 and H5 identical; H6 `{}` |
| No seeded arm has zero locked-field change | H7 `{}`; arm table locked changes 23012/6377 |
| Auto-resolution equals arm B 4/12 | `C29_resolution.csv` equals_truth TRUE rows |
| Auto-resolution differs 8/12 | `C29_resolution.csv` equals_truth FALSE rows |
| Seed defects match SPEC | SEED DIFFS for NODUP and NOTHIN on RA/RB |
| Seeded outputs differ from B on run path | ARM MANIFESTS output hashes differ from B RA/RB hashes |
| P1 not satisfied on frozen predicate | 4/12 equal vs required 12/12 |
| Blocking objection on B recon | H2 “B recon is 0/0/0” vs B recon table dormant=1/open_age=2 |
| Row-level facts unavailable | No raw reconciliation/diff/classification row files in packet |

END C29 VALIDATOR REPORT
