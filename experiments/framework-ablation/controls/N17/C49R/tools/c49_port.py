#!/usr/bin/env python3
"""Python port of c49_check.R / c49_score.R (box harness choice; the R scripts stay authoritative).
Usage:
  c49_port.py check <delivery_dir> <outdir> [--sums SHA256SUMS.txt]
  c49_port.py score <root> [--layout c49r|n13] [--sums NAME] [--out DIR]
c49r layout: <root>/scorer/{ARMS.tsv,KNOWN_ANSWERS.csv}, <root>/delivery/FILES, replies <root>/C49R-<arm>/{reply.md,TIMES.txt}, out <root>/post
n13 layout : <root>/runner_b6/seeds/C49/{ARMS.tsv,KNOWN_ANSWERS.csv,delivery/FILES}, replies <root>/C49/C49-<arm>/..., out given by --out"""
import sys, re, csv, hashlib, zipfile, pathlib, math, datetime, io
from zoneinfo import ZoneInfo
sha = lambda b: hashlib.sha256(b).hexdigest()
def rdl(p):
    t = pathlib.Path(p).read_bytes().decode("utf-8")
    x = re.split(r"\r\n|\n|\r", t)
    if x and x[-1] == "": x.pop()
    if x and x[0].startswith("\ufeff"): x[0] = x[0][1:]
    return x
def trimws(s): return re.sub(r"^[ \t\r\n]+|[ \t\r\n]+$", "", s)
nz = lambda x: [l for l in x if trimws(l) != ""]
def norm(s):
    s = s.replace("`", ""); s = s.replace("\\|", "|"); s = s.replace("**", ""); s = re.sub(r"[ \t\n\r\f\v]+", " ", s); return trimws(s)
def q(v):
    if v is None: return "NA"
    if isinstance(v, bool): return "TRUE" if v else "FALSE"
    if isinstance(v, (int,)): return str(v)
    if isinstance(v, float):
        if math.isinf(v): return "Inf" if v > 0 else "-Inf"
        return ("%.15g" % v)
    return '"' + str(v).replace('"', '""') + '"'
def wcsv(path, cols, rows):
    out = [",".join('"%s"' % c for c in cols)] + [",".join(q(r[c]) for c in cols) for r in rows]
    pathlib.Path(path).write_bytes(("\n".join(out) + "\n").encode("utf-8"))
def rcsv(path):
    return list(csv.DictReader(io.StringIO(pathlib.Path(path).read_bytes().decode("utf-8-sig"))))
def check(D, OUT, sums_name):
    D = pathlib.Path(D); OUT = pathlib.Path(OUT); OUT.mkdir(parents=True, exist_ok=True); F = D/"FILES"
    sums = [l for l in rdl(F/sums_name) if l]; h = [re.sub(r"  .*$", "", l) for l in sums]; nm = [re.sub(r"^[0-9a-f]{64}  ", "", l) for l in sums]
    files = sorted(set(p.name for p in F.iterdir()) - {sums_name}); zf = D/"ZIP"/"evidence_pkg.zip"; z = zipfile.ZipFile(zf); zn = z.namelist()
    allf = nm + [sums_name]; tab = []
    for i, f in enumerate(allf):
        b = (F/f).read_bytes(); zb = z.read(f) if f in zn else None
        tab.append({"file": f, "bytes": len(b), "sha256_listed": h[i] if i < len(nm) else None, "sha256_file": sha(b), "in_zip": f in zn, "sha256_zip": sha(zb) if zb is not None else "MISSING"})
    ok = set(nm) == set(files) and all(t["sha256_listed"] == t["sha256_file"] for t in tab[:len(nm)]) and all(t["in_zip"] for t in tab) and all(t["sha256_zip"] == t["sha256_file"] for t in tab) and len(zn) == len(nm) + 1
    wcsv(OUT/"DELIVERY_FILES.csv", ["file","bytes","sha256_listed","sha256_file","in_zip","sha256_zip"], tab)
    line = "status=%s n_evidence_files=%d zip_entries=%d zip_bytes=%d files_bytes_total=%d zip_sha256=%s" % ("PASS" if ok else "FAIL", len(nm), len(zn), zf.stat().st_size, sum(t["bytes"] for t in tab), sha(zf.read_bytes()))
    (OUT/"DELIVERY_CHECK.txt").write_text(line + "\n"); print(line); return 0 if ok else 1
def tm(p):
    p = pathlib.Path(p)
    if not p.exists(): return None
    x = rdl(p); tz = ZoneInfo("America/Chicago")
    def g(k):
        z = [l for l in x if l.startswith(k + "=")]
        if not z: return None
        m = re.match(r"(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)", z[0][len(k)+1:])
        if not m: return None
        return datetime.datetime(*map(int, m.groups()), tzinfo=tz).astimezone(datetime.timezone.utc)
    s, d = g("sent"), g("reply_complete")
    return None if s is None or d is None else (d - s).total_seconds() / 60
