# C35 Builder Report

## 1. Role attestation and ablation ID.

I am acting as **Builder only** for an **independent first pass**, blind to the Validator. The ablation is **C35**, Remaining Ablation Program catalog #35, **“Freeze Validated Pack,”** in N15 batch 3 of 3. The target is **Stage 5**, where deeper analysis must not alter validated data.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The frozen control protects the validated analytical pack by keeping a separate archived freeze and comparing the validated files to that archive after Stage 5. C35 removes that protection: there is no separate archive available to the operational Stage-5 regime and no post-analysis integrity check; Stage 5 works in the same folders as the validated files. Stage 5's independent count checks remain. The runner's FRZ_POST comparison is therefore experimental instrumentation used to establish the harm set, not a safeguard available in the ablated regime.

The exact seeded changes are:

**FV_VALSORT**

```
write_csv(arrange(val, desc(dormant_h)), file.path(root, "outputs/validated_action_list.csv"))  # [seed] Stage 5 re-sorts the validated list in place
```

**FV_ADDRANK**

```
ra_w <- read_csv(file.path(root, "R-A/outputs/RA_classifications.csv"), show_col_types = FALSE); ra_w$priority_rank <- rank(-ra_w$dormant_h, ties.method = "first")
write_csv(ra_w, file.path(root, "R-A/outputs/RA_classifications.csv"))  # [seed] Stage 5 adds a column to the validated classifications in place
```

**FV_ROUND**

```
ra_w <- read_csv(file.path(root, "R-A/outputs/RA_classifications.csv"), show_col_types = FALSE); ra_w$dormant_h <- round(ra_w$dormant_h, 1)
write_csv(ra_w, file.path(root, "R-A/outputs/RA_classifications.csv"))  # [seed] Stage 5 writes rounded dormant_h back into the validated classifications
```

**FV_DROPTHIN**

```
write_csv(filter(val, peer_n >= 100), file.path(root, "outputs/validated_action_list.csv"))  # [seed] Stage 5 overwrites the validated list with a filtered copy (peer_n >= 100)
```

**FV_EARLY**

```
val <- val[-1, ]; write_csv(val, file.path(root, "outputs/validated_action_list.csv"))  # [seed] Stage 5 drops a row from the validated list before its checks
```

This seed is deliberately placed before the independent checks.

**FV_BENIGN**

```
write_csv(count(ra, type_key, classification), file.path(out, "diag_type_by_class.csv"))  # [seed] benign: new diagnostic in stage-05 only
```

Thus five seeds attempt to change validated artifacts; the sixth writes only an additional Stage-5 diagnostic.

## 3. Hard mechanical facts table.

