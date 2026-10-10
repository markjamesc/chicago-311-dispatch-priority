# C43 VALIDATOR REPORT

## 1. Role attestation and ablation ID

I am DeepSeek, acting only as Validator for this first pass. I am blind to the Builder; I have not seen and have not asked for the Builder output. I return no terminal state.

Ablation ID: **C43** — Addendum 01b, candidate #43 “Freeze scope,” N13 batch b6.  
Roles in the frozen spec: Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok.  
Constitution version: 1.0, SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`.

## 2. Independent test plan: what I checked, and how

I performed a packet-only audit of the frozen C43 evidence. I did not rerun R, read MySQL, or use tools. I checked:

1. Role and ablation identity against the SPEC.
2. Frozen preflight gating against the declared frozen reference hashes and runner-side file hashes.
3. Arm manifests against runner-side file hashes and output hashes quoted in the packet.
4. Arithmetic identities in `SUMMARY.txt`, `NEEDED.csv`, `CITATIONS.csv`, and the summarized `HASHED_ARTIFACTS.csv`.
5. The mechanical P1 condition mapping from `C43_RESULTS.md` against `NEEDED.csv` and `AUDIT_RESULT.txt`.
6. Self-test evidence in `SELFTEST.txt` and `AUDIT_RESULT.txt`.
7. Internal consistency of class totals, citation totals, needed counts, unresolved-path totals, and hash-list totals.
8. The known N1 / OF-1 clock note, to confirm C43 does not depend on clock values or R path reruns.
9. Cross-hash equality among preflight, frozen reference hashes, runner-side files, arm input manifests, and arm output manifests.

## 3. Independently recomputed hard facts

### Class and artifact identities

From `SUMMARY.txt` and the summarized `HASHED_ARTIFACTS.csv`:

- Class I total:  
  `1650 + 62 + 3 + 4210 + 40 = 5965` → matches `class_I=5965`.
- Class G total: `8130` → matches `class_G=8130`.
- Distinct hashed artifacts:  
  `8130 + 5965 = 14095` → matches `distinct_hashed_artifacts=14095`.
- By-rule sum:  
  `I1 1650 + I2 62 + I3 3 + I4 4210 + I5 40 + G0 8130 = 14095`.
- Unresolved-path sum:  
  `G 5738 + I1 1128 + I2 2 + I3 0 + I4 0 + I5 0 = 6868` → matches `unresolved_paths=6868`.
- Class-I known bytes:  
  `7,353,129 + 1,675,268 + 2,504,801 + 487,189,756 + 1,937,804 = 500,660,758` → matches `class_I_bytes_known=500660758`.

### Needed and citation identities

From `NEEDED.csv` and `CITATIONS.csv`:

- Needed-by-directory: 3 rows:  
  `_interim_b4`, `_superseded_v0`, `_smoke_b3` → matches `needed_by_directory=3`.
- Needed-by-path: 2 rows:  
  `N15/pc_run_b2.tgz`, `N15/pc_run_b3.tgz` → matches `needed_by_path_or_name=2`.
- Needed-by-hash: 10 rows:  
  `C26_3_ADJUDICATOR_Grok.HEAD.txt`, `C26_3_ADJUDICATOR_Grok.HEAD.v1.txt`, `C31...HEAD.txt`, `C31...HEAD.v1.txt`, `C39...HEAD.txt`, `C39...HEAD.v1.txt`, `C30...HEAD.txt`, `C30...HEAD.v1.txt`, `C29...HEAD.txt`, `C29...HEAD.v1.txt` → matches `needed_by_hash=10`.
- `NEEDED.csv` contains 15 distinct artifact/kind rows, but the reported counts are by distinct artifact for hash and path/name and by directory name for directories.
- Counted citation rows in `CITATIONS.csv`: 16 rows.
- `hash_but_G_copy_exists` rows: `11198`.
- Citation total:  
  `16 + 11198 = 11214` → matches `citations_total=11214`.
- Sum of `hash_but_G_copy_exists` by record:  
  `29 + 48 + 48 + 48 + 3965 + 3 + 407 + 407 + 407 + 5229 + 414 + 193 = 11198` → matches `citations_hash_with_G_copy=11198`.

### Trail and hash-list identities

From `SUMMARY.txt` and `UNHASHED_TRAIL_FILES.txt`:

- `trail_files=7804`.
- `hash_list_files=598`.
- `trail_files_not_in_any_hash_list=598`.
- UNHASHED by kind: `.jsonl 3 + .sha256 449 + other 146 = 598` → matches the unhashed count.
- `hash_records=16261`, `distinct_hashed_artifacts=14095`; the difference is duplicate hash records, consistent with the packet.
- `unparsed_hash_lines=0`.

### Cross-arm and cross-file hash equalities

There is only one arm, `AUDIT`. No cross-arm behavioral deltas or D-sets are present in this C43 packet. I checked the hash equalities that are present:

| Item | Packet hash | Check |
| --- | --- | --- |
| `runner_b6/seeds/C43/ARMS.tsv` | `25d004971a97c26af0e468dc50bb45d3788a8efd9eb1692cdcd80ac938a84d67` | matches preflight and frozen reference |
| `runner_b6/seeds/C43/AUDIT` | `b0fcc932c071cf7d9a8ebe459130b898fcd94797157d76d6ad106068c7e5c1a3` | matches preflight and frozen reference |
| `runner_b6/seeds/C43/CLASS_RULES.tsv` | `f19694e21b94dc5b02759767a5fd4eae121302c70c6f9d140ad2c3f7bbf1e794` | matches preflight and frozen reference |
| `runner_b6/seeds/C43/RECORD_RULES.tsv` | `4a56ec8da726a0edda28d0302f8ba2f29d2490f65a50075474cab7cc40ffc220` | matches preflight and frozen reference |
| `runner_b6/seeds/C43/TRAIL_INDEX.tar` | `0fcc3b64ac8d464abec4cdaa33315d7c3009111a9cf5c54a1967897e1fb4c9c9` | matches preflight, frozen reference, and arm input manifest |
| `runner_b6/seeds/C43/TRAIL_INDEX_INVENTORY.tsv` | `cbe2903cbcb915f6e708efb075146a060a372a596b217af16d4b060c1957b6a9` | matches preflight and frozen reference |
| `runner_b6/seeds/C43/c43_audit.R` | `4c792370f92be028cab6d92b585b17851a4d9689dc2ee97926e1a86e884e0406` | matches preflight, frozen reference, and arm input manifest |
| `runner_b6/eval_b6.R` | `6f5f25181d1033b7162a393b8dc0fd1e2a65cee094cbddf9d9244f707526bb1a` | matches preflight and frozen reference |
| `runner_b6/run_batch_v6.ps1` | `5b97cd2a0520f6ea88f4bf220b3fca0756292ff352eebf28991e52d9d21254fb` | matches frozen reference |
| Frozen key7 outputs | `c099...`, `a0e42...`, `33696...`, `0d722...`, `b588...`, `eb677...`, `7a18...` | all match preflight and `FROZEN_KEY7.sha256` lines |
| Arm output files | `CITATIONS.csv d8039778...`, `HASHED_ARTIFACTS.csv 5f547e...`, `NEEDED.csv 229b...`, `SELFTEST.txt 121257...`, `SUMMARY.txt 6375...`, `UNHASHED_TRAIL_FILES.txt 68ebb...` | match arm manifest and quoted packet hashes |

### Internal inconsistency flags

- No arithmetic contradiction was found in the class totals, needed counts, citation totals, unresolved totals, or rule counts.
- Minor reporting truncation: `trail_index_sha256` in `C43_arms.csv` and in the `C43_RESULTS.md` arm table is shown as `0fcc3b64ac8d464a` (16 hex characters), not the full 64-hex SHA-256. The full hash is present elsewhere and matches the frozen reference. This is a reporting truncation, not a hash mismatch.
- `hash_records_class_I=6380`, `records_scanned=21`, and `records_excluded_class_I=3` cannot be independently recomputed from the summarized packet alone; I found no contradiction with the provided evidence.
- Portfolio deltas and D-sets: not applicable to this C43 packet; no R-A/R-B portfolio delta table or D-set table is present. Cross-arm comparison is limited to the single `AUDIT` arm.

## 4. Facts that cannot be recomputed from this packet

The following cannot be independently recomputed from the provided evidence:

1. The full 7,804-row `INVENTORY.tsv` and the full `TRAIL_INDEX.tar` contents.
2. The full 14,095-row `HASHED_ARTIFACTS.csv`; only the summarized class/rule table is provided.
3. The full 11,214-row `CITATIONS.csv`; only 16 counted rows and a summary of 11,198 `hash_but_G_copy_exists` rows are provided.
4. The full 598-path `UNHASHED_TRAIL_FILES.txt`; only counts by kind are provided.
5. The exact 21 scanned records and 3 excluded class-I records.
6. `hash_records_class_I=6380` from raw hash-record tables.
7. Individual `class_I_bytes_known` values for unresolved class-I artifacts.
8. The actual preflight execution output beyond the quoted block.
9. The self-test execution internals beyond `SELFTEST.txt`.
10. The actual contents of the cited records beyond the quoted citation lines.
11. The N1 / OF-1 clock values and R path behavior; C43 evidence does not include the clock rows or R reruns.
12. The full list of 598 hash-list files and the full list of 598 unhashed trail files.
13. Whether any audit or reconstruction depended silently on an intermediate artifact without naming or hashing it; the spec declares this limit.

## 5. P1 assessment against the frozen predicate in the SPEC

Frozen P1 conditions from the SPEC:

1. **No class-I artifact is NEEDED by hash.**  
   Evidence: `needed_by_hash=10`; `NEEDED.csv` lists ten class-I hash citations from `N15/TOOLS_PATCH_LOG.txt` for `C26`, `C31`, `C39`, `C30`, and `C29` `.HEAD.txt` and `.HEAD.v1.txt` files. Condition 1 is **NOT MET** by the mechanical evidence.
2. **No class-I artifact is NEEDED by path or file name, and no intermediate folder is cited.**  
   Evidence: `needed_by_path_or_name=2` for `N15/pc_run_b2.tgz` and `N15/pc_run_b3.tgz`, both cited in `N15/RESULTS_N15.md`; `needed_by_directory=3` for `_interim_b4`, `_superseded_v0`, and `_smoke_b3`. Condition 2 is **NOT MET** by the mechanical evidence.
3. **Harness validity: the auditor self-test passes.**  
   Evidence: `SELFTEST.txt` records `selftest=PASS seed_cite_detected=TRUE clean_not_flagged_with_G_copy=TRUE class_rules=TRUE`; `AUDIT_RESULT.txt` records `selftest=PASS`. Condition 3 is **MET**.

Cost reported, not scored: class-I hashed artifacts = 5,965; known class-I bytes = 500,660,758; by rule I1=1650, I2=62, I3=3, I4=4210, I5=40.

No terminal state is given here.

## 6. Blocking objections

None. I find no defect in the harness, seed, predicate application, or evidence in this packet that should block a verdict.

Non-blocking observations:

- The mechanical “needed” definition is an upper-bound proxy by design; it counts citations, not proven audit dependence, and cannot see silent use.
- The I5 assembly-input hash citations follow the declared rule: they are counted because no class-G artifact has the same SHA-256, even though their full text is inside an assembled gate-feeding packet.
- `trail_index_sha256` is truncated in the arm CSV and results table, but the full hash is present and consistent elsewhere.
- The N1 / OF-1 clock issue is disclosed and does not enter any C43 number.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| Validator role and ablation ID C43 | SPEC header; roles section; constitution hash `e6c3b348...` |
| Preflight gating passed | PREFLIGHT section: `preflight gating result: PASS` |
| Runner-side C43 files match frozen reference hashes | PREFLIGHT seed OK lines; FROZEN REFERENCE HASHES; RUNNER-SIDE FILES |
| Frozen key7 outputs match frozen pack hashes | PREFLIGHT frozen OK lines; FROZEN_KEY7.sha256 block |
| Audit arm ran to exit 0 | RUN LOG; `C43_arms.csv`; `RUN_AUDIT.exit` |
| Self-test passed | `SELFTEST.txt`; `AUDIT_RESULT.txt`; `C43_RESULTS.md` condition 3 |
| Class totals are internally consistent | `SUMMARY.txt`; summarized `HASHED_ARTIFACTS.csv` |
| Needed counts are internally consistent | `NEEDED.csv`; `AUDIT_RESULT.txt`; `C43_arms.csv` |
| Citation totals are internally consistent | `SUMMARY.txt`; counted `CITATIONS.csv` rows; `hash_but_G_copy_exists` summary |
| P1 condition 1 not met | `needed_by_hash=10`; `NEEDED.csv` hash rows |
| P1 condition 2 not met | `needed_by_path_or_name=2`; `needed_by_directory=3`; `NEEDED.csv` path/directory rows |
| P1 condition 3 met | `SELFTEST.txt`; `AUDIT_RESULT.txt` |
| N1 / OF-1 is known and outside C43 | COORDINATOR NOTE N1 / OF-1; C43 scope says it reruns no R path and reads no clock value |

END C43 VALIDATOR REPORT
