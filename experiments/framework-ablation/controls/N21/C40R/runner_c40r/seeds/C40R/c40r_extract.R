#!/usr/bin/env Rscript
# C40R code extraction (N13 c40r). Usage: Rscript c40r_extract.R <reply.md> <END line> <out 20_integrity_and_classify.R>
# Refuses (exit 3) if the reply's last non-empty line is not the END line or no fenced code block exists. Takes the LARGEST fenced block. Writes <out> and <out dir>/EXTRACT.txt.
suppressPackageStartupMessages(library(digest))
a <- commandArgs(trailingOnly = TRUE); f <- a[[1]]; endl <- a[[2]]; out <- a[[3]]
x <- readLines(f, warn = FALSE, encoding = "UTF-8"); if (length(x) && startsWith(x[1], "\ufeff")) x[1] <- substring(x[1], 2)
nz <- trimws(x); nz <- nz[nzchar(nz)]
if (!length(nz) || !grepl(endl, nz[length(nz)], fixed = TRUE)) { cat("REFUSED: last non-empty line is not", endl, "\n"); quit(status = 3) }
fen <- grep("^[[:space:]]*```", x); if (length(fen) < 2) { cat("REFUSED: no fenced code block\n"); quit(status = 3) }
blocks <- list(); i <- 1
while (i < length(fen)) { s <- fen[i]; e <- fen[i + 1]; blocks[[length(blocks) + 1]] <- if (e - s > 1) x[(s + 1):(e - 1)] else character(0); i <- i + 2 }
sz <- sapply(blocks, function(b) sum(nchar(b))); b <- blocks[[which.max(sz)]]
dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE); con <- file(out, open = "wb"); writeBin(charToRaw(enc2utf8(paste0(paste(b, collapse = "\n"), "\n"))), con); close(con)
writeLines(sprintf("reply=%s reply_sha256=%s blocks=%d chosen_block_lines=%d code_sha256=%s", basename(f), digest(file = f, algo = "sha256"), length(blocks), length(b), digest(file = out, algo = "sha256")), file.path(dirname(out), "EXTRACT.txt"))
cat(readLines(file.path(dirname(out), "EXTRACT.txt")), "\n")
