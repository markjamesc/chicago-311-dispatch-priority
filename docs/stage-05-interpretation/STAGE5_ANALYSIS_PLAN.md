# Stage 5 — Deeper R analysis plan (Chicago 311)

**Status:** LOCKED for execution (post Validation Gate + workflow_gate PASS)  
**When:** 2026-09-19 CT  
**ML mode:** None (rules / TCD-IG only)  
**Frozen inputs:** `validated_action_list.csv` + R-A/R-B judged tables (SHA-256 in LINEAGE_ATTESTATION)  
**Framing:** CQ-F02 — assign ESCALATE / INCONCLUSIVE / STANDARD for Dana Brooks portfolio simulation (not live City dispatch / not SLA)

## Questions this deeper pass answers

1. How large is the ESCALATE portfolio vs INCONCLUSIVE vs STANDARD at locked κ=2?
2. Which `type_key` values dominate ESCALATE (count and share)?
3. How does the portfolio shift across the locked κ grid {1, 1.5, 2, 3}? (from frozen R-B kappa grid counts — descriptive sensitivity, not a new knob lock)
4. What integrity clauses drive INCONCLUSIVE?
5. Capacity note only: does ESCALATE volume (131,968) exceed a plausible single-shift attention budget? (FLAG for Framing return if owner wants ranking — do **not** invent ranking here)

## Out of scope

- Re-judging labels / changing κ / changing T_freeze
- City SLA claims, employee scoring, live dispatch
- Mode A/B ML
- Capacity ranking / shortlist algorithms

## Deliverables

| Artifact | Purpose |
|----------|---------|
| `deeper/portfolio_summary.csv` | Overall counts + rates |
| `deeper/escalate_by_type_top.csv` | Top type_keys in ESCALATE |
| `deeper/inconclusive_by_clause.csv` | Integrity clause mix |
| `deeper/kappa_sensitivity.csv` | Copy/confirm R-B κ grid |
| `deeper/STAGE5_DEEPER_FINDINGS.md` | Narrative for method review + memo |
| Excel pack (optional) | Charts for owner |

## Builder / review roles

- AI1 (coordinator/R): build deeper scripts against **frozen** CSVs only
- AI2: methodological critique (still CQ-F02? SLA creep?)
- AI3: implementation critique + independent checks of critical counts

## Critical independent checks (must match freeze)

- n_decision = 222,002
- n_ESCALATE = 131,968
- n_INCONCLUSIVE = 6,377
- n_STANDARD = 83,657
- validated_action_list rows = 131,968
