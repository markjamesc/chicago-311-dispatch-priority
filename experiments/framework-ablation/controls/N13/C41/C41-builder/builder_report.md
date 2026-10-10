# C41 Builder Report

## 1. Role attestation and ablation ID.

I am acting **only as the Builder** for **C41 — Addendum 01, candidate #41, “Fixture depth over count,” N13 batch 5**. This is an independent first pass; I am blind to the Validator. I provide no terminal disposition. The packet assigns Builder=ChatGPT, Validator=DeepSeek, and Adjudicator=Grok.

The tested change is confined to the **Stage 4 fixture gate**. The frozen baseline uses 14 synthetic fixture rows that are already parsed before entering `rb_judge_rows`; the depth variant runs the same locked fixture expectations through production-layout serialization, file reading, normalization, judging, and a poison-judge stub probe.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C41 removes the assumption that **14/14 direct-judge synthetic fixture passes are sufficient evidence of fixture-gate integrity**. The baseline count gate exercises classification logic but bypasses `rb_read_csv_flex`, `rb_normalize_open`, and `rb_normalize_peers`; therefore defects in file representation, parsing, or normalization cannot make those fixtures fail. The depth variant retains the same locked cases and expectations but puts them through the production I/O path and adds a poison-judge test for fixtures whose result has been hard-coded.

The exact planted source changes are:

| Arm | File | Frozen code | Seeded code |
| --- | --- | --- | --- |
| `P_DUPINT` | `R-B/R/10_io_parse.R` | `DUPLICATE = getc(col_dup),` | `DUPLICATE = suppressWarnings(as.character(as.integer(getc(col_dup)))),` |
| `P_DATESWAP` | `R-B/R/10_io_parse.R` | `"%Y-%m-%d %H:%M:%S",` | `"%Y-%d-%m %H:%M:%S",` |
| `STUB_F11` | `R-B/R/40_fixtures.R` | no assignment at this point | `m$observed_classification[m$fixture_id == "F11"] <- "ESCALATE"` |
| `JUDGE_P50` | `R-B/R/20_integrity_and_classify.R` | `thresh <- kappa * peer_p75` | `thresh <- kappa * joined$peer_p50_h` |
| `P_TZUTC` | `R-B/R/10_io_parse.R` | `tz = "America/Chicago"` | `tz = "UTC"` |

These are one-line production-code mutations in their respective seeded arms. `P_DUPINT` and `P_DATESWAP` are the ruled parser targets; `STUB_F11` is the ruled always-pass-test target; `JUDGE_P50` is the control defect already detectable by the old gate; `P_TZUTC` is explicitly an INFO probe outside P1.

The depth harness itself does not change fixture expectations. It serializes the same pack into production-shaped text, reads it back through the production loader/normalizers, judges it, and separately substitutes a judge returning `POISON`; a fixture that still passes under that poison judge is marked as a stub.

## 3. Hard mechanical facts table.

**Provenance convention:** **Recomputed** means I independently derived the number/set/equality from the packet's raw rows or hashes. **Quoted** means the value is transcribed without further arithmetic. Where a row contains quoted source numbers but an arithmetic equality/delta, the resulting fact is marked **Recomputed**.