| Mechanical fact | Result | Status |
| --- | --- | --- |
| Total arms | **7** = B + 6 seeded arms | **Recomputed** from the seven `C35_arms.csv` rows |
| Seeded arms | **6** | **Recomputed** |
| Arms with FRZ_PRE modification | **0/7** | **Recomputed** from run log/raw arms; every arm begins clean |
| Stage-5 exit 0 | **6/7** | **Recomputed** |
| Stage-5 non-zero exit | **1/7**, FV_EARLY | **Recomputed** |
| Arms with FRZ_POST validated-file changes | **5/7** | **Recomputed** |
| Harm-set size |H| | **5** | **Recomputed** |
| H | `{FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY}` | **Recomputed** |
| Caught by archived post-analysis comparison | **5/5 harms** | **Recomputed** |
| Without-control detection set D_abl | `{FV_EARLY}`; size **1** | **Recomputed** from `s5_exit != 0` |
| H \ D_abl | `{FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}`; size **4** | **Recomputed** |
| H \ caught-with | `∅`; size **0** | **Recomputed** |
| Flagged-with-control but not in H | `∅`; size **0** | **Recomputed** |
| Harm detection rate with archived comparison | **5/5 = 100%** | **Recomputed** |
| Harm detection rate using Stage-5 checks alone | **1/5 = 20%** | **Recomputed** |
| Harm escape rate without archived comparison | **4/5 = 80%** | **Recomputed** |
| B Stage-5 reproduction | **8/8** standard outputs equal frozen outputs | **Recomputed** from the eight frozen hashes and B manifest; also quoted by RESULTS |
| Successful seeded-arm standard Stage-5 outputs vs B | **40/40 equal** = 5 successful seeded arms × 8 outputs | **Recomputed** from manifests |
| `portfolio_summary.csv` among B + five successful seeds | **6/6 identical hashes**, 183 bytes each | **Recomputed**; therefore file-level portfolio delta vs B is zero for those successful arms |
| FV_EARLY portfolio comparison | No `portfolio_summary.csv` produced after its early failure | **Recomputed** from its output manifest |
| Standard validated-pack byte size in B | **35,897,293 bytes** = 22,271,481 + 13,625,648 + 164 | **Recomputed** |
| FV_VALSORT validated-pack byte delta | **0 bytes**, despite changed action-list hash | **Recomputed** |
| FV_ADDRANK validated-pack byte delta | **+1,442,923 bytes** | **Recomputed**: 23,714,404 − 22,271,481 |
| FV_ROUND validated-pack byte delta | **−1,112,982 bytes** | **Recomputed**: 21,158,499 − 22,271,481 |
| FV_DROPTHIN validated-pack byte delta | **−402 bytes** | **Recomputed** |
| FV_EARLY validated-pack byte delta | **−105 bytes** | **Recomputed** |
| FV_BENIGN validated-pack byte delta | **0 bytes** | **Recomputed** |
| Validated action-list hash changed | **3/7 arms**: VALSORT, DROPTHIN, EARLY | **Recomputed** |
| R-A classifications hash changed | **2/7 arms**: ADDRANK, ROUND | **Recomputed** |
| R-B kappa-grid hash changed | **0/7 arms** | **Recomputed** |
| Harmful arms changing exactly one of the three validated files | **5/5** | **Recomputed** |
| `VALIDATION_FREEZE.sha256` hash equality across arm outputs | **7/7 identical** (`65b910…`) | **Recomputed** |
| FRZ_PRE file hash equality across all arms | **7/7 identical** (`81ad52…`) | **Recomputed** |
| FRZ_POST equals the clean FRZ_PRE representation | **2/7 arms**: B and FV_BENIGN | **Recomputed** |
| FRZ_POST differs from clean FRZ_PRE representation | **5/7 arms** | **Recomputed** |
| Seed-script hash agreement between frozen spec, preflight and runner-side listing | **6/6** | **Recomputed** from repeated SHA-256 values |
| Source candidates row count | **245,193** | **Quoted** from frozen spec/preflight |
| Peer-stats database preflight count | **104** | **Quoted** from preflight |
| Fixture-result data rows in this Stage-5-only control | **0** | **Recomputed** from the fixture-results table: header only |
| Full-field frozen-pair `dormant_h` mismatches | **1** | **Quoted** from N1 |
| Full-field frozen-pair `open_age_h` mismatches | **2** | **Quoted** from N1 |
| Total disclosed full-field clock-value mismatch rows | **3 = 1 + 2** | **Recomputed total from quoted component counts** |
| Magnitude on each disclosed clock mismatch | **1.000 h** | **Quoted** |
| Classification disagreement for those three rows | **0**; labels agree | **Quoted** |

The arm-level facts and set membership recompute directly from the raw seven-row `C35_arms.csv`: five arms have a nonempty `frz_post_changed` field and are in H; only FV_EARLY has `s5_exit=1` and `caught_without=TRUE`; FV_BENIGN changes no validated file and adds only `diag_type_by_class.csv`.

The run log independently gives the same 0/1 pattern: every FRZ_PRE check is clean, the five destructive seeds produce FRZ_POST `changed=1`, FV_EARLY alone exits 1, and B/FV_BENIGN remain FRZ_POST-clean.

The B manifest reproduces the frozen validated hashes and all eight frozen Stage-5 output hashes. The successful seeded manifests preserve those eight standard Stage-5 output hashes even where a validated artifact is subsequently changed; FV_BENIGN additionally contains the 2,952-byte diagnostic.

