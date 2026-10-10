# C07 — Ablation specification (FROZEN)

**Ablation ID:** C07 (owner ablation list control #7: Framing gate: exactly one question (ledger replay))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 7-C replay only (count, in the real Chicago ledgers, how many extra questions arose and whether any would have entered scope; no new chats). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 0.** Builder (ChatGPT, High), Validator (DeepSeek, DeepThink on / Search off) and Adjudicator (Grok, Expert) only.
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** Stage 1-2 framing
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #7)
Framing gate as it stands: exactly one candidate question is locked (CQ-F02 in the Chicago run); extra questions are not locked together with it.
Ablation: the Framing gate may lock up to 3 questions. KEEP would mean the one-question rule can be relaxed.

## Verdict convention
**KEEP = the Framing gate may lock more than one question. REVERT = the Framing gate keeps exactly one locked question.** HALT as in constitution §9.

## Arms
- BASE (the rule): the real Stage 1-2 ledgers with one locked question (CQ-F01 -> CQ-F02).
- VARIANT (replay): list the extra decision questions the ledgers show arising (ambiguity-ledger rows that were deferred and are substantive), and trace each to the locked Stage 3 design and to the Stage 5 package / Finish Gate (carried or LOST).

## Operational benefit predicate P1 (made mechanical before execution)
1. KEEP side iff no extra decision question arose, OR at least one extra question was lost (not found in the locked Stage 3 design or Stage 5 package);
2. REVERT side otherwise (extra questions arose but the single locked question contained every one of them without loss).
Declared rule, fixed before the reporting run. The KEEP side is the only evidence of harm from the one-question rule; absence of harm in a replay is not evidence that multiple questions would be safe, so the test is weak.

## Disclosures and deviations (declared before the chats)
- Weak test (owner sheet says so): no counterfactual Framing run; the scope-creep claim (new unlocked claims in the Stage 3 design) is not measured.
- Topic keys for each deferred item (window, open/eligible, urgency, capacity, SLA) are declared in the scorer; whether a keyword hit means 'carried' is for the judges to confirm against the verbatim documents.
- Scratch-run adjustment: the topic key for row A006 (SLA) was added and the INFO row label corrected before the reporting run.
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
- `scorers/score_c07.py` SHA-256 `8c26588039f75016340ada7835931c65c7ffc05a721b05451785724857dc62a3`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
- `C07/evidence/C07_RESULTS.md` SHA-256 `ab49fcea90b680382fe4edba075484fe81d64dbc595f464d80556b3a7721cba8`
- `C07/evidence/C07_extra_questions.csv` SHA-256 `abfd4ad33199a8ec1e6626c713f78cc7c7ebc0bde631b3175d49381d7d4f6f44`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Re-derive the list of extra questions from the ambiguity and decision ledgers and decide, from the verbatim documents, whether each was carried or lost.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
