#!/usr/bin/env Rscript
# =============================================================================
# Chicago 311 Stage 4 — R-B judged path (AI-3 / independent)
# Construct: B-leaning hybrid TCD-IG (type-conditional dormancy + integrity gate)
# Authority: docs/MEASUREMENT_DESIGN_LOCKED.md | fixtures-v1-tcd-ig
#
# Independence attestation: this tree does not read, source, or mirror chicago311/R-A.
# Organization: modular predicate-matrix under R-B/R/ (not a single pipe script).
# =============================================================================

suppressPackageStartupMessages({
  # Soft deps — core path works with base R; tidyverse preferred when present
  has_dplyr <- requireNamespace("dplyr", quietly = TRUE)
  has_readr <- requireNamespace("readr", quietly = TRUE)
})

rb_dir <- (function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) == 1) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg), winslash = "/", mustWork = FALSE)))
  }
  if (basename(getwd()) == "R-B") return(normalizePath(".", winslash = "/"))
  if (dir.exists("R-B")) return(normalizePath("R-B", winslash = "/"))
  normalizePath(getwd(), winslash = "/")
})()

source(file.path(rb_dir, "R", "00_config.R"), local = FALSE)
source(file.path(rb_dir, "R", "10_io_parse.R"), local = FALSE)
source(file.path(rb_dir, "R", "20_integrity_and_classify.R"), local = FALSE)
source(file.path(rb_dir, "R", "40_fixtures.R"), local = FALSE)

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "all"  # fixtures | production | all | wait
wait_secs <- if (length(args) >= 2) as.integer(args[[2]]) else 0L

paths <- rb_paths()
dir.create(paths$out_dir, recursive = TRUE, showWarnings = FALSE)

message("[R-B] project root: ", paths$root)
message("[R-B] rule_version: ", RB_RULE_VERSION, "  kappa_default=", RB_KAPPA_DEFAULT)
message("[R-B] T_freeze: ", format(RB_T_FREEZE, usetz = TRUE))

write_csv_rb <- function(df, path) {
  if (requireNamespace("readr", quietly = TRUE)) {
    readr::write_csv(df, path, na = "")
  } else {
    utils::write.csv(df, path, row.names = FALSE, na = "")
  }
  message("[R-B] wrote ", path, " (n=", nrow(df), ")")
}

# ----- Fixtures (always available; no production CSV required) -----
run_fixtures <- function() {
  message("[R-B] scoring fixture pack ", RB_FIXTURE_VERSION, " ...")
  fx <- rb_score_fixtures(kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE)
  out <- file.path(paths$out_dir, "RB_fixture_results.csv")
  write_csv_rb(fx, out)
  n_pass <- sum(fx$pass, na.rm = TRUE)
  n_tot <- nrow(fx)
  f03 <- fx[fx$fixture_id == "F03", , drop = FALSE]
  message("[R-B] fixtures pass ", n_pass, "/", n_tot,
          " | F03 observed=", if (nrow(f03)) f03$observed_classification[[1]] else "?",
          " expected=STANDARD")
  if (nrow(f03) && isTRUE(f03$pass[[1]])) {
    message("[R-B] F03→STANDARD OK at kappa=2")
  } else {
    warning("[R-B] F03 did not pass STANDARD at kappa=2", call. = FALSE)
  }
  invisible(fx)
}

wait_for_sources <- function(max_wait_sec = 0L) {
  needed <- c(paths$open_csv, paths$peer_csv)
  deadline <- Sys.time() + max_wait_sec
  repeat {
    missing <- needed[!file.exists(needed)]
    if (!length(missing)) {
      message("[R-B] source CSVs present")
      return(TRUE)
    }
    if (max_wait_sec <= 0 || Sys.time() >= deadline) {
      message("[R-B] waiting for source CSVs still missing:\n  - ", paste(missing, collapse = "\n  - "))
      return(FALSE)
    }
    message("[R-B] poll for CSVs (", paste(basename(missing), collapse = ", "), ") ...")
    Sys.sleep(min(15, max(1, as.numeric(difftime(deadline, Sys.time(), units = "secs")))))
  }
}

