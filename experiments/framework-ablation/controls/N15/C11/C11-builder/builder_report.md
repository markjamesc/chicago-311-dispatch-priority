## 1. Role attestation and ablation ID

I am **Builder = ChatGPT**, performing the **independent first pass** for **Ablation C11, “Method Constants vs Knobs,” catalog #11**. I am operating only in the Builder role and have not used or been shown a Validator first-pass output. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

The target is the Stage 3→4 control distinguishing fixed method constants from the single owner-tunable knob κ. The frozen data configuration is Chicago 311 Dataset 2, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.  [source: C11_1_BUILDER_ChatGPT]

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS

The control under test distinguishes **fixed method constants** `W = 365 d` and `n_min = 50` from the owner-tunable knob `κ`. Under the control, changing `n_min` is a design change rather than tuning. The ablation removes that distinction for `n_min`: `n_min` is treated as tunable and may be silently retuned without a design change. `W` is not seeded because it is applied in the SQL peer extract and cannot be varied without producing a new extract.  [source: C11_1_BUILDER_ChatGPT]

The exact code changes shown by the frozen SEED DIFFS are narrow constant substitutions. For the `30` seed, R-A changes only `N_MIN <- 50L` to `N_MIN <- 30L`; R-B changes only `RB_N_MIN <- 50L` to `RB_N_MIN <- 30L`. The surrounding `RULE_VERSION`, `KAPPA`, `T_FREEZE`, `RB_KAPPA_DEFAULT`, and `RB_KAPPA_GRID` lines shown in the diff remain unchanged.  [source: C11_1_BUILDER_ChatGPT]

For the `75` seed, R-A changes only `N_MIN <- 50L` to `N_MIN <- 75L`, while R-B changes only `RB_N_MIN <- 50L` to `RB_N_MIN <- 75L`.  [source: C11_1_BUILDER_ChatGPT]

For the `100` seed, R-A changes only `N_MIN <- 50L` to `N_MIN <- 100L`, while R-B changes only `RB_N_MIN <- 50L` to `RB_N_MIN <- 100L`.  [source: C11_1_BUILDER_ChatGPT]

These files are deployed as four arms: `K_NMIN30_CM` uses the 30 seed on both R-A and R-B; `K_NMIN75_CM` uses the 75 seed on both; `K_NMIN100_CM` uses the 100 seed on both; and `K_NMIN30_RB` applies the same R-B 30 seed on R-B only, with the unrun R-A path taken from arm B.  [source: C11_1_BUILDER_ChatGPT]

Thus the conceptual removal is not an algorithm rewrite, source-data change, κ change, window change, fixture rewrite, or reconciliation rewrite. It is specifically the loss of the rule that makes `n_min=50` a locked method constant whose alteration itself is detectable.

## 3. Hard mechanical facts table

“Recomputed” below means derived independently from the supplied raw/result rows or by checking identities/equalities between supplied values. “Quoted” means the numerical value is exposed by the runner evidence but the packet does not expose lower-level data from which I can independently regenerate that particular value.

