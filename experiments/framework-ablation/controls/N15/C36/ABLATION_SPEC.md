# C36 — Ablation specification (FROZEN)

**Ablation ID:** C36 (owner Remaining Ablation Program, catalog #36 "No Re-Judging Validation Labels")
**Batch:** N15 batch 3 of 3 (controls C36, C35, C32, C15, C45)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 5 (analysis adds insight; it does not reclassify)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
Deeper analysis cannot change classifications set by the Validation Gate. Before release, a label-consistency check confirms that every label-derived Stage-5 output matches the validated labels.

## Exact change being tested (ablation)
There is no label-consistency check. Stage 5's own independent checks stay; they test the input counts, not the outputs.
Seeded Stage-5 variants re-judge labels inside the analysis.

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. A full-field R-A vs R-B recon therefore shows dormant_h 1 and open_age_h 2 on the frozen pack itself. Every "B recon 0/0/0" rule in this batch uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h. Stage-5-only controls (C36, C35, C32, C15) do not rerun R-A or R-B; they start from the frozen validated state.

## Stage-5-only arm design (runner v3, `seeds/<CID>/S5ONLY`)
Every arm, including arm B, starts from the frozen validated state, copied from the frozen PC pack:
- `R-A/outputs/RA_classifications.csv` SHA-256 `c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9` (22,271,481 bytes)
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` (164 bytes)
- `outputs/validated_action_list.csv` SHA-256 `2bffa38b1cf13b99296a4c5d02ead7e22d3c20c4ff22647df31e1fa33761954a` (13,625,648 bytes)
- `stage-05/run_deeper_analysis.R` SHA-256 `ed8694277737989d301b9b1f7e6a06a2dbb87a2ad25254fd53b1db47d92c1ec2` (3,443 bytes)
- `stage-05/deeper/independent_checks_critical_counts.csv` SHA-256 `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146` (190 bytes)
- `stage-05/deeper/portfolio_summary.csv` SHA-256 `b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167` (183 bytes)
- `stage-05/deeper/escalate_by_type.csv` SHA-256 `0f2d8fe0b3509fe27c400eb7cee01e2126beadbca5d82c1b02a9083e00260159` (3,932 bytes)
- `stage-05/deeper/escalate_by_type_top25.csv` SHA-256 `6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176` (1,264 bytes)
- `stage-05/deeper/inconclusive_by_clause.csv` SHA-256 `f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d` (58 bytes)
- `stage-05/deeper/escalate_dormancy_summary.csv` SHA-256 `1c411c1fd02c74f17d94ed6d28849f640c992f075ad86d9d1c405cf350e21e63` (138 bytes)
- `stage-05/deeper/kappa_sensitivity.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` (164 bytes)
- `stage-05/deeper/capacity_coverage_note.csv` SHA-256 `4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609` (644 bytes)
Before anything else runs, the runner writes `VALIDATION_FREEZE.sha256` (SHA-256 and bytes of `R-A/outputs/RA_classifications.csv`, `R-B/outputs/RB_kappa_grid_counts.csv` and `outputs/validated_action_list.csv`). Each arm then runs these steps:
1. **PRE** (C32 only): the arm's post-validation edit script.
2. **FRZ_PRE**: re-hash of the three files against the freeze.
3. **S5**: Stage 5, either the frozen-path harness `runner/stage45/run_deeper_analysis.R` (SHA-256 `a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94`, 3439 bytes; a path-only copy of the frozen `stage-05/run_deeper_analysis.R`) or the arm's seeded variant.
4. **FRZ_POST**: re-hash of the three files after Stage 5.

**Arm B** = no edit + harness. It is the truth reference, and it must reproduce the frozen `stage-05/deeper` outputs.

The harness keeps Stage 5's own independent checks: a `stopifnot` that n_decision, n_ESCALATE, n_INCONCLUSIVE, n_STANDARD and the validated-list count equal the frozen counts. Stage-5 outputs are compared by CSV content, with numbers to 1e-9. Seed scripts and diffs vs the harness are in `runner/SEEDS_b3.sha256` and `runner/SEED_DIFFS_b3.txt`. No R-A/R-B code seeds and no source variants are used in batch 3.

**Harm set H:** Stage 5 completes and either of these holds:
- a label-derived output (`portfolio_summary`, `escalate_by_type`, `escalate_by_type_top25`, `inconclusive_by_clause`, `escalate_dormancy_summary`) differs from arm B;
- an added output's SR-level labels (columns sr_number + classification/action/label) or class totals (n_ESCALATE / n_INCONCLUSIVE / n_STANDARD) disagree with the frozen validated labels.

**Caught with the control:** the label-consistency check, which uses the same definition, fails.
**Caught without the control (D_abl):** Stage 5 exits non-zero.
Disclosure: H and "caught with" coincide by construction, and the benign arm tests for false positives. A benign arm that adds insight without changing labels must not be flagged.

## Seeded arms (frozen before execution)
- **RJ_INC2ESC**: analysis re-judges INCONCLUSIVE with dormant_h >= 8760 as ESCALATE.
  - Stage-5 script `runner/seeds/C36/RJ_INC2ESC__run_deeper_analysis.R` SHA-256 `70f8ed752b24f13556b143f4689576b8c2afdba2475a2c39288440c3f6638753` (3632 bytes)
- **RJ_KAPPA3**: analysis re-judges ESCALATE at kappa 3 and reports kappa 3.
  - Stage-5 script `runner/seeds/C36/RJ_KAPPA3__run_deeper_analysis.R` SHA-256 `60fef3511f3c703fb181dc8ac485df41a41b8523439728eaf04d1e447c98dc94` (3611 bytes)
- **RJ_OPENAGE**: analysis demotes ESCALATE with open_age_h < 720 (diagnostic-only field).
  - Stage-5 script `runner/seeds/C36/RJ_OPENAGE__run_deeper_analysis.R` SHA-256 `7c2410e125cfcc896fc94072ddd5fd044c7f789fc0501ce879bc94f94f902c03` (3619 bytes)
- **RJ_PRECHECK**: re-judging placed before Stage 5's own checks.
  - Stage-5 script `runner/seeds/C36/RJ_PRECHECK__run_deeper_analysis.R` SHA-256 `974bb28be6f2ab44651a7b015d5e3d8d68465c987835dc811d621fab62e1bb28` (3617 bytes)
- **RJ_BENIGN**: benign: adds an ESCALATE-by-peer_n-bin table; labels unchanged.
  - Stage-5 script `runner/seeds/C36/RJ_BENIGN__run_deeper_analysis.R` SHA-256 `f5083f8070fd3253c1447b9f0a7e79f7ab67c541dcd94759b9a7e1dc401a023f` (3714 bytes)

## Operational benefit predicate P1
- **P1 satisfied (KEEP side):** arm B is clean (Stage 5 exit 0; 8/8 outputs equal the frozen stage-05/deeper; the with-control check does not flag B) and H \ D_abl = ∅. Every harm is still caught without the control.
- **P1 failed:** H \ D_abl ≠ ∅.

Also reported, but not counted in P1:
- H \ caught-with: harms the control itself misses.
- Arms flagged with the control but not in H: the control's over-blocking cost.
Owner threshold: Pass = all validated labels remained unchanged; Fail = labels were (even subtly) changed (keep rule).

## Allowed source/data scope
Frozen PC pack, read only and copied into the work folder `...\ablation-runs\N15`. No new extract. MySQL is used only for a read-only COUNT preflight. Nothing in the frozen pack is modified. All edits happen on arm copies.

## Regression / HALT rules
- HALT if arm B's Stage 5 exits non-zero, if arm B's 8 Stage-5 outputs differ from the frozen `stage-05/deeper`, or if any arm lacks an S5 exit record or a FRZ_PRE/FRZ_POST file.
- HALT if Builder and Validator disagree on a hard number in the RESULTS file.
- A seeded arm whose Stage 5 exits non-zero counts as caught in every regime (D_abl). It is not a HALT.
- Raw evidence present → do not HALT for missing historical stdout. If P1 fails and no HALT condition holds → REVERT.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
