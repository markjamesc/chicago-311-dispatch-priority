# Stage 5 Evidence Package — Chicago 311 Dispatch Priority (Dataset 2)

**Package version:** stage5-evidence-v1  
**Prepared:** 2026-09-19 CT  
**ML mode:** None  
**Conclusion ceiling:** Portfolio-simulation assignment under locked TCD-IG rules — **not** City SLA, not live dispatch, not employee scoring, not causal claims about City performance.

## File inventory (retrieved / used)

| File | Role |
|------|------|
| docs/stage-01-02-start-framing/stage1_decision.json | Start lock |
| docs/stage-01-02-start-framing/stage2_framing.json | Framing CQ-F02 |
| docs/stage-03-measurement-design/stage3_locked_design.json | Design `stage3-v1-tcd-ig` |
| docs/stage-04-execution-validation/stage4_validation_status.json | Stage 4 PASS |
| docs/stage-04-execution-validation/WORKFLOW_GATE_RECEIPT.md | Workflow gate PASS |
| validation/workflow-gate/workflow_gate_status.json | Machine gate result |
| validation/reconciliation/RECON_SUMMARY.csv | Exact recon 222002/222002 |
| validation/cross-review/structural_cross_review.md | Structural PASS |
| docs/stage-04-execution-validation/LINEAGE_ATTESTATION.md | SHA-256 lineage |
| outputs/validated_action_list.csv | Frozen ESCALATE list n=131968 |
| stage-05/deeper/portfolio_summary.csv | Deeper portfolio |
| stage-05/deeper/escalate_by_type_top25.csv | Type concentration |
| stage-05/deeper/inconclusive_by_clause.csv | INCONCLUSIVE mix |
| stage-05/deeper/kappa_sensitivity.csv | κ grid descriptive |
| stage-05/deeper/independent_checks_critical_counts.csv | Critical checks PASS |
| stage-05/deeper/capacity_coverage_note.csv | Capacity FLAG only |
| stage-05/deeper/STAGE5_DEEPER_FINDINGS.md | Deeper narrative |

## Locked decision / question

- **Decision owner:** (project) Dana Brooks simulation / Mark as methodology owner  
- **CQ-F02:** Among open eligible 311 requests in the frozen decision window, which requests should receive ESCALATE, INCONCLUSIVE, and STANDARD (one row per request) so limited shift attention can focus on unresolved requests that warrant elevation while uncertain cases are held separately, under portfolio-simulation rules (not live City dispatch, not employee scoring, without inventing an official City SLA)?

## Locked measurement (Stage 3)

- Construct: TCD-IG (type-conditional dormancy + integrity gate)  
- T_freeze: 2026-09-12 23:59:59 America/Chicago  
- Knob κ=2.0 (grid {1, 1.5, 2, 3} descriptive only)  
- W=365d, n_min=50 (constants, not knobs)  
- selected := (action == ESCALATE); **RANKING_NOT_IN_SCOPE**  
- open_age_h diagnostic only — not escalate trigger  
- Peer P75 = empirical Completed-peer statistic — never City SLA

## Validated Stage 4 facts (do not invent beyond these)

- Source Gate PASS; fixtures 14/14 both paths; exact recon **0** disagreements on 222,002 rows  
- Portfolio at κ=2: ESCALATE **131,968** (59.4%) · INCONCLUSIVE **6,377** (2.9%) · STANDARD **83,657** (37.7%)  
- All INCONCLUSIVE = `thin_type_or_missing_peer`  
- Top ESCALATE types: WCA2 64,922 (49.2% of ESCALATE); SED 17,254 (13.1%); SKA 7,316 (5.5%)  
- κ sensitivity (descriptive): ESCALATE 152,292 / 140,340 / 131,968 / 118,246 at κ=1 / 1.5 / 2 / 3  
- Clock-parse repair: first run 104-row ESCALATE/STANDARD mismatch (~5h tz); fixed; recon clean  
- Workflow gate: PASS, stage5_allowed=true

## Available decision options (simulation — for recommendation proportionality)

1. **Accept frozen labels as the Stage 5 portfolio assignment** for methodology evaluation / Dana Brooks simulation.  
2. **Accept with Framing return** on capacity: ESCALATE volume exceeds any small shift budget; ranking still out of scope unless Framing reopens.  
3. **Pilot / monitor** using ESCALATE list + type concentration (esp. WCA2) without live dispatch.  
4. **No operational action** — treat as methodology evidence only (Dataset 2 of 3).  
5. **Do not** invent City SLA, live dispatch, or employee scoring.

## Constraints

- Do not reopen Stage 3/4 locks in prose.  
- Do not claim causal City performance.  
- Human owner retains final authority.
