#!/usr/bin/env python3
"""N15 batch 2 (C14 C11 C34 C16 C18): build seeded code files from the frozen Chicago 311 code.
Every replacement must match exactly once, or the script aborts. Writes seeds/<CID>/..., seeds/<CID>/ARMS.tsv,
seeds/C34/STAGE45 (marker), stage45/ harness files, SEEDS_b2.sha256 and SEED_DIFFS_b2.txt. No source variants in b2."""
import hashlib, difflib, pathlib, sys, shutil
ROOT = pathlib.Path(__file__).resolve().parent
REPO = pathlib.Path("/workspace/chicago-311-dispatch-priority"); FROZEN = REPO/"R"
PCREF = pathlib.Path("/workspace/ablation_plan/_pcref")
sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
FROZEN_SHA = {FROZEN/"r-a/run_RA.R": "f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587",
              FROZEN/"r-b/R/00_config.R": "6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b",
              FROZEN/"r-b/R/20_integrity_and_classify.R": "72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99",
              FROZEN/"r-b/R/40_fixtures.R": "2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e",
              REPO/"docs/stage-05-interpretation/run_deeper_analysis.R": "ed8694277737989d301b9b1f7e6a06a2dbb87a2ad25254fd53b1db47d92c1ec2",
              PCREF/"build_validated_action_list.R": "c115c5bcd1883b56a466bacca8cb302b6eeed7c850541f7f6128dca4bf507542",
              REPO/"validation/workflow-gate/workflow_gate.R": "27a6e83c3ff2780aeb50c0a681d46b07590fe011ec45e6eb8bc87f28ca36c193"}
for p, h in FROZEN_SHA.items(): assert sha(p) == h, p
RA = (FROZEN/"r-a/run_RA.R").read_text(encoding="utf-8"); CFG = (FROZEN/"r-b/R/00_config.R").read_text(encoding="utf-8")
CLS = (FROZEN/"r-b/R/20_integrity_and_classify.R").read_text(encoding="utf-8"); FXB = (FROZEN/"r-b/R/40_fixtures.R").read_text(encoding="utf-8")
def mut(t, pairs):
    for old, new in pairs:
        n = t.count(old)
        if n != 1: sys.exit(f"target found {n} times: {old!r}")
        t = t.replace(old, new)
    return t
A, B, C, X = ("frozen/R-A/run_RA.R", RA, "R-A\\run_RA.R"), ("frozen/R-B/R/20_integrity_and_classify.R", CLS, "R-B\\R\\20_integrity_and_classify.R"), \
             ("frozen/R-B/R/00_config.R", CFG, "R-B\\R\\00_config.R"), ("frozen/R-B/R/40_fixtures.R", FXB, "R-B\\R\\40_fixtures.R")
RA_EXCL = "exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open"
RB_INDEC = "in_decision <- is_open & !dup_flag & !leg_flag"
RB_EXP = '''      "ESCALATE", "STANDARD", "STANDARD", "INCONCLUSIVE", "INCONCLUSIVE", "INCONCLUSIVE",
      "OUT_OF_SET", "OUT_OF_SET", "INCONCLUSIVE",'''
def rb_exp(i, new):  # rewrite the i-th (1-based, of the first 9) expected label in the R-B fixture vector
    v = ["ESCALATE", "STANDARD", "STANDARD", "INCONCLUSIVE", "INCONCLUSIVE", "INCONCLUSIVE", "OUT_OF_SET", "OUT_OF_SET", "INCONCLUSIVE"]; v[i-1] = new
    return [(RB_EXP, "      " + ", ".join(f'"{x}"' for x in v[:6]) + ",\n      " + ", ".join(f'"{x}"' for x in v[6:]) + ",  # [seed] F%02d expected rewritten to the observed label after a fixture failure" % i)]