def rround(x, n):  # R round half-even on the decimal repr, as base R >= 4.0
    return round(x, n)
def score(W, layout, sums_name, outdir):
    W = pathlib.Path(W)
    if layout == "c49r": S = W/"scorer"; DF = W/"delivery"/"FILES"; rep = lambda a: W/f"C49R-{a}"; OUT = pathlib.Path(outdir) if outdir else W/"post"
    else: S = W/"runner_b6"/"seeds"/"C49"; DF = S/"delivery"/"FILES"; rep = lambda a: W/"C49"/f"C49-{a}"; OUT = pathlib.Path(outdir)
    OUT.mkdir(parents=True, exist_ok=True)
    L = rdl(S/"ARMS.tsv"); hdr = L[0].split("\t"); arms = [dict(zip(hdr, l.split("\t"))) for l in L[1:] if l]
    sums = nz(rdl(DF/sums_name)); H = {re.sub(r"^[0-9a-f]{64}  ", "", l): re.sub(r"  .*$", "", l) for l in sums}
    truth = {}
    for f in H:
        x = nz(rdl(DF/f)); truth[f] = (norm(x[0]), norm(x[-1]))
    ka = rcsv(S/"KNOWN_ANSWERS.csv"); rows = []; halt = []
    PFX = r"^[ \t\n\r\f\v>*`-]*"
    for a in arms:
        arm = a["arm"]; endl = a["end_line"]; f = rep(arm)/"reply.md"
        if not f.exists(): halt.append("reply missing: " + arm); continue
        x = rdl(f); nzl = [trimws(l) for l in x if trimws(l) != ""]; last = nzl[-1] if nzl else None
        end_ok = last is not None and endl in last
        if not end_ok: halt.append("reply has no END line as last line: " + arm)
        st = [i for i, l in enumerate(x) if re.search(PFX + "FILE:", l)]; inv = []
        for j, s0 in enumerate(st):
            e = (st[j+1] - 1) if j < len(st) - 1 else s0 + 12; blk = x[s0:min(len(x), e + 1)]
            def g(k):
                z = [l for l in blk if re.search(PFX + k + ":", l)]
                return norm(re.sub(PFX + k + r":\**", "", z[0], count=1)) if z else None
            op = g("OPENED"); inv.append({"file": g("FILE"), "sha256": g("SHA256"), "opened": op.upper() if op else None, "lines": g("LINES"), "first": g("FIRST"), "last": g("LAST")})
        for r in inv: r["file"] = re.sub(r"[`*]", "", r["file"]).split("/")[-1].split("\\")[-1] if r["file"] is not None else None
        ev = []
        for fn in H:
            rr = [r for r in inv if r["file"] == fn]
            sm = len(rr) > 0 and any(r["sha256"] is not None and re.sub(r"[^0-9a-fA-F]", "", r["sha256"]).lower() == H[fn] for r in rr)
            fo = any(r["first"] == truth[fn][0] for r in rr if r["first"] is not None); lo = any(r["last"] == truth[fn][1] for r in rr if r["last"] is not None)
            so = any(r["opened"] is not None and r["opened"].startswith("YES") for r in rr)
            ev.append({"file": fn, "listed": any(r["file"] == fn for r in inv), "sha_match": sm, "first_ok": fo, "last_ok": lo, "said_opened": so, "opened_proven": fo and lo})
        wcsv(OUT/f"INVENTORY_{arm}.csv", ["file","listed","sha_match","first_ok","last_ok","said_opened","opened_proven"], ev)
        fa = []
        for k in ka:
            qq = k["q"]; z = [l for l in x if re.search(PFX + re.escape(qq) + r"[:.)]", l)]; val = None
            if z:
                s = re.sub(r"^.*?" + re.escape(qq) + r"[:.)]", "", z[0], count=1)
                v = re.findall(r"[0-9][0-9,]*\.?[0-9]*", s); val = v[0].replace(",", "") if v else None
            ok = False
            if val is not None:
                try: ok = abs(float(val) - float(k["answer"])) < 1e-9
                except ValueError: ok = False
            fa.append({"q": qq, "expected": k["answer"], "reply": val, "correct": ok})
        wcsv(OUT/f"FACTS_{arm}.csv", ["q","expected","reply","correct"], fa)
        mins = tm(rep(arm)/"TIMES.txt")
        if mins is None: halt.append("TIMES.txt missing or incomplete: " + arm)
        usable = end_ok and all(e["opened_proven"] for e in ev) and all(r["reply"] is not None for r in fa)
        rows.append({"arm": arm, "model": a["model"], "delivery": a["delivery"], "reply_sha256": sha(f.read_bytes()), "end_line": end_ok, "files_listed": sum(e["listed"] for e in ev),
            "files_opened_proven": sum(e["opened_proven"] for e in ev), "n_files": len(ev), "files_said_opened": sum(e["said_opened"] for e in ev), "sha_match": sum(e["sha_match"] for e in ev),
            "facts_answered": sum(r["reply"] is not None for r in fa), "facts_correct": sum(r["correct"] for r in fa), "usable": usable,
            "minutes": None if mins is None else rround(mins, 2), "time_to_usable_min": (None if mins is None else rround(mins, 2)) if usable else float("inf")})
    G = lambda arm, col: next((r[col] for r in rows if r["arm"] == arm), None)
    v = ["DS_FILES", "GPT_FILES"]
    def allv(col): return all(G(a, col) is not None and G(a, col) == G(a, "n_files") for a in v)
    t1, t2 = G("DS_FILES", "time_to_usable_min"), G("DS_ZIP", "time_to_usable_min")
    c3 = t1 is not None and t2 is not None and t1 <= t2 + 2
    conds = [("1. variant access: DS_FILES and GPT_FILES each prove access to every evidence file (FIRST and LAST lines match)", allv("files_opened_proven")),
             ("2. inventory hashes: in DS_FILES and GPT_FILES every evidence file is listed with the SHA-256 in " + sums_name, allv("sha_match")),
             ("3. delay no worse: DS_FILES time to a usable first pass <= DS_ZIP time to a usable first pass + 2 min (DS_ZIP not usable = met)", c3)]
    verdict = "HALT" if halt else ("P1 MET" if all(c[1] for c in conds) else "P1 NOT MET")
    cols = ["arm","model","delivery","reply_sha256","end_line","files_listed","files_opened_proven","n_files","files_said_opened","sha_match","facts_answered","facts_correct","usable","minutes","time_to_usable_min"]
    if rows: wcsv(OUT/"C49_POST_arms.csv", cols, rows)
    def fmtcol(col):  # R format() gives a column a common number of decimals
        vals = [r[col] for r in rows if isinstance(r[col], float) and not math.isinf(r[col])]
        dec = max([len(("%.15g" % x).split(".")[1]) if "." in ("%.15g" % x) else 0 for x in vals] or [0])
        for r in rows:
            if isinstance(r[col], float) and not math.isinf(r[col]): r[col] = ("%." + str(dec) + "f") % r[col]
    mdrows = None
    md = lambda hd, rs: ["| " + " | ".join(hd) + " |", "|" + "|".join(["---"] * len(hd)) + "|"] + ["| " + " | ".join(str(c).replace("|", "/") for c in r) + " |" for r in rs]
    import copy; rows_fmt = copy.deepcopy(rows); rows_bak = rows; rows = rows_fmt; fmtcol("minutes"); fmtcol("time_to_usable_min")
    Lm = ["# C49 POST-CHAT RESULTS (mechanical; generated %s by c49_port.py)" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), "", "**Mechanical predicate result: %s**" % verdict, ""]
    if halt: Lm += ["HALT reasons:"] + ["- " + h for h in halt] + [""]
    Lm += ["## Predicate conditions"] + md(["condition", "met"], [(c, "MET" if m else "NOT MET") for c, m in conds]) + ["", "## Arms"] + (md(cols, [[("TRUE" if r[c] is True else "FALSE" if r[c] is False else "Inf" if r[c] == float("inf") else r[c]) for c in cols] for r in rows]) if rows else ["(none)"]) + [""]
    rows = rows_bak
    for a in arms:
        for k in ("INVENTORY_", "FACTS_"):
            pp = OUT/f"{k}{a['arm']}.csv"
            if pp.exists():
                rr = rcsv(pp); Lm += ["## %s%s.csv" % (k, a["arm"])] + md(list(rr[0].keys()), [list(r.values()) for r in rr]) + [""]
    (OUT/"C49_POST_RESULTS.md").write_text("\n".join(Lm) + "\n"); print("C49:", verdict); return 0
if __name__ == "__main__":
    a = sys.argv[1:]
    opt = lambda k, d=None: a[a.index(k)+1] if k in a else d
    if a[0] == "check": sys.exit(check(a[1], a[2], opt("--sums", "SHA256SUMS.txt")))
    elif a[0] == "score": sys.exit(score(a[1], opt("--layout", "c49r"), opt("--sums", "SHA256SUMS.txt"), opt("--out")))
