#!/usr/bin/env Rscript
# R-A — Independent judged path (SEQUENTIAL mutate / case_when)
# Stage 3 LOCKED: stage3_locked_design.json | fixtures-v0.1 (do not rewrite)
# No shared judged helpers with R-B. No copying ID lists.
# Portfolio simulation — NOT live City dispatch; open_age_days_threshold=14 is NOT City SLA.

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(stringr)
  library(lubridate)
  library(jsonlite)
  library(tibble)
})

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "fixtures"
# mode: fixtures | production
# production arg2 = path to source TSV

T_FREEZE <- as.POSIXct("2026-09-12 23:59:59", tz = "America/Chicago")
OPEN_AGE_THRESHOLD <- 14L
DESIGN_VERSION <- "stage3-v0.1"
FIXTURE_VERSION <- "fixtures-v0.1"
SNAPSHOT_ID <- "chicago311-raw-frozen-2026-09-12"
INFO_ONLY <- "311 INFORMATION ONLY CALL"

is_blank <- function(x) {
  is.na(x) | str_trim(as.character(x)) == ""
}

is_truthy <- function(x) {
  v <- tolower(str_trim(as.character(x)))
  v %in% c("true", "t", "1", "yes", "y")
}

parse_created <- function(x) {
  # Interpret as America/Chicago wall time when no offset present
  out <- suppressWarnings(as.POSIXct(x, tz = "America/Chicago", format = "%Y-%m-%d %H:%M:%S"))
  miss <- is.na(out) & !is_blank(x)
  if (any(miss)) {
    out2 <- suppressWarnings(ymd_hms(x, tz = "America/Chicago", quiet = TRUE))
    out[miss] <- out2[miss]
  }
  out
}

judge_ra <- function(src) {
  src %>%
    mutate(
      .sr = as.character(SR_NUMBER),
      .type = as.character(SR_TYPE),
      .status = as.character(STATUS),
      .dup = as.character(DUPLICATE),
      .parent = as.character(PARENT_SR_NUMBER),
      .legacy = as.character(LEGACY_RECORD),
      .created_raw = as.character(CREATED_DATE),
      is_open = (.status == "Open"),
      created_ts = parse_created(.created_raw),
      created_ok = !is_blank(.created_raw) & !is.na(created_ts),
      dup_truthy = is_truthy(.dup),
      parent_present = !is_blank(.parent),
      self_parent = parent_present & !is_blank(.sr) & (.parent == .sr),
      # Contradiction (§5.2) — stay eligible → INCONCLUSIVE
      contradictory = (dup_truthy & !parent_present) |
        (parent_present & !dup_truthy) |
        self_parent,
      # Clean duplicate-child exclusion
      clean_dup_child = (dup_truthy | parent_present) & !contradictory,
      legacy_truthy = is_truthy(.legacy),
      blank_id = is_blank(.sr),
      blank_type = is_blank(.type),
      info_only = !blank_type & (.type == INFO_ONLY),
      after_freeze = created_ok & (created_ts > T_FREEZE),
      # Eligibility (fixtures: post-freeze kept eligible → INCONCLUSIVE; missing created excluded)
      exclusion_reason = case_when(
        !is_open ~ "not_open",
        blank_id ~ "blank_id",
        blank_type ~ "blank_type",
        !created_ok ~ "bad_created",
        info_only ~ "info_only",
        legacy_truthy ~ "legacy",
        clean_dup_child ~ "duplicate_child",
        TRUE ~ NA_character_
      ),
      is_eligible = is_open & is.na(exclusion_reason),
      open_age_days = if_else(
        created_ok,
        as.integer(floor(as.numeric(difftime(T_FREEZE, created_ts, units = "secs")) / 86400)),
        NA_integer_
      ),
      # Action order: INCONCLUSIVE → ESCALATE → STANDARD (eligible only)
      action = case_when(
        !is_eligible ~ NA_character_,
        contradictory ~ "INCONCLUSIVE",
        after_freeze ~ "INCONCLUSIVE",
        !created_ok ~ "INCONCLUSIVE",
        open_age_days >= OPEN_AGE_THRESHOLD ~ "ESCALATE",
        TRUE ~ "STANDARD"
      ),
      evidence_notes = case_when(
        !is_eligible ~ NA_character_,
        contradictory ~ "contradictory_duplicate_parent",
        after_freeze ~ "created_after_freeze",
        TRUE ~ NA_character_
      ),
      selected = !is.na(action) & action == "ESCALATE",
      snapshot_id = SNAPSHOT_ID,
      design_version = DESIGN_VERSION,
      fixture_version = FIXTURE_VERSION,
      builder = "R-A-sequential",
      simulation_label = "portfolio_simulation_not_live_dispatch"
    ) %>%
    select(
      SR_NUMBER = .sr,
      is_open, is_eligible, exclusion_reason, open_age_days,
      action, selected, evidence_notes,
      snapshot_id, design_version, fixture_version, builder, simulation_label
    )
}