S = {
 # ---- C14 alternative readings of unlocked terms ----
 "RA_SEM_DUPKEEP":  (A, [(RA_EXCL, "exclude <- is_true_like(leg) | !in_envelope_open"),
                         ('  check(is_blank(base$type_key), "blank_type_key")\n', '  check(is_true_like(dup), "duplicate_retained")  # [seed] duplicates kept, held INCONCLUSIVE\n  check(is_blank(base$type_key), "blank_type_key")\n')]),
 "RB_SEM_DUPKEEP":  (B, [(RB_INDEC, "in_decision <- is_open & !leg_flag"),
                         ('  integrity_clause[p_closed_contra] <- "I01_open_closed_date"\n', '  integrity_clause[dup_flag] <- "I00_duplicate_retained"  # [seed] duplicates kept, held INCONCLUSIVE\n  integrity_clause[p_closed_contra] <- "I01_open_closed_date"\n')]),
 "RA_SEM_NOPEER":   (A, [("  integrity_clause <- rep(NA_character_, nrow(base))\n", "  base$exclude <- base$exclude | base$peer_missing  # [seed] 'eligible' read as 'has peer statistics'\n  integrity_clause <- rep(NA_character_, nrow(base))\n")]),
 "RB_SEM_NOPEER":   (B, [(RB_INDEC, RB_INDEC + " & !is.na(peer_p75)  # [seed] 'eligible' read as 'has peer statistics'")]),
 "RA_SEM_LEGACYIN": (A, [(RA_EXCL, "exclude <- is_true_like(dup) | !in_envelope_open  # [seed] legacy records read as eligible")]),
 "RB_SEM_LEGACYIN": (B, [(RB_INDEC, "in_decision <- is_open & !dup_flag  # [seed] legacy records read as eligible")]),
 "RA_SEM_OPENEXACT":(A, [('in_envelope_open <- tolower(status) == "open"', 'in_envelope_open <- status == "Open"  # [seed] exact token, no case normalization')]),
 "RB_SEM_OPENEXACT":(B, [('is_open <- tolower(status_norm) == "open"', 'is_open <- as.character(joined$STATUS) == "Open"  # [seed] exact token, no trim/case normalization')]),
 # ---- C11 method constant silently retuned ----
 "RA_NMIN30":  (A, [("N_MIN <- 50L\n", "N_MIN <- 30L\n")]), "RB_NMIN30":  (C, [("RB_N_MIN <- 50L\n", "RB_N_MIN <- 30L\n")]),
 "RA_NMIN75":  (A, [("N_MIN <- 50L\n", "N_MIN <- 75L\n")]), "RB_NMIN75":  (C, [("RB_N_MIN <- 50L\n", "RB_N_MIN <- 75L\n")]),
 "RA_NMIN100": (A, [("N_MIN <- 50L\n", "N_MIN <- 100L\n")]), "RB_NMIN100": (C, [("RB_N_MIN <- 50L\n", "RB_N_MIN <- 100L\n")]),
 # ---- C16 rules omitted from the builder packet (both builders get the same packet) ----
 "RA_OM_LEGACY":    (A, [(RA_EXCL, "exclude <- is_true_like(dup) | !in_envelope_open  # [seed] LEGACY exclusion omitted from packet")]),
 "RB_OM_LEGACY":    (B, [(RB_INDEC, "in_decision <- is_open & !dup_flag  # [seed] LEGACY exclusion omitted from packet")]),
 "RA_OM_CLOCKS":    (A, [('  check(!is.na(base$created_ts) & !is.na(base$mod_ts) & base$mod_ts < base$created_ts, "inverted_clocks")\n', ""),
                         ('  check(!is.na(base$created_ts) & base$created_ts > t_freeze, "created_after_T")\n', "  # [seed] I02 clock-order and created>T clauses omitted from packet\n")]),
 "RB_OM_CLOCKS":    (B, [("p_bad_clock <- is.na(created_ts) | is.na(mod_ts) | (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |\n    (!is.na(created_ts) & created_ts > t_freeze)",
                          "p_bad_clock <- is.na(created_ts) | is.na(mod_ts)  # [seed] clock-order and created>T clauses omitted from packet")]),
 "RA_OM_BLANKTYPE": (A, [('  check(is_blank(base$type_key), "blank_type_key")\n', "  # [seed] blank type_key clause omitted from packet\n")]),
 "RB_OM_BLANKTYPE": (B, [("p_blank_type <- rb_is_blank(joined$type_key)", "p_blank_type <- rep(FALSE, n)  # [seed] blank type_key clause omitted from packet")]),
 "RA_OM_UNPARSE":   (A, [('  check(is.na(base$created_ts), "unparseable_created")\n', "  # [seed] unparseable CREATED_DATE clause omitted from packet\n")]),
 "RB_OM_UNPARSE":   (B, [("p_bad_clock <- is.na(created_ts) | is.na(mod_ts) |", "p_bad_clock <- is.na(mod_ts) |  # [seed] unparseable CREATED_DATE clause omitted from packet\n   ")]),
 # ---- C34 / C18 defects (same text as the b1 catalogue) ----
 "RA_NOTHIN":  (A, [('check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")', 'check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")')]),
 "RB_NOTHIN":  (B, [("p_thin <- peer_n < RB_N_MIN", "p_thin <- rep(FALSE, n)")]),
 "RA_NODUP":   (A, [(RA_EXCL, "exclude <- is_true_like(leg) | !in_envelope_open")]),
 "RB_NODUP":   (B, [(RB_INDEC, "in_decision <- is_open & !leg_flag")]),
 "RA_NOI01":   (A, [('  check(!is.na(base$closed_ts), "open_with_closed_date")\n', '  # [seed] I01 open+closed-date clause removed\n')]),
 "RB_NOI01":   (B, [("p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))", "p_closed_contra <- rep(FALSE, n)")]),
 "RB_K25":     (C, [("RB_KAPPA_DEFAULT <- 2.0\n", "RB_KAPPA_DEFAULT <- 2.5\n")]),
 "RA_ROUND1":  (A, [("    dormant_h = round(base$dormant_h, 6),\n", "    dormant_h = round(base$dormant_h, 1),  # [seed] reported dormant_h rounded to 0.1 h\n")]),
 "RB_CRASH":   (B, [("rb_judge_rows <- function(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE) {\n",
                     "rb_judge_rows <- function(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE) {\n  stop(\"[seed] simulated R-B Stage-4 failure\")\n")]),
 # ---- C18 fixture expectations rewritten to the observed label (defect + rewrite) ----
 "RA_NOTHIN_RW": (A, [('check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")', 'check(rep(FALSE, nrow(base)), "thin_type_or_missing_peer")'),
                      ('list(id = "F06", expected = "INCONCLUSIVE"', 'list(id = "F06", expected = "ESCALATE"  # [seed] rewritten to observed after fixture failure\n        ')]),
 "RA_NODUP_RW":  (A, [(RA_EXCL, "exclude <- is_true_like(leg) | !in_envelope_open"),
                      ('list(id = "F07", expected = "OUT_OF_SET", in_set = FALSE', 'list(id = "F07", expected = "ESCALATE", in_set = TRUE  # [seed] rewritten to observed after fixture failure\n        ')]),
 "RA_NOI01_RW":  (A, [('  check(!is.na(base$closed_ts), "open_with_closed_date")\n', '  # [seed] I01 open+closed-date clause removed\n'),
                      ('list(id = "F04", expected = "INCONCLUSIVE"', 'list(id = "F04", expected = "STANDARD"  # [seed] rewritten to observed after fixture failure\n        ')]),
 "RB_FX_F06_RW": (X, rb_exp(6, "ESCALATE")), "RB_FX_F07_RW": (X, rb_exp(7, "ESCALATE")), "RB_FX_F04_RW": (X, rb_exp(4, "STANDARD")),
}
FN = {"R-A\\run_RA.R": "run_RA.R", "R-B\\R\\20_integrity_and_classify.R": "20_integrity_and_classify.R", "R-B\\R\\00_config.R": "00_config.R", "R-B\\R\\40_fixtures.R": "40_fixtures.R"}
FZ = "FROZEN"
def arm(name, paths, seeds, desc): return (name, paths, seeds, FZ, FZ, desc)
ARMS = {
 "C14": [arm("SEM_DUPKEEP_RB", "RB", ["RB_SEM_DUPKEEP"], "R-B alone reads 'duplicate' as 'keep and hold INCONCLUSIVE' (the F07 alternative named in the design)"),
         arm("SEM_DUPKEEP_CM", "RA+RB", ["RA_SEM_DUPKEEP", "RB_SEM_DUPKEEP"], "Both paths read 'duplicate' as 'keep and hold INCONCLUSIVE'"),
         arm("SEM_NOPEER_RB", "RB", ["RB_SEM_NOPEER"], "R-B alone reads 'eligible' as 'has peer statistics' (rows with no peer stats excluded, not INCONCLUSIVE)"),
         arm("SEM_NOPEER_CM", "RA+RB", ["RA_SEM_NOPEER", "RB_SEM_NOPEER"], "Both paths read 'eligible' as 'has peer statistics'"),
         arm("SEM_LEGACYIN_CM", "RA+RB", ["RA_SEM_LEGACYIN", "RB_SEM_LEGACYIN"], "Both paths read LEGACY_RECORD rows as eligible (no legacy exclusion)"),
         arm("SEM_OPENEXACT_CM", "RA+RB", ["RA_SEM_OPENEXACT", "RB_SEM_OPENEXACT"], "Both paths read 'open' as the exact token STATUS == \"Open\" (no case/space normalization)")],
 "C11": [arm("K_NMIN30_CM", "RA+RB", ["RA_NMIN30", "RB_NMIN30"], "Method constant n_min retuned 50 -> 30 on both paths (treated as a knob)"),
         arm("K_NMIN75_CM", "RA+RB", ["RA_NMIN75", "RB_NMIN75"], "Method constant n_min retuned 50 -> 75 on both paths"),
         arm("K_NMIN100_CM", "RA+RB", ["RA_NMIN100", "RB_NMIN100"], "Method constant n_min retuned 50 -> 100 on both paths"),
         arm("K_NMIN30_RB", "RB", ["RB_NMIN30"], "Method constant n_min retuned 50 -> 30 on R-B only")],
 "C34": [arm("W_RA_NOTHIN", "RA+RB", ["RA_NOTHIN"], "Stage-4 failure: R-A drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs"),
         arm("W_RB_NOTHIN", "RA+RB", ["RB_NOTHIN"], "Stage-4 failure: R-B drops the I04 thin-peer clause (fixture F06 and recon fail); Stage 5 then runs"),
         arm("W_RB_K25", "RA+RB", ["RB_K25"], "Stage-4 failure: R-B production kappa 2.5 (recon fails); Stage 5 then runs"),
         arm("W_RB_CRASH", "RA+RB", ["RB_CRASH"], "Stage-4 failure: R-B exits non-zero with no outputs; Stage 5 then runs"),
         arm("W_RA_ROUND1", "RA+RB", ["RA_ROUND1"], "R-A reports dormant_h rounded to 0.1 h (labels unchanged; the frozen key+label recon passes); Stage 5 then runs")],
 "C16": [arm("OM_LEGACY_CM", "RA+RB", ["RA_OM_LEGACY", "RB_OM_LEGACY"], "LEGACY exclusion omitted from the builder packet: both paths lack it"),
         arm("OM_LEGACY_RB", "RB", ["RB_OM_LEGACY"], "LEGACY exclusion omitted from R-B's packet only"),
         arm("OM_CLOCKS_CM", "RA+RB", ["RA_OM_CLOCKS", "RB_OM_CLOCKS"], "Clock-order (mod < created) and created > T clauses omitted: both paths lack them"),
         arm("OM_BLANKTYPE_CM", "RA+RB", ["RA_OM_BLANKTYPE", "RB_OM_BLANKTYPE"], "Blank type_key clause omitted: both paths lack it"),
         arm("OM_UNPARSE_CM", "RA+RB", ["RA_OM_UNPARSE", "RB_OM_UNPARSE"], "Unparseable CREATED_DATE clause omitted: both paths lack it")],
 "C18": [arm("FX_CM_NOTHIN", "RA+RB", ["RA_NOTHIN", "RB_NOTHIN"], "Both paths drop the I04 thin-peer clause; fixtures as frozen (no rewrite)"),
         arm("RW_CM_NOTHIN", "RA+RB", ["RA_NOTHIN_RW", "RB_NOTHIN", "RB_FX_F06_RW"], "Same defect; F06 expected rewritten to the observed label on both paths"),
         arm("FX_CM_NODUP", "RA+RB", ["RA_NODUP", "RB_NODUP"], "Both paths drop the DUPLICATE exclusion; fixtures as frozen"),
         arm("RW_CM_NODUP", "RA+RB", ["RA_NODUP_RW", "RB_NODUP", "RB_FX_F07_RW"], "Same defect; F07 expected rewritten to the observed label on both paths"),
         arm("FX_CM_NOI01", "RA+RB", ["RA_NOI01", "RB_NOI01"], "Both paths drop the I01 open+closed-date clause; fixtures as frozen"),
         arm("RW_CM_NOI01", "RA+RB", ["RA_NOI01_RW", "RB_NOI01", "RB_FX_F04_RW"], "Same defect; F04 expected rewritten to the observed label on both paths"),
         arm("FX_RB_NOTHIN", "RB", ["RB_NOTHIN"], "R-B alone drops the I04 thin-peer clause; fixtures as frozen"),
         arm("RW_RB_NOTHIN", "RB", ["RB_NOTHIN", "RB_FX_F06_RW"], "Same R-B defect; R-B's F06 expected rewritten to the observed label")],
}
out = ROOT/"seeds"; diffs = []; shalines = []
for cid in ARMS: shutil.rmtree(out/cid, ignore_errors=True)
def emit_seed(cid, name):
    (lab, base, dest), pairs = S[name]
    text = mut(base, pairs); rel = f"seeds/{cid}/{name}__{FN[dest]}"
    p = ROOT/rel; p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(text.encode("utf-8"))
    diffs.append("".join(difflib.unified_diff(base.splitlines(True), text.splitlines(True), lab, rel)))
    return rel, dest
