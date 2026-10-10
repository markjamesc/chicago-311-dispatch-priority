1. Role attestation.

I am acting only as Adjudicator for C26 (Frozen Source Package, catalog #26, N15 batch 1 of 3). Builder is ChatGPT; Validator is DeepSeek; Adjudicator is Grok. I have not rerun any arm, repaired code, created a criterion, or relaxed a gate. This decision is made only on the re-adjudication packet. Terminal state is reserved for the last two lines.

2. Freeze check.

The FREEZE RECORD (frozen_at_ct 2026-10-03 05:33:46 CDT, constitution 1.0) identifies the Builder pack as C26/C26-builder/builder_report.md, 18500 bytes, SHA-256 9cc758256e5654760b318da4242c88b703c898a6892207644f3d84b679c128ce, verdict_token_leak: false, and the Validator pack as C26/C26-validator/validator_report.md, 7706 bytes, SHA-256 1703313644f81699ff65a0c8d84017708ed2a334159033fcd838515295acdcae, verdict_token_leak: false. The re-adjudication note states that those two reports are byte-identical to the first adjudication and that only the coordinator-side evidence block was completed (PD-1). Both reports are present in full. The Builder report ends with END C26 BUILDER REPORT. The Validator report ends with END C26 VALIDATOR REPORT. Neither report contains a KEEP, REVERT, or HALT token. Baseline framework hashes in the FREEZE RECORD match the SPEC and the BASELINE FRAMEWORK HASHES block (70a14831… and 24aec49c…). Preflight reports frozen OK for both source files and the frozen code hashes named in the SPEC. I do not recompute the pack SHA-256 values; the packet identifies these texts as the frozen files, and no contrary hash is in the record.

3. Hard-fact agreement table.

Compared against C26_RESULTS.md, C26_arms.csv, the fixture rows, the run log, and the arm manifests.

| Fact | Builder | Validator | Runner RESULTS / raw | Mark |
| --- | --- | --- | --- | --- |
| Seeded arms recorded | 6/6 | 6/6 | H3 6/6; run log has B plus six RB exits | agree |
| All recorded exits | B RA 0, B RB 0; seeded RB 0 | B 0/0; seeded rows exit 0 | H1; run log exit=0 on every line | agree |
| B fixtures | RA 14/14, RB 14/14 | 14 and 14, all TRUE | H1; fixture rows B RA and B RB | agree |
| Seeded fixtures | 14/14 on each RB path; 112/112 raw rows pass | each seeded RB 14, all TRUE | fixture blocks; arms.csv 14/14 | agree |
| B vs frozen pack | 0/0/0/0 on both paths | reproduces frozen pack | H2 TRUE; repro table all zeros | agree |
| B key/label recon | 0/0/0 | 0/0/0 | H2; recon table n_only_ra=0, n_only_rb=0, n_disagree=0 | agree |
| B full-field numeric mismatches | dormant 1, open_age 2 | dormant 1, open_age 2 | H2; recon table 1 and 2 | agree |
| B key counts | n_ra = n_rb = n_inner = 222002 | same | recon table | agree |
| H | {S_STALE24, S_PEER10, S_ONEROW} | same | H4; arms.csv harm=TRUE on those three | agree |
| D_abl (caught without control) | {S_STALE24, S_PEER10} | same | H5 | agree |
| H \ D_abl | {S_ONEROW} | same | H6 | agree |
| No locked-field change | {S_LF, S_REVERSE, S_BOOLCASE} | same | H7; locked changes 0/0/0 | agree |
| Caught with control | all 6 | all 6 | H8 | agree |
| Caught with control, no locked change | {S_LF, S_REVERSE, S_BOOLCASE} | same | H9 | agree |
| S_STALE24 locked / decision | 773 / 773; only_ra 773 | 773 / 773; only_ra 773 | arms row | agree |
| S_PEER10 locked / decision | 269 / 269; disagree 269 | 269 / 269 | arms row | agree |
| S_ONEROW locked / decision / caught without | 1 / 0 / FALSE; RB dormant vs B = 1; key/label 0/0/0; exit 0; fx 14/14 | same | arms row | agree |
| S_LF, S_REVERSE, S_BOOLCASE locked / decision | 0 / 0 | 0 / 0 | arms rows | agree |
| P1 (H ⊆ D_abl) | false | false | H6 non-empty | agree |
| Source-variant hashes vs preflight | match stated variant hashes | match stated variant hashes | manifests and variant OK lines | agree |
| Code seeds | none | code hashes equal B | SEED DIFFS: no code seeds; manifests equal B on 00_config.R, 20_integrity_and_classify.R, run_RB.R | agree |
| S_REVERSE RB classification file byte-equal to B | no; equal set is S_LF and S_BOOLCASE only (2/6) | yes; lists S_LF, S_REVERSE, S_BOOLCASE | manifest: B and S_LF and S_BOOLCASE are a0e42b86…; S_REVERSE is 2b1abe84… | disagree (ancillary; not a RESULTS number) |

The disagree row is a Validator mis-grouping. The runner manifest is the third column and matches the Builder: S_REVERSE’s classification CSV is not byte-identical to arm B, which is consistent with reversed row order and with locked-field changes of 0. It does not change H, D_abl, exits, fixtures, or P1. It is not a hard number in C26_RESULTS.md. I do not use it as a gate.

4. The nine KEEP conditions of constitution §7.
5. PASS. Evidence packs are present and identified by the FREEZE RECORD; both reports are complete and end on their END lines; this packet supplies the arm manifests, runner file hash, raw fixture rows, arms CSV, RESULTS, run log, and variant hashes that PD-1 omitted. Citation: FREEZE RECORD; re-adjudication note; C26_EVIDENCE.sha256; ARM MANIFESTS; FIXTURE RESULTS.
6. PASS. Roles are Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Each report attests a single role and blindness; freeze record marks verdict_token_leak: false; neither report issues a terminal state. Citation: FREEZE RECORD roles; Builder §1; Validator §1.
7. PASS. Builder and Validator agree on every hard number in the RESULTS file and on H, D_abl, H \ D_abl, fixture passes, exits, B repro, and B recon 0/0/0. The S_REVERSE output-hash mis-grouping is ancillary, contradicted by the manifest, and not a RESULTS hard number. Citation: agreement table; RESULTS H1–H9; C26_arms.csv.
8. PASS. Required exact recon on clean arm B is key set plus classification. That recon is 0/0/0. B R-A vs frozen RA and B R-B vs frozen RB are 0 key / 0 label / 0 dormant / 0 open_age. The dormant_h 1 and open_age_h 2 RA-vs-RB mismatches are the disclosed full-field finding (OF-1 / DST ambiguous hour), outside the frozen recon definition, and the coordinator records them as expected on every control. Citation: RESULTS H2 and Arm B recon table; COORDINATOR NOTES; SPEC regression rule.
9. PASS. Clean arm B is 14/14 on R-A and 14/14 on R-B. Every raw B fixture row has pass=TRUE (F01–F14). Seeded paths are also 14/14; that is confirmatory, not the §7.5 surface. Citation: RESULTS H1; FIXTURE RESULTS B,RA and B,RB.
10. PASS. No undeclared semantic change on clean arm B. SEED DIFFS are empty (source variants only). Arm B uses the frozen source hashes ba089fcc… and cb78ae… and reproduces the frozen path outputs. Seeded semantic effects are reserved to P1. Citation: SEED DIFFS; B input manifest; RESULTS H2; SPEC “Exact change being tested.”
11. PASS. No locked regression on clean arm B: zero key, label, dormant, or open_age differences against the frozen RA and RB classifications, and B fixtures 14/14. Citation: RESULTS Arm B repro table; H1–H2.
12. FAIL. The predeclared predicate is P1 satisfied iff H ⊆ D_abl. H = {S_STALE24, S_PEER10, S_ONEROW}. D_abl = {S_STALE24, S_PEER10}, defined as crash, key/label recon mismatch (n_only_ra + n_only_rb + n_disagree > 0), or fixture failure. H \ D_abl = {S_ONEROW}. S_ONEROW exits 0, fixtures 14/14, key/label recon 0/0/0, decision changes 0, but locked_field_changes_vs_B=1 on dormant_h (RB_vs_B dormant=1). The checksum regime catches it (caught_with_control=TRUE) because src_open_candidates.csv is 64b66028…, not the frozen ba089fcc…. Arms with no locked-field change (S_LF, S_REVERSE, S_BOOLCASE) do not enter P1. Citation: SPEC Operational benefit predicate P1; RESULTS H4–H6; arms.csv S_ONEROW row; S_ONEROW input manifest.
13. PASS. The Validator’s blocking-objection list is empty. The H2 “recon” wording is a label ambiguity (key/label 0/0/0 versus full-field 1 and 2), and the V_STALE24 peer-stats line repeats “rows dropped: 848” on an unchanged file. Neither is a supported blocking objection. The S_REVERSE hash mis-grouping is not raised as an objection and is not supported against the manifest. Citation: Validator §6; COORDINATOR NOTES; ARM MANIFESTS S_REVERSE out.

Conditions are conjunctive. Condition 8 fails.

5. HALT conditions of §9.

- Hard mechanical results conflict: absent. RESULTS hard numbers agree. The ancillary S_REVERSE classification-hash mis-grouping is disclosed above and is settled by the runner manifest; it is not a disagreement on a hard number in the RESULTS file. Citation: agreement table; SPEC regression rule; ARM MANIFESTS S_REVERSE vs B.
- Required raw evidence missing: absent. Runner results, arms CSV, fixture rows, manifests, variant hashes, run log, and both reports are in this packet. Historical stdout is not required. Citation: re-adjudication note; FIXTURE RESULTS; ARM MANIFESTS; user HALT rule on raw evidence.
- Hashes or frozen versions mismatch: absent. Preflight is frozen OK against the SPEC source and code hashes. Variant hashes in the manifests match the SPEC and the variant OK lines. Baseline hashes match the FREEZE RECORD. Citation: PREFLIGHT; SOURCE VARIANTS; FREEZE RECORD; BASELINE FRAMEWORK HASHES.
- Baseline or constitution changed mid-run: absent. Constitution 1.0 and the two baseline hashes are the same in the SPEC and the FREEZE RECORD. Citation: SPEC; FREEZE RECORD.
- Role separation violated: absent. Three distinct roles; no model holds two. Citation: FREEZE RECORD roles.
- Information barrier breached before first-pass freeze: absent. Both reports attest blindness; freeze record marks no verdict-token leak; neither report cites the other. Citation: Builder §1; Validator §1; FREEZE RECORD.
- Benefit predicate not defined before execution: absent. P1, H, D_abl, and the locked fields are in the SPEC, frozen before the run. Citation: SPEC Operational benefit predicate P1; FREEZE RECORD frozen_at_ct.
- Adjudicator cannot tell which pack is authoritative: absent. One Builder pack and one Validator pack are named in the FREEZE RECORD, and the runner RESULTS are the mechanical source both recomputed. Citation: FREEZE RECORD; C26_RESULTS.md.

Spec HALT rules are also absent: arm B reproduces the frozen pack and B recon is 0/0/0 with fixtures 14/14; all six seeded runs have an exit; Builder and Validator do not disagree on a hard number in the RESULTS file. A seeded crash would be a catch, not a HALT; none crashed.

6. Blocking objections raised by the Validator and how the evidence bears on them.

The Validator raised none. Two notes were offered and do not block.

The H2 wording reports “B recon is 0/0/0: TRUE” and, separately, full-field dormant_h 1 and open_age_h 2. The SPEC defines exact recon as key set plus classification. The recon table shows 0/0/0 and, in other columns, 1 and 2. The coordinator identifies those three 1.000 h differences (SR22-01936870 dormant_h; SR25-02017553 and SR25-02017556 open_age_h) as open finding OF-1, expected on every control, and not a seeded effect. That note is consistent with the evidence.

The variant log repeats “rows dropped: 848” on V_STALE24 src_peer_stats.csv. The peer-stats hash on that line is the frozen hash cb78ae…, and the S_STALE24 manifest confirms the peer file is unchanged. The misapplied note is not a numerical contradiction.

The S_REVERSE classification-hash error is mine to record, not a Validator objection. It does not touch P1.

7. Verdict rationale.

Removing the control materially changes detection on the frozen pack. With the control, a source SHA-256 that differs from the frozen package is a catch. Without it, a catch is only a crash, a key/label recon failure, or a fixture failure.

On the clean arm the ablation is quiet: both paths exit 0, fixtures are 14/14, frozen-pack repro is clean, and key/label recon is 0/0/0. That satisfies §7 conditions 4–7 for arm B. It does not prove the control is redundant.

Of the three seeded arms that move a locked field, two are still caught without the checksum. S_STALE24 drops 848 source rows and loses 773 output keys (only_ra=773). S_PEER10 scales WCA2 peer_p75_h from 2250 to 2475 and produces 269 classification disagreements. S_ONEROW is not caught. It moves one in-set mod_ts / LAST_MODIFIED_DATE 30 days earlier (SR18-00191995); R-B exits 0; F01–F14 pass; key set and classification match; decision changes are 0; and one locked dormant_h value differs from arm B. The frozen no-check definition does not treat a dormant or open_age numeric mismatch as a catch. The with-check regime catches S_ONEROW, and also the three no-harm byte variants (S_LF, S_REVERSE, S_BOOLCASE), which the SPEC excludes from P1.

So H is not a subset of D_abl. P1 fails. No HALT condition holds. The conservative rule is REVERT: catalog #26 stays. The frozen source checksum is not removable on this pack, because a one-row timestamp edit changes a locked duration field and still clears exit, fixtures, and frozen key/label recon.

TERMINAL_STATE: REVERT
END C26 ADJUDICATION