# C24V3 CHUNKED run_production(): the only function that differs from the frozen run_RB.R. rb_normalize_open(), rb_judge_rows(),
# rb_portfolio_counts(), rb_kappa_grid_counts() and all constants are the frozen functions, applied to row-chunks (all judgments are row-local).
run_production <- function() {
  if (!wait_for_sources(wait_secs)) {
    stop("Source CSVs not found under data/source/. Expected:\n  ",
         paths$open_csv, "\n  ", paths$peer_csv, call. = FALSE)
  }
  message("[R-B] loading open candidates (chunked)...")
  chunk_rows <- as.integer(Sys.getenv("C24_CHUNK_ROWS", "250000"))
  peer_raw <- rb_read_csv_flex(paths$peer_csv)
  peer_df <- rb_normalize_peers(peer_raw)
  hdr <- names(readr::read_tsv(paths$open_csv, n_max = 0, col_types = readr::cols(.default = readr::col_character()), show_col_types = FALSE, progress = FALSE))
  ct <- do.call(readr::cols, stats::setNames(rep(list(readr::col_character()), length(hdr)), hdr))
  class_path <- file.path(paths$out_dir, "RB_classifications.csv")
  part_path <- paste0(class_path, ".partial")
  if (file.exists(part_path)) file.remove(part_path)
  st <- new.env(); st$first <- TRUE; st$n_in <- 0L; st$chunks <- 0L; st$n_lab <- 0L
  st$port <- NULL; st$grid <- NULL
  addcnt <- function(acc, df) if (is.null(acc)) df else { for (nm in setdiff(names(df), "kappa")) acc[[nm]] <- acc[[nm]] + df[[nm]]; acc }
  cb <- readr::SideEffectChunkCallback$new(function(x, pos) {
    open_df <- rb_normalize_open(as.data.frame(x, stringsAsFactors = FALSE))
    judged <- rb_judge_rows(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE)
    labeled <- judged[!is.na(judged$classification), , drop = FALSE]
    class_out <- labeled[, c(
      "SR_NUMBER", "type_key", "classification", "evidence_reason",
      "dormant_h", "open_age_h", "peer_n", "peer_p75_h", "peer_p50_h",
      "kappa", "integrity_clause", "rule_version", "design_version"
    )]
    readr::write_csv(class_out, part_path, na = "", append = !st$first)
    st$first <- FALSE
    st$port <- addcnt(st$port, rb_portfolio_counts(judged, kappa = RB_KAPPA_DEFAULT))
    g <- rb_kappa_grid_counts(open_df, peer_df, grid = RB_KAPPA_GRID, t_freeze = RB_T_FREEZE)
    g <- g[, c("kappa", "n_decision", "n_ESCALATE", "n_INCONCLUSIVE", "n_STANDARD")]
    if (is.null(st$grid)) st$grid <- g else for (nm in setdiff(names(g), "kappa")) { stopifnot(all(st$grid$kappa == g$kappa)); st$grid[[nm]] <- st$grid[[nm]] + g[[nm]] }
    st$n_in <- st$n_in + nrow(open_df); st$n_lab <- st$n_lab + nrow(labeled); st$chunks <- st$chunks + 1L
    message("[R-B] chunk ", st$chunks, " pos=", pos, " in=", st$n_in, " labeled=", st$n_lab)
    invisible(NULL)
  })
  readr::read_tsv_chunked(paths$open_csv, callback = cb, chunk_size = chunk_rows, col_types = ct, progress = FALSE)
  message("[R-B] open n=", st$n_in, " peer types=", nrow(peer_df), " chunks=", st$chunks, " chunk_rows=", chunk_rows)
  if (st$n_lab < 1) stop("classification n==0 \u2014 abort", call. = FALSE)
  file.rename(part_path, class_path)
  message("[R-B] wrote ", class_path, " (n=", st$n_lab, ")")

  port <- st$port
  write_csv_rb(port, file.path(paths$out_dir, "RB_portfolio_counts.csv"))
  message("[R-B] portfolio: decision=", port$n_decision,
          " ESCALATE=", port$n_ESCALATE,
          " INCONCLUSIVE=", port$n_INCONCLUSIVE,
          " STANDARD=", port$n_STANDARD)
  write_csv_rb(st$grid, file.path(paths$out_dir, "RB_kappa_grid_counts.csv"))
  message("[R-B] kappa grid written for {", paste(RB_KAPPA_GRID, collapse = ", "), "}")
  invisible(list(portfolio = port, grid = st$grid))
}

# Dispatch
if (mode %in% c("fixtures", "all")) {
  fx <- run_fixtures()
}
if (mode %in% c("production", "all", "wait")) {
  if (mode == "wait") wait_secs <- max(wait_secs, 3600L)
  prod <- run_production()
}

message("[R-B] done mode=", mode)
