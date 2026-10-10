1. Role attestation and ablation ID.  
   I am DeepSeek, acting only as Validator for this packet. I am blind to the Builder; I have not seen and did not request Builder output. Ablation ID: C31, “Lineage Attestation,” batch N15 batch 1 of 3, Constitution version 1.0. Role assignment in the SPEC is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The baseline framework hashes in the packet match the SPEC. The ablation was frozen at 2026-10-03 CT before the runner executed.
2. Independent test plan: what I checked, and how.

- Checked preflight gating: compared SPEC-frozen hashes to PREFLIGHT lines for source, code, seed, and baseline framework hashes; checked MySQL read-only counts.
- Checked arm B: exits, fixture counts, reproduction against frozen RA/RB classifications, and R-A vs R-B reconciliation.
- Reconstructed D_abl and H from C31_RESULTS.md and C31_arms.csv: exits, recon only_ra/only_rb/disagree, fixture pass counts, RA_vs_B/RB_vs_B key/label/dormant/open_age deltas.
- Recomputed locked_field_changes_vs_B and decision_changes_vs_B arithmetic from the per-path deltas.
- Compared ARM MANIFESTS SHA-256 and byte sizes across arms for input/output equalities and differences.
- Checked fixture rows for F01–F14 on every path/arm.
- Checked SEED DIFFS against the SPEC-seeded changes.
- Checked SOURCE VARIANTS notes against the declared variant files.
- Evaluated P1 strictly against the frozen predicate: P1 satisfied iff H ⊆ D_abl.

3. Independently recomputed hard facts. Recompute every number you can from the evidence tables: identities, portfolio deltas, D-sets, and cross-arm hash equalities. Flag any internal inconsistency in the runner output.

Preflight / frozen identity:

- `src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` matches SPEC and PREFLIGHT.
- `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58` matches SPEC and PREFLIGHT.
- `R-A\run_RA.R` SHA-256 `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587` matches SPEC and PREFLIGHT.
- `R-B\R\00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b` matches SPEC and PREFLIGHT.
- `R-B\R\20_integrity_and_classify.R` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99` matches SPEC and PREFLIGHT.
- Seed hashes in PREFLIGHT match SPEC for `RA_COMMENT` `51a47bd1...`, `RA_K25` `7b3e23dc...`, `RA_TF24` `4694d22d...`, `RB_COMMENT` `bdf1f3cb...`, `RB_K25` `401d894c...`, `RB_TF24` `3484c86e...`.
- MySQL read-only counts: `src_open_candidates` 245193; `src_peer_stats` 104.
- R version 4.6.1 recorded in PREFLIGHT.

Arm B:

- H1: R-A exit 0, R-B exit 0. Fixtures R-A 14/14, R-B 14/14. Confirmed from RUN LOG and FIXTURE RESULTS.
- H2 reproduction vs frozen pack: B R-A vs frozen RA_classifications has `n_only_x=0, n_only_truth=0, n_label_diff=0, n_dormant_diff=0, n_open_age_diff=0`; B R-B vs frozen RB_classifications has all zeros. Confirmed.
- B recon R-A vs R-B: `n_ra=222002`, `n_rb=222002`, `n_inner=222002`, `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`, `n_dormant_mismatch=1`, `n_open_age_mismatch=2`. Confirmed from B recon table.
- Note: the H2 wording “B recon is 0/0/0” is true for only_ra/only_rb/disagree, but not for full-field dormant/open_age mismatch counts. The SPEC defines exact recon as key set + classification, so the 0/0/0 reading is consistent with the SPEC definition, but the wording is ambiguous.

Seeded arms:

- H3: 5 seeded arms, all runs recorded. All RA/RB exits are 0 for L_STALE24, L_PEER10, L_TF24, L_K25, L_COMMENT. Confirmed.
- H4 harm set H: recomputed from RA_vs_B/RB_vs_B deltas.

  - L_STALE24: `only_B=773` on RA and RB. Locked-field changes = 773*2 = 1546; decision changes = 1546.
  - L_PEER10: `label=269` on RA and RB. Locked-field changes = 269*2 = 538; decision changes = 538.
  - L_TF24: `label=573`, `dormant=222002`, `open_age=222002` on RA and RB. Locked-field changes per path = 573 + 222002 + 222002 = 444577; both paths = 889154. Decision changes = 573*2 = 1146.
  - L_K25: `label=6893` on RA and RB. Locked-field changes = 6893*2 = 13786; decision changes = 13786.
  - L_COMMENT: all locked deltas 0.
  - Therefore H = {L_STALE24, L_PEER10, L_TF24, L_K25}. This matches H4.
- H5 / D_abl: caught without control = crash, recon key/label mismatch, or fixture failure on any path. All seeded arms have exits 0, `recon_only_ra=0`, `recon_only_rb=0`, `recon_disagree=0`, and all fixtures 14/14. Therefore D_abl = {}.
- H6: H minus D_abl = {L_STALE24, L_PEER10, L_TF24, L_K25}. Confirmed.
- H7: arms with no locked-field change = {L_COMMENT}. Confirmed.
- H8: caught with control = {L_STALE24, L_PEER10, L_TF24, L_K25, L_COMMENT}. Confirmed by input hash differences from B.
- H9: caught with control but no locked-field change = {L_COMMENT}. Confirmed.

Cross-arm hash equalities:

- L_COMMENT outputs are byte-identical to arm B:

  - `R-A\outputs\RA_classifications.csv` `c099e092...` 22271481 bytes.
  - `R-A\outputs\RA_fixture_results.csv` `33696cd1...` 985 bytes.
  - `R-B\outputs\RB_classifications.csv` `a0e42b86...` 41963733 bytes.
  - `R-B\outputs\RB_fixture_results.csv` `0d72245c...` 1792 bytes.
- Other seeded arms have output hashes differing from B.
- Inputs differing from B:

  - L_STALE24: `data\source\src_open_candidates.csv` `8268fb54...` vs B `ba089fcc...`.
  - L_PEER10: `data\source\src_peer_stats.csv` `573b4132...` vs B `cb78ae21...`.
  - L_TF24: `R-A\run_RA.R` `4694d22d...` vs B `f4e8993c...`; `R-B\R\00_config.R` `3484c86e...` vs B `6c9b0e31...`.
  - L_K25: `R-A\run_RA.R` `7b3e23dc...` vs B `f4e8993c...`; `R-B\R\00_config.R` `401d894c...` vs B `6c9b0e31...`.
  - L_COMMENT: `R-A\run_RA.R` `51a47bd1...` vs B `f4e8993c...`; `R-B\R\00_config.R` `bdf1f3cb...` vs B `6c9b0e31...`.

Fixture results:

- Every arm/path has 14 fixture rows, F01–F14, and every `pass` value is TRUE.
- F14 expected/observed differs by path across all arms:

  - R-A F14: expected `TWO_INDEPENDENT_LABELS`, observed `TWO_INDEPENDENT_LABELS`.
  - R-B F14: expected `STANDARD|STANDARD`, observed `STANDARD|STANDARD`.
- This means the fixture suite is not presenting a single common expected value for F14 across R-A and R-B.

Internal inconsistencies flagged:

- SOURCE VARIANTS line for `V_STALE24/src_peer_stats.csv` reports `rows dropped: 848 (created_ts >= 2026-09-11 23:59:59)`, but the same line and manifest state the file is unchanged, SHA-256 equals the frozen `cb78ae21...`, and PREFLIGHT gives `src_peer_stats` count 104. A 104-row unchanged peer-stats file cannot have 848 rows dropped.
- F14 has different expected values on R-A vs R-B in all arms.
- L_K25 `R-B\outputs\RB_fixture_results.csv` manifest hash/size is `f777621e...` 1820 bytes, while arm B is `0d72245c...` 1792 bytes. The provided raw fixture rows for L_K25 RB are identical to B’s raw fixture rows for all 14 fixtures. If the provided rows are the full file, this is inconsistent; if there are additional columns/bytes, the packet does not show them.
- H2 says “B recon is 0/0/0” while also reporting full-field recon mismatches `dormant_h 1`, `open_age_h 2`. This is not necessarily a contradiction under the SPEC’s exact-recon definition, but it is an ambiguity in the runner output.
- B reproduces frozen RA/RB with 0 dormant/open_age differences, yet B R-A vs R-B recon has 1 dormant and 2 open_age mismatches. This implies the frozen RA/RB files themselves may differ by 1 dormant and 2 open_age mismatches, but the packet does not include frozen RA/RB inter-path recon to confirm.

4. Facts that cannot be recomputed from this packet.

- Actual raw file bytes and independently recomputed SHA-256 hashes; only provided hashes and sizes are available.
- Frozen RA/RB classification contents and whether they already contain the 1 dormant / 2 open_age inter-path mismatches implied by B recon.
- Full `ARM_MANIFESTS.txt`; the packet says key files only, so the full manifest list cannot be recomputed.
- `SEEDS_b1.sha256` contents; only PREFLIGHT seed hash checks are shown.
- `_variants/VARIANTS.tsv` contents; only SOURCE VARIANTS summary lines are shown.
- Full source-variant construction details and row-level counts beyond the notes.
- Full fixture expected files; cannot determine whether the F14 R-A/R-B expected difference is intentional or a harness defect.
- Full `RB_fixture_results.csv` file bytes for L_K25; cannot determine why its hash/size differs from B while the provided raw rows match.
- Builder output and Builder/Validator hard-number agreement; Builder is not in this packet.

5. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

- Frozen predicate: P1 satisfied iff H ⊆ D_abl. P1 failed iff H \ D_abl is non-empty.
- Reconstructed H = {L_STALE24, L_PEER10, L_TF24, L_K25}.
- Reconstructed D_abl = {}.
- H \ D_abl = {L_STALE24, L_PEER10, L_TF24, L_K25}, which is non-empty.
- Therefore the frozen predicate’s failure condition is met: P1 is not satisfied.
- L_COMMENT has no locked-field change and is reported separately; it does not count for or against P1.
- L_COMMENT is caught with the control only because its code bytes differ from the frozen record.

6. Blocking objections. List any defect in the harness, seed, predicate application or evidence that should block a verdict, or state “none”.  
   The following evidence defects should block a verdict until resolved:

- The SOURCE VARIANTS line for `V_STALE24/src_peer_stats.csv` reports 848 rows dropped even though that file is unchanged, matches the frozen SHA-256, and is only 104 rows by preflight count. This is a direct seed/variant evidence inconsistency.
- F14 has different expected values on R-A (`TWO_INDEPENDENT_LABELS`) and R-B (`STANDARD|STANDARD`) across all arms. The SPEC describes a fixture suite `fixtures-v1-tcd-ig` F01–F14 on every path; a path-dependent expected value for the same fixture ID undermines the fixture evidence as a common locked behavioral suite.
- L_K25 `R-B\outputs\RB_fixture_results.csv` differs from arm B in hash and byte size (`f777621e...` 1820 vs `0d72245c...` 1792) while the provided raw fixture rows are identical to B for all 14 fixtures. If the provided rows are complete, this is an internal inconsistency; if not, the packet lacks the additional bytes/columns needed to explain it.
- The H2 wording “B recon is 0/0/0” coexists with full-field recon mismatches `dormant_h 1` and `open_age_h 2`. The SPEC defines exact recon as key set + classification, so this may be only a wording ambiguity, but it should be clarified because it touches the B reconciliation hard gate.
- B reproduces frozen RA/RB with 0 dormant/open_age differences, but B R-A vs R-B recon has 1 dormant and 2 open_age mismatches. The packet does not include frozen RA/RB inter-path recon, so the source of those mismatches cannot be independently verified.

7. Claim → evidence map.

- Validator role and ablation ID: SPEC “Roles” line; SPEC “Ablation ID” line.
- Baseline framework hashes: BASELINE FRAMEWORK HASHES section.
- Frozen source/code hashes: SPEC frozen data/code list; PREFLIGHT “frozen OK” lines.
- Seed hashes: SPEC seeded changes; PREFLIGHT “seed OK” lines.
- MySQL counts: PREFLIGHT `mysql` line.
- Arm B exits and fixtures: RUN LOG B RA/RB lines; FIXTURE RESULTS B RA/RB rows.
- Arm B reproduction vs frozen: “Arm B repro vs frozen pack” table.
- Arm B recon: “Arm B recon” table.
- H set: C31_RESULTS H4; C31_arms rows for L_STALE24, L_PEER10, L_TF24, L_K25; recomputed RA_vs_B/RB_vs_B deltas.
- D_abl empty: C31_RESULTS H5; C31_arms exit, recon_only_ra/rb, recon_disagree, fixture columns.
- H6 = H \ D_abl: C31_RESULTS H6; recomputed H and D_abl.
- Caught with control: C31_RESULTS H8; ARM MANIFESTS input differences for each seeded arm.
- L_COMMENT benign: C31_RESULTS H7/H9; C31_arms L_COMMENT locked deltas all 0; ARM MANIFESTS L_COMMENT outputs equal B.
- Input hash differences: ARM MANIFESTS “in” lines for each arm vs B.
- Seed diffs: SEED DIFFS section.
- Source variant inconsistency: SOURCE VARIANTS `V_STALE24/src_peer_stats.csv` line vs SPEC variant note and PREFLIGHT count.
- F14 expected difference: FIXTURE RESULTS B RA F14 vs B RB F14 and all seeded RA/RB F14 rows.
- L_K25 RB fixture manifest mismatch: ARM MANIFESTS L_K25 out `RB_fixture_results.csv` vs B out `RB_fixture_results.csv`; FIXTURE RESULTS L_K25 RB rows.
- P1 failure: SPEC P1 definitions; C31_RESULTS H4, H5, H6; recomputed H \ D_abl.

END C31 VALIDATOR REPORT
