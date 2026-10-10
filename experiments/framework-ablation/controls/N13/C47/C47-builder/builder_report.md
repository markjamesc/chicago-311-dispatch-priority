# C47 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for an independent first pass and am blind to the Validator’s first-pass output. The frozen role assignment is Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. The ablation is **C47, Addendum 02 candidate #47, “Small-denominator and single-unit dominance check on gating accuracy metrics,”** targeting the Stage 4 report as an accuracy-adding hardening control. The frozen Chicago 311 pack is read-only, with R-only execution and no MySQL or external data.

This report uses the frozen specification, raw arm outputs, manifests, hashes, and SEED DIFFS supplied in the packet. I make no terminal disposition.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The baseline has **no declared minimum denominator and no single-unit-share limit** for the headline metric. Conceptually, C47 therefore removes a Stage 4 **diagnostic blind spot**: a result could be based on a small ESCALATE denominator or be dominated by one `type_key` without that concentration being surfaced. It does **not** remove rows, alter classifications, or delete production logic. The new check is reporting-only: a detected concentration is written to the Stage 4 report and routed to the owner while the underlying result remains unchanged.

The SEED DIFFS show an entirely additive runner-side change set; no frozen R-A or R-B source file is patched. The added `dom_check.R` reads only `SR_NUMBER`, `type_key`, and `classification`; restricts the metric to rows whose classification is `ESCALATE`; sets `MIN_TOTAL <- 1000L`, `MIN_TYPE <- 30L`, and `MAX_SHARE <- 1/3`; computes each type’s ESCALATE share; marks a type eligible only when total ESCALATE is at least 1,000 and that type has at least 30 ESCALATE rows; and sets its flag only when the eligible type’s share is **strictly greater than** one third. It writes `DOM_TABLE.csv` plus a one-row `DOM_RESULT.csv`.

Three known-answer data files are added. `SYN_DOM60.csv` contains 13,000 rows: 10,000 ESCALATE and 3,000 STANDARD, with T01 contributing 6,000 ESCALATE rows and the remaining 4,000 distributed across T02–T10. `SYN_BAL.csv` also contains 13,000 rows: 10,000 ESCALATE and 3,000 STANDARD, with T01 the largest contributor at 1,900/10,000 = 19%. `SYN_SMALLN.csv` contains 1,200 rows: 900 ESCALATE and 300 STANDARD, with T01 at 540/900 = 60%.

`ARMS.tsv` adds five executions: the frozen R-B classifications, the frozen R-A classifications, the 60% dominance seed, the balanced seed, and the 900-row small-denominator seed. `DOMCHK` is a 37-byte marker file identifying the C47 runner-v5 dominance-check arms.

I independently reconstructed the exact textual `dom_check.R` shown in the SEED DIFFS and obtained SHA-256 `582cb7822b44ef187282c981fbd7efa1d4dea8cec9014878e2b98a92a4355145` over 2,017 bytes, exactly matching the frozen runner hash. I likewise reconstructed `ARMS.tsv` as 619 bytes with SHA-256 `b887a2d4fa959e8185f9620711312fd6b9d6ff4ad4bda42c25c17f876c6b4b0c` and `DOMCHK` as 37 bytes with SHA-256 `047e783a9c351ef1db14a3b1f4acd572d88d79498b0627b1d208a6ce9c53ee78`.

## 3. Hard mechanical facts table.

