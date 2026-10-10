1. Role attestation and ablation ID
I am DeepSeek, acting only as Validator (DeepThink on, Search off). I have not seen the Builder output and have not asked for it. I do not return a terminal state.

Ablation ID: C07 — owner ablation list control #7: Framing gate: exactly one question (ledger replay). Batch: N16. Target stage: Stage 1-2 framing. Capture mode: TEXT-ONLY as declared. Roles per SPEC: Builder=ChatGPT (High), Validator=DeepSeek (DeepThink on / Search off), Adjudicator=Grok (Expert).

2. Independent test plan: what I checked, and how
I checked the frozen SPEC, constitution, preflight output, C07_RESULTS.md, C07_extra_questions.csv, the frozen scorer source score_c07.py, and the verbatim frozen inputs supplied in the packet.

Independently performed checks:

Re-derived candidate-question count from frozen/stage12/candidate_question_ledger.md.

Re-derived the set of “extra decision questions that arose and were deferred” row-by-row from frozen/stage12/ambiguity_ledger.md, using the SPEC definition and the scorer’s declared TOPIC keys.

Compared the scorer’s mechanical count and row classifications with the verbatim ambiguity-ledger resolutions.

Checked in_stage3 / in_stage5 classifications against the verbatim MEASUREMENT_DESIGN_LOCKED.md, FINISH_GATE_PACKAGE.md, and STAGE5_EVIDENCE_PACKAGE.md using the scorer’s topic regexes and manual semantic reading.

Re-derived decision-ledger “open later” rows from frozen/stage12/decision_ledger.md.

Rechecked arithmetic and percentages in the Stage 5 portfolio counts, top ESCALATE types, and κ sensitivity.

Checked repeated SHA-256 values across SPEC, preflight, and C07_EVIDENCE.sha256.

Checked internal identity and lock-status consistency, especially CQ-F01 vs CQ-F02 and the Framing Gate lock status.

Did not execute code; this is a text-only packet. I did not use MySQL, R, or fresh data.

3. Independently recomputed hard facts
Candidate-question ledger
Fact	Recomputed value	Source
Candidate-question rows beginning CQ-	2	candidate_question_ledger.md
Not superseded / live	1	CQ-DRAFT-01 superseded; CQ-F01 live
CQ-DRAFT-01 status	Superseded by CQ-F01	candidate_question_ledger.md
CQ-F01 status	Promote candidate; awaiting AI Framing reviews + owner Framing Gate	candidate_question_ledger.md
CQ-F02 in Stage 1-2 candidate ledger	Not present	candidate_question_ledger.md
revision_trail.md mentions of CQ-F01/CQ-F02	1	Scorer regex; verbatim revision trail contains CQ-F01 only
Runner output says: 2 candidate questions, 1 not superseded. That part is mechanically consistent with the Stage 1-2 candidate ledger, except for the CQ-F01/CQ-F02 identity issue noted below.

Extra decision questions
Runner output says: 5 extra decision questions arose and were deferred; 0 lost.

Row-by-row recomputation from the ambiguity ledger:

Ambiguity ID	Scorer class	Manual deferred-extra assessment	In Stage 3?	In Stage 5 / Finish Gate?	Outcome
A003	extra question (deferred)	Yes — exact dates OPEN → Stage 3	yes	yes	carried
A006	extra question (deferred)	No — resolution says “Resolved (T008): no invented City SLA; portfolio urgency later”	yes	yes	runner says carried
A007	extra question (deferred)	Yes — exact formulas OPEN → Stage 3	yes	yes	carried
A008	extra question (deferred)	Yes — “Open — Stage 3”	yes	yes	carried
A011	extra question (deferred)	Yes — ranking/capacity OPEN later	yes	yes	carried
Manual count of deferred substantive extra questions: 4, not 5, if A006 is excluded because its stated point was resolved and the remaining “portfolio urgency later” is already represented by A008. The scorer’s literal regex catches A006 because the resolution contains “later”.

Lost count: 0 under both the runner’s 5-row set and the manual 4-row set. All listed rows are marked carried by keyword hits.

Decision-ledger rows marked open later
Row	Status text	Scorer output
Time scope	“Principle confirmed; dates open”	listed
Capacity / ranking	“Open later (Framing note / Stage 3)”	listed
Recomputed count: 2 rows listed by the scorer’s Open filter. The decision ledger also has an “Urgency / SLA” row with “Confirmed deferral”, but its status does not contain “Open”, so it is not listed under this heading. That is consistent with the heading as written.

Stage 5 portfolio arithmetic and deltas
From STAGE5_EVIDENCE_PACKAGE.md:

