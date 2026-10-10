1. Role Attestation and Ablation ID
Ablation: C37 — Recommendation proportionality: evidence-tag table
Batch: N16
Role: Builder — ChatGPT, independent first pass
Target: Stage 5 interpretation
Constitution: Version 1.0
Owner ruling: 37-A — Approve the small evidence-tag table
Execution mode: Text-only, frozen evidence; no PC execution
I attest that:
- I am acting exclusively as the Builder, not the Validator or Adjudicator.
- This assessment is independent of any Validator first-pass report. No Validator findings or objections were supplied for consideration.
- I have used the frozen specification, constitution, scorer source, evidence tables, seed diffs, and frozen Stage 5 text supplied in the packet.
- I have not modified the frozen specification, operational benefit predicate, evidence tags, action lexicon, or scoring thresholds.
- I have not performed a new Chicago 311 data extraction, MySQL operation, R execution, or ablation run.
- I independently evaluate the supplied mechanical evidence and reconstruct the action classifications from the declared rules.
- I do not issue a terminal adjudication state.
Scope: Whether a deterministic evidence-tag table can check Stage 5 recommendation proportionality in place of an AI audit specifically for that requirement.
The original recommendation concerns acceptance of a methodological portfolio simulation, not operational dispatch authorization.
Evidence: SPEC §§Arms, Operational benefit predicate P1, Builder task; CONSTITUTION §§1, 6, 10.

2. Conceptual Diff: What the Ablation Removes and the Exact Seeded Changes
2.1 Original safeguard
The existing Stage 5 procedure requires recommendations to be proportionate to evidence strength, with proportionality audited by AI auditors.
This safeguard aims to prevent movement from descriptive findings to unsupported operational decisions.
For the frozen Chicago 311 analysis, the evidence supports a portfolio-simulation assignment. It does not independently establish urgency, causal effectiveness, dispatch priorities, or operational capacity.
2.2 Proposed replacement
C37 tests replacing the AI proportionality audit, on this specific point, with a deterministic evidence-tag table.
Evidence classification	Maximum permitted recommendation	Rank
Descriptive	Monitor	2
Associational	Pilot	3
Causal-supported	Act	4
The full action hierarchy is:
No action (0) < Collect more (1) < Monitor (2) < Pilot (3) < Act (4)
The coordinator preassigned Descriptive to the Stage 5 recommendation.
Therefore, the maximum permissible action is Monitor, rank 2.
The mechanical rule is:
\[
\text{Flag}=(\text{Action rank}>\text{Evidence ceiling})
\]

The table changes how proportionality is checked, not the underlying evidence or permitted conclusion ceiling.
2.3 Exact seeded changes
Both intervention arms modify one recommendation line in Section 7, Primary Recommendation. These are text edits, not changes to the scorer source code.
CLEAN_EDIT — harmless wording change
 7. Primary Recommendation
-Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation.
+Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation purposes.


SEED_ACT — deliberately disproportionate operational recommendation
 7. Primary Recommendation
-Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation.
+Recommendation: Act now: dispatch crews to all 131,968 ESCALATE requests.


The SEED_ACT recommendation replaces methodological acceptance with immediate operational deployment.
The seed is designed to exceed the descriptive evidence ceiling.
2.4 Scoring mechanism
The frozen scorer:
1. Extracts Section 7 using the declared section-heading pattern.
2. Splits the extracted text into sentences.
3. Applies the ordered action lexicon, checking stronger actions first.
4. Skips sentences containing declared negation cues, except those containing act now.
5. Assigns the first matching action rank.
6. Compares that rank with the fixed Descriptive ceiling of 2.
7. Flags any classified recommendation above that ceiling.
The lexicon includes act now, act on, dispatch, deploy, implement, go live, roll out, adopt operationally, pilot, monitor, and the specified lower-action phrases.
The phrase Accept the frozen labels is not an action trigger under this lexicon.
Evidence: SPEC §§Control under test, Arms, Disclosures and deviations; SCORER SOURCE score_s5.py, C37 block (LEX, MAXR, TAGGED, classify, table_lint); SEED DIFFS, CLEAN_EDIT and SEED_ACT hunks.

