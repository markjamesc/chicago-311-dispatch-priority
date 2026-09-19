DESIGN B — Independent Counter-Design

Role: AI 2 — Independent Counter-Designer

Blindness: Design A and AI 3 dossier unseen. This is a first-pass design, not an edit of another design.

Locked Start / CQ-F02: Among open eligible 311 requests in a frozen decision window, assign each request exactly one of ESCALATE, INCONCLUSIVE, or STANDARD so limited shift attention can focus on unresolved requests that warrant elevation while uncertain cases are held separately. Portfolio simulation only. Not live City dispatch. Not employee scoring. Do not invent an official City SLA.

Owner: Dana Brooks simulation / human owner approval.

Source: chicago311.raw_311_requests (~14,635,395 rows, 39 varchar columns; SR_NUMBER unique in snapshot). STATUS ≈ Open 245,193 / Completed 14.18M / Canceled ~212k / Closed 1. CREATED_DATE ~2018-07-01 to 2026-09-12; missing CLOSED_DATE ~245k. Dates stored as strings. Method B: SQL nonjudgmental extract; R judge. No City SLA in source.

0. Design B name and one-sentence claim

Type-Conditional Dormancy with Integrity Gate (TCD-IG).

A request warrants ESCALATE only if it is still open and eligible, its record is coherent enough to trust, and it has been dormant (no LAST_MODIFIED activity) for longer than the empirical closure cycle of its own SR_TYPE / SR_SHORT_CODE peers — not merely because calendar age from CREATED_DATE exceeds a global day cutoff.

1. Hypothesis

H-B. Among open eligible requests in a frozen window, the construct that matches the locked question (“unresolved requests that warrant elevation”) is forgotten-relative-to-type work, not raw open age.

Calendar age from CREATED_DATE mixes three different states: (i) long-cycle types that are supposed to stay open, (ii) tickets that crews are actively touching, and (iii) tickets that have gone silent.
LAST_MODIFIED dormancy, conditioned on the completed-peer distribution of the same type, separates (iii) from (i) and (ii).
When type history is thin, dates conflict, duplicate/parent links are unresolved, or status and closed-date disagree, the honest label is INCONCLUSIVE, not a forced ESCALATE/STANDARD.

Falsifiable prediction. If TCD-IG is measuring the intended construct, then among completed historical peers: requests that would have been labeled ESCALATE at a synthetic as-of mid-life should show a higher rate of subsequent ultra-long tails (still open far past type P90) than STANDARD cases of the same type. If ESCALATE and STANDARD have indistinguishable remaining-time distributions after the as-of cut, the dormancy construct is not doing work and the design fails.

2. Population, eligibility (measurement-open but stated), grain

Population (decision set). One row per SR_NUMBER that, at frozen as-of timestamp 
𝑇
T, is in the open-eligible set. Exact window dates and the official eligible predicate remain Framing-open; Design B requires them as inputs and does not invent them.

Working eligible skeleton (not a City rule; a simulation filter Dana must lock):

Include only if all hold:

STATUS parses to Open (case/whitespace-normalized). Completed / Canceled / Closed are out of the decision set.
DUPLICATE is not a true-like flag (true / Y / 1 / yes). Duplicate-open rows are not “the” unresolved work item; they are noise or children.
LEGACY_RECORD is not true-like or Dana explicitly includes legacy (default: exclude). Legacy rows have a different generating process.
CREATED_DATE parses to a timestamp 
≤
𝑇
≤T.
SR_TYPE or SR_SHORT_CODE is non-blank after trim.

Rows that fail (4)–(5) or have contradictory status/date facts never receive STANDARD/ESCALATE; they are INCONCLUSIVE if they otherwise look like they belong in the window, or are dropped from the decision set if they are not open.

Grain. One decision per SR_NUMBER. Parent/child clusters are not collapsed into a super-row (that would change grain and silently become a ranking/capacity design). A child with PARENT_SR_NUMBER populated is sent to INCONCLUSIVE unless the parent is itself Open and the child is a clean non-duplicate open row — still one label per child row. Cluster policy is a fixture, not a second knob.

