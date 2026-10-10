# C36 Builder Report — Independent First Pass

## 1. Role attestation and ablation ID.

I attest that I am acting **only as Builder** for **C36**, Remaining Ablation Program catalog #36, **“No Re-Judging Validation Labels.”** I am performing an independent first pass and am blind to the Validator’s first-pass output. The frozen role assignment is Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. The target is Stage 5, under the frozen premise that analysis may add insight but may not reclassify Validation-Gate labels.

The frozen control requires a pre-release label-consistency check ensuring that label-derived Stage-5 outputs remain consistent with validated labels. The C36 ablation removes that check while leaving Stage 5’s own independent input-count checks in place.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

**Conceptual removal.** The ablated regime removes the final label-consistency check. The remaining Stage-5 checks verify frozen input counts—`n_decision`, `n_ESCALATE`, `n_INCONCLUSIVE`, `n_STANDARD`, and validated-list count—but do not independently compare the downstream label-derived outputs against the frozen validated labels. The seeded arms therefore test whether Stage 5 can pass those input checks and subsequently re-judge labels in analysis.

**RJ_INC2ESC.** Immediately after the independent checks have passed, the seed mutates `classification`, promoting sufficiently dormant `INCONCLUSIVE` rows to `ESCALATE`:

```
ra <- ra %>% mutate(
  classification = ifelse(
    classification == "INCONCLUSIVE" & dormant_h >= 8760,
    "ESCALATE",
    classification
  )
)
```

The insertion occurs after `stopifnot(all(chk$pass))`, so the frozen count check observes the unmodified labels and the downstream analyses observe the re-judged labels.

**RJ_KAPPA3.** Again after the independent checks pass, the seed demotes validated `ESCALATE` rows that do not satisfy a `3 * peer_p75_h` threshold:

```
ra <- ra %>% mutate(
  classification = ifelse(
    classification == "ESCALATE" & dormant_h < 3 * peer_p75_h,
    "STANDARD",
    classification
  )
)
```

It also changes the reported portfolio parameter from:

```
kappa = 2
```

to:

```
kappa = 3
```

Thus both the classification used by subsequent analysis and the reported κ are changed after the frozen input-count check.

**RJ_OPENAGE.** After the independent checks pass, the seed uses the diagnostic-only `open_age_h` field to demote some validated `ESCALATE` labels:

```
ra <- ra %>% mutate(
  classification = ifelse(
    classification == "ESCALATE" & open_age_h < 720,
    "STANDARD",
    classification
  )
)
```

This directly tests Stage-5 re-judging on a field the seed itself describes as diagnostic-only.

**RJ_PRECHECK.** This seed uses the same substantive re-judging rule as RJ_INC2ESC but deliberately places it **before** the frozen independent checks:

```
ra <- ra %>% mutate(
  classification = ifelse(
    classification == "INCONCLUSIVE" & dormant_h >= 8760,
    "ESCALATE",
    classification
  )
)
```

The subsequent frozen count checks therefore see the altered classifications. This is the placement-control arm for testing whether Stage 5’s existing count checks catch re-judging when it occurs before rather than after those checks.

**RJ_BENIGN.** This arm does not mutate `classification`. It adds a new descriptive analysis of already validated `ESCALATE` rows:

```
esc_bin <- ra %>%
  filter(classification == "ESCALATE") %>%
  mutate(peer_n_bin = cut(peer_n, c(0, 99, 999, 9999, Inf))) %>%
  count(peer_n_bin, name = "n_ESCALATE")

write_csv(
  esc_bin,
  file.path(out, "escalate_by_peer_n_bin.csv")
)
```

Its purpose is to test whether the control incorrectly blocks added analytical insight that leaves validated labels unchanged.

## 3. Hard mechanical facts table.

