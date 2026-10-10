# C51 Builder Report

## 1. Role attestation and ablation ID

I attest that I am acting **only as the Builder** for **C51**, Addendum 02 candidate #51, “Reduced-scale real-data smoke run before the full pipeline.” I am making an independent first pass, am blind to the Validator’s first-pass output, and am not performing adjudication or issuing a terminal-state recommendation. The frozen assignment identifies Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.

The control tests a Stage-4 execution addition: after fixtures, run the frozen real-data pipeline first on deterministic 1/16 and 1/4 subsets before the full run. Smoke outputs are segregated under `smoke/`, marked `NON_REPORTING.txt`, are never reconciled, and never enter a receipt.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS

Conceptually, C51 removes the **immediate fixtures → full-data-run jump** as the operational execution path. It inserts deterministic reduced-scale real-data execution before the full run. It does **not** remove the fixture harness, the eventual clean full run, frozen-output reconciliation, or reporting safeguards. Under the declared cost model, a seeded full run is avoided operationally when the smoke sequence detects the defect first; the experimental runner nevertheless executed all three scales so both regimes could be costed from the same observation set.

The deterministic subset is header plus data lines `1, 1+k, 1+2k, ...` from `src_open_candidates.csv`, preserving frozen file/SR_NUMBER order. `src_peer_stats.csv` and `src_extract_lineage.csv` are copied unchanged. The exact selector implemented in `make_subset.R` is:

`keep <- c(1L, 1L + which((seq_len(length(x) - 1L) - 1L) %% k == 0L))`

with `k=16` and `k=4`.

The four R-B seeds are exactly:

**SM_QUADLOOP.** Immediately after `open_df <- rb_normalize_open(open_raw)`, the seed adds an intentionally quadratic per-row full-frame subset:

`same_type_n <- vapply(seq_len(nrow(open_df)), function(i) nrow(open_df[open_df$type_key %in% open_df$type_key[i], , drop = FALSE]), integer(1))`

followed by a message reporting its length. No scoring rule is changed.

**SM_MIDCRASH.** In the classification output column vector, the existing `"dormant_h"` request is replaced by `".dormant_h"`. Because that column does not exist, the seeded path fails when constructing `class_out`, after judging.

**SM_OUTCRASH.** The final kappa-grid output call changes its object from `grid_out` to undefined `grid_out_final`, while leaving the constructed `grid_out` and returned value otherwise unchanged. The failure is therefore at the final kappa-grid write.

**SM_RARECRASH.** Before normalization, the seed adds:

`if (any(open_raw$SR_SHORT_CODE %in% "ODM")) stop("unhandled SR_SHORT_CODE ODM in normalization", call. = FALSE)`

The frozen full extract contains six ODM rows, but neither deterministic smoke subset contains them. This arm is explicitly outside the three-defect detection target and probes subset bias.

`ARMS.tsv` maps those four seeded `run_RB.R` files into their respective arms; `SMOKE` is the runner marker file.

## 3. Hard mechanical facts table

All arithmetic below is independently recomputed from the raw/result evidence where possible. “Quoted” means the underlying raw datum is taken directly from the frozen packet; “recomputed” means the stated result follows arithmetically or by direct hash-string comparison from those raw data. The arm timing inputs are the six rows of `C51_arms.csv`.

