# C15 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as the Builder** for **C15**, catalog #15, **“Ranking/Capacity Framing-Only,”** in N15 batch 3 of 3. I have made this as an independent first pass and have not used or inferred a Validator result. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; constitution version is 1.0.

The control under test requires ranking or capacity constraints to be declared in Framing. The locked Stage-3 state is `capacity.flag = RANKING_NOT_IN_SCOPE`, and the validated ESCALATE action list is explicitly unordered.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

Conceptually, C15 removes only the **Stage-5 framing-scope check**. Stage 5's own independent count checks remain. The consequence under test is whether Stage 5 can introduce a capacity cap or ranking after Framing/Stage 3 and create an SR-level `stage-05/deeper/final_action_list.csv` that changes the validated ESCALATE action set without being stopped by Stage 5's existing checks.

**RK_CAP200 — late hard cap of 200 using** `dormant_h / peer_p75_h`**:**

```
fal <- ra %>% filter(classification == "ESCALATE") %>% arrange(desc(dormant_h / peer_p75_h)) %>% head(200) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification, priority_rank = row_number())
write_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late hard cap of 200 by urgency ratio
```

This both changes the SR set and introduces `priority_rank`.

**RK_TYPECAP — late per-type cap of 100:**

```
fal <- ra %>% filter(classification == "ESCALATE") %>% group_by(type_key) %>% slice_max(dormant_h, n = 100, with_ties = FALSE) %>% ungroup() %>% transmute(SR_NUMBER = sr_number, type_key, action = classification)
write_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late per-type cap of 100
```

The selection is performed separately by `type_key`; no rank/priority column is written.

**RK_KAPPACAP — late capacity constraint by raising κ to 8:**

```
fal <- ra %>% filter(classification == "ESCALATE", dormant_h >= 8 * peer_p75_h) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification)
write_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] capacity via a raised kappa (8) at Stage 5
```

This changes the SR set using an undeclared Stage-5 κ threshold.

**RK_RANKONLY — late ranking without changing the ESCALATE set:**

```
fal <- ra %>% filter(classification == "ESCALATE") %>% arrange(desc(dormant_h / peer_p75_h)) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification, priority_rank = row_number())
write_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late ranking, same set, no cap
```

The full ESCALATE set is retained, but `priority_rank` is introduced.

**RK_PRECAP — mutation of classifications before Stage 5's independent checks:**

```
ra <- ra %>% mutate(classification = ifelse(classification == "ESCALATE" & rank(-dormant_h / peer_p75_h, ties.method = "first") > 1000, "STANDARD", classification))  # [seed] cap applied to labels before the checks
```

Unlike the prior four seeds, this changes the classifications that feed the existing Stage-5 count checks rather than merely writing a downstream action artifact.

**RK_BENIGN — one additional illustrative capacity row only:**

```
label = c("illustrative_shift_50", "illustrative_shift_200", "illustrative_shift_500", "illustrative_shift_1000", "full_escalate_portfolio"),  # [seed] benign: extra illustrative budget row, FLAG only
attention_slots = c(50, 200, 500, 1000, 131968),
```

The frozen `escalate_n = 131968`, coverage formula, and `RANKING_NOT_IN_SCOPE` note remain unchanged.

## 3. Hard mechanical facts table.

