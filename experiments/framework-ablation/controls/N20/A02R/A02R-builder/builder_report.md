1. Role attestation and ablation ID
Ablation ID: A02R
Batch: N20
Role: Builder — ChatGPT
Review type: Independent first pass
Constitution: v1.0
Specification: ABLATION_SPEC_A02R.md
Proposed change: Make the mandatory pre-builder known-case Fixture Gate optional or post-hoc.
I attest that:
- I am acting exclusively as Builder, not Validator or Adjudicator.
- This assessment uses the supplied frozen specification, constitutional rules, evidence tables, execution logs, code excerpts, receipts, and evidence manifest.
- I have not consulted Validator findings or an earlier A02 Builder, Validator, or Adjudicator report.
- I have not modified the frozen inputs, changed expected fixture outcomes, or rerun the Chicago 311 production workload.
- Arithmetic and comparisons identified as recomputed are independently calculated from the supplied evidence.
- Assertions that cannot be independently reconstructed from the supplied evidence are identified as quoted.
- I issue no terminal ablation verdict.
The original A02 history is acknowledged only as disclosed in ABLATION_SPEC_A02R.md. It is not used as independent evidence for the outcome of A02R.
2. Conceptual diff
Baseline workflow
The baseline establishes two complementary protections.
Stage 3 — Fixture freeze before builders
The workflow establishes and freezes the intended classification semantics before production implementation. This includes the known-case fixture pack F01–F14, expected classifications, the decision grain, and the interpretation of the κ-dependent dormancy threshold.
F03 specifically establishes:
- peer_p75_h = 2,160
- dormant_h = 2,400
- κ = 2
- Expected classification: STANDARD
The owner-approved known cases become a fixed behavioral reference for the independent implementations.
Stage 4 — Mandatory Fixture Gate enforcement
The baseline requires the known-case Fixture Gate to pass before the independent R-A and R-B production builders are authorized to proceed.
This provides a defined behavioral checkpoint in addition to the later exact reconciliation of production outputs.
The two controls answer different questions:
- The Fixture Gate asks whether an implementation respects independently established classification expectations.
- Exact reconciliation asks whether R-A and R-B agree with each other on the compared production results.
Agreement between implementations does not, by itself, establish that their shared interpretation is correct.
Proposed A02R change
A02R evaluates the original A02 proposal:
Remove or make optional the requirement for a frozen, passing Fixture Gate before production execution, allowing production-first execution with fixtures optional or performed afterward.
Control	Baseline	Proposed ablation
Stage 3 known-case fixture freeze	Mandatory before builders	No longer required as a mandatory pre-builder condition
Stage 4 Fixture Gate PASS	Required	Optional or post-hoc
Independent R-A/R-B builds	Retained	Retained
Exact production reconciliation	Retained	Retained
Chicago frozen design and source scope	Unchanged	Unchanged
κ and T_freeze	Frozen	Unchanged
SQL nonjudgment	Preserved	Preserved
Dual-path independence	Preserved	Preserved
Fixture expectations after failure	Must not be rewritten to match code	Same prohibition remains binding
The intended operational benefit is fewer mandatory steps without reduced defect detection or increased incorrect shipped classifications.
The principal tradeoff is the removal of a required pre-implementation semantic checkpoint while retaining a downstream comparison between independent implementations.
Evidence: ABLATION_SPEC_A02R.md; ORIGINAL_A02_ABLATION_SPEC.md; CONSTITUTION_v1.md; KNOWN_CASE_FIXTURE_PACK_LOCKED.md; FIXTURE_GATE_RECEIPT.md.
3. Hard mechanical facts table
The following results were checked against the supplied fixture CSVs, production logs, reconciliation output, and code. “Recomputed” means independently calculated from the supplied values. “Quoted” means the underlying operation or raw evidence could not be independently reproduced.
3.1 Fixture results and classifications
The two fixture-result CSVs each contain 14 rows, covering F01–F14.
Fixture	Expected	R-A observed	R-B observed
F01	ESCALATE	ESCALATE	ESCALATE
F02	STANDARD	STANDARD	STANDARD
F03	STANDARD	STANDARD	STANDARD
F04	INCONCLUSIVE	INCONCLUSIVE	INCONCLUSIVE
F05	INCONCLUSIVE	INCONCLUSIVE	INCONCLUSIVE
F06	INCONCLUSIVE	INCONCLUSIVE	INCONCLUSIVE
F07	OUT_OF_SET	OUT_OF_SET	OUT_OF_SET
F08	OUT_OF_SET	OUT_OF_SET	OUT_OF_SET
F09	INCONCLUSIVE	INCONCLUSIVE	INCONCLUSIVE
F10	STANDARD	STANDARD	STANDARD
F11	ESCALATE	ESCALATE	ESCALATE
F12	OUT_OF_SET	OUT_OF_SET	OUT_OF_SET
F13	INCONCLUSIVE	INCONCLUSIVE	INCONCLUSIVE
F14	Two independent labels	Two independent labels	STANDARD / STANDARD
Independently recomputed results:
Check	Result	Evidence status
Distinct fixture IDs	14	Recomputed
Underlying synthetic cases, including F14A/F14B	15	Recomputed from runner definitions
ESCALATE cases	2	Recomputed
STANDARD cases	3	Recomputed
INCONCLUSIVE cases	5	Recomputed
OUT_OF_SET cases	3	Recomputed
F14 grouped case	1	Recomputed
R-A passing fixtures	14/14	Recomputed
R-B passing fixtures	14/14	Recomputed
Passing fixtures across two paths and two production runs	56/56 reported	Recomputed from four logged 14/14 results
F03 expected versus observed	STANDARD = STANDARD	Recomputed
F14 is represented as one reported fixture containing two underlying records, not as two separately counted fixtures.
Evidence: r_a_fixture_results.csv, r_b_fixture_results.csv, run_RA.R, RB_40_fixtures.R, both production logs.
3.2 F03 arithmetic
The frozen F03 case specifies:
Variable	Value
Dormancy	2,400 hours = 100 days
Peer P75	2,160 hours = 90 days
κ	2
Escalation threshold	4,320 hours = 180 days
Margin below threshold	1,920 hours = 80 days
Expected classification	STANDARD
R-A observed	STANDARD
R-B observed	STANDARD
The decisive comparison is:
\[
2400 < 2(2160)=4320
\]

