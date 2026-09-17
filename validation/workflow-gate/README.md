# Chicago 311 R Workflow Gate

This directory contains the deterministic enforcement layer for the five-stage Chicago 311 run.

It is separate from Stage 4 analytical validation.

- **Stage 4 R-A / R-B + reconciliation** answer: did the two independent judged implementations produce the same locked analytical result?
- **The workflow gate** answers: was the required five-stage procedure actually followed on the correct locked design and fixture versions, with preserved evidence and no unresolved validation failure?

Run from the repository root:

```bash
Rscript validation/workflow-gate/workflow_gate.R .
```

The script requires `jsonlite` and reads these machine-readable receipts:

- `docs/stage-01-02-start-framing/stage1_decision.json`
- `docs/stage-01-02-start-framing/stage2_framing.json`
- `docs/stage-03-measurement-design/stage3_locked_design.json`
- `docs/stage-04-execution-validation/stage4_validation_status.json`

It writes:

- `validation/workflow-gate/workflow_gate_status.json`

Stage 5 is allowed only when the gate exits successfully and the report contains:

```json
{
  "result": "PASS",
  "stage5_allowed": true
}
```

The gate verifies procedure, version continuity, declared evidence artifacts, and pass/fail controls. It does **not** decide whether the Stage 3 design is substantively correct and does not replace human or three-AI methodological review.
