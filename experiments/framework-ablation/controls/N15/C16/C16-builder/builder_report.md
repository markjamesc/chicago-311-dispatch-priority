## 1. Role attestation and ablation ID

I attest that I am acting **only as Builder** for this independent first pass, blind to the Validator’s first-pass analysis. The assigned ablation is **C16**, owner Remaining Ablation Program catalog #16, **“Spec→Builder Packet Complete,”** in N15 batch 2 of 3. The frozen role assignment is Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. The target stage is **Stage 3→4**, specifically translation of locked Stage-3 rules into explicit builder requirements.  [source: C16_1_BUILDER_ChatGPT]

The control under test is: **every Stage-3 rule is translated into an explicit implementation requirement in the builder packet.** The ablation removes one locked rule from the builder packet so the receiving builder does not implement that rule. Common-mode seeds remove the rule from both R-A and R-B; one asymmetric seed removes the LEGACY rule from R-B only. Arm B is the complete-packet truth reference.  [source: C16_1_BUILDER_ChatGPT]

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS

Conceptually, C16 asks whether omission of an otherwise locked implementation rule from the builder packet can change the frozen Stage-4 outputs without being detected by the pre-existing crash/reconciliation/fixture mechanisms. Four omission families were seeded: LEGACY exclusion, clock-order/future-created integrity clauses, blank `type_key`, and unparseable `CREATED_DATE`.  [source: C16_1_BUILDER_ChatGPT]

**OM_LEGACY_CM / OM_LEGACY_RB — remove LEGACY exclusion.**

R-A changes:

Diff

`- exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open
+ exclude <- is_true_like(dup) | !in_envelope_open # [seed] LEGACY exclusion omitted from packet`

R-B changes:

Diff

`- in_decision <- is_open & !dup_flag & !leg_flag
+ in_decision <- is_open & !dup_flag # [seed] LEGACY exclusion omitted from packet`

`OM_LEGACY_CM` installs both changes. `OM_LEGACY_RB` installs only the R-B change. These are the exact seeded edits shown in the SEED DIFFS.  [source: C16_1_BUILDER_ChatGPT]

**OM_CLOCKS_CM — remove `mod < created` and `created > T` clauses.**

R-A changes:

Diff

`- check(!is.na(base$created_ts) & !is.na(base$mod_ts) & base$mod_ts < base$created_ts, "inverted_clocks")
- check(!is.na(base$created_ts) & base$created_ts > t_freeze, "created_after_T")
+ # [seed] I02 clock-order and created>T clauses omitted from packet`

R-B changes:

Diff

`- p_bad_clock <- is.na(created_ts) | is.na(mod_ts) | (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |
- (!is.na(created_ts) & created_ts > t_freeze)
+ p_bad_clock <- is.na(created_ts) | is.na(mod_ts) # [seed] clock-order and created>T clauses omitted from packet`

Thus missing/unparseable clock checks remain, while the ordering and post-freeze-time conditions are specifically removed.  [source: C16_1_BUILDER_ChatGPT]

**OM_BLANKTYPE_CM — remove blank-`type_key` clause.**

R-A changes:

Diff

`- check(is_blank(base$type_key), "blank_type_key")
+ # [seed] blank type_key clause omitted from packet`

R-B changes:

Diff

`- p_blank_type <- rb_is_blank(joined$type_key)
+ p_blank_type <- rep(FALSE, n) # [seed] blank type_key clause omitted from packet`

The R-B edit explicitly forces the predicate false for every row.  [source: C16_1_BUILDER_ChatGPT]

**OM_UNPARSE_CM — remove the unparseable-`CREATED_DATE` clause.**

R-A changes:

Diff

`- check(is.na(base$created_ts), "unparseable_created")
+ # [seed] unparseable CREATED_DATE clause omitted from packet`

R-B changes:

Diff

`- p_bad_clock <- is.na(created_ts) | is.na(mod_ts) | (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |
+ p_bad_clock <- is.na(mod_ts) | # [seed] unparseable CREATED_DATE clause omitted from packet
+ (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |`