Therefore, STANDARD is consistent with the frozen κ-dependent dormancy rule.
The ratio is:
\[
\frac{2400}{2160}=1.1111\ldots < 2
\]

Status: Recomputed.
Additional check: F03's creation age is 120 days, also less than the κ-adjusted 180-day threshold. Therefore, F03 independently confirms its expected classification, but does not by itself distinguish dormancy-based classification from a mistaken creation-age implementation that still uses the same κ-adjusted threshold. F02 is a stronger discriminating example for that particular mistake.
Evidence: KNOWN_CASE_FIXTURE_PACK_LOCKED.md, run_RA.R, RB_40_fixtures.R, both fixture-result CSVs.
3.3 Other numerical fixture checks
Fixture	Calculation	Result
F01	480 ≥ 2 × 168 = 336	ESCALATE
F02	24 < 2 × 168 = 336	STANDARD
F03	2,400 < 2 × 2,160 = 4,320	STANDARD
F10	96 < 2 × 72 = 144	STANDARD
F11	192 ≥ 2 × 72 = 144	ESCALATE
All calculations are independently recomputed.
Other fixtures exercise integrity conditions, exclusion rules, missing values, and decision grain rather than relying solely on numerical thresholds.
3.4 First production run — before timezone correction
September 19, 2026, 12:56 CT
Metric	R-A	R-B	R-B − R-A
Decision rows	222,002	222,002	0
ESCALATE	131,968	132,072	+104
INCONCLUSIVE	6,377	6,377	0
STANDARD	83,657	83,553	−104
Fixtures passing	14/14	14/14	0
Arithmetic checks:
\[
131968+6377+83657=222002
\]

\[
132072+6377+83553=222002
\]

