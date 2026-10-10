#!/usr/bin/env Rscript
# =============================================================================
# Chicago 311 Stage 4 — R-A judged path (AI 1 / TCD-IG B-leaning hybrid)
# Independence: authored without reading or mirroring any R-B code.
# rule_version: RA-tcd-ig-v1
# =============================================================================

suppressPackageStartupMessages({
  # Prefer isolated R-A lib when present (box); else default user/site libs (PC)
  ra_lib <- Sys.getenv("RA_LIB", unset = "")
  if (!nzchar(ra_lib)) {
    cand <- path.expand("~/R/RA-lib")
    if (dir.exists(cand)) ra_lib <- cand
  }
  if (nzchar(ra_lib) && dir.exists(ra_lib)) {
    .libPaths(c(ra_lib, .libPaths()))
  }
  need <- c("dplyr", "readr", "stringr", "lubridate", "tidyr", "janitor", "tibble")
  for (p in need) {
    if (!requireNamespace(p, quietly = TRUE)) {
      install.packages(p, repos = "https://cloud.r-project.org", quiet = TRUE)
    }
  }
  library(dplyr)
  library(readr)
  library(stringr)
  library(lubridate)
  library(tidyr)
  library(tibble)
})

# ---- Locked constants -------------------------------------------------------
RULE_VERSION <- "RA-tcd-ig-v1"
KAPPA <- 2.0
N_MIN <- 50L
T_FREEZE <- lubridate::ymd_hms("2026-09-12 23:59:59", tz = "America/Chicago")

# ---- Paths ------------------------------------------------------------------
resolve_project_root <- function() {
  env <- Sys.getenv("CHICAGO311_ROOT", unset = "")
  if (nzchar(env) && dir.exists(env)) return(normalizePath(env, winslash = "/", mustWork = TRUE))

  # Script-relative: .../chicago311/R-A/run_RA.R  OR  .../stage-04/R-A/run_RA.R
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  script_path <- if (length(file_arg)) sub("^--file=", "", file_arg[1]) else NA_character_
  if (!is.na(script_path) && nzchar(script_path)) {
    ra_dir <- dirname(normalizePath(script_path, winslash = "/", mustWork = FALSE))
    parent <- dirname(ra_dir)
    # If parent contains data/source or looks like chicago311 root
    if (dir.exists(file.path(parent, "data", "source")) ||
        grepl("chicago311", basename(parent), ignore.case = TRUE)) {
      return(parent)
    }
    # stage-04 layout: parent is stage-04; project-ish root is parent
    if (basename(parent) == "stage-04" || dir.exists(file.path(parent, "data"))) {
      return(parent)
    }
  }

  win <- "C:/Users/Mark/Documents/R Working Directory/chicago311"
  if (dir.exists(win)) return(win)

  box <- "/workspace/chicago-311-run/stage-04"
  if (dir.exists(box)) return(box)

  stop("Cannot resolve chicago311 project root. Set CHICAGO311_ROOT.")
}

PROJECT_ROOT <- resolve_project_root()
RA_DIR <- file.path(PROJECT_ROOT, "R-A")
if (!dir.exists(RA_DIR)) {
  # Script may live inside R-A already
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg)) {
    RA_DIR <- dirname(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = FALSE))
  } else {
    dir.create(RA_DIR, recursive = TRUE, showWarnings = FALSE)
  }
}
OUT_DIR <- file.path(RA_DIR, "outputs")
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)
SOURCE_DIR <- file.path(PROJECT_ROOT, "data", "source")
dir.create(SOURCE_DIR, recursive = TRUE, showWarnings = FALSE)

message("PROJECT_ROOT=", PROJECT_ROOT)
message("RA_DIR=", RA_DIR)
message("SOURCE_DIR=", SOURCE_DIR)
message("OUT_DIR=", OUT_DIR)

# ---- Helpers ----------------------------------------------------------------
is_true_like <- function(x) {
  s <- tolower(str_trim(as.character(x)))
  s %in% c("true", "t", "y", "yes", "1")
}

is_blank <- function(x) {
  is.na(x) | !nzchar(str_trim(as.character(x)))
}

