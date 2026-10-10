# C44 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting as **Builder only** for **C44 — Addendum 02, candidate #44, “Changed-files-only re-review.”** This is an independent first pass. I have not used or seen a Validator first-pass output. I used only the supplied frozen C44 packet and its embedded evidence; I did not introduce outside data, internet evidence, new Chicago 311 data, or a new R/MySQL execution.

The tested scope change is narrow: after an artifact has already received a full cross-review in the stage, a later re-review receives the changed artifact, its diff, and hashes of unchanged inputs rather than receiving all unchanged bodies again. The FULL arm reuses the frozen C48 AI3 second audit; the DELTA arm is a new DeepSeek re-review with the reduced packet. Both arms receive the same revision request and the same revised interpretation.

Ablation ID: **C44**.

Known OF-1/N1 is acknowledged but is outside the numerical effect of this control: C44 reads Stage 5 text/evidence only and reruns neither R path. The three repeated-fall-back-hour discrepancies therefore do not enter a C44 result.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

**Conceptual removal.** The control removes redundant retransmission of the bodies of the 13 inputs that were unchanged after the prior full review. It does **not** remove their identity: each unchanged input remains represented in the DELTA packet by filename, byte count, and SHA-256. The changed revised interpretation and the revision request remain present in full, and the original→revised unified diff is added as direct change context. The FULL packet remains the full-scope comparator.

**Runner-side seeded implementation.** `ARMS.tsv` binds FULL to the frozen C48 AI3 second-audit reply/packet and DELTA to the new C44 delta reply/packet. `RESCOPE` identifies the C44 delta scope check. `c44_static.R` parses both packet inventories, hashes `REVISED_SEED.md`, derives the unchanged-input set by excluding the revised artifact and revision request, requires every unchanged SHA-256 to appear in DELTA, requires the revised text to appear verbatim, checks that unchanged `# EVIDENCE:` and `# FIRST-ROUND REVIEW:` bodies are absent, records both packet hashes and sizes, and fails its static run if any required condition is false. `c44_score.R` freezes the arm definitions, verifies required END lines, checks the frozen FULL reply hash when its freeze exists, parses V-1…V-6 statuses, parses BLOCKING/MATERIAL/MINOR finding rows and `relates_to` keys, tests V-3 detection, and uses packet bytes as the cost proxy when both arm timings are not available.

No analytical R-A/R-B implementation, classification rule, fixture function, SQL logic, or Stage 3 measurement rule is changed by C44.

**Exact changed-artifact seed.** The original→revised diff makes these six revision changes: V-4 changes “0 disagreements” to “0 label disagreements” and adds the lineage qualification; V-3 inserts the WCA2 concentration sentence but deliberately uses **42.9%** rather than the required **49.2%**; V-1 changes the capacity return from “Plausible next step” to “Required next step”; V-2 replaces a pilot/monitor option with type-level monitoring only and explicitly forbids a row-level pilot; V-5 adds the required Framing return to the primary recommendation; and V-6 removes the chat-interface artifact.

The V-3 error is therefore the planted changed-file defect. The addendum's separate unchanged-file defect case was **not planted** in this experiment.

## 3. Hard mechanical facts table.

“Recomputed” means I independently calculated the value from numeric or set-valued evidence in the packet. “Quoted” means the packet supplies the value/status directly and the underlying primitive data necessary to recreate it are not included. The pre-chat static result reports 58,214 versus 18,691 packet bytes, 13/13 unchanged hashes listed, and verbatim revised text. The frozen post-chat arm table and finding tables supply the reply-level facts.

