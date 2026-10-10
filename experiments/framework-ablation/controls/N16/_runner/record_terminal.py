#!/usr/bin/env python3
"""Python port of N13 runner/record_terminal.R. Usage: record_terminal.py <N16_ROOT> <CID>: reads <CID>/<CID>-adjudicator/adjudicator_raw.md, writes <CID>/TERMINAL_STATE.txt (refuses if ambiguous / incomplete)."""
import pathlib, re, sys
W = pathlib.Path(sys.argv[1]).resolve(); cid = sys.argv[2]; f = W/cid/f"{cid}-adjudicator/adjudicator_raw.md"
if not f.exists(): print("REFUSED: missing", f); sys.exit(3)
x = [l.strip() for l in f.read_text(encoding="utf-8-sig").splitlines() if l.strip()]
if not x or f"END {cid} ADJUDICATION" not in x[-1]: print("REFUSED: reply does not end with END", cid, "ADJUDICATION"); sys.exit(3)
m = re.findall(r"TERMINAL_STATE:\s*\**\s*(KEEP|REVERT|HALT)", "\n".join(x))
if len(set(m)) != 1: print("REFUSED: need exactly one TERMINAL_STATE value, found:", m); sys.exit(3)
(W/cid/"TERMINAL_STATE.txt").write_text(m[0] + "\n"); print(cid, "TERMINAL_STATE =", m[0])
