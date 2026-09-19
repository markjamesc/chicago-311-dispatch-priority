# A08 Builder — Independent First Pass

## 1. Role attestation and ablation ID

- **Role:** Builder (DeepSeek)
- **Ablation ID:** A08
- **Constitution:** 1.0, frozen
- **Target:** Stage 4 exact reconciliation / critical field set
- **Proposed change:** Shrink or loosen the critical reconciliation field list to aggregate decision counts plus a smaller label summary, replacing full exact `SR_NUMBER`-level and decision-field reconciliation.
- **Decision status:** Withheld. No terminal decision issued.
- **Barrier attestation:** I read only the frozen A08 packet. I did not infer or invent Validator or Adjudicator output. No browser AI was used; no `TERMINAL_STATE` or `ADJUDICATION` artifact was created.

## 2. Conceptual/unified diff for the proposed change

The locked full reconciliation joins R-A and R-B on `SR_NUMBER` and compares, per row, the full critical field set. The candidate replaces that with a reduced/loosened check.

### Removed or relaxed under the candidate (conceptual)

| Locked element | Candidate treatment |
|---|---|
| `SR_NUMBER` key-set equality (`n_only_ra`, `n_only_rb`) | Removed as a named gate; replaced by aggregate counts only |
| `n_inner` | Removed or reduced to aggregate decision total |
| Row-level `n_agree` / `n_disagree` | Removed; no row-level agreement check |
| Row-level classification/action labels | Removed or replaced by a smaller label summary |
| Integrity clauses (`I01_open_closed_date`, `I02_bad_clocks`, etc.) | Not stated as retained; at minimum loosened |
| `dormant_h`, `open_age_h`, `peer_n`, `peer_p75_h` | Removed as diagnostic explanation fields |
| Portfolio counts for `ESCALATE`/`INCONCLUSIVE`/`STANDARD` | Retained; this is the aggregate check |
| Fixture IDs and expected/observed results for both paths | Scope unclear in the candidate; locked baseline requires both |

**Retained:** aggregate decision counts (`ESCALATE`/`INCONCLUSIVE`/`STANDARD`), possibly a reduced label summary.

**Net conceptual effect:** The candidate stops comparing the two paths row-by-row at `SR_NUMBER` grain and stops carrying the clock/age/peer fields that explain why a row received its label.

## 3. Hard mechanical facts table

Facts below are from the frozen packet only.

| # | Hard mechanical fact | Frozen value | Source |
|---|---|---|---|
| H1 | R-A decision rows | 222,002 | `RECON_SUMMARY.csv`; `RA_portfolio_counts.csv` |
| H2 | R-B decision rows | 222,002 | `RECON_SUMMARY.csv`; `RB_portfolio_counts.csv` |
| H3 | Inner join rows | 222,002 | `RECON_SUMMARY.csv` |
| H4 | Only-R-A rows | 0 | `RECON_SUMMARY.csv` |
| H5 | Only-R-B rows | 0 | `RECON_SUMMARY.csv` |
| H6 | Row-level agree | 222,002 | `RECON_SUMMARY.csv` |
| H7 | Row-level disagree | 0 | `RECON_SUMMARY.csv` |
| H8 | R-A ESCALATE / INCONCLUSIVE / STANDARD | 131,968 / 6,377 / 83,657 | `RA_portfolio_counts.csv`; `EXACT_RECON_REPORT.md` |
| H9 | R-B ESCALATE / INCONCLUSIVE / STANDARD | 131,968 / 6,377 / 83,657 | `RB_portfolio_counts.csv`; `EXACT_RECON_REPORT.md` |
| H10 | R-B out-of-set | 23,191 | `RB_portfolio_counts.csv` |
| H11 | κ | 2 | Both portfolio files; fixtures |
| H12 | Rule version | `RA-tcd-ig-v1` | `RA_portfolio_counts.csv` |
| H13 | `T_freeze` | `2026-09-12 23:59:59 CDT` | `RA_portfolio_counts.csv`; frozen spec |
| H14 | R-A fixture results | 14/14 PASS (head shows F01–F05 TRUE) | `r_a_fixture_results.csv` |
| H15 | R-B fixture results | 14/14 PASS (head shows F01–F05 TRUE) | `r_b_fixture_results.csv` |
| H16 | Prior production defect | 104 rows, STANDARD (R-A) vs ESCALATE (R-B) | `EXACT_RECON_REPORT.md` |
| H17 | Defect cause | Naive wall clocks tagged UTC via readr; R-B POSIXct kept the wrong instant; approximately 5.0-hour systematic offset | `EXACT_RECON_REPORT.md` |
| H18 | Defect location | All 104 within 5 hours of the κ×p75 threshold | `EXACT_RECON_REPORT.md` |
| H19 | Locked rule | Character → parse as America/Chicago wall; never `force_tz`; never trust readr POSIXct for these columns | `EXACT_RECON_REPORT.md` |
| H20 | Recon join grain | `full_join` on `SR_NUMBER`; no ID copying | `STRUCTURAL_CROSS_REVIEW.md` |
| H21 | Boundary rule | `created > T_freeze` → INCONCLUSIVE; ESCALATE uses `>=` on κ×p75; F03 STANDARD at κ=2 | `STRUCTURAL_CROSS_REVIEW.md` |
| H22 | Fixture versions | `fixtures-v1-tcd-ig` | `r_b_fixture_results.csv` |
| H23 | κ in R-B fixtures | 2 | `r_b_fixture_results.csv` |

