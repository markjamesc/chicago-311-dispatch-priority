## 1. Role attestation and ablation ID

- Role: Validator only, DeepSeek, DeepThink on.
- Blindness: I have not seen, requested, or used the Builder output. This is an independent first pass.
- Ablation ID: C30 — Structural Cross-Review, catalog #30, N15 batch 1 of 3.
- Constitution: v1.0.
- Roles per SPEC: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.
- I do not return KEEP, REVERT, or HALT.

## 2. Independent test plan: what I checked, and how

I checked:

1. Frozen input/code/seed hashes against the SPEC and preflight lines.
2. Run-log completeness and exits for arm B and all seeded arms.
3. Arm B fixture pass counts from the raw fixture rows.
4. Arm B reproduction against frozen RA/RB classifications from the provided comparison table.
5. Arm B recon identities from the B recon table.
6. Each seeded arm’s recon columns, fixture failures, and locked-field deltas vs arm B from `C30_arms.csv`.
7. Recomputed H and D_abl from the arm table and raw fixture results.
8. Cross-arm output SHA-256 equalities from the key ARM_MANIFESTS rows.
9. Seed diffs against the frozen code for the five declared common-mode changes.
10. Internal consistency among `C30_RESULTS.md`, `C30_arms.csv`, raw fixture rows, run log, and manifests.

## 3. Independently recomputed hard facts

### Frozen hashes

- `src_open_candidates.csv`: `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` matches SPEC.
- `src_peer_stats.csv`: `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58` matches SPEC.
- `R-A/run_RA.R`: `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587` matches SPEC.
- `R-B/R/00_config.R`: `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b` matches SPEC.
- `R-B/R/20_integrity_and_classify.R`: `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99` matches SPEC.
- All five seed pairs match the SHA-256 values listed in SPEC for CM_GT, CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01.
- No source variants used.

### Run completion

- Run log records B RA/RB and all 5 seeded arms on RA+RB, all `exit=0`.
- Seeded arms with every run recorded: 5/5.
- No crash is recorded for any arm.

### Arm B fixtures and reproduction

- B RA fixtures: 14 rows, all `pass=TRUE`; 14/14.
- B RB fixtures: 14 rows, all `pass=TRUE`; 14/14.
- B R-A vs frozen `RA_classifications`: `n_only_x=0`, `n_only_truth=0`, `n_label_diff=0`, `n_dormant_diff=0`, `n_open_age_diff=0`.
- B R-B vs frozen `RB_classifications`: `n_only_x=0`, `n_only_truth=0`, `n_label_diff=0`, `n_dormant_diff=0`, `n_open_age_diff=0`.
- B recon table:

  - `n_ra=222002`, `n_rb=222002`, `n_inner=222002`
  - `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`
  - `n_dormant_mismatch=1`, `n_open_age_mismatch=2`
- Recon identity holds for B: `n_ra = n_inner + n_only_ra` and `n_rb = n_inner + n_only_rb`.

### Fixture failures per seeded arm

| Arm | RA fixtures | RB fixtures | Failing fixture(s) |
| --- | --- | --- | --- |
| B | 14/14 | 14/14 | none |
| CM_GT | 14/14 | 14/14 | none |
| CM_NODUP | 13/14 | 13/14 | F07 both paths: expected OUT_OF_SET, observed ESCALATE |
| CM_NOPARENT | 13/14 | 13/14 | F09 both paths: expected INCONCLUSIVE, observed ESCALATE |
| CM_NOTHIN | 13/14 | 13/14 | F06 both paths: expected INCONCLUSIVE, observed ESCALATE |
| CM_NOI01 | 13/14 | 13/14 | F04 both paths: expected INCONCLUSIVE, observed STANDARD |

### Locked-field deltas vs arm B

