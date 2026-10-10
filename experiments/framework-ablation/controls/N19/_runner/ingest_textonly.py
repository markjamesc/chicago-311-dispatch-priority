#!/usr/bin/env python3
"""Text-only capture ingest (owner-approved 2026-10-09 01:52 CT; see CAPTURE_MODE_TEXTONLY.md). New file; no frozen file is altered.
Usage: ingest_textonly.py <N13_ROOT> <CID> <builder|validator|adjudicator>
Reads <CID>/<CID>-<role>/<name>_TEXTONLY.txt (name: builder_chatgpt | validator_deepseek | adjudicator_grok), verifies it, and writes
  builder:      <CID>-builder/builder_report.md        (input to assemble_adjudicator.R)
  validator:    <CID>-validator/validator_report.md    (input to assemble_adjudicator.R)
  adjudicator:  <CID>-adjudicator/adjudicator_raw.md   (input to record_terminal.R)
plus <role>_TEXTONLY.ingest.json (hashes, checks). Normalisation only: BOM removed, CRLF->LF, trailing whitespace at end of file trimmed to one LF. Refuses (exit 3) on any failed check;
refuses to overwrite an existing output that differs."""
import hashlib, json, pathlib, re, sys
root, cid, role = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3]
cfg = {"builder": ("builder_chatgpt", "builder_report.md", "BUILDER REPORT", 7), "validator": ("validator_deepseek", "validator_report.md", "VALIDATOR REPORT", 7),
       "adjudicator": ("adjudicator_grok", "adjudicator_raw.md", "ADJUDICATION", 7)}[role]
d = root/cid/f"{cid}-{role}"; src = d/f"{cfg[0]}_TEXTONLY.txt"; out = d/cfg[1]
fail = lambda m: (print("REFUSED:", m), sys.exit(3))
if not src.exists(): fail(f"missing {src}")
raw = src.read_bytes(); sha = lambda b: hashlib.sha256(b).hexdigest()
txt = raw.decode("utf-8-sig").replace("\r\n", "\n").replace("\r", "\n"); txt = txt.rstrip() + "\n"
lines = [l for l in txt.split("\n") if l.strip()]; end = f"END {re.sub(r'V\d+$', '', cid)} {cfg[2]}"
chk = {"end_count": txt.count(end), "end_last_line": lines[-1].strip() == end if lines else False}
if role == "adjudicator":
    ts = re.findall(r"(?m)^\s*\**\s*TERMINAL_STATE:\s*\**\s*(KEEP|REVERT|HALT)\b", txt)
    chk["terminal_state_lines"] = len(ts); chk["second_last_is_terminal"] = len(lines) > 1 and bool(re.match(r"^\W*TERMINAL_STATE:\s*\W*(KEEP|REVERT|HALT)\W*$", lines[-2].strip()))
    chk["leak"] = False
else:   # same pattern as assemble_adjudicator.R verdict_leak, plus any bare verdict word as a warning
    chk["leak"] = bool(re.search(r"(?mi)^\s*(\*\*)?\s*(TERMINAL[_ ]STATE|FINAL VERDICT|VERDICT)\s*(\*\*)?\s*[:=]\s*(\*\*)?\s*(KEEP|REVERT|HALT)\b", txt))
    chk["bare_verdict_words"] = len(re.findall(r"\b(KEEP|REVERT|HALT)\b", txt))
heads = [int(m) for m in re.findall(r"(?m)^\s*\**#*\s*([1-9])\.\s+\S", txt)]
need = list(range(1, cfg[3] + 1)); pos = 0; found = []
for h in heads:
    if pos < len(need) and h == need[pos]: found.append(h); pos += 1
# Fallback (added 2026-10-09 for DeepSeek text pastes that lose list numbering): the 7 section titles as standalone lines, in order. Text is never modified.
TITLES = {"builder": ["Role attestation", "Conceptual diff", "Hard mechanical facts", "P1 assessment", "Fixture and reconciliation", "Semantic/regression risks", "Claim"],
          "validator": ["Role attestation", "Independent test plan", "Independently recomputed hard facts", "Facts that cannot be recomputed", "P1 assessment", "Blocking objections", "Claim"],
          "adjudicator": ["Role attestation", "Freeze check", "Hard-fact agreement", "KEEP conditions", "HALT conditions", "Blocking objections", "Verdict rationale"]}[role]
tpos, tfound = 0, []
for l in txt.split("\n"):
    t = re.sub(r"^[\s#*\d.)]+", "", l).strip()
    if tpos < 7 and (len(l) < 160 or t.lower().startswith(TITLES[tpos].lower())) and (t.lower().startswith(TITLES[tpos].lower()) or (role == "adjudicator" and TITLES[tpos].lower() in t.lower()[:40])): tfound.append(TITLES[tpos]); tpos += 1
chk["sections_found_in_order"] = found; chk["sections_by_title"] = tfound
chk["sections_ok"] = found == need or len(tfound) == 7
chk["one_reply"] = chk["end_count"] == 1 and len(re.findall(r"(?mi)^[\s#*\d.)]*Role attestation", txt)) == 1
ok = chk["end_count"] == 1 and chk["end_last_line"] and chk["sections_ok"] and chk["one_reply"] and not chk["leak"] and (role != "adjudicator" or (chk["terminal_state_lines"] == 1 and chk["second_last_is_terminal"]))
body = txt.encode("utf-8")
rec = {"cid": cid, "role": role, "source": str(src.relative_to(root)), "source_bytes": len(raw), "source_sha256": sha(raw), "output": str(out.relative_to(root)),
       "output_bytes": len(body), "output_sha256": sha(body), "checks": chk, "ok": ok, "times_txt": (d/"TIMES.txt").read_text().strip() if (d/"TIMES.txt").exists() else None}
if not ok: print(json.dumps(rec, indent=1)); fail("checks failed")
if out.exists() and out.read_bytes() != body: fail(f"{out} exists with different content")
if not out.exists(): out.write_bytes(body)
(d/f"{cfg[0]}_TEXTONLY.ingest.json").write_text(json.dumps(rec, indent=1) + "\n"); print(json.dumps(rec, indent=1))