| Hard fact | Result | Status |
| --- | --- | --- |
| Source DUPLICATE partition | 222,176 + 23,017 = **245,193** | Recomputed |
| Source LEGACY_RECORD partition | 245,014 + 179 = **245,193** | Recomputed |
| `peer_n` bucket partition | 6,443 + 27 + 35 + 14 + 19 + 238,655 = **245,193** | Recomputed |
| Frozen `src_open_candidates.csv` row count | **245,193** | Quoted; agrees with the three independently summable partitions above |
| Frozen `src_peer_stats.csv` row count | **104** | Quoted |
| Baseline framework hashes listed in SPEC vs BASELINE FRAMEWORK HASHES | **2/2 equal** | Recomputed string equality |
| Frozen source hashes in SPEC vs PREFLIGHT | **2/2 equal** | Recomputed string equality |
| Frozen C11 code hashes named in SPEC vs PREFLIGHT | **4/4 equal** for R-A `run_RA.R`, R-B `00_config.R`, `20_integrity_and_classify.R`, `40_fixtures.R` | Recomputed string equality |
| Seeded arms expected from arm definitions | **4** | Recomputed |
| Seeded path executions expected | 2 + 2 + 2 + 1 = **7** | Recomputed |
| Seeded path executions present in run log | **7/7** | Recomputed |
| Total path executions including B | 2 + 7 = **9** | Recomputed |
| Recorded nonzero exits | **0/9** | Recomputed from run log |
| Arm B raw fixtures | R-A **14/14**, R-B **14/14**, total **28/28** | Recomputed from fixture rows |
| Arm B vs frozen R-A differences | key 0, label 0, dormant 0, open-age 0 | Quoted |
| Arm B vs frozen R-B differences | key 0, label 0, dormant 0, open-age 0 | Quoted |
| Arm B frozen recon | n_RA=222,002; n_RB=222,002; n_inner=222,002; only-RA=0; only-RB=0; disagree=0 | Quoted |
| Arm B `n_agree` | 222,002 − 0 = **222,002** | Recomputed |
| Arm B identity | `n_agree + n_disagree = 222,002 + 0 = 222,002 = n_inner` | Recomputed |
| Arm B key identities | `n_inner + n_only_RA = 222,002 = n_RA`; `n_inner + n_only_RB = 222,002 = n_RB` | Recomputed |
| Arm B full-field numerical mismatches | dormant 1 + open-age 2 = **3** | Recomputed total from quoted components |
| `K_NMIN30_CM` R-A vs B classification changes | **35** | Quoted |
| `K_NMIN30_CM` R-B vs B classification changes | **35** | Quoted |
| `K_NMIN30_CM` cross-path locked-field/decision-change total | 35 + 35 = **70** | Recomputed |
| `K_NMIN75_CM` R-A/R-B classification changes | **14 / 14** | Quoted |
| `K_NMIN75_CM` cross-path locked-field/decision-change total | 14 + 14 = **28** | Recomputed |
| `K_NMIN100_CM` R-A/R-B classification changes | **33 / 33** | Quoted |
| `K_NMIN100_CM` cross-path locked-field/decision-change total | 33 + 33 = **66** | Recomputed |
| `K_NMIN30_RB` R-A/R-B classification changes vs B | **0 / 35** | Quoted |
| `K_NMIN30_RB` locked-field/decision-change total | 0 + 35 = **35** | Recomputed |
| Key-set changes vs B in all four seeds | **0** | Recomputed from all `only_x=0`, `only_B=0` cells |
| Seed-caused dormant/open-age changes vs B | **0** in every seeded path | Recomputed from arm comparison cells |
| Harm arms, using locked-field-change >0 | `{K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}` = **4/4** | Recomputed |
| Arms with no locked-field change | `{}` = **0/4** | Recomputed |
| `K_NMIN30_CM` fixtures | R-A 14/14 + R-B 14/14 = **28/28** | Recomputed from raw fixture rows |
| `K_NMIN75_CM` fixtures | R-A 14/14 + R-B 14/14 = **28/28** | Recomputed from raw fixture rows |
| `K_NMIN100_CM` fixtures | R-A 14/14 + R-B 13/14 = **27/28** | Recomputed |
| `K_NMIN100_CM` failed fixture count | **1**, R-B F14 | Recomputed |
| `K_NMIN30_RB` fixtures | R-B **14/14**; effective R-A from B is 14/14 | Recomputed |
| Paired-seed frozen recon key/label tuple, 30 | **0/0/0** | Recomputed from arm row |
| Paired-seed frozen recon key/label tuple, 75 | **0/0/0** | Recomputed from arm row |
| Paired-seed frozen recon key/label tuple, 100 | **0/0/0** | Recomputed from arm row |
| One-path 30-RB frozen recon key/label tuple | **0/0/35** | Recomputed from arm row |
| `K_NMIN30_RB` implied `n_agree` | 222,002 − 35 = **221,967** | Recomputed from unchanged key set and disagreement count |
| Full-field recon mismatches in every seed | dormant **1**, open-age **2**, total **3** | Recomputed/confirmed across arm rows |
| Caught-without-control set `D_abl` | `{K_NMIN100_CM, K_NMIN30_RB}` = **2 arms** | Recomputed from frozen detection rule |
| Harm minus caught-without-control | `{K_NMIN30_CM, K_NMIN75_CM}` = **2 arms** | Recomputed set difference |
| Caught-with-control set | all four harmful arms = **4/4** | Recomputed from `n_min != 50` |
| Caught-with-control but no locked-field change | `{}` = **0** | Recomputed |
| H ∩ `D_abl` | `{K_NMIN100_CM, K_NMIN30_RB}` = **2** | Recomputed |
| H \ `D_abl` | `{K_NMIN30_CM, K_NMIN75_CM}` = **2** | Recomputed |
| Fraction of harmful seeds caught without constants rule | 2 / 4 = **50%** | Recomputed descriptive ratio |
| Fraction of harmful seeds caught with constants rule | 4 / 4 = **100%** | Recomputed descriptive ratio |

