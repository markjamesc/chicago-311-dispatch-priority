# Chicago 311 Controlling Framework Manifest

This file records the reusable framework documents and project-level controls that govern the Chicago 311 run.

If conversational memory conflicts with the current framework files, the framework files control.

| Stage / control | Framework | Repository path | Purpose |
|---|---|---|---|
| 1–2 | Start & Framing | `ai-augmented-analyst-workflow/docs/three-ai-start-and-framing-dialogue-framework.md` | Discover and lock the decision and analytical question |
| 3 | Measurement Design | `ai-augmented-analyst-workflow/docs/three-ai-measurement-design-framework.md` | Freeze analytical meaning and the SQL→R handoff |
| 4 | Validation & Analysis | `ai-augmented-analyst-workflow/docs/three-ai-validation-and-analysis-framework.md` | Controlled SQL source delivery, Source Gate, independent R-A/R-B, reconciliation, cross-review |
| 4 optional | R Workflow Engine | `ai-augmented-analyst-workflow/docs/ENGINE.md` | Optional post-gate R implementation/reporting aid |
| Cross-stage enforcement | Chicago 311 R Workflow Gate | `validation/workflow-gate/workflow_gate.R` | Deterministically verify that required Stage 1–4 procedural controls were completed on the same locked design before Stage 5 |
| 5 | Interpretation & Recommendation | `ai-augmented-analyst-workflow/docs/three-ai-interpretation-and-recommendation-framework.md` | Convert validated evidence into a proportionate recommendation |

## Canonical URLs

- https://github.com/markjamesc/ai-augmented-analyst-workflow/blob/main/docs/three-ai-start-and-framing-dialogue-framework.md
- https://github.com/markjamesc/ai-augmented-analyst-workflow/blob/main/docs/three-ai-measurement-design-framework.md
- https://github.com/markjamesc/ai-augmented-analyst-workflow/blob/main/docs/three-ai-validation-and-analysis-framework.md
- https://github.com/markjamesc/ai-augmented-analyst-workflow/blob/main/docs/ENGINE.md
- https://github.com/markjamesc/ai-augmented-analyst-workflow/blob/main/docs/three-ai-interpretation-and-recommendation-framework.md

The project-local deterministic enforcement layer is:

- `validation/workflow-gate/workflow_gate.R`
- `validation/workflow-gate/README.md`

## Machine-readable control receipts

The run must create these actual receipts from the corresponding `.example.json` templates after each gate passes:

- `docs/stage-01-02-start-framing/stage1_decision.json`
- `docs/stage-01-02-start-framing/stage2_framing.json`
- `docs/stage-03-measurement-design/stage3_locked_design.json`
- `docs/stage-04-execution-validation/stage4_validation_status.json`

The R workflow gate writes:

- `validation/workflow-gate/workflow_gate_status.json`

Stage 5 is prohibited unless that report says `PASS` and `stage5_allowed = true`.

The gate verifies procedural compliance and evidence presence. It does not replace analytical judgment, the Stage 4 R-A/R-B reconciliation, or human approval.

## Project orchestration prompt

The project-specific controlling prompt is preserved separately at:

`docs/orchestration/master-orchestration-prompt.md`

Do not silently rewrite it after the run begins.

## Versioning rule

At formal run start, record the commit/blob/retrieval version for each controlling framework. If a controlling framework or the workflow-gate contract changes materially during the project, document the change and determine whether any previously passed gate must be reopened.
