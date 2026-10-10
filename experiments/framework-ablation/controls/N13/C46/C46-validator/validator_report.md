1. Role attestation and ablation ID

- Role: DeepSeek, Validator only. I have not seen and did not ask for the Builder output. No terminal disposition is returned.
- Ablation ID: C46, Addendum 02 candidate #46 “Design-time numerical determinism”, N13 batch 4.
- Frozen spec/governance in packet: constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; C46 spec freeze line `6920322b91d2fee391706a98ca7d0dc99f475dc137ad536ce9e5e47fee62e139 C46/ABLATION_SPEC.md`.
- Blindness: Validator blind to Builder; no tools/files requested.

2. Independent test plan: what I checked, and how

- Checked role/spec scope, frozen hashes, and preflight gating result from the quoted PREFLIGHT.
- Compared `ARMS.tsv` entries against each `arms/<arm>/ARM.txt`.
- Recomputed arm-level identities from `C46_arms.csv`, each `RECON.csv`, each `fit_info.csv`, and the manifest hash list.
- Checked `events = any(fail_p) + any(fail_pct1) + any(fail_flag)` and `extra_rebuilds = events`.
- Checked `max_abs_dp`, `fail_p`, `fail_p_pct1`, `fail_flag`, `n_dp_gt_0`, `n_dp_gt_1e6`, `n_p_pct1_diff` for internal arithmetic.
- Checked cross-arm SHA-256 equality of prediction files and relevant fit-info rows.
- Checked pre-execution scratch-check numbers against BASE and THRESH_ONLY.
- Checked P1 condition table against the frozen SPEC predicate.
- Did not rerun R-A/R-B or C46 fits; no row-level `pred.csv` contents are present.

3. Independently recomputed hard facts

3.1 Arm-level recomputation from `C46_arms.csv` / `RECON.csv`

| arm | n | RA p_cols | RB p_cols | jerr RA/RB | recon | events | extra_rebuilds | max_abs_dp | fail_p | fail_p_pct1 | fail_flag |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BASE | 215687 | 32 | 32 | 0/0 | FAIL | 2 | 2 | 0.008446989841342178 | 0 | 17564 | 11 |
| DECL | 215687 | 32 | 32 | 0/0 | PASS | 0 | 0 | 0 | 0 | 0 | 0 |
| THRESH_ONLY | 215687 | 32 | 32 | 0/0 | FAIL | 1 | 1 | 9.44668978275498e-6 | 0 | 30 | 0 |
| ORDER_ONLY | 215687 | 32 | 32 | 0/0 | PASS | 0 | 0 | 0 | 0 | 0 | 0 |
| DEFECT_DECL | 215687 | 32 | 31 | 0/0 | FAIL | 3 | 3 | 0.766791177978111 | 193060 | 111789 | 2070 |
| DEFECT_BASE | 215687 | 32 | 31 | 0/0 | FAIL | 3 | 3 | 0.7656221672416856 | 12890 | 111885 | 2082 |

Identities checked:

- `n = 215687` for every arm.
- RA `p_cols = 32` for every arm; RB `p_cols = 32` except DEFECT_DECL and DEFECT_BASE, both `31`.
- `jerr_RA = jerr_RB = 0` for every arm.
- `extra_rebuilds = events` for every arm.
- `events = any(fail_p) + any(fail_p_pct1) + any(fail_flag)` holds for every arm:

  - BASE: 0 + 1 + 1 = 2.
  - DECL: 0 + 0 + 0 = 0.
  - THRESH_ONLY: 0 + 1 + 0 = 1.
  - ORDER_ONLY: 0 + 0 + 0 = 0.
  - DEFECT_DECL: 1 + 1 + 1 = 3.
  - DEFECT_BASE: 1 + 1 + 1 = 3.
- Arm table `recon` matches raw `RECON.csv` `recon` for every arm.
- Arm table `max_abs_dp` matches raw `RECON.csv` `max_abs_dp` for every arm.