The inverted-clock and `created > T` tests remain in this seed; only the `is.na(created_ts)` trigger is removed.  [source: C16_1_BUILDER_ChatGPT]

## 3. Hard mechanical facts table

| Mechanical fact | Result | Status | Independent recomputation / basis |
| --- | --- | --- | --- |
| Frozen source rows | **245,193** | **Recomputed** | `222,176 DUPLICATE=false + 23,017 DUPLICATE=true = 245,193`. Independently, `245,014 LEGACY=false + 179 LEGACY=true = 245,193`; peer-size bins also sum to 245,193. Data-profile inputs are frozen in SPEC.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline decision/output rows, R-A | **222,002** | **Quoted and identity-checked** | Arm-B recon row reports `n_ra=222002`.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline decision/output rows, R-B | **222,002** | **Quoted and identity-checked** | Arm-B recon row reports `n_rb=222002`.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline intersection | **222,002** | **Quoted** | `n_inner=222002`.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline classification agreements | **222,002** | **Recomputed** | `n_agree = n_inner − n_disagree = 222,002 − 0 = 222,002`. |
| Baseline identity `agree + disagree = inner` | **222,002 + 0 = 222,002** | **Recomputed** | Exact arithmetic from Arm-B recon. |
| Baseline key-set reconciliation | **0 only-R-A / 0 only-R-B** | **Quoted** | Arm-B recon.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline classification disagreement | **0** | **Quoted** | Arm-B recon.  [source: C16_1_BUILDER_ChatGPT] |
| Baseline dormant-hour full-field mismatch | **1** | **Quoted** | Known N1 and Arm-B recon. |
| Baseline open-age full-field mismatch | **2** | **Quoted** | Known N1 and Arm-B recon. |
| Total known N1 full-field mismatching cells | **3** | **Recomputed** | `1 dormant + 2 open_age = 3`; these concern three disclosed rows and do not change labels.  [source: C16_1_BUILDER_ChatGPT] |
| Arm-B reproduction vs frozen R-A | **0/0/0/0/0 differences** | **Quoted** | `only_x`, `only_truth`, label, dormant, and open-age differences are all zero.  [source: C16_1_BUILDER_ChatGPT] |
| Arm-B reproduction vs frozen R-B | **0/0/0/0/0 differences** | **Quoted** | Same five fields all zero.  [source: C16_1_BUILDER_ChatGPT] |
| Arm-B fixtures, R-A | **14/14** | **Recomputed from raw fixture rows** | F01–F14 all have `pass=TRUE`.  [source: C16_1_BUILDER_ChatGPT] |
| Arm-B fixtures, R-B | **14/14** | **Recomputed from raw fixture rows** | F01–F14 all have `pass=TRUE`.  [source: C16_1_BUILDER_ChatGPT] |
| Seeded arms completely executed | **5/5** | **Recomputed** | All five seeded-arm rows have the required recorded exit(s); run log contains every declared execution.  [source: C16_1_BUILDER_ChatGPT] |
| Seeded path executions | **9** | **Recomputed** | `2 + 1 + 2 + 2 + 2 = 9` seeded path executions. |
| Seeded path nonzero exits | **0** | **Recomputed** | Every seeded exit shown is zero. |
| LEGACY nonduplicate rows newly admitted when LEGACY exclusion is removed | **174** | **Recomputed/confirmed** | Each modified LEGACY path has `only_x=174`; baseline has no `only_B` rows.  [source: C16_1_BUILDER_ChatGPT] |
| LEGACY rows also marked duplicate | **5** | **Recomputed** | Frozen profile has 179 LEGACY rows. Removing only the LEGACY exclusion admits 174 while duplicate exclusion remains; therefore `179 − 174 = 5` are simultaneously excluded as duplicates. |
| Baseline excluded union | **23,191** | **Recomputed** | `23,017 duplicate + 179 legacy − 5 overlap = 23,191`; `245,193 − 23,191 = 222,002`, independently reproducing Arm-B output cardinality. |
| OM_LEGACY_CM R-A rows | **222,176** | **Recomputed** | `222,002 + 174 = 222,176`. |
| OM_LEGACY_CM R-B rows | **222,176** | **Recomputed** | `222,002 + 174 = 222,176`. |
| OM_LEGACY_CM intersection | **222,176** | **Recomputed** | Both modified paths add the same 174 keys and recon has zero one-sided keys. |
| OM_LEGACY_CM agreements | **222,176** | **Recomputed** | `n_inner 222,176 − n_disagree 0`. |
| OM_LEGACY_CM locked-field changes summed across paths | **348** | **Recomputed** | `174 R-A + 174 R-B = 348`; matches the results row.  [source: C16_1_BUILDER_ChatGPT] |
| OM_LEGACY_CM decision changes summed across paths | **348** | **Recomputed/confirmed** | Same two 174-row additions; quoted result is 348. |
| OM_LEGACY_CM portfolio/output cardinality delta | **+174 R-A, +174 R-B** | **Recomputed** | Derived from baseline row count plus each path's `only_x=174`. Label-specific portfolio-count deltas cannot be recovered because the packet supplies portfolio file hashes, not their row contents. |
| OM_LEGACY_RB R-A rows | **222,002** | **Recomputed** | R-A is taken from Arm B. |
| OM_LEGACY_RB R-B rows | **222,176** | **Recomputed** | `222,002 + 174`. |
| OM_LEGACY_RB intersection | **222,002** | **Recomputed** | R-B has 174 additional keys; `recon_only_rb=174`, so all 222,002 R-A keys are shared. |
| OM_LEGACY_RB agreements | **222,002** | **Recomputed** | `222,002 inner − 0 disagreements`. |
| OM_LEGACY_RB identity | **222,002 + 0 = 222,002** | **Recomputed** | `n_agree + n_disagree = n_inner`. |
| OM_LEGACY_RB locked-field changes | **174** | **Recomputed/confirmed** | Only R-B adds 174 keys.  [source: C16_1_BUILDER_ChatGPT] |
| OM_LEGACY_RB portfolio/output cardinality delta | **0 R-A, +174 R-B** | **Recomputed** | R-A is Arm B; modified R-B adds 174. |
| OM_CLOCKS_CM locked-field changes | **0** | **Recomputed/confirmed** | Both `RA_vs_B` and `RB_vs_B` have zero key, label, dormant, and open-age changes.  [source: C16_1_BUILDER_ChatGPT] |
| OM_CLOCKS_CM agreements | **222,002** | **Recomputed** | Both classification outputs are byte-identical to B; recon one-sided keys and disagreements are zero. |
| OM_CLOCKS_CM portfolio cardinality delta | **0 / 0** | **Recomputed** | Classification/portfolio hashes equal B on both paths. |
| OM_BLANKTYPE_CM locked-field changes | **0** | **Recomputed/confirmed** | All per-path comparison components are zero.  [source: C16_1_BUILDER_ChatGPT] |
| OM_BLANKTYPE_CM agreements | **222,002** | **Recomputed** | Same key sets and zero disagreements. |
| OM_BLANKTYPE_CM portfolio cardinality delta | **0 / 0** | **Recomputed** | Classification and portfolio files are hash-identical to B. |
| OM_UNPARSE_CM locked-field changes | **0** | **Recomputed/confirmed** | All per-path comparison components are zero.  [source: C16_1_BUILDER_ChatGPT] |
| OM_UNPARSE_CM agreements | **222,002** | **Recomputed** | Same key sets and zero disagreements. |
| OM_UNPARSE_CM portfolio cardinality delta | **0 / 0** | **Recomputed** | Classification and portfolio hashes equal B. |
| Harm set `H` | **{OM_LEGACY_CM, OM_LEGACY_RB}** | **Recomputed** | Exactly the arms with `locked_field_changes_vs_B > 0`: 348 and 174 respectively; the remaining three are zero. |
| Detection set `D_abl` | **{OM_LEGACY_CM, OM_LEGACY_RB, OM_CLOCKS_CM, OM_UNPARSE_CM}** | **Recomputed** | LEGACY_CM has F08 failures; LEGACY_RB has 174 one-sided R-B keys and F08 failure; CLOCKS_CM has R-A F05 failure; UNPARSE_CM has R-A F13 failure; BLANKTYPE_CM has neither crash, key/label recon mismatch, nor fixture failure.  [source: C16_1_BUILDER_ChatGPT] |
| `H ∩ D_abl` | **{OM_LEGACY_CM, OM_LEGACY_RB}** | **Recomputed** | Both members of H are members of D_abl. |
| `H \ D_abl` | **{}** | **Recomputed** | Set subtraction is empty. |
| Arms with no locked-field change | **{OM_CLOCKS_CM, OM_BLANKTYPE_CM, OM_UNPARSE_CM}** | **Recomputed** | Their locked-field-change counts are each zero. |
| Actual seeded fixture evaluations | **126** | **Recomputed** | `9 actual seeded paths × 14 fixtures = 126`. |
| Actual seeded fixture failures | **5** | **Recomputed** | LEGACY_CM RA F08 + RB F08; LEGACY_RB RB F08; CLOCKS_CM RA F05; UNPARSE_CM RA F13. |
| Actual seeded fixture passes | **121/126** | **Recomputed** | `126 − 5 = 121`. |
| Frozen source hash equality across all arms | **2/2 source data files identical in every arm** | **Recomputed from manifests** | `src_open_candidates.csv` remains `ba089...d81b9`; `src_peer_stats.csv` remains `cb78...d79eb58` in B and every seeded arm. |
| OM_BLANKTYPE_CM classification hashes equal B | **2/2** | **Recomputed from manifests** | R-A `c099...0d9`; R-B `a0e4...e193`, identical to B. |
| OM_CLOCKS_CM classification hashes equal B | **2/2** | **Recomputed from manifests** | Same R-A and R-B classification hashes as B. |
| OM_UNPARSE_CM classification hashes equal B | **2/2** | **Recomputed from manifests** | Same R-A and R-B classification hashes as B. |
| No-change arms' portfolio hashes equal B | **6/6 path files** | **Recomputed from manifests** | CLOCKS, BLANKTYPE, and UNPARSE each have R-A and R-B portfolio hashes identical to B. |
| OM_LEGACY_CM classification hashes equal B | **0/2** | **Recomputed from manifests** | Both modified classification files differ from B. |
| OM_LEGACY_CM portfolio hashes equal B | **0/2** | **Recomputed from manifests** | Both portfolio-count files differ from B despite retaining the same byte sizes. |
| OM_LEGACY_RB R-B outputs equal OM_LEGACY_CM R-B outputs | **4/4 core R-B files** | **Recomputed from manifests** | Classification, fixture-results, kappa-grid-counts, and portfolio-count hashes are identical between the two arms, consistent with the identical R-B LEGACY seed. |

