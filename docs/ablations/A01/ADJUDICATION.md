# A01 Adjudication
- mode: Expert
- CT timestamp: 2026-09-19 15:15 CT
- Adjudicator=Grok

# A01 Adjudicator — Terminal Decision

**Mode:** Comprehensive (constitution applied clause-by-clause; no new criteria).

## 1. Role attestation

- **Adjudicator = Grok.**
- Constitution v1.0 frozen; ablation spec A01 frozen; no rewrite of ablation, no rerun, no invented gates.
- Saw **only** the frozen packs in this brief: Builder pack (`builder_report.md` SHA-256 `b7a84548bd8bb9910dcac060fbe770f635add8756f80ce50e3387448e27a0ac8`; `execution_stdout.txt` SHA-256 `3d577110e462fababef562b64f097442a87101c986126bd2e32e446dcb405195`) and Validator pack (`validator_report.md` SHA-256 `ca03eb7b073db70de399eccb7ea3e6c682c6a4a45324a3d22c2d1b251433d763`; `execution_stdout.txt` SHA-256 `6e44906296f57a45760b2d1378e14c08393cafaf5ef895dd128c27f1c5d34219`).
- Role assignment matches freeze record: Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok.
- Both first-pass packs attest blindness. No Builder/Validator raw workspace trees were attached to the adjudicator freeze; adjudication is confined to those hashed packs.

## 2. Hard mechanical agreement check (Builder vs Validator)

Predeclared critical fields and related hard facts:

| Fact | Builder | Validator independent recompute | Agree? |
|---|---|---|---|
| n_decision / n_inner | 222,002 | 222,002 (RECON_SUMMARY.csv arithmetic) | Yes |
| n_agree | 222,002 | 222,002 | Yes |
| n_disagree | 0 | 0 | Yes |
| n_only_ra / n_only_rb | 0 / 0 | 0 / 0 | Yes |
| Path-count identities | implied by table | n_ra = n_agree + n_only_ra; n_rb = n_agree + n_only_rb; n_inner = n_agree + n_disagree | Yes |
| Portfolio κ=2 ESCALATE / INCONCLUSIVE / STANDARD | 131,968 / 6,377 / 83,657 | same; sums to 222,002; R-A = R-B | Yes |
| Post-fix exact recon | 222,002 / 222,002 agree | same reported PASS | Yes on reported counts |
| Fixtures | 14/14 both paths; F03 STANDARD | same **reported**; raw actuals/expecteds not in pack | No **conflict** on the stated result |
| Pre-fix mismatch | 104 rows; R-A STANDARD vs R-B ESCALATE; ~5h tz/force_tz | same **reported**; raw 104-row list not in pack | No **conflict** on the stated result |
| Baseline SHA-256s | accepted as declared | declared; Validator could not rehash raw `.md` files from this packet | No conflicting hash |

**Ruling:** There is **no hard mechanical disagreement** on any predeclared numeric fact both packs state. Validator’s “reported only / cannot independently verify from raw join/fixture dumps” notes are completeness caveats, not conflicting values. Constitution §4 HALT-for-disagreement is **not** triggered.

Missing *underlying* dumps (raw RA/RB decision files, fixture actuals, gate stdout, fix diffs) are addressed under KEEP #1 / §3, not as a §4 conflict.

## 3. KEEP conditions 1–9 (conjunctive)