| Mechanical fact | Independent recomputation / observation | Status |
| --- | --- | --- |
| Total arms | `1` clean B + `5` seeded arms = **6 arms**. | **Recomputed** from `C36_arms.csv`. |
| Stage-5 exit distribution | Exit `0`: B, RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE, RJ_BENIGN = **5**. Exit `1`: RJ_PRECHECK = **1**. Identity: `5 + 1 = 6`. | **Recomputed** from raw arm rows; independently consistent with the run log. |
| Freeze checks before Stage 5 | All six arms show `FRZ_PRE changed=0`: **6/6 unchanged**. | **Recomputed** from six run-log rows. |
| Freeze checks after Stage 5 | All six arms show `FRZ_POST changed=0`: **6/6 unchanged**. | **Recomputed** from six run-log rows. |
| `VALIDATION_FREEZE.sha256` equality | All six arms have hash `65b910...b5f8fd`, 335 bytes: **1 unique hash across 6 arms**. | **Recomputed** from arm manifests. and manifest continuation through RJ_PRECHECK. |
| Frozen `validated_action_list.csv` equality | All six arms carry hash `2bffa38b...61954a`, 13,625,648 bytes: **6/6 identical to B**. | **Recomputed** from manifests. B and seeded-arm entries show the same hash/size. |
| Frozen `RA_classifications.csv` equality | Hash `c099e092...ae0d9`, 22,271,481 bytes in every arm: **6/6 identical**. | **Recomputed** from manifests. |
| Frozen `RB_kappa_grid_counts.csv` equality | Hash `7a18fcb1...52c8a`, 164 bytes in every arm: **6/6 identical**. | **Recomputed** from manifests. |
| Frozen validated-state arm/file comparisons | Three frozen files × six arms = **18 arm-file instances**; all use the same corresponding B hash. | **Recomputed** from the preceding three cross-arm hash equalities. |
| `FRZ_PRE.txt` / `FRZ_POST.txt` manifest equality | Each is hash `81ad521a...ae98f`, 343 bytes in every arm. Thus **12/12 recorded PRE/POST freeze files** share that hash, and PRE=POST within each of the six arms. | **Recomputed** from manifests. Representative rows for B and RJ_BENIGN are explicit; the same values recur in the remaining arm manifests. |
| Arm-B frozen Stage-5 reproduction | The eight frozen Stage-5 output hashes listed in the SPEC all match the eight corresponding B manifest hashes: **8/8**. | **Recomputed**, and independently agrees with the runner’s “YES (8/8)” statement. |
| B with-control result | B is reported clean. | **Quoted** from Arm-B result. |
| RJ_INC2ESC differing label-derived outputs | Listed differences: portfolio, escalate-by-type, top25, inconclusive-by-clause, dormancy summary = **5 differing outputs**. | **Recomputed** by counting the raw semicolon-delimited entries. |
| RJ_KAPPA3 differing label-derived outputs | Portfolio, escalate-by-type, top25, dormancy summary = **4 differing outputs**. | **Recomputed** from raw row. |
| RJ_OPENAGE differing label-derived outputs | Portfolio, escalate-by-type, top25, dormancy summary = **4 differing outputs**. | **Recomputed** from raw row. |
| RJ_BENIGN standard Stage-5 differences | Differing-vs-B field is empty = **0** standard output differences. Added-files field contains exactly **1** file, `escalate_by_peer_n_bin.csv`. | **Recomputed** from raw row and confirmed by manifest. |
| RJ_PRECHECK completed label-derived differences | Stage 5 exits `1` before normal completion; raw row records **0 listed downstream output differences** and `caught_without=TRUE`. | **Recomputed/quoted** from the raw row; absence of completed downstream outputs is also visible in its shortened manifest. |
| Post-check arms’ independent-check artifact | B, RJ_BENIGN, RJ_INC2ESC, RJ_KAPPA3, and RJ_OPENAGE all have the exact `independent_checks_critical_counts.csv` hash `4aca9c...fd146`, 190 bytes = **5/5 identical among arms that reached the post-check mutation pattern/normal completion**. RJ_PRECHECK instead has hash `e6105c...2cf6`, 192 bytes. | **Recomputed** from manifests. This mechanically distinguishes the before-check seed from the after-check seeds. |
| Portfolio hash relation | Among the five arms that complete Stage 5, B and RJ_BENIGN share the same portfolio hash; RJ_INC2ESC, RJ_KAPPA3, and RJ_OPENAGE each have a different hash. Therefore **4 unique portfolio hashes across 5 completed arms**. | **Recomputed** from manifests. |
| Exact numerical portfolio deltas | The packet supplies portfolio **hashes and byte sizes**, but not the actual CSV rows/values for the seeded arms. Exact changes in `n_ESCALATE`, `n_INCONCLUSIVE`, `n_STANDARD`, or percentages therefore cannot be numerically recomputed from the supplied evidence. | **Not computable from supplied table contents.** |
| `kappa_sensitivity.csv` across completed arms | B, RJ_BENIGN, RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE all use hash `7a18fcb1...52c8a`: **5/5 identical** among completed arms. | **Recomputed** from manifests. Representative B and benign rows plus harmful-arm manifests establish equality. |
| `capacity_coverage_note.csv` across completed arms | Same hash `4bf45230...11609`, 644 bytes in all five completed arms: **5/5 identical**. | **Recomputed** from manifests. |
| `inconclusive_by_clause.csv` relation | RJ_INC2ESC differs from B; B, RJ_BENIGN, RJ_KAPPA3, RJ_OPENAGE share the B hash. Thus **1 of 4 seeded completed arms differs** on this file and **3 of 4 do not**. | **Recomputed** from manifests/raw difference lists. |
| Harm set H | From raw `in_H=TRUE`: `{RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}`; cardinality **3**. | **Recomputed** from `C36_arms.csv`, agrees with RESULTS. |
| Caught-with-control set | Raw `caught_with=TRUE` for the same three arms; cardinality **3**. | **Recomputed**. |
| `D_abl` / caught-without set | Only RJ_PRECHECK has `caught_without=TRUE`: `{RJ_PRECHECK}`; cardinality **1**. | **Recomputed**. |
| `H \ D_abl` | `{INC2ESC,KAPPA3,OPENAGE} \ {PRECHECK}` = `{INC2ESC,KAPPA3,OPENAGE}`; cardinality **3**. | **Recomputed set difference**; agrees with RESULTS. |
| `H \ caught-with` | The sets are identical, so difference = `∅`; cardinality **0**. | **Recomputed**. |
| `caught-with \ H` | Again identical sets, so difference = `∅`; cardinality **0**. | **Recomputed**; this is the observed control over-blocking count among the seeded arms. |
| Harm detection without control | Of the **3** completed harmful arms in H, **0** are in `D_abl`; hence **3/3 escape** the remaining Stage-5 exit-based detection rule. | **Recomputed** from H and `D_abl`. |
| Harm detection with control | All **3/3** H arms are in `caught_with`. | **Recomputed** from equal sets H and caught-with. |
| Benign-arm false positive | RJ_BENIGN: `in_H=FALSE`, `caught_with=FALSE`, `caught_without=FALSE`; therefore **0 benign flags** for this benign seed. | **Recomputed** from raw row. |
| Source variants | **0** source variants were used. | **Quoted**. |
| Source preflight counts | `src_open_candidates`: expected 245,193 and observed 245,193. `src_peer_stats`: expected 104 and observed 104. Both identities match exactly. | **Recomputed equality** from SPEC/preflight. |
| Seed-script hash verification | Five C36 Stage-5 seed scripts are listed in preflight and the runner-side file table with matching hashes: **5/5 seed-script hashes agree across the two evidence sections**. | **Recomputed cross-table equality**. |
| Known full-field frozen-pair mismatches | `dormant_h = 1` row and `open_age_h = 2` rows; `1 + 2 = 3` total affected rows. All three have agreeing labels. | **Recomputed total from quoted N1 component counts.** |
| Frozen reconciliation key/classification result | Coordinator N1 states the applicable frozen reconciliation definition is only-RA, only-RB, classification disagreement and describes clean B as `0/0/0`. | **Quoted**; the packet does not provide an underlying reconciliation-count table from which to independently reproduce those three zeroes. |
| `n_agree + n_disagree = n_inner` identity | No `n_agree`, `n_disagree`, or `n_inner` values are supplied anywhere in the evidence packet. | **Not recomputable from supplied evidence; no numbers inferred.** |
| Fixture-row count in supplied fixture evidence table | Header is present, followed by **0 fixture data rows**. | **Recomputed from the supplied fixture-results section.** |
| Numerical fixture pass/fail totals | With zero fixture rows supplied, no per-fixture expected/observed/pass totals can be recomputed from this packet. | **Not computable from supplied fixture table.** |

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen P1 condition requires both: (a) clean arm B, defined as Stage-5 exit `0`, all eight Stage-5 outputs equal to the frozen outputs, and no B flag from the label-consistency control; and (b) `H \ D_abl = ∅`.