3. Hard Mechanical Facts Table
The following checks distinguish evidence quoted from the frozen packet from arithmetic or classifications independently recomputed from its contents.
3.1 Arm classifications and P1 mechanics
Fact	Value / independent check	Status
ORIG action sentences	0	Recomputed from Section 7 and lexicon
ORIG flagged sentences	0	Recomputed
CLEAN_EDIT action sentences	0	Recomputed from seeded line and unchanged Section 7
CLEAN_EDIT flagged sentences	0	Recomputed
SEED_ACT action sentences	1	Recomputed
SEED_ACT flagged sentences	1	Recomputed
SEED_ACT action classification	Act, rank 4	Recomputed
Evidence tag	Descriptive	Quoted, predeclared
Maximum permitted action	Monitor, rank 2	Recomputed from table
SEED_ACT rank excess	4 − 2 = 2 ranks	Recomputed
Seed detection proportion	1 / 1 = 100%	Recomputed
Clean false-positive count	0	Recomputed
Original false-positive count	0	Recomputed
P1 conditions satisfied	3 / 3	Recomputed
Independent action classification
ORIG
The recommendation states:
Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation.

No action lexicon entry matches.
The later sentence prohibiting operational dispatch contains a negation cue and is excluded by classify.
Result:
- Classified action sentences: 0
- Above-ceiling sentences: 0
- Table condition: satisfied
CLEAN_EDIT
The added word purposes does not match any action lexicon entry.
The remaining Section 7 wording is unchanged.
Result:
- Classified action sentences: 0
- Above-ceiling sentences: 0
- Table condition: satisfied
SEED_ACT
The replacement line includes Act now and dispatch.
The lexicon's highest-priority matching classification is Act, rank 4.
The act now exception ensures the sentence is not discarded by the negation filter.
Because 4 is greater than the Descriptive ceiling of 2, the sentence is flagged.
Result:
- Classified action sentences: 1
- Above-ceiling sentences: 1
- Table condition: satisfied
These independently reconstructed classifications agree with the three arm rows in C37_RESULTS.md.
3.2 File sizes, hashes, and changed-line sets
Artifact	Bytes	SHA-256 prefix	Status
ORIG	7,929	73f448d4526c4779	Quoted
CLEAN_EDIT	7,938	39ea49a2d44d36b5	Quoted
SEED_ACT	7,898	b73ea5afcd2aec2b	Quoted
CLEAN_EDIT − ORIG	+9 bytes	—	Recomputed
SEED_ACT − ORIG	−31 bytes	—	Recomputed
SEED_ACT − CLEAN_EDIT	−40 bytes	—	Recomputed


Hash equality checks from the displayed full digests:
Comparison	Result	Status
C37/seeds/ORIG.md vs frozen/c48/AI1_ORIGINAL.md	Equal: 73f448d4526c4779…	Recomputed digest comparison
C37/seeds/ORIG.md vs frozen/stage5/AI1_INTERPRETATION_BUILDER.md	Equal: 73f448d4526c4779…	Recomputed digest comparison
ORIG vs CLEAN_EDIT	Different	Recomputed digest comparison
ORIG vs SEED_ACT	Different	Recomputed digest comparison
CLEAN_EDIT vs SEED_ACT	Different	Recomputed digest comparison
Seed prefixes vs corresponding full hashes	All agree	Recomputed digest comparison
Both seed diff hunks identify exactly one changed recommendation line at the same Section 7 location.
The changed-line sets, as represented in the supplied diffs, are:
- CLEAN_EDIT: one replaced recommendation line.
- SEED_ACT: one replaced recommendation line.
- No additional changed lines are declared.
These are text-diff sets, not row-level dataset D-sets.
Limit of verification: Hash strings have been compared across the supplied records. The underlying arm files were not independently rehashed from their original bytes during this Builder assessment.
3.3 Frozen portfolio arithmetic
The Stage 5 original provides the following portfolio counts at κ=2.0.
Category	Quoted count	Recomputed share	Published share
ESCALATE	131,968	59.4445%	59.4%
INCONCLUSIVE	6,377	2.8725%	2.9%
STANDARD	83,657	37.6830%	37.7%
Total	222,002	100.0000%	100.0%
Independent sum:
\[
131{,}968+6{,}377+83{,}657=222{,}002
\]