| Mechanical fact | Independent result | Basis |
| --- | --- | --- |
| Full source rows | 245,193 | Quoted from preflight/runtime evidence. |
| k16 subset rows | **15,325** | Recomputed: `floor((245193-1)/16)+1 = 15,325`; matches observed subset output. |
| k4 subset rows | **61,299** | Recomputed: `floor((245193-1)/4)+1 = 61,299`; matches observed subset output. |
| Clean B R-A smoke ratio | **4.4 / 2.4 = 1.8333 → 1.83** | Recomputed. Below threshold 6. |
| Clean B R-B smoke ratio | **7.8 / 3.1 = 2.5161 → 2.52** | Recomputed. Below threshold 6. |
| SM_QUADLOOP smoke ratio | **357.7 / 19.4 = 18.4381 → 18.44** | Recomputed. Above threshold 6, therefore detection occurs at k4. |
| SM_RARECRASH smoke ratio | **7.9 / 2.9 = 2.7241 → 2.72** | Recomputed. Below threshold 6; both smoke exits are zero. |
| SM_MIDCRASH detection | **k16** | Quoted exit=1 at k16; detection follows directly from frozen rule. |
| SM_OUTCRASH detection | **k16** | Quoted exit=1 at k16; detection follows directly from frozen rule. |
| Clean B R-A baseline | **11.0 s** | Recomputed from rule: clean baseline = full only. |
| Clean B R-A variant | **2.4+4.4+11.0 = 17.8 s** | Recomputed. |
| Clean B R-B baseline | **25.0 s** | Recomputed from rule. |
| Clean B R-B variant | **3.1+7.8+25.0 = 35.9 s** | Recomputed. |
| SM_QUADLOOP baseline | **1800.4+25.0 = 1825.4 s** | Recomputed; seeded full time is capped observation plus clean R-B rerun. |
| SM_QUADLOOP variant | **19.4+357.7+3.1+7.8+25.0 = 413.0 s** | Recomputed; detection is at k4, so seeded full is excluded from variant cost. |
| SM_MIDCRASH baseline | **18.5+25.0 = 43.5 s** | Recomputed. |
| SM_MIDCRASH variant | **2.4+3.1+7.8+25.0 = 38.3 s** | Recomputed; k16 detects it. |
| SM_OUTCRASH baseline | **25.6+25.0 = 50.6 s** | Recomputed. |
| SM_OUTCRASH variant | **3.4+3.1+7.8+25.0 = 39.3 s** | Recomputed; k16 detects it. |
| SM_RARECRASH baseline | **5.8+25.0 = 30.8 s** | Recomputed. |
| SM_RARECRASH variant | **2.9+7.9+5.8+3.1+7.8+25.0 = 52.5 s** | Recomputed; no smoke detection, so seeded full remains in variant cost. |
| Total baseline | **1,986.3 s** | Recomputed: `11+25+1825.4+43.5+50.6+30.8`. |
| Total variant | **596.8 s** | Recomputed: `17.8+35.9+413.0+38.3+39.3+52.5`. |
| Aggregate time difference | **1,389.5 s lower** | Recomputed: `1986.3−596.8 = 1389.5 s` = 23 min 9.5 s. |
| Aggregate proportional reduction | **69.954%** | Recomputed: `1389.5/1986.3 × 100`. |
| Baseline/variant ratio | **3.3283×** | Recomputed: `1986.3/596.8`. |
| Clean-run smoke overhead, R-A | **+6.8 s** | Recomputed: `17.8−11.0`. |
| Clean-run smoke overhead, R-B | **+10.9 s** | Recomputed: `35.9−25.0`. |
| Rare-crash smoke overhead | **+21.7 s** | Recomputed: `52.5−30.8`. |
| R-B full decision portfolio identity | **131,968+6,377+83,657 = 222,002** | Recomputed; exact identity holds. |
| Full rows outside decision portfolio | **245,193−222,002 = 23,191** | Recomputed. |
| R-B k16 portfolio identity | **8,185+394+5,312 = 13,891** | Recomputed; exact identity holds. |
| k16 rows outside decision portfolio | **15,325−13,891 = 1,434** | Recomputed. |
| R-B k4 portfolio identity | **32,905+1,610+20,967 = 55,482** | Recomputed; exact identity holds. |
| k4 rows outside decision portfolio | **61,299−55,482 = 5,817** | Recomputed. |
| Clean full fixture count | **14/14 R-A; 14/14 R-B** | Quoted/verified from raw fixture files and runtime output. |
| Full arm run-exit records | **6/6 units present** | Recomputed from the six arm rows; both clean full runs exit 0, three intentional seeded arms exit nonzero, QUADLOOP times out. |
| Total execution records represented by six units × three scales | **18** | Recomputed; run log contains k16, k4, and full record for every unit. |
| B full frozen-key equality | **7/7 TRUE** | Recomputed by comparing each listed arm-B SHA-256 string with its frozen counterpart. |
| SM_OUTCRASH full classification delta vs clean B | **0 bytes semantically at file level: hashes identical** | Recomputed hash equality: both classifications use `a0e42b…`; portfolio files both use `eb677b…`; fixtures both use `0d7224…`. |
| k16 complete R-B classification hashes across B / QUADLOOP / OUTCRASH / RARECRASH | **identical** | Recomputed: each available classification is `52746d…`; MIDCRASH has no classification output because it crashes before write. |
| k4 complete R-B classification hashes across B / QUADLOOP / OUTCRASH / RARECRASH | **identical** | Recomputed: each available classification is `52b322…`; MIDCRASH again has no classification output. |
| k16 portfolio deltas across complete B / QUADLOOP / OUTCRASH / RARECRASH outputs | **0** | Recomputed from identical `0f9521…` portfolio hashes. |
| k4 portfolio deltas across complete B / QUADLOOP / OUTCRASH / RARECRASH outputs | **0** | Recomputed from identical `13cfb1…` portfolio hashes. |
| Seeded/full R-B fixture hash equality | **all four seeded full arms equal clean B R-B fixture hash** | Recomputed: all use `0d72245c…`, including arms that fail later. |
| Full-arm manifest references to a `smoke/` root | **0** | Recomputed from the reporting-arm manifest entries; smoke entries are separately prefixed `smoke/...`. |