The evidence establishes the first conjunct. B exits `0`; its eight Stage-5 output hashes independently match the frozen eight outputs; and the results record the with-control B check as clean.

The second conjunct is false on the observed sets:

`H = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}`

`D_abl = {RJ_PRECHECK}`

Therefore:

`H \ D_abl = {RJ_INC2ESC, RJ_KAPPA3, RJ_OPENAGE}`

and:

`|H \ D_abl| = 3 ≠ 0`.

This arithmetic is independently recoverable from the raw arm rows and agrees with the runner’s stated set.

Mechanically, all three harmful after-check re-judging arms complete Stage 5 with exit `0`; none is caught by the remaining exit-based rule. The before-check version, RJ_PRECHECK, exits `1`. Thus the supplied experiment isolates **placement relative to the independent count checks**: the count checks detect the re-judging when it occurs before them, but the same class of re-judging can proceed to changed label-derived outputs when performed after them.

The with-control comparison is:

`caught_with = H`

so:

`H \ caught_with = ∅`

and:

`caught_with \ H = ∅`.

Within the declared seeded arms, the control therefore catches all three defined harms and does not flag the benign added-analysis arm.

Accordingly, under the exact frozen logical predicate, **P1 evaluates false because** `H \ D_abl` **is nonempty with three members**. This is an assessment of the predicate only, not a terminal ablation state.

