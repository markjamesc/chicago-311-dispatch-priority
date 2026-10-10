# C49 Builder Report

# 1. Role attestation and ablation ID

I attest that I am acting only as the independent **Builder** for **C49, Addendum 02 candidate #49, “Individual-file evidence delivery.”** I have not seen or used the Validator’s first-pass output. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The target is Stage 5 first-pass evidence delivery, not the analytical R implementation itself.

The coordinator’s N1/OF-1 disclosure is treated as a pre-existing frozen-pack finding: three ESCALATE rows have exactly 1.000-hour R-A/R-B clock differences in the repeated fall-back hour, while their labels agree. C49 does not rerun either R path, and the N1 note was held constant across reviewer prompts.

# 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS

Conceptually, C49 removes dependence on a **single archive being successfully delivered and opened** as the only Stage 5 evidence transport. The tested variant exposes the same nine evidence files individually, adds `SHA256SUMS`, and requires a per-file inventory containing `FILE / SHA256 / OPENED / LINES / FIRST / LAST`. The ZIP and FILES arms otherwise use identical evidence, and the inventory requirement is held constant so the intended experimental difference is delivery format.

The packet does **not** include the body of `runner_b6/SEED_DIFFS_b6.txt`; it includes only its frozen SHA-256, `729ed8cad382ae82805499d493bf7eb8fa38687665286649bb3746330f0b1e2d`. Therefore an exact line-by-line baseline→candidate diff cannot be independently reproduced from the SEED DIFFS artifact itself. The packet instead supplies the full C49 seed/harness file bodies, from which the implemented changes can be reconstructed.

| Seed/harness artifact | Exact seeded behavior visible in the packet |
| --- | --- |
| `delivery/FILES/` | Nine frozen evidence files plus `SHA256SUMS`; the evidence files are verbatim copies of their frozen sources. |
| `delivery/ZIP/evidence_pkg.zip` | Deterministic ZIP of those same ten files. |
| `KNOWN_ANSWERS.csv` | Q1=131968; Q2=64922; Q3=49.2; Q4=25; Q5=118246. |
| `ARMS.tsv` | Three reviewer arms: DS_ZIP, DS_FILES, GPT_FILES. |
| `c49_check.R` | Reads the nine hashes from `SHA256SUMS`; hashes the individual files; unzips the archive; requires the file-name sets to agree, each listed hash to equal the individual-file hash, every file to exist in the ZIP, every ZIP hash to equal its individual-file hash, and ZIP entry count to equal evidence-file count + 1. It writes `DELIVERY_CHECK.txt` and `DELIVERY_FILES.csv`. |
| `c49_score.R` | Derives access proof from matching normalized FIRST and LAST non-empty lines; requires the final END line; parses Q1–Q5; defines a usable pass as END + all nine access proofs + all five answers; assigns infinite time-to-usable to an unusable arm; mechanically evaluates predicate conditions 1–3. |
| `DELIVCHK` | Marker renamed from the originally attempted `DELIVERY` because Windows case-insensitive paths caused a collision with the `delivery/` directory during scratch preflight. |

These new C49 seed/harness artifacts are presented in full or by frozen hash in the packet.

A separate **post-freeze PD-3 correction** is not part of the original frozen seed state: the first DeepSeek FILES delivery omitted the extensionless `SHA256SUMS`. The rerun used byte-identical evidence with that file renamed `SHA256SUMS.txt`; the packet changed its two textual mentions accordingly, and the DS_FILES `ARMS.tsv` row was patched to point to the rerun packet. `c49_score.R` itself was unchanged.

# 3. Hard mechanical facts table

| Mechanical fact | Result | Status | Independent derivation / check |
| --- | --- | --- | --- |
| Evidence files excluding checksum manifest | **9** | **Recomputed** | Nine evidence rows precede `SHA256SUMS` in `DELIVERY_FILES.csv`. |
| Total files in each delivery set | **10** | **Recomputed** | 9 evidence files + 1 `SHA256SUMS`. |
| ZIP entries | **10** | **Recomputed** | Required count is 9+1; runner reports 10. |
| Uncompressed FILES bytes | **17,323** | **Recomputed** | 4051+2007+644+1264+58+190+164+183+7929+833 = 17,323. |
| ZIP bytes | **9,592** | **Quoted** | Binary compressed size is reported by the runner; it cannot be derived from uncompressed sizes alone. |
| Listed-hash = individual-file-hash = ZIP-hash, evidence files | **9/9** | **Recomputed** | All nine evidence rows have the same three hashes and `in_zip=TRUE`. |
| `SHA256SUMS` individual hash = ZIP hash | **1/1** | **Recomputed** | Final delivery row has equal file/ZIP hashes. |
| Total individual↔ZIP content-hash equality | **10/10** | **Recomputed** | Nine evidence files + checksum manifest all match. |

