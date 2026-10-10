# C33 Validator Report

## 1. Role attestation and ablation ID

I am DeepSeek, acting as Validator only for ablation ID C33. DeepThink is on. I am blind to the Builder and have not seen or requested the Builder output. I do not return KEEP, REVERT, or HALT.

## 2. Independent test plan: what I checked, and how

I checked the frozen SPEC, Constitution, preflight, run log, `C33_RESULTS.md`, `C33_EVIDENCE.sha256`, arm manifests, seed diffs, and the label-flip CSV. I recomputed arithmetic from the evidence tables: run counts, exit/fixture counts, portfolio sums and deltas, reconciliation identities, label-diff counts, dormant-hour shift counts, and cross-arm hash equalities. I compared the runner’s prose claims against the numeric tables. I checked the P1 predicate literally against the evidence. I did not use Builder output or external files.

## 3. Independently recomputed hard facts

### Runs and fixtures

- Four runs are listed: B RA, B RB, X1 RB, X2 RA.
- All four have `exit=0`.
- All four list fixtures as `14/14` passed with no failures.
- Fixture failure count is blank/zero in the runs table.

### Identity checks

- `n = 222002` is consistent across recon, portfolio, and vs-contract tables.
- B R-A portfolio sum: `131968 + 6377 + 83657 = 222002`.
- B R-B portfolio sum: `131968 + 6377 + 83657 = 222002`.
- X1 R-B portfolio sum: `132072 + 6377 + 83553 = 222002`.
- X2 R-A portfolio sum: `132072 + 6377 + 83553 = 222002`.
- X1 recon sum: `221898 agree + 104 disagree = 222002`; `n_inner=222002`; `n_only_ra=0`; `n_only_rb=0`.
- X2 recon sum: `222002 agree + 0 disagree = 222002`; `n_inner=222002`; `n_only_ra=0`; `n_only_rb=0`.

### Portfolio deltas vs B

- X1 R-B vs B R-B: `ESCALATE +104`, `INCONCLUSIVE 0`, `STANDARD -104`.
- X2 R-A vs B R-A: `ESCALATE +104`, `INCONCLUSIVE 0`, `STANDARD -104`.
- This matches the 104 label flips moving from STANDARD to ESCALATE.

### Label diffs

- B R-A vs frozen RA_classifications: `0` label diffs; `0` only rows.
- B R-B vs frozen RB_classifications: `0` label diffs; `0` only rows.
- X1/X2 R-B(pre-contract) vs B R-B(contract): `104` label diffs.
- X2 R-A(no-contract) vs B R-A(contract): `104` label diffs.
- Runner H3 says “total 208.” That is consistent if counting the distinct ablated paths: R-B path = 104 and seeded R-A path = 104. If counting every ablated execution separately, X2 R-B would add another 104 only if X2 R-B were a separate run; the runs table does not list X2 R-B separately, so it is presumably reusing X1 R-B.

### Dormant-hour shifts

- B repro checks: `n_dormant_diff=0`; `max_abs_d_dormant_h=0`; `max_abs_d_open_age_h=0`.
- X1/X2 R-B vs B R-B: `n_dormant_diff=222002`; `max_abs_d_dormant_h=6`; `max_abs_d_open_age_h=6`.
- X2 R-A vs B R-A: `n_dormant_diff=222002`; `max_abs_d_dormant_h=6`; `max_abs_d_open_age_h=6`.
- First 12 label-flip rows show `dormant_h_ablated - dormant_h_contract = 5.0 h` exactly for every listed row. The full set is not present, so the aggregate `222002` and `max 6` cannot be independently recomputed beyond the runner table.

### D-set / disagreement set

- X1 disagreement set: `n_disagree=104`, listed label pair `STANDARD` (R-A) vs `ESCALATE` (R-B), count `104`.
- X2 disagreement set: `n_disagree=0`.
- The first 12 label-flip rows show ablated class `ESCALATE`, contract class `STANDARD`, with +5 h dormant shift.

### Cross-arm hash equalities

- `src_open_candidates.csv`: preflight hash `ba089fcc…d81b9` equals B in, X1 in, and X2 in.
- `R-B\R\20_integrity_and_classify.R`: preflight hash `72ac5def…1d99` equals B in and X1 in.
- `R-B\R\10_io_parse.R`: B in uses preflight frozen hash `40e67d83…154a`; X1 in uses seed hash `8df344f5…4866`. This is a declared changed file.
- `R-A\run_RA.R`: B out lists frozen hash `f4e8993c…8587`; X2 out lists seed hash `65772bee…f03`. This is a declared changed file.
- `R-A\outputs\RA_classifications.csv`: B out hash `c099e092…e0d9` equals preflight frozen RA hash.
- `R-B\outputs\RB_classifications.csv`: B out hash `a0e42b86…e193` equals preflight frozen RB hash.
- X1 out `RB_classifications.csv` hash `87c15c88…f00e` differs from B/frozen.
- X2 out `RA_classifications.csv` hash `a67a9b9d…964b` differs from B/frozen.
- `C33_EVIDENCE.sha256` lists evidence-file hashes, but the underlying evidence files are not in the packet, so those hashes cannot be independently recomputed here.

