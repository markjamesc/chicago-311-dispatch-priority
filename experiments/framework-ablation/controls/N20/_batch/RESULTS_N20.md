# RESULTS — N20 (A02R, re-run of A02 Known-case Fixture Gate before builders). Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok

Recorded 2026-10-10 CT. KEEP = change under test adopted; REVERT = existing rule stays (mandatory pre-builder Fixture Gate stays).

| Control | Runner / script facts | Terminal state |
|---|---|---|
| A02R | `A02R_FACTS.md`: 15/15 script checks TRUE (no verdict); no new compute | **REVERT** (supersedes the original A02 HALT of 2026-09-19; the HALT evidence stays on record) |

- Adjudicator reply: `A02R/A02R-adjudicator/adjudicator_raw.md`, ends `TERMINAL_STATE: REVERT` / `END A02 ADJUDICATION`; recorded with `runner/record_terminal.py` to `A02R/TERMINAL_STATE.txt` (REVERT).
- Grok's reason: P1 not satisfied. Fixtures passed 14/14 while production portfolios diverged by 104 labels, so the fixtures did not catch the ingestion defect and exact recon did; recon gives no independent semantic sign-off against the locked F03 expectation, and optional fixtures would remove the checkpoint against common-mode error. No HALT condition.
- Validator objections (disclosed): pre-fix recon is aggregate only (104 from portfolio counts); `A02R_FACTS.json` shows R-B F03 as null (script column-name bug; the CSV and log show STANDARD); SOURCE_GATE_REPORT (~07:30 CT) cites a Fixture Gate PASS before the receipt lock at 10:26:37 CT; SQL/diff raw outputs and original log bytes are hash-only; R-B fixture CSV has only an F14 rollup; SPEC_FREEZE file is not in the manifest.
- Evidence: `A02R/` (spec, packets, evidence, reports, `EVIDENCE_FREEZE.json`, `SPEC_FREEZE_A02R.sha256`, `PACKETS_A02R.sha256`). Original A02: `chicago-311-run/ablations/A02/` (HALT, unchanged).
