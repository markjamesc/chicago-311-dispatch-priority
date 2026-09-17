# SQL Source Delivery

Stage 4 SQL belongs here.

SQL must remain a **controlled, faithful, nonjudgmental source-delivery layer**. It may perform authorized mechanical extraction and joins, but it should not silently decide analytical concepts such as:

- `is_in_window`
- `is_open`
- `is_eligible`
- analytical duplicate treatment
- urgency / lateness
- `action`
- `selected`
- final request membership

unless Stage 3 explicitly authorizes the step as mechanical.

The delivery query and its lineage must be auditable against `chicago311.raw_311_requests`.

Status: **No production SQL yet.**
