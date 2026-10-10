# C34 Builder Report

## 1. Role attestation and ablation ID.

I am acting **only as Builder (ChatGPT)** for **C34**, independently and blind to the Validator. I am not performing adjudication.

**Ablation:** C34 — catalog #34, **“Deterministic Workflow Gate”**  
**Batch:** N15, batch 2 of 3  
**Constitution:** version 1.0  
**Target:** Stage 4 → Stage 5 workflow gate  
**Frozen baseline:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze `2026-09-12 23:59:59 America/Chicago`, κ = 2.  
**Assigned roles:** Builder = ChatGPT; Validator = DeepSeek; Adjudicator = Grok.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The control requires the deterministic workflow gate to return PASS before Stage 5 may start. C34 removes that enforcement dependency: the runner still constructs the Stage-4 receipt and executes/records the frozen gate, but **Stage 5 runs regardless of the gate result**. Stage 5 retains only its own internal independent-count checks and `stopifnot` checks on decision/classification/validated-list counts. The validated action list is built from R-A.

The exact seed modifications are:

| Arm | Frozen code | Seeded code | Mechanical effect |
| --- | --- | --- | --- |
| `W_RA_NOTHIN` | `check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")` | `check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")` | R-A no longer invokes the thin/missing-peer integrity clause. |
| `W_RB_NOTHIN` | `p_thin <- peer_n < RB_N_MIN` | `p_thin <- rep(FALSE, n)` | R-B no longer invokes the thin-peer predicate. |
| `W_RB_K25` | `RB_KAPPA_DEFAULT <- 2.0` | `RB_KAPPA_DEFAULT <- 2.5` | R-B production κ changes from 2.0 to 2.5. |
| `W_RB_CRASH` | no stop at entry to `rb_judge_rows()` | `stop("[seed] simulated R-B Stage-4 failure")` | R-B terminates before producing its normal outputs. |
| `W_RA_ROUND1` | `dormant_h = round(base$dormant_h, 6)` | `dormant_h = round(base$dormant_h, 1)` | R-A reports `dormant_h` at 0.1-hour precision while classifications remain unchanged. |

These are exact one-line semantic seed changes from the frozen code.

Two additional SEED-DIFF entries are explicitly harness-only path substitutions rather than semantic seeds: `build_validated_action_list.R` replaces hard-coded Chicago311 paths with `CHICAGO311_ROOT` and creates the output directory; `run_deeper_analysis.R` likewise changes its hard-coded root to `Sys.getenv("CHICAGO311_ROOT")`.

## 3. Hard mechanical facts table.

### Frozen/hash integrity

| Fact | Recalculation | Result | Basis |
| --- | --- | --- | --- |
| Baseline framework hashes | SPEC hashes compared with `BASELINE FRAMEWORK HASHES` | **2/2 equal** | Recomputed |
| Frozen code hashes named in SPEC | SPEC vs preflight | **4/4 equal** | Recomputed |
| Stage-4/5 harness files named in SPEC | SPEC vs preflight hashes | **7/7 equal** | Recomputed |
| Five seed hashes | SPEC/preflight vs changed-path hashes in arm inputs | **5/5 equal** | Recomputed |
| Frozen source inputs in seeded arms | 3 source hashes × 5 seeded arms compared with B | **15/15 equal** | Recomputed |
| Input isolation per seeded arm | Each arm has 9 listed code/data inputs; 8 equal B and exactly the declared seed file differs | **8/9 equal + 1/9 seeded, for all 5 arms** | Recomputed |
| Stage 1–3 frozen receipts | 3 hashes × 5 seeded arms compared with B | **15/15 equal** | Recomputed |
| Source variants | Packet states none | **0** | Quoted |

The B manifest establishes the frozen source/code hashes and Stage 1–3 hashes; the seeded manifests preserve those same values except for each arm's single declared input mutation.

### Baseline reconciliation and arithmetic identities

