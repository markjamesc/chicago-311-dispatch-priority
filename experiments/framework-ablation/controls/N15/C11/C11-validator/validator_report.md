# C11 Validator Report

## 1. Role attestation and ablation ID

I am acting as **Validator only** for ablation **C11 — Method Constants vs Knobs** (N15 batch 2 of 3), under Constitution version 1.0. DeepThink is on. I am blind to the Builder and have not seen or requested Builder output. I return no terminal verdict.  
Ablation ID: **C11**. Roles stated in packet: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

## 2. Independent test plan: what I checked, and how

I checked and recomputed the following from the packet’s frozen evidence tables:

1. **Frozen input hashes** against the SPEC and PREFLIGHT lines.
2. **Arm B reproduction** by comparing B outputs to frozen RA/RB classifications and hashes.
3. **Arm B recon identities** using `n_ra`, `n_rb`, `n_inner`, `n_only_ra`, `n_only_rb`, `n_disagree`, and full-field mismatch counts.
4. **Seeded-arm locked-field arithmetic**: `RA_vs_B` + `RB_vs_B` label changes vs `locked_field_changes_vs_B`.
5. **D-sets**: `H`, `D_abl` = caught-without-control set, and `H \ D_abl`.
6. **Fixture pass counts** per arm and per path from the raw fixture table.
7. **Seed diffs** to confirm only `N_MIN` / `RB_N_MIN` changed.
8. **Manifest input differences** against the declared seed files.
9. **Cross-arm hash equalities** in `ARM MANIFESTS`, including repeated RB outputs for arms sharing the same RB config.
10. **Internal consistency** of runner output against the disclosed N1 clock-mismatch note.

## 3. Independently recomputed hard facts

### 3.1 Preflight and frozen-input identities

- Source: `src_open_candidates.csv` SHA-256 `ba089fcc...` matches SPEC; row count `245193` matches MySQL preflight.
- Source: `src_peer_stats.csv` SHA-256 `cb78ae21...`; MySQL count `104`.
- Frozen R-A `run_RA.R` SHA-256 `f4e8993c...` matches SPEC.
- Frozen R-B `00_config.R` SHA-256 `6c9b0e31...` matches SPEC.
- Frozen R-B `20_integrity_and_classify.R` SHA-256 `72ac5def...` matches SPEC.
- Frozen R-B `40_fixtures.R` SHA-256 `2ad4aa69...` matches SPEC.
- Frozen outputs in preflight:

  - `R-A/outputs/RA_classifications.csv` = `c099e092...`
  - `R-B/outputs/RB_classifications.csv` = `a0e42b86...`
- These two frozen output hashes equal arm B’s output hashes in the manifest.

### 3.2 Arm B reproduction and recon

Arm B vs frozen pack:

| cmp | n_only_x | n_only_truth | n_label_diff | n_dormant_diff | n_open_age_diff |
| --- | --- | --- | --- | --- | --- |
| B R-A vs frozen RA_classifications | 0 | 0 | 0 | 0 | 0 |
| B R-B vs frozen RB_classifications | 0 | 0 | 0 | 0 | 0 |

Arm B recon R-A vs R-B:

| n_ra | n_rb | n_inner | n_only_ra | n_only_rb | n_disagree | n_dormant_mismatch | n_open_age_mismatch |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 222002 | 222002 | 222002 | 0 | 0 | 0 | 1 | 2 |

Recomputed identity:  
`n_inner = n_ra - n_only_ra = 222002 - 0 = 222002`;  
`n_inner = n_rb - n_only_rb = 222002 - 0 = 222002`;  
`n_union = n_inner + n_only_ra + n_only_rb = 222002`.  
The frozen recon definition gives `0/0/0`: `only_ra=0`, `only_rb=0`, `disagree=0`. The `dormant_h=1` and `open_age_h=2` full-field mismatches are the disclosed N1 open finding.

### 3.3 Seeded-arm locked-field arithmetic

Recomputed from `C11_arms.csv`:

| arm | RA_vs_B label | RB_vs_B label | sum | locked_field_changes_vs_B | decision_changes_vs_B | harm |
| --- | --- | --- | --- | --- | --- | --- |
| K_NMIN30_CM | 35 | 35 | 70 | 70 | 70 | TRUE |
| K_NMIN75_CM | 14 | 14 | 28 | 28 | 28 | TRUE |
| K_NMIN100_CM | 33 | 33 | 66 | 66 | 66 | TRUE |
| K_NMIN30_RB | 0 | 35 | 35 | 35 | 35 | TRUE |