**Critical mechanical observation H24:** H8 and H9 are identical aggregates. Aggregate counts alone cannot distinguish the pre-repair state (104 disagreeing rows) from the post-repair state, because the 104 flips were compensating: 104 rows moved out of STANDARD in R-A and into ESCALATE, while the locked report's aggregates are post-repair. The pre-repair aggregates are not supplied, but the defect description establishes that row-level flips existed while the paths' row sets were the same size.

## 4. P1 assessment from frozen evidence only

**P1:** A shorter or looser reconciliation is faster/cheaper while still detecting material path defects and semantic disagreements.

**P1 fails if:** the full critical list was necessary to catch the 104-row clock-skew incident or the resulting label disagreements, including the 104 STANDARD (R-A) versus ESCALATE (R-B) rows.

Assessment:

- The 104-row incident was a row-level label disagreement with identical aggregate totals on both paths (H8, H9). The frozen A08 detection excerpt states explicitly that “aggregate portfolio counts alone could remain identical while compensating row-level flips cancel out.”
- Exact reconciliation surfaced the defect because the paths were joined on `SR_NUMBER` and compared row-level decisions (H20 and the A08 detection excerpt).
- The clock/age/peer fields (`dormant_h`, `open_age_h`, `peer_n`, `peer_p75_h`) were needed to explain the defect: the approximately 5.0-hour offset and near-threshold placement (H17, H18 and the A08 detection excerpt).
- The candidate removes the `SR_NUMBER` join, row-level label comparison, and diagnostic clock/age/peer fields, retaining aggregate counts and a smaller label summary.
- Under the candidate, the pre-repair 104-row state would have produced the same aggregate counts as the repaired state, so the candidate would not have surfaced the incident.

**P1 result from frozen evidence:** P1 is not satisfied. The frozen evidence affirmatively states that aggregate-only checks could remain identical while row-level flips cancel, and that exact reconciliation was the mechanism that surfaced the 104-row incident. The candidate removes exactly that mechanism. This is the Builder's independent finding; no terminal decision is issued.

## 5. Fixture and exact-recon implications

### Fixture implications

- The locked baseline requires both paths' fixture IDs and expected/observed results to be checked (frozen spec, critical field list). R-A and R-B each show 14/14 PASS (H14, H15).
- The candidate's retained “smaller label summary” does not state whether it preserves fixture-ID execution, per-fixture expected versus observed results, or the integrity-clause column (for example, `I01_open_closed_date` and `I02_bad_clocks` in F04/F05).
- F03 (STANDARD at κ=2 with `dormant_h=2400`, `peer_p75_h=2160`) and F04/F05 (INCONCLUSIVE via integrity clauses) are boundary/semantic cases. A reduced label summary that drops `dormant_h`/`peer_p75_h` or integrity-clause comparison loses the ability to distinguish F03-style near-threshold STANDARD from ESCALATE, and to distinguish integrity-driven INCONCLUSIVE from dormancy-driven decisions.

### Exact-recon implications

- The locked reconciliation is a `full_join` on `SR_NUMBER` with `n_inner=222,002`, `n_agree=222,002`, and `n_disagree=0` (H3, H6, H7, H20).
- The candidate removes the `SR_NUMBER` join and row-level agreement/disagreement counts. The remaining aggregate check (H8 versus H9) is already equal and would have been equal even in the defective state, according to the frozen detection excerpt.
- Therefore the candidate cannot re-establish the locked exact-recon result and cannot detect a recurrence of the 104-row class of defect.

## 6. Semantic/regression risks and unchanged surfaces

### Semantic/regression risks