| Arm | RA_vs_B | RB_vs_B | locked_field_changes_vs_B | harm |  
|---|---|---|---|---:|---|  
| CM_GT | all 0 | all 0 | 0 | FALSE |  
| CM_NODUP | `only_x=23012`, rest 0 | `only_x=23012`, rest 0 | 46024 | TRUE |  
| CM_NOPARENT | all 0 | all 0 | 0 | FALSE |  
| CM_NOTHIN | `label=6377`, rest 0 | `label=6377`, rest 0 | 12754 | TRUE |  
| CM_NOI01 | all 0 | all 0 | 0 | FALSE |

Recomputed H = {CM_NODUP, CM_NOTHIN}.

### D_abl recomputation

D_abl definition: crash, recon key/label mismatch, or fixture failure on any path.

- Exits: all seeded arms `RA=0 RB=0`; no crash caught.
- Recon key/label mismatch columns: `recon_only_ra=0`, `recon_only_rb=0`, `recon_disagree=0` for every seeded arm.
- Fixture failures occur in CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01.
- CM_GT has no fixture failure and no recon key/label mismatch.

Recomputed D_abl = {CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01}.

### Set identities

- H = {CM_NODUP, CM_NOTHIN}
- D_abl = {CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01}
- H \ D_abl = {}
- Arms with no locked-field change = {CM_GT, CM_NOPARENT, CM_NOI01}

### Cross-arm hash equalities from manifests

- RA_classifications hash:

  - B = CM_GT = CM_NOI01 = CM_NOPARENT = `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`
  - CM_NODUP differs: `eb28be6ba3d3e634fd565856eb55dadca1482529cca66e5ebaf98e7e79959e64`
  - CM_NOTHIN differs: `40c85fac6c24a8b7e78d8f99639d7812ee90000caa20b0eb2a31e32739afbfa5`
- RB_classifications hash:

  - B = CM_GT = CM_NOI01 = CM_NOPARENT = `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
  - CM_NODUP differs: `ca411fca7a509c468b4d2854e8002adeeb6a9127a008012ea03a8599ffbb8fab`
  - CM_NOTHIN differs: `f6611d8dcec6b65e6f6a9cfee6f9b500dd5b4b2b9667b4785be42d0a28f419f8`
- RA_fixture_results hash:

  - B = CM_GT = `33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110`
  - CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01 all differ.
- RB_fixture_results hash:

  - B = CM_GT = `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
  - CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01 all differ.

### Internal inconsistencies / flags in runner output

- `C30_RESULTS.md` H2 states: “B recon is 0/0/0: TRUE” and also “B full-field recon mismatches: dormant_h 1, open_age_h 2”.
- The B recon table shows `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`, but also `n_dormant_mismatch=1`, `n_open_age_mismatch=2`.
- This is only consistent if “0/0/0” excludes `dormant_h` and `open_age_h`. The packet does not define the triple.
- Every seeded arm also shows `recon_dormant_mismatch=1` and `recon_open_age_mismatch=2`, same as B. These mismatches are therefore not seed-specific in the provided tables.
- F14 expected/observed differs between B RA and B RB: RA uses `TWO_INDEPENDENT_LABELS`; RB uses `STANDARD|STANDARD`. Each passes on its own path, but the expected-generation rule is not in the packet.

## 4. Facts that cannot be recomputed from this packet

- The frozen critical reconciliation field list.
- The exact definition of “B recon is 0/0/0”, including whether it covers `dormant_h` and `open_age_h`.
- The identity of the 1 dormant mismatch and 2 open_age mismatches in B recon.
- Full per-row recon details for seeded arms; only aggregate `recon_only_ra`, `recon_only_rb`, `recon_disagree`, `recon_dormant_mismatch`, `recon_open_age_mismatch` are given.
- Full stdout/stderr for each run; only the RUN LOG summary is provided.
- The full ARM_MANIFESTS list; only key files are included.
- Fixture expected-value generation rules; only expected/observed rows are provided.
- The full contents of frozen source data and classifications beyond hashes, row counts, and aggregate comparisons.
- Why CM_GT’s `>=` to `>` code change produced zero locked-field changes; this is plausible only if no equality cases exist, but that cannot be confirmed from the packet.

