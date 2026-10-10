# C05 — Ablation specification (FROZEN)

**Ablation ID:** C05 (owner ablation list control #5: Claim ceiling: word-list lint instead of auditor judgement)
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 5-A (overclaim = a causal, ranking or should-act sentence without a matching evidence tag; seeded stronger sentence in the frozen AI 1 text; no chats). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
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

## Control under test (owner list #5)
Stage 5 claim ceiling as it stands: conclusions cannot be stronger than the evidence (no cause from descriptive data); the AI 2 / AI 3 audits enforce it.
Ablation: the ceiling is enforced by a mechanical word-list lint (causal / ranking / should-act sentences without an evidence tag Descriptive / Associational / Causal-supported). KEEP would mean the lint can stand in for the auditors on this point.

## Verdict convention
**KEEP = the claim ceiling may be enforced by the mechanical lint. REVERT = the claim ceiling stays with the AI auditors.** HALT as in constitution §9.

## Arms
- ORIG = frozen AI 1 Stage 5 text (`c48/AI1_ORIGINAL.md`).
- CLEAN_EDIT = one wording change in section 2.
- SEED_OVERCLAIM = ORIG with one overclaim sentence inserted after the section 3 heading 'Evaluation' (causal + ranking + should-act).

## Operational benefit predicate P1 (made mechanical before execution)
1. the lint flags the seeded overclaim sentence (new hit);
2. the lint raises no new hit on the clean edit;
3. every lint hit on the unmodified original is also objected to by the real first-round AI 2 / AI 3 reviews (8-word match; zero hits is trivially met).
P1 MET -> KEEP. Not MET -> REVERT. Lint hits on the real text are false positives unless the real auditors also objected to the sentence.

## Disclosures and deviations (declared before the chats)
- Scratch-run adjustment before the reporting run: the lines under 'What the Evidence Does Not Establish' are exempt (their heading negates them).
- The real AI 1 text carries 'Evidence status' labels, not the Descriptive / Associational / Causal-supported tags of the owner ruling; no sentence in the real text carries a ruling tag, so the tag escape in the lint is exercised only by the scorer's logic, not by the data.
- Depends on C04 only by order (sheet: #4 before #5). If C04 removes the three roles, 'the auditors' no longer exist and the question changes; the Adjudicator is told this in the HEAD.
- Same style as C48 (KEEP); no new chats.
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
- `scorers/score_s5.py` SHA-256 `d0f8c42b907075c5d98e162ca7428cd814199a4f86b23020ce6b6cf42ee7737a`
- `scorers/s5text.py` SHA-256 `d3f2d61f5f2ef389b85a353a68071f2a2135c5f8619e16b53d8927cbd0091568`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
- `C05/seeds/CLEAN_EDIT.md` SHA-256 `fc5e4f12236fae88057ecded1be43d61dcdf82c96483f20878a14fd282a1f091`
- `C05/seeds/SEED_OVERCLAIM.md` SHA-256 `ae7188e83c512816d08c950802f4bfa2a4a40689a1a645a34c97049901629788`
- `C05/seeds/ORIG.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
**Result and evidence files:**
- `C05/evidence/C05_RESULTS.md` SHA-256 `895c99a36657c07f0c05e85895dfe982d685a131c0731c5aeb57dd1d500c4c13`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the lint hits for the three arms by reading the verbatim text with the declared word lists; list sentences the lint should have caught or wrongly caught.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
