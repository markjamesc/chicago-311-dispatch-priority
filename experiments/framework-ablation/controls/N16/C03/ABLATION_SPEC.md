# C03 — Ablation specification (FROZEN)

**Ablation ID:** C03 (owner ablation list control #3: Design Gate after the cross-review (pre-gate replay))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 3-A mechanical form (replay on the real Chicago Stage 3 records; no new design chat). Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 0.** Builder (ChatGPT, High), Validator (DeepSeek, DeepThink on / Search off) and Adjudicator (Grok, Expert) only.
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** Stage 3 design
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #3)
Stage 3 order as it stands (three-AI measurement design framework): independent first passes (Design A, Design B, data-risk dossier), then the cross-review synthesis, then the Design Gate (owner checklist, locked design). The Design Gate comes AFTER the cross-review.
Ablation: apply the Design Gate BEFORE the cross-review, on the pre-review documents only (Design A, Design B, the AI 3 dossier). KEEP would mean the gate can be moved earlier (and the cross-review round dropped or shortened).

## Verdict convention
**KEEP = the Design Gate may be applied before the cross-review. REVERT = the Design Gate stays after the cross-review.** HALT as in constitution §9.

## Arms
- BASE (the rule): the real gate after the cross-review = `stage3/DESIGN_GATE_PACKAGE.md` + `DESIGN_GATE_RECEIPT.md` (PASS 2026-09-19 05:23:53 CDT).
- VARIANT (replay): the same 14 design items of the real gate checklist evaluated against the pre-review set {AI1_DESIGN_A, AI2_DESIGN_B, AI3_DATA_RISK_DOSSIER} only (regex key terms declared in the scorer), plus a token-level comparison of the locked design against the pre-review set, plus the count of material disagreements the cross-review itself lists.

## Operational benefit predicate P1 (made mechanical before execution)
1. every gate checklist design item 1-14 is decidable from the pre-review documents (none synthesis-only, none missing);
2. every distinct design token of the locked design appears in at least one pre-review document (the cross-review adds no design token);
3. the cross-review's section-4 list of material disagreements between Design A and Design B is empty (a gate before it would have approved one design without a reconciliation).
P1 MET -> KEEP. Any failed condition -> REVERT. Regex judgement of 'decidable' is an aid: the judges verify each class against the verbatim documents.

## Disclosures and deviations (declared before the chats)
- Baseline = the real Chicago run (owner Q0-A). It was run with a coordinator and extra reviews, so it is not a clean A/B; no counterfactual gate was run.
- The check is a replay of what the documents contain; it does not show that an owner would have approved or refused a pre-review gate.
- Items 15 and 16 of the real checklist are process items (superseded scratch; accept Grok Auto) and are not scored.
- Scratch-run adjustment (before the reporting run): file-metadata tokens (`MEASUREMENT_DESIGN_LOCKED`, `design_version`, `locked_at`, `reconciled_design_*`) are excluded from the locked-design token comparison; they are not design content.
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
- `scorers/score_c03.py` SHA-256 `9cd3dc726b2ade2bd0c7431763a0979418de5af4235fec68b131cf46c4dd4e62`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
- `C03/evidence/C03_RESULTS.md` SHA-256 `8cc735ffea6a3124901959656fb08f64be63fa95579186da40a3f9e1ccd4af34`
- `C03/evidence/C03_items.csv` SHA-256 `d3801c09adbf3efc608c8650d8f1fce63a96eb815b0c98e01712a4f3a61a600a`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recompute the checklist classification and the token comparison yourself from the verbatim documents; list any item whose class you would change.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
