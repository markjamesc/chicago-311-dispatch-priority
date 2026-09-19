# A03 — Ablation specification (FROZEN)

**Ablation ID:** A03  
**Roles:** Builder=Grok · Validator=ChatGPT · Adjudicator=DeepSeek  
**Target:** Stage 4 (and Stage 3 source-delivery contract language)  
**Constitution:** 1.0  

## Exact change being tested

**Proposed KEEP candidate:** Remove or soften the SQL nonjudgment bright line so SQL may precompute judged labels / eligibility / dormant thresholds (single-path SQL judgment allowed).

## Benefit predicate P1

Allowing judged logic in SQL reduces duplicated R work while Chicago’s Source Gate + dual R recon would still have caught label errors with equal coverage.

P1 **fails** if evidence shows SQL nonjudgment was necessary to keep Source Gate meaningful or to prevent judged leakage into the extract.

## Raw evidence

Use `/workspace/chicago-311-run/ablations/_raw_evidence/` MANIFEST (recon, fixtures, portfolio, lineage, stage4/workflow JSON, framework SHAs).

## Adjudicator note (harness)

If Builder/Validator agree on mechanics and RAW_EVIDENCE_MANIFEST is present, do not HALT solely for missing historical R stdout; use REVERT when P1 fails.
