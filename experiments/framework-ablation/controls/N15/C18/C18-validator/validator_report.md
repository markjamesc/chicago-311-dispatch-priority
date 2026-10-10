# C18 VALIDATOR REPORT — DeepSeek

## 1. Role attestation and ablation ID

I am DeepSeek, acting only as Validator, DeepThink on. I have not seen the Builder output and I do not ask for it. I am blind to the Builder first pass.

Ablation ID: **C18**. Batch: **N15 batch 2 of 3**. Control under test: **No Fixture Rewrite on Fail**. Roles per frozen SPEC: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Constitution version 1.0. Target stage: Stage 4 fixture failures.

I return no terminal adjudication state.

## 2. Independent test plan: what I checked, and how

I checked the packet by:

1. Recomputing all hard numbers available from `C18_RESULTS.md`, `C18_arms.csv`, the per-arm fixture rows, the manifests, the preflight, and the seed diffs.
2. Verifying frozen input hashes against the SPEC and preflight.
3. Reconstructing the arm B truth reference from the repro table, recon table, fixture rows, and output-file hashes.
4. Recomputing H, H_RW, D_abl, and H_RW \ D_abl from the arm table and the frozen definitions.
5. Recomputing fixture pass/fail counts from the raw fixture rows, not from the summary columns alone.
6. Checking cross-arm output hash equalities in the manifests to confirm which classification, portfolio, kappa-grid, and fixture-result files changed.
7. Checking seed diffs against the declared defect/rewrite descriptions.
8. Checking the disclosed open finding N1 against the B recon counts.
9. Checking the P1 subset condition from the frozen SPEC using only frozen evidence.

## 3. Independently recomputed hard facts

### 3.1 Frozen inputs and seed hashes

Preflight frozen checks pass for the declared hashes:

- `src_open_candidates.csv`: `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`; COUNT 245,193.
- `src_peer_stats.csv`: `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`; COUNT 104.
- `R-A/run_RA.R`: `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`.
- `R-B/R/00_config.R`: `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`.
- `R-B/R/20_integrity_and_classify.R`: `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`.
- `R-B/R/40_fixtures.R`: `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`.

All listed C18 seed hashes in the preflight match the SPEC seed hashes. No source variants are used in this control.

### 3.2 Run log and missing runs

All declared seeded runs are present:

- Arm B: RA exit=0, RB exit=0.
- FX_CM_NOTHIN: RA exit=0, RB exit=0.
- RW_CM_NOTHIN: RA exit=0, RB exit=0.
- FX_CM_NODUP: RA exit=0, RB exit=0.
- RW_CM_NODUP: RA exit=0, RB exit=0.
- FX_CM_NOI01: RA exit=0, RB exit=0.
- RW_CM_NOI01: RA exit=0, RB exit=0.
- FX_RB_NOTHIN: RB exit=0.
- RW_RB_NOTHIN: RB exit=0.

Seeded arms with every run recorded: **8/8**. No seeded arm crashed. No seeded run is missing from the run log or manifests.

### 3.3 Arm B truth reference

Arm B repro vs frozen pack:

| comparison | n_only_x | n_only_truth | n_label_diff | n_dormant_diff | n_open_age_diff |
| --- | --- | --- | --- | --- | --- |
| B R-A vs frozen RA_classifications | 0 | 0 | 0 | 0 | 0 |
| B R-B vs frozen RB_classifications | 0 | 0 | 0 | 0 | 0 |

Arm B output hashes also match the frozen classification outputs:

- B RA classifications `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9` = frozen RA classifications.
- B RB classifications `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` = frozen RB classifications.

Arm B recon (R-A vs R-B):

| n_ra | n_rb | n_inner | n_only_ra | n_only_rb | n_disagree | n_dormant_mismatch | n_open_age_mismatch |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 222002 | 222002 | 222002 | 0 | 0 | 0 | 1 | 2 |