1. **Loss of row-level flip detection.** Aggregate counts are invariant to compensating row-level label swaps (H8, H9 and the A08 detection excerpt). This is exactly the failure mode of the 104-row incident.
2. **Loss of `SR_NUMBER` grain.** Removing the key-set equality check (`n_only_ra`, `n_only_rb`) drops detection of row-set membership divergence. The locked value is 0/0 (H4, H5); the candidate does not preserve this gate.
3. **Loss of diagnostic explanation fields.** Dropping `dormant_h`, `open_age_h`, `peer_n`, and `peer_p75_h` removes the evidence needed to diagnose a future clock/time-zone defect (H17, H18 and the A08 detection excerpt).
4. **Loss or loosening of integrity-clause checks.** Fixtures F04 and F05 depend on `I01_open_closed_date` and `I02_bad_clocks` (H15). If the candidate drops integrity clauses, it cannot distinguish integrity-driven INCONCLUSIVE from dormancy-driven decisions.
5. **Boundary semantics at risk.** κ×p75 `>=` for ESCALATE and F03 STANDARD at κ=2 (H21) are boundary rules that a loosened label summary may not preserve.
6. **Undeclared semantic-change risk.** The candidate does not state exactly which fields are removed versus relaxed, while the frozen spec requires that exact statement. This is an incompleteness in the candidate specification as frozen.

### Unchanged surfaces (expected per frozen spec)

- SQL nonjudgment boundary — no evidence of change in the packet.
- TCD-IG rules — rule version `RA-tcd-ig-v1` (H12); no declared change.
- Exact fixture expecteds — `fixtures-v1-tcd-ig` (H22); no declared change.
- Frozen Chicago 311 Stage 4 pack — the candidate is counterfactual and does not rewrite the pack; no rewrite declared.

The `SR_NUMBER` grain is a locked recon grain (H20), but the candidate removes it; it is therefore not an unchanged surface under the candidate despite being expected to remain unchanged by the frozen spec.

### Regression rule application (factual, no verdict)

Any undeclared semantic change, missed row-set disagreement, missed label disagreement, or fixture/recon regression is a failure of the candidate. As described, the candidate removes the mechanism that caught the 104-row label disagreement and removes the `SR_NUMBER` row-set gate; these are the exact surfaces the regression rule protects.

## 7. Claim → evidence citations

| Claim | Evidence |
|---|---|
| Locked recon has 222,002 inner rows, 0 only-R-A, 0 only-R-B, and 0 disagree | `RECON_SUMMARY.csv`; H3–H7 |
| Both paths have identical aggregate portfolio counts | `RA_portfolio_counts.csv`; `RB_portfolio_counts.csv`; H8, H9 |
| R-B has 23,191 out-of-set rows | `RB_portfolio_counts.csv`; H10 |
| Both fixture suites are 14/14 PASS | `r_a_fixture_results.csv`; `r_b_fixture_results.csv`; H14, H15 |
| Fixtures cover integrity clauses and near-threshold STANDARD | `r_b_fixture_results.csv`, F03/F04/F05; H15, H21 |
| The 104-row incident was STANDARD (R-A) versus ESCALATE (R-B) | `EXACT_RECON_REPORT.md`; H16 |
| The incident was caused by time-zone/clock parsing, with an approximately 5.0-hour offset near threshold | `EXACT_RECON_REPORT.md`; H17, H18 |
| Locked rule is character → America/Chicago wall parsing; never `force_tz` | `EXACT_RECON_REPORT.md`; H19 |
| Recon is `full_join` on `SR_NUMBER`; no ID copying | `STRUCTURAL_CROSS_REVIEW.md`; H20 |
| Aggregate counts alone could remain identical while row-level flips cancel | A08-specific detection excerpt; H8, H9 |
| Exact recon surfaced the defect via `SR_NUMBER` join plus row-level decision comparison | A08-specific detection excerpt; H20 |
| Clock/age/peer fields are needed to explain the defect | A08-specific detection excerpt; H17, H18 |
| Boundary rules include `created > T_freeze` → INCONCLUSIVE and ESCALATE `>=` κ×p75 | `STRUCTURAL_CROSS_REVIEW.md`; H21 |
| `T_freeze` and κ are locked | `RA_portfolio_counts.csv`; `RB_portfolio_counts.csv`; frozen spec; H11, H13 |
| Candidate is counterfactual and must not rewrite the locked pack | Frozen spec; no rewrite declared in packet |
| Candidate must state exactly which fields are removed or relaxed | Frozen spec; candidate description does not fully itemize removed versus relaxed fields |
| RAW MANIFEST is present; the adjudicator note says not to halt for missing historical R stdout | RAW MANIFEST; adjudicator note in frozen spec |

End of Builder first pass. No KEEP/REVERT/HALT issued. No `TERMINAL_STATE` or `ADJUDICATION` artifact created. Validator first pass remains blind to this output per constitution §1.