parse_ts_chicago <- function(x) {
  # Locked rule: SQL export clocks are naive America/Chicago wall times (no offset).
  # Never force_tz on POSIXct — readr often tags naive ISO as UTC and force_tz then
  # shifts the instant by the CDT/CST offset (~5h), flipping near-threshold labels.
  # Always recover printed digits, then parse as America/Chicago wall clock.
  if (inherits(x, "POSIXt")) {
    tz_src <- attr(x, "tzone")
    if (is.null(tz_src) || !nzchar(tz_src[[1]])) tz_src <- "UTC"
    s <- format(x, format = "%Y-%m-%d %H:%M:%S", tz = tz_src[[1]])
  } else {
    s <- str_trim(as.character(x))
  }
  s[is_blank(s)] <- NA_character_
  s <- str_replace(s, "T", " ")
  # Drop fractional seconds, trailing Z / offset — wall digits are Chicago
  s2 <- str_replace(s, "\\.[0-9]+", "")
  s2 <- str_replace(s2, "(Z|[+-][0-9]{2}:?[0-9]{2})$", "")
  out <- suppressWarnings(lubridate::ymd_hms(s2, tz = "America/Chicago", quiet = TRUE))
  miss <- is.na(out) & !is.na(s2)
  if (any(miss)) {
    out[miss] <- suppressWarnings(lubridate::mdy_hms(s2[miss], tz = "America/Chicago", quiet = TRUE))
  }
  miss <- is.na(out) & !is.na(s2)
  if (any(miss)) {
    out[miss] <- suppressWarnings(lubridate::ymd_hm(s2[miss], tz = "America/Chicago", quiet = TRUE))
  }
  miss <- is.na(out) & !is.na(s2)
  if (any(miss)) {
    out[miss] <- suppressWarnings(lubridate::mdy_hm(s2[miss], tz = "America/Chicago", quiet = TRUE))
  }
  out
}

hours_between <- function(later, earlier) {
  as.numeric(difftime(later, earlier, units = "hours"))
}


# Force naive clock columns to character so parse_ts_chicago owns tz (not readr)
clock_col_types <- readr::cols(
  created_ts = readr::col_character(),
  mod_ts = readr::col_character(),
  closed_ts = readr::col_character(),
  CREATED_DATE = readr::col_character(),
  LAST_MODIFIED_DATE = readr::col_character(),
  CLOSED_DATE = readr::col_character(),
  .default = readr::col_guess()
)


read_table_flex <- function(path_csv, path_tsv = NULL) {
  if (file.exists(path_csv)) {
    message("Reading ", path_csv)
    # MySQL --batch exports are tab-separated (LOCATION fields contain commas)
    return(readr::read_tsv(path_csv, col_types = clock_col_types, show_col_types = FALSE, guess_max = 100000, progress = FALSE))
  }
  if (!is.null(path_tsv) && file.exists(path_tsv)) {
    message("Reading ", path_tsv)
    return(readr::read_tsv(path_tsv, col_types = clock_col_types, show_col_types = FALSE, guess_max = 100000))
  }
  NULL
}

poll_source_files <- function(source_dir, max_wait_sec = 600, interval_sec = 15) {
  open_csv <- file.path(source_dir, "src_open_candidates.csv")
  peer_csv <- file.path(source_dir, "src_peer_stats.csv")
  open_tsv <- file.path(source_dir, "src_open_candidates.tsv")
  peer_tsv <- file.path(source_dir, "src_peer_stats.tsv")
  waited <- 0
  repeat {
    open_ok <- file.exists(open_csv) || file.exists(open_tsv)
    peer_ok <- file.exists(peer_csv) || file.exists(peer_tsv)
    if (open_ok && peer_ok) {
      return(list(
        open = if (file.exists(open_csv)) open_csv else open_tsv,
        peer = if (file.exists(peer_csv)) peer_csv else peer_tsv
      ))
    }
    if (waited >= max_wait_sec) {
      stop(
        "Source files not found after ", max_wait_sec, "s under ", source_dir,
        "\nExpected src_open_candidates.csv and src_peer_stats.csv (tsv fallback ok)."
      )
    }
    message(
      sprintf(
        "[poll %ds] open=%s peer=%s — waiting for export...",
        waited, open_ok, peer_ok
      )
    )
    Sys.sleep(interval_sec)
    waited <- waited + interval_sec
  }
}

