# C16 Validator Report

## 1. Role attestation and ablation ID

I am acting only as Validator for ablation **C16**. I am blind to the Builder and have not seen, requested, or used Builder output. Role assignment in the SPEC is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Constitution version: 1.0. I return no KEEP, REVERT, or HALT terminal state.

## 2. Independent test plan: what I checked and how

I checked the packet mechanically from the frozen evidence provided:

- Compared the SPEC, PREFLIGHT, RUNNER-SIDE FILES, and seed manifests for hash agreement.
- Recomputed fixture pass counts from the raw per-arm, per-path fixture rows.
- Recomputed the arm-level recon identities from the reported `n_only_ra`, `n_only_rb`, and `n_disagree` fields.
- Recomputed `locked_field_changes_vs_B` from the reported per-path `only_x`, `only_B`, `label`, `dormant`, and `open_age` differences.
- Recomputed the harm set `H`, the without-control caught set `D_abl`, `H \ D_abl`, and the no-locked-change set.
- Checked the seed diffs against the declared omissions for each seeded arm.
- Compared cross-arm output hashes from the ARM MANIFESTS for classification, fixture, portfolio, and kappa files.
- Checked the disclosed N1 full-field recon mismatch counts against the B recon table.

## 3. Independently recomputed hard facts

### 3.1 Frozen/preflight hash facts

- Preflight reports frozen OK for `src_open_candidates.csv` SHA-256 `ba089fcc...` and `src_peer_stats.csv` SHA-256 `cb78ae21...`, matching the SPEC.
- Preflight reports frozen OK for `R-A/run_RA.R` `f4e8993c...`, `R-B/R/00_config.R` `6c9b0e31...`, `R-B/R/20_integrity_and_classify.R` `72ac5def...`, and `R-B/R/40_fixtures.R` `2ad4aa69...`, matching the SPEC.
- All C16 seed hashes in PREFLIGHT match the RUNNER-SIDE FILES list and the declared seed hashes in the SPEC.

### 3.2 Arm B recomputation

- Run log shows B R-A exit=0 and B R-B exit=0.
- Raw fixture rows show B R-A 14/14 TRUE and B R-B 14/14 TRUE.
- B repro table:

  - B R-A vs frozen `RA_classifications`: `n_only_x=0`, `n_only_truth=0`, `n_label_diff=0`, `n_dormant_diff=0`, `n_open_age_diff=0`.
  - B R-B vs frozen `RB_classifications`: all five difference counts 0.
- B recon table:

  - `n_ra=222002`, `n_rb=222002`, `n_inner=222002`.
  - `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`.
  - `n_dormant_mismatch=1`, `n_open_age_mismatch=2`.
- Identity check: `n_ra = n_inner + n_only_ra = 222002 + 0 = 222002`; `n_rb = n_inner + n_only_rb = 222002 + 0 = 222002`. Key sets are identical and labels agree under the frozen recon definition.

### 3.3 Seeded arm recomputation

From `C16_arms.csv` and raw fixture rows:

| arm | exits | fixtures | recon only_ra / only_rb / disagree | locked changes vs B | harm | caught without control |
| --- | --- | --- | --- | --- | --- | --- |
| OM_LEGACY_CM | RA=0, RB=0 | RA 13/14 F08 fail; RB 13/14 F08 fail | 0 / 0 / 0 | 348 | TRUE | TRUE |
| OM_LEGACY_RB | RB=0 | RA 14/14; RB 13/14 F08 fail | 0 / 174 / 0 | 174 | TRUE | TRUE |
| OM_CLOCKS_CM | RA=0, RB=0 | RA 13/14 F05 fail; RB 14/14 | 0 / 0 / 0 | 0 | FALSE | TRUE |
| OM_BLANKTYPE_CM | RA=0, RB=0 | RA 14/14; RB 14/14 | 0 / 0 / 0 | 0 | FALSE | FALSE |
| OM_UNPARSE_CM | RA=0, RB=0 | RA 13/14 F13 fail; RB 14/14 | 0 / 0 / 0 | 0 | FALSE | TRUE |

