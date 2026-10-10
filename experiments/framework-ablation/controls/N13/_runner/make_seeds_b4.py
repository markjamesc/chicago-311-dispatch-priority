#!/usr/bin/env python3
"""N13 batch b4 (C51 smoke run, C46 numerical determinism, C52 concurrent Source Gate queries): build every seed / harness file
from frozen code and frozen SQL. Every text replacement must match exactly once, or the script aborts.
Writes seeds/<CID>/..., seeds/<CID>/ARMS.tsv + mode marker, SEEDS_b4.sha256 and SEED_DIFFS_b4.txt."""
import hashlib, difflib, pathlib, re, sys, shutil
ROOT = pathlib.Path(__file__).resolve().parent; REPO = pathlib.Path("/workspace/chicago-311-dispatch-priority")
sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
FROZEN = {REPO/"R/r-b/run_RB.R": "6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd",
          REPO/"sql/01_source_extract.sql": "f365e84a7e5d95f39a5fc19133d068e53a3aa5898f619e39db4dc6e0ba3a57b5",
          REPO/"sql/02_source_gate_checks.sql": "ae26edb6af074a1a61e92d241fffef0730c893fef0c8c7ae6929d3f2d50aef59"}
for p, h in FROZEN.items(): assert sha(p) == h, p
RB = (REPO/"R/r-b/run_RB.R").read_text(encoding="utf-8")
def mut(t, pairs):
    for old, new in pairs:
        n = t.count(old)
        if n != 1: sys.exit(f"target found {n} times: {old!r}")
        t = t.replace(old, new)
    return t
S = ROOT/"seeds"; diffs = []
def put(rel, text, frozen_label=None, frozen_text=None):
    p = S/rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(text.encode("utf-8"))
    if frozen_text is not None:
        diffs.append("".join(difflib.unified_diff(frozen_text.splitlines(True), text.splitlines(True), fromfile=frozen_label, tofile=f"seeds/{rel}")))
    else:
        diffs.append(f"### seeds/{rel} (new file, {len(text.encode())} bytes)\n" + text + ("" if text.endswith("\n") else "\n"))
# ---------------- C51: R-B code seeds modelled on PricePoint R-B r2/r3/r4 + one subset-bias probe ----------------
LOAD = '  open_df <- rb_normalize_open(open_raw)\n'
C51 = {
 "SM_QUADLOOP": [(LOAD, LOAD + '  # [seed C51 SM_QUADLOOP] per-row same-type count via a full-frame subset each row: O(n^2) (PricePoint R-B r2 pattern)\n'
                  '  same_type_n <- vapply(seq_len(nrow(open_df)), function(i) nrow(open_df[open_df$type_key %in% open_df$type_key[i], , drop = FALSE]), integer(1))\n'
                  '  message("[R-B] same_type_n computed for ", length(same_type_n), " rows")\n')],
 "SM_MIDCRASH": [('    "dormant_h", "open_age_h", "peer_n", "peer_p75_h", "peer_p50_h",\n',
                  '    ".dormant_h", "open_age_h", "peer_n", "peer_p75_h", "peer_p50_h",  # [seed C51 SM_MIDCRASH] renamed column consumed mid-pipeline (PricePoint R-B r3 pattern)\n')],
 "SM_OUTCRASH":  [('  write_csv_rb(grid_out, file.path(paths$out_dir, "RB_kappa_grid_counts.csv"))\n',
                  '  write_csv_rb(grid_out_final, file.path(paths$out_dir, "RB_kappa_grid_counts.csv"))  # [seed C51 SM_OUTCRASH] object not found at output writing (PricePoint R-B r4 pattern)\n')],
 "SM_RARECRASH": [('  peer_raw <- rb_read_csv_flex(paths$peer_csv)\n',
                  '  peer_raw <- rb_read_csv_flex(paths$peer_csv)\n  # [seed C51 SM_RARECRASH] unhandled rare value: SR_SHORT_CODE ODM (6 rows in the frozen extract, none in the smoke subsets)\n'
                  '  if (any(open_raw$SR_SHORT_CODE %in% "ODM")) stop("unhandled SR_SHORT_CODE ODM in normalization", call. = FALSE)\n')]}
