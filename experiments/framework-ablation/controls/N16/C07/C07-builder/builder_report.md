1. Role attestation and ablation ID
Role: Builder — ChatGPT, independent first pass
Ablation ID: C07
Batch: N16
Owner control: #7 — Framing gate: exactly one question (ledger replay)
Constitution: Version 1.0
Target stage: Stage 1–2 Framing
Method: Frozen-ledger replay, text only
Reporting date: 2026-10-09 CT
Independence attestation
I am acting solely as the Builder.
- This assessment is independent of the Validator's first-pass findings.
- I have not received or relied on a Validator report.
- I have not assumed the Adjudicator role.
- I have used the supplied frozen specification, scorer, results, evidence tables, and verbatim Stage 1–5 documents.
- I have not modified the frozen evidence, scorer, constitution, or benefit predicate.
- This report provides mechanical findings and semantic assessment without issuing a terminal adjudication.
Scope limitation: C07 is a retrospective text-level analysis, not a newly executed Chicago 311 workflow. No SQL, MySQL, R, fresh data retrieval, independent three-model workflow execution, or PC-based ablation was performed.
The packet reports the N16 preflight as PASS with zero failures. That is supplied provenance evidence, not an independently repeated verification of the original frozen files.
2. Conceptual diff: removal and seeded code changes
Baseline control
The baseline Framing gate requires exactly one locked candidate decision question.
The Chicago 311 framing sequence records:
- CQ-DRAFT-01: provisional Start-era candidate.
- CQ-F01: Dana-confirmed Framing candidate, awaiting subsequent reviews and owner approval in the Stage 1–2 ledger.
- CQ-F02: the final question identified as locked in the Stage 3 design and Stage 5 evidence package.
The question concerns assigning each open eligible Chicago 311 request exactly one classification: ESCALATE, INCONCLUSIVE, or STANDARD.
Supporting issues—time-window definition, eligibility, urgency rules, SLA interpretation, and capacity—are treated as definitions, design work, limitations, or return-to-Framing triggers rather than additional simultaneously locked decision questions.
Conceptual variant
C07 examines a relaxation permitting up to three locked questions, instead of exactly one.
The intended distinction is:
Dimension	Baseline	Conceptual variant
Framing question limit	Exactly 1	Up to 3
Primary decision	Three-way request classification	Same primary decision
Additional substantive questions	Defer to Stage 3 or later	Potentially lock alongside primary
Evaluation	Existing real Chicago ledgers	Replay of deferred questions
Evidence source	Frozen Stage 1–5 records	Identical frozen records
Counterfactual workflow	Not applicable	Not executed
Stage 3/5 artifacts	Frozen	Unchanged
The replay asks whether additional substantive questions arose and whether they disappeared before the locked Stage 3 design or Stage 5 outputs.
Exact seeded code changes
Seed files: none.
The SPEC explicitly records (none) under Seed files. No SEED DIFFS containing a code patch, changed framework file, or executable modification is supplied.
Accordingly:
1. No baseline code was replaced.
2. No multi-question Framing gate was implemented.
3. No new set of three questions was locked.
4. No existing Stage 3 or Stage 5 artifact was regenerated under altered Framing rules.
The supplied scorer, scorers/score_c07.py, performs the replay using these declared topic keys:
Ledger ID	Frozen topic pattern
A003	window\|T_freeze\|as-of\|snapshot
A006	SLA
A007	[Oo]pen\|[Ee]ligible
A008	κ\|knob\|dormant\|P75\|urgenc
A011	[Cc]apacity\|ranking
The scorer classifies a topic as carried when its pattern appears in the locked Stage 3 document or the combined Stage 5 documents.
Declared pre-report adjustment: The A006 SLA topic key was added and an INFO row label was corrected during the scratch run, before the reporting run. These are scorer-setup adjustments, not seeded changes to the underlying framework.
The conceptual difference is therefore a proposed relaxation of the one-question limit; the measured difference is whether the original workflow preserved or lost the additional substantive topics.
3. Hard mechanical facts table
3.1 Independent ledger recount
The ambiguity ledger has 13 numbered entries, A001–A013.
I independently classified them as follows:
Mechanical fact	Value	Status	Evidence
Total ambiguity-ledger rows	13	Recomputed	Ambiguity Ledger A001–A013
Deferred substantive topics selected	5	Recomputed	A003, A006, A007, A008, A011
Other resolved substantive entries	4	Recomputed	A001, A002, A004, A005
Process/governance entries	4	Recomputed	A009, A010, A012, A013
Classification identity	5 + 4 + 4 = 13	Recomputed	Independent partition
Candidate-question rows	2	Recomputed	CQ-DRAFT-01, CQ-F01
Superseded candidates	1	Recomputed	CQ-DRAFT-01
Candidates not marked superseded	1	Recomputed	CQ-F01
Decision-ledger rows	13	Recomputed	Decision Ledger
Decision rows with explicit open status text	2	Recomputed	Time scope; Capacity/ranking
Revision-trail rows R000–R011	12	Recomputed	Revision Trail
Revision-trail mentions of CQ-F01/CQ-F02	1	Recomputed	R011
C07 substantive topics carried	5	Recomputed	CSV and verbatim cross-check
C07 substantive topics lost	0	Recomputed	CSV and verbatim cross-check
C07 topic accounting	5 = 5 + 0	Recomputed	Carried + lost
Frozen input files in manifest	75	Quoted	SPEC / PREFLIGHT
Preflight failures	0	Quoted	PREFLIGHT_N16.txt
Seed files	0	Quoted	SPEC, Seed files
Additional chats	0	Quoted	SPEC, Roles / Extra chats
The selected five topics agree with the scorer's results. The other four substantive entries were resolved at Start/Framing; the four process/governance entries are not additional decision questions.
3.2 Carried/lost matrix
ID	Stage 3	Stage 5	Independent classification
A003 — Timing/window	Yes	Yes	Carried
A006 — Official SLA	Yes	Yes	Carried
A007 — Open/eligible	Yes	Yes	Carried
A008 — Urgency rules	Yes	Yes	Carried
A011 — Capacity/ranking	Yes	Yes	Carried as deferred scope
Totals	5/5	5/5	5 carried, 0 lost
Recomputed identities:
- n_extra = 5
- n_carried = 5
- n_lost = 0
- n_extra = n_carried + n_lost = 5
- Stage 3 coverage = 5 / 5 = 100%
- Stage 5 coverage = 5 / 5 = 100%
The supplied CSV and scorer output agree on all five classifications. These coverage values describe documentary topic presence, not complete operational implementation of every issue. 


