# SQL Source Gate

Blocking validation that the controlled SQL package equals the authorized mechanical extract from `chicago311.raw_311_requests`.

**FAIL stops R.** “Close” is not a pass.

## Run (PC)
1. Deliver Open envelope (`sql/source-delivery/`).
2. Materialize `chicago311.source_open_envelope` (`load_delivered_for_gate.sql` or TSV load).
3. Run `source_gate_checks.sql`; paste results into `SOURCE_GATE_REPORT.md`.
4. Freeze package path + SHA-256 for identical R-A / R-B handoff.
