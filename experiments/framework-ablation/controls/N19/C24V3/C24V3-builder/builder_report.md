C24 v3 — Independent Builder Report
1. Role attestation and ablation ID
Role: Builder — ChatGPT
Review mode: Independent first pass, blind to Validator
Ablation: C24 v3 — Mechanical vs Judged Population
Catalog: #24
Batch: N19
Constitution: Version 1.0
Target: Stage 4 source extraction and R population judgment
I have examined the supplied C24 v3 packet and independently recalculated the numerical identities and comparisons available from its evidence tables. I have not received or relied on a Validator report.
This assessment is limited to the supplied packet. The original multi-gigabyte extracts and executable run artifacts are not independently available for re-execution here. Accordingly, numerical arithmetic and comparisons of reported hashes are independently checked, while underlying execution and file-hash values are treated as recorded evidence.
The original frozen control, operational predicate P1, and constitutional rules remain unchanged.
The N13 and N18 records remain distinct historical attempts. C24 v3 is the chunked re-execution of the COLLAPSED R processing, not a replacement of their preserved evidence.
2. Conceptual diff: control removed and exact seeded changes
A. Control under test
The control separates two operations:
1. Mechanical SQL extraction: establish a broad, explicitly defined source envelope.
2. Judged R population: apply the final inclusion, exclusion, integrity, and classification rules.
The separated reference arm B uses:
WHERE r.STATUS = 'Open'


The COLLAPSED arm removes this SQL restriction and supplies the full source table to R.
Consequently:
Property	Arm B	COLLAPSED
SQL population restriction	STATUS = 'Open'	No status restriction
Input rows	245,193	14,635,395
Final judgment	R-A / R-B	R-A / R-B
Peer-statistics source	Frozen Envelope B	Same frozen Envelope B
Judgment rules	Frozen	Frozen
R production reading	Whole table	Chunked
Intended final decision population	Same	Same
The ablation tests whether moving the population boundary entirely into R preserves the required output behavior.
B. SQL seed changes
Under the original frozen SPEC:
- X_SEP.sql retains the WHERE r.STATUS = 'Open' condition.
- X_FULL.sql removes that condition.
- The COLLAPSED extract carries the descriptive label NONE (full table; envelope applied in R).
- The selected columns, ordering by SR_NUMBER, and remaining query structure are specified as unchanged.
- src_peer_stats.csv and src_extract_lineage.csv remain unchanged.
The packet identifies the SQL change precisely but does not reproduce the complete SQL patch. No additional SQL edits can be independently inferred.
C. C24 v3 R implementation changes
The supplied CODE DIFF: frozen scripts vs chunked scripts identifies run_production() as the modified function in both R paths.
R-A changes:
- Replace whole-table read_tsv() loading with read_tsv_chunked().
- Establish character column types from the input header.
- Use C24_CHUNK_ROWS, defaulting to 250,000.
- Execute the frozen classify_open_rows() on successive chunks.
- Accumulate decision and classification counts.
- Append classifications to a .partial file.
- Rename the partial file after completion.
- Construct portfolio counts from the accumulated counts rather than the complete in-memory decision table.
R-B changes:
- Replace rb_read_csv_flex() whole-table loading with chunked reading.
- Preserve rb_normalize_open(), rb_judge_rows(), rb_portfolio_counts(), and rb_kappa_grid_counts().
- Apply those functions separately to each chunk.
- Accumulate portfolio counts through addcnt().
- Accumulate kappa-grid counts by corresponding kappa values.
- Append classified rows to a partial output before final rename.
The important feature of R-B is that rb_portfolio_counts() remains unchanged. It receives each chunk's judged rows, including rows excluded from the final population, and its counters are added across chunks.
This is directly relevant to the observed n_out_of_set difference.
D. Other v3 execution changes
The addendum specifies:
- Chunk size: 250,000 rows.
- Pre-run free-memory threshold: reduced from 19,968 MB to 6,144 MB.
- MEMKILL threshold: unchanged at 2,048 MB.
- Per-R-run limit: unchanged at 14,400 seconds.
- No changes to tolerances or P1.
- Arm B outputs and SQL evidence carried forward from C24 v2 after hash verification.
The interrupted runner was resumed at 11:51 CDT for R-B only. The coordinator discloses that run_c24v3_resume.ps1 was not included in the frozen seed list.
Sources: SPEC, “Exact change being tested”; SPEC ADDENDUM v3, “What changes in v3”; CODE DIFF, R-A lines 500–548 and R-B lines 96–143; COORDINATOR NOTE.
3. Hard mechanical facts table
Status terminology:
- Recomputed: independently calculated from supplied values.
- Quoted: directly recorded in the packet.
- Compared: independently compared the supplied strings or table entries; original files were not rehashed.
A. SQL and population identities
Mechanical fact	Result	Basis
SQL total rows	14,635,395	Quoted
Canceled	212,654	Quoted
Closed	1	Quoted
Completed	14,177,547	Quoted
Open	245,193	Quoted
Sum of all statuses	14,635,395	Recomputed
Full extract rows	14,635,395	Quoted
Separated extract rows	245,193	Quoted
Non-Open rows	14,390,202	Recomputed
Decision rows, each arm/path	222,002	Quoted
Excluded from arm B	23,191	Recomputed
Excluded from COLLAPSED	14,413,393	Recomputed
Difference in excluded counts	14,390,202	Recomputed
Decision retention among Open rows	90.5417%	Recomputed
The status identity is:
\[
212,654+1+14,177,547+245,193=14,635,395
\]

