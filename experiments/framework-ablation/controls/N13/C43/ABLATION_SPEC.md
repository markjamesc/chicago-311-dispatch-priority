# C43 — Ablation specification (FROZEN)

**Ablation ID:** C43 (Addendum 01b, candidate #43 "Freeze scope")
**Batch:** N13 batch 6 (controls C43, C49, C44, C40; owner approval 2026-10-03 10:52 CT; built the way batch b5 was built)
**Definitions and approval (operational definitions, constitution §9):** Definitions: `ablation_plan/ADDENDUM_01_control_39.md` SHA-256 `a3bf8f6a6b27a670c8a3dde85e7fe51a53febfff298d2e70b2f3511e82de5b4f` (#40, #43) and `ablation_plan/ADDENDUM_02_pricepoint_candidates.md` SHA-256 `5d8756efbed04f168f3d53e2d8fab8064503752bd04f8c61b670cf81f9c757a6` (#44, #49; #40 evidence). Owner approval of #43, #49, #44, #40: 2026-10-03 10:52 CT (blockers in `N13/SELECTION_N13.md` SHA-256 `f6fd85c5137f27710a1b38e24836b3b473a720b5f221f57a38c43b8f11547c8f`). Owner rulings batch 01 (`OWNER_RULINGS_BATCH_01_DECISIONS.md` SHA-256 `9c2f58098581e31eae81d5742d6784da454fc994e4fc851ca0bc93546f6243ba`) apply where cited (41A depth gate, 48A, 53A clock rule).
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Extra chats:** none. The test is a box-side audit of the coordinator's own trail, run by an R auditor on the PC from a frozen index; only the standard Builder/Validator/Adjudicator chats follow.
**Usage priority (owner):** SuperGrok usage is the scarcest resource; extra chats are kept to the smallest number the test validly allows, and no extra chat uses Grok.
**Target stage:** All stages (governance of the coordinator's freeze/hash trail)
**Frozen at CT:** 2026-10-03, before the reporting run executed (runner `runner_b6/run_batch_v6.ps1`, evaluator `runner_b6/eval_b6.R`; R only, no MySQL, no git)

## Control under test (Addendum 01b #43)
Rule as it stands: every intermediate capture, failed copy and partial reply is frozen, hashed and logged. Variant: hash only gate-feeding artifacts (final captures, deployed code, outputs and gate evidence). Addendum metric: "whether any audit or reconstruction question needed an intermediate artifact". SELECTION_N13 blocker: "only possible as a box-side audit of the coordinator's own trail, and 'needed' is judgment-laden" — so this spec fixes a mechanical definition of "needed" before execution.

## Verdict convention (Addendum 01b)
**KEEP = narrow the freeze scope (no audit or reconstruction record needed an intermediate artifact). REVERT = keep the full scope (one did).** HALT as in constitution §9.

## Exact change being tested
- **Trail (frozen input):** every file of the coordinator's two run trees on the box, `runs/N15/` and `runs/N13/`, with modification time ≤ **2026-10-03 10:52:00 CT** (the owner's approval instant; nothing built for this batch is in it). `make_seeds_b6.py` writes `seeds/C43/TRAIL_INDEX.tar` (deterministic): `INVENTORY.tsv` (run-qualified path, bytes, SHA-256, mtime of every trail file), `lists/<path>` (verbatim copies of every hash list: `*.sha256`, `*.jsonl`, `*FREEZE*.json`, `*_ARM_MANIFESTS.txt`) and `records/<path>` (verbatim copies of every audit/reconstruction record, `RECORD_RULES.tsv`). The auditor re-verifies every copy against INVENTORY before use.
- **Hashed artifacts:** every (path, SHA-256) pair in any hash list (text lists, arm-manifest lines `arms/<arm>/MANIFEST :: sha bytes path`, JSON/JSONL keys `sha256` / `*_sha256`). Paths are resolved against the inventory; a listed path that is not on the box (PC-side arm files that were never pulled) is kept with its logical path and reported as unresolved.
- **Classes (`CLASS_RULES.tsv`, first match wins):** I1 scratch (`_smoke*`, `_preflight*`, `_interim*` folders, `smoke_*.tgz`); I2 superseded (`_superseded*` folders, `.bak`, `.HEAD.vN.txt`, `evidence_first_*` folders, `.partial`); I3 transfer bundles (`.tar`, `.tgz`, `.zip`, `pull_*.lst`); I4 saved-page assets (`*_files/`); I5 assembly inputs (`.HEAD.txt`, `.TEMPLATE.txt`, whose full text is inside the assembled hashed packet). **G0 = everything else** (gate-feeding: final captures, deployed code and seeds, frozen pack files, arm outputs, specs, packets, evidence, results, terminal states). Variant scope = hash class G only.
- **Records (`RECORD_RULES.tsv`):** R1 narrative (`RESULTS_*.md`, `SUMMARY_*.md`, `TOOLS_PATCH_LOG.txt`, `PROGRESS_*.md`, `PLAN_*.md`, `SELECTION_*.md`); R2 re-adjudication (`N15/REAJ/**/*.md|txt`); R3 disclosure (`PRECHECK_*.json`, `README*`, `INTERIM.txt`, `REAJ_RECORD.txt`). A record that is itself class I is not scanned.
- **"Needed" (mechanical definition, declared now):** a class-I hashed artifact is NEEDED when a scanned record cites it (a) by SHA-256 — the full hash or a prefix of ≥ 8 hex characters — and no class-G artifact has the same SHA-256 (if a gate-feeding copy with the same bytes exists, the narrowed scope still holds that hash, so the citation is reported as `hash_but_G_copy_exists` and not counted); or (b) by its path inside the run (either slash), or by its file name when that name is unique in the trail, ≥ 12 characters and not the name of a class-G artifact; or (c) by the name of the intermediate folder that holds it (`_smoke*`, `_preflight*`, `_interim*`, `_superseded*`, `evidence_first_*`).
- **Disclosed limits of the definition:** citation is an upper-bound proxy for "needed" (a record may mention an artifact without the audit having depended on it), and silent use (an audit that read an intermediate file without writing its name or hash) is invisible to it. The trail is the box-side copy only (PC-only files enter as hash-list entries, not as files). Records are coordinator-written; chat replies are not scanned as records.

## Known open finding N1 / OF-1 (disclosed before execution; frozen pack not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h; mod_ts 2022-11-06 01:00:00) and SR25-02017553, SR25-02017556 (open_age_h; created 2025-11-02 01:19 / 01:21). Their labels agree. All three clocks fall in the repeated fall-back hour. Cause, confirmed on the PC (R 4.6.1, 2026-10-03, read-only probe): R-B's base `as.POSIXct(..., tz = "America/Chicago")` reads a repeated-hour wall time as the first occurrence (CDT; 2025-11-02 01:30 → epoch 1762065000), while R-A's lubridate parse reads it as the second occurrence (CST; epoch 1762068600). It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). The owner's 53A ruling (clock rule: repeated hour = first occurrence, daylight time, on both paths) makes R-B's reading the conforming one; R-A's frozen output departs from it on these 3 rows. C43 audits the coordinator's hash trail only; it reruns no R path and reads no clock value, so N1 cannot change any C43 number.

## Arms (runner v6, `seeds/C43/AUDIT`)
- **AUDIT**: `Rscript c43_audit.R TRAIL_INDEX.tar CLASS_RULES.tsv RECORD_RULES.tsv outputs` on the PC (R 4.6.1). Runs a self-test first (planted intermediate cited by hash prefix must be found; a hash with a gate-feeding copy must not be counted; class rules must give the declared classes on 6 known paths); aborts if it fails. Writes HASHED_ARTIFACTS.csv, CITATIONS.csv, NEEDED.csv, SUMMARY.txt, AUDIT_RESULT.txt, SELFTEST.txt, UNHASHED_TRAIL_FILES.txt.

## Operational benefit predicate P1 (made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. no class-I artifact is NEEDED by hash (rule a);
2. no class-I artifact is NEEDED by path or file name (rule b) and no intermediate folder is cited (rule c);
3. harness validity: the auditor self-test passes.
REVERT side: 1 or 2 fails (an audit or reconstruction record needed an intermediate artifact). If 3 fails: HALT (harness defect).
Cost (reported, not scored): number and bytes of class-I hashed artifacts the narrowed scope would no longer hash.

## Regression / HALT rules
- HALT if the audit run is missing or fails, if an index copy does not match INVENTORY, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 conditions 4–5: the audit writes nothing into any pipeline; its known-answer cases are the self-test (declared now). Conditions 6–7: the trail is only read (copied into a frozen index).

## Allowed source/data scope
The coordinator's own box trail (N15 + N13, cut at 10:52:00 CT), frozen into the index. No MySQL, no internet, no new data.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
**Runner-side files for this control (frozen list `runner_b6/SEEDS_b6.sha256`; preflight gating):**
- `runner_b6/seeds/C43/ARMS.tsv` SHA-256 `25d004971a97c26af0e468dc50bb45d3788a8efd9eb1692cdcd80ac938a84d67`
- `runner_b6/seeds/C43/AUDIT` SHA-256 `b0fcc932c071cf7d9a8ebe459130b898fcd94797157d76d6ad106068c7e5c1a3`
- `runner_b6/seeds/C43/CLASS_RULES.tsv` SHA-256 `f19694e21b94dc5b02759767a5fd4eae121302c70c6f9d140ad2c3f7bbf1e794`
- `runner_b6/seeds/C43/RECORD_RULES.tsv` SHA-256 `4a56ec8da726a0edda28d0302f8ba2f29d2490f65a50075474cab7cc40ffc220`
- `runner_b6/seeds/C43/TRAIL_INDEX.tar` SHA-256 `0fcc3b64ac8d464abec4cdaa33315d7c3009111a9cf5c54a1967897e1fb4c9c9`
- `runner_b6/seeds/C43/TRAIL_INDEX_INVENTORY.tsv` SHA-256 `cbe2903cbcb915f6e708efb075146a060a372a596b217af16d4b060c1957b6a9`
- `runner_b6/seeds/C43/c43_audit.R` SHA-256 `4c792370f92be028cab6d92b585b17851a4d9689dc2ee97926e1a86e884e0406`
- `runner_b6/eval_b6.R` SHA-256 `6f5f25181d1033b7162a393b8dc0fd1e2a65cee094cbddf9d9244f707526bb1a`
- `runner_b6/run_batch_v6.ps1` SHA-256 `5b97cd2a0520f6ea88f4bf220b3fca0756292ff352eebf28991e52d9d21254fb` (the runner; carries the preflight list above)
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above; definitions files as above. This spec is hashed in `SPEC_FREEZE_b6.sha256` before the reporting run.
**Trail index:** `runner_b6/seeds/C43/TRAIL_INDEX.tar` (hash above) holds every input the auditor reads; `TRAIL_INDEX_INVENTORY.tsv` is the same inventory, beside it for reading. (The frozen-pack preflight runs for every batch; C43 reads none of the pack.)
## Pre-execution check (disclosed)
The predicate text (`eval_b6.R`) and every harness script were hashed in `SEEDS_b6.sha256` before any PC execution. The complete runner was exercised on the PC in scratch folders (non-reporting, NON_REPORTING.txt in each): `N13\_preflight_b6` (runner tar v1) stopped at the preflight because the C49 marker file `seeds/C49/DELIVERY` collided with the folder `seeds/C49/delivery/` on Windows (case-insensitive paths); nothing executed. The marker was renamed `DELIVCHK` (runner and evaluator updated; first builds kept in `runner_b6/_superseded_v0` and `_superseded_v1` with README). `N13\_preflight_b6_2` (runner tar v2) was killed during the C43 audit when the remote session dropped (no result). `N13\_preflight_b6_3` (runner tar v2, SHA-256 7e4dac855c3a640f311856928c9666e50ce8d464a57273f645a4a337d978e7fc, started detached) ran to completion at 11:27:46 PC time (4.18 min, preflight PASS). Before that, the R scripts were dry-run on the box (R 4.5) with synthetic replies for the post-chat scorers; a Q-answer parsing bug in c49_score.R was fixed then. C43 in the scratch run: self-test PASS; needed_by_hash = 10, needed_by_path_or_name = 2, needed_by_directory = 3 (the same numbers as the box dry-run, which ran after the decision rule was fixed in PROGRESS_b6.md 11:05 CT). No arm, threshold, seed or predicate was changed after that check.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