The delivery table supplying those byte counts and hashes is frozen in the runner output.

| Analytical/mechanical identity | Result | Status | Independent derivation / check |
| --- | --- | --- | --- |
| Q1, κ=2 ESCALATE | **131,968** | **Quoted / mechanically exposed source row** | `portfolio_summary.csv` verified LAST row contains 131968. |
| Q2, WCA2 ESCALATE | **64,922** | **Quoted** | Present in `KNOWN_ANSWERS.csv` and both usable reviewer answers; the underlying WCA2 row is not reproduced in this packet. |
| Q3, WCA2 share of ESCALATE | **49.2%** | **Recomputed** | 64,922 / 131,968 × 100 = 49.195259…%, rounded to one decimal = 49.2%. |
| Q4, `escalate_by_type_top25.csv` data rows | **25** | **Recomputed** | Both usable inventories report 26 lines; one header leaves 25 data rows. |
| Q5, κ=3 ESCALATE | **118,246** | **Quoted / mechanically exposed source row** | Verified LAST row of `kappa_sensitivity.csv`. |
| κ=2 portfolio identity | **222,002** | **Recomputed** | 131,968 ESCALATE + 6,377 INCONCLUSIVE + 83,657 STANDARD = 222,002. |
| κ=2 share identity | **1.000000…** | **Recomputed** | 0.5944450950892334 + 0.028724966441743768 + 0.3768299384690228 ≈ 1. |
| κ=3 portfolio identity | **222,002** | **Recomputed** | 118,246 + 6,377 + 97,379 = 222,002. |
| κ=2→κ=3 ESCALATE delta | **−13,722** | **Recomputed** | 118,246 − 131,968. |
| κ=2→κ=3 INCONCLUSIVE delta | **0** | **Recomputed** | 6,377 − 6,377. |
| κ=2→κ=3 STANDARD delta | **+13,722** | **Recomputed** | 97,379 − 83,657. |
| κ=2→κ=3 decision-total delta | **0** | **Recomputed** | 222,002 − 222,002. |

The mechanically proven LAST rows used above are present in both usable reviewer inventories.

| Reviewer-arm fact | Result | Status | Independent derivation / check |
| --- | --- | --- | --- |
| DS_ZIP files listed | **9/9** | **Recomputed** | Nine expected names appear, but names alone are not access proof. |
| DS_ZIP files access-proven | **0/9** | **Recomputed** | FIRST and LAST fail for all nine inventory rows. |
| DS_ZIP hash matches | **0/9** | **Recomputed** | All nine `sha_match` values are false. |
| DS_ZIP usable | **FALSE** | **Recomputed** | Zero access proofs, so usable-pass conjunction fails. |
| DS_ZIP scorer `facts_answered/facts_correct` | **3/1** | **Quoted scorer output** | Frozen scorer falsely parses `25` from `top25` text. |
| DS_ZIP actual answered/correct hard facts | **0/0** | **Recomputed** | Verbatim reply says Q1–Q5 are all `UNAVAILABLE`; deviation note explicitly records the scorer artifact. |
| DS_FILES rerun access proof | **9/9** | **Recomputed** | Nine inventory rows, every `opened_proven=TRUE`. |
| DS_FILES rerun hash matches | **9/9** | **Recomputed** | Nine inventory rows, every `sha_match=TRUE`. |
| DS_FILES rerun facts | **5/5 answered, 5/5 correct** | **Recomputed** | Q1–Q5 equal expected values. |
| GPT_FILES access proof | **9/9** | **Recomputed** | Nine inventory rows, every `opened_proven=TRUE`. |
| GPT_FILES hash matches | **9/9** | **Recomputed** | Nine inventory rows, every `sha_match=TRUE`. |
| GPT_FILES facts | **5/5 answered, 5/5 correct** | **Recomputed** | Q1–Q5 equal expected values. |
| Reviewer END lines | **3/3 present** | **Recomputed** | All arm rows have `end_line=TRUE`. |

The post-chat arm table and inventory/fact tables expose those counts. The packet separately records that the DS_ZIP `3/1` scorer count is a parser false positive and should semantically be `0/0`.

| Timing fact | Result | Status | Independent derivation / check |
| --- | --- | --- | --- |
| DS_ZIP raw elapsed | **39 s = 0.65 min** | **Recomputed** | 11:41:31→11:42:10; completion is an upper bound, not a directly observed finish. |
| DS_ZIP time-to-usable | **∞** | **Recomputed** | Frozen rule assigns infinity to an unusable first pass. |
| DS_FILES rerun raw/time-to-usable | **50 s = 0.8333… min ≈ 0.83 min** | **Recomputed** | 12:30:32→12:31:22 and arm is usable. |
| GPT_FILES raw/time-to-usable | **300 s = 5.00 min** | **Recomputed** | 11:44:55→11:49:55; completion is an upper bound. |
| Raw DS_FILES comparison to ZIP+2 | **0.83 ≤ 2.65** | **Recomputed** | 0.83 ≤ 0.65+2, although the frozen predicate already treats the ZIP baseline as unusable. |