| Hard fact | Calculation / comparison | Result | Basis |
| --- | --- | --- | --- |
| FULL packet size | Packet table | 58,214 B | Quoted |
| DELTA packet size | Packet table | 18,691 B | Quoted |
| DELTA/FULL packet ratio | 18,691 / 58,214 | **0.32107397 = 32.1074%**; reported 0.3211 | Recomputed |
| Packet-byte reduction | 1 − 18,691 / 58,214 | **67.8926%** | Recomputed |
| Bytes removed | 58,214 − 18,691 | **39,523 B** | Recomputed |
| ≥30% byte-reduction threshold | 0.70 × 58,214 = 40,749.8 B; DELTA = 18,691 B | DELTA is **22,058.8 B below** the maximum permitted by the threshold | Recomputed |
| Unchanged input count | Count DELTA `UNCHANGED` inventory rows | **13** | Recomputed |
| Unchanged hashes represented | 13 matching hash rows / 13 unchanged inputs | **13/13 = 100%** | Recomputed |
| Complete input-hash equality across inventories | Compare the 13 unchanged inputs + revised interpretation + revision request | **15/15 named input hashes match** between FULL and DELTA inventories | Recomputed |
| Revised interpretation hash | Compare inventories/preflight | `c1ac310a…a720b63` in both arms | Recomputed string equality |
| FULL reply size | Post-chat Arms row | 3,053 B | Quoted |
| DELTA reply size | Post-chat Arms row | 2,834 B | Quoted |
| Reply-size difference | 3,053 − 2,834 | **219 B smaller**, a **7.1733%** reduction | Recomputed |
| Required END lines | FULL TRUE; DELTA TRUE | **2/2 present** | Quoted/recomputed count |
| Parsed findings | FULL 1; DELTA 1 | **1 each** | Quoted |
| BLOCKING/MATERIAL findings | FULL 1; DELTA 1 | **1 each** | Quoted |
| Finding-key sets | FULL `{V-3}`; DELTA `{V-3}` | Equal sets | Recomputed |
| D-set, FULL not in DELTA | `{V-3} \ {V-3}` | **∅** | Recomputed |
| D-set, DELTA not in FULL | `{V-3} \ {V-3}` | **∅** | Recomputed |
| Symmetric finding-key difference | `{V-3} △ {V-3}` | **∅** | Recomputed |
| V-3 arithmetic | 64,922 / 131,968 | **0.4919525946 = 49.1953% → 49.2%** | Recomputed |
| Seed error magnitude | 49.195259% − 42.9% | **6.2953 percentage points** | Recomputed |
| Decision-set partition | 131,968 + 6,377 + 83,657 | **222,002** | Recomputed |
| ESCALATE share | 131,968 / 222,002 | **59.4445095% → 59.4%** | Recomputed |
| INCONCLUSIVE share | 6,377 / 222,002 | **2.8724966% → 2.9%** | Recomputed |
| STANDARD share | 83,657 / 222,002 | **37.6829938% → 37.7%** | Recomputed |
| Portfolio share identity | 59.4445095 + 2.8724966 + 37.6829938 | **100.0000000%** | Recomputed |
| INCONCLUSIVE clause concentration | 6,377 / 6,377 | **100%** `thin_type_or_missing_peer` | Recomputed |
| WCA2 share of ESCALATE | 64,922 / 131,968 | **49.1953%** | Recomputed |
| SED share of ESCALATE | 17,254 / 131,968 | **13.0744%** | Recomputed |
| SKA share of ESCALATE | 7,316 / 131,968 | **5.5438%** | Recomputed |
| Top-3 ESCALATE concentration | (64,922 + 17,254 + 7,316) / 131,968 | **67.8134%** | Recomputed |
| Top-25 count | Sum of the 25 displayed type counts | **126,607** | Recomputed |
| Top-25 share | 126,607 / 131,968 | **95.9377%** | Recomputed |
| ESCALATE outside top 25 | 131,968 − 126,607 | **5,361** | Recomputed |
| κ=1 partition | 152,292 + 6,377 + 63,333 | **222,002** | Recomputed |
| κ=1.5 partition | 140,340 + 6,377 + 75,285 | **222,002** | Recomputed |
| κ=2 partition | 131,968 + 6,377 + 83,657 | **222,002** | Recomputed |
| κ=3 partition | 118,246 + 6,377 + 97,379 | **222,002** | Recomputed |
| κ 1→1.5 portfolio delta | ESCALATE 140,340−152,292; STANDARD 75,285−63,333 | **−11,952 ESCALATE; +11,952 STANDARD; INCONCLUSIVE 0** | Recomputed |
| κ 1.5→2 delta | 131,968−140,340; 83,657−75,285 | **−8,372; +8,372; INCONCLUSIVE 0** | Recomputed |
| κ 2→3 delta | 118,246−131,968; 97,379−83,657 | **−13,722; +13,722; INCONCLUSIVE 0** | Recomputed |
| κ monotonicity | 152,292 > 140,340 > 131,968 > 118,246 | ESCALATE strictly decreases as κ rises across supplied grid | Recomputed |
| 50-slot coverage | 50 / 131,968 | **0.0003788797 = 0.037888%** | Recomputed |
| 200-slot coverage | 200 / 131,968 | **0.0015155189 = 0.151552%** | Recomputed |
| 1,000-slot coverage | 1,000 / 131,968 | **0.0075775946 = 0.757759%** | Recomputed |
| Full-portfolio coverage | 131,968 / 131,968 | **1 = 100%** | Recomputed |
| DELTA timing interval | 11:41:20 − 11:40:34 | **46 s = 0.7667 min → 0.77 min** | Recomputed; completion is disclosed as an upper bound |
| Fixtures | Evidence package | **14/14 on both R paths** | Quoted |
| Final label reconciliation | Evidence package | **0 label disagreements / 222,002 rows** | Quoted |
| N1 clock discrepancy | Coordinator note | **3 rows × exactly 1.000 h**, labels agree | Quoted |
| `n_agree + n_disagree = n_inner` | No such fields occur in C44's supplied evidence tables | **Not applicable to this control** | Source absence noted |