| # | Condition | Pass/Fail | Frozen-evidence citation |
|---|---|---|---|
| 1 | Evidence packs complete and frozen | **Fail (completeness)** | Freeze record hashes the four pack files. Validator §7 lists absent raw artifacts (RA/RB decision outputs, recon join, 104-row list, fixture actuals F01–F14, gate outputs, fix diffs/hashes, baseline file bytes). Builder cites `EXACT_RECON_REPORT` / `STRUCTURAL_CROSS_REVIEW` without attaching those files to the adjudicator freeze. Packs are *frozen*; they are not *complete raw backing* under Constitution §3. |
| 2 | Role separation valid | **Pass** | Spec + freeze record + both attestations: three distinct models; first-pass blindness claimed; Adjudicator sees only frozen packs. |
| 3 | Builder and Validator agree on hard mechanical facts | **Pass** | §2 table: identical 222,002 / 0 / portfolio / 104-row story. No conflicting number. |
| 4 | Exact reconciliation passes where required | **Pass (on reported post-fix state)** | Builder §3 / Validator facts 5–13: post-fix Agree 222,002 / Disagree 0. Ablation does not claim a new recon run under shared helpers. |
| 5 | Every mandatory fixture passes | **Fail as independently established** | Both *report* 14/14 and F03→STANDARD. Validator fact 17: raw fixture actuals/expecteds absent from the frozen packet → fixture PASS is a claim, not raw-backed evidence (§3). |
| 6 | No undeclared semantic change detected | **Pass (vacuous on candidate)** | No candidate shared-helper implementation exists (Validator fact 29, objection 1). Declared change is only the independence rule. No undeclared rewrite of ESCALATE/INCONCLUSIVE/STANDARD, Chicago pack, Fixture Gate, or exact-recon requirement appears in either pack. |
| 7 | No locked regression introduced | **Pass (no implemented change)** | Proposal text in Builder §2 keeps exact recon, Fixture Gate, Validation Gate, κ/T_freeze, frozen Chicago pack. Nothing implemented that would strip A02/A08 locks. |
| 8 | Predeclared benefit predicate P1 satisfied | **Fail** | See §4 below. Both packs: detection of the 104-row defect depended on independent parse/tz implementations. |
| 9 | No blocking objection remains supported by frozen evidence | **Fail** | Validator §6 objections still standing: no candidate implementation or shared-helper run; no detection-coverage test under sharing; 104-row signal was path asymmetry; fixtures 14/14 did not catch production mismatch; cost reduction unmeasured; no replacement safeguard; independence attestation (“Shared judged helpers: None”) would be voided with no new control. Builder §4–§5 independently supports the same detection-coverage objection. |

**KEEP is unavailable:** conditions 1, 5, 8, and 9 are not established. All nine are conjunctive (Constitution §7).

## 4. Benefit predicate P1 ruling

**P1 (frozen):** benefit only if dropping dual-path independence / allowing shared judged helpers would still have caught the production 104-row near-threshold ESCALATE/STANDARD disagreement (or an equivalent seeded path-asymmetry defect) with **equal or better detection coverage**, while reducing duplicated judged implementation cost.

**Failure clause (frozen):** P1 fails if evidence shows dual-path (or independent parse implementations) was **necessary** to surface the 104-row defect.

**Ruling: P1 FAILED.**

- Builder §3–§4 and Validator facts 18–22 agree the defect was 104 rows, R-A STANDARD vs R-B ESCALATE, systematic ~5h `dormant_h` offset, near κ×p75, cause = R-B POSIXct shortcut vs R-A `force_tz`.
- Builder §4: “the defect existed because two independent implementations provided two different interpretations of the same raw field”; a shared timestamp helper “could produce identical outputs; zero reconciliation disagreement.”
- Validator §5: “the evidence matches P1’s stated failure condition: independent parse implementations were necessary to surface the 104-row defect.” No shared-helper run, no seeded equivalent under sharing, no cost measurement.
- Additional coverage gap (Validator objection 4): both paths already 14/14 fixture PASS while the 104-row production miss still occurred — fixtures are not a substitute for path independence on this defect class.

P1’s cost-reduction conjunct is also unshown (Validator fact 30 / objection 5). Even if cost were granted, detection coverage is not shown preserved.

## 5. Terminal state

**REVERT**

HALT is not returned: §4 mechanical values do not conflict; roles, constitution version, baseline hashes-as-declared, and predeclared P1 wording are intact; packs are hashed and authoritative as between each other. Missing raw dumps prevent *KEEP* completeness, but they do not leave two irreconcilable mechanical worlds. Mechanics of the *baseline Chicago run as reported* are coherent. Constitution §8: coherent mechanics + absent HALT + unproven KEEP ⇒ **REVERT**.

## 6. KEEP Stage 3/4 edits

Not applicable.

## 7. REVERT rationale

The hashed packs agree that post-fix Method B recon is 222,002/222,002 with identical κ=2 portfolios and a reported 14/14 fixture pass, and they agree that the only production path-asymmetry in evidence—the 104-row STANDARD↔ESCALATE miss—was generated by independent timestamp implementations (`force_tz` vs POSIXct), then caught by exact recon. A01’s proposed weakening (shared judged helpers / common judged library) has no candidate implementation, no shared-helper rerun, and no measured cost save; both packs conclude that sharing the parse/clock layer would have removed the differential signal that exposed that defect. That is exactly P1’s predeclared failure condition, and Validator blocking objections remain evidence-backed. KEEP therefore fails on benefit, remaining objections, and incomplete raw backing of fixture/gate claims. The conservative constitutional default is to leave the Stage 4 independence lock (“no shared judged helpers”) canonical.