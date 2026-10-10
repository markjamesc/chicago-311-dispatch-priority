Role attestation and ablation ID.
Role: Validator only (DeepSeek, DeepThink on, Search off). I am blind to the Builder and have not seen its output. Ablation ID: C50, batch N16. Capture mode: text-only; no PC run, no MySQL, no R. I do not return a terminal state.

Independent test plan: what you checked, and how.
I checked only the frozen text in this packet. I re-parsed the C48 and C50 evidence tables, the two frozen second-audit replies, AUDIT_FREEZE.json, REVISIONS.json, rev_check.R, and the hash references in the SPEC, preflight, EVIDENCE list, and input headers. I recomputed the P1 conditions from raw evidence rather than from the C50 scorer output. I recomputed the WCA2 share arithmetic and checked the cross-arm and cross-file hash equalities.
Fixture and reconciliation items: not applicable to N16. Reason: text-only capture, no PC run, no MySQL/R/fixture execution. Text-level equivalent: hash equality checks and table-level recomputation from frozen text.

Independently recomputed hard facts. Recompute every number you can from the evidence tables: identities, portfolio deltas, D-sets, and cross-arm hash equalities. Flag any internal inconsistency in the runner output.

3.1 Hash and byte identities

item	stated SHA-256	bytes	cross-check
CONSTITUTION_v1.md	e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9	—	matches SPEC and preflight
owner sheet	1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417	—	matches SPEC and preflight
owner answer	3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b	—	matches SPEC and preflight
scorers/score_c50.py	0c26a39c70041f283ca3fc5336404b8e9b36d69f6f10a0b520b4a8fe62faa622	5128	matches SPEC and C50_EVIDENCE
scorers/n16lib.py	4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47	1723	SPEC only; content not provided
C50/evidence/C50_RESULTS.md	fb85b8abb71294f0f529eea864ee4ca721ed917573d2c50f3224f02473c085b7	2419	matches SPEC and C50_EVIDENCE
frozen/c48/C48_RESULTS.md	5df149f9f300620ebab767f7af17a98d078f92e85b7604cce1f5f82480b59c92	2260	matches preflight, C50_EVIDENCE, input
frozen/c48/TERMINAL_STATE.txt	c7cde8022846cd6aff9b189e32dc3aa4f3eea733835d469093054391490627b2	5	matches preflight and C50_EVIDENCE
frozen/c48/AUDIT_FREEZE.json	c70917e4a21e085922e4f2585ed9ae92d7cb2992b27122aedc300409db293878	874	matches preflight and C50_EVIDENCE
frozen/c48/ai2_second_audit.md	06b3e1f75be60142b054ac034cdb78579b9812efb87a1e535d5d0a0530b22e27	4078	matches AUDIT_FREEZE and input
frozen/c48/ai3_second_audit.md	8b473adf6fd7cfe4ba6b363fcb52f009561b26f4ca44d6295126ad9a96c2aed2	3053	matches AUDIT_FREEZE and input
frozen/c48/REVISIONS.json	970bac860ea65fcf4658cbb932d11e666f2609de4a8708161ac0b7df824ce0b4	2651	matches preflight and C50_EVIDENCE
frozen/c48/rev_check.R	6cc4ea649d67c1d22a90bfcbcbf3756a69837d900f26943940f0b6bb57297156	2824	matches preflight and C50_EVIDENCE
frozen/c48/AI1_ORIGINAL.md	73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932	7929	matches preflight, C50_EVIDENCE, and frozen/stage5/AI1_INTERPRETATION_BUILDER.md
frozen/c48/REVISED_SEED.md	c1ac310a7c77ab4228ac14ebb6c56e58b408e4e64cdf74fae8f1f68b9a720b63	8215	matches preflight and C50_EVIDENCE
frozen/c48/REVISED_CLEAN.md	d92e480b9531d5018ca02e6dbd116dbaaa3a2df53981e690e48eff13eb00278c	8215	matches preflight and C50_EVIDENCE
Cross-arm hash equality: REVISED_SEED.md and REVISED_CLEAN.md have the same byte count, 8215, but different SHA-256 values. AI1_ORIGINAL.md and stage5/AI1_INTERPRETATION_BUILDER.md have the same SHA-256 73f448....

