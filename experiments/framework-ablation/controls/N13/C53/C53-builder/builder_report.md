# C53 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for the independent first pass of **C53 — Addendum 02, candidate #53, “Design-time output-field completeness.”** I am blind to the Validator output and make no adjudicative determination. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The target is the Stage 3 Design Gate / Stage 4 reconciliation boundary, using the frozen Chicago 311 Dataset 2 pack, κ=2, and R-only reporting run.

The control under test requires the Design Gate to specify the value of **every output field for every outcome**, including the repeated-fall-back-hour clock rule. The baseline has no such field × outcome table.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C53 removes a **design-time specification gap**: without a complete field × outcome contract, two implementations can disagree about an output cell without any frozen rule identifying the conforming path, and an implementation defect can also escape entirely when the two paths happen to agree. The proposed control turns those cell semantics into Design-Gate requirements and checks them directly with T0–T6. In particular, the table fixes presence/value semantics for `dormant_h`, `open_age_h`, `peer_n`, `peer_p75_h`, `integrity_clause`, and `evidence_reason`, plus the first-occurrence/daylight-time rule for repeated fall-back-hour wall times. The baseline reconciliation remains an implementation-to-implementation comparison on key, classification, `dormant_h`, `open_age_h`, `peer_n`, and `peer_p75_h`.

The four seeded code changes are exactly these one-line mutations from the frozen code:

```
# U_DORMINC
labeled$dormant_h[labeled$classification == "INCONCLUSIVE"] <- NA_real_

# U_P75THIN
labeled$peer_p75_h[
  !is.na(labeled$peer_n) &
  labeled$peer_n >= 1 &
  labeled$peer_n < RB_N_MIN
] <- NA_real_

# U_PEERNBLANK
labeled$peer_n[
  !is.na(labeled$peer_n) &
  labeled$peer_n == 0L
] <- NA_integer_

# U_CLOCKLATE
amb <- !is.na(out) &
  format(out + 3600, "%Y-%m-%d %H:%M:%S") ==
  format(out, "%Y-%m-%d %H:%M:%S")
out[amb] <- out[amb] + 3600
```

Thus U_DORMINC blanks `dormant_h` on INCONCLUSIVE rows; U_P75THIN blanks `peer_p75_h` where `1 <= peer_n < RB_N_MIN`; U_PEERNBLANK converts `peer_n == 0` to blank; and U_CLOCKLATE shifts ambiguous repeated-hour timestamps by one hour to the second occurrence. These are the only seeded code mutations shown in the SEED DIFFS.

The runner-side addition `table_check.R` independently reconstructs expected clock values from frozen source text, uses tolerance `2e-6 h`, self-tests that `2025-11-02 01:30:00` resolves to epoch `1762065000`, and implements cells T0 through T6. The baseline `recon_c53.R` compares the common key set plus classification and five numeric fields with numeric tolerance `1e-6`; blank-versus-number is a mismatch.

## 3. Hard mechanical facts table.

Notation: **R = independently recomputed from packet evidence**; **Q = directly quoted because the packet does not expose enough underlying material to independently regenerate the number itself.** For reconciliation vectors, field order is `(classification, dormant_h, open_age_h, peer_n, peer_p75_h)`.

