1. **Role attestation and ablation ID**

   - Role: Validator only (DeepSeek), DeepThink on.
   - I am blind to the Builder; I have not seen and did not request the Builder output.
   - I return no terminal state.
   - Ablation ID: C36 — “No Re-Judging Validation Labels”.
   - Batch: N15 batch 3 of 3.
   - Frozen roles from SPEC: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.
   - Target stage: Stage 5, stage-5-only arm design.
   - Frozen at CT: 2026-10-03, before runner execution.
2. **Independent test plan: what I checked, and how**

   - Parsed the SPEC, Constitution, preflight, run log, `C36_RESULTS.md`, raw `C36_arms.csv`, evidence hashes, arm manifests, and seed diffs.
   - Checked role separation and ablation ID against the frozen SPEC.
   - Verified frozen framework hashes against the BASELINE FRAMEWORK HASHES section.
   - Verified preflight source row counts and SHA-256 values for `src_open_candidates.csv` and `src_peer_stats.csv`.
   - Reconstructed the arm-level facts from raw `C36_arms.csv`: exits, output-difference lists, added files, label-check failures, `in_H`, `caught_with`, `caught_without`.
   - Reconstructed cross-arm hash equalities from ARM MANIFESTS.
   - Checked arm B against the frozen `stage-05/deeper` hashes in the SPEC.
   - Checked FRZ_PRE/FRZ_POST consistency from manifests and run log.
   - Checked seed diffs against the SPEC-seeded descriptions.
   - Checked H, D_abl, H \ D_abl, H \ caught-with, and over-blocking set from the raw table.
   - Checked the fixture-results section and manifests for fixture evidence.
   - Checked disclosed open finding N1 against the coordinator note and SPEC.
   - No R execution was possible or needed; this is a packet-only recomputation.
