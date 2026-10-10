# Chicago 311 framework ablation evidence pack (A01-A08 reference plus numbered controls C01-C54)

Evidence published as it exists. Nothing was reconstructed, re-adjudicated or edited for this publication; no verdict here was assigned by the publisher. Each terminal state is the state recorded in the control's own `TERMINAL_STATE.txt`.

## What is here
- `controls/<batch>/<control>/`: for each control, its frozen spec (`ABLATION_SPEC*.md`), baseline and constitution hashes, `EVIDENCE_FREEZE.json`, packets sent to the Builder, Validator and Adjudicator, their saved replies and reports, the mechanical evidence (`evidence/`, arms, scorers, seeds, SQL/R run logs where they exist), and `TERMINAL_STATE.txt`.
- Batches: N13, N15 (including `REAJ`, the re-adjudication of C26 and C45), N16, `C27_C33`, N17 (C49R), N18 (C24V2, an attempt), N19 (C24V3), N20 (A02R, the re-run of A02) and N21 (C40R, the re-run of C40). For C40R the mechanical result is in `controls/N21/C40R/post/C40R_POST_RESULTS.md`; its spec calls for no Builder/Validator/Adjudicator chats after a mechanical HALT, so the assembled review packets are unused.
- `controls/<batch>/_batch`, `_runner`, `_tools`: batch-level freeze and hash files and the runner scripts used.
- `SCORECARD.tsv`: one row per control with the mechanical result and the terminal state recorded in the control directory, plus notes where a later control supersedes an earlier record.
- `MANIFEST.tsv`: every published file with its original path (relative to the run root), original SHA-256 and published SHA-256. Content is byte-identical, so the two hashes match for every file; only some file names were normalised (a suffix was dropped from some reply file names; `MANIFEST.tsv` maps each).
- `EXCLUDED.tsv`: files not published, with their SHA-256 and reason (saved web-page captures: html pages and their asset folders).

## Earlier batch A01-A08
A01-A08 were published on 2026-09-19 under `docs/ablations/` (commit 5d4825c) and are not copied again. Terminal states there: A01 REVERT, A02 HALT, A03-A08 REVERT. A02 was later re-run as A02R (`controls/N20/A02R`), terminal state REVERT, which supersedes the A02 HALT; the original A02 evidence stays on record. A09 and A10 were deferred and never run, so there is no evidence for them.

## Tally of final states (numbered controls plus A01-A08, 50 controls)
KEEP 14, REVERT 35, HALT 1 (C40R: mechanical HALT, outcome BOTH_CENSORED, existing rule stays).
Superseded records kept on file and not counted: A02 HALT (superseded by N20 A02R REVERT), N13 C40 NOT_TRIGGERED (superseded by N21 C40R HALT), N13 C24 HALT and N18 C24V2 attempts (superseded by N19 C24V3 REVERT), N13 C49 HALT (superseded by N17 C49R KEEP), N15 C26 HALT-INCOMPLETE (superseded by REVERT), N15 C45 REVERT (superseded by KEEP).
KEEP means the change under test is adopted; REVERT means the existing rule stays; HALT means undecidable and the rule stays.

## Integrity
All files are published byte-for-byte; verify with `MANIFEST.tsv` (`published_sha256`). Local file paths and machine names that appear inside original evidence files were left as they were.

## Branch status
Published on a dedicated branch for review. Not merged; nothing was changed on `main`.
