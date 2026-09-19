# A07 Validator — Independent First Pass (DeepThink)

## Scope and method

I treated the attached `A07_VALIDATOR_PASTE.txt` as the complete frozen validator packet and did not use or infer any Builder report. I independently checked the mechanical facts visible in the packet, then assessed P1. The terminal adjudication is intentionally withheld.

The counterfactual proposes replacing the TCD-IG age construction with raw open age computed directly from `T_freeze - CREATED_DATE`, removing type-conditional dormancy, or simplifying it only if mechanical equivalence is explicitly documented. The frozen baseline is `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, `T_freeze=2026-09-12 23:59:59 America/Chicago`, κ=2.

## Hard facts recomputed from the frozen excerpts

### Reconciliation

From `RECON_SUMMARY.csv`:

- `n_ra = 222002`
- `n_rb = 222002`
- `n_inner = 222002`
- `n_only_ra = 0`
- `n_only_rb = 0`
- `n_agree = 222002`
- `n_disagree = 0`

The shown baseline reconciliation is exact on the inner set, with no one-sided IDs or disagreements.

### Portfolio counts

`RA_portfolio_counts.csv` reports:

- `n_decision = 222002`
- `n_ESCALATE = 131968`
- `n_INCONCLUSIVE = 6377`
- `n_STANDARD = 83657`
- `kappa = 2`
- `rule_version = RA-tcd-ig-v1`
- `t_freeze = 2026-09-12 23:59:59 CDT`

`RB_portfolio_counts.csv` reports the same in-set counts and κ=2, plus `n_out_of_set = 23191`. The RA excerpt does not expose an out-of-set field, so the full portfolio files should be checked for representation consistency.

### Fixtures and arithmetic

Fixtures F01–F14 are shown as executed and passing in both result excerpts. F14 is represented at `SR_NUMBER` grain as two independent labels (`F14A`/`F14B` in R_B), both STANDARD.

The critical F03 row is:

- expected/observed: STANDARD/STANDARD;
- `dormant_h = 2400`;
- `peer_p75_h = 2160`;
- κ=2;
- integrity clause: `within_type_dormancy`;
- R_B reason: `S_dormant_lt_kappa_p75`.

The arithmetic is coherent for the locked TCD-IG construct: κ × peer p75 = 2 × 2160 = 4320 hours, and 2400 < 4320, yielding STANDARD. Other shown checks are consistent: F01 has 480 ≥ 2×168 and is ESCALATE; F11 has 192 ≥ 2×72 and is ESCALATE; F02 has 24 < 2×168 and is STANDARD; F10 has 96 < 2×72 and is STANDARD. F04/F05/F06/F09/F13 are integrity-driven INCONCLUSIVE cases, while F07/F08/F12 are OUT_OF_SET. The evidence repeatedly uses `dormant_h`, `peer_p75_h`, κ, and integrity clauses rather than raw-open-age values.

The raw manifest lists 16 SHA-256 entries, but the packet does not include most referenced file bodies. The hashes therefore cannot be independently recomputed from the packet alone.

## P1 assessment

P1 requires both a demonstrated interpretability/complexity benefit and no material change to Stage 4 PASS status or locked fixture semantics. Neither arm is established by the packet.

The benefit side is not mechanically measured: there is no candidate SQL/R implementation, deterministic diff, removed-field list, line-count or complexity comparison, or explicit equivalence note. The constitution permits simplification only when it is mechanically equivalent and explicitly documented; that documentation is absent.

The non-regression side is also unproven. The packet supplies only TCD-IG baseline fixture results. It does not supply raw `CREATED_DATE` values, computed `open_age_h`/`open_age_days`, candidate outputs, or a candidate comparison against the locked thresholds. In particular, F03's locked STANDARD result is tied to `within_type_dormancy` and `S_dormant_lt_kappa_p75`. Raw open age might happen to equal `dormant_h` for F03, but that is not shown; it could differ when the type-conditional construction matters. The same gap applies to the other age-sensitive fixtures. No candidate Design Gate result for `open_age_days >= 14` or Stage 4 status content is present.

Accordingly, the baseline is internally coherent, but the proposed raw-age candidate and its equivalence are absent. P1 is not established from the frozen packet.

## Blocking objections

1. The packet does not specify whether type-conditional dormancy is removed entirely or simplified while claiming equivalence; those are different counterfactuals.
2. No candidate treatment is shown for `peer_p75_h`, κ, peer `n`, or integrity-first ordering after removing the dormancy construction.
3. No demonstration shows that ESCALATE, INCONCLUSIVE, and STANDARD boundaries remain unchanged across F01–F14.
4. F03 is explicitly named by the spec, yet its raw open age and candidate result are absent.
5. No candidate proof covers unparseable CREATED_DATE (F13), inverted clocks (F05), open-with-closed-date (F04), thin peers (F06), orphan parents (F09), out-of-set rows, or F14A/F14B SR_NUMBER grain.
6. No candidate proof addresses the SQL nonjudgment boundary, exact reconciliation controls, or unchanged SR_NUMBER grain.
7. The RB excerpt exposes `n_out_of_set=23191` while the RA excerpt does not; the full candidate and baseline portfolio fields need reconciliation.
8. The manifest establishes names and hashes as claims, not independently recomputed file identity; most file contents are not present.
9. `stage4_validation_status.json` and `workflow_gate_status.json` are listed in the manifest, but their contents and any candidate Stage 4 result are absent.
10. Timezone treatment is only label-consistent (`CDT` versus `America/Chicago`); a parse/conversion log and `created_ts <= T_freeze` checks are not shown.

## Missing evidence needed before adjudication

- candidate framework/version identifier and SHA-256;
- candidate SQL/R source or deterministic diff against `stage3-v1-tcd-ig`;
- declared changed-file set;
- candidate F01–F14 actuals and expected/observed comparison;
- raw rows with `CREATED_DATE`, type, peer inputs, `T_freeze`, and computed raw ages;
- F03 raw-age derivation showing whether `open_age_h` equals 2400;
- candidate Design Gate output for `open_age_days >= 14`;
- candidate parse, clock, and America/Chicago timezone validation;
- candidate exact reconciliation, disagreement IDs, portfolio counts, and all critical fields;
- candidate contents of `stage4_validation_status.json`, `workflow_gate_status.json`, `SOURCE_GATE_REPORT.md`, and `EXACT_RECON_REPORT.md`;
- independently recomputed manifest hashes;
- explicit mechanical-equivalence documentation if the change is a simplification rather than full removal.

The adjudicator note means missing historical R stdout alone is not a reason to stop; it does not substitute for the missing candidate evidence above.

## Unchanged-surface checks

| Surface | Evidence in packet | Finding |
|---|---|---|
| SQL nonjudgment boundary | No candidate SQL or diff | Unverified |
| Integrity-first ordering | Baseline integrity clauses shown; no candidate | Unverified for candidate |
| Exact recon controls | Baseline summary is exact; no candidate recon | Baseline coherent; candidate unverified |
| SR_NUMBER grain | F14 baseline states two independent labels; no candidate | Baseline shown; candidate unverified |
| Fixture IDs/expecteds | Baseline F01–F14 shown; no candidate outputs | Candidate unverified |
| Frozen Stage 4 pack | Status file listed, content absent | Unverified |
| ESCALATE/INCONCLUSIVE/STANDARD semantics | Baseline counts/fixtures shown; no candidate | Candidate unverified |
| No City SLA/dispatch-order scope creep | Candidate evidence absent | Cannot verify |
| κ and T_freeze | Baseline κ=2 and CDT timestamp shown | Baseline consistent; timezone log absent |

## Claim-to-evidence map

| Claim | Evidence present | Validator assessment |
|---|---|---|
| Raw age improves interpretability | No quantified measure | Not established |
| Raw age reduces complexity | No diff or complexity measure | Not established |
| Raw age is mechanically equivalent | No candidate code, raw-age values, or equivalence note | Not established |
| F03 remains STANDARD | TCD-IG row only: 2400, 2160, within-type dormancy | Candidate preservation not established |
| Design Gate remains valid | No candidate `open_age_days` or gate output | Not established |
| Stage 4 PASS remains unchanged | Status JSON content absent | Not established |
| Reconciliation remains exact | Baseline zero-disagreement summary only | Candidate not established |
| Fixture semantics remain unchanged | Baseline expecteds only | Candidate not established |
| No undeclared semantic change | No candidate semantic diff | Not established |

## Closing

The frozen baseline evidence is internally coherent: the shown reconciliation is exact, RA/RB in-set counts match, κ=2 is consistent, and the shown fixtures pass under `fixtures-v1-tcd-ig`. However, the raw-open-age candidate state is not present. There are no raw-age fixture actuals, candidate reconciliation, Design Gate output, Stage 4 status content, or mechanical-equivalence proof for F03 and the other type-conditional fixtures. Terminal adjudication is withheld.