| Hard fact | Result | Status / recomputation |
| --- | --- | --- |
| Decision-set size / `n_inner` | **222,002** | **R** — T0 checks 222,002 rows and every arm has `only_ra=0`, `only_rb=0`; hence the common key population is 222,002. |
| Clean B disagreement vector | **(0, 1, 2, 0, 0)** | **R** from B `RECON_BASE`. |
| Clean B agreement vector | **(222,002, 222,001, 222,000, 222,002, 222,002)** | **R** by `n_agree = 222,002 − n_disagree`; every field satisfies `n_agree + n_disagree = n_inner`. |
| U_DORMINC disagreement vector | **(0, 6,378, 2, 0, 0)** | **R** from `RECON_BASE`. |
| U_DORMINC agreement vector | **(222,002, 215,624, 222,000, 222,002, 222,002)** | **R** by subtraction from 222,002. |
| U_P75THIN disagreement vector | **(0, 1, 2, 0, 62)** | **R** from `RECON_BASE`. |
| U_P75THIN agreement vector | **(222,002, 222,001, 222,000, 222,002, 221,940)** | **R** by subtraction. |
| U_PEERNBLANK disagreement vector | **(0, 1, 2, 6,315, 0)** | **R** from `RECON_BASE`. |
| U_PEERNBLANK agreement vector | **(222,002, 222,001, 222,000, 215,687, 222,002)** | **R** by subtraction. |
| U_CLOCKLATE disagreement vector | **(0, 0, 0, 0, 0)** | **R** from `RECON_BASE`. |
| U_CLOCKLATE agreement vector | **(222,002, 222,002, 222,002, 222,002, 222,002)** | **R** by subtraction. |
| Clean B mismatch D-set | **3 field/ID pairs on 3 rows** | **R**: `{dormant_h × SR22-01936870, open_age_h × SR25-02017553, open_age_h × SR25-02017556}`. |
| U_DORMINC `D+ = M_arm \ M_B` | **6,377 new** `dormant_h` **mismatches** | **R**: `6,378 − 1 = 6,377`; no other mismatch count increases. |
| U_DORMINC `D− = M_B \ M_arm` | **0** | **R**: all three clean mismatches remain. |
| U_P75THIN `D+` | **62 new** `peer_p75_h` **mismatches** | **R**: baseline `0 → 62`. |
| U_P75THIN `D−` | **0** | **R**: clean `dormant_h=1` and `open_age_h=2` remain. |
| U_PEERNBLANK `D+` | **6,315 new** `peer_n` **mismatches** | **R**: baseline `0 → 6,315`. |
| U_PEERNBLANK `D−` | **0** | **R**: all three clean mismatches remain. |
| U_CLOCKLATE `D+` | **0** | **R**: no reconciliation field has a new mismatch. |
| U_CLOCKLATE `D−` | **3** | **R**: `dormant_h: 1 → 0`, `open_age_h: 2 → 0`; exactly the three N1 field/ID pairs are removed. |
| B total table violations | **0** | **R**: all T0–T6 violation counts are zero. |
| U_DORMINC total table violations | **6,377** | **R**: T1a contributes 6,377 and every other cell contributes zero. |
| U_P75THIN total table violations | **62** | **R**: T4 contributes 62 and all other cells zero. |
| U_PEERNBLANK total table violations | **6,315** | **R**: T3 contributes 6,315 and all other cells zero. |
| U_CLOCKLATE total table violations | **3** | **R**: T1c `1` + T2c `2` = `3`. |
| Total seeded-arm violations | **12,757** | **R**: `6,377 + 62 + 6,315 + 3 = 12,757`. |
| T5 partition identity | **215,625 + 6,377 = 222,002** | **R**: ESCALATE/STANDARD rows plus INCONCLUSIVE rows exhaust the decision rows. |
| Clean dormant clock partition | **222,001 + 1 = 222,002** | **R**: ordinary-hour T1b rows plus repeated-hour T1c row. |
| Clean open-age clock partition | **222,000 + 2 = 222,002** | **R**: ordinary-hour T2b rows plus repeated-hour T2c rows. |
| U_DORMINC dormant partition | **215,624 + 1 + 6,377 = 222,002** | **R**: checked nonambiguous values + repeated-hour value + blanked T1a violations. |
| Frozen R-A counted table violations | **215,628** | **R**: `215,625 + 1 + 2 = 215,628`; T6 is absent and recorded as `NA`, not added. |
| κ=1 identity | **152,292 + 6,377 + 63,333 = 222,002** | **R**. |
| κ=1.5 identity | **140,340 + 6,377 + 75,285 = 222,002** | **R**. |
| κ=2 identity | **131,968 + 6,377 + 83,657 = 222,002** | **R**. |
| κ=3 identity | **118,246 + 6,377 + 97,379 = 222,002** | **R**. |
| κ=2 portfolio total | **222,002 decision rows** | **R**: `131,968 + 6,377 + 83,657 = 222,002`. |
| Portfolio including out-of-set | **245,193 rows** | **R**: `222,002 + 23,191 = 245,193`. |
| Seeded-arm portfolio delta vs B | **(0,0,0,0,0)** for `(decision, ESCALATE, INCONCLUSIVE, STANDARD, out_of_set)` in every seed | **R** from identical portfolio rows and identical portfolio SHA-256 across all five R-B arms. |
| κ-grid delta vs B | **0 in every count cell for every seeded arm** | **R** from identical four-row κ-grid outputs and identical SHA-256 across all five arms. |
| Fixture rows per arm | **14** | **R** from F01–F14. |
| Fixture passes per arm | **14/14** | **R**: every raw fixture row has `pass=TRUE`. |
| Fixture hash equality across B + four seeds | **1 unique hash across 5 arms** | **R**: all equal `0d72245c…e9e9`. |
| κ-grid hash equality across B + four seeds | **1 unique hash across 5 arms** | **R**: all equal `7a18fcb1…2c8a`. |
| Portfolio hash equality across B + four seeds | **1 unique hash across 5 arms** | **R**: all equal `eb677bc1…673c`. |
| Classification-output hashes across B + four seeds | **5 distinct hashes** | **R** from manifests; B matches frozen exactly, while each seeded classification file differs bytewise as expected from its cell mutation. |
| Clean B four key-output hash matches to frozen references | **4/4** | **R**: classifications, fixtures, portfolio counts and κ-grid hashes equal their frozen reference hashes byte-for-byte. |
| Per-row classification mismatches vs frozen R-A | **0 in all five R-B arms** | **R** from all five reconciliation tables; with identical key sets, all arms therefore have the same classification labels as B/frozen R-B despite altered non-label cells. |
| Large D-set full membership independently enumerable from packet text | **No** | **Q limitation**: large `RECON_IDS.csv` files are summarized in the packet; their counts and SHA-256 values are supplied, but the complete thousands-of-ID lists are not printed. The cardinalities above are nevertheless independently derivable from the full-field mismatch counts. |

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