The separated population identity is:
\[
245,193-222,002=23,191
\]

The collapsed population identity is:
\[
14,635,395-222,002=14,413,393
\]

The excluded-count delta therefore equals the population introduced by removing the SQL status restriction:
\[
14,413,393-23,191=14,390,202
\]

\[
14,635,395-245,193=14,390,202
\]

These two independently calculated differences agree exactly.
Source: C24V3_RESULTS.md, “SQL query counts vs final analytic set,” rows total, status=*, envelope_open, and four R decision rows; COORDINATOR NOTE, n_out_of_set figures.
B. Portfolio classifications and deltas
The supplied R-B portfolio row and coordinator note establish:
Metric	Arm B	COLLAPSED	Delta
kappa	2	2	0
n_decision	222,002	222,002	0
n_ESCALATE	131,968	131,968	0
n_INCONCLUSIVE	6,377	6,377	0
n_STANDARD	83,657	83,657	0
n_out_of_set	23,191	14,413,393	+14,390,202
Status: portfolio values quoted from the supplied packet; delta values recomputed. The full arm-B CSV row is not reproduced, so its values are also corroborated by the coordinator note and population arithmetic.
Classification accounting:
\[
131,968+6,377+83,657=222,002
\]

The three categories exhaust the reported decision population.
The counts have no cross-arm difference except n_out_of_set.
C. Agreement identities and D-sets
The packet supplies byte-identical classification outputs for B and COLLAPSED separately within R-A and R-B.
For a same-path, cross-arm comparison:
Quantity	R-A: B vs COLLAPSED	R-B: B vs COLLAPSED	Basis
n_inner	222,002	222,002	Derived from identical files and decision counts
n_agree	222,002	222,002	Derived
n_disagree	0	0	Derived
n_agree + n_disagree	222,002	222,002	Recomputed
Classification difference set	∅	∅	Derived from hash equality
This establishes the identity:
\[
n_{\text{agree}}+n_{\text{disagree}}
=n_{\text{inner}}=222,002
\]

Here, agreement means identical rows in the same path's classification file across the two arms.
This is not a claim that R-A and R-B agree on every numeric field with one another. The packet preserves the known OF-1 discrepancy on three timestamp fields.
For the seven-file key-output set:
\[
D_{\text{key outputs}}
=\{\texttt{RB\_portfolio\_counts.csv}\}
\]

For the identified portfolio field set:
\[
D_{\text{portfolio fields}}
=\{\texttt{n\_out\_of\_set}\}
\]