Measure	Value	Recheck
Decision set	222,002	131,968 + 6,377 + 83,657 = 222,002
ESCALATE	131,968	59.4% of 222,002
INCONCLUSIVE	6,377	2.9% of 222,002
STANDARD	83,657	37.7% of 222,002
Top ESCALATE type WCA2	64,922	49.2% of 131,968
Top ESCALATE type SED	17,254	13.1% of 131,968
Top ESCALATE type SKA	7,316	5.5% of 131,968
κ sensitivity ESCALATE at κ=1 / 1.5 / 2 / 3	152,292 / 140,340 / 131,968 / 118,246	monotonically decreasing as κ increases
No arithmetic inconsistency found in these portfolio numbers.

Cross-arm and hash equalities
Repeated hashes checked:

Item	Hash value	Consistency
Constitution	e6c3b348...	SPEC, PREFLIGHT, packet match
Owner rulings sheet	1214c896...	SPEC, PREFLIGHT, packet match
Owner answer file	3a7a87ca...	SPEC, PREFLIGHT, packet match
scorers/score_c07.py	8c265880...	SPEC, C07_EVIDENCE, packet match
scorers/n16lib.py	4a6675fa...	SPEC only; not in C07_EVIDENCE
C07_RESULTS.md	ab49fcea...	SPEC, C07_EVIDENCE, packet match
C07_extra_questions.csv	abfd4ad3...	SPEC, C07_EVIDENCE, packet match
Stage 1-2 ambiguity ledger	f6d856ea...	PREFLIGHT, C07_EVIDENCE match
Candidate-question ledger	fefdaab5...	PREFLIGHT, C07_EVIDENCE match
Decision ledger	9d704ede...	PREFLIGHT, C07_EVIDENCE match
Revision trail	aafa32e3...	PREFLIGHT, C07_EVIDENCE match
Stage 3 locked design	7297cf3e...	PREFLIGHT, C07_EVIDENCE match
Stage 5 Finish Gate package	22dc6a94...	PREFLIGHT, C07_EVIDENCE match
Stage 5 Evidence Package	c8e191d8...	PREFLIGHT, C07_EVIDENCE match
No listed hash mismatch found. No R-A/R-B cross-arm hashes exist because N16 declares no R run.

Internal inconsistencies in the runner output / evidence
A006 overcount. C07_RESULTS.md and C07_extra_questions.csv classify A006 as an “extra question (deferred)”. The verbatim ambiguity ledger A006 resolution says “Resolved (T008): no invented City SLA; portfolio urgency later”. The deferred part “portfolio urgency later” is not the A006 point (“Official City SLA”) and is already represented by A008. The runner’s regex counts A006 because of the substring “later”. This makes the hard count 5 inconsistent with a manual application of the SPEC’s “deferred” meaning, which yields 4.

CQ-F01 vs CQ-F02 identity mismatch. The SPEC control under test says the Chicago run locks CQ-F02. The frozen Stage 1-2 candidate ledger has CQ-F01 as the live promoted candidate and does not contain CQ-F02. Stage 3 and Stage 5 refer to CQ-F02. The runner output’s candidate-question section reports CQ-F01.

Framing Gate lock-status mismatch. The Stage 1-2 candidate ledger says “Framing Gate not owner-locked” and CQ-F01 is “Promote candidate — awaiting AI Framing reviews + owner Framing Gate”. The SPEC and Stage 3/5 treat CQ-F02 as the locked Stage 2 framing question. The packet does not include a Framing Gate lock receipt resolving this.

Timestamp ordering. C07_RESULTS.md is generated at 2026-10-09 02:21:35 CT; the N16 preflight output is timestamped 2026-10-09 02:21:42 CT. The results timestamp is 7 seconds earlier than the preflight timestamp. If preflight was required before the reporting run, this ordering is inconsistent. If preflight was a later re-verification, it may be harmless, but the packet does not clarify.

Missing n16lib hash in C07_EVIDENCE. C07_EVIDENCE.sha256 includes scorers/score_c07.py but not scorers/n16lib.py, even though score_c07.py imports n16lib. The n16lib hash is given in the SPEC, so this is a traceability gap rather than a proven hash mismatch.

4. Facts that cannot be recomputed from this packet
The following cannot be independently recomputed from the supplied packet alone:

Actual SHA-256 values from the raw files; only the listed hash strings can be compared.

The full 75-file FROZEN_INPUTS.sha256 contents and the omitted origin-hash comparison lines from preflight.

The source and behavior of scorers/n16lib.py; only its hash is listed.

The contents/hash of SPEC_FREEZE_N16.sha256.

Whether the owner answer Z, extra-chats-zero condition, text-only capture, and role separation were actually enforced outside the packet.

Whether keyword hits in the locked Stage 3 design or Stage 5 package semantically mean “carried”; the SPEC says this is for judges to confirm against verbatim documents.

Whether CQ-F01 and CQ-F02 are an authoritative renaming of the same question, or whether there was a real identity change.

Whether the Framing Gate was actually owner-locked after the Stage 1-2 ledger snapshot; the Stage 1-2 ledger says pending.

