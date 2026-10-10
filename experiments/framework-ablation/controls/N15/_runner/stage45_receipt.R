#!/usr/bin/env Rscript
# N15 C34 harness: write the Stage-4 receipt for one arm from its mechanical results, then the gate reads it.
# Usage: Rscript stage45_receipt.R <ARM_ROOT> <RUNNER_DIR>. Writes only under <ARM_ROOT>.
# Each mechanical field is PASS only if its own check passed in this arm:
#   r_a_status / r_b_status : RUN_<path>.exit == 0 and the classification output exists
#   r_a_fixtures / r_b_fixtures : every row of the path's fixture results has pass == TRUE
#   reconciliation : the frozen pack's recon practice (key set + classification), 0 only-RA, 0 only-RB, 0 disagreements
#   validation_gate : PASS only if all of the above pass (the owner approval would be withheld otherwise)
# Copied from the frozen 2026-09-19 receipt, not re-run: sql_source_gate, structural_cross_review, lineage_attestation (PASS).
# unresolved_issues = number of mechanical fields that are FAIL; status = PASS only if that number is 0.
suppressPackageStartupMessages({ library(jsonlite); library(readr) })
a <- commandArgs(trailingOnly = TRUE); stopifnot(length(a) == 2)
root <- normalizePath(a[[1]], winslash = "/"); H <- file.path(normalizePath(a[[2]], winslash = "/"), "stage45")
d12 <- file.path(root, "docs", "stage-01-02-start-framing"); d3 <- file.path(root, "docs", "stage-03-measurement-design"); d4 <- file.path(root, "docs", "stage-04-execution-validation")
for (d in c(d12, d3, d4)) dir.create(d, recursive = TRUE, showWarnings = FALSE)
file.copy(file.path(H, "stage1_decision.json"), d12); file.copy(file.path(H, "stage2_framing.json"), d12); file.copy(file.path(H, "stage3_locked_design.json"), d3)
ex <- function(p) { f <- file.path(root, paste0("RUN_", p, ".exit")); if (!file.exists(f)) return(NA_integer_); as.integer(strsplit(readLines(f, warn = FALSE)[1], ",")[[1]][1]) }
cls <- c(RA = "R-A/outputs/RA_classifications.csv", RB = "R-B/outputs/RB_classifications.csv")
fxf <- c(RA = "R-A/outputs/RA_fixture_results.csv", RB = "R-B/outputs/RB_fixture_results.csv")
st <- function(p) isTRUE(ex(p) == 0) && file.exists(file.path(root, cls[[p]]))
fx <- function(p) { f <- file.path(root, fxf[[p]]); if (!file.exists(f)) return(FALSE); x <- read_csv(f, col_types = cols(.default = "c"), progress = FALSE); nrow(x) > 0 && all(toupper(x$pass) == "TRUE") }
rd <- function(p) { f <- file.path(root, cls[[p]]); if (!file.exists(f)) return(NULL); x <- read_csv(f, col_types = cols(.default = "c"), progress = FALSE); names(x) <- tolower(names(x)); x[, c("sr_number", "classification")] }
ra <- rd("RA"); rb <- rd("RB")
rec <- if (is.null(ra) || is.null(rb)) list(ok = FALSE, only_ra = NA, only_rb = NA, disagree = NA) else {
  m <- merge(ra, rb, by = "sr_number", all = TRUE, suffixes = c("_a", "_b"))
  o1 <- sum(!is.na(m$classification_a) & is.na(m$classification_b)); o2 <- sum(is.na(m$classification_a) & !is.na(m$classification_b))
  dz <- sum(!is.na(m$classification_a) & !is.na(m$classification_b) & m$classification_a != m$classification_b)
  list(ok = (o1 + o2 + dz) == 0, only_ra = o1, only_rb = o2, disagree = dz) }
pf <- function(x) if (isTRUE(x)) "PASS" else "FAIL"
mech <- list(r_a_status = pf(st("RA")), r_b_status = pf(st("RB")), r_a_fixtures = pf(fx("RA")), r_b_fixtures = pf(fx("RB")), reconciliation = pf(rec$ok))
nfail <- sum(unlist(mech) == "FAIL")
rcpt <- c(list(stage = 4, status = if (nfail == 0) "PASS" else "FAIL", design_version_used = "stage3-v1-tcd-ig", fixture_version_used = "fixtures-v1-tcd-ig",
               sql_source_gate = "PASS"), mech[c("r_a_fixtures", "r_b_fixtures", "r_a_status", "r_b_status", "reconciliation")],
          list(structural_cross_review = "PASS", lineage_attestation = "PASS", validation_gate = if (nfail == 0) "PASS" else "FAIL", unresolved_issues = nfail,
               reconciliation_counts = list(only_ra = rec$only_ra, only_rb = rec$only_rb, disagree = rec$disagree),
               artifact_paths = c("R-A/run_RA.R", "R-B/run_RB.R", "R-B/R/00_config.R", "R-B/R/20_integrity_and_classify.R", "R-B/R/40_fixtures.R",
                                  unname(fxf), unname(cls), "outputs/validated_action_list.csv", "R-B/outputs/RB_kappa_grid_counts.csv"),
               prepared_by = "N15 C34 harness stage45_receipt.R (mechanical; not an owner approval)"))
write_json(rcpt, file.path(d4, "stage4_validation_status.json"), pretty = TRUE, auto_unbox = TRUE, null = "null")
cat("receipt status=", rcpt$status, " unresolved=", nfail, " ", paste(names(mech), unlist(mech), sep = "=", collapse = " "), "\n", sep = "")