Identity check: `n_inner = n_ra - n_only_ra = 222002 - 0 = 222002`; also `n_inner = n_rb - n_only_rb = 222002 - 0 = 222002`. Holds.

Arm B fixtures: RA 14/14, RB 14/14. Raw rows confirm the only path-specific fixture label difference is F14: B RA F14 expected/observed `TWO_INDEPENDENT_LABELS`; B RB F14 expected/observed `STANDARD|STANDARD`.

### 3.4 Fixture pass/fail counts recomputed from raw rows

| arm | RA fixtures | RB fixtures | failing fixture(s) |  
|---|---|---:|---:|---|  
| B | 14/14 | 14/14 | none |  
| FX_CM_NOTHIN | 13/14 | 13/14 | F06 on both |  
| RW_CM_NOTHIN | 14/14 | 14/14 | none |  
| FX_CM_NODUP | 13/14 | 13/14 | F07 on both |  
| RW_CM_NODUP | 14/14 | 14/14 | none |  
| FX_CM_NOI01 | 13/14 | 13/14 | F04 on both |  
| RW_CM_NOI01 | 14/14 | 14/14 | none |  
| FX_RB_NOTHIN | 14/14 from B | 13/14 | F06 on RB |  
| RW_RB_NOTHIN | 14/14 from B | 14/14 | none |

### 3.5 Harm set and D-sets

From the arm table, recomputed:

- **H** = seeded arms whose output differs from arm B on any locked field = `{FX_CM_NOTHIN, RW_CM_NOTHIN, FX_CM_NODUP, RW_CM_NODUP, FX_RB_NOTHIN, RW_RB_NOTHIN}`. Size 6.
- **H_RW** = RW arms in H = `{RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN}`. Size 3.
- **D_abl** = RW arms caught without the control = `{RW_RB_NOTHIN}`. Size 1.
- **H_RW \ D_abl** = `{RW_CM_NOTHIN, RW_CM_NODUP}`. Size 2.
- Arms with no locked-field change = `{FX_CM_NOI01, RW_CM_NOI01}`. Size 2.
- Caught with the control = `{FX_CM_NOTHIN, FX_CM_NODUP, FX_CM_NOI01, FX_RB_NOTHIN}`. Size 4.
- FX arms in H not caught with the control = `{}`. Size 0.

Locked-field change arithmetic:

| arm | RA change vs B | RB change vs B | locked_field_changes_vs_B | decision_changes_vs_B |
| --- | --- | --- | --- | --- |
| FX_CM_NOTHIN | label=6377 | label=6377 | 12754 | 12754 |
| RW_CM_NOTHIN | label=6377 | label=6377 | 12754 | 12754 |
| FX_CM_NODUP | only_x=23012 | only_x=23012 | 46024 | 46024 |
| RW_CM_NODUP | only_x=23012 | only_x=23012 | 46024 | 46024 |
| FX_CM_NOI01 | 0 | 0 | 0 | 0 |
| RW_CM_NOI01 | 0 | 0 | 0 | 0 |
| FX_RB_NOTHIN | 0 | label=6377 | 6377 | 6377 |
| RW_RB_NOTHIN | 0 | label=6377 | 6377 | 6377 |

Decision changes equal locked-field changes in every row.

### 3.6 Cross-arm hash equalities

Key classification-file hash equalities:

- B RA classifications = FX_CM_NOI01 RA = RW_CM_NOI01 RA = `c099e092...`.
- B RB classifications = FX_CM_NOI01 RB = RW_CM_NOI01 RB = `a0e42b86...`.
- FX_CM_NOTHIN RA classifications = RW_CM_NOTHIN RA = `40c85fac...`; differs from B RA.
- FX_CM_NOTHIN RB classifications = RW_CM_NOTHIN RB = FX_RB_NOTHIN RB = RW_RB_NOTHIN RB = `f6611d8d...`; differs from B RB.
- FX_CM_NODUP RA classifications = RW_CM_NODUP RA = `eb28be6b...`; differs from B RA.
- FX_CM_NODUP RB classifications = RW_CM_NODUP RB = `ca411fca...`; differs from B RB.

