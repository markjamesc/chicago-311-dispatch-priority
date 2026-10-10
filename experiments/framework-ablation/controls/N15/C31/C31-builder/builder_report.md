# C31 Builder Report

## 1. Role attestation and ablation ID.

I attest that I am acting **only as Builder** for this independent first pass, blind to the Validator. The frozen role assignment is Builder = ChatGPT, Validator = DeepSeek, Adjudicator = Grok. The ablation is **C31**, Remaining Ablation Program catalog #31, **“Lineage Attestation,”** in N15 batch 1 of 3, targeting Stage 4 provenance of data and code versions. Constitution version is 1.0.

No terminal adjudication is made in this report.

## 2. Conceptual diff: what the ablation removes, and the exact seeded code changes, from the SEED DIFFS.

The control under test requires an explicit lineage attestation before outputs are trusted: a manifest containing the SHA-256 of every source and code input is compared with the frozen record. C31 removes that attestation. Under the ablated regime, trust therefore rests only on successful execution, fixtures on both paths, and RA↔RB exact reconciliation of key set plus classification. Consequently, a common undocumented change applied consistently to both paths can escape detection when both paths continue to agree with each other.

The five frozen seeds are:

- **L_STALE24:** no code diff. Both paths receive the stale `src_open_candidates.csv`; 848 source rows with `created_ts >= 2026-09-11 23:59:59` are dropped. `src_peer_stats.csv` remains byte-identical to frozen.
- **L_PEER10:** no code diff. Both paths receive altered peer statistics: WCA2 `peer_p75_h` changes from 2250 to 2475, while `src_open_candidates.csv` remains byte-identical to frozen.
- **L_TF24:** the exact RA code change is  
  `T_FREEZE <- lubridate::ymd_hms("2026-09-12 23:59:59", tz = "America/Chicago")`  
  →  
  `T_FREEZE <- lubridate::ymd_hms("2026-09-13 23:59:59", tz = "America/Chicago")`.  
  The exact RB change is  
  `RB_T_FREEZE <- as.POSIXct("2026-09-12 23:59:59", tz = "America/Chicago")`  
  →  
  `RB_T_FREEZE <- as.POSIXct("2026-09-13 23:59:59", tz = "America/Chicago")`.
- **L_K25:** the exact RA code change is `KAPPA <- 2.0` → `KAPPA <- 2.5`; the exact RB code change is `RB_KAPPA_DEFAULT <- 2.0` → `RB_KAPPA_DEFAULT <- 2.5`.
- **L_COMMENT:** the exact added line in both paths is `# lineage test: comment-only edit, no semantic change`. No executable statement changes.

Thus the seed portfolio tests two undocumented data-version changes, two undocumented executable configuration changes, and one byte-level but semantically inert code change.

## 3. Hard mechanical facts table.

**Notation:** **R** = independently recomputed from the supplied raw evidence; **Q** = quoted directly because the underlying files needed to recompute that value are not themselves supplied as row-level data.

