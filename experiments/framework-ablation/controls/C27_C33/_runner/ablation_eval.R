#!/usr/bin/env Rscript
# C27/C33 ablation evaluator (read-only on inputs). Two modes:
#   Rscript ablation_eval.R summarize <WORK_ROOT> <FROZEN_ROOT>
# Reads arm outputs written by run_ablations.ps1 and writes, per control,
#   <WORK_ROOT>/<CID>/evidence/<CID>_RESULTS.md and <CID>_results.json and recon CSVs,
# plus <WORK_ROOT>/RUN_SUMMARY.txt. Recon logic = frozen recon/run_recon.R
# (full join on sr_number, compare classification), extended with clock-field deltas.
suppressPackageStartupMessages({ library(readr); library(dplyr) })
args <- commandArgs(trailingOnly = TRUE)
stopifnot(length(args) >= 3, args[[1]] == "summarize")
W <- normalizePath(args[[2]], winslash = "/"); FZ <- normalizePath(args[[3]], winslash = "/")

rd <- function(p) {
  if (!file.exists(p)) return(NULL)
  d <- read_csv(p, col_types = cols(.default = col_character()), progress = FALSE)
  names(d) <- tolower(names(d))
  d %>% transmute(sr_number, classification,
                  dormant_h = suppressWarnings(as.numeric(dormant_h)),
                  open_age_h = suppressWarnings(as.numeric(open_age_h)))
}
recon <- function(ra, rb) {
  if (is.null(ra) || is.null(rb)) return(tibble(n_ra = NA, n_rb = NA, n_inner = NA, n_only_ra = NA, n_only_rb = NA, n_agree = NA, n_disagree = NA))
  j <- full_join(ra %>% select(sr_number, class_ra = classification),
                 rb %>% select(sr_number, class_rb = classification), by = "sr_number")
  tibble(n_ra = nrow(ra), n_rb = nrow(rb),
         n_inner = sum(!is.na(j$class_ra) & !is.na(j$class_rb)),
         n_only_ra = sum(!is.na(j$class_ra) & is.na(j$class_rb)),
         n_only_rb = sum(is.na(j$class_ra) & !is.na(j$class_rb)),
         n_agree = sum(j$class_ra == j$class_rb, na.rm = TRUE),
         n_disagree = sum(j$class_ra != j$class_rb, na.rm = TRUE))
}
disagree_pairs <- function(ra, rb) {
  if (is.null(ra) || is.null(rb)) return(tibble())
  inner_join(ra %>% select(sr_number, a = classification), rb %>% select(sr_number, b = classification), by = "sr_number") %>%
    filter(a != b) %>% count(a, b, name = "n")
}
# compare an ablated path's output against the same path's contract/clean output ("truth" = control-on arm)
vs_truth <- function(x, t) {
  if (is.null(x) || is.null(t)) return(tibble(n_x = NA, n_truth = NA, n_only_x = NA, n_only_truth = NA, n_label_diff = NA,
                                              n_dormant_diff = NA, max_abs_d_dormant_h = NA, max_abs_d_open_age_h = NA))
  j <- full_join(x %>% rename_with(~paste0(.x, "_x"), -sr_number), t %>% rename_with(~paste0(.x, "_t"), -sr_number), by = "sr_number")
  both <- j %>% filter(!is.na(classification_x), !is.na(classification_t))
  dd <- abs(both$dormant_h_x - both$dormant_h_t); da <- abs(both$open_age_h_x - both$open_age_h_t)
  tibble(n_x = nrow(x), n_truth = nrow(t),
         n_only_x = sum(!is.na(j$classification_x) & is.na(j$classification_t)),
         n_only_truth = sum(is.na(j$classification_x) & !is.na(j$classification_t)),
         n_label_diff = sum(both$classification_x != both$classification_t),
         n_dormant_diff = sum(dd > 1e-6, na.rm = TRUE),
         max_abs_d_dormant_h = suppressWarnings(round(max(dd, na.rm = TRUE), 6)),
         max_abs_d_open_age_h = suppressWarnings(round(max(da, na.rm = TRUE), 6)))
}
portfolio <- function(x) if (is.null(x)) tibble(n_decision = NA, ESCALATE = NA, INCONCLUSIVE = NA, STANDARD = NA) else
  tibble(n_decision = nrow(x), ESCALATE = sum(x$classification == "ESCALATE"),
         INCONCLUSIVE = sum(x$classification == "INCONCLUSIVE"), STANDARD = sum(x$classification == "STANDARD"))
