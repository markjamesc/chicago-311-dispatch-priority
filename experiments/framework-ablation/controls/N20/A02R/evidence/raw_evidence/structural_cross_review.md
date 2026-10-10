# Structural Cross-Review — Chicago 311 Stage 4 Method B

**Verdict:** **PASS**  
**When:** 2026-09-19 ~14:00 CT  
**design_version:** `stage3-v1-tcd-ig` (TCD-IG B-leaning hybrid)  
**fixture_version:** `fixtures-v1-tcd-ig`  
**Builders:** R-A single-file `run_RA.R`; R-B modular `R/00_config.R` + `10_io_parse.R` + `20_integrity_and_classify.R` + `40_fixtures.R`

## Independence attestation

- Separate trees; no shared judged helper modules or copied ID lists between paths.
- Distinct construction: R-A tidyverse pipeline; R-B base/data.frame rule-table style with named integrity clauses I01–I06.
- First production judged outputs compared only at recon (barriers removed after exact recon PASS).

## §10.6 checklist

| Risk | Finding | Status |
|------|---------|--------|
| Wrong date / tz semantics | First run: ~5h CDT skew from readr UTC-tagged naive ISO + asymmetric POSIXct handling → 104 near-threshold label flips. **Fixed:** both paths force clock cols to character and parse as America/Chicago wall. Re-run recon 0 disagrees. | PASS (after repair) |
| Status / open misinterpretation | Both require Open (normalized); non-Open excluded from decision set. | PASS |
| Accidental exclusion | DUPLICATE / LEGACY true-like excluded; envelope Open candidates ~245k → decision 222,002 both paths. | PASS |
| Duplicate / legacy handling | Truthy parsers on both; fixtures F07/F08 cover. | PASS |
| Parse / null handling | Unparseable clocks → INCONCLUSIVE; fixtures F13. | PASS |
| Boundary errors | T_freeze locked; created > T → INCONCLUSIVE; κ×p75 threshold with `>=` for ESCALATE. F03 STANDARD at κ=2 locked. | PASS |
| Judged logic in SQL | SQL comments forbid labels; Source Gate checks absence of label columns; peer aggregates only. | PASS |
| Envelope = final universe | SQL delivers Open mechanical envelope; R applies eligibility/integrity. | PASS |
| Source-field misunderstanding | type_key = coalesce(short_code, type); dormant = T − mod_ts; open_age diagnostic only. | PASS |
| Post-hoc ID manipulation | Recon is full_join on SR_NUMBER; no ID copying between paths. | PASS |
| Shared judged helpers | None. | PASS |

## Exact recon evidence

- n_inner = 222,002; n_agree = 222,002; n_disagree = 0 (post-fix).
- Portfolio identical at κ=2: ESCALATE 131,968 · INCONCLUSIVE 6,377 · STANDARD 83,657.
- Fixtures: R-A 14/14, R-B 14/14 (F03 → STANDARD).

## Residual notes (non-blocking)

- Parent-SR integrity wording differs slightly in clause names (R-B `I05_parent_sr_present` vs design “orphan”); production labels still matched exactly — treat clause-string vocabulary as audit text, not a recon-critical field mismatch.
- Old draft cross-review (age-threshold / fixtures-v0.1) is superseded by this document.

## Freeze readiness

Analytical chain ready for owner **Validation Gate**. Do not start Stage 5 until Validation Gate PASS + R Workflow Gate PASS.
