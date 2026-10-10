#!/usr/bin/env python3
"""After an extra chat is ingested: score it, freeze it, and fill the B/V/HEAD templates of the controls that use it. Usage: assemble_extra_bv.py <N16_ROOT> <X12|X4>
Runs scorers/<score>.py on <X>/<X>-chat/reply.md -> <X>/post/, writes <X>/EXTRA_FREEZE.json, and for each control writes CID/packets/CID_{1_BUILDER_ChatGPT,2_VALIDATOR_DeepSeek,3_ADJUDICATOR_Grok.HEAD}.txt from the .TEMPLATE.txt files (placeholder @@EXTRA_CHAT_BLOCK@@),
plus CID/evidence/CID_RESULTS.md (the post score for that control) and CID_EVIDENCE.sha256. Refuses (exit 3) on a missing reply, an existing freeze with a different hash, or a missing template."""
import hashlib, json, pathlib, re, subprocess, sys, datetime
R0 = pathlib.Path(__file__).resolve().parent.parent; sys.path.insert(0, str(R0)); from tools_make_n16_defs import EXTRA
root = pathlib.Path(sys.argv[1]).resolve(); x = sys.argv[2]; e = EXTRA[x]; sha = lambda b: hashlib.sha256(b).hexdigest(); fail = lambda m: (print("REFUSED:", m), sys.exit(3))
reply = root/x/f"{x}-chat/reply.md"; pk = root/e["packet"]
if not reply.exists(): fail(f"missing {reply} (run ingest_extra_textonly.py first)")
fz = root/x/"EXTRA_FREEZE.json"; rh = sha(reply.read_bytes())
if fz.exists() and rh not in fz.read_text(): fail("EXTRA_FREEZE.json exists with a different reply hash - reply changed after freeze")
post = root/e["post"]; r = subprocess.run([sys.executable, str(root/"scorers"/e["score"]), str(reply), str(post)], capture_output=True, text=True); print(r.stdout.strip()); 
if r.returncode: fail("scorer failed: " + r.stderr[-300:])
score_f = next(post.glob("*_POST_SCORE.md")); sc = score_f.read_text()
if not fz.exists():
    fz.write_text(json.dumps({"extra": x, "frozen_at_ct": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S CT"), "packet": e["packet"], "packet_sha256": sha(pk.read_bytes()), "reply": str(reply.relative_to(root)), "reply_sha256": rh, "reply_bytes": reply.stat().st_size,
         "score": str(score_f.relative_to(root)), "score_sha256": sha(score_f.read_bytes()), "scorer_sha256": sha((root/"scorers"/e["score"]).read_bytes()), "ingest": json.loads((reply.parent/f"{e['name']}_TEXTONLY.ingest.json").read_text())}, indent=2) + "\n")
block = ["# EXTRA CHAT (frozen; this is the variant arm)", f"Chat: {e['model']}, a NEW conversation; packet sent = `{e['packet']}` sha256 {sha(pk.read_bytes())} ({pk.stat().st_size} bytes); END line `{e['end']}`.", "EXTRA_FREEZE.json:", fz.read_text().rstrip(), "",
         f"## Post-chat score (scorer output, `{score_f.relative_to(root)}`)", sc.rstrip(), ""]
if x == "X4": block += ["## FINAL text extracted by the scorer (`X4/post/FINAL_TEXT.md`)", (post/"FINAL_TEXT.md").read_text().rstrip(), "", "## FINAL text with the two scorer-inserted seeds (`X4/post/FINAL_SEEDED.md`, sha256 " + sha((post/"FINAL_SEEDED.md").read_bytes()) + ")", "(the two inserted sentences are quoted in the score above; the rest is identical to the FINAL text)", ""]
block += ["## Extra-chat packet header (what the chat was told; the supplied evidence follows it in the packet and is hashed in the packet inventory / frozen inputs)", "\n".join(pk.read_text().splitlines()[:60]), "", "## Extra-chat reply (verbatim, text-only capture)", reply.read_text().rstrip(), ""]
blk = "\n".join(block)
for cid in e["used_by"]:
    ev = root/cid/"evidence"; ev.mkdir(exist_ok=True)
    others = {"C01": "C01 (blindness; seed S1)", "C02": "C02 (coordinator draft; seed S2)", "C04": "C04"}[cid]
    (ev/f"{cid}_RESULTS.md").write_text(f"# {cid} RESULTS (post-chat; the shared score file `{score_f.relative_to(root)}` is quoted below; read the section for {others})\n\n" + sc, encoding="utf-8")
    (ev/f"{cid}_EVIDENCE.sha256").write_text("\n".join(f"{sha(p.read_bytes())}  {p.stat().st_size}  {p.relative_to(root).as_posix()}" for p in [pk, reply, fz, score_f, root/"scorers"/e["score"], ev/f"{cid}_RESULTS.md"]) + "\n")
    for n in ("1_BUILDER_ChatGPT", "2_VALIDATOR_DeepSeek", "3_ADJUDICATOR_Grok.HEAD"):
        t = root/cid/"packets"/f"{cid}_{n}.TEMPLATE.txt"
        if not t.exists(): fail(f"missing template {t}")
        txt = t.read_text(encoding="utf-8"); assert txt.count("@@EXTRA_CHAT_BLOCK@@") == 1, t
        o = root/cid/"packets"/f"{cid}_{n}.txt"; o.write_text(txt.replace("@@EXTRA_CHAT_BLOCK@@", blk), encoding="utf-8"); print(o.relative_to(root), o.stat().st_size, sha(o.read_bytes()))