| Hard mechanical fact | Independent calculation / comparison | Result | Provenance |
| --- | --- | --- | --- |
| Number of C47 arms | Count REAL_RB, REAL_RA, SEED_DOM60, CLEAN_BAL, SMALL_N | **5** | Recomputed |
| Successful arm exits | Five raw `RUN_DOM.exit` records each contain exit `0` | **5/5 exit 0** | Recomputed |
| Sum of reported arm run times | 1.4 + 5.2 + 3.6 + 3.4 + 3.9 | **17.5 s** | Recomputed |
| SEED_DOM60 ESCALATE total | 6,000 + (8 × 445) + 440 | **10,000** | Recomputed |
| SEED_DOM60 total rows | 10,000 ESCALATE + (10 × 300 STANDARD) | **13,000** | Recomputed |
| SEED_DOM60 T01 share | 6,000 / 10,000 | **0.600000** | Recomputed |
| SEED_DOM60 other-type maximum | 445 / 10,000 | **0.044500** | Recomputed |
| SEED_DOM60 flagged-type count | T01 > 1/3; every other share ≤ 0.0445; all counts ≥30 | **1, T01** | Recomputed |
| CLEAN_BAL ESCALATE total | 1,900+1,500+1,200+1,100+1,000+900+800+700+500+400 | **10,000** | Recomputed |
| CLEAN_BAL total rows | 10,000 + (10 × 300) | **13,000** | Recomputed |
| CLEAN_BAL maximum share | 1,900 / 10,000 | **0.190000** | Recomputed |
| CLEAN_BAL flagged-type count | 0.19 < 1/3 and every remaining share is smaller | **0** | Recomputed |
| SMALL_N ESCALATE total | 540 + (9 × 40) | **900** | Recomputed |
| SMALL_N total rows | 900 + (10 × 30) | **1,200** | Recomputed |
| SMALL_N T01 share | 540 / 900 | **0.600000** | Recomputed |
| SMALL_N denominator test | 900 < 1,000 | **check not applicable** | Recomputed |
| REAL_RA number of ESCALATE types | Count of complete raw DOM table rows | **81** | Recomputed |
| REAL_RA ESCALATE total | Sum of all 81 `n_escalate` entries | **131,968** | Recomputed |
| REAL_RB ESCALATE total | Complete table is row-for-row identical to REAL_RA | **131,968** | Recomputed |
| WCA2 ESCALATE count | Raw WCA2 row | **64,922** | Quoted |
| WCA2 share | 64,922 / 131,968 | **0.4919525945683802** | Recomputed |
| WCA2 excess above the threshold | 0.4919525945683802 − 1/3 | **0.15861926123504688** | Recomputed |
| Real eligible-type count | Count full-table types having `n_escalate ≥ 30` | **54** | Recomputed |
| Real ineligible-type count | 81 − 54 | **27** | Recomputed |
| Real flagged-type count | WCA2 exceeds 1/3; next type SED = 17,254/131,968 ≈ 0.130744 | **1, WCA2** | Recomputed |
| REAL_RA vs REAL_RB DOM tables | Compare all 81 raw rows | **81/81 identical** | Recomputed |
| REAL_RA DOM_TABLE SHA-256 | SHA-256 reconstructed from verbatim 3,330-byte table | `b5a46c63d017be7e8a19162e3fafaac6bdde9082ebd828725bab539eda83a182` | Recomputed |
| REAL_RB DOM_TABLE SHA-256 | SHA-256 reconstructed from verbatim 3,330-byte table | same `b5a46c…a182` | Recomputed |
| SEED_DOM60 DOM_TABLE SHA-256 | Reconstructed from verbatim 296-byte table | `04f12e81e239654053c0c2d3bfc3b9856317520543166eacc1b1f2fab94febd0` | Recomputed |
| CLEAN_BAL DOM_TABLE SHA-256 | Reconstructed from verbatim 284-byte table | `c413e66b0bca12cc0ac0fd2d17e6c88072f87f7524ff6f2f591c107063123f52` | Recomputed |
| SMALL_N DOM_TABLE SHA-256 | Reconstructed from verbatim 424-byte table | `d579d57c895cab605040bc2f8f251c78b295efd3cc16f1fb8b778761aefd5b4e` | Recomputed |
| REAL_RA DOM_RESULT SHA-256 | Reconstructed from verbatim 311-byte output | `bdb09e93dd76eee4c82e8bf18ea53fb6a0f9cb8ef8835194d6a7f7972d9e79eb` | Recomputed |
| REAL_RB DOM_RESULT SHA-256 | Reconstructed from verbatim 311-byte output | `7bf5c0119085839d66d1a8615662756f3cd2a4b9c0daf72b984f3dc49ca8e570` | Recomputed |
| Five input before/after comparisons | Compare the full before and after SHA-256 strings separately for each arm | **5/5 equal** | Recomputed |
| REAL_RA input vs frozen reference | `c099e092…0d9` before/after equals frozen RA hash | **equal** | Recomputed |
| REAL_RB input vs frozen reference | `a0e42b86…193` before/after equals frozen RB hash | **equal** | Recomputed |
| Three planted inputs vs frozen seed hashes | BAL=`89c3…3d54`; DOM60=`eba0…14df5`; SMALL_N=`d846…44f61` | **3/3 equal** | Recomputed |
| `dom_check.R` hash across arm manifests | Each of five manifests names `582cb782…5145` | **5/5 equal** | Recomputed comparison |
| Empty stderr | Every arm manifest gives SHA-256 `e3b0c442…b855` and 0 bytes | **5/5 empty** | Recomputed comparison |
| `C47_arms.csv` evidence-file hash | Reconstructed six-line, 523-byte CSV | `2b28f2c5ca5518485a4aa55c0602fada44aaf43f6ec85a0f7776a80d415741c6` | Recomputed |
| Baseline flag count | Baseline has no dominance check | **0 by construction** | Quoted |
| `n_agree + n_disagree = n_inner` identity | No such C47 numerical table appears in the supplied evidence | **not numerically available** | Packet-scope inspection |
| Portfolio-count deltas | Portfolio artifacts occur as frozen hashes, but their count values are not supplied | **not numerically available** | Packet-scope inspection |
| D-sets | No C47 D-set table or D-set values are supplied | **not numerically available** | Packet-scope inspection |

