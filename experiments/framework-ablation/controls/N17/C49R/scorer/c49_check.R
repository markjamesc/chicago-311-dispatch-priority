#!/usr/bin/env Rscript
# C49 delivery-set check (N13 b6, pre-chat). Usage: Rscript c49_check.R <delivery_dir> <OUTDIR>
# Verifies FILES/SHA256SUMS against the files, and that ZIP/evidence_pkg.zip holds byte-identical copies of the same files. Writes OUTDIR/DELIVERY_CHECK.txt, DELIVERY_FILES.csv.
suppressPackageStartupMessages(library(digest))
a <- commandArgs(trailingOnly = TRUE); D <- a[[1]]; OUT <- a[[2]]; dir.create(OUT, recursive = TRUE, showWarnings = FALSE)
sha <- function(p) digest(file = p, algo = "sha256")
F <- file.path(D, "FILES"); sums <- readLines(file.path(F, "SHA256SUMS.txt"), warn = FALSE); sums <- sums[nzchar(sums)]
h <- sub("  .*$", "", sums); nm <- sub("^[0-9a-f]{64}  ", "", sums)
files <- setdiff(list.files(F), "SHA256SUMS.txt")
uz <- file.path(OUT, "unzipped"); dir.create(uz, showWarnings = FALSE); zf <- file.path(D, "ZIP", "evidence_pkg.zip")
zl <- utils::unzip(zf, list = TRUE); utils::unzip(zf, exdir = uz)
tab <- data.frame(file = c(nm, "SHA256SUMS.txt"), bytes = file.info(file.path(F, c(nm, "SHA256SUMS.txt")))$size, sha256_listed = c(h, NA), sha256_file = sapply(file.path(F, c(nm, "SHA256SUMS.txt")), sha),
                  in_zip = c(nm, "SHA256SUMS.txt") %in% zl$Name, stringsAsFactors = FALSE)
tab$sha256_zip <- sapply(tab$file, function(f) { p <- file.path(uz, f); if (file.exists(p)) sha(p) else "MISSING" })
ok <- setequal(nm, files) && all(tab$sha256_listed[seq_along(nm)] == tab$sha256_file[seq_along(nm)]) && all(tab$in_zip) && all(tab$sha256_zip == tab$sha256_file) && nrow(zl) == length(nm) + 1
write.csv(tab, file.path(OUT, "DELIVERY_FILES.csv"), row.names = FALSE)
writeLines(sprintf("status=%s n_evidence_files=%d zip_entries=%d zip_bytes=%d files_bytes_total=%d zip_sha256=%s", if (ok) "PASS" else "FAIL", length(nm), nrow(zl), file.info(zf)$size, sum(tab$bytes), sha(zf)), file.path(OUT, "DELIVERY_CHECK.txt"))
cat(readLines(file.path(OUT, "DELIVERY_CHECK.txt")), "\n"); if (!ok) quit(status = 1)
