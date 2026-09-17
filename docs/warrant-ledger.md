# Chicago 311 Warrant Ledger

This ledger records the basis for every material cutoff, rule, or action criterion used in the project.

Allowed basis labels:

- **source-backed**
- **stakeholder-locked portfolio requirement**
- **methodological judgment**
- **unresolved/open**

The ledger separates **translation consistency** from **substantive warrant**. Exact R-A/R-B agreement shows that the frozen specification was implemented consistently; it does not by itself prove that the underlying escalation rule is operationally justified.

| Item | Rule / cutoff | Basis | Evidence / rationale | Status |
|---|---|---|---|---|
| Decision class | `ESCALATE` / `INCONCLUSIVE` / `STANDARD` | stakeholder-locked portfolio requirement | Locked project decision class | Locked |
| Final grain | One row per request | stakeholder-locked portfolio requirement | Project decision is request-level | Locked |
| Decision window | TBD in Stage 3 | unresolved/open | Must be frozen before Stage 4 | Open |
| Open definition | TBD in Stage 3 | unresolved/open | Must distinguish source status from analytical rule | Open |
| Eligibility rule | TBD in Stage 3 | unresolved/open | Must be materially supported by source fields | Open |
| Urgency / lateness rule | TBD in Stage 3 | unresolved/open | Do not invent a City SLA | Open |
| Action rule | TBD in Stage 3 | unresolved/open | Must be frozen before builders run | Open |
| Duplicate treatment | TBD in Stage 3 | unresolved/open | Raw snapshot currently has unique `SR_NUMBER`; semantic duplicate fields may still matter | Open |
| Missing / contradictory evidence treatment | TBD in Stage 3 | unresolved/open | Must define when result becomes `INCONCLUSIVE` | Open |
| Source-delivery envelope | TBD in Stage 3 | unresolved/open | Must be bounded, faithful, and nonjudgmental | Open |
| Owner-tunable decision knob | At most one | stakeholder-locked portfolio requirement | Prevents post-hoc threshold tuning | Open |

Update this ledger as Stage 3 freezes the measurement design. Do not silently change the basis of a rule after seeing Stage 4 results.
