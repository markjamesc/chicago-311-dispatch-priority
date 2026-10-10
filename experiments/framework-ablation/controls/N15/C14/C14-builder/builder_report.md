# C14 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as Builder** for **C14**, Remaining Ablation Program catalog #14, **“Explicit Semantics (Open/Elig.)”**, N15 batch 2 of 3, Constitution v1.0. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. This is an **independent first pass**; I do not rely on or infer the Validator’s assessment.

Target stage: **Stage 3→4**, specifically the semantics of **open, eligible, duplicate, and legacy**. The control locks those meanings in the Stage-3 design and requires both builders to implement them. The ablation removes that semantic lock and permits each builder to apply a plausible plain-language interpretation.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The ablation removes the requirement that “open,” “eligibility,” “duplicate,” and “legacy” have one frozen Stage-3 meaning shared by R-A and R-B. The six arms then test either a single-path alternate reading or a common alternate reading on both paths.

| Seed | Exact code change |
| --- | --- |
| **SEM_DUPKEEP_RB** | In R-B, duplicates are assigned `integrity_clause[dup_flag] <- "I00_duplicate_retained"` and `!dup_flag` is removed from `in_decision`, changing `is_open & !dup_flag & !leg_flag` to `is_open & !leg_flag`. |
| **SEM_DUPKEEP_CM / R-A side** | In R-A, duplicate status is removed from `exclude`, changing `is_true_like(dup) | is_true_like(leg) | !in_envelope_open` to `is_true_like(leg) | !in_envelope_open`; a `check(is_true_like(dup), "duplicate_retained")` integrity clause is added. |
| **SEM_NOPEER_RB** | In R-B, decision membership gains `& !is.na(peer_p75)`, so a row without peer statistics is excluded. |
| **SEM_NOPEER_CM / R-A side** | In R-A, `base$exclude <- base$exclude | base$peer_missing` is inserted before classification. |
| **SEM_LEGACYIN_CM / R-A side** | In R-A, `is_true_like(leg)` is removed from the exclusion expression, so legacy records can enter the decision set. |
| **SEM_LEGACYIN_CM / R-B side** | In R-B, `!leg_flag` is removed from `in_decision`, changing `is_open & !dup_flag & !leg_flag` to `is_open & !dup_flag`. |
| **SEM_OPENEXACT_CM / R-A side** | R-A changes `tolower(status) == "open"` to `status == "Open"`. Importantly, `status` was already produced with `str_trim(...)`; therefore this seed removes case normalization but **still retains whitespace trimming on R-A**. |
| **SEM_OPENEXACT_CM / R-B side** | R-B changes `tolower(status_norm) == "open"` to raw `as.character(joined$STATUS) == "Open"`, removing both trimming and case normalization from the actual comparison. |

Those are the complete seeded hunks shown in `SEED DIFFS`; no source variant is used.

The R-A/R-B difference in the OPENEXACT implementation is noteworthy: the frozen seed description says both paths use the exact token with no case/space normalization, but R-A still trims before its comparison while R-B does not. The frozen source does not exercise that difference because every source STATUS is exactly `"Open"`.

## 3. Hard mechanical facts table.

**Notation:** **R** = recomputed independently from supplied raw/table evidence. **Q** = quoted directly because the underlying scalar cannot be independently reconstructed further from the supplied packet. Where both appear, the quoted value was independently cross-checked by arithmetic.

### Baseline/source arithmetic

| Fact | Result | Basis |
| --- | --- | --- |
| Source rows from duplicate split | `222,176 + 23,017 = 245,193` | **R** |
| Source rows from legacy split | `245,014 + 179 = 245,193` | **R** |
| Peer-bin total | `6,443 + 27 + 35 + 14 + 19 + 238,655 = 245,193` | **R** |
| Arm-B decision-set rows, each path | `222,002` | **Q**, RESULTS Arm B recon row |
| Duplicate∩legacy overlap implied by B | `23,017 + 179 - (245,193 - 222,002) = 5` | **R** |
| Duplicate-only rows | `23,017 - 5 = 23,012` | **R** |
| Legacy-only rows | `179 - 5 = 174` | **R** |
| No-peer rows surviving baseline duplicate/legacy exclusions | `6,315` | **R**, from NOPEER removal |
| No-peer rows already outside B | `6,443 - 6,315 = 128` | **R** |

