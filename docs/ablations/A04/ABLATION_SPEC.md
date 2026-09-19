# A04 — Ablation specification (FROZEN)

**Ablation ID:** A04  
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok  
**Target:** Stage 4 SQL Source Gate  
**Constitution:** 1.0  

## Exact change being tested

**Proposed change:** Remove or make optional the SQL Source Gate vs raw (trust the extract; skip formal Source Gate PASS before R builders).

## Benefit predicate P1

Skipping Source Gate reduces steps while Chicago’s dual R recon + fixtures would still have caught extract/delivery defects with equal coverage.

P1 **fails** if Source Gate was necessary to prove nonjudgmental delivery / completeness vs raw, or if skipping it would leave silent extract bugs undetectable by recon alone.

## Raw evidence

`_raw_evidence` MANIFEST including SOURCE_GATE_REPORT, recon, fixtures, stage4 JSON.

## Adjudicator note

If packs agree and RAW MANIFEST present → do not HALT for missing historical mysql stdout; REVERT when P1 fails.