The underlying timing table reports exactly the independently reproduced values above. The seven clean-B hashes are individually identical to their frozen references. Runtime evidence supplies the full and subset portfolio counts used in the identities above.

The packet does **not** contain `n_inner`, `n_agree`, `n_disagree`, or a D-set table for C51. I therefore do not invent values for those template examples. This control deliberately does not perform an R-A/R-B pair reconciliation; its clean-arm exact-reconciliation mechanism is byte equality of the seven path-specific outputs to their frozen references.

The aggregate saving is necessarily conservative for SM_QUADLOOP because its observed full time is the 1,800-second capped value, not an uncapped completion time.

## 4. P1 assessment against the frozen predicate in the SPEC

**P1 condition 1 — targeted seeded defects detected before their full runs: established.** SM_MIDCRASH exits 1 at k16 after 2.4 s. SM_OUTCRASH exits 1 at k16 after 3.4 s. SM_QUADLOOP exits 0 at both smoke scales, but its independently recomputed k4/k16 time ratio is 18.44, exceeding the frozen threshold of 6, so it is detected at k4.

The corresponding raw errors also match the seeds rather than unrelated failures: MIDCRASH reports “undefined columns selected”; OUTCRASH reports `grid_out_final` not found; QUADLOOP reaches real processing at both smoke scales and exhibits the intended nonlinear runtime growth.

**P1 condition 2 — no false smoke flag on clean B: established.** Clean R-A exits zero at k16 and k4 with a 1.83 ratio. Clean R-B exits zero at both scales with a 2.52 ratio. Both ratios are below 6, neither run hits its 600-second cap, and both clean full runs exit zero.

**P1 condition 3 — summed variant time is lower: established.** Independent addition gives 1,986.3 s baseline versus 596.8 s variant, a difference of 1,389.5 s, approximately 69.95% of baseline. This total includes SM_RARECRASH exactly as prespecified.

**P1 condition 4 — clean full outputs remain frozen-equal and smoke outputs remain non-reporting: established by the supplied evidence.** All seven B full-run key-output hashes exactly match their frozen references. The full reporting-arm manifest is rooted under `arms/B`; smoke runs have separate `smoke/...` roots and `NON_REPORTING.txt`.

Thus, on the frozen four-part predicate itself, **all four P1 conditions are mechanically established in the supplied evidence**. This statement is limited to the P1 predicate and is not an adjudicative terminal disposition.

## 5. Fixture and reconciliation implications

The fixture safeguard remains active before real-data execution. Clean full R-A reports `pass=14/14`; the raw R-A fixture table shows all F01–F14 passing, including F14’s two independent labels. Clean full R-B likewise has all F01–F14 passing.

