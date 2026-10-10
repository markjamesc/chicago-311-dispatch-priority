#!/usr/bin/env Rscript
# N19 C24V3 evaluator (mechanical; COLLAPSED arm ran CHUNKED, spec v3). Usage: Rscript eval_c24v3.R <WORK> <FROZEN_ROOT>. Writes <WORK>/C24/C24V3_RESULTS.md and C24V3_arms.csv.
suppressPackageStartupMessages({ library(digest) })
a <- commandArgs(trailingOnly = TRUE); W <- a[[1]]; FZ <- a[[2]]; C <- file.path(W, "C24V3")
sha <- function(p) if (file.exists(p)) digest(file = p, algo = "sha256") else "MISSING"
K7 <- c("R-A/outputs/RA_classifications.csv", "R-B/outputs/RB_classifications.csv", "R-A/outputs/RA_fixture_results.csv", "R-B/outputs/RB_fixture_results.csv",
        "R-A/outputs/RA_portfolio_counts.csv", "R-B/outputs/RB_portfolio_counts.csv", "R-B/outputs/RB_kappa_grid_counts.csv")
md <- function(df) c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"), apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |")))
rexit <- function(arm, p) { f <- file.path(C, "arms", arm, paste0("RUN_", p, ".exit")); if (!file.exists(f)) return(c("MISSING", NA, NA, NA)); z <- strsplit(readLines(f, warn = FALSE)[1], ",")[[1]]; z[c(1, 2, 5, 6)] }
nlines <- function(f) if (file.exists(f)) length(readLines(f, warn = FALSE)) - 1L else NA
fix <- function(arm, p) { f <- file.path(C, "arms", arm, if (p == "RA") "R-A/outputs/RA_fixture_results.csv" else "R-B/outputs/RB_fixture_results.csv")
  if (!file.exists(f)) return(c(NA, NA)); x <- read.csv(f, stringsAsFactors = FALSE); pv <- toupper(as.character(x$pass)) %in% c("TRUE", "T", "1", "PASS"); c(sum(pv), nrow(x)) }
q <- strsplit(readLines(file.path(C, "Q_COUNTS.tsv"), warn = FALSE), "\t"); qv <- setNames(as.numeric(sapply(q, `[`, 2)), sapply(q, `[`, 1))
ex <- read.csv(file.path(C, "EXTRACTS.csv"), stringsAsFactors = FALSE, colClasses = c("character", "character", "numeric", "numeric"))
st <- read.csv(file.path(C, "SQL_TIMES.csv"), header = FALSE, col.names = c("step", "exit", "secs", "end"), stringsAsFactors = FALSE)
errb <- sapply(st$step, function(s) { f <- file.path(C, paste0("SQL_", s, ".err")); if (file.exists(f)) file.size(f) else NA })
rows <- list(); for (arm in c("B", "COLLAPSED")) for (p in c("RA", "RB")) { e <- rexit(arm, p); fx <- fix(arm, p)
  cls <- file.path(C, "arms", arm, if (p == "RA") K7[1] else K7[2])
  rows[[length(rows) + 1]] <- data.frame(arm = arm, path = p, exit = e[1], secs = e[2], min_free_MB = e[3], peak_R_MB = e[4], decision_rows = nlines(cls), fixtures_pass = fx[1], fixtures_n = fx[2]) }
tab <- do.call(rbind, rows)
hb <- sapply(K7, function(k) sha(file.path(C, "arms/B", k))); hc <- sapply(K7, function(k) sha(file.path(C, "arms/COLLAPSED", k)))
FROZ <- c("c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9", "a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193", "33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110",
          "0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9", "b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3", "eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c",
          "7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a")