The portfolio, type-concentration, κ-grid, integrity-clause and capacity calculations above reproduce the embedded Stage 5 evidence tables.

The hash comparison is stronger than merely counting the static check's 13 booleans: comparing the displayed FULL and DELTA inventories directly shows the same hashes for all 13 unchanged artifacts, the revised interpretation, and the revision request. The distinction is that the static code mechanically gates the 13 unchanged hashes and the verbatim revised body; the 15/15 statement above is my direct inventory-string comparison.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

**Condition 0 — static scope validity.** The static arm exits 0 with status PASS. Its output reports FULL 58,214 B, DELTA 18,691 B, 13 unchanged inputs, 13 hashes listed, revised text verbatim, and unchanged bodies absent. Those facts satisfy the predeclared mechanical scope checks.

**Condition 1 — no lost FULL BLOCKING/MATERIAL finding.** The FULL frozen reply contains exactly one such finding: F-1, BLOCKING, relating to V-3, identifying the 42.9% WCA2 share as wrong and requiring 49.2%. The DELTA reply independently contains exactly one finding: F1, MATERIAL, also relating to V-3, quoting the same defective sentence and prescribing the same 42.9%→49.2% correction. The severity labels differ, but the finding identity does not: both identify the same numerical defect in the same sentence and derive the same corrected percentage. Thus the FULL finding has a corresponding DELTA finding at finding level, not merely at key level.

**Condition 2 — changed-file seed detection.** DELTA marks V-3 **NO**, records `seed_V3_caught = TRUE`, and raises the V-3 finding as MATERIAL. Independently, 64,922 / 131,968 = 49.195259…%, so the revised 42.9% is demonstrably inconsistent with the frozen evidence. The FULL arm marks V-3 PARTIAL and identifies the same arithmetic error.

**Condition 3 — ≥30% cost reduction.** FULL wall-clock timing is unavailable, so the frozen predicate directs use of the declared packet-byte proxy. DELTA is 18,691 / 58,214 = 32.1074% of FULL, which is a **67.8926% reduction**, exceeding the 30% reduction threshold by 37.8926 percentage points. The DELTA 0.77-minute value cannot substitute for a two-arm timing comparison because there is no corresponding FULL timing and the DELTA completion timestamp is itself an upper bound.