The portfolio-count **contents themselves are not reproduced in the packet**, so label-by-label numerical deltas cannot be independently reconstructed. What can be reconstructed exactly is output cardinality, locked-field changes, and whether the portfolio-count files are byte-identical or different across arms.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate is:

- `H` = seeded arms whose output differs from Arm B on any locked field.
- `D_abl` = arms caught by a crash, a reconciliation key/classification mismatch, or a fixture failure on any path.
- The predicate evaluates true exactly when `H ⊆ D_abl`; it evaluates false if `H \ D_abl` is non-empty.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

From the raw seeded-arm and fixture evidence:

`H = {OM_LEGACY_CM, OM_LEGACY_RB}`.

`D_abl = {OM_LEGACY_CM, OM_LEGACY_RB, OM_CLOCKS_CM, OM_UNPARSE_CM}`.

Therefore:

`H ⊆ D_abl`.

`H \ D_abl = {}`.

The frozen P1 predicate therefore **evaluates true on this evidence**. The fact that `OM_BLANKTYPE_CM` is not detected does not alter this predicate result because that arm changes no locked output field in the frozen data pack. Likewise, `OM_CLOCKS_CM` and `OM_UNPARSE_CM` are detected by fixtures despite causing no locked production-output change, so they are members of `D_abl` but not of `H`. These set memberships reproduce H4–H7 independently from the seeded-arm rows.  [source: C16_1_BUILDER_ChatGPT]

