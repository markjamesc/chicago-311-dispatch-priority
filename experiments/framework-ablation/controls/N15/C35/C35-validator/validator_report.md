1. Role attestation and ablation ID

I am the Validator (DeepSeek). I attest I am blind to the Builder and have not seen or requested its output. I hold only the Validator role. Ablation ID: C35, catalog #35 “Freeze Validated Pack,” N15 batch 3 of 3. I return no terminal state.

2. Independent test plan: what I checked, and how

I checked the frozen SPEC, coordinator note N1, preflight output, run log, `C35_RESULTS.md`, `C35_arms.csv`, arm manifests, seed diffs, and the evidence hash file. I did not run code or access external files. I recomputed, from the provided raw tables only:

- the three frozen validated-file identities;
- per-arm FRZ_PRE/FRZ_POST changed status from hashes and run log;
- per-arm S5 exit status;
- per-arm changed validated file(s);
- cross-arm SHA-256/byte equalities;
- the harm set H;
- the without-control detection set D_abl;
- H \ D_abl and related P1 sets;
- P1 against the frozen predicate.

I flagged internal inconsistencies where the runner’s CSV/RESULTS fields disagree with the run log or manifests.

3. Independently recomputed hard facts

Frozen validated-file identities from SPEC and manifests:

| file | frozen SHA-256 | frozen bytes |
| --- | --- | --- |
| `R-A/outputs/RA_classifications.csv` | `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9` | 22,271,481 |
| `R-B/outputs/RB_kappa_grid_counts.csv` | `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` | 164 |
| `outputs/validated_action_list.csv` | `2bffa38b1cf13b99296a4c5d02ead7e22d3c20c4ff22647df31e1fa33761954a` | 13,625,648 |

Arm B:

- S5 exit: `0`.
- FRZ_PRE and FRZ_POST both hash to `81ad521ae58e99efe553814d6cbf9866a4309f9559a6de6fdd3f5d7bd7aae98f`, 343 bytes. Therefore B `frz_post_changed = 0`.
- B outputs match frozen validated files: RA `c099...`, RB `7a18...`, validated `2bff...`.
- B stage-05/deeper 8 outputs match the frozen hashes: `capacity_coverage_note.csv` `4bf452...` 644; `escalate_by_type.csv` `0f2d8f...` 3932; `escalate_by_type_top25.csv` `6d3bd2...` 1264; `escalate_dormancy_summary.csv` `1c411c...` 138; `inconclusive_by_clause.csv` `f29e33...` 58; `independent_checks_critical_counts.csv` `4aca9c...` 190; `kappa_sensitivity.csv` `7a18fc...` 164; `portfolio_summary.csv` `b58fc4...` 183.
- B is clean on the evidence shown.

Per-arm recomputation:

| arm | S5 exit | changed validated file(s) from manifest | changed bytes vs frozen | FRZ_POST vs FRZ_PRE | in H | caught_with | caught_without |
| --- | --- | --- | --- | --- | --- | --- | --- |
| B | 0 | none | 0 | same hash | FALSE | FALSE | FALSE |
| FV_VALSORT | 0 | `outputs/validated_action_list.csv` `0de2eb...` | same size 13,625,648; hash changed | `f1dbbc...` 341 vs `81ad...` 343 | TRUE | TRUE | FALSE |
| FV_ADDRANK | 0 | `R-A/outputs/RA_classifications.csv` `0efb2f...` | 23,714,404; +1,442,923 | `ca146e...` 341 vs `81ad...` 343 | TRUE | TRUE | FALSE |
| FV_ROUND | 0 | `R-A/outputs/RA_classifications.csv` `cc6491...` | 21,158,499; -1,112,982 | `88355c...` 341 vs `81ad...` 343 | TRUE | TRUE | FALSE |
| FV_DROPTHIN | 0 | `outputs/validated_action_list.csv` `adc8b7...` | 13,625,246; -402 | `485bab...` 341 vs `81ad...` 343 | TRUE | TRUE | FALSE |
| FV_EARLY | 1 | `outputs/validated_action_list.csv` `ae5317...` | 13,625,543; -105 | `accc84...` 341 vs `81ad...` 343 | TRUE | TRUE | TRUE |
| FV_BENIGN | 0 | none | 0 | same hash `81ad...` 343 | FALSE | FALSE | FALSE |

FV_EARLY additional facts:

- `RUN_S5.stderr.txt` is present, 52 bytes; stdout is empty.
- Under `stage-05/deeper`, only `independent_checks_critical_counts.csv` is listed, hash `8fe938...`, 191 bytes, vs B/frozen `4aca9c...`, 190 bytes. The other seven frozen deeper outputs are absent from its manifest.
- S5 exit is non-zero, so it counts in D_abl.

FV_BENIGN additional facts:

- The frozen 8 stage-05/deeper outputs match B/frozen.
- It adds `stage-05/deeper/diag_type_by_class.csv`, hash `1b5dae...`, 2,952 bytes.
- No validated file changes. Not in H.

Cross-arm hash equalities:

- `RB_kappa_grid_counts.csv` is identical across all arms: `7a18...`, 164 bytes.
- `RA_classifications.csv` is identical to frozen for B, FV_VALSORT, FV_DROPTHIN, FV_EARLY, FV_BENIGN: `c099...`. It differs for FV_ADDRANK and FV_ROUND.
- `validated_action_list.csv` is identical to frozen for B, FV_ADDRANK, FV_ROUND, FV_BENIGN: `2bff...`. It differs for FV_VALSORT, FV_DROPTHIN, FV_EARLY.
- All `FRZ_PRE.txt` files are identical: `81ad...`, 343 bytes.
- `FRZ_POST.txt` equals `FRZ_PRE.txt` for B and FV_BENIGN only. All other seeded arms have 341-byte `FRZ_POST.txt` files with different hashes.
- The frozen 8 stage-05/deeper outputs are identical across B, FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, and FV_BENIGN. FV_EARLY is the exception.