run_fixtures <- function(fixture_dir, out_csv) {
  files <- sort(list.files(fixture_dir, pattern = "^F[0-9]+\\.json$", full.names = TRUE))
  rows <- list()
  for (fp in files) {
    fx <- fromJSON(fp, simplifyVector = TRUE)
    src <- as_tibble(fx$source_row)
    # ensure columns exist
    judged <- judge_ra(src)
    exp <- fx$expected
    ok_open <- identical(as.logical(judged$is_open[[1]]), as.logical(exp$is_open))
    ok_elig <- identical(as.logical(judged$is_eligible[[1]]), as.logical(exp$is_eligible))
    ok_action <- identical(
      if (is.null(exp$action) || (length(exp$action) == 1 && is.na(exp$action))) NA_character_ else as.character(exp$action),
      if (is.na(judged$action[[1]])) NA_character_ else as.character(judged$action[[1]])
    )
    ok_sel <- identical(as.logical(judged$selected[[1]]), as.logical(exp$selected))
    ok_age <- TRUE
    if (!is.null(exp$open_age_days)) {
      ok_age <- identical(as.integer(judged$open_age_days[[1]]), as.integer(exp$open_age_days))
    }
    ok_excl <- TRUE
    if (!is.null(exp$exclusion_reason)) {
      ok_excl <- identical(as.character(judged$exclusion_reason[[1]]), as.character(exp$exclusion_reason))
    }
    pass <- ok_open && ok_elig && ok_action && ok_sel && ok_age && ok_excl
    rows[[length(rows) + 1]] <- tibble(
      fixture_id = fx$fixture_id,
      pass = pass,
      got_action = judged$action[[1]],
      exp_action = if (is.null(exp$action)) NA_character_ else as.character(exp$action),
      got_eligible = judged$is_eligible[[1]],
      exp_eligible = exp$is_eligible,
      got_age = judged$open_age_days[[1]],
      builder = "R-A"
    )
  }
  res <- bind_rows(rows)
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)
  write_csv(res, out_csv)
  cat("R-A fixtures:", sum(res$pass), "/", nrow(res), "PASS\n")
  if (any(!res$pass)) {
    print(res %>% filter(!pass))
    quit(status = 1)
  }
  invisible(res)
}

if (identical(mode, "fixtures")) {
  root <- if (length(args) >= 2) args[[2]] else {
    # discover repo root from this script
    this <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
    if (is.null(this)) getwd() else normalizePath(file.path(dirname(this), "..", ".."))
  }
  # When run via Rscript path, use relative from cwd
  fixture_dir <- file.path("docs", "stage-03-measurement-design", "fixtures")
  if (!dir.exists(fixture_dir)) {
    fixture_dir <- file.path(root, "docs", "stage-03-measurement-design", "fixtures")
  }
  out_csv <- file.path("validation", "fixtures", "r_a_fixture_results.csv")
  run_fixtures(fixture_dir, out_csv)
} else if (identical(mode, "production")) {
  src_path <- args[[2]]
  out_path <- if (length(args) >= 3) args[[3]] else "outputs/r_a_judged.csv"
  src <- read_tsv(src_path, col_types = cols(.default = "c"), na = c("", "NA", "NULL"))
  judged <- judge_ra(src)
  # Judged universe = eligible open only (+ keep exclusion audit separately)
  eligible <- judged %>% filter(is_eligible)
  audit <- judged %>% filter(!is_eligible)
  dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
  write_csv(eligible, out_path)
  write_csv(audit, sub("\\.csv$", "_exclusions.csv", out_path))
  cat("R-A production eligible_n=", nrow(eligible), " excluded_n=", nrow(audit), "\n", sep = "")
} else {
  stop("Unknown mode: ", mode)
}
