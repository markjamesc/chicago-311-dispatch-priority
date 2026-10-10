# A02R — Ablation specification (FROZEN before any A02R chat)

**Ablation ID:** A02R (re-run of A02, "Known-case Fixture Gate before builders"). Batch N20. Owner-authorised 2026-10-10 ("finish A02").
**Supersedes nothing.** The original A02 (2026-09-19, Builder=DeepSeek, Validator=Grok, Adjudicator=ChatGPT, terminal HALT twice) and all its evidence stay on file unchanged: `chicago-311-run/ablations/A02/`, spec `ORIGINAL_A02_ABLATION_SPEC.md` (copied here byte-for-byte).
**Design: identical to A02.** Same change under test, same benefit predicate P1, same critical mechanical facts, same expected-unchanged surfaces, same regression rule, same constitution (v1.0, hash in `SPEC_FREEZE_A02R.sha256`), same baseline framework hashes.

## Why A02R exists (disclosure)
The original A02 returned HALT, twice (ChatGPT as Adjudicator). The substantive finding was not KEEP; the HALT was triggered by Constitution §3/§9 "required raw evidence is missing": the packet carried result tables and a markdown recon summary but not the raw production stdout, the fixture runner source, the fixture-freeze ordering receipt, or the code that produced the numbers. A later diagnosis (`A02/HARNESS_DIAGNOSIS.md`) concluded the evidence packet, not the ablation, was deficient.

## What changes in A02R (the only changes)
1. **Roles rotated to the current protocol:** Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok (original: DeepSeek/Grok/ChatGPT). Builder and Validator are fresh chats that never saw the original A02 packs, reports or verdict; the Adjudicator is told the history (HALT, why) in a disclosure block.
2. **Evidence packet completed.** Added to the original `_raw_evidence` set: (a) the raw production stdout/stderr logs of the 2026-09-19 12:56 CT first production run (pre-fix) and the 13:46 CT tz-fix re-run, in original bytes plus a decoded text copy; (b) the R-A and R-B production source and the R-B module source, including both fixture runners (R-A `build_fixture_pack`/`run_fixtures` in `run_RA.R`; R-B `R/40_fixtures.R`); (c) the recon scripts `run_recon.R`, `diagnose_disagree.R`; (d) the Fixture Gate receipt (locked 2026-09-19 10:26:37 CT, i.e. before the 12:56 CT production run) and the locked fixture pack; (e) SHA-256 of every file (`EVIDENCE_MANIFEST_A02R.sha256`); (f) a deterministic mechanical facts table produced by `runner/a02r_facts.py` from those files.
3. **No new compute.** Nothing is re-executed on the PC. The raw logs are the original run's own output. No code, fixture, or expected value is modified or re-run; A02R is an evidence-complete re-adjudication of the same experiment under the rotated roles.
4. **Known gaps, disclosed up front (not hidden):** (i) the 104 SR_NUMBERs of the first run's disagreement were not saved (only the post-fix empty list `RECON_DISAGREE_IDS.csv` and the 104 count derived from the portfolio counts 132,072 vs 131,968, plus the Builder-reported diagnostics in the original A02 which A02R does not give the new Builder/Validator); (ii) the PowerShell log files mix UTF-8 and UTF-16 bytes, the decoded copy strips NULs and is a convenience only; (iii) `stage-03/fixtures/*.json` hold only F01–F12 and a README still labelled v0.1-PENDING; F13/F14 live in the fixture runner code; the locked pack md and Fixture Gate receipt are authoritative; (iv) the Fixture Gate receipt carries the lock time but the pack has no external timestamp authority.

## Operational benefit predicate P1 (unchanged from A02)
Removing mandatory pre-builder Fixture Gate reduces steps while detection coverage remains equal: Chicago's production clock-skew defect (104-row disagree) and construct boundaries (F03→STANDARD) would still have been caught by exact recon / other controls alone, with no increase in shipped wrong labels.
Benefit **fails** if evidence shows Fixture Gate was necessary for construct sign-off (e.g. F03) or that optional fixtures would have allowed greenwash / silent design drift.

## Critical mechanical facts (unchanged; now checked by script, `A02R_FACTS.md`)
- Fixture results: R-A 14/14, R-B 14/14, F03→STANDARD
- Production first recon: 104 disagrees; post-fix: 0
- Fixtures use in-process clocks (did not catch CSV tz bug)

## Expected unchanged
Chicago frozen pack; κ/T_freeze; SQL nonjudgment; dual-path (A01 REVERT already kept).

## Regression
Must not authorize rewriting fixtures after fail to match code.

## Verdict convention
KEEP = the Fixture Gate may be made optional / post-hoc. REVERT = mandatory pre-builder Fixture Gate stays. HALT per Constitution §9 only. Per the harness note: if Builder and Validator agree on hard numbers, the raw evidence manifest is present, P1 fails and no §9 condition holds, the result is REVERT.
