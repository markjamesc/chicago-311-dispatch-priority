AI 3 — Data and Risk Dossier

Blind first pass. No Design A/B or coordinator MEASUREMENT_DESIGN content used.
Scope: Chicago 311 portfolio simulation only. Not live dispatch, not employee scoring, not official City SLA.

1. Concept → field mapping feasibility
Concept	Candidate fields	Feasibility	Bounds / risks
Open	STATUS, CLOSED_DATE	Row-level feasible	STATUS='Open' ~245,193. CLOSED_DATE missing ~245,217, so open-via-status and open-via-null-closed differ by ~24. Must reconcile.
Eligible	STATUS, SR_TYPE, SR_SHORT_CODE, DUPLICATE, LEGACY_RECORD, LEGACY_SR_NUMBER, PARENT_SR_NUMBER, dates	Not feasible until eligibility rules locked	Source has fields, but “eligible” is measurement-design open. No official City SLA exists in source.
Age	CREATED_DATE vs frozen window reference	Feasible if parsing locked	Exact window dates deferred. All dates are varchar. Timezone not stated. Hour/DST-level age is not supportable without timezone rule.
Activity	LAST_MODIFIED_DATE, maybe CLOSED_DATE, status history	Partially feasible	Field exists, but “activity” semantics are not defined. LAST_MODIFIED_DATE may be post-decision if snapshot is later than frozen window.
Action	Derived label only: ESCALATE / INCONCLUSIVE / STANDARD	Output feasible, not source field	Requires decision/evidence rules and exactly one owner-tunable knob. Capacity/ranking deferred; if needed, return to Framing.
2. Key uniqueness / duplicates / legacy / parent

SR_NUMBER is unique in this snapshot: ~14,635,395 rows, 0 duplicate IDs. Good row-level key.

Conceptual request uniqueness is not guaranteed. DUPLICATE, LEGACY_RECORD, LEGACY_SR_NUMBER, and PARENT_SR_NUMBER can create parent/child, legacy, or duplicate relationships.

No distributions were provided for those flags. Without locked eligibility rules, deduping or excluding them would be invented methodology.

Provisional safe assumption: one row per SR_NUMBER; do not dedupe beyond locked eligibility rules. Exact recon is blocked until duplicate/legacy/parent treatment is locked.

3. Date-as-varchar parsing / timezone

All dates are strings, not native DATETIME.

CREATED_DATE range: ~2018-07-01 to 2026-09-12; 0 missing.

Parsing is mechanically possible if formats are consistent and locked. If mixed formats exist, TRY_CAST-style parsing may silently null or misparse.

Timezone is not specified. For date-level age, naive local wall-clock may be tolerable. For hour-level age or DST boundaries, timezone is a blocking gap.

Do not invent official SLA or official timezone semantics. Lock the parsing expression and timezone rule before R-A/R-B recon.

4. Missingness

CREATED_DATE: 0 missing.

CLOSED_DATE: ~245,217 missing; STATUS='Open' ~245,193. The ~24-row gap must be reconciled.

CLOSED_DATE missingness aligns broadly with open status but is not exact. STATUS='Open' and CLOSED_DATE IS NULL should not be treated as interchangeable until the discrepancy is explained.

Missingness for LAST_MODIFIED_DATE, WARD, COMMUNITY_AREA, LOCATION, and other fields is unknown from the packet. Profile before using them in eligibility, activity, or uncertainty rules.

5. 14.6M-row delivery / mechanical envelope strategy

Do not deliver or analyze the full 14.6M-row table in R for Stage 3.

Mechanical envelope should:

project only needed columns;

filter to the locked frozen window and locked open/eligible rules;

compute deterministic date parses, age/activity fields, missing flags, duplicate/legacy/parent flags, and row hashes;

output a narrow candidate extract, expected on the order of the open population (~245k before window/eligibility cuts, potentially much smaller).

Use chunked/columnar delivery if needed. Preserve SR_NUMBER as the stable row key.

Source Gate should produce counts: total rows, status distribution, open count, date min/max, null counts, duplicate SR_NUMBER, and candidate-window counts.

R-A/R-B should run independently on the same frozen extract, not re-query a moving source.

6. What SQL may do mechanically vs what R must judge

SQL may mechanically:

extract, filter, project, count, hash;

parse dates under a locked rule;

compute age/activity deltas under a locked reference;

flag missingness, duplicate, legacy, parent;

enforce SR_NUMBER uniqueness;

produce known-case fixture extracts.

R must judge:

eligibility semantics;

duplicate/legacy/parent treatment;

uncertainty and INCONCLUSIVE rules;

evidence thresholds and action assignment;

leakage adjudication;

sensitivity to parsing/timezone/window assumptions;

known-case fixture interpretation;

R-A/R-B reconciliation.

SQL must not decide eligibility or action labels by itself.

7. Leakage risks

Post-outcome fields: CLOSED_DATE, final STATUS, and potentially LAST_MODIFIED_DATE after the decision window.

Status contamination: if the snapshot is later than the frozen decision window, current STATUS='Open' may not equal open-at-window. The source has no status-history table in the packet. This is a major risk for historical simulation.

Window leakage: if the extract uses data modified after the decision window, activity or status fields can leak future information.

Dedup/legacy leakage: duplicate, legacy, or parent relationships may be determined after the decision point.

Target leakage: action labels derived from the same fields used as evidence require careful separation, especially if any field is post-window.

8. Exact R-A/R-B recon feasibility

Exact R-A/R-B recon is not feasible now. It becomes feasible only after locking:

exact decision window dates;

open and eligible definitions;

date parsing format and timezone;

duplicate / legacy / parent treatment;

activity definition;

evidence and action rules;

capacity/ranking rules, if any.

With those locked, recon is feasible because SR_NUMBER is unique and mechanical counts/hashes can be deterministic. Without them, R-A/R-B will diverge by construction.

9. Blocking gaps vs provisional assumptions

Blocking gaps:

exact frozen decision window dates;

open/eligible definitions;

date format and timezone;

snapshot-vs-window status contamination;

duplicate/legacy/parent treatment;

~24-row CLOSED_DATE vs Open discrepancy;

activity definition;

evidence/action rules and the single owner-tunable knob;

known-case fixtures;

capacity/ranking if ESCALATE exceeds attention — return to Framing.

Provisional assumptions:

SR_NUMBER is the row key and is unique.

STATUS='Open' is the row-level open proxy.

CLOSED_DATE IS NULL supports open status but is not identical.

CREATED_DATE is parseable.

LAST_MODIFIED_DATE is available for activity if semantics are locked.

No official City SLA is used or inferred.

One owner-tunable decision knob must remain the only tunable decision parameter.

Feasibility verdict: Supportable-with-bounds

Supportable: row-level assignment for snapshot-open 311 requests, one row per SR_NUMBER, using STATUS='Open' plus parseable core dates, under portfolio-simulation rules, after eligibility/action rules are locked.

Not supportable now: historical as-of open status without status history; exact hour-level age without timezone; conceptual dedupe without duplicate/legacy/parent rules; capacity/ranking; exact R-A/R-B recon before the blocking gaps are closed; any official City SLA claim.

Exact bounds: If the frozen decision window equals the snapshot and eligibility is limited to STATUS='Open', the dossier supports a bounded feasibility case. If the window is historical or eligibility requires duplicate/legacy/parent treatment, return to Framing/measurement design for as-of status and eligibility rules. If capacity/ranking is required, return to Framing.
