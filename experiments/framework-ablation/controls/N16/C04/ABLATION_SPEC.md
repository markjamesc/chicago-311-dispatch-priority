# C04 — Ablation specification (FROZEN)

**Ablation ID:** C04 (owner ablation list control #4: Stage-5 three-AI roles vs one interpreter)
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 4-C (one single-interpreter chat on the frozen Stage 5 package, plus one seeded unsupported claim and one seeded wrong number inserted into its output). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 1** — `X4/packets/X4_SINGLE_INTERPRETER_ChatGPT.txt` (ChatGPT, High): one chat that plays AI 1, AI 2 and AI 3. A NEW conversation, blind to this ablation.
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** Stage 5 interpretation
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #4)
Stage 5 as it stands: three roles (AI 1 builder, AI 2 decision critic, AI 3 claim-to-evidence auditor) interpret the frozen evidence package.
Ablation: a single interpreter (one ChatGPT chat) plays all three roles. KEEP would mean the three roles can be replaced by one interpreter plus the mechanical checks.

## Verdict convention
**KEEP = one interpreter (self-audit + mechanical checks) may replace the three Stage 5 roles. REVERT = the three Stage 5 roles stay.** HALT as in constitution §9.

## Arms
- BASE (the rule): the real three-role round (AI 1 first pass, AI 2 and AI 3 first-round reviews) whose required revisions are V-1..V-6 (`c48/REVISIONS.json`).
- VARIANT: extra chat X4 (ChatGPT): one chat with the same evidence the real roles had; sections 1-10 (AI 1), 11 (AI 2 critique), 12 (AI 3 audit), 13 (final text). Scored on its section-13 text.

## Operational benefit predicate P1 (made mechanical before execution)
1. none of the real first-round required revisions V-1..V-5 is missing from the single interpreter's final text (missed findings = 0);
2. the final text has no number outside the evidence (recomputable shares allowed) and no claim-ceiling lint hit;
3. the mechanical checks catch both scorer-inserted seeds (S3 unsupported causal / should-act sentence by the lint, S4 wrong share 42.9% by the number check);
4. the reply is complete (sections 11-13 present, single END C04 SINGLE INTERPRETER as last line).
P1 MET -> KEEP. Not MET -> REVERT. Extra chat incomplete or missing -> HALT. #50, #5, #37, #38 assume the roles exist: if C04 is KEEP, the Adjudicators of those controls are told.

## Disclosures and deviations (declared before the chats)
- V-1..V-5 stand in for 'the real AI 2 / AI 3 findings': they are the coordinator's reconciled revision list (`C48/REVISIONS.json`, each with its source line in the real reviews), not the raw review text; V-6 is a capture artefact and not applicable.
- The single interpreter sees the same evidence package, deeper findings and CSVs as the real roles (superset of AI 1's pasted package; disclosed).
- The seeds are inserted into a copy of the final text by the scorer after the chat, so 'caught' means caught by the mechanical checks; the single interpreter's own self-audit is not tested against them.
- Real-role satisfaction regexes (V-1..V-5) are declared in the scorer; they were validated on the frozen AI 1 original (misses all five) and the frozen revised-clean text (satisfies all five) before the reporting run (X4/selftest, NON_REPORTING).
- Scratch-run adjustment: the lint counts a causal word only in a sentence about WCA2 / ESCALATE / dormancy / concentration / crews / staff, because definitional 'because' sentences in the real AI 1 text were flagged.
- Same role overlap as the N13 audits: ChatGPT is also the Builder of the trios; the extra chat is a separate conversation.
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
- `scorers/score_c04.py` SHA-256 `0d4b3c56310c5dc4327ee9f703308d5b74078327e8e707011a4e4b46f560525d`
- `scorers/build_x4.py` SHA-256 `7ea2ee295ae792cd00098f3abac10bf02505cf1445d21977573d7e6b81cca0a8`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
(the post-chat score file is created after the extra chat; its scorer hash is above; the extra-chat packet hash is below)
- `X4/packets/X4_SINGLE_INTERPRETER_ChatGPT.txt` SHA-256 `fe2899cb6a99713bd0b9cd653ae1c60d1301c847410a375b18fe20474216cc30` (12981 bytes); END line `END C04 SINGLE INTERPRETER`; reply save: `X4/X4-chat/single_interp_chatgpt_TEXTONLY.txt`.
**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Check each V-1..V-5 satisfaction, the number check and the seeds against the verbatim reply.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
