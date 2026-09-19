# Ablation scorecard index (Chicago 311 — **8-ablation batch**)

| ID | Control | Terminal | Canonical effect |
|----|---------|----------|------------------|
| A01 | Dual-path independence | **REVERT** | Dual-path remains |
| A02 | Fixture Gate | **HALT** (P1 failed; see HARNESS_DIAGNOSIS) | Fixture Gate remains; no KEEP |
| A03 | SQL nonjudgment | **REVERT** | SQL nonjudgment remains |
| A04 | Source Gate | **REVERT** | Source Gate remains |
| A05 | Single owner knob | **REVERT** | Single knob remains |
| A06 | Integrity INCONCLUSIVE | **REVERT** | Hard INCONCLUSIVE remains |
| A07 | TCD-IG vs raw age | **REVERT** | TCD-IG construct remains |
| A08 | Exact recon fields | **REVERT** | Full exact recon remains |
| A09 | Capacity Framing-only | **DEFERRED** | Not in this batch |
| A10 | ML Mode declaration | **DEFERRED** | Not in this batch |

**Batch result:** 0 KEEP · 7 REVERT · 1 HALT · A09/A10 deferred → **no Stage 3/4 framework edits.**

Full write-up: [BATCH_A01_A08_SCORECARD.md](BATCH_A01_A08_SCORECARD.md)