Whether A006’s “portfolio urgency later” is distinct from A008 or was intended to be counted as part of A006.

Full Stage 4/Stage 5 validation artifacts; only summaries and selected frozen files are included.

Any R-A/R-B path, fixtures, MySQL/R outputs, or clean-arm byte identity checks; N16 declares these not applicable.

5. P1 assessment against the frozen predicate in the SPEC
Frozen predicate, as stated in the SPEC:

KEEP side iff no extra decision question arose, OR at least one extra question was lost.

REVERT side otherwise.

The scorer’s mechanical rule is the same.

Recomputed facts:

P1 element	Runner value	Independent manual value
Extra decision questions that arose and were deferred	5	4
Lost extra questions	0	0
KEEP-side first disjunct: no extra question arose	false	false
KEEP-side second disjunct: at least one lost	false	false
Scorer-selected branch	alternative branch	alternative branch
Under both the runner’s count and the manual count, extra questions arose and none was lost. Therefore the KEEP-side condition in the frozen predicate is not satisfied, and the scorer’s declared rule selects its alternative branch. I do not return a terminal state.

The SPEC’s own weak-test disclosure remains relevant: there is no counterfactual Framing run, and keyword hits for “carried” are not a semantic proof that the single locked question contained every extra question.

6. Blocking objections
Blocking objections that should block a verdict until resolved:

Predicate-application defect: A006 is counted as deferred although its resolution says resolved.
The runner reports 5 extra deferred questions. The verbatim ambiguity ledger shows A006 as “Resolved (T008): no invented City SLA; portfolio urgency later”. The deferred part is not the A006 point and is already represented by A008. This changes a hard mechanical count from 5 to 4 and means the runner’s hard fact is not independently reproduced.

Identity and lock-status defect: CQ-F01 vs CQ-F02.
The SPEC says the Chicago run locks CQ-F02. The frozen Stage 1-2 candidate ledger has CQ-F01, not CQ-F02, and says the Framing Gate is not owner-locked. Stage 3/5 refer to CQ-F02. The packet lacks a mapping or lock receipt. This is an evidence/identity defect affecting the control under test.

Other noted issues, not necessarily blocking on their own:

C07_RESULTS.md timestamp precedes the preflight timestamp by 7 seconds.

C07_EVIDENCE.sha256 omits scorers/n16lib.py, though the scorer imports it.

Keyword-hit operationalization is disclosed and weak, but it is declared in the SPEC.

7. Claim → evidence map
Claim	Evidence
Validator is blind to Builder	Packet role statement; no Builder artifact in packet; attestation above
Ablation C07 / N16 / Stage 1-2 framing	SPEC header
Text-only capture approved	Coordinator note; SPEC capture mode
Constitution hash matches	SPEC e6c3b348...; PREFLIGHT e6c3b348...
Owner rulings and answer hashes match	SPEC and PREFLIGHT matching 1214c896..., 3a7a87ca...
Scorer hash matches	SPEC, C07_EVIDENCE, packet 8c265880...
C07 results and CSV hashes match	SPEC, C07_EVIDENCE ab49fcea..., abfd4ad3...
Candidate-question count = 2, live = 1	candidate_question_ledger.md; C07_RESULTS.md
Runner extra count = 5	C07_RESULTS.md; C07_extra_questions.csv
Manual extra count = 4 if A006 excluded	ambiguity_ledger.md A006 resolution; C07_extra_questions.csv A006 row
Lost count = 0	All runner rows outcome=carried; manual rows A003, A007, A008, A011 carried
Decision-ledger open-later rows = 2	decision_ledger.md; C07_RESULTS.md
Portfolio decision set = 222,002	STAGE5_EVIDENCE_PACKAGE.md; FINISH_GATE_PACKAGE.md
ESCALATE = 131,968, INCONCLUSIVE = 6,377, STANDARD = 83,657	STAGE5_EVIDENCE_PACKAGE.md; FINISH_GATE_PACKAGE.md
Top type percentages 49.2%, 13.1%, 5.5%	Recomputed from Stage 5 counts
κ sensitivity monotonic	STAGE5_EVIDENCE_PACKAGE.md
CQ-F01/CQ-F02 mismatch	SPEC says CQ-F02; candidate_question_ledger.md says CQ-F01; Stage 3/5 say CQ-F02
Framing Gate lock-status mismatch	candidate_question_ledger.md says not owner-locked; SPEC/Stage 3/5 treat CQ-F02 as locked
Preflight/results timestamp ordering	PREFLIGHT_N16.txt 02:21:42 CT; C07_RESULTS.md 02:21:35 CT
P1 KEEP-side condition not satisfied	SPEC predicate; runner extra=5, lost=0; manual extra=4, lost=0
No terminal state returned	This Validator report
END C07 VALIDATOR REPORT
