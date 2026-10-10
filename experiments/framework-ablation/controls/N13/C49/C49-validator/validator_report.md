# C49 VALIDATOR REPORT

## 1. Role attestation and ablation ID

I am the Validator only. I am blind to the Builder; I have not seen and must not ask for its output. I am not returning KEEP, REVERT, or HALT. Ablation ID: C49 (Addendum 02 candidate #49, “Individual-file evidence delivery”).

## 2. Independent test plan: what you checked, and how

I checked the frozen SPEC, constitution, preflight gating output, runner log, `C49_RESULTS.md`, `C49_POST_RESULTS.md`, the three reviewer replies, their `TIMES.txt` files, the deviation notes, the patched and original `ARMS.tsv`, and the seed/delivery hash lists. I recomputed arithmetic from the evidence tables: file byte sums, portfolio counts, kappa sensitivity, Q1–Q5, and percentages. I checked SHA-256 equalities across `SHA256SUMS`, `DELIVERY_FILES.csv`, the preflight seed hashes, and the DS_FILES/GPT_FILES replies. I checked access-proof and inventory-hash conditions against the frozen P1 text. I did not rerun R code, open the ZIP, or access any external file; everything below is from the packet.

## 3. Independently recomputed hard facts

- **Delivery set identity:** 9 evidence files + `SHA256SUMS` = 10 files. Sum of 9 evidence bytes = 16,490; plus `SHA256SUMS` 833 = 17,323. ZIP entries = 10; ZIP bytes = 9,592; ZIP SHA-256 = `ea8ff49d164e41dcd442590dbec6c7d9ffb2c83a9baa5a5e6193d79c6cde5f9d`. CHECK arm exit=0, status=PASS, secs=0.6.
- **SHA-256 equalities:** In `DELIVERY_FILES.csv`, for all 9 evidence files, `sha256_listed = sha256_file = sha256_zip`. These equal the preflight seed hashes. The `SHA256SUMS` row has `sha256_listed=NA`, `sha256_file=1f2aad88d78e4c4a582e39d0745af8d710d1fcdedb69a35982e245b213ddec75`, `sha256_zip=1f2aad88…`. The 9 listed hashes match the `SHA256SUMS` content.
- **Cross-arm hash equality:** DS_FILES and GPT_FILES replies list identical SHA-256 values for all 9 evidence files, and each equals the `SHA256SUMS` hash. DS_ZIP lists `UNAVAILABLE` for all 9.
- **Portfolio summary:** `n_decision=222002`, `n_ESCALATE=131968`, `n_INCONCLUSIVE=6377`, `n_STANDARD=83657`, `kappa=2`. Sum: 131968 + 6377 + 83657 = 222002. `pct_ESCALATE=0.5944450950892334` = 131968/222002. `pct_INCONCLUSIVE=0.028724966441743768` = 6377/222002. `pct_STANDARD=0.3768299384690228` = 83657/222002. Percent sum = 1.
- **Kappa sensitivity last line:** `kappa=3`, `n_decision=222002`, `n_ESCALATE=118246`, `n_INCONCLUSIVE=6377`, `n_STANDARD=97379`. Sum: 118246 + 6377 + 97379 = 222002. Delta kappa=2 → 3: ESCALATE −13722, INCONCLUSIVE 0, STANDARD +13722, n_decision 0.
- **Q1 = 131968** (portfolio_summary.csv ESCALATE at kappa=2).
- **Q2 = 64922** (KNOWN_ANSWERS.csv WCA2). Not independently recomputed from the primary file; the WCA2 row is not in the packet.
- **Q3 = 49.2**: 64922/131968 × 100 = 49.195… rounded to 1 decimal = 49.2.
- **Q4 = 25**: `escalate_by_type_top25.csv` has LINES=26, first line header, so 25 data rows.
- **Q5 = 118246** (kappa_sensitivity.csv ESCALATE at kappa=3).
- **Escalate by type last line:** `WCA,460,0.0034856935014548982,0.9593765155189137`. **Inconclusive by clause last line:** `thin_type_or_missing_peer,6377,1`.
- **Access proof:** DS_FILES: 9/9 `opened_proven`, 9/9 `sha_match`, 5/5 facts answered, 5/5 correct, `usable=TRUE`, `minutes=0.83`, `time_to_usable=0.83`. GPT_FILES: 9/9 `opened_proven`, 9/9 `sha_match`, 5/5 facts answered, 5/5 correct, `usable=TRUE`, `minutes=5.00`, `time_to_usable=5.00`. DS_ZIP: 0/9 `opened_proven`, 0/9 `sha_match`, `usable=FALSE`, `time_to_usable=Inf`, `minutes=0.65` upper bound.
- **TIMES:** DS_ZIP sent 11:41:31, reply_complete 11:42:10 = 0.65 min (upper bound). DS_FILES sent 12:30:32, reply_complete 12:31:22 = 0.83 min (operator-logged). GPT_FILES sent 11:44:55, reply_complete 11:49:55 = 5.00 min (upper bound).
- **Predicate conditions as recorded by the frozen scorer:** condition 0 MET; condition 1 MET; condition 2 MET; condition 3 MET.
- **Internal inconsistencies flagged in runner output:**

  - **DS_ZIP scorer parse artifact:** `C49_POST_RESULTS.md` reports DS_ZIP `facts_answered=3`, `facts_correct=1`, but the DS_ZIP reply has Q1–Q5 all `UNAVAILABLE`. The scorer picked “25” from `escalate_by_type_top25.csv` in the `UNAVAILABLE` text. This is a scorer defect, not a model answer.
  - **AI1_INTERPRETATION.md LINES discrepancy:** DS_FILES reply says `LINES: 254`; GPT_FILES reply says `LINES: 252`; the superseded first DS_FILES reply says `LINES: 252`. The file hash is identical (`73f448…`), so the line count should be identical. This does not affect access proof (FIRST/LAST used), but it is an internal inconsistency in the inventory.
  - **Post-freeze patches:** The `ARMS.tsv` used by the scorer has hash `bead849473f20fa93faf53091325faaa87f6db9f03c5ea6ed1b6a2809c1a4f95`; the preflight frozen hash is `edc8a02618014eb9e370ae01f605303630874d465917f3785b7fa5518d3ddeea`. DS_FILES used packet `C49_R_DS_FILES_PD3.txt` (`89ac5ab…`) instead of frozen `C49_R_DS_FILES.txt` (`9fa6cc…`). DS_FILES used delivery set `FILES_PD3` with `SHA256SUMS.txt` instead of frozen `FILES/` with `SHA256SUMS`.

## 4. Facts that cannot be recomputed from this packet

- Full contents of the 9 evidence files; only first/last lines and some numbers are present.
- Q2 (WCA2 row) cannot be independently recomputed from the primary file; only `KNOWN_ANSWERS.csv` gives it.
- Full `kappa_sensitivity.csv` rows for kappa=1 and 1.5; only the last line and GPT reply citation are present.
- Full `escalate_by_type_top25.csv` rows; only header and last row are present.
- Full `STAGE5_EVIDENCE_PACKAGE.md`, `STAGE5_DEEPER_FINDINGS.md`, and `AI1_INTERPRETATION.md` beyond first/last lines and GPT findings.
- The actual ZIP binary and unzipped files; only hashes and byte counts are present.
- Exact observed completion times for DS_ZIP and GPT_FILES; they are upper bounds from page mtime.
- The original DS_FILES first reply is superseded and not scored; its TIMES and reply are provided as evidence only.
- The DS_ZIP upload attempt/refusal is operator account only, not mechanically evidenced.
- The cause of PD-3 is stated as likely (extensionless file) but not proven.
- No separate D-set table is present; only the delivery-set identities above can be recomputed.

## 5. P1 assessment against the frozen predicate

Facts only, no terminal state.

- **Condition 0 (validity):** CHECK arm exit=0, status=PASS; `c49_check.R` output `status=PASS`; `DELIVERY_FILES.csv` shows `SHA256SUMS` matches all 9 evidence files and the ZIP holds byte-identical copies. Condition 0 MET.
- **Condition 1 (variant access):** DS_FILES and GPT_FILES each prove access to all 9 evidence files. `INVENTORY_DS_FILES.csv`: `opened_proven=TRUE` for all 9. `INVENTORY_GPT_FILES.csv`: `opened_proven=TRUE` for all 9. Condition 1 MET.
- **Condition 2 (inventory hashes):** DS_FILES and GPT_FILES each list every evidence file with the SHA-256 in `SHA256SUMS`. `INVENTORY_DS_FILES.csv`: `sha_match=TRUE` for all 9. `INVENTORY_GPT_FILES.csv`: `sha_match=TRUE` for all 9. Condition 2 MET.
- **Condition 3 (delay no worse):** DS_ZIP is not usable (`opened_proven=0`, `usable=FALSE`), so by the frozen SPEC text “DS_ZIP not usable = met.” DS_FILES time to usable first pass = 0.83 min. DS_ZIP time = 0.65 min upper bound but not usable. Condition 3 MET.
- The frozen scorer records all P1 conditions as MET. Note: condition 2 for DS_FILES depends on the PD-3 rerun and the patched `ARMS.tsv`; see blocking objections.

## 6. Blocking objections

- **Blocking objection 1:** Post-freeze modification of frozen runner-side file `ARMS.tsv`. Preflight gating verified `edc8a02618014eb9e370ae01f605303630874d465917f3785b7fa5518d3ddeea`; the scorer uses `bead849473f20fa93faf53091325faaa87f6db9f03c5ea6ed1b6a2809c1a4f95`. This is a hash mismatch against the frozen preflight list.
- **Blocking objection 2:** Post-freeze substitution of the DS_FILES packet. Frozen packet `C49_R_DS_FILES.txt` has hash `9fa6cc58745d144a5c53a371f0b41db69d0503b212c2b1ce08a33eb84998f7a2`; used packet `C49_R_DS_FILES_PD3.txt` has hash `89ac5ab586f1daab8d4cbfa8c4819ebb1f2bf764d232773f769cc3c6afed0aba`. This is a changed frozen input.
- **Blocking objection 3:** Post-freeze substitution of the DS_FILES delivery set. Frozen set is `seeds/C49/delivery/FILES/` with `SHA256SUMS`; used set is `FILES_PD3` with `SHA256SUMS.txt`. Although the 9 evidence files are byte-identical, the frozen seed path and filename for `SHA256SUMS` are changed. This is a deviation from the frozen seed.  
  These are disclosed in the deviation notes, but under constitution §9 a hash/frozen-version mismatch is a blocking condition. If the coordinator’s deviation ruling is treated as authoritative, they may be non-blocking; as Validator, I record them as blocking objections supported by the frozen evidence.
- **Non-blocking defects:** DS_ZIP scorer parse artifact (`facts_answered=3`, `correct=1` should be 0/0); AI1_INTERPRETATION.md LINES discrepancy (254 vs 252); TIMES upper bounds for DS_ZIP and GPT_FILES.

## 7. Claim → evidence map

| Claim | Evidence |
| --- | --- |
| C49 CHECK delivery set valid | `C49_RESULTS.md`, `arms/CHECK/outputs/DELIVERY_CHECK.txt`, `DELIVERY_FILES.csv` |
| 9 evidence + SHA256SUMS, 10 files, 17,323 bytes | `DELIVERY_FILES.csv`, byte sums |
| ZIP 10 entries, 9,592 bytes, SHA `ea8ff49d…` | `DELIVERY_CHECK.txt`, `C49_RESULTS.md` |
| Q1 = 131968 | `portfolio_summary.csv` last line (DS_FILES/GPT_FILES replies) |
| Q2 = 64922 | `KNOWN_ANSWERS.csv` |
| Q3 = 49.2 | computed 64922/131968 |
| Q4 = 25 | `escalate_by_type_top25.csv` LINES=26 |
| Q5 = 118246 | `kappa_sensitivity.csv` last line |
| DS_FILES access 9/9 | `INVENTORY_DS_FILES.csv`, DS_FILES reply |
| GPT_FILES access 9/9 | `INVENTORY_GPT_FILES.csv`, GPT_FILES reply |
| DS_ZIP access 0/9 | `INVENTORY_DS_ZIP.csv`, DS_ZIP reply |
| DS_FILES sha_match 9/9 | `INVENTORY_DS_FILES.csv`, `SHA256SUMS` |
| GPT_FILES sha_match 9/9 | `INVENTORY_GPT_FILES.csv`, `SHA256SUMS` |
| TIMES | `C49/C49-*/TIMES.txt` |
| PD-3 defect | `DEVIATION_NOTES_post.md`, part 2 |
| ARMS.tsv patch | `ARMS.tsv` patched, `ARMS.v1_prePD3.tsv`, deviation notes |
| Scorer parse artifact | `C49_POST_RESULTS.md` vs DS_ZIP reply |
| N1/OF-1 | COORDINATOR NOTE N1, SPEC |

END C49 VALIDATOR REPORT
