1. Role attestation and ablation ID.

- I am DeepSeek, acting only as Validator. I am blind to the Builder; I have not seen, requested, or used Builder output. I did not ask for files or tools. I do not return KEEP, REVERT, or HALT.
- Ablation ID: C45 (Addendum 02, candidate #45 “Parallel R-A/R-B runs”).
- Batch: N15 batch 3 of 3. Constitution version: 1.0. Roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

2. Independent test plan: what you checked, and how.

- I checked frozen-input identity by comparing the SPEC hashes against the PREFLIGHT block and the ARM MANIFESTS input hashes.
- I checked runner seed identity against `seeds/C45/ARMS.tsv` and `seeds/C45/PARALLEL`.
- I reconstructed the arm table from `C45_arms.csv`, the RUN LOG, and `C45_RESULTS.md`, then recomputed exit counts, wall-clock medians, wall-clock ratio, memory-check arithmetic, and peak-memory maxima.
- I checked fixture pass counts by counting every row in the per-arm/path fixture table.
- I checked cross-arm byte-identity of the 7 key outputs by comparing SHA-256 hashes in `C45_ARM_MANIFESTS.txt` across all six arms.
- I checked the disclosed N1 finding against the available packet evidence and separated what is disclosed from what is independently recomputable.
- I did not execute code; all recomputations are from the frozen evidence tables in this packet.

3. Independently recomputed hard facts. Recompute every number you can from the evidence tables: identities, portfolio deltas, D-sets, and cross-arm hash equalities. Flag any internal inconsistency in the runner output.

- Identities:

  - All six arms use identical input hashes in the manifests: `src_extract_lineage.csv` eaa9a76d…, `src_open_candidates.csv` ba089fcc…, `src_peer_stats.csv` cb78ae21…, `R-A\run_RA.R` f4e8993c…, `R-B\R\00_config.R` 6c9b0e31…, `R-B\R\10_io_parse.R` 40e67d83…, `R-B\R\20_integrity_and_classify.R` 72ac5def…, `R-B\R\40_fixtures.R` 2ad4aa69…, `R-B\run_RB.R` 6786fcf5….
  - The SPEC-listed frozen source hashes match the PREFLIGHT “frozen OK” entries for the two source CSVs and the R scripts listed there.
  - `ARMS.tsv` hash 699a7f34… and `PARALLEL` hash cd396dd4… match the SPEC and PREFLIGHT.
  - Arm/path exit identities: all 12 path runs show exit 0 in `C45_arms.csv` and the RUN LOG.
- Fixture identities:

  - 6 arms × 2 paths × 14 fixtures = 168 fixture rows.
  - All 168 rows have `pass=TRUE`.
  - RA: 14/14 pass for each of B, PAR_1, SER_2, PAR_2, SER_3, PAR_3.
  - RB: 14/14 pass for each of B, PAR_1, SER_2, PAR_2, SER_3, PAR_3.
  - Arm B is 14/14 on both paths.
  - Path-specific F14: RA expected/observed `TWO_INDEPENDENT_LABELS`; RB expected/observed `STANDARD|STANDARD`. All arms agree.
- Portfolio deltas:

  - Numeric portfolio deltas cannot be recomputed from this packet because the contents of `RA_portfolio_counts.csv` and `RB_portfolio_counts.csv` are not included.
  - File-level cross-arm equality is recomputable: all arms share `RA_portfolio_counts.csv` SHA-256 b5888db2… and `RB_portfolio_counts.csv` SHA-256 eb677bc1….
- D-sets:

  - Full-field RA-vs-RB D-sets cannot be independently recomputed from this packet because the raw classification files and row-level comparison outputs are not included.
  - The packet discloses N1: dormant_h difference 1, open_age_h difference 2, involving SR22-01936870, SR25-02017553, SR25-02017556; labels agree. The frozen recon definition for “B recon 0/0/0” is only-RA, only-RB, and classification disagreements, not dormant_h/open_age_h.
- Cross-arm hash equalities for the 7 key outputs:

  - RA_classifications: c099e092… for B, PAR_1, SER_2, PAR_2, SER_3, PAR_3.
  - RA_fixture_results: 33696cd1… for all six arms.
  - RA_portfolio_counts: b5888db2… for all six arms.
  - RB_classifications: a0e42b86… for all six arms.
  - RB_fixture_results: 0d72245c… for all six arms.
  - RB_portfolio_counts: eb677bc1… for all six arms.
  - RB_kappa_grid_counts: 7a18fcb1… for all six arms.
  - Therefore, the 7/7 cross-arm key-output equality claim is independently supported by the manifests.
- Frozen-output equality:

  - PREFLIGHT lists frozen `R-A\outputs\RA_classifications.csv` as c099e092… and frozen `R-B\outputs\RB_classifications.csv` as a0e42b86….
  - Arm B’s manifest outputs for those two files match the frozen hashes.
  - The other five frozen key-output hashes are not present in PREFLIGHT or elsewhere in the packet.
- Wall-clock:

  - Serial arms: B 36.4 s, SER_2 37.8 s, SER_3 37.8 s. Median = 37.8 s.
  - Concurrent arms: PAR_1 29.4 s, PAR_2 27.1 s, PAR_3 26.6 s. Median = 27.1 s.
  - Ratio = 27.1 / 37.8 = 0.71693…, reported as 0.717. Recomputes correctly.
  - All PAR wall-clock values are below all SER wall-clock values in this sample.
- Memory:

  - Serial peak: max(718, 714, 718) = 718 MB.
  - Concurrent peak: max(1011, 1006, 997) = 1011 MB.
  - Declared memory-check need = 2 × 718 + 2048 = 1436 + 2048 = 3484 MB.
  - RUN LOG says free 15399 MB, PASS. PAR_1 free before was 15286 MB, still above 3484 MB.
- Internal inconsistencies / flags in runner output:

  - `C45_RESULTS.md` H2 claims every concurrent arm’s 7 key outputs are byte-identical to the frozen outputs. The packet only provides frozen hashes for 2 of those 7 outputs: RA_classifications and RB_classifications. For the other 5, the frozen hash is not available, so the “to the frozen outputs” part of H2 is runner-asserted, not independently recomputable from this packet.
  - The manifest exit-file hashes differ across arms despite every arm reporting exit=0. The packet does not provide exit-file contents, so exit-record identity cannot be verified beyond the CSV/RUN LOG exit codes.
  - No arithmetic inconsistency was found in the recomputed medians, ratio, memory-check calculation, fixture pass counts, or cross-arm key-output hashes.

4. Facts that cannot be recomputed from this packet.

- Raw row-level contents of `RA_classifications.csv` and `RB_classifications.csv`.
- Full RA-vs-RB D-sets, including the disclosed N1 three-row 1.000 h differences.
- Numeric portfolio-count values and any RA-vs-RB portfolio delta.
- Frozen hashes for `RA_fixture_results.csv`, `RA_portfolio_counts.csv`, `RB_fixture_results.csv`, `RB_portfolio_counts.csv`, and `RB_kappa_grid_counts.csv`.
- Actual contents of `RUN_RA.exit`, `RUN_RB.exit`, `PERF.csv`, stdout, and stderr files.
- Whether the N1 mismatch is caused by a daylight-saving ambiguous-hour read; this is disclosed as likely but not confirmed.
- Whether the concurrent runs actually overlapped in the intended way beyond the runner’s wall-clock evidence.
- Whether the memory sampler covered every relevant R process exactly as stated.
- Builder/Validator hard-number agreement, because no Builder output is in this packet.

5. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

- P1 positive condition, part 1: every arm exits 0 on both paths.

  - Evidence: `C45_arms.csv` has ra_exit=0 and rb_exit=0 for all six arms; RUN LOG shows exit=0 for every path run. Recomputes as 12/12 path runs with exit 0.
- P1 positive condition, part 2a: every concurrent arm’s 7 key outputs byte-identical to the serial arms.

  - Evidence: manifests show all seven key-output hashes identical across B, PAR_1, SER_2, PAR_2, SER_3, PAR_3. Recomputes as supported.
- P1 positive condition, part 2b: every concurrent arm’s 7 key outputs byte-identical to the frozen outputs.

  - Evidence: frozen hashes are available only for RA_classifications and RB_classifications; both match arm B and all arms. The other five frozen key-output hashes are absent from the packet. Therefore this part is not fully independently recomputable from the provided evidence, although `C45_arms.csv` reports `outputs_equal_frozen=7/7` for all arms.
- P1 positive condition, part 2c: median concurrent wall-clock below median serial wall-clock.

  - Evidence: serial median 37.8 s, concurrent median 27.1 s, ratio 0.717. Recomputes as below 1.
- P1 negative condition: any output differs or any run fails from contention.

  - Evidence: no exit failures are recorded. Cross-arm key-output hashes are identical. Frozen equality is incomplete for five key outputs as noted above.
- SPEC memory-check failure condition:

  - Evidence: declared need 3484 MB, free 15399 MB, PASS. Recomputes as passing.
- SPEC arm-B classification reproduction condition:

  - Evidence: arm B RA_classifications c099e092… and RB_classifications a0e42b86… match the two frozen classification hashes in PREFLIGHT. Recomputes as matching.

6. Blocking objections. List any defect in the harness, seed, predicate application or evidence that should block a verdict, or state "none".

- Blocking evidence defect: the packet does not provide frozen SHA-256 hashes for 5 of the 7 key outputs required by P1: `RA_fixture_results.csv`, `RA_portfolio_counts.csv`, `RB_fixture_results.csv`, `RB_portfolio_counts.csv`, and `RB_kappa_grid_counts.csv`. Without those frozen hashes, the “byte-identical to the frozen outputs” part of P1 cannot be independently verified from the packet. This should block a verdict based solely on this packet.
- Evidence defect: raw classification and portfolio-count files are absent, so portfolio deltas and full RA-vs-RB D-sets cannot be independently recomputed. The N1 1/2 full-field mismatches are disclosed only by coordinator note, not by raw comparison output.
- Evidence defect: exit-file hashes differ across arms even though all reported exits are 0. The packet does not include exit-file contents, so exit-record identity cannot be fully checked beyond the reported exit codes.
- No seed defect found: `ARMS.tsv` and `PARALLEL` hashes match the SPEC and PREFLIGHT; no source variants are used.
- No predicate-wording defect found in the SPEC itself: the P1 predicate is mechanically defined before execution.
- N1 is disclosed as an open finding and is stated not to be a seeded effect or harness defect. It is not independently recomputable from the packet, but it is not presented as a new defect in this run.

7. Claim → evidence map.

- Claim: Preflight passed and frozen inputs match SPEC hashes. → PREFLIGHT block; SPEC frozen hashes.
- Claim: Arm B is serial reference. → `C45_arms.csv`; RUN LOG.
- Claim: Memory check passed before first concurrent arm. → RUN LOG 06:13:04 MEMCHECK; `C45_RESULTS.md`.
- Claim: All arms exited 0 on both paths. → `C45_arms.csv`; RUN LOG exit lines.
- Claim: Arm B fixtures are 14/14 on both paths. → fixture results table.
- Claim: All arms are 14/14 on both paths. → fixture results table, 168/168 pass rows.
- Claim: All 7 key outputs are byte-identical across arms. → ARM MANIFESTS SHA-256 hashes for the seven key outputs.
- Claim: Arm B reproduces frozen RA/RB classifications byte-for-byte. → PREFLIGHT frozen hashes c099e092… and a0e42b86… vs B manifest hashes.
- Claim: All 7 key outputs are byte-identical to frozen outputs. → `C45_arms.csv` `outputs_equal_frozen=7/7`; raw frozen hashes only present for 2/7, so unsupported for 5/7.
- Claim: Median concurrent wall-clock is below median serial wall-clock. → `C45_arms.csv` wall_s values; recomputed medians 37.8 s vs 27.1 s, ratio 0.717.
- Claim: Peak serial memory 718 MB, peak concurrent 1011 MB. → `C45_arms.csv`; `C45_RESULTS.md`; recomputed maxima.
- Claim: N1 full-field mismatch exists in frozen pack. → Coordinator Note N1; not independently recomputable from raw packet rows.
- Claim: No source variants used. → SOURCE VARIANTS section; SEED DIFFS section.

END C45 VALIDATOR REPORT
