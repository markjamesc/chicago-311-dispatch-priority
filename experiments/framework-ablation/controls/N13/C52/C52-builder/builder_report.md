1. Role attestation and ablation ID
Role: Builder — ChatGPT
Ablation ID: C52
Candidate: Addendum 02, #52 — Concurrent raw-side Source Gate queries
Batch: N13, batch 4
Constitution: Version 1.0
Target: Stage 4 Source Gate scheduling
Evidence basis: Frozen C52 packet, including SPEC, CONSTITUTION, PREFLIGHT, RUN LOG, C52_RESULTS.md, C52_arms.csv, raw per-arm records, ARM MANIFESTS, and SEED DIFFS.
I attest that this is an independent Builder first-pass assessment. I have not consulted the Validator's findings or any Adjudicator decision.
The assessment independently recomputes mechanical facts from the supplied evidence, distinguishes computed values from reported values, and evaluates the frozen P1 predicate without issuing a terminal adjudication state.
The test compares serial execution of the read-only extract and gate chains against concurrent execution on the frozen Chicago 311 snapshot.

2. Conceptual diff: what the ablation removes, and the exact seeded code changes
2.1 Control being relaxed
The baseline Source Gate process executes in this order:
Serial baseline
E1 → E2 → G


The candidate permits two independent chains to overlap:
Concurrent candidate
           ┌── E1 → E2 ──┐
START ─────┤             ├── COMPLETE
           └── G ────────┘


The candidate removes the scheduling dependency requiring G to begin only after E1 and E2 finish.
It does not remove the Source Gate, any of its 17 checks, or the checksum bracket.
The distinction is important: the candidate removes an execution-order constraint, not a validation requirement.
2.2 Exact seeded changes
The SEED DIFFS section supplies the complete contents of six new runner-side files. They are read-only derivatives or control files rather than in-place modifications to the frozen SQL.
Seeded file	Exact implementation change
E1.sql	Converts frozen Envelope A's table-producing operation into a read-only SELECT streamed to E1.tsv.
E2.sql	Replaces Envelope B's staging-table sequence with one CTE statement containing stage and ranked, streamed to E2.tsv.
G.sql	Converts each frozen Source Gate INSERT INTO src_gate_results ... SELECT ... into its underlying SELECT, preserving the 17 checks and their order.
CK.sql	Executes CHECKSUM TABLE over the four specified tables.
ARMS.tsv	Defines SER_1, PAR_1, SER_2, and PAR_2, including execution modes.
SQLCONC	Identifies the C52 serial-versus-concurrent SQL control for runner v4.
E1: Envelope A
The seeded SQL retains the frozen time setting:
SET @T_freeze =
    CAST('2026-09-12 23:59:59' AS DATETIME);


Its query selects the raw request columns and mechanically derived fields, including type_key, created_ts, mod_ts, closed_ts, t_freeze, mechanical_envelope, and snapshot_id.
Its concluding selection is:
FROM raw_311_requests r
WHERE r.STATUS = 'Open'
ORDER BY r.SR_NUMBER;


It does not create or modify src_open_candidates.
E2: Envelope B
The new statement uses:
WITH stage AS (
    ...
), ranked AS (
    ...
)
SELECT ...
FROM ranked
GROUP BY type_key
ORDER BY type_key;


The seeded transformation preserves the specified peer-population filters: completed requests, exclusion of duplicates and legacy records, valid creation and closure timestamps, nonnegative elapsed cycles, the frozen 365-day lookback, and a nonnull type_key.
The ranking calculation retains:
ROW_NUMBER() OVER (
    PARTITION BY type_key
    ORDER BY cycle_h ASC
) AS rn


and the nearest-rank percentile expressions:
CEILING(peer_n * 0.50)
CEILING(peer_n * 0.75)


The packet reports that this SELECT-only form replaces the frozen staging tables. The original SQL text is not reproduced in full for an independent line-by-line equivalence check.
G: Source Gate
All 17 check rows remain, in order:
A, B, C_missing, C_extra, D, E, F, G_null_profile, G_closed_info, H, I_present, I_null_key, I_p75, J, K_open, K_freeze, L.
The seeded G reads raw_311_requests and the existing frozen extract tables.
This differs materially from a production run in which newly written extract tables are subsequently inspected. Concurrent E1/E2 outputs are written to TSV files, not to the tables read by G.
CK: checksum bracket
CHECKSUM TABLE
    chicago311.raw_311_requests,
    chicago311.src_open_candidates,
    chicago311.src_peer_stats,
    chicago311.src_extract_lineage;