All four seeded arms have `locked_field_changes_vs_B > 0`, so the harm set is:

`H = {K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}`.

Arms with no locked-field change: `{}`.

### 3.4 D_abl and H \ D_abl

`caught_without_control` set from `C11_arms.csv` / RESULTS H5:

`D_abl = {K_NMIN100_CM, K_NMIN30_RB}`.

Recomputed `H \ D_abl`:

`H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}`.

This is non-empty.

Recomputed `caught_with_control` set:

`{K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}`.

`caught_with_control` but no locked-field change: `{}`.

### 3.5 Fixture pass counts

From the raw fixture rows:

| arm | path | pass count |
| --- | --- | --- |
| B | RA | 14/14 |
| B | RB | 14/14 |
| K_NMIN30_CM | RA | 14/14 |
| K_NMIN30_CM | RB | 14/14 |
| K_NMIN75_CM | RA | 14/14 |
| K_NMIN75_CM | RB | 14/14 |
| K_NMIN100_CM | RA | 14/14 |
| K_NMIN100_CM | RB | 13/14 |
| K_NMIN30_RB | RB | 14/14 |
| K_NMIN30_RB | RA | not run; displayed as B 14/14 per RESULTS header |

The single fixture failure is `K_NMIN100_CM`, path `RB`, fixture `F14`: expected `STANDARD|STANDARD`, observed `INCONCLUSIVE|INCONCLUSIVE`, `pass=FALSE`.

### 3.6 Seed diffs and input differences

Seed diffs show only the intended constant changes:

- `RA_NMIN30__run_RA.R`: `N_MIN <- 50L` → `30L`
- `RB_NMIN30__00_config.R`: `RB_N_MIN <- 50L` → `30L`
- `RA_NMIN75__run_RA.R`: `N_MIN <- 50L` → `75L`
- `RB_NMIN75__00_config.R`: `RB_N_MIN <- 50L` → `75L`
- `RA_NMIN100__run_RA.R`: `N_MIN <- 50L` → `100L`
- `RB_NMIN100__00_config.R`: `RB_N_MIN <- 50L` → `100L`

Manifest `inputs_differing_from_B` matches the declared seed scope:

- `K_NMIN30_CM`: `R-A\run_RA.R`; `R-B\R\00_config.R`
- `K_NMIN75_CM`: `R-A\run_RA.R`; `R-B\R\00_config.R`
- `K_NMIN100_CM`: `R-A\run_RA.R`; `R-B\R\00_config.R`
- `K_NMIN30_RB`: `R-B\R\00_config.R` only

No source variants were used; all arms share the same frozen source hashes.

### 3.7 Cross-arm hash equalities

Notable equalities and differences from the manifests:

- B `RA_classifications.csv` hash `c099e092...` equals the frozen RA preflight hash.
- B `RB_classifications.csv` hash `a0e42b86...` equals the frozen RB preflight hash.
- `RA_fixture_results.csv` hash `33696cd1...` is identical for B RA, K_NMIN30_CM RA, K_NMIN75_CM RA, and K_NMIN100_CM RA.
- `RB_fixture_results.csv` hash `0d72245c...` is identical for B RB, K_NMIN30_CM RB, K_NMIN75_CM RB, and K_NMIN30_RB RB.
- K_NMIN100_CM RB `RB_fixture_results.csv` hash `31e2dec6...` is unique, consistent with its F14 failure.
- K_NMIN30_CM RB outputs match K_NMIN30_RB RB outputs on:

  - `RB_classifications.csv` = `34342fd4...`
  - `RB_kappa_grid_counts.csv` = `e3df7e29...`
  - `RB_portfolio_counts.csv` = `68ed99d7...`
  - `RB_fixture_results.csv` = `0d72245c...`
- `RA_portfolio_counts.csv` file sizes are `140` bytes for all arms that ran RA.
- `RB_portfolio_counts.csv` file sizes are `100` bytes for all arms that ran RB.
- `RB_kappa_grid_counts.csv` file sizes are `164` bytes for all arms that ran RB.

### 3.8 Internal inconsistency flags