No terminal disposition is stated here.

## 5. Fixture and reconciliation implications

**Arm B establishes the clean reference mechanically.** Both paths execute successfully, all 28 baseline fixture evaluations pass, each path exactly reproduces its frozen classification file, and key/classification reconciliation is `0/0/0`. The separate full-field comparison retains the disclosed N1 differences of one `dormant_h` value and two `open_age_h` values. The three one-hour clock mismatches are therefore part of the frozen reference condition rather than seeded effects.  [source: C16_1_BUILDER_ChatGPT]

**OM_LEGACY_CM demonstrates the common-mode limitation of reconciliation.** Both R-A and R-B admit the same 174 extra keys. Consequently, R-A and R-B still reconcile at `0 only-R-A / 0 only-R-B / 0 classification disagreements`; an inter-path comparison alone does not reveal the common-mode omission. F08 fails independently on both paths, changing expected `OUT_OF_SET` to observed `ESCALATE`, so the fixture suite catches the omission despite perfect key/label agreement between the two implementations.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

**OM_LEGACY_RB is visible through both asymmetric reconciliation and the fixture suite.** R-B gains 174 keys while R-A remains the Arm-B reference, producing `recon_only_rb=174`; R-B F08 also fails `OUT_OF_SET → ESCALATE`. Thus this asymmetric omission is mechanically visible through two independent frozen mechanisms.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

