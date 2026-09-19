# A01 Builder Report

- **Model/mode:** ChatGPT — High reasoning (highest available on account; Pro 4/4 required upgrade)
- **CT timestamp:** 2026-09-19 14:55 CT (frozen packet: ~14:46 CT)
- **Role:** Builder ChatGPT
- **Blindness:** Independent first pass; no Validator or Adjudicator outputs seen

1. Ablation ID + Role Attestation
Ablation ID

A01 — Weakening Stage 4 Dual-Path Independence by Allowing Shared Judged Helpers

Role Attestation

Role: Builder

Assigned model: ChatGPT

Constitution version: 1.0

Ablation specification: A01 (frozen)

First-pass condition: Independent first pass

Validator outputs seen: No

Adjudicator outputs seen: No

This pack analyzes only the proposed Stage 4 change:

Allow Method B independent paths (R-A/R-B) to share judged helper modules or a common judged library, weakening the current no-shared-judged-helper independence rule.

No decision outcome is issued.

2. Proposed Framework Text Diff (Conceptual Unified Diff Against Stage 4 Independence Rules)
Current Stage 4 Independence Rule (baseline)
Diff
- R-A and R-B must implement judged logic independently.
- No shared judged helper modules.
- No copied judged ID lists.
- Independent parsing, normalization, eligibility, and classification paths
  are required before reconciliation.
- Agreement is evaluated only after independent construction.
Proposed A01 Change
Diff
+ R-A and R-B may share approved judged helper modules or a common
+ judged library.
+
+ Shared helpers may contain:
+ - timestamp normalization
+ - parsing functions
+ - eligibility utilities
+ - classification utilities
+ - common decision-rule implementations
+
+ Independent reconciliation remains required.
+ Exact recon fields remain mandatory.
+ Fixture Gate remains mandatory.
+ Validation Gate remains mandatory.
Surfaces affected

Changed:

Stage 4 Method B independence requirements.

Definition of acceptable independent-path construction.

Audit requirement for helper provenance.

Unchanged:

Stage 1 decision lock.

Stage 2 framing.

Frozen Chicago 311 artifacts.

Fixture expected labels F01–F14.

κ threshold lock.

T_freeze lock.

Exact reconciliation requirement.

3. Hard Mechanical Facts Table
Metric	Frozen Evidence Result
Decision set size (n_decision)	222,002
SR_NUMBER set identity	Identical between R-A and R-B
Post-fix agreement	222,002 / 222,002
Post-fix disagreement	0
Only R-A labels	0
Only R-B labels	0
ESCALATE count (κ=2)	131,968
INCONCLUSIVE count (κ=2)	6,377
STANDARD count (κ=2)	83,657
Fixtures executed	14
R-A fixture result	14/14 PASS
R-B fixture result	14/14 PASS
F03 expected behavior	STANDARD
Prior production disagreement	104 rows
Prior disagreement direction	STANDARD (R-A) vs ESCALATE (R-B)
Threshold distance of affected rows	Within ~5 hours of κ×p75 threshold
Detected defect source	Timestamp interpretation asymmetry
4. Benefit Predicate P1 Assessment
P1 Definition

The proposed weakening provides benefit only if:

Shared judged helpers preserve detection coverage of the 104-row near-threshold disagreement (or equivalent seeded path-asymmetry defect) while reducing duplicated judged implementation cost.

Evidence Supporting Possible Benefit
1. The defect was ultimately detectable through reconciliation

The frozen evidence shows:

R-A and R-B produced different outputs.

Exact reconciliation detected:

104 row disagreements.

STANDARD vs ESCALATE divergence.

The disagreement triggered structural investigation.

This indicates that the reconciliation layer, not only independent implementation, surfaced the existence of a production defect.

2. Shared helpers could preserve detection of some classes of defects

A shared helper architecture could still detect:

downstream integration mistakes;

misuse of helper outputs;

rule application differences outside shared code;

configuration differences;

implementation defects occurring after helper execution.

The existing exact recon requirement would remain capable of identifying output disagreement.

Evidence Against Preserved Detection Coverage
1. The specific 104-row defect depended on asymmetric implementations

The defect arose because:

R-B used a POSIXct shortcut.

R-A used force_tz.

The two paths interpreted naive timestamps differently.

The disagreement was approximately a 5-hour Chicago offset.

The resulting labels changed only near the κ×p75 boundary.

Evidence:

"Structural cross-review notes tz/force_tz asymmetry between independent paths."

The defect existed because two independent implementations provided two different interpretations of the same raw field.

2. A shared timestamp helper could remove the disagreement signal

Under the proposed weaker architecture:

Raw timestamp
      |
      v
