#!/usr/bin/env Rscript
# N13 b5 C41 fixture-gate harness (owner ruling 41A, 2026-10-03 09:58 CT).
# Usage: Rscript fixdepth.R <ARM_ROOT> <count|depth> <FROZEN_SOURCE_DIR>
#   count = the frozen gate: rb_score_fixtures() on the locked synthetic pack; gate PASS iff every row passes (N/N).
#   depth = ruling 41A: the SAME rows of rb_build_fixture_pack() are written as text in the production source layout
#           (tab-separated, the frozen src_open_candidates.csv / src_peer_stats.csv header lines, MySQL-style *_ts columns,
#           raw-style *_DATE columns) and read back through 10_io_parse (rb_read_csv_flex -> rb_normalize_open /
#           rb_normalize_peers) before rb_judge_rows; expectations are the locked ones, unchanged.
#           Plus a stub probe: rb_score_fixtures() is re-run with rb_judge_rows replaced by a poison judge
#           (every label 'POISON', every row in the decision set); any fixture that still passes is a stub.
#           Depth gate PASS iff every row passes through the loader AND no stub AND no error.
# Writes <ARM_ROOT>/outputs/FIX_<mode>.csv and <ARM_ROOT>/outputs/GATE_<mode>.txt. Reads the frozen source dir only for header lines.
a <- commandArgs(trailingOnly = TRUE); root <- a[[1]]; mode <- a[[2]]; src <- a[[3]]
stopifnot(mode %in% c("count", "depth"))
for (f in c("00_config.R", "10_io_parse.R", "20_integrity_and_classify.R", "40_fixtures.R")) source(file.path(root, "R-B", "R", f))
od <- file.path(root, "outputs"); dir.create(od, showWarnings = FALSE, recursive = TRUE)
gate_line <- function(...) writeLines(paste0(...), file.path(od, paste0("GATE_", mode, ".txt")))
score <- function(j, pack) {
  got <- j$classification; got[!j$in_decision_set] <- "OUT_OF_SET"
  e <- pack$expected
  d <- data.frame(fixture_id = e$fixture_id, SR_NUMBER = e$SR_NUMBER, expected = e$expected_classification,
                  observed = got[match(e$SR_NUMBER, j$SR_NUMBER)], stringsAsFactors = FALSE)
  d$pass <- !is.na(d$observed) & d$expected == d$observed
  f14 <- d[d$fixture_id %in% c("F14A", "F14B"), ]
  rbind(d[!d$fixture_id %in% c("F14A", "F14B"), ],
        data.frame(fixture_id = "F14", SR_NUMBER = "SYN-F14A|SYN-F14B", expected = "STANDARD|STANDARD",
                   observed = paste(f14$observed, collapse = "|"), pass = all(f14$pass), stringsAsFactors = FALSE))
}
if (mode == "count") {
  res <- tryCatch({ fx <- rb_score_fixtures(kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE)
    data.frame(fixture_id = fx$fixture_id, expected = fx$expected_classification, observed = fx$observed_classification, pass = fx$pass %in% TRUE, stringsAsFactors = FALSE) },
    error = function(e) structure(list(msg = conditionMessage(e)), class = "err"))
  if (inherits(res, "err")) { gate_line("gate=FAIL n_pass=0 n=0 stubs=NA error=", gsub("[\r\n]+", " ", res$msg)); quit(status = 0) }
  write.csv(res, file.path(od, "FIX_count.csv"), row.names = FALSE)
  gate_line("gate=", if (nrow(res) == 14 && all(res$pass)) "PASS" else "FAIL", " n_pass=", sum(res$pass), " n=", nrow(res), " stubs=NA error=")
  quit(status = 0)
}
# ---------------- depth ----------------
harness_ts <- function(x) suppressWarnings(as.POSIXct(x, format = "%Y-%m-%d %H:%M:%S", tz = "America/Chicago"))  # harness-own parse of the pack's ISO strings
mdy <- function(ts) ifelse(is.na(ts), NA_character_, format(ts, "%m/%d/%Y %I:%M:%S %p"))
iso <- function(ts) ifelse(is.na(ts), "NULL", paste0(format(ts, "%Y-%m-%d %H:%M:%S"), ".000000"))
err <- ""; res <- NULL
pack <- rb_build_fixture_pack(t_freeze = RB_T_FREEZE)
res <- tryCatch({
  hdr_o <- strsplit(readLines(file.path(src, "src_open_candidates.csv"), n = 1, warn = FALSE), "\t")[[1]]
  hdr_p <- strsplit(readLines(file.path(src, "src_peer_stats.csv"), n = 1, warn = FALSE), "\t")[[1]]
  o <- pack$open; n <- nrow(o)
  O <- as.data.frame(matrix("", nrow = n, ncol = length(hdr_o), dimnames = list(NULL, hdr_o)), stringsAsFactors = FALSE)
  rawdate <- function(s) { t <- harness_ts(s); ifelse(is.na(t), ifelse(is.na(s), "", s), mdy(t)) }
  O$SR_NUMBER <- o$SR_NUMBER; O$SR_TYPE <- o$SR_TYPE; O$SR_SHORT_CODE <- o$SR_SHORT_CODE; O$STATUS <- o$STATUS
  O$CREATED_DATE <- rawdate(o$CREATED_DATE); O$LAST_MODIFIED_DATE <- rawdate(o$LAST_MODIFIED_DATE)
  O$CLOSED_DATE <- ifelse(nzchar(o$CLOSED_DATE), rawdate(o$CLOSED_DATE), "")
  O$created_ts <- iso(harness_ts(o$CREATED_DATE)); O$mod_ts <- iso(harness_ts(o$LAST_MODIFIED_DATE))
  O$closed_ts <- ifelse(nzchar(o$CLOSED_DATE), iso(harness_ts(o$CLOSED_DATE)), "NULL")
  O$DUPLICATE <- o$DUPLICATE; O$LEGACY_RECORD <- o$LEGACY_RECORD; O$PARENT_SR_NUMBER <- o$PARENT_SR_NUMBER
  O$type_key <- o$type_key; O$t_freeze <- "2026-09-12 23:59:59"; O$mechanical_envelope <- "fixture"; O$snapshot_id <- RB_FIXTURE_VERSION
  P <- as.data.frame(matrix("", nrow = nrow(pack$peers), ncol = length(hdr_p), dimnames = list(NULL, hdr_p)), stringsAsFactors = FALSE)
  P$type_key <- pack$peers$type_key; P$peer_n <- as.character(pack$peers$peer_n)
  P$peer_p50_h <- format(pack$peers$peer_p50_h, scientific = FALSE, trim = TRUE); P$peer_p75_h <- format(pack$peers$peer_p75_h, scientific = FALSE, trim = TRUE)
  P$t_freeze <- "2026-09-12 23:59:59"; P$lookback_w_days <- "365"; P$peer_def <- "fixture"; P$peer_label_note <- "fixture"
  fo <- file.path(od, "FIXTURE_src_open_candidates.tsv"); fp <- file.path(od, "FIXTURE_src_peer_stats.tsv")
  write.table(O, fo, sep = "\t", quote = FALSE, row.names = FALSE, na = ""); write.table(P, fp, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
  j <- rb_judge_rows(rb_normalize_open(rb_read_csv_flex(fo)), rb_normalize_peers(rb_read_csv_flex(fp)), kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE)
  score(j, pack) }, error = function(e) { err <<- gsub("[\r\n]+", " ", conditionMessage(e)); NULL })
real <- rb_judge_rows
assign("rb_judge_rows", function(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE) {
  r <- real(open_df, peer_df, kappa = kappa, t_freeze = t_freeze); r$classification <- "POISON"; r$in_decision_set <- TRUE; r }, envir = globalenv())
fxp <- tryCatch(rb_score_fixtures(kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE), error = function(e) NULL)
assign("rb_judge_rows", real, envir = globalenv())
stubs <- if (is.null(fxp)) character(0) else fxp$fixture_id[fxp$pass %in% TRUE]
if (!is.null(res)) { res$stub <- res$fixture_id %in% stubs; write.csv(res, file.path(od, "FIX_depth.csv"), row.names = FALSE) }
ok <- !is.null(res) && nrow(res) == 14 && all(res$pass) && !length(stubs) && !nzchar(err)
gate_line("gate=", if (ok) "PASS" else "FAIL", " n_pass=", if (is.null(res)) 0 else sum(res$pass), " n=", if (is.null(res)) 0 else nrow(res),
          " stubs=", if (length(stubs)) paste(stubs, collapse = "|") else "none", " poison_probe=", if (is.null(fxp)) "error" else "ran", " error=", err)