Thus both portfolios sum correctly to their reported decision counts.
The portfolio differences independently establish 104 additional ESCALATE labels in R-B and 104 fewer STANDARD labels in R-B.
However, aggregate counts establish a minimum of 104 row-level disagreements, not necessarily exactly 104. The statement that exactly 104 records disagreed, all STANDARD in R-A versus ESCALATE in R-B, is quoted from EXACT_RECON_REPORT.md; the first-run disagreement IDs and row-level reconciliation output were not preserved.
The nrow 104 appearing near the beginning of the first production log refers to the peer-type table, not the disagreement list.
Status: Portfolio totals and deltas recomputed; exact original disagreement count and direction quoted.
3.5 Second production run — after timezone correction
September 19, 2026, 13:46 CT
Metric	R-A	R-B	R-B − R-A
Decision rows	222,002	222,002	0
ESCALATE	131,968	131,968	0
INCONCLUSIVE	6,377	6,377	0
STANDARD	83,657	83,657	0
Fixtures passing	14/14	14/14	0
Between runs, R-A's portfolio did not change.
R-B's portfolio changed by:
- ESCALATE: −104
- STANDARD: +104
- INCONCLUSIVE: 0
- Decision rows: 0
These changes exactly eliminate the aggregate differences.
Status: Recomputed.
3.6 Post-fix reconciliation
Reconciliation metric	Value	Status
R-A rows	222,002	Quoted from execution output
R-B rows	222,002	Quoted from execution output
Matched rows	222,002	Quoted
Only R-A	0	Quoted
Only R-B	0	Quoted
Agreements	222,002	Quoted
Disagreements	0	Quoted
Disagreement-file data rows	0	Recomputed from inline CSV
Agreement rate	100%	Recomputed
The reconciliation output is internally arithmetically consistent:
\[
222002+0+0=222002
\]

\[
222002+0=222002
\]

run_recon.R demonstrates comparison of SR_NUMBER and classification. It does not establish exact equality of all intermediate numerical fields.
Evidence: RECON_SUMMARY.csv, RECON_DISAGREE_IDS.csv, run_recon.R, EXACT_RECON_REPORT.md.
3.7 Source population and exits
Check	Value	Status
Open source records	245,193	Quoted
Decision records	222,002	Quoted
Excluded/out-of-set difference	23,191	Recomputed
Peer types	104	Quoted
R executions across both runs	4	Recomputed
R execution exits reported as zero	4	Recomputed from logs
Source Gate checks	15 PASS, 0 FAIL, 2 INFO	Quoted
\[
245193-222002=23191
\]

