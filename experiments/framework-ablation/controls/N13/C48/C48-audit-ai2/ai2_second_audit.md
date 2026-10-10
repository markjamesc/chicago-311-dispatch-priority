1. Per-revision verification table

V-1 | YES | “2. Accept with Framing return on capacity Required next step Validated with limitation Capacity concern is real because ESCALATE volume is large, but addressing it requires a new framing decision.” | “2. Accept with Framing return on capacity Required next step” | None. Assessment cell changed from “Plausible next step” to “Required next step”; rationale unchanged and still consistent.

V-2 | YES | “3. Monitor type-level aggregates only (WCA2 / SED / SKA); no row-level pilot Possible methodological follow-up Sensitivity-dependent Useful for evaluation, but must remain simulation-only and cannot become live dispatch.” | “3. Monitor type-level aggregates only (WCA2 / SED / SKA); no row-level pilot Possible methodological follow-up” | None on the required option text. Rationale was not in the correction and still bars live dispatch.

V-3 | PARTIAL | “131,968 requests (59.4%) / WCA2 alone supplies 64,922 of these (42.9% of ESCALATE), so the ESCALATE volume is concentrated in one service type.” | “131,968 requests (59.4%) / WCA2 alone supplies 64,922 of these (49.2% of ESCALATE), so the ESCALATE volume is concentrated in one service type.” | Sentence was inserted in the requested place with the correct count 64,922, but the share was written 42.9% instead of the requested and package-supported 49.2%.

V-4 | YES | “Exact reconciliation: 0 label disagreements across 222,002 rows (label-only reconciliation; SHA-256 lineage values are in LINEAGE_ATTESTATION.md, not inline in this package)” | “Exact reconciliation: 0 label disagreements across 222,002 rows (label-only reconciliation; SHA-256 lineage values are in LINEAGE_ATTESTATION.md, not inline in this package)” | None.

V-5 | YES | “Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation, with a Framing return on capacity as the required next design question.” | “Recommendation: Accept the frozen labels as the Stage 5 portfolio assignment for methodology evaluation, with a Framing return on capacity as the required next design question.” | None. Section 7 body still withholds operational dispatch, which matches the reconciliation.

V-6 | YES | Line absent. Revised text ends at “The evidence supports using the output as a simulation assignment, while leaving real-world dispatch implications unresolved.” | “(delete the quoted line)” | None. Chat-interface artifact removed.

2. Findings

F-1 | MATERIAL | V-3 | “WCA2 alone supplies 64,922 of these (42.9% of ESCALATE), so the ESCALATE volume is concentrated in one service type.” | Replace 42.9% with 49.2%. Package and AI3: 64,922 / 131,968 = 0.491952595 = 49.2% of ESCALATE. 42.9% is not in the evidence, the κ grid, or the first-round reviews. Do not change the count 64,922 or the rest of the sentence.

none otherwise. V-1, V-2, V-4, V-5, and V-6 match the request. No new recommendation, rival, capacity claim, or causal claim was added. Untouched text still stays inside the ceiling: simulation partition only; no City SLA; no live dispatch; no employee scoring; WCA2 concentration explicitly not an operational cause; ranking still out of scope; Framing return now required rather than optional; option 3 is type-aggregate monitor only.

3. Overall verdict

PASS WITH REQUIRED REVISIONS

Five of six revisions landed exactly, and the decision content now matches the first-round resolution: accept the frozen labels as the Dataset 2 methodology assignment, treat Framing return on capacity as required, restrict any follow-up to type-level aggregates (WCA2 / SED / SKA) with no row-level pilot, and keep the causal ceiling. The revision did not reopen Stage 3/4 locks or invent a shift budget. It cannot be released as is because V-3 introduced a wrong share: 42.9% instead of 49.2%. That is the figure a reader would use for the concentration claim the audit asked to add. Correct that one number to 49.2% and the revised interpretation is releasable.

END C48 AI2 SECOND AUDIT
