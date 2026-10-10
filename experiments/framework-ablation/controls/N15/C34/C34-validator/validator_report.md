# C34 Validator — DeepSeek (INDEPENDENT FIRST PASS)

## 1. Role attestation and ablation ID

Role: Validator only, DeepThink on. I am blind to the Builder; I have not seen and must not ask for the Builder’s output. I do not return KEEP, REVERT, or HALT.

Ablation ID: C34 — Deterministic Workflow Gate, catalog #34. Batch N15 batch 2 of 3. Constitution version 1.0. Roles frozen as Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Frozen at CT 2026-10-03 before execution. Target stage: Stage 4→5 gate before interpretation. Control under test: deterministic workflow gate `validation/workflow-gate/workflow_gate.R`. Ablation: no workflow gate; Stage 5 runs on whatever Stage 4 produced, with its own built-in independent count checks.

## 2. Independent test plan: what I checked, and how

I checked the packet mechanically without using Builder output:

- Verified preflight hash claims against the SPEC and manifests: source CSVs, frozen R-A/R-B code, seed files, stage45 files.
- Reconstructed arm exits, gate exits, receipt statuses, and Stage-5 exits from `C34_stage45.csv` and the RUN log.
- Recounted fixture rows from the raw fixture-results table per arm/path.
- Reconstructed D-sets from `C34_stage45.csv` using the frozen definitions: caught-without-control = Stage 5 exit non-zero; caught-with-control = gate FAIL or Stage 5 exit non-zero.
- Reconstructed H sets from both SPEC readings: locked-field harm from `locked_field_changes_vs_B` and Stage-5 harm from Stage-5 exit 0 plus `n_stage5_files_differing > 0`.
- Compared cross-arm output SHA-256 hashes from `C34_ARM_MANIFESTS.txt` to arm B and to each other.
- Checked internal identities available from the summary tables: B recon `n_inner = n_ra - only_ra`, fixture counts, exit-code consistency, and D-set membership.
- Checked the raw `C34_arms.csv` against `C34_RESULTS.md` and `C34_stage45.csv` for internal disagreement.

## 3. Independently recomputed hard facts

### 3.1 Frozen/input hash checks

All preflight hashes in the packet match the SPEC and manifests for the frozen source CSVs, frozen R-A/R-B code, stage45 scripts, and seed files. The seed diffs in `SEED_DIFFS_b2.txt` match the declared seed SHA-256 values. No source variants are used.

### 3.2 Fixture counts from raw fixture rows

| arm | R-A fixtures | R-B fixtures | failing fixture |
| --- | --- | --- | --- |
| B | 14/14 | 14/14 | none |
| W_RA_NOTHIN | 13/14 | 14/14 | R-A F06: expected INCONCLUSIVE, observed ESCALATE |
| W_RB_NOTHIN | 14/14 | 13/14 | R-B F06: expected INCONCLUSIVE, observed ESCALATE |
| W_RB_K25 | 14/14 | 14/14 | none |
| W_RB_CRASH | 14/14 | missing | R-B missing |
| W_RA_ROUND1 | 14/14 | 14/14 | none |

B R-A F14 expected/observed `TWO_INDEPENDENT_LABELS`; B R-B F14 expected/observed `STANDARD|STANDARD`. This is in the raw fixture table.

### 3.3 Exit, gate, receipt, Stage-5 facts

| arm | receipt_status | receipt_unresolved | gate_exit | gate_result | stage5_exit | n_stage5_files_differing |
| --- | --- | --- | --- | --- | --- | --- |
| B | PASS | 0 | 0 | PASS | 0 | 0 |
| W_RA_NOTHIN | FAIL | 2 | 1 | FAIL | 1 | 8 |
| W_RB_NOTHIN | FAIL | 2 | 1 | FAIL | 0 | 1 |
| W_RB_K25 | FAIL | 1 | 1 | FAIL | 0 | 0 |
| W_RB_CRASH | FAIL | 3 | 1 | FAIL | 1 | 8 |
| W_RA_ROUND1 | PASS | 0 | 0 | PASS | 0 | 1 |

### 3.4 Recomputed D-sets and H-sets

From `C34_stage45.csv` and the frozen definitions:

