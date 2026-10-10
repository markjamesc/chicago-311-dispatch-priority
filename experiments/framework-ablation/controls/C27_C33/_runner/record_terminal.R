#!/usr/bin/env Rscript
# After the Grok reply is saved to <WORK>/<CID>/<CID>-adjudicator/adjudicator_raw.md, record its terminal state.
# Usage: Rscript record_terminal.R <WORK_ROOT> <C33|C27>   -> writes <WORK>/<CID>/TERMINAL_STATE.txt (refuses if ambiguous/incomplete)
args <- commandArgs(trailingOnly = TRUE); stopifnot(length(args) == 2)
W <- normalizePath(args[[1]], winslash = "/"); cid <- args[[2]]
f <- file.path(W, cid, paste0(cid, "-adjudicator"), "adjudicator_raw.md")
if (!file.exists(f)) { cat("REFUSED: missing", f, "\n"); quit(status = 3) }
x <- trimws(readLines(f, warn = FALSE, encoding = "UTF-8")); x <- x[nzchar(x)]
if (!length(x) || !grepl(paste0("END ", cid, " ADJUDICATION"), x[length(x)], fixed = TRUE)) { cat("REFUSED: reply does not end with END", cid, "ADJUDICATION\n"); quit(status = 3) }
m <- regmatches(x, regexpr("TERMINAL_STATE:\\s*\\**\\s*(KEEP|REVERT|HALT)", x))
st <- unique(sub(".*(KEEP|REVERT|HALT).*", "\\1", m))
if (length(st) != 1) { cat("REFUSED: need exactly one TERMINAL_STATE line, found:", paste(m, collapse = " | "), "\n"); quit(status = 3) }
writeLines(st, file.path(W, cid, "TERMINAL_STATE.txt"))
cat(cid, "TERMINAL_STATE =", st, "\n")
