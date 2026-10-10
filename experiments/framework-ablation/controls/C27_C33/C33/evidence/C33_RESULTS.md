# C33 RESULTS — Naive Clock Contract ablation (runner output, mechanical facts only)

Contract = naive SQL clocks read as character and parsed as America/Chicago wall time. Truth reference = arm B (contract ON).

## Mechanical facts
- H1 all four runs exit 0: TRUE
- H2 contract arm B reproduces frozen labels (0 label diffs, 0 only-rows vs frozen RA/RB; recon 0 disagree): TRUE
- H3 label flips vs contract arm: X1/X2 R-B=104; X2 R-A=104 (total 208)
- H4 clock-field shift vs contract arm: R-B rows with |d dormant_h|>1e-6 = 222002 (max 6 h); R-A = 222002 (max 6 h)
- H5 cross-path recon detects the ablated defect: X1 n_disagree=104; X2 n_disagree=0
- H6 fixtures detect the ablated defect: B-RA 14/14; B-RB 14/14; X1-RB 14/14; X2-RA 14/14

## Runs
| arm | path | code | exit | secs | fixtures_pass | fixtures_failed |
|---|---|---|---|---|---|---|
| B | RA | frozen R-A | 0 | 16.2 | 14/14 |  |
| B | RB | frozen R-B | 0 | 28.4 | 14/14 |  |
| X1 | RB | R-B pre-contract parser (historical 12:56 CT 2026-09-19) | 0 | 24.5 | 14/14 |  |
| X2 | RA | R-A seeded no-contract parser | 0 | 15.2 | 14/14 |  |

## Reconciliation (frozen recon logic: full join on sr_number, compare classification)
| pair | n_ra | n_rb | n_inner | n_only_ra | n_only_rb | n_agree | n_disagree |
|---|---|---|---|---|---|---|---|
| B: R-A(frozen) vs R-B(frozen) [contract ON both] | 222002 | 222002 | 222002 | 0 | 0 | 222002 | 0 |
| X1: R-A(frozen) vs R-B(pre-contract) [contract OFF on R-B] | 222002 | 222002 | 222002 | 0 | 0 | 221898 | 104 |
| X2: R-A(seeded no-contract) vs R-B(pre-contract) [contract OFF both] | 222002 | 222002 | 222002 | 0 | 0 | 222002 | 0 |

## Ablated paths vs contract arm (and repro vs frozen pack)
| cmp | n_x | n_truth | n_only_x | n_only_truth | n_label_diff | n_dormant_diff | max_abs_d_dormant_h | max_abs_d_open_age_h |
|---|---|---|---|---|---|---|---|---|
| B R-A vs frozen RA_classifications (repro check) | 222002 | 222002 | 0 | 0 | 0 | 0 | 0 | 0 |
| B R-B vs frozen RB_classifications (repro check) | 222002 | 222002 | 0 | 0 | 0 | 0 | 0 | 0 |
| X1/X2 R-B(pre-contract) vs B R-B(contract) | 222002 | 222002 | 0 | 0 | 104 | 222002 | 6 | 6 |
| X2 R-A(no-contract) vs B R-A(contract) | 222002 | 222002 | 0 | 0 | 104 | 222002 | 6 | 6 |

## Portfolio
| run | n_decision | ESCALATE | INCONCLUSIVE | STANDARD |
|---|---|---|---|---|
| B R-A | 222002 | 131968 | 6377 | 83657 |
| B R-B | 222002 | 131968 | 6377 | 83657 |
| X1 R-B(pre-contract) | 222002 | 132072 | 6377 | 83553 |
| X2 R-A(no-contract) | 222002 | 132072 | 6377 | 83553 |

## Disagreeing label pairs (R-A label a vs R-B label b)
| pair | a | b | n |
|---|---|---|---|
| X1 | STANDARD | ESCALATE | 104 |

