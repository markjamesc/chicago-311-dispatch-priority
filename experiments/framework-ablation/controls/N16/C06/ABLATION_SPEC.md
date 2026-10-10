# C06 — Ablation specification (FROZEN)

**Ablation ID:** C06 (owner ablation list control #6: Start Gate action vocabulary lock (drift scan))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 6-A (text scan over the frozen Chicago Stage 1-5 files plus seeds; no chats). Owner flag: weak test. Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
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

## Control under test (owner list #6)
Start Gate as it stands: the action vocabulary is locked at Start (ESCALATE / INCONCLUSIVE / STANDARD in the Chicago run, `stage1_decision.json`).
Ablation: no vocabulary lock. Drift = any action word in the Stage 2-5 records outside the locked Start set. KEEP would mean the lock can be dropped.

## Verdict convention
**KEEP = the Start-Gate action-vocabulary lock may be dropped. REVERT = the Start-Gate action-vocabulary lock stays.** HALT as in constitution §9.

## Arms
- LOCK = the scan of the frozen Stage 1-5 records for action tokens outside the Start set.
- Seeds (copies of the frozen AI 1 text): CLEAN_EDIT (wording change), SEED_1_UPPER (appends `assign PILOT_EXPAND`), SEED_2_LOWER (appends `pilot-and-expand`).
- NOTHING-ELSE check = the existing number-diff of C48 (a changed number would flag); the seeds contain no number.

## Operational benefit predicate P1 (made mechanical before execution)
1. the lock flags both seeded actions;
2. the lock does not flag the clean edit nor the unmodified original;
3. no unlisted action-like token in the real Stage 2-5 records (after the declared ignore list SR_NUMBER, SR_TYPE, COORDINATOR_DRAFT);
4. the existing number-diff check does not flag either seed (nothing else catches it).
Here P1 is evidence that the lock earns its keep: **all four MET -> REVERT** (as the owner sheet says: 'KEEP-the-rule (REVERT) if the lock catches it and nothing else does'). Any condition not MET -> KEEP (the lock can be dropped), except a seed that cannot be applied or a scan that errors, which is HALT.

## Disclosures and deviations (declared before the chats)
- Weak test (owner sheet): a text scan, not real builder behaviour.
- The ignore list was tuned on the frozen real records (three field / status names) BEFORE the seeds were added; this is declared, and a different scan could produce other false flags.
- Scratch-run adjustments before the reporting run: the number-diff regex first counted the digit in `WCA2` and was fixed to ignore digits inside words; the lowercase-action pattern first required the hyphenated token right after `assign` and was widened to a hyphenated token of 3+ parts within 60 characters.
- Seeds 1 and 2 are the coordinator's own choices; whether a real builder would drift differently is not tested.
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
- `scorers/score_c06.py` SHA-256 `bb2a6609767d113a9f9d9b73d2c634bf9a920e8c3000956c43e2d65843be16e7`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
- `C06/seeds/CLEAN_EDIT.md` SHA-256 `bd79f9a21b32db6e8930a487552777f892e3e9c7ff135fa1e45263eead3796d3`
- `C06/seeds/SEED_1_UPPER.md` SHA-256 `f9a2d9de0d68192e6ec29e224abd76f1dbc10286b10625d9b2c7ec91fe51f3bb`
- `C06/seeds/SEED_2_LOWER.md` SHA-256 `aa01c4c51aed9764cf2f3e912f74361ecb776223b92b55e5f3ec706301b88f1d`
- `frozen/c48/AI1_ORIGINAL.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932`
**Result and evidence files:**
- `C06/evidence/C06_RESULTS.md` SHA-256 `e43b1fa6f05e800fbd8c3eeb846160df6c850ab9d4131f7e1ed37327b50fa82b`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the scan result for the three seed arms and for the unmodified original; check the ignore list against the real-records table.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
