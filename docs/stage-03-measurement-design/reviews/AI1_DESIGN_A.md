I will produce AI 1 — Primary Measurement Architect: Design A only, using the locked Start and Framing packet. I will not incorporate Design B, AI 3, coordinator decisions, production SQL/R, or hidden assumptions.

Design A — Primary Measurement Architecture
Project: Chicago 311 Dispatch Priority Simulation
Stage 3 — Measurement Design
AI 1: Primary Measurement Architect

Status: Analytical proposal only
Authority boundary: Stage 1 Start and Stage 2 Framing are locked. Measurement choices below remain proposals requiring Stage 3 owner approval.

1. Decision Context
Locked Decision

Among open eligible 311 requests in a frozen decision window, assign exactly one classification:

ESCALATE

INCONCLUSIVE

STANDARD

Each request receives one row-level decision.

Intended Decision Use

This is a portfolio simulation designed to test whether structured evidence rules can separate requests requiring elevated attention from requests that can remain under normal handling.

This is:

Not live City dispatch.

Not employee performance evaluation.

Not an official City SLA model.

Not a prediction of City policy.

2. Hypothesis
Business Hypothesis

When shift attention is limited, unresolved 311 requests can be separated into:

requests with stronger evidence of needing elevated attention,

requests where available evidence is insufficient,

requests suitable for standard handling.

A structured classification approach may improve consistency compared with treating all open requests identically.

Mechanism Hypothesis

Open requests differ in their observable characteristics:

age since creation,

evidence of continued unresolved state,

modification history,

request category/context,

geographic or operational context.

These observable signals may indicate different levels of attention need.

Observable Implication

If the hypothesis is useful:

ESCALATE requests should demonstrate stronger evidence patterns than STANDARD requests.

INCONCLUSIVE requests should contain insufficient evidence to confidently assign either elevated or standard treatment.

The classification should be reproducible from available fields.

Counterevidence

The hypothesis would weaken if:

open status primarily reflects administrative workflow rather than unresolved need,

request age does not correlate with attention need,

available fields do not contain meaningful urgency signals,

classifications are highly unstable under reasonable specification changes.

3. Population Definition
Analytical Population Proposal
Target Population

All 311 requests available within the frozen decision window that satisfy Stage 3 approved open and eligibility rules.

4. Open Definition
Proposed Open Rule

Provisional analytical rule:

A request is open if:

STATUS = 'Open'

and the request exists within the frozen snapshot boundary.

Rationale

STATUS is the strongest explicit lifecycle indicator available.

Limitation

Open status may represent:

operational unresolved work,

administrative delay,

incomplete closure processing.

Therefore:

STATUS alone should not determine escalation.

5. Eligibility Definition
Proposed Eligibility Contract

A request is eligible when:

It exists inside the frozen decision window.

It satisfies approved open criteria.

It has sufficient required evidence fields for classification.

Required Evidence Fields Proposal

Minimum:

Field	Purpose
SR_NUMBER	row identifier
SR_TYPE	request context
CREATED_DATE	age calculation
STATUS	open state
LAST_MODIFIED_DATE	activity evidence
COMMUNITY_AREA	optional segmentation
WARD	optional segmentation
6. Exclusions
Proposed Exclusions

Exclude only when necessary for analytical integrity.

Potential exclusions:

Exclusion	Reason
Missing SR_NUMBER	cannot maintain grain
Invalid creation timestamp	cannot calculate age
Records outside frozen window	violates population boundary
Explicit Non-Exclusions

Do not exclude based on:

request type,

geography,

age,

workload difficulty.

Those are potential analytical signals, not cleaning criteria.

7. Grain
Locked Analytical Grain Proposal

One row per:

SR_NUMBER
Grain Contract

Each request receives exactly:

SR_NUMBER → one classification

Allowed outputs:

ESCALATE
INCONCLUSIVE
STANDARD
8. KPI / Evidence Contract
Primary Outcome

No traditional KPI is locked because the decision is classification.

The primary measurement object is:

Dispatch Priority Classification
Evidence Domains
Domain 1 — Persistence

Question:

Has the request remained unresolved for a meaningful period?

Possible evidence:

age since CREATED_DATE

absence of CLOSED_DATE

Domain 2 — Activity

Question:

Does the request show evidence of continued attention?

Possible evidence:

LAST_MODIFIED_DATE relationship to creation date

Domain 3 — Context

Question:

Does request context affect interpretation?

Possible evidence:

SR_TYPE

SR_SHORT_CODE

geography fields

9. Comparisons / Segments
Proposed Diagnostic Segments

Not decision rules.

Used only for evaluation.

Segment A — Request Type

Purpose:

Determine whether classifications disproportionately concentrate in specific request categories.

Segment B — Age Bands

Example:

newer requests

medium-age requests

older requests

Cutoffs are:

portfolio/provisional analytical choices only

They are not City SLAs.

Segment C — Geography

Examples:

WARD

COMMUNITY_AREA

Purpose:

Detect uneven classification behavior.

10. Confounders

Potential confounders:

Factor	Risk
Request type	different workflows
Creation date	historical process changes
Geography	operational differences
Seasonal effects	changing request volume
Administrative closure behavior	STATUS may not equal unresolved reality
Missing timestamps	measurement bias
11. Data Quality Plan
Required Checks

Before classification:

Identity

Verify:

SR_NUMBER unique
Timestamp Quality

Check:

parse failures,

impossible date ordering,

missing required timestamps.

Status Quality

Confirm:

distribution of:

Open

Completed

Canceled

Closed

Missingness

Profile missingness by:

request type,

date period,

geography.

12. Decision Rule Architecture
Important Boundary

The decision rule is an analytical proposal.

It is not a City operating policy.

Proposed Three-Way Logic
ESCALATE

A request is ESCALATE when:

Evidence indicates:

The request remains open.

The available evidence suggests elevated unresolved attention need.

Confidence exceeds the approved decision threshold.

INCONCLUSIVE

A request is INCONCLUSIVE when:

evidence suggests possible attention need,

but available evidence is insufficient,

or conflicting signals exist.

Purpose:

Prevent forced decisions.

STANDARD

A request is STANDARD when:

it remains open,

evidence does not indicate elevated attention need,

and available evidence is sufficient for normal handling classification.

13. Single Owner-Tunable Decision Knob
Proposed Locked Knob
Evidence Confidence Threshold

One adjustable parameter:

confidence_threshold

Purpose:

Controls how much evidence is required before assigning ESCALATE.

Why This Knob

It directly affects the tradeoff:

Higher threshold:

fewer ESCALATE classifications,

more INCONCLUSIVE.

Lower threshold:

more ESCALATE classifications,

fewer INCONCLUSIVE.

Not Allowed as Knobs

Do not tune:

multiple urgency weights,

geographic adjustments,

employee-related factors,

hidden SLA assumptions,

capacity ranking.

14. SQL Source Delivery Contract
SQL Responsibility

SQL provides:

extraction,

joins if needed,

type-safe delivery,

nonjudgmental fields.

SQL Must Not Decide

SQL must not:

assign ESCALATE,

calculate urgency scores,

apply thresholds,

classify requests.

SQL Output Contract

Minimum delivery:

Column	Purpose
SR_NUMBER	grain
STATUS	lifecycle
CREATED_DATE	age
LAST_MODIFIED_DATE	activity
CLOSED_DATE	closure evidence
SR_TYPE	context
SR_SHORT_CODE	context
COMMUNITY_AREA	segment
WARD	segment
15. R Judged Logic Contract

R owns:

parsing,

feature creation,

evidence evaluation,

classification,

validation.

R must document:

every transformation,

every threshold,

every exclusion,

every classification reason.

16. Specification → Builder Requirements

The implementation builder needs:

Required Inputs

Frozen snapshot date.

Approved open definition.

Approved eligibility definition.

Approved evidence fields.

Approved single knob.

Approved fixture cases.

Required Outputs

A final table:

SR_NUMBER
classification
evidence_reason
rule_version
17. Fixture Requirements

Known-case fixtures required before implementation.

Fixture Categories
Fixture 1 — Clear Escalation Candidate

Example characteristics:

open,

old,

sufficient evidence of unresolved attention need.

Expected:

ESCALATE
Fixture 2 — Clear Standard Case

Example:

open,

insufficient evidence of elevated concern.

Expected:

STANDARD
Fixture 3 — Ambiguous Case

Example:

conflicting evidence.

Expected:

INCONCLUSIVE
Fixture 4 — Boundary Case

Example:

exactly near evidence threshold.

Expected:

Depends on locked knob.

18. Limitations
Measurement Limitations

The dataset does not directly measure:

actual resident harm,

urgency,

resource availability,

operational capacity.

Interpretation Limitations

A classification system may identify patterns but cannot establish:

causal urgency,

official priority,

optimal dispatch behavior.

Governance Limitations

Final operational use would require:

City policy approval,

operational validation,

stakeholder review.

19. Design Gate Self-Check
Gate 1 — Decision Alignment

PASS

Design directly supports locked ESCALATE / INCONCLUSIVE / STANDARD decision.

Gate 2 — Population Definition

PASS

Population, open definition, and eligibility are separated.

Gate 3 — Grain Integrity

PASS

One SR_NUMBER receives one classification.

Gate 4 — Measurement Validity

PASS

Evidence contracts defined without inventing SLA.

Gate 5 — Comparison Integrity

PASS

Segments are diagnostic only.

Gate 6 — Confounder Awareness

PASS

Known operational and data confounders documented.

Gate 7 — Data Quality Controls

PASS

Identity, timestamp, missingness, and status checks specified.

Gate 8 — Decision Rule Completeness

PASS

Three outcomes defined.

Gate 9 — Knob Governance

PASS

Exactly one tunable decision knob proposed.

Gate 10 — SQL/R Boundary

PASS

SQL extracts; R judges.

Gate 11 — Implementation Readiness

PASS WITH OPEN ITEMS

Architecture is ready for specification after owner approval.

AI 1 Design A Final Self-Score
Gate	Result
Gate 1 Decision Alignment	PASS
Gate 2 Population	PASS
Gate 3 Grain	PASS
Gate 4 Evidence Contract	PASS
Gate 5 Comparisons	PASS
Gate 6 Confounders	PASS
Gate 7 Data Quality	PASS
Gate 8 Decision Rules	PASS
Gate 9 Single Knob	PASS
Gate 10 SQL/R Separation	PASS
Gate 11 Builder Readiness	PASS WITH OPEN ITEMS
Open Owner Items Before Stage 3 Lock

Approve exact frozen decision window.

Approve final open definition.

Approve eligibility requirements.

Approve evidence fields.

Approve the single confidence-threshold knob.

Approve whether age/activity signals are admissible evidence.

Approve fixture expectations.

Confirm whether any capacity discussion remains deferred to later stages.

End of AI 1 Design A.