The seeded failures do not corrupt the fixture layer. Every seeded full R-B arm’s fixture output has the same SHA-256 as clean B’s R-B fixture file, `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`. MIDCRASH and OUTCRASH therefore fail after successful fixtures, QUADLOOP times out later, and RARECRASH fails after source loading.

The same pattern holds in smoke roots. R-A k16 and k4 fixture hashes remain equal to the frozen R-A fixture hash, while clean R-B k16 and k4 fixture hashes remain equal to the frozen R-B fixture hash. The subset changes real-data classification/portfolio outputs, as expected, but not the locked synthetic fixture pack.

For C51, “exact reconciliation” is **not** a fresh R-A-versus-R-B row comparison. Clean B is reconciled path-by-path against the seven frozen output artifacts. Those seven comparisons are all byte-identical. This design also prevents the known OF-1 clock discrepancy from becoming a C51 mismatch: OF-1 is the pre-existing 1.000-hour difference on three ESCALATE rows, with agreeing labels, already embedded in the frozen path-specific files.

Smoke artifacts have no reconciliation role at all. They are explicitly non-reporting test executions and are isolated from the reporting-arm roots.

## 6. Semantic/regression risks and unchanged surfaces

The strongest demonstrated limitation is **subset blindness to rare values**. SM_RARECRASH is specifically triggered by six `ODM` rows present in the full extract but absent from both deterministic subsets. Consequently, both smoke runs complete normally—2.9 s at k16 and 7.9 s at k4—while the full run exits 1 after 5.8 s with `unhandled SR_SHORT_CODE ODM in normalization`. The smoke mechanism therefore cannot be treated as exhaustive defect detection.

A related semantic risk is the **systematic every-kth-row sampling rule**. It is deterministic and auditable, which is advantageous for reproducibility, but deterministic spacing can miss rare or position-correlated conditions. C51 itself demonstrates this with ODM. The evidence does not establish detection coverage for defects requiring a particular excluded row, full-data memory pressure, or behavior emerging only above 1/4 scale.

There is also a **cost tradeoff on successful or smoke-invisible runs**. Clean R-A incurs 6.8 s extra; clean R-B incurs 10.9 s extra; the smoke-invisible rare crash incurs 21.7 s extra. The aggregate result is favorable only because the targeted expensive and late failures more than offset those charges, especially QUADLOOP.

The nonlinear runtime detector is dependent on measured wall-clock ratios. Clean ratios of 1.83 and 2.52 are well below the threshold, while QUADLOOP is 18.44, giving substantial separation in this run. Even so, timing-based detection is inherently sensitive to machine/runtime conditions in a way an exit-code failure is not; C51 establishes the measured instance, not a universal timing distribution.

The **unchanged surfaces are strongly evidenced**. The frozen data inputs and common R-B modules retain their frozen hashes across reporting arms; only each arm’s seeded `run_RB.R` differs as declared. The full clean B R-A and R-B scripts themselves retain the frozen hashes.

At smoke scale, `src_peer_stats.csv` remains at its frozen hash and `src_extract_lineage.csv` is copied identically; each scale uses one common subset hash across arms. The complete R-B outputs that exist before an intentional failure are likewise byte-identical across clean and seeded arms at the same subset scale, showing no evidence that QUADLOOP or RARECRASH changes classifications merely by executing successfully on the subset.

SM_OUTCRASH is particularly informative semantically: on the full extract, its classification, fixture, and portfolio files are byte-identical to clean B, and only the intentionally undefined final kappa-grid object prevents completion.

The repeated R-B warning about named parsers not matching column names occurs in clean and seeded/smoke executions; on this evidence it is an unchanged pre-existing runtime surface rather than a C51 seed-specific regression.

OF-1 is also unchanged: the packet explicitly identifies it as pre-existing, known, expected, and not caused by C51. The C51 reconciliation construction does not compare the two paths against each other.

## 7. Claim → evidence map

