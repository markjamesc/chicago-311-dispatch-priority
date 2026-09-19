# AI1 — Primary Measurement Architect (Stage 3)
**Mode required:** ChatGPT Chat — highest reasoning  
**Independence:** Do not see AI2/AI3 outputs. Do not write production SQL or R.

## Inputs (read-only)
- Locked Start: stage1_decision.json (ESCALATE/INCONCLUSIVE/STANDARD)
- Locked Framing CQ-F02: stage2_framing.json
- Framework: stage3-framework.md
- Master prompt Method B: controlled SQL → Source Gate → R-A/R-B
- Source-manifest + data-documentation field list
- Proposed draft (for critique/improvement, not rubber-stamp): MEASUREMENT_DESIGN.md

## Task
Produce **Design A**: complete measurement design covering hypothesis, population/open/eligible, grain, open_age_days evidence, decision rules, one knob, fixtures needs, SQL source contract (nonjudgmental), Spec→builder gates, limitations.  
Label every numeric cutoff **portfolio / provisional** — never City SLA.  
Capacity/ranking: defer (not in action rule) unless you justify returning to Framing.

## Output format
1. Keep / Revise / Replace recommendation vs coordinator draft  
2. Exact revised clauses if Revise  
3. Design Gate self-score gates 1–10  
4. Explicit WA list for owner  
5. Verdict: Pass / Pass with required revisions / Fail