| Mechanical fact | Independent result | Status / derivation |
| --- | --- | --- |
| Frozen source row counts | `src_open_candidates = 245,193 (Q)`; `src_peer_stats = 104 (Q)` | Preflight COUNT output. |
| Stale-source row count after seed | `244,345 (R)` | `245,193 (Q) − 848 (Q) = 244,345 (R)`. |
| PEER10 magnitude | `+225 h (R)`; `+10% (R)`; affected in-set WCA2 population `72,732 (Q)` | `2475 − 2250 = 225`; `225 / 2250 = 0.10`. Source-variant evidence gives the affected population. |
| Process executions recorded | `12/12 (R)` total; `10/10 (R)` seeded; `5/5 (R)` seeded arms complete | Run log contains B RA+RB plus `5 (R) × 2 (R) = 10 (R)` seeded executions; every recorded exit is `0 (Q)`. |
| Fixture executions | `168/168 (R)` pass overall; `28/28 (R)` for B; `140/140 (R)` seeded | `6 arms × 2 paths × 14 fixtures = 168`; raw fixture rows all have `pass=TRUE`. |
| B reproduction versus frozen outputs | `10/10 zero comparison cells (R)` across the two paths | Each B-vs-frozen row has `5 (Q)` zero difference fields; `2 × 5 = 10 (R)`. |
| B key/label reconciliation identity | `n_agree = 222,002 (R)`; `n_disagree = 0 (Q)`; `n_inner = 222,002 (Q)` | `222,002 − 0 = 222,002`; therefore `n_agree + n_disagree = 222,002 + 0 = 222,002 = n_inner`. Also `n_inner + n_only_RA = 222,002 + 0 = 222,002 = n_RA`, and symmetrically for RB. |
| B full-field RA↔RB numerical mismatches | `dormant_h = 1 (Q)`; `open_age_h = 2 (Q)` | These coexist with `0 (Q)` key-set and `0 (Q)` classification disagreement. |
| Seeded RA↔RB key/label checks | `15/15 zero values (R)` | Five seeded arms each have `recon_only_ra=0`, `recon_only_rb=0`, `recon_disagree=0`; `5 × 3 = 15`. |
| L_STALE24 inferred RA/RB population | `221,229 (R)` on each path | B has `222,002 (Q)` keys; each seeded path has `only_B=773 (Q)`, `only_x=0 (Q)`: `222,002 − 773 = 221,229`. With RA↔RB disagreement `0 (Q)`, all `221,229 (R)` common rows agree on classification. |
| L_STALE24 locked-field changes | `1,546 (R)` | RA: `773`; RB: `773`; `773 + 773 = 1,546`. Reported value `1,546 (Q)` matches. |
| L_STALE24 decision changes | `1,546 (R)` | Only missing-key differences occur: `773 + 773 = 1,546`. Reported `1,546 (Q)` matches. |
| L_PEER10 locked-field changes | `538 (R)` | RA label changes `269 (Q)` + RB label changes `269 (Q)` = `538`. Reported `538 (Q)` matches. |
| L_PEER10 decision changes | `538 (R)` | Same `269 + 269 = 538`; no key/numerical-field changes. |
| L_TF24 locked-field changes | `889,154 (R)` | Per path: `573 + 222,002 + 222,002 = 444,577`; two paths: `444,577 × 2 = 889,154`. Reported `889,154 (Q)` matches. |
| L_TF24 decision changes | `1,146 (R)` | Classification only for decision-change count: `573 × 2 = 1,146`. Reported `1,146 (Q)` matches. |
| L_TF24 non-decision numerical-field delta | `888,008 (R)` | `889,154 − 1,146 = 888,008`, entirely from dormant/open-age changes across both paths. |
| L_K25 locked-field changes | `13,786 (R)` | `6,893 (Q) + 6,893 (Q) = 13,786`. Reported `13,786 (Q)` matches. |
| L_K25 decision changes | `13,786 (R)` | Same label-change total; no key/dormant/open-age change. |
| L_COMMENT locked-field changes | `0 (R)` | Both RA-vs-B and RB-vs-B vectors contain only zeroes. Reported `0 (Q)` matches. |
| L_COMMENT decision changes | `0 (R)` | No key or classification difference. |
| Portfolio locked-field-change total | `905,024 (R)` | `1,546 + 538 + 889,154 + 13,786 + 0 = 905,024`. |
| Portfolio decision-change total | `17,016 (R)` | `1,546 + 538 + 1,146 + 13,786 + 0 = 17,016`. |
| Portfolio locked-minus-decision delta | `888,008 (R)` | `905,024 − 17,016 = 888,008`. |
| Harm set H | `{L_STALE24, L_PEER10, L_TF24, L_K25} (R)`; cardinality `4 (R)` | Exactly the arms with recomputed locked-field-change count greater than `0`. |
| Non-harmful seeded set | `{L_COMMENT} (R)`; cardinality `1 (R)` | Recomputed locked-field-change count equals `0`. |
| D_abl, caught without lineage attestation | `{ } (R)`; cardinality `0 (R)` | Every seeded execution exits `0`; every fixture passes; every seeded arm has zero RA↔RB key/label discrepancy. |
| H \ D_abl | `{L_STALE24, L_PEER10, L_TF24, L_K25} (R)`; cardinality `4 (R)` | Removing the empty D-set from H leaves H unchanged. This independently reproduces H6. |
| Caught under SHA-attested regime | all `5/5 (R)` seeded arms | Each seed changes at least one actual input SHA relative to B. |
| Harmful arms caught under SHA-attested regime | `4/4 (R)` | Every member of H has a source or code input hash difference. |
| Benign byte-change alarm | `1/1 (R)` non-harmful arm, L_COMMENT | Input code hashes differ while locked outputs do not. |
| `src_extract_lineage.csv` hash equality | `6/6 arms (R)` identical | B plus all five seeded arms use hash `eaa9…ddd1b`. |
| `R-B/R/20_integrity_and_classify.R` hash equality | `6/6 arms (R)` identical | Hash `72ac…1d99` throughout. |
| `R-B/run_RB.R` hash equality | `6/6 arms (R)` identical | Hash `6786…defd` throughout. |
| `src_open_candidates.csv` equality to B among seeded arms | `4/5 (R)` equal | Only L_STALE24 differs. |
| `src_peer_stats.csv` equality to B among seeded arms | `4/5 (R)` equal | Only L_PEER10 differs. |
| `R-A/run_RA.R` equality to B among seeded arms | `2/5 (R)` equal | L_STALE24 and L_PEER10 equal B; TF24, K25 and COMMENT differ. |
| `R-B/R/00_config.R` equality to B among seeded arms | `2/5 (R)` equal | Same arm pattern as RA code. |
| Classification-output hash equality to B | both path hashes equal B in `1/5 (R)` seeded arms | L_COMMENT alone exactly reproduces both B classification-output hashes; all `4/4 (R)` harmful arms differ on both classification output files. |
| Fixture-output hash equality to B | RA `5/5 (R)`; RB `4/5 (R)` | RA fixture file hash remains B-identical in every seed. RB is B-identical except L_K25, whose RB fixture file hash differs even though all `14/14 (Q)` fixture outcomes pass. |
| Comment-seed byte delta | RA `+54 bytes (R)`; RB config `+54 bytes (R)` | RA `25,063 − 25,009 = 54`; RB config `1,936 − 1,882 = 54`; classification outputs nevertheless remain exactly B-identical on both paths. |

