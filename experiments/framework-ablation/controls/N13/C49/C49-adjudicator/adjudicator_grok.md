1. Role attestation

I am the Adjudicator only for C49 (Addendum 02 candidate #49, “Individual-file evidence delivery”). Role assignment in the FREEZE RECORD is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I have not rerun code, repaired artifacts, created a criterion, or relaxed a gate. I return one terminal state under constitution §7–§10 and the packet’s HALT list. N1/OF-1 is treated as the disclosed frozen-pack clock finding (three ESCALATE rows, 1.000 h, labels agree, repeated fall-back hour; 53A makes R-B the conforming reading). C49 did not rerun either R path.

2. Freeze check

The FREEZE RECORD (2026-10-03 13:28:12 CDT) names C49/C49-builder/builder_report.md (17860 bytes, SHA-256 d73c807fa982c9ddb7dbe961abd3d8f58120052e00cd0375585861f70b3c09fb, verdict_token_leak: false) and C49/C49-validator/validator_report.md (10269 bytes, SHA-256 f7f285be5268fc36890ac99467a9cca0e49c935a67c64ed8cff654552c0d9891, verdict_token_leak: false). The two reports in this packet are those named files, given verbatim. I am not rehashing them. Each is complete and ends with its END line: Builder with END C49 BUILDER REPORT, Validator with END C49 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token.

REPLY_FREEZE.json (dfc41fb13e9bfca1a81c1f1e3cb1f498fba65b6364d7441e6b5a60aa72f243eb, frozen 2026-10-03 12:47:03 CDT) names the three scored replies and TIMES files. The hashes printed beside those verbatim bodies match that record: DS_ZIP reply 434ead16…, DS_FILES reply f6e0a1f7…, GPT_FILES reply 94cab4c7…. All three replies end with END C49 FIRST PASS.

The pre-execution FROZEN REFERENCE HASHES do not match the runner-side file the scorer actually read. Preflight and ARMS.v1_prePD3.tsv are edc8a02618014eb9e370ae01f605303630874d465917f3785b7fa5518d3ddeea. The patched ARMS.tsv the scorer used is bead849473f20fa93faf53091325faaa87f6db9f03c5ea6ed1b6a2809c1a4f95. The frozen DS_FILES packet is 9fa6cc58745d144a5c53a371f0b41db69d0503b212c2b1ce08a33eb84998f7a2; the scored packet is C49_R_DS_FILES_PD3.txt at 89ac5ab586f1daab8d4cbfa8c4819ebb1f2bf764d232773f769cc3c6afed0aba, which is not in SPEC_FREEZE_b6.sha256. That mismatch is disclosed in the deviation notes and is taken up in §5 and §6. It is not a failure of the B/V report freeze itself.

3. Hard-fact agreement table

Builder and Validator do not disagree on a hard number. The DS_ZIP fact-counter defect and the AI1 line-count split are agreed descriptions of the same artifacts, not a split result.

| Fact | Builder | Validator | Runner / frozen scorer | Mark |
| --- | --- | --- | --- | --- |
| CHECK exit / status | 0 / PASS | 0 / PASS | C49_arms.csv: exit 0, PASS; DELIVERY_CHECK.txt status=PASS | agree |
| Evidence files / delivery files / ZIP entries | 9 / 10 / 10 | 9 / 10 / 10 | 9, 10, 10 | agree |
| FILES bytes / ZIP bytes / ZIP SHA-256 | 17323 / 9592 / ea8ff49d… | 17323 / 9592 / ea8ff49d… | same in DELIVERY_CHECK.txt | agree |
| Evidence listed = file = ZIP hash | 9/9, plus SHA256SUMS file=ZIP 1f2aad88… | 9/9, same | DELIVERY_FILES.csv | agree |
| P1 condition 0 | MET | MET | pre-chat RESULTS: MET | agree |
| Q1 / Q3 / Q4 / Q5 | 131968 / 49.2 / 25 / 118246 | same | KNOWN_ANSWERS.csv; both usable replies | agree |
| Q2 | 64922, quoted, WCA2 row not in packet | 64922, not recomputed from primary file | known-answer file only | agree |
| κ=2 and κ=3 portfolio sums | 222002 and 222002; ESCALATE delta −13722 offset by STANDARD +13722 | same | LAST lines in both usable inventories | agree |
| DS_ZIP access / hashes / usable / time-to-usable | 0/9, 0/9, FALSE, Inf; minutes 0.65 upper bound | same | INVENTORY_DS_ZIP.csv, arms row | agree |
| DS_ZIP substantive Q answers | scorer 3/1 is a parse artifact; verbatim 0/5 | same | FACTS_DS_ZIP.csv vs reply text; deviation note | agree |
| DS_FILES (scored PD-3 rerun) access / hashes / facts / usable / minutes | 9/9, 9/9, 5/5, TRUE, 0.83 | same | INVENTORY_DS_FILES.csv, FACTS_DS_FILES.csv, TIMES 12:30:32→12:31:22 | agree |
| GPT_FILES access / hashes / facts / usable / minutes | 9/9, 9/9, 5/5, TRUE, 5.00 upper bound | same | INVENTORY_GPT_FILES.csv, FACTS_GPT_FILES.csv | agree |
| Scorer P1 conditions 1–3 | MET / MET / MET | MET / MET / MET | C49_POST_RESULTS.md: P1 MET | agree |
| AI1 LINES | DS_FILES 254, GPT_FILES 252, same SHA 73f448…; not an access proof | same | replies; LINES not in the frozen proof | agree |
| ARMS.tsv preflight vs scored | edc8a026… vs bead8494… | same two hashes | both files quoted | agree |
| DS_FILES packet frozen vs scored | 9fa6cc58… vs 89ac5ab5… | same | SPEC freeze vs REPLY_FREEZE | agree |

Access-proof recheck against the delivery record: for every evidence file, DS_FILES and GPT_FILES FIRST and LAST lines match each other and match the lines the scorer treated as truth (package title through “Human owner retains final authority”; deeper-findings title through the WCA2 sentence; the six CSV header/last rows; AI1 title through “Is this conversation helpful so far?”). Those FIRST/LAST strings are identical across the two FILES replies, and the nine SHA-256 strings they print equal SHA256SUMS and DELIVERY_FILES.csv. DS_ZIP prints UNAVAILABLE / OPENED: NO for all nine. The scorer’s access table is consistent with the replies. Its DS_ZIP Q parser is not: the reply says all five facts are UNAVAILABLE, and both packs correctly refuse the scorer’s 3/1 count. That defect does not move usability, which is already false on 0/9 access.

4. The nine KEEP conditions of constitution §7
5. Evidence packs complete and frozen: FAIL. The B/V reports and the post-rerun replies are frozen, but the scored DS_FILES path is not the pre-execution frozen path. ARMS.tsv and the DS_FILES packet differ from the FROZEN REFERENCE HASHES and from SPEC_FREEZE_b6.sha256 (Validator §3 and §6; deviation notes part 2).
6. Role separation valid: PASS on the barrier that was actually tested. Both reports attest blindness to each other; reviewer chats are separate conversations and were frozen before the B/V packets (SPEC “Roles”; FREEZE RECORD). The same-model overlap (DeepSeek reviewer and Validator; ChatGPT reviewer and Builder) is pre-declared in the frozen SPEC, not a mid-run breach. No packet evidence shows either first pass saw the other.
7. Builder and Validator agree on hard mechanical facts: PASS. Section 3 has no disagree row. Constitution §4 is not triggered.
8. Exact reconciliation where required: PASS for the declared C49 check. SPEC assigns §7 condition 4 to byte-identical evidence across arms. c49_check.R PASS: 9/9 listed hashes equal file hashes equal ZIP hashes, and SHA256SUMS file hash equals its ZIP hash (DELIVERY_FILES.csv). C49 does not rerun analytical reconciliation. The quoted 14/14 fixtures and 0 disagreements on 222002 rows are Stage 5 text inside the delivery set, not a C49 recomputation. N1/OF-1 remains an open frozen-pack finding and is not a C49 effect.
9. Every mandatory fixture passes: PASS for the fixtures this control declared. SPEC assigns §7 condition 5 to zip/file identity and SHA256SUMS. CHECK exit 0, status=PASS, zip SHA-256 ea8ff49d164e41dcd442590dbec6c7d9ffb2c83a9baa5a5e6193d79c6cde5f9d matches the frozen reference. Untested arms (no GPT_ZIP, no Grok reviewer) are not evidence either way.
10. No undeclared semantic change: PASS on the evidence bytes. The nine evidence hashes in the FILES replies equal the frozen SHA256SUMS. The declared change is delivery format. The PD-3 rename is a harness deviation, not a change to those nine bytes. N1 was held constant in every reviewer prompt.
11. No locked regression introduced: PASS on the surfaces C49 was allowed to touch. No R path was rerun. The delivery check did not alter file bytes. The DS_ZIP scorer parse defect is disclosed and does not decide P1.
12. Predeclared benefit predicate satisfied: FAIL as a KEEP condition, because it is not established on the frozen arm. On the scored replies the frozen scorer and both packs say condition 0 MET, DS_FILES and GPT_FILES 9/9 access and 9/9 hash match, and condition 3 MET because DS_ZIP is unusable (time-to-usable Inf; the 0.83 ≤ 0.65+2 comparison is surplus). Condition 2 for DS_FILES is true only of the PD-3 rerun, after the frozen packet and ARMS.tsv were replaced. I do not treat that rerun as the frozen predicate result.
13. No blocking objection remains supported: FAIL. Validator objections 1–3 are supported by the hash and path evidence in §6. Constitution §7.9 fails whether or not those objections are also §9 HALT grounds.
14. HALT conditions of §9

- Hard mechanical conflict between Builder and Validator: absent. Section 3.
- Required raw evidence missing: absent. Runner RESULTS, DELIVERY_FILES.csv, arm manifests, three replies, three TIMES files, both deviation notes, both ARMS versions, and the superseded first DS_FILES reply are in the packet. Historical stdout is not a HALT ground here. DS_ZIP and GPT_FILES completion times are disclosed upper bounds; DS_ZIP unusable makes condition 3 unambiguous under the frozen rule.
- Hash or frozen-version mismatch against the FREEZE RECORD or the FROZEN REFERENCE HASHES: present. FROZEN REFERENCE HASHES and preflight lock seeds/C49/ARMS.tsv at edc8a026…. The scorer read bead8494…. SPEC freeze locks C49_R_DS_FILES.txt at 9fa6cc58…. The scored packet is 89ac5ab5…. The checksum file the DS_FILES reviewer opened was SHA256SUMS.txt under FILES_PD3/, not the frozen delivery/FILES/SHA256SUMS. The B/V report hashes in the FREEZE RECORD are a separate freeze and are not the mismatch.
- Baseline or constitution changed mid-run: absent. Both baseline hashes and constitution e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9 are restated as frozen.
- Role separation violated / information barrier breached before first-pass freeze: absent as a demonstrated breach. Overlap is pre-declared; both packs attest blindness; replies were frozen before B/V.
- Benefit predicate not defined before execution: absent. P1 conditions 0–3 are in the frozen SPEC, and c49_score.R was hashed in SEEDS_b6.sha256 before the reporting run.
- Adjudicator cannot tell which pack is authoritative: absent as a separate ground, and not needed. The deviation notes say the PD-3 copy is what was scored, and the original is preserved under _superseded_PD3. The HALT ground is the mismatch with the pre-execution reference, not ambiguity about which file was scored.

6. Blocking objections raised by the Validator and how the evidence bears on them

Objection 1, patched ARMS.tsv. Supported. Preflight gating line is edc8a026… seeds/C49/ARMS.tsv. The file quoted as the scorer input is bead8494…, and it points DS_FILES at C49_R_DS_FILES_PD3.txt with delivery label “FILES (PD-3 rerun: FILES_PD3, SHA256SUMS.txt)”. The pre-patch file is preserved and matches the freeze. Disclosure does not restore the frozen hash.

Objection 2, substituted DS_FILES packet. Supported. Frozen packet 9fa6cc58… (2808 bytes) is in the SPEC freeze and in the FROZEN REFERENCE list. Scored packet 89ac5ab5… (2816 bytes) appears in REPLY_FREEZE, which was written after the rerun. The text change is the checksum filename. It is still a changed frozen input.

Objection 3, substituted delivery set. Supported as a frozen-path deviation, not as a byte change to the nine evidence files. Deviation notes part 2 say FILES_PD3/ is byte-identical except SHA256SUMS renamed SHA256SUMS.txt, and the operator confirmed 11/11 chips. The scored reply’s nine hashes equal frozen SHA256SUMS. The filename and directory are not the frozen seed path. The first DS_FILES reply (preserved, not scored) shows why the rerun happened: SHA256: UNAVAILABLE — SHA256SUMS not provided on all nine, with OPENED: YES and the same five facts. That is a harness delivery defect. It does not authorize scoring a post-freeze packet against a pre-execution hash lock.

Non-blocking items, agreed and not decisive: DS_ZIP scorer 3/1 versus verbatim 0/5; AI1 LINES 254 versus 252 at identical SHA-256 73f448…; DS_ZIP and GPT_FILES TIMES as upper bounds. The DS_ZIP end state (upload reported accepted, page shows only the packet, model reports no openable zip, 0/9 access) is the baseline observation, not PD-3. Cause of the zip miss is not isolated. That does not cure objections 1–3.

7. Verdict rationale

The change under test is individual-file evidence delivery plus SHA256SUMS and a mandatory inventory. On the replies that were scored, that format is the one that produced a usable first pass: DS_FILES and GPT_FILES each prove 9/9 FIRST/LAST access, list the frozen hashes, and answer Q1–Q5 as 131968 / 64922 / 49.2 / 25 / 118246. The ZIP arm proves 0/9 and is unusable, which is the PricePoint failure mode this control was built to measure. Delivery-set identity itself passed before any chat.

That outcome is not adoptable. P1 conditions 1 and 2 require the frozen DS_FILES arm. The arm that satisfied them was a post-freeze rerun: different ARMS.tsv hash, different packet hash, checksum file renamed. Those hashes are in the FROZEN REFERENCE HASHES and the SPEC freeze. Constitution §9 and this packet’s HALT list treat a frozen-version mismatch as HALT, not as a soft objection to be waived because the nine evidence bytes matched and the coordinator disclosed the repair. I cannot pick the scored PD-3 result over the frozen reference, and I cannot demote the mismatch to a non-blocking note. P1 is therefore not established on the frozen pack, and the experiment is not valid enough to KEEP or REVERT.

TERMINAL_STATE: HALT
END C49 ADJUDICATION
