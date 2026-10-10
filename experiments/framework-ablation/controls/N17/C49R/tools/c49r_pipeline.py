#!/usr/bin/env python3
"""C49R pipeline (box). Usage: c49r_pipeline.py <C49R_ROOT> <step>
 steps: verify-freeze | ingest-blind | score | assemble-bv | ingest <builder|validator|adjudicator> | assemble-grok | record-terminal
Blind replies: <ROOT>/C49R-<ARM>/reply_TEXTONLY.txt + TIMES.txt (arm in DS_ZIP, DS_FILES, GPT_FILES). Never edits evidence; refuses to overwrite differing outputs."""
import sys, re, json, hashlib, pathlib, subprocess, datetime
R = pathlib.Path(sys.argv[1]).resolve(); step = sys.argv[2]; T = pathlib.Path(__file__).resolve().parent
RUNS = R.parent.parent; N13 = RUNS/"N13"/"C49"/"packets"; N16 = RUNS/"N16"/"runner"
sha = lambda b: hashlib.sha256(b).hexdigest(); fail = lambda *a: (print("REFUSED:", *a), sys.exit(3))
rd = lambda p: pathlib.Path(p).read_bytes().decode("utf-8-sig").replace("\r\n", "\n")
ARMS = [l.split("\t") for l in rd(R/"scorer/ARMS.tsv").strip().split("\n")[1:]]
def verify_freeze():
    bad = []
    for l in rd(R/"C49R_SPEC_FREEZE.sha256").split("\n"):
        if not l.strip() or l.startswith("#"): continue
        h, p = l.split("  ", 1)
        if not (R/p).exists() or sha((R/p).read_bytes()) != h: bad.append(p)
    if bad: fail("frozen files changed or missing:", bad)
    print("freeze OK: all frozen files match C49R_SPEC_FREEZE.sha256")
def lastline(t): return ([l.strip() for l in t.split("\n") if l.strip()] or [""])[-1]
def ingest_blind():
    for arm, model, deliv, endl, pkt in ARMS:
        d = R/f"C49R-{arm}"; src = d/"reply_TEXTONLY.txt"; out = d/"reply.md"
        if not src.exists(): fail("missing", src)
        if not (d/"TIMES.txt").exists(): fail("missing", d/"TIMES.txt")
        t = rd(src).rstrip() + "\n"
        if t.count(endl) != 1 or lastline(t) != endl: fail(arm, "END line", repr(endl), "must appear once and be the last line; count", t.count(endl))
        if re.search(r"(?mi)^\s*(TERMINAL[_ ]STATE|VERDICT)\s*[:=]\s*(KEEP|REVERT|HALT)\b", t): fail(arm, "verdict token in reply")
        if len(t) < 200: fail(arm, "reply too small")
        if out.exists() and out.read_bytes() != t.encode(): fail(arm, "reply.md exists and differs")
        out.write_bytes(t.encode()); print("ingested", arm, len(t), sha(t.encode()))
