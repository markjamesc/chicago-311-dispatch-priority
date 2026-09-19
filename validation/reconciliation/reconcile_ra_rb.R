#!/usr/bin/env Rscript
# Exact R-A ↔ R-B reconciliation on critical fields
suppressPackageStartupMessages({ library(dplyr); library(readr) })
args <- commandArgs(trailingOnly = TRUE)
a_path <- if (length(args)>=1) args[[1]] else "outputs/r_a_judged.csv"
b_path <- if (length(args)>=2) args[[2]] else "outputs/r_b_judged.csv"
out_path <- if (length(args)>=3) args[[3]] else "validation/reconciliation/reconciliation.csv"

a <- read_csv(a_path, show_col_types = FALSE)
b <- read_csv(b_path, show_col_types = FALSE)
crit <- c("SR_NUMBER","is_open","is_eligible","action","selected")
stopifnot(all(crit %in% names(a)), all(crit %in% names(b)))

a2 <- a %>% select(all_of(crit), open_age_days) %>% arrange(SR_NUMBER)
b2 <- b %>% select(all_of(crit), open_age_days) %>% arrange(SR_NUMBER)

only_a <- setdiff(a2$SR_NUMBER, b2$SR_NUMBER)
only_b <- setdiff(b2$SR_NUMBER, a2$SR_NUMBER)
joined <- full_join(a2, b2, by="SR_NUMBER", suffix=c("_a","_b"))
mism <- joined %>% filter(
  is.na(is_open_a) | is.na(is_open_b) |
  is_open_a != is_open_b |
  is_eligible_a != is_eligible_b |
  !identical(as.character(action_a), as.character(action_b)) & !(is.na(action_a)&is.na(action_b)) |
  selected_a != selected_b |
  !identical(as.integer(open_age_days_a), as.integer(open_age_days_b)) & !(is.na(open_age_days_a)&is.na(open_age_days_b))
)
# Fix action compare properly
mism <- joined %>%
  mutate(
    action_a_n = if_else(is.na(action_a), "<NA>", as.character(action_a)),
    action_b_n = if_else(is.na(action_b), "<NA>", as.character(action_b)),
    bad = is.na(is_open_a) | is.na(is_open_b) |
      (is_open_a != is_open_b) |
      (is_eligible_a != is_eligible_b) |
      (action_a_n != action_b_n) |
      (selected_a != selected_b) |
      xor(is.na(open_age_days_a), is.na(open_age_days_b)) |
      (!is.na(open_age_days_a) & !is.na(open_age_days_b) & open_age_days_a != open_age_days_b)
  ) %>% filter(bad)

summary <- tibble(
  check = c("universe_n_a","universe_n_b","only_in_a","only_in_b","field_mismatches","exact_recon"),
  value = c(nrow(a2), nrow(b2), length(only_a), length(only_b), nrow(mism),
            if (length(only_a)==0 && length(only_b)==0 && nrow(mism)==0) "PASS" else "FAIL")
)
dir.create(dirname(out_path), recursive=TRUE, showWarnings=FALSE)
write_csv(summary, out_path)
if (nrow(mism)>0) write_csv(mism, sub("\\.csv$", "_mismatches.csv", out_path))
print(summary)
if (summary$value[summary$check=="exact_recon"] != "PASS") quit(status=1)
