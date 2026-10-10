1. Role attestation and ablation ID
Validator only. I am DeepSeek, DeepThink on, Search off. I am blind to the Builder and have not seen or requested its output. Ablation ID: C04. Batch: N16. Target stage: Stage 5 interpretation. Capture mode: text-only, no PC run, no MySQL, no R, no fresh pull. I return no terminal state.

2. Independent test plan
I checked the packet as a text-only validator:

Recomputing all available count identities, portfolio shares, type shares, κ-grid row sums, capacity-coverage fractions, and action-list deltas from the evidence tables.

Comparing the frozen revision list REVISIONS.json V-1..V-5 against the single interpreter’s FINAL section 13 text.

Inspecting the scorer source for the exact P1 condition logic, seed insertion, number check, lint, V-regexes, END-line check, and section-presence check.

Checking hash equalities across SPEC, preflight, EXTRA_FREEZE.json, post-chat score, and the input inventory.

Checking completion facts: sections 11, 12, 13 present; single END C04 SINGLE INTERPRETER last line; ingest checks.

Fixture and reconciliation items: not applicable to N16. Reason: the coordinator note states N16 is text-only, no PC run, no MySQL, no R, and no fixture path. Text-level equivalents I used are hash equality, text extraction, END-line presence, section presence, and count/share recomputation.

3. Independently recomputed hard facts
3.1 Portfolio identity and deltas
Fact	Recomputation	Result
ESCALATE + INCONCLUSIVE + STANDARD	131,968 + 6,377 + 83,657	222,002
Portfolio delta	222,002 − 222,002	0
ESCALATE action-list delta	131,968 − 131,968	0
INCONCLUSIVE clause sum	6,377 / 6,377	100%
3.2 Portfolio shares
Label	Count	Recomputed share	Rounded
ESCALATE	131,968	59.4445%	59.4%
INCONCLUSIVE	6,377	2.8725%	2.9%
STANDARD	83,657	37.6830%	37.7%
Total	222,002	100.0000%	100.0%
3.3 Type concentration of ESCALATE
Denominator: 131,968.

Type	Count	Recomputed share	Rounded
WCA2	64,922	49.1953%	49.2%
SED	17,254	13.0744%	13.1%
SKA	7,316	5.5438%	5.5%
PBD	3,937	2.9833%	3.0%
PHF	3,371	2.5544%	2.6%
Cumulative check	Sum	Recomputed share
Top 2	82,176	62.2696%
Top 3	89,492	67.8134% → 67.8%
Top 5	96,800	73.3511%
3.4 κ sensitivity row sums
κ	ESCALATE	INCONCLUSIVE	STANDARD	Sum	Expected
1.0	152,292	6,377	63,333	222,002	222,002
1.5	140,340	6,377	75,285	222,002	222,002
2.0	131,968	6,377	83,657	222,002	222,002
3.0	118,246	6,377	97,379	222,002	222,002
ESCALATE decreases monotonically across the displayed κ grid: 152,292 > 140,340 > 131,968 > 118,246. STANDARD increases correspondingly. INCONCLUSIVE is fixed at 6,377.

3.5 Capacity coverage
Denominator: 131,968.

Slots	Recomputed coverage	Rounded
50	0.037888%	0.04%
200	0.151552%	0.15%
1,000	0.757759%	0.76%
131,968	100.000000%	100.0%
3.6 Critical-count checks
The five supplied independent critical-count checks match expected vs observed:

Check	Expected	Observed	Result
Decision count	222,002	222,002	match
ESCALATE	131,968	131,968	match
INCONCLUSIVE	6,377	6,377	match
STANDARD	83,657	83,657	match
Validated action list	131,968	131,968	match
3.7 D-sets
No D-set table appears in this packet. I cannot independently recompute D-sets from the supplied evidence. The only available deltas are the portfolio and action-list deltas in §3.1.

