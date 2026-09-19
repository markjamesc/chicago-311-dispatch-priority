# AI3 Claim-to-Evidence and Numerical Auditor

- **Model/mode:** DeepSeek — DeepThink on
- **Timestamp (America/Chicago):** 2026-09-19 14:39:07 CDT
- **Blindness attestation:** I did **not** open or read `AI1_INTERPRETATION_BUILDER.md` or `AI2_DECISION_METHOD_CRITIC.md`; this is an independent first pass auditing the supplied artifacts and numbers only.

---
AI 3 — Independent First-Pass Claim-to-Evidence and Numerical Audit

Mode: DeepThink. Blindness: AI 1 / AI 2 not seen. Audit is artifact/number-only.
ML mode: None. Conclusion ceiling: Portfolio-simulation assignment under locked TCD-IG rules; not City SLA, not live dispatch, not employee scoring, not causal City-performance claims.

1. File inventory — Used vs Listed

Status key: Used = content/claim relied on in this audit via the package text. Listed = appears in package manifest but no underlying content/hash/rows were available for independent audit.

File	Role	Audit status
docs/stage-01-02-start-framing/stage1_decision.json	Start lock	Used
docs/stage-01-02-start-framing/stage2_framing.json	Framing CQ-F02	Used
docs/stage-03-measurement-design/stage3_locked_design.json	Design stage3-v1-tcd-ig	Used
docs/stage-04-execution-validation/stage4_validation_status.json	Stage 4 PASS	Used
docs/stage-04-execution-validation/WORKFLOW_GATE_RECEIPT.md	Workflow gate PASS	Used
validation/workflow-gate/workflow_gate_status.json	Machine gate result	Used
validation/reconciliation/RECON_SUMMARY.csv	Exact recon 222002/222002	Used
validation/cross-review/structural_cross_review.md	Structural PASS	Used
docs/stage-04-execution-validation/LINEAGE_ATTESTATION.md	SHA-256 lineage	Listed-only — no SHA values shown in package
outputs/validated_action_list.csv	Frozen ESCALATE list n=131968	Used
stage-05/deeper/portfolio_summary.csv	Deeper portfolio	Used
stage-05/deeper/escalate_by_type_top25.csv	Type concentration	Used
stage-05/deeper/inconclusive_by_clause.csv	INCONCLUSIVE mix	Used
stage-05/deeper/kappa_sensitivity.csv	κ grid descriptive	Used
stage-05/deeper/independent_checks_critical_counts.csv	Critical checks PASS	Used
stage-05/deeper/capacity_coverage_note.csv	Capacity FLAG only	Used as FLAG; no numeric budget
stage-05/deeper/STAGE5_DEEPER_FINDINGS.md	Deeper narrative	Used
2. Result Inventory — material numbers with source files
Item	Value	Source file / package source
Reconciled population rows	222,002	validation/reconciliation/RECON_SUMMARY.csv
Recon disagreements	0	validation/reconciliation/RECON_SUMMARY.csv
Fixtures	14/14 both paths	stage4_validation_status.json / Stage 4 facts
ESCALATE count	131,968	outputs/validated_action_list.csv; portfolio_summary.csv
INCONCLUSIVE count	6,377	portfolio_summary.csv
STANDARD count	83,657	portfolio_summary.csv
ESCALATE share	59.4%	portfolio_summary.csv / derived
INCONCLUSIVE share	2.9%	portfolio_summary.csv / derived
STANDARD share	37.7%	portfolio_summary.csv / derived
WCA2 ESCALATE count	64,922	escalate_by_type_top25.csv
WCA2 share of ESCALATE	49.2%	escalate_by_type_top25.csv / derived
SED ESCALATE count	17,254	escalate_by_type_top25.csv
SED share of ESCALATE	13.1%	escalate_by_type_top25.csv / derived
SKA ESCALATE count	7,316	escalate_by_type_top25.csv
SKA share of ESCALATE	5.5%	escalate_by_type_top25.csv / derived
κ=1 ESCALATE	152,292	kappa_sensitivity.csv
κ=1.5 ESCALATE	140,340	kappa_sensitivity.csv
κ=2 ESCALATE	131,968	kappa_sensitivity.csv
κ=3 ESCALATE	118,246	kappa_sensitivity.csv
INCONCLUSIVE clause	All = thin_type_or_missing_peer	inconclusive_by_clause.csv
Clock-parse repair	first run 104-row ESCALATE/STANDARD mismatch (~5h tz); fixed; recon clean	Stage 4 facts / STAGE5_DEEPER_FINDINGS.md
Workflow gate	PASS, stage5_allowed=true	workflow_gate_status.json / WORKFLOW_GATE_RECEIPT.md
T_freeze	2026-09-12 23:59:59 America/Chicago	stage3_locked_design.json
κ knob	2.0; grid {1, 1.5, 2, 3} descriptive only	stage3_locked_design.json
W / n_min	W=365d; n_min=50 constants	stage3_locked_design.json
Selection rule	selected := (action == ESCALATE)	stage3_locked_design.json
Ranking	RANKING_NOT_IN_SCOPE	stage3_locked_design.json
Capacity	FLAG only	capacity_coverage_note.csv
open_age_h	diagnostic only; not escalate trigger	stage3_locked_design.json
Peer P75	empirical Completed-peer statistic; never City SLA	stage3_locked_design.json
3. Independent checks of critical values

Recomputed from counts:

Check	Calculation	Result	Package value	Verdict
ESCALATE share	131,968 / 222,002	0.594445095 = 59.4445%	59.4%	OK
INCONCLUSIVE share	6,377 / 222,002	0.028724966 = 2.8725%	2.9%	OK
STANDARD share	83,657 / 222,002	0.376829938 = 37.6830%	37.7%	OK
WCA2 share of ESCALATE	64,922 / 131,968	0.491952595 = 49.1953%	49.2%	OK
Count partition	131,968 + 6,377 + 83,657	222,002	222,002	OK
Share sum	59.4445 + 2.8725 + 37.6830	100.0000%	100%	OK
SED share of ESCALATE	17,254 / 131,968	0.1307438 = 13.0744%	13.1%	OK
SKA share of ESCALATE	7,316 / 131,968	0.0554377 = 5.5438%	5.5%	OK
κ monotonicity	152,292 > 140,340 > 131,968 > 118,246	monotone decreasing	stated	OK

Arithmetic inconsistency flag: None found in the critical values. Rounding is consistent with stated percentages.

4. Population, grain, and time-window verification vs locks
Locked element	Package evidence	Audit verdict
Population: open eligible 311 requests in frozen decision window	Recon 222,002/222,002; action counts partition to 222,002	Consistent with lock; raw eligibility filter not shown
Grain: one row per request	Action counts sum to population; CQ-F02 states one row per request	Consistent; no unique key/raw row check available
Time window: T_freeze 2026-09-12 23:59:59 America/Chicago	Stated in stage3 lock; clock-parse repair noted	Stated; min/max timestamps not shown, so not independently verifiable
Selected set	ESCALATE n=131,968; selected := action == ESCALATE	Matches lock
Ranking	RANKING_NOT_IN_SCOPE	Matches lock

Limitation: The package does not include raw row-level timestamps, eligibility SQL, or unique request IDs. Population/grain/time-window are internally consistent but not independently recomputable from the shared package alone.

5. Table-to-chart consistency

N/A. No chart artifacts are present in the evidence package. There are tables and numeric summaries, but no charts to compare against tables.

6. Model / forecast metric audit

N/A — Mode None confirmed.
No ML model, no forecast, no train/test split, no prediction metrics, no calibration/discrimination metrics. κ sensitivity is descriptive only and is not a model-selection or forecast metric.

7. Decision-rule application audit
Rule element	Audit finding
TCD-IG order	Locked construct is type-conditional dormancy + integrity gate. Package states INCONCLUSIVE all = thin_type_or_missing_peer. Full clause order/code is not exposed, so order cannot be independently verified.
selected := ESCALATE	Package uses ESCALATE n=131,968 and frozen list. Matches lock.
RANKING_NOT_IN_SCOPE	No ranking output is presented; ranking remains out of scope. Matches lock.
Decision options	Options are simulation/proportionality options only. No live dispatch, no employee scoring, no City SLA.
Human authority	Human owner retains final authority.

Limitation: TCD-IG clause-level application is only summarized; row-level rule trace is not in the package.

8. Unsupported-claim list

Claims the package does not support:

City SLA compliance, breach, or official priority.

Live dispatch, operational deployment, or real-time capacity feasibility.

Employee performance scoring or productivity ranking.

Causal claims about City performance, resolution speed, or outcome improvement.

Ranking or prioritization within ESCALATE — ranking is explicitly out of scope.

That Peer P75 is a City SLA.

That WCA2 is officially a City priority type; package only reports concentration.

That κ sensitivity is a tuned model or final model-selection evidence.

That INCONCLUSIVE means generally uncertain beyond thin_type_or_missing_peer.

That the 104-row clock-parse repair affected final labels beyond the stated fixed/recon-clean statement.

That exact recon 222,002/222,002 resolves all data-quality issues beyond row reconciliation.

That capacity is solved; package only has a capacity FLAG.

That Stage 5 recommendation is final; human owner retains authority.

9. Unvalidated-computation list

Computations not independently recomputable from the shared package:

Full TCD-IG clause evaluation per request.

Type-conditional dormancy thresholds and integrity-gate flags.

Peer P75 empirical Completed-peer computation.

W=365d and n_min=50 application details.

open_age_h diagnostic computation.

Eligibility filter producing 222,002 open requests under T_freeze.

Unique-request grain/deduplication logic.

SHA-256 lineage values from LINEAGE_ATTESTATION.md.

Capacity coverage/budget calculations; only FLAG is present.

κ grid ESCALATE counts beyond supplied package counts.

Full INCONCLUSIVE clause mix beyond “all = thin_type_or_missing_peer.”

Full top-25 ESCALATE type table beyond WCA2/SED/SKA excerpts.

Reconciliation disagreement categories beyond “0 disagreements.”

Fixture 14/14 both-path details.

Clock-parse repair before/after row-level effects beyond the 104-row mismatch note.

Any chart-based consistency — no charts present.

10. Evidence-traceability verdict

Verdict: PASS-WITH-LIMITATIONS.

Why not FAIL: Critical counts and shares are internally consistent, arithmetic checks pass, action counts partition to 222,002, and material numbers trace to listed package files.

Why not full PASS: The audit cannot independently recompute raw population, grain, time-window, TCD-IG clause order, SHA lineage, capacity coverage, or full κ-grid behavior because raw rows, full rule traces, SHA values, and charts are not in the shared package. The clock repair and capacity issue are acknowledged but not fully auditable at row level.