3.2 C48 checklist and number diff

CLEAN arm:

exit 0, status PASS, flagged_revisions empty, unexplained_numbers none.

CHECK.csv: V-1 through V-6 all flag = FALSE.

NUMDIFF.csv: no rows.

SEED arm:

exit 0, status FLAG, flagged_revisions = V-3.

unexplained_numbers: 42.9(expected 0, found 1)/49.2(expected 1, found 0).

CHECK.csv: V-3 has target_in_original=1, replacement_found=0, target_left=1, a_replacement_verbatim=FALSE, b_target_gone=TRUE, flag=TRUE; V-1, V-2, V-4, V-5, V-6 are FALSE.

V-6 in both CLEAN and SEED: target_in_original=1, replacement_found=0, target_left=0, a_replacement_verbatim=TRUE, b_target_gone=TRUE, flag=FALSE.

3.3 Frozen second-audit per-revision verdicts and findings

Per-revision verdicts:

revision	AI2	AI3	SEED checklist flag
V-1	YES	YES	FALSE
V-2	YES	YES	FALSE
V-3	PARTIAL	PARTIAL	TRUE
V-4	YES	YES	FALSE
V-5	YES	YES	FALSE
V-6	YES	YES	FALSE
BLOCKING / MATERIAL findings recomputed manually from the raw replies:

AI2: F-1 | MATERIAL | V-3.

AI3: F-1 | BLOCKING | V-3.

No other BLOCKING or MATERIAL findings.

No finding relates to NEW or to another revision.

AI2 overall verdict: PASS WITH REQUIRED REVISIONS.

AI3 overall verdict: FAIL.

Internal inconsistency in runner output: C50_RESULTS.md lists only AI3 | F-1 | BLOCKING | V-3 in its BLOCKING/MATERIAL findings table. It omits the AI2 MATERIAL finding because the scorer’s finding regex expects a leading-pipe markdown table row, while AI2’s finding line is not in that format. Manual recomputation includes AI2 and still leaves P1 condition 2 met.

3.4 Arithmetic identities

64,922 / 131,968 = 0.491952595... = 49.1953%, rounded to 49.2%.

131,968 / 222,002 = 0.594445... = 59.4%, consistent with the quoted 59.4%.

42.9% of 131,968 is 56,614.272, not 64,922; the 42.9% value is not supported by the quoted numerator and denominator.

The required V-3 correction is 42.9% -> 49.2%, leaving the count 64,922 unchanged.

3.5 Round counts

design	rounds	basis
revise / re-audit loop	3	round 1 first audit; round 2 frozen second audit on revised text; round 3 projected after V-3 fix
one consolidated pass + checklist	1	first audit, one revision, frozen rev_check
reduction	2	3 - 1 = 2, which is at least 1
Round 3 is projected, not run, as declared in the SPEC and C50_RESULTS.

3.6 Portfolio deltas and D-sets

The packet contains only hash references for the Stage 5 deeper CSVs (portfolio_summary.csv, capacity_coverage_note.csv, escalate_by_type_top25.csv, inconclusive_by_clause.csv, independent_checks_critical_counts.csv, kappa_sensitivity.csv). Their contents are not provided, so portfolio deltas and D-sets cannot be independently recomputed from this packet.

Facts that cannot be recomputed from this packet.

The contents of scorers/n16lib.py are not provided; only its SHA-256 and byte count are stated.

The full FROZEN_INPUTS.sha256 and FROZEN_ORIGINS.tsv are not provided; only the preflight summary and selected hashes are available.

The contents of the Stage 5 deeper CSVs are not provided, so portfolio deltas, D-sets, and row-level reconciliation facts cannot be recomputed.

