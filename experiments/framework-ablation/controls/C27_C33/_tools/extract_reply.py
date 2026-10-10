#!/usr/bin/env python3
"""Extract the assistant reply verbatim (as Markdown) from a 'Webpage, Complete' save of ChatGPT or DeepSeek (Oct 2026 DOM).
Usage: extract_reply.py <html> <out.md> <END line>
- ChatGPT: last [data-chatgpt-selection-message-id] message; if it holds a writing block, use its ProseMirror body
  (block title is emitted as a first-line H1); else the MarkdownRoot. Follow-up suggestion chips, copy buttons and icons
  are UI and are dropped; inline file-citation chips are kept as "[source: <label>]".
- DeepSeek: last .ds-assistant-message-main-content (the reasoning/think pane is excluded).
Prints a JSON line with checks; exit 1 if the END line is not the last non-blank line."""
import sys, re, json, hashlib
from bs4 import BeautifulSoup, NavigableString
from markdownify import MarkdownConverter

class MD(MarkdownConverter):
    def convert_span(self, el, text, *a, **k):
        cls = " ".join(el.get("class", []))
        if "InlineCode" in cls and text.strip(): return "`" + text.strip() + "`"
        return text
    def convert_code(self, el, text, *a, **k):
        if el.find_parent("pre"): return text
        return "`" + text.replace("`", "") + "`" if text.strip() else ""

def md(el): return MD(heading_style="ATX", bullets="-", escape_underscores=False, escape_asterisks=False, escape_misc=False, strip=["svg", "path", "img"]).convert_soup(el)

html, out, endline = sys.argv[1], sys.argv[2], sys.argv[3]
raw = open(html, "rb").read()
s = BeautifulSoup(raw.decode("utf-8", errors="replace"), "lxml")
info = {"html": html, "html_sha256": hashlib.sha256(raw).hexdigest(), "html_bytes": len(raw)}
title = None
msgs = s.select("[data-chatgpt-selection-message-id]")
if msgs:
    info["site"] = "chatgpt"; m = msgs[-1]; info["n_assistant_msgs"] = len(msgs)
    wb = m.select_one("[class*='writing-block-surface']")
    if wb:
        hdr = wb.find("header"); title = hdr.get_text(" ", strip=True) if hdr else None
        root = wb.select_one(".ProseMirror"); info["format"] = "writing-block"
    else:
        root = m.select_one("[class*='MarkdownRoot']"); info["format"] = "markdown"
    for b in root.find_all("button"):
        lab = b.get_text(" ", strip=True)
        if b.get("data-testid") == "chatgpt-library-file-citation" and lab: b.replace_with(NavigableString(f" [source: {lab}]"))
        else: b.decompose()
else:
    info["site"] = "deepseek"; ms = s.select(".ds-assistant-message-main-content"); info["n_assistant_msgs"] = len(ms)
    root = ms[-1]; info["format"] = "ds-markdown"
    for g in root.select("[class*='ds-scroll-area__']"): g.decompose()
vis = root.get_text(" ", strip=True)
text = md(root)
text = re.sub(r"\n{3,}", "\n\n", text).strip() + "\n"
if title: text = f"# {title}\n\n" + text
open(out, "w", encoding="utf-8").write(text)
lines = [l.strip() for l in text.splitlines() if l.strip()]
info.update({
  "md": out, "md_bytes": len(text.encode()), "md_sha256": hashlib.sha256(text.encode()).hexdigest(),
  "visible_chars": len(re.sub(r"\s+", "", vis)), "md_chars_nows": len(re.sub(r"[\s`*#|\-:]", "", text)),
  "ends_with_END": bool(lines) and lines[-1].strip("*` ") == endline,
  "END_count": text.count(endline),
  "section_headers": [l for l in lines if re.match(r"^#{1,4}\s*\d+[.)]", l) or re.match(r"^\*\*\d+[.)]", l)],
  "verdict_line": [l for l in lines if re.match(r"^\W*(TERMINAL[_ ]STATE|FINAL VERDICT|VERDICT)\W*[:=]\W*(KEEP|REVERT|HALT)\b", l, re.I)],
  "source_chips": text.count("[source: "),
  "ui_stop_markers": [k for k in ("Continue generating", "Stopped", "stopped thinking", "Server busy", "network error") if k in raw.decode("utf-8","replace")],
})
print(json.dumps(info, ensure_ascii=False))
sys.exit(0 if info["ends_with_END"] else 1)
