#!/usr/bin/env python3
import pathlib, hashlib, re
R = pathlib.Path(__file__).resolve().parent.parent; E = R/"evidence"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
rd = lambda p: p.read_text(encoding="utf-8", errors="replace").replace("\r\n","\n").rstrip("\n")
def lines(p, a, b): return "\n".join(rd(p).split("\n")[a-1:b])
def block(title, body, lang=""): return f"\n### {title}\n```{lang}\n{body}\n```\n"
# inline evidence (everything else is hash-listed in the manifest)
inline = [
 ("raw production stdout/stderr, run 1 (2026-09-19 12:56 CT, pre-tz-fix; decoded copy, original bytes hashed in manifest)", rd(E/"raw_logs/PRODUCTION_RUN1_DECODED.txt")),
 ("raw production stdout/stderr, tz-fix re-run (2026-09-19 13:46 CT; decoded copy)", rd(E/"raw_logs/PRODUCTION_RERUN_TZFIX_DECODED.txt")),
 ("raw_evidence/RECON_SUMMARY.csv (post-fix)", rd(E/"raw_evidence/RECON_SUMMARY.csv")),
 ("raw_evidence/RECON_DISAGREE_IDS.csv (post-fix; header only)", rd(E/"raw_evidence/RECON_DISAGREE_IDS.csv")),
 ("raw_evidence/RA_portfolio_counts.csv", rd(E/"raw_evidence/RA_portfolio_counts.csv")), ("raw_evidence/RB_portfolio_counts.csv", rd(E/"raw_evidence/RB_portfolio_counts.csv")),
 ("raw_evidence/r_a_fixture_results.csv", rd(E/"raw_evidence/r_a_fixture_results.csv")), ("raw_evidence/r_b_fixture_results.csv", rd(E/"raw_evidence/r_b_fixture_results.csv")),
 ("raw_evidence/EXACT_RECON_REPORT.md", rd(E/"raw_evidence/EXACT_RECON_REPORT.md")), ("raw_evidence/SOURCE_GATE_REPORT.md", rd(E/"raw_evidence/SOURCE_GATE_REPORT.md")),
 ("raw_evidence/LINEAGE_ATTESTATION.md", rd(E/"raw_evidence/LINEAGE_ATTESTATION.md")),
 ("fixtures/FIXTURE_GATE_RECEIPT.md (lock time)", rd(E/"fixtures/FIXTURE_GATE_RECEIPT.md")), ("fixtures/KNOWN_CASE_FIXTURE_PACK_LOCKED.md", rd(E/"fixtures/KNOWN_CASE_FIXTURE_PACK_LOCKED.md")),
 ("code/run_RA.R lines 102-134 (parse_ts_chicago)", lines(E/"code/run_RA.R",102,134)),
 ("code/run_RA.R lines 328-497 (R-A fixture pack and runner)", lines(E/"code/run_RA.R",328,497)),
 ("code/RB_40_fixtures.R (R-B fixture pack and runner, full)", rd(E/"code/RB_40_fixtures.R")),
 ("code/RB_10_io_parse.R (R-B timestamp parsing, full)", rd(E/"code/RB_10_io_parse.R")),
 ("code/run_recon.R (exact recon, full)", rd(E/"code/run_recon.R")),
]
# manifest of every evidence file
man = [f"{sha(p)}  {p.relative_to(R)}" for p in sorted(E.rglob("*")) if p.is_file()]
for extra in ("ABLATION_SPEC_A02R.md","ORIGINAL_A02_ABLATION_SPEC.md","CONSTITUTION_v1.md","BASELINE_FRAMEWORK.sha256","A02R_FACTS.md","A02R_FACTS.json","runner/a02r_facts.py"): man.append(f"{sha(R/extra)}  {extra}")
(R/"EVIDENCE_MANIFEST_A02R.sha256").write_text("\n".join(man)+"\n")
ev = "\n".join(block(t, b) for t, b in inline)
common = ("\n---\n# FROZEN SPEC (ABLATION_SPEC_A02R.md)\n" + rd(R/"ABLATION_SPEC_A02R.md") + "\n\n---\n# ORIGINAL A02 SPEC (byte-identical copy; design is the same)\n" + rd(R/"ORIGINAL_A02_ABLATION_SPEC.md")
 + "\n\n---\n# CONSTITUTION v1.0\n" + rd(R/"CONSTITUTION_v1.md") + "\n\n---\n# BASELINE FRAMEWORK HASHES\n" + rd(R/"BASELINE_FRAMEWORK.sha256")
 + "\n\n---\n# SCRIPT-DERIVED MECHANICAL FACTS (A02R_FACTS.md; produced by runner/a02r_facts.py from the evidence below; no verdict)\n" + rd(R/"A02R_FACTS.md")
 + "\n\n---\n# EVIDENCE (inline). All other evidence files are listed by hash only.\n" + ev
 + "\n---\n# EVIDENCE MANIFEST (sha256 of every evidence file, inline or not)\n" + "\n".join(man) + "\n")
