# C37 — Ablation specification (FROZEN)

**Ablation ID:** C37 (owner ablation list control #37: Recommendation proportionality: evidence-tag table)
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 37-A (approve the small table; seeded over-confident 'Act' on descriptive data must be flagged, a clean text must pass; no chats). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
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

## Control under test (owner list #37)
Stage 5 recommendation proportionality as it stands: the final action must match evidence strength (Act / Pilot / Monitor / Collect more / No action); audited by the AI auditors.
Ablation: proportionality is checked by a small table: Descriptive -> at most Monitor; Associational -> at most Pilot; Causal-supported -> Act. KEEP would mean the table can stand in for the audit on this point.

## Verdict convention
**KEEP = recommendation proportionality may be checked by the table. REVERT = recommendation proportionality stays with the AI auditors.** HALT as in constitution §9.

## Arms
- ORIG = frozen AI 1 text; CLEAN_EDIT = harmless wording change in section 7; SEED_ACT = section 7 recommendation replaced by 'Act now: dispatch crews to all 131,968 ESCALATE requests'.
- Evidence tag of the recommendation (declared before scoring): Descriptive (the Stage 5 package has no causal or association test).

## Operational benefit predicate P1 (made mechanical before execution)
1. the table flags the seeded over-confident action;
2. the clean edit passes the table;
3. the unmodified original passes the table.
P1 MET -> KEEP. Not MET -> REVERT.

## Disclosures and deviations (declared before the chats)
- The evidence tag is assigned by the coordinator once, for the whole recommendation (Descriptive); it is not derived per claim. The real text has no ruling tags.
- Action words are classified by a declared lexicon; 'Accept the frozen labels' is not an action word and passes.
- The C05 lint also matches the seed (INFO overlap); the merged #5 + #37 form (sheet option C) is not tested.
- The scope is section 7 'Primary Recommendation' only (the option matrix lists menu items, not recommendations).
- Depends on C04 by order only.
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
- `C37/seeds/CLEAN_EDIT.md` SHA-256 `39ea49a2d44d36b51acb34b6425c70fdd6171184759ce21312bf4e7a79f51161`
- `C37/seeds/SEED_ACT.md` SHA-256 `b73ea5afcd2aec2b15a7c8cfd7db5faf8b202ffcb8ec6e111feaea66a581fafd`
- `C37/seeds/ORIG.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
**Result and evidence files:**
- `C37/evidence/C37_RESULTS.md` SHA-256 `efb87f54c7f77826fe0fdbe1f1f83b5015550b5e590f3fad2fa7d26ad1a10dc6`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the action classification of section 7 for each arm from the declared lexicon and table.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
