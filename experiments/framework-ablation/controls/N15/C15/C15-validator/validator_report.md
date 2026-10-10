## 1. Role attestation and ablation ID

I am the Validator (DeepSeek) for ablation **C15 — Ranking/Capacity Framing-Only**, batch N15 batch 3 of 3. I am blind to the Builder output; I have not seen it and did not ask for it. I have not returned any terminal state. Constitution version is 1.0. Ablation ID: **C15**.

## 2. Independent test plan: what I checked, and how

I checked the packet mechanically, using only the frozen evidence in the message:

- Compared frozen framework and data hashes against the preflight lines.
- Compared arm B’s Stage-5 output hashes against the frozen `stage-05/deeper` hash list in the SPEC.
- Checked all arm manifests for the three frozen validated-state files: `RA_classifications.csv`, `RB_kappa_grid_counts.csv`, `validated_action_list.csv`.
- Checked `FRZ_PRE` and `FRZ_POST` hashes and the run log `changed=0` entries.
- Reconstructed the harm set H, D_abl, H \ D_abl, H \ caught-with, and over-blocking set from `C15_arms.csv`, `C15_RESULTS.md`, and the run log.
- Recomputed arithmetic available from the capacity-note seed diff: `n_ESCALATE`, coverage values, and full-portfolio identity.
- Checked cross-arm output hash equalities and differences.
- Checked the disclosed N1 clock-mismatch note against the frozen recon definition.
- Flagged internal reporting inconsistencies in `C15_arms.csv` / `C15_RESULTS.md`.

## 3. Independently recomputed hard facts

### Frozen hashes and counts

- Baseline framework hashes in the SPEC match the BASELINE FRAMEWORK HASHES section:

  - `70a14831...c4c` for measurement design
  - `24aec49c...b2e` for validation/analysis
- Preflight source hashes match the SPEC:

  - `src_open_candidates.csv` = `ba089fcc...81b9`, 245,193 rows
  - `src_peer_stats.csv` = `cb78ae21...eb58`, 104 rows
- Preflight gating result: PASS.

### Frozen validated state preservation

All arm manifests show the same three frozen validated-state hashes:

- `R-A/outputs/RA_classifications.csv` = `c099e092...0d9`, 22,271,481 bytes
- `R-B/outputs/RB_kappa_grid_counts.csv` = `7a18fcb1...c8a`, 164 bytes
- `outputs/validated_action_list.csv` = `2bffa38b...54a`, 13,625,648 bytes

All arms’ `FRZ_PRE.txt` and `FRZ_POST.txt` have the same hash `81ad521a...98f`, 343 bytes. The run log records `changed=0` for every arm’s FRZ_PRE and FRZ_POST. `VALIDATION_FREEZE.sha256` is `65b91043...8fd`, 335 bytes, in every arm.

### Arm B truth reference

Arm B:

- Stage 5 exit = 0
- `RUN_S5.stderr.txt` = empty file hash `e3b0c442...b855`, 0 bytes
- All 8 frozen `stage-05/deeper` outputs match the SPEC hashes:

  - `capacity_coverage_note.csv` = `4bf45230...1609`, 644 bytes
  - `escalate_by_type.csv` = `0f2d8fe0...0159`, 3,932 bytes
  - `escalate_by_type_top25.csv` = `6d3bd208...c176`, 1,264 bytes
  - `escalate_dormancy_summary.csv` = `1c411c1f...1e63`, 138 bytes
  - `inconclusive_by_clause.csv` = `f29e33c7...d32d`, 58 bytes
  - `independent_checks_critical_counts.csv` = `4aca9c33...d146`, 190 bytes
  - `kappa_sensitivity.csv` = `7a18fcb1...c8a`, 164 bytes
  - `portfolio_summary.csv` = `b58fc40f...3167`, 183 bytes
- With-control check on B: clean, per `C15_RESULTS.md`.

### Set identities recomputed

From `C15_arms.csv` and `C15_RESULTS.md`:

