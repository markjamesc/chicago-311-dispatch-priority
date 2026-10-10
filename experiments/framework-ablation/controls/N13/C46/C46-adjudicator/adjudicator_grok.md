1. Role attestation.

I am acting only as Adjudicator for C46 (Addendum 02, candidate #46, “Design-time numerical determinism”), N13 batch 4. Role assignment in the FREEZE RECORD and SPEC is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I did not rerun fits, repair code, create a criterion, relax a gate, or substitute one side’s mechanical result for the other’s. Terminal disposition is issued only in the final two lines.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 10:07:27 CDT) names the packs that are the authoritative reports in this message:

- Builder: C46/C46-builder/builder_report.md, 24696 bytes, SHA-256 f895f19e860af304a11674a14120732777983ba840551a9a61253fa3a488ddd6, verdict_token_leak: false.
- Validator: C46/C46-validator/validator_report.md, 12131 bytes, SHA-256 ab927b3db06618cdde97e97e01ea3ef3a53388d1f50413a61854f7444199cd9b, verdict_token_leak: false.

Both reports in this packet are those role outputs. Each is complete and ends with its END line (END C46 BUILDER REPORT; END C46 VALIDATOR REPORT). Neither emits KEEP, REVERT, or HALT. Constitution version in the record is 1.0, matching the packet constitution SHA-256 e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9. Baseline framework hashes in the record match the BASELINE FRAMEWORK HASHES block. Spec freeze line for this control is 6920322b91d2fee391706a98ca7d0dc99f475dc137ad536ce9e5e47fee62e139 C46/ABLATION_SPEC.md (SPEC_FREEZE_b4, written 2026-10-03 08:48 CDT before execution). Runner evidence file hash in the record is e0ace4859e7c7e67bdc61e3f021d0d270d52bef3fa9e317647c2bf9f95f74190. Preflight gating result is PASS; listed frozen-pack and seed hashes match the FROZEN REFERENCE HASHES and the PREFLIGHT lines.

3. Hard-fact agreement table.

Builder and Validator both recompute from C46_RESULTS.md, C46_arms.csv, raw RECON.csv / fit_info.csv, exit files, and arm manifests. They agree with each other and with the runner RESULTS on every predeclared hard number below.

| Fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| n (all arms) | 215687 | 215687 | 215687 | agree |
| Clean p_cols / defect RB p_cols | 32 / 31 | 32 / 31 | 32 / 31 | agree |
| All fit jerr | 0 | 0 | 0 | agree |
| BASE recon / events / extra_rebuilds | FAIL / 2 / 2 | FAIL / 2 / 2 | FAIL / 2 / 2 | agree |
| BASE max_abs_dp / fail_p / fail_p_pct1 / fail_flag | 0.008446989841342178 / 0 / 17564 / 11 | same | same | agree |
| DECL recon / events / extra_rebuilds | PASS / 0 / 0 | PASS / 0 / 0 | PASS / 0 / 0 | agree |
| DECL max_abs_dp and all fail counts | 0 / 0 / 0 / 0 | same | same | agree |
| THRESH_ONLY events / max_abs_dp / fail_p_pct1 / fail_flag | 1 / 9.44668978275498e-6 / 30 / 0 | same | same | agree |
| ORDER_ONLY events / max_abs_dp / fails | 0 / 0 / all 0 | same | same | agree |
| DEFECT_DECL recon / events / max_abs_dp / fails | FAIL / 3 / 0.766791177978111 / 193060, 111789, 2070 | same | same | agree |
| DEFECT_BASE recon / events / max_abs_dp / fails | FAIL / 3 / 0.7656221672416856 / 12890, 111885, 2082 | same | same | agree |
| events = extra_rebuilds, all six paired arms | yes | yes | yes (arms table) | agree |
| DECL vs REF max|dp| / flag differences | 5.33069e-05 / 0 | 5.33069e-05 / 0 | 5.33069e-05 / 0 | agree |
| P1 clauses met | 1, 2, 3, 5 met; 4 not met | same | P1 NOT MET; condition 4 NOT MET | agree |
| Preflight / seed hashes | match, gating PASS | match, gating PASS | preflight PASS | agree |
| DECL RA pred.csv = DECL RB pred.csv | fd47d91e…f43e50 | same | manifest | agree |
| ORDER_ONLY RA pred.csv = ORDER_ONLY RB pred.csv | ff4b93fe…3e281f | same | manifest | agree |

No hard mechanical disagreement. Items the SPEC marks not measured (design minutes, PricePoint-scale costs) are not treated as evidence either way. N1/OF-1 is disclosed and is not a C46 number: C46 reads frozen R-B classifications as labels and features and does not rerun R-A or R-B.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are present and named in the FREEZE RECORD; both reports end with their END lines; verdict_token_leak is false; preflight gating PASS; runner RESULTS, raw per-arm RECON/fit_info/exit files, manifests, and frozen reference hashes are in the packet. Citation: FREEZE RECORD; PREFLIGHT “preflight gating result: PASS”; C46_RESULTS.md; ARM MANIFESTS.
6. PASS. Three distinct roles; Builder and Validator each attest blindness and issue no terminal state. Citation: FREEZE RECORD roles; Builder §1; Validator §1; both verdict_token_leak: false.
7. PASS. Builder and Validator agree on the hard mechanical facts in section 3, including the failing REF comparison. Citation: Builder §3 and §4; Validator §3 and §5; C46_arms.csv and raw RECON.csv rows.
8. PASS. SPEC maps this condition to the declared-regime comparator on arm DECL. DECL RECON.csv: regime=declared, p_tol=1e-6, max_abs_dp=0, fail_p=0, fail_p_pct1=0, fail_flag=0, events=0, recon=PASS. Citation: SPEC “Regression / HALT rules”; arms/DECL/RECON.csv; C46_RESULTS.md DECL row.
9. PASS. SPEC declares, before execution, that the seeded fit has no fixture harness, so no mandatory fixture applies. Frozen Chicago 311 fixture files are hash-gated only; C46 does not rerun them. Citation: SPEC condition-5 sentence; PREFLIGHT fixture-result hash lines.
10. PASS. No undeclared semantic change on the frozen pack. Seed diffs are new runner-side files only (fit_path.R, recon_c46.R, ARMS.tsv, DETFIT). Frozen pack is read-only; same seed bytes in every arm root. Citation: SEED DIFFS; PREFLIGHT frozen OK lines; ARM MANIFESTS input hashes d681aff9… and 9cd9fe12….
11. PASS. No locked regression on the frozen pack: pack hashes re-verified, C46 does not rewrite R-A/R-B outputs, all 13 fits jerr=0, all logged exits 0, DEFECT_DECL still FAILs (events=3), so the declared tolerance does not hide the seeded omission of x_log_peer_p75. Citation: PREFLIGHT; RUN LOG; DEFECT_DECL RECON.csv; SPEC conditions 6–7.
12. FAIL. The predeclared benefit predicate P1 is conjunctive. Runner: “Mechanical predicate result: P1 NOT MET.” Clauses 1, 2, 3, and 5 are met (BASE events=2; DECL events=0; DEFECT_DECL recon=FAIL; extra rebuilds BASE=2, DECL=0). Clause 4 is not met: DECL R-A vs REF max|dp| = 5.33069e-05, which is greater than 1e-6, with flag differences = 0. Both sides report the same failure. The unmeasured design-minute cost is not converted into a pass. Citation: SPEC P1 items 1–5; C46_RESULTS.md predicate table and “DECL vs REF”; Builder §4; Validator §5.
13. PASS. Validator’s blocking-objection section states that no blocking objection is supported by the frozen aggregate evidence. The listed caveats (no row-level pred.csv, interim evaluation disclosure, OF-1, OF-2) are disclosed limitations, not supported blocks. Citation: Validator §6; SPEC OF-1 and OF-2 sentences; coordinator note on N1.

All nine are conjunctive. Condition 8 fails, so KEEP is not available.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3 is agree on every hard number, including the P1 failure. Citation: Builder §3–§4; Validator §3 and §5; C46_RESULTS.md.
- Required raw evidence missing: absent. Runner RESULTS, raw RECON.csv, fit_info.csv, exit files, manifests, logs, and frozen reference hashes are in the packet. Instruction for this adjudication: do not HALT only because historical stdout is missing. Row-level pred.csv bodies are hashed, not pasted; both sides treat that as a recomputation limit, not a conflicting fact, and both accept the evaluator’s DECL-vs-REF aggregate. Citation: packet raw per-arm files and ARM MANIFESTS; Validator §4 and §6; coordinator evidence note.
- Hashes or frozen versions mismatch: absent. Preflight gating PASS; seed and frozen-pack hashes match SPEC and FROZEN REFERENCE HASHES; constitution and baseline hashes match the FREEZE RECORD. Citation: PREFLIGHT; SPEC_FREEZE_b4; FREEZE RECORD.
- Baseline or constitution changed mid-run: absent. Spec freeze is timestamped before execution (08:48 CDT); runs are 09:29–09:34; freeze of packs is 10:07. Citation: SPEC_FREEZE_b4; RUN LOG; FREEZE RECORD.
- Role separation violated: absent. Three roles; no verdict-token leak. Citation: FREEZE RECORD.
- Information barrier breached before first-pass freeze: absent. Each report attests blindness; freeze record records both packs with verdict_token_leak: false. Citation: Builder §1; Validator §1; FREEZE RECORD.
- Benefit predicate not operationally defined before execution: absent. P1’s five mechanical clauses are in the frozen SPEC, with the design-minute metric expressly not measured. Citation: SPEC “Operational benefit predicate P1.”
- Adjudicator cannot tell which pack is authoritative: absent. FREEZE RECORD names both packs by path, bytes, and SHA-256, and those reports are the ones in this message. Citation: FREEZE RECORD.

No §9 HALT condition is present. SPEC’s local HALT triggers (jerr ≠ 0, missing fit/RECON, Builder/Validator disagreement on a hard RESULTS number) are also absent: all jerr=0, all RECON files present, hard numbers agree.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no blocking objection supported by the frozen aggregate evidence. The caveats and how the evidence bears on them:

- Row-level pred.csv is not in the packet, so max|dp| and failing-row identities cannot be recomputed from rows. Arm manifests hash the prediction files; DECL RA and DECL RB share fd47d91eb05003d3c2ccc04df5eda018658a8ffabb760d7bde6f7e7edef43e50 (byte-identical paired paths); ORDER_ONLY RA and RB share ff4b93fe0223b319b3f9b920b3f74d973b8d03ba2b0668f1067c92c40a3e281f. The failing P1 clause is the evaluator aggregate DECL vs REF max|dp| = 5.33069e-05, which both sides quote and which neither disputes. That is a failed gate, not a conflict.
- C46_RESULTS.md is an interim evaluation of a byte-copy of finished C46 arms (09:41 CDT) because batch-end evaluation waits on C52. The packet discloses that any non-timestamp difference will be reported. Both sides use the same interim tables. That disclosure is not a numerical disagreement.
- OF-2: design-time Stage 3 minutes are not measured. SPEC says the cost side is operationalised only as rebuild counts. Those counts favor DECL (2 vs 0) but do not repair clause 4.
- OF-1 / N1: three frozen-pack ESCALATE rows differ by 1.000 h between clean R-A and R-B; labels agree; coordinator decision is record and disclose, do not change the pack. C46 does not rerun R-A or R-B, so N1 is not a C46 number and is not a seeded effect.

None of these is a supported blocking objection that would force HALT, and none reverses the agreed failure of P1 clause 4.

7. Verdict rationale.

The change under test is the adoption of four design-time numerical determinism declarations: solver tolerance, canonical column order, exact tie rule p ≥ 0.5, and the rounding-derived reconciliation rule.

On the frozen seeded pack it did change the paired-path outcome. Under the baseline regime, natural vs reversed order at thresh 1e-7 produces two reconciliation events (fail_p_pct1=17564, fail_flag=11, fail_p=0, max_abs_dp=0.008446989841342178). Under the declared regime, canonical/canonical at thresh 1e-12 produces byte-identical predictions, zero events, and zero extra rebuilds. ORDER_ONLY shows that canonical order alone clears the baseline comparator on this seed; THRESH_ONLY shows that the tighter threshold alone does not (30 rounded-field failures, 1 event). DEFECT_DECL still fails all three comparator fields after dropping x_log_peer_p75, so the declared tolerance does not hide that defect.

That paired-path change is not the whole predicate. P1 clause 4 requires DECL R-A vs the tighter REF (canonical, thresh 1e-14) to satisfy max|Δp| ≤ 1e-6 and identical flags. Flags match (0 differences). The probability gap does not: max|dp| = 5.33069e-05, about 53 times the declared 1e-6 limit. DECL’s two paths agree with each other and still miss the frozen proximity requirement against REF. The runner, the Builder, and the Validator all record P1 as not met for that reason.

Constitution §8: mechanics are coherent, HALT conditions are absent, and at least one KEEP condition is not established (§7.8). The instruction for this control is the same rule: if P1 fails and no HALT condition holds, return REVERT. The four declarations are not adopted.

TERMINAL_STATE: REVERT
END C46 ADJUDICATION