# ---- Core classifier (one row in → classification) --------------------------
classify_open_rows <- function(open_df, peer_df, kappa = KAPPA, t_freeze = T_FREEZE, n_min = N_MIN) {
  # Normalize column names lightly
  nm <- names(open_df)
  names(open_df) <- nm

  # type_key
  if (!"type_key" %in% names(open_df)) {
    sc <- if ("SR_SHORT_CODE" %in% names(open_df)) open_df$SR_SHORT_CODE else NA_character_
    st <- if ("SR_TYPE" %in% names(open_df)) open_df$SR_TYPE else NA_character_
    open_df$type_key <- dplyr::coalesce(na_if(str_trim(as.character(sc)), ""), na_if(str_trim(as.character(st)), ""))
  } else {
    open_df$type_key <- na_if(str_trim(as.character(open_df$type_key)), "")
  }

  # Clocks: prefer pre-parsed created_ts/mod_ts/closed_ts if present; else parse raw
  created_ts <- if ("created_ts" %in% names(open_df)) parse_ts_chicago(open_df$created_ts) else parse_ts_chicago(open_df$CREATED_DATE)
  # If created_ts column was character empties that parse failed, try CREATED_DATE
  if ("CREATED_DATE" %in% names(open_df)) {
    miss_c <- is.na(created_ts)
    created_ts[miss_c] <- parse_ts_chicago(open_df$CREATED_DATE[miss_c])
  }
  mod_ts <- if ("mod_ts" %in% names(open_df)) parse_ts_chicago(open_df$mod_ts) else {
    if ("LAST_MODIFIED_DATE" %in% names(open_df)) parse_ts_chicago(open_df$LAST_MODIFIED_DATE) else as.POSIXct(NA)
  }
  if ("LAST_MODIFIED_DATE" %in% names(open_df)) {
    miss_m <- is.na(mod_ts)
    mod_ts[miss_m] <- parse_ts_chicago(open_df$LAST_MODIFIED_DATE[miss_m])
  }
  closed_ts <- if ("closed_ts" %in% names(open_df)) parse_ts_chicago(open_df$closed_ts) else {
    if ("CLOSED_DATE" %in% names(open_df)) parse_ts_chicago(open_df$CLOSED_DATE) else as.POSIXct(NA)
  }
  if ("CLOSED_DATE" %in% names(open_df)) {
    # CLOSED_DATE blank should stay NA; if closed_ts from SQL is present use it
    raw_closed_blank <- is_blank(open_df$CLOSED_DATE)
    closed_from_raw <- parse_ts_chicago(open_df$CLOSED_DATE)
    closed_ts <- dplyr::coalesce(closed_ts, closed_from_raw)
    closed_ts[raw_closed_blank & is.na(closed_from_raw)] <- as.POSIXct(NA)
  }

  dup <- if ("DUPLICATE" %in% names(open_df)) open_df$DUPLICATE else FALSE
  leg <- if ("LEGACY_RECORD" %in% names(open_df)) open_df$LEGACY_RECORD else FALSE
  parent <- if ("PARENT_SR_NUMBER" %in% names(open_df)) open_df$PARENT_SR_NUMBER else ""
  status <- if ("STATUS" %in% names(open_df)) str_trim(as.character(open_df$STATUS)) else "Open"

  # Exclude from decision set: DUPLICATE / LEGACY true-like; non-Open status
  in_envelope_open <- tolower(status) == "open"
  exclude <- is_true_like(dup) | is_true_like(leg) | !in_envelope_open

  # Peer join
  peer_df <- peer_df %>%
    mutate(
      type_key = na_if(str_trim(as.character(type_key)), ""),
      peer_n = as.integer(peer_n),
      peer_p75_h = as.numeric(peer_p75_h)
    ) %>%
    select(type_key, peer_n, peer_p75_h) %>%
    distinct(type_key, .keep_all = TRUE)

  base <- tibble(
    SR_NUMBER = as.character(open_df$SR_NUMBER),
    type_key = open_df$type_key,
    STATUS = status,
    created_ts = created_ts,
    mod_ts = mod_ts,
    closed_ts = closed_ts,
    parent_nonblank = !is_blank(parent),
    exclude = exclude
  ) %>%
    left_join(peer_df, by = "type_key")

  base <- base %>%
    mutate(
      peer_n = tidyr::replace_na(peer_n, 0L),
      peer_missing = is.na(peer_p75_h),
      dormant_h = hours_between(t_freeze, mod_ts),
      open_age_h = hours_between(t_freeze, created_ts),
      kappa = kappa
    )

  # Integrity clauses (first hit wins for reporting)
  integrity_clause <- rep(NA_character_, nrow(base))
  classification <- rep(NA_character_, nrow(base))

  # Out of decision set
  classification[base$exclude] <- NA_character_
  integrity_clause[base$exclude] <- "EXCLUDED"

  idx <- which(!base$exclude)

  # Integrity checks on decision-set candidates
  check <- function(cond, clause) {
    hit <- idx[cond[idx] & is.na(classification[idx])]
    classification[hit] <<- "INCONCLUSIVE"
    integrity_clause[hit] <<- clause
  }

  check(is_blank(base$type_key), "blank_type_key")
  check(!is.na(base$closed_ts), "open_with_closed_date")
  check(is.na(base$created_ts), "unparseable_created")
  check(is.na(base$mod_ts), "unparseable_mod")
  check(!is.na(base$created_ts) & !is.na(base$mod_ts) & base$mod_ts < base$created_ts, "inverted_clocks")
  check(!is.na(base$created_ts) & base$created_ts > t_freeze, "created_after_T")
  check(base$parent_nonblank, "orphan_parent_nonblank")
  check(base$peer_missing | base$peer_n < n_min, "thin_type_or_missing_peer")
  check(is.na(base$dormant_h), "unparseable_dormant_h")

  # Decision among remaining coherent rows
  remain <- which(!base$exclude & is.na(classification))
  thr <- kappa * base$peer_p75_h[remain]
  esc <- !is.na(base$dormant_h[remain]) & !is.na(thr) & (base$dormant_h[remain] >= thr)
  classification[remain[esc]] <- "ESCALATE"
  integrity_clause[remain[esc]] <- "dormant_ge_kappa_peer_p75"
  classification[remain[!esc]] <- "STANDARD"
  integrity_clause[remain[!esc]] <- "within_type_dormancy"

  tibble(
    SR_NUMBER = base$SR_NUMBER,
    type_key = base$type_key,
    classification = classification,
    dormant_h = round(base$dormant_h, 6),
    peer_n = base$peer_n,
    peer_p75_h = base$peer_p75_h,
    kappa = base$kappa,
    open_age_h = round(base$open_age_h, 6),
    integrity_clause = integrity_clause,
    rule_version = RULE_VERSION,
    .exclude = base$exclude
  )
}