No D-set is defined or tabulated for C49; consequently there is no C49 D-set count or set identity to recompute.

# 4. P1 assessment against the frozen predicate in the SPEC

The frozen predicate contains four conjunctive conditions: delivery-set validity, full access in both individual-file arms, full hash inventory in both individual-file arms, and no worse DeepSeek time-to-usable under the specified rule.

| Frozen P1 condition | Evidence-based status | Builder recomputation |
| --- | --- | --- |
| 0. Delivery sets valid | **MET** | Pre-chat `CHECK` exited 0; all 10 individual↔ZIP content hashes match; nine listed SHA values match the nine evidence files. |
| 1. DS_FILES and GPT_FILES each prove all 9 evidence files | **MET** | DS_FILES=9/9; GPT_FILES=9/9 FIRST+LAST proofs. |
| 2. Both FILES arms list all evidence hashes correctly | **MET** | DS_FILES=9/9 SHA matches after the PD-3 rerun; GPT_FILES=9/9. |
| 3. DS_FILES time-to-usable ≤ DS_ZIP + 2 min, with unusable ZIP treated as infinite | **MET** | DS_ZIP is unusable, therefore its time-to-usable is ∞; DS_FILES is usable at 0.83 min. Even the raw elapsed values satisfy 0.83 ≤ 0.65+2. |

The frozen post-chat tables independently show the same condition-level outcomes.

The condition-2 evidence for DeepSeek comes specifically from the **PD-3 rerun**, not the superseded initial DS_FILES attempt. The rerun had 11/11 attachment chips before send, all nine evidence hashes matched the frozen sums, and Q1–Q5 matched the known answers.

# 5. Fixture and reconciliation implications

C49 does not rerun the analytical R implementation, source extraction, classification logic, or analytical reconciliation. Its mandatory mechanical cases are delivery-level: the individual-file/SHA manifest relationship and byte identity of the ZIP contents. Those delivery checks pass 10/10 file↔ZIP hash comparisons. The allowed scope is frozen Stage 5 evidence only—no MySQL, internet, or new data.

The delivered Stage 5 evidence, as reported by the GPT_FILES reviewer, states **14/14 fixtures on both paths**, **0 reconciliation disagreements on 222,002 rows**, Source Gate pass, and Workflow Gate pass. Those numbers are **quoted**, not independently rerun by C49.

That statement must be kept distinct from N1/OF-1. The frozen pack separately contains **three** ESCALATE rows with **1.000-hour** R-A/R-B clock-field differences caused by repeated fall-back-hour parsing; their labels agree. C49 neither causes nor repairs those differences. Thus C49 establishes delivery identity, not a new claim that every numeric intermediate field in the underlying frozen R outputs is equal.

The κ=2 and κ=3 portfolio identities also reconcile arithmetically to the same decision total of 222,002, with the κ=2→3 decrease of 13,722 ESCALATE cases exactly offset by a 13,722 increase in STANDARD and no change in INCONCLUSIVE.

# 6. Semantic/regression risks and unchanged surfaces

The main experimental risk is **PD-3**. The first DS_FILES reviewer did receive and open the nine evidence files but did not receive the extensionless `SHA256SUMS`; the coordinator classified this as a delivery-harness defect and reran only that arm with the checksum file renamed `SHA256SUMS.txt`. That rerun changed the DS_FILES packet’s two checksum-name mentions and required a post-freeze `ARMS.tsv` patch. The original frozen `ARMS.tsv` hash was `edc8a...`, while the patched file is `bead84...`; both versions are preserved.

A second risk is timing provenance. The original DS_ZIP and GPT_FILES `TIMES.txt` records were written later from operator send logs plus saved-page mtimes; their completion times are upper bounds. The DS_FILES rerun timing was instead written at chat time. The timing asymmetry does not alter condition 3 here because DS_ZIP is unusable under the frozen rule, but it limits fine-grained performance interpretation.

A third risk is causal attribution of the ZIP observation. The operator reports that the ZIP upload was attempted and appeared accepted, while the saved DeepSeek page exposes only the packet and DeepSeek reports no readable ZIP. The evidence therefore establishes an end-to-end **ZIP delivery/readability failure in that DeepSeek arm**, but it does not isolate whether the failure occurred in upload persistence, UI-to-model transfer, attachment handling, or archive opening.

