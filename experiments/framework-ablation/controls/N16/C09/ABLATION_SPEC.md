# C09 — Ablation specification (FROZEN)

**Ablation ID:** C09 (owner ablation list control #9: Ambiguity attack before lock (ledger replay))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 9-C replay (score the real ambiguity_ledger.md against later rulings; no new chats). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
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

## Control under test (owner list #9)
Before a stage is locked, an adversarial ambiguity challenge is run (the Chicago Stage 1-2 ambiguity ledger plus the independent AI 2 / AI 3 Start and Framing reviews).
Ablation: no pre-lock ambiguity attack. KEEP would mean the attack can be dropped.

## Verdict convention
**KEEP = the pre-lock ambiguity attack may be dropped. REVERT = the pre-lock ambiguity attack stays.** HALT as in constitution §9.

## Arms
- BASE (the rule): the real ledger A001-A013 and the four independent AI 2 / AI 3 Start / Framing reviews.
- VARIANT (replay): count how many substantive ledger ambiguities needed a later ruling, and how many of the 16 Design Gate checklist items the ledger and the Start lock had already named.

## Operational benefit predicate P1 (made mechanical before execution)
1. KEEP side iff 0 substantive ledger ambiguities needed a later ruling (the attack found nothing that mattered);
2. REVERT side otherwise (the attack found ambiguities that later needed a ruling).
Declared rule. The second count (checklist items already named, 8 of 16 by the scorer's declared topic regexes) is reported, not scored.

## Disclosures and deviations (declared before the chats)
- Weak test: a replay of the coordinator's ledger, not a run without the attack; a ledger row 'needing a later ruling' is read from its own Resolution / Severity text.
- The ledger records the coordinator's dialogue; the independent attack record is the four review files, of which only keyword counts are scored.
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
- `scorers/score_c09.py` SHA-256 `8b3da05ebec56f322d1bf8ca1e24bd98399a19d1ed6adea6aa0af2347997a430`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
- `C09/evidence/C09_RESULTS.md` SHA-256 `490ce631ae7d17493cdf3acdd3484aabbc9f875685250ad1bfa3fb67144668fc`
- `C09/evidence/C09_ledger.csv` SHA-256 `220fa2785f11ddf2c9cc3c89e7b1f9fd273711ee4429d85efa00ec47fcc8f2dd`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the ledger counts and the checklist-item mapping from the verbatim files; say which mapping rows you would change.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
