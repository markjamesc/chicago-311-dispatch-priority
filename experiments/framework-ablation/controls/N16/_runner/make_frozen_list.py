#!/usr/bin/env python3
"""Write FROZEN_INPUTS.sha256 (every file under frozen/) and FROZEN_ORIGINS.tsv (frozen copy -> origin path, origin sha at write time). Run once at build; preflight_n16.py re-verifies both."""
import pathlib, hashlib, sys
R = pathlib.Path(__file__).resolve().parent.parent; N13 = pathlib.Path("/workspace/ablation_plan/runs/N13"); CR = pathlib.Path("/workspace/chicago-311-run"); DP = pathlib.Path("/workspace/chicago-311-dispatch-priority/docs"); AP = pathlib.Path("/workspace/ablation_plan")
sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
def origin(rel):
    n = pathlib.Path(rel).name; parts = pathlib.Path(rel).parts
    cands = {"stage12": [CR/"stage-01-02", CR/"stage-01-02/reviews", CR/"stage-05/packets"], "stage3": [CR/"stage-03", CR/"stage-03/reviews", CR/"stage-03/packets"], "stage5": [DP/"stage-05-interpretation/reviews", CR/"stage-05/packets", DP/"stage-05-interpretation"],
             "c48": [N13/"runner_b5/seeds/C48", N13/"C48", N13/"C48/C48-audit-ai2", N13/"C48/C48-audit-ai3"], "n13logs": [N13, N13/"C43", N13/"C49", N13/"C40"], "rulings": [AP]}
    if parts[0] == "stage5" and len(parts) > 2 and parts[1] == "deeper": return DP/"stage-05-interpretation/deeper"/n
    if parts[0] == "frozen" or len(parts) == 1: return (N13/"C51"/n) if n != "BASELINE_FRAMEWORK.sha256" else (N13/"C51"/n)
    for c in cands.get(parts[0], []):
        if (c/n).exists(): return c/n
    alt = {"C43_TERMINAL_STATE.txt": N13/"C43/TERMINAL_STATE.txt", "C40_DEVIATION_NOTES_post_2.md": N13/"C40/DEVIATION_NOTES_post_2.md", "C40_DEVIATION_NOTES_post.md": N13/"C40/DEVIATION_NOTES_post.md", "C49_DEVIATION_NOTES_post_2.md": N13/"C49/DEVIATION_NOTES_post_2.md", "C49_DEVIATION_NOTES_post.md": N13/"C49/DEVIATION_NOTES_post.md",
           "ai2_second_audit.md": N13/"C48/C48-audit-ai2/ai2_second_audit.md", "ai3_second_audit.md": N13/"C48/C48-audit-ai3/ai3_second_audit.md"}
    return alt.get(n)
fz = R/"frozen"; L1, L2, bad = [], [], []
for p in sorted(fz.rglob("*")):
    if not p.is_file(): continue
    rel = p.relative_to(R).as_posix(); L1.append(f"{sha(p)}  {p.stat().st_size}  {rel}"); o = origin(p.relative_to(fz).as_posix())
    if o is None or not o.exists(): bad.append(rel); L2.append(f"{rel}\t(origin not found)\t-"); continue
    L2.append(f"{rel}\t{o}\t{sha(o)}" + ("" if sha(o) == sha(p) else "\tMISMATCH"))
(R/"FROZEN_INPUTS.sha256").write_text("\n".join(L1) + "\n"); (R/"FROZEN_ORIGINS.tsv").write_text("\n".join(L2) + "\n")
print(len(L1), "files; origin not found:", bad); print([l for l in L2 if "MISMATCH" in l])