**Condition 1 — every seeded arm is flagged by the table check, with no ruling required by the variant.** Established by the raw table checks: U_DORMINC has 6,377 T1a violations; U_P75THIN has 62 T4 violations; U_PEERNBLANK has 6,315 T3 violations; U_CLOCKLATE has one T1c plus two T2c violations. Thus all **4/4** seeded arms are mechanically flagged by a table cell whose prescribed value identifies the R-B output as defective.

**Condition 2 — baseline must leave at least one seed unsettled or undetected without the table.** Established. Three seeds introduce new path disagreements: `dormant_h:+6377`, `peer_p75_h:+62`, and `peer_n:+6315`; without the table the reconciliation exposes disagreement but does not identify which implementation is conforming. U_CLOCKLATE introduces **no** new path disagreement and instead eliminates all three clean N1 mismatches, so under the baseline comparison it escapes.

**Condition 3 — clean B has zero table violations and all four key R-B outputs equal frozen.** Established. Every B T0–T6 violation count is zero. The B output hashes for classifications, fixtures, κ-grid counts and portfolio counts equal the frozen reference hashes byte-for-byte.

**Condition 4 — seeds alter table cells without changing labels, portfolio, κ-grid or fixtures.** Established. All seeded arms have zero classification mismatches against the same frozen R-A key population, so their labels equal the clean B labels. All four seeded arms also reproduce the same fixture, κ-grid and portfolio hashes as B/frozen R-B. Their classification-file hashes differ, confirming that the seeded cell changes themselves were actually emitted.

Accordingly, the evidence establishes **all four frozen P1 conditions as written**. This is a predicate assessment only; no adjudicative terminal state is supplied. The packet's own generated predicate table independently records the same four conditions as met.