| Mechanical fact | Independent result | Provenance |
| --- | --- | --- |
| Reporting-run processes | Six arms × three executions per arm = **18/18 exit records with exit 0**; no timeouts shown | Recomputed from run log |
| Clean B count gate | **14/14**, failures `∅`, gate PASS | Recomputed from raw `FIX_count.csv` |
| Clean B depth gate | **14/14**, stubs `∅`, failures `∅`, gate PASS | Recomputed from raw `FIX_depth.csv` |
| `P_DUPINT` count gate | **14/14**, failures `∅` | Recomputed |
| `P_DUPINT` depth gate | **13/14**; failure set `{F07}` | Recomputed |
| `P_DATESWAP` count gate | **14/14**, failures `∅` | Recomputed |
| `P_DATESWAP` depth gate | **10/14**; failure set `{F03,F05,F10,F14}` | Recomputed |
| `STUB_F11` count gate | **14/14** | Recomputed |
| `STUB_F11` depth label comparisons | **14/14** label comparisons pass, but stub set = `{F11}`, so depth gate fails | Recomputed |
| `JUDGE_P50` count gate | **12/14**; failure set `{F03,F10}` | Recomputed |
| `JUDGE_P50` depth gate | **12/14**; failure set `{F03,F10}` | Recomputed |
| `P_TZUTC` count/depth | **14/14** and **14/14**, no stub; both gates pass | Recomputed |
| Count-gate caught set | `D_count = {JUDGE_P50}`; cardinality **1** | Recomputed |
| Depth-gate caught set | `D_depth = {P_DUPINT, P_DATESWAP, STUB_F11, JUDGE_P50}`; cardinality **4** | Recomputed |
| Set preservation | `D_count ⊆ D_depth`; `D_count − D_depth = ∅` | Recomputed |
| Incremental caught set | `D_depth − D_count = {P_DUPINT, P_DATESWAP, STUB_F11}`; cardinality **3** | Recomputed |
| Scored seeded-arm detection | count **1/4** versus depth **4/4**, a difference of **3 arms / 75 percentage points** | Recomputed; excludes INFO-only `P_TZUTC` |
| B portfolio identity | `131,968 + 6,377 + 83,657 = 222,002 = n_decision` | Recomputed |
| B total population represented | `222,002 + 23,191 = 245,193` | Recomputed |
| `P_DUPINT` portfolio identity | `131,968 + 29,389 + 83,657 = 245,014`; plus `179` out-of-set = **245,193** total | Recomputed |
| `P_DUPINT` delta vs B | decision **+23,012**; ESCALATE **0**; INCONCLUSIVE **+23,012**; STANDARD **0**; out-of-set **−23,012** | Recomputed |
| `P_DATESWAP` portfolio identity | `120,630 + 38,605 + 62,767 = 222,002`; plus `23,191` = **245,193** | Recomputed |
| `P_DATESWAP` delta vs B | ESCALATE **−11,338**; INCONCLUSIVE **+32,228**; STANDARD **−20,890**; decision/out-of-set **0** | Recomputed |
| `STUB_F11` portfolio | All five portfolio counts equal B; total remains **245,193** | Recomputed |
| `JUDGE_P50` portfolio identity | `148,941 + 6,377 + 66,684 = 222,002`; total **245,193** | Recomputed |
| `JUDGE_P50` delta vs B | ESCALATE **+16,973**; STANDARD **−16,973**; INCONCLUSIVE/decision/out-of-set **0** | Recomputed |
| `P_TZUTC` portfolio identity | `132,072 + 6,377 + 83,553 = 222,002`; total **245,193** | Recomputed |
| `P_TZUTC` delta vs B | ESCALATE **+104**; STANDARD **−104**; all other portfolio counts **0 delta** | Recomputed |
| Population conservation | Every arm has decision + out-of-set = **245,193** | Recomputed |
| Clean B key-output equality | classifications, fixture results, portfolio counts, κ grid = **4/4 exact SHA-256 matches** to frozen | Recomputed from four hash pairs |
| `P_DUPINT` key-output equality | **1/4**; only `RB_fixture_results.csv` equals frozen | Recomputed from manifests |
| `P_DATESWAP` key-output equality | **1/4**; only `RB_fixture_results.csv` equals frozen | Recomputed |
| `STUB_F11` key-output equality | **4/4** equal frozen | Recomputed |
| `JUDGE_P50` key-output equality | **0/4** equal frozen | Recomputed |
| `P_TZUTC` key-output equality | **1/4**; only `RB_fixture_results.csv` equals frozen | Recomputed |
| Count-output hash equivalence across arms | B, `P_DUPINT`, `P_DATESWAP`, `STUB_F11`, and `P_TZUTC` have identical `FIX_count.csv`; `JUDGE_P50` differs | Recomputed from manifests |
| Depth-output hash equivalence across arms | B and `P_TZUTC` have identical `FIX_depth.csv`; the four detected defects have differing depth outputs | Recomputed from manifests |
| Serialized fixture sources | Both generated fixture-source files have the same hashes across all arms | Recomputed from manifests |
| Clean B timing | count **0.5 s**, depth **1.2 s**; depth overhead = **0.7 s** | Recomputed |
| Frozen cost ceiling for B | `0.5 + 60 = 60.5 s`; observed depth **1.2 s**; margin = **59.3 s** | Recomputed |
| `n_agree + n_disagree = n_inner` | No `n_agree`, `n_disagree`, or `n_inner` evidence table exists in this C41 packet, so that example identity is not applicable/recomputable here | Source-availability fact |

The gate outcomes, caught sets, failing-fixture sets, and clean 4/4 hash equality independently reproduce the runner summary. The raw B portfolio row is `222002,131968,6377,83657,23191`. The raw `JUDGE_P50` portfolio is `222002,148941,6377,66684,23191`. The remaining portfolio arithmetic above is computed from the corresponding raw per-arm rows.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 has four conjunctive conditions.

