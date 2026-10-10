#!/usr/bin/env python3
"""Usage: python3 c40r_assemble.py <WORK_ROOT>   (after the round protocol finished and c40r_eval.py shows EVALUATED / P1 MET / P1 NOT MET).
Freezes the rounds (ROUNDS_FREEZE.json with SHA-256 of every round file), embeds them, and writes the final Builder / Validator / Adjudicator packets."""
import sys, os, json, hashlib, subprocess, glob
W = os.path.abspath(sys.argv[1]); C = os.path.join(W, "C40R"); P = os.path.join(C, "packets")
HERE = os.path.dirname(os.path.abspath(__file__))
subprocess.check_call([sys.executable, os.path.join(HERE, "seeds", "C40R", "c40r_eval.py"), W])
pr = open(os.path.join(C, "post", "C40R_POST_RESULTS.md"), encoding="utf-8").read()
line = [l for l in pr.splitlines() if l.startswith("**Mechanical predicate result: ")][0]
if not any(k in line for k in ("P1 MET", "P1 NOT MET", "HALT**")): sys.exit("outcome not evaluable (%s): by the SPEC there are no B/V/G chats" % line)
sha = lambda p: hashlib.sha256(open(p, "rb").read()).hexdigest()
files = {}
for d in sorted(glob.glob(os.path.join(C, "arms", "*_r*"))):
    for fn in ("GATE_RESULT.txt", "GATE_REPORT.md", "RUN_RB.exit", "RUN_GATE.exit", "RUN_HIDDEN.exit", "MANIFEST_inputs.sha256", "MANIFEST_outputs.sha256"):
        p = os.path.join(d, fn)
        if os.path.exists(p): files[os.path.relpath(p, C)] = sha(p)
    p = os.path.join(d, "outputs", "GATE_depth.txt")
    if os.path.exists(p): files[os.path.relpath(p, C)] = sha(p)
for d in sorted(glob.glob(os.path.join(C, "C40R-*", "r*"))):
    for fn in ("MESSAGE.txt", "reply.md", "TIMES.txt", "EXTRACT.txt", "20_integrity_and_classify.R"):
        p = os.path.join(d, fn)
        if os.path.exists(p): files[os.path.relpath(p, C)] = sha(p)
for fn in ("ROUNDS_LOG.tsv", "STATE_LOG.txt"):
    p = os.path.join(C, fn)
    if os.path.exists(p): files[fn] = sha(p)
fz = os.path.join(C, "ROUNDS_FREEZE.json")
if os.path.exists(fz): sys.exit("ROUNDS_FREEZE.json exists; never overwritten")
json.dump(files, open(fz, "w"), indent=1, sort_keys=True)
blk = ["# C40R ROUNDS AND POST-PROTOCOL RESULT (frozen; P1 is decided from these)", f"ROUNDS_FREEZE.json SHA-256 {sha(fz)}:", "```", open(fz).read(), "```", "", "## c40r_eval.py output", pr, "", "## ROUNDS_LOG.tsv (gate validation arms and rounds)", "```", open(os.path.join(C, "ROUNDS_LOG.tsv"), encoding="utf-8").read(), "```", ""]
for rel in sorted(files):
    if rel.endswith(("GATE_REPORT.md", "TIMES.txt", "MESSAGE.txt", "GATE_RESULT.txt")) or rel.endswith("GATE_depth.txt"):
        blk += [f"### {rel} (SHA-256 {files[rel]})", "```", open(os.path.join(C, rel), encoding="utf-8", errors="replace").read().rstrip("\n"), "```", ""]
    elif rel.endswith("20_integrity_and_classify.R"):
        blk += [f"### {rel} (SHA-256 {files[rel]}; code not reproduced; ChatGPT builder output, hash only)", ""]
rb = "\n".join(blk); out = []
for t in glob.glob(os.path.join(P, "C40R_[345]_*.TEMPLATE.txt")):
    s = open(t, encoding="utf-8").read(); assert "@@C40R_ROUNDS@@" in s
    o = t.replace(".TEMPLATE.txt", ".txt"); open(o, "w", encoding="utf-8", newline="\n").write(s.replace("@@C40R_ROUNDS@@", rb)); out.append(o)
with open(os.path.join(C, "PACKETS_C40R.sha256"), "a") as f:
    for o in sorted(out): f.write("%s  %s\n" % (sha(o), os.path.relpath(o, C)))
print("assembled", out)
