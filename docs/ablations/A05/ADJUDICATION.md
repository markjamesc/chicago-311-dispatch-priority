# A05 Adjudication — ChatGPT

## Terminal decision

**REVERT**

## Constitutional assessment

- **Evidence completeness/freeze:** PASS. Builder and Validator pack hashes and the RAW MANIFEST are present; the packet explicitly says missing historical R stdout is not a HALT condition.
- **Role separation:** PASS. Builder=DeepSeek, Validator=Grok, Adjudicator=ChatGPT; Builder and Validator attest independent first passes.
- **Hard mechanical agreement:** PASS. Frozen reconciliation agrees: `n_ra=222002`, `n_rb=222002`, `n_inner=222002`, `n_only_ra=0`, `n_only_rb=0`, `n_agree=222002`, `n_disagree=0`.
- **Exact recon/fixtures:** Baseline PASS, but candidate multi-knob recon and candidate fixture results are not established.
- **Undeclared semantic change:** FAIL for KEEP. No lock amendment, Design Gate approval, configuration attestation, or knob-ownership policy authorizes converting W/n_min from constants to tunables.
- **Benefit predicate P1:** FAIL. The evidence shows only descriptive single-κ sensitivity (ESCALATE 131,968 at κ=2 vs. 118,246 at κ=3), not a validated multi-knob benefit with equal coverage and preserved Stage 4 semantics.

HALT is not appropriate: there is no role breach, missing RAW MANIFEST, or hard mechanical disagreement. Under the frozen rule, coherent evidence without proven benefit reverts. Retain the single owner knob κ with W=365 and n_min=50 as constants.
