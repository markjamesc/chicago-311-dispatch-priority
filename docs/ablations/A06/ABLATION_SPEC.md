# A06 — Ablation specification (FROZEN)

**Ablation ID:** A06  
**Roles:** Builder=Grok · Validator=ChatGPT · Adjudicator=DeepSeek  
**Target:** Stage 3 integrity / INCONCLUSIVE  
**Constitution:** 1.0  

## Exact change being tested

**Proposed change:** Soften integrity-gate INCONCLUSIVE into a soft residual / STANDARD-by-default when evidence is thin (instead of hard INCONCLUSIVE for integrity fails such as thin peer).

## Benefit predicate P1

Soft residual reduces INCONCLUSIVE share and improves actionable portfolio size without increasing wrong ESCALATE labels or breaking fixtures/recon.

P1 **fails** if hard INCONCLUSIVE was necessary to quarantine thin/missing-peer and other integrity failures (Chicago: all 6,377 INCONCLUSIVE = thin_type_or_missing_peer).

## Adjudicator note

RAW MANIFEST present → do not HALT for missing historical R stdout; REVERT when P1 fails.
