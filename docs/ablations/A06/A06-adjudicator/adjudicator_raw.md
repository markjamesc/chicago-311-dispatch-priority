# A06 Adjudicator — DeepSeek (TERMINAL DECISION)

**Decision:** REVERT

**Constitution:** 1.0  
**Ablation ID:** A06  
**Role:** Adjudicator only

---

## 1. HALT screening

| HALT condition | Status |
|---|---|
| Hard mechanical conflict between Builder and Validator | No |
| Required raw evidence missing | No — RAW MANIFEST present; adjudicator note says do not HALT for missing historical R stdout |
| Hash / frozen version mismatch | No — baseline hash cited consistently |
| Baseline or constitution changed mid-run | No |
| Role separation violated | No — Builder=Grok, Validator=ChatGPT, Adjudicator=DeepSeek |
| Information barrier breached before first-pass freeze | No — both first passes declare blindness |
| Benefit predicate not operationally defined before execution | No — P1 stated in frozen spec |
| Adjudicator cannot determine authoritative evidence pack | No |

P1 does not fail in the sense of forcing REVERT at the HALT gate; the P1 fail condition is a REVERT trigger under the adjudicator note, not a HALT trigger. No HALT condition is present.

---

## 2. Hard mechanical agreement (Constitution §4)

Builder and Validator agree on the frozen mechanical facts:

| Fact | Builder | Validator | Agreement |
|---|---:|---:|---|
| n_ra / n_rb / n_inner | 222,002 | 222,002 | Yes |
| n_only_ra / n_only_rb | 0 / 0 | 0 / 0 | Yes |
| n_agree / n_disagree | 222,002 / 0 | 222,002 / 0 | Yes |
| RA total decisions | 222,002 | 222,002 | Yes |
| RA ESCALATE | 131,968 | 131,968 | Yes |
| RA INCONCLUSIVE | 6,377 | 6,377 | Yes |
| RA STANDARD | 83,657 | 83,657 | Yes |
| INCONCLUSIVE attribution | 100% thin_type_or_missing_peer | 100% thin_type_or_missing_peer | Yes |
| Baseline hash | 86067f79…ade08 | 86067f79…ade08 | Yes |

No hard mechanical disagreement → no HALT under §4.

---

## 3. KEEP conditions (Constitution §7)

| # | Condition | Status |
|---:|---|---|
| 1 | Evidence packs complete and frozen | Partially — RAW MANIFEST present, but candidate-side artifacts (RB portfolio body, fixture actuals, recon body, gate bodies) are not in the supplied pack |
| 2 | Role separation valid | Yes |
| 3 | Builder and Validator agree on hard mechanical facts | Yes |
| 4 | Exact reconciliation passes where required | Yes on the supplied RA/RB summary (0 disagreements) |
| 5 | Every mandatory fixture passes | Not established — fixture bodies absent |
| 6 | No undeclared semantic change detected | **Not established** — soft-residual rewrite of an integrity gate is a semantic change whose preservation is undemonstrated |
| 7 | No locked regression introduced | Not established |
| 8 | Predeclared benefit predicate satisfied | **No** — see §5 |
| 9 | No blocking objection remains supported by frozen evidence | **No** — blocking objections stand (see §4) |

KEEP requires all nine conjunctively. Conditions 1, 5, 6, 7, 8, 9 are not met. KEEP is unavailable.

---

## 4. Blocking objections (supported by frozen evidence)

1. **P1's explicit fail condition is triggered by the frozen evidence.** The spec states: “P1 fails if hard INCONCLUSIVE was necessary to quarantine thin/missing-peer and other integrity failures (Chicago: all 6,377 INCONCLUSIVE = thin_type_or_missing_peer).” The frozen `inconclusive_by_clause.csv` shows exactly that: 6,377 / 6,377 = 1.0 share for `thin_type_or_missing_peer`. The predicate's own fail limb is satisfied on the frozen record.

2. **Semantic change to an integrity gate is undeclared and unvalidated.** The proposed change converts a fail-closed certification (INCONCLUSIVE for thin/missing peer) into a soft residual / STANDARD-by-default. Constitution §5 requires behavioral fixtures covering decision-changing semantics. No candidate fixture results, no candidate label mix, and no candidate-vs-baseline semantic diff are in the frozen pack.

3. **Actionable-size increase is not shown to be safe.** P1 requires the increase in actionable portfolio size to occur *without increasing wrong ESCALATE labels*. The frozen evidence shows RA = RB counts and zero recon disagreement, but does not show what the 6,377 released rows become under the candidate, nor whether any of them cross into ESCALATE.

4. **Validator's independent objections are unrebutted by any frozen artifact.** Builder reaches the same evidentiary conclusion from the opposite direction (withholding disposition due to missing candidate bodies). Both first passes converge on: candidate-behavior evidence is absent.

---

## 5. P1 assessment

P1 has a positive limb (reduce INCONCLUSIVE share, increase actionable portfolio) and a negative limb (no increase in wrong ESCALATE labels; fixtures/recon unbroken). The frozen evidence supports only the baseline side. The spec's own fail condition — hard INCONCLUSIVE was necessary to quarantine thin/missing-peer — is affirmatively satisfied by the frozen `inconclusive_by_clause.csv` (share = 1). Under the adjudicator note, **P1 fails → REVERT**.

---

## 6. Constitution §8 REVERT test

| REVERT condition | Status |
|---|---|
| Mechanics internally coherent | Yes — arithmetic consistent, both first passes agree |
| HALT conditions absent | Yes — see §1 |
| One or more KEEP conditions not established | Yes — §7 conditions 1, 5, 6, 7, 8, 9 |

All three REVERT conditions are met. REVERT is the conservative default for unresolved soft judgment (§8) and is independently mandated by the P1 fail condition in the frozen spec.

---

## 7. Adjudicator limits observed (Constitution §10)

- No new success criterion created.
- No failed hard gate relaxed.
- No mechanical result chosen over another (none conflict).
- No Builder or Validator artifact modified.
- No code repaired.
- No ablation rerun.
- No majority vote used.
- Each constitutional condition cited against frozen evidence above.

---

## 8. Terminal decision

**REVERT.**

Rationale in one line: mechanics cohere and no HALT condition is present, but the frozen evidence affirmatively satisfies P1's own fail condition (all 6,377 INCONCLUSIVE = `thin_type_or_missing_peer`) and KEEP conditions 1, 5, 6, 7, 8, 9 are not established — hard INCONCLUSIVE is retained for integrity fails (`thin_type_or_missing_peer` and peers).

> **Hard disagreement halts. Coherent evidence without proven benefit reverts. Only independently reproduced, regression-free, predeclared benefit is kept.**