# ---- Synthetic fixtures F01–F14 (locked pack; do not rewrite expected) -------
build_fixture_pack <- function(t_freeze = T_FREEZE) {
  # Peer stats used by fixtures
  peers <- tribble(
    ~type_key, ~peer_n, ~peer_p75_h,
    "POTHOLE", 500L, 7 * 24,
    "BUILDING", 200L, 90 * 24,
    "FASTTYPE", 100L, 3 * 24,
    "RARETYPE", 8L, 10 * 24
  )

  # Helper to stamp times relative to T
  ago <- function(hours) t_freeze - lubridate::dhours(hours)
  fmt <- function(x) format(x, "%Y-%m-%d %H:%M:%S")

  rows <- list(
    # F01 ESCALATE: dormant 20d, peer_p75=7d, κ=2 → 20>=14
    list(id = "F01", expected = "ESCALATE", in_set = TRUE,
         SR_NUMBER = "FIX-F01", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(25 * 24)), LAST_MODIFIED_DATE = fmt(ago(20 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F02 STANDARD: created 40d, modified 1d ago
    list(id = "F02", expected = "STANDARD", in_set = TRUE,
         SR_NUMBER = "FIX-F02", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(40 * 24)), LAST_MODIFIED_DATE = fmt(ago(1 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F03 STANDARD: building peer_p75=90d, dormant 100d; 100 < 180
    list(id = "F03", expected = "STANDARD", in_set = TRUE,
         SR_NUMBER = "FIX-F03", SR_SHORT_CODE = "BUILDING", SR_TYPE = "Building",
         STATUS = "Open", CREATED_DATE = fmt(ago(120 * 24)), LAST_MODIFIED_DATE = fmt(ago(100 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F04 INCONCLUSIVE: Open + CLOSED_DATE
    list(id = "F04", expected = "INCONCLUSIVE", in_set = TRUE,
         SR_NUMBER = "FIX-F04", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(10 * 24)), LAST_MODIFIED_DATE = fmt(ago(5 * 24)),
         CLOSED_DATE = fmt(ago(1 * 24)), DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F05 INCONCLUSIVE: mod before created
    list(id = "F05", expected = "INCONCLUSIVE", in_set = TRUE,
         SR_NUMBER = "FIX-F05", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(5 * 24)), LAST_MODIFIED_DATE = fmt(ago(10 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F06 INCONCLUSIVE: thin type peer_n=8
    list(id = "F06", expected = "INCONCLUSIVE", in_set = TRUE,
         SR_NUMBER = "FIX-F06", SR_SHORT_CODE = "RARETYPE", SR_TYPE = "Rare",
         STATUS = "Open", CREATED_DATE = fmt(ago(30 * 24)), LAST_MODIFIED_DATE = fmt(ago(20 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F07 Out of set: DUPLICATE=true
    list(id = "F07", expected = "OUT_OF_SET", in_set = FALSE,
         SR_NUMBER = "FIX-F07", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(400 * 24)), LAST_MODIFIED_DATE = fmt(ago(400 * 24)),
         CLOSED_DATE = "", DUPLICATE = "true", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F08 Out of set: LEGACY
    list(id = "F08", expected = "OUT_OF_SET", in_set = FALSE,
         SR_NUMBER = "FIX-F08", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(25 * 24)), LAST_MODIFIED_DATE = fmt(ago(20 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "true", PARENT_SR_NUMBER = ""),
    # F09 INCONCLUSIVE: nonblank unresolved parent
    list(id = "F09", expected = "INCONCLUSIVE", in_set = TRUE,
         SR_NUMBER = "FIX-F09", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(25 * 24)), LAST_MODIFIED_DATE = fmt(ago(20 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = "MISSING-PARENT-999"),
    # F10 STANDARD: peer_p75=3d, dormant 4d; 4 < 6
    list(id = "F10", expected = "STANDARD", in_set = TRUE,
         SR_NUMBER = "FIX-F10", SR_SHORT_CODE = "FASTTYPE", SR_TYPE = "Fast",
         STATUS = "Open", CREATED_DATE = fmt(ago(4 * 24)), LAST_MODIFIED_DATE = fmt(ago(4 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F11 ESCALATE: dormant 8d; 8 >= 6
    list(id = "F11", expected = "ESCALATE", in_set = TRUE,
         SR_NUMBER = "FIX-F11", SR_SHORT_CODE = "FASTTYPE", SR_TYPE = "Fast",
         STATUS = "Open", CREATED_DATE = fmt(ago(8 * 24)), LAST_MODIFIED_DATE = fmt(ago(8 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F12 No label: Completed
    list(id = "F12", expected = "OUT_OF_SET", in_set = FALSE,
         SR_NUMBER = "FIX-F12", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Completed", CREATED_DATE = fmt(ago(10 * 24)), LAST_MODIFIED_DATE = fmt(ago(2 * 24)),
         CLOSED_DATE = fmt(ago(1 * 24)), DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F13 INCONCLUSIVE: unparseable CREATED_DATE
    list(id = "F13", expected = "INCONCLUSIVE", in_set = TRUE,
         SR_NUMBER = "FIX-F13", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = "NOT-A-DATE", LAST_MODIFIED_DATE = fmt(ago(5 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    # F14a/b: two independent STANDARD-ish coherent rows (both labeled)
    list(id = "F14a", expected = "STANDARD", in_set = TRUE, fixture_group = "F14",
         SR_NUMBER = "FIX-F14A", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(3 * 24)), LAST_MODIFIED_DATE = fmt(ago(2 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = ""),
    list(id = "F14b", expected = "STANDARD", in_set = TRUE, fixture_group = "F14",
         SR_NUMBER = "FIX-F14B", SR_SHORT_CODE = "POTHOLE", SR_TYPE = "Pothole",
         STATUS = "Open", CREATED_DATE = fmt(ago(4 * 24)), LAST_MODIFIED_DATE = fmt(ago(1 * 24)),
         CLOSED_DATE = "", DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = "")
  )

  open_df <- bind_rows(lapply(rows, function(r) {
    as_tibble(r[c(
      "SR_NUMBER", "SR_SHORT_CODE", "SR_TYPE", "STATUS", "CREATED_DATE",
      "LAST_MODIFIED_DATE", "CLOSED_DATE", "DUPLICATE", "LEGACY_RECORD", "PARENT_SR_NUMBER"
    )])
  }))
  meta <- bind_rows(lapply(rows, function(r) {
    tibble(
      fixture_id = r$id,
      fixture_group = if (!is.null(r$fixture_group)) r$fixture_group else r$id,
      SR_NUMBER = r$SR_NUMBER,
      expected = r$expected,
      in_set = r$in_set
    )
  }))
  list(open = open_df, peers = peers, meta = meta)
}

run_fixtures <- function(out_dir) {
  pack <- build_fixture_pack()
  judged <- classify_open_rows(pack$open, pack$peers)
  # Map observed label: excluded → OUT_OF_SET
  observed <- judged %>%
    mutate(
      observed = dplyr::case_when(
        .exclude ~ "OUT_OF_SET",
        is.na(classification) ~ "OUT_OF_SET",
        TRUE ~ classification
      )
    ) %>%
    select(SR_NUMBER, observed, classification, dormant_h, peer_n, peer_p75_h, integrity_clause)

  # Per-fixture rows (F14 is group pass if both labeled independently)
  detail <- pack$meta %>%
    left_join(observed, by = "SR_NUMBER") %>%
    mutate(
      pass = observed == expected
    )

  # Collapse F14 to one fixture result: both must pass and both in decision set with labels
  f14 <- detail %>% filter(fixture_group == "F14")
  f14_pass <- nrow(f14) == 2 && all(f14$pass) && all(f14$observed != "OUT_OF_SET")

  results <- detail %>%
    filter(fixture_group != "F14") %>%
    transmute(
      fixture_id = fixture_group,
      expected,
      observed,
      pass,
      dormant_h,
      peer_p75_h,
      integrity_clause,
      notes = ""
    ) %>%
    bind_rows(tibble(
      fixture_id = "F14",
      expected = "TWO_INDEPENDENT_LABELS",
      observed = if (f14_pass) "TWO_INDEPENDENT_LABELS" else paste(f14$observed, collapse = ","),
      pass = f14_pass,
      dormant_h = NA_real_,
      peer_p75_h = NA_real_,
      integrity_clause = paste(f14$integrity_clause, collapse = ";"),
      notes = paste(f14$SR_NUMBER, f14$observed, sep = "=", collapse = "; ")
    )) %>%
    arrange(fixture_id)

  # Ensure F01–F14 present
  stopifnot(all(sprintf("F%02d", 1:14) %in% results$fixture_id))

  out_path <- file.path(out_dir, "RA_fixture_results.csv")
  readr::write_csv(results, out_path)
  message("Wrote ", out_path, " pass=", sum(results$pass), "/", nrow(results))
  print(results %>% select(fixture_id, expected, observed, pass), n = 20)
  invisible(results)
}

# ---- Production run (C24V3 CHUNKED: row-wise exact; see ABLATION_SPEC_V3) -----
# Only run_production() differs from the frozen run_RA.R. classify_open_rows(), constants, parsing and fixtures are unchanged.
# Every judgment is row-local (peer stats are a separate small table), so chunk results concatenate to the whole-table result.
run_production <- function(source_dir, out_dir, max_wait_sec = as.integer(Sys.getenv("RA_SOURCE_WAIT_SEC", "900"))) {
  paths <- poll_source_files(source_dir, max_wait_sec = max_wait_sec)
  chunk_rows <- as.integer(Sys.getenv("C24_CHUNK_ROWS", "250000"))
  peer_df <- if (grepl("\\.csv$", paths$peer, ignore.case = TRUE)) {
    readr::read_tsv(paths$peer, show_col_types = FALSE, guess_max = 100000, progress = FALSE)
  } else {
    readr::read_tsv(paths$peer, show_col_types = FALSE, guess_max = 100000)
  }
  hdr <- names(readr::read_tsv(paths$open, n_max = 0, col_types = readr::cols(.default = readr::col_character()), show_col_types = FALSE, progress = FALSE))
  ct <- do.call(readr::cols, stats::setNames(rep(list(readr::col_character()), length(hdr)), hdr))
  class_path <- file.path(out_dir, "RA_classifications.csv")
  part_path <- paste0(class_path, ".partial")
  if (file.exists(part_path)) file.remove(part_path)
  st <- new.env(); st$first <- TRUE; st$n_in <- 0L; st$n_dec <- 0L; st$esc <- 0L; st$inc <- 0L; st$std <- 0L; st$chunks <- 0L
  cb <- readr::SideEffectChunkCallback$new(function(x, pos) {
    judged_all <- classify_open_rows(x, peer_df)
    decision <- judged_all %>% filter(!.exclude) %>% select(-.exclude)
    readr::write_csv(decision, part_path, append = !st$first)
    st$first <- FALSE
    st$n_in <- st$n_in + nrow(x)
    st$n_dec <- st$n_dec + nrow(decision)
    st$esc <- st$esc + sum(decision$classification == "ESCALATE", na.rm = TRUE)
    st$inc <- st$inc + sum(decision$classification == "INCONCLUSIVE", na.rm = TRUE)
    st$std <- st$std + sum(decision$classification == "STANDARD", na.rm = TRUE)
    st$chunks <- st$chunks + 1L
    message("chunk ", st$chunks, " pos=", pos, " in=", st$n_in, " decision=", st$n_dec)
    invisible(NULL)
  })
  readr::read_tsv_chunked(paths$open, callback = cb, chunk_size = chunk_rows, col_types = ct, progress = FALSE)
  message("open_n=", st$n_in, " peer_types=", nrow(peer_df), " chunks=", st$chunks, " chunk_rows=", chunk_rows)
  stopifnot(st$n_dec > 0)
  file.rename(part_path, class_path)
  message("Wrote ", class_path, " n=", st$n_dec)

  portfolio_wide <- tibble(
    n_decision = st$n_dec,
    n_ESCALATE = st$esc,
    n_INCONCLUSIVE = st$inc,
    n_STANDARD = st$std,
    kappa = KAPPA,
    rule_version = RULE_VERSION,
    t_freeze = format(T_FREEZE, "%Y-%m-%d %H:%M:%S %Z")
  )
  port_path <- file.path(out_dir, "RA_portfolio_counts.csv")
  readr::write_csv(portfolio_wide, port_path)
  message("Wrote ", port_path)
  print(portfolio_wide)
  invisible(list(portfolio = portfolio_wide))
}

# ---- Main -------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) tolower(args[[1]]) else "all"

fixture_results <- NULL
prod <- NULL

if (mode %in% c("fixtures", "all", "fixture")) {
  fixture_results <- run_fixtures(OUT_DIR)
  f03 <- fixture_results %>% filter(fixture_id == "F03")
  if (nrow(f03) != 1 || isFALSE(f03$pass[[1]]) || f03$expected[[1]] != "STANDARD") {
    stop("F03 must be STANDARD and pass; got: ", paste(f03$observed, collapse = ","))
  }
}

if (mode %in% c("production", "all", "prod")) {
  wait <- as.integer(Sys.getenv("RA_SOURCE_WAIT_SEC", if (mode == "all") "120" else "900"))
  prod <- tryCatch(
    run_production(SOURCE_DIR, OUT_DIR, max_wait_sec = wait),
    error = function(e) {
      message("Production skipped/failed: ", conditionMessage(e))
      NULL
    }
  )
  if (mode == "production" && is.null(prod)) stop("Production required but failed.")
}

message("R-A done. mode=", mode)