The source-profile identities are internally exact: each independently supplied partition sums to the frozen 245,193-row source count.  [source: C11_1_BUILDER_ChatGPT] The run log contains all seven expected seeded path runs and shows exit 0 on each.  [source: C11_1_BUILDER_ChatGPT]

Arm B reproduces both frozen path outputs with zero key, label, dormant, or open-age differences. Its R-A/R-B key-and-label reconciliation is 0/0/0 over 222,002 common rows, while the separately disclosed full-field comparison retains one dormant and two open-age differences.  [source: C11_1_BUILDER_ChatGPT]

The seeded-arm arithmetic independently reproduces the runner's locked-field totals: `35+35=70`, `14+14=28`, `33+33=66`, and `0+35=35`. It also reproduces the four-arm harm set and the 2-arm caught-without-control set.  [source: C11_1_BUILDER_ChatGPT]

For portfolio implications, the packet exposes both row-level classification-change counts and the SHA-256 values of the portfolio-count files. Every executed seeded path has a portfolio-count hash different from B. The packet does **not** print the bodies of the portfolio-count CSVs, so a directional class-by-class delta such as “STANDARD −x / INCONCLUSIVE +x” cannot be independently reconstructed from the packet without inventing information. The mechanically available row-level portfolio-change magnitudes are therefore the 35/35, 14/14, 33/33, and 0/35 classification-change counts above. The manifest nevertheless establishes that the corresponding aggregate portfolio files changed.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

The manifest also gives several independently checkable hash equalities. The source lineage, open-candidate source, and peer-stat source hashes are identical across B and every seeded arm. The unchanged R-B `10_io_parse.R`, `20_integrity_and_classify.R`, `40_fixtures.R`, and `run_RB.R` hashes are likewise constant across arms; only `00_config.R` changes for an R-B seed.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

There is also an exact same-seed replication check: `K_NMIN30_CM` and `K_NMIN30_RB` use the identical R-B config hash `db2ee…f6ae`, and their R-B classifications, fixture results, κ-grid counts, and portfolio counts have identical hashes. Thus running the same 30 seed on R-B inside the paired arm versus the R-B-only arm reproduces the same R-B substantive output artifacts.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

R-A fixture-result hashes are identical across B and all three paired retunes. R-B fixture-result hashes are identical for B, 30-CM, 75-CM, and 30-RB; only the 100-CM R-B fixture output hash differs, matching the single raw F14 failure.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

## 4. P1 assessment against the frozen predicate in the SPEC

The frozen predicate is explicit: P1 is satisfied only if **H ⊆ D_abl**, meaning every seeded arm that changes any locked output field must still be detected after the constants-vs-knobs control is removed. P1 fails when **H \ D_abl is non-empty**. Arms causing no locked-field change are neutral.  [source: C11_1_BUILDER_ChatGPT]

Recomputation gives:

`H = {K_NMIN30_CM, K_NMIN75_CM, K_NMIN100_CM, K_NMIN30_RB}`

because all four have positive locked-field changes: 70, 28, 66, and 35 respectively.

Without the constants rule, the frozen detection regime catches only:

`D_abl = {K_NMIN100_CM, K_NMIN30_RB}`.

`K_NMIN100_CM` is detected because R-B fixture F14 fails. `K_NMIN30_RB` is detected because R-A versus R-B has 35 classification disagreements. By contrast, `K_NMIN30_CM` and `K_NMIN75_CM` neither crash, nor produce key/label reconciliation disagreement, nor fail any fixture.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

Therefore:

`H \ D_abl = {K_NMIN30_CM, K_NMIN75_CM}`

and its cardinality is **2**. The subset identity required by P1 does not hold:

`H ⊄ D_abl`.

Equivalently, two harmful seeds alter locked outputs while satisfying every remaining detection condition in the ablated regime. This matches the frozen P1-failed condition and is a direct set-theoretic consequence of the mechanical rows, not a qualitative judgment.

## 5. Fixture and reconciliation implications

The fixtures and reconciliation mechanisms provide **partial but not complete substitute coverage** for the constants lock.

For `K_NMIN30_CM`, both independently implemented paths change 35 classifications relative to their own B path, for 70 cross-path locked-field changes, yet both paths still pass all 14 fixtures and reconcile with each other at 0 only-R-A / 0 only-R-B / 0 classification disagreements. The same structure occurs at `K_NMIN75_CM`: each path changes 14 classifications relative to B, giving 28 cross-path changes, while fixtures remain 14/14 on each path and key/label reconciliation remains 0/0/0.  [source: C11_1_BUILDER_ChatGPT]