I found no internal inconsistency that changes the mechanical facts. The apparent tension in H2 — “B recon is 0/0/0” while full-field recon shows `dormant_h=1` and `open_age_h=2` — is resolved by N1 and the frozen recon definition: `0/0/0` means only-RA, only-RB, and classification disagreements, not `dormant_h` or `open_age_h`.  
Similarly, `K_NMIN30_RB` showing `fx_RA=14/14` despite RA not running is consistent with the RESULTS header: unrun paths are taken from arm B.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the packet alone:

- The exact `SR_NUMBER` rows behind the `35`, `14`, `33`, and `35` label changes.
- The exact rows behind the `recon_disagree=35` for `K_NMIN30_RB`.
- The exact portfolio count values inside `*_portfolio_counts.csv`; only file hashes and byte sizes are available.
- The full raw stdout/stderr content beyond presence, exit status, byte size, and SHA-256.
- The actual SQL peer-extract logic and whether `W` could have been varied without a new extract.
- The confirmed root cause of N1; the packet only gives the disclosed likely daylight-saving ambiguous-hour explanation.
- The internal fixture definitions and expected-output derivation beyond the fixture table.
- Whether the `n_min` changes have any effect outside the diffed lines and observed locked fields.
- The exact row-level classification algorithm beyond code hashes and seed diffs.
- How `n_ra=222002` and `n_rb=222002` are derived from the full source profile; the packet gives aggregate source counts but not the row-level filter path.
- Builder output or Builder-Validator agreement; I am blind to the Builder by design.

## 5. P1 assessment against the frozen predicate in the SPEC

Frozen predicate:

- **P1 satisfied:** `H ⊆ D_abl`.
- **P1 failed:** `H \ D_abl` is non-empty.

Recomputed sets:

- `H = {K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}`
- `D_abl = {K_NMIN100_CM, K_NMIN30_RB}`
- `H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}`

`H \ D_abl` is non-empty. Therefore the frozen P1 predicate is **not satisfied** on the evidence as written.

Arms with no locked-field change: `{}`. They do not count for or against P1.

## 6. Blocking objections

None.

The disclosed N1 open finding is not a blocking objection under the frozen recon definition: the HALT/recon rule uses key set and classification disagreements, and those are `0/0/0` for arm B. The `dormant_h=1` and `open_age_h=2` full-field mismatches are disclosed as pre-existing in the frozen pack and are not treated as a seeded effect.  
No defect was found in the harness, seed files, predicate application, or evidence tables that should block adjudication.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Frozen source and code hashes match SPEC. | PREFLIGHT lines; SPEC SHA-256 list. |
| Arm B reproduces frozen RA/RB classifications. | B repro table all zero; B output hashes equal frozen preflight hashes. |
| Arm B recon is `0/0/0` under frozen definition. | B recon table: `only_ra=0`, `only_rb=0`, `disagree=0`. |
| Arm B full-field recon has N1 mismatches. | B recon table: `dormant=1`, `open_age=2`; N1 note. |
| All four seeded arms have locked-field changes. | `C11_arms.csv` `locked_field_changes_vs_B`: 70, 28, 66, 35; H4. |
| `D_abl = {K_NMIN100_CM, K_NMIN30_RB}`. | H5; `caught_without_control=TRUE` for those two only. |
| `H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}`. | H4 minus H5; H6. |
| K_NMIN100_CM is caught without control by fixture failure. | Fixture table: K_NMIN100_CM RB F14 `FALSE`. |
| K_NMIN30_RB is caught without control by recon disagreement. | `C11_arms.csv`: `recon_disagree=35`; `caught_without_control=TRUE`. |
| K_NMIN30_CM and K_NMIN75_CM are not caught without control. | Both have recon `0/0/0`, fixtures 14/14 both paths, exit 0; `caught_without_control=FALSE`. |
| Seed diffs only change n_min. | SEED DIFFS show only `N_MIN` / `RB_N_MIN` line changes. |
| Inputs differing from B match declared seeds. | ARM MANIFESTS `inputs_differing_from_B` per arm. |
| K_NMIN30_CM and K_NMIN30_RB share identical RB outputs. | Same RB output hashes in manifests. |
| No source variants used. | ARM MANIFESTS show only frozen source hashes. |

END C11 VALIDATOR REPORT
