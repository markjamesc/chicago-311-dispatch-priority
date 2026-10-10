# C27 VALIDATOR REPORT

## 1. Role attestation and ablation ID

I am DeepSeek, acting as Validator only for ablation **C27**. I have not seen the Builder output and have not asked for it. I do not return a terminal disposition in this report. Role assignment matches the frozen SPEC: Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. Constitution version = 1.0. Ablation frozen at CT 2026-10-03 before runner execution.

## 2. Independent test plan: what I checked, and how

I checked the packet by:

- Verifying the frozen SPEC identifiers, role assignments, source hashes, framework hashes, and preflight gating result.
- Recomputing clean-arm reconciliation identities from `C27_RESULTS.md`.
- Recomputing clean-arm reproduction counts from `C27_RESULTS.md`.
- Recomputing `D_fix`, `D_abl`, `D_fix \ D_abl`, and the caught-by-neither set from the mutant table.
- Checking per-mutant reconciliation identities: `n_rb`, `n_only_ra`, `n_only_rb`, `n_disagree`, and `prod_rows_changed_vs_clean_RB`.
- Checking cross-arm SHA-256 equalities between clean R-B output, mutant R-B outputs, and frozen preflight outputs.
- Checking mutant seed input hashes against `runner/SEEDS.sha256` values shown in preflight and `C27_ARM_MANIFESTS.txt`.
- Checking seed diffs against the declared rule deletions.
- Checking the run log for completeness of all arms and mutants.
- Flagging internal inconsistencies in the runner output and missing raw evidence.

## 3. Independently recomputed hard facts

### Frozen/preflight facts

- `src_open_candidates.csv` SHA-256 = `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`; row count from read-only MySQL preflight = **245,193**.
- `src_peer_stats.csv` SHA-256 = `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`; row count = **104**.
- Framework hashes match the two frozen baseline framework hashes in the packet.
- Preflight gating result = **PASS**.
- R version = **4.6.1**; package versions are as listed in preflight.

### Clean arm facts

- R-A exit = **0**; R-B exit = **0**.
- R-A fixtures = **14/14**; R-B fixtures = **14/14**.
- Clean R-A vs frozen `RA_classifications`: `n_x = 222002`, `n_truth = 222002`, `n_only_x = 0`, `n_only_truth = 0`, `n_label_diff = 0`, `n_dormant_diff = 0`, max abs deltas = **0**.
- Clean R-B vs frozen `RB_classifications`: `n_x = 222002`, `n_truth = 222002`, `n_only_x = 0`, `n_only_truth = 0`, `n_label_diff = 0`, `n_dormant_diff = 0`, max abs deltas = **0**.
- Clean recon: `n_ra = 222002`, `n_rb = 222002`, `n_inner = 222002`, `n_only_ra = 0`, `n_only_rb = 0`, `n_agree = 222002`, `n_disagree = 0`.
- Identity check: `n_ra - n_only_ra = 222002 = n_inner`; `n_rb - n_only_rb = 222002 = n_inner`; `n_agree + n_disagree = 222002`. Consistent.
- Clean R-A output hash `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9` equals frozen `R-A\outputs\RA_classifications.csv`.
- Clean R-B output hash `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` equals frozen `R-B\outputs\RB_classifications.csv`.

### D-set recomputation

From the mutant table:

- `D_fix` = mutants with `rb_fixtures < 14/14` or crash = **{M01, M02, M04, M05, M06, M07, M08}**. Size = **7**.
- `D_abl` = mutants with recon not clean (`n_only_ra > 0` or `n_only_rb > 0` or `n_disagree > 0`) or crash = **{M01, M04, M05, M06}**. Size = **4**.
- `D_fix \ D_abl` = **{M02, M07, M08}**. Size = **3**.
- Caught by neither regime = **{M03, M09}**. Size = **2**.
- `D_abl` is a subset of `D_fix`: all of M01, M04, M05, M06 are also in `D_fix`.
- Therefore `D_fix ⊆ D_abl` is **false**.

These match runner H4, H5, H6, and H7.

### Per-mutant hard identities