B = """# A02R Builder — ChatGPT (INDEPENDENT FIRST PASS)

Role: Builder only. Use the highest reasoning setting. You are blind to the Validator and to any earlier review of this ablation. Do NOT return KEEP, REVERT or HALT.

Everything you need is in this message. There are no attachments and no tools, so do not ask for files.
Write a report with exactly these sections:
1. Role attestation and ablation ID.
2. Conceptual diff: what the ablation removes from the baseline workflow (Stage 3 fixture freeze before builders, Stage 4 Fixture Gate enforcement).
3. Hard mechanical facts table. Recompute every number you can from the evidence below (fixture counts and labels, F03 arithmetic, portfolio deltas between R-A and R-B in each run, recon counts, time order of the Fixture Gate lock vs the production runs). Mark each number as recomputed or quoted.
4. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state. State separately what the Fixture Gate detected, what exact recon detected, and what would remain undetected if fixtures were optional or post-hoc.
5. Fixture and reconciliation implications, including the clock-skew defect and F03.
6. Semantic/regression risks and unchanged surfaces (including the rule against rewriting fixtures after a fail).
7. Claim -> evidence map. Cite the evidence item name for each claim.
8. Missing or weak evidence you noticed (list; say "none" if none).
End your reply with this exact line on its own:
END A02 BUILDER REPORT
"""
V = """# A02R Validator — DeepSeek (INDEPENDENT FIRST PASS)

Role: Validator only (DeepThink on). You are blind to the Builder and to any earlier review of this ablation; you have not seen and must not ask for their output. Do NOT return KEEP, REVERT or HALT.

Everything you need is in this message. There are no attachments and no tools, so do not ask for files.
Write a report with exactly these sections:
1. Role attestation and ablation ID.
2. Independent test plan: what you checked, and how.
3. Independently recomputed hard facts. Recompute every number you can from the evidence: fixture pass counts and F03 labels, R-A vs R-B portfolio deltas in each production run, recon summary identities (n_agree + n_disagree = n_inner etc.), the Fixture Gate lock time vs production run times. Flag any internal inconsistency, including in the script-derived facts table.
4. Facts that cannot be recomputed from this packet.
5. P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.
6. Blocking objections. List any defect in the harness, predicate application or evidence that should block a verdict, or state "none". Judge evidence completeness against Constitution section 3 explicitly: which required raw artifact classes are present, which absent.
End your reply with this exact line on its own:
END A02 VALIDATOR REPORT
"""
G = """# A02R Adjudicator — Grok (TERMINAL DECISION)

Role: Adjudicator only (Expert mode, as in A01-A08). Return exactly one terminal state: KEEP, REVERT or HALT.
- KEEP: the ablation is adopted: the known-case Fixture Gate may be made optional or post-hoc.
- REVERT: the mandatory pre-builder Fixture Gate stays.
- HALT: only for these conditions:
  - a hard mechanical disagreement between the Builder and Validator packs;
  - missing raw evidence required for the predeclared P1 and critical facts;
  - a hash or frozen-version mismatch against the FREEZE RECORD or the manifest;
  - a role or information-barrier breach;
  - a predicate that was not defined before execution.
- Raw evidence is present (production stdout logs, fixture runner source, recon script and outputs, Fixture Gate receipt, manifests). Do not HALT only because a historical artifact outside the predeclared critical facts is absent; the known gaps are listed in the SPEC section 4.
- If P1 fails and no HALT condition holds, return REVERT. That is the conservative default.
You may not rerun anything, repair code, create new criteria, relax a gate, or pick one side's mechanical result over the other's (constitution section 10).

# HISTORY DISCLOSURE (facts, not guidance)
- Original A02 (2026-09-19; Builder DeepSeek, Validator Grok, Adjudicator ChatGPT) returned HALT twice. The recorded reason was missing raw evidence (production stdout, fixture runner source, fixture-freeze ordering). The original substantive reading was that P1 fails. Neither is binding on you; decide only on this packet.
- A02R is the same ablation with the rotated roles and the completed evidence listed in the SPEC. No experiment was re-executed.
Final two lines of your reply: 'TERMINAL_STATE: <KEEP|REVERT|HALT>' then 'END A02 ADJUDICATION'.
"""
P = R/"packets"
(P/"A02R_1_BUILDER_ChatGPT.txt").write_text(B + common)
(P/"A02R_2_VALIDATOR_DeepSeek.txt").write_text(V + common)
(P/"A02R_3_ADJUDICATOR_Grok.HEAD.txt").write_text(G + common)