3.2 RECON raw-count checks

| arm | p_tol | n_dp_gt_0 | n_dp_gt_1e6 | n_p_pct1_diff | notes |
| --- | --- | --- | --- | --- | --- |
| BASE | 0.05 | 215637 | 123276 | 17564 | `fail_p=0` because max_abs_dp < 0.05; `fail_pct1 = n_p_pct1_diff`. |
| DECL | 1e-6 | 0 | 0 | 0 | all comparator counts zero. |
| THRESH_ONLY | 0.05 | 213998 | 6627 | 30 | `fail_p=0`; `fail_pct1 = n_p_pct1_diff = 30`. |
| ORDER_ONLY | 0.05 | 0 | 0 | 0 | all zero. |
| DEFECT_DECL | 1e-6 | 215687 | 193060 | 111789 | `fail_p = n_dp_gt_1e6 = 193060`; `fail_pct1 = n_p_pct1_diff = 111789`. |
| DEFECT_BASE | 0.05 | 215687 | 193114 | 111885 | `fail_p=12890` because tolerance is 0.05; `fail_pct1 = n_p_pct1_diff = 111885`. |

3.3 Fit-info recomputation

| arm | path | order | thresh | drop | n | p_cols | npasses | jerr | dev_ratio_last | secs |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| REF | RA | canonical | 1e-14 | - | 215687 | 32 | 16386 | 0 | 0.8356498569181723 | 48.5 |
| BASE | RA | natural | 1e-7 | - | 215687 | 32 | 1220 | 0 | 0.8356434248182028 | 12.8 |
| BASE | RB | reversed | 1e-7 | - | 215687 | 32 | 1223 | 0 | 0.8356412282097697 | 12.9 |
| DECL | RA | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 33.3 |
| DECL | RB | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 34.3 |
| THRESH_ONLY | RA | natural | 1e-12 | - | 215687 | 32 | 8088 | 0 | 0.8356498304330563 | 27 |
| THRESH_ONLY | RB | reversed | 1e-12 | - | 215687 | 32 | 8682 | 0 | 0.8356498321830208 | 28.7 |
| ORDER_ONLY | RA | canonical | 1e-7 | - | 215687 | 32 | 1500 | 0 | 0.8356432205347253 | 12.4 |
| ORDER_ONLY | RB | canonical | 1e-7 | - | 215687 | 32 | 1500 | 0 | 0.8356432205347253 | 12.6 |
| DEFECT_DECL | RA | canonical | 1e-12 | - | 215687 | 32 | 10811 | 0 | 0.835649844758912 | 32.5 |
| DEFECT_DECL | RB | canonical | 1e-12 | x_log_peer_p75 | 215687 | 31 | 2136 | 0 | 0.8294719972850374 | 14.9 |
| DEFECT_BASE | RA | natural | 1e-7 | - | 215687 | 32 | 1220 | 0 | 0.8356434248182028 | 12.6 |
| DEFECT_BASE | RB | reversed | 1e-7 | x_log_peer_p75 | 215687 | 31 | 533 | 0 | 0.8294668664093228 | 11.2 |

Checks:

- DECL RA and DECL RB have identical `dev_ratio_last` and `npasses`.
- ORDER_ONLY RA and ORDER_ONLY RB have identical `dev_ratio_last` and `npasses`.
- DEFECT_DECL RA matches DECL RA on `dev_ratio_last` and `npasses`.
- DEFECT_BASE RA matches BASE RA on `dev_ratio_last` and `npasses`.
- BASE RA vs BASE RB differ as expected under different column order.
- THRESH_ONLY RA vs THRESH_ONLY RB differ as expected under different column order.
- All `jerr = 0`; all `RUN_*` exit files report exit `0`; all `stderr` files are empty hashes (`e3b0c44...`).

3.4 Cross-arm hash equalities

