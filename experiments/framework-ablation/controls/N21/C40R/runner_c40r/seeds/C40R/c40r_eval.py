#!/usr/bin/env python3
"""C40R post-protocol evaluator (Python port of N13 c40_eval.R; same predicate, module = 20_integrity_and_classify.R).
Usage: python3 c40r_eval.py <WORK_ROOT>     (reads <WORK_ROOT>/C40R/arms/<INC|FRESH>_r<k>/ and <WORK_ROOT>/C40R/C40R-<arm>/r<k>/TIMES.txt; writes <WORK_ROOT>/C40R/post/)
Mechanical only: never decides KEEP/REVERT/HALT beyond the frozen P1 text; adjudication is Grok's."""
import sys, os, re, csv, hashlib, datetime
W = os.path.abspath(sys.argv[1]); C = os.path.join(W, "C40R"); OUT = os.path.join(C, "post"); os.makedirs(OUT, exist_ok=True)
MOD = "20_integrity_and_classify.R"; CAP = 2; INC_MAX = 6; FRESH_MAX = 2
def rl(p):
    if not os.path.exists(p): return None
    with open(p, encoding="utf-8", errors="replace") as f: return (f.readline() or "").strip()
def kv(line, k):
    if not line: return None
    m = re.search(r"(?:^|\s)%s=([^\s]*)" % re.escape(k), line); return m.group(1) if m else None
def ex(p):
    z = rl(p)
    try: return float(z.split(",")[1])
    except Exception: return None
def tmin(p):
    if not os.path.exists(p): return None
    d = {}
    for ln in open(p, encoding="utf-8", errors="replace"):
        m = re.match(r"^(sent|reply_complete)=(\d{4}-\d\d-\d\d \d\d:\d\d:\d\d)", ln)
        if m and m.group(1) not in d: d[m.group(1)] = datetime.datetime.strptime(m.group(2), "%Y-%m-%d %H:%M:%S")
    if "sent" in d and "reply_complete" in d: return (d["reply_complete"] - d["sent"]).total_seconds() / 60
    return None
def sha16(p): return hashlib.sha256(open(p, "rb").read()).hexdigest()[:16] if os.path.exists(p) else "MISSING"
rows = []
for arm in ("INC", "FRESH"):
    for k in range(1, INC_MAX + 1):
        d = os.path.join(C, "arms", "%s_r%d" % (arm, k))
        if not os.path.isdir(d): continue
        g = rl(os.path.join(d, "GATE_RESULT.txt")); hd = rl(os.path.join(d, "outputs", "GATE_depth.txt"))
        rm = tmin(os.path.join(C, "C40R-" + arm, "r%d" % k, "TIMES.txt"))
        gs = sum(x for x in (ex(os.path.join(d, n)) for n in ("RUN_RB.exit", "RUN_GATE.exit", "RUN_HIDDEN.exit")) if x is not None) / 60
        rows.append(dict(arm=arm, round=k, gate=kv(g, "gate"), rb_exit=kv(g, "rb_exit"), fixtures=kv(g, "fixtures"),
            classifications_equal=kv(g, "classifications_equal"), hidden_depth_gate=("not run (gate FAIL)" if hd is None else kv(hd, "gate")),
            reply_min=None if rm is None else round(rm, 2), gate_min=round(gs, 2), round_active_min=None if rm is None else round(rm + gs, 2),
            code_sha256=sha16(os.path.join(d, "R-B", "R", MOD))))
inc = [r for r in rows if r["arm"] == "INC"]; fr = [r for r in rows if r["arm"] == "FRESH"]
def first_pass(t):
    for r in sorted(t, key=lambda r: r["round"]):
        if r["gate"] == "PASS": return r["round"]
    return None
