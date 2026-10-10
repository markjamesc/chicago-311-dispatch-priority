#!/usr/bin/env python3
"""Text-only ingest for an EXTRA chat (X12 or X4). Usage: ingest_extra_textonly.py <N16_ROOT> <X12|X4>
Reads <X>/<X>-chat/<name>_TEXTONLY.txt, checks (exactly one END line and it is the last non-empty line; not tiny; for X4 sections 11, 12, 13 present), writes <X>/<X>-chat/reply.md + <name>_TEXTONLY.ingest.json. Normalisation only (BOM, CRLF, trailing whitespace). Exit 3 on any failed check; never overwrites a different existing reply.md."""
import hashlib, json, pathlib, re, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent)); from tools_make_n16_defs import EXTRA
root = pathlib.Path(sys.argv[1]).resolve(); x = sys.argv[2]; e = EXTRA[x]; d = root/x/f"{x}-chat"; src = d/f"{e['name']}_TEXTONLY.txt"; out = d/"reply.md"; sha = lambda b: hashlib.sha256(b).hexdigest()
fail = lambda m: (print("REFUSED:", m), sys.exit(3))
if not src.exists(): fail(f"missing {src}")
raw = src.read_bytes(); txt = raw.decode("utf-8-sig").replace("\r\n", "\n").replace("\r", "\n").rstrip() + "\n"; lines = [l for l in txt.split("\n") if l.strip()]
chk = {"end_count": txt.count(e["end"]), "end_last_line": bool(lines) and lines[-1].strip() == e["end"], "length_ok": len(txt) >= e["minlen"]}
if x == "X4": chk["sections_11_12_13"] = all(re.search(rf"(?m)^\W*#*\s*{n}[.)]\s", txt) for n in (11, 12, 13))
ok = chk["end_count"] == 1 and chk["end_last_line"] and chk["length_ok"] and chk.get("sections_11_12_13", True)
body = txt.encode(); rec = {"extra": x, "source": str(src.relative_to(root)), "source_bytes": len(raw), "source_sha256": sha(raw), "output": str(out.relative_to(root)), "output_bytes": len(body), "output_sha256": sha(body), "checks": chk, "ok": ok,
       "times_txt": (d/"TIMES.txt").read_text().strip() if (d/"TIMES.txt").exists() else None}
if not ok: print(json.dumps(rec, indent=1)); fail("checks failed")
if out.exists() and out.read_bytes() != body: fail(f"{out} exists with different content")
if not out.exists(): out.write_bytes(body)
(d/f"{e['name']}_TEXTONLY.ingest.json").write_text(json.dumps(rec, indent=1) + "\n"); print(json.dumps(rec, indent=1))
