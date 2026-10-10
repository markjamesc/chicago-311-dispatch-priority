suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})
ra <- read_csv("C:/Users/Mark/Documents/R Working Directory/chicago311/R-A/outputs/RA_classifications.csv", show_col_types = FALSE)
rb <- read_csv("C:/Users/Mark/Documents/R Working Directory/chicago311/R-B/outputs/RB_classifications.csv", show_col_types = FALSE)
names(ra) <- tolower(names(ra))
names(rb) <- tolower(names(rb))
cat("RA cols: ", paste(names(ra), collapse=","), "\n")
cat("RB cols: ", paste(names(rb), collapse=","), "\n")
ra2 <- ra %>% transmute(sr_number = as.character(sr_number), class_ra = classification)
rb2 <- rb %>% transmute(sr_number = as.character(sr_number), class_rb = classification)
j <- full_join(ra2, rb2, by = "sr_number")
summary <- tibble(
  n_ra = nrow(ra2),
  n_rb = nrow(rb2),
  n_inner = sum(!is.na(j$class_ra) & !is.na(j$class_rb)),
  n_only_ra = sum(!is.na(j$class_ra) & is.na(j$class_rb)),
  n_only_rb = sum(is.na(j$class_ra) & !is.na(j$class_rb)),
  n_agree = sum(j$class_ra == j$class_rb, na.rm = TRUE),
  n_disagree = sum(j$class_ra != j$class_rb, na.rm = TRUE)
)
write_csv(summary, "C:/Users/Mark/Documents/R Working Directory/chicago311/recon/RECON_SUMMARY.csv")
disagree <- j %>% filter(!is.na(class_ra), !is.na(class_rb), class_ra != class_rb)
write_csv(disagree, "C:/Users/Mark/Documents/R Working Directory/chicago311/recon/RECON_DISAGREE_IDS.csv")
print(summary)
print(count(disagree, class_ra, class_rb))
ra_a <- ra %>% select(any_of(c("sr_number","classification","type_key","dormant_h","peer_n","peer_p75_h","integrity_clause","open_age_h","kappa","age_days","dormancy_ratio","action","mod_ts","created_ts")))
rb_a <- rb %>% select(any_of(c("sr_number","classification","type_key","dormant_h","peer_n","peer_p75_h","integrity_clause","open_age_h","kappa","evidence_reason","age_days","dormancy_ratio","action","mod_ts","created_ts")))
diag <- disagree %>%
  left_join(ra_a, by = "sr_number", suffix = c("", "_x")) %>%
  left_join(rb_a, by = "sr_number", suffix = c("_ra", "_rb"))
write_csv(diag, "C:/Users/Mark/Documents/R Working Directory/chicago311/recon/RECON_DISAGREE_DIAG.csv")
cat("wrote recon; disagree n=", nrow(disagree), "\n")