## 5. Fixture and reconciliation implications.

The fixtures remain completely invariant across the experiment: each arm contains **14 fixture rows, F01–F14, all passing**, and all five R-B arms have exactly the same fixture-file SHA-256. Therefore the existing locked fixture suite does not distinguish any of the four seeded output-cell defects in this experiment.

That result matters differently for the first three seeds and U_CLOCKLATE. U_DORMINC, U_P75THIN and U_PEERNBLANK still become visible through full-field R-A/R-B reconciliation, but reconciliation supplies only the fact of disagreement. The design table supplies the missing normative fact about the required cell value, converting those disagreements into mechanically settled table violations.

U_CLOCKLATE demonstrates the stronger case. Clean B differs from frozen R-A on exactly three known fall-back-hour rows because B uses the first occurrence while frozen R-A uses the second. The U_CLOCKLATE seed changes R-B to the second occurrence, so it becomes **perfectly equal to R-A on every reconciled field**. Thus implementation-to-implementation agreement improves from three mismatch pairs to zero precisely while the seeded path moves away from the approved design rule. The table check still identifies all three errors—one T1c and two T2c.

This is the principal reconciliation implication of C53: **cross-path equality is not itself proof of design conformance**. A frozen field × outcome contract supplies an external semantic reference capable of detecting a defect even when both compared implementations agree.

The INFO checks reinforce the same point. Frozen R-B has zero table violations, whereas frozen R-A has one T1c clock violation, two T2c clock violations, 215,625 T5a violations because it writes an integrity clause on ESCALATE/STANDARD rows, and no T6 column. Those INFO results are pre-existing characteristics of frozen R-A, not seeded changes.

## 6. Semantic/regression risks and unchanged surfaces.

The principal **unchanged surfaces** are strong and mechanical. Every seed preserves the 222,002-row decision population, all classification labels, the full κ-grid, the κ=2 portfolio counts, and all fixture results. Input source hashes and unchanged R-B modules remain frozen; the seeded classification CSV differs only because the intended table-cell mutations are emitted. The three aggregate outputs—fixtures, κ-grid and portfolio—are byte-identical across B and all four seeds.

The first semantic risk is **checker correctness and synchronization**. Once the table becomes authoritative, `table_check.R` must remain a faithful executable representation of that frozen table. Its clock self-test, independent reconstruction from source text, explicit presence rules, and frozen hash materially reduce that risk, but a later divergence between the design table and checker would itself become a governance problem.

The second risk is **false confidence from agreement-only reconciliation**. U_CLOCKLATE is direct evidence: a seed can make two implementations agree more closely while violating the approved semantic rule. Thus a zero cross-path mismatch count cannot substitute for an independently frozen output contract.

The third risk is **coverage asymmetry between reconciliation and the table**. `recon_c53.R` compares only fields available in both paths. `evidence_reason` is R-B-only, so the baseline reconciliation cannot test T6 at all. The table can. Frozen R-A explicitly lacks that column.

The fourth risk is **misinterpreting N1 as a seeded effect**. The three repeated-hour differences were disclosed before execution, are present in clean B, and must be subtracted when constructing each seeded arm's new mismatch set. U_CLOCKLATE removes those three differences; without the clean-arm subtraction rule its escape behavior could be misread.

The fifth limitation is that **design-time cost was not measured**. The packet explicitly states there was no Stage 3 design chat for this run, so the approximately 29-minute PricePoint historical evidence is contextual rather than an experimentally measured C53 cost result.

Finally, all reporting-arm R-B runs, table checks and reconciliations exited successfully. The identical parser warning shown in each R-B stderr tail is an unchanged cross-arm warning rather than a seed-specific regression signal. The frozen outputs and relevant runner-side files were hash-gated before execution.

## 7. Claim → evidence map.