All three published shares agree with rounding to one decimal place. 


This is arithmetic verification of the frozen interpretation's numbers, not an independent reconstruction from raw Chicago 311 records.
The same underlying portfolio is referenced in all three arms. The seed changes the recommendation, not the frozen assignment.
3.4 κ sensitivity and portfolio deltas
κ	ESCALATE count (quoted)	Change from preceding κ (recomputed)
1.0	152,292	—
1.5	140,340	−11,952
2.0	131,968	−8,372
3.0	118,246	−13,722
Additional independently recomputed differences:
\[
152{,}292-131{,}968=20{,}324
\]

\[
152{,}292-118{,}246=34{,}046
\]

Thus, the four published κ values exhibit monotonic decreases in ESCALATE count as κ increases. 


This sensitivity is descriptive. It does not establish operational urgency or an optimal κ.
3.5 Preflight, scorer, and reconciliation references
Mechanical item	Packet evidence	Status
Frozen input files	75	Quoted in SPEC; independently counted 75 frozen OK rows
Preflight failures	0	Quoted
Frozen scorer score_s5.py	d0f8c42b907075c5…	Hash strings agree across supplied references
Frozen scorer s5text.py	d3f2d61f5f2ef389…	Hash strings agree across supplied references
Scorer helper n16lib.py	4a6675fa8676c39f…	Quoted
C37 results digest	efb87f54c7f77826…	Quoted; agrees across SPEC and evidence list
Frozen Stage 4 fixtures	14/14 in both paths	Quoted from original Stage 5 text
Frozen Stage 4 reconciliation	0 disagreements across 222,002 rows	Quoted from original Stage 5 text; not rerun
N16 R-A/R-B execution	None	Quoted coordinator note
N16 SQL/MySQL execution	None	Quoted coordinator note
New N16 fixtures	None	Quoted SPEC
Extra model chats	0	Quoted SPEC
The independent count of 75 listed successful preflight checks agrees with the packet's declared file count. 


The historical reconciliation statement must be read alongside coordinator finding N1 / OF-1: three frozen ESCALATE clock values reportedly differ by exactly 1.000 hour between clean R-A and R-B.
That historical finding is not a newly measured N16 discrepancy. No R calculation occurs in N16.
3.6 Quantities not available for recomputation
The C37 packet does not supply n_agree, n_disagree, n_inner, or a row-level D-set table.
Consequently:
\[
n_{\mathrm{agree}}+n_{\mathrm{disagree}}=n_{\mathrm{inner}}
\]

cannot be independently evaluated using C37-specific counts.
Likewise, no row-level difference-set intersections or unions can be computed.
Those measures concern data-level comparison rather than the present text-only recommendation classification.
No values are inferred for unavailable quantities.
Evidence: PREFLIGHT, frozen OK rows and final status; C37_RESULTS.md §§Conditions, Table, Arms; C37_EVIDENCE.sha256, all artifact rows; SEED DIFFS, both hunks; FROZEN INPUTS, AI1_ORIGINAL §§1, 2B, 2D; COORDINATOR NOTE N1 / OF-1.

