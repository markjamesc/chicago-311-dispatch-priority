# A02 — Ablation specification (FROZEN)

**Ablation ID:** A02  
**Constitution version:** 1.0  
**Roles:** Builder=DeepSeek · Validator=Grok · Adjudicator=ChatGPT  
**Target stage(s):** Stage 3 (fixture freeze before builders) and Stage 4 (Fixture Gate enforcement)  
**Baseline SHAs:** see BASELINE_FRAMEWORK.sha256

## Exact change being tested

**Proposed canonical change:** Remove or make optional the requirement that a frozen known-case Fixture Gate must PASS before R-A/R-B production builders run (allow production-first; fixtures optional/post-hoc).

## Operational benefit predicate P1

Removing mandatory pre-builder Fixture Gate reduces steps while detection coverage remains equal: Chicago’s production clock-skew defect (104-row disagree) and construct boundaries (F03→STANDARD) would still have been caught by exact recon / other controls alone, with no increase in shipped wrong labels.

Benefit **fails** if evidence shows Fixture Gate was necessary for construct sign-off (e.g. F03) or that optional fixtures would have allowed greenwash / silent design drift.

## Critical mechanical facts

- Fixture results: R-A 14/14, R-B 14/14, F03→STANDARD  
- Production first recon: 104 disagrees; post-fix: 0  
- Fixtures use in-process clocks (did not catch CSV tz bug)

## Expected unchanged

Chicago frozen pack; κ/T_freeze; SQL nonjudgment; dual-path (A01 REVERT already kept).

## Regression

Must not authorize rewriting fixtures after fail to match code.