fixt <- function(p) {
  if (!file.exists(p)) return(list(n_pass = NA, n = NA, failed = "MISSING_FILE"))
  f <- read_csv(p, col_types = cols(.default = col_character()), progress = FALSE)
  ps <- toupper(f$pass) == "TRUE"
  list(n_pass = sum(ps), n = nrow(f), failed = if (all(ps)) "" else paste(f$fixture_id[!ps], collapse = ";"))
}
runinfo <- function(cid, arm, path) {
  p <- file.path(W, cid, "arms", arm, paste0("RUN_", path, ".exit"))
  if (!file.exists(p)) return(list(exit = NA, secs = NA))
  v <- strsplit(trimws(readLines(p, warn = FALSE)[1]), ",")[[1]]
  list(exit = as.integer(v[1]), secs = as.numeric(v[2]))
}
out_ra <- function(cid, arm) file.path(W, cid, "arms", arm, "R-A", "outputs", "RA_classifications.csv")
out_rb <- function(cid, arm) file.path(W, cid, "arms", arm, "R-B", "outputs", "RB_classifications.csv")
fx_ra  <- function(cid, arm) file.path(W, cid, "arms", arm, "R-A", "outputs", "RA_fixture_results.csv")
fx_rb  <- function(cid, arm) file.path(W, cid, "arms", arm, "R-B", "outputs", "RB_fixture_results.csv")
md_tbl <- function(df) {
  df <- as.data.frame(df, stringsAsFactors = FALSE)
  h <- paste0("| ", paste(names(df), collapse = " | "), " |")
  s <- paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|")
  r <- apply(df, 1, function(z) paste0("| ", paste(ifelse(is.na(z), "NA", trimws(format(z, scientific = FALSE))), collapse = " | "), " |"))
  c(h, s, r)
}
frozen_ra <- rd(file.path(FZ, "R-A", "outputs", "RA_classifications.csv"))
frozen_rb <- rd(file.path(FZ, "R-B", "outputs", "RB_classifications.csv"))
preflight <- if (file.exists(file.path(W, "PREFLIGHT.txt"))) readLines(file.path(W, "PREFLIGHT.txt"), warn = FALSE) else "PREFLIGHT.txt MISSING"
summary_lines <- c(paste0("RUN_SUMMARY C27_C33  written ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")), "", "## PREFLIGHT", preflight, "")

# ============================ C33 ============================
cid <- "C33"; ev <- file.path(W, cid, "evidence"); dir.create(ev, recursive = TRUE, showWarnings = FALSE)
B_ra <- rd(out_ra(cid, "B")); B_rb <- rd(out_rb(cid, "B")); X_rb <- rd(out_rb(cid, "X1")); X2_ra <- rd(out_ra(cid, "X2"))
runs33 <- bind_rows(lapply(list(c("B","RA"), c("B","RB"), c("X1","RB"), c("X2","RA")), function(a) {
  ri <- runinfo(cid, a[1], a[2]); fx <- fixt(if (a[2] == "RA") fx_ra(cid, a[1]) else fx_rb(cid, a[1]))
  tibble(arm = a[1], path = a[2], code = c(B_RA = "frozen R-A", B_RB = "frozen R-B", X1_RB = "R-B pre-contract parser (historical 12:56 CT 2026-09-19)", X2_RA = "R-A seeded no-contract parser")[paste0(a[1], "_", a[2])],
         exit = ri$exit, secs = ri$secs, fixtures_pass = paste0(fx$n_pass, "/", fx$n), fixtures_failed = fx$failed)
}))
rec33 <- bind_rows(
  recon(B_ra, B_rb) %>% mutate(pair = "B: R-A(frozen) vs R-B(frozen) [contract ON both]", .before = 1),
  recon(B_ra, X_rb) %>% mutate(pair = "X1: R-A(frozen) vs R-B(pre-contract) [contract OFF on R-B]", .before = 1),
  recon(X2_ra, X_rb) %>% mutate(pair = "X2: R-A(seeded no-contract) vs R-B(pre-contract) [contract OFF both]", .before = 1))
tru33 <- bind_rows(
  vs_truth(B_ra, frozen_ra) %>% mutate(cmp = "B R-A vs frozen RA_classifications (repro check)", .before = 1),
  vs_truth(B_rb, frozen_rb) %>% mutate(cmp = "B R-B vs frozen RB_classifications (repro check)", .before = 1),
  vs_truth(X_rb, B_rb) %>% mutate(cmp = "X1/X2 R-B(pre-contract) vs B R-B(contract)", .before = 1),
  vs_truth(X2_ra, B_ra) %>% mutate(cmp = "X2 R-A(no-contract) vs B R-A(contract)", .before = 1))