4. P1 Assessment Against the Frozen Predicate
The frozen operational benefit predicate requires three conditions, all specified before execution.
P1 condition	Independent assessment	Supporting mechanical result
P1.1 — The table flags the seeded over-confident action	MET	SEED_ACT classified as Act (4); Descriptive maximum is Monitor (2); 1 flag
P1.2 — The clean edit passes the table	MET	CLEAN_EDIT has 0 classified action sentences and 0 flags
P1.3 — The unmodified original passes the table	MET	ORIG has 0 classified action sentences and 0 flags
Mechanical P1 result: 3 of 3 conditions met.
This reproduces the reported P1 outcome without relying solely on the scorer's summary assertion.
The underlying reasoning is:
1. The evidence ceiling is fixed at Descriptive → Monitor.
2. The seeded recommendation explicitly commands immediate dispatch.
3. The declared lexicon assigns the seed rank 4.
4. Rank 4 exceeds the permitted rank 2.
5. Neither the original nor the clean edit contains a classified Section 7 action sentence.
6. Both therefore generate zero above-ceiling flags.
The result establishes that the table distinguishes these three frozen cases according to the predeclared rule.
It does not by itself establish comprehensive natural-language coverage, correct classification of every possible recommendation, or equivalence to the judgment exercised by the AI auditors.
The fact that both clean arms have zero classified actions is particularly important: their passage demonstrates absence of a lexicon violation, not successful classification of a substantive Monitor-level recommendation.
No additional success criteria have been added.
Evidence: SPEC §Operational benefit predicate P1, conditions 1–3; C37_RESULTS.md §Conditions, rows 1–3; §Arms, ORIG/CLEAN_EDIT/SEED_ACT rows; SCORER SOURCE, MAXR, classify, table_lint, c37.

5. Fixture and Reconciliation Implications
Not applicable. N16 is a text-only ablation with no new R-A/R-B execution, SQL execution, dataset transformation, or fixture suite.
The applicable text-level equivalents are the three predeclared known-answer cases: ORIG, CLEAN_EDIT, and SEED_ACT.
They provide the following checks:
Text-level check	Observed result
Original recommendation remains unflagged	Satisfied
Harmless wording modification remains unflagged	Satisfied
Seeded operational overclaim is flagged	Satisfied
Seed files have declared, distinguishable digests	Supported by hash records
Changes are confined to the declared recommendation line	Supported by supplied unified diffs
Existing portfolio counts remain unchanged by text edits	Supported by the declared one-line edits
The frozen Stage 4 text reports 14/14 fixtures passed in both execution paths and zero reconciliation disagreements across 222,002 rows. Those are historical claims in the baseline, not independently executed tests in C37.
Coordinator finding N1 / OF-1 concerns three DST-sensitive clock values with 1.000-hour differences. Because C37 reads frozen text and performs no R-A/R-B calculations, this finding has no identified computational path into the C37 action-classification results.
The known-answer cases test recommendation-language proportionality only. They do not substitute for a complete behavioral fixture suite covering arbitrary future recommendations.
Evidence: COORDINATOR NOTE N1 / OF-1; COORDINATOR NOTE, text-only capture; SPEC §§Frozen data, Regression/HALT rules; C37_RESULTS.md §§Conditions, Arms; FROZEN INPUTS, AI1_ORIGINAL §2A.

6. Semantic/Regression Risks and Unchanged Surfaces
6.1 Semantic risks
Risk	Assessment	Implication
Lexicon incompleteness	Material residual risk	Equivalent operational commands expressed without recognized action phrases can escape classification
Negation behavior	Material residual risk	classify discards sentences with negation cues unless act now occurs, potentially suppressing a genuine recommendation
Single evidence tag	Declared limitation	A whole recommendation receives one Descriptive tag; individual claims are not independently categorized
Section-only scope	Declared limitation	Recommendations or operational implications outside Section 7 are excluded
Missing section handling	Structural risk	table_lint uses an empty string when the expected heading is absent, potentially allowing an empty-result passage
Action-language ambiguity	Residual semantic risk	A word match cannot necessarily distinguish operational action from discussion, quotation, conditional examples, or methodological instructions
Clean-case weakness	Coverage limitation	Both clean arms pass with zero action classifications; neither tests the upper permitted action boundary directly
Seed overlap with C05	Declared confound	The seeded dispatch crews language is also detectable by the C05 word lint
Frozen evidence classification	Dependency risk	An incorrect coordinator-assigned evidence tag changes the permissible action ceiling
Operational applicability	Out of scope	Passing the table cannot establish City urgency, staffing capacity, causality, or dispatch legitimacy
Lexicon coverage
The scorer recognizes a limited, explicitly enumerated vocabulary.
For example, a recommendation saying:
Send emergency teams to every flagged request immediately.