**OM_CLOCKS_CM does not change frozen production locked fields but is fixture-detectable on R-A.** R-A F05 changes from expected `INCONCLUSIVE` to observed `STANDARD`; R-B's F05 remains `INCONCLUSIVE` and all R-B fixtures pass. Both production classification outputs remain identical to B. This means the frozen fixture suite contains at least one R-A test sensitive to the removed clock-order/future-created clauses, even though the frozen production source contains zero `mod < created` and zero `created > T` rows.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

**OM_BLANKTYPE_CM is inert in this frozen pack and fixture suite.** The production source contains zero blank `type_key` rows; both paths remain byte-identical to B on classifications and both run 14/14 fixtures. Therefore the omission is neither behaviorally harmful on the frozen locked fields nor detected by the frozen fixture/reconciliation definition.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

**OM_UNPARSE_CM also leaves production locked fields unchanged but is fixture-detectable on R-A.** The frozen source contains zero unparseable created/mod timestamps. R-A F13 changes from `INCONCLUSIVE` to `STANDARD`; all R-B fixtures still pass. Production classifications remain identical to B on both paths.  [source: C16_1_BUILDER_ChatGPT]  [source: C16_1_BUILDER_ChatGPT]

Across all seeded arms, the N1 `1 dormant_h / 2 open_age_h` inter-path mismatch pattern remains invariant. That invariance, plus the exact B reproduction and the zero per-path dormant/open-age differences versus B in every seed, separates N1 from the seeded changes.

## 6. Semantic/regression risks and unchanged surfaces

The strongest semantic risk exposed by C16 is **common-mode blindness of dual-path reconciliation**. `OM_LEGACY_CM` changes 348 path-summed locked outputs while retaining zero key-set or classification disagreement between R-A and R-B. The semantic fixture F08, rather than reconciliation, is what detects the common-mode error. A two-build architecture therefore does not by itself protect against a requirement omitted identically from both builder packets.