The bracket is executed before and after each arm.
Execution arrangement
Each chain uses MySQL CLI options:
--login-path=chicago311 -N -B --raw


E1 and E2 execute consecutively within the extract chain. In serial arms, G begins afterward. In parallel arms, both chains are launched concurrently.
Changed-file scope: Six new seeded files. The runner and evaluator are separately frozen and hash-verified, but their source changes are not presented as C52-specific conceptual diffs.
Evidence: SEED DIFFS, E1.sql, E2.sql, G.sql, CK.sql, ARMS.tsv, and SQLCONC; SPEC, “Exact change being tested.” C52_1_BUILDER_ChatGPT.txt


3. Hard mechanical facts table
Notation: R = independently recomputed from supplied numerical or textual evidence; Q = quoted from the packet. A reported checksum or SHA-256 value is Q; equality among supplied values can be R.
3.1 Per-arm execution results
Arm	Mode	Wall (s), Q	E chain (s), Q	G chain (s), Q	Exits, Q	Error bytes, Q
SER_1	Serial	3,677.3	666.9	3,010.4	0/0/0	0
PAR_1	Parallel	3,246.8	1,107.7	3,246.7	0/0/0	0
SER_2	Serial	3,137.4	504.2	2,633.2	0/0/0	0
PAR_2	Parallel	2,911.8	902.7	2,911.8	0/0/0	0
Serial duration reconciliation:
- SER_1: 666.9 + 3,010.4 = 3,677.3 seconds (R).
- SER_2: 504.2 + 2,633.2 = 3,137.4 seconds (R).
In both parallel arms, the G chain is longer than E, so G determines the concurrent completion duration, subject to timing precision. PAR_1's independently reported chain duration differs from the total by 0.1 second.
There are four arms, comprising two serial and two parallel observations (R).
All 12 E1/E2/G exit entries are zero (R). Across those four arms, the supplied aggregate error-byte count is zero (R). The individual E1, E2, G, and checksum .err entries in ARM MANIFESTS also have zero-byte sizes.
3.2 Recomputed timing results
Mechanical quantity	Independently recomputed
Median serial duration	3,407.35 s
Median parallel duration	3,079.30 s
Parallel/serial ratio	0.903723
Median time reduction	328.05 s
Percentage reduction	9.6277%
Maximum permitted parallel median (80% of serial)	2,725.88 s
Parallel median above required maximum	353.42 s
Parallel median above permitted maximum, percentage	12.9654%
SER_1 minus PAR_1	430.5 s
SER_2 minus PAR_2	225.6 s
Paired reduction, first pair	11.7070%
Paired reduction, second pair	7.1907%
The reported rounded medians of 3,407.4 and 3,079.3 seconds and ratio of 0.904 agree with the independent calculations. 


The separate chain medians are:
Chain	Serial median	Parallel median
E	585.55 s (R)	1,005.20 s (R)
G	2,821.80 s (R)	3,079.25 s (R)
Both individual chains exhibit larger observed durations under the concurrent scheduling mode, even though total elapsed time is lower. This is a descriptive observation; resource contention is a plausible explanation, not an established cause. 


3.3 Source Gate row identities
Quantity	Per arm	Four-arm total	Verification
Gate rows	17 Q	68 R	17 × 4
PASS	15 Q	60 R	15 × 4
FAIL	0 Q	0 R	0 × 4
INFO	2 Q	8 R	2 × 4
Count identity	15 + 0 + 2 = 17 R	60 + 0 + 8 = 68 R	Exact
The 17 rows were also independently counted from the raw PAR_1/G.tsv representation, and the raw G row text agrees among all four arms. 

 


Important individual gate values include:
Gate row	Quoted evidence	Recomputed identity
A_open_count_match	245,193 / 245,193	Difference = 0
B_distinct_sr_equals_rows	245,193 / 245,193	Difference = 0
C_id_missing_in_extract	0	No missing IDs reported
C_id_extra_in_extract	0	No extra IDs reported
D_field_mismatch_critical	0	Critical-field mismatch count = 0
H_sr_checksum_match	4,226,609,361 / 4,226,609,361	Difference = 0
I_peer_stats_present	104 / 104	Difference = 0
I_peer_no_null_type_key	0	No null/blank key failures reported
I_peer_p75_nonneg_when_n	0	No qualifying percentile violations reported
J_no_judged_columns	0	No prohibited judged columns reported
K_lineage_open_matches_raw	245,193 / 245,193	Difference = 0
K_lineage_t_freeze	2026-09-12 23:59:59	Matches frozen T_freeze
The raw distribution INFO row reports:
Status	Count, Q
Canceled	212,654
Closed	1
Completed	14,177,547
Open	245,193
Total	14,635,395 (R)
The total is the arithmetic sum of the four reported status counts, not an independently executed database count. 