The seeded-arm calculations above come directly from the raw arm rows, whose RA-vs-B/RB-vs-B component counts independently reproduce all five reported locked-field and decision-change totals. The input/output hash comparisons come from the per-arm manifests.

## 4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.

The frozen predicate defines P1 as satisfied exactly when **H ⊆ D_abl**; it defines the contrary condition as **H \ D_abl non-empty**. Arms with no locked-field change do not count for or against P1.

Independent reconstruction gives:

- `H = {L_STALE24, L_PEER10, L_TF24, L_K25}`.
- `D_abl = {}`.
- Therefore `H ⊆ D_abl` is **false**.
- `H \ D_abl = {L_STALE24, L_PEER10, L_TF24, L_K25}` is non-empty, with four members.
- All four harmful seeds therefore alter at least one locked output field while satisfying every detection mechanism retained by the ablated regime: exit success, fixture success, and RA↔RB key/classification reconciliation.
- L_COMMENT has no locked-field change and therefore does not affect the predicate. It does demonstrate that SHA-based attestation responds to a byte-level provenance change even when the tested locked outputs are unchanged.

Thus, under the frozen P1 definition, the **P1-satisfied condition is false and the P1-failed condition is true**. This is a predicate result only, not a terminal adjudication.

## 5. Fixture and reconciliation implications.

