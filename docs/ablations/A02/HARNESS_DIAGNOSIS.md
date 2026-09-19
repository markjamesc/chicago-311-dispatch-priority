# A02 HALT — harness diagnosis

**Official terminal state:** HALT (twice; ChatGPT Adjudicator)

**Substantive finding (not a KEEP):** Benefit predicate P1 failed — Fixture Gate and exact recon protect different defect classes (F03 construct vs path asymmetry). Making Fixture Gate optional is not justified.

**Why HALT instead of REVERT:** Adjudicator treated missing *original production R stdout/fixture-runner logs* as Constitution §3 incompleteness even after RECON_SUMMARY, fixture result CSVs, portfolio CSVs, lineage, and framework SHAs were attached. A01’s Adjudicator (Grok) faced similar gaps and correctly returned **REVERT** (coherent mechanics + unproven KEEP).

**Harness fix going forward:** Adjudicator briefs for A03–A10 explicitly state: if Builder/Validator agree on hard numbers and the `_raw_evidence` MANIFEST (recon CSV, fixture result CSVs, portfolio CSVs, baseline framework SHAs, gate JSONs) is present, do **not** HALT solely for absent historical Rscript stdout from the production night; return **REVERT** when P1 fails and HALT conditions (conflicting numbers, role breach, missing predeclared P1) are absent.

**Canonical effect of A02:** No framework edit. Mandatory Fixture Gate **remains** (same practical outcome as REVERT).