**Scope qualification.** The changed-file defect was measured. The separately contemplated unchanged-file defect whose behavior depends on a changed artifact was not planted and therefore is not measured by this evidence. The packet explicitly identifies that as the main unresolved coverage risk of this experiment.

## 5. Fixture and reconciliation implications.

C44 does not alter or rerun the Stage 4 analytical implementation. Consequently, its evidence does not establish a new fixture result or a new R-A/R-B reconciliation result; it inherits the frozen Stage 5 evidence that reports **14/14 fixtures passed on both paths** and **0 final label disagreements across 222,002 rows**.

The ablation's relevance to reconciliation is textual and review-scoped rather than computational. V-4 changes the Stage 5 interpretation from the broader phrase “0 disagreements” to the precise statement **“0 label disagreements across 222,002 rows”**, explicitly identifying the reconciliation as label-only and locating SHA-256 lineage values in `LINEAGE_ATTESTATION.md`. Both FULL and DELTA mark V-4 as applied exactly.

The portfolio identities remain internally exact under every supplied κ row: ESCALATE + INCONCLUSIVE + STANDARD = 222,002. At κ=2, 131,968 + 6,377 + 83,657 = 222,002. Thus nothing in the changed-files-only review scope induces a numerical portfolio discrepancy.

OF-1/N1 does not change that conclusion about labels. The frozen R paths differ by exactly one hour on three repeated-hour clock values, but their labels agree on all three rows. C44 reruns neither R path and reads no new clock-derived data, so OF-1 is an unchanged, disclosed upstream finding rather than a C44-induced fixture or reconciliation effect.

The practical implication is therefore limited: this control tests whether reducing **re-review context** loses a material correction finding. It does not test whether reducing execution, fixture, reconciliation, or provenance checks would be safe.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk remains the **unmeasured unchanged-file interaction case**. A delta reviewer receives hashes rather than the bodies of previously reviewed unchanged artifacts. That is sufficient for identity/integrity, but it does not give the new re-review conversation the content needed to rediscover a newly relevant defect residing only in an unchanged artifact. The packet explicitly says that such a seed was not planted because the FULL comparator is a pre-existing frozen reply and a valid planted test would require another new full-scope review. Accordingly, the evidence directly tests the changed-artifact case, not every cross-artifact dependency case.

A second limitation is that finding severity is not invariant: FULL calls V-3 **BLOCKING**, DELTA calls it **MATERIAL**. The substantive finding, affected sentence, arithmetic, and required correction are the same. Under the frozen condition-1 wording, the relevant question is whether the FULL finding is also raised, not whether the second reviewer assigns the identical severity label. Still, severity stability is not demonstrated.

A third limitation concerns cost measurement. Only DELTA has a recorded timing interval, and its completion time is an upper bound derived from the saved-page mtime. Therefore the experiment's valid cost comparison is packet bytes, not latency. Any claim about review-speed improvement would go beyond the evidence.

The N1 note was intentionally excluded from the DELTA reviewer packet because the frozen FULL reviewer never received it; otherwise the arms would differ in more than review scope. That preserves the intended arm comparison, while also meaning C44 does not test whether delta re-review would reason correctly about that unrelated known clock discrepancy.

The disclosed execution-role deviation also remains: the re-review round is performed by the AI3-role DeepSeek chat, whereas the addendum sketch contemplated Builder/Validator review. The Builder and Validator instead judge the frozen finding sets. The DELTA reviewer was a separate conversation and was not told about the ablation.

The unchanged surfaces supported by the packet are substantial: the same revised artifact is reviewed in both arms; the same revision request is supplied; the 13 unchanged input hashes match; the 13 unchanged bodies are omitted only from DELTA; the changed revised artifact is sent verbatim; the baseline framework, constitution, frozen data pack, Stage 3/4 outputs and Stage 5 evidence hashes remain frozen; no MySQL is used; no R analysis path is rerun; and no new data enter the control. The static run additionally verifies that the expected unchanged-body section markers are absent while the revised body is present verbatim.

