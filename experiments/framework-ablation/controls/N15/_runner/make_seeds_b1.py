#!/usr/bin/env python3
"""N15 batch 1 (C26 C31 C39 C30 C29): build seeded code files from the frozen Chicago 311 code.
Every replacement must match exactly once, or the script aborts. Writes seeds/<CID>/..., seeds/<CID>/ARMS.tsv,
SEEDS_b1.sha256 and SEED_DIFFS_b1.txt. Source-data variants are not built here: runner/source_variants.R builds them
on the PC from the frozen source, deterministically."""
import hashlib, difflib, pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parent
FROZEN = pathlib.Path("/workspace/chicago-311-dispatch-priority/R")
FROZEN_SHA = {"r-a/run_RA.R": "f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587",
              "r-b/R/00_config.R": "6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b",
              "r-b/R/20_integrity_and_classify.R": "72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99"}
sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
for rel, h in FROZEN_SHA.items(): assert sha(FROZEN/rel) == h, rel
RA = (FROZEN/"r-a/run_RA.R").read_text(encoding="utf-8")
CFG = (FROZEN/"r-b/R/00_config.R").read_text(encoding="utf-8")
CLS = (FROZEN/"r-b/R/20_integrity_and_classify.R").read_text(encoding="utf-8")
def mut(t, pairs):
    for old, new in pairs:
        n = t.count(old)
        if n != 1: sys.exit(f"target found {n} times: {old!r}")
        t = t.replace(old, new)
    return t
