# C01 — Ablation specification (FROZEN)

**Ablation ID:** C01 (owner ablation list control #1: Stage-3 blindness (one unblinded design chat))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answers Z = recommended: 1-C (one unblinded design chat, ChatGPT) and Q0-A (the real blind Chicago pair is the baseline). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 1, shared with C02** — `X12/packets/X12_DESIGN_ChatGPT.txt` (ChatGPT, High), a Stage 3 design chat; it is counted once for both controls. The extra chat is a NEW conversation, blind to this ablation's purpose (it is told it may use or reject the supplied material).
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** Stage 3 design
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #1)
Stage 3 as it stands: Design A, Design B and the risk dossier are produced blind to each other until the cross-review.
Ablation: the designer sees the peer design (Design B) and the dossier first. KEEP would mean the blindness rule can be relaxed.

## Verdict convention
**KEEP = Stage-3 blindness may be relaxed (designers may see peers' work first). REVERT = Stage-3 blindness stays.** HALT as in constitution §9.

## Arms
- BASE (the rule): the real blind Design A (`stage3/AI1_DESIGN_A.md`), produced from the shared packet only (meta: 'Independent Design A from shared packet only', 2026-09-19 04:57 CT).
- VARIANT: the shared extra chat X12 (ChatGPT): the same packet, blindness lines removed, plus the supplied coordinator draft, Design B with SEED S1, and the real dossier. Scored for S1.

## Operational benefit predicate P1 (made mechanical before execution)
1. S1 detected: the reply flags the P25 statistic in Design B's rule;
2. S1 not adopted: the reply does not use peer_p25_h as its own rule;
3. coverage of the 8 blocking-gap topics of the dossier is at least the real Design A's;
4. the reply is complete (single END X12 DESIGN as last line).
P1 MET -> KEEP. Not MET -> REVERT. If the extra chat is incomplete or missing -> HALT.

## Disclosures and deviations (declared before the chats)
- Shared chat with C02 (owner answers 1-C and 2-C): the chat sees BOTH the coordinator draft and the peer design, so the two effects are not separated by design; they are attributed by seed (S1 to C01, S2 to C02) and by the scorer's per-seed conditions, but interaction effects are not separated.
- Only the unblinded half is run (1-C); the reverse (DeepSeek sees ChatGPT's design) is not.
- The owner sheet (#2-A) describes the real design as 'coordinator-draft-anchored'; the frozen records say otherwise: `AI1_meta.txt` and the cross-review attest the real Design A came from the shared packet only, and `SHARED_INPUT_PACKET.md` forbids drafts. (The `AI1_STAGE3_PRIMARY_DESIGN_PROMPT.md` file lists the draft as an input, and the later post-lock `AI1_FULL_PASTE.md` includes it; neither is the Design A packet, `AI1_INDEPENDENT_DESIGN_A.md`.) This SPEC follows the records.
- Seeded flaws are detected by regex + a critique-cue word list; the judges verify against the verbatim reply.
- Stage 3 only; the new design is NOT run through Stage 4 (no pull).
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
- `scorers/score_x12.py` SHA-256 `fef3ad0d5c303e525b2bbfaaee0d85c45164aad10e884f3ad92de95fef6849d1`
- `scorers/build_x12.py` SHA-256 `73f4e8ab7c4625526de13917f410b3ebfdf062bd79c6bcdf17648588116b4abc`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
(the post-chat score file is created after the extra chat; its scorer hash is above; the extra-chat packet hash is below)
- `X12/packets/X12_DESIGN_ChatGPT.txt` SHA-256 `1af3405807436ea9bac8eafb31d765fa5c986599a710825c41b609fda56ae372` (48576 bytes); END line `END X12 DESIGN`; reply save: `X12/X12-chat/design_chatgpt_TEXTONLY.txt`.
**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Check the seeded-flaw findings and the coverage table against the verbatim reply; list anything the scorer missed.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
