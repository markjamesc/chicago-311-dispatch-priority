# A08 Validator Report — Independent First Pass (Grok)

**Role:** Validator only  
**Ablation:** A08 — shrink/loosen Stage 4 critical reconciliation field list  
**Constitution:** 1.0 (frozen)  
**Blindness:** No Builder pack was read. This pass uses only the frozen validator packet (SPEC, CONSTITUTION, RAW MANIFEST, EVIDENCE EXCERPTS).  
**Terminal adjudication:** Withheld. No KEEP / REVERT / HALT is returned.

**Evidence-scope note.** The specification authorizes read-only use of `/workspace/chicago-311-run` and `/workspace/chicago-311-dispatch-priority`. Those trees are not present in this validator environment. Hard facts below are therefore recomputed from the frozen excerpts and manifest hashes in the packet, plus internal arithmetic identities. Raw row files, R stdout, and byte-level SHA-256 verification of the named artifacts could not be re-executed here. The packet itself states that a RAW MANIFEST is present and that missing historical R stdout is not, by itself, a halt condition.

---

## 1. What is being tested (conceptual recon diff)

The locked Stage 4 recon is an **exact, SR_NUMBER-grained, two-path agreement check**. It is not a dashboard of totals.

**Locked critical list (full):**

| Layer | Fields / checks |
|---|---|
| Universe | SR_NUMBER key-set equality; `n_decision`; `n_inner`; `n_only_ra`; `n_only_rb` |
| Decision identity | `n_agree`; `n_disagree`; row-level classification/action labels on the inner join |
| Diagnosis | `dormant_h`, `open_age_h`, `peer_n`, `peer_p75_h` where present |
| Integrity | integrity clauses (audit text; see residual note) |
| Portfolio | counts of ESCALATE / INCONCLUSIVE / STANDARD |
| Fixtures | fixture IDs and expected vs observed results on both paths |

**Candidate reduction (as specified, not as an implemented patch):** replace that list with **aggregate decision counts plus a smaller label summary**. Exact membership of the reduced list is not enumerated field-by-field in this packet. The operational meaning of the candidate, taken from the SPEC, is:

- keep some form of portfolio / n_decision totals;
- drop or relax SR_NUMBER set equality, `n_only_*`, row-level label comparison, `n_disagree` identity, and the diagnostic clock/peer columns;
- do not rewrite the locked Stage 4 pack, TCD-IG rules, fixtures, or SQL nonjudgment boundary.

That is a **protocol ablation** (what the recon harness is required to look at), not a change to classification logic.

The semantic gap is therefore:

```
full recon  = same keys ∧ same labels ∧ (optionally) same diagnostic fields
reduced recon = same headline counts  (± a coarse label summary)
```

Those are not equivalent. Count equality is implied by exact recon; exact recon is not implied by count equality.

---

## 2. Independently recomputed hard facts

All figures below are taken from the frozen excerpts and checked for internal consistency. They are the post-repair production state unless marked “prior mismatch.”

### 2.1 Recon identities (post-fix)

From `RECON_SUMMARY.csv` and `EXACT_RECON_REPORT.md`:

| Fact | Value | Identity check |
|---|---|---|
| `n_ra` | 222,002 | given |
| `n_rb` | 222,002 | given |
| `n_inner` | 222,002 | `n_ra == n_inner + n_only_ra` holds |
| `n_only_ra` | 0 | given |
| `n_only_rb` | 0 | given |
| `n_agree` | 222,002 | `n_agree + n_disagree == n_inner` holds |
| `n_disagree` | 0 | given |
| SR_NUMBER sets | identical | stated; implied by `n_only_* = 0` and `n_inner = n_ra = n_rb` |

Post-fix recon status: **PASS (after clock-parse fix)**, dated 2026-09-19 13:46 CT in the excerpt.

### 2.2 Portfolio (κ = 2), both paths

From `EXACT_RECON_REPORT.md`, `RA_portfolio_counts.csv`, `RB_portfolio_counts.csv`:

| Path | n_decision | ESCALATE | INCONCLUSIVE | STANDARD | other |
|---|---|---|---|---|---|
| R-A | 222,002 | 131,968 | 6,377 | 83,657 | (not in excerpt) |
| R-B | 222,002 | 131,968 | 6,377 | 83,657 | `n_out_of_set = 23,191` |