ip = first_pass(inc); fp = first_pass(fr); halt = []; outcome = "PENDING"
if not inc: halt.append("no incumbent round recorded")
if ip is not None and ip <= CAP: outcome = "NOT_TRIGGERED"
diverged = len([r for r in inc if r["round"] <= CAP]) >= CAP and all(r["gate"] == "FAIL" for r in inc if r["round"] <= CAP)
base_t = var_t = None; esc_v = esc_b = None
if diverged:
    post = [r for r in inc if r["round"] >= CAP + 1 and (ip is None or r["round"] <= ip)]
    base_t = float("inf") if ip is None else sum((r["round_active_min"] or 0) for r in post)
    var_t = float("inf") if fp is None else sum((r["round_active_min"] or 0) for r in fr if r["round"] <= fp)
    inc_done = ip is not None or (inc and max(r["round"] for r in inc) >= INC_MAX)
    fr_done = fp is not None or (fr and max(r["round"] for r in fr) >= FRESH_MAX)
    if not (inc_done and fr_done): outcome = "PENDING (protocol not finished)"
    elif ip is None and fp is None: outcome = "BOTH_CENSORED"
    else: outcome = "EVALUATED"
    if any(r["round_active_min"] is None for r in [x for x in inc if x["round"] > CAP] + fr):
        halt.append("a TIMES.txt record is missing for a post-divergence round")
    esc_v = next((r["hidden_depth_gate"] for r in fr if r["round"] == fp), None) if fp else None
    esc_b = next((r["hidden_depth_gate"] for r in inc if r["round"] == ip), None) if ip else None
names = ["1. variant valid build: the fresh builder passes the gate within its cap (2 failed rounds)",
 "2. no later: variant active time from divergence <= baseline active time from divergence (baseline without a valid build by r6 = infinite)",
 "3. no defect escapes: the variant's valid build passes the hidden depth check (ruling-41A depth gate, never shown to builders)"]
if outcome == "EVALUATED" and not halt: met = [fp is not None, (var_t is not None and var_t <= base_t), esc_v == "PASS"]
else: met = [None, None, None]
if halt: verdict = "HALT"
elif outcome == "NOT_TRIGGERED": verdict = "NOT TRIGGERED (cap never reached; no verdict; no Builder/Validator/Adjudicator chats)"
elif outcome == "BOTH_CENSORED": verdict = "HALT-INCOMPLETE (neither regime produced a valid build; no Builder/Validator/Adjudicator chats)"
elif outcome == "EVALUATED": verdict = "P1 MET" if all(met) else "P1 NOT MET"
else: verdict = "PENDING"
def mdrow(v): return "| " + " | ".join(str(x).replace("|", "/") for x in v) + " |"
L = ["# C40R POST-PROTOCOL RESULTS (mechanical; generated %s)" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), "",
     "**Mechanical predicate result: %s**" % verdict, ""]
if halt: L += ["HALT reasons:"] + ["- " + h for h in halt] + [""]
L.append("Outcome class: %s. Incumbent first PASS: %s. Fresh first PASS: %s. Diverged: %s." % (outcome, ip, fp, diverged))
if diverged and outcome == "EVALUATED":
    L.append("Active minutes from divergence: baseline (INC r%d..) = %s; variant (FRESH) = %s. Hidden check on the valid builds: variant %s, baseline %s." % (CAP + 1, base_t, var_t, esc_v, esc_b))
L += ["", "## Predicate conditions", "| condition | met |", "|---|---|"] + [mdrow((n, "n/a" if m is None else ("MET" if m else "NOT MET"))) for n, m in zip(names, met)] + ["", "## Rounds"]
cols = ["arm", "round", "gate", "rb_exit", "fixtures", "classifications_equal", "hidden_depth_gate", "reply_min", "gate_min", "round_active_min", "code_sha256"]
if rows: L += [mdrow(cols), "|" + "---|" * len(cols)] + [mdrow([r[c] for c in cols]) for r in rows]
else: L.append("(none)")
sl = os.path.join(C, "STATE_LOG.txt")
if os.path.exists(sl): L += ["", "## STATE_LOG.txt", "```"] + open(sl, encoding="utf-8", errors="replace").read().splitlines() + ["```"]
open(os.path.join(OUT, "C40R_POST_RESULTS.md"), "w", encoding="utf-8").write("\n".join(L) + "\n")
if rows:
    with open(os.path.join(OUT, "C40R_POST_rounds.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader(); w.writerows(rows)
print("C40R:", verdict)
