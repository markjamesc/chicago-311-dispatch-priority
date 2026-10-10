# C54 — Ablation specification (FROZEN)

**Ablation ID:** C54 (owner ablation list control #54: Builder file-download capture channel (capture-log replay))
**Batch:** N16 (the 12 controls untested after N13: #1-#7, #9, #37, #38, #50, #54). Built 2026-10-09 on the box, text only.
**Definitions and approval (operational definitions, constitution §9):** owner rulings sheet `ablation_plan/OWNER_RULINGS_BATCH_02.md` SHA-256 `1214c8966aea50f3dc67b3c57a74d89c894fb0c973d41a40999b9a907af1f417`; owner answer **Z (all recommended)** at 2026-10-09 01:49 CT, recorded in `OWNER_BATCH_02_ANSWERS.md` SHA-256 `3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b`. Owner answer Z = recommended: 54-B replay now (measure from the N13 capture logs how many capture failures happened and which a download would have avoided; no new chats); 54-A (live proof) not run and blocked while Chrome saving is broken. Q0 = A: the real Chicago 311 Stage 1-3 run (`chicago-311-run/stage-01-02`, `stage-03`, Stage 5) is the shared baseline for the design controls; it was run with a coordinator and extra reviews, so it is not a perfectly clean A/B.
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data:** the frozen Chicago 311 Dataset 2 run and its Stage 1-5 records; every input is a hashed copy under `N16/frozen/` (`FROZEN_INPUTS.sha256`, origins in `FROZEN_ORIGINS.tsv`, re-verified by `runner/preflight_n16.py`, output `PREFLIGHT_N16.txt`). No MySQL, no fresh pull, no git, no R, nothing on the PC.
**Roles:** Builder=ChatGPT (High) · Validator=DeepSeek (DeepThink on, Search off) · Adjudicator=Grok (Expert)
**Extra chats: 0.** Builder (ChatGPT, High), Validator (DeepSeek, DeepThink on / Search off) and Adjudicator (Grok, Expert) only.
**Capture mode:** TEXT-ONLY (owner-approved 2026-10-09 01:52 CT; `N13/TEXTONLY_PROCEDURE.md`, `runner/ingest_textonly.py`); recorded in run notes only, never in anything published.
**Target stage:** capture process (all stages)
**Frozen at CT:** 2026-10-09, before any chat of this control; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Control under test (owner list #54)
Capture as it stands: each chat reply is captured by saving the page (now: text-only paste) and extracted; every artefact is hashed and logged under the full freeze scope (#43 = REVERT keeps it).
Addition: a UI file download of the reply as a second capture channel (ChatGPT, Grok). KEEP would mean the download channel is adopted (page capture kept as a cross-check).

## Verdict convention
**KEEP = the file-download capture channel is added. REVERT = the file-download capture channel is not added.** HALT as in constitution §9.

## Arms
- BASE (the rule): the 41 logged captures in `CAPTURE_EXTRACTION_LOG_*.jsonl` and `ADJ_GROK_*_EXTRACTION_LOG.jsonl` (N13 batches b4, b5, b6, b6b and Grok adjudicators).
- VARIANT (replay): incident entries (no END at the end, END count not 1, log entry without extraction result) classified by site and cause; an incident counts as avoidable only if its cause is established as a page-capture problem in a coordinator note AND the site is download-capable (premise).

## Operational benefit predicate P1 (made mechanical before execution)
1. at least one reply-capture failure, with an established page-capture cause, on a download-capable site (ChatGPT or Grok) that a download would have avoided;
2. at least 30 logged captures;
3. dependency #43 = REVERT (frozen `C43/TERMINAL_STATE.txt`), so every downloaded file would be hashed and logged under the existing scope (no saving is claimed).
P1 MET -> KEEP (adopt as an addition, page capture kept as the cross-check). Any condition not MET -> REVERT. If the log cannot be read -> HALT.

## Disclosures and deviations (declared before the chats)
- Premise, not verified: ChatGPT and Grok UIs offer a file download of a reply; DeepSeek's does not.
- Not measured (needs the live test 54-A): byte-identity of downloaded vs saved replies, intake minutes, whether downloads add failures of their own.
- A capture is the last entry per page path; the C48 AI 2 Grok log entry has `ends_ok=false` while its extracted reply ends at its END line, and no note establishes why, so it is NOT counted as avoidable.
- The two C40 deviation notes (D-C1 backticks as U+001F in a SENT message; D-C2 re-extraction tool fix) are input-side or tool-side and are listed, not scored.
- Scratch-run adjustment before the reporting run: the 'cause established' rule was added after a first run counted the C48 Grok entry as avoidable.
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
- `scorers/score_c54.py` SHA-256 `59ce70c16eee8b8d3583caf374f894924a73b4cd67800f599eb9cb214db3dd86`
- `scorers/n16lib.py` SHA-256 `4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47`
**Seed files:**
(none)
**Result and evidence files:**
- `C54/evidence/C54_RESULTS.md` SHA-256 `d7dcea67edca73804c92a50294a80fd01a8dfc84563e1e15e7e6ea15cfa0e4d4`
- `C54/evidence/C54_captures.csv` SHA-256 `e1c52c50e64a52139824dedcf749e647465e5f16e2d1cbb878a64fc5f180c72c`

**Governance:** constitution and baselines as above; this spec is hashed in `SPEC_FREEZE_N16.sha256`.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT. Recount the incidents from the capture table and check each incident's cause against the quoted notes; say whether any other entry should count.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
