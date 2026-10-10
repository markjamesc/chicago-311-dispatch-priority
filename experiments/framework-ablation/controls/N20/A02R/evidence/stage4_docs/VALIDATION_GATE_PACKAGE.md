# Validation Gate Package — Chicago 311 Dispatch Priority

**Ask:** Approve Validation Gate to **freeze** the validated analytical labels for Stage 5.  
**Status:** PENDING OWNER  
**Prepared:** 2026-09-19 CT

## What you are freezing

| Item | Value |
|------|-------|
| design_version | `stage3-v1-tcd-ig` |
| fixture_version | `fixtures-v1-tcd-ig` |
| T_freeze | 2026-09-12 23:59:59 America/Chicago |
| κ | 2.0 |
| Decision set | 222,002 SR_NUMBER |
| ESCALATE (unordered) | 131,968 |
| INCONCLUSIVE | 6,377 |
| STANDARD | 83,657 |

Primary freeze artifact: `outputs/validated_action_list.csv` (ESCALATE list). Full judged tables remain on PC under `chicago311/R-A/outputs` and `R-B/outputs` with matching SHA-256s in `LINEAGE_ATTESTATION.md`.

## Required chain (all analytical PASS)

1. SQL Source Gate — PASS  
2. R-A fixtures — 14/14 PASS  
3. R-B fixtures — 14/14 PASS  
4. Exact R-A/R-B recon — 222,002/222,002 agree (0 disagree after clock-parse fix)  
5. Structural cross-review — PASS  
6. Lineage attestation — PASS (hashes recorded)

## Problem surfaced and repaired (for the record)

First production run: **104** rows R-A STANDARD vs R-B ESCALATE (~5h America/Chicago clock skew). Surfaced immediately; both parsers locked to character → Chicago wall; re-ran; recon clean.

## After your Clear

1. Set `stage4_validation_status.json` → overall PASS + `validation_gate: PASS`  
2. Run `Rscript validation/workflow-gate/workflow_gate.R .`  
3. Only if workflow gate PASS → Stage 5 (deeper R → reviews → interpretation)

## Approve with

> Approve Validation Gate: freeze stage3-v1-tcd-ig / fixtures-v1-tcd-ig labels at κ=2; ESCALATE n=131968; proceed to workflow_gate then Stage 5