As-of clock. Single frozen 
𝑇
T for the whole portfolio. All ages and peer windows are computed against 
𝑇
T. 
𝑇
T is an input Dana supplies with the window; Design B does not pick a calendar date.

3. Metrics (computed, not judged in SQL)

All metrics are derived. None is an official SLA.

Metric	Definition	Role
created_ts	Parsed CREATED_DATE	Clock start
mod_ts	Parsed LAST_MODIFIED_DATE; if missing, treat as integrity fail	Activity clock
closed_ts	Parsed CLOSED_DATE	Integrity only on open rows
open_age_h	
𝑇
−
T− created_ts in hours	Diagnostic only; not the decision statistic
dormant_h	
𝑇
−
T− mod_ts in hours; require mod_ts 
≥
≥ created_ts	Primary decision statistic
type_key	Coalesce(SR_SHORT_CODE, SR_TYPE) after trim	Peer group
peer_n	Count of Completed, non-duplicate, non-legacy historical rows with same type_key, closed_ts and created_ts parseable, closed_ts 
≥
≥ created_ts, created in a lookback window 
𝑊
W ending at 
𝑇
T (default 
𝑊
=
W= 365 days; not a knob — a fixed method constant Dana may change only by returning to design)	Sample-size gate
peer_p50_h, peer_p75_h	Median and 75th percentile of (closed_ts − created_ts) hours on those peers	Type-conditional cycle
thin_type	peer_n < n_min where 
𝑛
𝑚
𝑖
𝑛
=
50
n
min
	​

=50 is a fixed method constant	Integrity/uncertainty
activity_after_create	mod_ts > created_ts + 1 hour	Distinguishes touched vs never-touched
geo_missing	COMMUNITY_AREA and WARD both blank	Diagnostic, not a rule input
integrity_fail	See §4	Gate

Lookback 
𝑊
W and 
𝑛
𝑚
𝑖
𝑛
n
min
	​

 are method constants, not the owner knob. Changing them is a design change.

SQL must not compute labels. SQL emits the typed columns above plus raw identity fields.

4. Integrity gate (INCONCLUSIVE before any elevation)

A row is INCONCLUSIVE if any of:

STATUS is Open but closed_ts is parseable and non-null (contradiction).
created_ts or mod_ts unparseable, or mod_ts < created_ts.
created_ts > T (future create; snapshot/clock error).
type_key blank.
thin_type is true (cannot form a type-conditional cycle).
DUPLICATE unparseable (not clearly true or clearly false).
PARENT_SR_NUMBER populated and parent cannot be resolved in the extract to a single SR_NUMBER with known STATUS (orphan child).
STATUS string is Open-like but not in the locked Open token list Dana approves (e.g., unexpected “Open - Dup” if that token exists in extract and was not mapped).

INCONCLUSIVE is a first-class output, not a residual bin for model failure. It exists so uncertain cases are held separately, which is part of the locked question.

5. Decision rules (exactly one label per row)

Apply in order. No scoring of employees. No City SLA number.

Step 0 — Not in decision set. If not open-eligible at 
𝑇
T, do not emit a label for that row.

Step 1 — INCONCLUSIVE if integrity_fail.

Step 2 — ESCALATE if not integrity-fail and

dormant_h
≥
𝜅
⋅
peer_p75_h
dormant_h≥κ⋅peer_p75_h

where 
𝜅
κ is the single owner-tunable knob (see §6).

Interpretation: the ticket has been silent for at least 
𝜅
κ times the type’s own historical P75 closure cycle. A graffiti ticket and a building-violation ticket are not forced onto the same calendar cutoff.

Step 3 — STANDARD otherwise (open, eligible, coherent, but not dormant-relative-to-type at the current 
𝜅
κ).

No tie-break ranking inside ESCALATE. The output is an unordered partition of the decision set into three labels.