A second risk is **coverage boundedness of the frozen data and fixtures**. `OM_BLANKTYPE_CM` removes a real locked rule yet produces no source-output change and no fixture failure because the frozen source has zero blank `type_key` rows and the frozen fixture suite does not expose an outcome change from this omission. The C16 result therefore establishes the frozen operational predicate only; it does not establish that the blank-type rule is semantically unnecessary for future datasets.

A related limitation applies to CLOCKS and UNPARSE. Their production outputs are unchanged because the frozen source has zero inverted clocks, zero post-freeze created timestamps, and zero unparseable created/mod timestamps. R-A fixtures expose both omissions, but R-B fixtures do not. This is evidence of path-specific fixture sensitivity and argues against interpreting production equality in this pack as general semantic equivalence.

N1 must remain separated from seeded regression analysis. The one `dormant_h` and two `open_age_h` mismatches are disclosed frozen-pack differences, exactly one hour each, with agreeing labels. Their likely daylight-saving explanation is explicitly unconfirmed. They recur unchanged in every arm and therefore provide no evidence of a C16-seeded defect.  [source: C16_1_BUILDER_ChatGPT]

The following surfaces are mechanically unchanged:

- Both frozen source data files retain exactly the Arm-B hashes in every arm; there are no source variants.
- `R-B/R/00_config.R`, `R-B/R/10_io_parse.R`, `R-B/R/40_fixtures.R`, and `R-B/run_RB.R` remain at their frozen hashes wherever that path runs. Only the declared seeded implementation files differ.
- For `OM_CLOCKS_CM`, `OM_BLANKTYPE_CM`, and `OM_UNPARSE_CM`, both production classification hashes and both portfolio-count hashes equal Arm B.
- For `OM_BLANKTYPE_CM`, even the R-A and R-B fixture-result files are hash-identical to Arm B.
- The two LEGACY arms use the same R-B seed, and their R-B classification, fixture, kappa-grid, and portfolio outputs are hash-identical to one another. This is a deterministic cross-arm replication of that seeded R-B implementation.
- All five seeded arms have every declared execution recorded and every executed process exits zero.

The LEGACY seeds are the only arms in which frozen production classification/portfolio hashes depart from B. Their changes consist of 174 added keys per modified path; the comparison tables report zero label, dormant-hour, or open-age changes on keys shared with B.

## 7. Claim → evidence map

