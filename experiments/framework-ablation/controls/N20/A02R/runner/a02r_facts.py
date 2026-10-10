#!/usr/bin/env python3
"""A02R mechanical facts. Reads only files under evidence/. Writes A02R_FACTS.md and A02R_FACTS.json next to evidence/. No R needed."""
import re, json, hashlib, pathlib, sys, csv
R = pathlib.Path(__file__).resolve().parent.parent; E = R/"evidence"
t1 = (E/"raw_logs/PRODUCTION_RUN1_DECODED.txt").read_text(errors="replace")
t2 = (E/"raw_logs/PRODUCTION_RERUN_TZFIX_DECODED.txt").read_text(errors="replace")
def ra_rb(t):
    d = {}
    m = re.search(r"R-A.*?pass=(\d+)/(\d+)", t) or re.search(r"RA_fixture_results\.csv\s+pass=(\d+)/(\d+)", t); d["ra_fix_pass"] = m and f"{m[1]}/{m[2]}"
    m = re.search(r"fixtures pass (\d+)/(\d+) \| F03 observed=(\w+) expected=(\w+)", t); d["rb_fix_pass"] = m and f"{m[1]}/{m[2]}"; d["rb_F03"] = m and (m[3], m[4])
    m = re.search(r"F03\s+STANDARD\s+(\w+)\s+TRUE", t); d["ra_F03_observed_pass"] = bool(re.search(r"\bF03\s+STANDARD\s+STANDARD\s+TRUE", t))
    m = re.search(r"\n\s*1\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+2\s+RA-", t); d["ra_portfolio"] = m and dict(zip(["decision","ESC","INC","STD"], map(int, m.groups())))
    m = re.search(r"portfolio: decision=(\d+) ESCALATE=(\d+) INCONCLUSIVE=(\d+) STANDARD=(\d+)", t); d["rb_portfolio"] = m and dict(zip(["decision","ESC","INC","STD"], map(int, m.groups())))
    m = re.search(r"RECON_SUMMARY|\n\s*1\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s*\n", t); d["recon_in_log"] = m and (m.groups() if m.lastindex else None)
    d["exit_ra"] = re.findall(r"RA EXIT (\d+)", t); d["exit_rb"] = re.findall(r"RB EXIT (\d+)", t)
    return d
r1, r2 = ra_rb(t1), ra_rb(t2)
rs = list(csv.DictReader(open(E/"raw_evidence/RECON_SUMMARY.csv")))[0]
fixes = {}
for k, f in (("RA","r_a_fixture_results.csv"),("RB","r_b_fixture_results.csv")):
    rows = list(csv.DictReader(open(E/"raw_evidence"/f))); fixes[k] = {"n": len(rows), "all_pass": all(str(r.get("pass","")).upper()=="TRUE" for r in rows)}
    f3 = [r for r in rows if r.get("fixture_id","").upper().endswith("F03")]; fixes[k]["F03"] = [(r.get("expected"), r.get("observed")) for r in f3]