- `OM_LEGACY_CM` locked changes: `only_x=174` on RA plus `only_x=174` on RB gives `174+174=348`.
- `OM_LEGACY_RB` locked changes: RB `only_x=174` gives 174.
- All other seeded arms have `locked_field_changes_vs_B=0`.
- Fixture failures recomputed from raw rows:

  - `OM_LEGACY_CM` F08: expected `OUT_OF_SET`, observed `ESCALATE`, FALSE on both RA and RB.
  - `OM_LEGACY_RB` F08: expected `OUT_OF_SET`, observed `ESCALATE`, FALSE on RB.
  - `OM_CLOCKS_CM` F05: expected `INCONCLUSIVE`, observed `STANDARD`, FALSE on RA.
  - `OM_UNPARSE_CM` F13: expected `INCONCLUSIVE`, observed `STANDARD`, FALSE on RA.

### 3.4 Recomputed D-sets

- Harm set `H`: `{OM_LEGACY_CM, OM_LEGACY_RB}`.
- Without-control caught set `D_abl`: `{OM_LEGACY_CM, OM_LEGACY_RB, OM_CLOCKS_CM, OM_UNPARSE_CM}`.
- `H \ D_abl`: `{}` — empty.
- `D_abl \ H`: `{OM_CLOCKS_CM, OM_UNPARSE_CM}`.
- Arms with no locked-field change: `{OM_CLOCKS_CM, OM_BLANKTYPE_CM, OM_UNPARSE_CM}`.
- `OM_BLANKTYPE_CM` is neither in `H` nor in `D_abl`.

### 3.5 Seed diff facts

The seed diffs match the declared omissions:

- `OM_LEGACY_CM`: removes `is_true_like(leg)` from R-A and `!leg_flag` from R-B.
- `OM_LEGACY_RB`: same R-B removal only.
- `OM_CLOCKS_CM`: removes clock-order and `created > T` clauses from both R-A and R-B.
- `OM_BLANKTYPE_CM`: removes blank `type_key` check from R-A and replaces `p_blank_type` with `rep(FALSE, n)` in R-B.
- `OM_UNPARSE_CM`: removes unparseable `CREATED_DATE` clause from both R-A and R-B.

### 3.6 Cross-arm output hash equalities from manifests

Key equalities/differences:

| output file | B | OM_LEGACY_CM | OM_LEGACY_RB | OM_CLOCKS_CM | OM_BLANKTYPE_CM | OM_UNPARSE_CM |
| --- | --- | --- | --- | --- | --- | --- |
| `RA_classifications.csv` | c099e092 | bd211ae8 | not run | c099e092 | c099e092 | c099e092 |
| `RB_classifications.csv` | a0e42b86 | 7f136975 | 7f136975 | a0e42b86 | a0e42b86 | a0e42b86 |
| `RA_fixture_results.csv` | 33696cd1 | bc197ec8 | not run | add3f80d | 33696cd1 | 2dfdec00 |
| `RB_fixture_results.csv` | 0d72245c | 515cb431 | 515cb431 | ad970c75 | 0d72245c | 126930d0 |
| `RA_portfolio_counts.csv` | b5888db2 | 0f0e7d5d | not run | b5888db2 | b5888db2 | b5888db2 |
| `RB_portfolio_counts.csv` | eb677bc1 | 4366ca29 | 4366ca29 | eb677bc1 | eb677bc1 | eb677bc1 |
| `RB_kappa_grid_counts.csv` | 7a18fcb1 | abde0565 | abde0565 | 7a18fcb1 | 7a18fcb1 | 7a18fcb1 |

### 3.7 Internal inconsistency flagged in runner output

There is an inconsistency between the raw fixture rows and the manifest hashes for `RB_fixture_results.csv`.

- B RB fixture rows are all TRUE, hash `0d72245c...`, bytes 1792.
- `OM_BLANKTYPE_CM` RB fixture rows are also all TRUE, but the manifest hash is still `0d72245c...`, bytes 1792, despite the raw rows showing `arm=OM_BLANKTYPE_CM`.
- `OM_CLOCKS_CM` RB fixture rows are all TRUE, but the manifest hash is `ad970c75...`, bytes 1814.
- `OM_UNPARSE_CM` RB fixture rows are all TRUE, but the manifest hash is `126930d0...`, bytes 1814.
- `OM_LEGACY_CM` and `OM_LEGACY_RB` have different arm labels but share the same `RB_fixture_results.csv` hash `515cb431...`, bytes 1869.