For the destructive file-size deltas, the manifests show FV_DROPTHIN's action list at 13,625,246 bytes, FV_EARLY's at 13,625,543 bytes, FV_ROUND's R-A file at 21,158,499 bytes, FV_ADDRANK's R-A file at 23,714,404 bytes, and FV_VALSORT retaining the baseline 13,625,648-byte action-list size while changing its hash.

No `n_agree`, `n_disagree`, or `n_inner` values are present in this C35 evidence packet, so that identity cannot be recomputed without inventing evidence. Likewise, the body of `portfolio_summary.csv` is not supplied; numeric portfolio cells cannot be independently recalculated. What can be established mechanically is stronger at the file level for successful runs: the portfolio file hashes are identical to B, hence their serialized portfolio output is unchanged byte-for-byte.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 predicate requires two factual conditions: arm B must be clean, and **H \ D_abl must be empty**.

The first condition is established. B exits Stage 5 with code 0, reproduces all **8/8** frozen Stage-5 outputs, and has no post-Stage-5 validated-file change.

The second condition is false. Recomputing from the raw arm rows gives:

`H = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY}`

`D_abl = {FV_EARLY}`

therefore:

`H \ D_abl = {FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN}`

and `|H \ D_abl| = 4`, not 0.

Accordingly, **P1 evaluates false under its frozen definition**. Four of five observed validated-pack modifications are not detected by Stage 5's own independent checks.

## 5. Fixture and reconciliation implications.

The fixture-results table contains only its header and **zero result rows**. That is consistent with C35 being a Stage-5-only control: the frozen specification explicitly states that C35 does not rerun R-A or R-B, and no R-A/R-B code seeds or source variants are used. Consequently, this report does not infer or manufacture new fixture passes, fixture failures, `n_agree`, `n_disagree`, or fresh cross-path reconciliation counts.

There is one predeclared reconciliation qualification. In the already-frozen clean pack, R-A and R-B differ by exactly **1.000 hour** on three ESCALATE rows: one `dormant_h` mismatch and two `open_age_h` mismatches. Their classifications agree. The proposed daylight-saving ambiguous-hour explanation is explicitly unconfirmed. The batch's frozen reconciliation definition concerns only R-A-only keys, R-B-only keys, and classification disagreements, so those three full-field clock-value differences are outside that narrower reconciliation definition. They predate C35 and are not a seeded C35 effect.

Within C35 itself, the integrity reconciliation is instead the freeze comparison. All seven arms have the same clean FRZ_PRE representation; after Stage 5, five arms diverge from it, while B and FV_BENIGN do not. This isolates the detected changes to Stage-5 execution rather than differences in starting state.

## 6. Semantic/regression risks and unchanged surfaces.

**FV_VALSORT** demonstrates a byte-level integrity change that leaves file size unchanged. The action list remains 13,625,648 bytes but receives a different SHA-256 after sorting by descending `dormant_h`. Pure count checks cannot establish original row order, so the Stage-5 checks exit normally.

**FV_ADDRANK** demonstrates schema mutation. It adds `priority_rank` to the validated R-A classifications and enlarges the file by 1,442,923 bytes, yet Stage 5 exits 0 and its eight standard deeper-analysis outputs remain identical to B. Thus the retained Stage-5 output/count checks do not establish schema immutability.

**FV_ROUND** demonstrates validated-value mutation. It rounds `dormant_h` to one decimal and rewrites the R-A classifications, reducing the file by 1,112,982 bytes. Stage 5 still exits 0 and standard Stage-5 outputs remain equal to B. The checks therefore do not establish byte-level or numeric-field immutability.

**FV_DROPTHIN** demonstrates a post-check row-set mutation. The inserted write filters the validated action list to `peer_n >= 100`; because the seed is located near the end of Stage 5 after the existing independent checks/output generation, Stage 5 exits 0. The action-list file shrinks by 402 bytes and its hash changes. This is direct evidence that a count assertion performed earlier in the script does not protect a validated file from a later write.

**FV_EARLY** provides the contrasting case. Its one-row deletion is placed before the independent checks. The resulting action list is 105 bytes smaller and Stage 5 exits 1. Thus the existing checks do catch a mutation when that mutation changes the checked state before the assertions execute.

