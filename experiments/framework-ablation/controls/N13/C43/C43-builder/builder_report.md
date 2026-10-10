# C43 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for **C43 — Addendum 01b, candidate #43, “Freeze scope.”** I am making an independent first pass, am blind to the Validator’s first-pass output, and am not assuming an Adjudicator role. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. C43 targets governance of the coordinator’s freeze/hash trail across all stages, using the coordinator’s N15+N13 box-side trail cut at 2026-10-03 10:52:00 CT.

The control does not rerun an analytical R path, connect to MySQL, or read clock values. The disclosed OF-1 repeated-hour discrepancy in the frozen R-A/R-B pack is therefore outside C43’s measured surface and cannot change a C43 count.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C43 tests narrowing the freeze/hash obligation. The standing rule freezes, hashes, and logs every intermediate capture, failed copy, and partial reply. The variant would continue hashing gate-feeding artifacts but would cease requiring hashes for artifacts mechanically classified as intermediate. It does **not** test deleting final evidence or changing analytical calculations; it tests removing five class-I categories from the mandatory hash scope while retaining class G.

The five excluded classes are exactly: I1 scratch/preflight/interim material; I2 superseded or failed versions; I3 transfer bundles/listings; I4 saved-page asset folders; and I5 assembly inputs such as `.HEAD.txt` and `.TEMPLATE.txt`. G0 retains everything else, including final captures, deployed code and seeds, frozen-pack files, arm outputs, specs, packets, evidence, results, and terminal-state artifacts. The seeded `CLASS_RULES.tsv` implements those rules first-match-wins.

There is one evidence-pack qualification. `runner_b6/SEED_DIFFS_b6.txt` is frozen and identified by SHA-256 `729ed8cad382ae82805499d493bf7eb8fa38687665286649bb3746330f0b1e2d`, but its verbatim body is not reproduced in this packet. Therefore I cannot truthfully claim to quote the textual contents of that diff file itself. The packet does, however, reproduce the C43 seed/harness files from which the concrete C43 implementation can be independently reconstructed.

The reconstructable seeded changes are as follows. `ARMS.tsv` creates one `AUDIT` arm over `seeds\C43\TRAIL_INDEX.tar`; the `AUDIT` marker identifies it as the runner-v6 freeze-scope audit. `CLASS_RULES.tsv` adds the six first-match classifications I1–I5 and G0. `RECORD_RULES.tsv` defines three record populations: R1 coordinator narratives, R2 N15 re-adjudication material, and R3 disclosures.

The new `c43_audit.R` parses textual, JSON, JSONL, and arm-manifest hash records; resolves their paths against the frozen inventory; deduplicates hashed artifacts by logical-path/SHA pair; classifies each artifact; excludes records that are themselves class I; and scans eligible records for three forms of evidence: SHA citations, path/eligible unique-filename citations, and intermediate-directory citations. A SHA citation is downgraded to `hash_but_G_copy_exists` when a class-G artifact retains matching bytes, so it does not count as an intermediate dependency.

The audit also seeds known-answer tests before touching the real trail: one planted intermediate hash citation must be detected, a hash whose bytes also exist in G must not be counted, and six known paths must receive the declared classes. Failure aborts before the real audit.

For the real run, the tar is unpacked under the output directory, every copied list and scanned record is re-hashed against `INVENTORY.tsv`, and an inventory mismatch causes the audit to stop. The code then writes `HASHED_ARTIFACTS.csv`, `CITATIONS.csv`, `NEEDED.csv`, `SUMMARY.txt`, `AUDIT_RESULT.txt`, `SELFTEST.txt`, and `UNHASHED_TRAIL_FILES.txt`; the three operative counts are distinct needed artifacts by hash, by path/file name, and by directory.

No C43 analytical seed alters R-A, R-B, the Chicago 311 source data, portfolio outputs, or κ-grid outputs. Those files remain frozen inputs checked by the batch preflight rather than mutated C43 surfaces.