| Mechanical fact | Independent result | Provenance |
| --- | --- | --- |
| Total arms | **7** = B + 6 seeded arms | **Recomputed** from the 7 raw `C15_arms.csv` rows. |
| Stage-5 exit distribution | **6 exit 0; 1 exit 1** | **Recomputed** from the run log. The sole nonzero arm is RK_PRECAP. |
| Seeded-arm exit distribution | **5/6 exit 0; 1/6 exit 1** | **Recomputed** from the same run log. |
| S5 exit records present | **7/7** | **Recomputed**: every arm has an S5 line. |
| Freeze checks present | **14/14** = 7 FRZ_PRE + 7 FRZ_POST | **Recomputed** from the run log. |
| Freeze changes | **0/14 changed** | **Recomputed**: every FRZ_PRE and FRZ_POST reports `changed=0`. |
| Frozen validated files across arms | **21/21 equal** = 3 files × 7 arms | **Recomputed** from manifests: every arm carries the identical hashes for `validated_action_list.csv`, `RA_classifications.csv`, and `RB_kappa_grid_counts.csv`. |
| `VALIDATION_FREEZE.sha256` equality | **7/7 equal** at `65b910...b5f8fd` | **Recomputed** from all seven arm manifests. |
| FRZ_PRE / FRZ_POST manifest equality | **14/14 equal** at `81ad52...aae98f` | **Recomputed** across seven PRE and seven POST files. |
| Arm B Stage-5 frozen-output reproduction | **8/8 hash-equal** | **Recomputed** by matching the eight frozen Stage-5 hashes in the SPEC to B's eight manifest output hashes. |
| RK_CAP200 existing Stage-5 outputs vs B | **8/8 equal**, plus `final_action_list.csv` | **Recomputed** from B and RK_CAP200 manifests. |
| RK_TYPECAP existing Stage-5 outputs vs B | **8/8 equal**, plus `final_action_list.csv` | **Recomputed** from manifests. |
| RK_KAPPACAP existing Stage-5 outputs vs B | **8/8 equal**, plus `final_action_list.csv` | **Recomputed** from manifests. |
| RK_RANKONLY existing Stage-5 outputs vs B | **8/8 equal**, plus `final_action_list.csv` | **Recomputed** from manifests. |
| RK_BENIGN existing Stage-5 outputs vs B | **7/8 equal**; only `capacity_coverage_note.csv` differs | **Recomputed** from manifests. Its capacity-note hash is `5fa9...6452` versus B's `4bf4...1609`. |
| RK_PRECAP Stage-5 output completion | **1/8 present**, and that 1 differs from B; **7/8 not produced** | **Recomputed** from the manifest after its exit 1. Only `independent_checks_critical_counts.csv` is present, hash `97d45...7705`. |
| Portfolio-summary deltas vs B | **0** for all **5/5** seeded arms that complete Stage 5 | **Recomputed** from identical `portfolio_summary.csv` hashes (`b58fc...3167`) for RK_CAP200, RK_TYPECAP, RK_KAPPACAP, RK_RANKONLY and RK_BENIGN. RK_PRECAP does not reach a portfolio output. |
| Harm set H | **3 arms** = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP}` | **Recomputed** from `in_H=TRUE` raw rows; agrees with quoted RESULTS set. |
| Caught-with set | **4 arms** = H plus `RK_RANKONLY` | **Recomputed** from `caught_with=TRUE`. |
| D_abl / caught-without set | **1 arm** = `{RK_PRECAP}` | **Recomputed** from nonzero Stage-5 exits and `caught_without=TRUE`. |
| `H \ D_abl` | **3 arms** = `{RK_CAP200, RK_TYPECAP, RK_KAPPACAP}` | **Recomputed**: H has 3 members and has no intersection with `{RK_PRECAP}`. |
| `H \ caught-with` | **0 arms / ∅** | **Recomputed** because all three H members are among the four caught-with arms. |
| Caught-with but not in H | **1 arm** = `{RK_RANKONLY}` | **Recomputed** set difference. |
| RK_CAP200 action rows | **200** | **Recomputed** from `head(200)` and frozen ESCALATE volume 131,968 (>200). |
| RK_CAP200 SR reduction relative to full ESCALATE | **131,768 removed** = 131,968 − 200 | **Recomputed**. |
| RK_CAP200 retained share | **0.1515519%** | **Recomputed** as 200 / 131,968 × 100. |
| RK_RANKONLY action rows | **131,968** | **Recomputed from quoted frozen ESCALATE count**: its code filters all ESCALATE records and performs no cap. |
| Benign illustrative coverage: 50 slots | **0.03788797%** | **Recomputed** as 50 / 131,968 × 100. |
| Benign illustrative coverage: 200 slots | **0.15155189%** | **Recomputed**. |
| Benign illustrative coverage: 500 slots | **0.37887973%** | **Recomputed**. |
| Benign illustrative coverage: 1,000 slots | **0.75775946%** | **Recomputed**. |
| Full 131,968-slot portfolio coverage | **100%** | **Recomputed** from `pmin(1, 131968 / 131968)`. |
| MySQL preflight row-count checks | **2/2 match**: 245,193 and 104 | **Recomputed equality** from expected/observed preflight values; the 245,193 open-candidate count also matches the frozen SPEC. |
| Baseline framework hash consistency | **2/2 match** between SPEC and baseline-hash block | **Recomputed** from the two repeated SHA-256 values. |
| Seed-script hash consistency | **6/6 match** across frozen seed declarations, PREFLIGHT and runner-side list | **Recomputed** from all six seed hashes. |
| Stage-5 harness hash consistency | **1/1 match** at `a2868e...9cf94` | **Recomputed** between SPEC, preflight and runner-side entry. |
| Fixture-result data rows in this packet | **0** | **Recomputed**: the fixture-results section contains only its CSV header. |
| Known full-field clock mismatches | **3 rows total** = 1 `dormant_h` + 2 `open_age_h` | **Recomputed sum from quoted counts**. Each difference is quoted as exactly **1.000 h** and labels agree. |
| Frozen reconciliation definition | **0/0/0** for only-RA / only-RB / classification disagreements | **Quoted** from N1. The 1+2 hour-field mismatches are outside that frozen definition. |
| `n_agree + n_disagree = n_inner` | **Not numerically recomputable from this packet** | No `n_agree`, `n_disagree`, or `n_inner` table is supplied; no values are invented. |

The raw arm table independently supports the recomputed H/caught sets: the three cap arms have `in_H=TRUE`; RK_RANKONLY has `in_H=FALSE` but `caught_with=TRUE`; RK_PRECAP alone has `caught_without=TRUE`; RK_BENIGN is false on all three flags.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 requires both conditions: **arm B clean** and `H \ D_abl = ∅`.

The first condition is established mechanically. B has Stage-5 exit **0**, its eight ordinary Stage-5 output hashes match the frozen eight **8/8**, its framing-scope check is reported clean, and its frozen validated inputs remain unchanged.

The second condition is not established. Recomputing from the raw arm rows gives:

`H = {RK_CAP200, RK_TYPECAP, RK_KAPPACAP}`

`D_abl = {RK_PRECAP}`

therefore

`H \ D_abl = {RK_CAP200, RK_TYPECAP, RK_KAPPACAP}`

with cardinality **3**, not 0. The three harm arms all complete Stage 5 with exit 0 when the framing-scope control is absent.

Accordingly, **P1 is failed by the frozen predicate**. This conclusion is solely the predicate evaluation; no terminal ablation state is issued here.

Separately from P1, the with-control set contains all three H arms, so `H \ caught-with = ∅`. It also contains RK_RANKONLY, which is outside H because its SR set is unchanged; that is the measured over-blocking cost of one arm.

## 5. Fixture and reconciliation implications.

The packet contains **zero per-arm fixture-result rows**: the fixture-results block contains only the header. This is consistent with the frozen Stage-5-only design: C15 does not seed or rerun R-A/R-B code; all arms start from the already validated frozen state. Therefore no new C15 fixture pass/fail counts can be reconstructed, and none should be fabricated.

Stage 5 nevertheless retains its own independent checks on `n_decision`, `n_ESCALATE`, `n_INCONCLUSIVE`, `n_STANDARD`, and validated-list count. RK_PRECAP changes classifications **before** those checks and exits 1. This demonstrates that the existing Stage-5 count guard detects this particular class of upstream label mutation. By contrast, RK_CAP200, RK_TYPECAP, RK_KAPPACAP, and RK_RANKONLY leave the checked classifications/counts intact, write a later `final_action_list.csv`, and all exit 0.

For reconciliation, the frozen batch definition remains **only-RA=0, only-RB=0, classification disagreements=0**. The known broader full-field comparison contains three pre-existing one-hour differences: one `dormant_h` mismatch and two `open_age_h` mismatches. All three labels agree. The packet explicitly records these as pre-existing frozen-pack findings, not seeded C15 effects.

The manifests further show that all seven arms preserve the same R-A classifications, R-B κ-grid counts, and validated action list before and after Stage 5. Thus C15 introduces no evidence of a new R-A/R-B reconciliation difference; its observed semantic effects occur downstream in Stage-5 action construction.

The illustrative identity `n_agree + n_disagree = n_inner` cannot be numerically checked because those quantities are not present in this packet.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk demonstrated by C15 is a **downstream-action escape**. RK_CAP200, RK_TYPECAP, and RK_KAPPACAP each alter the SR set in a newly written `final_action_list.csv`, yet all three exit Stage 5 successfully and leave the existing eight Stage-5 outputs byte-identical to B. A regression check restricted to the pre-existing output set can therefore remain green while a new operational action artifact changes the population acted upon.

RK_RANKONLY demonstrates the converse cost. It adds an explicit `priority_rank` but preserves the full ESCALATE SR set, so it is outside H under the frozen definition. The framing-scope control still flags it because the control also prohibits rank/priority columns. Thus the control's observed over-blocking surface is concrete and limited here to RK_RANKONLY.

RK_PRECAP demonstrates an unchanged independent safeguard: changing the classifications upstream of Stage 5's count checks is detected without relying on the framing-scope control. Its Stage-5 exit is 1 and the normal downstream output suite is not completed.

RK_BENIGN establishes that an illustrative FLAG-only capacity-note extension can change `capacity_coverage_note.csv` without changing the portfolio summary, action set, rank columns, or harm classification. Its other seven ordinary Stage-5 output hashes remain equal to B.

Unchanged surfaces are mechanically extensive: no source variants are used; the frozen source pack remains read-only; no R-A/R-B code seed is used; all three frozen validated files remain hash-identical in every arm; every FRZ_PRE and FRZ_POST reports unchanged; and the five seeded arms that complete Stage 5 all retain the exact B `portfolio_summary.csv`.

The N1 clock discrepancy remains a known regression-analysis qualification but not a C15 semantic change: three rows have one-hour full-field differences, while their classifications agree and the frozen key/classification reconciliation remains 0/0/0.

## 7. Claim → evidence map.

| Claim | Packet section and exact evidence row |
| --- | --- |
| C15 tests removal of the Stage-5 framing-scope enforcement while retaining Stage-5 independent checks. | **SPEC → Exact change being tested (ablation)**: “There is no framing-scope check at Stage 5. Stage 5's own independent checks stay.” |
| RK_CAP200 imposes a late top-200 urgency-ratio cap and adds `priority_rank`. | **SEED DIFFS → RK_CAP200 hunk**, added `head(200)`/`priority_rank` rows. |
| RK_TYPECAP imposes a per-`type_key` cap of 100. | **SEED DIFFS → RK_TYPECAP hunk**, `group_by(type_key)` + `slice_max(..., n = 100)`. |
| RK_KAPPACAP imposes a Stage-5 κ=8 threshold. | **SEED DIFFS → RK_KAPPACAP hunk**, `dormant_h >= 8 * peer_p75_h`. |
| RK_RANKONLY keeps the ESCALATE set but adds ranking. | **SEED DIFFS → RK_RANKONLY hunk** and **C15_arms.csv → RK_RANKONLY row**. |
| RK_PRECAP mutates classifications before independent checks and is the sole nonzero Stage-5 exit. | **SEED DIFFS → RK_PRECAP hunk**; **RUN LOG → RK_PRECAP S5 exit=1**; **C15_arms.csv → RK_PRECAP row**. |
| RK_BENIGN adds only the illustrative 500-slot capacity row. | **SEED DIFFS → RK_BENIGN hunk**. |
| All arms leave the three frozen validated files unchanged. | **RUN LOG → every FRZ_PRE/FRZ_POST** `changed=0` and **ARM MANIFESTS → repeated identical hashes**. |
| B reproduces the frozen ordinary Stage-5 output suite 8/8. | **C15 RESULTS → Arm B row**, independently supported by **SPEC frozen output hashes + B manifest rows**. |
| The three harmful cap arms complete Stage 5 and escape the existing Stage-5 checks when the framing-scope control is absent. | **C15 RESULTS → Arms rows RK_CAP200/RK_TYPECAP/RK_KAPPACAP**: `s5_exit=0`, `action_set_differs=final_action_list.csv`, `in_H=TRUE`, `caught_without=FALSE`. |
| H contains exactly RK_CAP200, RK_TYPECAP, RK_KAPPACAP. | **C15 RESULTS → Sets → H row**; independently reconstructable from the three `in_H=TRUE` raw CSV rows. |
| D_abl contains only RK_PRECAP. | **C15 RESULTS → Sets → D_abl row** and raw `caught_without` column. |
| `H \ D_abl` contains all three harmful cap arms and is nonempty. | **C15 RESULTS → Sets → H \ D_abl row**. |
| The framing-scope control misses no member of H in this seed set. | **C15 RESULTS →** `H \ caught-with = {}` **row**. |
| The measured over-blocking cost is RK_RANKONLY. | **C15 RESULTS → “flagged with the control but not in H” row**. |
| P1's B-clean condition is satisfied but its empty-escape-set condition is not. | **SPEC → Operational benefit predicate** and **C15 RESULTS → Predicate P1**. |
| No per-arm fixture result rows are supplied for C15. | **FIXTURE RESULTS per arm and path**: header followed by no data rows. |
| The frozen reconciliation's key/classification result is 0/0/0, while full-field recon has three known one-hour discrepancies. | **COORDINATOR NOTE N1**: one `dormant_h`, two `open_age_h`, labels agree; frozen 0/0/0 excludes those hour fields. |
| The harmful late-output arms preserve the ordinary portfolio computation. | **ARM MANIFESTS →** `portfolio_summary.csv`: B, RK_CAP200, RK_TYPECAP, RK_KAPPACAP and RK_RANKONLY all carry hash `b58fc...3167`; RK_BENIGN does as well. |
| No source variant is used by C15. | **SOURCE VARIANTS used by this control**: `(no source variants used)`. |

END C15 BUILDER REPORT