def score(): subprocess.run([sys.executable, str(T/"c49_port.py"), "score", str(R), "--layout", "c49r", "--sums", "SHA256SUMS.txt"], check=True)
def freeze_json(name, items):
    fz = R/name; h = {i: sha((R/p).read_bytes()) for i, p in items}
    if fz.exists():
        old = fz.read_text()
        if not all(v in old for v in h.values()): fail(name, "exists with different hashes")
        return fz
    fz.write_text(json.dumps({"ablation_id": "C49R", "frozen_at_ct": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S CT"), "records": [{"id": i, "path": p, "bytes": (R/p).stat().st_size, "sha256": h[i]} for i, p in items]}, indent=2) + "\n"); return fz
def verb(title, p, fence=False):
    p = pathlib.Path(p); b = p.read_bytes(); rel = p.relative_to(R)
    return ["---", f"## {title} — `{rel}` (sha256 {sha(b)}, {len(b)} bytes, verbatim)"] + (["````"] if fence else []) + [rd(p).rstrip("\n")] + (["````"] if fence else []) + [""]
def header(kind):
    src = {"B": "C49_1_BUILDER_ChatGPT.TEMPLATE.txt", "V": "C49_2_VALIDATOR_DeepSeek.TEMPLATE.txt", "G": "C49_3_ADJUDICATOR_Grok.HEAD.TEMPLATE.txt"}[kind]
    L = rd(N13/src).split("\n"); i = L.index("---"); h = "\n".join(L[:i]).replace("C49", "C49R").replace("SHA256SUMS", "SHA256SUMS.txt").replace("SHA256SUMS.txt.txt", "SHA256SUMS.txt")
    return h.replace("C49RR", "C49R")
def assemble_bv():
    verify_freeze(); score(); items = []
    for arm, *_ in ARMS:
        for f in ("reply.md", "TIMES.txt"):
            if not (R/f"C49R-{arm}"/f).exists(): fail("missing", f, arm)
            items.append((f"{arm}_{f}", f"C49R-{arm}/{f}"))
    fz = freeze_json("REPLY_FREEZE.json", items)
    chk = R/"post"/"DELIVERY_CHECK.txt"; subprocess.run([sys.executable, str(T/"c49_port.py"), "check", str(R/"delivery"), str(R/"post"/"check_out")], check=True)
    blk = ["---", "# C49R REVIEWER REPLIES AND POST-CHAT SCORE (frozen; P1 conditions 1-3 are decided from these)", f"REPLY_FREEZE.json SHA-256 {sha(fz.read_bytes())}:", fz.read_text().rstrip("\n"), "",
           "Each reviewer received only its packet (hashes in the spec freeze) and the delivery set of `delivery/` (DS_ZIP: `ZIP/evidence_pkg.zip`; FILES arms: the 10 files of `FILES/`), new chat, not told about the ablation. Times are operator-logged (TIMES.txt).", ""]
    blk += verb("C49R post-chat score (scorer output)", R/"post/C49_POST_RESULTS.md")
    for arm, model, deliv, *_ in ARMS: blk += verb(f"{arm} TIMES.txt", R/f"C49R-{arm}/TIMES.txt") + verb(f"{arm} reply ({model}, {deliv})", R/f"C49R-{arm}/reply.md")
    base = ["---", "# COORDINATOR NOTE N1 / OF-1", "The N1/OF-1 repeated-hour clock note (disclosed in the packets; owner ruling 53A) is known and expected; C49R delivers frozen Stage 5 text and CSVs only; no R path is rerun.", ""]
    base += ["---", "# SPEC"] + [rd(R/"ABLATION_SPEC_C49R.md").rstrip("\n"), ""]
    base += ["---", "# CONSTITUTION", rd(RUNS/"N13"/"C49"/"CONSTITUTION_v1.md").rstrip("\n"), ""]
    base += verb("SPEC FREEZE", R/"C49R_SPEC_FREEZE.sha256", True)
    base += verb("Pre-chat delivery check (c49_port.py check)", R/"post/check_out/DELIVERY_CHECK.txt") + verb("DELIVERY_FILES.csv", R/"post/check_out/DELIVERY_FILES.csv")
    if (R/"C49R_HARNESS_NOTES.md").exists(): base += verb("Harness notes (Python port and parity)", R/"C49R_HARNESS_NOTES.md")
    base += verb("scorer c49_score.R (authoritative logic)", R/"scorer/c49_score.R", True) + verb("scorer c49_check.R", R/"scorer/c49_check.R", True) + verb("Python port c49_port.py (box harness)", R/"tools/c49_port.py", True)
    for kind, name, endl in (("B", "C49R_1_BUILDER_ChatGPT.txt", "END C49R BUILDER REPORT"), ("V", "C49R_2_VALIDATOR_DeepSeek.txt", "END C49R VALIDATOR REPORT"), ("G", "C49R_3_ADJUDICATOR_Grok.HEAD.txt", None)):
        o = R/"packets"/name; txt = "\n".join([header(kind)] + base + blk + ([f"---\nReminder: no KEEP/REVERT/HALT. Finish with the line: {endl}"] if endl else []))
        if o.exists() and o.read_bytes() != txt.encode(): fail(o, "exists and differs (never overwritten)")
        o.write_bytes(txt.encode()); print("wrote", o.relative_to(R), len(txt.encode()), sha(txt.encode()))
    print("Next: send packets/C49R_1_* to ChatGPT (Builder) and C49R_2_* to DeepSeek (Validator); save C49R/C49R-{builder,validator}/..._TEXTONLY.txt")
def ingest(role):
    r = subprocess.run([sys.executable, str(N16/"ingest_textonly.py"), str(R.parent), "C49R", role]); sys.exit(r.returncode)
def assemble_grok():
    fb, fv = R/"C49R-builder/builder_report.md", R/"C49R-validator/validator_report.md"; head = R/"packets/C49R_3_ADJUDICATOR_Grok.HEAD.txt"
    for f in (fb, fv, head):
        if not f.exists(): fail("missing", f)
    b, v = rd(fb), rd(fv)
    if "END C49R BUILDER REPORT" not in lastline(b) or "END C49R VALIDATOR REPORT" not in lastline(v): fail("END lines")
    fz = freeze_json("EVIDENCE_FREEZE.json", [("builder_report", "C49R-builder/builder_report.md"), ("validator_report", "C49R-validator/validator_report.md")])
    out = "\n".join([rd(head).rstrip("\n"), "---", "# FREEZE RECORD (EVIDENCE_FREEZE.json)", fz.read_text().rstrip("\n"), "", "---", "# BUILDER REPORT (ChatGPT) — frozen, verbatim", b.rstrip("\n"), "", "---", "# VALIDATOR REPORT (DeepSeek) — frozen, verbatim", v.rstrip("\n"), "",
                     "---", "Reminder: exactly one terminal state. Final two lines: 'TERMINAL_STATE: <KEEP|REVERT|HALT>' then 'END C49R ADJUDICATION'."])
    o = R/"packets/C49R_3_ADJUDICATOR_Grok.txt"
    if o.exists() and o.read_bytes() != out.encode(): fail(o, "exists and differs")
    o.write_bytes(out.encode()); print("wrote", o.relative_to(R), len(out.encode()), sha(out.encode()))
def record_terminal():
    f = R/"C49R-adjudicator/adjudicator_raw.md"
    if not f.exists(): fail("missing", f)
    x = [l.strip() for l in rd(f).split("\n") if l.strip()]
    if "END C49R ADJUDICATION" not in x[-1]: fail("no END")
    m = re.findall(r"TERMINAL_STATE:\s*\**\s*(KEEP|REVERT|HALT)", "\n".join(x))
    if len(set(m)) != 1: fail("need exactly one TERMINAL_STATE, found", m)
    (R/"TERMINAL_STATE.txt").write_text(m[0] + "\n"); print("C49R TERMINAL_STATE =", m[0])
{"verify-freeze": verify_freeze, "ingest-blind": ingest_blind, "score": score, "assemble-bv": assemble_bv, "assemble-grok": assemble_grok, "record-terminal": record_terminal}.get(step, lambda: ingest(sys.argv[3]) if step == "ingest" else fail("unknown step"))()