## 5. Fixture and reconciliation implications.

This is explicitly a **Stage-5-only** ablation. C36 does not rerun R-A or R-B; every arm begins from the same frozen validated state. The frozen classification/action artifacts remain byte-identical across every arm before and after Stage 5.

The fixture-results section contains only its header and no fixture rows. Therefore there are no C36 per-arm fixture actual/expected rows from which to recompute fixture pass counts. That absence is consistent with the declared Stage-5-only design rather than evidence that C36 executed a fresh classification fixture suite.

The reconciliation implication is similarly bounded. C36 does not create a new R-A/R-B reconciliation result. It inherits the frozen validated state. The disclosed frozen-pair finding is:

- `dormant_h`: **1 mismatch**;
- `open_age_h`: **2 mismatches**;
- total affected rows: **3**;
- each difference is exactly **1.000 h**;
- all three affected rows remain `ESCALATE` on both paths, so label agreement is preserved.

The proposed daylight-saving ambiguous-hour explanation is explicitly **unconfirmed** and must remain an open finding rather than a causal conclusion. The frozen reconciliation definition used for the control concerns only key-set differences (`only-RA`, `only-RB`) and classification disagreement; under that definition the disclosed B result is `0/0/0`. The `dormant_h` and `open_age_h` full-field differences are outside that frozen `0/0/0` definition.