port33 <- bind_rows(portfolio(B_ra) %>% mutate(run = "B R-A", .before = 1), portfolio(B_rb) %>% mutate(run = "B R-B", .before = 1),
                    portfolio(X_rb) %>% mutate(run = "X1 R-B(pre-contract)", .before = 1), portfolio(X2_ra) %>% mutate(run = "X2 R-A(no-contract)", .before = 1))
dp33 <- bind_rows(disagree_pairs(B_ra, X_rb) %>% mutate(pair = "X1", .before = 1), disagree_pairs(X2_ra, X_rb) %>% mutate(pair = "X2", .before = 1))
write_csv(runs33, file.path(ev, "C33_runs.csv")); write_csv(rec33, file.path(ev, "C33_recon.csv"))
write_csv(tru33, file.path(ev, "C33_vs_contract.csv")); write_csv(port33, file.path(ev, "C33_portfolio.csv")); write_csv(dp33, file.path(ev, "C33_disagree_pairs.csv"))
if (!is.null(B_rb) && !is.null(X_rb)) {
  mis <- inner_join(X_rb %>% select(sr_number, class_ablated = classification, dormant_h_ablated = dormant_h),
                    B_rb %>% select(sr_number, class_contract = classification, dormant_h_contract = dormant_h), by = "sr_number") %>% filter(class_ablated != class_contract)
  write_csv(mis, file.path(ev, "C33_X1_RB_label_flips.csv"))
}
repro33 <- isTRUE(all(tru33$n_label_diff[1:2] == 0) && all(tru33$n_only_x[1:2] == 0) && all(tru33$n_only_truth[1:2] == 0) && isTRUE(rec33$n_disagree[1] == 0) && isTRUE(rec33$n_only_ra[1] == 0) && isTRUE(rec33$n_only_rb[1] == 0))
allran33 <- isTRUE(all(runs33$exit == 0))
mis_total <- sum(tru33$n_label_diff[3:4], na.rm = TRUE)
mech33 <- c(
  paste0("H1 all four runs exit 0: ", allran33),
  paste0("H2 contract arm B reproduces frozen labels (0 label diffs, 0 only-rows vs frozen RA/RB; recon 0 disagree): ", repro33),
  paste0("H3 label flips vs contract arm: X1/X2 R-B=", tru33$n_label_diff[3], "; X2 R-A=", tru33$n_label_diff[4], " (total ", mis_total, ")"),
  paste0("H4 clock-field shift vs contract arm: R-B rows with |d dormant_h|>1e-6 = ", tru33$n_dormant_diff[3], " (max ", tru33$max_abs_d_dormant_h[3], " h); R-A = ", tru33$n_dormant_diff[4], " (max ", tru33$max_abs_d_dormant_h[4], " h)"),
  paste0("H5 cross-path recon detects the ablated defect: X1 n_disagree=", rec33$n_disagree[2], "; X2 n_disagree=", rec33$n_disagree[3]),
  paste0("H6 fixtures detect the ablated defect: ", paste(paste0(runs33$arm, "-", runs33$path, " ", runs33$fixtures_pass), collapse = "; ")))
c33 <- c("# C33 RESULTS — Naive Clock Contract ablation (runner output, mechanical facts only)", "",
  "Contract = naive SQL clocks read as character and parsed as America/Chicago wall time. Truth reference = arm B (contract ON).", "",
  "## Mechanical facts", paste0("- ", mech33), "", "## Runs", md_tbl(runs33), "", "## Reconciliation (frozen recon logic: full join on sr_number, compare classification)", md_tbl(rec33), "",
  "## Ablated paths vs contract arm (and repro vs frozen pack)", md_tbl(tru33), "", "## Portfolio", md_tbl(port33), "",
  "## Disagreeing label pairs (R-A label a vs R-B label b)", if (nrow(dp33)) md_tbl(dp33) else "(none)", "")
writeLines(c33, file.path(ev, "C33_RESULTS.md"), useBytes = TRUE)
summary_lines <- c(summary_lines, "## C33", mech33, "")