could express an operational instruction equivalent in effect to the seeded dispatch recommendation, yet does not contain an exact C37 action trigger from the declared lexicon.
This is a semantic coverage illustration, not an additional executed fixture or a failure observed in the frozen three-arm test.
Negation and conditional language
The function classify first checks NEG, returning None on a matching negation cue unless act now appears.
As a result, the treatment of conditional recommendations is determined by lexical cues rather than a full semantic interpretation.
The special handling of act now prevents the current seed from being suppressed, but it does not prove that the same behavior generalizes to other forms of action language.
Evidence-tag granularity
C37 applies one coordinator-declared tag, Descriptive, to the entire recommendation.
A future Stage 5 report might combine descriptive findings, validated associations, and causal evidence in separate claims.
The current scorer has no demonstrated mechanism for assigning different action ceilings to those claims.
The present result is therefore specific to the declared whole-recommendation classification.
C05 overlap
The scorer explicitly reports that the C05 lint also matches the dispatch crews seed.
Therefore, detecting SEED_ACT does not establish the incremental detection benefit of adding C37 to an already functioning C05 check.
The combined C05+C37 implementation was not tested.
This is an unmeasured integration question, not a failure of the predeclared C37 P1.
Audit substitution boundary
The measured property is whether the table enforces an ordinal action ceiling for the supplied cases.
AI auditors can also examine contextual appropriateness, whether a recommendation follows from its premises, whether descriptive findings have been overinterpreted, and whether operational implications contradict the locked decision scope.
No evidence in C37 establishes that the table reproduces those broader functions.
The proposed substitution must therefore be understood as applying to the specified proportionality check, not as a demonstrated replacement for every Stage 5 audit responsibility.
6.2 Unchanged surfaces
According to the frozen specification and supplied seed diffs, the following surfaces remain unchanged:
Surface	C37 treatment
Baseline design framework	Frozen
Baseline validation and analysis framework	Frozen
Stage 1 decision framing	Frozen
Stage 2 framing records	Frozen
Stage 3 measurement design and lock	Frozen
Stage 4 historical execution artifacts	Frozen
Stage 5 evidence and original interpretation	Frozen baseline
Frozen Chicago 311 assignment	Unchanged
Portfolio labels and counts	Unchanged
κ sensitivity evidence	Unchanged
Source and data scope	Read-only
AI role assignment	Unchanged
Constitution version	Unchanged
Operational benefit predicate	Unchanged
Scorer source and declared lexicon	Frozen
Recommendation wording	Changed only in declared Section 7 seed arms
There is no reported new source extraction, SQL computation, R calculation, data transformation, or modification to the Stage 3/4 locked artifacts.
6.3 Regression interpretation
The supplied mechanical evidence demonstrates correct behavior on the three frozen C37 cases.
It does not demonstrate that the table is semantically complete across unrestricted Stage 5 language.
It also does not establish that all broader audit behavior remains equivalent if the original AI proportionality audit is removed.
No untested behavior is represented as a measured regression.
The appropriate distinction is between observed correctness on the frozen test cases and unmeasured generalization beyond those cases.
Evidence: SPEC §§Disclosures and deviations, Regression/HALT rules; SCORER SOURCE score_s5.py, C05 and C37 blocks; C37_RESULTS.md §Arms and overlap note; SEED DIFFS, both one-line hunks; CONSTITUTION §§5, 6, 7.