**FV_BENIGN** writes only `stage-05/deeper/diag_type_by_class.csv`. The three validated-file hashes remain identical to B, FRZ_POST stays clean, Stage 5 exits 0, and the original eight Stage-5 outputs remain identical. This separates legitimate Stage-5 analytical expansion from modification of the validated pack.

The principal unchanged surfaces are also mechanically visible. `R-B/outputs/RB_kappa_grid_counts.csv` remains identical in **7/7** arms. All successful runs retain B's hashes for the original eight `stage-05/deeper` outputs. There are no source variants in this control, and no R-A/R-B implementation seeds are used. Arm B retains the original three validated-file hashes exactly.

The semantic risk shown by C35 is therefore specific: **Stage-5 result/count reproducibility is not equivalent to validated-pack immutability.** Four seeds altered validated bytes while allowing Stage 5 to complete normally and while preserving its standard output files.

## 7. Claim → evidence map.

| Claim | Packet section and evidence row |
| --- | --- |
| C35 removes the separate validated-pack archive/post-analysis protection while retaining Stage-5 independent count checks. | **SPEC → “Control under test” / “Exact change being tested”**, especially lines describing separate archive versus no archive/post-analysis check. |
| All seven arms start clean before Stage 5. | **RUN LOG → every** `FRZ_PRE changed=0` **row** for B, FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY, FV_BENIGN. |
| B is a clean reference and reproduces 8/8 frozen Stage-5 outputs. | **C35_RESULTS.md → “Arm B” row**; corroborated by **ARM MANIFESTS → B out** hashes matching the eight hashes frozen in SPEC. |
| Five seeded arms modify a validated file after Stage 5. | **C35_arms.csv rows FV_VALSORT, FV_ADDRANK, FV_ROUND, FV_DROPTHIN, FV_EARLY**, each with a populated `frz_post_changed` and `in_H=TRUE`. |
| Only FV_EARLY is detected by Stage 5's own checks. | **C35_arms.csv → FV_EARLY row** has `s5_exit=1` and `caught_without=TRUE`; the other four harmful rows have `s5_exit=0` and `caught_without=FALSE`. |
| H \ D_abl contains four arms. | **C35_RESULTS.md → Sets**, row `H \ D_abl = {FV_VALSORT,FV_ADDRANK,FV_ROUND,FV_DROPTHIN}`; independently recomputed from raw arm rows. |
| FV_VALSORT changes content without changing file size. | **ARM MANIFESTS → B** `validated_action_list.csv`: hash `2bffa…`, 13,625,648 bytes; **FV_VALSORT row**: hash `0de2…`, same 13,625,648 bytes. |
| FV_ADDRANK and FV_ROUND alter R-A classifications while leaving standard Stage-5 outputs equal to B. | **ARM MANIFESTS → FV_ADDRANK out** and **FV_ROUND out**; R-A hashes/sizes differ, while the eight standard deeper-output hashes match B. |
| FV_DROPTHIN modifies the action list yet completes Stage 5 normally. | **C35_arms.csv → FV_DROPTHIN row** plus **ARM MANIFESTS → FV_DROPTHIN action-list/RUN_S5 rows**. |
| FV_EARLY is placed before the checks and yields the sole non-zero Stage-5 exit. | **SEED DIFFS → FV_EARLY hunk**, immediately before “Independent checks vs freeze”; **RUN LOG → FV_EARLY S5 exit=1**. |
| FV_BENIGN adds only a Stage-5 diagnostic and leaves validated hashes unchanged. | **C35_arms.csv → FV_BENIGN row** and **ARM MANIFESTS → FV_BENIGN out**, including `diag_type_by_class.csv` and baseline validated hashes. |
| No fixture rows were executed/reported for this Stage-5-only control. | **FIXTURE RESULTS → table contains header only**; SPEC states C35 does not rerun R-A/R-B. |
| The three 1-hour full-field clock mismatches pre-exist C35 and have agreeing labels. | **COORDINATOR NOTE N1** and **SPEC → Known open finding N1**. |
| P1 evaluates false because its required `H \ D_abl = ∅` condition is contradicted by a four-arm escape set. | **SPEC → Operational benefit predicate P1** combined with **C35_RESULTS.md → Sets / Predicate P1**. |

END C35 BUILDER REPORT