Shared parser
      |
   +--+--+
   |     |
  R-A   R-B

Both paths would inherit the same parsing assumption.

A timestamp interpretation error inside the shared helper could produce:

Raw timestamp
      |
      v
Incorrect shared parser
      |
   +--+--+
   |     |
  R-A   R-B

Result:

identical outputs;

zero reconciliation disagreement;

defect not exposed through independence comparison.

P1 Evidence Assessment

The frozen evidence demonstrates:

exact reconciliation detected the actual 104-row defect;

the defect was caused by independent parsing asymmetry;

removing independent parsing paths could remove this detection mechanism.

Therefore:

The evidence provides support that dual-path independence contributed directly to detecting the observed defect.

The evidence does not establish that shared helpers would preserve equal detection coverage.

5. Semantic / Regression Risks
Risk 1 — Common-mode implementation failure

A shared judged library creates a larger common-mode failure surface.

Example:

Current:

R-A parser ──┐
             ├── compare outputs
R-B parser ──┘

Proposed:

       Shared parser
            |
      +-----+-----+
      |           |
     R-A         R-B

A single semantic mistake may propagate identically.

Risk 2 — Reduced ability to challenge hidden assumptions

The original design intentionally creates two independent interpretations.

The Chicago evidence demonstrates why:

timestamp semantics;

timezone interpretation;

wall-clock conversion;

were not merely coding details but decision-changing assumptions.

Risk 3 — Independence becomes audit-only rather than computational

If judged logic is shared:

the second path validates execution;

it no longer validates independent reasoning about the rule.

This changes the meaning of Method B.

Risk 4 — Possible engineering benefit

The proposed change does reduce:

duplicated parsing logic;

duplicated rule maintenance;

divergence risk from intentional code drift.

However, the frozen evidence does not quantify maintenance savings.

6. Builder Evidence Summary
Mechanical Summary

The Chicago 311 Stage 4 experiment produced:

222,002 decision rows.

Exact agreement after repair.

Zero remaining mismatches.

Identical κ=2 portfolio.

Full fixture pass.

The original disagreement consisted of:

104 rows.

STANDARD vs ESCALATE.

Caused by timezone parsing differences.

Concentrated near the decision threshold.

Interpretation Summary

The observed defect was not merely a final output mismatch.

It was a disagreement created by independent implementations interpreting raw timestamps differently.

The independence requirement therefore functioned as a detection mechanism:

Independent paths interpreted inputs.

Outputs diverged.

Exact reconciliation exposed the difference.

Structural review identified the timezone cause.

Repairs restored agreement.

Allowing shared judged helpers would likely reduce duplicated work, but the frozen evidence does not demonstrate that it preserves this specific detection capability.

7. Manifest of Claims → Evidence Citations
Claim	Evidence Source
Decision set contained 222,002 rows	EXACT_RECON_REPORT — "Decision set: 222,002 rows"
R-A and R-B agreed after fix	EXACT_RECON_REPORT — "Agree: 222,002 / 222,002"
Disagreement count became zero	EXACT_RECON_REPORT — "Disagree: 0"
Prior disagreement was 104 rows	EXACT_RECON_REPORT — "First production run disagreed on 104 rows"
Prior disagreement labels were STANDARD vs ESCALATE	EXACT_RECON_REPORT — "all STANDARD (R-A) vs ESCALATE (R-B)"
Disagreement came from timezone offset	EXACT_RECON_REPORT — "dormant_h differed by systematic ~5.0 hours"
Cause involved asymmetric timestamp handling	EXACT_RECON_REPORT — "R-B POSIXct shortcut kept wrong instant; R-A force_tz happened to recover Chicago wall digits"
Fixture suite contained 14 fixtures	EXACT_RECON_REPORT — "Fixtures: both paths 14/14 PASS"
Portfolio counts matched	EXACT_RECON_REPORT Portfolio table
Independent trees had no shared judged helpers	STRUCTURAL_CROSS_REVIEW — "Separate trees; no shared judged helper modules"
Structural review passed after repair	STRUCTURAL_CROSS_REVIEW — "Verdict: PASS"
Timestamp semantics were a Stage 4 risk	STRUCTURAL_CROSS_REVIEW §10.6 checklist
Shared judged helpers were absent in baseline	STRUCTURAL_CROSS_REVIEW — "Shared judged helpers: None. PASS"
Builder Closing Observation

The frozen evidence shows a tradeoff:

Engineering benefit: shared judged helpers may reduce duplicated implementation effort.

Validation cost: the observed Chicago 311 failure mode was exposed precisely because judged logic was independently implemented.

The available evidence demonstrates the value of independent paths for this defect class, but does not provide a measured estimate of duplicated implementation savings.
