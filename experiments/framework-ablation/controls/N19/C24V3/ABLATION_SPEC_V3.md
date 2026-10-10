# C24 v3 — Ablation specification addendum (FROZEN before launch)

**Ablation ID:** C24 v3 (catalog #24 "Mechanical vs Judged Population"), batch N19. Owner-authorised 2026-10-10 ("okay, let us do that" = build and run the chunked collapsed arm).
**Supersedes nothing.** N13 C24 (HALT, harness defect) and C24 v2 / N18 (resource failure) stay on file unchanged. v3 is the same ablation re-run with a different R-side reading strategy for the COLLAPSED arm only.
**Design: identical to N13 C24 and C24 v2** (control, KEEP/REVERT convention, arms X_SEP/X_FULL, predicate P1, HALT rules, frozen data pack hashes, constitution and baseline hashes, SQL seeds). See `runs/N13/C24/ABLATION_SPEC.md` and `runs/N18/C24V2/ABLATION_SPEC_V2.md`.

## Why v3 exists (disclosure)
In C24 v2 (N18) the SQL phase and arm B completed cleanly (checksum bracket PRE = POST). The COLLAPSED arm R-A and R-B read the full 14,635,395-row extract (8,167,123,771 bytes) into memory at once and were killed by the unchanged 2,048 MB free-RAM guard (MEMKILL), twice:
- attempt 1 (v2 main run, ~05:50 CDT 2026-10-10): R-A MEMKILL after 143 s, peak 19,346 MB; R-B MEMKILL after 130.1 s, peak 19,321 MB;
- attempt 2 (R steps only, 10:53 CDT 2026-10-10): R-A MEMKILL after 142.4 s, peak 20,128 MB; R-B not started (runner stops after a R-A kill).
The full-table version therefore does not fit this PC (32 GB RAM). This is a resource failure, not a finding about the correctness of collapsing. Both MEMKILL attempts, their logs, exit files and fixture outputs are preserved untouched in `N18\C24V2\` (including `attempt1_collapsed\`) and are part of the evidence for v3.

## What changes in v3 (the only changes)
1. **COLLAPSED arm R-A and R-B read the full extract in row chunks** (readr `read_tsv_chunked`, 250,000 rows per chunk, all columns read as character) and apply the unchanged frozen judgment functions to each chunk. Only the `run_production()` function differs from the frozen scripts (`run_RA_chunked.R`, `run_RB_chunked.R`). `classify_open_rows()`, `rb_normalize_open()`, `rb_judge_rows()`, `rb_portfolio_counts()`, `rb_kappa_grid_counts()`, all constants, parsing rules and the fixture code are byte-for-byte the frozen code (the four R-B module files are the frozen files, hashes verified in preflight).
2. **Exactness argument.** Every judgment is a function of one row plus the small peer-statistics table (`src_peer_stats.csv`, 104 types, loaded once, never derived from the chunked data): population filter (STATUS/DUPLICATE/LEGACY), clock parsing, integrity clauses, peer join, dormancy/threshold decision. There is no ranking, no dedupe across rows, no group statistic computed from the extract, no row-order dependence. Therefore the whole-table output equals the concatenation of the per-chunk outputs (same row order), and every count is the sum of chunk counts. Columns are read as character in both designs for all columns the code uses (clock columns were already forced to character; the remaining used columns are converted with `as.character`/`str_trim` before use), so type guessing cannot differ between chunks.
3. **Outputs:** same 7 key files, same names, same format. Classification files are written chunk by chunk to a `.partial` file that is renamed only on completion; counts files are written once from summed counts.
4. **Memory:** the 2,048 MB MEMKILL watchdog is UNCHANGED. The pre-run free-RAM wait is lowered from 19,968 MB to 6,144 MB because the chunked run needs only a few GB. 4 h cap per R run unchanged. No tolerance change; predicate P1 unchanged (COLLAPSED exits 0 and its 7 key outputs are byte-identical to arm B's).
5. **Carried unchanged from C24 v2:** SQL extracts (B and COLLAPSED, verified by sha256 against `EXTRACTS.csv` in preflight; the COLLAPSED extract is hard-linked, not copied), SQL count query results, CHECKSUM bracket (matched), arm B R-A/R-B outputs and run records. Arm B is not re-run.
6. **Names:** work dir `...\ablation-runs\N19`, output `C24V3`, log `RUNNER_LOG_C24V3.txt`, results `C24V3_RESULTS.md`, `C24V3_arms.csv`, `C24V3_EVIDENCE.sha256`; runner `run_c24v3.ps1`, evaluator `eval_c24v3.R`, seeds list `SEEDS_C24V3.sha256`.

## Equivalence proof performed before freezing (evidence in `N19\test_evidence\`)
- **T1, arm-B extract (245,193 rows, 5 chunks of 50,000):** chunked R-A and R-B outputs vs the whole-table frozen-code outputs recorded in C24 v2 arm B: **all 7 key outputs byte-identical (sha256 equal)**.
- **T2, 1,245,193-row sample** (first 1,000,000 data rows of the full extract + all 245,193 arm-B rows), whole-table frozen code vs chunked code with 77,777-row chunks (chunk boundaries not aligned to anything): **all 7 key outputs byte-identical (sha256 equal)**; 238,746 decision rows, kappa grid identical.
- Hashes: `TEST_OUTPUT_HASHES.sha256`; run times: `tests_log.txt`.
The proof covers the code path; it does not prove behaviour on the 13.4M rows not in the sample, which is what the v3 run itself tests (P1 compares against arm B).

## Roles / tasks
Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok, same tasks as N13 C24. Verdict convention unchanged: KEEP = collapse the envelope into R; REVERT = separation stays; HALT per constitution §9. Reviewers must be told the COLLAPSED arm ran chunked and why; chunking is a harness change, not a design change.

## Frozen runner-side hashes
`runner/SEEDS_C24V3.sha256` (verified by preflight). Spec hash in `SPEC_FREEZE_C24V3.sha256`.