3.3 Frozen Stage 5 portfolio arithmetic
These numbers are unchanged baseline context. They were not produced by executing C07.
Measure	Quoted	Independently recomputed check
ESCALATE	131,968	59.4% of decision set
INCONCLUSIVE	6,377	2.9%
STANDARD	83,657	37.7%
Total decision set	222,002	131,968 + 6,377 + 83,657 = 222,002
Percentage sum	100.0%	59.4 + 2.9 + 37.7 = 100.0
Reconciliation disagreements	0	Quoted from Stage 5
Reconciliation coverage	222,002/222,002	Quoted from Stage 5
Stage 4 fixtures	14/14, both paths	Quoted; not independently executed
The Stage 5 reconciliation identifies zero disagreements over 222,002 reconciled rows. The corresponding count identity, assuming the reported full reconciliation coverage, is 222,002 agreements + 0 disagreements = 222,002 compared rows.
The complete underlying reconciliation records are not included verbatim in the C07 packet; the Stage 5 numbers are therefore documentary evidence, not an independently reproduced Stage 4 reconciliation.
3.4 Descriptive κ sensitivity and portfolio deltas
κ	ESCALATE count	Change from preceding κ
1.0	152,292	—
1.5	140,340	−11,952
2.0	131,968	−8,372
3.0	118,246	−13,722
The total ESCALATE change from κ=1.0 to κ=3.0 is −34,046, consistent with the locked design's monotonic prediction.
The Stage 5 evidence also quotes WCA2 = 64,922, SED = 17,254, and SKA = 7,316 ESCALATE rows. Dividing by 131,968 gives 49.2%, 13.1%, and 5.5%, respectively, rounded to one decimal.
All these results are background checks. They are not additional C07 benefit measurements. 