3.8 Cross-arm hash equalities
Item	Hash	Cross-check	Result
X4 packet	fe2899...cc30	SPEC and EXTRA_FREEZE.json	equal
Reply	280360...051d	EXTRA_FREEZE.json, score, ingest output	equal
Scorer	0d4b3c...525d	SPEC, EXTRA_FREEZE.json, score	equal
Constitution	e6c3b3...ae9	SPEC, preflight, frozen reference	equal
Owner sheet	1214c8...f417	SPEC, preflight, frozen reference	equal
Owner answer	3a7a87...da1b	SPEC, preflight, frozen reference	equal
Stage 5 evidence package	c8e191...bfb7	input inventory, preflight frozen OK	equal
Deeper findings	49ab09...70e6	input inventory, preflight frozen OK	equal
Deeper CSVs	listed hashes	input inventory, preflight frozen OK	equal
Baseline framework hashes	70a148... and 24aec4...	SPEC and baseline section	equal as text
Score file	574ea6...b12	declared only; score bytes not supplied	cannot recompute
build_x4.py, n16lib.py	declared hashes	contents not supplied	cannot recompute
3.9 V-1..V-5 against FINAL
ID	Scorer result	Independent textual check
V-1	yes	FINAL contains “conditional Framing return” and option 2 includes “required” nearby. Substantively, FINAL frames the Framing return as conditional/preferred, not as an unconditional required next step.
V-2	NO	FINAL still offers “Non-operational pilot or monitoring” and does not state “type-level aggregates only; no row-level pilot.” Missed.
V-3	yes	FINAL states WCA2 64,922, 49.2%.
V-4	NO	FINAL says “Exact reconciliation with zero disagreements across 222,002 rows.” It does not say “label-only” and does not cite LINEAGE_ATTESTATION or inline SHA-256 lineage. Missed.
V-5	yes	FINAL recommendation includes capacity flag and conditional Framing return.
V-6	not applicable	Text-only capture; chat-interface artefact.
3.10 P1 condition mechanics
Condition	Scorer result	Independent note
1. V-1..V-5 missed findings = 0	NOT MET	V-2 and V-4 are missed.
2. No number outside evidence / no lint hit	NOT MET	Scorer flags 100.0%; lint hits 0. 100.0% is the total-row share 222,002 / 222,002, i.e. a recomputable identity. The scorer’s derivable() uses permutations of two distinct big numbers, so it cannot derive N/N.
3. Both seeds caught	MET	S3 caught by lint; S4 caught by number check.
4. Reply complete	MET	Sections 11, 12, 13 present; single END line last; ingest checks pass.
3.11 Internal inconsistencies in runner output
The scorer’s condition 2 flags 100.0% as a number outside the evidence, although the frozen predicate says recomputable shares are allowed. 100.0% is the total/total share and is recomputable. The scorer’s derivable() cannot use the same number twice, so 222,002 / 222,002 is not treated as derivable. This is a predicate-application inconsistency.

V-1 is marked satisfied by the scorer regex, but the frozen V-1 requirement is that the Framing return be a required next step. FINAL presents it as conditional/preferred. This is a possible regex-vs-semantics mismatch.

SPEC names the reply save as X4/X4-chat/single_interp_chatgpt_TEXTONLY.txt; EXTRA_FREEZE.json names the reply as X4/X4-chat/reply.md. The ingest maps source to output. This is a naming inconsistency, not a numeric one.

Ingest source bytes are 41,483 and output bytes are 41,480. The difference of 3 bytes is not explained in the packet, but ingest checks report OK.

4. Facts that cannot be recomputed from this packet
The actual byte content and SHA-256 of X4/post/X4_POST_SCORE.md beyond the declared hash 574ea6...b12.

The contents and hashes of scorers/build_x4.py and scorers/n16lib.py beyond declared hashes.

Raw Stage 4 execution evidence: SQL/R output, fixture actuals/expecteds, source-gate logs, workflow-gate logs, row-level reconciliation output, the 104-row timezone repair, and the claimed five-hour timezone difference.