Portfolio-count file hash equalities:

- B RA portfolio = FX_CM_NOI01 RA = RW_CM_NOI01 RA = `b5888db2...`.
- B RB portfolio = FX_CM_NOI01 RB = RW_CM_NOI01 RB = `eb677bc1...`.
- FX_CM_NOTHIN RA portfolio = RW_CM_NOTHIN RA = `94cf2ea6...`; differs from B RA.
- FX_CM_NOTHIN RB portfolio = RW_CM_NOTHIN RB = FX_RB_NOTHIN RB = RW_RB_NOTHIN RB = `c9982cb1...`; differs from B RB.
- FX_CM_NODUP RA portfolio = RW_CM_NODUP RA = `499ea6f0...`; differs from B RA.
- FX_CM_NODUP RB portfolio = RW_CM_NODUP RB = `af0711a2...`; differs from B RB.

Kappa-grid hash equalities:

- B RB kappa = FX_CM_NOI01 RB = RW_CM_NOI01 RB = `7a18fcb1...`.
- FX_CM_NOTHIN RB kappa = RW_CM_NOTHIN RB = FX_RB_NOTHIN RB = RW_RB_NOTHIN RB = `9346c86d...`; differs from B RB.
- FX_CM_NODUP RB kappa = RW_CM_NODUP RB = `1214c489...`; differs from B RB.

### 3.7 Internal inconsistencies flagged

1. N1 is internally consistent: B full-field recon shows dormant_h mismatch 1 and open_age_h mismatch 2, matching the coordinator note of three rows: SR22-01936870 dormant_h, and SR25-02017553/SR25-02017556 open_age_h. Labels agree. This is disclosed and excluded from the frozen B recon 0/0/0 definition.
2. F14 has a path-specific fixture expectation in the raw fixture rows: B RA F14 expected/observed `TWO_INDEPENDENT_LABELS`; B RB F14 expected/observed `STANDARD|STANDARD`. This is not accompanied by any B recon key/label disagreement. It is an observed path-specific fixture expectation. The packet does not include an external frozen fixture-expected list to decide whether this path-specific difference is intended.
3. The raw `C18_arms.csv` column `caught_without_control` is TRUE for some FX arms, but the SPEC defines D_abl only for RW_ arms. `C18_RESULTS.md` H5 correctly restricts D_abl to RW_ arms. This is a raw-column labeling difference, not a numeric conflict with the H5 set.
4. No other arithmetic inconsistency was found in the runner output.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the supplied packet:

- Actual contents of `RA_portfolio_counts.csv`, `RB_portfolio_counts.csv`, `RB_kappa_grid_counts.csv`, and the fixture-result CSV files beyond the rows and hashes provided.
- Actual stdout/stderr contents; only hashes and byte counts are present.
- Actual exit-file contents; only hashes and the run log exits are present.
- Row-level classification files; only summaries and file hashes are present.
- The exact SR_NUMBER keys behind the 6377 label changes, the 23012 only_x changes, and the N1 dormant/open_age rows, except for the N1 row identifiers disclosed in the coordinator note.
- Whether the N1 clock mismatch is caused by a daylight-saving ambiguous-hour read; the note says this is not confirmed.
- Numeric portfolio deltas; only hash equality/inequality can be inferred.
- Builder’s first-pass numbers; Validator is blind to them.
- Whether the F14 path-specific fixture expectation is an intended part of the frozen fixture suite or an artifact, because no external frozen fixture-expected table is in the packet.
- The exact SQL preflight query text; only the COUNT result is shown.

## 5. P1 assessment against the frozen predicate

Frozen P1: **H_RW ⊆ D_abl**.

From the frozen evidence:

- H_RW = `{RW_CM_NOTHIN, RW_CM_NODUP, RW_RB_NOTHIN}`.
- D_abl = `{RW_RB_NOTHIN}`.
- H_RW \ D_abl = `{RW_CM_NOTHIN, RW_CM_NODUP}`.

The subset condition H_RW ⊆ D_abl is not met by the frozen evidence. The non-empty difference contains two RW arms: `RW_CM_NOTHIN` and `RW_CM_NODUP`. These two arms changed locked output fields versus arm B and passed their rewritten fixtures without being caught by crash, recon key/label mismatch, or remaining fixture failure after the rewrite.

Arms with no locked-field change (`FX_CM_NOI01`, `RW_CM_NOI01`) do not count for or against P1 under the frozen predicate.

No terminal state is stated here.

## 6. Blocking objections

No blocking objection is supported by the frozen packet under the frozen definitions.

Open findings that are not blocking on the evidence as supplied:

- N1: B full-field recon shows dormant_h 1 and open_age_h 2 mismatches. This is disclosed, labels agree, and the frozen B recon 0/0/0 definition excludes dormant_h and open_age_h. B repro vs frozen RA/RB classifications is 0 on all locked fields.
- F14 path-specific fixture expectation: RA uses `TWO_INDEPENDENT_LABELS`, RB uses `STANDARD|STANDARD` for F14. This does not affect B’s 14/14 fixture pass on either path. If the frozen fixture suite were required to have identical expected labels across paths, this would require separate adjudication; the packet does not contain an external frozen fixture-expected list to establish that requirement.
- Raw `caught_without_control` column in `C18_arms.csv` is not restricted to RW_ arms, while the SPEC D_abl definition is restricted to RW_ arms. The RESULTS H5 set is correctly restricted. This is a labeling inconsistency in the raw table, not a hard mechanical conflict.

## 7. Claim → evidence map

| claim | evidence |
| --- | --- |
| Role separation is as declared | SPEC role line: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; Validator packet only |
| Frozen inputs match SPEC | Preflight frozen OK lines; SPEC hashes; source counts 245193/104 |
| Seed hashes match SPEC | Preflight seed OK lines; SPEC seed SHA-256 list |
| No source variants used | Packet line “(no source variants used)” |
| Arm B reproduces frozen pack | C18_RESULTS repro table: all 0; B output hashes match frozen RA/RB classification hashes |
| B recon key/label is 0/0/0 | B recon table: only_ra=0, only_rb=0, disagree=0 |
| B full-field recon has N1 mismatches | B recon table: dormant=1, open_age=2; coordinator note N1 rows |
| B fixtures are 14/14 both paths | Raw fixture rows for B RA and B RB |
| All seeded runs recorded | Run log; manifests exit files; H3 8/8 |
| H set | C18_arms.csv harm column and locked-field changes; recomputed H = 6 arms |
| H_RW set | H intersected with RW arms; recomputed H_RW = 3 arms |
| D_abl set | H5 and C18_arms.csv caught_without_control for RW arms; recomputed D_abl = `{RW_RB_NOTHIN}` |
| H_RW \ D_abl is non-empty | Recomputed difference `{RW_CM_NOTHIN, RW_CM_NODUP}` |
| Locked change arithmetic | Arm table label/only_x sums: 12754, 46024, 6377; decision changes equal locked changes |
| Fixture rewrite effect | FX vs RW fixture rows: F06/F07/F04 fail under FX and pass under RW |
| Cross-arm hash equalities | Manifests for classifications, portfolios, kappa grids |
| Seed diffs match declared defects/rewrites | `SEED_DIFFS_b2.txt` for RA_NOTHIN, RB_NOTHIN, RA_NODUP, RB_NODUP, RA_NOI01, RB_NOI01 and F06/F07/F04 rewrites |
| P1 subset condition not met | H_RW and D_abl recomputed from frozen tables |

END C18 VALIDATOR REPORT