What this deliberately does not do

Does not use open_age_h as the trigger (age is reported as a diagnostic column only).
Does not use WARD / COMMUNITY_AREA equity weights (that would be a second policy question).
Does not use ORIGIN, OWNER_DEPARTMENT, or CREATED_DEPARTMENT as priority (would become employee/department scoring).
Does not import CHI311 public “average completion time” or OIG-described work-order SLAs.
6. Exactly one owner-tunable knob

Knob 
𝜅
κ — dormancy multiplier on type P75.

Domain: 
𝜅
∈
{
1.0
,
1.5
,
2.0
,
3.0
}
κ∈{1.0,1.5,2.0,3.0} as the simulation grid; continuous 
𝜅
≥
1
κ≥1 allowed if Dana wants a slider.
Default for first simulation pass: 
𝜅
=
2.0
κ=2.0.
Meaning: “How many type-cycles of silence count as warranting elevation?”
Why this and not a day cutoff: a day cutoff is the naive design this packet is written against. 
𝜅
κ stays in construct units (type cycles), so Dana tunes strictness of forgottenness, not a hidden SLA.

If Dana instead wants to tune 
𝑛
𝑚
𝑖
𝑛
n
min
	​

, 
𝑊
W, or a cap on ESCALATE count, that is a second knob or a Framing change. Design B refuses those as silent extras.

7. How Design B differs from a naive open-age-threshold approach

Naive rule: STATUS=Open and (T − CREATED_DATE) > X days → ESCALATE; else STANDARD; maybe a few ad-hoc type exceptions.

Failure of naive age	What TCD-IG does instead	Risk solved	Tradeoff
Long-cycle types (building, some trees, complex violations) flood ESCALATE even when work is on a normal path	Compares silence to that type’s completed P75	False elevation of structurally slow types	Types with no completed history cannot escalate; they go INCONCLUSIVE
Recently created but already abandoned tickets look “young”	Uses dormant_h from LAST_MODIFIED, not create-age	Missed forgotten-new work	LAST_MODIFIED can be a system touch (ETL, geocode refresh) not field work — over-activity bias
Old tickets that crews touched yesterday look “stale”	Yesterday’s modify resets dormancy	False elevation of actively worked tickets	A single heartbeat modify can hide a ticket that is otherwise stuck
Duplicates and legacy inflate the old-open pile	Integrity + duplicate + legacy gates	Counting the same hole five times	True unique issues that were only filed as dups get held, not escalated
One global 
𝑋
X secretly becomes a fake City SLA	No day threshold; 
𝜅
κ is unitless relative to empirical peers	Inventing an official SLA	Peer P75 is a historical description, not a service promise; must be labeled as such in every output table
No place for bad clocks / thin types	Explicit INCONCLUSIVE	Forced labels on garbage rows	Owner must staff a review pile; INCONCLUSIVE can be large in dirty slices

Material difference is the statistic (type-conditional dormancy vs global open age) and the third label as a gate, not a cosmetic leftover.

8. SQL vs R split (Method B)

SQL (nonjudgmental extract only)

Filter snapshot to columns needed: SR_NUMBER, SR_TYPE, SR_SHORT_CODE, STATUS, CREATED_DATE, LAST_MODIFIED_DATE, CLOSED_DATE, DUPLICATE, LEGACY_RECORD, PARENT_SR_NUMBER, COMMUNITY_AREA, WARD, OWNER_DEPARTMENT (department is diagnostic only).
Parse-or-null timestamps into typed fields; do not drop rows for parse failure (R must see them).
Build peer aggregate table: for each type_key, peer_n, peer_p50_h, peer_p75_h from Completed non-dup non-legacy rows in lookback 
𝑊
W.
Emit decision-candidate rows (STATUS Open-like) joined to peer stats.
No CASE that writes ESCALATE / INCONCLUSIVE / STANDARD.

R-A (judge / labels)