| Mutant | n_rb | only_ra | only_rb | disagree | prod_rows_changed | identity check | RB output hash vs clean |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M01 | 222002 | 0 | 0 | 16973 | 16973 | `222002 + 0 = 222002`; prod delta = disagree | differs |
| M02 | 222002 | 0 | 0 | 0 | 0 | `222002 + 0 = 222002` | equals clean |
| M03 | 222002 | 0 | 0 | 0 | 0 | `222002 + 0 = 222002` | equals clean |
| M04 | 222002 | 0 | 0 | 6377 | 6377 | `222002 + 0 = 222002`; prod delta = disagree | differs |
| M05 | 245014 | 0 | 23012 | 0 | 23012 | `222002 + 23012 = 245014`; prod delta = only_rb | differs |
| M06 | 222176 | 0 | 174 | 0 | 174 | `222002 + 174 = 222176`; prod delta = only_rb | differs |
| M07 | 222002 | 0 | 0 | 0 | 0 | `222002 + 0 = 222002` | equals clean |
| M08 | 222002 | 0 | 0 | 0 | 0 | `222002 + 0 = 222002` | equals clean |
| M09 | 222002 | 0 | 0 | 0 | 0 | `222002 + 0 = 222002` | equals clean |

### Fixture failure facts

- M01: 12/14; failed F03; F10.
- M02: 13/14; failed F04.
- M03: 14/14; no failed IDs.
- M04: 13/14; failed F06.
- M05: 13/14; failed F07.
- M06: 13/14; failed F08.
- M07: 13/14; failed F09.
- M08: 13/14; failed F12.
- M09: 14/14; no failed IDs.

### Cross-arm hash equalities and seed hashes

- All mutant `20_integrity_and_classify.R` input hashes match the corresponding `seeds/C27/Mxx_20_integrity_and_classify.R` hashes shown in preflight and `C27_ARM_MANIFESTS.txt`.
- Mutant R-B output hashes equal clean R-B output hash for **M02, M03, M07, M08, M09**.
- Mutant R-B output hashes differ from clean R-B output hash for **M01, M04, M05, M06**.
- Run log records exits for B RA, B RB, and M01–M09. All recorded exits are **0**. No missing mutant run is evident from the run log.

### Internal inconsistencies flagged in runner output

1. **M03 and M09 fixture-protection inconsistency.**  
   M03 is described as “I02 mod<created sub-clause deleted (F05)” but reports `rb_fixtures = 14/14`, no failed fixture IDs, clean recon, and zero production-row change.  
   M09 is described as “I02 missing-CREATED deleted (F13)” but reports `rb_fixtures = 14/14`, no failed fixture IDs, clean recon, and zero production-row change.  
   If the parenthetical fixture IDs denote the fixtures intended to protect those rules, then either the seeds are not actually exercised by those fixtures or the fixtures do not protect those sub-clauses as claimed. This does not alter the recomputed D-sets, but it is a seed/fixture-coverage inconsistency.
2. **M01 coverage-vs-failure set.**  
   M01 is labeled with coverage `(F01-F03,F10,F11)` but only F03 and F10 are listed as failed. This is not necessarily inconsistent if the parenthetical is a coverage list rather than a predicted failure list, but the runner output does not distinguish those meanings.
3. **Manifest categorization defect.**  
   `C27_ARM_MANIFESTS.txt` notes that `run_RA.R` / `run_RB.R` are listed under `MANIFEST_outputs` instead of `MANIFEST_inputs` because the runner’s `RUN_*` file filter is case-insensitive. The hashes for `run_RA.R` match the frozen preflight input hash, so this is a manifest categorization defect rather than an observed code mutation.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the packet as provided:

- Row-level classifications for clean or mutant arms.
- Per-fixture actual versus expected outputs.
- The full contents of `C27_baseline_recon.csv`, `C27_mutants.csv`, `C27_repro.csv`, and the full arm manifests.
- Exact `n_inner` and `n_agree` per mutant from raw recon output. These can be partly inferred from the summary table and clean R-A count, but not verified from raw rows.
- R-A fixture results for each mutant run. The packet does not show per-mutant R-A fixture counts; I can only infer that R-A is unchanged and that the ablated regime would run R-A fixtures.
- stdout/stderr logs for each run. Only the run log summary is present.
- The exact rows changed by M01, M04, M05, and M06.
- Independent verification that M03 and M09 truly leave all fixture expecteds unchanged, versus a fixture harness defect.