dis = len(list(csv.reader(open(E/"raw_evidence/RECON_DISAGREE_IDS.csv"))))-1
receipt = (E/"fixtures/FIXTURE_GATE_RECEIPT.md").read_text(); lock = re.search(r"locked_at:\*\*\s*([0-9\- :]+ CT)", receipt)
run1_start = re.search(r"=== RESTART (\S+) ===", t1)
facts = {
 "run1_pre_fix": r1, "rerun_post_fix": r2,
 "run1_ESC_delta_RB_minus_RA": (r1["rb_portfolio"]["ESC"]-r1["ra_portfolio"]["ESC"]) if r1["ra_portfolio"] and r1["rb_portfolio"] else None,
 "run1_STD_delta_RA_minus_RB": (r1["ra_portfolio"]["STD"]-r1["rb_portfolio"]["STD"]) if r1["ra_portfolio"] and r1["rb_portfolio"] else None,
 "post_fix_portfolios_equal": r2["ra_portfolio"] == r2["rb_portfolio"] and r2["ra_portfolio"] is not None,
 "recon_summary_csv": rs, "recon_disagree_ids_rows_post_fix": dis, "fixture_csvs": fixes,
 "fixture_gate_locked_at": lock and lock[1], "run1_started_at": run1_start and run1_start[1],
 "fixture_run_in_log_before_recon_flagged_defect": bool(r1["ra_fix_pass"] and r1["rb_fix_pass"]),
}
(R/"A02R_FACTS.json").write_text(json.dumps(facts, indent=2, default=str)+"\n")
checks = [
 ("R-A fixtures 14/14 in pre-fix run", r1["ra_fix_pass"] == "14/14"), ("R-B fixtures 14/14 in pre-fix run", r1["rb_fix_pass"] == "14/14"),
 ("R-A fixtures 14/14 in post-fix run", r2["ra_fix_pass"] == "14/14"), ("R-B fixtures 14/14 in post-fix run", r2["rb_fix_pass"] == "14/14"),
 ("F03 expected=observed=STANDARD (R-B, both runs)", r1["rb_F03"] == ("STANDARD","STANDARD") and r2["rb_F03"] == ("STANDARD","STANDARD")),
 ("F03 STANDARD/STANDARD TRUE (R-A table, both runs)", r1["ra_F03_observed_pass"] and r2["ra_F03_observed_pass"]),
 ("Pre-fix: ESC differs RB-RA = 104", facts["run1_ESC_delta_RB_minus_RA"] == 104), ("Pre-fix: STD differs RA-RB = 104", facts["run1_STD_delta_RA_minus_RB"] == 104),
 ("Pre-fix: INC equal 6377 and decision equal 222002", r1["ra_portfolio"] and r1["rb_portfolio"] and r1["ra_portfolio"]["INC"] == r1["rb_portfolio"]["INC"] == 6377 and r1["ra_portfolio"]["decision"] == r1["rb_portfolio"]["decision"] == 222002),
 ("Post-fix portfolios identical (131968/6377/83657)", facts["post_fix_portfolios_equal"] and r2["ra_portfolio"]["ESC"] == 131968 and r2["ra_portfolio"]["STD"] == 83657),
 ("Post-fix RECON_SUMMARY.csv: agree 222002, disagree 0, only_ra 0, only_rb 0", rs["n_agree"] == "222002" and rs["n_disagree"] == "0" and rs["n_only_ra"] == "0" and rs["n_only_rb"] == "0"),
 ("RECON_DISAGREE_IDS.csv has 0 data rows", dis == 0),
 ("All four R exits 0", r1["exit_ra"] == ["0"] and r1["exit_rb"] == ["0"] and r2["exit_ra"] == ["0"] and r2["exit_rb"] == ["0"]),
 ("Fixture CSVs 14 rows all pass", fixes["RA"]["n"] == 14 and fixes["RB"]["n"] == 14 and fixes["RA"]["all_pass"] and fixes["RB"]["all_pass"]),
 ("Fixture Gate lock time precedes first production run (2026-09-19 10:26:37 CT < 12:56:16 CT)", bool(lock) and lock[1].startswith("2026-09-19 10:26:37") and bool(run1_start) and run1_start[1].startswith("2026-09-19T12:56")),
]
facts["checks"] = [(n, bool(ok)) for n, ok in checks]; (R/"A02R_FACTS.json").write_text(json.dumps(facts, indent=2, default=str)+"\n")
md = ["# A02R mechanical facts (script-derived; no verdict)", "", "Source: `evidence/` files only. Script: `runner/a02r_facts.py`.", "", "| # | Check | Result |", "|---|-------|--------|"] + [f"| {i+1} | {n} | {'TRUE' if ok else 'FALSE'} |" for i, (n, ok) in enumerate(facts["checks"])]
md += ["", "## Extracted values", "```json", json.dumps({k: facts[k] for k in ("run1_pre_fix","rerun_post_fix","recon_summary_csv","fixture_csvs","fixture_gate_locked_at","run1_started_at")}, indent=2, default=str), "```", "",
 "Note: Fixture runs in both the pre-fix and post-fix logs are 14/14 PASS. The 104-row disagreement was therefore invisible to the Fixture Gate and visible to exact recon (portfolio ESC 131,968 vs 132,072)."]
(R/"A02R_FACTS.md").write_text("\n".join(md)+"\n"); print("\n".join(f"{'OK ' if ok else 'FAIL'} {n}" for n, ok in facts["checks"]))