for cid, arms in ARMS.items():
    rows = ["arm\tpaths\tcode_seeds\tra_source\trb_source\tdescription"]; done = {}
    for a, paths, seeds, ras, rbs, desc in arms:
        specs = []
        dests = [S[s][0][2] for s in seeds]
        if len(dests) != len(set(dests)): sys.exit(f"{cid} {a}: two seeds for one destination")
        for s in seeds:
            if s not in done: done[s] = emit_seed(cid, s)
            rel, dest = done[s]; specs.append(f"{rel}>{dest}")
        rows.append("\t".join([a, paths, ";".join(specs) or "-", ras, rbs, desc]))
    (out/cid).mkdir(parents=True, exist_ok=True); (out/cid/"ARMS.tsv").write_text("\n".join(rows) + "\n", encoding="utf-8")
(out/"C34"/"STAGE45").write_text("Stage-4 receipt + workflow gate + Stage-5 deeper analysis run after each arm (runner v2)\n", encoding="utf-8")
# ---- stage45 harness: path-only substitutions of frozen Stage-4/5 scripts + frozen receipts ----
H = ROOT/"stage45"; shutil.rmtree(H, ignore_errors=True); H.mkdir()
WIN = "C:/Users/Mark/Documents/R Working Directory/chicago311"
bv = (PCREF/"build_validated_action_list.R").read_text(encoding="utf-8")
bv2 = mut(bv, [(f'read_csv("{WIN}/R-A/outputs/RA_classifications.csv"', 'read_csv(file.path(Sys.getenv("CHICAGO311_ROOT"), "R-A/outputs/RA_classifications.csv")'),
               (f'write_csv(esc, "{WIN}/outputs/validated_action_list.csv")', 'dir.create(file.path(Sys.getenv("CHICAGO311_ROOT"), "outputs"), showWarnings = FALSE)\nwrite_csv(esc, file.path(Sys.getenv("CHICAGO311_ROOT"), "outputs/validated_action_list.csv"))')])
