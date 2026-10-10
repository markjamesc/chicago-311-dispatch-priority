<!-- GROK TURN 1 of 2 (response-b77ebc2c-8581-4994-b242-f42a604e1931) -->

1. Role attestation

I am Adjudicator only for ablation C11 (catalog #11, Method Constants vs Knobs), Constitution 1.0. Role assignment in the frozen spec and FREEZE RECORD is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. I return exactly one terminal state. I do not rerun, repair, add criteria, relax a gate, or prefer one side’s mechanical result over the other’s. Builder and Validator packs are taken as the frozen first-pass reports in this packet. Both attest blindness to the other first pass and return no KEEP/REVERT/HALT token. FREEZE RECORD marks verdict_token_leak: false on both packs.

2. Freeze check

FREEZE RECORD (frozen_at_ct 2026-10-03 07:04:49 CDT, constitution 1.0) binds:

- Builder: C11/C11-builder/builder_report.md, 22237 bytes, SHA-256 fbe8a11821fd45c7986c9471e3750eca28d54261ee384ffd63b9cf05a46e637f
- Validator: C11/C11-validator/validator_report.md, 10863 bytes, SHA-256 0cbddb9ce4da579a0f343acbaedc8cea864734fbc349d658276649f5c24b7096
- Runner evidence file SHA-256 f10397c51fd7993f9151ae00f4177fd241d354eef42ec80614b12af1a97ab69d

The reports in this packet are those frozen verbatim packs. Each is complete. Builder ends with END C11 BUILDER REPORT. Validator ends with END C11 VALIDATOR REPORT. Neither report contains a terminal-state token. Baseline framework hashes in the FREEZE RECORD match the BASELINE FRAMEWORK HASHES block (70a14831… measurement-design; 24aec49c… validation-and-analysis). I do not recompute pack hashes; the freeze record is the binding identification, and no hash mismatch is asserted in either pack.

3. Hard-fact agreement table

Runner RESULTS (H1–H9, arm table, C11_arms.csv, raw fixture rows) is the mechanical reference. Builder and Validator recomputed the same facts. No row disagrees.

| Fact | Runner RESULTS | Builder | Validator | Mark |
| --- | --- | --- | --- | --- |
| Arm B exits | RA 0, RB 0 | 0/9 nonzero exits | exits recorded, B reproduced | agree |
| Arm B fixtures | 14/14, 14/14 | 28/28 | 14/14 both paths | agree |
| Arm B vs frozen pack | 0/0/0/0/0 both paths | same | same; B output hashes equal frozen preflight hashes | agree |
| B recon (frozen definition) | only-RA 0, only-RB 0, disagree 0 | 0/0/0 on 222002 | 0/0/0 | agree |
| B full-field recon | dormant_h 1, open_age_h 2 | 1+2=3, N1 | 1 and 2, N1 | agree |
| Seeded arms recorded | 4/4 | 7/7 seeded paths, all exit 0 | all four present | agree |
| H (locked-field harm) | {30_CM, 75_CM, 100_CM, 30_RB} | same, 4/4 | same | agree |
| Locked-field counts | 70, 28, 66, 35 | 35+35, 14+14, 33+33, 0+35 | same arithmetic | agree |
| Decision changes | equal to locked-field counts | same | same | agree |
| Key-set change vs B | 0 on every seed | 0 | 0 | agree |
| Seeded dormant/open_age vs B | 0 | 0 | not contradicted | agree |
| D_abl (caught without control) | {100_CM, 30_RB} | same | same | agree |
| H \ D_abl | {30_CM, 75_CM} | nonempty, cardinality 2 | nonempty | agree |
| Caught with control | all four | 4/4 via n_min ≠ 50 | same | agree |
| No locked-field change | {} | {} | {} | agree |
| 30_CM detection without control | FALSE; recon 0/0/0; fx 14/14 both | not caught | not caught | agree |
| 75_CM detection without control | FALSE; recon 0/0/0; fx 14/14 both | not caught | not caught | agree |
| 100_CM detection without control | TRUE; RB fx 13/14 (F14) | F14 fail | F14 expected STANDARD|STANDARD, observed INCONCLUSIVE|INCONCLUSIVE | agree |
| 30_RB detection without control | TRUE; recon_disagree 35 | 0/0/35 | recon_disagree 35 | agree |
| Seed diffs | N_MIN / RB_N_MIN only (30, 75, 100) | only those lines | only those lines | agree |
| Inputs differing from B | declared seed files only | same | same | agree |
| Source variants | none | none; source hashes fixed | none | agree |
| P1 | H ⊄ D_abl | not satisfied | not satisfied | agree |
| Validator blocking objections | — | — | None | agree |

N1 is treated the same way by coordinator note, RESULTS H2, Builder §5, and Validator §3.8: full-field 1/2 is pre-existing in the frozen pack; frozen recon 0/0/0 does not include dormant_h or open_age_h. Not a disagreement.

4. The nine KEEP conditions of constitution §7

Conditions 4–7 are applied to clean arm B, as instructed. Seeded effects are assessed through P1 (conditions 8–9).

1. Evidence packs complete and frozen — PASS. FREEZE RECORD binds both packs and the runner evidence hash. Reports complete with END lines. Raw evidence present: RESULTS, C11_arms.csv, fixture rows, manifests, seed diffs, run log, preflight. Citation: FREEZE RECORD; C11_EVIDENCE.sha256; ARM MANIFESTS; fixture table.
2. Role separation valid — PASS. Three distinct roles; Builder and Validator each attest a blind first pass; no terminal token in either pack; verdict_token_leak: false. Citation: SPEC Roles; FREEZE RECORD roles; both report §1.
3. Builder and Validator agree on hard mechanical facts — PASS. Section 3 has no disagree row. Citation: RESULTS H1–H9; Builder §3–§4; Validator §3–§5.
4. Exact reconciliation passes where required — PASS on arm B. Frozen-definition recon is 0/0/0; B vs frozen RA and RB is 0 key / 0 label / 0 dormant / 0 open_age. The disclosed N1 full-field 1/2 is outside that definition and is not a seeded effect. Citation: RESULTS H2 and Arm B recon table; coordinator note N1; Validator §3.2.
5. Every mandatory fixture passes — PASS on arm B: F01–F14 true on RA and RB (14/14, 14/14). The only fixture failure is seeded arm K_NMIN100_CM RB F14, which is a detection event under D_abl, not a clean-arm failure. Citation: fixture rows for arm B; RESULTS H1.
6. No undeclared semantic change on the clean arm — PASS. Arm B uses frozen code hashes and frozen source hashes; B classifications match frozen outputs (hash equality c099e092… RA, a0e42b86… RB). Seeded diffs are declared n_min substitutions only. Citation: PREFLIGHT frozen OK; ARM MANIFESTS B in/out; SEED DIFFS; Validator §3.1.
7. No locked regression on the clean arm — PASS. B reproduces the frozen pack; B fixtures 14/14 both paths; B recon 0/0/0. Citation: RESULTS H1–H2 and B repro table.
8. Predeclared benefit predicate satisfied — FAIL. Frozen P1: satisfied only if H ⊆ D_abl; failed if H \ D_abl is nonempty. H = {K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}. D_abl = {K_NMIN100_CM, K_NMIN30_RB}. H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}. Both of those arms change locked classification fields (70 and 28) with exit 0, recon 0/0/0, and fixtures 14/14 on both paths, so they pass undetected once n_min is treated as a silent knob. Owner threshold maps that failure to “Ambiguous tuning found without rule (keep rule).” Citation: SPEC Operational benefit predicate P1; RESULTS H4–H6 and seeded-arm rows; Builder §4; Validator §5.
9. No blocking objection remains supported by the frozen evidence — PASS. Validator §6: “None.” N1 is disclosed and excluded from the frozen recon HALT rule; it does not support a blocking objection. Citation: Validator §6; coordinator note N1.

