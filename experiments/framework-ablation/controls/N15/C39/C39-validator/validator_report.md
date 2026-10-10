1. **Role attestation and ablation ID**  
   I am DeepSeek, acting as Validator only, DeepThink on. I am blind to the Builder and have not seen its output. I do not return KEEP, REVERT, or HALT.  
   Ablation ID: **C39** — Ablation Addendum 01, control #39 “Reconciliation scope & tolerance.” Batch N15 batch 1 of 3. Target stage: Stage 4 reconciliation field scope. Constitution version: 1.0. Roles: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Frozen at CT 2026-10-03 before runner execution.
2. **Independent test plan: what I checked, and how**  
   I parsed the frozen SPEC, CONSTITUTION, PREFLIGHT, RUN LOG, C39_RESULTS.md, C39_arms.csv, fixture rows, C39_EVIDENCE.sha256, ARM_MANIFESTS, and SEED_DIFFS. I independently reconstructed: arm list, exits, fixture pass counts, recon counts, locked-field deltas vs arm B, harm set H, D_abl, and the P1 subset relation. I cross-checked declared seed hashes against preflight and manifests, compared output hashes across arms to arm B, and checked seed diffs against the declared changes. I also checked arithmetic/set identities from the aggregate evidence. I could not recompute row-level outputs because only aggregate tables and hashes are in this packet.
3. **Independently recomputed hard facts**  
   Preflight: `src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`, 245,193 rows; `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`, 104 rows. Preflight gating result: PASS.

Run log: all six runs recorded exit=0: B RA 12.1s, B RB 26.3s, R_ROUND1 RB 26.6s, R_OPENAGE RB 25.3s, R_GT RB 26.4s, R_NOTHIN RB 27.3s.

Arm B:

- Fixtures: R-A 14/14, R-B 14/14.
- Repro vs frozen pack: for B R-A vs frozen RA and B R-B vs frozen RB, all `n_only_x=0`, `n_only_truth=0`, `n_label_diff=0`, `n_dormant_diff=0`, `n_open_age_diff=0`.
- B recon R-A vs R-B: `n_ra=222002`, `n_rb=222002`, `n_inner=222002`, `n_only_ra=0`, `n_only_rb=0`, `n_disagree=0`, `n_dormant_mismatch=1`, `n_open_age_mismatch=2`.

Seeded arms:

| arm | exit | fx_RA | fx_RB | recon_disagree | recon_dormant | recon_open_age | locked_changes | decision_changes | harm | caught_with_control | caught_without_control |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R_ROUND1 | RB=0 | 14/14 | 14/14 | 0 | 221457 | 2 | 221457 | 0 | TRUE | TRUE | FALSE |
| R_OPENAGE | RB=0 | 14/14 | 14/14 | 0 | 1 | 221986 | 221986 | 0 | TRUE | TRUE | FALSE |
| R_GT | RB=0 | 14/14 | 14/14 | 0 | 1 | 2 | 0 | 0 | FALSE | TRUE | FALSE |
| R_NOTHIN | RB=0 | 14/14 | 13/14 (F06) | 6377 | 1 | 2 | 6377 | 6377 | TRUE | TRUE | TRUE |

Recomputed sets:

- H = {R_ROUND1, R_OPENAGE, R_NOTHIN}
- D_abl = {R_NOTHIN}
- H \ D_abl = {R_ROUND1, R_OPENAGE}
- H ∩ D_abl = {R_NOTHIN}
- D_abl \ H = ∅
- Arms with no locked-field change = {R_GT}
- Caught with control = {R_ROUND1, R_OPENAGE, R_GT, R_NOTHIN}
- Caught with control but no locked-field change = {R_GT}

Fixture recomputation: R_NOTHIN R-B F06 expected `INCONCLUSIVE`, observed `ESCALATE`, pass FALSE. All other fixture rows shown pass. B R-B F14 expected/observed `STANDARD|STANDARD`; B R-A F14 expected/observed `TWO_INDEPENDENT_LABELS`.

Cross-arm hash equalities:

- B R-B `RB_classifications.csv` hash `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` equals R_GT R-B `RB_classifications.csv` hash `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`.
- B R-B `RB_fixture_results.csv` hash `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9` equals R_GT, R_ROUND1, and R_OPENAGE R-B `RB_fixture_results.csv` hashes.
- R_NOTHIN R-B `RB_classifications.csv` hash `f6611d8dcec6b65e6f6a9cfee6f9b500dd5b4b2b9667b4785be42d0a28f419f8` differs from B; R_NOTHIN R-B `RB_fixture_results.csv` hash `22638dab341ff6c64dc00b8697ceceb73f52331dffcbadc037659b17865921bb` differs from B.
- R_ROUND1 R-B `RB_classifications.csv` hash `08ab597bfa23dde172e1d67f6994bab4647d6c1df5743db5182772add7070469` differs from B.
- R_OPENAGE R-B `RB_classifications.csv` hash `58a44c72585b1e57bc3bd1292cc866d0490badcda9b48828158258a7576715f5` differs from B.
- Seeded input code hashes match preflight and manifests: R_ROUND1 `c7080cecaea56428b1544b0d9a366f7b17adf315bf31f26720cc86c169506bfd`; R_OPENAGE `9be2b7e928124cc96bf0e1e85bcab326a55533f65702906be4e27ad4a15e1ac5`; R_GT `484db21bbd924040b990afdca785e4fafa6d7dabe967b19e8fe94b45cf07fb8f`; R_NOTHIN `487b769ce4cfcae6ad773f3611b11728271dc35e3ffc9f6590c49e30f65639ff`.

