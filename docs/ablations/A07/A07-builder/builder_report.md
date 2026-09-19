# A07 Builder — ChatGPT (INDEPENDENT FIRST PASS)

## 1. Role attestation and ablation ID

**Ablation ID:** A07
**Role:** Builder
**Builder:** ChatGPT
**Validator:** DeepSeek
**Adjudicator:** Grok
**Target:** Stage 3 measurement / Stage 4 age implementation
**Constitution:** 1.0
**Frozen at CT:** 2026-09-19

I am acting only as the Builder for this first pass. I have read only the frozen A07 packet. Builder and Validator outputs are separate artifacts; I have not used, inferred, or created any Validator or Adjudicator conclusions. I am not issuing a terminal ablation outcome. The required Builder task is limited to describing the proposed change, recording frozen mechanical facts, assessing implications, identifying risks, and mapping claims to evidence. 

The proposed ablation tests whether raw open age or an equivalent simpler age metric could replace the TCD-IG age construction by computing `open_age_days` / `open_age_h` directly from `T_freeze - CREATED_DATE`, removing the type-conditional dormancy construction, or simplifying only where mechanically equivalent and explicitly documented. The packet specifies that this is a counterfactual analysis and does not rewrite the locked Chicago 311 Stage 4 pack. 

---

## 2. Conceptual/unified diff for the proposed change

### Conceptual diff against locked TCD-IG age design

```diff
- Measurement construct:
- TCD-IG B-leaning hybrid using type-conditional dormancy plus integrity gate.

- Primary age statistic:
- dormant_h = T_freeze - mod_ts
- Decision trigger uses dormant_h >= kappa * peer_p75_h

- open_age_h = T_freeze - created_ts
- Diagnostic only; not used as decision trigger.

+ Candidate alternative:
+ Use raw open age directly:
+ open_age_h = T_freeze - CREATED_DATE

+ Candidate classifier behavior:
+ Replace or simplify dormant-based age assessment with raw elapsed calendar age.

+ Documentation requirement:
+ If simplification is claimed equivalent, demonstrate mechanical equivalence
+ and explicitly document the equivalence.

- Preserve:
- Integrity ordering
- Exact reconciliation controls
- Fixture suite
- SR_NUMBER grain
- Frozen Stage 4 pack
```

The baseline design states that `open_age_h = T - created_ts` is diagnostic only, while `dormant_h = T - mod_ts` is the primary decision statistic and requires `mod_ts >= created_ts`. The mechanism is explicitly described as forgotten-relative-to-type work rather than simply raw age. 

The candidate change therefore modifies the meaning of the age signal itself. It does not merely change implementation syntax; it potentially changes the causal interpretation from “stale relative to comparable work type” to “old since creation.”

---

## 3. Hard mechanical facts table

| Area                | Frozen evidence fact                                                                                               | Builder interpretation                                        |
| ------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------- |
| Decision population | `n_decision = 222,002`                                                                                             | Frozen baseline decision set size                             |
| R-A reconciliation  | `n_ra=222,002`, `n_rb=222,002`, `n_inner=222,002`, `n_only_ra=0`, `n_only_rb=0`, `n_agree=222,002`, `n_disagree=0` | Baseline paths currently reconcile exactly                    |
| Portfolio labels    | ESCALATE `131,968`; INCONCLUSIVE `6,377`; STANDARD `83,657`                                                        | Current frozen classification distribution                    |
| κ                   | `kappa=2`                                                                                                          | Frozen threshold multiplier                                   |
| Freeze time         | `2026-09-12 23:59:59 CDT`                                                                                          | Locked temporal boundary                                      |
| Rule version        | `RA-tcd-ig-v1`                                                                                                     | Current baseline classifier version                           |
| Fixture status      | Both paths 14/14 PASS                                                                                              | Existing fixture suite validates locked semantics             |
| F03 behavior        | Expected STANDARD, observed STANDARD                                                                               | Important semantic boundary fixture                           |
| Prior defect        | 104 rows differed before clock fix; all were STANDARD vs ESCALATE flips                                            | Time semantics are already shown to affect threshold outcomes |
| Age metric roles    | `open_age_h` diagnostic; `dormant_h` decision statistic                                                            | Raw age replacement changes a locked conceptual role          |

The frozen reconciliation summary reports complete agreement: 222,002 rows compared, zero disagreements, and zero rows exclusive to either path. 

The frozen portfolio counts show the baseline output: 222,002 decisions, 131,968 ESCALATE, 6,377 INCONCLUSIVE, and 83,657 STANDARD with κ=2 and the TCD-IG rule version. 

The exact reconciliation report further states that the decision sets are identical, both paths agree on all labels, and fixtures pass with F03 remaining STANDARD. 

---

## 4. P1 assessment from frozen evidence only

**P1 statement:**

> Raw open age (or an equivalent simpler age metric) improves interpretability and reduces construction complexity without materially changing Stage 4 PASS status or locked fixture semantics. 

### Evidence supporting possible benefit

A raw open-age construction would likely be simpler conceptually because it uses a single elapsed-time measure:

```
T_freeze - CREATED_DATE
```

instead of combining:

* type-relative dormancy,
* modification timestamps,
* peer distributions,
* integrity requirements around modification history.

This could reduce implementation complexity if the simpler measure preserved the same decision semantics.

### Evidence against assuming equivalence

The frozen design explicitly distinguishes calendar age from dormancy:

* Calendar age mixes long-cycle types, active touches, and silence.
* The locked mechanism is forgotten-relative-to-type work.
* Raw open age is diagnostic rather than a trigger. 

