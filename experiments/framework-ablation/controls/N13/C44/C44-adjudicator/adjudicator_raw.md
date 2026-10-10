1. Role attestation.

I am acting as Adjudicator only for ablation C44 (Addendum 02, candidate #44, “Changed-files-only re-review”), N13 batch b6, constitution 1.0. Builder is ChatGPT; Validator is DeepSeek; Adjudicator is Grok, as frozen in the FREEZE RECORD and the SPEC. This is a terminal decision on frozen evidence only. I did not rerun any arm, repair code, create a criterion, relax a gate, or substitute one side’s mechanical result for the other’s. OF-1/N1 is disclosed and does not enter a C44 number: this control reads Stage 5 text and frozen Stage 5 evidence and reruns no R path.

2. Freeze check.

The FREEZE RECORD (EVIDENCE_FREEZE.json, frozen_at_ct 2026-10-03 12:44:09 CDT) names the two first-pass packs and records verdict_token_leak false for both:

- Builder: C44/C44-builder/builder_report.md, 19,696 bytes, SHA-256 4fbad9aac1c27587fa394e24c62359f1c944c9974adc915d6d4846ebbe0a1988.
- Validator: C44/C44-validator/validator_report.md, 11,786 bytes, SHA-256 7ec60d47981cb386f45e0c838f7541028dcbde8c764cdacbfa812b95fbfd215f.

The reports embedded in this packet are those packs. Each is complete and ends with its required END line: END C44 BUILDER REPORT and END C44 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Reply freeze is separate and earlier: REREVIEW_FREEZE.json SHA-256 e791b4a6d5521a1fc24b295b3df48e271c14ab22756f75470ccc60a26e033f2a, frozen_at_ct 2026-10-03 12:23:37 CDT, covering the FULL reply (8b473adf6fd7cfe4ba6b363fcb52f009561b26f4ca44d6295126ad9a96c2aed2, 3,053 bytes, ends END C48 AI3 SECOND AUDIT) and the DELTA reply (d0635883ab82f4bf5d1f3fc94200715d5d4b66746aaf2023a99c64b43a9cebfb, 2,834 bytes, ends END C44 AI3 DELTA RE-REVIEW). Those reply hashes match the post-chat scorer arm table. Preflight gating result is PASS, and the runner-side hashes the SPEC lists (FULL packet dab6e55f…, DELTA packet a3c359dc…, REVISED_SEED c1ac310a…, c44_static.R, c44_score.R) match the preflight and REREVIEW_FREEZE lines.

3. Hard-fact agreement table.

| Fact | Builder | Validator | Runner / frozen replies | Agreement |
| --- | --- | --- | --- | --- |
| STATIC exit / status | exit 0, PASS | exit 0, PASS | C44_arms.csv: STATIC,0,PASS; STATIC_CHECK.txt status=PASS | agree |
| FULL packet bytes / hash | 58,214; dab6e55f…f6aeb96 | same | preflight, REREVIEW_FREEZE, scorer | agree |
| DELTA packet bytes / hash | 18,691; a3c359dc…6508bb | same | preflight, REREVIEW_FREEZE, scorer | agree |
| DELTA/FULL ratio | 18,691/58,214 = 0.32107397 (reported 0.3211); reduction 67.8926% | 0.3211; reduction ≈ 67.89% | scorer condition 3 MET on packet-byte proxy | agree |
| Unchanged inputs listed by hash | 13/13 | 13/13 | UNCHANGED_HASH_LIST_CHECK.csv all TRUE | agree |
| Revised text verbatim; unchanged bodies absent | TRUE; TRUE | TRUE; TRUE | STATIC_CHECK.txt | agree |
| Revised-text hash both inventories | c1ac310a…a720b63 | same | preflight and both packet inventories | agree |
| FULL reply hash / bytes / END | 8b473adf…c2aed2, 3,053, END present | same | REREVIEW_FREEZE; reply ends END C48 AI3 SECOND AUDIT | agree |
| DELTA reply hash / bytes / END | d0635883…a9cebfb, 2,834, END present | same | REREVIEW_FREEZE; reply ends END C44 AI3 DELTA RE-REVIEW | agree |
| V-1..V-6 | FULL YES/YES/PARTIAL/YES/YES/YES; DELTA YES/YES/NO/YES/YES/YES | same | frozen replies and scorer arm table | agree |
| BLOCKING/MATERIAL finding count and key | FULL 1, key V-3; DELTA 1, key V-3; set difference empty | same | FINDINGS_FULL.csv, FINDINGS_DELTA.csv; key-level aid TRUE | agree |
| Finding identity | F-1 BLOCKING V-3 and F1 MATERIAL V-3 quote the same 42.9% sentence and require 49.2% | same quote and correction | both frozen finding rows | agree |
| V-3 arithmetic | 64,922/131,968 = 0.49195259… = 49.1953% → 49.2% | same | escalate_by_type_top25.csv WCA2 row 0.4919525945683802 | agree |
| κ=2 partition | 131,968+6,377+83,657 = 222,002 | same | portfolio and critical-count tables | agree |
| Condition 2 mechanical | DELTA V-3 NO and MATERIAL on V-3; seed caught | same; seed_V3_caught=TRUE | scorer MET | agree |
| Condition 3 metric | packet-byte proxy, because FULL minutes = NA; ≥30% met | same; DELTA 0.77 min is an upper bound and is not the scored metric | scorer: proxy MET; TIMES.txt ruling | agree |
| Condition 1 | same defect raised; severity labels differ; predicate does not require identical severity | same | scorer leaves condition 1 PENDING (judged) | agree |
| Unchanged-file seed | not planted; not measured | not planted; not measured | SPEC deviation 1; scorer note | agree |
| N1/OF-1 | 3 rows × 1.000 h, labels agree; not a C44 number | does not enter C44 numbers | coordinator note; SPEC | agree |

No hard-number disagreement. The PARTIAL vs NO grade and the BLOCKING vs MATERIAL label are recorded by both sides as the same defect, not as conflicting mechanical results.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are complete and frozen: FREEZE RECORD 2026-10-03 12:44:09 CDT; REREVIEW_FREEZE 2026-10-03 12:23:37 CDT; preflight PASS; static and post-chat outputs present; both replies and both first-pass reports end on their END lines; verdict_token_leak false.
6. PASS. Role separation is the frozen assignment Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Both first passes attest blindness to the other. The SPEC discloses that DeepSeek also wrote the AI 3 re-review in a separate conversation, blind to this ablation and frozen before the Builder and Validator packets were built. That is the measured arm, not a second constitution role, and it is not an information-barrier breach of the first passes.
7. PASS. Builder and Validator agree on every predeclared hard mechanical fact in the table above, including packet bytes, hashes, 13/13 unchanged listing, verbatim revised text, reply hashes, END lines, V-status vectors, and the single BLOCKING/MATERIAL key V-3. Constitution §4 disagreement is absent.
8. PASS. The SPEC assigns this condition to byte-identity of the revised text in both arms. Static check revised_text_verbatim=TRUE; both inventories carry c1ac310a7c77ab4228ac14ebb6c56e58b408e4e64cdf74fae8f1f68b9a720b63. Inherited Stage 5 fact remains 0 label disagreements across 222,002 rows; C44 reruns no reconciliation.
9. PASS. The SPEC assigns this condition to the static check’s known-answer cases: 13 unchanged hashes listed, revised text verbatim, unchanged bodies absent. STATIC_CHECK.txt and UNCHANGED_HASH_LIST_CHECK.csv record all of those as true, STATIC exit 0. Inherited fixture statement remains 14/14 on both paths; C44 reruns no fixture.
10. PASS. The only scope difference is the declared one: DELTA omits unchanged bodies and sends the diff plus unchanged hashes. Both arms review the same revised text. No undeclared semantic change is detected in the frozen replies. The unchanged-file seed is marked not measured and is not evidence either way.
11. PASS. No locked regression is introduced. No R path, fixture, or reconciliation was rerun. The planted changed-file defect is still caught. OF-1 remains the disclosed upstream clock finding and is outside C44.
12. PASS. P1, as frozen before execution, is satisfied. Condition 0: static PASS. Condition 1, judged from the two frozen replies: FULL’s only BLOCKING/MATERIAL finding is F-1, the sentence WCA2 alone supplies 64,922 of these (42.9% of ESCALATE)…, correction to 49.2% with 64,922 / 131,968 = 0.491952595. DELTA F1 quotes that sentence, relates it to V-3, grades it MATERIAL, and requires the same replacement. The SPEC requires the finding to be raised, any wording, not the same severity token. I do not add a severity-identity gate. Condition 2: DELTA marks V-3 NO and raises a MATERIAL finding on V-3. Condition 3: FULL send time is not logged, so the declared proxy applies; 18,691 is 32.11% of 58,214, a 67.89% reduction, above 30%. The DELTA 0.77-minute figure is an upper bound and is not scored.
13. PASS. The Validator’s blocking-objection section is “None.” The residual caveats (reused FULL arm, unmeasured unchanged-file seed, proxy cost, N1 omitted from the DELTA packet) are disclosed SPEC deviations and are not supported as blocking by the frozen evidence.
14. HALT conditions of §9.

- Hard mechanical conflict: absent. Section 3; both reports agree.
- Required raw evidence missing: absent. Static stdout/exit, STATIC_CHECK.txt, unchanged-hash CSV, both replies, REREVIEW_FREEZE, post-chat scorer, and TIMES.txt are in the packet. Historical FULL stdout is not required; the instruction says not to HALT only because historical stdout is missing.
- Hash or frozen-version mismatch: absent. Preflight PASS; reply and packet hashes match REREVIEW_FREEZE and the scorer; constitution hash e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9 is the frozen 1.0 hash.
- Baseline or constitution changed mid-run: absent. Spec freeze and baseline framework hashes are recorded before the reporting run; no mid-run change is shown.
- Role separation violated: absent. Section 4 condition 2.
- Information barrier breached before first-pass freeze: absent. Both reports attest blindness; DELTA chat was frozen at 12:23:37 CDT, evidence freeze at 12:44:09 CDT.
- Benefit predicate not defined before execution: absent. P1 conditions 0–3 are in the frozen SPEC; eval_b6.R and the harness were hashed in SEEDS_b6.sha256 before the reporting run.
- Authoritative pack indeterminate: absent. FREEZE RECORD names one Builder pack and one Validator pack; both are the reports in this message.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no blocking objection. The non-blocking caveats, and the Builder’s corresponding limits, bear as follows.

Severity is not identical: FULL F-1 is BLOCKING and the FULL verdict is FAIL; DELTA F1 is MATERIAL and the DELTA verdict is PASS WITH REQUIRED REVISIONS. The frozen replies still identify the same sentence, the same wrong percentage, the same recomputation, and the same required correction, and DELTA says the error must be corrected before release. P1 condition 1 asks whether the FULL finding is raised, not whether the severity token matches. Treating the label difference as a failure would be a new criterion, which §10 forbids. It is not a blocking objection.

The unchanged-file seed was not planted. The SPEC marks it not measured. The instruction says items marked not measured are not evidence either way. A KEEP here covers the changed-artifact case only, which is the case this control defined and ran.

Cost is the declared packet-byte proxy, not wall-clock. FULL minutes are NA. TIMES.txt says an upper bound must not be scored as met if it makes a timing condition ambiguous; that ruling does not displace the predeclared proxy, which the scorer applied and both reports accept.

N1 was left out of the DELTA packet by SPEC deviation 2 so the arms differ in scope only. It is not a C44 result.

7. Verdict rationale.

The change under test is a re-review limited to the changed artifact, its diff, and the SHA-256 of the unchanged inputs, against the frozen full-scope C48 AI 3 second audit of the same revised text. On that frozen pack the outcome did not materially change. Both arms rejected exact application of V-3. Both required 42.9% to be replaced by 49.2% because 64,922 / 131,968 = 49.1953%. The static check shows the scope reduction is real: 18,691 bytes against 58,214, unchanged bodies absent, 13/13 unchanged inputs listed by the same hashes, revised text byte-identical. P1 conditions 0, 1, 2, and 3 hold, the nine §7 conditions hold, and no §9 HALT condition is present. The conservative default REVERT is not triggered.

TERMINAL_STATE: KEEP
END C44 ADJUDICATION