- D_abl = caught without control = Stage 5 exits non-zero = `{W_RA_NOTHIN, W_RB_CRASH}`.
- Caught with control = gate FAIL or Stage 5 exits non-zero = `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25, W_RB_CRASH}`.
- Stage-5 harm set, as used in `C34_RESULTS.md` H4 = Stage 5 exit 0 and `n_stage5_files_differing > 0` = `{W_RB_NOTHIN, W_RA_ROUND1}`.
- Locked-field harm set, from `locked_field_changes_vs_B > 0` in `C34_arms.csv` = `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25, W_RA_ROUND1}`.
- Stage-5 H \ D_abl = `{W_RB_NOTHIN, W_RA_ROUND1}` — non-empty.
- Locked-field H \ D_abl = `{W_RB_NOTHIN, W_RB_K25, W_RA_ROUND1}` — non-empty.

### 3.5 Locked-field counts recomputed from `C34_arms.csv`

| arm | RA_vs_B label | RB_vs_B label | locked_field_changes_vs_B | decision_changes_vs_B | dormant change | open_age change |
| --- | --- | --- | --- | --- | --- | --- |
| W_RA_NOTHIN | 6377 | 0 | 6377 | 6377 | 0 | 0 |
| W_RB_NOTHIN | 0 | 6377 | 6377 | 6377 | 0 | 0 |
| W_RB_K25 | 0 | 6893 | 6893 | 6893 | 0 | 0 |
| W_RB_CRASH | 0 | NA | 0 | 0 | 0 | NA |
| W_RA_ROUND1 | 0 | 0 | 221457 | 0 | 221457 | 0 |

Therefore classification-change arms are `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25}`. `W_RA_ROUND1` has no classification change; its locked-field change is dormant_h only.

### 3.6 Recon facts

B recon: `n_ra=222002`, `n_rb=222002`, `n_inner=222002`, `only_ra=0`, `only_rb=0`, `disagree=0`, `dormant_mismatch=1`, `open_age_mismatch=2`. The identity `n_inner = n_ra - only_ra = 222002` holds.

Seeded recon summaries:

| arm | recon_disagree | recon_dormant_mismatch | recon_open_age_mismatch |
| --- | --- | --- | --- |
| W_RA_NOTHIN | 6377 | 1 | 2 |
| W_RB_NOTHIN | 6377 | 1 | 2 |
| W_RB_K25 | 6893 | 1 | 2 |
| W_RB_CRASH | NA | NA | NA |
| W_RA_ROUND1 | 0 | 221457 | 2 |

For seeded arms, `n_ra`, `n_rb`, `n_inner`, `only_ra`, `only_rb` are not given, so the B-style inner identity cannot be independently recomputed for them.

### 3.7 Cross-arm hash equalities from manifests

Input hashes: all match declared frozen/seed hashes.

Key output comparisons vs B:

- `RA_classifications.csv`: B `c099e...`; W_RA_NOTHIN `40c85...` differs; W_RB_NOTHIN same; W_RB_K25 same; W_RB_CRASH same; W_RA_ROUND1 `cc649...` differs.
- `RB_classifications.csv`: B `a0e42...`; W_RA_NOTHIN same; W_RB_NOTHIN `f6611...` differs; W_RB_K25 `50f56...` differs; W_RB_CRASH missing; W_RA_ROUND1 same.
- `validated_action_list.csv`: B `2bffa...`; W_RA_NOTHIN `43f28...` differs; W_RB_NOTHIN same; W_RB_K25 same; W_RB_CRASH same; W_RA_ROUND1 `e6db3...` differs.
- Stage-5/deeper files:

  - W_RB_NOTHIN: 7 of 8 files match B; `kappa_sensitivity.csv` differs (`9346c...` vs B `7a18f...`).
  - W_RA_ROUND1: 7 of 8 match B; `escalate_dormancy_summary.csv` differs (`6ce01...` vs B `1c411...`).
  - W_RB_K25: all 8 Stage-5 files match B.
  - W_RA_NOTHIN: manifest contains only `independent_checks_critical_counts.csv` (`900012...` vs B `4aca9...`); the other 7 claimed differing Stage-5 files are absent from the manifest.
  - W_RB_CRASH: manifest contains no Stage-5/deeper files; all 8 claimed differing files are absent.