The difference agrees with RB_portfolio_counts.csv's reported n_out_of_set = 23191.
3.8 Fixture Gate and production chronology
Event	September 19, 2026 (CT)	Status
Source Gate report	Approximately 07:30	Quoted
Fixture Gate locked	10:26:37	Quoted
First production run began	12:56:16.755	Quoted
Time from fixture lock to first production	2h 29m 39.755s	Recomputed
Timezone-fix rerun began	13:46:08.354	Quoted
Post-fix reconciliation completed	13:46:45.235	Quoted
The recorded Fixture Gate lock precedes the first production run.
The timestamps therefore support the claimed ordering, subject to the stated limitation that the lock receipt has no externally authenticated timestamp.
Evidence: FIXTURE_GATE_RECEIPT.md, PRODUCTION_RUN1_DECODED.txt, PRODUCTION_RERUN_TZFIX_DECODED.txt.
The evidence manifest contains 55 path/hash entries, representing 53 distinct reported hashes. These counts were recomputed from the supplied manifest text. The hashes themselves were not independently recalculated against all original files because many files were supplied only by hash.
4. P1 assessment against the frozen predicate
The frozen P1 states that removing the mandatory pre-builder Fixture Gate reduces steps while maintaining equal detection coverage for the production clock-skew defect and construct boundaries, including F03, without increasing shipped wrong labels.
Two distinct kinds of detection must be evaluated.
4.1 What the Fixture Gate detected
The Fixture Gate demonstrated that both implementations satisfied the reported frozen known-case expectations.
Specifically:
- R-A and R-B each passed F01–F14.
- F03 was classified as STANDARD.
- Integrity and exclusion examples received their expected classifications.
- The F14 case reported independent labeling at the SR_NUMBER grain.
The gate provided evidence of agreement with predetermined behavioral expectations, not merely agreement between implementations.
The Fixture Gate did not detect the production timezone defect.
Both paths returned 14/14 PASS in the first production run, even though their production portfolio counts differed.
This is consistent with the fixture runners using in-process synthetic timestamps instead of exercising the full production CSV ingestion path.
4.2 What exact reconciliation detected
The production comparison exposed an aggregate difference of 104 ESCALATE classifications and an opposite difference of 104 STANDARD classifications.
The supplied reconciliation report attributes this to 104 row-level disagreements.
Following timezone correction, the production reconciliation recorded:
- 222,002 matching identifiers;
- 222,002 matching labels;
- zero disagreements;
- zero unmatched records.
The recorded results support the narrower conclusion that the independent production paths ultimately agreed on all compared classifications.
They do not independently prove that every classification was semantically correct.
4.3 What optional or post-hoc fixtures would leave unprotected
Exact reconciliation alone does not independently determine whether both implementations respect the frozen known-case semantics.
Examples of errors that could pass a label-only reconciliation if both paths made the same mistake include:
- Applying a shared incorrect dormancy threshold.
- Substituting creation age for dormancy.
- Misapplying an exclusion rule in both paths.
- Giving the same incorrect label to an integrity-failure case.
- Accidentally changing the decision grain.
- Agreeing on an incorrect interpretation of F03.
- Adopting modified fixture expectations that accommodate the implementation rather than testing it.
These are potential undetected common-mode errors, not demonstrated wrong production labels in this experiment.
Post-hoc fixtures could still reveal semantic mistakes if they remained frozen, independent, and mandatory before output authorization. Making fixture execution optional removes that assured checkpoint.
4.4 P1 evidentiary status
P1 component	Evidence-based assessment
Reduced mandatory steps	Follows from the proposed procedure; no measured execution-time reduction supplied
Detection of production timezone disagreement	Supported for cross-path comparison
Equal construct-boundary detection	Not established by label reconciliation alone
F03 correctness without fixture enforcement	Not independently demonstrated
No increase in shipped wrong labels	No observed shipping regression supplied; counterfactual not independently established
No silent semantic drift	Cannot be established from cross-path label agreement alone
Factual assessment: The evidence supports the usefulness of exact reconciliation for the observed production discrepancy, but does not establish that it provides the same semantic protection as a mandatory frozen Fixture Gate.
No terminal state is assigned.
5. Fixture and reconciliation implications
5.1 The two mechanisms are complementary
The fixture suite and reconciliation address different failure modes.
The fixture suite tests conformance to known-case expectations. Reconciliation compares the results produced by independent implementations.
In this experiment, the controls exercised different capabilities.
The fixture results remained green while the first production portfolios diverged. The eventual classification agreement did not retroactively make the known-case expectations unnecessary.
Conversely, the Fixture Gate PASS was insufficient to establish that both production implementations handled their timestamp input correctly.
This demonstrates a practical distinction:
A fixture PASS does not guarantee correct production ingestion, and reconciliation agreement does not guarantee correct shared semantics.
5.2 Clock-skew defect
The supplied EXACT_RECON_REPORT.md attributes the original production disagreement to timestamp handling.
The stated causal sequence is:
1. SQL exports contained naive wall-clock timestamps.
2. The CSV reader could interpret those values as UTC.
3. R-A and R-B handled those representations differently.
4. Derived dormancy values differed by approximately five hours.
5. Near-threshold records received different classifications.
6. A consistent America/Chicago wall-clock interpretation eliminated the observed label disagreements.
The revised parsing code is consistent with that diagnosis.
R-A's parse_ts_chicago and R-B's rb_parse_ts explicitly recover timestamp strings and parse them as America/Chicago wall times.
R-B's CSV reader additionally specifies character column types for relevant clock fields.
The post-fix agreement supports successful resolution of the observed classification disagreement.
The precise five-hour discrepancy and affected record identities remain quoted diagnostic findings rather than independently reconstructed observations.
5.3 Why the Fixture Gate missed the timezone problem
R-A constructs synthetic input rows internally through build_fixture_pack.
R-B constructs synthetic rows internally through rb_build_fixture_pack.
Those fixtures are then passed to the classification functions.
They do not reproduce the complete path in which production SQL exports are loaded from files through the CSV reader and normalized.
Therefore, a production CSV parsing defect may remain invisible to fixtures whose timestamps are created within the R process.
The actual first run is an example of that limitation: both fixture suites passed while the production classifications differed.
5.4 F03 and semantic sign-off
F03 captures the intended classification STANDARD for a case with 100 days of dormancy and a peer P75 of 90 days when κ=2.
The owner-approved Fixture Gate makes that result an implementation-independent obligation.
Under optional fixtures, two paths could agree on a different classification without label reconciliation alone demonstrating the violation of the frozen expected result.
There is also a limitation in F03's discriminatory strength. Its 120-day creation age falls below the 180-day κ-adjusted threshold. Consequently, F03 does not isolate every plausible creation-age substitution error.
F02, with 40 days of creation age and only one day of dormancy against a 14-day threshold, more directly discriminates between raw age and dormancy.
This does not invalidate F03's observed result; it clarifies which specific semantic mistakes the fixture can independently expose.
5.5 Reconciliation scope
The supplied run_recon.R performs equality checks for the classification field after joining by SR_NUMBER.
It also collects diagnostic fields for disagreed records.
However, the script does not directly enforce field-by-field equality for:
- dormant_h;
- peer_n;
- peer_p75_h;
- open_age_h;
- kappa;
- integrity_clause.
Therefore, the demonstrated reconciliation is an exact classification reconciliation, not a full intermediate-state reconciliation.
The evidence shows correct post-fix label agreement, not independent verification of equality across every calculation feeding those labels.
6. Semantic/regression risks and unchanged surfaces
6.1 Semantic risks
Risk	Mechanism	Evidence-based implication
Common-mode semantic error	Both paths apply the same wrong interpretation	Label reconciliation can pass
Construct drift	Expected behavior is not enforced before implementation	Independent semantic checkpoint is weakened
Post-hoc rationalization	Expected outcomes are adjusted to match code	A failed fixture can be concealed
Timestamp ingestion defect	Synthetic fixtures bypass production CSV parsing	Fixtures can pass despite production disagreement
Incomplete reconciliation	Only final labels are compared	Intermediate discrepancies can remain invisible
Shared fixture weakness	Tests do not distinguish all plausible incorrect implementations	Green results can overstate semantic coverage
The locked fixture pack explicitly prohibits rewriting a failed fixture to make the code pass.
That prohibition must remain binding regardless of the disposition of the proposed Fixture Gate change.
6.2 Fixture implementation risks
The R-A and R-B fixture suites agree on their expected labels but do not use identical numerical input values for every case.
For example, F04, F06, and F09 differ in selected dormancy or peer-statistic inputs across the two fixture-result CSVs.
The variations preserve the intended category-level behavior, but reduce the strength of a claim that both implementations were tested on byte-identical synthetic cases.
There is also an implementation-level weakness in the supplied R-B F14 rollup:
f14_pass <- all(f14$pass)