# ============================ C27 ============================
cid <- "C27"; ev <- file.path(W, cid, "evidence"); dir.create(ev, recursive = TRUE, showWarnings = FALSE)
B_ra <- rd(out_ra(cid, "B")); B_rb <- rd(out_rb(cid, "B"))
mut <- read_tsv(file.path(W, "runner", "seeds", "C27", "MUTANTS.tsv"), col_types = cols(.default = col_character()), progress = FALSE)
fxa <- fixt(fx_ra(cid, "B")); fxb <- fixt(fx_rb(cid, "B")); riA <- runinfo(cid, "B", "RA"); riB <- runinfo(cid, "B", "RB")
base_rec <- recon(B_ra, B_rb)
rows <- lapply(seq_len(nrow(mut)), function(i) {
  m <- mut$mutant_id[i]; x <- rd(out_rb(cid, m)); ri <- runinfo(cid, m, "RB"); fx <- fixt(fx_rb(cid, m)); r <- recon(B_ra, x); t <- vs_truth(x, B_rb)
  crashed <- is.na(ri$exit) || ri$exit != 0 || is.null(x)
  det_fix <- crashed || is.na(fx$n_pass) || fx$n_pass < fx$n
  det_rec <- crashed || isTRUE((r$n_only_ra + r$n_only_rb + r$n_disagree) > 0)
  tibble(mutant = m, rule_removed = mut$description[i], exit = ri$exit, rb_fixtures = paste0(fx$n_pass, "/", fx$n), rb_fixtures_failed = fx$failed,
         recon_n_rb = r$n_rb, recon_only_ra = r$n_only_ra, recon_only_rb = r$n_only_rb, recon_disagree = r$n_disagree,
         prod_rows_changed_vs_clean_RB = if (is.na(t$n_label_diff)) NA else t$n_label_diff + t$n_only_x + t$n_only_truth,
         detected_baseline_regime = det_fix, detected_ablated_regime = det_rec)
})
mt <- bind_rows(rows)
write_csv(mt, file.path(ev, "C27_mutants.csv"))
tru27 <- bind_rows(vs_truth(B_ra, frozen_ra) %>% mutate(cmp = "B R-A vs frozen RA_classifications", .before = 1),
                   vs_truth(B_rb, frozen_rb) %>% mutate(cmp = "B R-B vs frozen RB_classifications", .before = 1))
write_csv(tru27, file.path(ev, "C27_repro.csv")); write_csv(base_rec, file.path(ev, "C27_baseline_recon.csv"))
repro27 <- isTRUE(all(tru27$n_label_diff == 0) && all(tru27$n_only_x == 0) && all(tru27$n_only_truth == 0) && base_rec$n_disagree == 0 && base_rec$n_only_ra == 0 && base_rec$n_only_rb == 0)
Dfix <- mt$mutant[mt$detected_baseline_regime]; Dabl <- mt$mutant[mt$detected_ablated_regime]
gap <- setdiff(Dfix, Dabl)
mech27 <- c(
  paste0("H1 clean arm B: R-A exit ", riA$exit, ", R-B exit ", riB$exit, "; fixtures R-A ", fxa$n_pass, "/", fxa$n, ", R-B ", fxb$n_pass, "/", fxb$n),
  paste0("H2 clean arm reproduces frozen labels and recon 0/0/0: ", repro27),
  paste0("H3 all ", nrow(mut), " mutant runs present (exit recorded): ", all(!is.na(mt$exit))),
  paste0("H4 D_fix (caught by R-B's own fixtures = baseline regime): {", paste(Dfix, collapse = ","), "}"),
  paste0("H5 D_abl (caught with R-B fixtures skipped: R-A fixtures + exact recon vs R-A, or crash): {", paste(Dabl, collapse = ","), "}"),
  paste0("H6 D_fix minus D_abl (defects only the second-path fixture run catches): {", paste(gap, collapse = ","), "}"),
  paste0("H7 caught by neither regime: {", paste(mt$mutant[!mt$detected_baseline_regime & !mt$detected_ablated_regime], collapse = ","), "}"))
c27 <- c("# C27 RESULTS — Fixtures on Both Paths ablation (runner output, mechanical facts only)", "",
  "Baseline regime: both R-A and R-B must pass the 14 fixtures before production is trusted. Ablated regime: only R-A's fixtures run; R-B is trusted if exact recon vs R-A is clean.",
  "Seeds: 9 single-rule deletions in R-B 20_integrity_and_classify.R, one per fixture-protected rule (frozen before the run; see seed diffs).", "",
  "## Mechanical facts", paste0("- ", mech27), "", "## Clean arm repro vs frozen pack", md_tbl(tru27), "", "## Clean arm recon", md_tbl(base_rec), "",
  "## Mutants", md_tbl(mt), "")
writeLines(c27, file.path(ev, "C27_RESULTS.md"), useBytes = TRUE)
summary_lines <- c(summary_lines, "## C27", mech27, "", "Per-control evidence: C33\\evidence\\C33_RESULTS.md, C27\\evidence\\C27_RESULTS.md")
writeLines(summary_lines, file.path(W, "RUN_SUMMARY.txt"), useBytes = TRUE)
cat(summary_lines, sep = "\n")