Condition 8 fails. The nine conditions are conjunctive. KEEP is not available.

5. HALT conditions of §9

- Hard mechanical results conflict — absent. Section 3 is agree throughout. Citation: RESULTS H4–H6 vs Builder §3–§4 vs Validator §3.3–§3.4.
- Required raw evidence missing — absent. Runner results, raw arms CSV, fixture rows, manifests, seed diffs, run log, and preflight are present. Historical stdout bodies are not required to adjudicate; instruction forbids HALT solely for missing historical stdout. Citation: C11_arms.csv; fixture table; ARM MANIFESTS; run log.
- Hashes or frozen versions mismatch — absent. Preflight reports frozen OK on source, frozen code, and frozen classification outputs. Seed hashes in preflight match SPEC. Baseline hashes match FREEZE RECORD. Citation: PREFLIGHT; SPEC frozen hashes; FREEZE RECORD.
- Baseline or constitution changed mid-run — absent. Constitution 1.0 and the two baseline hashes are fixed in SPEC and FREEZE RECORD. Citation: SPEC; FREEZE RECORD.
- Role separation violated — absent. Distinct Builder, Validator, Adjudicator. Citation: SPEC Roles; FREEZE RECORD.
- Information barriers breached before first-pass freeze — absent. Both packs attest blindness; freeze record records no verdict-token leak. Citation: Builder §1; Validator §1; FREEZE RECORD verdict_token_leak: false.
- Benefit predicate not operationally defined before execution — absent. P1 is a set predicate (H ⊆ D_abl) frozen in the spec before the runner. Citation: SPEC “Operational benefit predicate P1”; “Frozen at CT: 2026-10-03, before the runner executed.”
- Adjudicator cannot determine which frozen evidence pack is authoritative — absent. One builder pack and one validator pack are bound in the FREEZE RECORD, and both are present and complete. Citation: FREEZE RECORD.

