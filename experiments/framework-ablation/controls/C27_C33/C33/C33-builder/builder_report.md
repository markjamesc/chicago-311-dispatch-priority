# C33 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for **C33, catalog #33, “Naive Clock Contract,”** in an independent first pass, blind to the Validator. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The target is Stage 4, and the control under test requires naive SQL export clocks to be read as character and parsed as `America/Chicago` wall time, without a readr POSIXct shortcut or `force_tz`.

I make no adjudicative or terminal-state determination in this report. That is outside the Builder role and is expressly excluded from this first pass.

**Ablation ID:** C33  
**Constitution:** 1.0  
**Frozen pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`  
**T_freeze:** 2026-09-12 23:59:59 America/Chicago  
**κ:** 2  
**Frozen before execution:** 2026-10-03.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The control being ablated is the explicit ownership of naive SQL clock semantics by the R parser. Under the contract, the six clock fields—`created_ts`, `mod_ts`, `closed_ts`, `CREATED_DATE`, `LAST_MODIFIED_DATE`, and `CLOSED_DATE`—are forced to character at ingestion and then interpreted as Chicago wall-clock values. C33 removes that guarantee and lets readr/type inference plus each path's historical parser determine the interpretation. B retains the contract on both paths; X1 removes it only from R-B; X2 removes it from both paths, creating a common-mode case.

For **R-B/X1**, the seed diff makes three material changes. First, `rb_parse_ts()` no longer detects an incoming POSIXt object, recovers its printed digits using its tagged source timezone, and then reparses those digits; it instead immediately applies `trimws(as.character(x))`. Second, `rb_read_csv_flex()` no longer declares all six clock columns as `col_character()` with `.default = col_guess()`. The explicit `clock_cols` object and `tryCatch()` read path are removed, and the code uses ordinary `readr::read_tsv(..., guess_max = 100000)`, permitting readr to infer the clock types. Third, the post-read timestamp handling changes: the character-owned fallback repairs are removed, while POSIXt inputs for `created_ts`, `mod_ts`, and `closed_ts` can pass through `as.POSIXct(..., tz = "America/Chicago")`, which changes timezone presentation without reconstructing the intended naive wall-clock instant.

For **R-A/X2**, there are exactly the two seeded edits allowed by the specification. In the POSIXt branch, the frozen code's recovery of printed digits in the source timezone is replaced by `return(as.POSIXct(x, tz = "America/Chicago"))`, explicitly retaining readr's instant. Separately, the six explicit `col_character()` declarations are removed from `clock_col_types`, leaving only `.default = readr::col_guess()`.

Thus X1 tests a **single-path clock-semantics defect**, while X2 tests the same defect as a **common-mode error across both independent R paths**.

## 3. Hard mechanical facts table.

The source result table reports all four executions as exit code 0; B reproduces the frozen labels; X1/X2 R-B and X2 R-A each have 104 label flips against their corresponding contract path; both ablated implementations show 222,002 rows with a `dormant_h` difference and a maximum absolute difference of 6 hours.

### Reconciliation arithmetic

| Mechanical fact | Result | Status |
| --- | --- | --- |
| B: `n_agree + n_disagree` | `222002 + 0 = 222002 = n_inner` | **Recomputed** |
| B: R-A key identity | `222002 inner + 0 only_RA = 222002 n_RA` | **Recomputed** |
| B: R-B key identity | `222002 inner + 0 only_RB = 222002 n_RB` | **Recomputed** |
| X1: `n_agree + n_disagree` | `221898 + 104 = 222002 = n_inner` | **Recomputed** |
| X1: R-A key identity | `222002 + 0 = 222002 n_RA` | **Recomputed** |
| X1: R-B key identity | `222002 + 0 = 222002 n_RB` | **Recomputed** |
| X2: `n_agree + n_disagree` | `222002 + 0 = 222002 = n_inner` | **Recomputed** |
| X2: R-A key identity | `222002 + 0 = 222002 n_RA` | **Recomputed** |
| X2: R-B key identity | `222002 + 0 = 222002 n_RB` | **Recomputed** |
| X1 cross-path disagreements | 104 | **Quoted** |
| X2 cross-path disagreements | 0 | **Quoted** |

The underlying reconciliation rows are B=`222002/222002/222002/0/0/222002/0`, X1=`222002/222002/222002/0/0/221898/104`, and X2=`222002/222002/222002/0/0/222002/0`.

### Contract-comparison and D-set arithmetic

Define:

`D_RB = {SR_NUMBER : X1/X2 pre-contract R-B label ≠ B R-B label}`

`D_RA = {SR_NUMBER : X2 no-contract R-A label ≠ B R-A label}`

| Mechanical fact | Result | Status |
| --- | --- | --- |
| ` | D_RB | ` | 104 | **Quoted / independently consistent with X1 recon** |
| ` | D_RA | ` | 104 | **Quoted** |
| Path-level flip instances | `104 + 104 = 208` | **Recomputed** |
| B R-A reproduction label differences | 0 | **Quoted** |
| B R-B reproduction label differences | 0 | **Quoted** |
| B R-A/B R-B frozen-only rows | `0 / 0` | **Quoted** |
| X1/X2 R-B contract-only/ablated-only rows | `0 / 0` | **Quoted** |
| X2 R-A contract-only/ablated-only rows | `0 / 0` | **Quoted** |

The comparison table directly reports 104 label differences for pre-contract R-B and 104 for no-contract R-A, together with 222,002 `dormant_h` differences for each.

A stronger D-set identity is mechanically derivable. B R-A and B R-B agree on all 222,002 rows. X2 no-contract R-A and pre-contract R-B also agree on all 222,002 rows. Therefore, relative to the common B label vector, `D_RA = D_RB`, not merely `|D_RA| = |D_RB|`. The unique affected SR_NUMBER set therefore contains **104 rows**, although there are **208 path-level flip observations** across the two ablated implementations. This is **recomputed** from the B and X2 zero-disagreement relationships plus the two 104-difference counts.

The X1 disagreement-pair table states that all 104 X1 disagreements are `STANDARD` on frozen R-A versus `ESCALATE` on pre-contract R-B. Because B R-A equals B R-B and X2 R-A equals the same pre-contract R-B label vector, the common affected D-set is also `STANDARD → ESCALATE` under X2.

### Portfolio arithmetic

| Run | ESCALATE | INCONCLUSIVE | STANDARD | Recomputed sum |
| --- | --- | --- | --- | --- |
| B R-A | 131,968 | 6,377 | 83,657 | `131968 + 6377 + 83657 = 222002` |
| B R-B | 131,968 | 6,377 | 83,657 | `222002` |
| X1 R-B | 132,072 | 6,377 | 83,553 | `132072 + 6377 + 83553 = 222002` |
| X2 R-A | 132,072 | 6,377 | 83,553 | `222002` |

The component counts are **quoted**; every row sum is **recomputed**.

The portfolio deltas are:

| Comparison | ΔESCALATE | ΔINCONCLUSIVE | ΔSTANDARD | Net |
| --- | --- | --- | --- | --- |
| X1 R-B − B R-B | `+104` | `0` | `−104` | `0` |
| X2 R-A − B R-A | `+104` | `0` | `−104` | `0` |

All four deltas are **recomputed**. The portfolio arithmetic independently matches the 104-row `STANDARD → ESCALATE` D-set.

The fraction of decisions whose label changes under either affected path is `104 / 222002 × 100 = 0.0468464%`, **recomputed**. This percentage is small in frequency but is not zero.

### Clock-field arithmetic

For each ablated implementation, the comparison table reports **222,002 rows** with `|Δdormant_h| > 1e-6`, against 222,002 compared rows. Therefore the affected share is:

`222002 / 222002 = 100%`.

The 100% figure is **recomputed**; the 222,002 count is **quoted**. The maximum absolute `dormant_h` difference is **6 h**, and the maximum absolute `open_age_h` difference is also **6 h**, both **quoted**.

The packet exposes the first 12 of the 104 label-flip records. For every one of those 12:

`dormant_h_ablated − dormant_h_contract = +5.000000 h`.

Thus **12/12 shown flip rows have an exact +5 h dormant shift**, **recomputed** from the displayed values.

### Run and fixture arithmetic

The four run rows report exit code 0 with durations 16.2, 28.4, 24.5, and 15.2 seconds. All four show `14/14` fixtures.

| Fact | Result | Status |
| --- | --- | --- |
| Executions represented | 4 | **Recomputed by row count** |
| Exit-zero executions | `4/4` | **Recomputed** |
| Total fixture executions represented | `14 × 4 = 56` | **Recomputed** |
| Total fixture passes represented | `56/56` | **Recomputed** |
| Fixture failures represented | 0 | **Recomputed from 14/14 on each run** |
| Total listed runtime | `16.2 + 28.4 + 24.5 + 15.2 = 84.3 s` | **Recomputed** |

### Source/preflight arithmetic and hash equalities

The read-only MySQL preflight returns `245193` `src_open_candidates` rows and `104` `src_peer_stats` types, exactly matching the frozen-pack expected counts of 245,193 and 104. The equality is **recomputed**; the counts themselves are **quoted**.

The following exact hash relations are **recomputed by string equality** from the preflight and arm manifests:

| Relation | Mechanical result | Status |
| --- | --- | --- |
| B/X1/X2 `src_open_candidates.csv` | all `ba089fcc…d81b9` | **Recomputed equal** |
| B R-B `20_integrity_and_classify.R` vs X1 | both `72ac5def…1d99` | **Recomputed equal** |
| B R-A output vs frozen R-A output | both `c099e092…e0d9` | **Recomputed equal** |
| B R-B output vs frozen R-B output | both `a0e42b86…e193` | **Recomputed equal** |
| X1 parser vs frozen C33 X1 seed | both `8df344f5…c4866` | **Recomputed equal** |
| X2 R-A runner vs frozen C33 X2 seed | both `65772bee…2b9a6d` | **Recomputed equal** |
| B R-A runner vs frozen R-A runner | both `f4e8993c…58587` | **Recomputed equal** |

The relevant manifest hashes are shown for B, X1, and X2, while the corresponding frozen/seed hashes are established in preflight.

The ablated classification output byte hashes are not equal to their B counterparts: X1 R-B=`87c15c88…f00e` versus B R-B=`a0e42b86…e193`; X2 R-A=`a67a9b9d…964b` versus B R-A=`c099e092…e0d9`. These inequalities are **recomputed**.

The X1 R-B output size is 41,963,341 bytes, exactly equal to the historical 2026-09-19 output size quoted in the packet. That size equality is **recomputed**. Its portfolio `ESCALATE=132,072` also exactly equals the historical count, another **recomputed equality**.

For completeness, the output-size changes relative to B are **recomputed** as:

`X1 R-B − B R-B = 41,963,341 − 41,963,733 = −392 bytes`

`X2 R-A − B R-A = 22,273,051 − 22,271,481 = +1,570 bytes`.

These byte differences are informational rather than the label-level gate specified by C33.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 predicate requires **both** of the following for X1 and X2: every ablated path must have exactly **0 label flips** against arm B, and **no row** may have `|Δdormant_h| > 1e-6 h`. Conversely, one or more label flips or one or more clock-derived shifts makes the predicate false. Reconciliation/fixture detection is explicitly supporting evidence rather than part of P1 itself.

Observed against that predicate:

| Ablated path | Required label flips | Observed | Required shifted rows | Observed |
| --- | --- | --- | --- | --- |
| X1/X2 pre-contract R-B vs B R-B | 0 | **104** | 0 | **222,002** |
| X2 no-contract R-A vs B R-A | 0 | **104** | 0 | **222,002** |

The maximum absolute observed `dormant_h` shift is 6 hours on both affected paths.

Therefore the frozen P1 Boolean condition is **not satisfied** by the observed X1 or X2 results. This follows independently from either component: the observed label-flip count is nonzero, and the observed clock-shift count is nonzero.

## 5. Fixture and reconciliation implications.

**Reconciliation is effective against the asymmetric X1 defect.** X1 keeps R-A frozen and removes the contract only from R-B. The resulting comparison has 221,898 agreements and 104 disagreements, with all 104 disagreements shown as frozen R-A=`STANDARD` and pre-contract R-B=`ESCALATE`.

**Reconciliation does not expose the common-mode X2 defect.** With the same no-contract behavior present on both R paths, X2 has 222,002 agreements and zero cross-path disagreements, even though each ablated path differs from its corresponding B path on 104 labels and shows a clock-field shift on all 222,002 rows. Thus exact R-A/R-B agreement alone cannot distinguish “both implementations are correct” from “both implementations share this same clock interpretation error.”

**The fixture result requires a qualification.** The results summary labels H6 as “fixtures detect the ablated defect,” but the evidence printed beside that statement is B-RA 14/14, B-RB 14/14, X1-RB 14/14, and X2-RA 14/14. The run table likewise shows every execution at 14/14 with no listed fixture failures.

From the packet as supplied, the mechanically supportable statement is therefore: **all frozen fixtures passed in all four executions**. A conventional pass/fail fixture signal did **not** distinguish B from X1 or X2. The packet does not provide a per-fixture output showing some separate positive “defect detected” condition that would reconcile the wording of H6 with 14/14 pass results. Consequently, the phrase “fixtures detect the ablated defect” is not established by the displayed fixture counts alone.

This matters especially in X2: both independent analytical implementations agree perfectly and every fixture passes, yet comparison against the contract arm still exposes 104 decision-label changes and clock-derived differences on every classified row. The contract comparison is therefore carrying information not supplied by cross-path agreement or the displayed fixture pass/fail signal in the common-mode case.

## 6. Semantic/regression risks and unchanged surfaces.

The primary semantic risk is that **type inference is allowed to determine the meaning of a naive clock**. The frozen contract prevents that by making the values character first and assigning `America/Chicago` wall-clock semantics explicitly. The ablation lets readr produce POSIXct values and then permits code such as `as.POSIXct(x, tz="America/Chicago")` to preserve an already inferred instant rather than reconstruct the intended local wall time. The seed comments themselves identify the resulting CDT/CST-offset behavior, and the empirical comparison reaches a maximum absolute shift of 6 hours.

The decision-level regression surface is narrow in count but concrete: the affected D-set is 104 SR_NUMBERs, all moving from `STANDARD` to `ESCALATE`, with portfolio counts correspondingly moving from 131,968 to 132,072 ESCALATE and from 83,657 to 83,553 STANDARD. INCONCLUSIVE remains 6,377. The SR_NUMBER key set itself does not change.

The larger metric-level semantic surface is not narrow: `dormant_h` differs for 222,002 of 222,002 rows on each affected implementation. Therefore a small number of threshold-crossing label changes should not be interpreted as evidence that the clock error exists on only 104 rows; the displayed evidence says the clock-derived metric changes across the full classified population, with only 104 rows crossing the relevant decision boundary.

The strongest common-mode risk is demonstrated by X2. Because both implementations preserve the same wrongly interpreted instant, structural independence at the code-path level does not by itself guarantee semantic independence at the clock-contract level. X2 produces zero R-A/R-B disagreements while still differing from B on the same 104-row D-set. This is precisely the failure mode that an explicit shared semantic contract prevents.

The specification declares the following surfaces unchanged: SQL extract and Source Gate, TCD-IG rules, κ, fixture expecteds, SR_NUMBER grain, and the frozen Chicago 311 Stage 4 pack. The manifests support key parts of that declaration mechanically: the frozen source candidate file has the same SHA-256 in B, X1, and X2, and R-B's `20_integrity_and_classify.R` is byte-identical between B and X1.

Arm B also reproduces the frozen classifications with zero label differences and zero only-rows on both paths, and B's two paths reconcile with zero disagreement. Its R-A and R-B classification output hashes exactly equal the preflight-frozen output hashes, adding byte-level reproduction evidence for this run.

Finally, byte identity to the original 2026-09-19 historical run is explicitly informational rather than the controlling comparison because the current environment is R 4.6.1 whereas the original run used R 4.5.1; label-level equality is the specified gate. The present environment is reported as R 4.6.1 with readr 2.2.0 and lubridate 1.9.5.

## 7. Claim → evidence map.

| Claim | Packet section and table/row | Evidence |
| --- | --- | --- |
| C33 tests removal of the naive-clock character→Chicago wall-time contract. | **SPEC → Control under test / Exact change being tested** | Six named clocks, no readr POSIXct shortcut; B/X1/X2 arm definitions. |
| X1 uses the genuine historical pre-contract R-B parser; X2 also seeds R-A with the POSIXct shortcut. | **SPEC → Exact change being tested, X1 and X2 rows** | Historical R-B parser and X2 two-edit definition. |
| All four executions exited zero and reported 14/14 fixtures. | **C33_RESULTS → Runs, all four rows** | B RA, B RB, X1 RB, X2 RA. |
| B reproduces the frozen pack at the label/key level. | **C33_RESULTS → Ablated paths vs contract arm, first two rows** | Both B paths: 0 only-rows, 0 label differences, 0 dormant differences. |
| B's two paths reconcile exactly. | **C33_RESULTS → Reconciliation, B row** | 222,002 agreements, zero disagreements. |
| X1 reconciliation detects 104 asymmetric label disagreements. | **C33_RESULTS → Reconciliation, X1 row** | 221,898 agree + 104 disagree = 222,002. |
| Those 104 X1 disagreements are all `STANDARD → ESCALATE`. | **C33_RESULTS → Disagreeing label pairs, X1 row** | `STANDARD / ESCALATE / 104`. |
| X2 has zero cross-path disagreements despite the ablation. | **C33_RESULTS → Reconciliation, X2 row** | 222,002 agreements, zero disagreements. |
| Each affected implementation differs from B on 104 labels and 222,002 dormant values. | **C33_RESULTS → Ablated paths vs contract arm, X1/X2 R-B and X2 R-A rows** | `n_label_diff=104`, `n_dormant_diff=222002`, max absolute difference 6 h. |
| `D_RA = D_RB` and contains 104 unique SR_NUMBERs. | **Derived from Reconciliation B row + X2 row + contract-comparison rows** | B vectors are identical; X2 ablated vectors are identical; both ablated-vs-B differences are 104. |
| Both ablated portfolios move exactly 104 decisions from STANDARD to ESCALATE. | **C33_RESULTS → Portfolio, all four rows** | ESCALATE `131968→132072`; STANDARD `83657→83553`; INCONCLUSIVE unchanged. |
| All 12 displayed flip examples have a +5 h `dormant_h` difference. | **C33_X1_RB_label_flips.csv → displayed rows 1–12** | Direct subtraction of ablated minus contract values on each displayed row. |
| The source candidate hash is identical across B, X1, and X2. | **ARM MANIFESTS → B/X1/X2 source rows** | Same `ba089fcc…d81b9` SHA-256. |
| The X1 parser and X2 R-A runner are exactly the frozen C33 seeds. | **PREFLIGHT seed rows + ARM MANIFESTS X1/X2 code rows** | Exact SHA-256 equality for `8df344f5…c4866` and `65772bee…2b9a6d`. |
| B's classification outputs are byte-identical to the preflight-frozen outputs. | **PREFLIGHT frozen output rows + ARM MANIFESTS B output rows** | Exact R-A `c099e092…e0d9` and R-B `a0e42b86…e193` equality. |
| The frozen P1 condition is not satisfied by the observations. | **SPEC → Operational benefit predicate P1 + C33_RESULTS → contract-comparison rows** | Predicate requires zero flips and zero shifted rows; observations are 104 flips and 222,002 shifted rows per affected path. |
| The displayed fixture counts do not mechanically demonstrate defect detection. | **C33_RESULTS → H6 + Runs rows** | H6 says “detect,” but every listed execution is 14/14 with no failure shown. |
| X2 demonstrates a common-mode semantic risk invisible to cross-path label reconciliation. | **C33_RESULTS → X2 reconciliation row + X2/B comparison rows** | X2 has zero cross-path disagreements while each ablated implementation differs from B on 104 labels and 222,002 dormant values. |
| Declared unchanged surfaces include SQL/Source Gate, TCD-IG, κ, fixture expecteds, SR_NUMBER grain, and frozen Stage 4 pack. | **SPEC → Expected unchanged surfaces** | Explicit frozen specification. |

END C33 BUILDER REPORT
