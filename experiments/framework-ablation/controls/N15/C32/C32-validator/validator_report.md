1. Role attestation and ablation ID.  
   I am the Validator (DeepSeek), DeepThink on, blind to the Builder. I have not seen and do not request Builder output. Ablation ID: C32 (“Freeze Before Stage 5”), batch N15 batch 3 of 3. Frozen roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I return no KEEP, REVERT, or HALT.
2. Independent test plan: what I checked, and how.  
   I checked the packet’s frozen hashes against the preflight, SPEC, manifests, RUN log, C32_arms.csv, and C32_EVIDENCE.sha256. I recomputed the arm sets H, caught_with, D_abl, H \ D_abl, H \ caught_with, and flagged-with-but-not-H from C32_arms.csv and the raw manifests. I compared every arm’s Stage-5 output hashes against arm B and against the frozen `stage-05/deeper` hashes in the SPEC. I checked FRZ_PRE/FRZ_POST changes, S5 exit codes, and whether arm B satisfies the frozen clean-reference condition. I assessed P1 using only the frozen predicate. I did not use Builder output and did not ask for files or tools.
3. Independently recomputed hard facts. Recompute every number you can from the evidence tables: identities, portfolio deltas, D-sets, and cross-arm hash equalities. Flag any internal inconsistency in the runner output.

Frozen/preflight facts:

- `src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`; MySQL count 245193. Matches SPEC and preflight.
- `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`; MySQL count 104. Preflight says expect 245193 / 104; observed 245193 / 104.
- Frozen `RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`, 22,271,481 bytes.
- Frozen `RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`, 164 bytes.
- Frozen `validated_action_list.csv` SHA-256 `2bffa38b1cf13b99296a4c5d02ead7e22d3c20c4ff22647df31e1fa33761954a`, 13,625,648 bytes.
- Frozen `stage-05/deeper` output hashes in SPEC:

  - `capacity_coverage_note.csv` `4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609` 644 bytes
  - `escalate_by_type.csv` `0f2d8fe0b3509fe27c400eb7cee01e2126beadbca5d82c1b02a9083e00260159` 3932 bytes
  - `escalate_by_type_top25.csv` `6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176` 1264 bytes
  - `escalate_dormancy_summary.csv` `1c411c1fd02c74f17d94ed6d28849f640c992f075ad86d9d1c405cf350e21e63` 138 bytes
  - `inconclusive_by_clause.csv` `f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d` 58 bytes
  - `independent_checks_critical_counts.csv` `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146` 190 bytes
  - `kappa_sensitivity.csv` `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` 164 bytes
  - `portfolio_summary.csv` `b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167` 183 bytes
- Frozen `stage-05/run_deeper_analysis.R` in SPEC: `ed8694277737989d301b9b1f7e6a06a2dbb87a2ad25254fd53b1db47d92c1ec2`, 3443 bytes.
- Runner `stage45/run_deeper_analysis.R`: `a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94`, 3439 bytes. This differs from the frozen `stage-05/run_deeper_analysis.R` hash; the SPEC describes it as a path-only copy, but the hash is not equal.
- `VALIDATION_FREEZE.sha256` hash is `65b91043101ec09a96ea082dc2876cf0a2eaf41c9674c15aba2f7b14dba5f8fd`, 335 bytes, in every arm manifest. Consistent.

Arm B clean-reference facts:

- S5 exit 0, per RUN log and `C32_arms.csv`.
- FRZ_PRE changed=0; FRZ_POST changed=0; FRZ_PRE.txt and FRZ_POST.txt both hash `81ad521ae58e99efe553814d6cbf9866a4309f9559a6de6fdd3f5d7bd7aae98f`, 343 bytes.
- All 8 Stage-5 output hashes match the frozen `stage-05/deeper` hashes exactly:

  - `capacity_coverage_note.csv` = `4bf452...1609`
  - `escalate_by_type.csv` = `0f2d8f...0159`
  - `escalate_by_type_top25.csv` = `6d3bd2...c176`
  - `escalate_dormancy_summary.csv` = `1c411c...1e63`
  - `inconclusive_by_clause.csv` = `f29e33...d32d`
  - `independent_checks_critical_counts.csv` = `4aca9c...d146`
  - `kappa_sensitivity.csv` = `7a18fc...2c8a`
  - `portfolio_summary.csv` = `b58fc4...3167`
- With-control check on B: clean, caught_with=FALSE.

Arm-level recomputation:

| arm | pre_exit | s5_exit | frz_pre_changed | s5_outputs_differ_vs_B | in_H | caught_with | caught_without |
| --- | --- | --- | --- | --- | --- | --- | --- |
| B | NA | 0 | none | none | NA | FALSE | FALSE |
| FB_KGRID | 0 | 0 | `R-B/outputs/RB_kappa_grid_counts.csv` | `kappa_sensitivity.csv` | TRUE | TRUE | FALSE |
| FB_TF24 | 0 | 0 | `R-A/outputs/RA_classifications.csv` | `escalate_dormancy_summary.csv` | TRUE | TRUE | FALSE |
| FB_CLAUSE | 0 | 0 | `R-A/outputs/RA_classifications.csv` | `inconclusive_by_clause.csv` | TRUE | TRUE | FALSE |
| FB_ROUND | 0 | 0 | `R-A/outputs/RA_classifications.csv` | `escalate_dormancy_summary.csv` | TRUE | TRUE | FALSE |
| FB_RECLASS | 0 | 1 | `R-A/outputs/RA_classifications.csv` | blank in arms CSV | FALSE | TRUE | TRUE |
| FB_VALSORT | 0 | 0 | `outputs/validated_action_list.csv` | none | FALSE | TRUE | FALSE |

Set identities recomputed:

- H = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}
- caught_with = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND, FB_RECLASS, FB_VALSORT}
- D_abl = caught_without = {FB_RECLASS}
- H \ D_abl = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}
- H \ caught_with = {}
- flagged with control but not in H = {FB_RECLASS, FB_VALSORT}

Cross-arm hash equalities and differences:

- `kappa_sensitivity.csv`: B=`7a18fc...2c8a`; FB_KGRID=`12ea06...6cee`; all other completed arms=`7a18fc...2c8a`.
- `escalate_dormancy_summary.csv`: B=`1c411c...1e63`; FB_TF24=`fa12c9...30df`; FB_ROUND=`cbdc78...e058`; other completed arms=`1c411c...1e63`.
- `inconclusive_by_clause.csv`: B=`f29e33...d32d`; FB_CLAUSE=`a22d7d...2871`; other completed arms=`f29e33...d32d`.
- `independent_checks_critical_counts.csv`: B=`4aca9c...d146`; FB_RECLASS=`2c3258...46ac`; all other arms with this file=`4aca9c...d146`.
- `capacity_coverage_note.csv`, `escalate_by_type.csv`, `escalate_by_type_top25.csv`, `portfolio_summary.csv`: identical hashes across all arms that produced them, and identical to arm B/frozen SPEC.
- `R-A/outputs/RA_classifications.csv`: B=`c099e0...e0d9`; FB_TF24=`b02c68...29a3`; FB_CLAUSE=`0ecbdb...3935`; FB_ROUND=`ab82f1...74fd`; FB_RECLASS=`36e8ef...957c`; FB_KGRID and FB_VALSORT=`c099e0...e0d9`.
- `R-B/outputs/RB_kappa_grid_counts.csv`: B=`7a18fc...2c8a`; FB_KGRID=`12ea06...6cee`; all other arms=`7a18fc...2c8a`.
- `outputs/validated_action_list.csv`: B=`2bffa3...954a`; FB_VALSORT=`0de2eb...761e`; all other arms=`2bffa3...954a`.

Portfolio deltas: The packet contains only the `portfolio_summary.csv` hash and byte count (`b58fc40...3167`, 183 bytes). The row-level portfolio numbers are not present in the packet, so I cannot independently recompute portfolio deltas from content. The observable portfolio fact is that all completed arms except FB_RECLASS produced the same `portfolio_summary.csv` hash as arm B and the frozen SPEC.

Internal inconsistency flags in runner output:

- FB_RECLASS manifest contains `stage-05/deeper/independent_checks_critical_counts.csv` with hash `2c3258e6d8191846a8cfb29bb18a35a657957886df31582843ef5052413a46ac`, 192 bytes, which differs from arm B’s `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146`, 190 bytes. `C32_arms.csv` leaves `s5_outputs_differ_vs_B` blank for FB_RECLASS. This does not change H because H requires Stage 5 exit 0, and FB_RECLASS has exit 1, but the table and manifest are not fully aligned in presentation.
- The runner harness `stage45/run_deeper_analysis.R` hash `a2868ef...cf94` differs from the SPEC-listed frozen `stage-05/run_deeper_analysis.R` hash `ed86942...1ec2`. The SPEC describes the runner file as a path-only copy, but strict hash equality does not hold.
- The fixture results table has only a header and no fixture rows. If fixtures were mandatory for this control, the packet does not provide fixture actuals/expecteds.

4. Facts that cannot be recomputed from this packet.