Unlike the R-A runner, this statement does not independently require that exactly two F14 records exist.
Because all(logical(0)) evaluates to TRUE in R, an empty F14 subset could satisfy that particular pass expression.
The actual supplied output does show both F14 labels. This is therefore a latent regression risk, not an observed failure of the reported F14 result.
6.3 Expected unchanged surfaces
The specification identifies the following protected surfaces:
Surface	Required condition	Assessment from supplied evidence
Chicago frozen pack	Unchanged	Declared unchanged; no new computation
κ	Default remains 2	Confirmed in fixtures and production outputs
T_freeze	September 12, 2026, 23:59:59 America/Chicago	Confirmed in reports and logs
SQL nonjudgment	SQL performs source preparation, not classification judgment	Source Gate reports PASS for no judged columns
Dual independent paths	R-A and R-B retained	Both executed and produced separate outputs
Original A02 history	Preserved unchanged	Explicitly declared in A02R specification
Baseline framework versions	Identical baseline hashes	Listed consistently; not independently verified against full original files
Frozen fixture expectations	Must remain unchanged after failure	Required in specification and locked pack
A02R declares no new production execution, fixture changes, code repairs, or modified expected values.
The manifest supplies hashes for the evidence set, but not all underlying files are available inline for independent byte-level comparison.
6.4 Regression rule
The governing rule remains:
A failed fixture is evidence against an implementation, not authorization to change the expected fixture result.

