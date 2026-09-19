#!/usr/bin/env Rscript
# R-B — Independent judged path (RULE-TABLE / predicate-join construction)
# Stage 3 LOCKED: stage3_locked_design.json | fixtures-v0.1 (do not rewrite)
# No shared judged helpers with R-A. No copying ID lists.
# Portfolio simulation — NOT live City dispatch; knob 14 is NOT City SLA.

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(stringr)
  library(lubridate)
  library(jsonlite)
  library(tibble)
  library(purrr)
})

args <- commandArgs(trailingOnly = TRUE)
mode <- if (length(args) >= 1) args[[1]] else "fixtures"

T_FREEZE_RB <- as.POSIXct("2026-09-12T23:59:59", format = "%Y-%m-%dT%H:%M:%S", tz = "America/Chicago")
KNOB_DAYS <- 14L
DV <- "stage3-v0.1"
FV <- "fixtures-v0.1"
SID <- "chicago311-raw-frozen-2026-09-12"

blank_chr <- function(z) is.na(z) | gsub("^\\s+|\\s+$", "", as.character(z)) == ""

truthy_flag <- function(z) {
  tolower(gsub("^\\s+|\\s+$", "", as.character(z))) %in% c("true", "1", "yes", "y", "t")
}

to_ts <- function(z) {
  x <- as.character(z)
  a <- suppressWarnings(as.POSIXct(x, format = "%Y-%m-%d %H:%M:%S", tz = "America/Chicago"))
  b <- suppressWarnings(ymd_hms(x, tz = "America/Chicago", quiet = TRUE))
  ifelse(is.na(a), b, a) |> as.POSIXct(origin = "1970-01-01", tz = "America/Chicago")
}

judge_rb <- function(raw_tbl) {
  base <- raw_tbl %>%
    transmute(
      SR_NUMBER = as.character(SR_NUMBER),
      SR_TYPE = as.character(SR_TYPE),
      STATUS = as.character(STATUS),
      CREATED_DATE = as.character(CREATED_DATE),
      DUPLICATE = as.character(DUPLICATE),
      PARENT_SR_NUMBER = as.character(PARENT_SR_NUMBER),
      LEGACY_RECORD = as.character(LEGACY_RECORD)
    )

  # Predicate feature table (rule-table style)
  feats <- base %>%
    mutate(
      p_open = STATUS == "Open",
      p_blank_id = blank_chr(SR_NUMBER),
      p_blank_type = blank_chr(SR_TYPE),
      ts = to_ts(CREATED_DATE),
      p_created_ok = !blank_chr(CREATED_DATE) & !is.na(ts),
      p_info = !p_blank_type & SR_TYPE == "311 INFORMATION ONLY CALL",
      p_legacy = truthy_flag(LEGACY_RECORD),
      p_dup = truthy_flag(DUPLICATE),
      p_parent = !blank_chr(PARENT_SR_NUMBER),
      p_self_parent = p_parent & !p_blank_id & PARENT_SR_NUMBER == SR_NUMBER,
      p_contradict = (p_dup & !p_parent) | (p_parent & !p_dup) | p_self_parent,
      p_clean_child = (p_dup | p_parent) & !p_contradict,
      p_after = p_created_ok & (ts > T_FREEZE_RB),
      age = if_else(
        p_created_ok,
        as.integer(floor(as.numeric(T_FREEZE_RB - ts, units = "secs") / 86400)),
        NA_integer_
      )
    )

  # Exclusion rule table (priority order via join ranks)
  excl_rules <- tribble(
    ~rule, ~rank,
    "not_open", 1L,
    "blank_id", 2L,
    "blank_type", 3L,
    "bad_created", 4L,
    "info_only", 5L,
    "legacy", 6L,
    "duplicate_child", 7L
  )

  fired <- bind_rows(
    feats %>% filter(!p_open) %>% transmute(SR_NUMBER, rule = "not_open"),
    feats %>% filter(p_open, p_blank_id) %>% transmute(SR_NUMBER, rule = "blank_id"),
    feats %>% filter(p_open, !p_blank_id, p_blank_type) %>% transmute(SR_NUMBER, rule = "blank_type"),
    feats %>% filter(p_open, !p_blank_id, !p_blank_type, !p_created_ok) %>% transmute(SR_NUMBER, rule = "bad_created"),
    feats %>% filter(p_open, !p_blank_id, !p_blank_type, p_created_ok, p_info) %>% transmute(SR_NUMBER, rule = "info_only"),
    feats %>% filter(p_open, !p_blank_id, !p_blank_type, p_created_ok, !p_info, p_legacy) %>% transmute(SR_NUMBER, rule = "legacy"),
    feats %>% filter(p_open, !p_blank_id, !p_blank_type, p_created_ok, !p_info, !p_legacy, p_clean_child) %>%
      transmute(SR_NUMBER, rule = "duplicate_child")
  ) %>%
    left_join(excl_rules, by = "rule") %>%
    group_by(SR_NUMBER) %>%
    slice_min(order_by = rank, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    select(SR_NUMBER, exclusion_reason = rule)

  # Action rule table for eligible
  action_rules <- tribble(
    ~predicate, ~action, ~evidence_notes, ~prio,
    "contradict", "INCONCLUSIVE", "contradictory_duplicate_parent", 1L,
    "after_freeze", "INCONCLUSIVE", "created_after_freeze", 2L,
    "escalate", "ESCALATE", NA_character_, 3L,
    "standard", "STANDARD", NA_character_, 4L
  )

  with_excl <- feats %>%
    left_join(excl_rules %>% select(rule) %>% distinct() %>% mutate(dummy = 1), by = character()) %>%
    select(-dummy) %>%
    left_join(fired, by = "SR_NUMBER") %>%
    mutate(
      is_open = p_open,
      is_eligible = p_open & is.na(exclusion_reason),
      open_age_days = age
    )

  act_fire <- bind_rows(
    with_excl %>% filter(is_eligible, p_contradict) %>%
      transmute(SR_NUMBER, predicate = "contradict"),
    with_excl %>% filter(is_eligible, !p_contradict, p_after) %>%
      transmute(SR_NUMBER, predicate = "after_freeze"),
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, !is.na(age), age >= KNOB_DAYS) %>%
      transmute(SR_NUMBER, predicate = "escalate"),
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, !is.na(age), age < KNOB_DAYS) %>%
      transmute(SR_NUMBER, predicate = "standard"),
    # eligible but age NA shouldn't happen if created_ok; hold inconclusive
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, is.na(age)) %>%
      transmute(SR_NUMBER, predicate = "contradict") # won't match; fix below
  )

  # Fix NA-age eligible → INCONCLUSIVE via after_freeze-like path
  act_fire <- act_fire %>%
    filter(predicate != "contradict" | SR_NUMBER %in% (with_excl %>% filter(is_eligible, p_contradict) %>% pull(SR_NUMBER)))

  act_fire2 <- bind_rows(
    with_excl %>% filter(is_eligible, p_contradict) %>% transmute(SR_NUMBER, predicate = "contradict"),
    with_excl %>% filter(is_eligible, !p_contradict, p_after) %>% transmute(SR_NUMBER, predicate = "after_freeze"),
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, is.na(age)) %>% transmute(SR_NUMBER, predicate = "after_freeze"),
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, !is.na(age), age >= KNOB_DAYS) %>% transmute(SR_NUMBER, predicate = "escalate"),
    with_excl %>% filter(is_eligible, !p_contradict, !p_after, !is.na(age), age < KNOB_DAYS) %>% transmute(SR_NUMBER, predicate = "standard")
  ) %>%
    left_join(action_rules, by = "predicate") %>%
    group_by(SR_NUMBER) %>%
    slice_min(order_by = prio, n = 1, with_ties = FALSE) %>%
    ungroup()

  with_excl %>%
    left_join(act_fire2 %>% select(SR_NUMBER, action, evidence_notes), by = "SR_NUMBER") %>%
    mutate(
      selected = !is.na(action) & action == "ESCALATE",
      snapshot_id = SID,
      design_version = DV,
      fixture_version = FV,
      builder = "R-B-rule-table",
      simulation_label = "portfolio_simulation_not_live_dispatch"
    ) %>%
    select(
      SR_NUMBER, is_open, is_eligible, exclusion_reason, open_age_days,
      action, selected, evidence_notes,
      snapshot_id, design_version, fixture_version, builder, simulation_label
    )
}

