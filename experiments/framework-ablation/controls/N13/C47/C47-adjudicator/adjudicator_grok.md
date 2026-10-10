1. Role attestation.

I am acting only as Adjudicator for ablation C47 (Addendum 02, candidate #47, “Small-denominator and single-unit dominance check on gating accuracy metrics”), expert mode as in A01–A08. Frozen role assignment: Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok (owner instruction 2026-10-03 04:26 CT; FREEZE RECORD roles). I did not build, validate, rerun, repair code, create criteria, or relax a gate. This reply returns exactly one terminal state under constitution v1.0 (e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9).

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 11:21:10 CDT) identifies the authoritative packs as C47/C47-builder/builder_report.md (17,718 bytes, SHA-256 c569dae0b8e6cfbf9b55bff4ae95036f2a926109468f5b9e907a2cac1f413098, verdict_token_leak: false) and C47/C47-validator/validator_report.md (10,593 bytes, SHA-256 2ee6ef7643ae1ab5c5ad75f44ecd53754a8311e999423e0748baca8f6c7e3968, verdict_token_leak: false). The reports supplied in this packet are those frozen reports, presented verbatim. Each is complete and ends with its END line: Builder ends END C47 BUILDER REPORT; Validator ends END C47 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Spec freeze hash for C47/ABLATION_SPEC.md is d1582be670cf3d4721b7f0f710a00b5bc090bed6a2d0a62cc507dce2c1901aa8, written 2026-10-03 10:28 CDT before the reporting run. Constitution hash in the freeze record, SPEC, and spec-freeze file is the same e6c3b348…fdae9. Baseline framework hashes match the frozen pair 70a14831…600c4c and 24aec49c…3cdb2e. No hash or frozen-version mismatch is disclosed against the FREEZE RECORD or the FROZEN REFERENCE HASHES.

3. Hard-fact agreement table.

Builder vs Validator vs runner C47_RESULTS.md / C47_arms.csv / raw per-arm files. Agree means all three sources state the same mechanical value (or the two packs recompute the same value the runner reports).

| Hard fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| Arm count | 5 | 5 | 5 (REAL_RB, REAL_RA, SEED_DOM60, CLEAN_BAL, SMALL_N) | agree |
| Arm exits | 5/5 exit 0 | 5/5 exit 0 | all exit 0 | agree |
| SEED_DOM60 n_escalate / top / share / status / flagged | 10,000; T01; 0.600000; FLAG; exactly T01 | 10,000; T01; 0.600000; FLAG; {T01} | 10000; T01; 0.600000; FLAG; T01 | agree |
| CLEAN_BAL n_escalate / top share / status / flagged | 10,000; 0.190000; NO_FLAG; 0 | 10,000; 0.190000; NO_FLAG; ∅ | 10000; 0.190000; NO_FLAG; empty | agree |
| SMALL_N n_escalate / status | 900; NOT_APPLICABLE_BELOW_MIN_TOTAL | 900; NOT_APPLICABLE_BELOW_MIN_TOTAL | 900; NOT_APPLICABLE_BELOW_MIN_TOTAL | agree |
| REAL_RA and REAL_RB n_escalate | 131,968 both | 131,968 both | 131968 both | agree |
| WCA2 n / share | 64,922; 0.4919525945683802 | 64,922; 0.4919525945683802 | 64922; 0.491953 (6 d.p. in summary; full share in DOM_TABLE) | agree |
| Real flagged set | exactly WCA2 | {WCA2} | WCA2 | agree |
| REAL_RA vs REAL_RB DOM_TABLE | 81/81 identical; SHA-256 b5a46c63…a182 | identical; same SHA-256, 3,330 bytes | same truncated hash b5a46c63d017be7e | agree |
| Real eligible types | 54 of 81 (≥30) | 54 of 81; only WCA2 over 1/3 | DOM_TABLE eligible/flag columns match | agree |
| Input before = after, all arms | 5/5 equal | 5/5 equal | input_unchanged TRUE all five | agree |
| Real inputs = frozen hashes | RA c099e092…0d9; RB a0e42b86…193 | same | INPUT_HASH files quote those full hashes | agree |
| Planted inputs = SEEDS_b5 hashes | BAL 89c3…3d54; DOM60 eba0…14df5; SMALL d846…44f61 | same | INPUT_HASH files quote those hashes | agree |
| dom_check.R hash | 582cb782…5145 on all arms | same | preflight and arm manifests | agree |
| stderr | 5/5 empty (e3b0c442…b855) | 5/5 empty | manifests, 0 bytes | agree |
| P1 conditions 1–5 | all supported | all supported | P1 MET | agree |
| N1/OF-1 effect on C47 counts | none (labels agree; C47 counts labels) | none | SPEC disclosure; not a C47 number change | agree |

