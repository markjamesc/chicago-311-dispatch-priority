# Exact Reconciliation

R-A and R-B must reconcile exactly on every Stage 3 field marked reconciliation-critical.

At minimum the reconciliation should cover, when locked:

- final request universe size and membership;
- request key;
- in-window judgment;
- open judgment;
- eligibility judgment;
- action;
- selected flag if used;
- and all locked audit components supporting those judgments.

`SR_NUMBER` is unique in the frozen raw snapshot and may be used as the request-level reconciliation key for this snapshot.

"Close enough" is a failure. Any mismatch requires investigation, correction, rerun, and a new exact reconciliation before the project advances.

Status: **Not started.**