3.4 Cross-arm hash equality
All four ARM MANIFESTS supply identical complete SHA-256 values for each of the following outputs:
Artifact	SHA-256, Q	Bytes, Q	Equality, R
E1.tsv	65bf0d9ae5bff494faa00094799f969c8fedaa85328b67775103723c694b4de6	118,671,465	Four of four equal
E2.tsv	95dc8cab2e82009fde69327f1af8921bb039b1ccedeee4668e8873d646342a06	16,184	Four of four equal
G.tsv	ec26cd171c4617eb86d0145cd564662577db37e683c1608009083c2f011807f1	1,556	Four of four equal
CK_PRE.tsv, CK_POST.tsv	13b7f2d53daaaf27de17173bc1dee24314f8717902fa29b55d8a3d8171602ee7	162	Eight of eight equal
These checks compare the quoted full hashes, not independently recomputed hashes from the underlying bulky output bytes. Each artifact class has one unique reported digest and one reported size across all four arms. 


3.5 Checksum bracket
The checksum tables report these four values in every arm, before and after execution:
Table	Reported checksum
raw_311_requests	727,006,061
src_open_candidates	1,392,669,554
src_peer_stats	791,123,155
src_extract_lineage	2,028,659,591
Recomputed comparisons:
- Four tables × two bracket positions × four arms = 32 table-checksum entries.
- All four pre/post pairs match within every arm.
- All eight complete checksum strings agree across arms.
Thus, no checksum change is reported. 


3.6 Frozen-file and manifest integrity facts
The PREFLIGHT contains 17 frozen-file OK entries and eight runner-seed OK entries, with overall preflight PASS.
The arm manifests contain 84 entries: six inputs and 15 outputs per arm. These counts were independently enumerated from the supplied manifest. 


Key frozen identifiers, quoted:
- Constitution: e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9
- C52 specification: 961faf00c0cd426e4105bf1be2fcaa820c40983241bac7d4d3d88c443b9f7e74
- Baseline measurement framework: 70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c
- Baseline validation framework: 24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e
Reported evidence wrapper hashes:
- C52_ARM_MANIFESTS.txt: 279c8d7d3c260452d8cb6c97aaabe37da224d3171aebdbac083b49388546effe
- C52_arms.csv: af5a3ed71f4a7121549c62e12c4f490414bc462a63e435e3f0e21bd664cfb72e
- C52_RESULTS.md: bde134f2d83b7da3aea1f60f8f608f834346eee41946099966c7609e74924bdf
The reported hashes cannot be independently regenerated from the packet's hash listings alone.
Nonapplicable requested identity classes: No n_inner, n_agree, n_disagree, portfolio count transitions, portfolio deltas, or classification D-sets are defined for C52. Their values are not zero; they are not applicable to this scheduling ablation.

4. P1 assessment against the frozen predicate
P1 requires all four specified conditions to hold.
Frozen P1 condition	Independent assessment	Evidence
1. All chain exits zero and all error files empty	MET	Exit records, error manifests
2. G has 17 rows, 15 PASS / 0 FAIL / 2 INFO; byte-identical across arms	MET	G.tsv records, manifests
3. E1 and E2 byte-identical across arms	MET	Full SHA-256 equalities
4. Median parallel duration ≤ 80% of median serial duration	NOT MET	Independently recomputed medians
Timing comparison
Serial median
3,407.35 s



Parallel median
3,079.30 s



Required parallel maximum
2,725.88 s



Relative elapsed durations, with the serial median normalized to 100%.
The mechanical inequality is:
\[
3079.30 \leq 0.80(3407.35)
\]

which reduces to:
\[
3079.30 \leq 2725.88
\]

This inequality is false.
Concurrent execution achieved a median reduction of 328.05 seconds, approximately 9.63%, rather than the required 20%.
P1 is not satisfied. This is an assessment of the frozen operational predicate, not a terminal adjudication state.
The result is consistent with the evaluator's reported P1 NOT MET. C52_1_BUILDER_ChatGPT.txt