The raw fixture table contains **168 fixture executions**: six arms including B, two paths per arm, and F01–F14 per path. All 168 have `pass=TRUE`; therefore every seeded arm independently contributes 28/28 passing fixture executions. The fixture suite detects none of the four harmful common-mode seeds.

The clean B arm also reproduces each frozen path with zero key, label, dormant, or open-age difference versus that path's frozen classification file. Its RA↔RB reconciliation is zero on the three ablation detection fields—RA-only keys, RB-only keys, and classification disagreement—while the fuller reconciliation records one `dormant_h` mismatch and two `open_age_h` mismatches.

Every seeded arm preserves the same cross-path pattern: `recon_only_ra=0`, `recon_only_rb=0`, `recon_disagree=0`, `recon_dormant_mismatch=1`, `recon_open_age_mismatch=2`. Consequently:

- The seeded defects are **common-mode with respect to RA versus RB**. RA and RB independently agree with one another after being given the same changed provenance.
- Exact key/classification reconciliation therefore establishes cross-implementation agreement, not fidelity to the frozen data/code identity.
- The pre-existing 1/2 dormant/open-age RA↔RB mismatch signature is unchanged across B and all five seeds, so it supplies no discrimination among these arms.
- Fixture success likewise establishes that F01–F14 still behave as expected under each path; it does not establish that the production run consumed the frozen source/configuration.
- L_K25 gives an additional file-level nuance: its RB fixture-results file hash changes relative to B while every expected-versus-observed fixture result still passes. Therefore fixture-file byte equality and fixture semantic pass/fail are distinct properties.

## 6. Semantic/regression risks and unchanged surfaces.

The central semantic risk exposed by the evidence is **common-mode provenance drift**. Independent RA and RB implementations do not protect against a source snapshot, peer-stat table, freeze instant, or shared production knob being changed consistently for both paths. Four such changes altered locked outputs yet left both paths mutually consistent and all fixtures passing.

A second risk is that the retained checks can create a false sense of provenance assurance: successful execution plus inter-path agreement shows that two implementations processed their inputs compatibly, but without input identity it cannot establish that those were the frozen inputs.

The opposite operational characteristic is visible in L_COMMENT. Exact SHA-256 attestation is intentionally byte-sensitive: it catches the comment-only edit despite exact preservation of both classification output hashes and zero locked-field change. That means the control distinguishes **documented/frozen identity** rather than only semantic equivalence. In an operational workflow, benign intentional edits therefore require an updated frozen record rather than being silently tolerated.

Observed unchanged surfaces are strong and specific. `src_extract_lineage.csv`, `R-B/R/20_integrity_and_classify.R`, and `R-B/run_RB.R` are hash-identical across B and all five seeded arms. L_STALE24 changes only `src_open_candidates.csv`; L_PEER10 changes only `src_peer_stats.csv`; L_TF24, L_K25, and L_COMMENT change only the seeded RA script and RB configuration among the key manifested inputs.

The clean B classification outputs have the same hashes as the frozen preflight outputs, and the B-vs-frozen comparison reports zero differences on both paths. L_COMMENT likewise reproduces the B classification hashes exactly. By contrast, every harmful arm produces classification-output hashes different from B on both paths, consistent with the nonzero locked-field comparisons.

No evidence in this packet indicates a regression in the fixture pass surface, process-exit surface, RA↔RB key/classification reconciliation surface, or the three explicitly unchanged manifested files. The evidence instead shows that those unchanged surfaces are insufficient to discriminate the four harmful lineage changes when lineage attestation is absent.

## 7. Claim → evidence map.

