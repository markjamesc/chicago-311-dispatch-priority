#!/usr/bin/env python3
"""Python port of N13 runner/assemble_adjudicator.R (box only; no PC). Usage: assemble_adjudicator.py <N16_ROOT> <CID>
Inputs : <CID>/<CID>-builder/builder_report.md, <CID>/<CID>-validator/validator_report.md, <CID>/packets/<CID>_3_ADJUDICATOR_Grok.HEAD.txt
Outputs: <CID>/EVIDENCE_FREEZE.json, <CID>/packets/<CID>_3_ADJUDICATOR_Grok.txt
Fills @@C04_TERMINAL@@ in the HEAD from <ROOT>/C04/TERMINAL_STATE.txt (refuses if the HEAD needs it and the file is missing). Refuses (exit 3) if a reply is missing/too small/lacks its END line or differs from an existing freeze."""
import hashlib, json, pathlib, re, sys, datetime
if len(sys.argv) != 3 or not re.fullmatch(r"A\d{2}R?", sys.argv[2]): print("usage: assemble_adjudicator.py <N16_ROOT> <CID>"); sys.exit(2)
W = pathlib.Path(sys.argv[1]).resolve(); cid = sys.argv[2]; base = cid[:3]; sha = lambda b: hashlib.sha256(b).hexdigest()
def fail(*a): print("REFUSED:", *a); sys.exit(3)
fb, fv = W/cid/f"{cid}-builder/builder_report.md", W/cid/f"{cid}-validator/validator_report.md"; hf = W/cid/"packets"/f"{cid}_3_ADJUDICATOR_Grok.HEAD.txt"
for f in (fb, fv, hf):
    if not f.exists() or f.stat().st_size < 200: fail("missing or too small:", f)
rdu = lambda p: p.read_bytes().decode("utf-8-sig").replace("\r\n", "\n"); b, v, head = rdu(fb), rdu(fv), rdu(hf)
last = lambda t: ([l.strip() for l in t.split("\n") if l.strip()] or [""])[-1]
if f"END {base} BUILDER REPORT" not in last(b): fail("builder reply does not end with END", cid, "BUILDER REPORT")
if f"END {base} VALIDATOR REPORT" not in last(v): fail("validator reply does not end with END", cid, "VALIDATOR REPORT")
leak = lambda t: bool(re.search(r"(?mi)^\s*(\*\*)?\s*(TERMINAL[_ ]STATE|FINAL VERDICT|VERDICT)\s*(\*\*)?\s*[:=]\s*(\*\*)?\s*(KEEP|REVERT|HALT)\b", t))
hb, hv = sha(fb.read_bytes()), sha(fv.read_bytes()); fz = W/cid/"EVIDENCE_FREEZE.json"
if fz.exists():
    old = fz.read_text()
    if hb not in old or hv not in old: fail("EVIDENCE_FREEZE.json exists with different hashes - replies changed after freeze")
if "@@C04_TERMINAL@@" in head:
    t = W/"C04/TERMINAL_STATE.txt"
    if not t.exists(): fail("this HEAD needs C04/TERMINAL_STATE.txt (run C04 first)")
    head = head.replace("@@C04_TERMINAL@@", t.read_text().strip())
if re.search(r"@@(C04_TERMINAL|EXTRA_CHAT_BLOCK)@@", head): fail("unfilled placeholder in HEAD (extra-chat block not assembled?)")
evs = W/cid/"evidence"/f"{cid}_EVIDENCE.sha256"
js = {"ablation_id": cid, "frozen_at_ct": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S CT"), "constitution_version": "1.0", "roles": {"Builder": "ChatGPT", "Validator": "DeepSeek", "Adjudicator": "Grok"},
      "baseline_sha256_files": [l for l in (W/cid/"SPEC_FREEZE_A02R.sha256").read_text().splitlines() if l.strip()],
      "builder_pack": [{"path": f"{cid}/{cid}-builder/builder_report.md", "bytes": fb.stat().st_size, "sha256": hb, "verdict_token_leak": leak(b)}], "validator_pack": [{"path": f"{cid}/{cid}-validator/validator_report.md", "bytes": fv.stat().st_size, "sha256": hv, "verdict_token_leak": leak(v)}],
      "runner_evidence_sha256_file": sha(evs.read_bytes()) if evs.exists() else None, "capture_mode": "text-only (run note; do not publish)"}
if not fz.exists(): fz.write_text(json.dumps(js, indent=2) + "\n")
sup = W/cid/"packets"/f"{cid}_SUPPLEMENT_n16lib.txt"; supt = [ "---", rdu(sup).rstrip("\n"), ""] if sup.exists() else []
out = "\n".join([head.rstrip("\n")] + supt + ["---", "# FREEZE RECORD (EVIDENCE_FREEZE.json)", fz.read_text().rstrip("\n"), "", "---", "# BUILDER REPORT (ChatGPT) — frozen, verbatim", b.rstrip("\n"), "", "---", "# VALIDATOR REPORT (DeepSeek) — frozen, verbatim", v.rstrip("\n"), "",
                "---", f"Reminder: exactly one terminal state. Final two lines: 'TERMINAL_STATE: <KEEP|REVERT|HALT>' then 'END {base} ADJUDICATION'."])
of = W/cid/"packets"/f"{cid}_3_ADJUDICATOR_Grok.txt"; of.write_bytes(out.encode("utf-8"))
print("frozen", cid, "builder", hb, "validator", hv, "\nverdict_token_leak builder=", leak(b), "validator=", leak(v), "\nwrote", of, of.stat().st_size, "bytes", sha(of.read_bytes()))