Apply integrity predicates.
Apply 
𝜅
κ rule.
Write one label per SR_NUMBER plus reason codes (integrity clause id, dormant_h, peer_p75_h, 
𝜅
κ).
Produce portfolio counts and fixture pass/fail.

R-B (challenge / sensitivity, same design)

Re-run labels at the 
𝜅
κ grid.
Leave-one-constant checks: swap P75 for P50 (diagnostic only; not a second knob in production).
Report how many labels flip; if flips are massive, construct is fragile.

No production SQL/R ships in Stage 3; only this contract and fixtures.

9. Known-case fixtures (required)

Fixtures are synthetic but field-realistic. They lock intended behavior before any warehouse run. Dates are relative to 
𝑇
T.

ID	Sketch	Expected label	Why
F01	Open pothole-like type; peer_p75 = 7d; last modify 20d ago; 
𝜅
=
2
κ=2	ESCALATE	Silent > 2× type P75
F02	Same type; created 40d ago but modified 1d ago	STANDARD	Age is large; dormancy is not
F03	Building-violation-like type; peer_p75 = 90d; dormant 100d; 
𝜅
=
2
κ=2	STANDARD	100 < 180; naive 30-day age rule would have escalated
F04	Open + CLOSED_DATE populated	INCONCLUSIVE	Contradiction
F05	LAST_MODIFIED before CREATED	INCONCLUSIVE	Clock fail
F06	Rare type, peer_n = 8	INCONCLUSIVE	Thin type
F07	DUPLICATE = true, STATUS Open, dormant 400d	Not in decision set / or INCONCLUSIVE if Dana keeps dups in set	Not the work item
F08	LEGACY_RECORD true, otherwise F01-like	Out of set under default	Different generating process
F09	Parent SR blank-missing but PARENT_SR_NUMBER set	INCONCLUSIVE	Orphan child
F10	Type with peer_p75 = 3d; created 4d ago; never modified after create; dormant 4d; 
𝜅
=
2
κ=2	STANDARD	4 < 6; new-but-not-yet-cycle
F11	Same as F10 but dormant 8d	ESCALATE	Crossed 
𝜅
×
κ× P75 without needing a large calendar age
F12	Canceled or Completed	No label	Outside decision set
F13	Unparseable CREATED_DATE, STATUS Open	INCONCLUSIVE	Cannot compute clocks
F14	Two open non-dup rows same address/type (not flagged duplicate)	Two independent labels	Grain is SR_NUMBER; Design B does not invent clustering

Owner sign-off on F01–F14 is the construct check. If Dana disagrees with F03 (wants long-cycle types escalated by raw age), Design B is the wrong design and Framing must be reopened — that disagreement is a different question (“old in days”) than CQ-F02 as written.

10. Construct validity, falsifiability, confounding

Construct. “Unresolved + warrants elevation under limited attention” operationalized as coherent open row whose silence exceeds 
𝜅
κ type-cycles.

Validity threats

LAST_MODIFIED ≠ field work. Portal writes, batch geocodes, or status-preserving ETL reset mod_ts and hide stuck work (false STANDARD). Risk named; not solvable from the 39 columns without a work-order table the packet does not grant.
Completed-peer P75 ≠ ‘should have been done.’ Slow historical performance lowers the bar for ESCALATE (a chronically slow type escalates later). This is confounding of “forgotten” with “department is generally slow.” Design B accepts it because using a tighter target would invent an SLA. Mitigation: report peer_p75_h beside every ESCALATE so Dana sees the bar.
Seasonality / storm surge. Tree debris and potholes after freeze-thaw have different cycles than the trailing 365-day mix. Fixed 
𝑊
W can mis-scale P75. Named; fixing it is a second design (seasonal peers), not a silent extra.
Selection into Completed. Only finished tickets form the peer bar. Types that almost never close produce thin_type → INCONCLUSIVE, which is conservative but can park the worst types in the hold pile forever.
Duplicate under-flagging. Unflagged multi-reports of one asset create parallel ESCALATE rows. Grain rule accepts this; capacity panic from it is a Framing issue (§11).
Survivor open stock. The 245k Open rows are a stock, not a flow. Very old opens that remain because they are unworkable (bad address, private property) will look dormant. Integrity cannot see unworkability. Fixture gap; limitation.