# ---- seed catalogue: name -> (base file label, base text, replacement pairs, dest path in arm) ----
S = {
 "RA_GT":       ("frozen/R-A/run_RA.R", RA, [("(base$dormant_h[remain] >= thr)", "(base$dormant_h[remain] > thr)")], "R-A\\run_RA.R"),
 "RA_NODUP":    ("frozen/R-A/run_RA.R", RA, [("exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open", "exclude <- is_true_like(leg) | !in_envelope_open")], "R-A\\run_RA.R"),
 "RA_NOPARENT": ("frozen/R-A/run_RA.R", RA, [('  check(base$parent_nonblank, "orphan_parent_nonblank")\n', '  # [seed] I05 parent clause removed\n')], "R-A\\run_RA.R"),
 "RA_NOTHIN":   ("frozen/R-A/run_RA.R", RA, [('check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")', 'check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")')], "R-A\\run_RA.R"),
 "RA_NOI01":    ("frozen/R-A/run_RA.R", RA, [('  check(!is.na(base$closed_ts), "open_with_closed_date")\n', '  # [seed] I01 open+closed-date clause removed\n')], "R-A\\run_RA.R"),
 "RA_TF24":     ("frozen/R-A/run_RA.R", RA, [('T_FREEZE <- lubridate::ymd_hms("2026-09-12 23:59:59", tz = "America/Chicago")', 'T_FREEZE <- lubridate::ymd_hms("2026-09-13 23:59:59", tz = "America/Chicago")')], "R-A\\run_RA.R"),
 "RA_K25":      ("frozen/R-A/run_RA.R", RA, [("KAPPA <- 2.0\n", "KAPPA <- 2.5\n")], "R-A\\run_RA.R"),
 "RA_COMMENT":  ("frozen/R-A/run_RA.R", RA, [("#!/usr/bin/env Rscript\n", "#!/usr/bin/env Rscript\n# lineage test: comment-only edit, no semantic change\n")], "R-A\\run_RA.R"),
 "RB_GT":       ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("(dormant_h >= thresh)", "(dormant_h > thresh)")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_NODUP":    ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("in_decision <- is_open & !dup_flag & !leg_flag", "in_decision <- is_open & !leg_flag")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_NOPARENT": ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("p_parent <- parent_nonblank", "p_parent <- rep(FALSE, n)")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_NOTHIN":   ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("p_thin <- peer_n < RB_N_MIN", "p_thin <- rep(FALSE, n)")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_NOI01":    ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))", "p_closed_contra <- rep(FALSE, n)")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_ROUND1":   ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("    dormant_h = dormant_h,\n    open_age_h = open_age_h,\n", "    dormant_h = round(dormant_h, 1),\n    open_age_h = open_age_h,\n")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_OPENAGE":  ("frozen/R-B/R/20_integrity_and_classify.R", CLS, [("open_age_h[has_created] <- rb_hours_diff(t_freeze, created_ts[has_created])", "open_age_h[has_mod] <- rb_hours_diff(t_freeze, mod_ts[has_mod])")], "R-B\\R\\20_integrity_and_classify.R"),
 "RB_TF24":     ("frozen/R-B/R/00_config.R", CFG, [('RB_T_FREEZE <- as.POSIXct("2026-09-12 23:59:59", tz = "America/Chicago")', 'RB_T_FREEZE <- as.POSIXct("2026-09-13 23:59:59", tz = "America/Chicago")')], "R-B\\R\\00_config.R"),
 "RB_K25":      ("frozen/R-B/R/00_config.R", CFG, [("RB_KAPPA_DEFAULT <- 2.0\n", "RB_KAPPA_DEFAULT <- 2.5\n")], "R-B\\R\\00_config.R"),
 "RB_COMMENT":  ("frozen/R-B/R/00_config.R", CFG, [("# R-B config", "# lineage test: comment-only edit, no semantic change\n# R-B config")], "R-B\\R\\00_config.R"),
}
FN = {"R-A\\run_RA.R": "run_RA.R", "R-B\\R\\20_integrity_and_classify.R": "20_integrity_and_classify.R", "R-B\\R\\00_config.R": "00_config.R"}
# ---- arms: control -> list of (arm, paths, code seeds, RA source variant, RB source variant, description) ----
FZ = "FROZEN"
ARMS = {
 "C26": [("S_STALE24", "RB", [], FZ, "V_STALE24", "R-B reads a stale snapshot: rows with created_ts >= 2026-09-11 23:59:59 removed"),
         ("S_PEER10", "RB", [], FZ, "V_PEER10", "R-B reads peer stats with peer_p75_h of the most frequent open type_key x1.10"),
         ("S_ONEROW", "RB", [], FZ, "V_ONEROW", "R-B source: one in-set row's mod_ts/LAST_MODIFIED_DATE moved 30 days earlier"),
         ("S_LF", "RB", [], FZ, "V_LF", "R-B source re-saved with LF line endings (bytes differ, content identical)"),
         ("S_REVERSE", "RB", [], FZ, "V_REVERSE", "R-B source with data rows in reverse order (bytes differ, same rows)"),
         ("S_BOOLCASE", "RB", [], FZ, "V_BOOLCASE", "R-B source with DUPLICATE/LEGACY_RECORD true/false written as TRUE/FALSE")],
 "C31": [("L_STALE24", "RA+RB", [], "V_STALE24", "V_STALE24", "Both paths read the stale snapshot (undocumented snapshot change)"),
         ("L_PEER10", "RA+RB", [], "V_PEER10", "V_PEER10", "Both paths read the altered peer stats (undocumented)"),
         ("L_TF24", "RA+RB", ["RA_TF24", "RB_TF24"], FZ, FZ, "Both paths' T_freeze moved +24 h (undocumented config change)"),
         ("L_K25", "RA+RB", ["RA_K25", "RB_K25"], FZ, FZ, "Both paths' kappa 2.0 -> 2.5 (undocumented knob change)"),
         ("L_COMMENT", "RA+RB", ["RA_COMMENT", "RB_COMMENT"], FZ, FZ, "Comment-only edit in both paths (bytes differ, no semantic change)")],
 "C39": [("R_ROUND1", "RB", ["RB_ROUND1"], FZ, FZ, "R-B reports dormant_h rounded to 0.1 h (labels computed before rounding)"),
         ("R_OPENAGE", "RB", ["RB_OPENAGE"], FZ, FZ, "R-B reports open_age_h from mod_ts instead of created_ts (not a decision input)"),
         ("R_GT", "RB", ["RB_GT"], FZ, FZ, "R-B kappa threshold uses > instead of >= (boundary rows only)"),
         ("R_NOTHIN", "RB", ["RB_NOTHIN"], FZ, FZ, "R-B I04 thin-peer integrity clause removed (decision defect)")],
 "C30": [("CM_GT", "RA+RB", ["RA_GT", "RB_GT"], FZ, FZ, "Common-mode: both paths use > instead of >= at the kappa threshold"),
         ("CM_NODUP", "RA+RB", ["RA_NODUP", "RB_NODUP"], FZ, FZ, "Common-mode: both paths drop the DUPLICATE exclusion"),
         ("CM_NOPARENT", "RA+RB", ["RA_NOPARENT", "RB_NOPARENT"], FZ, FZ, "Common-mode: both paths drop the I05 parent clause"),
         ("CM_NOTHIN", "RA+RB", ["RA_NOTHIN", "RB_NOTHIN"], FZ, FZ, "Common-mode: both paths drop the I04 thin-peer clause"),
         ("CM_NOI01", "RA+RB", ["RA_NOI01", "RB_NOI01"], FZ, FZ, "Common-mode: both paths drop the I01 open+closed-date clause")],
 "C29": [("X_RB_NODUP", "RB", ["RB_NODUP"], FZ, FZ, "Mismatch from an R-B defect: DUPLICATE exclusion dropped (extra R-B keys)"),
         ("X_RA_NODUP", "RA", ["RA_NODUP"], FZ, FZ, "Mismatch from an R-A defect: DUPLICATE exclusion dropped (extra R-A keys)"),
         ("X_RB_NOTHIN", "RB", ["RB_NOTHIN"], FZ, FZ, "Mismatch from an R-B defect: I04 thin-peer clause dropped (label disagreements)"),
         ("X_RA_NOTHIN", "RA", ["RA_NOTHIN"], FZ, FZ, "Mismatch from an R-A defect: I04 thin-peer clause dropped (label disagreements)")],
}
out = ROOT/"seeds"; diffs = []; shalines = []
def emit_seed(cid, name):
    lab, base, pairs, dest = S[name]
    text = mut(base, pairs)
    rel = f"seeds/{cid}/{name}__{FN[dest]}"
    p = ROOT/rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(text.encode("utf-8"))
    diffs.append("".join(difflib.unified_diff(base.splitlines(True), text.splitlines(True), lab, rel)))
    return rel, dest
for cid, arms in ARMS.items():
    rows = ["arm\tpaths\tcode_seeds\tra_source\trb_source\tdescription"]
    done = {}
    for arm, paths, seeds, ras, rbs, desc in arms:
        specs = []
        for s in seeds:
            if s not in done: done[s] = emit_seed(cid, s)
            rel, dest = done[s]; specs.append(f"{rel}>{dest}")
        rows.append("\t".join([arm, paths, ";".join(specs) or "-", ras, rbs, desc]))
    (out/cid).mkdir(parents=True, exist_ok=True)
    (out/cid/"ARMS.tsv").write_text("\n".join(rows) + "\n", encoding="utf-8")
for p in sorted((out).rglob("*")):
    if p.is_file() and p.parts[-2] in ARMS: shalines.append(f"{sha(p)}  {p.relative_to(ROOT).as_posix()}")
shalines.append(f"{sha(ROOT/'source_variants.R')}  source_variants.R")
(ROOT/"SEEDS_b1.sha256").write_text("\n".join(shalines) + "\n", encoding="utf-8")
(ROOT/"SEED_DIFFS_b1.txt").write_text("".join(diffs), encoding="utf-8")
print(len(shalines), "hashed;", len(diffs), "seed diffs")
