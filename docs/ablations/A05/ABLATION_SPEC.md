# A05 — Ablation specification (FROZEN)

**Ablation ID:** A05  
**Roles:** Builder=DeepSeek · Validator=Grok · Adjudicator=ChatGPT  
**Target:** Stage 3 (locked knob)  
**Constitution:** 1.0  

## Exact change being tested

**Proposed change:** Allow multiple owner-tunable knobs (or treat method constants W / n_min as knobs) instead of a single locked owner knob (κ).

## Benefit predicate P1

Multiple knobs improve Stage 5 portfolio usefulness (e.g. shrink ESCALATE) without harming Stage 4 exact recon / fixture Pass, with equal detection coverage.

P1 **fails** if multi-knob designs create silent Stage 4 disagreement, greenwash, or convert constants into undeclared tunables that invalidate the Design Gate lock.

## Evidence

Chicago: single κ=2 locked; W=365, n_min=50 constants; κ grid descriptive only in Stage 5; Finish Gate did not change κ.

## Adjudicator note

RAW MANIFEST present → do not HALT for missing historical R stdout; REVERT when P1 fails.