A separately defined cross-path R-A-versus-R-B n_inner, full n_agree, and complete field-level D-set cannot be reconstructed from the aggregate tables alone.
Sources: C24V3_RESULTS.md, “7 key outputs” rows RA_classifications.csv and RB_classifications.csv; COLLAPSED RB_portfolio_counts.csv; COORDINATOR NOTE; SPEC, “Known open finding N1 / OF-1.”
D. Seven required file hashes
The following are comparisons of reported SHA-256 strings.
Key output	COLLAPSED = B	B = frozen
RA classifications	Yes	Yes
RB classifications	Yes	Yes
RA fixtures	Yes	Yes
RB fixtures	Yes	Yes
RA portfolio counts	Yes	Yes
RB portfolio counts	No	Yes
RB kappa grid	Yes	Yes
Recomputed equality tally:
- COLLAPSED versus B: 6 of 7 equal, 1 unequal.
- B versus frozen: 7 of 7 equal.
- COLLAPSED versus frozen: 6 of 7 equal, 1 unequal.
The differing hashes are:
Arm B:
eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c
COLLAPSED:
9f0f050a19c5131660bd7ae9b58b6ef6babb63cffea88577d3948851012b15ea
The corresponding file sizes are 100 bytes for B and 103 bytes for COLLAPSED.
The supplied CSV row and coordinator note identify n_out_of_set as the sole differing field. The differing full-file hashes are consistent with that identified change.
Sources: C24V3_RESULTS.md, seven-row “7 key outputs” table; ARM MANIFESTS, B and COLLAPSED MANIFEST_outputs.sha256, corresponding seven file rows.
E. Execution facts and resource deltas
Metric	B R-A	COLLAPSED R-A	B R-B	COLLAPSED R-B
Exit code	0	0	0	0
Duration (seconds)	19.9	346.9	24.9	1,132.5
Peak R memory (MB)	519	6,412	720	8,346
Minimum free memory (MB)	20,803	13,346	20,452	13,702
Fixtures passed	14/14	14/14	14/14	14/14
Recomputed:
- R-A runtime increase: 327.0 seconds, or approximately 17.43 times B.
- R-B runtime increase: 1,107.6 seconds, or approximately 45.48 times B.
- R-A peak-memory increase: 5,893 MB.
- R-B peak-memory increase: 7,626 MB.
- Combined COLLAPSED R processing time: 1,479.4 seconds.
- Four run/path combinations report 56 of 56 fixture executions passing.
The full extract is approximately 59.69 times the separated extract in row count and 68.82 times its size in bytes.
The reported 250,000-row chunk size implies 59 chunks for 14,635,395 input rows, assuming regular chunk partitioning. The packet does not reproduce every callback line, so this is a calculated expectation rather than an independently verified logged chunk count.
The SQL CHECKSUM bracket contains four matching PRE/POST values:
Table	PRE	POST
raw_311_requests	727006061	727006061
src_open_candidates	1392669554	1392669554
src_peer_stats	791123155	791123155
src_extract_lineage	2028659591	2028659591
All four reported checksum values match between PRE and POST. The evidence manifest additionally reports equal SHA-256 digests for CK_PRE.tsv and CK_POST.tsv.
Sources: C24V3_RESULTS.md, “R runs,” “Extracts,” and CHECKSUM bracket; C24V3_arms.csv, four rows; EVIDENCE SHA256, CK_PRE.tsv and CK_POST.tsv.
4. P1 assessment against the frozen predicate
The four conditions below reproduce the predeclared P1 requirements without amending their meaning.
P1 condition	Evidence	Assessment
1. SQL extract row counts reconcile to SQL source counts	Full = 14,635,395; Open = 245,193; both equal their corresponding extracts	MET
2. COLLAPSED R-A and R-B exit successfully	Both exit 0; neither reaches memory or duration guard	MET
3. All seven key outputs byte-identical to arm B	Six match; RB portfolio counts differs	NOT MET
4. Every COLLAPSED fixture passes on both paths	R-A 14/14, R-B 14/14	MET
Mechanical P1 result: NOT MET.
This is the same result reported by the supplied evaluator, independently supported by the displayed seven-file hash table.
The failed condition is narrowly identifiable: the R-B portfolio count retains the number of excluded rows from its input population. Because the COLLAPSED input contains all statuses, that output differs from the reference arm even while the final classifications remain byte-identical.
The frozen predicate explicitly requires equality of the complete seven-file set. Equality of six files, or equality of only the final decision metrics, is insufficient to satisfy condition 3.
No terminal adjudication state is assigned in this report.
Sources: SPEC, “Operational benefit predicate P1,” conditions 1–4; C24V3_RESULTS.md, “Predicate conditions,” four rows; “7 key outputs,” RB_portfolio_counts.csv row.
5. Fixture and reconciliation implications
A. Behavioral fixture coverage
All four arm/path runs report 14 of 14 fixtures passing.
The two pre-freeze chunking equivalence tests also report matching seven-file outputs:
- T1: 245,193-row arm-B extract, chunked against whole-table reference; 7/7 equal.
- T2: 1,245,193-row sample, whole-table against chunked; 7/7 equal.
The T2 sample reported 238,746 decision rows, and both implementations produced the same corresponding file hashes.
These tests support the chunked implementation's equivalence to whole-table processing on the tested data. They do not override the full-run P1 mismatch.
B. Final analytic population
The matching classification-file hashes provide stronger evidence than matching portfolio totals alone.
For each R path, B and COLLAPSED produce byte-identical classification outputs. Therefore, on the reported files, the final decision rows, row ordering, labels, and serialized critical reconciliation fields are preserved across arms.
There is no reported classification regression attributable to the SQL-envelope collapse.
C. Reconciliation failure is localized
The difference is not in the 222,002 decision rows, their classification totals, or the kappa grid.
It is in the population-accounting field n_out_of_set, whose denominator changes with the source envelope.
This exposes an important distinction:
Final judged-population equivalence has been demonstrated in the output files, but complete portfolio-output equivalence has not.
The current portfolio schema makes the number of excluded input rows part of the required output. Consequently, changing the input population changes one required count even when the final analytic set is preserved.
D. Outstanding reconciliation limitations
The supplied packet does not include the raw classification rows for a fresh cross-path field-by-field R-A-versus-R-B reconciliation. It therefore does not independently resolve the known OF-1 finding involving three one-hour timestamp discrepancies.
Likewise, fixture pass totals and matching fixture-file hashes establish the reported fixture outcome, but individual fixture expected/actual rows are not reproduced for separate manual inspection.
Sources: EQUIVALENCE TESTS, T1 seven output rows and T2 whole/chunked matching output rows; C24V3_RESULTS.md, “R runs” and “7 key outputs”; SPEC, “Known open finding N1 / OF-1.”
6. Semantic/regression risks and unchanged surfaces
A. Population-accounting semantics
Observed issue: n_out_of_set is dependent on the input extraction boundary.
Its meaning differs operationally across arms:
- In B, it counts rows excluded after the SQL Open envelope.
- In COLLAPSED, it counts excluded rows across the full source table.
Those are different accounting populations.
This is not evidence that the final decision classifications are incorrect. It is evidence that the outputs are not semantically interchangeable in every declared field.
The frozen P1 condition requires byte equality without an exception for source-population-dependent counters.
B. Chunking correctness
The supplied rationale that judgments are row-local and depend only on a frozen peer-statistics table is compatible with chunk processing.
T1, T2, and the full-run classification hashes support equivalence for the current code and inputs.
A future modification introducing cross-row deduplication, window calculations, ranking, or a statistic calculated from the current extract could invalidate the same chunking argument. The current tests do not establish equivalence for such future logic.
C. Runtime and resource effects
The COLLAPSED path requires substantially more processing.
The v2 whole-table approach was MEMKILLed; the v3 chunked approach succeeded within the unchanged memory guard.
However, the full extract increases R runtime substantially, especially in R-B.
These are operational costs, not separate P1 failures, because the frozen predicate explicitly treats resource use as reported rather than gated once successful execution is achieved.
D. Execution interruption and provenance
The v3 runner was interrupted after R-A completed and before R-B started. The resumed execution completed R-B.
The resume script is disclosed but not included in SEEDS_C24V3.sha256. The supplied note states that it reused the same R execution code, guard, and chunk size.
The supplied packet is consistent with a successful resumed run, but it does not provide the complete resume script or an independent diff against the original runner. That provenance limitation should remain visible to validation and adjudication.
The interruption alone does not demonstrate changed computational results, and no such change should be invented.
E. Unchanged surfaces
The supplied frozen specifications, hashes, and output comparisons support the following unchanged areas:
Surface	Evidence
Constitution v1.0	Frozen SPEC and governance hash
Baseline framework definitions	Two baseline SHA-256 values
Population judgment functions	SPEC v3 and CODE DIFF
R-B configuration and parsing modules	PREFLIGHT, four module hash rows
Peer-statistics source	Same hash across arms
SQL source data bracket	Four matching PRE/POST checksums
Decision rows and classification outputs	Matching hashes within each R path
Fixture results	Matching hashes and 14/14 counts
R-A portfolio counts	Matching hash
R-B kappa-grid counts	Matching hash
P1 success criteria	Explicitly unchanged in v3
The one identified output divergence remains R-B portfolio accounting.
Sources: SPEC ADDENDUM v3, “What changes in v3,” “Exactness argument,” and “Equivalence proof”; PREFLIGHT C24V3; RUN LOG, 11:19:23 and 11:51:36 entries; ARM MANIFESTS; COORDINATOR NOTE.
7. Claim → evidence map
Claim	Evidence location and row
The SQL collapse removes the Open-only envelope	SPEC, “Exact change being tested,” X_SEP and X_FULL entries
Full source contains 14,635,395 rows	C24V3_RESULTS.md, “SQL query counts,” total row
Separated extract contains 245,193 rows	C24V3_RESULTS.md, “Extracts,” B row
Full extract matches SQL total	C24V3_RESULTS.md, “Extracts,” COLLAPSED row, compared with “SQL query counts,” total
All four R runs complete with exit 0	C24V3_RESULTS.md, “R runs,” rows B/RA, B/RB, COLLAPSED/RA, COLLAPSED/RB
Both COLLAPSED runs remain within the memory guard	COLLAPSED RUN EXIT FILES, RA and RB rows; RUN LOG, 11:19:23 and 12:10:29
Every fixture passes	C24V3_RESULTS.md, “R runs,” all four fixtures_pass and fixtures_n entries
Classification files remain identical across arms	C24V3_RESULTS.md, “7 key outputs,” RA_classifications.csv and RB_classifications.csv rows
Exactly six of seven required files match	C24V3_RESULTS.md, “7 key outputs,” seven COLLAPSED_eq_B entries
R-B portfolio counts differ	C24V3_RESULTS.md, “7 key outputs,” RB_portfolio_counts.csv row
The differing value is n_out_of_set	COLLAPSED RB_portfolio_counts.csv, single data row; COORDINATOR NOTE, differing-field statement
The excluded-count delta equals the non-Open population	C24V3_RESULTS.md, total, status=Open, and decision-count rows; independently recomputed subtraction
Source checksums did not change	C24V3_RESULTS.md, CHECKSUM PRE/POST rows for four tables; EVIDENCE SHA256, CK_PRE.tsv and CK_POST.tsv
Chunked reading passed preliminary equivalence tests	EQUIVALENCE TESTS, T1 seven file rows and T2 paired whole/chunked rows
v3 preserved the original judgment functions	CODE DIFF, R-A production diff and R-B production diff; SPEC ADDENDUM v3, change 1
The resumed runner reused the declared R setup, according to coordinator	COORDINATOR NOTE, interruption/resumption entry; RUN LOG, 11:51:36 resume row
P1 condition 3 is not satisfied	SPEC, “Operational benefit predicate P1,” condition 3; C24V3_RESULTS.md, “Predicate conditions,” third row
The overall recorded P1 result is NOT MET	C24V3_RESULTS.md, mechanical predicate result, supported by the seven-output comparison
Builder concluding assessment: The supplied evidence demonstrates that the COLLAPSED arm successfully processes the full extract and preserves the recorded final classification outputs across both independent R paths. It also demonstrates a specific, reproducible difference in the R-B excluded-population count. That difference causes frozen P1 condition 3 to remain unsatisfied. The evidence does not justify changing the predicate, disregarding the differing file, or treating a narrower notion of decision-set equivalence as full seven-output equivalence.
This report makes no terminal adjudication decision.
END C24 BUILDER REPORT