| P1 condition | Independent factual assessment |
| --- | --- |
| 1. Superset | Satisfied mechanically. The count caught set is `{JUDGE_P50}` and the depth caught set is `{P_DUPINT, P_DATESWAP, STUB_F11, JUDGE_P50}`. Therefore every count-caught seed is depth-caught. |
| 2. Ruled targets | Satisfied mechanically. `P_DUPINT` produces depth failure F07; `P_DATESWAP` produces depth failures F03/F05/F10/F14; `STUB_F11` is detected as stub F11 even though all 14 ordinary label comparisons pass. |
| 3. Clean B | Satisfied mechanically. Count = 14/14 PASS; depth = 14/14 PASS with no stub/error; all four R-B key-output hashes equal their frozen hashes byte-for-byte. |
| 4. Cost | Satisfied mechanically. Clean count = 0.5 s and depth = 1.2 s. `1.2 ≤ 0.5 + 60 = 60.5`; observed overhead is 0.7 s. Extra chats are zero by the frozen construction. |

Thus, independently applying the frozen definition, **all four P1 conditions are established by the supplied mechanical evidence**. This matches the generated RESULTS statement that P1 was met, but the conclusion above follows from the raw arm facts rather than relying on that statement alone.

## 5. Fixture and reconciliation implications.

The strongest fixture implication is that **fixture depth exposes failure modes that fixture count alone cannot expose**. `P_DUPINT` and `P_DATESWAP` leave the direct synthetic count fixtures at 14/14 because those fixtures bypass the defective loader. Once the same test data are represented in production layout and returned through the loader, `P_DUPINT` changes F07 from expected `OUT_OF_SET` to `ESCALATE`, while `P_DATESWAP` changes F03, F05, F10, and F14.

`STUB_F11` demonstrates a distinct failure mode. Its ordinary count result is 14/14, and even the depth-path expected-versus-observed labels are 14/14. The poison probe nevertheless identifies F11 as a stub because F11 still returns its hard-coded `ESCALATE` observation when the underlying judge has been replaced. Therefore the stub check adds information that cannot be obtained merely by increasing or recounting expected-versus-observed fixture rows.

`JUDGE_P50` provides the superset control: both gates independently expose F03 and F10, so introducing the depth path did not lose the judge defect already caught by the baseline. The failing set is exactly `{F03,F10}` in both modes.

Exact reconciliation for C41 is narrower than an R-A/R-B reconciliation. For clean arm B, the four R-B key outputs are byte-identical to the frozen R-B outputs: classifications, fixture results, portfolio counts, and κ-grid counts all match their frozen SHA-256 values.

The disclosed N1/OF-1 issue therefore does not contaminate the C41 clean reconciliation. N1 concerns three one-hour R-A/R-B clock-field differences in the repeated fall-back hour; C41 compares clean B's R-B files against the already-frozen R-B files rather than comparing R-A against R-B. The labels on those three N1 rows also agree.

The production-output hashes add an important distinction between **gate detection** and **production semantic effect**. `STUB_F11` changes no production output because its seed is inside fixture scoring only, yet depth correctly detects the invalid test construction. Conversely, `P_DUPINT`, `P_DATESWAP`, and `P_TZUTC` retain the frozen production `RB_fixture_results.csv` because that production fixture path itself does not traverse the affected real-source parsing route, even though their classifications/portfolio/κ outputs differ.

## 6. Semantic/regression risks and unchanged surfaces.

The principal residual coverage risk is `P_TZUTC`. It is a genuine parser mutation with a measurable production effect, yet both count and depth gates remain 14/14. The portfolio arithmetic shows exactly **104 rows move from STANDARD to ESCALATE** relative to B, with decision-set size, INCONCLUSIVE count, and out-of-set count unchanged. The packet describes this as a 5–6 hour clock shift that moves no fixture label, and explicitly excludes the INFO probe from P1. Accordingly, C41 demonstrates materially greater fixture depth but does **not** demonstrate exhaustive detection of every I/O/parsing defect.

A second implementation observation is that depth execution emits the warning that several named parsers do not match column names. This warning occurs in clean B as well as seeded arms. It does not become `depth_error`, does not prevent B from passing 14/14, and does not prevent B's four production outputs from exactly matching frozen outputs. It is therefore an observed unchanged warning surface, not evidence in this packet of a C41-induced semantic regression.

The timing measurement is mechanically within its frozen tolerance, but the packet discloses concurrent MySQL work on the same PC. Because the two gates for an arm run back-to-back, the design treats contention as approximately shared. The clean measured difference is only 0.7 seconds against a 60-second allowance, so the reported contention does not approach the frozen cost boundary.

The changed-file surface is tightly declared. `P_DUPINT`, `P_DATESWAP`, and `P_TZUTC` replace only `10_io_parse.R`; `JUDGE_P50` replaces only `20_integrity_and_classify.R`; `STUB_F11` replaces only `40_fixtures.R`. Source data, `00_config.R`, `run_RB.R`, and all non-targeted R-B modules retain their frozen hashes in the relevant arms. The fixture serializer inputs are identical across arms, and the two serialized fixture-source artifacts hash identically across all arms. The underlying frozen source data are read-only, and this batch uses no MySQL.