3.5 Hash and unchanged-arm checks
The following SHA-256 strings are consistent across the displayed frozen preflight and C07 evidence manifest:
Artifact	SHA-256 (abbreviated)	Check
Ambiguity ledger	f6d856ea328f…	Printed values agree
Candidate-question ledger	fefdaab549d9…	Printed values agree
Decision ledger	9d704ede8c20…	Printed values agree
Locked Stage 3 design	7297cf3ef25b…	Printed values agree
Stage 5 Finish Gate	22dc6a94006f…	Printed values agree
Stage 5 evidence package	c8e191d861a7…	Printed values agree
The SPEC and evidence manifest also report the same hashes for:
- scorers/score_c07.py: 8c26588039f75016340ada7835931c65c7ffc05a721b05451785724857dc62a3
- C07_RESULTS.md: ab49fcea90b680382fe4edba075484fe81d64dbc595f464d80556b3a7721cba8
- C07_extra_questions.csv: abfd4ad33199a8ec1e6626c713f78cc7c7ebc0bde631b3175d49381d7d4f6f44
These are cross-document string-equality checks, not newly computed SHA-256 digests from the separate original files. 


Not applicable: C07 has no two executable output arms, no A/B portfolio delta, no decision-changing D-set, and no C07-specific n_inner, n_agree, or n_disagree reconciliation dataset. Those quantities must not be invented or confused with the existing Stage 5 baseline.
4. P1 assessment against the frozen predicate
4.1 Frozen predicate
The SPEC defines operational benefit P1 using two conditions:
1. No additional substantive decision question arose.
2. At least one additional substantive decision question arose but was lost—absent from both the locked Stage 3 design and Stage 5 package.
The predicate is satisfied if either condition holds.
No alternative success criterion is introduced here.
4.2 Evaluation of the predicate
P1 input	Frozen test	Observed fact	Boolean
Extra substantive questions	n_extra == 0	n_extra = 5	False
Lost substantive questions	n_lost >= 1	n_lost = 0	False
Combined P1 expression	(n_extra == 0) OR (n_lost >= 1)	False OR False	False
Mechanical finding: Five deferred substantive topics were identified. All five appear in the locked Stage 3 design and Stage 5 material. None meets the frozen definition of lost.
4.3 Independent semantic trace
The following classifications were assessed against the verbatim documents, not solely against the scorer's keyword matches.
ID	Framing ambiguity	Stage 3 disposition	Stage 5 disposition	Assessment
A003	Meaning of “this period” and exact window dates	§0 establishes frozen as-of T; §3 defines snapshot population	Evidence Package specifies T_freeze = 2026-09-12 23:59:59 America/Chicago	Carried; window operationalized
A006	Official City SLA and urgency interpretation	§0 prohibits invented official City SLA; empirical peer P75 distinguished from City SLA	Evidence Package repeats the non-SLA constraint; Finish Gate excludes City SLA breach claims	Carried; correct policy boundary preserved
A007	Open and eligible population	§3 defines Open-token handling, duplicate/legacy exclusion, cutoff, type key, and integrity treatment	Evidence Package identifies open-eligible population and locked TCD-IG construct	Carried; eligibility operationalized
A008	Urgency/lateness evidence rules	§§4–7 define type-conditional dormancy, κ threshold, integrity gate, and action assignment	Evidence Package states TCD-IG, κ=2.0, empirical P75, and validated portfolio results	Carried; urgency method operationalized
A011	Capacity and ranking if ESCALATE exceeds available attention	§13 expressly prohibits ranking within current scope and requires a return to Framing	Finish Gate identifies excessive ESCALATE volume and recommends a new capacity/ranking question	Carried as a deferred decision issue; ranking not implemented
4.4 Scope interpretation
The five topics did not disappear from the workflow.
However, being preserved in the documentation is not equivalent to being fully resolved.
A003, A007, and A008 progressed into concrete measurement specifications. A006 became an explicit inference and policy constraint.
A011 received a different treatment: its relevance was preserved, its operational consequences were acknowledged, and a future Framing return was recommended.
That is sufficient for documentary carriage under the frozen test. It is not evidence that a usable ranked shortlist was delivered.
The supplied Stage 5 results make the remaining capacity issue material: 131,968 of 222,002 classified requests, or 59.4%, receive ESCALATE at κ=2.0. The Finish Gate explicitly states that this does not produce a focused list for limited shift attention.
4.5 Limits of P1 evidence
The replay does not establish:
- How a real up-to-three-question Framing session would have behaved.
- Which additional questions, if any, would actually have been locked.
- Whether additional locks would have caused unauthorized scope expansion.
- Whether a multi-question run would have improved operational usefulness.
- Whether the multi-question variant would have changed Stage 3, Stage 4, or Stage 5 deliverables.
These are unmeasured counterfactuals. They cannot be inferred from the fact that all five topics survived in the existing single-question workflow.
5. Fixture and reconciliation implications
Not applicable. C07 is a text-only ledger replay with no newly executed R/SQL paths, decision fixtures, or independently reconciled variant outputs.
The text-level equivalent is an exact topic-accounting and document-trace check:
Text-level check	Finding
Five selected deferred topics match ambiguity-ledger IDs	Confirmed
Candidate question supersession	CQ-DRAFT-01 superseded by CQ-F01
Topic classification against frozen result CSV	5/5 agree
Topic preservation in locked Stage 3 design	5/5 confirmed
Topic preservation in Stage 5 evidence/Finish Gate	5/5 confirmed
Carried/lost accounting	5 + 0 = 5
Frozen source hashes	Supplied preflight reports no failures
Existing Stage 4 fixtures	14/14 both paths, quoted only
Existing Stage 4 reconciliation	222,002 rows, zero disagreements, quoted only
These are documentary controls. They do not substitute for executing the underlying Stage 4 fixture suite or reconciliation pipeline.
6. Semantic/regression risks and unchanged surfaces
6.1 Semantic risks
Risk S1 — Keyword presence versus meaningful carriage
The scorer uses topic-specific regular-expression searches. A keyword match alone could be a false positive: for example, mentioning capacity is not proof that a ranking rule was designed.
Independent document review reduces this risk for C07 because each reported carried topic has a relevant substantive passage.
The distinction remains important for A011, which is carried as an explicit unresolved capacity issue.
Risk S2 — Deferral classified as an additional question
A003, A006, A007, A008, and A011 are substantive decision-related issues, but the source ledger does not show five separately formulated candidate questions formally proposed for locking.
The scorer treats them as extra deferred questions by operational definition.
Therefore, five is the reproducible count of qualifying deferred topics, not a verified count of five additional formally locked questions.
Risk S3 — Capacity remains unresolved operationally
The locked Stage 3 design expressly excludes ranking.
The Stage 5 package demonstrates that the generated ESCALATE set is too broad to function by itself as a small attention-budget shortlist.
The issue is preserved rather than silently discarded. Nevertheless, preservation is not solution.
Risk S4 — Counterfactual validity
The actual workflow used one-question Framing, coordination, additional reviews, and downstream design deliberation.
No parallel multi-question workflow was executed.
The replay consequently cannot estimate causal effects of changing the Framing rule. This limitation was declared before reporting.
Risk S5 — Candidate-question version chronology
The supplied Stage 1–2 candidate-question ledger records CQ-F01 awaiting final Framing reviews and owner approval. The later authoritative Stage 3 and Stage 5 documents identify CQ-F02 as locked.
These represent different points in the recorded workflow. The complete CQ-F01-to-CQ-F02 approval transition is not reproduced within the verbatim ledger excerpts supplied for this report.
CQ-F02 should not be misclassified as a separate deferred decision topic merely because its identifier differs.
Risk S6 — Documentary coverage versus authorization
The fact that a topic appears in Stage 3 or Stage 5 does not demonstrate that it was independently approved as a new decision objective.
The single-question workflow preserved these issues through definitions, assumptions, limitations, and explicit scope boundaries.
That mechanism differs from simultaneously authorizing several separate analytical questions.
Risk S7 — Weak benefit inference
The predicate tests whether the one-question rule caused documentary loss.
It does not directly measure the safety, efficiency, or decision quality of relaxing the rule.
No positive statement about the safety of simultaneous multiple-question locking follows from this replay.
6.2 Known N1 / OF-1 finding
The packet discloses a known 1.000-hour difference between clean R-A and R-B calculations on three frozen Chicago 311 rows:
- SR22-01936870 — dormant_h
- SR25-02017553 — open_age_h
- SR25-02017556 — open_age_h
The coordinator attributes the difference to ambiguous repeated-hour parsing during the daylight-saving fall-back transition.
C07 reads frozen text only. Its scorer does not perform R-A/R-B timestamp parsing, consume those row-level clocks, or recompute classifications.
Implication: The known clock difference has no demonstrated pathway into C07's topic counts or carriage classifications.
This statement does not resolve OF-1; it identifies why OF-1 is outside C07's calculation path.
6.3 Unchanged surfaces
Surface	Observed treatment
Constitution v1.0	Unchanged
Baseline measurement-design framework	Unchanged
Baseline validation-and-analysis framework	Unchanged
Stage 1 Start decision	Unchanged
Stage 2 locked-question authority	Unchanged
Stage 3 locked measurement design	Unchanged
TCD-IG decision construct	Unchanged
Open/eligible population definition	Unchanged
ESCALATE / INCONCLUSIVE / STANDARD menu	Unchanged
κ default/grid, W, n_min	Unchanged
SQL/R responsibility separation	Unchanged
Stage 4 implementation and outputs	Not executed or modified
Frozen Stage 4 fixtures and reconciliation	Not rerun
Stage 5 interpretation and Finish Gate	Unchanged
Capacity/ranking exclusion	Preserved
Official City SLA prohibition	Preserved
Frozen evidence documents	Read-only replay
Source-data scope	No new data
C07 code seeds	None
No changed framework artifact or regenerated analytical result is presented by C07.
6.4 Evidentiary qualifications
The supplied preflight reports all frozen-file checks passing. The displayed hashes are internally consistent, but their original file bytes were not independently rehashed in this Builder assessment.
The Builder and Validator have not been compared in this report.
No statement is made concerning the completeness, agreement, or future adjudication of evidence outside this first-pass packet.
7. Claim → evidence map
The following map identifies the frozen evidence for each material claim, including section and table-row references.
Claim	Frozen evidence	Specific reference
C07 tests a one-question Framing gate against a possible three-question limit	SPEC	Control under test; Arms
Replay uses a fixed Boolean benefit predicate	SPEC	Operational benefit predicate P1, items 1–2
The candidate ledger has two entries, with one superseded	Candidate Question Ledger	Rows CQ-DRAFT-01, CQ-F01
Five deferred substantive issues qualify	Ambiguity Ledger	Rows A003, A006, A007, A008, A011
Four substantive issues were resolved earlier	Ambiguity Ledger	Rows A001, A002, A004, A005
Four other entries concern process/governance	Ambiguity Ledger	Rows A009, A010, A012, A013
Time scope and ranking were expressly left open	Decision Ledger	Time scope; Capacity/ranking
Revision history records the question and deferral evolution	Revision Trail	R004, R005, R009, R010, R011
All five topics were classified as carried by the scorer	C07_RESULTS.md / CSV	Extra-question table rows A003, A006, A007, A008, A011
Source: frozen SPEC, C07_RESULTS.md, and Stage 1–2 ledgers. C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt

7.1 Topic-specific evidence map
Topic	Stage 3 evidence	Stage 5 evidence	Supported claim
A003 — Timing	MEASUREMENT_DESIGN_LOCKED.md §§0, 3	STAGE5_EVIDENCE_PACKAGE.md, Locked measurement	Frozen window and as-of date are operationalized
A006 — SLA	Stage 3 §§0, 4, 6	Stage 5 Evidence Package, Conclusion ceiling / Locked measurement	Official SLA is excluded; peer P75 is empirical
A007 — Eligibility	Stage 3 §3, Population/open/eligible/grain	Stage 5 Evidence Package, Locked decision / question	Open/eligible population is explicitly defined
A008 — Urgency	Stage 3 §§4–7, Evidence construct / decision rules	Stage 5 Evidence Package, Locked measurement and validated facts	Dormancy and κ threshold operationalize urgency
A011 — Capacity	Stage 3 §13, Capacity / Framing return rule	Finish Gate §§1.4–1.5, caveat and recommended action	Capacity issue preserved but ranking intentionally excluded
The relevant passages are not merely passing references. They specify implementation rules, constraints, or explicit deferred decision procedures. A011 is the exception in operational completeness: it establishes what must happen next rather than implementing ranking now. C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt
 C07_1_BUILDER_ChatGPT.txt