## 3. Hard mechanical facts table.

| ID | Hard fact | Independent calculation / observation | Status |
| --- | --- | --- | --- |
| HF-01 | One reporting arm exists. | `C43_arms.csv` contains only `AUDIT`. | **Recomputed from table row count.** |
| HF-02 | AUDIT exited successfully in 35.7 s. | Raw exit row gives exit `0`, elapsed `35.7`. | **Quoted.** |
| HF-03 | Self-test has 3/3 successful components. | `seed_cite_detected=TRUE`, `clean_not_flagged_with_G_copy=TRUE`, `class_rules=TRUE`; conjunction gives PASS. | **Recomputed; matches quoted PASS.** |
| HF-04 | Distinct hashed artifacts = 14,095. | `8,130 G + 5,965 I = 14,095`. | **Recomputed.** |
| HF-05 | Class-I rule counts reconcile to 5,965. | `1,650 + 62 + 3 + 4,210 + 40 = 5,965`. | **Recomputed.** |
| HF-06 | Detailed folder counts independently reconcile to each class-I summary. | Folder table sums to I1=`1,650`, I2=`62`, I3=`3`, I4=`4,210`, I5=`40`. | **Recomputed from 102 detailed folder rows.** |
| HF-07 | Known class-I bytes = 500,660,758. | `7,353,129 + 1,675,268 + 2,504,801 + 487,189,756 + 1,937,804 = 500,660,758`. | **Recomputed.** |
| HF-08 | Known bytes across G+I = 567,330,051; class I is 88.25% of known bytes. | `66,669,293 + 500,660,758 = 567,330,051`; `500,660,758 / 567,330,051 = 88.25%`. | **Recomputed.** |
| HF-09 | Class I is 42.32% of distinct hashed artifacts. | `5,965 / 14,095 = 42.32%`. | **Recomputed.** |
| HF-10 | I4 saved-page assets dominate known class-I byte cost. | `487,189,756 / 500,660,758 = 97.31%`; the remaining I classes account for 13,471,002 known bytes. | **Recomputed.** |
| HF-11 | Total unresolved hashed artifacts = 6,868. | `5,738 G + 1,128 I1 + 2 I2 + 0 + 0 + 0 = 6,868`. | **Recomputed.** |
| HF-12 | Class-I unresolved artifacts = 1,130; resolved distinct artifacts overall = 7,227. | `1,128 + 2 = 1,130`; `14,095 − 6,868 = 7,227`. | **Recomputed.** |
| HF-13 | Hash-list records exceed distinct path/SHA artifacts by 2,166. | `16,261 − 14,095 = 2,166` repeated list occurrences after path/SHA deduplication. | **Recomputed.** |
| HF-14 | Class-I hash-list records exceed distinct class-I artifacts by 415. | `6,380 − 5,965 = 415`. Correspondingly G has `16,261−6,380=9,881` hash records, or `9,881−8,130=1,751` repeats. | **Recomputed.** |
| HF-15 | The frozen trail contains 24 candidate record files, 21 scanned and 3 excluded as class I. | `21 + 3 = 24`, exactly matching the trail-index declaration of 24 record files. | **Recomputed cross-table identity.** |
| HF-16 | Total citation rows reconcile exactly. | `11,198 hash_but_G_copy_exists + 16 counted rows = 11,214 total`. | **Recomputed.** |
| HF-17 | Counted dependency identities reconcile to 15 distinct needed artifact/kind entries. | `10 hash + 2 path/file-name + 3 directory = 15`. `NEEDED.csv` has 15 data rows. | **Recomputed.** |
| HF-18 | Those 15 distinct entries generate 16 counted citing lines. | `_interim_b4` has 2 citing lines; each of the remaining 14 entries has 1, so `2 + 14 = 16`. | **Recomputed.** |
| HF-19 | The 10 hash-needed artifact entries contain 5 unique SHA-256 values. | C26, C31, C39, C30 and C29 each contribute a HEAD / HEAD.v1 pair sharing the same historical SHA. | **Recomputed from hashes.** |
| HF-20 | Exactly 2 path/file-name dependencies are present, and both are path dependencies. | `pc_run_b2.tgz` and `pc_run_b3.tgz`; there is no `file_name` row among counted entries. | **Recomputed.** |
| HF-21 | Exactly 3 distinct intermediate directories are cited. | `_interim_b4`, `_superseded_v0`, `_smoke_b3`. `_interim_b4` is cited twice but counts once as a distinct needed directory. | **Recomputed.** |
| HF-22 | Four intermediate directory names exist in the audit’s discovered set, but only three are cited. | Discovered set is `_interim_b4`, `_superseded_v0`, `_smoke_b3`, `evidence_first_0500`; the latter is absent from `NEEDED.csv`. | **Recomputed.** |
| HF-23 | 598 trail files are absent from every parsed hash list. | Breakdown `3 .jsonl + 449 .sha256 + 146 other = 598`. | **Recomputed.** |
| HF-24 | Trail index contains 7,804 files and 598 hash-list files. | Direct trail-index/SUMMARY counts agree. | **Quoted and cross-checked.** |
| HF-25 | No parsed hash lines failed. | `unparsed_hash_lines=0`. | **Quoted.** |
| HF-26 | Trail-index SHA is consistent across the frozen reference, runner-side file listing, arm input manifest, and actual arm result prefix. | Full hash is `0fcc3b64ac8d464abec4cdaa33315d7c3009111a9cf5c54a1967897e1fb4c9c9`; arm result reports its matching `0fcc3b64ac8d464a` prefix. | **Recomputed hash equality/prefix equality.** |
| HF-27 | C43 audit-code and rule-file hashes reconcile across frozen/preflight/arm evidence. | `c43_audit.R=4c7923…406`, `CLASS_RULES.tsv=f19694…794`, `RECORD_RULES.tsv=4a56ec…220` repeat consistently in preflight, runner-side listing, and arm manifest. | **Recomputed equality.** |

