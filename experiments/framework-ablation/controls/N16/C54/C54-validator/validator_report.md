1. Role attestation and ablation ID
Role: Validator only (DeepSeek, DeepThink on, Search off). I am blind to the Builder; I have not seen and must not ask for its output.
Ablation ID: C54. Batch: N16.
I do not return KEEP, REVERT or HALT. No terminal state is issued here.

2. Independent test plan: what I checked, and how
I checked the frozen packet as follows:

Counted every row in C54_captures.csv and grouped by log, control, file, site, md_bytes, and incident text.

Recomputed the number of log entries, incident entries, incidents still present in the final entry for the same capture path, download-capable captures, and avoidable incidents.

Inspected scorers/score_c54.py to see the declared incident rule and the exact mechanical form of P1 conditions 1–3.

Compared the scorer’s counts and condition table against the raw C54_captures.csv table.

Checked each incident against the quoted coordinator notes: C43_NOTES.md, C49_NOTES.md, and the C48 disclosure in the SPEC.

Checked site classification: ChatGPT, Grok, or DeepSeek.

Checked the frozen dependency C43_TERMINAL_STATE.txt.

Compared the listed SHA-256 values across the SPEC, preflight, and evidence list for all files cited in this packet.

Checked for duplicate capture paths and how the scorer handles them.

Fixture and reconciliation items: not applicable to N16. Reason: no R run, no fixture, no MySQL, no fresh pull. Text-level equivalent: all mechanical numbers in this packet were produced from frozen text inputs by the quoted scorer, with no PC execution.

3. Independently recomputed hard facts
3.1 Counts from C54_captures.csv
Fact	Recomputed value	Basis
Total log entries	41	Row count of C54_captures.csv
ChatGPT captures	14	Rows with site chatgpt
Grok captures	11	Rows with site grok
DeepSeek captures	16	Rows with site deepseek
Download-capable captures (ChatGPT + Grok)	25	14 + 11
Incident entries	3	Rows with non-empty incident field
Incidents still in final entry for that capture	3	No incident row is superseded by a later non-incident row for the same (control, file) path
Avoidable incidents	0	No incident has both an established page-capture cause and a download-capable site
3.2 Incident classification
Log	Control	File	Site	Incident	Cause established?	Download-capable?	Avoidable?
CAPTURE_C49BV	C49	validator_deepseek.html	deepseek	reply did not end at END line	Yes, per C49_NOTES.md	No	No
CAPTURE_b5	C48	ai2_grok.html	grok	reply did not end at END line	No, per SPEC disclosure	Yes	No
CAPTURE_b6	C43	validator_deepseek.html	deepseek	no extraction result	Yes, per C43_NOTES.md	No	No
Avoidable incident count is therefore 0.

3.3 P1 condition recomputation
P1 condition	Scorer result	My recomputation	Basis
1. At least one reply-capture failure, established page-capture cause, download-capable site, avoidable by download	NOT MET	NOT MET	0 avoidable incidents
2. At least 30 logged captures	MET	MET	41 log entries ≥ 30
3. Dependency #43 terminal-state value is the required one	MET	MET	C43_TERMINAL_STATE.txt content matches the required value
Overall mechanical P1	NOT MET	NOT MET	Condition 1 not met
3.4 Hash and identity checks
I compared the hashes available in this packet:

C54_RESULTS.md: SPEC value d7dcea67… matches the evidence-list value d7dcea67….

C54_captures.csv: SPEC value e1c52c50… matches the evidence-list value e1c52c50….

scorers/score_c54.py: SPEC value 59ce70c1… matches the evidence-list value 59ce70c1….

scorers/n16lib.py: listed in the SPEC as 4a6675fa…; no source content is included in this packet.

All 14 extraction-log hashes listed in C54_EVIDENCE.sha256 match the corresponding preflight hashes.

C43_TERMINAL_STATE.txt: preflight hash 0bce0104… matches the evidence-list hash 0bce0104….

C43_NOTES.md: preflight hash cc63489f… matches the evidence-list hash cc63489f….

C49_NOTES.md: preflight hash 53acc338… matches the evidence-list hash 53acc338….