## 7. Claim → evidence map.

| Claim | Evidence location and table row |
| --- | --- |
| C44 tests changed-files-only re-review after an earlier full cross-review. | **SPEC → Control under test** and **Exact change being tested**, especially DELTA-arm description. |
| Both arms review the same changed revised interpretation containing the planted V-3 percentage error. | **SPEC → Exact change being tested**, first bullet; **DIFF of interpretation**, added WCA2 sentence. |
| Static scope validation reports 58,214 B FULL, 18,691 B DELTA, 13 unchanged inputs, 13 listed hashes, revised text verbatim. | **C44_RESULTS.md → Arms → STATIC row** and **UNCHANGED_HASH_LIST_CHECK.csv → all 13 rows**. |
| The DELTA packet is 32.1074% of FULL and removes 67.8926% of packet bytes. | Derived from **C44_RESULTS.md → Arms → STATIC row**, 18,691 / 58,214. |
| FULL and DELTA inventory hashes agree for every named input: 13 unchanged + revised interpretation + revision request. | **DELTA packet → INPUT INVENTORY**, all 15 rows, compared with **FULL packet → INPUT INVENTORY**, corresponding 15 rows. |
| FULL has one qualifying finding and it is the V-3 42.9%→49.2% defect. | **C44 POST-CHAT RESULTS → FINDINGS_FULL.csv → sole row**. |
| DELTA raises the same V-3 defect. | **C44 POST-CHAT RESULTS → FINDINGS_DELTA.csv → sole row**. |
| The finding-key D-sets are equal and the symmetric difference is empty. | **C44 POST-CHAT RESULTS → Arms →** `bm_keys`, FULL=`V-3`, DELTA=`V-3`; **Key-level aid** states every FULL key is present in DELTA. |
| The finding match is substantive, not merely a key-parser coincidence. | **FULL reply → Findings → F-1 row** and **DELTA reply → Findings → F1 row**: both quote the same WCA2 sentence and require the same correction. |
| The correct WCA2 value is 49.2%. | **deeper/escalate_by_type_top25.csv → WCA2 row**: 64,922 and 0.4919525945683802; independently 64,922/131,968 = 49.1953%. |
| The κ=2 portfolio exactly partitions 222,002 rows. | **deeper/portfolio_summary.csv → only row** and **independent_checks_critical_counts.csv → n_decision/n_ESCALATE/n_INCONCLUSIVE/n_STANDARD rows**; recomputation 131,968+6,377+83,657=222,002. |
| All supplied κ rows preserve the same decision population and 6,377 INCONCLUSIVE rows. | **deeper/kappa_sensitivity.csv → κ=1,1.5,2,3 rows**; each row sums to 222,002 and `n_INCONCLUSIVE=6377`. |
| Capacity examples represent only a Framing flag and no ranking mechanism. | **capacity_coverage_note.csv → illustrative_shift_50/200/1000/full_escalate_portfolio rows** and **STAGE5_DEEPER_FINDINGS → Capacity note**. |
| Stage 4 fixture/reconciliation facts are inherited rather than rerun by C44. | **STAGE5_EVIDENCE_PACKAGE → Validated Stage 4 facts** plus **SPEC → Known open finding N1 / Arms**. |
| OF-1/N1 affects three clock values by exactly one hour but not their labels and does not enter a C44 number. | **SPEC → Known open finding N1 / OF-1**. |
| The unchanged-file interaction seed is not measured. | **SPEC → Exact change being tested → Deviations (1)** and **C44 POST-CHAT RESULTS → “Unchanged-file seed: NOT PLANTED”**. |
| Cost comparison must use packet bytes because FULL timing is unavailable. | **C44 POST-CHAT RESULTS → Predicate conditions → condition 3** and **Arms → FULL minutes NA**; DELTA time is separately disclosed as an upper bound. |

END C44 BUILDER REPORT
