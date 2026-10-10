suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
})
d <- read_csv("C:/Users/Mark/Documents/R Working Directory/chicago311/recon/RECON_DISAGREE_DIAG.csv", show_col_types = FALSE)
cat("=== colnames ===\n"); print(names(d))
cat("\n=== head ===\n"); print(as.data.frame(head(d, 5)))
cat("\n=== type_key counts ===\n"); print(count(d, type_key_ra, type_key_rb) %>% arrange(desc(n)))
cat("\n=== integrity ===\n"); print(count(d, integrity_clause_ra, integrity_clause_rb))
cat("\n=== peer_n / peer_p75 compare ===\n")
d2 <- d %>% mutate(
  peer_n_eq = peer_n_ra == peer_n_rb,
  peer_p75_eq = abs(peer_p75_h_ra - peer_p75_h_rb) < 1e-6,
  dormant_eq = abs(dormant_h_ra - dormant_h_rb) < 1e-6,
  open_age_eq = abs(open_age_h_ra - open_age_h_rb) < 1e-6,
  kappa_eq = kappa_ra == kappa_rb,
  thr_ra = kappa_ra * peer_p75_h_ra,
  thr_rb = kappa_rb * peer_p75_h_rb,
  dormant_vs_thr_ra = dormant_h_ra - thr_ra,
  dormant_vs_thr_rb = dormant_h_rb - thr_rb
)
cat("peer_n_eq=", sum(d2$peer_n_eq, na.rm=TRUE), "/", nrow(d2), "\n")
cat("peer_p75_eq=", sum(d2$peer_p75_eq, na.rm=TRUE), "/", nrow(d2), "\n")
cat("dormant_eq=", sum(d2$dormant_eq, na.rm=TRUE), "/", nrow(d2), "\n")
cat("open_age_eq=", sum(d2$open_age_eq, na.rm=TRUE), "/", nrow(d2), "\n")
cat("kappa_eq=", sum(d2$kappa_eq, na.rm=TRUE), "/", nrow(d2), "\n")
cat("\n=== where peer_p75 differs ===\n")
print(summary(d2$peer_p75_h_ra - d2$peer_p75_h_rb))
cat("\n=== where dormant differs ===\n")
print(summary(d2$dormant_h_ra - d2$dormant_h_rb))
cat("\n=== dormant vs threshold (RA should be STANDARD => dormant < thr) ===\n")
print(summary(d2$dormant_vs_thr_ra))
print(summary(d2$dormant_vs_thr_rb))
cat("\n=== RA: dormant < thr? ===\n"); print(table(d2$dormant_h_ra < d2$thr_ra, useNA="ifany"))
cat("\n=== RB: dormant >= thr? ===\n"); print(table(d2$dormant_h_rb >= d2$thr_rb, useNA="ifany"))
cat("\n=== evidence_reason_rb ===\n"); print(count(d, evidence_reason_rb) %>% arrange(desc(n)))
# sample rows with key fields
samp <- d2 %>% select(sr_number, class_ra, class_rb, type_key_ra, dormant_h_ra, dormant_h_rb, peer_p75_h_ra, peer_p75_h_rb, thr_ra, thr_rb, dormant_vs_thr_ra, dormant_vs_thr_rb, peer_n_ra, peer_n_rb, integrity_clause_ra, integrity_clause_rb, evidence_reason_rb) %>% head(15)
print(as.data.frame(samp))
write_csv(d2, "C:/Users/Mark/Documents/R Working Directory/chicago311/recon/RECON_DISAGREE_ENRICHED.csv")