### Internal inconsistencies in runner output

- H6 says “fixtures detect the ablated defect,” but every listed fixture result is `14/14` passed and no fixture failed. The numeric evidence shows fixtures did **not** detect the defect by failing.
- H5 says “cross-path recon detects the ablated defect: X1 n_disagree=104; X2 n_disagree=0.” Only X1 detects it by recon; X2 has `n_disagree=0`, so X2 recon does not detect the defect.
- The manifest note says `run_RA.R` / `run_RB.R` are listed under `MANIFEST_outputs` because of a case-insensitive filter, even though they are inputs and unmodified. This is a harness/manifest defect.
- H3’s “total 208” is ambiguous if X2 R-B is counted as a separate ablated execution; the runs table does not list X2 R-B separately.

## 4. Facts that cannot be recomputed from this packet

- Full row-level reconciliation for all `222002` rows; only aggregates and first 12 label-flip rows are present.
- The full list of 104 label-flip SR_NUMBERs.
- Fixture actuals and expecteds; only `14/14` pass counts are present.
- Raw stdout/stderr for each run; only the run-log summary is present.
- Full per-arm manifests; only key files are shown.
- Byte-level rehashing of evidence files; only hashes are listed.
- MySQL preflight counts beyond the runner’s INFO line.
- Historical 2026-09-19 raw run output; only context text is provided.
- Exact R runtime behavior; only package versions are provided.
- Whether X2 R-B was rerun or reused from X1 R-B, beyond the absence of a separate X2 R-B run row.

## 5. P1 assessment against the frozen predicate in the SPEC

The frozen P1 satisfied condition requires, in X1 and X2, every ablated path’s labels to equal arm B’s labels for all SR_NUMBERs (`0` label flips) and no row to have `|Δdormant_h| > 1e-6 h`.

Evidence shows:

- X1 R-B has `104` label flips vs B R-B and `222002` rows with `n_dormant_diff`, max `6 h`.
- X2 R-A has `104` label flips vs B R-A and `222002` rows with `n_dormant_diff`, max `6 h`.

Therefore the P1 satisfied condition is not met on the evidence. The P1 failed condition is met on the evidence, because at least one ablated path has `≥1` label flip and at least one row with a clock-derived shift. This is a factual assessment only; no terminal state is returned.

## 6. Blocking objections

- H6 is internally inconsistent with the fixture table: it claims fixtures detected the defect, but all fixture results are `14/14` passed with no failures. This should block reliance on H6 as evidence of fixture detection.
- H5 is internally inconsistent in wording: it says cross-path recon detects the defect, but X2 `n_disagree=0` means X2 recon does not detect it. This should block reliance on H5 as a uniform detection claim.
- The manifest misclassifies `run_RA.R` / `run_RB.R` as outputs. Hash equality suggests they were not modified, but the declared changed-file set is muddled by the harness filter.
- H3’s “total 208” needs clarification on whether X2 R-B is counted as a separate ablated execution or as a reused X1 R-B output.
- Fixture actuals/expecteds are not present; only pass counts are given. If fixture-level verification is required, this packet does not permit independent recomputation beyond `14/14`.
- The full 104-row label-flip set and full 222002-row dormant-diff set are not present, so only aggregate counts and first 12 rows can be checked.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| All four runs exit 0 | Run log; runs table |
| B reproduces frozen labels | H2; vs-contract table repro rows; recon B row; B output hashes equal frozen hashes |
| X1 R-B has 104 label flips vs B | H3; vs-contract table X1/X2 R-B row; label-flip CSV |
| X2 R-A has 104 label flips vs B | H3; vs-contract table X2 R-A row |
| X1 recon has 104 disagreements | H5; recon table X1 row; disagreeing label-pairs table |
| X2 recon has 0 disagreements | H5; recon table X2 row |
| Dormant-hour shifts are widespread | H4; vs-contract table `n_dormant_diff=222002`, max `6 h` |
| Portfolio shifts from STANDARD to ESCALATE | Portfolio table; delta `+104 ESCALATE`, `-104 STANDARD` |
| Seed X1 changes R-B parser | SEED_DIFFS; manifest X1 in hash `8df344f5…4866` |
| Seed X2 changes R-A parser | SEED_DIFFS; manifest X2 out hash `65772bee…f03` |
| P1 satisfied condition not met | X1/X2 label diffs `104`; X1/X2 dormant diffs `222002` |
| P1 failed condition met | Same evidence: ≥1 label flip and ≥1 clock-derived shift |
| Fixture detection claim | H6 and runs table conflict: H6 says detect; table says `14/14` pass |

END C33 VALIDATOR REPORT