dp = (REPO/"docs/stage-05-interpretation/run_deeper_analysis.R").read_text(encoding="utf-8")
dp2 = mut(dp, [(f'root <- "{WIN}"', 'root <- Sys.getenv("CHICAGO311_ROOT")  # [harness] path only')])
for name, base, text, lab in (("build_validated_action_list.R", bv, bv2, "frozen/outputs/build_validated_action_list.R"), ("run_deeper_analysis.R", dp, dp2, "frozen/stage-05/run_deeper_analysis.R")):
    (H/name).write_bytes(text.encode("utf-8")); diffs.append("".join(difflib.unified_diff(base.splitlines(True), text.splitlines(True), lab, f"stage45/{name}")))
shutil.copy(REPO/"validation/workflow-gate/workflow_gate.R", H/"workflow_gate.R")
for f in ("docs/stage-01-02-start-framing/stage1_decision.json", "docs/stage-01-02-start-framing/stage2_framing.json", "docs/stage-03-measurement-design/stage3_locked_design.json"):
    shutil.copy(REPO/f, H/pathlib.Path(f).name)
shutil.copy(ROOT/"stage45_receipt.R", H/"stage45_receipt.R")
for p in sorted(out.rglob("*")):
    if p.is_file() and p.parts[-2] in ARMS: shalines.append(f"{sha(p)}  {p.relative_to(ROOT).as_posix()}")
for p in sorted(H.iterdir()): shalines.append(f"{sha(p)}  {p.relative_to(ROOT).as_posix()}")
(ROOT/"SEEDS_b2.sha256").write_text("\n".join(shalines) + "\n", encoding="utf-8")
(ROOT/"SEED_DIFFS_b2.txt").write_text("".join(diffs), encoding="utf-8")
print(len(shalines), "hashed;", len(diffs), "seed diffs")