The 23,012 duplicate-only and 174 legacy-only derivations exactly reproduce the observed DUPKEEP and LEGACYIN additions in the seeded-arm table.

### Arm-B reconciliation identities

| Fact | Result | Basis |
| --- | --- | --- |
| `n_ra` | 222,002 | **Q** |
| `n_rb` | 222,002 | **Q** |
| `n_inner` | 222,002 | **Q** |
| `n_only_ra` | 0 | **Q** |
| `n_only_rb` | 0 | **Q** |
| `n_disagree` | 0 | **Q** |
| `n_agree = n_inner - n_disagree` | `222,002 - 0 = 222,002` | **R** |
| Check `n_agree + n_disagree = n_inner` | `222,002 + 0 = 222,002` | **R** |
| Full-field dormant mismatch | 1 | **Q** |
| Full-field open-age mismatch | 2 | **Q** |

Arm B also shows zero differences against each corresponding frozen classification file for key set, labels, dormant_h and open_age_h.

### Seeded-arm cardinalities and reconciliation identities

Starting from B=`222,002`, the `only_x`/`only_B` comparisons permit the path sizes, intersection sizes, agreements and portfolio-cardinality deltas to be recomputed:

| Arm | Derived `n_RA` | Derived `n_RB` | `n_inner` | `n_agree` | RA Δ vs B | RB Δ vs B | Locked changes | Basis |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| SEM_DUPKEEP_RB | 222,002 | 245,014 | 222,002 | 222,002 | 0 | +23,012 | 23,012 | **R** |
| SEM_DUPKEEP_CM | 245,014 | 245,014 | 245,014 | 245,014 | +23,012 | +23,012 | 46,024 | **R** |
| SEM_NOPEER_RB | 222,002 | 215,687 | 215,687 | 215,687 | 0 | −6,315 | 6,315 | **R** |
| SEM_NOPEER_CM | 215,687 | 215,687 | 215,687 | 215,687 | −6,315 | −6,315 | 12,630 | **R** |
| SEM_LEGACYIN_CM | 222,176 | 222,176 | 222,176 | 222,176 | +174 | +174 | 348 | **R** |
| SEM_OPENEXACT_CM | 222,002 | 222,002 | 222,002 | 222,002 | 0 | 0 | 0 | **R** |

For every arm, `n_disagree=0`, so `n_agree=n_inner`. The recomputed locked-change totals equal the runner’s reported values exactly: `23,012`, `46,024`, `6,315`, `12,630`, `348`, and `0`.

These deltas are the recomputable **total portfolio/decision-set cardinality deltas**. Exact class-by-class portfolio deltas cannot be numerically reconstructed from the packet because the contents of the `*_portfolio_counts.csv` files are not printed; the manifests provide their hashes and byte sizes, not their internal class counts.

### Runs and fixtures

| Fact | Result | Basis |
| --- | --- | --- |
| Baseline path runs | 2 | **R** |
| Seeded path runs | `1+2+1+2+2+2 = 10` | **R** |
| Total path runs | 12 | **R** |
| Seeded arms with all required runs recorded | 6/6 | **R**, confirms quoted H3 |
| Recorded nonzero exits | 0 | **R** |
| Fixture rows executed | `12 × 14 = 168` | **R** |
| Fixture failures | 5 | **R** |
| Fixture passes | `168 - 5 = 163` | **R** |

The five failing fixture rows are: SEM_DUPKEEP_RB/RB F07; SEM_DUPKEEP_CM/RA F07; SEM_DUPKEEP_CM/RB F07; SEM_LEGACYIN_CM/RA F08; SEM_LEGACYIN_CM/RB F08. All other raw fixture rows pass.

