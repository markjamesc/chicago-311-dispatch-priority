#!/usr/bin/env python3
"""N16 preflight (box, text only): re-hash every frozen input copy against FROZEN_INPUTS.sha256 and against its origin (FROZEN_ORIGINS.tsv). Prints one line per check and PREFLIGHT PASS/FAIL; exit 1 on any failure."""
import pathlib, hashlib, sys, datetime
R = pathlib.Path(__file__).resolve().parent.parent; sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest(); bad = 0
print("N16 preflight", datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S CT"), "root", R)
for l in (R/"FROZEN_INPUTS.sha256").read_text().splitlines():
    h, n, rel = l.split("  ", 2); ok = (R/rel).exists() and sha(R/rel) == h and (R/rel).stat().st_size == int(n); bad += not ok; print("frozen", "OK" if ok else "FAIL", h, rel)
for l in (R/"FROZEN_ORIGINS.tsv").read_text().splitlines():
    rel, o, oh = l.split("\t")[:3]
    if o.startswith("("): print("origin", "FAIL(no origin)", rel); bad += 1; continue
    ok = pathlib.Path(o).exists() and sha(o) == oh == sha(R/rel); bad += not ok; print("origin", "OK" if ok else "FAIL", oh[:16], o)
print("PREFLIGHT", "FAIL" if bad else "PASS", "failures:", bad); sys.exit(1 if bad else 0)