A regression in a frozen behavioral expectation cannot be repaired by redefining the expected behavior in response to the failed test.
Any legitimate change in semantics would require its own authorized design-amendment and freezing process, rather than a silent fixture rewrite.
Evidence: ORIGINAL_A02_ABLATION_SPEC.md, CONSTITUTION_v1.md, KNOWN_CASE_FIXTURE_PACK_LOCKED.md, run_RA.R, RB_40_fixtures.R, SOURCE_GATE_REPORT.md.
7. Claim → evidence map
Claim	Evidence item(s)	Support
A02R tests removal of mandatory pre-builder fixtures	ABLATION_SPEC_A02R.md; ORIGINAL_A02_ABLATION_SPEC.md	Direct specification
The benefit predicate is unchanged	Both ablation specifications	Direct textual match
Fixture pack contains F01–F14	KNOWN_CASE_FIXTURE_PACK_LOCKED.md; run_RA.R; RB_40_fixtures.R	Direct
Both implementations passed all 14 fixtures	r_a_fixture_results.csv; r_b_fixture_results.csv; both production logs	Independently counted
F03 expected and observed STANDARD	Both fixture-result CSVs; FIXTURE_GATE_RECEIPT.md	Direct and independently checked
F03 satisfies the threshold	Fixture values; κ=2 in FIXTURE_GATE_RECEIPT.md	Arithmetic recomputed
The Fixture Gate was locked before production	FIXTURE_GATE_RECEIPT.md; PRODUCTION_RUN1_DECODED.txt	Timestamp ordering recomputed
First production portfolios differed	PRODUCTION_RUN1_DECODED.txt	Recomputed category deltas
Exactly 104 records disagreed in the first run	EXACT_RECON_REPORT.md	Quoted; original row-level reconciliation unavailable
Clock parsing produced approximately five hours of skew	EXACT_RECON_REPORT.md; LINEAGE_ATTESTATION.md	Diagnostic claim, not independently reproduced
Clock-handling code was revised	run_RA.R; RB_10_io_parse.R	Direct code inspection
Post-fix portfolio counts matched	PRODUCTION_RERUN_TZFIX_DECODED.txt; RA_portfolio_counts.csv; RB_portfolio_counts.csv	Independently compared
Post-fix reconciliation showed zero label disagreements	RECON_SUMMARY.csv; RECON_DISAGREE_IDS.csv; run_recon.R	Direct execution evidence
Fixture runners use internally constructed inputs	run_RA.R; RB_40_fixtures.R	Direct code inspection
Source Gate reported no judged SQL columns	SOURCE_GATE_REPORT.md	Quoted PASS
The fixture-rewrite prohibition remains binding	ORIGINAL_A02_ABLATION_SPEC.md; KNOWN_CASE_FIXTURE_PACK_LOCKED.md	Direct
SHA-256 manifest exists	EVIDENCE_MANIFEST_A02R.sha256 listing	Direct listing; files not all independently hashed
Exact reconciliation compares classifications rather than every intermediate state	run_recon.R	Direct code inspection
F03 does not independently exclude all creation-age mistakes	run_RA.R; RB_40_fixtures.R; frozen F03 parameters	Independently derived
R-B F14 rollup lacks an explicit two-row check	RB_40_fixtures.R	Direct code inspection
The unchanged framework baseline is identified	BASELINE_FRAMEWORK.sha256; evidence manifest	Hashes quoted
8. Missing or weak evidence noticed
The following limitations are relevant to the strength and reproducibility of the claims. They are not terminal-state determinations.
1. First-run disagreement identifiers are missing.
The individual SR_NUMBER values for the original reported 104 disagreements were not preserved.
The first-run portfolio counts establish a minimum of 104 differing classifications, while EXACT_RECON_REPORT.md supplies the exact 104-row assertion.
That assertion cannot be independently reconstructed from the supplied first-run aggregate counts.
2. The original row-level clock-skew diagnostics are incomplete.
The approximately five-hour discrepancy, its direction, and the statement that all affected records lay close to their thresholds are reported in EXACT_RECON_REPORT.md.
The underlying first-run disagreement records and their intermediate timestamps are unavailable.
The code and post-fix reconciliation are consistent with the diagnosis, but cannot independently recreate it.
3. Manifest coverage is not the same as independent hash verification.
The manifest provides 55 entries.
Many corresponding files, including original mixed-encoding logs and complete source modules, are represented by hashes rather than full inline content.
Consequently, the listed hashes and full frozen-file identity cannot all be independently verified from this packet alone.
4. Fixture-lock timing has no independent timestamp authority.
The receipt reports a 10:26:37 CT lock, earlier than the first production start.
The temporal ordering is consistent with that evidence.
However, the report does not supply externally authenticated timestamp evidence.
Additionally, SOURCE_GATE_REPORT.md, dated approximately 07:30 CT, references Fixture Gate PASS even though the supplied locked receipt is timed at 10:26:37 CT. That could reflect a prior pass or retrospective document updating; the exact chronology of the earlier PASS is not established.
5. The first-run exact reconciliation output is absent.
The first production log supplies separate classifications and portfolio totals but does not include the rowwise reconciliation demonstrated in the post-fix log.
Accordingly, the reported initial 104-row exact disagreement is less independently auditable than the zero-disagreement post-fix result.
6. The demonstrated reconciliation checks final labels, not every critical intermediate field.
run_recon.R compares classifications keyed by SR_NUMBER.
It does not enforce equality of all numerical inputs or intermediate decisions.
The post-fix evidence therefore supports complete agreement of reported labels, but not complete equality of all computational states.
7. Fixture inputs differ between the R-A and R-B implementations.
The fixtures test the same named constructs and produce the same expected labels, but some numerical parameters differ.
That limits strict case-for-case comparison even though the reported categorical outcomes match.
8. F03 is not a complete discriminator of an incorrect age-based rule.
The frozen case's creation age is 120 days, below the κ-adjusted threshold of 180 days.
An implementation substituting creation age for dormancy while retaining that threshold could still classify F03 as STANDARD.
F02 provides stronger coverage for this particular mistake. The frozen F03 result remains correct, but the breadth of its claimed semantic protection should not be overstated.
9. R-B F14 aggregation has a potential vacuous-pass weakness.
The supplied code tests all(f14$pass) without an explicit nrow(f14) == 2 condition.
The observed fixture output contains both expected labels, so the present result is not contradicted.
The code nevertheless permits a latent completeness weakness.
10. The mechanical-facts JSON has a fixture-field extraction inconsistency.
A02R_FACTS.json shows null values for the R-B F03 fields under the fixture_csvs extraction.
The actual r_b_fixture_results.csv contains expected_classification=STANDARD and observed_classification=STANDARD, and the production logs confirm the same.
This appears to be an extraction-schema issue in the facts-generation process rather than an observed F03 failure.
11. The production workload has not been executed under the proposed optional-fixture procedure.
A02R reuses the original production results and intentionally performs no new computation.
The evidence permits examination of which safeguards detected the observed discrepancies, but does not directly measure the outcomes, saved time, or shipping risks of a newly executed production-first configuration.
This matters when distinguishing demonstrated detection coverage from counterfactual predictions.
12. Execution warnings remain present in the logs.
The PowerShell logs include NativeCommandError wrappers despite reported R exit codes of zero.
The post-fix R-B log also includes column-parser warnings.
Neither is accompanied by an observed failed classification run in the supplied evidence, but their presence means the logs are not warning-free. Their effect on the specific observed outputs is not demonstrated.

The supplied evidence establishes passing known-case fixtures, a production classification divergence before timezone correction, and zero reported classification disagreements afterward. It demonstrates the distinct functions of fixture-based semantic checking and cross-path reconciliation. It does not establish their interchangeability.
END A02 BUILDER REPORT