The C48 audit packet files are not provided; AUDIT_FREEZE.json gives only their packet_sha256 values.

The C04 terminal state is not in this packet. C50_RESULTS says it was not yet known when that file was written.

The actual raw byte streams of the frozen files are not available for hashing; I can only compare the stated SHA-256 values across references.

P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

P1 condition	independently recomputed result	basis
1. checklist flags V-3 on SEED and passes CLEAN	MET	SEED CHECK.csv V-3 TRUE; CLEAN all FALSE; SEED status FLAG; CLEAN status PASS
2. every BLOCKING / MATERIAL finding in the two frozen second-audit replies relates to V-3; none NEW or another revision	MET	AI2 F-1 MATERIAL V-3; AI3 F-1 BLOCKING V-3; no other BLOCKING/MATERIAL findings. Runner table omits AI2 but manual recomputation still satisfies the condition.
3. V-6 not flagged by checklist and neither audit grades V-6 NO / PARTIAL	MET	CLEAN and SEED V-6 flags both FALSE; AI2 and AI3 both grade V-6 YES
4. audit rounds fall by at least 1	MET	loop 3 incl. 1 projected; one pass 1; reduction 2
5. the two replies are byte-identical to AUDIT_FREEZE.json hashes	MET	AI2 06b3e1... matches; AI3 8b473a... matches
All five P1 conditions are MET from the frozen evidence as recomputed here. The C48 terminal-state dependency file is present and hash-consistent with the C50_RESULTS reference. The C04 terminal state is not in this packet; the SPEC says C50 is moot if C04’s recorded terminal state is the single-interpreter replacement state.

Blocking objections. List any defect in the harness, seed, predicate application or evidence that should block a verdict, or state "none".

No blocking objections that change the P1 result.
Non-blocking harness defect: the C50 scorer’s finding regex does not capture AI2’s F-1 MATERIAL V-3 because AI2’s finding is not formatted as a leading-pipe markdown table. This makes the C50_RESULTS findings table incomplete. Manual recomputation includes the omitted finding, and it relates to V-3, so P1 condition 2 remains MET.
Unresolved dependency: C04 terminal state is absent from the packet; adjudication must check it because the SPEC makes C50 moot if C04 records the single-interpreter replacement state.
Round 3 is projected, not run; this is declared in the SPEC and included in the frozen P1 wording, so it is not a blocking defect.

Claim → evidence map.

claim	evidence
C50 P1 condition 1 MET	C48_RESULTS.md CLEAN/SEED CHECK.csv tables; SEED status FLAG; CLEAN status PASS
C50 P1 condition 2 MET	ai2_second_audit.md F-1 MATERIAL V-3; ai3_second_audit.md F-1 BLOCKING V-3; no other BLOCKING/MATERIAL findings
C50 P1 condition 3 MET	C48_RESULTS.md V-6 flags FALSE; AI2/AI3 V-6 verdicts YES
C50 P1 condition 4 MET	SPEC round definition; C50_RESULTS Rounds table; 3 vs 1
C50 P1 condition 5 MET	AUDIT_FREEZE.json reply hashes vs ai2_second_audit.md and ai3_second_audit.md input hashes
WCA2 share should be 49.2%	64,922 / 131,968 = 0.491952595 = 49.2%; both AI2 and AI3 correct 42.9% to 49.2%
V-3 is the only checklist-flagged seed	C48_RESULTS.md SEED CHECK.csv V-3 flag TRUE; all others FALSE
Runner findings table is incomplete	C50_RESULTS.md lists only AI3 F-1; raw ai2_second_audit.md contains AI2 F-1 MATERIAL V-3
C04 terminal state is not available here	C50_RESULTS dependency note; no C04 file in packet
Portfolio deltas / D-sets not recomputable	only hash references for Stage 5 deeper CSVs; no table contents
END C50 VALIDATOR REPORT
