# Data Documentation

This folder documents the source schema, field meanings, source-version notes, and project-specific data handling decisions without storing the raw multi-gigabyte CSV.

Authoritative raw database location:

```text
schema: chicago311
table:  raw_311_requests
```

Important source fields include:

- `SR_NUMBER`
- `SR_TYPE`
- `STATUS`
- `CREATED_DATE`
- `LAST_MODIFIED_DATE`
- `CLOSED_DATE`
- `DUPLICATE`
- `LEGACY_RECORD`
- `LEGACY_SR_NUMBER`
- `PARENT_SR_NUMBER`
- `WARD`
- `COMMUNITY_AREA`

Do not treat source-field presence as an analytical definition. Concepts such as open, eligible, in-window, urgent, selected, and final action are frozen in Stage 3 and independently implemented in Stage 4.