No hard mechanical disagreement. Items both packs mark as not numerically available (portfolio-count deltas, D-set tables, n_agree + n_disagree = n_inner) are outside C47’s declared evidence and are not a disagreement.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are complete and frozen: FREEZE RECORD names both reports with hashes and verdict_token_leak: false; both end on their END lines; runner evidence (C47_RESULTS.md, C47_arms.csv, raw per-arm DOM_RESULT/DOM_TABLE/INPUT_HASH/RUN_DOM.exit, arm manifests, C47_EVIDENCE.sha256, preflight, run log) is in the packet. Constitution §7.1; FREEZE RECORD; both END lines.
6. PASS. Role separation is valid: one Builder (ChatGPT), one Validator (DeepSeek), one Adjudicator (Grok); both first passes attest blindness and return no terminal state; freeze record records no verdict-token leak. Constitution §1 and §7.2; SPEC Roles; FREEZE RECORD.
7. PASS. Builder and Validator agree on every predeclared hard mechanical fact in the table in §3, and both agree with the runner RESULTS. Constitution §4 and §7.3.
8. PASS. Exact reconciliation required here is the SPEC’s constitution §7 condition 4: the check writes nothing into the pipeline; locked results are the frozen classifications, hash-checked before and after. All five INPUT_HASH_before files equal the matching INPUT_HASH_after files; REAL_RA equals frozen c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9; REAL_RB equals frozen a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193. REAL_RA and REAL_RB DOM_TABLE.csv are byte-identical (b5a46c63d017be7e8a19162e3fafaac6bdde9082ebd828725bab539eda83a182). DOM_RESULT hashes differ only by input basename, which P1 condition 4 does not require to be identical. Constitution §7.4; SPEC regression rules; raw INPUT_HASH pairs.
9. PASS. Every mandatory known-answer case passes: SEED_DOM60 FLAG exactly T01; CLEAN_BAL NO_FLAG; SMALL_N NOT_APPLICABLE_BELOW_MIN_TOTAL. SPEC condition 5: no fixture is added to the locked pack; the planted tables are the known-answer cases declared in the SPEC. Constitution §7.5; SPEC Arms and P1.1–1.3; raw DOM_RESULT/DOM_TABLE.
10. PASS. No undeclared semantic change. The change set is additive and runner-side (dom_check.R, ARMS.tsv, DOMCHK, three planted tables). The script reads classifications, writes only DOM_TABLE.csv and DOM_RESULT.csv, and a FLAG routes to the Stage 4 report and the owner without dropping or rewriting a row (routing text on FLAG arms; “none” on non-FLAG arms). Constitution §5 and §7.6; SEED DIFFS dom_check.R; DOM_RESULT routing fields.
11. PASS. No locked regression. Every arm input hash is unchanged across the check and the real inputs equal the frozen classification hashes. Preflight gated the frozen pack and runner-side files before the arms ran (preflight PASS). OF-1 is disclosed, label-identical on the three rows, and cannot change a C47 count. Constitution §7.7; INPUT_HASH files; SPEC N1/OF-1; coordinator note.
12. PASS. The predeclared benefit predicate P1 is satisfied on all five conjuncts: (1) SEED_DOM60 FLAG exactly T01; (2) CLEAN_BAL NO_FLAG; (3) SMALL_N NOT_APPLICABLE_BELOW_MIN_TOTAL; (4) REAL_RB and REAL_RA both FLAG exactly WCA2 with identical DOM_TABLE.csv; (5) every input hash unchanged and real inputs equal frozen hashes. Runner states P1 MET; both packs recompute the same. Constitution §6 and §7.8; SPEC Operational benefit predicate P1; C47_RESULTS predicate table.
13. PASS. No blocking objection remains supported by the frozen evidence. Validator §6: “None supported by this packet.” Builder’s residual note (exact boundaries 1,000 / 30 / 1/3 not seeded; blank type_key not seeded; scratch preflight disclosed) is not a failed P1 conjunct and is not evidence against adoption. SPEC: items marked “not measured” are not evidence either way. Constitution §7.9; Validator §6; Builder §6.