| Mechanical fact | Calculation | Result | Basis |
| --- | --- | --- | --- |
| B R-A rows | supplied reconciliation count | 222,002 | Quoted |
| B R-B rows | supplied reconciliation count | 222,002 | Quoted |
| B inner join | supplied reconciliation count | 222,002 | Quoted |
| B only-R-A | supplied | 0 | Quoted |
| B only-R-B | supplied | 0 | Quoted |
| B classification disagreements | supplied | 0 | Quoted |
| B classification agreements | `222,002 − 0` | **222,002** | Recomputed |
| R-A identity | `n_inner + n_only_ra = 222,002 + 0` | **222,002 = n_ra** | Recomputed |
| R-B identity | `n_inner + n_only_rb = 222,002 + 0` | **222,002 = n_rb** | Recomputed |
| B full-field dormant mismatches | supplied | 1 | Quoted |
| B full-field open-age mismatches | supplied | 2 | Quoted |

Thus the frozen reconciliation definition is exactly `0/0/0` for only-R-A / only-R-B / classification disagreement, while the broader full-field comparison retains the disclosed `1/2` numeric mismatches.

The three numeric baseline discrepancies are the disclosed frozen-pack finding: one `dormant_h` and two `open_age_h` differences of exactly 1.000 hour; the suggested DST explanation is explicitly unconfirmed.

### Seeded-arm mechanics

For every non-crash arm, both path key sets remain identical to B, so `n_inner = 222,002`. Therefore `n_agree = 222,002 − recon_disagree`.

| Arm | Fixtures RA / RB | Recon disagree | Recomputed n_agree | Dormant / open-age recon | Locked-field changes vs B | Decision changes vs B | Receipt / gate | Stage 5 | Stage-5 differing files |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `W_RA_NOTHIN` | 13/14 / 14/14 | 6,377 | **215,625** | 1 / 2 | 6,377 | 6,377 | FAIL / FAIL | exit 1 | 8 listed |
| `W_RB_NOTHIN` | 14/14 / 13/14 | 6,377 | **215,625** | 1 / 2 | 6,377 | 6,377 | FAIL / FAIL | exit 0 | 1 |
| `W_RB_K25` | 14/14 / 14/14 | 6,893 | **215,109** | 1 / 2 | 6,893 | 6,893 | FAIL / FAIL | exit 0 | 0 |
| `W_RB_CRASH` | 14/14 / missing | NA | NA | NA / NA | 0 reported | 0 reported | FAIL / FAIL | exit 1 | 8 listed |
| `W_RA_ROUND1` | 14/14 / 14/14 | 0 | **222,002** | 221,457 / 2 | 221,457 | 0 | PASS / PASS | exit 0 | 1 |

All quoted comparison counts and gate/Stage-5 states reproduce the raw arm and Stage-4→5 rows.

Relative to B's one dormant mismatch, `W_RA_ROUND1` increases the R-A/R-B dormant mismatch count by **221,456** (`221,457 − 1`), while the open-age mismatch count remains at the frozen baseline of 2. Its classifications still agree on all 222,002 inner rows.

### Fixture recomputation

From the raw fixture rows:

- B contributes 28/28 passes.
- `W_RA_NOTHIN` contributes 27/28; the sole failure is R-A F06, expected `INCONCLUSIVE`, observed `ESCALATE`.
- `W_RB_NOTHIN` contributes 27/28; the sole failure is R-B F06 with the same expected/observed pair.
- `W_RB_K25` contributes 28/28.
- `W_RB_CRASH` contributes 14/14 available R-A rows; R-B fixture output is absent.
- `W_RA_ROUND1` contributes 28/28.

Therefore, over fixture rows actually present, **152/154 pass**, with exactly **2 failures**, both F06 thin-peer tests.

### Portfolio and downstream hash deltas

The packet contains hashes and byte sizes for the portfolio-count artifacts, but not their CSV contents. Therefore semantic class-count deltas inside those files are **not numerically recomputable from this packet**. Hash equality and artifact-size changes are recomputable.