If the raw fixture file includes the `arm` column as displayed, then all-pass RB fixture files for different arms should not hash identically to B. If the file does not include the `arm` column, then the all-pass RB files for `OM_CLOCKS_CM` and `OM_UNPARSE_CM` should hash identically to B. Neither is consistently true. This prevents independent verification of cross-arm fixture hash equalities.

## 4. Facts that cannot be recomputed from this packet

- Numeric portfolio deltas: only portfolio count file hashes and bytes are provided, not contents.
- Exact row-level `SR_NUMBER` sets behind `only_x=174` for the legacy arms.
- Exact `dormant_h` and `open_age_h` values for the three N1 rows.
- The overlap between `DUPLICATE=true` and `LEGACY=true` needed to derive the B recon `n_ra=222002` from the data profile counts.
- Full stdout/stderr contents; only run-log exit lines and manifest hashes/bytes are present.
- Full contents of the output CSV files behind the listed SHA-256 hashes.
- Full contents of the frozen code beyond the provided diffs.
- The exact contents of `RUN_*.exit` files; the packet gives run-log exits and manifest hashes, but not the exit file text.

## 5. P1 assessment against the frozen predicate in the SPEC

Frozen predicate:

- P1 satisfied if `H ⊆ D_abl`.
- P1 failed if `H \ D_abl` is non-empty.
- Arms with no locked-field change are reported and do not count for or against P1.

Recomputed facts:

- `H = {OM_LEGACY_CM, OM_LEGACY_RB}`.
- `D_abl = {OM_LEGACY_CM, OM_LEGACY_RB, OM_CLOCKS_CM, OM_UNPARSE_CM}`.
- `H \ D_abl = {}`.
- `H ⊆ D_abl` is true on this evidence.
- Arms with no locked-field change: `{OM_CLOCKS_CM, OM_BLANKTYPE_CM, OM_UNPARSE_CM}`.
- `OM_BLANKTYPE_CM` is not in `H` and not in `D_abl`.

## 6. Blocking objections

- **Blocking objection:** The `RB_fixture_results.csv` manifest hashes are internally inconsistent with the displayed raw fixture rows and across arms. This affects required SHA-256-backed fixture evidence and prevents independent verification of cross-arm fixture hash equalities. See §3.7.
- The disclosed N1 full-field recon mismatches (`dormant_h=1`, `open_age_h=2`) are known and excluded from the frozen recon HALT definition. They are not, by themselves, a blocking objection under the packet as written.
- No other blocking objection is identified from the packet.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Preflight frozen source/code hashes match SPEC | PREFLIGHT lines; SPEC frozen hashes |
| All recorded runs exited 0 | RUN LOG; `C16_arms.csv` exit fields |
| Arm B fixtures are 14/14 on both paths | Raw FIXTURE RESULTS rows for B RA and B RB |
| Arm B reproduces frozen pack with 0 key/label/dormant/open_age differences vs frozen RA/RB | Arm B repro table |
| B recon is 0/0/0 under frozen definition | B recon table: `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0` |
| B full-field recon has dormant 1, open_age 2 | B recon table; COORDINATOR NOTE N1 |
| Harm set H = legacy arms | `C16_arms.csv`: `locked_field_changes_vs_B=348` for `OM_LEGACY_CM`; `=174` for `OM_LEGACY_RB`; 0 for others |
| D_abl = legacy + clocks + unparse | `C16_arms.csv`: `caught_without_control=TRUE` for `OM_LEGACY_CM`, `OM_LEGACY_RB`, `OM_CLOCKS_CM`, `OM_UNPARSE_CM` |
| `H \ D_abl` is empty | Recomputed from H and D_abl above |
| Arms with no locked-field change | `C16_arms.csv`: `OM_CLOCKS_CM`, `OM_BLANKTYPE_CM`, `OM_UNPARSE_CM` |
| Seed diffs match declared omissions | SEED DIFFS section |
| Cross-arm output hash equalities | ARM MANIFESTS section |
| `RB_fixture_results.csv` hash inconsistency | ARM MANIFESTS vs raw FIXTURE RESULTS rows |

END C16 VALIDATOR REPORT