Most importantly for C36, none of the Stage-5 seeds alters the three frozen validation artifacts. FRZ_PRE and FRZ_POST both report `changed=0` for all six arms, and the arm manifests retain identical hashes for `RA_classifications.csv`, `RB_kappa_grid_counts.csv`, and `validated_action_list.csv`. The harmful effect therefore occurs **inside downstream Stage-5 analysis state/output generation**, not by mutating the frozen Validation-Gate artifacts themselves.

## 6. Semantic/regression risks and unchanged surfaces.

The principal semantic risk demonstrated by C36 is a **post-validation semantic fork**: Stage 5 can read an unchanged, correctly frozen validation state, pass checks against that state, and then mutate its in-memory `classification` field before generating label-derived analysis outputs. The on-disk validated labels stay intact while the released analytical summaries cease to represent them.

The evidence demonstrates three distinct versions of that risk:

1. **Category promotion:** RJ_INC2ESC reinterprets a validated `INCONCLUSIVE` case as `ESCALATE` using a one-year dormancy threshold. It completes normally and changes all five declared label-derived output families.
2. **Threshold/specification substitution:** RJ_KAPPA3 changes the operative analysis threshold from the validated κ=2 regime to an in-analysis κ=3 re-judgment and reports κ=3. It completes normally and changes four of the five label-derived output families.
3. **Diagnostic-field reclassification:** RJ_OPENAGE changes a validated `ESCALATE` to `STANDARD` based on `open_age_h < 720`, despite that field being declared diagnostic-only by the seed description. It also completes normally and changes four declared label-derived output families.

The RJ_PRECHECK contrast narrows the mechanism. The same INC2ESC-style re-judging placed before the independent count checks produces Stage-5 exit `1`, whereas the corresponding mutation placed after those checks exits `0`. Thus the evidence does not show that Stage 5 has no checking capability; it shows that the existing checks are **order-sensitive** and protect their input state rather than downstream label-derived semantics.

The benign arm establishes an unchanged semantic surface for legitimate added analysis. RJ_BENIGN adds exactly one file, `escalate_by_peer_n_bin.csv`, while all eight standard Stage-5 outputs remain hash-identical to B and neither `in_H` nor `caught_with` is true. This is the packet’s direct false-positive probe for adding insight without relabeling.

Several surfaces remain mechanically unchanged across the successful harmful arms despite the changed label-derived outputs:

- the frozen R-A classifications;
- the frozen R-B κ-grid counts;
- the validated action list;
- `independent_checks_critical_counts.csv`;
- `kappa_sensitivity.csv`;
- `capacity_coverage_note.csv`.

This separation is significant: unchanged input artifacts and unchanged count/check outputs are not sufficient to establish unchanged downstream classification semantics.

The output-difference pattern also matches each seed’s intended semantic reach. RJ_INC2ESC is the only harmful completed arm that changes `inconclusive_by_clause.csv`, consistent with directly removing some rows from the `INCONCLUSIVE` class. RJ_KAPPA3 and RJ_OPENAGE demote from `ESCALATE` to `STANDARD`, so their `inconclusive_by_clause.csv` remains hash-identical to B while their ESCALATE-related and portfolio outputs differ. This is a semantic consistency check derived from the manifests rather than merely from the runner’s H labels.

The known N1 clock discrepancy remains an unchanged surface and should not be conflated with the seeded effects. It existed in the frozen pack before execution, affects three full-field hour values by exactly 1.000 h, preserves labels, and appears across controls. The packet does not establish daylight saving time as its cause.

No source variants were used, no new extract was taken, and preflight source counts match their expected values. Thus the observed Stage-5 differences are not accompanied by declared source-data substitutions.

## 7. Claim → evidence map.