The task template mentions identities such as `n_agree + n_disagree = n_inner`, portfolio deltas, D-sets, and cross-arm hash comparisons. Those data structures are not instantiated by C43: this is a single-arm hash-trail audit, not a two-analytical-arm classification ablation. I therefore do not manufacture portfolio or D-set quantities that the C43 evidence does not contain. The applicable identities are the audit-count, class-count, byte-count, citation-count, record-count, and repeated-hash equalities above.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

P1 is a three-part conjunction. Condition 1 requires **zero** class-I artifacts needed by hash. The audit reports **10**, represented by ten hash-kind entries in `NEEDED.csv`; therefore condition 1 is false.

Condition 2 requires both **zero** class-I dependencies by path/eligible file name and **zero** intermediate-directory citations. The audit reports **2** path/file-name dependencies and **3** distinct directory dependencies. The two path entries are `N15/pc_run_b2.tgz` and `N15/pc_run_b3.tgz`; the three directory entries are `_interim_b4`, `_superseded_v0`, and `_smoke_b3`. Therefore condition 2 is false.

Condition 3 requires the auditor self-test to pass. All three seeded self-test components are true and `selftest=PASS`; therefore condition 3 is true.

Because P1 requires all three conditions simultaneously, and conditions 1 and 2 are false while condition 3 is true, **P1 is not satisfied by the frozen C43 evidence**. This is the predicate assessment only; no terminal disposition is supplied.

The cost quantity attached to the predicate is also mechanically available: narrowing the hash scope would remove **5,965 distinct class-I path/SHA artifacts from the mandatory scope**, representing **500,660,758 known bytes**. Because 1,130 class-I artifacts are unresolved in the box inventory, the byte figure is explicitly a known-byte quantity rather than proof that no additional bytes exist outside the box copy.

## 5. Fixture and reconciliation implications.

