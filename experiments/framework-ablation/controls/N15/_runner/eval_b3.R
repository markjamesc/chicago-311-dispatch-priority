#!/usr/bin/env Rscript
# N15 batch-3 evaluator (read-only on inputs). Usage: Rscript eval_b3.R <WORK_ROOT> <FROZEN_ROOT> <CID,CID,...>
# Stage-5-only controls (C32 C35 C36 C15): arm B = frozen validated state + frozen-path Stage-5 harness = truth reference.
# C45: serial vs concurrent R-A/R-B runs; outputs compared byte-for-byte with the serial arms and the frozen outputs.
# Writes <CID>/evidence/<CID>_RESULTS.md and <CID>_arms.csv, and RUN_SUMMARY.txt. Statements are measured facts under the stated definitions.
options(warn = 1)
suppressPackageStartupMessages({ library(readr); library(dplyr) })
a <- commandArgs(trailingOnly = TRUE); stopifnot(length(a) == 3)
W <- normalizePath(a[[1]], winslash = "/"); FZ <- normalizePath(a[[2]], winslash = "/"); CIDS <- strsplit(a[[3]], ",")[[1]]
S5_FILES <- c("independent_checks_critical_counts.csv", "portfolio_summary.csv", "escalate_by_type.csv", "escalate_by_type_top25.csv",
              "inconclusive_by_clause.csv", "escalate_dormancy_summary.csv", "kappa_sensitivity.csv", "capacity_coverage_note.csv")
LABEL_FILES <- c("portfolio_summary.csv", "escalate_by_type.csv", "escalate_by_type_top25.csv", "inconclusive_by_clause.csv", "escalate_dormancy_summary.csv")
rdc <- function(p) read_csv(p, col_types = cols(.default = col_character()), progress = FALSE)
same_csv <- function(f1, f2) { if (!file.exists(f1) || !file.exists(f2)) return(FALSE)
  x <- rdc(f1); y <- rdc(f2)
  if (!identical(dim(x), dim(y)) || !identical(names(x), names(y))) return(FALSE)
  for (k in names(x)) { a <- x[[k]]; b <- y[[k]]; na <- suppressWarnings(as.numeric(a)); nb <- suppressWarnings(as.numeric(b))
    if (!identical(is.na(a), is.na(b))) return(FALSE)
    num <- !is.na(na) & !is.na(nb); if (any(abs(na[num] - nb[num]) > 1e-9)) return(FALSE)
    txt <- !num & !is.na(a); if (any(a[txt] != b[txt])) return(FALSE) }
  TRUE }
exit_of <- function(d, tag) { p <- file.path(d, paste0("RUN_", tag, ".exit")); if (!file.exists(p)) return(NA_integer_)
  as.integer(strsplit(readLines(p, warn = FALSE)[1], ",")[[1]][1]) }
secs_of <- function(d, tag) { p <- file.path(d, paste0("RUN_", tag, ".exit")); if (!file.exists(p)) return(NA_real_)
  as.numeric(strsplit(readLines(p, warn = FALSE)[1], ",")[[1]][2]) }
frz <- function(d, tag) { p <- file.path(d, paste0("FRZ_", tag, ".txt")); if (!file.exists(p)) return(NA_character_)
  x <- readLines(p, warn = FALSE, encoding = "UTF-8"); x <- sub("^\ufeff", "", x); ch <- x[startsWith(x, "CHANGED")]
  if (!length(ch)) "" else paste(vapply(strsplit(ch, "  ", fixed = TRUE), function(z) z[3], ""), collapse = ";") }
set_s <- function(x) paste0("{", paste(x, collapse = ","), "}")
md_tbl <- function(df) { df <- as.data.frame(df, stringsAsFactors = FALSE)
  c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
    apply(df, 1, function(z) paste0("| ", paste(ifelse(is.na(z), "NA", trimws(format(z, scientific = FALSE))), collapse = " | "), " |"))) }