| Claim | Evidence section and table row |
| --- | --- |
| C31 is the Lineage Attestation ablation and ChatGPT is the Builder | **SPEC → header / Roles**: ablation ID, catalog #31, role assignment, target Stage 4. |
| The ablation removes input SHA-256 lineage attestation and retains exit/fixtures/key-label reconciliation | **SPEC → Control under test / Exact change being tested**. |
| L_STALE24 drops 848 source rows; L_PEER10 changes WCA2 peer p75 from 2250 to 2475 | **SPEC → Seeded undocumented changes**, L_STALE24 and L_PEER10 rows; **SOURCE VARIANTS**, V_STALE24/V_PEER10 rows. |
| L_TF24 changes both freeze instants from 2026-09-12 23:59:59 to 2026-09-13 23:59:59 | **SEED DIFFS → RA_TF24 and RB_TF24 rows**. |
| L_K25 changes κ from 2.0 to 2.5 in both implementations | **SEED DIFFS → RA_K25 and RB_K25 rows**. |
| L_COMMENT adds only the stated comment line to each seeded code file | **SEED DIFFS → RA_COMMENT and RB_COMMENT rows**. |
| All B and seeded executions recorded exit 0 | **RUN LOG → B, L_STALE24, L_PEER10, L_TF24, L_K25, L_COMMENT RA/RB rows**. |
| B reproduces both frozen classification paths with zero differences | **C31_RESULTS → Arm B repro vs frozen pack**, both B rows. |
| B has 222,002 rows on each path, zero key/classification disagreement, but 1 dormant and 2 open-age cross-path mismatches | **C31_RESULTS → Arm B recon**, single data row. |
| L_STALE24 has 1,546 locked/decision changes and no ablated-regime detection | **C31_RESULTS → Seeded arms → L_STALE24 row**; independently `773 + 773 = 1,546`. |
| L_PEER10 has 538 locked/decision changes and no ablated-regime detection | **C31_RESULTS → Seeded arms → L_PEER10 row**; independently `269 + 269 = 538`. |
| L_TF24 has 889,154 locked-field changes but 1,146 decision changes and no ablated-regime detection | **C31_RESULTS → Seeded arms → L_TF24 row**; independently `2 × (573 + 222,002 + 222,002) = 889,154` and `2 × 573 = 1,146`. |
| L_K25 has 13,786 locked/decision changes and no ablated-regime detection | **C31_RESULTS → Seeded arms → L_K25 row**; independently `6,893 + 6,893 = 13,786`. |
| L_COMMENT has zero locked/decision changes while its code hashes differ | **C31_RESULTS → Seeded arms → L_COMMENT row** plus **ARM MANIFESTS → L_COMMENT inputs/outputs**. |
| H consists of the four harmful arms and D_abl is empty | **C31_RESULTS → Mechanical facts H4–H6**, independently reproduced from raw seeded-arm rows. |
| P1's satisfied condition is false because H is not a subset of D_abl | **SPEC → Operational benefit predicate P1**, combined with **C31_RESULTS → H4–H6**. |
| Exact attestation catches all five seeds, including benign L_COMMENT | **C31_RESULTS → H8–H9** and **Seeded arms → caught_with_control column**. |
| L_COMMENT classification outputs are byte-identical to B | **ARM MANIFESTS → B output rows and L_COMMENT output rows**: RA `c099…ae0d9` equals B and RB `a0e4…fe193` equals B. |
| The four harmful arms have classification-output hashes different from B on both paths | **ARM MANIFESTS → L_K25, L_PEER10, L_STALE24, L_TF24 output rows**. |
| `src_extract_lineage.csv`, `R-B/R/20_integrity_and_classify.R`, and `R-B/run_RB.R` remain invariant across the tested arms | **ARM MANIFESTS → B and all seeded-arm input rows**. |
| The evidence package itself records hashes for the arm manifests, raw arms CSV, and results file | **C31_EVIDENCE.sha256 → three evidence rows**. |

END C31 BUILDER REPORT
