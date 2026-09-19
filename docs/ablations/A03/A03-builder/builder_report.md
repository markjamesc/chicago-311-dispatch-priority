# A03 Builder — Grok (Independent First Pass)

## Role and scope

Ablation A03, Builder=Grok, Validator=ChatGPT, Adjudicator=DeepSeek; Constitution 1.0. This is a blind Builder-only pass. No Validator pack was used and no adjudication token is issued here. Target is Stage 4 plus the Stage 3 source-delivery contract. The requested mutation is to remove or soften the SQL nonjudgment bright line so SQL may precompute judged labels, eligibility/integrity, dormant age, and kappa-times-p75 thresholds.

## Conceptual contract diff

The frozen baseline delivers a mechanical Open envelope and peer aggregates from SQL, while R applies eligibility/integrity and independently derives judged labels. SQL label columns are forbidden and Source Gate check J_no_judged_columns passes. The conceptual candidate would allow SQL to emit labels and/or eligibility/dormant-threshold columns, retire or reinterpret J, and allow R to consume pre-judged values. A weak softening could leave final authority in dual R while moving helper arithmetic; the strong reading permits single-path SQL judgment and therefore removes the independent judged implementation. No candidate tree, candidate framework SHA, post-change SQL/R run, revised gate, or candidate fixture run is present, so this is not an executed before/after implementation ablation.

## Hard mechanical facts in the packet

The RAW MANIFEST is present with the listed SHA-256 artifacts, but several bodies are only hashed or excerpted. Baseline framework hash is present; no distinct candidate hash is present. RECON_SUMMARY reports n_ra=222,002, n_rb=222,002, n_inner=222,002, n_only_ra=0, n_only_rb=0, n_agree=222,002, and n_disagree=0. Source Gate is PASS (15 PASS, 0 FAIL, 2 INFO), with extract Open n=245,193, raw Open n=245,193, distinct SR_NUMBER=245,193, peer type_key n=104, and peer row sum=1,881,338. J_no_judged_columns is PASS; lineage and critical field checks pass. Structural evidence reports exact post-fix recon 0 disagreements, identical portfolios at kappa=2 (ESCALATE 131,968; INCONCLUSIVE 6,377; STANDARD 83,657), and fixtures 14/14 for both R-A and R-B, with F03 STANDARD. A prior timezone/clock defect caused 104 near-threshold flips and was repaired before the frozen zero-disagreement recon.

These are baseline facts, not evidence that the proposed SQL-judgment candidate ran. Candidate SQL, candidate gate output, candidate SHA, a measured R-work reduction, and candidate stdout/stderr are absent from the pasted evidence. Missing historical R stdout is not used as a standalone halt argument under the harness note, but the absence of candidate execution remains material to the benefit predicate.

## P1 assessment

P1 requires both measurable reduction of duplicated R work and equal coverage of label errors by Source Gate plus dual R recon. Neither is established. No LOC, runtime, rule-count, or other work-reduction delta is provided. More importantly, the observed 104 near-threshold flips were detected by independent R date semantics and repaired through the dual-path process. A single SQL judgment path, or two R consumers reading one SQL judgment, would make recon agreement true by construction and would not preserve the same detector.

The explicit P1 failure hook is met by the frozen baseline: SQL nonjudgment is necessary to keep the current Source Gate meaningful and to prevent judged leakage into the extract. J_no_judged_columns is a first-class PASS check, not commentary. The extract is a 245,193-row mechanical Open envelope, while the 222,002-row decision set is formed after R eligibility/integrity; moving eligibility into SQL collapses that boundary under the current table names and gate semantics. The Stage 3 delivery contract likewise says SQL delivers the envelope and R judges; the candidate inverts that contract without a new schema, gate definition, or recon authority.

## Risks

Softening/removing the line risks turning Source Gate into a different instrument, leaking labels or eligibility into src_open_candidates, creating false recon greens when both R paths read the same SQL value, collapsing envelope and decision universe, making fixtures tautological, recreating timezone/session-TZ and boundary errors in MySQL, and replacing independent judged builds with two readers of one judge. It also creates Stage 3 contract drift and risks contamination when peer p75 is both an aggregate feature and a judged threshold input. Keeping the current line has a real maintenance cost, but the evidence shows the duplication is the recon instrument, not demonstrated idle work.

## Claim-to-evidence map

Established: manifest presence; one baseline hash and no candidate hash; 245,193 Open envelope; 222,002 decision set; exact recon n_disagree=0; Source Gate PASS; J_no_judged_columns PASS; SQL mechanical-envelope/R-judgment separation; independent R trees; portfolio counts; narrative fixture pass. Established at narrative level only: per-fixture CSV rows and hashed artifact bodies. Not in evidence: candidate SQL judgment implementation, re-gated candidate Source Gate, measured R duplication reduction, or equal-coverage seeded label-error test. Supported: the SQL nonjudgment bright line is load-bearing for Source Gate meaning and extract-vs-decision separation. Builder conclusion: P1 is not satisfied on the frozen evidence. This is a finding, not KEEP/REVERT/HALT.
