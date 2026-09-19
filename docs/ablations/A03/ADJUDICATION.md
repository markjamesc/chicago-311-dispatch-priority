REVERT

## Constitutional basis (A03, Constitution 1.0)

- **Role separation valid** — Builder=Grok, Validator=ChatGPT, Adjudicator=DeepSeek; first-pass outputs blind to one another. No violation shown.
- **Frozen inputs present** — A03 spec, constitution version, fixture suite reference, critical reconciliation field list, allowed scope, expected unchanged surfaces, benefit predicate P1, regression rule, and role assignment are all declared/frozen. RAW MANIFEST is present. No HALT for missing frozen inputs.
- **Raw evidence present** — `/workspace/chicago-311-run/ablations/_raw_evidence/MANIFEST.sha256` is present with SHA-256 entries. The harness note explicitly says not to HALT solely for absent historical Rscript stdout. No HALT for missing raw artifact.
- **Hard mechanical agreement** — Builder and Validator agree on the material mechanical facts:
  - reconciliation: 222,002 / 222,002 / 222,002 / 0 / 0 / 222,002 / 0;
  - Source Gate: PASS, 15 PASS, 0 FAIL, 2 INFO;
  - extract Open n=245,193; raw Open n=245,193; distinct SR_NUMBER=245,193; peer type_key n=104; peer row sum=1,881,338;
  - fixtures: 14/14 for R-A and R-B;
  - portfolio: ESCALATE 131,968; INCONCLUSIVE 6,377; STANDARD 83,657;
  - J_no_judged_columns: PASS;
  - baseline framework hash present, no candidate hash present;
  - 104 near-threshold flips from timezone/clock defect were repaired before frozen zero-disagreement recon.

  No hard mechanical conflict → no HALT under §4 or §9.
- **Semantic protection / undeclared semantic change** — No candidate implementation, candidate SQL, candidate gate output, or candidate fixture run is present. The proposed change would alter the SQL nonjudgment boundary and potentially Source Gate meaning; no evidence establishes that the semantic effect is declared, bounded, and regression-free.
- **Benefit predicate P1** — P1 fails on the frozen evidence. The evidence shows the SQL nonjudgment bright line is load-bearing for Source Gate meaning and for separating the mechanical Open envelope from the judged decision universe. The 104 near-threshold timezone flips were detected by independent R reconstruction; a SQL-judgment candidate would make recon agreement true by construction and would not preserve the same detector. No quantified reduction in duplicated R work is supplied. The explicit P1 failure hook is met: SQL nonjudgment was necessary to keep Source Gate meaningful and to prevent judged leakage into the extract.
- **KEEP rule** — Not all nine conjunctive conditions are satisfied. In particular, condition 8 (predeclared benefit predicate satisfied) fails, and condition 6 (no undeclared semantic change) is not established.
- **REVERT rule** — Mechanics are internally coherent; HALT conditions are absent; but one or more KEEP conditions are not established. This is the conservative default for unresolved soft judgment.

**Decision:** REVERT.
