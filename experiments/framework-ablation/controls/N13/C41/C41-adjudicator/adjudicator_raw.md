1. Role attestation.

I am acting only as Adjudicator for C41 (Addendum 01 candidate #41, “Fixture depth over count,” N13 batch 5). Role assignment in the FREEZE RECORD is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I did not rerun anything, repair code, create a criterion, or relax a gate. Disposition is from the frozen packet only.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 11:21:09 CDT, constitution 1.0) names the packs that are included in this message as frozen verbatim:

- Builder: C41/C41-builder/builder_report.md, 17713 bytes, SHA-256 5fafa5d1ba02576953200e28535cc2f74f824239071cb85e25bcc9d3f134075f, verdict_token_leak: false. The included report ends with END C41 BUILDER REPORT and states no terminal disposition.
- Validator: C41/C41-validator/validator_report.md, 9611 bytes, SHA-256 49c9ccf3f385c787576009427ff1c16791145ee52c561146d936bf23b4f7b90a, verdict_token_leak: false. The included report ends with END C41 VALIDATOR REPORT and states no KEEP/REVERT/HALT.

Both reports are complete and end on their END lines. Runner evidence is bound by runner_evidence_sha256_file bd12765e67a5cbc4ebd71586ceba58a29f05215316e01a8698bbdfb4c3879854, with C41_EVIDENCE.sha256 covering C41_ARM_MANIFESTS.txt, C41_arms.csv, and C41_RESULTS.md. Preflight gating result is PASS against the FROZEN REFERENCE HASHES and the runner-side seed list. I did not rehash the embedded report text (tools forbidden; hashes are the freeze record’s). No freeze mismatch is asserted in either pack.

3. Hard-fact agreement table.

Facts below are the predeclared mechanical facts. Builder and Validator both recompute them from the same raw files; the runner RESULTS column is C41_RESULTS.md / C41_arms.csv / GATE and FIX files.

| Fact | Builder | Validator | Runner RESULTS | Agreement |
| --- | --- | --- | --- | --- |
| Exit records | 18/18 exit 0, no timeout | 18/18 present, first field 0, no timeout; B RUN_RB.exit 0 | Run log: 18 lines, all exit=0, timeout=0 | agree |
| B count | PASS 14/14, failures empty | PASS 14, none | PASS, 14, caught_count FALSE | agree |
| B depth | PASS 14/14, stubs empty | PASS 14, none, stubs none | PASS, 14, stubs none | agree |
| B key outputs vs frozen | 4/4 SHA-256 equal | 4/4 equal to the four frozen hashes | 4/4 equal | agree |
| P_DUPINT count / depth | 14/14 PASS; depth 13/14 fail {F07} | same | PASS 14; FAIL 13, F07 | agree |
| P_DATESWAP count / depth | 14/14 PASS; depth 10/14 fail {F03,F05,F10,F14} | same | PASS 14; FAIL 10, F03/F05/F10/F14 | agree |
| STUB_F11 | count 14/14; depth labels 14/14 but stub {F11}, gate FAIL | same | count PASS 14; depth FAIL, n_pass 14, stubs F11 | agree |
| JUDGE_P50 | both gates 12/14, fail {F03,F10} | same | both FAIL, 12, F03/F10 | agree |
| P_TZUTC (INFO, not scored) | both 14/14 PASS, no stub | same | both PASS 14; rb 1/4; real effect differs | agree |
| Count-caught set | {JUDGE_P50} | JUDGE_P50 only | JUDGE_P50 | agree |
| Depth-caught set | {P_DUPINT, P_DATESWAP, STUB_F11, JUDGE_P50} | same four | same four | agree |
| Superset | count-caught ⊆ depth-caught | same | condition 1 MET | agree |
| B portfolio | 131968+6377+83657=222002; +23191=245193 | same | raw row 222002,131968,6377,83657,23191 | agree |
| P_DUPINT delta vs B | decision +23012, INC +23012, out −23012 | same | portfolio 245014 / 179 | agree |
| P_DATESWAP delta vs B | ESC −11338, INC +32228, STD −20890 | same | portfolio 120630,38605,62767 | agree |
| JUDGE_P50 delta vs B | ESC +16973, STD −16973 | same | portfolio 148941,66684 | agree |
| P_TZUTC delta vs B | ESC +104, STD −104 | same | portfolio 132072,83553 | agree |
| STUB_F11 portfolio | equal to B | equal to B | equal counts; rb 4/4 | agree |
| Population | every arm decision+out = 245193 | same | implied by raw rows | agree |
| B timing | count 0.5 s, depth 1.2 s; 1.2 ≤ 0.5+60 | same | count_s 0.5, depth_s 1.2 | agree |
| P1 conditions 1–4 | all established | all supported by facts | P1 MET | agree |
| Blocking objections | none raised | none | — | agree |

Validator’s TSV-casing caveat is marked non-blocking and is not a numerical disagreement. No hard-fact row disagrees.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are present and named in the FREEZE RECORD; both reports end on their END lines; runner RESULTS, C41_arms.csv, raw GATE/FIX/exit files, ARM MANIFESTS, seed diffs, and preflight are in the packet. Citation: FREEZE RECORD; C41_EVIDENCE.sha256; PREFLIGHT preflight gating result: PASS.
6. PASS. Three distinct roles; Builder and Validator each attest a blind first pass and emit no terminal token; freeze record verdict_token_leak: false on both packs. Citation: FREEZE RECORD roles; Builder §1; Validator §1.
7. PASS. Section 3: Builder and Validator agree on exits, gate outcomes, failing sets, stub set, caught sets, portfolio identities and deltas, and clean-B 4/4 hashes. Citation: Builder §3; Validator §3; C41_RESULTS.md Arms and Failing fixtures.
8. PASS. Clean arm B’s four R-B key outputs equal the FROZEN REFERENCE HASHES byte-for-byte: classifications a0e42b86…fe193, fixture results 0d72245c…e9e9, portfolio counts eb677bc1…673c, κ grid 7a18fcb1…2c8a. Citation: C41_RESULTS.md “Arm B R-B outputs vs frozen”; ARM MANIFESTS arms/B out lines; FROZEN REFERENCE HASHES. N1/OF-1 is disclosed and cannot produce this mismatch: comparison is R-B to frozen R-B, which already embeds those three rows (Coordinator note).
9. PASS. Mandatory fixtures for this control are clean arm B’s count gate 14/14 and the frozen RB_fixture_results.csv hash. B count gate is PASS n_pass=14; B’s RB_fixture_results.csv hash equals 0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9. Depth gate on B is also PASS 14/14, stubs none. Seeded arms are scored under P1, not under this condition. Citation: SPEC regression rules; arms/B/outputs/GATE_count.txt; arms/B/outputs/FIX_count.csv; RESULTS arm B row.
10. PASS. Declared change is the depth gate (ruling 41A) plus the listed seeds. Clean arm B inputs match frozen R-B hashes (10_io_parse.R 40e67d83…, 20_integrity_and_classify.R 72ac5def…, 40_fixtures.R 2ad4aa69…) and its four outputs match frozen, so no undeclared semantic change on the clean path. Seeded file replacements match the declared seed hashes in preflight and the SEED DIFFS. Citation: ARM MANIFESTS arms/B in; SEED DIFFS; preflight seed OK lines.
11. PASS. No locked regression: clean B production run exit 0, 4/4 outputs equal frozen, both gates PASS, population 245193 conserved. The named-parser warning appears on clean B and on seeded arms and is not a depth_error and does not move B’s outputs. Citation: arms/B/RUN_RB.exit; RESULTS arm B; arms/B/RUN_FIX_depth.stderr.txt.
12. PASS. Predeclared P1 (ruling 41A, hashed in eval_b5.R before the reporting run) holds on the reporting evidence. (1) Superset: count catches only JUDGE_P50; depth also catches it. (2) Ruled targets: depth FAIL on P_DUPINT (F07 expected OUT_OF_SET observed ESCALATE), P_DATESWAP (F03/F05/F10/F14), and STUB_F11 (labels 14/14 but poison probe stubs=F11, gate FAIL). (3) Clean B count PASS, depth PASS, 4/4 frozen equality. (4) Depth wall time 1.2 s ≤ count 0.5 s + 60 s; extra chats none by construction. P_TZUTC is INFO and not scored. Citation: SPEC “Operational benefit predicate P1”; C41_RESULTS.md predicate table; raw FIX_depth.csv and GATE_depth.txt for those four arms; B exit lines 0.5 s and 1.2 s.
13. PASS. Validator §6: “Blocking objections: None.” The TSV DUPLICATE/LEGACY casing caveat is expressly non-blocking and does not change any recomputed gate outcome. No other objection is supported by the frozen evidence. Citation: Validator §6.
14. HALT conditions of §9.

- Hard mechanical conflict: absent. Section 3 has no disagree row. Citation: Builder §3; Validator §3 “No numerical inconsistency.”
- Required raw evidence missing: absent. Exit records, GATE/FIX files, portfolio rows, manifests, preflight, and frozen hashes are in the packet. Items the Validator could not recompute (generated TSV bytes, full function source, scratch-run raw, chat count) are not required raw artifacts for P1. Citation: packet instruction “Raw evidence is present”; Validator §4.
- Hash or frozen-version mismatch: absent. Preflight all frozen and seed lines OK; constitution hash e6c3b348…fdae9 matches the freeze; clean B outputs match the frozen four. Citation: PREFLIGHT; FROZEN REFERENCE HASHES; RESULTS arm B hash table.
- Baseline or constitution changed mid-run: absent. Baseline framework hashes and constitution 1.0 are the frozen pair; spec freeze written 2026-10-03 10:28 CDT before the 10:29 reporting run. Citation: SPEC freeze block; BASELINE FRAMEWORK HASHES.
- Role separation violated: absent. Citation: FREEZE RECORD roles; both attestations.
- Information barrier breached before first-pass freeze: absent. Both packs verdict_token_leak: false; each attests blindness. Citation: FREEZE RECORD; Builder §1; Validator §1.
- Benefit predicate not defined before execution: absent. P1 is in the frozen SPEC; pre-execution check states eval_b5.R was hashed before execution. Citation: SPEC “Pre-execution check”; constitution §6 form “detection of a seeded failure missed by baseline.”
- Adjudicator cannot tell which pack is authoritative: absent. One builder pack and one validator pack, both hash-named in the FREEZE RECORD. Citation: FREEZE RECORD.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no blocking objection. The only caveat is that exact casing of generated fixture-TSV DUPLICATE/LEGACY cannot be verified because the packet gives hashes and sizes, not TSV text, and the harness writes columns via write.table while the SPEC says true/false. That caveat does not bear on a gate result: serialized fixture-source hashes are identical across arms (FIXTURE_src_open_candidates.tsv 399a7f18…, FIXTURE_src_peer_stats.tsv 127fee5d…), depth outcomes differ only where the seeded loader or stub differs, and clean B still passes 14/14 with 4/4 frozen equality. It is not a supported blocking objection under §7 condition 9.

P_TZUTC (both gates PASS, production classifications differ, +104 ESCALATE / −104 STANDARD) is an INFO probe excluded from P1 by the SPEC. It is a residual coverage limit, not a failed KEEP condition and not a Validator objection.

7. Verdict rationale.

The change under test is ruling 41A: fixtures must enter through the production file-reading path, and a poison-judge stub probe must fail the gate. On the frozen pack it materially changes the outcome. The count gate catches only the superset control JUDGE_P50 (F03/F10). The depth gate still catches JUDGE_P50 and additionally catches the three ruled targets the count gate misses: P_DUPINT (F07), P_DATESWAP (F03/F05/F10/F14), and STUB_F11 (stub F11 while ordinary labels still pass). Clean arm B does not false-flag (count 14/14, depth 14/14, stubs none) and its four R-B outputs equal the frozen hashes. Cost is 0.7 s over the count gate, inside the +60 s allowance. All nine §7 conditions pass and no §9 HALT condition is present, so the depth rule is adopted.

TERMINAL_STATE: KEEP
END C41 ADJUDICATION