DESC51 = {"SM_QUADLOOP": "R-B adds an O(n^2) per-row full-frame subset loop after loading (PricePoint R-B r2: O(n^2) per-row loop, full run stopped at 43 min)",
          "SM_MIDCRASH": "R-B selects a renamed column '.dormant_h' when writing classifications, after judging (PricePoint R-B r3: renamed column, EXIT 1 at step 10)",
          "SM_OUTCRASH": "R-B writes an undefined object at the last output (kappa grid) (PricePoint R-B r4: object not found at output writing)",
          "SM_RARECRASH": "R-B stops on a rare SR_SHORT_CODE (ODM, 6 rows, none in the 1/4 or 1/16 smoke subsets): subset-bias probe"}
rows = ["arm\tpaths\tcode_seeds\tdesc"]
for arm, pairs in C51.items():
    rel = f"C51/RB_{arm}__run_RB.R"; put(rel, mut(RB, pairs), "frozen/R-B/run_RB.R", RB)
    rows.append(f"{arm}\tRB\tseeds/{rel}>R-B\\run_RB.R\t{DESC51[arm]}")
put("C51/ARMS.tsv", "\n".join(rows) + "\n"); put("C51/SMOKE", "C51 smoke-run arms (runner v4)\n")
# ---------------- C46: seeded iterative fit, arms = (RA order, RB order, thresh, RB drop, regime) ----------------
for f in ("fit_path.R", "recon_c46.R"): put(f"C46/{f}", (ROOT/"src"/f).read_text(encoding="utf-8"))
A46 = [("BASE", "natural", "reversed", "1e-7", "-", "baseline", "baseline regime: no determinism declarations; glmnet default thresh 1e-7; paths use different column orders; baseline comparator"),
       ("DECL", "canonical", "canonical", "1e-12", "-", "declared", "declared regime: thresh 1e-12, canonical column order, tie rule p>=0.5, rounding-derived reconciliation rule"),
       ("THRESH_ONLY", "natural", "reversed", "1e-12", "-", "baseline", "attribution probe: tight thresh only (orders differ, baseline comparator)"),
       ("ORDER_ONLY", "canonical", "canonical", "1e-7", "-", "baseline", "attribution probe: canonical order only (default thresh, baseline comparator)"),
       ("DEFECT_DECL", "canonical", "canonical", "1e-12", "x_log_peer_p75", "declared", "real defect under the declared regime: R-B omits feature x_log_peer_p75 (must still fail recon)"),
       ("DEFECT_BASE", "natural", "reversed", "1e-7", "x_log_peer_p75", "baseline", "same real defect under the baseline regime")]
put("C46/ARMS.tsv", "arm\tra_order\trb_order\tthresh\trb_drop\tregime\tdesc\n" + "".join("\t".join(a) + "\n" for a in A46)); put("C46/DETFIT", "C46 seeded-fit arms (runner v4); REF = canonical order, thresh 1e-14, single path\n")
# ---------------- C52: read-only SQL derived mechanically from the frozen 01/02 scripts ----------------
X = (REPO/"sql/01_source_extract.sql").read_text(encoding="utf-8"); G = (REPO/"sql/02_source_gate_checks.sql").read_text(encoding="utf-8")
def body(t, start):   # statement text after `start` up to the first ';' outside single-quoted strings and '--' comments
    assert t.count(start) == 1, start
    i = t.index(start) + len(start); q = False; j = i
    while j < len(t):
        if not q and t.startswith("--", j): j = t.index("\n", j); continue   # skip '-- ...' comments (they may contain ';')
        if t[j] == "'": q = not q
        elif t[j] == ";" and not q: return t[i:j].strip("\n")
        j += 1
    raise SystemExit("no terminator: " + start)
PRE = ("USE chicago311;\nSET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';\n"
       "SET @T_freeze = CAST('2026-09-12 23:59:59' AS DATETIME);\nSET @T_lookback_start = DATE_SUB(@T_freeze, INTERVAL 365 DAY);\n")
for s in ("SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';", "SET @T_freeze = CAST('2026-09-12 23:59:59' AS DATETIME);",
          "SET @T_lookback_start = DATE_SUB(@T_freeze, INTERVAL 365 DAY);"): assert X.count(s) == 1, s