The raw per-arm evidence supports the seed arithmetic and statuses directly. The arm manifests independently record the input/check/output hashes used above.

The instruction mentions reconciliation identities, portfolio deltas, and D-sets as examples of quantities to recompute, but C47 supplies no numerical evidence table for those quantities. The only portfolio evidence here is hash-level preflight evidence for the frozen RA/RB portfolio files, so inventing a portfolio delta from those hashes would be unsupported.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 predicate has five conjunctive conditions.

| P1 condition | Independent assessment from raw evidence |
| --- | --- |
| 1. SEED_DOM60 must flag exactly T01 | **Satisfied mechanically.** T01 = 6,000/10,000 = 0.600000 and is eligible. The other nine types are at 0.0445 or 0.0440, so none exceeds 1/3. Raw status is `FLAG`, flagged types `T01`. |
| 2. CLEAN_BAL must produce no flag | **Satisfied mechanically.** The maximum is T01 = 1,900/10,000 = 0.190000, below 1/3. Raw status is `NO_FLAG` and flagged types is empty. |
| 3. SMALL_N must be below the minimum denominator | **Satisfied mechanically.** Total ESCALATE = 540 + 9×40 = 900, below 1,000. Raw status is `NOT_APPLICABLE_BELOW_MIN_TOTAL`; no type is flagged even though T01's raw share is 0.60. |
| 4. REAL_RB and REAL_RA must both flag exactly WCA2 and have identical DOM tables | **Satisfied mechanically.** Each table contains 81 types summing to 131,968 ESCALATE rows. WCA2 = 64,922/131,968 = 0.4919525945683802 and is the sole type over 1/3. The complete tables are row-for-row identical and both reconstruct to SHA-256 `b5a46c63…a182`. |
| 5. Inputs must remain unchanged and real inputs must equal their frozen hashes | **Satisfied mechanically.** All five before/after input hashes are equal. REAL_RA matches frozen `c099e092…0d9`; REAL_RB matches frozen `a0e42b86…193`; the three seed hashes match their frozen SEEDS_b5 values. |

Thus all five P1 conjuncts are supported by the raw evidence and independent arithmetic/hash comparison. This agrees with the runner’s reported mechanical P1 result.

## 5. Fixture and reconciliation implications.

C47 does **not** add a fixture to the locked Chicago fixture pack. Instead, `SYN_DOM60`, `SYN_BAL`, and `SYN_SMALLN` serve as predeclared known-answer cases for the new reporting check. They cover positive dominance detection, a clean negative case, and suppression below the minimum total denominator respectively. The frozen specification explicitly states that the check writes nothing into the pipeline and that the planted tables are check-specific known-answer cases rather than additions to the locked fixture pack.

For the data relevant to C47, R-A and R-B reconcile exactly. Their input files are not byte-identical—their frozen SHA-256 hashes are intentionally different—but the complete resulting 81-row `DOM_TABLE.csv` files are byte-identical and independently reconstruct to the same SHA-256. Their one-row `DOM_RESULT.csv` files have different hashes because the `input` field names differ (`RA_classifications.csv` versus `RB_classifications.csv`); the substantive metric fields, WCA2 count/share, flagged type, status, and routing are the same.

The disclosed OF-1 clock discrepancy does not contaminate this reconciliation. It affects three numeric clock fields by exactly one hour during repeated fall-back-hour timestamps, but the three rows have the same classification label on both paths. C47 consumes the classification labels and `type_key`, not those clock values, so the three OF-1 rows cannot alter the C47 counts.

The preflight confirms frozen hashes for the existing RA/RB fixture-result files, portfolio-count files, classification files, R code, source extracts, and the R-B κ-grid output. C47 itself does not supply a fresh rerun of the locked fixture suite; its direct behavioral evidence consists of the three C47 known-answer tables plus exact reconciliation of the real dominance outputs.

## 6. Semantic/regression risks and unchanged surfaces.

The main residual semantic risk is **boundary-case coverage rather than ambiguity in the implementation**. The code makes the boundaries deterministic: total ESCALATE equal to 1,000 is in scope because the comparison is `>= 1000`; a type with exactly 30 ESCALATE rows is eligible because the comparison is `>= 30`; and a share exactly equal to one third is not flagged because the comparison is strictly `> 1/3`. The provided seeds exercise 10,000 and 900 total rows, type counts well above 30, and shares of 0.60 and 0.19, but they do not independently exercise exactly 1,000, exactly 30, or exactly one third. Consequently the code semantics at those boundaries are inspectable, but direct known-answer regression coverage for the exact boundaries is absent.