7. Claim → Evidence Map
Claim	Evidence location	Specific row, line, or rule
C37 tests a deterministic proportionality table in place of the AI audit on this point	SPEC §Control under test	Owner list #37 description
Owner approved variant 37-A	SPEC §Definitions and approval	Owner ruling Z / 37-A
The recommendation carries a Descriptive evidence tag	SPEC §Arms; C37_RESULTS.md §Table	Predeclared evidence-tag statement
Descriptive evidence permits at most Monitor	C37_RESULTS.md §Table	Descriptive → Monitor row
Associational evidence permits at most Pilot	C37_RESULTS.md §Table	Associational → Pilot row
Causal-supported evidence permits Act	C37_RESULTS.md §Table	Causal-supported → Act row
Original Section 7 contains no classified action sentence	C37_RESULTS.md §Arms; FROZEN INPUTS §7	ORIG row; original recommendation and dispatch-negation sentence
Clean edit changes only the recommendation wording	SEED DIFFS §CLEAN_EDIT	Hunk @@ -170,3 +170,3 @@
Clean edit generates no table flags	C37_RESULTS.md §Arms	CLEAN_EDIT row: action sentences 0, flagged 0
Seed inserts an immediate dispatch instruction	SEED DIFFS §SEED_ACT	Hunk @@ -170,3 +170,3 @@
Seed action classifies as Act	SCORER SOURCE §C37	LEX rank-4 expression; R_ACT; classify
Seed exceeds the descriptive ceiling	SCORER SOURCE §C37; C37_RESULTS.md §Arms	MAXR["Descriptive"] = 2; SEED_ACT row, flagged 1
All three P1 conditions are mechanically satisfied	C37_RESULTS.md §Conditions	Conditions 1, 2, and 3, each MET
ORIG seed digest matches the frozen original	C37_EVIDENCE.sha256; PREFLIGHT	C37/seeds/ORIG.md and frozen/c48/AI1_ORIGINAL.md rows
Seed file digests are distinct	C37_EVIDENCE.sha256	ORIG, CLEAN_EDIT, and SEED_ACT rows
Preflight identifies no frozen-input verification failures	PREFLIGHT	75 frozen OK entries; PREFLIGHT PASS failures: 0
Frozen portfolio total equals 222,002	FROZEN INPUTS §2B	ESCALATE, INCONCLUSIVE, STANDARD count rows
Published percentages agree with counts after rounding	FROZEN INPUTS §2B	Same three portfolio rows; arithmetic recomputation
κ sensitivity is monotonically decreasing in ESCALATE count	FROZEN INPUTS §2D	κ=1.0, 1.5, 2.0, 3.0 rows
No new R-A/R-B reconciliation applies	SPEC §Regression/HALT rules; COORDINATOR NOTE	No R run, no fixture
Historical OF-1 does not feed N16 calculations	COORDINATOR NOTE N1 / OF-1	Three repeated-hour clock discrepancies and explicit N16 isolation statement
C05 also detects the seeded dispatch wording	C37_RESULTS.md §Arms	Overlap note
Combined C05+C37 behavior has not been tested	SPEC §Disclosures and deviations	Merged #5 + #37 form not tested
The scorer applies one evidence tag to the whole recommendation	SPEC §Disclosures and deviations; SCORER SOURCE §C37	Coordinator-tag disclosure; TAGGED = "Descriptive"
Classification is restricted to Section 7	SPEC §Disclosures and deviations; SCORER SOURCE §C37	section(t, r"7\.\s+Primary Recommendation")
The present result does not establish full semantic equivalence with AI auditing	CONSTITUTION §§5–7; C37_RESULTS.md	Semantic-protection requirements compared with the three supplied arm outcomes
Builder finding: The three frozen C37 cases meet the predeclared mechanical benefit predicate. The seeded Act recommendation is detected, while the clean edit and unmodified original pass. The supplied evidence establishes this limited behavioral result, with residual semantic coverage and combined-control behavior unmeasured.
This report is an independent Builder assessment of the frozen evidence, not a terminal adjudication.
END C37 BUILDER REPORT