| Claim | Frozen evidence citation |
| --- | --- |
| C16 tests complete translation of locked Stage-3 rules into builder requirements. | **SPEC → “Control under test” and “Exact change being tested”**, lines 38–45.  [source: C16_1_BUILDER_ChatGPT] |
| ChatGPT is Builder only; DeepSeek is Validator; Grok is Adjudicator. | **SPEC → Roles**, line 34; Constitution → separation of duties.  [source: C16_1_BUILDER_ChatGPT] |
| The exact four seeded omission families are LEGACY, clocks, blank type, and unparseable CREATED_DATE. | **SPEC → Seeded omissions**, lines 53–71; **SEED DIFFS**, lines 665–755.  [source: C16_1_BUILDER_ChatGPT] |
| Arm B exactly reproduces both frozen path outputs and has 14/14 fixtures on both paths. | **C16_RESULTS → Mechanical facts H1/H2; Arm B repro rows; Arm B recon row**, lines 331–349; **Fixture results → B RA/RB F01–F14**, lines 373–400.  [source: C16_1_BUILDER_ChatGPT] |
| Clean key/classification reconciliation is 0/0/0 while full-field recon retains N1 = 1 dormant and 2 open-age mismatches. | **C16_RESULTS → H2 and Arm B recon row**, lines 333 and 346–349; **Coordinator Note N1**, lines 18–19.  [source: C16_1_BUILDER_ChatGPT] |
| OM_LEGACY_CM adds 174 keys to each path, changes 348 path-summed locked outputs, and remains 0/0/0 on inter-path key/class reconciliation. | **C16_RESULTS → Seeded arms → OM_LEGACY_CM row**, line 354.  [source: C16_1_BUILDER_ChatGPT] |
| OM_LEGACY_CM is detected by F08 on both paths. | **Fixture results → OM_LEGACY_CM RA F08 and RB F08**, rows at lines 408 and 422.  [source: C16_1_BUILDER_ChatGPT] |
| OM_LEGACY_RB adds 174 R-B-only keys and fails R-B F08. | **C16_RESULTS → Seeded arms → OM_LEGACY_RB**, line 355; **Fixture results → OM_LEGACY_RB RB F08**, line 436.  [source: C16_1_BUILDER_ChatGPT] |
| OM_CLOCKS_CM has zero locked production changes but R-A F05 fails. | **C16_RESULTS → OM_CLOCKS_CM**, line 356; **Fixture results → OM_CLOCKS_CM RA F05**, line 447.  [source: C16_1_BUILDER_ChatGPT] |
| OM_BLANKTYPE_CM has zero locked production changes and no fixture failure. | **C16_RESULTS → OM_BLANKTYPE_CM**, line 357; **Fixture results → OM_BLANKTYPE_CM RA/RB**, lines 471–498.  [source: C16_1_BUILDER_ChatGPT] |
| OM_UNPARSE_CM has zero locked production changes but R-A F13 fails. | **C16_RESULTS → OM_UNPARSE_CM**, line 358; **Fixture results → OM_UNPARSE_CM RA F13**, line 511.  [source: C16_1_BUILDER_ChatGPT] |
| `H = {OM_LEGACY_CM, OM_LEGACY_RB}`. | **C16_RESULTS → Mechanical fact H4**, line 335, independently reproduced from the positive locked-change counts in Seeded arms rows 354–358.  [source: C16_1_BUILDER_ChatGPT] |
| `D_abl = {OM_LEGACY_CM, OM_LEGACY_RB, OM_CLOCKS_CM, OM_UNPARSE_CM}`. | **C16_RESULTS → Mechanical fact H5**, line 336, independently reproduced from Seeded arms plus raw fixture rows.  [source: C16_1_BUILDER_ChatGPT] |
| `H \ D_abl = {}` and therefore the frozen P1 predicate evaluates true. | **C16_RESULTS → H6**, line 337; **SPEC → Operational benefit predicate P1**, lines 72–76.  [source: C16_1_BUILDER_ChatGPT] |
| The three non-LEGACY seeds have no locked-field change. | **C16_RESULTS → H7**, line 338; **Seeded arms → OM_CLOCKS_CM, OM_BLANKTYPE_CM, OM_UNPARSE_CM**, lines 356–358.  [source: C16_1_BUILDER_ChatGPT] |
| Frozen source conditions explain why CLOCKS, BLANKTYPE, and UNPARSE have no production impact in this pack. | **SPEC → Data profile**, line 51: blank type 0, unparseable created/mod 0, mod<created 0, created>T 0.  [source: C16_1_BUILDER_ChatGPT] |
| The source is invariant across arms and no source variants were used. | **SOURCE VARIANTS**, lines 306–307; **ARM MANIFESTS**, repeated source hashes beginning line 537. |
| No-change arms retain B classification and portfolio hashes; LEGACY arms alter those hashes. | **ARM MANIFESTS → B outputs and seeded-arm outputs**, lines 546–655. |
| The identical R-B LEGACY seed yields identical R-B core output hashes in OM_LEGACY_CM and OM_LEGACY_RB. | **ARM MANIFESTS → OM_LEGACY_CM R-B outputs and OM_LEGACY_RB R-B outputs**, lines 615–618 and 633–636. |
| Every declared seeded path was executed and exited zero. | **RUN LOG**, lines 310–322; **C16_RESULTS → H3**, line 334.  [source: C16_1_BUILDER_ChatGPT] |

END C16 BUILDER REPORT