## 5. P1 assessment against the frozen predicate in the SPEC

- SPEC P1 definitions:

  - H = seeded arms whose output differs from arm B on any locked field.
  - D_abl = seeded arms caught without the control by crash, recon key/label mismatch, or fixture failure on any path.
  - P1 satisfied if H ⊆ D_abl.
  - P1 failed if H \ D_abl is non-empty.
- Recomputed H = {CM_NODUP, CM_NOTHIN}.
- Recomputed D_abl = {CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01}.
- Recomputed H \ D_abl = {}.
- Arms with no locked-field change = {CM_GT, CM_NOPARENT, CM_NOI01}; per SPEC they do not count for or against P1.
- Under the runner’s stated D_abl definition and the columns in `C30_arms.csv`, P1 is satisfied: every arm in H is also in D_abl.
- Caveat: if the SPEC’s “exact reconciliation” or “B recon is 0/0/0” is intended to include `dormant_h` and `open_age_h`, then B itself has nonzero recon mismatches, and the D_abl basis is ambiguous. This caveat is listed under blocking objections.

## 6. Blocking objections

1. **Recon 0/0/0 ambiguity / internal inconsistency.**  
   `C30_RESULTS.md` H2 says B recon is 0/0/0, but the same table and B recon table show `n_dormant_mismatch=1` and `n_open_age_mismatch=2`. The packet does not define whether 0/0/0 includes the locked recon fields `dormant_h` and `open_age_h`. If it does, the SPEC’s blocking condition on B recon is not satisfied by the evidence as written. This should block a verdict until the reconciliation field list and the 0/0/0 definition are frozen or clarified.
2. **D_abl predicate application ambiguity.**  
   D_abl as applied counts recon key/label mismatch, not the `dormant_h`/`open_age_h` recon mismatches shown in the same recon table. If exact recon is supposed to include those fields, then D_abl undercounts or misclassifies caught arms. If it is not supposed to include them, the packet does not explain why those columns are present as recon mismatches. This affects the P1 assessment basis.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Frozen source/data/code hashes match SPEC | PREFLIGHT frozen OK lines |
| Seed hashes match SPEC | PREFLIGHT seed OK lines and SPEC seed hash list |
| All seeded arms recorded and exited 0 | RUN LOG lines for all 10 seeded RA/RB runs |
| B fixtures 14/14 both paths | Raw fixture rows for B RA and B RB; `C30_RESULTS.md` H1 |
| B reproduces frozen pack | B R-A vs frozen RA and B R-B vs frozen RB tables, all differences 0 |
| B recon identities hold | B recon table: `222002 = 222002 + 0` on both sides |
| H = {CM_NODUP, CM_NOTHIN} | `C30_arms.csv` locked-field deltas: CM_NODUP 46024; CM_NOTHIN 12754; others 0 |
| D_abl = {CM_NODUP, CM_NOPARENT, CM_NOTHIN, CM_NOI01} | `C30_arms.csv` exits 0; recon key/label columns 0; fixture failures F07, F09, F06, F04 |
| H \ D_abl = {} | Set computation from recomputed H and D_abl |
| Cross-arm classification hash equalities | ARM_MANIFESTS: B=CM_GT=CM_NOI01=CM_NOPARENT for RA/RB classifications |
| CM_NODUP and CM_NOTHIN differ from B | ARM_MANIFESTS unique classification and fixture hashes |
| Internal inconsistency in H2 | `C30_RESULTS.md` H2 vs B recon table `n_dormant_mismatch=1`, `n_open_age_mismatch=2` |
| P1 satisfied under runner definitions | Recomputed H ⊆ D_abl and H \ D_abl = {} |

END C30 VALIDATOR REPORT