### 3.8 Internal inconsistencies in runner output

1. `C34_arms.csv` marks `caught_without_control=TRUE` for `W_RB_NOTHIN` and `W_RB_K25`, but their `stage5_exit=0` in `C34_stage45.csv`. The frozen D_abl definition is Stage 5 exits non-zero. `C34_RESULTS.md` H5 lists D_abl as `{W_RA_NOTHIN, W_RB_CRASH}`. This is a hard internal conflict.
2. `C34_RESULTS.md` H4b says “arms with any classification locked-field change vs arm B” are `{W_RA_NOTHIN,W_RB_NOTHIN,W_RB_K25,W_RA_ROUND1}`. Raw `C34_arms.csv` gives W_RA_ROUND1 label differences = 0 and decision_changes_vs_B = 0. It should not be in a classification-change set.
3. `C34_RESULTS.md` H4 and the SPEC’s earlier locked-field H are different sets. The runner uses Stage-5 H in H4/H6, but `C34_arms.csv` carries a `harm` column matching locked-field harm, including `W_RB_K25`. This is a predicate ambiguity/internal inconsistency.
4. For `W_RA_NOTHIN` and `W_RB_CRASH`, `C34_stage45.csv` lists 8 Stage-5 files differing from B, but the arm manifests show only 1 and 0 Stage-5 files respectively. This is consistent only if missing files are being counted as “differing”, which is not stated.
5. `C34_arms.csv` has `caught_with_control=NA` for every arm, while `C34_RESULTS.md` H8 and `C34_stage45.csv` gate results give a determinate caught-with-control set. The column is not populated consistently with the rest of the runner output.

## 4. Facts that cannot be recomputed from this packet

- Portfolio counts and portfolio deltas: only file hashes are present; no contents of `RA_portfolio_counts.csv`, `RB_portfolio_counts.csv`, or portfolio summary files are included.
- Seeded-arm recon inner/only counts: the packet gives only summary recon columns; `n_ra`, `n_rb`, `n_inner`, `only_ra`, `only_rb` are not given for seeded arms, so the identity `n_inner = n_ra - only_ra` cannot be checked for them.
- Frozen `stage-05/deeper` reference hashes: the packet lists B’s Stage-5 output hashes, but not a separate frozen reference hash list for `stage-05/deeper`. Therefore H2b’s claim that B Stage-5 files differ from frozen `stage-05/deeper` by “none” cannot be independently verified from this packet.
- Raw stdout/stderr content: only hashes and sizes are present for most `RUN_*` logs; the text itself is not included except for small exit files.
- Raw source row-level data: only source hashes and preflight counts are present.
- MySQL count: the preflight reports `245193` and `104`, but this cannot be independently recomputed without the database.
- Receipt and gate JSON internals: manifests list `stage4_validation_status.json` and `workflow_gate_status.json` hashes, but their contents are not included, so the detailed receipt/gate field logic cannot be independently recomputed.

## 5. P1 assessment against the frozen predicate in the SPEC

Facts only:

- D_abl from the frozen definition and `C34_stage45.csv` is `{W_RA_NOTHIN, W_RB_CRASH}`.
- Under the `C34_RESULTS.md` Stage-5 harm set H4, H = `{W_RB_NOTHIN, W_RA_ROUND1}`. Then H \ D_abl = `{W_RB_NOTHIN, W_RA_ROUND1}` — non-empty.
- Under the SPEC’s earlier locked-field harm definition, H = `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25, W_RA_ROUND1}`. Then H \ D_abl = `{W_RB_NOTHIN, W_RB_K25, W_RA_ROUND1}` — non-empty.
- The uncaught locked-field changes include:

  - `W_RB_NOTHIN`: R-B label change 6377, Stage 5 exit 0, `kappa_sensitivity.csv` differs from B.
  - `W_RA_ROUND1`: R-A dormant_h change 221457, Stage 5 exit 0, `escalate_dormancy_summary.csv` differs from B.
  - Under the locked-field reading, also `W_RB_K25`: R-B label change 6893, Stage 5 exit 0, no Stage-5 output differs from B.
