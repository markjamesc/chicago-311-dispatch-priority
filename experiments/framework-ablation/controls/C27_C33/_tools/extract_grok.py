#!/usr/bin/env python3
"""Extract Grok assistant reply/replies (grok.com 'Webpage, Complete' save, Oct 2026 DOM) to Markdown.
Usage: extract_grok.py <html> <out.md> <CID>
Assistant turns = div[id^=response-] whose .message-bubble is the rounded (assistant) bubble; the body is
.response-content-markdown. The 'Worked for Ns' thinking header, buttons, icons, and action bars are dropped.
If there are several assistant turns (e.g. after a user 'continue'), they are joined in DOM order with an explicit
separator line naming the intervening user message. Prints JSON checks."""
import sys, re, json, hashlib
from bs4 import BeautifulSoup
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from markdownify import MarkdownConverter
class MD(MarkdownConverter):
    def convert_code(self, el, text, *a, **k):
        if el.find_parent("pre"): return text
        return "`" + text.replace("`", "") + "`" if text.strip() else ""
def md(el): return MD(heading_style="ATX", bullets="-", escape_underscores=False, escape_asterisks=False, escape_misc=False, strip=["svg","path","img"]).convert_soup(el)
html, out, cid = sys.argv[1:4]
raw = open(html, "rb").read(); s = BeautifulSoup(raw.decode("utf-8", "replace"), "lxml")
turns = []
for r in s.select("div[id^=response-]"):
    b = r.select_one(".message-bubble")
    if b is None: continue
    m = b.select_one(".response-content-markdown")
    if "rounded-3xl" not in b.get("class", []) or m is None:
        turns.append(("user", r["id"], b.get_text(" ", strip=True))); continue
    for x in m.find_all(["button"]): x.decompose()
    t = re.sub(r"\n{3,}", "\n\n", md(m)).strip()
    turns.append(("assistant", r["id"], t, len(re.sub(r"\s+", "", m.get_text()))))
asst = [t for t in turns if t[0] == "assistant"]
parts = []
for i, t in enumerate(turns):
    if t[0] == "assistant":
        if parts or len(asst) > 1: parts.append(f"<!-- GROK TURN {sum(1 for u in turns[:i+1] if u[0]=='assistant')} of {len(asst)} ({t[1]}) -->")
        parts.append(t[2])
    elif parts:
        parts.append(f"<!-- USER MESSAGE BETWEEN TURNS: \"{t[2]}\" -->")
text = "\n\n".join(parts).strip() + "\n"
open(out, "w", encoding="utf-8").write(text)
lines = [l.strip() for l in text.splitlines() if l.strip() and not l.startswith("<!--")]
ts = re.findall(r"TERMINAL_STATE:\s*\**\s*(KEEP|REVERT|HALT)", text)
print(json.dumps({"html": html, "html_sha256": hashlib.sha256(raw).hexdigest(), "html_bytes": len(raw),
  "n_assistant_turns": len(asst), "turn_chars": [len(t[2]) for t in asst], "turn_visible_nows": [t[3] for t in asst],
  "user_msgs": [t[2] for t in turns if t[0]=="user"],
  "md": out, "md_bytes": len(text.encode()), "md_sha256": hashlib.sha256(text.encode()).hexdigest(),
  "terminal_states": ts, "last_two": lines[-2:], "ends_ok": lines[-1] == f"END {cid} ADJUDICATION" and lines[-2].startswith("TERMINAL_STATE:"),
  "each_turn_ends_ok": [t[2].strip().splitlines()[-1].strip()==f"END {cid} ADJUDICATION" for t in asst]}, ensure_ascii=False))
