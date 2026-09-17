# SQL Source Gate

This folder contains the blocking validation that proves the controlled SQL source package faithfully represents the authorized raw source contract before R-A and R-B proceed.

The Source Gate is distinct from raw-import verification.

It should verify, as applicable:

- row / universe counts;
- request-ID coverage;
- multiplicity and duplicate behavior;
- critical-field equality against the authoritative raw source;
- source value preservation;
- status and domain distributions;
- missingness;
- date coverage and extraction boundaries;
- lineage / source version;
- and the Stage 3 mechanical extraction envelope.

A gate must be independently derived from the Stage 3 source-delivery contract rather than merely restating the extraction query predicates.

Status: **Not started.**