E1 = ("-- N13 C52 E1: read-only form of frozen 01_source_extract.sql Envelope A (the SELECT of CREATE TABLE src_open_candidates AS ...),\n"
      "-- streamed to a file instead of creating a table; ORDER BY SR_NUMBER = the frozen table's primary-key order. No DDL, no writes.\n"
      + PRE + body(X, "CREATE TABLE src_open_candidates AS\n") + "\nORDER BY r.SR_NUMBER;\n")
stage = body(X, "CREATE TABLE src_peer_cycle_stage AS\n"); ranked = body(X, "CREATE TABLE src_peer_ranked AS\n"); stats = body(X, "CREATE TABLE src_peer_stats AS\n")
assert ranked.count("FROM src_peer_cycle_stage") == 1 and stats.count("FROM src_peer_ranked") == 1
E2 = ("-- N13 C52 E2: read-only form of frozen 01_source_extract.sql Envelope B (src_peer_cycle_stage -> src_peer_ranked -> src_peer_stats)\n"
      "-- as one statement with CTEs instead of staging tables; ORDER BY type_key = the frozen table's primary-key order. No DDL, no writes.\n"
      + PRE + "WITH stage AS (\n" + stage + "\n), ranked AS (\n" + ranked.replace("FROM src_peer_cycle_stage", "FROM stage") + "\n)\n"
      + stats.replace("FROM src_peer_ranked", "FROM ranked") + "\nORDER BY type_key;\n")
g = G.split("-- Emit results")[0]; g = g[g.index("-- A. Open count extract vs raw"):]
n_ins = g.count("INSERT INTO src_gate_results"); g2 = re.sub(r"INSERT INTO src_gate_results \([^)]*\)\n", "", g)
assert n_ins == 17 and not re.search(r"\b(INSERT|CREATE|DROP)\b", g2), n_ins
GQ = ("-- N13 C52 G: read-only form of frozen 02_source_gate_checks.sql. Each 'INSERT INTO src_gate_results (...) SELECT ...' is run as its SELECT\n"
      "-- (17 result rows, same order as the frozen script); the results table DDL and the final emit/overall SELECTs are dropped (overall computed by the evaluator).\n"
      "-- Reads raw_311_requests and the frozen extract tables src_open_candidates / src_peer_stats / src_extract_lineage. No DDL, no writes.\n"
      "USE chicago311;\n" + g2.strip("\n") + "\n")
CK = "-- N13 C52 checksum bracket (read-only)\nCHECKSUM TABLE chicago311.raw_311_requests, chicago311.src_open_candidates, chicago311.src_peer_stats, chicago311.src_extract_lineage;\n"
for n, t in (("E1.sql", E1), ("E2.sql", E2), ("G.sql", GQ), ("CK.sql", CK)):
    for bad in (r"\bINSERT\b", r"\bCREATE\b", r"\bDROP\b", r"\bALTER\b", r"\bUPDATE\b", r"\bDELETE\b"):
        assert not re.search(bad, re.sub(r"(?m)^--.*$", "", t)), (n, bad)
    put(f"C52/{n}", t)
put("C52/ARMS.tsv", "arm\tmode\tdesc\nSER_1\tSER\textract chain (E1, E2) then gate chain (G), one after the other\nPAR_1\tPAR\textract chain and gate chain launched concurrently\n"
    "SER_2\tSER\textract chain then gate chain\nPAR_2\tPAR\textract chain and gate chain launched concurrently\n")
put("C52/SQLCONC", "C52 serial-vs-concurrent SQL arms (runner v4)\n")
for f in ("make_subset.R",): put(f"common/{f}", (ROOT/"src"/f).read_text(encoding="utf-8"))
(ROOT/"SEED_DIFFS_b4.txt").write_text("\n".join(diffs), encoding="utf-8")
files = sorted(p for p in S.rglob("*") if p.is_file())
extra = [ROOT/"run_batch_v4.ps1", ROOT/"eval_b4.R"]
(ROOT/"SEEDS_b4.sha256").write_text("".join(f"{sha(p)}  {p.relative_to(ROOT).as_posix()}\n" for p in files + [e for e in extra if e.exists()]), encoding="utf-8")
print(len(files), "seed files;", sum(1 for e in extra if e.exists()), "runner files hashed")