3. **Independently recomputed hard facts**

   - Preflight source counts: `src_open_candidates.csv` = 245,193 rows, SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`; `src_peer_stats.csv` = 104 rows, SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
   - Baseline framework hashes match the SPEC exactly:

     - `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
     - `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
   - Frozen arm-start identities are consistent across all arms and match the SPEC:

     - `R-A/outputs/RA_classifications.csv` = `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`, 22,271,481 bytes.
     - `R-B/outputs/RB_kappa_grid_counts.csv` = `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`, 164 bytes.
     - `outputs/validated_action_list.csv` = `2bffa38b1cf13b99296a4c5d02ead7e22d3c20c4ff22647df31e1fa33761954a`, 13,625,648 bytes.
     - `VALIDATION_FREEZE.sha256` = `65b91043101ec09a96ea082dc2876cf0a2eaf41c9674c15aba2f7b14dba5f8fd`, 335 bytes.
   - Arm B is clean on the frozen Stage-5 outputs: B’s 8 `stage-05/deeper` files match the SPEC frozen hashes:

     - `capacity_coverage_note.csv` = `4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609`, 644 bytes.
     - `escalate_by_type.csv` = `0f2d8fe0b3509fe27c400eb7cee01e2126beadbca5d82c1b02a9083e00260159`, 3,932 bytes.
     - `escalate_by_type_top25.csv` = `6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176`, 1,264 bytes.
     - `escalate_dormancy_summary.csv` = `1c411c1fd02c74f17d94ed6d28849f640c992f075ad86d9d1c405cf350e21e63`, 138 bytes.
     - `inconclusive_by_clause.csv` = `f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d`, 58 bytes.
     - `independent_checks_critical_counts.csv` = `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146`, 190 bytes.
     - `kappa_sensitivity.csv` = `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`, 164 bytes.
     - `portfolio_summary.csv` = `b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167`, 183 bytes.
   - FRZ_PRE and FRZ_POST are present for every arm and have the same hash: `81ad521ae58e99efe553814d6cbf9866a4309f9559a6de6fdd3f5d7bd7aae98f`, 343 bytes. This implies `frz_pre_changed=0` and `frz_post_changed=0` for all arms, consistent with the run log.
   - Arm-level recomputation from `C36_arms.csv`:

     - B: `s5_exit=0`, no differing outputs, no added files, no label-check failure, `in_H=NA`, `caught_with=FALSE`, `caught_without=FALSE`.
     - RJ_INC2ESC: `s5_exit=0`; differs on `portfolio_summary.csv`, `escalate_by_type.csv`, `escalate_by_type_top25.csv`, `inconclusive_by_clause.csv`, `escalate_dormancy_summary.csv`; no added files; label-check fails on the same 5 files; `in_H=TRUE`, `caught_with=TRUE`, `caught_without=FALSE`.
     - RJ_KAPPA3: `s5_exit=0`; differs on `portfolio_summary.csv`, `escalate_by_type.csv`, `escalate_by_type_top25.csv`, `escalate_dormancy_summary.csv`; `inconclusive_by_clause.csv` is unchanged; no added files; label-check fails on the same 4 files; `in_H=TRUE`, `caught_with=TRUE`, `caught_without=FALSE`.
     - RJ_OPENAGE: `s5_exit=0`; differs on `portfolio_summary.csv`, `escalate_by_type.csv`, `escalate_by_type_top25.csv`, `escalate_dormancy_summary.csv`; `inconclusive_by_clause.csv` is unchanged; no added files; label-check fails on the same 4 files; `in_H=TRUE`, `caught_with=TRUE`, `caught_without=FALSE`.
     - RJ_PRECHECK: `s5_exit=1`; no label-derived output differences are listed; no added files; no label-check failure; `in_H=FALSE`, `caught_with=FALSE`, `caught_without=TRUE`. Manifest shows it wrote `independent_checks_critical_counts.csv` with hash `e6105c60cdb6a34f7d78518bf21cd44559c69a60c17e658a0f2d5d6613af2cf6`, 192 bytes, unlike B’s `4aca...`, 190 bytes. It also has `RUN_S5.stderr.txt` 52 bytes and `RUN_S5.stdout.txt` 0 bytes.
     - RJ_BENIGN: `s5_exit=0`; no differing label-derived outputs; added file `stage-05/deeper/escalate_by_peer_n_bin.csv` = `09b6590a3253f80f3de228f349ef12ba87069728fc6d23c867baed4c6da207b8`, 89 bytes; no label-check failure; `in_H=FALSE`, `caught_with=FALSE`, `caught_without=FALSE`.
   - Reconstructed sets:

     - H = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}.
     - caught_with = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}.
     - D_abl = {RJ_PRECHECK}.
     - H \ D_abl = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}.
     - H \ caught_with = {}.
     - flagged with control but not in H = {}.
   - Cross-arm hash equalities:

     - All arms share `RA_classifications.csv` = `c099...`, `RB_kappa_grid_counts.csv` = `7a18...`, `validated_action_list.csv` = `2bff...`, `VALIDATION_FREEZE.sha256` = `65b9...`, and FRZ_PRE/FRZ_POST = `81ad...`.
     - `capacity_coverage_note.csv` = `4bf4...` for B, RJ_BENIGN, RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE; RJ_PRECHECK did not write it.
     - `kappa_sensitivity.csv` = `7a18...` for all arms that wrote it; same as B.
     - `independent_checks_critical_counts.csv` = `4aca...` for B, RJ_BENIGN, RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE; RJ_PRECHECK differs at `e610...`.
     - `portfolio_summary.csv`: B and RJ_BENIGN = `b58f...`; RJ_INC2ESC = `24aab...`; RJ_KAPPA3 = `a721...`; RJ_OPENAGE = `274b...`; RJ_PRECHECK absent.
     - `escalate_by_type.csv`: B and RJ_BENIGN = `0f2d...`; RJ_INC2ESC = `17a2...`; RJ_KAPPA3 = `df4f...`; RJ_OPENAGE = `d9ca...`; RJ_PRECHECK absent.
     - `escalate_by_type_top25.csv`: B and RJ_BENIGN = `6d3b...`; RJ_INC2ESC = `9033...`; RJ_KAPPA3 = `a673...`; RJ_OPENAGE = `11fe...`; RJ_PRECHECK absent.
     - `inconclusive_by_clause.csv`: B, RJ_BENIGN, RJ_KAPPA3, RJ_OPENAGE = `f29e...`; RJ_INC2ESC = `3e91...`; RJ_PRECHECK absent.
     - `escalate_dormancy_summary.csv`: B and RJ_BENIGN = `1c41...`; RJ_INC2ESC = `80c3...`; RJ_KAPPA3 = `fd3a...`; RJ_OPENAGE = `9888...`; RJ_PRECHECK absent.
   - Seed hashes match the SPEC exactly for all five seeded scripts and `ARMS.tsv` / `S5ONLY`.
   - Runner harness `runner/stage45/run_deeper_analysis.R` has SHA-256 `a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94`, 3,439 bytes. The frozen `stage-05/run_deeper_analysis.R` has SHA-256 `ed8694277737989d301b9b1f7e6a06a2dbb87a2ad25254fd53b1db47d92c1ec2`, 3,443 bytes. The SPEC describes the runner copy as path-only, so the hash difference is expected, but path-only equivalence is not independently verifiable from this packet.
   - Internal inconsistencies in runner output:

     - `C36_RESULTS.md` and raw `C36_arms.csv` leave `frz_pre_changed` and `frz_post_changed` blank, while the run log and manifests show changed=0 for all arms. This is likely formatting, not a hard conflict.
     - For RJ_PRECHECK, `s5_outputs_differ_vs_B` is blank, but the manifest shows `independent_checks_critical_counts.csv` differs from B. That file is not in the H label-derived list, so it does not change H, but the column name is broader than the H set and creates an ambiguity.
     - Fixture results per arm and path table is empty, and no `*_fixture_results.csv` files appear in the manifests.
4. **Facts that cannot be recomputed from this packet**

   - Actual CSV contents: portfolio counts/percentages, escalate-by-type totals, top25 rows, inconclusive clauses, dormancy summaries, capacity note contents, independent-check count values.
   - Exact `n_decision`, `n_ESCALATE`, `n_INCONCLUSIVE`, `n_STANDARD`, and `validated_action_list_n` values.
   - Exact SR-level label changes in the seeded arms.
   - Exact contents of `RUN_S5.exit`, `RUN_S5.stdout.txt`, and `RUN_S5.stderr.txt`; only hashes and byte counts are present.
   - Exact fixture IDs, expected/observed values, and pass/fail rows; the fixture table is empty.
   - The frozen critical reconciliation field list is not explicitly listed in the packet.
   - The content of `C36_ARM_MANIFESTS.txt` itself is not shown as text, only referenced by hash in `C36_EVIDENCE.sha256`.
   - The exact path-only diff between `stage45/run_deeper_analysis.R` and `stage-05/run_deeper_analysis.R` is not shown, only the SPEC statement and hash/byte differences.
5. **P1 assessment against the frozen predicate in the SPEC**

   - Frozen P1 positive condition: arm B clean, 8/8 outputs equal the frozen `stage-05/deeper`, with-control check does not flag B, and H \ D_abl = ∅.
   - Recomputed B condition: B `s5_exit=0`; B’s 8 Stage-5 outputs match the frozen hashes; B’s label-check status is clean; B is not in H.
   - Recomputed escape condition: H \ D_abl = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}.
   - Because H \ D_abl is non-empty, the P1 positive condition is not met.
   - Other reported P1-adjacent sets from the raw evidence:

     - H \ caught_with = {}.
     - flagged with the control but not in H = {}.
     - D_abl = {RJ_PRECHECK}.
   - Owner threshold facts: the raw table records `label_check_fail` for RJ_INC2ESC, RJ_KAPPA3, and RJ_OPENAGE; B and RJ_BENIGN show no label-check failure; RJ_PRECHECK exits non-zero before label-derived outputs are written.
6. **Blocking objections**

   - Potential blocking evidence gap: the fixture-results table is empty and no `*_fixture_results.csv` files appear in the manifests. If the frozen fixture suite is mandatory for this ablation under Constitution §5, then mandatory fixture pass/fail evidence is missing and cannot be verified from this packet. The SPEC’s Stage-5-only text does not list fixture IDs or a fixture suite, so this remains unresolved from the packet.
   - Non-blocking runner-output ambiguity: RJ_PRECHECK’s `independent_checks_critical_counts.csv` differs from B by hash and byte count, but `s5_outputs_differ_vs_B` is blank for RJ_PRECHECK. This does not alter H because that file is not in the H label-derived list, but the column naming is ambiguous.
   - Non-blocking formatting inconsistency: `frz_pre_changed` and `frz_post_changed` are blank in `C36_RESULTS.md` and `C36_arms.csv`, while run log and manifests show changed=0.
   - N1 is disclosed as an open finding: three frozen-pack rows differ by exactly 1.000 h between clean R-A and R-B (`SR22-01936870` dormant_h; `SR25-02017553`, `SR25-02017556` open_age_h). The labels agree; the frozen recon definition is 0/0/0; the coordinator note says this is not a seeded effect and not a harness defect. I do not treat N1 as blocking on its own.
7. **Claim → evidence map**

   - Role separation / ablation ID: SPEC roles section; frozen CT date.
   - Frozen baseline framework hashes: BASELINE FRAMEWORK HASHES section.
   - Source row counts and source hashes: PREFLIGHT lines and mysql INFO line.
   - Arm-start frozen identities: SPEC frozen pack hashes; manifests for every arm.
   - B clean: `C36_RESULTS.md` Arm B; `C36_arms.csv` B row; B manifest stage-05/deeper hashes; SPEC frozen stage-05/deeper hashes.
   - FRZ_PRE/FRZ_POST unchanged: run log `changed=0`; all-arm manifests `FRZ_PRE.txt` and `FRZ_POST.txt` = `81ad...`.
   - H set: `C36_arms.csv` `in_H=TRUE` rows; s5 output difference lists.
   - caught_with set: `C36_arms.csv` `label_check_fail` rows; `C36_RESULTS.md` Sets.
   - D_abl set: `C36_arms.csv` `s5_exit`; run log; RJ_PRECHECK manifest `RUN_S5.exit` and stderr.
   - H \ D_abl non-empty: set difference from raw `C36_arms.csv` and runner Sets.
   - Benign false-positive check: RJ_BENIGN row; added `escalate_by_peer_n_bin.csv`; all B label-derived hashes unchanged.
   - PRECHECK caught without control: `s5_exit=1`; `RUN_S5.stderr.txt` 52 bytes; no label-derived outputs written.
   - Cross-arm hash equalities/differences: ARM MANIFESTS section.
   - Seed descriptions: SEED DIFFS section vs SPEC seeded arms.
   - N1: COORDINATOR NOTE N1 and SPEC open finding N1.
   - Fixture evidence gap: Fixture Results section empty; manifests lack fixture files.
   - Numeric gaps: no CSV contents, no stdout/stderr text, no exit-file text in packet.

END C36 VALIDATOR REPORT