### Recomputed sets

Using the frozen `D_abl` definition—crash, key/label reconciliation mismatch, or any fixture failure:

| Set | Recomputed membership | Basis |
| --- | --- | --- |
| Harm set `H` | `{SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_NOPEER_CM, SEM_LEGACYIN_CM}` | **R** from nonzero locked-field changes |
| `D_abl` | `{SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_LEGACYIN_CM}` | **R** from recon + fixture rows |
| `H ∩ D_abl` | four arms above | **R** |
| `H \ D_abl` | `{SEM_NOPEER_CM}` | **R** |
| No-locked-change set | `{SEM_OPENEXACT_CM}` | **R** |
| ` | H | ` | 5 | **R** |
| ` | D_abl | ` | 4 | **R** |
| ` | H \ D_abl | ` | 1 | **R** |

These recomputations exactly reproduce H4–H7 in the runner results.

### Manifest/hash equalities

| Equality | Recomputed finding |
| --- | --- |
| Frozen source lineage across all 7 arms | Same SHA-256 in every arm: `eaa9a76d...ddd1b` — **R** |
| `src_open_candidates.csv` across all 7 arms | Same SHA-256 `ba089fcc...d81b9` — **R** |
| `src_peer_stats.csv` across all 7 arms | Same SHA-256 `cb78ae21...d79eb58` — **R** |
| R-B `00_config.R` across all 7 arms | Same SHA-256 `6c9b0e31...c70450b` — **R** |
| R-B `10_io_parse.R` across all 7 arms | Same SHA-256 `40e67d83...2154a` — **R** |
| R-B `40_fixtures.R` across all 7 arms | Same SHA-256 `2ad4aa69...b7a07e` — **R** |
| R-B `run_RB.R` across all 7 arms | Same SHA-256 `6786fcf5...6defd` — **R** |
| DUPKEEP RB classification output, single-path vs common-reading arm | Same SHA-256 `561adc80...8f1a5` — **R** |
| DUPKEEP RB fixture output, single-path vs common-reading arm | Same SHA-256 `fe34d4fc...05cc` — **R** |
| DUPKEEP RB κ-grid output, single-path vs common-reading arm | Same SHA-256 `1214c489...fa80e` — **R** |
| DUPKEEP RB portfolio output, single-path vs common-reading arm | Same SHA-256 `af0711a2...6ddb` — **R** |
| NOPEER RB classification output, single-path vs common-reading arm | Same SHA-256 `6e439a2f...14b49` — **R** |
| NOPEER RB fixture output, single-path vs common-reading arm | Same SHA-256 `0d72245c...e9e9` — **R** |
| NOPEER RB κ-grid output, single-path vs common-reading arm | Same SHA-256 `d7532246...0dfa` — **R** |
| NOPEER RB portfolio output, single-path vs common-reading arm | Same SHA-256 `25f870af...ed86` — **R** |
| OPENEXACT RA classification/fixture/portfolio outputs vs B | All three hashes identical to B — **R** |
| OPENEXACT RB classification/fixture/κ-grid/portfolio outputs vs B | All four hashes identical to B — **R** |

Thus the single-path and common-reading versions of DUPKEEP produce byte-identical R-B analytical outputs, as do the two NOPEER R-B executions. OPENEXACT produces byte-identical core analytical outputs to B on both paths.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate states that P1 is satisfied only when `H ⊆ D_abl`; it is failed when `H \ D_abl` is non-empty.

The recomputed sets are:

`H = {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_NOPEER_CM, SEM_LEGACYIN_CM}`

`D_abl = {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_LEGACYIN_CM}`

Therefore:

`H \ D_abl = {SEM_NOPEER_CM}`

and `H ⊄ D_abl`.

Accordingly, **the frozen P1 failed condition is met**. The specific counterexample is SEM_NOPEER_CM: both implementations adopt the same unlocked reading that eligibility requires peer statistics; each drops 6,315 rows relative to B, producing 12,630 locked-field path-changes in aggregate, while R-A/R-B reconciliation remains `0/0/0`, all 28 fixtures across the two paths pass, and both processes exit normally.