Seed diffs match declared changes:

- R_ROUND1: `dormant_h = round(dormant_h, 1)`.
- R_OPENAGE: `open_age_h[has_created]` from `created_ts` changed to `open_age_h[has_mod]` from `mod_ts`.
- R_GT: `dormant_h >= thresh` changed to `dormant_h > thresh`.
- R_NOTHIN: `p_thin <- peer_n < RB_N_MIN` changed to `p_thin <- rep(FALSE, n)`.

Internal inconsistency flags:

- The B recon table shows `n_dormant_mismatch=1` and `n_open_age_mismatch=2`, while H2 states “B recon is 0/0/0: TRUE.” This is consistent only if “0/0/0” means `only_ra=0`, `only_rb=0`, `disagree=0`. Under a full locked-field reading, B recon is not 0/0/0.
- The HALT rule says to halt if B recon is not 0/0/0. That rule is ambiguous against the B recon table because full-field dormant/open-age mismatches are nonzero.
- The strict control catches R_GT even though R_GT has no locked-field change, because inherited B R-A vs R-B dormant/open-age mismatches remain. This is not an arithmetic contradiction, but it shows the strict control raises an alarm on a clean output.

4. **Facts that cannot be recomputed from this packet**  
   Exact row-level values and the derivation of counts `221457`, `221986`, `6377`, `1`, and `2` cannot be independently recomputed from this packet; only aggregate tables are provided. The full arm manifests beyond the listed key files are not present. Raw stdout/stderr beyond the RUN LOG is not present. The actual source code beyond the provided unified diffs is not present. MySQL behavior beyond the preflight COUNT is not present. Builder hard facts are not present because the first pass is blind. I cannot independently verify the listed SHA-256 hashes without the underlying files, though the listed hashes are internally cross-referenced.
5. **P1 assessment against the frozen predicate in the SPEC**  
   The frozen predicate is: P1 satisfied iff `H ⊆ D_abl`; P1 failed iff `H \ D_abl` is non-empty.  
   Recomputed: `H = {R_ROUND1, R_OPENAGE, R_NOTHIN}`. `D_abl = {R_NOTHIN}`. `H \ D_abl = {R_ROUND1, R_OPENAGE}`. This subset is non-empty.  
   R_ROUND1 changes `dormant_h` on 221,457 rows vs arm B, with `decision_changes_vs_B=0`, and is not caught without the control. R_OPENAGE changes `open_age_h` on 221,986 rows vs arm B, with `decision_changes_vs_B=0`, and is not caught without the control. R_NOTHIN changes classification on 6,377 rows and is caught without the control. R_GT has no locked-field change and does not count for or against P1. Therefore, on the frozen evidence, P1 is not satisfied.
6. **Blocking objections**

- Ambiguity/conflict in B recon: B recon has full-field mismatches `dormant_h=1` and `open_age_h=2`, while H2 says “B recon is 0/0/0: TRUE.” If the HALT rule’s “B recon is not 0/0/0” is read as full-field recon, the clean arm does not meet it. This should be resolved before a verdict.
- The strict control is not clean on arm B/R_GT: R_GT is “caught with control” with zero locked-field changes because the inherited B R-A vs R-B dormant/open-age mismatches persist. This complicates interpretation of the strict regime’s alarm behavior.
- Raw row-level evidence is not in this packet, so exact counts cannot be independently recomputed from source. If raw artifacts are unavailable in the authoritative evidence pack, the constitution’s raw-evidence requirement is not met.
- No other blocking objection found from the provided aggregate tables: exits are recorded, fixture pass counts reconcile, seed hashes match declared seeds, and the H/D set arithmetic is internally consistent.

7. **Claim → evidence map**

| Claim | Evidence |
| --- | --- |
| Ablation ID C39, target Stage 4, roles Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok | SPEC header and role line |
| Frozen data/code hashes and row counts | PREFLIGHT lines: `ba089...`, `cb78...`, `f4e899...`, `6c9b...`, `72ac...`; MySQL 245193 / 104 |
| Preflight PASS | PREFLIGHT “preflight gating result: PASS” |
| All six runs recorded exit=0 | RUN LOG |
| Arm B fixtures 14/14 both paths | C39_RESULTS H1 and fixture rows |
| Arm B reproduces frozen pack with 0 differences | C39_RESULTS “Arm B repro vs frozen pack” table |
| B recon `n_inner=222002`, `only=0/0`, `disagree=0`, `dormant=1`, `open_age=2` | C39_RESULTS “Arm B recon” table |
| H = {R_ROUND1, R_OPENAGE, R_NOTHIN} | C39_RESULTS H4; C39_arms.csv `harm=TRUE` rows |
| D_abl = {R_NOTHIN} | C39_RESULTS H5; C39_arms.csv `caught_without_control` column |
| H \ D_abl = {R_ROUND1, R_OPENAGE} | Recomputed from H and D_abl |
| R_ROUND1 locked changes 221457, decision changes 0 | C39_arms.csv / C39_RESULTS seeded table |
| R_OPENAGE locked changes 221986, decision changes 0 | C39_arms.csv / C39_RESULTS seeded table |
| R_GT no locked-field change but caught with control | C39_RESULTS H7/H9; C39_arms.csv |
| R_NOTHIN fixture F06 fail, recon_disagree 6377 | Fixture rows; C39_arms.csv |
| Seed diffs match declared changes | SEED_DIFFS |
| Cross-arm hash equalities | ARM_MANIFESTS |

END C39 VALIDATOR REPORT
