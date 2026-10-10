#!/usr/bin/env python3
import os, hashlib
W = os.path.dirname(os.path.abspath(__file__)); P = os.path.join(W, "packets"); S = os.path.join(W, "runner_c40r", "seeds", "C40R")
rd = lambda p: open(p, encoding="utf-8").read().rstrip("\n")
sha = lambda p: hashlib.sha256(open(p, "rb").read()).hexdigest()
spec = rd(os.path.join(W, "ABLATION_SPEC_C40R.md"))
scripts = []
for n in ("c40r_gate.R", "c40r_next.R", "c40r_eval.py"):
    scripts += [f"## {n} (SHA-256 {sha(os.path.join(S, n))})", "```", rd(os.path.join(S, n)), "```", ""]
scripts += ["## fixdepth.R (hidden depth check; byte-identical to the C40 / b5-C41 file)", f"SHA-256 {sha(os.path.join(S, 'fixdepth.R'))}; the file is not reproduced here (never shown to builders).", ""]
seeds = [f"- `{n}` SHA-256 `{sha(os.path.join(S, n))}`" for n in sorted(os.listdir(S)) if n.startswith("SEED_")]
common_tail = ["", "---", "# SPEC", spec, "", "---", "# SEEDS (gate-validation modules; derived from the frozen module by a one-line edit each)"] + seeds + ["", "---", "# HARNESS SCRIPTS (verbatim)"] + scripts + ["---", "@@C40R_ROUNDS@@", ""]
real = ["", "---", "# WHAT IS REAL AND WHAT IS MODELLED", "Real: every builder reply, gate run, exit record, hidden check and timing record under ROUNDS. Prior real evidence (C40 NOT_TRIGGERED; PricePoint R-B r1–r10) is context only and is not re-scored. Modelled: the task difficulty (the larger module 20_integrity_and_classify.R was chosen so that the cap can trigger; this was decided before any builder chat). See the SPEC section 'Design choice'."]
B = """# C40R Builder — ChatGPT (INDEPENDENT FIRST PASS)

Role: Builder only (a NEW chat, not one of the extra builder chats INC or FRESH). Use the highest reasoning setting. You are blind to the Validator. Do NOT return KEEP, REVERT or HALT.

Everything you need is in this message. There are no attachments and no tools.
Write a report with exactly these sections:
1. Role attestation and ablation ID.
2. Conceptual diff: what the cap changes, and what is real vs modelled in this test.
3. Hard mechanical facts table: per round, gate result, fixtures, hidden check, active minutes; first PASS per arm; divergence; the two active-minute totals. Recompute every number you can from the evidence tables; mark each as recomputed or quoted.
4. P1 assessment against the frozen predicate in the SPEC (conditions 0–3). Facts only, no terminal state.
5. Risks: n=1 task, one builder model, handover advantage of the fresh builder, operator-logged timing, modelled difficulty.
6. Claim → evidence map. Cite the section and table row for each claim.
End your reply with this exact line on its own:
END C40R BUILDER REPORT
""" 
V = """# C40R Validator — DeepSeek (INDEPENDENT FIRST PASS)

Role: Validator only (DeepThink on). You are blind to the Builder; you have not seen and must not ask for its output. Do NOT return KEEP, REVERT or HALT.

Everything you need is in this message. There are no attachments and no tools.
Write a report with exactly these sections:
1. Role attestation and ablation ID.
2. Independent test plan: what you checked, and how.
3. Independently recomputed hard facts (per-round gate/fixtures/hidden, first PASS per arm, divergence, active minutes for both regimes, hash equalities). Flag any internal inconsistency in the runner output.
4. Facts that cannot be recomputed from this packet.
5. P1 assessment against the frozen predicate in the SPEC. Facts only, no terminal state.
6. Blocking objections: any defect in the harness, seeds, predicate application, timing records or evidence that should block a verdict, or "none".
7. Claim → evidence map.
End your reply with this exact line on its own:
END C40R VALIDATOR REPORT
"""
G = """# C40R Adjudicator — Grok (TERMINAL DECISION)

Role: Adjudicator only (Expert mode, as in A01–A08). Return exactly one terminal state: KEEP, REVERT or HALT.
- KEEP: the repair-round cap is adopted: after 2 failed rounds a fresh builder takes over with the gate reports (no code), with its own cap of 2, then escalation to the owner.
- REVERT: repair rounds stay unlimited for one builder.
- HALT: only for these conditions: a hard mechanical disagreement between the Builder and Validator packs; missing raw evidence; a hash or frozen-version mismatch against the frozen reference hashes; a role or information-barrier breach; a predicate not defined before execution; gate validation (P1 condition 0) failing.
- If P1 fails and no HALT condition holds, return REVERT. That is the conservative default.
- Items the SPEC marks modelled or not measured are not evidence either way. You may not rerun anything, repair code, create new criteria, relax a gate, or pick one side's mechanical result over the other's.
Everything you need is in this message. There are no attachments and no tools.
Reply in full, in one message. If your reply already ends with the two final lines, it is complete.

Write these sections:
1. Role attestation.
2. Freeze check: are the Builder and Validator reports the hashed files in the FREEZE RECORD, complete, ending with their END line?
3. Hard-fact agreement table: Builder vs Validator vs runner RESULTS. Mark each row agree or disagree.
4. P1 conditions 0–3: MET or NOT MET with citation.
5. HALT conditions: present or absent, with citation.
6. Blocking objections raised by the Validator and how the evidence bears on them.
7. Verdict rationale: did the change under test (repair-round cap, Addendum 01b #40) materially change the outcome on this task?
End your reply with exactly these two lines:
TERMINAL_STATE: <KEEP|REVERT|HALT>
END C40R ADJUDICATION
"""
for name, t in (("C40R_3_BUILDER_ChatGPT.TEMPLATE.txt", B), ("C40R_4_VALIDATOR_DeepSeek.TEMPLATE.txt", V), ("C40R_5_ADJUDICATOR_Grok.HEAD.TEMPLATE.txt", G)):
    open(os.path.join(P, name), "w", encoding="utf-8", newline="\n").write(t + "\n".join(real + common_tail))
print("ok")