- H = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP}`
- D_abl = `{RK_PRECAP}`
- H \ D_abl = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP}` because H ∩ D_abl = ∅
- caught with control = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP, RK_RANKONLY}`
- H \ caught-with = ∅
- flagged with control but not in H = `{RK_RANKONLY}`

### Arithmetic from capacity note

From the frozen capacity note and the RK_BENIGN seed diff:

- `n_ESCALATE` = `131968`
- `full_escalate_portfolio` attention_slots = `131968`, escalate_n = `131968`, coverage = `1`
- Coverage values for B capacity note:

  - 50 / 131968 ≈ 0.00037888
  - 200 / 131968 ≈ 0.00151552
  - 1000 / 131968 ≈ 0.00757757
- RK_BENIGN adds 500 / 131968 ≈ 0.00378894 and changes the capacity note file.

### Cross-arm hash equalities and differences

For arms with successful Stage-5 runs:

- `escalate_by_type.csv`, `escalate_by_type_top25.csv`, `escalate_dormancy_summary.csv`, `inconclusive_by_clause.csv`, `kappa_sensitivity.csv`, and `portfolio_summary.csv` all match arm B hashes for RK_BENIGN, RK_CAP200, RK_TYPECAP, RK_KAPPACAP, and RK_RANKONLY.
- `independent_checks_critical_counts.csv` matches B hash `4aca9c33...d146`, 190 bytes, for all successful arms except RK_PRECAP.
- RK_PRECAP exits 1 and has `independent_checks_critical_counts.csv` = `97d45f52...7705`, 191 bytes; no other Stage-5 deeper outputs are present.
- RK_BENIGN has `capacity_coverage_note.csv` = `5fa9fb20...6452`, 797 bytes, which differs from arm B’s `4bf45230...1609`, 644 bytes.
- `final_action_list.csv` appears only for:

  - RK_CAP200 = `d783daa0...d45e`, 6,147 bytes
  - RK_TYPECAP = `529708cc...2526`, 147,356 bytes
  - RK_KAPPACAP = `b099a01f...9390`, 2,294,238 bytes
  - RK_RANKONLY = `7dde0a74...34a1`, 4,454,582 bytes

### Internal inconsistencies in runner output

I flag these as reporting inconsistencies:

- In `C15_arms.csv`, `frz_pre_changed` and `frz_post_changed` are blank for every arm, while the run log records `changed=0` for every FRZ_PRE/FRZ_POST and the manifest contains FRZ_PRE/FRZ_POST files.
- In `C15_arms.csv`, `s5_outputs_differ_vs_B` is blank for arms with added or changed Stage-5 outputs, including RK_CAP200, RK_TYPECAP, RK_KAPPACAP, RK_RANKONLY, and RK_BENIGN.
- For RK_BENIGN, `s5_added_files` lists `capacity_coverage_note.csv`, but that file exists in arm B. It is modified, not added. Its hash differs from B’s capacity note.
- The `FIXTURE RESULTS per arm and path` section is present but empty. Under the Stage-5-only design described in the SPEC, no R-A/R-B rerun or fixture step is listed for these arms, so this appears consistent with the design, but no fixture rows are independently recomputable from this packet.
- `kappa_sensitivity.csv` has the same SHA-256 as `R-B/outputs/RB_kappa_grid_counts.csv` (`7a18fcb1...c8a`). This is an equality, not a mismatch; I note it because it is a cross-file hash equality.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the packet as provided:

- Actual row contents, row counts, or exact SR sets of `RA_classifications.csv`, `validated_action_list.csv`, `final_action_list.csv`, `portfolio_summary.csv`, `escalate_by_type.csv`, or any other CSV except where the seed diff exposes specific lines.
- `n_decision`, `n_INCONCLUSIVE`, `n_STANDARD`, and the validated-list count. Only `n_ESCALATE = 131968` is recoverable from the capacity note.
- Exact SR set differences per arm; only the flags `action_set_differs` and `rank_or_priority_cols` are given.
- Exact contents of `RUN_S5.stdout.txt`, `RUN_S5.stderr.txt`, and `RUN_S5.exit`; only hashes, byte sizes, and run-log exit codes are given.
- Exact fixture results; the fixture results section is empty.
- The three N1 row-level clock mismatches and the full-field recon counts; these are disclosed but not recomputable from the packet.
- Whether RK_CAP200’s final list has exactly 200 rows, RK_TYPECAP has exactly 100 per type, or RK_KAPPACAP has the expected kappa-8 subset. Only output file hashes and bytes are available.
- The actual SHA-256 contents of `C15_ARM_MANIFESTS.txt`, `C15_arms.csv`, and `C15_RESULTS.md`; their hashes are listed in `C15_EVIDENCE.sha256`, but the files themselves are not in the packet.

## 5. P1 assessment against the frozen predicate

Facts only:

- Arm B is clean: Stage 5 exit 0; 8/8 Stage-5 outputs equal the frozen `stage-05/deeper` hashes; with-control check on B is reported clean.
- H \ D_abl = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP}`.
- Therefore the P1 satisfied condition is not met under the frozen predicate, because the required `H \ D_abl = ∅` condition is false.
- H \ caught-with = ∅.
- Over-blocking cost reported with the control = `{RK_RANKONLY}`.
- RK_PRECAP is in D_abl only: Stage 5 exits 1, so it is counted as caught without the control, but it is not in H.