| Arm | R-A portfolio counts vs B | R-B portfolio counts vs B | Validated action list vs B | Stage-5 `portfolio_summary.csv` vs B |
| --- | --- | --- | --- | --- |
| `W_RA_NOTHIN` | hash differs; 137 vs 140 bytes (**−3**) | hash equal | hash differs | not completed/present as normal finished output |
| `W_RB_NOTHIN` | hash equal | hash differs; 97 vs 100 bytes (**−3**) | hash equal | hash equal |
| `W_RB_K25` | hash equal | hash differs; 102 vs 100 bytes (**+2**) | hash equal | hash equal |
| `W_RB_CRASH` | hash equal | missing | hash equal | missing |
| `W_RA_ROUND1` | hash equal | hash equal | hash differs | hash equal |

For the three seeded arms in which Stage 5 completes, direct Stage-5 hashes independently reproduce the output-difference counts: `W_RB_NOTHIN` has **7/8 equal and 1/8 different** (`kappa_sensitivity.csv`); `W_RB_K25` has **8/8 equal**; `W_RA_ROUND1` has **7/8 equal and 1/8 different** (`escalate_dormancy_summary.csv`). The runner separately reports B as having zero Stage-5 differences from the frozen Stage-5 directory.

### Recomputed sets

The packet uses “harm” in two contexts: the raw Stage-4 arm flag denotes any locked-field change, while P1 explicitly says that **for P1, H is the Stage-5 harm set**.

| Set/fact | Recomputed result | Basis |
| --- | --- | --- |
| Arms with any locked-field change vs B | `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25, W_RA_ROUND1}` | Recomputed from `locked_field_changes_vs_B > 0` |
| Arms with classification/decision changes | `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25}` | Recomputed from `decision_changes_vs_B > 0` |
| Stage-5 harm set `H` | `{W_RB_NOTHIN, W_RA_ROUND1}` | Recomputed from `stage5_exit = 0` AND differing-file count > 0 |
| `D_abl`, caught without gate | `{W_RA_NOTHIN, W_RB_CRASH}` | Recomputed from `stage5_exit != 0` |
| `H ∩ D_abl` | `∅` | Recomputed |
| `H \ D_abl` | `{W_RB_NOTHIN, W_RA_ROUND1}` | Recomputed |
| ` | H | ` | 2 | Recomputed |
| ` | D_abl | ` | 2 | Recomputed |
| ` | H \ D_abl | ` | 2 | Recomputed |
| Caught with control | `{W_RA_NOTHIN, W_RB_NOTHIN, W_RB_K25, W_RB_CRASH}` | Recomputed from gate FAIL OR Stage-5 nonzero |
| Gate FAIL + Stage-5 exit 0 + unchanged Stage-5 output | `{W_RB_K25}` | Recomputed |
| Stage-5 harm not caught by the frozen gate | `{W_RA_ROUND1}` | Recomputed |

The runner's named H-, D-, and caught sets agree with these recomputations.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 predicate is:

`H ⊆ D_abl`

with P1's explicit instruction that `H` is the **Stage-5 harm set**. Its alternative branch is triggered when `H \ D_abl` is non-empty.

The mechanically recomputed sets are:

`H = {W_RB_NOTHIN, W_RA_ROUND1}`

`D_abl = {W_RA_NOTHIN, W_RB_CRASH}`

`H ∩ D_abl = ∅`

`H \ D_abl = {W_RB_NOTHIN, W_RA_ROUND1}`

Therefore `H ⊆ D_abl` **is false**, and `H \ D_abl` **contains two arms**.

Mechanically, neither Stage-5-harm arm was stopped by Stage 5's own independent checks when the workflow-gate result is ignored. `W_RB_NOTHIN` completed Stage 5 and changed `kappa_sensitivity.csv`; `W_RA_ROUND1` completed Stage 5 and changed `escalate_dormancy_summary.csv`.