C40_DEVIATION_NOTES_post_2.md: preflight hash 8bea7195… matches the evidence-list hash 8bea7195….

No hash mismatch was found among the values that appear in more than one place in this packet.

3.5 Internal consistency of runner output
No contradiction was found between C54_RESULTS.md, C54_captures.csv, and the scorer source.

One definitional note: C54_captures.csv has 41 log entries, but two (control, file) paths appear more than once:

C49 reply_deepseek.html under CAPTURE_b6 appears twice.

C40 inc_r2_chatgpt.html appears under CAPTURE_b6b and CAPTURE_b6b_fix.

The number of distinct (control, file) pairs is therefore 39. The scorer labels the count as “41 log entries,” not “41 distinct captures.” Even using the deduplicated count, condition 2 would still be MET because 39 ≥ 30. No incident is affected by the duplicate paths. This is a non-blocking definitional note, not an internal contradiction.

3.6 Portfolio deltas, D-sets, cross-arm equalities
No portfolio deltas or D-sets are present in this C54 packet. The only dependency-set item used by P1 is dependency #43, and its frozen terminal-state file is present and matches the required value. Cross-arm hash equalities available in the packet were checked as above; all matched.

4. Facts that cannot be recomputed from this packet
The exact raw JSONL contents of the 14 extraction logs.

The source content of scorers/n16lib.py.

The omitted origin-hash lines from preflight.

SPEC_FREEZE_N16.sha256 itself.

Byte-identity of a downloaded reply versus the saved page capture.

Intake minutes for any capture.

Whether the ChatGPT and Grok UIs actually offer a file download of a reply; this is a declared premise.

Whether a UI file download would in fact have avoided the C48 Grok incident.

The exact cause of the C48 Grok ends_ok=false entry.

Whether any entry other than the three listed would count as an incident under a different cause interpretation.

Actual SHA-256 values for files not listed in the packet.

5. P1 assessment against the frozen predicate in the SPEC
Facts only:

Condition 1: NOT MET. No incident has both an established page-capture cause and a download-capable site. The C49 and C43 incidents are on DeepSeek; the C48 incident is on Grok but its cause is not established.

Condition 2: MET. There are 41 log entries, which is ≥ 30.

Condition 3: MET. The frozen dependency #43 terminal-state file contains the required value.

Mechanical P1 result in C54_RESULTS.md: NOT MET.

I issue no terminal state.

6. Blocking objections
None.

Non-blocking observations:

The text-only capture mode and absence of a live 54-A download test are declared in the SPEC. They limit what can be measured but do not invalidate the replay conditions as written.

The duplicate (control, file) paths in C54_captures.csv do not change any condition because the deduplicated count is still ≥ 30 and no duplicate path is an incident.

The scratch-run adjustment declared in the SPEC is disclosed; it does not create a hidden predicate change in the reporting run.

7. Claim → evidence map
Claim	Evidence
Total log entries = 41	C54_captures.csv row count
Incident entries = 3	C54_captures.csv non-empty incident rows
Incidents still in final entry for that capture = 3	No incident row is superseded by a later non-incident row for the same (control, file) path
Download-capable captures = 25	14 ChatGPT rows + 11 Grok rows in C54_captures.csv
Avoidable incidents = 0	Incident table; C49/C43 are DeepSeek; C48 cause not established
Condition 1 NOT MET	0 avoidable incidents
Condition 2 MET	41 ≥ 30
Condition 3 MET	C43_TERMINAL_STATE.txt content matches the required value
Mechanical P1 NOT MET	C54_RESULTS.md; independently recomputed condition table
C43 dependency state present	C43_TERMINAL_STATE.txt, preflight hash 0bce0104…, evidence hash 0bce0104…
C49 cause established	C49_NOTES.md; preflight hash 53acc338…; evidence hash 53acc338…
C43 cause established	C43_NOTES.md; preflight hash cc63489f…; evidence hash cc63489f…
C48 cause not established	SPEC disclosure; C54_RESULTS.md incident explanation
Hash consistency	SPEC, preflight, and C54_EVIDENCE.sha256 values compared; no mismatch found
Fixture/reconciliation not applicable	N16 text-only, no R run, no fixture, no MySQL, no fresh pull
END C54 VALIDATOR REPORT