All nine are conjunctive and all nine pass.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3 is agree on every row. Constitution §4 and §9; both hard-fact sections; C47_RESULTS.
- Required raw evidence missing: absent. Runner results, raw per-arm files, manifests, logs, and frozen reference hashes are in the packet. Full historical stdout text is not pasted; stderr is the empty-file hash and exit files are present. The adjudication instruction says not to HALT only because historical stdout is missing. Constitution §3 and §9; RAW PER-ARM FILES; ARM MANIFESTS.
- Hashes or frozen versions mismatch: absent. Preflight frozen OK and seed OK lines match SPEC FROZEN REFERENCE HASHES, including RA c099e092…0d9, RB a0e42b86…193, dom_check.R 582cb782…5145, and the three planted-table hashes. Constitution §9; PREFLIGHT; FROZEN REFERENCE HASHES.
- Baseline or constitution changed mid-run: absent. Constitution hash and baseline framework hashes are stable across SPEC, spec freeze, and FREEZE RECORD. Constitution §9 and §11.
- Role separation violated: absent. Three distinct roles; freeze record matches SPEC. Constitution §1 and §9.
- Information barriers breached before first-pass freeze: absent. Both reports attest blindness; freeze record verdict_token_leak: false on both packs. Constitution §1 and §9; FREEZE RECORD.
- Benefit predicate not operationally defined before execution: absent. P1 is in the frozen SPEC; eval_b5.R is in SEEDS_b5.sha256 (49742ad3…3966); spec freeze written 10:28 CDT before the 10:32 reporting run; scratch outcome disclosed and no arm, threshold, seed, or predicate changed after it. Constitution §6 and §9; SPEC Pre-execution check.
- Adjudicator cannot determine which frozen evidence pack is authoritative: absent. FREEZE RECORD names one Builder pack and one Validator pack. Constitution §9; FREEZE RECORD.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raises no blocking objection. The only items it flags as not recomputable from this packet are full SHA-256 preimages of bulky files, row-level real labels beyond the ESCALATE type counts, make_seeds_b5.py source, eval_b5.R source text, full stdout bodies, and portfolio deltas. None of those is a declared C47 hard fact. The packet already supplies the hashes the KEEP conditions rely on, the verbatim DOM tables, the input-hash before/after pairs, and the N1 disclosure that the three clock rows share a label. Builder’s boundary-coverage note (exactly 1,000 total, exactly 30 per type, share exactly 1/3, blank type_key) describes unseeded edges, not a contradiction of the executed predicate: the frozen code uses >= 1000, >= 30, and strictly > 1/3, and the executed arms land on the sides the SPEC required (10,000 and 900; 0.60 and 0.19; WCA2 at 0.49195). The disclosed scratch run is provenance, not a post-freeze change. OF-1 remains an open finding on clocks; it is not a C47 defect.

7. Verdict rationale.

The change under test is the Stage 4 dominance check of owner ruling 47A: if ESCALATE total is at least 1,000, flag an eligible type (n >= 30) whose share exceeds 1/3, write the flag to the Stage 4 report, and route it to the owner; drop nothing.

On the frozen pack it does change the Stage 4 outcome. Baseline flags nothing by construction. The check, on both frozen classification files, flags WCA2 only: 64,922 of 131,968 ESCALATE rows, share 0.4919525945683802, with identical DOM tables. That is the concentration ruling 47A treated as a true flag, previously visible only later (PricePoint analogue FOODS_3_092 at Stage 5). The planted arms show the same rule detects a 60% unit (T01), does not flag a 19% maximum, and does not apply at 900 ESCALATE rows. Locked classifications are hash-identical before and after. P1 is met. Mechanics are coherent. No HALT condition is present. All nine KEEP conditions hold, so the conservative REVERT default does not apply.

TERMINAL_STATE: KEEP
END C47 ADJUDICATION