For context rather than P1 membership, `W_RA_NOTHIN` and `W_RB_CRASH` were caught without the gate because Stage 5 exited non-zero, while `W_RB_K25` completed Stage 5 with all eight outputs equal to B even though its Stage-4 reconciliation had 6,893 classification disagreements.

## 5. Fixture and reconciliation implications.

The fixture suite catches the two direct removals of the thin-peer rule exactly where expected. `W_RA_NOTHIN` fails **R-A F06** and `W_RB_NOTHIN` fails **R-B F06**; the counterpart paths remain 14/14. The observed seeded F06 result is `ESCALATE` instead of the locked expected `INCONCLUSIVE`.

`W_RB_K25` demonstrates a different protection surface: **all 28 available fixtures pass**, but cross-path reconciliation produces **6,893 classification disagreements**. Its receipt therefore fails only `reconciliation`, and the workflow gate records FAIL even though Stage 5 subsequently produces 8/8 B-identical outputs.

`W_RB_CRASH` exercises delivery/status protection. R-B exits non-zero and its fixture/classification outputs are missing; the receipt has three unresolved fields: `r_b_status`, `r_b_fixtures`, and `reconciliation`. Stage 5 also exits non-zero.

`W_RA_ROUND1` exposes the boundary of the frozen reconciliation definition. It passes **14/14 on both fixture paths**, has **0/0/0** key/classification reconciliation, receives a PASS receipt and PASS workflow-gate result, yet has **221,457 dormant_h mismatches** and produces a changed Stage-5 dormancy summary. This occurs because the frozen receipt reconciliation covers key set + classification, while the experiment's locked fields also include `dormant_h` and `open_age_h`.

The disclosed B `1/2` numeric mismatch must remain separate from seeded effects: it is already present in the frozen pack and does not alter labels.

## 6. Semantic/regression risks and unchanged surfaces.

| Surface | Evidence-backed implication |
| --- | --- |
| Removal of enforcement gate | `W_RB_NOTHIN` shows a truthful Stage-4 receipt with fixture/reconciliation failures can be followed by a successful Stage-5 run whose output differs from B if the gate result is not enforced. |
| Reliance on Stage-5 independent counts | The independent checks catch `W_RA_NOTHIN` and the missing-input `W_RB_CRASH`, but they do not catch either member of the recomputed Stage-5 harm set. |
| Frozen gate's reconciliation scope | `W_RA_ROUND1` changes a locked numeric field on 221,457 rows yet passes the key+classification reconciliation and the workflow gate. Thus gate PASS does not imply equality of every field declared locked for this experiment. |
| Stage-5 output equivalence as a proxy for Stage-4 integrity | `W_RB_K25` changes 6,893 R-B classifications but produces 8/8 B-identical Stage-5 files because downstream validated-list construction is R-A-based. Therefore unchanged Stage-5 outputs can coexist with material R-A/R-B Stage-4 disagreement. |
| “H” nomenclature | The SPEC first uses H for Stage-5 differing-output harm and later uses “Harm set H” for any Stage-4 locked-field difference. The P1 paragraph explicitly resolves its own use to the Stage-5 definition; these two concepts should not be merged when interpreting the evidence. |
| Copied receipt surfaces | `sql_source_gate`, `structural_cross_review`, and `lineage_attestation` are copied as PASS from the frozen receipt rather than rerun. Their PASS values establish preserved frozen state in this harness, not fresh execution evidence. |
| Frozen source | All five seeded arms retain all three B source hashes; no source variants are used. |
| Stage 1–3 | All 15 seeded-arm Stage 1–3 receipt/hash comparisons are equal to B. |
| Seed isolation | Each seeded arm changes exactly one of the nine listed run inputs; the other eight hashes equal B. |
| Clean arm | B reproduces both frozen classification files with zero key/label/dormant/open-age differences, has 14/14 fixtures on both paths, key/class reconciliation 0/0/0, receipt PASS, gate PASS, Stage-5 exit 0, and no reported Stage-5 difference from frozen output. |
| Harness substitution | The only harness script modifications shown in SEED DIFFS are path substitutions to `CHICAGO311_ROOT` plus output-directory creation; no decision rule is changed by those harness edits. |

