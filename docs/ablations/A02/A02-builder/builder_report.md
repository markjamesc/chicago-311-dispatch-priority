# A02 Builder Report

- DeepThink: ON
- CT: 2026-09-19 15:28 CT
- Builder: DeepSeek
- Blindness: Independent first pass; blind to Validator pack/input

## A02 Builder — Independent First Pass

### Role attestation
I am Builder for ablation A02, DeepSeek, DeepThink ON, independent first pass. I am blind to any Validator pack and have no Validator input. I am not Adjudicator. I make no KEEP/REVERT/HALT determination in this report. Constitution version 1.0. Target stages: Stage 3 fixture freeze before builders; Stage 4 Fixture Gate enforcement.

### Conceptual framework diff
Baseline requires a frozen known-case Fixture Gate to PASS before R-A/R-B production builders run. Stage 3 therefore freezes fixtures before production; Stage 4 enforces the gate. The candidate change removes or makes optional that requirement, allowing production-first and optional/post-hoc fixtures. Operationally this shifts fixtures from a pre-builder absolute semantic gate to a later optional check. Exact recon remains a dual-path differential control; SQL nonjudgment, κ/T_freeze, Chicago frozen pack, and dual-path are expected unchanged. The key semantic difference: exact recon can detect R-A vs R-B disagreement, but it cannot detect a shared wrong construct rule if both paths agree on the same wrong labels. Known-case fixtures are the absolute check for F03→STANDARD and related construct boundaries.

### Hard mechanical facts (from frozen paste)
- R-A fixtures: 14/14 PASS, including F03→STANDARD.
- R-B fixtures: 14/14 PASS, including F03→STANDARD; F14 is F14A/F14B both STANDARD.
- Production decision set: 222,002 rows; identical SR_NUMBER sets.
- Post-fix exact recon: agree 222,002/222,002; disagree 0; only-RA/only-RB 0/0.
- Portfolio at κ=2 identical: ESCALATE 131,968; INCONCLUSIVE 6,377; STANDARD 83,657.
- First production run: 104 disagreements, all STANDARD (R-A) vs ESCALATE (R-B); peer n/p75/κ matched; dormant_h differed by systematic ~5.0 h America/Chicago offset; all within 5 h of κ×p75 threshold.
- Cause: naive SQL wall clocks tagged UTC by readr; R-B POSIXct shortcut kept wrong instant; R-A force_tz recovered Chicago wall digits. Locked rule: character → parse as America/Chicago wall; never force_tz / never trust readr POSIXct for these columns.
- Fix files: `R-A/run_RA.R` (`parse_ts_chicago`, `clock_col_types`); `R-B/R/10_io_parse.R` (`rb_parse_ts`, `rb_normalize_open`, TSV + character cols).
- Fixtures use in-process clocks and did not catch the CSV tz bug.
- Structural cross-review: PASS after repair. `design_version=stage3-v1-tcd-ig`; `fixture_version=fixtures-v1-tcd-ig`.
- Missing from paste: baseline SHAs, raw stdout/stderr, SQL/R output, file manifests, SHA-256 hashes. These are evidence gaps for constitutional verification, not adjudicated here.

### P1 assessment from evidence
P1 requires reduced steps while detection coverage remains equal: the Chicago clock-skew defect and construct boundaries F03→STANDARD would still be caught by exact recon / other controls alone, with no increase in shipped wrong labels. For the clock-skew defect, evidence supports the claim: fixtures used in-process clocks, did not catch the CSV tz bug, and exact recon caught the 104 near-threshold flips; post-fix recon is 0. For construct boundaries, evidence does not establish equal coverage. F03 is an absolute known-case fixture. Exact recon only compares R-A vs R-B. If both paths shared the same wrong construct interpretation, exact recon would show 0 disagreements and would not catch it. The paste provides no independent control proving F03 semantics outside the Fixture Gate. Under the spec’s own failure condition—if Fixture Gate was necessary for construct sign-off (e.g. F03)—P1 is not demonstrated by the provided evidence. I do not decide the outcome.

### Risks
- Silent design drift/greenwash: optional/post-hoc fixtures may allow both builders to share a wrong semantic rule; exact recon remains green.
- Fixture freeze timing: production-first may let observed production behavior influence fixture interpretation unless the regression rule is strictly enforced.
- Fixture limitation: in-process clocks cannot catch CSV/I-O tz defects; exact recon did catch this class, but another integration defect class may not be covered.
- Regression rule: must not authorize rewriting fixtures after fail to match code; optional sequencing increases temptation.
- Evidence gaps: no raw artifacts/hashes/baseline SHAs in paste; no Validator first pass yet; hard mechanical agreement not established.

### Claim → evidence map
- R-A 14/14, R-B 14/14 → RA/RB fixture tables all `pass=TRUE`.
- F03→STANDARD → both fixture tables.
- First recon 104 disagrees → EXACT_RECON prior mismatch.
- Post-fix 0 disagrees → EXACT_RECON status PASS and label agreement.
- Fixtures did not catch tz bug → EXACT_RECON cause plus spec statement on in-process clocks.
- Exact recon caught clock skew → prior mismatch section: 104 near-threshold STANDARD/ESCALATE flips.
- Construct-boundary coverage gap → F03 is absolute fixture; exact recon is differential only; no counter-evidence in paste.
- Structural PASS → STRUCTURAL verdict PASS after repair.
- SQL nonjudgment unchanged → structural checklist: SQL comments forbid labels; Source Gate checks absence of label columns.
- Regression rule → A02 spec: must not authorize rewriting fixtures after fail to match code.

No KEEP/REVERT/HALT determination made.