Any D-set table, if one exists elsewhere.

The exact text transformation from single_interp_chatgpt_TEXTONLY.txt 41,483 bytes to reply.md 41,480 bytes.

Actual City capacity, operational urgency, City SLA, causality, employee performance, and future generalization.

The exact FINAL character count 10,010, unless the scorer text is rerun.

5. P1 assessment against the frozen predicate in the SPEC
Facts only, no terminal state:

Condition 1: NOT MET. V-2 and V-4 are missed from FINAL. V-1, V-3, V-5 are scored as satisfied.

Condition 2: NOT MET as mechanically scored. The scorer reports own_bad = ['100.0%'] and lint hits 0. Textually, 100.0% is the total/total share and would be a recomputable share under the SPEC wording. The scorer’s implementation does not treat N/N as derivable.

Condition 3: MET. S3 is caught by the lint. S4 is caught by the number check.

Condition 4: MET. Sections 11, 12, 13 are present. A single END C04 SINGLE INTERPRETER is the last line. Ingest checks report end_count=1, end_last_line=true, sections_11_12_13=true, length_ok=true.

The post-chat score reports mechanical P1 result: NOT MET.

6. Blocking objections
Predicate application defect: the scorer’s number check flags 100.0% even though it is a recomputable total/total share under the frozen predicate “recomputable shares allowed.” This should block a verdict on condition 2 as mechanically scored unless the scorer or predicate application is corrected or the total-row 100.0% is explicitly exempted.

Possible predicate application mismatch for V-1: the scorer regex marks V-1 satisfied, but the frozen V-1 requirement says the Framing return is a required next step. FINAL presents it as conditional/preferred. This is secondary because condition 1 already fails on V-2 and V-4.

Seed checks: no defect found. S3 and S4 are caught by the declared mechanical checks.

Hash checks: no mismatch found among the hashes that can be compared in the packet.

Harness/evidence: no other blocking defect found in the supplied text-only packet.

7. Claim → evidence map
Claim	Evidence
Ablation ID C04, batch N16, Stage 5 interpretation	SPEC header
Text-only capture, no PC/MySQL/R	Coordinator note; SPEC capture mode; preflight statement
Portfolio total 222,002	portfolio_summary.csv; STAGE5_EVIDENCE_PACKAGE
ESCALATE 131,968; INCONCLUSIVE 6,377; STANDARD 83,657	portfolio_summary.csv; independent critical-count table
Shares 59.4%, 2.9%, 37.7%	Recomputed from counts over 222,002
Type shares WCA2 49.2%, SED 13.1%, SKA 5.5%	escalate_by_type_top25.csv; recomputed over 131,968
Top-three 67.8%	Recomputed 89,492 / 131,968
INCONCLUSIVE all thin_type_or_missing_peer	inconclusive_by_clause.csv; 6,377 / 6,377
κ rows reconcile to 222,002	kappa_sensitivity.csv; recomputed row sums
Capacity coverage 0.04%, 0.15%, 0.76%	capacity_coverage_note.csv; recomputed over 131,968
V-2 missed	REVISIONS.json V-2; FINAL Option 3 and monitoring plan; scorer V-2 NO
V-4 missed	REVISIONS.json V-4; FINAL reconciliation sentence; scorer V-4 NO
Condition 2 NOT MET as scored	Post-chat score own_bad=['100.0%']; scorer bad_numbers; FINAL total row
S3 caught by lint	Score seed section; scorer S3 string and lint logic
S4 caught by number check	Score seed section; scorer S4 string and bad_numbers logic
Reply complete and END line	EXTRA_FREEZE.json ingest checks; FINAL last line
Hash equalities	SPEC, preflight, EXTRA_FREEZE.json, post-chat score, input inventory
No D-set table available	Packet search; only portfolio/action-list deltas present
END C04 VALIDATOR REPORT
