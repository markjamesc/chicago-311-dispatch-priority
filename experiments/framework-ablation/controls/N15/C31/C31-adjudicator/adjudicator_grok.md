<!-- GROK TURN 1 of 3 (response-f8e26dd6-2ab8-4c84-be7e-1a9ffeba095f) -->

1. Role attestation.

I am acting only as Adjudicator for ablation C31 (Remaining Ablation Program catalog #31, “Lineage Attestation,” N15 batch 1 of 3, Stage 4 provenance). Constitution version 1.0. Frozen role assignment: Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. This pass uses only the frozen packet. No rerun, no repair, no new criterion, no gate relaxation, and no selection of one side’s mechanical result over the other’s. No terminal state is taken from either first-pass report.

2. Freeze check.

FREEZE RECORD (frozen_at_ct 2026-10-03 05:33:48 CDT) names the authoritative packs and records verdict_token_leak: false for both:

- Builder: C31/C31-builder/builder_report.md, 18024 bytes, SHA-256 264e23d49a0fb88298de9821e3ccce9c1d1870318507313637aa30c887bebbb0.
- Validator: C31/C31-validator/validator_report.md, 12578 bytes, SHA-256 3e7f8c71ac426077e130ef13c2cec93376fd08d366722c48c30c78fd368a0dae.
- Runner evidence file hash 6b6ccb511abfcb0c5148b9d8e4d426c751499f32c77fcbc115d565c83cf97337. Packet evidence hashes: C31_RESULTS.md d2ba0b1dbff37f963c29f9f8cfbef35450b95590f78e97989d77e97c64c00e5d; C31_arms.csv 3e32165c5d367b925f1a90cb3f0b179435ba457ca92fa1f9ecd633302c02d30f; C31_ARM_MANIFESTS.txt d0b21c9c07eb49034afe1a9f2c4168b650dbda1c2bfd92bf02f73a4c9b61d46f.

The reports supplied in this message are the frozen verbatim packs identified by that record. Each is complete and ends with its required END line: Builder ends END C31 BUILDER REPORT; Validator ends END C31 VALIDATOR REPORT. Baseline framework hashes in the packet match the FREEZE RECORD and the SPEC (70a14831…600c4c, 24aec49c…3cdb2e). Constitution version is 1.0 throughout. No mid-run constitution or baseline substitution is recorded.

3. Hard-fact agreement table.

Hard facts are the predeclared RESULTS quantities and the locked-field arithmetic both sides recomputed from the seeded-arm rows. “Agree” means Builder, Validator, and runner RESULTS state the same value.

| Fact | Builder | Validator | Runner RESULTS | Mark |
| --- | --- | --- | --- | --- |
| B exits | RA 0, RB 0 | RA 0, RB 0 | H1: both 0 | agree |
| B fixtures | 14/14, 14/14 | 14/14, 14/14 | H1: 14/14, 14/14 | agree |
| B vs frozen pack | 0/0/0/0/0 on both paths | 0/0/0/0/0 on both paths | repro table all zeros; H2 TRUE | agree |
| B key/label recon | only_ra 0, only_rb 0, disagree 0; n = 222002 | same | recon row 0/0/0; H2 “0/0/0: TRUE” | agree |
| B full-field recon | dormant_h 1, open_age_h 2 | dormant_h 1, open_age_h 2 | H2 and recon row: 1 and 2 | agree |
| Seeded arms recorded | 5/5, all exits 0 | 5/5, all exits 0 | H3: 5/5; seeded table exits 0 | agree |
| L_STALE24 locked / decision | 1546 / 1546 (773+773) | 1546 / 1546 | 1546 / 1546; harm TRUE | agree |
| L_PEER10 locked / decision | 538 / 538 (269+269) | 538 / 538 | 538 / 538; harm TRUE | agree |
| L_TF24 locked / decision | 889154 / 1146 | 889154 / 1146 | 889154 / 1146; harm TRUE | agree |
| L_K25 locked / decision | 13786 / 13786 (6893+6893) | 13786 / 13786 | 13786 / 13786; harm TRUE | agree |
| L_COMMENT locked / decision | 0 / 0 | 0 / 0 | 0 / 0; harm FALSE | agree |
| H | {L_STALE24, L_PEER10, L_TF24, L_K25} | same | H4 same | agree |
| D_abl (caught without control) | {} | {} | H5: {} | agree |
| H \ D_abl | the four harmful arms | the four harmful arms | H6 same | agree |
| No locked-field change | {L_COMMENT} | {L_COMMENT} | H7: {L_COMMENT} | agree |
| Caught with control | all five seeds | all five seeds | H8 same | agree |
| Caught with control, no locked change | {L_COMMENT} | {L_COMMENT} | H9: {L_COMMENT} | agree |
| Seeded key/label recon | 0/0/0 on all five | 0/0/0 on all five | recon_only_ra/rb/disagree all 0 | agree |
| Seeded fixtures | 14/14 both paths, all arms | 14/14, all pass TRUE | fx_RA/fx_RB 14/14 | agree |
| P1 | H ⊆ D_abl false; H \ D_abl non-empty | same | H4–H6 imply the same | agree |

No hard number in the RESULTS file is in dispute. Both sides also agree on which input hashes differ from arm B (L_STALE24 open-candidates only; L_PEER10 peer-stats only; L_TF24, L_K25, and L_COMMENT the two seeded code files) and that L_COMMENT classification outputs match arm B.

4. The nine KEEP conditions of constitution §7.

Conditions 4–7 are applied to clean arm B. Seeded-arm effects are applied through conditions 8–9.

1. Evidence packs complete and frozen: PASS. Both packs are named in the FREEZE RECORD, both end with their END lines, and runner RESULTS, arm rows, manifests, and evidence hashes are in the packet (FREEZE RECORD; both END lines; C31_EVIDENCE.sha256).
2. Role separation valid: PASS. Builder attests Builder-only and blind; Validator attests Validator-only and blind; freeze record assigns three distinct models and records no verdict-token leak (Builder §1; Validator §1; FREEZE RECORD roles).
3. Builder and Validator agree on hard mechanical facts: PASS. Section 3 table; neither report substitutes a different RESULTS number (Builder §3–§4; Validator §3–§5; C31_RESULTS.md H1–H9 and seeded table).
4. Exact reconciliation passes where required: PASS for clean arm B. Required recon is key set plus classification. H2 states B recon is 0/0/0 TRUE, and the recon row is only_ra 0, only_rb 0, disagree 0, on 222002 inner keys. B versus each frozen classification file is 0 on key, label, dormant_h, and open_age_h (H2; Arm B repro table; Arm B recon table). The separate full-field RA↔RB counts (dormant_h 1, open_age_h 2) are the coordinator N1 baseline signature, present on B and on every seed, and are not a B-versus-frozen failure.
5. Every mandatory fixture passes: PASS on clean arm B. H1 and the seeded table: R-A 14/14, R-B 14/14. Validator confirms every F01–F14 row has pass TRUE (Validator §3 fixture results).
6. No undeclared semantic change on the clean arm: PASS. Arm B is frozen R-A, frozen R-B, and frozen source; preflight hashes match the SPEC; B reproduces the frozen pack at 0 differences (SPEC frozen code/data hashes; PREFLIGHT frozen OK; H2).
7. No locked regression on the clean arm: PASS. Same B-versus-frozen zeros, exits 0, fixtures 14/14 (H1, H2, repro table).
8. Predeclared benefit predicate satisfied: FAIL. SPEC P1 is satisfied only if H ⊆ D_abl. H = {L_STALE24, L_PEER10, L_TF24, L_K25}; D_abl = {}; H \ D_abl is those four arms. Each exits 0, passes 14/14 on both paths, and has key/label recon 0/0/0, while changing locked fields (1546, 538, 889154, 13786). L_COMMENT is excluded from P1 and does not repair the failure (SPEC P1; H4–H7; both reports §4/§5).
9. No blocking objection remains supported by the frozen evidence: PASS as a bar on adjudication. The Validator’s five objections are addressed in §6. None is a Builder/Validator conflict on a RESULTS hard number, none falsifies H or D_abl, and none is a §9 HALT condition. They do not restore P1.

All nine are conjunctive. Condition 8 fails, so KEEP is unavailable.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. Section 3; both reports recompute the same H, D_abl, locked counts, exits, and fixture passes (Builder §3; Validator §3; RESULTS H1–H9).
- Required raw evidence missing: absent. Runner RESULTS, arm table, fixture pass rows, manifests, preflight, and evidence hashes are present. The instruction forbids HALT solely for missing historical stdout. Validator §4 lists items that cannot be re-hashed from this packet; those gaps do not remove the raw facts used for P1.
- Hash or frozen-version mismatch against the FREEZE RECORD: absent. Baseline hashes match. Preflight source and code hashes match the SPEC. Both reports confirm seed hashes match. Packs are the freeze-record files (PREFLIGHT; FREEZE RECORD; Validator §3).
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the two baseline hashes are stable from SPEC through FREEZE RECORD.
- Role separation violated: absent. Three distinct roles; no verdict token in either pack (FREEZE RECORD verdict_token_leak: false).
- Information barrier breached before first-pass freeze: absent. Each report attests blindness; Validator §4 states Builder output was not in its packet.
- Benefit predicate not defined before execution: absent. P1, H, D_abl, and the locked-field rule are in the SPEC, frozen before the runner (SPEC Operational benefit predicate P1; frozen-at line).
- Adjudicator cannot tell which pack is authoritative: absent. FREEZE RECORD names one builder pack and one validator pack, with hashes.

Spec regression HALT is also absent: B reproduces the frozen pack, H2 states B recon is 0/0/0 TRUE, B fixtures are 14/14, and all five seeded runs have an exit recorded. A seeded crash would be caught, not a HALT; none crashed.

6. Blocking objections raised by the Validator and how the evidence bears on them.

- Source-variant note on V_STALE24/src_peer_stats.csv saying 848 rows dropped. Not supported as a seed-identity defect. SPEC and both reports give that file the frozen hash cb78ae21… and 16276 bytes, equal to arm B. Preflight count is 104. The 848-row drop is the open-candidates note (created_ts >= 2026-09-11 23:59:59; 245193 − 848). The note is mis-attached in the variant summary line. It does not change L_STALE24’s input difference, which is src_open_candidates.csv 8268fb54…, or the 1546 locked-field changes.
- F14 expected string differs by path (TWO_INDEPENDENT_LABELS on R-A, STANDARD|STANDARD on R-B) in every arm. Not a fixture failure. Each path’s expected equals its observed, and every F01–F14 row is pass TRUE. The SPEC requires F01–F14 on every path, not one shared expected string. This does not put any harmful arm into D_abl.
- L_K25 RB_fixture_results.csv hash/size differs from B (f777621e… 1820 vs 0d72245c… 1792) while the supplied 14 fixture rows match and pass. Both reports record the same nuance. The hard fixture fact used by D_abl is pass/fail, which is 14/14. Unexplained extra bytes are not a Builder/Validator numeric conflict and do not catch L_K25 without attestation.
- H2 says “B recon is 0/0/0” and also “dormant_h 1, open_age_h 2.” Wording is compressed, not contradictory. SPEC exact recon for the ablated detector is key set plus classification. The recon row is 0/0/0 on those three fields. The 1 and 2 are the full-field counts, identical on B and every seed. Coordinator N1 identifies them as a latent frozen-pack clock difference of 1.000 h on three ESCALATE rows, labels agreeing. B versus each frozen classification file is 0 on dormant_h and open_age_h, so this is not a clean-arm reproduction failure.
- Packet does not include a separate frozen RA↔RB recon file. The implication the Validator draws is the one N1 states: the 1 and 2 already sit in the frozen pair. B reproduces each frozen file at 0. This does not reopen H or D_abl.

None of these objections is a §9 HALT condition. None contradicts the agreed RESULTS arithmetic.

7. Verdict rationale.

Removing Lineage Attestation materially changes detection on the frozen pack, and the change is a loss. With the control, a differing input SHA-256 is caught: H8 is all five seeds. Without it, detection is exit 0, fixtures, and RA↔RB key/label recon. Those three stay green on every seed, so D_abl is empty.

The harm set is not empty. L_STALE24 drops 773 keys on each path (1546 locked changes) and is not caught. L_PEER10 moves 269 labels on each path (538) and is not caught. L_TF24 moves T_freeze +24 h, changes 573 labels per path plus dormant_h and open_age_h on all 222002 keys per path (889154 locked, 1146 decision) and is not caught. L_K25 moves kappa 2.0 to 2.5 and changes 6893 labels per path (13786) and is not caught. These are common-mode provenance changes: both paths agree with each other and still disagree with arm B. Inter-path agreement does not establish frozen identity.

L_COMMENT shows the other edge: attestation alarms on a +54-byte comment with zero locked-field change. That arm is outside P1. It does not offset the four misses.

Clean arm B is internally coherent: exits 0, fixtures 14/14, key/label recon 0/0/0, frozen-pack reproduction 0 on the locked fields. The N1 1.000 h full-field mismatches are baseline, not an ablation effect. Predicate P1 fails. No HALT condition holds. Constitution §8 and the packet default therefore require REVERT. Catalog #31 stays in the canonical framework.

TERMINAL_STATE: REVERT
END C31 ADJUDICATION

<!-- USER MESSAGE BETWEEN TURNS: "continue" -->

<!-- GROK TURN 2 of 3 (response-2d709ad0-39bc-484f-8fb4-02c677293b45) -->

C31 is already closed. The prior reply contained the full adjudication and ended on the two required lines. No further section, rerun, or second terminal state is open.

The mechanical record stands: Builder and Validator agree on the RESULTS hard facts; H = {L_STALE24, L_PEER10, L_TF24, L_K25}; D_abl = {}; P1 fails because H \ D_abl is non-empty; no §9 HALT condition is present. Lineage Attestation stays.

TERMINAL_STATE: REVERT
END C31 ADJUDICATION

<!-- USER MESSAGE BETWEEN TURNS: "continue" -->

<!-- GROK TURN 3 of 3 (response-68da9d64-d089-40b0-9c99-ed53469791ab) -->

Nothing further is open on C31. The adjudication is terminal and is not being reopened.

TERMINAL_STATE: REVERT
END C31 ADJUDICATION
