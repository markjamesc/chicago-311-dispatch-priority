#!/usr/bin/env python3
"""Deterministically build seeded files for C33 and C27 from the frozen Chicago 311 code.
Every replacement must match exactly once; otherwise abort. Writes seeds/, SEEDS.sha256, SEED_DIFFS.txt."""
import hashlib, difflib, pathlib, shutil, sys
ROOT = pathlib.Path(__file__).resolve().parent
FROZEN = pathlib.Path("/workspace/chicago-311-dispatch-priority/R")
PREFIX_RB = pathlib.Path("/workspace/ablation_plan/_pcref/pcb/R-B/R/10_io_parse.R")  # from PC R-B_bundle.tgz (12:56 CT 2026-09-19, the run that gave 104 disagrees)
FROZEN_SHA = {
 "r-a/run_RA.R": "f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587",
 "r-b/R/10_io_parse.R": "40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a",
 "r-b/R/20_integrity_and_classify.R": "72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99",
}
def sha(p): return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
for rel, h in FROZEN_SHA.items():
    assert sha(FROZEN/rel) == h, f"frozen hash mismatch {rel}"
assert sha(PREFIX_RB) == "8df344f5480c0a8ab36e08e05830d6cddd5851143811e28c3c968de59f0c4866"

def mutate(src_text, pairs):
    t = src_text
    for old, new in pairs:
        n = t.count(old)
        if n != 1: sys.exit(f"replacement target found {n} times: {old!r}")
        t = t.replace(old, new)
    return t

seeds = ROOT/"seeds"
diffs = []
def emit(relout, text, base_text, base_label):
    out = seeds/relout
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(text.encode("utf-8"))
    d = difflib.unified_diff(base_text.splitlines(True), text.splitlines(True), base_label, "seeds/"+relout)
    diffs.append("".join(d))

# ---- C33 ----
# X1: historical pre-contract R-B parser (verbatim from PC bundle), no edit.
pre = PREFIX_RB.read_text(encoding="utf-8")
frozen_io = (FROZEN/"r-b/R/10_io_parse.R").read_text(encoding="utf-8")
emit("C33/X_RB_10_io_parse.R", pre, frozen_io, "frozen/R-B/R/10_io_parse.R")
# X2: R-A without the clock contract, seeded with the same readr-POSIXct shortcut R-B used pre-contract.
ra = (FROZEN/"r-a/run_RA.R").read_text(encoding="utf-8")
ra_x = mutate(ra, [
 ("""clock_col_types <- readr::cols(
  created_ts = readr::col_character(),
  mod_ts = readr::col_character(),
  closed_ts = readr::col_character(),
  CREATED_DATE = readr::col_character(),
  LAST_MODIFIED_DATE = readr::col_character(),
  CLOSED_DATE = readr::col_character(),
  .default = readr::col_guess()
)""", """clock_col_types <- readr::cols(
  .default = readr::col_guess()
)  # C33 SEED: clock contract removed; readr guesses naive clocks as POSIXct (UTC-tagged)"""),
 ("""  if (inherits(x, "POSIXt")) {
    tz_src <- attr(x, "tzone")
    if (is.null(tz_src) || !nzchar(tz_src[[1]])) tz_src <- "UTC"
    s <- format(x, format = "%Y-%m-%d %H:%M:%S", tz = tz_src[[1]])
  } else {""", """  if (inherits(x, "POSIXt")) {
    return(as.POSIXct(x, tz = "America/Chicago"))  # C33 SEED: POSIXct shortcut (keeps readr's instant)
  } else {"""),
])
emit("C33/X2_RA_run_RA.R", ra_x, ra, "frozen/R-A/run_RA.R")

# ---- C27 mutants of R-B 20_integrity_and_classify.R (one per fixture-protected rule) ----
ic = (FROZEN/"r-b/R/20_integrity_and_classify.R").read_text(encoding="utf-8")
MUTANTS = [
 ("M01", "kappa rule uses peer p50 instead of p75 (F01-F03,F10,F11)",
  [("thresh <- kappa * peer_p75\n", "thresh <- kappa * joined$peer_p50_h  # C27 SEED M01\n")]),
 ("M02", "I01 Open+CLOSED_DATE contradiction deleted (F04)",
  [("p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))", "p_closed_contra <- rep(FALSE, n)  # C27 SEED M02")]),
 ("M03", "I02 mod<created sub-clause deleted (F05)",
  [(" (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |", "  # C27 SEED M03 (mod<created clause removed)\n   ")]),
 ("M04", "I04 thin peer_n<n_min deleted (F06)",
  [("p_thin <- peer_n < RB_N_MIN", "p_thin <- rep(FALSE, n)  # C27 SEED M04")]),
 ("M05", "DUPLICATE exclusion deleted (F07)",
  [("in_decision <- is_open & !dup_flag & !leg_flag", "in_decision <- is_open & !leg_flag  # C27 SEED M05")]),
 ("M06", "LEGACY_RECORD exclusion deleted (F08)",
  [("in_decision <- is_open & !dup_flag & !leg_flag", "in_decision <- is_open & !dup_flag  # C27 SEED M06")]),
 ("M07", "I05 PARENT_SR_NUMBER clause deleted (F09)",
  [("p_parent <- parent_nonblank", "p_parent <- rep(FALSE, n)  # C27 SEED M07")]),
 ("M08", "not-Open exclusion deleted (F12)",
  [('is_open <- tolower(status_norm) == "open"', 'is_open <- rep(TRUE, n)  # C27 SEED M08')]),
 ("M09", "I02 unparseable/missing CREATED sub-clause deleted (F13)",
  [("p_bad_clock <- is.na(created_ts) | is.na(mod_ts) |", "p_bad_clock <- is.na(mod_ts) |  # C27 SEED M09\n   ")]),
]
lines = []
for mid, desc, pairs in MUTANTS:
    emit(f"C27/{mid}_20_integrity_and_classify.R", mutate(ic, pairs), ic, "frozen/R-B/R/20_integrity_and_classify.R")
    lines.append(f"{mid}\t{desc}")
(seeds/"C27/MUTANTS.tsv").write_text("mutant_id\tdescription\n" + "\n".join(lines) + "\n", encoding="utf-8")
(ROOT/"SEED_DIFFS.txt").write_text("\n".join(diffs), encoding="utf-8")
with open(ROOT/"SEEDS.sha256", "w") as f:
    for p in sorted(seeds.rglob("*")):
        if p.is_file(): f.write(f"{sha(p)}  {p.relative_to(ROOT).as_posix()}\n")
print("ok")