- Arms with no locked-field change: `W_RB_CRASH` has `locked_field_changes_vs_B=0`, but R-B exits non-zero and Stage 5 exits non-zero, so it is caught without control.
- The runner output contains the internal conflicts listed in §3.8, including disagreement on whether `W_RB_NOTHIN` and `W_RB_K25` are caught without control.

## 6. Blocking objections

The following defects in the harness/evidence should block a verdict:

1. Hard disagreement on D_abl membership: `C34_arms.csv` marks `caught_without_control=TRUE` for `W_RB_NOTHIN` and `W_RB_K25`, but `C34_stage45.csv` and `C34_RESULTS.md` H5 put them outside D_abl because Stage 5 exits 0. This is a hard mechanical conflict inside the runner output.
2. `C34_RESULTS.md` H4b misclassifies `W_RA_ROUND1` as a classification-change arm despite raw label differences of 0.
3. The SPEC contains two different H definitions — locked-field harm and Stage-5 harm — and the runner applies them inconsistently. Under the locked-field wording, `W_RB_K25` is an uncaught locked-field change; under the Stage-5 wording it is not counted. This ambiguity directly affects P1.
4. Stage-5 file-difference lists for `W_RA_NOTHIN` and `W_RB_CRASH` claim 8 differing files, but the arm manifests contain only 1 and 0 Stage-5 files respectively. Missing files may be counted as differing, but that is not stated in the evidence.
5. No separate frozen `stage-05/deeper` reference hashes are provided, so the HALT-rule claim that B Stage-5 outputs do not differ from frozen `stage-05/deeper` cannot be independently verified from this packet.
6. `C34_arms.csv` leaves `caught_with_control=NA` for all arms, while `C34_RESULTS.md` H8 and `C34_stage45.csv` gate results define a concrete caught-with-control set. This is an evidence-population defect.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Ablation ID C34, roles Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok | SPEC header, constitution, packet header |
| Frozen input hashes match | Preflight, SPEC, `C34_ARM_MANIFESTS.txt` |
| B fixtures 14/14 both paths | Raw fixture rows for B |
| W_RA_NOTHIN R-A F06 fails | Raw fixture row W_RA_NOTHIN,RA,F06 |
| W_RB_NOTHIN R-B F06 fails | Raw fixture row W_RB_NOTHIN,RB,F06 |
| W_RB_CRASH R-B missing | Raw `C34_arms.csv`, `C34_stage45.csv`, manifest |
| B recon 0/0/0 by frozen definition, full-field dormant 1/open_age 2 | `C34_RESULTS.md` B recon table, N1 |
| D_abl from Stage-5 exits | `C34_stage45.csv` stage5_exit column |
| C34_arms D_abl conflict | `C34_arms.csv` `caught_without_control` vs `C34_stage45.csv` `stage5_exit` |
| Stage-5 harm H4 = `{W_RB_NOTHIN,W_RA_ROUND1}` | `C34_stage45.csv` stage5_exit=0 and n_stage5_files_differing>0 |
| Locked-field harm = `{W_RA_NOTHIN,W_RB_NOTHIN,W_RB_K25,W_RA_ROUND1}` | `C34_arms.csv` `locked_field_changes_vs_B` |
| H4b misclassifies W_RA_ROUND1 | `C34_arms.csv` label differences for W_RA_ROUND1 = 0 |
| W_RB_NOTHIN Stage-5 kappa_sensitivity differs | Manifest hashes B `7a18f...` vs W_RB_NOTHIN `9346c...` |
| W_RA_ROUND1 Stage-5 escalate_dormancy_summary differs | Manifest hashes B `1c411...` vs W_RA_ROUND1 `6ce01...` |
| W_RA_NOTHIN Stage-5 file list vs manifest | `C34_stage45.csv` 8 files; manifest only independent_checks_critical_counts.csv |
| W_RB_CRASH Stage-5 file list vs manifest | `C34_stage45.csv` 8 files; manifest has no Stage-5/deeper files |
| P1 non-empty under either H reading | Recomputed H \ D_abl sets in §3.4 and §5 |
| Frozen stage-05 reference unverifiable | No separate frozen stage-05 hash list in packet |

END C34 VALIDATOR REPORT
