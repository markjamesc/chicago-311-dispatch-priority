# Terminal Decision: REVERT

## Adjudication rationale

DeepSeek returned **REVERT**. HALT conditions are absent: the RAW MANIFEST is present, the baseline hash is consistent, role separation is valid, the benefit predicate was operationally defined, and Builder/Validator have no hard mechanical disagreement.

The frozen evidence affirmatively triggers P1's fail condition: all **6,377 INCONCLUSIVE** cases are attributed to `thin_type_or_missing_peer` (share = 1). The candidate-side behavioral evidence needed to establish safe softening is not shown, including candidate fixture results, candidate label mix, and semantic comparison. Therefore the hard INCONCLUSIVE outcome is retained for integrity failures; the proposed soft residual / STANDARD-by-default change is reverted.