The baseline frameworks and constitution remain the frozen versions declared before execution. Clean B supplies the direct regression check: all four protected R-B output files are exact frozen matches, both fixture gates pass, and the total represented population remains 245,193. The known N1 clock discrepancy remains an externally disclosed frozen-pack finding rather than a seeded or newly introduced C41 effect.

## 7. Claim → evidence map.

| Claim | Evidence section and row | Evidence |
| --- | --- | --- |
| C41 compares count-only fixture gating with a production-path depth gate and stub probe | SPEC → “Exact change being tested,” count/depth rows | Count is frozen `rb_score_fixtures`; depth serializes the same rows, parses/normalizes them, judges them, and runs poison probe. |
| `P_DUPINT` is exactly the `DUPLICATE` string→integer mutation | SEED DIFFS → `RB_P_DUPINT__10_io_parse.R` diff | `getc(col_dup)` replaced by integer coercion wrapped back to character. |
| `P_DATESWAP` swaps month/day in first ISO parse format | SEED DIFFS → `RB_P_DATESWAP__10_io_parse.R` diff | `%Y-%m-%d` → `%Y-%d-%m`. |
| `STUB_F11` hard-codes F11 observed classification | SEED DIFFS → `RB_STUB_F11__40_fixtures.R` diff | Assignment forces F11 to `ESCALATE`. |
| `JUDGE_P50` changes threshold from P75 to P50 | SEED DIFFS → `RB_JUDGE_P50__20_integrity_and_classify.R` diff | `kappa * peer_p75` → `kappa * joined$peer_p50_h`. |
| `P_TZUTC` changes Chicago parsing to UTC | SEED DIFFS → `RB_P_TZUTC__10_io_parse.R` diff | timezone argument changes from `America/Chicago` to `UTC`. |
| Count caught set is `{JUDGE_P50}` | RESULTS → Counts row; Arms → `JUDGE_P50` row | Only `JUDGE_P50` has `caught_count=TRUE`. |
| Depth caught set has four arms | RESULTS → Counts row | `P_DUPINT`, `P_DATESWAP`, `STUB_F11`, `JUDGE_P50`. |
| `P_DUPINT` fails depth on F07 only | RESULTS → Failing fixtures → `P_DUPINT`; raw depth row F07 | F07 expected `OUT_OF_SET`, observed `ESCALATE`; 13/14. |
| `P_DATESWAP` fails F03/F05/F10/F14 | RESULTS → Failing fixtures → `P_DATESWAP`; raw depth rows | Four failed depth fixtures; 10/14. |
| `STUB_F11` is detected despite 14/14 label matches | Arms → `STUB_F11`; raw `FIX_depth.csv` F11 | `depth_n_pass=14`, `depth_stubs=F11`, depth gate FAIL. |
| `JUDGE_P50` retains baseline detection | Failing fixtures → `JUDGE_P50` | Both gates fail F03/F10. |
| B passes both gates with no false flag | Arms → B | count PASS 14; depth PASS 14; no stubs/error. |
| B reconciles 4/4 production outputs | “Arm B R-B outputs vs frozen” → four file rows | Each frozen hash equals the corresponding B hash. |
| B portfolio identity is 131,968 + 6,377 + 83,657 = 222,002 | Raw B `RB_portfolio_counts.csv` row | Arithmetic recomputation from raw counts. |
| `JUDGE_P50` shifts 16,973 STANDARD rows to ESCALATE in aggregate | Raw B and `JUDGE_P50` portfolio rows | 148,941−131,968 = 16,973 and 66,684−83,657 = −16,973. |
| `P_DUPINT` expands the decision set by 23,012 while reducing out-of-set by 23,012 | Raw B and `P_DUPINT` portfolio rows | 245,014−222,002 = 23,012; 179−23,191 = −23,012. |
| `P_TZUTC` has real production effect but escapes both fixture gates | RESULTS → `P_TZUTC` row and Counts note | Both gates PASS; only 1/4 production outputs remains equal frozen; production differs. |
| Clean depth-gate cost satisfies frozen allowance | SPEC P1 condition 4 + Arms B timing row | 1.2 s versus 0.5 s count; independently computed overhead 0.7 s and 59.3 s remaining margin. |
| N1 cannot create a C41 clean mismatch | Coordinator Note N1/OF-1 | C41 compares B R-B to frozen R-B, which already contains the three repeated-hour rows. |
| P1's four frozen conditions are all mechanically established | RESULTS → Predicate conditions rows 1–4 plus independent recomputation above | Superset, ruled targets, clean B, and cost all hold. |

END C41 BUILDER REPORT
