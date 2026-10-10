# C24 — Ablation specification (FROZEN)

**Ablation ID:** C24 (owner program catalog #24 "Mechanical vs Judged Population")
**Batch:** N13, added 2026-10-03 by owner approval (fresh LOCAL re-extract of the full table; local MySQL only, read-only, no internet)
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 source extraction / R population judgment
**Frozen at CT:** 2026-10-03, before the runner executed (runner `run_c24.ps1`, evaluator `eval_c24.R`)

## Control under test (owner program, catalog #24)
"Separate broad SQL extraction (mechanical envelope) from the final judged universe in R" — purpose: avoid hiding judgment in query filtering. Evidence named by the program: SQL query result counts vs the final analytic set, clearly separated. Program Pass: collapsing the envelope into R causes no subtle changes. Program Fail: loss of separation yields incorrect counts (keep rule).
In the frozen pack the SQL mechanical envelope (Envelope A of `sql/01_source_extract.sql`) is `WHERE r.STATUS = 'Open'`, and R-A/R-B then judge the population (both paths also exclude non-Open, DUPLICATE and LEGACY rows in R).

## Verdict convention
**KEEP = the ablation is adopted: the separate SQL mechanical envelope can be collapsed into R (R receives the unfiltered table and applies the population rules itself). REVERT = the separation stays.** HALT as in constitution §9.

## Exact change being tested
Two fresh local extracts, same method, same session settings, run one after the other (no other MySQL client running; the runner refuses to start otherwise):
- **X_SEP** (arm B, separation kept) = the frozen Envelope A SELECT with `WHERE r.STATUS = 'Open'` (same text as N13 C52 `E1.sql`).
- **X_FULL** (arm COLLAPSED) = the same SELECT with that WHERE line removed; `mechanical_envelope` is labelled `NONE (full table; envelope applied in R)` (the column is not read by either R path). Everything else is identical (diff in the packet).
- Declared file layout for both: the frozen extract's first line, byte-for-byte (UTF-8 BOM + header + LF), followed by `mysql --login-path=chicago311 -N -B --raw` output, ORDER BY SR_NUMBER. The file is written as `data/source/src_open_candidates.csv` of the arm and left in place (not deleted).
- Both arms use the frozen R-A and R-B code unchanged, the frozen `src_peer_stats.csv` and `src_extract_lineage.csv` (Envelope B, the peer statistics, is not collapsed; it is an aggregate, not the population envelope).
- `Q_COUNTS.sql`: SQL counts — total rows, rows per STATUS, rows with STATUS = 'Open'.
- CHECKSUM TABLE (raw_311_requests and the three src_ tables) before the first and after the last SQL step. SHA-256, bytes and data-row count of both extracts are recorded (`EXTRACTS.csv`).
- R runs: arm B then COLLAPSED, R-A then R-B, `run_*.R all` (fixtures included). Cap 4 h per run. A watchdog kills an R run if free physical memory falls below 2,048 MB (to protect the PC); that is recorded as MEMKILL.

## Known open finding N1 / OF-1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). C24 compares each path with itself across arms (COLLAPSED vs B), so N1 cannot cause a C24 mismatch.

## Known export difference (disclosed before execution; INFO only)
The frozen `src_open_candidates.csv` was exported through a PowerShell pipe that turned non-ASCII characters into '?': in N13 C52 the same Envelope A query via `--raw` differed from the frozen data rows on 109 of 245,193 lines, all in SR_TYPE text (e.g. "Snow – Uncleared Sidewalk Complaint" vs "Snow ? Uncleared…"). Both C24 arms use the same fresh export method, so this cannot affect the COLLAPSED vs B comparison. Arm B vs frozen outputs is reported as INFO only.

## Operational benefit predicate P1 (program Pass/Fail made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. full-extract data rows = SQL total rows, and separated-extract data rows = SQL count with STATUS = 'Open' (counts clearly separated and reconciled);
2. COLLAPSED R-A and R-B exit 0 (an error, the 4 h cap or a MEMKILL counts as failure: the collapsed design did not produce an analytic set);
3. COLLAPSED's 7 key outputs (RA/RB classifications, RA/RB fixture results, RA/RB portfolio counts, RB kappa grid) are byte-identical to arm B's — no subtle change in the analytic set or counts;
4. every fixture passes on both COLLAPSED paths.
REVERT side: any of 1–4 fails. Resource use (extract size, R run time, peak memory) is reported, not gated.

## Regression / HALT rules
- HALT if the CHECKSUM bracket changes or is empty (the runner then does not run R), if a SQL step exits non-zero or writes to stderr, if arm B fails or its fixtures do not all pass, or if Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 conditions 4–7 apply to arm B (the separated reference): condition 4 = COLLAPSED vs B byte equality per path; condition 5 = all fixtures pass in arm B (and COLLAPSED via P1).

## Allowed source/data scope
Local MySQL 8.0 `chicago311` (SELECT and CHECKSUM TABLE only, via the CLI with `--login-path=chicago311`) and the frozen PC pack. No internet, no download. The full extract (≈14.6M rows, several GB) stays on the PC disk.

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, quoted in full in the packet)
**Frozen pack files (preflight gating):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`
- `R-A/run_RA.R` SHA-256 `f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587`
- `R-B/run_RB.R` SHA-256 `6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd`
- `R-B/R/00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`
- `R-B/R/10_io_parse.R` SHA-256 `40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a`
- `R-B/R/20_integrity_and_classify.R` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`
- `R-B/R/40_fixtures.R` SHA-256 `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`
- `R-A/outputs/RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-A/outputs/RA_fixture_results.csv` SHA-256 `33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-A/outputs/RA_portfolio_counts.csv` SHA-256 `b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
- `sql/01_source_extract.sql` SHA-256 `f365e84a7e5d95f39a5fc19133d068e53a3aa5898f619e39db4dc6e0ba3a57b5`
- `sql/02_source_gate_checks.sql` SHA-256 `ae26edb6af074a1a61e92d241fffef0730c893fef0c8c7ae6929d3f2d50aef59`
**Runner-side files (frozen list `runner/SEEDS_C24.sha256`; preflight gating):**
- `runner/seeds/C24/CK.sql` SHA-256 `044252cb90036cae89d201a0456094e028df23ace88e6f8e985914b218c4a866`
- `runner/seeds/C24/COLLAPSE` SHA-256 `7a554e73062f88dbe57998a951dff4a782215014562f9ec63d3ff3ce98854c42`
- `runner/seeds/C24/Q_COUNTS.sql` SHA-256 `28c52916aa871354e7ce2aa0b9679dabde2cc93dd793868fba5818eac3dfa603`
- `runner/seeds/C24/X_FULL.sql` SHA-256 `b7435bee0a124a52bf3b467bd459f3cd4ea9016434813ef64f2c329fda24467e`
- `runner/seeds/C24/X_SEP.sql` SHA-256 `dbe3ee193abd9e66f2d9fe100a53c21b229b4847f67a7855cc08d82b00cd6896`
- `runner/run_c24.ps1` SHA-256 `ced2eacb5b84d7a29f353c8681cb45de3af8de19dd3bf3d2f897badae2058c7c`
- `runner/eval_c24.R` SHA-256 `a25713de587851600484b78e26745f7600f30d299dbcc0a7a1d50e06fe78048c`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above. This spec is hashed in `SPEC_FREEZE_C24.sha256` before execution.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