C43’s relevant locked fixture is its internal known-answer self-test, not the frozen R-A/R-B analytical fixture suite. It checks three specific semantic properties before the real audit: a planted class-I citation by hash prefix is detected; a cited class-I hash is not counted when identical bytes remain in class G; and six representative paths receive their expected I/G classifications. All three checks passed.

The real audit then performs an integrity reconciliation of its frozen evidence copies. Every hash-list file and every selected record copied into `TRAIL_INDEX.tar` is re-hashed and matched to `INVENTORY.tsv` before use. The code stops on any absent inventory hash or digest mismatch. The observed arm exited `0`, with no such mismatch reported.

There is also agreement across the mechanically redundant output surfaces: `C43_RESULTS.md`, `C43_arms.csv`, `AUDIT_RESULT.txt`, and `SUMMARY.txt` all report self-test PASS and needed counts of **10 by hash, 2 by path/file name, and 3 by directory**.

The usual R-A/R-B exact reconciliation is not rerun by this control. C43 reads no frozen analytical pack file during the arm; the common batch preflight merely re-hashes the frozen source, R code, classification outputs, fixture outputs, portfolio counts, and κ-grid output before allowing execution. Those preflight checks passed.

Consequently, OF-1 does not become a C43 fixture failure or a C43 reconciliation delta. The three known one-hour R-A/R-B differences exist in the frozen analytical pack, but C43 does not read those clock fields or derive any result from them.

## 6. Semantic/regression risks and unchanged surfaces.

The largest semantic limitation is declared in the frozen specification itself: written citation is an **upper-bound proxy** for genuine necessity. A coordinator record may mention an intermediate artifact even if the audit did not depend on it. Conversely, silent dependency is invisible if an audit used an intermediate artifact without recording its path, file name, hash, or containing directory. The evidence universe is further restricted to the box-side trail; PC-only files may appear only as logical hash entries, and chat replies are not scanned as audit/reconstruction records.

That matters when interpreting the observed 15 distinct needed entries. The evidence establishes that those intermediate artifacts/directories were **cited under the predeclared mechanical rule**. It does not independently prove that every citation was causally indispensable to the historical reconstruction. Likewise, an absence of a citation would not prove an intermediate was never silently consulted.

A second coverage risk is the large unresolved population. Of 14,095 distinct hashed path/SHA artifacts, 6,868 are unresolved against the box inventory, including 1,130 class-I artifacts. They remain logically represented and may still be matched by their listed identities, but their bytes are not available for the known-byte cost calculation. Therefore 500,660,758 bytes is the exact sum of **known** class-I bytes, not a complete byte-size upper bound.

A third coverage observation is that 598 files in the trail inventory appear in no parsed hash list. Their reported composition—3 JSONL, 449 SHA-list files, and 146 other files—reconciles to 598. C43’s dependency predicate is specifically defined over **class-I hashed artifacts**, so those files are not silently added to the tested population.

A fourth semantic point is that the ten hash-needed artifacts reduce to five unique historical byte hashes. Each historical hash appears both for a `.HEAD.txt` path and for its preserved `.HEAD.v1.txt` counterpart. The count of ten is therefore an artifact-identity count under the declared path/SHA rule, not ten distinct byte contents. This does not change the zero-versus-nonzero predicate, but it matters when interpreting magnitude.

The cost is also highly concentrated: saved-page assets account for **487,189,756 bytes, or 97.31% of the 500,660,758 known class-I bytes**, yet none of the counted dependency rows is an I4 page asset. The actual counted dependencies arise from scratch directories, a superseded directory/version set, two transfer bundles, and assembly/superseded HEAD artifacts. Thus storage/hash-volume concentration and reconstruction dependency concentration are different facts in this trail.

The principal unchanged surfaces are strong and explicit. The two baseline framework hashes remain the frozen pre-hardening versions. The common preflight re-verifies the source extract, R-A runner, R-B runner/modules, classification files, fixture results, portfolio counts, and κ-grid counts. C43 itself is an R-only read-side audit with no MySQL or git activity and writes only its own audit outputs.