run_fixtures_rb <- function(fixture_dir, out_csv) {
  files <- sort(list.files(fixture_dir, pattern = "^F[0-9]+\\.json$", full.names = TRUE))
  rows <- map_dfr(files, function(fp) {
    fx <- fromJSON(fp, simplifyVector = TRUE)
    judged <- judge_rb(as_tibble(fx$source_row))
    exp <- fx$expected
    exp_action <- if (is.null(exp$action) || (length(exp$action) == 1 && is.na(exp$action))) NA_character_ else as.character(exp$action)
    got_action <- if (is.na(judged$action[[1]])) NA_character_ else as.character(judged$action[[1]])
    ok <- identical(as.logical(judged$is_open[[1]]), as.logical(exp$is_open)) &&
      identical(as.logical(judged$is_eligible[[1]]), as.logical(exp$is_eligible)) &&
      identical(got_action, exp_action) &&
      identical(as.logical(judged$selected[[1]]), as.logical(exp$selected))
    if (!is.null(exp$open_age_days)) {
      ok <- ok && identical(as.integer(judged$open_age_days[[1]]), as.integer(exp$open_age_days))
    }
    if (!is.null(exp$exclusion_reason)) {
      ok <- ok && identical(as.character(judged$exclusion_reason[[1]]), as.character(exp$exclusion_reason))
    }
    tibble(
      fixture_id = fx$fixture_id, pass = ok,
      got_action = got_action, exp_action = exp_action,
      got_eligible = judged$is_eligible[[1]], exp_eligible = exp$is_eligible,
      got_age = judged$open_age_days[[1]], builder = "R-B"
    )
  })
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)
  write_csv(rows, out_csv)
  cat("R-B fixtures:", sum(rows$pass), "/", nrow(rows), "PASS\n")
  if (any(!rows$pass)) {
    print(rows %>% filter(!pass))
    quit(status = 1)
  }
  invisible(rows)
}

if (identical(mode, "fixtures")) {
  fixture_dir <- file.path("docs", "stage-03-measurement-design", "fixtures")
  out_csv <- file.path("validation", "fixtures", "r_b_fixture_results.csv")
  run_fixtures_rb(fixture_dir, out_csv)
} else if (identical(mode, "production")) {
  src_path <- args[[2]]
  out_path <- if (length(args) >= 3) args[[3]] else "outputs/r_b_judged.csv"
  src <- read_tsv(src_path, col_types = cols(.default = "c"), na = c("", "NA", "NULL"))
  judged <- judge_rb(src)
  eligible <- judged %>% filter(is_eligible)
  audit <- judged %>% filter(!is_eligible)
  dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)
  write_csv(eligible, out_path)
  write_csv(audit, sub("\\.csv$", "_exclusions.csv", out_path))
  cat("R-B production eligible_n=", nrow(eligible), " excluded_n=", nrow(audit), "\n", sep = "")
} else stop("Unknown mode")