5. Fixture and reconciliation implications
5.1 Mandatory fixtures
The SPEC explicitly states that the SQL Source Gate has no fixture harness and therefore no mandatory fixture applies to C52.
Accordingly:
- No C52 behavioral fixture executions are reported.
- No fixture IDs or fixture pass counts should be invented.
- The frozen R-A/R-B fixtures are part of the unchanged pack, not newly executed by this control.
The absence of a mandatory C52 fixture is disclosed before execution. It is not evidence that an independent behavioral fixture suite passed.
5.2 Reconciliation established by the test
The supplied evidence establishes these comparisons:
Reconciliation surface	Finding
E1 output among all arms	Same reported SHA-256
E2 output among all arms	Same reported SHA-256
G output among all arms	Same reported SHA-256 and raw row text
Gate row counts	Exact 17 = 15 + 0 + 2
Open raw/extract counts	245,193 = 245,193
Missing and extra IDs	Both zero
Critical field mismatch count	Zero
Peer type-key count	104 = 104
Checksum before/after each arm	Identical
Frozen peer stats comparison	Reported TRUE
Frozen open-candidates comparison	Reported FALSE
The strongest supported claim is cross-arm identity of the three reported SQL output artifacts under the tested execution arrangement.
It is not equivalence of the complete production extract/write/gate workflow.
5.3 Differences against the frozen CSVs
The evaluator reports, after removing headers and normalizing lines:
- E1 versus src_open_candidates.csv: FALSE.
- E2 versus src_peer_stats.csv: TRUE.
The specification classified this comparison as informational because the export methods differ.
The E1 disagreement should therefore remain recorded rather than silently treated as equality. The packet does not isolate whether its cause is formatting, field serialization, or substantive data differences.
This does not overturn the established E1 equality across the four C52 arms, which is a different comparison.
5.4 Frozen-log comparison
The informational gate-versus-frozen-log table reports in_frozen_log = FALSE for every one of the 17 checks.
This means the evaluator's textual matching procedure did not find the complete check rows in the named frozen log. It does not by itself establish that a check's result differed.
The frozen aggregate gate reference is 15 PASS / 0 FAIL / 2 INFO, while direct per-check log equivalence is not independently demonstrated by that comparison.
5.5 Known OF-1
The predeclared finding concerning three one-hour R-A/R-B elapsed-time discrepancies is unchanged.
C52 executes no R classification code and does not modify the frozen R artifacts. The OF-1 discrepancies cannot be attributed to this scheduling test from the supplied evidence.

6. Semantic/regression risks and unchanged surfaces
6.1 Unchanged surfaces
The C52 evidence supports preservation, within the test's declared scope, of:
- All 17 Source Gate checks and their order.
- The frozen source and extract tables.
- The frozen source CSVs and SQL references verified at preflight.
- The baseline framework and constitution versions.
- The Stage-3 freeze settings, including the September 12, 2026 timestamp.
- The frozen R-A/R-B code and recorded outputs.
- The existing Source Gate result categories.
- The four-table checksum bracket.
C52 does not introduce a new analytical metric, classification rule, eligibility definition, action label, or statistical estimator.
However, hash preservation of frozen R artifacts is not a substitute for re-executing their tests.
6.2 Production scheduling equivalence
The most important semantic limitation is that G examines the existing frozen extract tables, while E1/E2 recompute extraction results as SELECT outputs.
The test establishes that G can run concurrently with those read-only queries without changing the observed outputs on the static snapshot.
It does not demonstrate that a production Source Gate can safely validate newly generated extract tables before the corresponding write operations have completed.
Consequently, the result should not be generalized to live writes, table replacement, incremental refreshes, or independently changing upstream sources.
6.3 Snapshot consistency
Matching pre/post table checksums provides useful evidence against persistent table changes during the test.
However, checksum brackets alone do not prove that every query observed the same transactional snapshot at every instant. They also cannot exclude transient changes that were reversed or undetected checksum collisions.
The candidate's concurrency safety is therefore supported only within the declared static-snapshot conditions.
6.4 Performance limitations
There are only two serial and two parallel timed arms.
The observed parallel speedup is consistent across the paired observations, but modest. Both concurrently executed chains took longer individually than their serial counterparts.
Possible explanations include CPU contention, storage contention, memory pressure, or changing workload conditions. The supplied measurements do not identify the cause.
The frozen timing requirement already determines whether the reported performance is sufficient. No post-execution relaxation of that threshold is justified.
6.5 Evidence-packaging interruption
A material provenance qualification is explicitly disclosed.
The batch runner encountered an access-denied error while writing a C51 evidence manifest, after the evaluator had completed. The overall runner therefore never logged DONE.
The coordinator subsequently assembled the C52 arm-manifest and evidence-hash files on October 9, 2026, using the runner's method.
The packet identifies C52_RESULTS.md and C52_arms.csv as unmodified evaluator outputs from October 3, 2026.
This supports distinguishing two events:
1. The C52 arm execution and evaluator calculations completed, according to the run records.
2. The overall batch's original automated evidence-packaging process did not complete normally.
The post-execution manifest reconstruction is documented and should remain disclosed. The original runtime completion of every upstream output is supported by the supplied logs and manifests, but those raw files are not independently available here for full rehashing.
6.6 Scope of semantic assurance
The candidate has three separately relevant observations:
- Cross-arm output consistency: supported by matching reported hashes and gate rows.
- Production workflow equivalence: not established by this SELECT-only experiment.
- Predeclared operational benefit: not achieved under the measured median-duration threshold.
These distinctions prevent interpreting output equality as comprehensive semantic or operational equivalence.