Falsifiability (operational)

Historical backcast: pick past 
𝑇
′
T
′
, label then-open rows, observe whether ESCALATE rows have longer remaining time-to-close (among those that later close) and higher still-open rates than STANDARD of the same type. If not, reject TCD-IG.
𝜅
κ-sweep: labels should move monotonically (higher 
𝜅
κ → fewer ESCALATE). Non-monotone movement means a coding bug, not a policy insight.
F03 vs naive: if Dana’s known cases say F03 should ESCALATE, the construct is wrong for this owner.

Confounders Design B will not “adjust away”: ward politics, origin channel, department identity, weather, work-order chain behind one SR. Adjusting those would either invent SLA-like priority or score units.

11. Capacity / ranking — return to Framing?

Yes, if and only if ESCALATE volume exceeds attention. Do not silently redefine Start.

Locked Start asks for a three-way assignment, one row per request. It defers “capacity/ranking if ESCALATE exceeds attention.” Design B therefore emits an unordered set.

If simulation at default 
𝜅
=
2
κ=2 produces more ESCALATE rows than Dana can review in a shift:

Do not add a secondary sort (open_age, ward, type harm) inside this design. That is a new decision: “which ESCALATE rows first?”
Do return to Framing with a new question, e.g. CQ-Fxx: Given the ESCALATE set from TCD-IG, impose a hard cap 
𝐶
C and a ranking statistic. That question needs its own construct (harm, equity, recency of silence, cluster collapse).
Lowering 
𝜅
κ is not a capacity tool; it changes the construct (what counts as forgotten), not the queue length under a fixed construct.

Design B flag: RANKING_NOT_IN_SCOPE. Any coordinator MEASUREMENT_DESIGN that adds a shortlist without a Framing rewrite is non-compliant with the locked packet.

12. Limitations (honest)
No work-order grain; one SR can hide many jobs (known City 311 structure). Dormancy of the SR header can be wrong for multi-job types.
String dates and mixed STATUS tokens; parse rules are part of measurement and must be fixture-locked.
Peer P75 is descriptive history, easily misread as a target. Output headers must say “empirical peer P75 (not a City SLA).”
Default drop of duplicates and legacy can hide the only surviving pointer to a real street problem.
INCONCLUSIVE may be large (thin types, dirty dates). That is a feature of the locked question, but operationally it can starve the ESCALATE list of the very types that never close.
Portfolio simulation only. Labels are not dispatch orders and are not performance scores.
13. Design Gate leaning for Design B

CONDITIONAL GO.

Answers the same locked Start/CQ-F02 with a complete grain, metric, rule, one knob, SQL/R split, and fixtures.
Does not invent a City SLA, does not score employees, does not live-dispatch.
Conditions that must be locked before a warehouse pass: frozen 
𝑇
T and window dates; Open-token list; duplicate/legacy include-exclude; confirmation that ranking stays out of scope.
Gate would flip to REVISE if Dana’s known cases treat raw calendar age as the thing to elevate (then TCD-IG is the wrong construct), or if Dana requires a capped shortlist without returning to Framing.
14. Output contract (what Dana receives)

One row per eligible SR_NUMBER:

SR_NUMBER, type_key, label, reason_code, dormant_h, peer_n, peer_p75_h, kappa, open_age_h, integrity_clause

Plus portfolio counts: n_decision, n_ESCALATE, n_INCONCLUSIVE, n_STANDARD, and the 
𝜅
κ-grid count table.

No ranked index. No department scorecard.

End of Design B. Independent of Design A. Ready for coordinator contrast on statistic (type-conditional dormancy vs alternatives), third-label gate, single knob 
𝜅
κ, and explicit return-to-Framing on capacity.
