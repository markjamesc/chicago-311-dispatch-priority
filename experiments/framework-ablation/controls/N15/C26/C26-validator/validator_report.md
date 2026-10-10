1. **Role attestation and ablation ID**  
   I am the Validator (DeepSeek), operating blind to the Builder. I have not seen, requested, or used the Builder’s output. Ablation ID: **C26** — “Frozen Source Package”, N15 batch 1 of 3. I am not returning a terminal state.
2. **Independent test plan: what I checked, and how**

- Read the frozen SPEC, constitution, preflight, run log, `C26_RESULTS.md`, `C26_arms.csv`, fixture rows, evidence hashes, and arm manifests.
- Recomputed identity relations in the recon tables: `n_inner = n_ra - n_only_ra = n_rb - n_only_rb`.
- Recomputed the harm set `H`, the caught-without-control set `D_abl`, `H \ D_abl`, caught-with-control set, and no-locked-field-change set.
- Checked source-variant SHA-256 values against the frozen source hashes and the variant table.
- Checked cross-arm hash equalities in the manifests for code, source inputs, and output files.
- Counted fixture rows and pass/fail values across paths and seeded arms.
- Checked internal consistency of the runner’s stated mechanical facts against the raw `C26_arms.csv` and manifest tables.

3. **Independently recomputed hard facts**

**Arm B recon identity**

| quantity | value | recomputation |
| --- | --- | --- |
| `n_ra` | 222002 | given |
| `n_rb` | 222002 | given |
| `n_inner` | 222002 | `222002 - 0 = 222002`; `222002 - 0 = 222002` |
| `n_only_ra` | 0 | given |
| `n_only_rb` | 0 | given |
| `n_disagree` | 0 | given |
| key/label recon sum | 0 | `0 + 0 + 0 = 0` |
| `n_dormant_mismatch` | 1 | given |
| `n_open_age_mismatch` | 2 | given |

**Seeded-arm recon and locked-field facts**

| arm | `only_ra` | `only_rb` | `disagree` | key/label sum | locked changes vs B | decision changes vs B | harm | caught without control | caught with control |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| S_STALE24 | 773 | 0 | 0 | 773 | 773 | 773 | TRUE | TRUE | TRUE |
| S_PEER10 | 0 | 0 | 269 | 269 | 269 | 269 | TRUE | TRUE | TRUE |
| S_ONEROW | 0 | 0 | 0 | 0 | 1 | 0 | TRUE | FALSE | TRUE |
| S_LF | 0 | 0 | 0 | 0 | 0 | 0 | FALSE | FALSE | TRUE |
| S_REVERSE | 0 | 0 | 0 | 0 | 0 | 0 | FALSE | FALSE | TRUE |
| S_BOOLCASE | 0 | 0 | 0 | 0 | 0 | 0 | FALSE | FALSE | TRUE |

Recomputed `S_STALE24` RB key count: `RB_vs_B only_B=773`, so `n_rb = 222002 - 773 = 221229`. Its recon identity is `n_inner = 222002 - 773 = 221229`, and `n_rb = 221229 + 0 = 221229`.

**D-sets**

- `H = {S_STALE24, S_PEER10, S_ONEROW}`
- `D_abl = {S_STALE24, S_PEER10}`
- `H \ D_abl = {S_ONEROW}`
- No locked-field change: `{S_LF, S_REVERSE, S_BOOLCASE}`
- Caught with control: `{S_STALE24, S_PEER10, S_ONEROW, S_LF, S_REVERSE, S_BOOLCASE}`
- Caught with control but no locked-field change: `{S_LF, S_REVERSE, S_BOOLCASE}`

**Cross-arm hash equalities from manifests**

- `B RB_classifications.csv` = `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` = `S_LF`, `S_REVERSE`, `S_BOOLCASE` RB classifications.
- `B RB_fixture_results.csv` = `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9` = all seeded RB fixture results.
- Seeded code hashes equal B code hashes: `00_config.R` `6c9b0e...`, `20_integrity_and_classify.R` `72ac5d...`, `run_RB.R` `6786fc...`.
- Differing RB classification hashes: `S_ONEROW` `43af16...`, `S_PEER10` `0bd73e...`, `S_STALE24` `088b4d...` with bytes `41819931` versus B RB `41963733`.
- Source variant hashes match the preflight variant table: `S_STALE24` open `8268fb...`; `S_PEER10` peer `573b41...`; `S_ONEROW` open `64b660...`; `S_LF` open `37f6de...`; `S_REVERSE` open `a441b1...`; `S_BOOLCASE` open `cf4ed6...`. Unchanged files equal frozen `ba089f...` or `cb78ae...`.