Recomputed sets:

- H = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY}
- caught with the control = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY}
- D_abl = {FV_EARLY}
- H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}
- H \ caught-with = {}
- flagged with the control but not in H = {}

Internal inconsistencies in runner output:

- `C35_arms.csv` and `C35_RESULTS.md` leave `frz_pre_changed` blank for every arm, while the run log records `FRZ_PRE changed=0` for every arm. The identical `FRZ_PRE.txt` hashes corroborate 0, but the CSV/RESULTS field is blank.
- B and FV_BENIGN have blank `frz_post_changed` in `C35_arms.csv`/RESULTS, while the run log records `FRZ_POST changed=0` and the hashes support no change.
- FV_EARLY has blank `s5_outputs_differ_vs_B`, but its manifest shows `independent_checks_critical_counts.csv` differs from B and seven other stage-05/deeper outputs are absent. If that column is meant for all arms, the blank is inconsistent.
- FV_BENIGN has `RUN_S5.exit` hash `6ae824...`, 33 bytes, while B and other exit-0 arms have 31-byte exit files. The content is not shown, so this is unexplained but not a direct contradiction of `exit=0`.
- The preflight output does not list `outputs/validated_action_list.csv` or `R-B/outputs/RB_kappa_grid_counts.csv`; it lists `R-B/outputs/RB_classifications.csv` `a0e42...`, which is not the Stage-5 validated RB file. The preflight gating PASS is therefore not a complete direct verification of the three validated files.
- The fixture results table has only a header and no rows.
- `VALIDATION_FREEZE.sha256` content is not shown; only its hash `65b9...`, 335 bytes, is given.

4. Facts that cannot be recomputed from this packet

I cannot recompute from this packet:

- the actual row-level contents of `RA_classifications.csv`, `RB_kappa_grid_counts.csv`, `validated_action_list.csv`, or any `stage-05/deeper` CSV;
- row counts, label counts, classification counts, `n_decision`, `n_ESCALATE`, `n_INCONCLUSIVE`, `n_STANDARD`, or `validated_action_list_n`;
- the N1 row-level mismatches for `SR22-01936870`, `SR25-02017553`, `SR25-02017556`;
- portfolio summary values or any delta inside `portfolio_summary.csv`;
- the contents of `FRZ_PRE.txt`, `FRZ_POST.txt`, or `VALIDATION_FREEZE.sha256`;
- fixture actuals/expecteds, because the fixture results table is empty;
- seed script behavior beyond the provided unified diffs;
- the baseline framework file contents beyond the supplied hashes;
- Builder–Validator hard-number agreement, since no Builder output is in this packet.

5. P1 assessment against the frozen predicate in the SPEC

Frozen P1 KEEP-side requires both:

1. arm B is clean: Stage 5 exit 0; 8/8 outputs equal frozen `stage-05/deeper`; with-control check does not flag B; and
2. H \ D_abl = ∅.

From the evidence:

- Arm B is clean: S5 exit 0; 8/8 stage-05/deeper hashes equal frozen; FRZ_POST equals FRZ_PRE; with-control check does not flag B.
- H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}, which is not empty.
- H \ caught-with = ∅.
- flagged with the control but not in H = ∅.

Therefore, against the frozen P1 predicate, P1 failed because H \ D_abl is non-empty. The four named arms are caught by the with-control comparison but not by Stage 5’s own non-zero exit checks.

6. Blocking objections

None that I can support from this packet as blocking the recomputation of H, D_abl, or P1. The blank `frz_pre_changed` fields, the FV_EARLY `s5_outputs_differ_vs_B` blank, the preflight omission of two validated-file hashes, and the empty fixture-results table are evidence/reporting defects noted in §3. They do not change the recomputed H, D_abl, or P1 outcome from the raw manifests and run log.

7. Claim → evidence map

| claim | evidence |
| --- | --- |
| Ablation is C35 “Freeze Validated Pack” | SPEC header; batch N15 batch 3 |
| Roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok | SPEC roles line |
| Frozen validated-file hashes | SPEC; arm manifests; B outputs |
| Arm B Stage 5 exit 0 | run log; `C35_arms.csv`; `RUN_S5.exit` |
| Arm B 8/8 deeper outputs equal frozen | B manifest hashes vs SPEC frozen stage-05/deeper hashes |
| B with-control clean | B FRZ_PRE/FRZ_POST equal `81ad...`; run log `B FRZ_POST changed=0` |
| H set | `C35_arms.csv` `in_H=TRUE` rows; RESULTS H set |
| Caught-with set | `frz_post_changed` nonblank for H arms; RESULTS caught-with set |
| D_abl set | only FV_EARLY has `s5_exit=1`; all others `s5_exit=0` |
| H \ D_abl nonempty | recomputed from H and D_abl |
| P1 failed | frozen P1 predicate; H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN} |
| FV_BENIGN benign | `frz_post_changed` unchanged; adds only `diag_type_by_class.csv`; `in_H=FALSE` |
| N1 known open finding | coordinator note N1; SPEC known open finding |
| Cross-arm validated-file changes | arm manifests: RA, RB, validated_action_list hashes |
| Internal reporting inconsistencies | `C35_arms.csv` blanks vs run log; FV_EARLY manifest vs `s5_outputs_differ_vs_B`; preflight omission; empty fixture table |

END C35 VALIDATOR REPORT
