#!/usr/bin/env Rscript
# C40R build gate (N13 c40r). Usage: Rscript c40r_gate.R <ARM_ROOT> <FROZEN_ROOT> <LABEL>
# Gate PASS (= valid build) iff RUN_RB.exit is 0, the fixture results are 14/14 pass, and the 4 R-B key outputs are byte-identical to the frozen R-B outputs.
# Writes <ARM_ROOT>/GATE_RESULT.txt (machine) and <ARM_ROOT>/GATE_REPORT.md (sent to the builder in the next repair round; field-level diff, no frozen code).
suppressPackageStartupMessages({ library(digest); library(readr) })
a <- commandArgs(trailingOnly = TRUE); R <- a[[1]]; FZ <- a[[2]]; LAB <- a[[3]]
sha <- function(p) if (file.exists(p)) digest(file = p, algo = "sha256") else "MISSING"
FROZEN_RB <- c("RB_classifications.csv" = "a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193", "RB_fixture_results.csv" = "0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9",
               "RB_portfolio_counts.csv" = "eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c", "RB_kappa_grid_counts.csv" = "7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a")
ex <- if (file.exists(file.path(R, "RUN_RB.exit"))) strsplit(readLines(file.path(R, "RUN_RB.exit"), warn = FALSE)[1], ",")[[1]] else c("MISSING", NA)
O <- file.path(R, "R-B", "outputs"); h <- sapply(names(FROZEN_RB), function(f) sha(file.path(O, f))); eq <- h == FROZEN_RB
fx <- if (file.exists(file.path(O, "RB_fixture_results.csv"))) read.csv(file.path(O, "RB_fixture_results.csv"), colClasses = "character") else NULL
fx_pass <- if (is.null(fx)) 0L else sum(fx$pass == "TRUE"); fx_n <- if (is.null(fx)) 0L else nrow(fx)
gate <- ex[1] == "0" && fx_n == 14 && fx_pass == 14 && all(eq)
rep <- c(paste0("# C40R gate report — ", LAB, " — ", if (gate) "PASS" else "FAILED"), "",
         sprintf("- Production run `Rscript R-B/run_RB.R all`: exit %s (%s s).", ex[1], ex[2]),
         sprintf("- Fixtures: %d/%d pass%s.", fx_pass, fx_n, if (!is.null(fx) && fx_pass < fx_n) paste0(" — failing: ", paste(fx$fixture_id[fx$pass != "TRUE"], collapse = ", ")) else ""), "",
         "| output | byte-identical to frozen reference |", "|---|---|", sprintf("| %s | %s |", names(FROZEN_RB), ifelse(eq, "YES", "NO")), "")
st <- file.path(R, "RUN_RB.stderr.txt")
if (ex[1] != "0" && file.exists(st)) { z <- readLines(st, warn = FALSE); z <- z[nzchar(trimws(z))]; rep <- c(rep, "Last 15 lines of stderr:", "```", tail(z, 15), "```", "") }
if (!eq[["RB_classifications.csv"]] && file.exists(file.path(O, "RB_classifications.csv"))) {
  rc <- function(p) read_csv(p, col_types = cols(.default = col_character()), progress = FALSE, na = character())
  fz <- rc(file.path(FZ, "R-B", "outputs", "RB_classifications.csv")); cd <- rc(file.path(O, "RB_classifications.csv"))
  rep <- c(rep, sprintf("RB_classifications.csv: reference %d rows, %d columns; yours %d rows, %d columns.", nrow(fz), ncol(fz), nrow(cd), ncol(cd)))
  if (!identical(names(fz), names(cd))) rep <- c(rep, paste0("Column names differ. Reference: ", paste(names(fz), collapse = ","), " | yours: ", paste(names(cd), collapse = ",")))
  m <- merge(fz, cd, by = "SR_NUMBER", all = TRUE, suffixes = c(".ref", ".yours"))
  rep <- c(rep, sprintf("SR_NUMBER only in reference: %d; only in yours: %d.", sum(!(fz$SR_NUMBER %in% cd$SR_NUMBER)), sum(!(cd$SR_NUMBER %in% fz$SR_NUMBER))), "", "| column | rows that differ (matched SR_NUMBER) |", "|---|---|")
  ex_rows <- character(0)
  for (cn in intersect(setdiff(names(fz), "SR_NUMBER"), names(cd))) { x <- m[[paste0(cn, ".ref")]]; y <- m[[paste0(cn, ".yours")]]; k <- !is.na(x) & !is.na(y) & x != y
    rep <- c(rep, sprintf("| %s | %d |", cn, sum(k)))
    if (any(k)) { i <- head(which(k), 5); ex_rows <- c(ex_rows, sprintf("| %s | %s | %s | %s |", m$SR_NUMBER[i], cn, x[i], y[i])) } }
  if (length(ex_rows)) rep <- c(rep, "", "First differing rows (up to 5 per column):", "", "| SR_NUMBER | column | reference | yours |", "|---|---|---|---|", ex_rows)
  if (identical(names(fz), names(cd)) && nrow(fz) == nrow(cd) && !length(ex_rows) && all(fz$SR_NUMBER == cd$SR_NUMBER)) rep <- c(rep, "", "All values equal but the bytes differ (row order, quoting, number formatting or line endings).")
  rep <- c(rep, "") }
for (f in setdiff(names(FROZEN_RB)[!eq], "RB_classifications.csv")) if (file.exists(file.path(O, f))) rep <- c(rep, paste0(f, " (yours):"), "```", readLines(file.path(O, f), warn = FALSE), "```", "")
writeLines(rep, file.path(R, "GATE_REPORT.md"))
writeLines(sprintf("gate=%s rb_exit=%s rb_secs=%s fixtures=%d/%d classifications_equal=%s fixture_results_equal=%s portfolio_equal=%s kappa_grid_equal=%s", if (gate) "PASS" else "FAIL", ex[1], ex[2], fx_pass, fx_n, eq[1], eq[2], eq[3], eq[4]), file.path(R, "GATE_RESULT.txt"))
cat(readLines(file.path(R, "GATE_RESULT.txt")), "\n")