A fourth risk is the frozen scorer’s Q parser: DS_ZIP is reported mechanically as `facts_answered=3, facts_correct=1`, although the verbatim response answers none of Q1–Q5. The deviation record explains that `25` was accidentally extracted from `escalate_by_type_top25.csv`. This defect does not change DS_ZIP usability because access proof remains 0/9, but those two scorer counters should not be used as substantive accuracy evidence.

A fifth non-scored discrepancy is reviewer-reported line count for `AI1_INTERPRETATION.md`: DeepSeek reports **254** lines while ChatGPT reports **252**, even though both report the identical SHA-256 `73f448...` and both FIRST/LAST access proofs pass. `LINES` is not part of the frozen access proof, so this does not affect the mechanical access result; it does show that reviewer-generated line counts are not themselves authoritative.

The principal unchanged surfaces are: the frozen analytical evidence bytes; the baseline frameworks and constitution; the nine evidence-content hashes; the Stage 5 analytical outputs; the R paths; the disclosed N1/OF-1 condition; and the inventory/access criterion itself. The pre-chat delivery check verifies that packaging the evidence into the ZIP changes none of the ten delivered file bytes.

The experiment’s generalization is also explicitly narrow: one chat per model×format arm, no ChatGPT ZIP arm, and no Grok reviewer arm.

Finally, the packet’s omission of the actual `SEED_DIFFS_b6.txt` body means the original seed diff cannot be audited line-by-line from this Builder packet; only its hash and the resulting full seed/harness artifacts are available. That is a documentation/evidence-surface limitation, separate from the delivery results themselves.

# 7. Claim → evidence map

| Claim | Packet section and exact evidence row |
| --- | --- |
| **C1. C49 isolates individual-file versus ZIP delivery while holding the evidence and inventory requirement constant.** | SPEC → “Exact change being tested,” evidence/prompt bullets. |
| **C2. The pre-chat delivery set contains nine evidence files plus the checksum manifest, and the ZIP contains byte-identical copies.** | `C49_RESULTS.md` → Arms `CHECK` row and `DELIVERY_FILES.csv` all ten rows. |
| **C3. All ten individual↔ZIP content hashes are equal.** | `DELIVERY_FILES.csv` → nine evidence rows plus `SHA256SUMS` row. |
| **C4. DS_FILES rerun proves 9/9 access and 9/9 hash matches and answers all five facts correctly.** | Post-chat `Arms` → DS_FILES row; `INVENTORY_DS_FILES.csv` nine rows; `FACTS_DS_FILES.csv` Q1–Q5 rows. |
| **C5. GPT_FILES proves 9/9 access and 9/9 hash matches and answers all five facts correctly.** | Post-chat `Arms` → GPT_FILES row; `INVENTORY_GPT_FILES.csv`; `FACTS_GPT_FILES.csv`. |
| **C6. DS_ZIP proves 0/9 file access and is unusable.** | Post-chat `Arms` → DS_ZIP row; `INVENTORY_DS_ZIP.csv` nine rows. |
| **C7. The scorer’s DS_ZIP** `3/1` **fact count is a parse artifact; the verbatim reply actually answers 0/5 hard facts.** | Coordinator deviation note → DS_ZIP scorer note; post-chat `FACTS_DS_ZIP.csv`. |
| **C8. DS_FILES usable elapsed time is 50 seconds ≈ 0.83 min.** | `DS_FILES TIMES.txt` → sent 12:30:32, complete 12:31:22. |
| **C9. The DS_FILES evidence used for scoring is a PD-3 rerun following an initial missing-checksum delivery defect and a disclosed post-freeze ARMS patch.** | Deviation notes part 1 → PD-3; part 2 → rerun and ARMS patch; patched/pre-patch `ARMS.tsv` rows. |
| **C10. κ=2 portfolio counts sum to 222,002; κ=3 counts also sum to 222,002, with −13,722 ESCALATE offset by +13,722 STANDARD.** | Mechanically proven LAST rows of `portfolio_summary.csv` and `kappa_sensitivity.csv` in DS_FILES/GPT_FILES inventories. |
| **C11. C49 does not rerun or resolve N1/OF-1; the three one-hour clock differences pre-exist and labels agree.** | SPEC → “Known open finding N1 / OF-1.” |
| **C12. The Stage 5 evidence is reported as 14/14 fixtures on both paths and 0 reconciliation disagreements on 222,002 rows, but C49 itself does not recompute those analytical checks.** | GPT_FILES finding F1 plus C49 scope statement that no R path is rerun. |
| **C13.** `SEED_DIFFS_b6.txt` **is frozen by hash but its body is absent from this packet.** | SPEC freeze list → `SEED_DIFFS_b6.txt` hash; packet then supplies full seed/harness files rather than the diff body. |

END C49 BUILDER REPORT