Mechanically, this demonstrates the blind spot created by coordinated same-direction retuning: exact cross-path agreement cannot detect a shared configuration change when both independent implementations are given the same altered method constant. R-A and R-B agree with each other while both differ from the frozen B reference.

`K_NMIN100_CM` is different. It also maintains 0/0/0 key/label reconciliation despite 33 changed classifications on each path, but the R-B fixture suite detects the retune because F14 expects `STANDARD|STANDARD` and observes `INCONCLUSIVE|INCONCLUSIVE`. R-A still passes all 14 of its fixtures.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

`K_NMIN30_RB` demonstrates the complementary strength of cross-path reconciliation. Because only R-B is changed, R-A remains at the B result and the 35 R-B classification changes become 35 R-A/R-B classification disagreements. Both fixture suites remain green, but reconciliation exposes the asymmetric implementation.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

The fixture suite therefore catches the 100 retune through one specific R-B case, but does not detect either paired 30 or paired 75 retune. Reconciliation catches the asymmetric 30 retune, but does not detect any of the three paired retunes because both paths move together.

The persistent full-field reconciliation differences—one `dormant_h` mismatch and two `open_age_h` mismatches—are not seeded effects. They occur in the frozen clean pair itself, affect three specified ESCALATE rows by exactly 1.000 hour, preserve labels, and are outside the frozen 0/0/0 key-and-classification reconciliation definition. The likely DST explanation is explicitly unconfirmed.  [source: C11_1_BUILDER_ChatGPT]

## 6. Semantic/regression risks and unchanged surfaces

The principal semantic risk exposed by C11 is **silent coordinated method retuning**. The 30 and 75 paired arms show that a method constant can be changed in both paths, alter 35 or 14 classifications per path, and still leave ordinary cross-path reconciliation and the entire fixture suite green. Thus implementation independence does not by itself protect a methodological constant if both implementations consume the same unauthorized value.

The fixture evidence also shows boundary-coverage dependence. Raising `n_min` to 100 crosses a condition exercised by R-B F14 and is detected, whereas moving to 30 or 75 changes actual portfolio classifications without hitting a fixture failure. The raw source profile makes the affected magnitudes structurally plausible: 35 rows lie in the 30–49 peer-count band, 14 in 50–74, and 19 in 75–99; correspondingly, the observed per-path classification changes are 35 for the 30 retune, 14 for the 75 retune, and 33 = 14 + 19 for the 100 retune.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

That correspondence is exact:

`n_min 50 → 30`: newly admitted 30–49 band = **35 rows**, observed classification changes = **35/path**.

`n_min 50 → 75`: newly excluded 50–74 band = **14 rows**, observed classification changes = **14/path**.

`n_min 50 → 100`: newly excluded 50–74 plus 75–99 bands = 14 + 19 = **33 rows**, observed classification changes = **33/path**.

This is a strong mechanical consistency check between the pre-frozen seed-selection profile and the later seeded outputs.

The unchanged surfaces are extensive. No source variant is used. Source hashes remain fixed. `W` is not varied. `κ` remains 2.0 in the displayed R-A diff and `RB_KAPPA_DEFAULT` remains 2.0 in R-B; the R-B κ grid is unchanged. `T_FREEZE` and the displayed R-A rule version are unchanged. The R-B parser, integrity/classification implementation, fixture code, and runner remain hash-identical across arms. Only the declared R-A `N_MIN` and/or R-B `RB_N_MIN` input files change according to arm.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]

No seed changes the SR_NUMBER key set relative to B, and no seed changes `dormant_h` or `open_age_h` relative to its B path. All seeded locked-field harm is therefore classification harm. The recurring 1/2 dormant/open-age R-A/R-B differences stay constant across the arms and are the pre-existing clean-pair finding rather than an effect of `n_min`.

All executions return exit 0. Thus none of the four seeded detections is crash-based. The difference between the regimes is entirely whether a constant mismatch is itself prohibited or whether the remaining fixtures/reconciliation happen to expose a downstream consequence.

## 7. Claim → evidence map