No §9 HALT condition is present. Spec regression/HALT rules are also unmet: B reproduces the frozen pack, B recon is 0/0/0 under the frozen definition, B fixtures are 14/14 both paths, all four seeded runs are recorded, and Builder and Validator do not disagree on a hard number.

6. Blocking objections raised by the Validator and how the evidence bears on them

Validator §6 raises none. The only candidate it addresses is N1. Evidence bears as follows. Arm B full-field recon is dormant_h 1 and open_age_h 2 on every arm, including B (RESULTS Arm B recon table; every seeded row). Coordinator note N1 and the spec identify the three frozen-pack rows (SR22-01936870 dormant_h; SR25-02017553 and SR25-02017556 open_age_h), labels agreeing, difference exactly 1.000 h, disclosed before execution as OF-1, pack not changed. Frozen HALT recon is key set plus classification disagreements only. Those are 0/0/0. Seeded locked-field harm is classification-only versus B (dormant and open_age deltas versus B are 0). N1 is not a harness defect, not a seeded effect, and not a supported blocking objection.

7. Verdict rationale

Removing the control materially changes detection on the frozen pack. With the control, a method constant in run code that differs from locked n_min = 50 is caught even if both paths agree. Without it, D_abl is only crash, recon key/label mismatch, or fixture failure.

All four seeds alter locked classification fields relative to arm B: K_NMIN30_CM 35+35=70, K_NMIN75_CM 14+14=28, K_NMIN100_CM 33+33=66, K_NMIN30_RB 0+35=35. No arm is neutral. Seed diffs change only N_MIN / RB_N_MIN. Source hashes are unchanged. κ, W, and T_freeze are not seeded.

Two harmful arms escape D_abl. K_NMIN30_CM and K_NMIN75_CM retune both paths the same way, exit 0, pass 14/14 on both paths, and reconcile at 0/0/0, while both differ from B. Cross-path agreement cannot see a shared unauthorized constant. The other two are caught only incidentally: K_NMIN100_CM by RB F14 (STANDARD|STANDARD vs INCONCLUSIVE|INCONCLUSIVE), K_NMIN30_RB by 35 classification disagreements against unmoved R-A. Fixture and recon coverage is therefore partial. The constants-vs-knobs rule is what catches the coordinated 30 and 75 retunes.

P1 fails because H \ D_abl is nonempty. Mechanics are coherent, HALT conditions are absent, and KEEP condition 8 is not established. Constitution §8 and the spec’s conservative default both require REVERT. Catalog #11 stays.

TERMINAL_STATE: REVERT
END C11 ADJUDICATION

<!-- USER MESSAGE BETWEEN TURNS: "continue" -->

<!-- GROK TURN 2 of 2 (response-f93390a2-413e-46aa-a30c-27eaf94e2280) -->

The C11 adjudication is already complete. The prior reply ended with the two required lines, so nothing further is open under the packet.

Catalog #11 (Method Constants vs Knobs) stays. P1 failed: H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}. Those two coordinated retunes changed locked classifications (70 and 28) and were not caught by crash, key/label recon, or fixtures. No HALT condition was present. KEEP condition 8 failed, so the conservative default applies.

TERMINAL_STATE: REVERT
END C11 ADJUDICATION
