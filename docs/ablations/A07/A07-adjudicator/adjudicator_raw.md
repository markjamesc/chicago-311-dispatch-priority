REVERT

## Constitutional adjudication (A07, Constitution 1.0)

### Terminal outcome
Keep the locked TCD-IG age construction for Design Gate / fixtures. Raw open age does not become canonical.

### Scope and role check
Ablation A07 is a frozen counterfactual on Stage 3 measurement / Stage 4 age: replace type-conditional TCD-IG dormancy with raw open_age_* = T_freeze − CREATED_DATE, or simplify only if mechanical equivalence is documented. Roles are valid and separated (Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok). RAW MANIFEST is present (16 SHA-256 entries). Per the adjudicator note, missing historical R stdout is not a HALT ground.

### HALT conditions — absent
No Builder/Validator conflict on predeclared baseline hard facts; no role breach; constitution and baseline version did not change mid-run; P1 was operationally defined before execution; the packet is the authoritative frozen pack. Constitution §9 HALT is therefore not triggered. Missing candidate implementation artifacts do not convert this run into HALT: the spec is explicitly a no-rewrite counterfactual, and the packet directs REVERT when P1 fails.

### Hard-fact agreement (baseline only)
Builder and Validator independently match on locked TCD-IG surfaces:

| Fact | Agreed value |
|---|---|
| n_decision / n_ra / n_rb / n_inner | 222,002 |
| n_only_ra / n_only_rb / n_disagree | 0 |
| n_agree | 222,002 |
| Portfolio | ESCALATE 131,968 · INCONCLUSIVE 6,377 · STANDARD 83,657 |
| κ / freeze | 2 / 2026-09-12 23:59:59 CDT (America/Chicago) |
| Rule version | RA-tcd-ig-v1 |
| Fixtures | F01–F14 PASS both paths; F03 expected/observed STANDARD |

Exact recon on the frozen critical list is internally coherent for the baseline. There is no candidate recon, no candidate fixture actuals, and no candidate Design Gate output in the pack.

### P1 — not satisfied (decisive)
P1 requires both interpretability/complexity gain and no material change to Stage 4 PASS or locked fixture semantics. The spec itself states P1 fails if TCD-IG age was necessary for the Design Gate (open_age_days >= 14 at T_freeze), the TCD-IG decision construct, or locked fixture expecteds, including F03 → STANDARD.

Frozen evidence shows that necessity:

- Baseline design: dormant_h = T_freeze − mod_ts is the decision statistic; open_age_h is diagnostic only.
- F03 (locked): dormant_h = 2400, peer_p75_h = 2160, κ=2 → 2400 < 4320 → STANDARD under within_type_dormancy / S_dormant_lt_kappa_p75. Both reports record that naive/raw calendar age would escalate this case.
- No candidate SQL/R, no deterministic diff, no equivalence note, no raw CREATED_DATE → open_age_* derivation for F03, no candidate Stage 4 status.

Complexity reduction is asserted, not measured. Mechanical equivalence is not documented. P1 therefore fails on the explicit fail clause.

### KEEP checklist (all nine required; several fail)
- Packs frozen — yes (manifest + reports).
- Role separation — yes.
- Hard-fact agreement — yes on baseline; candidate facts do not exist to agree on.
- Exact recon — baseline only; candidate unverified.
- Mandatory fixtures — baseline 14/14; candidate actuals absent.
- No undeclared semantic change — not established. F03 is a declared semantic boundary that raw age would move STANDARD → ESCALATE.
- No locked regression — not established. Changing F03 expecteds or ESCALATE/STANDARD meaning is a regression under the frozen surfaces.
- Benefit predicate satisfied — no.
- No supported blocking objection — no. Validator objections 1–6 (undefined remove-vs-simplify, missing peer/κ treatment, missing F01–F14 candidate results, missing F03 raw age, missing integrity/out-of-set/SR_NUMBER proofs) remain supported by the same frozen pack.

KEEP §7 is conjunctive. Failure of 6–9 bars KEEP.

### Fixture and regression implications
The locked construct answers “unusually dormant versus type peers,” not “old since creation.” Calendar age mixes long-cycle types, recent touches, and silence. Replacing dormancy with raw open age would:

- flip at least the named F03 STANDARD expected;
- leave integrity-first INCONCLUSIVE fixtures (F04/F05/F13 etc.) unspecified under a new age formula;
- leave the Design Gate open_age_days >= 14 semantically overloaded if that field stops being diagnostic and becomes the decision age.

Unchanged-surface contract (SQL nonjudgment, integrity-first order, exact recon controls, SR_NUMBER grain, fixture IDs/expecteds, frozen Stage 4 pack) is therefore not shown to survive the candidate. Capacity/SLA reinterpretation remains out of scope and is not licensed by this ablation.

### Two-sentence rationale
TCD-IG dormancy is necessary for the locked F03 STANDARD expected and for the type-conditional decision construct; raw T_freeze − CREATED_DATE is not shown to be mechanically equivalent and would change protected label semantics. Baseline mechanics are coherent and roles are intact, so the constitution’s conservative default applies: REVERT, keep stage3-v1-tcd-ig / fixtures-v1-tcd-ig.
