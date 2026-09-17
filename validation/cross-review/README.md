# Structural Cross-Review

Exact R-A/R-B agreement is necessary but not sufficient.

After exact reconciliation, perform structural cross-review for shared conceptual or implementation failure modes such as:

- fragile filters;
- boundary conditions;
- date parsing;
- missing-value handling;
- accidental row loss;
- duplicated joins;
- incorrect source assumptions;
- contradictory status/date combinations;
- unauthorized analytical logic in SQL;
- and hidden dependence between R-A and R-B.

The purpose is to test whether two agreeing implementations could still be wrong for the same reason.

Status: **Not started.**