| Claim | Packet section and exact evidence row(s) |
| --- | --- |
| C53 tests a Design-Gate requirement specifying every output field for every outcome. | `SPEC §Control under test` and `§Exact change being tested`, variant/baseline rows. |
| Clean B conforms to all tested table cells. | `C53_RESULTS.md §Per-arm table check → B`, rows **T0–T6**, each violations=`0`. |
| U_DORMINC is detected exactly at T1a on 6,377 rows. | `§Per-arm table check → U_DORMINC`, row **T1a**; `§Arms`, row **U_DORMINC**. |
| U_P75THIN is detected exactly at T4 on 62 rows. | `§Per-arm table check → U_P75THIN`, row **T4**; `§Arms`, row **U_P75THIN**. |
| U_PEERNBLANK is detected exactly at T3 on 6,315 rows. | `§Per-arm table check → U_PEERNBLANK`, row **T3**; `§Arms`, row **U_PEERNBLANK**. |
| U_CLOCKLATE is detected at T1c/T2c on exactly three rows. | `§Per-arm table check → U_CLOCKLATE`, rows **T1c** and **T2c**; `§Arms`, row **U_CLOCKLATE**. |
| Clean B's reconciliation baseline consists exactly of the three disclosed N1 differences. | `§Per-arm baseline recon → B`, rows **dormant_h=1** and **open_age_h=2**; `SPEC §Known open finding N1 / OF-1`. |
| The baseline surfaces U_DORMINC, U_P75THIN and U_PEERNBLANK as new disagreements. | `§Per-arm baseline recon`, rows **dormant_h=6378**, **peer_p75_h=62**, **peer_n=6315**, compared with clean counts `1,0,0`; `§Arms` corresponding baseline-outcome rows. |
| The baseline does not expose U_CLOCKLATE as a new disagreement; the seed instead removes all three clean N1 mismatches. | `§Per-arm baseline recon → U_CLOCKLATE`, all five fields `0`; `§Arms`, row **U_CLOCKLATE**, `clean_mismatches_removed=dormant_h:-1/open_age_h:-2`. |
| All seeds preserve labels and aggregate decision counts. | `§Arms`, all seeded rows: `labels_equal_frozen=TRUE`, `portfolio_grid_fixtures_equal_frozen=TRUE`; corroborated by zero classification reconciliation mismatch and identical portfolio/κ hashes in `ARM MANIFESTS`. |
| All 14 locked fixtures pass in B and remain byte-identical in every seeded arm. | `RAW PER-ARM FILES → B/RB_fixture_results.csv`, rows **F01–F14**, all `pass=TRUE`; `ARM MANIFESTS`, each arm's `RB_fixture_results.csv` hash=`0d72245c…e9e9`. |
| The κ=2 portfolio is 131,968 ESCALATE, 6,377 INCONCLUSIVE, 83,657 STANDARD, totaling 222,002 decisions with 23,191 out-of-set. | `RAW PER-ARM FILES → B/RB_portfolio_counts.csv`, κ=2 row; arithmetic recomputation `131968+6377+83657=222002`. |
| B's four key output files are byte-equal to the frozen references. | `FROZEN REFERENCE HASHES`, R-B classification/fixture/portfolio/κ-grid rows, compared with `ARM MANIFESTS → B out` corresponding four rows. |
| Seeded classification files genuinely changed while fixture, κ-grid and portfolio files did not. | `ARM MANIFESTS`, each seeded arm: distinct `RB_classifications.csv` hash; identical fixture, κ-grid and portfolio hashes. |
| Frozen R-A's table differences are pre-existing INFO findings, not seed effects. | `C53_RESULTS.md §INFO → FROZEN_RA`, rows **T1c=1, T2c=2, T5a=215625, T6 absent**; `SPEC §Known open finding N1 / OF-1`. |
| The four frozen P1 conditions are all established by the mechanical evidence. | `SPEC §Operational benefit predicate P1`, conditions 1–4, cross-checked against `C53_RESULTS.md §Predicate conditions`, rows **1–4**. |

END C53 BUILDER REPORT