## 5. P1 assessment against the frozen predicate

The frozen predicate states:

- **P1 satisfied:** `D_fix ⊆ D_abl`.
- **P1 failed:** `D_fix \ D_abl` is non-empty.

Independently recomputed from the mutant table:

- `D_fix = {M01, M02, M04, M05, M06, M07, M08}`
- `D_abl = {M01, M04, M05, M06}`
- `D_fix \ D_abl = {M02, M07, M08}`

`D_fix \ D_abl` is non-empty. Therefore the frozen predicate’s **P1-failed condition is met** on this pack. The mutants M02, M07, and M08 are detected by R-B fixtures but are not detected by the ablated regime’s R-A fixtures plus exact recon against R-A. M03 and M09 are caught by neither regime and do not count for or against P1 under the frozen predicate.

## 6. Blocking objections

1. **Missing raw evidence for required mechanical facts.**  
   The packet provides summary tables and hashes, but not the raw per-fixture actuals/expecteds, full recon CSVs, row-level classifications, or stdout/stderr. Under the frozen constitution’s evidence requirement, a claim that fixtures passed or that recon was clean must be backed by raw execution evidence. The summary tables are internally consistent, but the raw artifacts are not present in this packet for independent row-level verification. This should block a verdict unless the adjudicator has access to the raw files whose hashes are listed in `C27_EVIDENCE.sha256`.
2. **Seed/fixture coverage inconsistency for M03 and M09.**  
   M03 and M09 are described as fixture-protected rule deletions with associated fixture IDs F05 and F13, but both pass 14/14, show clean recon, and produce zero production-row change. This indicates the frozen seed set or fixture suite does not actually exercise those deletions as claimed. This is a defect in the ablation design evidence, though it does not change the recomputed P1 D-sets.
3. **Manifest categorization defect.**  
   The arm manifests place `run_RA.R` / `run_RB.R` under output manifests because of a case-insensitive `RUN_*` filter. The hashes match frozen inputs, so this is not an observed mutation, but it means the manifest’s input/output categorization is not reliable as a changed-file-set proof without manual correction.

## 7. Claim → evidence map

| Claim | Evidence in packet |
| --- | --- |
| C27 role assignment is Validator = DeepSeek | SPEC “Roles” line |
| Preflight source hashes and row counts match SPEC | PREFLIGHT block |
| Clean R-A and R-B reproduce frozen labels | `C27_RESULTS.md` clean arm repro table |
| Clean recon is 0/0/0 | `C27_RESULTS.md` clean arm recon table |
| Clean R-A output hash equals frozen R-A output | PREFLIGHT + `C27_ARM_MANIFESTS.txt` B out |
| Clean R-B output hash equals frozen R-B output | PREFLIGHT + `C27_ARM_MANIFESTS.txt` B out |
| `D_fix = {M01,M02,M04,M05,M06,M07,M08}` | `C27_RESULTS.md` H4 + mutant `rb_fixtures` column |
| `D_abl = {M01,M04,M05,M06}` | `C27_RESULTS.md` H5 + mutant recon columns |
| `D_fix \ D_abl = {M02,M07,M08}` | `C27_RESULTS.md` H6 + recomputation |
| Caught by neither = `{M03,M09}` | `C27_RESULTS.md` H7 + recomputation |
| All mutant runs present | RUN LOG + `C27_RESULTS.md` H3 |
| Seed input hashes match declared seeds | PREFLIGHT seed OK lines + `C27_ARM_MANIFESTS.txt` M01–M09 input hashes |
| M02, M03, M07, M08, M09 R-B outputs equal clean R-B output | `C27_ARM_MANIFESTS.txt` output hashes vs clean B out |
| M01, M04, M05, M06 R-B outputs differ from clean R-B output | `C27_ARM_MANIFESTS.txt` output hashes vs clean B out |
| P1-failed condition is met | Recomputed `D_fix \ D_abl = {M02,M07,M08}` non-empty |
| Raw per-fixture/recon artifacts are not in packet | `C27_EVIDENCE.sha256` lists files, but their contents are not included |

END C27 VALIDATOR REPORT
