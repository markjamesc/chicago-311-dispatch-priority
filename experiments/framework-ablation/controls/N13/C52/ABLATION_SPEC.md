# C52 — Ablation specification (FROZEN)

**Ablation ID:** C52 (Addendum 02, candidate #52 "Concurrent raw-side Source Gate queries")
**Batch:** N13 batch 4 (controls C51, C46, C52; the only three of the 25 open controls that qualified under the owner's 2026-10-03 rules: no new data pulls, no design chat, no owner ruling, mechanical threshold)
**Constitution version:** 1.0 — `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 Source Gate scheduling (cut/relax candidate)
**Frozen at CT:** 2026-10-03, before the runner executed (runner `run_batch_v4.ps1`, evaluator `eval_b4.R`)

## Control under test
The coordinator runs the extract queries and then the raw-side Source Gate queries serially. Source Gate itself was retained by A04 (REVERT); #52 removes no gate item. Hypothesis: on a static snapshot, running the gate concurrently with the extract gives identical results in less wall-clock time.

## Verdict convention (cut/relax candidate, Addendum 02)
**KEEP = the serial ordering can be relaxed: the gate queries may run concurrently with the extract queries (under the checksum bracket). REVERT = serial ordering stays.** HALT as in constitution §9.

## Exact change being tested
Read-only forms of the frozen SQL (`runner/seeds/C52/`, generated mechanically from the frozen `sql/01_source_extract.sql` and `sql/02_source_gate_checks.sql`; diffs in the packet):
- **E1** = Envelope A SELECT (src_open_candidates rows), **E2** = Envelope B as one CTE statement (peer stats); no DDL, no writes.
- **G** = the 17 gate items, each frozen `INSERT INTO src_gate_results … SELECT …` run as its SELECT, in the frozen order. G reads raw_311_requests and the existing frozen extract tables.
- **CK** = `CHECKSUM TABLE` on raw_311_requests, src_open_candidates, src_peer_stats, src_extract_lineage, before and after every arm.
- Each chain runs through the MySQL CLI (`--login-path=chicago311 -N -B --raw`, one session per chain). SER: chain E then chain G. PAR: both chains launched at once.
- Disclosed difference from the frozen run: the frozen extract wrote the src_ tables and the gate then checked them; here nothing is written, so G checks the existing frozen tables while E1/E2 recompute the extract in parallel. Whether E1/E2 match the frozen CSVs byte-for-byte is reported as INFO only (export flags differ).

## Known open finding N1 / OF-1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. It is open finding OF-1 in the coordinator's RESULTS_N15.md (coordinator decision 2026-10-03 05:08 CT: record and disclose, do not change the frozen pack). C52 runs no R code, so N1 does not enter any C52 number.

## Arms (runner v4, `seeds/C52/SQLCONC`)
SER_1, PAR_1, SER_2, PAR_2 (interleaved to spread drift).

## Operational benefit predicate P1 (Addendum 02 #52 success metric, made mechanical before execution)
**P1 satisfied (KEEP side)** when all hold:
1. every chain exit is 0 in every arm and every .err file is empty;
2. G returns 17 rows with 15 PASS / 0 FAIL / 2 INFO (the frozen Source Gate result, SOURCE_GATE_PASS 15/0/2) and G output is byte-identical across arms;
3. E1 and E2 outputs are byte-identical across arms;
4. median PAR wall-clock ≤ 0.80 × median SER wall-clock.
REVERT side: any of 1–4 fails.

## Regression / HALT rules
- **HALT** if the CHECKSUM TABLE bracket is missing or changes anywhere (snapshot not static), or Builder and Validator disagree on a hard number in the RESULTS file.
- Constitution §7 condition 4 = byte identity of E1/E2/G across arms; condition 5: the SQL gate has no fixture harness, so no mandatory fixture applies (declared now); condition 7 = the 15/0/2 gate result (frozen `sql/stage4_extract_run.log`: A 245193/245193, peer types 104, peer rows 1,881,338).

## Allowed source/data scope
Local MySQL 8.0 (`chicago311`, read-only SELECT and CHECKSUM TABLE through the CLI) and the frozen PC pack. It re-reads the local 8.3 GB raw table several times per arm: no internet, no new data, local disk only. Expected run time several hours (the frozen extract took 77 min and the gate 39 min).

## FROZEN REFERENCE HASHES (every hash a KEEP condition relies on; each is re-verified by the runner preflight, which is quoted in full in the packet)
**Frozen pack files (preflight gating; any mismatch = no arm runs):**
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`
- `sql/01_source_extract.sql` SHA-256 `f365e84a7e5d95f39a5fc19133d068e53a3aa5898f619e39db4dc6e0ba3a57b5`
- `sql/02_source_gate_checks.sql` SHA-256 `ae26edb6af074a1a61e92d241fffef0730c893fef0c8c7ae6929d3f2d50aef59`
**Runner-side files for this control (frozen list `runner/SEEDS_b4.sha256`; preflight gating):**
- `runner/seeds/C52/ARMS.tsv` SHA-256 `5204d57056a683ad24f138cc52ea518b72bc0297287da113d81880602e2bca69`
- `runner/seeds/C52/CK.sql` SHA-256 `23f177f32f9886328ac2eef2690dbf6cdd48261597ba5bb34c29b982b14e181e`
- `runner/seeds/C52/E1.sql` SHA-256 `b305fe4b01f3668424e96f71f5974c98d9102d9425d81f0116c1d1b585a578a9`
- `runner/seeds/C52/E2.sql` SHA-256 `51a0c414169aa57e6f6ffb6550bd9b121a5a027ebf3bccfa8e9b865b372251d7`
- `runner/seeds/C52/G.sql` SHA-256 `3bd63f1138aaeb52d0c9eaf40667171c41b8efb65104488821056fefa20e7f25`
- `runner/seeds/C52/SQLCONC` SHA-256 `9588ddebbfc9b050d5ab0f53921637af2f2270a248fa052164645f049d23fd6c`
- `runner/run_batch_v4.ps1` SHA-256 `6b857ef067967e9bec04e8cab7009b69e056c08245f520816f1ffd979b087d7e`
- `runner/eval_b4.R` SHA-256 `cd5ec767a4d2158830ccd2ba679a0619f668bf5d3f354d9e7a54648e1dab9396`
**Governance:** constitution SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`; baseline frameworks as above. This spec is hashed in `SPEC_FREEZE_b4.sha256` before execution.
**Gate reference:** frozen `sql/02_source_gate_checks.sql` and `sql/01_source_extract.sql` (above); E1/E2/G/CK are byte-checked by the preflight via the SEEDS list.

## Pre-execution check (disclosed)
Before this spec was frozen, `EXPLAIN` forms of E1, E2 and all 17 G statements were run on the PC (syntax/plan check only; no data returned, nothing written); all exited 0.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