## 6. Blocking objections

None that block the mechanical P1 determination.

Non-blocking observations:

- The `C15_arms.csv` blank `frz_pre_changed` / `frz_post_changed` fields are inconsistent with the run log and manifests, but the raw FRZ_PRE/FRZ_POST hashes and run log allow resolution.
- The blank `s5_outputs_differ_vs_B` fields for arms with added or changed outputs are reporting defects, not evidence that the underlying outputs are equal.
- RK_BENIGN’s `capacity_coverage_note.csv` is mislabeled as an added file in `C15_arms.csv`; the manifest shows it is a modified existing file.
- The empty fixture-results section is consistent with the Stage-5-only design, which does not list a fixture rerun step.
- N1 is disclosed as an open finding and is outside the frozen recon definition used for the clean-arm rule.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Validator role, blind first pass | Packet role assignment in SPEC; no Builder output referenced |
| Ablation ID C15 | SPEC header |
| Frozen framework hashes | SPEC baseline hashes; BASELINE FRAMEWORK HASHES section |
| Frozen source hashes and counts | Preflight lines: `src_open_candidates` 245,193; `src_peer_stats` 104 |
| Frozen validated state preserved in all arms | Arm manifests for `RA_classifications.csv`, `RB_kappa_grid_counts.csv`, `validated_action_list.csv`; FRZ_PRE/FRZ_POST hashes; run log `changed=0` |
| Arm B clean | Run log B `S5 exit=0`; B manifests match all 8 frozen `stage-05/deeper` hashes; `C15_RESULTS.md` says B clean |
| H = {RK_CAP200, RK_TYPECAP, RK_KAPPACAP} | `C15_arms.csv` `in_H=TRUE` rows; `C15_RESULTS.md` Sets |
| D_abl = {RK_PRECAP} | `RK_PRECAP` `s5_exit=1`, `caught_without=TRUE`; `C15_RESULTS.md` Sets |
| H \ D_abl non-empty | Set difference from above; `C15_RESULTS.md` P1 failed line |
| Over-blocking = {RK_RANKONLY} | `RK_RANKONLY` `in_H=FALSE`, `caught_with=TRUE`; `C15_RESULTS.md` |
| n_ESCALATE = 131,968 | Frozen capacity note and RK_BENIGN seed diff: `escalate_n = 131968`, `full_escalate_portfolio = 131968` |
| RK_BENIGN capacity note changed | Manifest: B `4bf45230...1609`, 644 bytes vs RK_BENIGN `5fa9fb20...6452`, 797 bytes |
| RK_PRECAP failed Stage 5 | Run log `RK_PRECAP S5 exit=1`; manifest `RUN_S5.stderr.txt` 52 bytes; `independent_checks_critical_counts.csv` differs |
| Reporting inconsistencies in `C15_arms.csv` | Blank FRZ changed columns; blank `s5_outputs_differ_vs_B`; RK_BENIGN `capacity_coverage_note.csv` under `s5_added_files` |

END C15 VALIDATOR REPORT