- DECL RA `pred.csv` = DECL RB `pred.csv` = DEFECT_DECL RA `pred.csv` = `fd47d91eb05003d3c2ccc04df5eda018658a8ffabb760d7bde6f7e7edef43e50`, 8,967,969 bytes.
- ORDER_ONLY RA `pred.csv` = ORDER_ONLY RB `pred.csv` = `ff4b93fe0223b319b3f9b920b3f74d973b8d03ba2b0668f1067c92c40a3e281f`, 8,968,141 bytes.
- BASE RA `pred.csv` = DEFECT_BASE RA `pred.csv` = `c641eadae6abf07e47aa5ef0fc622a53628135017a1c21e80f8ff9d4a86a8359`, 8,967,753 bytes.
- Fit-info hashes differ where `secs` differs even when other fit values match, e.g. DECL RA `333f2db1...` vs DECL RB `f6b6d704...`; BASE RA `28db7760...` vs DEFECT_BASE RA `9b6ceb4a...`.
- Frozen pack hashes in PREFLIGHT match the FROZEN KEY7 list and the frozen reference hashes in SPEC.
- Runner-side seed hashes match PREFLIGHT and SPEC: `ARMS.tsv d75c3c...`, `DETFIT 6757df...`, `fit_path.R d681aff...`, `recon_c46.R 9cd9fe...`, `run_batch_v4.ps1 6b857e...`, `eval_b4.R cd5ec7...`.

3.5 Pre-execution scratch check vs runner

- Pre-check thresh `1e-7`, natural vs reversed: max|Δp| `0.00845`, 11 flag differences.
- BASE reproduces max_abs_dp `0.008446989841342178` and `fail_flag = 11`.
- Pre-check thresh `1e-12`, natural vs reversed: max|Δp| `9.4e-6`, 0 flag differences.
- THRESH_ONLY reproduces max_abs_dp `9.44668978275498e-6` and `fail_flag = 0`.
- DECL vs REF line: max|dp| `5.33069e-05`, flag differences `0`. This is not recomputable from row-level files in the packet.

3.6 Internal inconsistency flags

- No hard aggregate inconsistency found in the runner output.
- Exit-file `secs` are consistently about 2 seconds larger than `fit_info.csv` `secs`; this is process wall time vs internal fit timer, not a contradiction.
- The C46 results file is an interim coordinator evaluation on a byte-copy before batch-end; the packet states the batch-end evaluation will be compared. That is disclosed, not a numerical inconsistency in the quoted C46 tables.
- Portfolio deltas and D-sets are not present in the packet; they cannot be recomputed here.

4. Facts that cannot be recomputed from this packet

- Per-row `p`, `p_pct1`, and `flag` values in `pred.csv`; only hashes/sizes are provided.
- Exact DECL-vs-REF max|dp| `5.33069e-05` and flag-difference count `0`; only the aggregate line is provided.
- Exact row identities of failing rows and any D-set of failing SR_NUMBERs.
- Portfolio deltas and portfolio-count contents; only hash/size lines exist for `RA_portfolio_counts.csv` and `RB_portfolio_counts.csv`.
- RA/RB classifications and the three N1/OF-1 rows; no row-level classification file contents are included.
- Source row-level contents and MySQL counts beyond the quoted preflight `245193 / 104`.
- Fixture actuals/expecteds; only fixture-result hashes are present.
- Contents of `run_batch_v4.ps1` and `eval_b4.R`; only hashes and behavior summaries are present.
- Builder first-pass output and any Builder/Validator hard-number agreement check.

5. P1 assessment against the frozen predicate in the SPEC  
   Facts only; no terminal state.

