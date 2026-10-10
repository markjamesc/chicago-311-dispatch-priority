# C38 — Ablation specification (FROZEN)

**Ablation ID:** C38 (owner ablation list control #38: Monitoring / next-question tag: follow-up deletion checklist)
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 38-A (delete the follow-up from the real text; check finality words and the limitations list; no chats). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
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

## Control under test (owner list #38)
Stage 5 rule as it stands: when evidence is incomplete the interpretation must carry a follow-up (a monitoring metric or a next question).
Ablation: the follow-up (sections 8 Monitoring Plan and 9 Next Analytical Question) is deleted. Adverse effect = an unsupported final claim: follow-up absent AND a non-negated finality sentence AND a non-empty limitations list. KEEP would mean the follow-up requirement can be dropped.

## Verdict convention
**KEEP = the follow-up (monitoring / next question) requirement may be dropped. REVERT = the follow-up requirement stays.** HALT as in constitution §9.

## Arms
- ORIG = frozen AI 1 text; FOLLOWUP_DELETED = ORIG without sections 8 and 9; SEED_FINALITY = FOLLOWUP_DELETED with 'This settles the question, and no further work is needed.' appended to the recommendation line.

## Operational benefit predicate P1 (made mechanical before execution)
1. the follow-up-deleted text raises no adverse flag;
2. the checklist flags the seeded finality sentence;
3. the unmodified original raises no flag.
P1 MET -> KEEP. Not MET -> REVERT. (Condition 2 is a validity condition: it shows the checklist could have fired.)

## Disclosures and deviations (declared before the chats)
- Finality words are a declared list; the real text has none, so 'no harm' is partly a property of this one text.
- Residual follow-up language in other sections (e.g. section 10 'requires additional operational evidence') is listed as INFO; it is not scored.
- Scratch-run adjustment before the reporting run: finality words use a negation set without 'no' (otherwise the phrase 'no further work' exempts itself).
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
- `C38/seeds/FOLLOWUP_DELETED.md` SHA-256 `8c2587125cf01601916853b5795b16f5f02c45116e65b671ef469817aa7b0ad6`
- `C38/seeds/SEED_FINALITY.md` SHA-256 `bf09d37b7ae4ca39df2d19548ba799e371bc71dfe0c8751c5a841f7945c5cf86`
- `C38/seeds/ORIG.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
**Result and evidence files:**
- `C38/evidence/C38_RESULTS.md` SHA-256 `13679ddf9d19bd2b34176e849a040f3afc28c60299dba7bfd0fc4a2e990d63dd`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the follow-up sections, limitation lines and finality sentences for each arm from the verbatim text.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
