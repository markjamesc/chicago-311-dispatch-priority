REVERT

# A07 Adjudication — Grok

## Terminal outcome
Keep the locked TCD-IG age construction for Design Gate / fixtures. Raw open age does not become canonical.

## Constitutional basis
- **Roles and freeze:** Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok; Constitution 1.0 and the RAW MANIFEST are present. Missing historical R stdout is explicitly not a HALT ground.
- **HALT:** Not triggered. There is no reported hard-fact conflict, role breach, mid-run constitution/version change, or ambiguity about the authoritative frozen pack.
- **Baseline mechanics:** Builder and Validator agree on 222,002 decisions, 222,002 inner rows, 0 one-sided rows, 0 disagreements, portfolio counts of 131,968 ESCALATE / 6,377 INCONCLUSIVE / 83,657 STANDARD, κ=2, the freeze timestamp, rule version, and F01–F14 passing with F03 STANDARD.
- **P1:** Fails. The baseline uses `dormant_h = T_freeze − mod_ts` as the decision statistic and `open_age_h` only diagnostically. F03 is STANDARD at `dormant_h=2400` versus `κ×peer_p75_h=4320`, while the packet records that naive/raw calendar age would escalate it. No candidate implementation, deterministic diff, candidate fixtures/reconciliation, F03 raw-age derivation, or Stage 4 output establishes equivalence or preserves semantics.
- **KEEP conditions:** Candidate exact reconciliation and fixture actuals are absent; no undeclared semantic change, no locked regression, and the benefit predicate are not established. KEEP is conjunctive, so the missing proof and the explicit F03 semantic boundary bar KEEP.
- **Regression scope:** SQL nonjudgment, integrity-first ordering, exact recon controls, SR_NUMBER grain, fixture IDs/expecteds, and the frozen Stage 4 pack are not shown to survive the proposed candidate. Capacity and SLA interpretations remain out of scope.

## Rationale excerpt
TCD-IG dormancy is necessary for the locked F03 STANDARD expected and for the type-conditional decision construct; raw T_freeze − CREATED_DATE is not shown to be mechanically equivalent and would change protected label semantics. Baseline mechanics are coherent and roles are intact, so the constitution’s conservative default applies: REVERT, keep stage3-v1-tcd-ig / fixtures-v1-tcd-ig.