# frozen validated labels (truth)
fra <- rdc(file.path(FZ, "R-A/outputs/RA_classifications.csv")); names(fra) <- tolower(names(fra))
VAL_SET <- sort(rdc(file.path(FZ, "outputs/validated_action_list.csv"))$SR_NUMBER)
NV <- c(ESCALATE = sum(fra$classification == "ESCALATE"), INCONCLUSIVE = sum(fra$classification == "INCONCLUSIVE"), STANDARD = sum(fra$classification == "STANDARD"))
cap_flag <- tryCatch(jsonlite::fromJSON(file.path(W, "runner", "stage45", "stage3_locked_design.json"))$capacity$flag, error = function(e) NA_character_)
# --- per-arm Stage-5 facts ---
s5_facts <- function(cid, arm) {
  d <- file.path(W, cid, "arms", arm); s5 <- file.path(d, "stage-05", "deeper"); b5 <- file.path(W, cid, "arms", "B", "stage-05", "deeper")
  ex <- exit_of(d, "S5"); pre <- exit_of(d, "PRE")
  dif <- if (identical(ex, 0L)) S5_FILES[!vapply(S5_FILES, function(f) same_csv(file.path(s5, f), file.path(b5, f)), TRUE)] else character(0)
  extra <- if (dir.exists(s5)) setdiff(list.files(s5, pattern = "\\.csv$"), S5_FILES) else character(0)
  # label check (C36 control): label-derived outputs equal arm B; added files with SR-level labels or class counts agree with validated labels
  lab_fail <- c(intersect(dif, LABEL_FILES))
  rank_cols <- character(0); set_fail <- character(0)
  for (f in extra) { x <- rdc(file.path(s5, f)); nm <- tolower(names(x))
    if (any(nm %in% c("n_escalate", "n_inconclusive", "n_standard"))) for (k in intersect(nm, c("n_escalate", "n_inconclusive", "n_standard"))) {
      cls <- toupper(sub("^n_", "", k)); if (sum(as.numeric(x[[which(nm == k)[1]]]), na.rm = TRUE) != NV[[cls]]) lab_fail <- c(lab_fail, f) }
    if ("sr_number" %in% nm) { sr <- x[[which(nm == "sr_number")[1]]]
      lc <- intersect(nm, c("classification", "action", "label"))
      if (length(lc)) { m <- match(sr, fra$sr_number); if (any(is.na(m)) || any(x[[which(nm == lc[1])[1]]] != fra$classification[m])) lab_fail <- c(lab_fail, f) }
      if (!identical(sort(unique(sr)), VAL_SET)) set_fail <- c(set_fail, f) }
    if (any(grepl("rank|priority", nm))) rank_cols <- c(rank_cols, f) }
  tibble(arm = arm, pre_exit = pre, s5_exit = ex, frz_pre_changed = frz(d, "PRE"), frz_post_changed = frz(d, "POST"),
         s5_outputs_differ_vs_B = paste(dif, collapse = ";"), s5_added_files = paste(extra, collapse = ";"),
         label_check_fail = paste(unique(lab_fail), collapse = ";"), action_set_differs = paste(unique(set_fail), collapse = ";"),
         rank_or_priority_cols = paste(unique(rank_cols), collapse = ";"))
}
DEF <- list(
  C32 = list(title = "Freeze Before Stage 5 (catalog #32)",
    H = "Stage 5 completes (exit 0) and at least one of its 8 standard outputs differs from arm B (CSV content, numbers to 1e-9)",
    with = "the pre-Stage-5 freeze check finds a Stage-5 input whose SHA-256 differs from the validation freeze (FRZ_PRE)",
    without = "Stage 5 exits non-zero (its own independent count checks)",
    inH = function(r) identical(r$s5_exit, 0L) && nzchar(r$s5_outputs_differ_vs_B), cw = function(r) !is.na(r$frz_pre_changed) && nzchar(r$frz_pre_changed)),
  C35 = list(title = "Freeze Validated Pack (catalog #35)",
    H = "after Stage 5, at least one validated file (RA_classifications, RB_kappa_grid_counts, validated_action_list) differs from the validation freeze (FRZ_POST)",
    with = "the archived validation freeze is compared after Stage 5 (FRZ_POST check) and any changed validated file is reported",
    without = "Stage 5 exits non-zero (its own independent count checks)",
    inH = function(r) !is.na(r$frz_post_changed) && nzchar(r$frz_post_changed), cw = function(r) !is.na(r$frz_post_changed) && nzchar(r$frz_post_changed)),
  C36 = list(title = "No Re-Judging of Validation Labels (catalog #36)",
    H = "Stage 5 completes and a label-derived output (portfolio_summary, escalate_by_type(_top25), inconclusive_by_clause, escalate_dormancy_summary) differs from arm B, or an added output's SR-level labels or class totals disagree with the validated labels",
    with = "the label-consistency check (same definition as H, applied before release) fails",
    without = "Stage 5 exits non-zero (its own independent count checks)",
    inH = function(r) identical(r$s5_exit, 0L) && nzchar(r$label_check_fail), cw = function(r) identical(r$s5_exit, 0L) && nzchar(r$label_check_fail)),
  C15 = list(title = "Ranking/Capacity Framing-Only (catalog #15)",
    H = "Stage 5 completes and writes an SR-level action output whose SR set differs from the validated (unordered) ESCALATE set",
    with = paste0("the framing-scope check fails: Stage 3 capacity flag is ", cap_flag, ", so any Stage-5 SR-level output whose set differs from the validated set, or any rank/priority column, is blocked"),
    without = "Stage 5 exits non-zero (its own independent count checks)",
    inH = function(r) identical(r$s5_exit, 0L) && nzchar(r$action_set_differs),
    cw = function(r) identical(r$s5_exit, 0L) && (nzchar(r$action_set_differs) || (nzchar(r$rank_or_priority_cols) && !identical(cap_flag, "DECLARED_CAP")))))