| Claim | Packet section / table row | Evidence |
| --- | --- | --- |
| C51 adds k16 and k4 real-data smoke execution before the full run. | SPEC → “Exact change being tested” | Variant ordering and deterministic subset rule are frozen before execution. |
| Smoke outputs are non-reporting and isolated from reporting-arm roots. | SPEC → “Exact change being tested”; ARM MANIFESTS header | Smoke roots are outside arm roots and carry `NON_REPORTING.txt`; manifests distinguish `arms/...` from `smoke/...`. |
| SM_QUADLOOP is exactly an O(n²) per-row full-frame subset insertion. | SEED DIFFS → SM_QUADLOOP hunk | Three inserted lines implement `vapply` over all rows and subset the full frame by `type_key`. |
| SM_MIDCRASH changes only the requested classification column from `dormant_h` to `.dormant_h`. | SEED DIFFS → SM_MIDCRASH hunk | One changed column token in `class_out`. |
| SM_OUTCRASH changes the final grid write from `grid_out` to undefined `grid_out_final`. | SEED DIFFS → SM_OUTCRASH hunk | One object-name substitution at the final write. |
| SM_RARECRASH stops only when `SR_SHORT_CODE == "ODM"` is present. | SEED DIFFS → SM_RARECRASH hunk | Exact added `if(any(...)) stop(...)` statement. |
| Clean B does not smoke-flag. | C51 RESULTS → Arms rows B/RA and B/RB | Both smoke exits are zero; recomputed ratios are 1.83 and 2.52, both below 6. |
| SM_QUADLOOP is detected at k4. | C51 RESULTS → SM_QUADLOOP row | k16=19.4 s, k4=357.7 s; ratio recomputes to 18.44 > 6. |
| SM_MIDCRASH is detected at k16. | C51 RESULTS → SM_MIDCRASH row | k16 exit=1 at 2.4 s. |
| SM_OUTCRASH is detected at k16. | C51 RESULTS → SM_OUTCRASH row | k16 exit=1 at 3.4 s. |
| SM_RARECRASH is missed by smoke and fails only on full data. | C51 RESULTS → SM_RARECRASH row; raw stderr | Both smoke exits zero, ratio 2.72; full exit=1, and raw error names ODM. |
| Baseline total is 1,986.3 s. | C51 RESULTS → Totals | Independently reproduced by summing six recomputed baseline unit costs. |
| Variant total is 596.8 s. | C51 RESULTS → Totals | Independently reproduced by summing six recomputed variant unit costs. |
| Aggregate reduction is 1,389.5 s, about 69.95%. | Derived from C51 RESULTS → Totals | `1986.3−596.8=1389.5`; `1389.5/1986.3=69.954%`. |
| Full R-B portfolio identity is exact. | Raw full B R-B stderr | `131968+6377+83657=222002`. |
| k16 R-B portfolio identity is exact. | Raw clean k16 R-B stderr | `8185+394+5312=13891`. |
| k4 R-B portfolio identity is exact. | Raw clean k4 R-B stderr | `32905+1610+20967=55482`. |
| Clean B fixtures pass on both paths. | Raw B fixture tables / stderr | R-A and R-B each execute F01–F14 successfully. |
| All four seeded full R-B arms preserve the frozen fixture file. | ARM MANIFESTS → seeded-arm outputs | Each seeded full arm has fixture SHA-256 `0d72245c…`, identical to clean B R-B. |
| Clean B’s seven full-run key artifacts equal the frozen artifacts. | C51 RESULTS → “B full-run key outputs vs frozen” | Seven of seven SHA-256 pairs are identical. |
| SM_OUTCRASH’s completed full-data classification and portfolio outputs equal clean B. | ARM MANIFESTS → SM_OUTCRASH outputs | Classification `a0e42b…`, fixtures `0d7224…`, portfolio `eb677b…` match clean B exactly. |
| C51 contains no `n_inner`/`n_agree`/`n_disagree` or D-set evidence to recompute. | Builder-task template versus C51 evidence structure | C51 uses path-to-frozen hash equality rather than a supplied cross-path reconciliation table; no such numerical fields appear in the evidence. The known cross-path OF-1 is disclosed separately. |
| OF-1 is pre-existing and cannot generate a C51 clean-arm hash mismatch. | Coordinator note N1 / OF-1 | The three one-hour differences are already embedded in the frozen path-specific outputs, and C51 does not reconcile R-A directly against R-B. |

END C51 BUILDER REPORT