The strongest evidence that raw age may alter semantics is the locked F03 fixture. The packet states:

* building peer percentile = 90 days,
* dormant age = 100 days,
* expected result = STANDARD because `100 < 180`,
* naive age would escalate. 

Therefore, based only on frozen evidence, the proposed simplification appears to directly interact with a known semantic boundary. The evidence supports testing whether simplicity can be achieved, but does not establish mechanical equivalence.

The proposed benefit depends on showing both:

1. reduced construction complexity; and
2. preservation of locked decision behavior, fixtures, and reconciliation semantics.

---

## 5. Fixture and exact-recon implications

### Fixture implications

The primary fixture concern is whether raw open age changes expected classifications.

The frozen fixture evidence includes:

| Fixture | Expected     | Observed     | Relevant age evidence           |
| ------- | ------------ | ------------ | ------------------------------- |
| F01     | ESCALATE     | ESCALATE     | dormant_h 480, peer_p75_h 168   |
| F02     | STANDARD     | STANDARD     | dormant_h 24, peer_p75_h 168    |
| F03     | STANDARD     | STANDARD     | dormant_h 2400, peer_p75_h 2160 |
| F04     | INCONCLUSIVE | INCONCLUSIVE | open/closed date integrity      |
| F05     | INCONCLUSIVE | INCONCLUSIVE | inverted clocks integrity       |



The critical risk is F03 because the packet explicitly identifies it as a case where naive age would escalate while TCD-IG remains STANDARD. A raw age implementation would need to demonstrate why this semantic difference is acceptable under the ablation definition.

### Exact reconciliation implications

The locked reconciliation contract includes:

* SR_NUMBER set equality,
* decision counts,
* inner joins,
* only-RA / only-RB counts,
* agreement/disagreement counts,
* classification/action labels,
* integrity clauses,
* portfolio counts. 

The baseline reconciliation currently shows:

* identical SR_NUMBER sets,
* 222,002 inner rows,
* zero disagreements,
* zero only-path rows. 

A candidate age implementation would need to preserve these controls while demonstrating that any changed labels are declared consequences of the ablation rather than unintended semantic drift.

---

## 6. Semantic/regression risks and unchanged surfaces

### Semantic risks

**1. Loss of type-relative interpretation**

The existing method treats dormancy relative to work type. Raw age changes the question being answered:

* Existing: “Has this item become unusually dormant compared with similar items?”
* Candidate: “Has this item existed for a long time?”

These are related but not identical measures.

**2. False escalation of long-cycle work**

The frozen evidence explicitly states that calendar age mixes long-cycle types, active touches, and silence. This creates a risk that raw age elevates items that are old but not dormant. 

**3. Fixture semantic changes**

F03 provides direct evidence that replacing dormancy with raw age can change classification behavior. 

**4. Integrity interaction**

The current implementation evaluates integrity first and then applies dormant-based thresholds. The age replacement must not weaken integrity-first ordering or introduce age calculations that override invalid timestamps. 

### Regression risks

The frozen regression rules identify unchanged surfaces:

* SQL nonjudgment boundary,
* integrity-first ordering,
* exact recon controls,
* SR_NUMBER grain,
* fixture IDs and expected outputs,
* frozen Chicago 311 Stage 4 pack. 

Any undeclared semantic change to ESCALATE, INCONCLUSIVE, or STANDARD is a regression under the frozen specification. 

### Unchanged surfaces

The proposed analysis should not alter:

* source data scope,
* SQL responsibility boundaries,
* reconciliation methodology,
* fixture identifiers,
* integrity clauses,
* capacity/ranking logic,
* SLA interpretation.

The packet explicitly states that age must not be treated as a City SLA or dispatch order and that capacity/ranking remains out of scope. 

---

## 7. Claim → evidence citations

| Claim                                                                | Evidence                                                                                                                                   |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| A07 tests replacement/simplification of TCD-IG age with raw open age | Proposed change specifies direct `T_freeze - CREATED_DATE` computation and removal/simplification of type-conditional dormancy.            |
| The baseline uses TCD-IG, not raw age, as the decision construct     | Measurement design states TCD-IG hybrid, with dormant hours as the primary decision statistic and open age as diagnostic only.             |
| Raw age may change semantics                                         | Frozen design notes that calendar age mixes long-cycle types, active touches, and silence.                                                 |
| F03 is a critical semantic boundary                                  | F03 is STANDARD under TCD-IG because dormant age is below threshold, while naive age would escalate.                                       |
| Baseline reconciliation is exact                                     | RECON_SUMMARY shows 222,002 agreements and zero disagreements.                                                                             |
| Fixture suite currently passes                                       | Exact reconciliation report states both paths 14/14 PASS with F03 → STANDARD.                                                              |
| Time semantics are a material implementation concern                 | Structural review identifies 104 near-threshold label flips caused by timezone semantics before correction.                                |
| Raw open age exists in implementation but is not the trigger         | R-A implementation excerpt states labels are assigned from integrity and dormant threshold logic while open age is emitted for diagnosis.  |

**Builder summary:** The proposed A07 change is a simplification of the age construct from type-conditional dormancy toward raw elapsed age. Frozen evidence establishes that the existing construct intentionally separates diagnostic age from decision age and that at least one locked fixture (F03) depends on that distinction. The main analytical question for the ablation is whether the reduced complexity of raw age can be achieved without changing protected decision semantics, fixture behavior, and reconciliation guarantees. No terminal ablation decision is issued in this Builder report.