summary_lines <- c(paste0("RUN_SUMMARY N15 ", paste(CIDS, collapse = ","), "  written ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")), "")
for (cid in CIDS) {
  ev <- file.path(W, cid, "evidence"); dir.create(ev, recursive = TRUE, showWarnings = FALSE)
  if (cid == "C45") {
    arms <- read_tsv(file.path(W, "runner", "seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()))
    allarms <- c("B", arms$arm); KEY <- c("R-A/outputs/RA_classifications.csv", "R-B/outputs/RB_classifications.csv", "R-A/outputs/RA_fixture_results.csv",
                                          "R-B/outputs/RB_fixture_results.csv", "R-A/outputs/RA_portfolio_counts.csv", "R-B/outputs/RB_portfolio_counts.csv", "R-B/outputs/RB_kappa_grid_counts.csv")
    hof <- function(p) if (file.exists(p)) digest::digest(file = p, algo = "sha256") else "MISSING"
    fz_h <- vapply(KEY, function(k) hof(file.path(FZ, k)), "")
    rows <- lapply(allarms, function(arm) { d <- file.path(W, cid, "arms", arm)
      pf <- if (file.exists(file.path(d, "PERF.csv"))) read_csv(file.path(d, "PERF.csv"), show_col_types = FALSE) else tibble(mode = NA, wall_s = NA, peak_ws_mb = NA, free_mb_before = NA)
      h <- vapply(KEY, function(k) hof(file.path(d, k)), "")
      tibble(arm = arm, mode = pf$mode[1], ra_exit = exit_of(d, "RA"), rb_exit = exit_of(d, "RB"), ra_secs = secs_of(d, "RA"), rb_secs = secs_of(d, "RB"),
             wall_s = pf$wall_s[1], peak_ws_mb = pf$peak_ws_mb[1], free_mb_before = pf$free_mb_before[1],
             outputs_equal_frozen = sprintf("%d/%d", sum(h == fz_h), length(KEY)), differing = paste(basename(KEY)[h != fz_h], collapse = ";"),
             .h = paste(h, collapse = ",")) })
    at <- bind_rows(rows); ref <- at$.h[at$mode == "SER"]
    at$outputs_equal_serial <- vapply(at$.h, function(z) all(z == ref), TRUE); at$.h <- NULL
    write_csv(at, file.path(ev, "C45_arms.csv"))
    mc <- if (file.exists(file.path(W, cid, "MEMCHECK.txt"))) readLines(file.path(W, cid, "MEMCHECK.txt"), warn = FALSE) else "MEMCHECK.txt missing"
    ser <- at %>% filter(mode == "SER"); par <- at %>% filter(mode == "PAR")
    fail <- any(c(at$ra_exit, at$rb_exit) != 0 | is.na(c(at$ra_exit, at$rb_exit)))
    ident <- nrow(par) > 0 && all(par$outputs_equal_serial) && all(at$outputs_equal_frozen == sprintf("%d/%d", length(KEY), length(KEY)))
    ms <- median(ser$wall_s); mp <- if (nrow(par)) median(par$wall_s) else NA
    p1 <- !fail && ident && !is.na(mp) && mp < ms
    res <- c(paste0("# C45 RESULTS — Parallel R-A/R-B runs (Addendum 02 #45) (runner output, mechanical facts only)"), "",
      "Arm B is the serial reference run. SER_* run R-A then R-B. PAR_* launch R-A and R-B concurrently on the same arm copy of the frozen package.",
      "Wall-clock = first launch to last exit, as measured by the runner. Peak memory = maximum summed working set of R processes, sampled every 0.5 s.", "",
      "## Declared memory check (before the first concurrent arm)", mc, "",
      "## Arms (C45_arms.csv)", md_tbl(at), "",
      "## Facts", paste0("- H1 runs with a non-zero exit or no exit record: ", if (fail) "YES" else "none"),
      paste0("- H2 every concurrent arm's 7 key outputs byte-identical to the serial arms and to the frozen outputs: ", if (ident) "YES" else "NO"),
      sprintf("- H3 median wall-clock: serial %.1f s (n=%d), concurrent %.1f s (n=%d); ratio %.3f", ms, nrow(ser), mp, nrow(par), mp / ms),
      sprintf("- H4 peak memory: serial max %.0f MB, concurrent max %.0f MB", max(ser$peak_ws_mb), if (nrow(par)) max(par$peak_ws_mb) else NA), "",
      "## Proposed predicate P1 (Addendum 02 #45 wording)",
      "KEEP-side if outputs are byte-identical to serial runs and wall-clock falls (median concurrent < median serial) with no run failure; REVERT-side if any output differs or a run fails.",
      paste0("P1 ", if (p1) "satisfied" else "not satisfied", ": identical=", ident, ", failure=", fail, sprintf(", median concurrent/serial=%.3f", mp / ms)))
    writeLines(res, file.path(ev, "C45_RESULTS.md"), useBytes = TRUE)
    summary_lines <- c(summary_lines, paste0("C45: P1 ", if (p1) "satisfied" else "not satisfied", sprintf(" (identical=%s failure=%s ratio=%.3f)", ident, fail, mp / ms)))
    next }
  D <- DEF[[cid]]; arms <- read_tsv(file.path(W, "runner", "seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()))
  b <- s5_facts(cid, "B"); b5 <- file.path(W, cid, "arms", "B", "stage-05", "deeper"); fz5 <- file.path(FZ, "stage-05", "deeper")
  brep <- S5_FILES[!vapply(S5_FILES, function(f) same_csv(file.path(b5, f), file.path(fz5, f)), TRUE)]
  at <- bind_rows(lapply(seq_len(nrow(arms)), function(i) { r <- s5_facts(cid, arms$arm[i])
    r$desc <- arms$desc[i]; r$in_H <- D$inH(r); r$caught_with <- D$cw(r); r$caught_without <- is.na(r$s5_exit) || r$s5_exit != 0L; r }))
  b$desc <- "clean reference"; b$in_H <- NA; b$caught_with <- D$cw(b); b$caught_without <- is.na(b$s5_exit) || b$s5_exit != 0L
  write_csv(bind_rows(b, at), file.path(ev, paste0(cid, "_arms.csv")))
  H <- at$arm[at$in_H]; Dw <- at$arm[at$caught_with]; Da <- at$arm[at$caught_without]
  esc <- setdiff(H, Da); miss_w <- setdiff(H, Dw); fp_w <- setdiff(Dw, H)
  bclean <- identical(b$s5_exit, 0L) && !length(brep) && !isTRUE(b$caught_with)
  p1 <- bclean && !length(esc)
  res <- c(paste0("# ", cid, " RESULTS — ", D$title, " ablation (runner output, mechanical facts only)"), "",
    "Every arm starts from the frozen validated state (RA_classifications.csv, RB_kappa_grid_counts.csv, validated_action_list.csv copied from the frozen pack) and records VALIDATION_FREEZE.sha256 before anything else runs.",
    "Arm B runs the frozen-path Stage-5 harness with no edit and is the truth reference. Seeded arms apply the listed edit (PRE step) or Stage-5 variant.", "",
    "## Definitions (frozen in the spec)", paste0("- Harm set H: ", D$H), paste0("- Caught with the control: ", D$with), paste0("- Caught without the control (D_abl): ", D$without), "",
    "## Arm B", sprintf("- Stage 5 exit %s; outputs equal frozen stage-05/deeper: %s; with-control check on B: %s", b$s5_exit, if (length(brep)) paste("NO, differ:", paste(brep, collapse = ";")) else "YES (8/8)", if (isTRUE(b$caught_with)) "FLAGGED (false positive)" else "clean"), "",
    paste0("## Arms (", cid, "_arms.csv)"), md_tbl(bind_rows(b, at) %>% select(arm, pre_exit, s5_exit, frz_pre_changed, frz_post_changed, s5_outputs_differ_vs_B, s5_added_files, label_check_fail, action_set_differs, rank_or_priority_cols, in_H, caught_with, caught_without)), "",
    "## Sets", paste0("- H = ", set_s(H)), paste0("- caught with the control = ", set_s(Dw)), paste0("- D_abl (caught without) = ", set_s(Da)),
    paste0("- H \\ D_abl (escapes once the control is removed) = ", set_s(esc)), paste0("- H \\ caught-with (missed even with the control) = ", set_s(miss_w)),
    paste0("- flagged with the control but not in H (control cost / over-blocking) = ", set_s(fp_w)), "",
    "## Predicate P1 (frozen)", "KEEP-side requires arm B clean and H \\ D_abl = {} (removing the control lets no harm through). Otherwise the control stays.",
    paste0("P1 ", if (p1) "satisfied" else paste0("failed: H \\ D_abl = ", set_s(esc), if (!bclean) " (arm B not clean)" else "")))
  writeLines(res, file.path(ev, paste0(cid, "_RESULTS.md")), useBytes = TRUE)
  summary_lines <- c(summary_lines, paste0(cid, ": H=", set_s(H), " D_abl=", set_s(Da), " with=", set_s(Dw), " -> P1 ", if (p1) "satisfied" else "failed"))
}
writeLines(summary_lines, file.path(W, "RUN_SUMMARY.txt"), useBytes = TRUE); cat(summary_lines, sep = "\n")