Finally, there is an evidence-packaging limitation for this Builder task: the packet freezes the SHA of `SEED_DIFFS_b6.txt` but does not reproduce that file’s actual diff text. The new C43 seed/harness files are reproduced sufficiently to inspect the C43 audit implementation itself, but an independent line-by-line verification that those files are exactly what `SEED_DIFFS_b6.txt` described cannot be performed from this packet alone.

## 7. Claim → evidence map.

| Claim | Evidence section and exact row(s) |
| --- | --- |
| **C1. C43 tests removing class I from the mandatory hash scope while retaining class G.** | SPEC → “Control under test” and “Exact change being tested”; `CLASS_RULES.tsv` rows I1_scratch through G0_gate. |
| **C2. The reporting run consisted of one successful AUDIT arm.** | C43_RESULTS → Arms row `AUDIT`; raw `C43_arms.csv`; `RUN_AUDIT.exit`. |
| **C3. The distinct-artifact inventory reconciles as 8,130 G + 5,965 I = 14,095.** | SUMMARY rows `distinct_hashed_artifacts`, `class_G`, `class_I`; Hashed artifacts by class/rule rows. |
| **C4. The five I-rule counts reconcile exactly to 5,965.** | Hashed artifacts by class/rule rows I1–I5 and detailed “Class-I artifacts by rule and top folder” rows. |
| **C5. Known class-I byte cost is 500,660,758 bytes.** | `HASHED_ARTIFACTS.csv` summarized rows I1–I5; arithmetic shown in HF-07. |
| **C6. There are ten needed hash-artifact entries, representing five unique hashes.** | `NEEDED.csv` hash rows for C26, C31, C39, C30, C29 HEAD and HEAD.v1 pairs. |
| **C7. There are two needed path entries and three needed directory identities.** | `NEEDED.csv` rows `_interim_b4`, `_superseded_v0`, `pc_run_b2.tgz`, `pc_run_b3.tgz`, `_smoke_b3`; SUMMARY needed-count rows. |
| **C8. Citation accounting reconciles to 11,214 total rows.** | SUMMARY rows `citations_total=11214`, `citations_hash_with_G_copy=11198`; CITATIONS section states 16 counted rows. `11,198 + 16 = 11,214`. |
| **C9. The self-test passes all three declared known-answer cases.** | `SELFTEST.txt` row; seeded self-test implementation `st_cite`, `st_clean`, `st_class`. |
| **C10. P1 condition 1 is false, condition 2 is false, and condition 3 is true.** | SPEC → P1 conditions; C43_RESULTS → Predicate conditions; NEEDED and SELFTEST raw evidence. |
| **C11. Twenty-one records were scanned and three excluded, reconciling to the 24 record files frozen into the trail index.** | SUMMARY rows `records_scanned=21`, `records_excluded_class_I=3`; seed description says trail index contains 24 record files. |
| **C12. The audit re-verifies copied inputs against INVENTORY before scanning them.** | `c43_audit.R` real-run code: inventory read, lists/records selected, SHA comparison and stop-on-mismatch. |
| **C13. The trail-index hash is consistent across frozen references and the AUDIT arm.** | Runner-side files and arm input manifest both give full SHA `0fcc3b64…c9c9`; results give matching prefix `0fcc3b64ac8d464a`. |
| **C14. C43 does not exercise or alter the frozen analytical R paths.** | SPEC says C43 reruns no R path and reads no clock value; batch preflight separately verifies frozen R/data/output hashes. |
| **C15. OF-1 is known but cannot change C43’s mechanical numbers.** | Coordinator Note N1 / SPEC “Known open finding N1 / OF-1.” |
| **C16. The packet does not provide a verbatim** `SEED_DIFFS_b6.txt` **body, although its hash is frozen.** | SPEC freeze lists `runner_b6/SEED_DIFFS_b6.txt` SHA `729ed8…e2d`; packet subsequently supplies the C43 seed/harness files directly. |

END C43 BUILDER REPORT
