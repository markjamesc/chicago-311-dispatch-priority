#!/usr/bin/env Rscript
# N15: build deterministic source-data variants from the frozen Chicago 311 source (read-only on the frozen pack).
# Usage: Rscript source_variants.R <FROZEN_ROOT> <OUT_DIR>
# Line-based edits; untouched lines are written back byte-identical. An identity rebuild must reproduce the
# frozen SHA-256 exactly, or the script stops. Writes <OUT_DIR>/<VID>/{src_open_candidates.csv,src_peer_stats.csv}
# and <OUT_DIR>/VARIANTS.tsv (variant, file, sha256, bytes, change note).
args <- commandArgs(trailingOnly = TRUE); stopifnot(length(args) == 2)
FZ <- args[[1]]; OUT <- args[[2]]; dir.create(OUT, recursive = TRUE, showWarnings = FALSE)
sha <- function(p) tolower(digest::digest(file = p, algo = "sha256"))
src <- file.path(FZ, "data", "source", "src_open_candidates.csv"); peer <- file.path(FZ, "data", "source", "src_peer_stats.csv")
stopifnot(sha(src) == "ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9",
          sha(peer) == "cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58")
rd <- function(p) {
  b <- readBin(p, "raw", file.info(p)$size); crlf <- any(b == as.raw(13))
  x <- rawToChar(b); Encoding(x) <- "bytes"
  eol <- if (crlf) "\r\n" else "\n"
  L <- strsplit(x, eol, fixed = TRUE, useBytes = TRUE)[[1]]
  list(L = L, eol = eol, trail = endsWith(x, eol))
}
wr <- function(o, p, eol = o$eol) {
  txt <- paste(o$L, collapse = eol); if (o$trail) txt <- paste0(txt, eol)
  con <- file(p, "wb"); writeBin(charToRaw(txt), con); close(con)
}
fields <- function(line) { f <- strsplit(paste0(line, "\tX"), "\t", fixed = TRUE, useBytes = TRUE)[[1]]; f[-length(f)] }
S <- rd(src); P <- rd(peer)
tmp <- file.path(OUT, "_ident.csv"); wr(S, tmp); stopifnot(sha(tmp) == sha(src)); wr(P, tmp); stopifnot(sha(tmp) == sha(peer)); unlink(tmp)
hdr <- fields(S$L[1]); hdr[1] <- sub("^\xef\xbb\xbf", "", hdr[1], useBytes = TRUE)  # header BOM: matching only; bytes unchanged
ci <- function(n) { i <- which(hdr == n); stopifnot(length(i) == 1); i }
data_idx <- 2:length(S$L)
F <- strsplit(paste0(S$L[data_idx], "\tX"), "\t", fixed = TRUE, useBytes = TRUE)
col <- function(n) vapply(F, `[`, "", ci(n))
created <- col("created_ts"); dupv <- col("DUPLICATE"); legv <- col("LEGACY_RECORD"); par <- col("PARENT_SR_NUMBER")
clo <- col("CLOSED_DATE"); tk <- col("type_key"); sr <- col("SR_NUMBER")
notes <- list()
emit <- function(vid, So, Po, note) {
  d <- file.path(OUT, vid); dir.create(d, showWarnings = FALSE)
  wr(So, file.path(d, "src_open_candidates.csv"), So$eol2 %||% So$eol); wr(Po, file.path(d, "src_peer_stats.csv"))
  notes[[vid]] <<- note
}
`%||%` <- function(a, b) if (is.null(a)) b else a
# V_STALE24: drop rows created in the last 24 h before T_freeze
keep <- !(created >= "2026-09-11 23:59:59")
So <- S; So$L <- c(S$L[1], S$L[data_idx][keep]); emit("V_STALE24", So, P, sprintf("rows dropped: %d (created_ts >= 2026-09-11 23:59:59)", sum(!keep)))
# V_PEER10: most frequent type_key among in-set rows; peer_p75_h x1.10 (rounded to integer like the frozen values)
inset <- dupv == "false" & legv == "false"
top <- names(sort(table(tk[inset]), decreasing = TRUE))[1]
ph <- fields(P$L[1]); ph[1] <- sub("^\xef\xbb\xbf", "", ph[1], useBytes = TRUE); pk <- which(ph == "type_key"); p75 <- which(ph == "peer_p75_h")
Pi <- which(vapply(P$L[-1], function(l) fields(l)[pk], "") == top) + 1; stopifnot(length(Pi) == 1)
pf <- fields(P$L[Pi]); old <- pf[p75]; pf[p75] <- as.character(round(as.numeric(old) * 1.10)); Po <- P; Po$L[Pi] <- paste(pf, collapse = "\t")
emit("V_PEER10", S, Po, sprintf("type_key %s: peer_p75_h %s -> %s (n in-set rows of this type: %d)", top, old, pf[p75], sum(tk[inset] == top)))
# V_ONEROW: first in-set row with blank parent and blank closed date; mod_ts and LAST_MODIFIED_DATE 30 days earlier
j <- which(inset & par == "" & clo == "")[1]; li <- data_idx[j]; f <- fields(S$L[li])
m0 <- f[ci("mod_ts")]; l0 <- f[ci("LAST_MODIFIED_DATE")]
mt <- as.POSIXct(substr(m0, 1, 19), format = "%Y-%m-%d %H:%M:%S", tz = "UTC") - 30 * 86400
lt <- as.POSIXct(l0, format = "%m/%d/%Y %I:%M:%S %p", tz = "UTC") - 30 * 86400
f[ci("mod_ts")] <- paste0(format(mt, "%Y-%m-%d %H:%M:%S"), substring(m0, 20)); f[ci("LAST_MODIFIED_DATE")] <- format(lt, "%m/%d/%Y %I:%M:%S %p")
So <- S; So$L[li] <- paste(f, collapse = "\t")
emit("V_ONEROW", So, P, sprintf("SR_NUMBER %s: mod_ts %s -> %s; LAST_MODIFIED_DATE %s -> %s", sr[j], m0, f[ci("mod_ts")], l0, f[ci("LAST_MODIFIED_DATE")]))
# V_LF: same lines, LF endings
So <- S; So$eol2 <- "\n"; emit("V_LF", So, P, "line endings CRLF -> LF; content identical")
# V_REVERSE: data rows in reverse order
So <- S; So$L <- c(S$L[1], rev(S$L[data_idx])); emit("V_REVERSE", So, P, "data rows reversed; same row set")
# V_BOOLCASE: DUPLICATE / LEGACY_RECORD true/false -> TRUE/FALSE
So <- S; Fb <- F; for (n in c("DUPLICATE", "LEGACY_RECORD")) { k <- ci(n); Fb <- lapply(Fb, function(z) { z[k] <- toupper(z[k]); z }) }
So$L <- c(S$L[1], vapply(Fb, function(z) paste(z[-length(z)], collapse = "\t"), ""))
emit("V_BOOLCASE", So, P, "DUPLICATE and LEGACY_RECORD values upper-cased (true/false -> TRUE/FALSE)")
rows <- do.call(rbind, lapply(names(notes), function(v) do.call(rbind, lapply(c("src_open_candidates.csv", "src_peer_stats.csv"), function(fn) {
  p <- file.path(OUT, v, fn); h <- sha(p); fz <- sha(if (fn == "src_peer_stats.csv") peer else src)  # v2: a file equal to the frozen file is labelled unchanged
  data.frame(variant = v, file = fn, sha256 = h, bytes = file.info(p)$size, note = if (h == fz) "unchanged (equals the frozen file)" else notes[[v]]) }))))
write.table(rows, file.path(OUT, "VARIANTS.tsv"), sep = "\t", quote = FALSE, row.names = FALSE)
print(rows[, c("variant", "file", "bytes", "note")], right = FALSE)