| condition | runner status | independent basis |
| --- | --- | --- |
| 1. BASE: >= 1 reconciliation event | MET | `BASE RECON.csv events=2`; arms table `extra_rebuilds=2`. |
| 2. DECL: 0 reconciliation events | MET | `DECL RECON.csv events=0`; all fail counts zero. |
| 3. DEFECT_DECL: recon FAIL | MET | `DEFECT_DECL RECON.csv recon=FAIL, events=3`. |
| 4. DECL R-A vs REF: max | Δp | <= 1e-6 and identical flags | NOT MET | `C46_RESULTS.md`: max | dp | `5.33069e-05`, flag differences `0`. The max | dp | value exceeds `1e-6`. |
| 5. extra rebuilds: BASE >= 1 and DECL = 0 | MET | BASE `extra_rebuilds=2`; DECL `extra_rebuilds=0`. |

Runner output line: `Mechanical predicate result: P1 NOT MET`. The independently visible failing condition is condition 4.

6. Blocking objections

- No blocking objection is supported by the frozen aggregate evidence in this packet.
- Caveats that limit independent recomputation but do not, by themselves, block the mechanical P1 assessment as reported:

  - `pred.csv` row-level contents are not included, so max|dp| and failing-row identities cannot be independently recomputed.
  - The C46 results file is an interim coordinator evaluation on a byte-copy before batch-end; the batch-end comparison is stated as pending.
  - OF-2: the design-time cost metric is disclosed as not measured; the operationalised cost side is rebuild counts only.
  - OF-1: the frozen-pack 1.000 h clock mismatch on three ESCALATE rows is disclosed; C46 does not rerun R-A/R-B and the SPEC states it does not enter C46 numbers.

7. Claim → evidence map  
   | claim | evidence |  
   |---|---|  
   | Preflight gating passed. | PREFLIGHT section: all frozen OK / seed OK; `preflight gating result: PASS`. |  
   | All C46 arms ran to completion without fit or RECON errors. | RUN LOG: all `exit=0`; `fit_info.csv` `jerr=0` for all fits; all `RUN_*` exit files `0`; all `stderr` empty. |  
   | BASE has >= 1 reconciliation event. | `arms/BASE/RECON.csv`: `events=2`, `recon=FAIL`; `C46_arms.csv` BASE `extra_rebuilds=2`. |  
   | DECL has 0 reconciliation events. | `arms/DECL/RECON.csv`: `events=0`, `recon=PASS`; `C46_arms.csv` DECL all fail counts zero. |  
   | DEFECT_DECL still fails reconciliation. | `arms/DEFECT_DECL/RECON.csv`: `events=3`, `recon=FAIL`, `fail_p=193060`, `fail_pct1=111789`, `fail_flag=2070`. |  
   | DECL R-A vs REF fails the `1e-6` max|dp| condition. | `C46_RESULTS.md` DECL vs REF: `max|dp| = 5.33069e-05`, `flag differences = 0`; condition table marks condition 4 `NOT MET`. |  
   | Extra rebuilds condition holds. | `C46_arms.csv`: BASE `extra_rebuilds=2`, DECL `extra_rebuilds=0`. |  
   | Canonical order on both paths gives identical RA/RB predictions. | DECL RA/RB `pred.csv` both `fd47d91...`; ORDER_ONLY RA/RB both `ff4b93...`; DECL and ORDER_ONLY fit-info dev_ratio/npasses match between RA/RB. |  
   | Dropping `x_log_peer_p75` changes RB and causes recon failure. | DEFECT_DECL RB `p_cols=31`, `drop=x_log_peer_p75`, `dev_ratio_last=0.8294719972850374`; DEFECT_BASE RB `p_cols=31`, `drop=x_log_peer_p75`, `dev_ratio_last=0.8294668664093228`; both RECON FAIL. |  
   | OF-1 is disclosed and not used by C46. | SPEC N1/OF-1 note; no C46 arm reruns R-A/R-B; C46 reads frozen R-B classifications only as labels/features. |  
   | OF-2 cost metric is not measured. | SPEC disclosed limitation: design-time cost below baseline rebuild minutes is not measured; cost side operationalised only as rebuild counts. |

END C46 VALIDATOR REPORT
