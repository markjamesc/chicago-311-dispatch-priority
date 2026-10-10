# C50 — Ablation specification (FROZEN)

**Ablation ID:** C50 (owner ablation list control #50: One-pass Stage 5 revision vs the revise / re-audit loop (C48 replay))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 50-B (no new audit chats; simulate the loop with C48's frozen second-audit replies and count the rounds the baseline would need). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 0.** Builder (ChatGPT, High), Validator (DeepSeek, DeepThink on / Search off) and Adjudicator (Grok, Expert) only.
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** Stage 5 interpretation
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #50)
Stage 5 as it stands: after the first audit, the interpretation is revised and re-audited until clean (a loop).
Ablation: one consolidated revision checked by the C48 mechanical checklist (rev_check), no re-audit loop. KEEP would mean the loop can be replaced by one pass + checklist.

## Verdict convention
**KEEP = the revise / re-audit loop may be replaced by one consolidated pass checked by the mechanical checklist. REVERT = the revise / re-audit loop stays.** HALT as in constitution §9.

## Arms
- LOOP (baseline): round 1 = the first audit (frozen; its revisions V-1..V-6 are `c48/REVISIONS.json`); round 2 = the second audit of the revised text (the frozen C48 AI 2 and AI 3 replies, on the text with the planted V-3 mis-application); round 3 = an audit after the V-3 fix (PROJECTED, not run).
- ONE PASS (variant): first audit, one consolidated revision, the frozen rev_check result (C48: SEED flagged V-3, CLEAN passed).

## Operational benefit predicate P1 (made mechanical before execution)
1. the checklist flags the planted material seed V-3 on SEED and passes CLEAN (frozen rev_check output);
2. every BLOCKING / MATERIAL finding in the two frozen second-audit replies relates to V-3 (none is NEW or on another revision);
3. the presentational seed V-6 is not flagged by the checklist and neither audit grades it NO / PARTIAL;
4. audit rounds fall by at least 1 (loop 3 incl. 1 projected, one pass 1);
5. the two replies are byte-identical to the hashes in `c48/AUDIT_FREEZE.json`.
P1 MET -> KEEP. Not MET -> REVERT. HALT if the C04 terminal state recorded at adjudication is KEEP (single interpreter replaces the three roles): then there is no audit to revise against and the question is moot. HALT if C48's terminal state is not KEEP.

## Disclosures and deviations (declared before the chats)
- This re-reads the C48 experiment as a loop count; it adds no new evidence about errors the checklist might miss, and the owner sheet itself says #48's KEEP covers most of #50 (option C).
- Round 3 is projected, not run.
- Dependencies: #4 (order and mootness), #48 (KEEP, frozen), #40 (paused; not required).
- The C04 terminal state is unknown when the Builder and Validator packets are built; the Grok HEAD carries a placeholder filled from `C04/TERMINAL_STATE.txt` by `runner/assemble_adjudicator.py`, which refuses if that file is missing.
- Known open finding N1 / OF-1 (clock mismatch on 3 rows of the frozen pack): cannot enter N16 (no R path run). See the coordinator note in the packets.
- Cost: not measured in minutes; the reply and packet byte sizes are the only cost proxy and are not part of P1 unless stated above.

## Regression / HALT rules
- HALT as in constitution §9, or if Builder and Validator disagree on a hard number or classification that decides a P1 condition, or if a reply is missing, incomplete (no END line) or changed after its freeze, or if a frozen input hash differs from `FROZEN_INPUTS.sha256`.
- Constitution §7 conditions 4 and 5 (clean-arm byte identity; fixtures) are not applicable: no R run and no fixture. The known-answer cases are the unmodified / clean arms and the seeds declared above. Conditions 6-7: the frozen inputs are only read (preflight).

## Allowed source/data scope
Frozen Chicago Stage 1-5 documents, frozen N13 logs and C48 outputs under `N16/frozen/`. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on)
**Frozen input files:** all 75 files in `FROZEN_INPUTS.sha256`; the ones used here are listed in the EVIDENCE list of the packet.
**Scorer files (hashed in `SCORERS_N16.sha256` before the reporting run):**
- `scorers/score_c50.py` SHA-256 `0c26a39c70041f283ca3fc5336404b8e9b36d69f6f10a0b520b4a8fe62faa622`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
- `C50/evidence/C50_RESULTS.md` SHA-256 `fb85b8abb71294f0f529eea864ee4ca721ed917573d2c50f3224f02473c085b7`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the per-revision verdicts, the finding list and the round counts from the frozen replies; check the reply hashes against AUDIT_FREEZE.json.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