Likewise, the three planted tables use populated `type_key` values T01–T10 and standardized `ESCALATE`/`STANDARD` labels. They do not provide known-answer cases for missing or blank `type_key` values or nonstandard classification values. The supplied evidence therefore establishes the declared behavior on the frozen real files and declared seeds, but not arbitrary malformed-input semantics.

The regression surface is deliberately narrow. The C47 script reads one classifications CSV, computes a table, and writes only its own `DOM_TABLE.csv` and `DOM_RESULT.csv`; a flag is reporting/routing information and does not drop or rewrite rows. Direct before/after evidence verifies all five arm inputs unchanged. The runner preflight separately confirms the frozen source extracts, R-A/R-B programs, R-B component files, classifications, fixture outputs, portfolio outputs, and κ-grid output at their declared reference hashes before execution.

One governance exposure is explicitly disclosed rather than hidden: a non-reporting scratch execution occurred before the final specification freeze, and its outcome was known. The packet also states that the predicate/evaluator had been hashed before that execution and that no arm, threshold, seed, or predicate was changed afterward. That history does not alter the C47 arithmetic reported here, but it remains relevant provenance for downstream review.

## 7. Claim → evidence map. Cite the section and the table row for each claim.

| Claim | Frozen/raw evidence |
| --- | --- |
| C47 adds a Stage 4 small-denominator/single-unit dominance diagnostic without changing rows | **SPEC § Exact change being tested**, rule defining ≥1,000 total, ≥30 per type, >1/3 share, and report-only routing. |
| The experiment has five arms | **SPEC § Arms**, REAL_RB, REAL_RA, SEED_DOM60, CLEAN_BAL, SMALL_N rows; independently repeated in **SEED DIFFS § ARMS.tsv**. |
| All five arm executions returned exit 0 | **RUN LOG**, five C47 arm rows, and each raw `RUN_DOM.exit` artifact. |
| SEED_DOM60 has 10,000 ESCALATE rows and flags only T01 at 60% | **C47_RESULTS § Arms**, SEED_DOM60 row; **SEED_DOM60 DOM_TABLE**, T01 row plus T02–T10 rows; raw DOM_RESULT corroborates the total/status. |
| CLEAN_BAL has 10,000 ESCALATE rows, maximum share 19%, and no flag | **C47_RESULTS § Arms**, CLEAN_BAL row; **CLEAN_BAL DOM_TABLE**, T01–T06 rows and complete raw table. |
| SMALL_N has 900 ESCALATE rows and the check is not applicable despite T01 = 60% | **C47_RESULTS § Arms**, SMALL_N row; **SMALL_N DOM_TABLE**, T01 row and remaining type rows; raw DOM_RESULT. |
| Real R-A and R-B each contain 131,968 ESCALATE rows and flag WCA2 | **C47_RESULTS § Arms**, REAL_RA and REAL_RB rows; raw **REAL_RA DOM_RESULT** and **REAL_RB DOM_RESULT**. |
| WCA2 contributes 64,922/131,968 = 0.4919525945683802 | **REAL_RA DOM_TABLE**, WCA2 row; **REAL_RB DOM_TABLE**, WCA2 row. The ratio is independently recomputed from those two integers. |
| The real R-A and R-B dominance tables reconcile exactly | **C47_RESULTS § Arms**, identical shortened DOM-table hash; complete raw REAL_RA/REAL_RB DOM tables; **ARM MANIFESTS**, both full hashes `b5a46c63…a182`. |
| Every arm input is unchanged before versus after | Raw `INPUT_HASH_before.txt` / `INPUT_HASH_after.txt` pairs for CLEAN_BAL, REAL_RA, REAL_RB, SEED_DOM60, and SMALL_N; summarized as `input_unchanged=TRUE` in all five `C47_arms.csv` rows. |
| The real inputs match their frozen reference hashes | **SPEC § FROZEN REFERENCE HASHES** gives RA `c099e092…0d9` and RB `a0e42b86…193`; raw per-arm before/after files contain the same full hashes. |
| The C47 runner-side code is additive and its frozen `dom_check.R` hash is reproduced | **SEED DIFFS § dom_check.R**, complete 2,017-byte script; **RUNNER-SIDE FILES** lists SHA-256 `582cb782…5145`; independent reconstruction gives the same hash. |
| OF-1 cannot change the C47 metric | **SPEC § Known open finding N1 / OF-1**: three one-hour clock differences, same labels on both paths, and C47 counts labels only. |
| C47 does not numerically establish portfolio deltas, D-sets, or an `n_agree+n_disagree=n_inner` identity | Those quantities have no value tables in the C47 evidence; portfolio artifacts appear only as frozen preflight hashes. |
| All five frozen P1 conjuncts are supported by the raw evidence | **SPEC § Operational benefit predicate P1**, conditions 1–5, compared independently against the raw arm data above; **C47_RESULTS § Predicate conditions** records all five as met. |

END C47 BUILDER REPORT