**Fixture count and pass/fail**

- B RA: 14 rows, all `pass=TRUE`.
- B RB: 14 rows, all `pass=TRUE`.
- Each seeded RB: 14 rows, all `pass=TRUE`.
- No fixture failure appears in the raw fixture rows.

**Internal inconsistency flags**

- `H2` states “B recon is 0/0/0: TRUE; B full-field recon mismatches: dormant_h 1, open_age_h 2.” This is consistent only if “recon” means key/label recon. The SPEC defines exact recon as key set + classification, so the dormant/open_age values are full-field mismatches, not the frozen recon. This is a terminology ambiguity in the runner output, not a numerical contradiction.
- In the source-variant preflight, the `V_STALE24 src_peer_stats.csv` line repeats “rows dropped: 848” even though peer stats is unchanged. This is a note misapplied to the peer-stats line.
- No other numerical inconsistency was found between `C26_RESULTS.md`, `C26_arms.csv`, the run log, and the manifests.

4. **Facts that cannot be recomputed from this packet**

- The actual byte-level contents and row-level differences behind the 773 `S_STALE24` key losses, the 269 `S_PEER10` label disagreements, and the single `S_ONEROW` dormant change.
- Frozen RA/RB row-level classifications; only aggregate comparisons are present.
- Full stdout/stderr for each R run beyond exit codes and fixture rows.
- Full contents of `runner/SEEDS_b1.sha256`, `runner/SEED_DIFFS_b1.txt`, `runner/source_variants.R`, and `seeds/C26/ARMS.tsv`.
- Full arm-manifest list; only key files are shown.
- Independent hashes of the evidence files themselves; only the provided `C26_EVIDENCE.sha256` values are available.
- MySQL preflight details beyond the reported counts `245193 / 104`.

5. **P1 assessment against the frozen predicate in the SPEC**  
   Facts only:

- Frozen `H = {S_STALE24, S_PEER10, S_ONEROW}`.
- Frozen `D_abl` definition: crash, recon key/label mismatch where `n_only_ra + n_only_rb + n_disagree > 0`, or fixture failure on any path.
- From the evidence, `D_abl = {S_STALE24, S_PEER10}`.
- `H \ D_abl = {S_ONEROW}`.
- `S_ONEROW` has RB exit `0`, fixtures `14/14`, recon key/label `0/0/0`, but `RB_vs_B dormant=1` and `locked_field_changes_vs_B=1`. It is not caught without the control.
- Therefore the condition `H ⊆ D_abl` is false because `S_ONEROW ∈ H` and `S_ONEROW ∉ D_abl`.
- `S_LF`, `S_REVERSE`, and `S_BOOLCASE` have no locked-field change and are not in `H`; they are caught with the control only by source SHA-256 difference.

6. **Blocking objections**  
   None supported by the frozen evidence. The only ambiguity is the `H2` use of “recon” for key/label `0/0/0` while also reporting full-field dormant/open_age mismatches; the SPEC defines exact recon as key set + classification, so this is an output-labeling ambiguity rather than a hard mechanical conflict. No harness, seed, predicate-application, or evidence defect in this packet blocks a verdict.
7. **Claim → evidence map**  
   | claim | evidence |  
   |---|---|  
   | Arm B exits 0 on both paths | run log; `C26_RESULTS.md` H1 |  
   | Arm B fixtures 14/14 on both paths | fixture rows for B RA and B RB; H1 |  
   | Arm B reproduces frozen pack | `C26_RESULTS.md` H2; Arm B repro table |  
   | B recon key/label is 0/0/0 | Arm B recon table; H2 |  
   | B full-field recon has dormant 1, open_age 2 | Arm B recon table; H2 |  
   | All six seeded arms recorded | run log; H3; `C26_arms.csv` |  
   | Harm set H | H4; `C26_arms.csv` `harm` column |  
   | Caught without control | H5; `C26_arms.csv` `caught_without_control` |  
   | `H \ D_abl` | H6; recomputation from H4 and H5 |  
   | No locked-field change arms | H7; `C26_arms.csv` `locked_field_changes_vs_B=0` |  
   | Caught with control | H8; `C26_arms.csv` `caught_with_control` |  
   | Caught with control but no locked-field change | H9; recomputation |  
   | Source variant hashes | preflight variant lines; arm manifests |  
   | Cross-arm output hash equalities | arm manifests |  
   | Fixture rows all pass | fixture results per arm and path |

END C26 VALIDATOR REPORT