- The numeric contents of all `stage-05/deeper/*.csv` files: only hashes and byte counts are provided, not rows or values. Therefore portfolio counts, escalation-by-type counts, dormancy-summary values, kappa-sensitivity counts, independent critical counts, and clause counts cannot be recomputed from first values.
- The contents of `RUN_S5.exit`, `RUN_PRE.exit`, `RUN_S5.stdout.txt`, and `RUN_S5.stderr.txt`: only hashes/byte counts are shown; exit codes are taken from the RUN log and `C32_arms.csv`.
- The contents of `FRZ_PRE.txt`, `FRZ_POST.txt`, and `VALIDATION_FREEZE.sha256`: only hashes/byte counts are shown.
- Fixture expected/observed rows: the fixture table is empty.
- The precise MySQL query and any returned schema beyond the preflight counts 245193 and 104.
- The actual diff between the frozen `stage-05/run_deeper_analysis.R` and runner `stage45/run_deeper_analysis.R`.

5. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.  
   Frozen P1 KEEP-side condition: arm B is clean and H \ D_abl = ∅.

- Arm B clean: yes. S5 exit 0; 8/8 Stage-5 outputs equal the frozen `stage-05/deeper` hashes; with-control check does not flag B.
- H \ D_abl = {FB_KGRID, FB_TF24, FB_CLAUSE, FB_ROUND}, which is not empty. D_abl = {FB_RECLASS}.
- Therefore the frozen P1 predicate is failed by the evidence: H \ D_abl ≠ ∅.  
  Reported non-P1 sets:
- H \ caught_with = {}.
- flagged with the control but not in H = {FB_RECLASS, FB_VALSORT}.

6. Blocking objections. List any defect in the harness, seed, predicate application or evidence that should block a verdict, or state "none".  
   None established by the frozen packet as a blocking objection. Non-blocking inconsistencies are noted in section 3: FB_RECLASS’s differing `independent_checks_critical_counts.csv` is not reflected in the `s5_outputs_differ_vs_B` cell, the runner Stage-5 script hash differs from the SPEC-listed frozen Stage-5 script hash, and the fixture table has no rows. These do not alter the recomputed H, D_abl, H \ D_abl, or P1 result under the frozen definitions.
7. Claim → evidence map.  
   | claim | evidence |  
   |---|---|  
   | Ablation C32, roles Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok | SPEC header |  
   | Frozen source hashes and counts match preflight | PREFLIGHT frozen OK lines; SPEC hashes |  
   | Frozen validated-state hashes match SPEC | SPEC; ARM MANIFESTS B out |  
   | Arm B is clean | RUN log “B S5 exit=0”; C32_arms.csv B row; B manifest output hashes match frozen `stage-05/deeper` hashes |  
   | Arm B FRZ_PRE/FRZ_POST changed=0 | RUN log; C32_arms.csv; B FRZ_PRE/FRZ_POST hashes equal |  
   | H = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND} | C32_arms.csv `in_H` column; manifest output diffs |  
   | caught_with = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND,FB_RECLASS,FB_VALSORT} | C32_arms.csv `caught_with`; FRZ_PRE changed non-empty for those arms |  
   | D_abl = {FB_RECLASS} | C32_arms.csv `caught_without`; RUN log FB_RECLASS S5 exit=1 |  
   | H \ D_abl = {FB_KGRID,FB_TF24,FB_CLAUSE,FB_ROUND} | Set subtraction from above |  
   | P1 failed | Arm B clean but H \ D_abl ≠ ∅, per frozen predicate |  
   | FB_KGRID caught with control | FRZ_PRE changed `R-B/outputs/RB_kappa_grid_counts.csv`; manifest hash changes to `12ea06...6cee` |  
   | FB_TF24 caught with control | FRZ_PRE changed `R-A/outputs/RA_classifications.csv`; manifest hash changes to `b02c68...29a3` |  
   | FB_CLAUSE caught with control | FRZ_PRE changed `R-A/outputs/RA_classifications.csv`; manifest hash changes to `0ecbdb...3935` |  
   | FB_ROUND caught with control | FRZ_PRE changed `R-A/outputs/RA_classifications.csv`; manifest hash changes to `ab82f1...74fd` |  
   | FB_RECLASS caught without control | RUN log S5 exit=1; C32_arms.csv caught_without=TRUE |  
   | FB_VALSORT caught with control, not in H | FRZ_PRE changed `outputs/validated_action_list.csv`; S5 outputs all match B; C32_arms.csv in_H=FALSE |  
   | No source variants used | PREFLIGHT “(no source variants used)” |  
   | Fixture table empty | FIXTURE RESULTS section has header only |

END C32 VALIDATOR REPORT