| Claim | Evidence location |
| --- | --- |
| C36 tests removal of the label-consistency check while retaining Stage-5 input-count checks. | **SPEC → “Control under test” / “Exact change being tested”**, lines 37–42. |
| C36 is Stage-5-only and begins from frozen validated artifacts. | **SPEC → “Stage-5-only arm design”**, lines 47–69. |
| Harm H is defined in terms of completed Stage-5 label-derived output disagreement or disagreeing added labels/totals. | **SPEC → “Harm set H”**, lines 71–77. |
| RJ_INC2ESC mutates labels after the independent checks. | **SEED DIFFS → RJ_INC2ESC**, inserted line 531 after `stopifnot`. |
| RJ_KAPPA3 mutates validated ESCALATE labels and changes reported κ from 2 to 3. | **SEED DIFFS → RJ_KAPPA3**, lines 536–553. |
| RJ_OPENAGE re-judges using diagnostic-only `open_age_h`. | **SEED DIFFS → RJ_OPENAGE**, lines 556–565. |
| RJ_PRECHECK places re-judging before the independent checks. | **SEED DIFFS → RJ_PRECHECK**, lines 567–576. |
| RJ_BENIGN adds a peer-count-bin table without changing labels. | **SEED DIFFS → RJ_BENIGN**, lines 578–588. |
| B exits 0 and reproduces all eight frozen Stage-5 outputs. | **C36_RESULTS → Arm B**, row/statement at lines 360–361; independently backed by B output hashes in **ARM MANIFESTS**, lines 419–426. |
| RJ_INC2ESC completes, changes five label-derived outputs, is in H, is caught with the control, and is not caught without it. | **C36_arms.csv → RJ_INC2ESC row**, line 389. |
| RJ_KAPPA3 completes, changes four label-derived outputs, is in H, is caught with the control, and is not caught without it. | **C36_arms.csv → RJ_KAPPA3 row**, line 390. |
| RJ_OPENAGE completes, changes four label-derived outputs, is in H, is caught with the control, and is not caught without it. | **C36_arms.csv → RJ_OPENAGE row**, line 391. |
| RJ_PRECHECK exits 1 and is the sole caught-without arm. | **C36_arms.csv → RJ_PRECHECK row**, line 392; also **RUN LOG**, lines 341–343. |
| RJ_BENIGN completes, adds one file, causes no standard-output difference and is not flagged. | **C36_arms.csv → RJ_BENIGN row**, line 393. |
| `H={RJ_INC2ESC,RJ_KAPPA3,RJ_OPENAGE}` and `D_abl={RJ_PRECHECK}`. | **C36_RESULTS → Sets**, lines 373–377, independently derivable from rows 389–393. |
| `H \ D_abl` contains all three harmful completed arms. | **C36_RESULTS → Sets**, line 377; direct set subtraction from the raw arm table. |
| The control misses none of H and produces no seeded-arm over-blocking in this experiment. | **C36_RESULTS → Sets**, lines 378–379. |
| The frozen P1 condition requires clean B plus empty `H \ D_abl`. | **SPEC → Operational benefit predicate P1**, lines 91–98. |
| P1’s set condition is false because `H \ D_abl` has three members. | **C36_RESULTS → Predicate P1**, lines 381–383, independently recomputed above. |
| Frozen validation artifacts are unchanged across every arm before and after Stage 5. | **RUN LOG**, lines 329–346, plus **ARM MANIFESTS** frozen-file hash rows. |
| The supplied fixture table contains no data rows. | **FIXTURE RESULTS**, lines 396–398. |
| N1 consists of one `dormant_h` and two `open_age_h` one-hour mismatches, with labels agreeing; DST is only a possible, unconfirmed explanation. | **COORDINATOR NOTE N1 / SPEC known finding**, lines 18–20 and 44–46. |
| No source variants were used. | **SOURCE VARIANTS**, lines 323–324. |
| Source preflight counts are 245,193 and 104 and match the expected frozen counts. | **PREFLIGHT**, lines 307–309, cross-checked against **SPEC frozen data pack**, lines 31–32. |
| Exact numerical portfolio count/percentage deltas cannot be recomputed because the packet provides the generated files’ hashes/sizes but not their CSV contents. | **ARM MANIFESTS** provide portfolio hashes only; e.g. B line 426 and harmful variants’ manifest rows. |

END C36 BUILDER REPORT
