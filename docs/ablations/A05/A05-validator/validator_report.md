# A05 Validator — Grok independent first pass

**Ablation:** A05  
**Role:** Validator only (Builder visibility: none)  
**Constitution:** 1.0  
**Requested response style:** Comprehensive; the Grok model picker exposed Expert, so Expert was selected. Grok rendered the pass in a Comprehensive style.  
**Decision scope:** This is not an adjudication. No KEEP/REVERT/HALT decision is issued.

## Role attestation

This pass is independent of the Builder. It inventories frozen inputs, reconstructs a checkable test plan from the specification and P1, extracts only mechanical facts present in the pasted excerpts, assesses whether P1 is supported, and records objections and missing evidence. It does not rewrite the proposed change, retune κ/W/n_min, modify the constitution, or claim that the change is better. The Adjudicator note is applied only to the stdout scope: the RAW MANIFEST means missing historical R stdout is not treated as a blocker, but it does not make absent candidate artifacts available.

## Test plan

P1 requires that multiple owner-tunable knobs improve Stage 5 portfolio usefulness (for example, reduce ESCALATE) without harming Stage 4 exact reconciliation or fixture pass, with equal detection coverage. P1 fails for silent Stage 4 disagreement, greenwash, or undeclared tunables that break the Design-Gate lock. A scorable comparison needs six artifact gates:

1. **Design-Gate identity:** establish knob cardinality, keep W=365 and n_min=50 as constants unless explicitly declared otherwise, prove Finish Gate did not retune after seeing Stage 5, and label any κ grid sensitivity-only.
2. **Dual-rail Stage 4 identity:** verify identical row universes, zero ID-level disagreement, status PASS for the same lock, and a separate recon pair for the multi-knob candidate.
3. **Fixture pass:** verify both rails and the candidate under the declared vector; inspect expected decision values, not merely schemas.
4. **Coverage equality:** compare decision census, eligible ID sets, inconclusive identity, and RA/RB coverage between baseline and candidate.
5. **Stage 5 benefit:** compare predeclared portfolio counts with κ held at 2 when still the owner knob, and prove the gain is from an additional declared knob rather than a κ retune.
6. **Fail-mode scan:** check silent disagreement, greenwash/holdout behavior, undeclared W or n_min changes, and a runtime knob vector that conflicts with the single-knob Design Gate.

## Hard facts from the frozen excerpts

The SPEC states the Chicago production lock is single κ=2; W=365 and n_min=50 are method constants; the κ grid is descriptive only in Stage 5; and Finish Gate did not change κ. The pasted RECON_SUMMARY row is mechanically internally consistent: n_ra=222002, n_rb=222002, n_inner=222002, n_only_ra=0, n_only_rb=0, n_agree=222002, n_disagree=0. This establishes identical rails and zero disagreement for one run, but the excerpt does not bind that row to a candidate multi-knob vector.

The pasted sensitivity table has n_decision=222002 and n_INCONCLUSIVE=6377 for κ=1, 1.5, 2, and 3. At κ=2, ESCALATE=131968 and STANDARD=83657. At κ=3, ESCALATE=118246 and STANDARD=97379: a 13,722-row partition shift, with no change in census or inconclusive count. This is a single-κ sensitivity slide, not evidence of a second knob and not a permitted Finish-Gate retune.

The RAW MANIFEST is an inventory of hashed filenames, including recon, fixture, portfolio, status, lineage, and framework entries. The pasted packet supplies neither the bodies of the fixture CSVs/status files nor a candidate multi-knob contrast. Filename presence alone cannot establish fixture PASS, candidate equality, or semantic equality.

## P1 assessment and blocking objections

The baseline-like recon excerpt supports B1/B2 for one run, but the candidate’s own RA′/RB′ recon is not supplied. Fixture gate C is unscored from content because the fixture bodies and expected/actual values are absent. Coverage gate D is not established for a second knob: the κ grid only demonstrates stability while moving κ. Benefit gate E is not established: the only visible reduction in ESCALATE is obtained by moving κ from 2 to 3, which the frozen evidence explicitly says was not done and which cannot be counted as a multi-knob benefit.

The blocking objection is therefore evidentiary, not a claim that the proposed change is mechanically impossible: there is no declared candidate knob vector, candidate Design-Gate/lineage record, candidate dual-rail recon, candidate fixture result pair, candidate ID-level coverage join, or side-by-side baseline/candidate portfolio counts with κ held at 2. There is also no evidence in the excerpts that W and n_min remain constants in a candidate implementation. Without those artifacts, equal detection coverage, exact Stage 4 preservation, and a non-greenwashed Stage 5 benefit cannot be independently checked.

## Missing evidence required for a scorable candidate

Provide the locked Design-Gate declaration and constant list; baseline and candidate dual-rail recon at their respective declared vectors; both baseline and candidate fixture actuals/expecteds; an ID-level eligible-set join; side-by-side portfolio counts for both arms; explicit W/n_min treatment; and lineage attestation that no post-inspection retune occurred. Hash and freeze those artifacts. The RAW MANIFEST exception concerns only historical R stdout and does not waive these candidate-comparison requirements.

## Summary

The supplied evidence is coherent for a single-knob baseline and its κ sensitivity table. It does not reproduce or evaluate a multiple-knob candidate. P1 is therefore not supported by the frozen excerpts: the observed ESCALATE reduction is a κ-only descriptive movement, while the required candidate Stage 4, fixture, coverage, and Stage 5 evidence is missing. This independent Validator pass intentionally issues no KEEP/REVERT/HALT decision; adjudication remains outside scope.