SEM_OPENEXACT_CM is not part of `H`: it produces zero locked-field changes and therefore counts neither for nor against P1 under the frozen definition.

## 5. Fixture and reconciliation implications.

The evidence separates three detection mechanisms cleanly.

**Duplicate semantics are fixture-protected.** SEM_DUPKEEP_RB creates a 23,012-row R-B-only key-set difference and also fails F07 on R-B. SEM_DUPKEEP_CM removes the reconciliation mismatch by making both paths adopt the same interpretation, but F07 fails independently on both paths. Thus the duplicate fixture still exposes common-mode semantic drift.

**Legacy semantics are fixture-protected.** SEM_LEGACYIN_CM adds 174 rows to each path, giving 348 aggregate locked-field changes while path reconciliation remains 0/0/0. F08 changes from expected `OUT_OF_SET` to observed `ESCALATE` on both R-A and R-B, so the shared interpretation is nevertheless exposed by the frozen fixture.

**The tested no-peer eligibility semantics are not fixture-protected.** SEM_NOPEER_RB is detected only because one path changes: R-A has 6,315 keys that seeded R-B no longer contains. When that same interpretation is applied to both paths in SEM_NOPEER_CM, each path contains 215,687 rows, both exclude the same 6,315 B rows, reconciliation is again 0/0/0, and every F01–F14 fixture passes on both paths.

That is the mechanically demonstrated common-mode gap: **independent-path reconciliation detects unilateral semantic drift, but cannot by itself distinguish two mutually agreeing implementations of the same alternate semantic rule.** For duplicate and legacy, F07/F08 supply the extra semantic anchor; for the seeded no-peer definition, the frozen fixture suite does not.

SEM_OPENEXACT_CM also has 0/0/0 reconciliation and 14/14 fixtures on each path, but unlike NOPEER_CM it causes zero locked-field change on this frozen pack. The source profile explains the result: all 245,193 source rows already have STATUS exactly `"Open"`.

The persistent full-field `dormant_h=1` and `open_age_h=2` mismatches are not generated by any seed. The coordinator predeclared them as three existing one-hour differences—SR22-01936870 for dormant_h and SR25-02017553/SR25-02017556 for open_age_h—with agreeing labels. Every seeded-arm result retains the same 1/2 pattern.

## 6. Semantic/regression risks and unchanged surfaces.

The principal demonstrated semantic risk is **common-mode reinterpretation**. SEM_NOPEER_CM shows that two independently implemented paths can agree perfectly with each other while jointly departing from the locked reference by 6,315 rows per path. Reconciliation is therefore evidence of cross-path agreement, not by itself evidence that the agreed semantics are the intended semantics.

Fixture coverage is semantic-specific rather than universal. F07 directly protects the locked duplicate behavior and F08 directly protects the locked legacy behavior. The supplied fixture suite does not distinguish the seeded “eligible means has peer statistics” interpretation from the locked treatment of missing peer statistics.

OPENEXACT has an additional regression-coverage limitation: because every frozen source row is already exact `"Open"` and the executed fixtures also produce no difference, this arm does not behaviorally exercise lower-case, mixed-case, leading-space, or trailing-space source statuses. Moreover, the R-A seed is not literally equivalent to the R-B seed with respect to whitespace: R-A compares an already `str_trim`med value, while R-B compares the untrimmed raw field. That discrepancy is present in the frozen seed code even though it is behaviorally dormant on this pack.

The known three-row clock discrepancy remains an unchanged open finding. Its suspected daylight-saving explanation is explicitly unconfirmed, and no evidence in C14 attributes it to any seeded semantic change.

The following surfaces are mechanically unchanged: the frozen source lineage, `src_open_candidates.csv`, and `src_peer_stats.csv` hashes are identical across every arm; no source variants are used; R-B `00_config.R`, `10_io_parse.R`, `40_fixtures.R`, and `run_RB.R` remain byte-identical across arms; only the declared semantic seed target files differ from B. The baseline framework hashes and frozen-code hashes also match the preflight declarations.