7. Claim → evidence map
Claim	Evidence section	Specific row or artifact
C52 tests concurrent Source Gate scheduling	SPEC, “Control under test” and “Exact change being tested”	E1, E2, G, CK definitions
No gate item is intentionally removed	SPEC and SEED DIFFS	G.sql 17 SELECT statements
Four interleaved arms are defined	SPEC “Arms”; SEED DIFFS	ARMS.tsv: SER_1, PAR_1, SER_2, PAR_2
Inputs were frozen at preflight	PREFLIGHT	17 frozen OK rows, eight seed OK rows, preflight PASS
All chain executions reported zero exits	RUN LOG; raw per-arm records	SER_1, PAR_1, SER_2, PAR_2 E/G exit records; E1/E2 timing exits
All specified error outputs were empty	RAW PER-ARM FILES; ARM MANIFESTS	Per-arm E1.err, E2.err, G.err, CK_PRE.err, CK_POST.err
Gate category identity holds	Raw G.tsv records	All 17 named rows; 15 PASS, two INFO
Critical raw-field reconciliation had zero mismatches	Raw G.tsv	D_field_mismatch_critical
Raw and extracted open counts matched	Raw G.tsv	A_open_count_match, 245193/245193
Missing and extra request IDs were zero	Raw G.tsv	C_id_missing_in_extract, C_id_extra_in_extract
Peer type-key count matched	Raw G.tsv	I_peer_stats_present, 104/104
E1 is identical among arms by reported digest	ARM MANIFESTS	Four E1.tsv rows
E2 is identical among arms by reported digest	ARM MANIFESTS	Four E2.tsv rows
G is identical among arms	ARM MANIFESTS; raw G records	Four G.tsv rows and full G text
Checksum bracket remained equal	RUN LOG; RAW PER-ARM FILES	CK_PRE.tsv, CK_POST.tsv for all four arms
Serial median is 3,407.35 seconds	C52_arms.csv	SER_1 3677.3 and SER_2 3137.4
Parallel median is 3,079.30 seconds	C52_arms.csv	PAR_1 3246.8 and PAR_2 2911.8
Parallel/serial ratio is approximately 0.903723	C52_arms.csv; independent arithmetic	Four wall_s values
The 80% performance criterion is not satisfied	SPEC P1.4; independent arithmetic	Required ≤2725.88 s; observed 3079.30 s
E1 did not match the frozen CSV by the evaluator's informational comparison	C52_RESULTS.md, extract-output INFO	E1 comparison FALSE
E2 matched the frozen CSV by that comparison	C52_RESULTS.md, extract-output INFO	E2 comparison TRUE
Individual gate-to-frozen-log textual matches were not found	C52_RESULTS.md, frozen-log INFO	All 17 in_frozen_log entries FALSE
No mandatory fixture applies	SPEC, “Regression / HALT rules”	Fixture-harness declaration
OF-1 is pre-existing and not exercised by C52	Coordinator Note N1; SPEC	Three one-hour R-A/R-B discrepancies
Runner evidence packaging was interrupted	C52_RESULTS.md evidence note	C51 manifest access-denied event
C52 manifest reconstruction was disclosed	C52_RESULTS.md evidence note; C52_EVIDENCE.sha256	October 9 reconstruction and three wrapper hashes
Frozen analytical outputs remained under preflight hashes	PREFLIGHT; FROZEN REFERENCE HASHES	R-A/R-B classification, fixture, portfolio, and kappa output rows
Builder assessment: The supplied evidence is mechanically consistent with successful read-only concurrent execution, unchanged reported E1/E2/G outputs across arms, and preservation of the specified checksum and gate results. The independently recomputed median performance ratio is approximately 0.903723, exceeding the frozen maximum of 0.80. Accordingly, the predeclared P1 operational benefit is not demonstrated. The SELECT-only production-equivalence limitation and the disclosed evidence-packaging interruption remain relevant qualifications; neither changes the timing calculation.
END C52 BUILDER REPORT