Independent sum: \(131{,}968 + 6{,}377 + 83{,}657 = 222{,}002\). Portfolio partitions the decision set exactly.

R-B envelope reconstruction: \(222{,}002 + 23{,}191 = 245{,}193\), which matches the structural review’s “Open candidates ~245k → decision 222,002.”

Shared locked parameters in the excerpts: `kappa = 2`, `T_freeze = 2026-09-12 23:59:59` America/Chicago (RA file prints `CDT`). RA also records `rule_version = RA-tcd-ig-v1`.

Schema note (not a count disagreement): RA’s excerpted portfolio file does not carry `n_out_of_set`; RB’s does. That is an artifact-schema asymmetry, not a label mismatch on the decision set.

### 2.3 Fixtures

Both paths: **14/14 PASS**. Locked boundary example called out: **F03 → STANDARD** at κ = 2. Fixture result CSVs are named in the RAW MANIFEST (`r_a_fixture_results.csv`, `r_b_fixture_results.csv`) but their row contents are not excerpted beyond the 14/14 / F03 statement.

### 2.4 Prior production mismatch (the P1 incident)

From `EXACT_RECON_REPORT.md` and `structural_cross_review.md`, independently restated:

- First production judged comparison disagreed on **104 rows**.
- Disagreement was **uniform in direction**: R-A `STANDARD` vs R-B `ESCALATE` on those 104. No other pairing is attested.
- Key sets were already aligned enough for a 104-row inner disagreement to be named (the incident is described as label flips on shared SR_NUMBERs, not as only-RA / only-RB membership errors).
- `peer_n`, `peer_p75`, and κ **matched** on the disagreed rows.
- `dormant_h` differed by a **systematic ~5.0 hours** (America/Chicago offset).
- All 104 sat **within 5 hours of the κ × p75 threshold**.
- Mechanism: naive SQL wall clocks (`created_ts` / `mod_ts`) tagged UTC by `readr`. R-B’s POSIXct path kept the wrong instant; R-A’s `force_tz` happened to restore Chicago wall digits.
- Locked repair: always ingest clock columns as character and parse as `America/Chicago` wall time; do not `force_tz`; do not trust readr POSIXct for these columns.
- Repair surfaces named: `R-A/run_RA.R` (`parse_ts_chicago` + `clock_col_types`); `R-B/R/10_io_parse.R` (`rb_parse_ts` / `rb_normalize_open` / TSV + character cols).
- After repair: `n_disagree = 0`, portfolios identical, fixtures 14/14.

**Causal reconstruction (Validator, not copied from a Builder narrative).**  
CDT = UTC−5 in mid-September. If a Chicago wall timestamp is stored naive and then treated as UTC, the instant is five hours too early. Then

\[
\texttt{dormant\_h} = T_{\text{freeze}} - \texttt{mod\_ts}
\]

is inflated by ~5 h. Rows whose true dormancy lay in \((\kappa \cdot p75 - 5\text{h},\; \kappa \cdot p75)\) cross the `>=` ESCALATE threshold only on the skewed clock. That predicts exactly: (i) unidirectional STANDARD → ESCALATE flips, (ii) peer statistics unchanged, (iii) all flips inside a 5 h band of the threshold, (iv) R-B (wrong instant) = ESCALATE and R-A (recovered wall digits) = STANDARD. The frozen narrative is internally consistent with that mechanism.

**Implied pre-fix portfolios, under the attested “R-A already on Chicago wall, R-B skewed, 104 the only flips” reading:**

| Path | ESCALATE | STANDARD |
|---|---|---|
| R-A (pre-fix, if unchanged) | 131,968 | 83,657 |
| R-B (pre-fix, +104 ESC) | 132,072 | 83,553 |

This implication is **not printed as a first-run portfolio table** in the packet. It is the unique arithmetic consequence of “104 STANDARD(R-A) vs ESCALATE(R-B) on an otherwise identical decision set,” together with the post-fix totals and the statement that R-A’s parse happened to be the intended wall semantics. If both paths moved at repair time, the pre-fix totals would differ; the packet does not give first-run portfolio CSVs, so that branch remains unclosed. It does not affect the row-level facts that *are* attested: 104 IDs, one label pairing, ~5 h `dormant_h` bias, peers matched.

Scale: \(104 / 222{,}002 \approx 0.0468\%\) of the decision set. Material as a **semantic path defect** (near-threshold rule sensitivity + tz bug), not as a volume share.