Finally, SEM_OPENEXACT_CM provides a direct unchanged-output regression check: despite altered comparison code, its R-A classification, fixture and portfolio outputs and its R-B classification, fixture, κ-grid and portfolio outputs have exactly the same hashes as B.

## 7. Claim → evidence map.

| Claim | Evidence section and row/hunk |
| --- | --- |
| **C1. ChatGPT is Builder for C14; target is Stage 3→4 semantic locking.** | SPEC → header rows “Ablation ID,” “Roles,” “Target stage”; Control under test. |
| **C2. C14 removes the frozen semantic lock and seeds plausible alternate readings.** | SPEC → “Exact change being tested (ablation)” and “Seeded readings.” |
| **C3. DUPKEEP, NOPEER, LEGACYIN and OPENEXACT code changes are as described in §2.** | SEED DIFFS → each R-A/R-B unified-diff hunk. |
| **C4. Baseline source arithmetic gives 245,193 rows, duplicate-only 23,012, legacy-only 174, and a 5-row duplicate/legacy overlap.** | SPEC → Data profile row; RESULTS → Arm-B recon row; recomputation shown in §3. |
| **C5. The six seeded-arm cardinality changes are +23,012, +23,012 each, −6,315, −6,315 each, +174 each, and zero respectively.** | C14_RESULTS → Seeded arms rows SEM_DUPKEEP_RB through SEM_OPENEXACT_CM; independently recomputed from `RA_vs_B`/`RB_vs_B`. |
| **C6. All seeded reconciliations have zero classification disagreement; shared-reading arms have zero key-set mismatch.** | C14_RESULTS → Seeded arms, `recon_only_ra`, `recon_only_rb`, `recon_disagree` columns. |
| **C7. H contains five arms, D_abl contains four, and** `H \ D_abl={SEM_NOPEER_CM}`**.** | SPEC → frozen D_abl/P1 definitions; C14_RESULTS → H4/H5/H6 and Seeded arms rows. |
| **C8. The frozen P1 failed condition is met.** | SPEC → P1 rows defining failure as nonempty `H \ D_abl`; RESULTS → H6=`{SEM_NOPEER_CM}`. |
| **C9. F07 catches duplicate reinterpretation and F08 catches legacy reinterpretation, while NOPEER_CM passes all fixtures.** | FIXTURE RESULTS → SEM_DUPKEEP_RB/CM F07 rows, SEM_NOPEER_CM F01–F14 rows, SEM_LEGACYIN_CM F08 rows. |
| **C10. SEM_NOPEER_CM is a common-mode semantic change invisible to key/label reconciliation and the frozen fixtures.** | C14_RESULTS → SEM_NOPEER_CM row: 12,630 locked changes, recon 0/0/0, 14/14 + 14/14, `caught_without_control=FALSE`. |
| **C11. The persistent 1 dormant_h / 2 open_age_h mismatches are the predeclared three-row N1 finding, not a seed effect.** | COORDINATOR NOTE N1; SPEC → Known open finding N1; every RESULTS arm row repeats 1/2. |
| **C12. Source hashes and non-target R-B support-code hashes remain unchanged across arms.** | ARM MANIFESTS → input rows for B and all seeded arms; preflight frozen hashes. |
| **C13. DUPKEEP_RB and DUPKEEP_CM have byte-identical R-B analytical outputs; the same is true for NOPEER_RB vs NOPEER_CM.** | ARM MANIFESTS → corresponding R-B classification, fixture, κ-grid and portfolio rows. |
| **C14. OPENEXACT_CM has byte-identical core analytical outputs to B.** | ARM MANIFESTS → B output rows and SEM_OPENEXACT_CM output rows. |
| **C15. R-A OPENEXACT still trims whitespace whereas R-B performs a raw exact comparison.** | SEED DIFFS → R-A OPENEXACT hunk and R-B OPENEXACT hunk. |

END C14 BUILDER REPORT