cmp <- data.frame(file = K7, frozen = FROZ, B = unname(hb), COLLAPSED = unname(hc), COLLAPSED_eq_B = unname(hb == hc & hb != "MISSING"), B_eq_frozen_INFO = unname(hb == FROZ))
g <- function(arm, p, col) tab[[col]][tab$arm == arm & tab$path == p]
xr <- function(arm) ex$data_rows[ex$arm == arm]
conds <- data.frame(condition = c("SQL counts: full-extract data rows = SQL total rows, and separated-extract data rows = SQL envelope count (STATUS = 'Open')",
                                  "COLLAPSED: R-A and R-B exit 0 (no error, timeout or memory kill)",
                                  "COLLAPSED: all 7 key outputs byte-identical to arm B's (same analytic set and counts)",
                                  "COLLAPSED: every fixture passes on both paths"),
                    met = c(isTRUE(xr("COLLAPSED") == qv[["total"]]) && isTRUE(xr("B") == qv[["envelope_open"]]),
                            all(c(g("COLLAPSED", "RA", "exit"), g("COLLAPSED", "RB", "exit")) == "0"),
                            all(cmp$COLLAPSED_eq_B),
                            all(!is.na(tab$fixtures_n[tab$arm == "COLLAPSED"])) && all(tab$fixtures_pass[tab$arm == "COLLAPSED"] == tab$fixtures_n[tab$arm == "COLLAPSED"])))
halt <- c(if (any(st$exit != 0) || any(is.na(errb)) || any(errb > 0)) "a SQL step exited non-zero or wrote to stderr",
          if (any(c(g("B", "RA", "exit"), g("B", "RB", "exit")) != "0")) "arm B (separated envelope) failed",
          if (any(is.na(tab$fixtures_n[tab$arm == "B"])) || any(tab$fixtures_pass[tab$arm == "B"] != tab$fixtures_n[tab$arm == "B"])) "arm B fixtures not all passing",
          if (!identical(readLines(file.path(C, "CK_PRE.tsv"), warn = FALSE), readLines(file.path(C, "CK_POST.tsv"), warn = FALSE))) "CHECKSUM TABLE bracket changed")
verdict <- if (length(halt)) "HALT" else if (all(conds$met)) "P1 MET" else "P1 NOT MET"
write.csv(tab, file.path(C, "C24V3_arms.csv"), row.names = FALSE)
L <- c(paste0("# C24 RESULTS (mechanical; generated ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), ")"), "", paste0("**Mechanical predicate result: ", verdict, "**"), "",
       if (length(halt)) c("HALT reasons:", paste0("- ", halt), ""),
       "## Predicate conditions", md(transform(conds, met = ifelse(met, "MET", "NOT MET"))), "",
       "## SQL query counts vs final analytic set", md(data.frame(quantity = c(names(qv), "separated extract data rows (arm B)", "full extract data rows (arm COLLAPSED)", paste("R decision rows", tab$arm, tab$path)),
                                                                value = c(format(qv, scientific = FALSE), format(xr("B"), scientific = FALSE), format(xr("COLLAPSED"), scientific = FALSE), tab$decision_rows))), "",
       "Note: COLLAPSED arm R-A/R-B ran CHUNKED (spec v3, run_RA_chunked.R/run_RB_chunked.R); B arm results and SQL/extract/checksum evidence are carried unchanged from C24V2 (N18).", "", "## Extracts (kept in place on the PC)", md(ex), "", "## SQL steps", md(cbind(st, err_bytes = errb)), "",
       "## R runs", md(tab), "", "## 7 key outputs: COLLAPSED vs B (gating) and B vs frozen pack (INFO only; the fresh export differs from the frozen export method, see SPEC)", md(cmp), "",
       paste0("CHECKSUM bracket PRE: ", paste(readLines(file.path(C, "CK_PRE.tsv"), warn = FALSE), collapse = " | ")),
       paste0("CHECKSUM bracket POST: ", paste(readLines(file.path(C, "CK_POST.tsv"), warn = FALSE), collapse = " | ")))
writeLines(L, file.path(C, "C24V3_RESULTS.md")); cat("C24V3:", verdict, "\n")