### 2.5 Structural / process facts from the packet

- Baseline identifiers: `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, `T_freeze=2026-09-12 23:59:59 America/Chicago`, κ = 2.
- Two independent builders: R-A single-file tidyverse `run_RA.R`; R-B modular base/data.frame (`00_config.R`, `10_io_parse.R`, `20_integrity_and_classify.R`, `40_fixtures.R`) with named clauses I01–I06.
- SQL is attested as nonjudgment: no label columns; peer aggregates only; Source Gate checks absence of labels.
- Residual non-blocking note: parent-SR clause *wording* differs (`I05_parent_sr_present` vs design “orphan”); production labels still matched. Clause strings are audit text, not a demonstrated label disagreement.
- RAW MANIFEST lists, among others: `EXACT_RECON_REPORT.md`, `RECON_SUMMARY.csv`, `RECON_DISAGREE_IDS.csv`, both portfolio CSVs, both fixture-result CSVs, `SOURCE_GATE_REPORT.md`, `structural_cross_review.md`, `stage4_validation_status.json`, `workflow_gate_status.json`, framework SHA, lineage attestation.
- `RECON_DISAGREE_IDS.csv` is present in the manifest. Its body is not excerpted. Post-fix `n_disagree = 0` is compatible with an empty current disagree set, a historical 104-ID archive, or both; the packet does not say which.

### 2.6 Facts that could **not** be independently recomputed here

- Byte hashes of the RAW MANIFEST entries (files absent).
- The actual 104 SR_NUMBER values.
- Per-row `dormant_h`, `open_age_h`, `peer_n`, `peer_p75_h` tables.
- First-run (pre-fix) recon CSVs and R stdout.
- Fixture-level expected/actual tables beyond “14/14, F03 → STANDARD.”
- Source-row extracts and SQL envelope contents.

Those absences constrain *how far* recomputation can go. They do not contradict any printed identity in §2.1–§2.4.

---

## 3. What a reduced recon would and would not detect

Assume the candidate is exactly what the SPEC says: aggregate decision counts + a smaller label summary, without SR_NUMBER set equality, without `n_only_*`, without row-level labels, and without diagnostic clocks/peers.

### 3.1 This specific 104-row incident

**Would likely detect that “the two paths are not identical at portfolio grain,” if first-run portfolio totals were compared.**  
Under the unidirectional-flip reconstruction, ESCALATE would differ by 104 and STANDARD by 104. A count-only gate would have gone red. That is existence detection of a net transfer between two labels.

**Would not detect the incident the SPEC names.**  
The SPEC’s P1-failure clause is not “any inequality of totals.” It is the production **104-row clock-skew incident** and the **resulting label disagreements, including the 104 `STANDARD` (R-A) versus `ESCALATE` (R-B) rows**. Catching that object requires:

1. SR_NUMBER inner join (otherwise there are no “104 rows,” only two histograms);
2. row-level action labels (otherwise there is no STANDARD-vs-ESCALATE pairing);
3. `n_disagree` / disagree-ID materialization (`RECON_DISAGREE_IDS.csv` exists in the manifest for a reason);
4. `dormant_h` vs `peer_p75_h` (and `peer_n`, κ) to show the 5 h systematic bias and the “all 104 within 5 h of threshold” localization.

None of (1)–(4) is available from portfolio totals. A “smaller label summary” that only reprints ESCALATE/INCONCLUSIVE/STANDARD counts is the same information as the portfolio table.

**Diagnosis, not just detection.**  
The structural review treats the tz bug as a §10.6 “Wrong date / tz semantics” risk that was found because recon exposed near-threshold flips with matched peers and skewed `dormant_h`. That diagnostic path is exactly the part of the locked list the candidate proposes to drop. Without it, the plausible first-line stories for a 104-count imbalance include: eligibility filter drift, duplicate/legacy parser divergence, different Open normalization, different T_freeze instant, different κ, different peer grain, or a real rule bug. The frozen evidence shows those alternatives were *ruled out* by the fields the candidate would relax.

### 3.2 Defect classes the reduced list misses even when counts match

These are in-scope for P1 (“material path defects and semantic disagreements”), not hypothetical decoration.

| Defect | Full list | Aggregate + coarse summary |
|---|---|---|
| Offsetting label flips (k STANDARD↔ESCALATE in both directions) | `n_disagree = 2k`, IDs listed | portfolios can match; silent pass |
| Same counts, different SR_NUMBER universes | `n_only_ra` / `n_only_rb` > 0 | `n_decision` can match |
| Identical labels, different integrity-clause outcomes that later become load-bearing | clause compare (today residual-only) | invisible |
| Clock/parse skew **inside** a bin, not yet across κ×p75 | `dormant_h` distribution / pairwise delta | invisible until a flip accumulates |
| Peer-definition drift that moves the threshold under the same labels today | `peer_n`, `peer_p75_h` | invisible |
| Fixture pass / production disagree (or the reverse) | fixtures + production recon are separate gates | a reduced production recon does not replace F03–F14 |
| Unidirectional flips whose count is then “explained away” as rounding or late-arriving rows | disagree IDs force an account | a 104-count delta can be rationalized without IDs |

The 104-row event happened to be **non-offsetting**. Coverage that works only because the bug was one-sided is not the same coverage as exact recon. The SPEC forbids replacing exact recon with aggregate-only assertion “without documenting the lost detection coverage.” This packet’s candidate statement does not document that loss; the Validator records it here.

### 3.3 What the reduced list still sees

- Gross volume disagreement (`n_decision` mismatch).
- Net label-mix disagreement when flips do not cancel.
- After the repair: the current green portfolio (`131,968 / 6,377 / 83,657`) — which is also what full recon reports, because full recon is stronger.

So the reduced list is a **lossy projection** of the full list. On the frozen *post-fix* surface it would also read PASS. On the frozen *pre-fix* surface it would likely have flagged a count mismatch and then stopped short of the 104-row / 5 h diagnosis.

---

## 4. P1 assessment (no terminal call)

**P1:** a shorter or looser recon is faster/cheaper **while still detecting material path defects and semantic disagreements.**

**P1 fails if** the full critical list was necessary to catch the 104-row clock-skew incident or the resulting label disagreements, including the 104 STANDARD vs ESCALATE rows.

Independent reading of the frozen evidence:

1. **Speed/cost half of P1 is not evidenced.** No timing, I/O, or reviewer-hour measurements appear in the packet. “Shorter list is cheaper” is plausible and unmeasured. Constitution §6 rejects a subjective “the change is better” as a predicate; the speed claim is in that neighborhood until measured against frozen artifacts.
2. **Detection half of P1 is not established.**  
   - Semantic disagreement, as used in the locked recon, is **row-level label disagreement on a shared SR_NUMBER**. That is `n_disagree` and the disagree-ID set, not a histogram.  
   - Catching *this* incident *as described* used the full list: key join + labels + `dormant_h` + peers.  
   - A count-only gate would have seen a 104-wide net transfer (on the unidirectional reconstruction) and would have missed the row identities, the STANDARD/ESCALATE pairing as a set, and the tz mechanism.  
   - The same gate would miss the entire family of offsetting or universe-mismatch defects.
3. Therefore the **predeclared failure clause of P1 is met as a factual condition**: the full critical list was necessary to catch the 104-row clock-skew incident *and* the 104 STANDARD vs ESCALATE disagreements as such. A looser recon is not shown to “still detect” those disagreements; it is shown, at best, to detect a coincident 104-count imbalance.

P1 is an operational predicate that must be checkable from frozen artifacts without asking the Builder what it meant. On that standard, P1 is **not satisfied** by this packet. That is a Validator finding on the predicate, not an adjudication under §7–§9.

---

## 5. Fixture implications

- Fixture suite `fixtures-v1-tcd-ig` is an **unchanged surface**. A08 is not allowed to rewrite expecteds.
- Both paths already lock **14/14 PASS**, including **F03 → STANDARD** at κ = 2. F03 sits on the same threshold family as the 104 production flips (near κ×p75). That is why F03 is called out in the recon report.
- Fixtures are synthetic / hand-specified cases. They did **not** substitute for production exact recon: the 104-row event was a production-scale parse asymmetry, not a fixture miss. The structural review lists F13 (unparseable clocks → INCONCLUSIVE) and F07/F08 (duplicate/legacy) as coverage for other risks; none of those is the tz-tagging bug that produced the 104.
- Dropping production row-level recon does not make the 14 fixtures a sufficient stand-in. Fixtures can stay green while 104 production rows disagree — which is what actually happened before the clock fix, relative to any fixture-only story.
- If the candidate also intended to shrink *fixture* recon to aggregates, that is not stated. Even if it were, F03 is a single-row expected label; an aggregate summary of 14 fixtures can hide one wrong label if another fixture offsets it. The locked rule is exact expected vs observed per fixture ID.

---

## 6. Unchanged surfaces (regression boundary)

The SPEC requires these to remain unchanged. Nothing in the frozen excerpts shows a rewrite of:

- SQL nonjudgment boundary (no labels in SQL; Source Gate);
- TCD-IG rules and `stage3-v1-tcd-ig`;
- exact fixture expecteds / `fixtures-v1-tcd-ig`;
- SR_NUMBER grain;
- the locked Chicago 311 Stage 4 pack;
- κ = 2 and `T_freeze`.

A08 as specified is a **recon-harness field-list** change. If a later implementation silently altered parse rules, eligibility, or labels in order to make aggregates “good enough,” that would be an undeclared semantic change. This packet contains no candidate code diff to test for that. Validator treats “no pack rewrite” as a constraint to be enforced, not as a verified code fact (no candidate tree is in scope here).

---

## 7. Risks

1. **False PASS on offsetting semantic disagreement.** Highest-severity coverage hole. Already realized in miniature: the only reason counts would have moved in 104-row lockstep is that every flip had the same direction.
2. **Loss of disagree-ID artifact.** `RECON_DISAGREE_IDS.csv` is how an incident becomes a finite, auditable set. Aggregates cannot produce it.
3. **Loss of tz/clock diagnostics.** `dormant_h` + `peer_p75_h` were the reason the 5 h CDT story is a finding rather than a guess. Future clock regressions (DST boundary, `force_tz` reintroduced, POSIXct shortcut) land in the same place.
4. **Universe drift hidden by equal `n_decision`.** Without `n_only_ra` / `n_only_rb` / key-set equality, two paths can judge different Open subsets of the same size.
5. **Integrity-clause vocabulary already differs** (I05 vs “orphan”). Today that is attested as non-blocking because labels matched. A looser recon that also drops labels would have no remaining proof that the wording drift is harmless.
6. **Portfolio schema already differs** (`n_out_of_set` only on RB). Aggregate comparison across non-identical schemas is an easy place to compare the wrong columns and call it agreement.
7. **Benefit unmeasured.** No frozen timing or cost artifact. Even a coverage-preserving shrink would still need that for P1’s “faster/cheaper” limb.
8. **Counterfactual contamination.** The packet’s current recon is green *because* the clock bug was found and fixed with the full list. Using the post-fix green aggregates as evidence that a short list “would have been enough” inverts the causal order.
9. **Evidence-environment gap.** Validator could not hash-check the manifest or re-query source rows. That limits how hard the “independent recompute” can be, and it is recorded rather than papered over.

---

## 8. Claim → evidence map

| Claim | Evidence in this packet | Validator status |
|---|---|---|
| Post-fix decision sets identical at 222,002 | `RECON_SUMMARY.csv`; recon report | Internally consistent |
| Post-fix `n_disagree = 0` | same | Internally consistent |
| Post-fix portfolios identical at 131,968 / 6,377 / 83,657 | recon report + both portfolio CSVs | Sum checks; both files agree on the three labels |
| RB `n_out_of_set = 23,191` | `RB_portfolio_counts.csv` | Consistent with ~245k envelope note |
| Fixtures 14/14, F03 → STANDARD | recon report; structural review | Attested; fixture CSV bodies not excerpted |
| Prior disagreement = 104 rows, STANDARD vs ESCALATE | recon report; structural review | Attested in two excerpts; IDs not excerpted |
| Peers matched; `dormant_h` ~5 h systematic; all 104 near threshold | recon report; structural review | Attested; diagnostic columns not dumped |
| Cause = naive clocks tagged UTC / asymmetric POSIXct | recon report; §10.6 table | Attested; mechanistically consistent with CDT |
| Repair = character → America/Chicago wall parse on both paths | recon report | Attested as locked rule; source files not readable here |
| Independence of R-A and R-B trees | structural review independence attestation | Attested; not re-verified from trees |
| SQL nonjudgment | structural review; Source Gate named in manifest | Attested; SQL not re-read here |
| RAW MANIFEST complete enough to name the recon artifacts | hash list in packet | Names present; bytes absent from this environment |
| Candidate states *exactly* which fields are removed | SPEC describes the class of reduction | **Not field-enumerated.** Gap against SPEC sentence “The candidate reduction must state exactly which fields are removed or relaxed.” |
| Reduced recon preserves detection coverage | none | **Not shown.** Opposite is shown for the 104-row incident as specified |
| Reduced recon is faster/cheaper | none | **Not shown** |
| P1 holds | P1 text + incident record | **Not established** (see §4) |

---

## 9. Blocking objections (supported by frozen evidence; not an adjudication)

These are objections an Adjudicator would have to dispose of. They are not a verdict.

**B1 — P1’s own failure clause is triggered.**  
The full critical list was necessary to catch the 104-row clock-skew incident *as* 104 SR_NUMBER-level STANDARD vs ESCALATE disagreements and to attribute them to a ~5 h `dormant_h` bias. Aggregate counts do not identify those rows or that pairing. SPEC: P1 fails in that case.

**B2 — Lost detection coverage is not documented by the candidate.**  
SPEC regression rule: do not replace exact recon with majority vote or aggregate-only assertion without documenting lost coverage. Offsetting flips, key-set mismatch at equal `n_decision`, and diagnostic-only clock skew are uncovered and unnamed in the candidate statement.

**B3 — Candidate field list is not exact.**  
SPEC requires the reduction to state exactly which fields are removed or relaxed. This packet gives a class (“aggregate decision counts and a smaller label summary”), not a closed field inventory. That leaves “smaller label summary” ambiguous (portfolio three-way table? `n_agree` without IDs? fixture pass-count only?).

**B4 — Speed/cost limb of P1 has no frozen measurement.**  
Constitution §6: the predicate must be checkable from frozen artifacts. No runtime or cost artifact is in the manifest excerpts.

**B5 — Post-fix green aggregates are not evidence that a short list would have caught the pre-fix defect.**  
Using the repaired identical portfolios as a success signal for a looser recon confuses the outcome of full recon + repair with the power of the proposed check.

**B6 — Environment cannot re-hash or re-query.**  
Independent recomputation here is excerpt-internal. Disagree IDs, first-run portfolios, and file hashes were not mechanically re-derived. This does not invent a new success criterion; it limits how much additional confirmation exists beyond the printed tables.

Non-objections (recorded so they are not treated as blockers):

- Role split in the SPEC (Builder=DeepSeek, Validator=Grok, Adjudicator=ChatGPT) is well-formed on paper; this pass did not see a Builder artifact.
- Post-fix mechanical identities in the excerpts do not contradict each other.
- Integrity-clause wording drift is explicitly classified as non-blocking in the structural review because labels matched.
- Historical R stdout is not required given the packet’s adjudicator note plus RAW MANIFEST.

---

## 10. Unchanged / out-of-scope for this pass

- No rewrite of locked labels, fixtures, or Stage 4 pack was attempted.
- No new extract, no browser AI, no candidate implementation.
- No comparison to a Builder narrative (blind).
- No constitutional KEEP / REVERT / HALT token is issued.

---

## 11. Validator summary

The frozen post-repair Stage 4 recon is internally coherent at the printed grain: 222,002 / 222,002 keys, 0 disagrees, identical κ = 2 portfolios \(131{,}968 / 6{,}377 / 83{,}657\), fixtures 14/14 with F03 → STANDARD. Those are the hard facts of the *current* locked surface.

The ablation does not ask whether that surface is presently green. It asks whether a **shorter recon field list** would still have caught material path defects, in particular the attested **104-row STANDARD vs ESCALATE clock-skew**.

Independent recompute of that incident: peers and κ matched; `dormant_h` was biased by a systematic ~5 h CDT/UTC parse error; the 104 rows all sat inside that 5 h band of κ×p75; R-B’s wrong instant produced ESCALATE where R-A produced STANDARD. Reconstructing *that object* uses SR_NUMBER equality, row-level labels, `n_disagree`, and the diagnostic clock/peer fields — the exact layer the candidate drops.

A portfolio-only check might have shown a 104-wide net label transfer if the first-run totals had been compared. That is not the same as catching the 104-row disagreement set, and it does not cover offsetting or universe-mismatch defects. P1’s detection requirement is therefore not met on the frozen evidence; P1’s cheaper/faster requirement is not measured at all.

**End of Validator first pass. Terminal adjudication withheld.**