| Claim | Packet evidence |
| --- | --- |
| Builder is ChatGPT, independent first pass, blind to Validator | Opening role instruction, lines 1–3; SPEC Roles row, line 34.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |
| C11 tests fixed method constants versus owner knob κ | SPEC → “Control under test,” lines 38–40.  [source: C11_1_BUILDER_ChatGPT] |
| Ablation removes the distinction for `n_min` and permits silent retuning | SPEC → “Exact change being tested,” lines 42–45.  [source: C11_1_BUILDER_ChatGPT] |
| 30 seed is exactly `N_MIN 50→30` / `RB_N_MIN 50→30` | SEED DIFFS, lines 605–625.  [source: C11_1_BUILDER_ChatGPT] |
| 75 seed is exactly `N_MIN 50→75` / `RB_N_MIN 50→75` | SEED DIFFS, lines 628–649.  [source: C11_1_BUILDER_ChatGPT] |
| 100 seed is exactly `N_MIN 50→100` / `RB_N_MIN 50→100` | SEED DIFFS, lines 650–671.  [source: C11_1_BUILDER_ChatGPT] |
| Source partitions sum exactly to 245,193 rows | SPEC → Data profile, line 50–51.  [source: C11_1_BUILDER_ChatGPT] |
| All four seeded arms were run as declared | RUN LOG, lines 303–313.  [source: C11_1_BUILDER_ChatGPT] |
| B fixtures are 14/14 on both paths; B reproduces the frozen pack | C11_RESULTS → Mechanical facts H1–H2, lines 322–325; B repro table, lines 333–337.  [source: C11_1_BUILDER_ChatGPT] |
| B has 222,002 common keys, 0/0/0 frozen recon, and 1/2 full-field mismatches | C11_RESULTS → Arm B recon row, lines 339–342.  [source: C11_1_BUILDER_ChatGPT] |
| Harm set contains all four seeds | C11_RESULTS → H4, line 326.  [source: C11_1_BUILDER_ChatGPT] |
| Caught-without-control set contains only 100-CM and 30-RB | C11_RESULTS → H5, line 327.  [source: C11_1_BUILDER_ChatGPT] |
| H minus caught-without-control is `{30-CM,75-CM}` | C11_RESULTS → H6, line 328.  [source: C11_1_BUILDER_ChatGPT] |
| With the constants rule all four seeds are caught | C11_RESULTS → H8, line 330.  [source: C11_1_BUILDER_ChatGPT] |
| 30-CM has 35+35 classification changes = 70 and remains 14/14, 14/14, 0/0/0 | Seeded arms table → `K_NMIN30_CM`, line 347.  [source: C11_1_BUILDER_ChatGPT] |
| 75-CM has 14+14 classification changes = 28 and remains 14/14, 14/14, 0/0/0 | Seeded arms table → `K_NMIN75_CM`, line 348.  [source: C11_1_BUILDER_ChatGPT] |
| 100-CM has 33+33 classification changes = 66 and R-B fixture result 13/14 | Seeded arms table → `K_NMIN100_CM`, line 349.  [source: C11_1_BUILDER_ChatGPT] |
| The specific 100-CM fixture failure is R-B F14, expected STANDARD|STANDARD and observed INCONCLUSIVE|INCONCLUSIVE | Raw fixture row, line 475.  [source: C11_1_BUILDER_ChatGPT] |
| 30-RB has 35 R-A/R-B label disagreements while its R-B fixtures remain 14/14 | Seeded arms table → `K_NMIN30_RB`, line 350; raw F14 remains passing at line 489.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |
| P1 requires `H ⊆ D_abl`; nonempty `H \ D_abl` is the frozen failed condition | SPEC → Operational benefit predicate P1, lines 69–73.  [source: C11_1_BUILDER_ChatGPT] |
| P1 condition is not met because `H \ D_abl={30-CM,75-CM}` | Mechanical facts H4–H6, lines 326–328.  [source: C11_1_BUILDER_ChatGPT] |
| The recurring 1 dormant + 2 open-age mismatches are frozen-pack findings, labels agree, and they are outside the frozen 0/0/0 definition | Coordinator Note N1, lines 18–20.  [source: C11_1_BUILDER_ChatGPT] |
| B and all seeds use unchanged source hashes | ARM MANIFESTS B and seeded input rows.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |
| 30-CM and 30-RB reproduce the same R-B classifications, fixtures, κ-grid counts, and portfolio counts | ARM MANIFESTS 30-CM and 30-RB output rows.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |
| R-A fixture output is hash-identical across B and all paired seeds | ARM MANIFESTS R-A fixture rows for B, 100, 30, and 75.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |
| R-B fixture output is hash-identical for B, 30-CM, 75-CM, and 30-RB, but differs for 100-CM | ARM MANIFESTS fixture-output rows.  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT]  [source: C11_1_BUILDER_ChatGPT] |

END C11 BUILDER REPORT
