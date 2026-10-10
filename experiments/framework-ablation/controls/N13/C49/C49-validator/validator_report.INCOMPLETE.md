# C49 VALIDATOR REPORT

## 1. Role attestation and ablation ID

I am DeepSeek, acting as Validator for **C49** (Addendum 02, candidate #49 “Individual-file evidence delivery”), batch **N13 batch b6**. I am blind to the Builder; I have not seen and must not ask for the Builder’s output. I do not return KEEP, REVERT, or HALT. This is an independent first pass.

## 2. Independent test plan

I checked the packet mechanically and independently:

1. Re-derived the delivery-set counts and byte totals from `DELIVERY_FILES.csv`, `DELIVERY_CHECK.txt`, and `C49_RESULTS.md`.
2. Cross-checked every `SHA256SUMS` entry against `DELIVERY_FILES.csv` (`sha256_file`, `sha256_zip`) and against the DS_FILES and GPT_FILES replies.
3. Re-derived Q1, Q3, Q4, Q5 from the provided CSV rows and identity arithmetic; checked Q2 only as far as the packet exposes it.
4. Recomputed portfolio-summary identities: row totals and percentages.
5. Recomputed cross-arm hash equalities: reply hashes, TIMES hashes, packet hashes, delivery-file hashes, ZIP-vs-FILES hashes.
6. Checked the frozen P1 predicate conditions 0–3 against the SPEC text and the post-chat scorer output.
7. Checked disclosed deviations and internal inconsistencies in the runner output.

## 3. Independently recomputed hard facts

### 3.1 Delivery-set counts and bytes

From `DELIVERY_FILES.csv` and `DELIVERY_CHECK.txt`:

| item | recomputed |
| --- | --- |
| evidence files (`n_evidence_files`) | 9 |
| `SHA256SUMS` entries | 9 evidence files |
| ZIP entries | 10 |
| ZIP bytes | 9592 |
| evidence-file bytes only | 16490 |
| all 10 files bytes total | 17323 |
| `files_bytes_total` | 17323 |

Sum check:

- 4051 + 2007 + 644 + 1264 + 58 + 190 + 164 + 183 + 7929 = **16490**
- 16490 + 833 (`SHA256SUMS`) = **17323**

These match `DELIVERY_CHECK.txt` and `C49_RESULTS.md`.

### 3.2 SHA-256 identities

`SHA256SUMS` lists these 9 hashes and files:

| file | SHA-256 in SHA256SUMS |
| --- | --- |
| STAGE5_EVIDENCE_PACKAGE.md | c8e191d861a71097b4bc2ebaaab2626633617350e39f130e1c7d148a3379bfb7 |
| STAGE5_DEEPER_FINDINGS.md | 49ab09c26c86e4a0abcd2031745e0c4bc786dffc8fe6cf4066e9c3afa93c70e6 |
| capacity_coverage_note.csv | 4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609 |
| escalate_by_type_top25.csv | 6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176 |
| inconclusive_by_clause.csv | f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d |
| independent_checks_critical_counts.csv | 4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146 |
| kappa_sensitivity.csv | 7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a |
| portfolio_summary.csv | b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167 |
| AI1_INTERPRETATION.md | 73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932 |

`DELIVERY_FILES.csv` has identical `sha256_file` and `sha256_zip` for all 9, plus `SHA256SUMS` itself:

- `SHA256SUMS` file hash: `1f2aad88d78e4c4a582e39d0745af8d710d1fcdedb69a35982e245b213ddec75`
- `SHA256SUMS` `sha256_listed`: `NA`
- `SHA256SUMS` `in_zip`: `TRUE`
- `SHA256SUMS` `sha256_zip`: `1f2aad88d78e4c4a582e39d0745af8d710d1fcdedb69a35982e245b213ddec75`

The ZIP is therefore byte-identical to the 10 files on the hashes shown.

### 3.3 Portfolio identities and Q facts

From `portfolio_summary.csv` last line:  
`222002,131968,6377,83657,0.5944450950892334,0.028724966441743768,0.3768299384690228,2`

Recomputed:

- `n_decision` = 222002
- `n_ESCALATE` = 131968
- `n_INCONCLUSIVE` = 6377
- `n_STANDARD` = 83657
- Sum: 131968 + 6377 + 83657 = **222002**
- `pct_ESCALATE` = 131968 / 222002 = **0.594445...**
- `pct_INCONCLUSIVE` = 6377 / 222002 = **0.028724966...**
- `pct_STANDARD` = 83657 / 222002 = **0.376829938...**
- kappa = 2

From `independent_checks_critical_counts.csv` last line:  
`validated_action_list_n,131968,131968,TRUE` — matches Q1.

From `capacity_coverage_note.csv` last line:  
`full_escalate_portfolio,131968,131968,1,...` — matches Q1.

From `kappa_sensitivity.csv` last line:  
`3,222002,118246,6377,97379` — Q5 = **118246**.

From `escalate_by_type_top25.csv`:

- Reply inventory says `LINES: 26`.
- Header line + 25 data rows => Q4 = **25**.
- Last line shown: `WCA,460,0.0034856935014548982,0.9593765155189137`.
- Q2 = 64922 is in `KNOWN_ANSWERS.csv` as `escalate_by_type_top25.csv WCA2`, but the provided last line does not expose WCA2 or 64922. Q2 cannot be independently recomputed from the packet excerpt alone.

Identity Q3:

- Q3 = 64922 / 131968 × 100 = **49.1952...%** => rounded to 1 decimal = **49.2**. Matches `KNOWN_ANSWERS.csv`.

### 3.4 Portfolio deltas and kappa sensitivity

From the GPT_FILES reply quoting `STAGE5_DEEPER_FINDINGS.md`:

- ESCALATE across kappa 1, 1.5, 2, 3 = 152292, 140340, 131968, 118246.
- Deltas:

  - 152292 − 140340 = **11952**
  - 140340 − 131968 = **8372**
  - 131968 − 118246 = **13722**
- Total kappa=1 to kappa=3 delta: 152292 − 118246 = **34046**.

The provided packet does not include the full `kappa_sensitivity.csv`, so these are cross-checked from the GPT_FILES reply and the last line, not fully independently recomputed from raw rows.

### 3.5 Cross-arm hash equalities

- `REPLY_FREEZE.json` reply hashes match the post-chat scorer `reply_sha256` values:

  - DS_ZIP: `434ead16128d6b32346a6a5febc0f944477c1d8c15a5a2b6156e75fc67157ca6`
  - DS_FILES: `f6e0a1f79a95ad566df9511366f5d5a021947d0e59cd11ca5218b22f663b074f`
  - GPT_FILES: `94cab4c78cb7760d3a557179579def0409d1ef6faf0c0c45294c31dac2aff740`
- `REPLY_FREEZE.json` TIMES hashes match the packet TIMES files:

  - DS_ZIP: `8b2b645eab7818ee25cfb3827c2d1061bc2265c37651c3aeb11b7844c607e7d5`
  - DS_FILES: `689612cf41574f755342ab8c2bd3a91f5d0997263b49c00bd6f9bca457c7ef58`
  - GPT_FILES: `927e813d535df3bfd7ccbdcd302addf2b494584b011bbc3f8da428a399ea2dcf`
- DS_ZIP packet hash: `158713b3193b8541f0a1f94b26267689a956ec8e11bdf1f759634f9099d4abe1` — matches SPEC and REPLY_FREEZE.
- GPT_FILES packet hash: `bf2f3ac4b7f82e0090852200be6c6906b1cd190fb6533a9ba8075cf04f6c27e2` — matches SPEC and REPLY_FREEZE.
- DS_FILES PD-3 packet hash: `89ac5ab586f1daab8d4cbfa8c4819ebb1f2bf764d232773f769cc3c6afed0aba` — matches REPLY_FREEZE but differs from the frozen SPEC’s original DS_FILES packet hash `9fa6cc58745d144a5c53a371f0b41db69d0503b212c2b1ce08a33eb84998f7a2`.

Delivery-file cross-arm equalities:

- DS_FILES reply lists 9/9 SHA-256 values matching `SHA256SUMS`.
- GPT_FILES reply lists 9/9 SHA-256 values matching `SHA256SUMS`.
- DS_ZIP reply lists 0/9 SHA-256 matches; it reports `UNAVAILABLE`.
- ZIP-vs-FILES: all 10 `sha256_zip` values equal their `sha256_file` values in `DELIVERY_FILES.csv`.

### 3.6 Internal inconsistencies in runner output

1. **DS_ZIP facts-scoring artifact.** `FACTS_DS_ZIP.csv` reports Q2=25, Q3=25, Q4=25, `facts_answered=3`, `facts_correct=1`. The verbatim DS_ZIP reply says Q2–Q4 are `UNAVAILABLE`. The 25s are parsed from `escalate_by_type_top25.csv` in the unavailable-text. This is disclosed in `DEVIATION_NOTES_post_2.md`. It does not change P1 because DS_ZIP is unusable either way, but it is an inconsistency in the scorer output.
2. **ARMS.tsv frozen-input mismatch.** The preflight seed list and SPEC show `ARMS.tsv` hash `edc8a026...`. The post-freeze patched `ARMS.tsv` is `bead849473f20fa93faf53091325faaa87f6db9f03c5ea6ed1b6a2809c1a4f95`. The post-chat scorer reads the patched file. This is disclosed as the PD-3 remediation.
3. **DS_FILES delivery-set deviation.** The original DS_FILES arm did not receive `SHA256SUMS`; the superseded reply says so. The rerun used `FILES_PD3/` with `SHA256SUMS.txt`. The frozen SPEC refers to `FILES/SHA256SUMS`. This is disclosed as PD-3.
4. **TIMES upper bounds.** DS_ZIP and GPT_FILES `reply_complete` are box mtimes, not observed completion times. D-T1 discloses this. Condition 3 is not affected because DS_ZIP is unusable.

## 4. Facts that cannot be recomputed from this packet

- Full contents of the 9 evidence files. Only hashes, selected first/last lines, and selected last rows are provided. I cannot independently verify all first/last lines against raw file bodies.
- Q2 = 64922 from `escalate_by_type_top25.csv WCA2`. The provided last line is `WCA,460,...`; WCA2 and 64922 are not exposed in the packet excerpt.
- The full `kappa_sensitivity.csv` rows. Only the last line and GPT_FILES’s quoted sequence are provided.
- The full `escalate_by_type_top25.csv` rows. Only header, line count, and last line are provided.
- Actual attachment chips / DOM for DS_ZIP and the original DS_FILES upload. The packet relies on operator account and saved-page gaps.
- True observed reply-completion times for DS_ZIP and GPT_FILES. Only page-mtime upper bounds are provided.
- The exact contents of `FILES_PD3/SHA256SUMS.txt`; only its hash relation and the scorer’s read of `FILES/SHA256SUMS` are provided.
- Any D-set table. No D-set table appears in the provided C49 packet; I cannot recompute D-sets.

## 5. P1 assessment against the frozen predicate in the SPEC

Facts only:

- **Condition 0 — delivery sets valid (pre-chat):** `CHECK` exit = 0, status = PASS. `n_evidence_files=9`, `zip_entries=10`, `zip_bytes=9592`, `files_bytes_total=17323`. All 9 `SHA256SUMS` hashes match their files; all 10 ZIP copies match their files. **MET**.
- **Condition 1 — variant access:** Post-chat scorer shows DS_FILES `files_opened_proven=9/9`; GPT_FILES `files_opened_proven=9/9`. Both replies list FIRST/LAST lines for all 9 evidence files. **MET** as scored.
- **Condition 2 — inventory hashes:** Post-chat scorer shows DS_FILES `sha_match=9/9`; GPT_FILES `sha_match=9/9`. DS_FILES used the PD-3 rerun with `SHA256SUMS.txt`; the hashes match the frozen `SHA256SUMS`. **MET** as scored, with the PD-3 deviation disclosed.
- **Condition 3 — delay no worse:** DS_ZIP is not usable: `files_opened_proven=0/9`, `usable=FALSE`, `time_to_usable_min=Inf`. Per the SPEC, “DS_ZIP not usable = met.” DS_FILES `time_to_usable_min=0.83` min. **MET** as scored.

The post-chat scorer reports: `**Mechanical predicate result: P1 MET**`. I do not return a terminal state.

## 6. Blocking objections

**Blocking objection:** The executed DS_FILES arm is not the frozen DS_FILES arm. The frozen SPEC identifies `C49_R_DS_FILES.txt` SHA-256 `9fa6cc...` and the `FILES/SHA256SUMS` delivery set. The scored DS_FILES arm uses `C49_R_DS_FILES_PD3.txt` SHA-256 `89ac5a...`, the patched `ARMS.tsv` hash `bead849...`, and the `FILES_PD3/SHA256SUMS.txt` delivery set. This is a post-freeze change to a frozen runner-side seed and packet. It is disclosed as PD-3 remediation, but under the frozen-input and HALT conditions in the constitution it is a procedural defect that should block a clean verdict unless the adjudicator explicitly accepts the disclosed PD-3 replacement as authoritative.

Other material defects, not blocking P1 by themselves:

- DS_ZIP scorer output contains incorrect `facts_answered` / `facts_correct` values relative to the verbatim DS_ZIP reply.
- DS_ZIP and GPT_FILES timing records are upper bounds, not observed completion times.
- The original DS_FILES delivery defect means the first DS_FILES attempt was invalid; the rerun is the scored record.

## 7. Claim → evidence map

| claim | evidence |
| --- | --- |
| Ablation ID C49; Validator DeepSeek; blind first pass | SPEC header; this packet |
| Delivery check passed | `C49_RESULTS.md`; `DELIVERY_CHECK.txt`; `DELIVERY_FILES.csv` |
| 9 evidence files + `SHA256SUMS` | `SHA256SUMS`; `DELIVERY_FILES.csv` |
| ZIP byte-identical to FILES | `DELIVERY_FILES.csv` `sha256_file == sha256_zip`; `zip_entries=10` |
| DS_FILES proves 9/9 access | DS_FILES reply; `INVENTORY_DS_FILES.csv`; post-chat arm row |
| GPT_FILES proves 9/9 access | GPT_FILES reply; `INVENTORY_GPT_FILES.csv`; post-chat arm row |
| DS_ZIP unusable | DS_ZIP reply `OPENED: NO`; `INVENTORY_DS_ZIP.csv`; post-chat arm row |
| Q1 = 131968 | `portfolio_summary.csv` last line; `independent_checks_critical_counts.csv` last line; `capacity_coverage_note.csv` last line |
| Q2 = 64922 | `KNOWN_ANSWERS.csv`; DS_FILES and GPT_FILES replies; not independently visible in the provided CSV excerpt |
| Q3 = 49.2 | identity 64922 / 131968 × 100 = 49.1952 → 49.2 |
| Q4 = 25 | `escalate_by_type_top25.csv` `LINES: 26`; header + 25 data rows |
| Q5 = 118246 | `kappa_sensitivity.csv` last line: `3,222` |
