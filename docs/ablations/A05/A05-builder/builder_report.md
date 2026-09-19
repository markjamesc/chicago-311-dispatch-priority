# A05 Builder — DeepSeek DeepThink (INDEPENDENT FIRST PASS)

## Role attestation

- **Ablation:** A05
- **Builder:** DeepSeek
- **Validator:** Grok
- **Adjudicator:** ChatGPT
- **Constitution:** 1.0
- **Target:** Stage 3 locked knob
- **Mode:** Builder only. DeepThink ON. Independent first pass. Blind to Validator.
- **Decision limit:** I do not issue KEEP / REVERT / HALT. Final adjudication belongs to ChatGPT.
- **Frozen inputs used:** SPEC, CONSTITUTION 1.0, RAW MANIFEST, RECON_SUMMARY.csv, kappa_sensitivity.csv, and FINISH_GATE_RECEIPT excerpt.
- **Manifest note:** RAW MANIFEST is present. Per the adjudicator note, missing historical R stdout is not treated as a HALT condition in this Builder pass.

## Conceptual Stage 3 diff (multi-knob)

### Current frozen Stage 3 surface

The supplied evidence states:

- single locked owner knob: **κ = 2**;
- method constants: **W = 365**, **n_min = 50**;
- κ grid is descriptive only in Stage 5;
- Finish Gate did not change κ.

Conceptually:

```yaml
stage3:
  owner_tunable_knobs:
    - kappa
  locked_knob:
    kappa: 2
  constants:
    W: 365
    n_min: 50
```

### Proposed conceptual change

Allow multiple owner-tunable knobs, or treat method constants W / n_min as knobs, instead of only the single locked owner knob κ. A candidate surface could be:

```yaml
stage3:
  owner_tunable_knobs:
    - kappa
    - W
    - n_min
  defaults:
    kappa: 2
    W: 365
    n_min: 50
  knob_policy:
    ranges: <not specified in frozen pack>
    lock_state: <not specified in frozen pack>
    owner_approval: <not specified in frozen pack>
  design_gate_lock:
    status: <not specified in frozen pack>
```

The exact candidate is not mechanically pinned in the supplied pack. It is unspecified whether W and n_min are definitely converted to knobs, whether κ remains locked, what ranges apply, what the full candidate config hash is, which Stage 4 reconciliation fields cover knob-induced semantic changes, and what lock attestation authorizes conversion of constants to tunables. Thus the proposed multi-knob surface is conceptual only; the frozen evidence supports a locked single-knob baseline and a descriptive κ grid, not a tested multi-knob candidate.

## Hard facts

From the frozen artifacts:

- RAW MANIFEST is present and includes hashed artifacts, including:
  - `BASELINE_FRAMEWORK.sha256` — `86067f79de27c634656462c1106a38c10c12c531432fb847a0e08e349a5ade08`
  - `EXACT_RECON_REPORT.md` — `85504e41a1c3898ae1cf0c1158aeb417738a9eadf6d59533e1e6c9f602f1bd16`
  - `RECON_SUMMARY.csv` — `110cabad9ba44bc69c1e2525ea014378e01cab9f17561779d8d7ea0648640b09`
  - `stage4_validation_status.json` — `81b62bc05901b902b18c7a97306fea5c89d222ceed6b0bc16446a351a847fcfb`
  - `r_a_fixture_results.csv` — `33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110`
  - `r_b_fixture_results.csv` — `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- Exact reconciliation summary: `n_ra = 222002`, `n_rb = 222002`, `n_inner = 222002`, `n_only_ra = 0`, `n_only_rb = 0`, `n_agree = 222002`, `n_disagree = 0`.
- κ sensitivity is descriptive:
  - κ=1: ESCALATE 152,292; INCONCLUSIVE 6,377; STANDARD 63,333.
  - κ=1.5: ESCALATE 140,340; INCONCLUSIVE 6,377; STANDARD 75,285.
  - κ=2: ESCALATE 131,968; INCONCLUSIVE 6,377; STANDARD 83,657.
  - κ=3: ESCALATE 118,246; INCONCLUSIVE 6,377; STANDARD 97,379.
  - Total decisions are 222,002 at every grid value.
- Finish Gate receipt excerpt: **PASS**, approved at `2026-09-19 14:41 CT`, design version `stage3-v1-tcd-ig`, fixture version `fixtures-v1-tcd-ig`.
- Locked Stage 5 stance accepts frozen κ=2 labels: ESCALATE 131,968, INCONCLUSIVE 6,377, STANDARD 83,657; no live dispatch from the ESCALATE file; framing return on capacity is required before any operational focus list or ranking.
- Spec-stated baseline: Chicago has single κ=2 locked; W=365 and n_min=50 are constants; κ grid is descriptive only in Stage 5; Finish Gate did not change κ.

## P1 assessment

**P1:** Multiple knobs improve Stage 5 portfolio usefulness (for example, shrink ESCALATE) without harming Stage 4 exact reconciliation / fixture Pass, with equal detection coverage.

### Benefit side

The provided κ grid shows that increasing κ alone shrinks ESCALATE: 152,292 at κ=1, 140,340 at κ=1.5, 131,968 at κ=2, and 118,246 at κ=3. INCONCLUSIVE remains constant at 6,377. This supports single-knob descriptive sensitivity, not a multi-knob benefit. There is no frozen candidate run showing that treating W and/or n_min as knobs improves Stage 5 portfolio usefulness. There is also no operational focus-list metric in the pack; the Finish Gate explicitly requires framing return on capacity before any operational focus list or ranking. Therefore the multi-knob benefit portion of P1 is not established by the frozen evidence.

### Harm side

Baseline exact reconciliation passes with `n_disagree = 0`; Finish Gate is PASS; and fixture version `fixtures-v1-tcd-ig` is frozen. However, no candidate multi-knob exact recon, fixture actuals/expecteds, or Stage 4 validation run is provided. Equal detection coverage is not defined or measured in the provided artifacts. Therefore “without harming Stage 4 exact recon / fixture Pass” is not demonstrated for the proposed multi-knob change.

### P1 failure triggers

- **Silent Stage 4 disagreement:** not observed in baseline, but untested for multi-knob.
- **Greenwash:** not assessed; there is no detection-coverage metric or candidate portfolio comparison.
- **Constants converted into undeclared tunables:** this is a live risk. W=365 and n_min=50 are currently constants. No lock amendment, owner approval, or Design Gate re-attestation authorizing their conversion appears in the frozen pack.

### Builder P1 conclusion

On the frozen evidence provided, P1 is not established for the multi-knob proposal. The only demonstrated effect is descriptive single-κ ESCALATE shrink. The multi-knob benefit, equal detection coverage, and Stage 4 non-harm remain unsupported without a frozen candidate multi-knob run. I make no KEEP / REVERT / HALT decision here.

## Risks

1. **Design Gate lock invalidation:** converting W / n_min from constants to tunables may invalidate the Stage 3 lock unless explicitly declared and approved; no lock amendment is included.
2. **Undeclared tunables:** the proposal could create undeclared tunables if ranges, defaults, ownership, and config hashes are not frozen. This directly matches a P1 failure condition.
3. **Silent Stage 4 disagreement:** multi-knob interactions could alter decision semantics while exact reconciliation still passes if critical fields omit those semantics; no candidate recon artifact is present.
4. **Greenwash / coverage loss:** shrinking ESCALATE is insufficient if detection coverage drops or INCONCLUSIVE/STANDARD shifts mask missed cases; no candidate fixture behavior or coverage metric is provided.
5. **Portfolio overfitting:** κ sensitivity already shows ESCALATE shrink, but the Finish Gate requires framing return on capacity before operational focus lists. Multi-knob tuning could optimize counts without proving operational usefulness.
6. **Reproducibility/config explosion:** multiple knobs expand the configuration space; a full candidate config hash is absent, while only baseline and κ sensitivity artifacts are frozen.
7. **Ambiguous exact change:** the spec allows “or treat method constants W / n_min as knobs,” which is not one mechanically frozen candidate. Without a pinned candidate, Builder/Validator agreement on the changed-file and config set is difficult.

## Claim → evidence

| Claim | Evidence | Builder assessment |
|---|---|---|
| Baseline exact reconciliation passes | `RECON_SUMMARY.csv`: `n_disagree=0`, `n_agree=222002` | Supported |
| κ=2 is locked baseline | Finish Gate locked Stage 5 stance; SPEC Chicago note | Supported |
| W=365 and n_min=50 are constants | SPEC evidence block | Supported |
| κ grid is descriptive only in Stage 5 | SPEC and `kappa_sensitivity.csv` | Supported |
| Finish Gate passed | Receipt excerpt: Result PASS | Supported |
| Fixture version is frozen | Receipt: `fixtures-v1-tcd-ig` | Supported |
| Raw manifest exists | RAW MANIFEST with hashes | Supported |
| Multiple knobs improve Stage 5 usefulness | No candidate multi-knob run; only single-κ grid | Not established |
| Multi-knob change does not harm Stage 4 or fixtures | No candidate multi-knob recon or fixture actuals | Not established |
| Equal detection coverage | No detection-coverage metric in frozen pack | Missing |
| Constants converting to tunables may invalidate Design Gate lock | W/n_min currently constants; no lock amendment | Supported as risk |
| Silent disagreement / greenwash under multi-knob | No candidate run; not observed but untested | Unexcluded |

**Builder first pass complete. No KEEP / REVERT / HALT decision issued.**