7.2 Mechanical and governance evidence map
Claim	Source	Section / row
Extra-topic count = 5	C07_RESULTS.md	Counts; Extra questions
Lost-topic count = 0	C07_RESULTS.md	Counts; Extra questions
Exact topic classifications	C07_extra_questions.csv	Rows A003, A006, A007, A008, A011
Topic pattern definitions	scorers/score_c07.py	TOPIC dictionary
Carriage calculation	scorers/score_c07.py	in3, in5, extra, lost
P1 computation	scorers/score_c07.py	keep Boolean expression
No seeded implementation changes	SPEC	Seed files (none)
Report-mode restrictions	Coordinator Note	Text-only capture; no PC run
Frozen-file check	PREFLIGHT_N16.txt	Final PASS, failures 0
Existing decision-set arithmetic	Stage 5 Evidence Package	Validated Stage 4 facts
Existing fixture and reconciliation numbers	Stage 5 Evidence Package	Validated Stage 4 facts
No ranked operational shortlist	Locked Stage 3 §13; Finish Gate	Capacity/Framing return; executive caveat
Missing counterfactual comparison	SPEC	Disclosures and deviations
7.3 Consolidated Builder findings
The frozen record supports these factual conclusions:
1. Five substantive deferred topics arose during the recorded Framing process.
2. All five are traceable into the locked Stage 3 design and Stage 5 documentation.
3. Under the frozen documentary-loss definition, zero were lost.
4. Four of the five have explicit downstream treatment as measurement definitions, decision rules, or policy constraints; the fifth—capacity/ranking—remains expressly deferred for a new Framing decision.
5. The supplied mechanical counts are internally coherent, and the relevant reported source-hash strings agree.
6. No executable multi-question Framing variant was run, so the counterfactual effect of relaxing the rule remains unmeasured.
7. C07 introduces no new analytical data, decision fixtures, R/SQL execution results, or changed Stage 3/5 artifacts.
These findings constitute the independent Builder first pass. Final adjudication remains outside this role.
END C07 BUILDER REPORT
