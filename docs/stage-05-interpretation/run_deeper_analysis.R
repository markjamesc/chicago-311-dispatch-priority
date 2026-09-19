# Stage 5 deeper analysis — frozen pack only (Mode None)
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(stringr)
})

root <- "C:/Users/Mark/Documents/R Working Directory/chicago311"
out <- file.path(root, "stage-05", "deeper")
dir.create(out, recursive = TRUE, showWarnings = FALSE)

ra <- read_csv(file.path(root, "R-A/outputs/RA_classifications.csv"), show_col_types = FALSE)
names(ra) <- tolower(names(ra))
val <- read_csv(file.path(root, "outputs/validated_action_list.csv"), show_col_types = FALSE)
kappa_grid <- read_csv(file.path(root, "R-B/outputs/RB_kappa_grid_counts.csv"), show_col_types = FALSE)

# Independent checks vs freeze
chk <- tibble(
  check = c("n_decision", "n_ESCALATE", "n_INCONCLUSIVE", "n_STANDARD", "validated_action_list_n"),
  expected = c(222002L, 131968L, 6377L, 83657L, 131968L),
  observed = c(
    nrow(ra),
    sum(ra$classification == "ESCALATE"),
    sum(ra$classification == "INCONCLUSIVE"),
    sum(ra$classification == "STANDARD"),
    nrow(val)
  )
) %>% mutate(pass = expected == observed)
write_csv(chk, file.path(out, "independent_checks_critical_counts.csv"))
stopifnot(all(chk$pass))

portfolio <- ra %>%
  summarise(
    n_decision = n(),
    n_ESCALATE = sum(classification == "ESCALATE"),
    n_INCONCLUSIVE = sum(classification == "INCONCLUSIVE"),
    n_STANDARD = sum(classification == "STANDARD"),
    pct_ESCALATE = n_ESCALATE / n_decision,
    pct_INCONCLUSIVE = n_INCONCLUSIVE / n_decision,
    pct_STANDARD = n_STANDARD / n_decision,
    kappa = 2
  )
write_csv(portfolio, file.path(out, "portfolio_summary.csv"))

esc_by_type <- ra %>%
  filter(classification == "ESCALATE") %>%
  count(type_key, name = "n_ESCALATE") %>%
  arrange(desc(n_ESCALATE)) %>%
  mutate(
    share_of_escalate = n_ESCALATE / sum(n_ESCALATE),
    cum_share = cumsum(share_of_escalate)
  )
write_csv(esc_by_type, file.path(out, "escalate_by_type.csv"))
write_csv(head(esc_by_type, 25), file.path(out, "escalate_by_type_top25.csv"))

inc_by_clause <- ra %>%
  filter(classification == "INCONCLUSIVE") %>%
  count(integrity_clause, name = "n") %>%
  arrange(desc(n)) %>%
  mutate(share = n / sum(n))
write_csv(inc_by_clause, file.path(out, "inconclusive_by_clause.csv"))

# dormancy diagnostics on ESCALATE
esc_diag <- ra %>%
  filter(classification == "ESCALATE") %>%
  summarise(
    n = n(),
    dormant_h_p50 = median(dormant_h, na.rm = TRUE),
    dormant_h_p75 = quantile(dormant_h, 0.75, na.rm = TRUE),
    dormant_h_p90 = quantile(dormant_h, 0.90, na.rm = TRUE),
    open_age_h_p50 = median(open_age_h, na.rm = TRUE),
    peer_n_p50 = median(peer_n, na.rm = TRUE)
  )
write_csv(esc_diag, file.path(out, "escalate_dormancy_summary.csv"))

write_csv(kappa_grid, file.path(out, "kappa_sensitivity.csv"))

# Capacity note (no ranking): ESCALATE volume vs illustrative shift budgets
cap <- tibble(
  label = c("illustrative_shift_50", "illustrative_shift_200", "illustrative_shift_1000", "full_escalate_portfolio"),
  attention_slots = c(50, 200, 1000, 131968),
  escalate_n = 131968,
  coverage = pmin(1, attention_slots / 131968),
  note = "FLAG only — RANKING_NOT_IN_SCOPE; excess ESCALATE returns to Framing if owner wants a hard cap"
)
write_csv(cap, file.path(out, "capacity_coverage_note.csv"))

cat("Stage 5 deeper analysis wrote to ", out, "\n", sep = "")
print(chk)
print(portfolio)
print(head(esc_by_type, 10))
print(inc_by_clause)
print(kappa_grid)