The frozen receipt mechanics, including the copied PASS fields, are specified explicitly in the per-arm pipeline. The clean-arm and seeded-arm regression outcomes are recorded in the runner results.

## 7. Claim → evidence map.

| Claim | Frozen evidence location |
| --- | --- |
| C34 removes workflow-gate enforcement while still running/recording the gate and then running Stage 5. | SPEC → **Control under test / Exact change being tested**, pipeline steps 1–5; lines 38–53. |
| The five semantic seeds are thin-rule removal in R-A, thin-rule removal in R-B, κ 2.0→2.5, forced R-B crash, and R-A dormant rounding 6→1 decimals. | **SEED DIFFS**, five seed hunks; lines 884–935. |
| B reproduces the frozen classification outputs and has frozen reconciliation 0/0/0, with the separately disclosed 1 dormant and 2 open-age mismatches. | C34_RESULTS → **Arm B repro vs frozen pack**, both rows; **Arm B recon**, B row. |
| B has 222,002 inner rows and therefore 222,002 classification agreements. | C34_RESULTS → **Arm B recon**, B row; `222002 − 0 = 222002`. |
| Thin-rule removals create 6,377 classification disagreements each and fail F06 on the seeded path. | C34_RESULTS → **Seeded arms**, `W_RA_NOTHIN` and `W_RB_NOTHIN`; FIXTURE RESULTS → each arm's F06 row. |
| κ=2.5 creates 6,893 classification disagreements while all fixtures pass. | C34_RESULTS → **Seeded arms**, `W_RB_K25`; FIXTURE RESULTS → `W_RB_K25` RA/RB rows. |
| R-B crash yields missing R-B outputs, receipt failures in status/fixtures/reconciliation, and Stage-5 exit 1. | C34_RESULTS → `W_RB_CRASH`; Stage 4→gate→Stage 5 table → `W_RB_CRASH`. |
| R-A rounding changes 221,457 locked-field values, changes no classifications, passes the frozen gate, and changes one Stage-5 file. | C34_RESULTS → `W_RA_ROUND1` seeded-arm and Stage-4→5 rows. |
| Recomputed Stage-5 `H` is `{W_RB_NOTHIN,W_RA_ROUND1}` and `D_abl` is `{W_RA_NOTHIN,W_RB_CRASH}`. | SPEC → Stage-5 H / D_abl definitions; C34_stage45 rows for all five seeded arms. |
| `H ∩ D_abl = ∅` and `H \ D_abl = {W_RB_NOTHIN,W_RA_ROUND1}`. | Arithmetic over the immediately preceding two sets; corroborated by C34_RESULTS H4–H6. |
| P1 uses the Stage-5 definition of H and tests `H ⊆ D_abl`; the observed inclusion is false because the difference contains two arms. | SPEC → **Operational benefit predicate P1**, especially the explicit final sentence defining H for P1; recomputed H/D sets above. |
| The only fixture failures present in the raw rows are the two F06 failures; 152/154 available fixture rows pass. | FIXTURE RESULTS, all rows: two FALSE entries at `W_RA_NOTHIN/RA/F06` and `W_RB_NOTHIN/RB/F06`; all other present rows TRUE. |
| Stage 1–3 and frozen sources are intentionally unchanged; no source variants are used. | SPEC → path-only harness/copy statement and allowed source scope; ARM MANIFESTS hash rows. |
| Numeric portfolio-count deltas cannot be derived from the supplied packet; only their hashes/byte sizes are supplied. | ARM MANIFESTS → `RA_portfolio_counts.csv`, `RB_portfolio_counts.csv`, and Stage-5 output hash entries; no portfolio CSV contents are included. |

END C34 BUILDER REPORT
