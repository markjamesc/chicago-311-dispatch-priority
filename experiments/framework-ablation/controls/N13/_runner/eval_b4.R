#!/usr/bin/env Rscript
# N13 batch b4 evaluator. Usage: Rscript eval_b4.R <WORK> <FROZEN_ROOT> <C51,C46,C52>
# Mechanical only: applies the frozen predicates in each <CID>/ABLATION_SPEC.md; writes <CID>/<CID>_RESULTS.md, <CID>/<CID>_arms.csv, <WORK>/RUN_SUMMARY.txt.
suppressPackageStartupMessages({ library(readr); library(dplyr); library(digest) })
a <- commandArgs(trailingOnly = TRUE); W <- a[[1]]; FZ <- a[[2]]; CIDS <- strsplit(a[[3]], ",")[[1]]
sha <- function(p) if (file.exists(p)) digest(file = p, algo = "sha256") else "MISSING"
rexit <- function(p) { if (!file.exists(p)) return(list(code = "MISSING", secs = NA_real_, to = NA))
  z <- strsplit(trimws(readLines(p, warn = FALSE)[1]), ",")[[1]]; list(code = z[1], secs = as.numeric(z[2]), to = if (length(z) >= 4) z[4] == "1" else FALSE) }
summ <- character(0); say <- function(...) { s <- paste0(...); summ <<- c(summ, s); cat(s, "\n") }
FROZEN7 <- c("R-A/outputs/RA_classifications.csv" = "c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9",
  "R-B/outputs/RB_classifications.csv" = "a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193",
  "R-A/outputs/RA_fixture_results.csv" = "33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110",
  "R-B/outputs/RB_fixture_results.csv" = "0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9",
  "R-A/outputs/RA_portfolio_counts.csv" = "b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3",
  "R-B/outputs/RB_portfolio_counts.csv" = "eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c",
  "R-B/outputs/RB_kappa_grid_counts.csv" = "7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a")
md <- function(df) c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
                     apply(df, 1, function(r) paste0("| ", paste(r, collapse = " | "), " |")))
fin <- function(cid, tab, conds, extra = character(0), halt = character(0)) {
  write_csv(tab, file.path(W, cid, paste0(cid, "_arms.csv")))
  verdict <- if (length(halt)) "HALT" else if (all(conds$met)) "P1 MET" else "P1 NOT MET"
  L <- c(paste0("# ", cid, " RESULTS (mechanical; generated ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), ")"), "",
         paste0("**Mechanical predicate result: ", verdict, "**"), "", if (length(halt)) c("HALT reasons:", paste0("- ", halt), ""),
         "## Predicate conditions", md(transform(conds, met = ifelse(met, "MET", "NOT MET"))), "", "## Arms", md(tab), "", extra)
  writeLines(L, file.path(W, cid, paste0(cid, "_RESULTS.md"))); say(cid, ": ", verdict)
}
for (cid in CIDS) {
  R <- file.path(W, cid)
  # ---------------- C51 smoke ----------------
  if (file.exists(file.path(W, "runner/seeds", cid, "SMOKE"))) {
    arms <- read_tsv(file.path(W, "runner/seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()))
    units <- rbind(data.frame(arm = "B", path = c("RA", "RB")), data.frame(arm = arms$arm, path = arms$paths))
    gx <- function(arm, path, k) { if (is.na(k)) rexit(file.path(R, "arms", arm, paste0("RUN_", path, ".exit"))) else rexit(file.path(R, "smoke", paste0(arm, "_", path, "_k", k), paste0("RUN_", path, ".exit"))) }
    bad <- function(e) e$code != "0"
    rows <- list()
    for (i in seq_len(nrow(units))) { u <- units[i, ]; s16 <- gx(u$arm, u$path, 16); s4 <- gx(u$arm, u$path, 4); f <- gx(u$arm, u$path, NA)
      ratio <- if (!bad(s16) && !bad(s4)) s4$secs / s16$secs else NA
      det <- if (bad(s16)) "k16" else if (bad(s4) || (!is.na(ratio) && ratio > 6)) "k4" else "none"
      rows[[i]] <- data.frame(arm = u$arm, path = u$path, k16_exit = s16$code, k16_s = s16$secs, k4_exit = s4$code, k4_s = s4$secs,
                              ratio_k4_k16 = round(ratio, 2), full_exit = f$code, full_s = f$secs, full_timeout = f$to, smoke_detects = det) }
    tab <- do.call(rbind, rows)
    bs <- function(p) tab[tab$arm == "B" & tab$path == p, ]
    tab$baseline_s <- NA_real_; tab$variant_s <- NA_real_
    for (i in seq_len(nrow(tab))) { r <- tab[i, ]; b <- bs(r$path)
      if (r$arm == "B") { tab$baseline_s[i] <- r$full_s; tab$variant_s[i] <- r$k16_s + r$k4_s + r$full_s }
      else { tab$baseline_s[i] <- r$full_s + b$full_s
        smk <- if (r$smoke_detects == "k16") r$k16_s else r$k16_s + r$k4_s
        tab$variant_s[i] <- smk + if (r$smoke_detects == "none") r$full_s + b$k16_s + b$k4_s + b$full_s else b$k16_s + b$k4_s + b$full_s } }
    # contamination: B full-run outputs must equal the frozen key outputs; no arm-root manifest may reference a smoke path
    bh <- sapply(names(FROZEN7), function(k) sha(file.path(R, "arms", "B", k)))
    man <- unlist(lapply(list.dirs(file.path(R, "arms"), recursive = FALSE), function(d) readLines(file.path(d, "MANIFEST_outputs.sha256"), warn = FALSE)))
    H <- c("SM_QUADLOOP", "SM_MIDCRASH", "SM_OUTCRASH")
    conds <- data.frame(condition = c("smoke catches SM_QUADLOOP, SM_MIDCRASH, SM_OUTCRASH (each detected at k16 or k4, i.e. before its full run)",
                                      "no false smoke flag on clean arm B (R-A and R-B)",
                                      "summed time over all arms (incl. B and SM_RARECRASH) lower under the variant",
                                      "B full-run 7 key outputs equal the frozen hashes and no full-run manifest references a smoke path"),
                        met = c(all(tab$smoke_detects[tab$arm %in% H] != "none") && all(H %in% tab$arm),
                                all(tab$smoke_detects[tab$arm == "B"] == "none"),
                                sum(tab$variant_s) < sum(tab$baseline_s),
                                all(bh == FROZEN7) && !any(grepl("smoke", man, ignore.case = TRUE))))
    halt <- c(if (any(tab$k16_exit == "MISSING" | tab$k4_exit == "MISSING" | tab$full_exit == "MISSING")) "a run exit record is missing",
              if (any(bs("RA")$full_exit != "0", bs("RB")$full_exit != "0")) "clean arm B full run failed")
    extra <- c("## Totals", sprintf("- baseline (no smoke) summed seconds: %.1f", sum(tab$baseline_s)), sprintf("- variant (smoke first) summed seconds: %.1f", sum(tab$variant_s)),
               sprintf("- SM_RARECRASH (outside H, subset-bias probe): smoke_detects=%s, full_exit=%s", paste(tab$smoke_detects[tab$arm == "SM_RARECRASH"], collapse = ","), paste(tab$full_exit[tab$arm == "SM_RARECRASH"], collapse = ",")),
               "", "## B full-run key outputs vs frozen", md(data.frame(file = names(FROZEN7), frozen = unname(FROZEN7), arm_B = unname(bh), equal = unname(bh == FROZEN7))))
    fin(cid, tab, conds, extra, halt); next }
  # ---------------- C46 seeded fit ----------------
  if (file.exists(file.path(W, "runner/seeds", cid, "DETFIT"))) {
    arms <- read_tsv(file.path(W, "runner/seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()))
    rd <- function(p) if (file.exists(p)) read_csv(p, col_types = cols(.default = col_character()), progress = FALSE) else NULL
    fi <- function(arm, pth) rd(file.path(R, "arms", arm, pth, "fit_info.csv"))
    rows <- lapply(seq_len(nrow(arms)), function(i) { x <- arms[i, ]; rc <- rd(file.path(R, "arms", x$arm, "RECON.csv")); fa <- fi(x$arm, "RA"); fb <- fi(x$arm, "RB")
      data.frame(arm = x$arm, regime = x$regime, ra_order = x$ra_order, rb_order = x$rb_order, thresh = x$thresh, rb_drop = x$rb_drop,
                 jerr_RA = if (is.null(fa)) "MISSING" else fa$jerr, jerr_RB = if (is.null(fb)) "MISSING" else fb$jerr,
                 recon = if (is.null(rc)) "MISSING" else rc$recon, events = if (is.null(rc)) NA else as.integer(rc$events),
                 max_abs_dp = if (is.null(rc)) NA else rc$max_abs_dp, fail_p = if (is.null(rc)) NA else rc$fail_p,
                 fail_p_pct1 = if (is.null(rc)) NA else rc$fail_p_pct1, fail_flag = if (is.null(rc)) NA else rc$fail_flag) })
    tab <- do.call(rbind, rows); tab$extra_rebuilds <- tab$events
    pr <- function(arm) read_csv(file.path(R, "arms", arm, "RA", "pred.csv"), col_types = cols(SR_NUMBER = col_character(), p = col_double(), p_pct1 = col_double(), flag = col_integer()), progress = FALSE)
    ref <- tryCatch(pr("REF"), error = function(e) NULL); dec <- tryCatch(pr("DECL"), error = function(e) NULL)
    refok <- !is.null(ref) && !is.null(dec) && identical(ref$SR_NUMBER, dec$SR_NUMBER)
    ref_dp <- if (refok) max(abs(ref$p - dec$p)) else NA; ref_fl <- if (refok) sum(ref$flag != dec$flag) else NA
    g <- function(arm, col) tab[[col]][tab$arm == arm]
    conds <- data.frame(condition = c("BASE: >= 1 reconciliation event (baseline regime produces spurious mismatch)",
                                      "DECL: 0 reconciliation events", "DEFECT_DECL: recon FAIL (declared regime still catches a real defect)",
                                      "DECL R-A vs REF (canonical, thresh 1e-14): max|dp| <= 1e-6 and identical flags",
                                      "extra rebuilds: BASE >= 1 and DECL = 0"),
                        met = c(isTRUE(g("BASE", "events") >= 1), isTRUE(g("DECL", "events") == 0), isTRUE(g("DEFECT_DECL", "recon") == "FAIL"),
                                isTRUE(ref_dp <= 1e-6) && isTRUE(ref_fl == 0), isTRUE(g("BASE", "extra_rebuilds") >= 1 && g("DECL", "extra_rebuilds") == 0)))
    jr <- fi("REF", "RA")
    halt <- c(if (any(c(tab$jerr_RA, tab$jerr_RB) != "0") || is.null(jr) || jr$jerr != "0") "a fit has jerr != 0 or is missing", if (any(tab$recon == "MISSING")) "a RECON.csv is missing")
    extra <- c("## DECL vs REF", sprintf("- max|dp| = %s ; flag differences = %s", format(ref_dp, digits = 6), ref_fl),
               "", "## Fit info", md(do.call(rbind, lapply(c("REF", arms$arm), function(arm) { lapply(c("RA", "RB"), function(p) { f <- fi(arm, p); if (is.null(f)) NULL else data.frame(arm = arm, path = p, order = f$order, thresh = f$thresh, drop = f$drop, n = f$n, p_cols = f$p_cols, npasses = f$npasses, jerr = f$jerr, dev_ratio_last = f$dev_ratio_last, secs = f$secs) }) |> do.call(what = rbind) }))))
    fin(cid, tab, conds, extra, halt); next }
  # ---------------- C52 SQL concurrency ----------------
  if (file.exists(file.path(W, "runner/seeds", cid, "SQLCONC"))) {
    arms <- read_tsv(file.path(W, "runner/seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()))
    ex <- function(arm) { L <- unlist(lapply(c("E", "G"), function(ch) { p <- file.path(R, "arms", arm, paste0("times_", ch, ".txt")); if (file.exists(p)) readLines(p, warn = FALSE) else "MISSING" }))
      codes <- sub("^\\S+ exit (\\S+).*$", "\\1", grep(" exit ", L, value = TRUE)); if (length(codes) != 3) "MISSING" else paste(codes, collapse = "/") }
    rd1 <- function(arm, f) { p <- file.path(R, "arms", arm, f); if (file.exists(p)) paste(readLines(p, warn = FALSE), collapse = " | ") else "MISSING" }
    gres <- function(arm) { p <- file.path(R, "arms", arm, "G.tsv"); if (!file.exists(p)) return(NULL); z <- strsplit(readLines(p, warn = FALSE), "\t")
      data.frame(check = sapply(z, `[`, 1), result = sapply(z, function(v) { r <- v[v %in% c("PASS", "FAIL", "INFO")]; if (length(r)) r[1] else "?" }), row = sapply(z, paste, collapse = "\t")) }
    tab <- do.call(rbind, lapply(seq_len(nrow(arms)), function(i) { x <- arms[i, ]; d <- file.path(R, "arms", x$arm); pf <- file.path(d, "PERF.csv")
      gr <- gres(x$arm); errsz <- sum(file.size(list.files(d, pattern = "\\.err$", full.names = TRUE)))
      data.frame(arm = x$arm, mode = x$mode, exits_E1_E2_G = ex(x$arm), err_bytes = errsz, wall_s = if (file.exists(pf)) as.numeric(read_csv(pf, show_col_types = FALSE)$wall_s) else NA,
                 E1_sha = substr(sha(file.path(d, "E1.tsv")), 1, 16), E2_sha = substr(sha(file.path(d, "E2.tsv")), 1, 16), G_sha = substr(sha(file.path(d, "G.tsv")), 1, 16),
                 gate_rows = if (is.null(gr)) 0 else nrow(gr), gate_pass = if (is.null(gr)) 0 else sum(gr$result == "PASS"), gate_fail = if (is.null(gr)) 0 else sum(gr$result == "FAIL"),
                 gate_info = if (is.null(gr)) 0 else sum(gr$result == "INFO"), ck_pre = rd1(x$arm, "CK_PRE.tsv"), ck_post = rd1(x$arm, "CK_POST.tsv")) }))
    ck <- unique(c(tab$ck_pre, tab$ck_post))
    halt <- c(if (length(ck) != 1 || any(ck == "MISSING")) "CHECKSUM TABLE bracket changed or missing (DB not in the frozen state)")
    g1 <- gres(arms$arm[1]); fl <- file.path(FZ, "sql", "stage4_extract_run.log"); flog <- if (file.exists(fl)) readLines(fl, warn = FALSE) else character(0)
    logcmp <- if (is.null(g1)) data.frame() else data.frame(check = g1$check, result = g1$result,
       in_frozen_log = sapply(seq_len(nrow(g1)), function(i) { v <- strsplit(g1$row[i], "\t")[[1]]; hit <- grep(g1$check[i], flog, fixed = TRUE, value = TRUE); length(hit) > 0 && any(sapply(hit, function(h) all(sapply(v[-length(v)], function(f) grepl(f, h, fixed = TRUE))))) }))
    ser <- median(tab$wall_s[tab$mode == "SER"]); par <- median(tab$wall_s[tab$mode == "PAR"])
    conds <- data.frame(condition = c("all chain exits 0 in every arm (and empty .err files)", "17 gate rows, 15 PASS / 0 FAIL / 2 INFO, byte-identical G output across arms",
                                      "E1 and E2 outputs byte-identical across arms", "median PAR wall <= 0.80 x median SER wall"),
                        met = c(all(tab$exits_E1_E2_G == "0/0/0") && all(tab$err_bytes == 0), all(tab$gate_rows == 17 & tab$gate_pass == 15 & tab$gate_fail == 0 & tab$gate_info == 2) && length(unique(tab$G_sha)) == 1,
                                length(unique(tab$E1_sha)) == 1 && length(unique(tab$E2_sha)) == 1, isTRUE(par <= 0.80 * ser)))
    strip <- function(p) { if (!file.exists(p)) return("MISSING"); x <- readLines(p, warn = FALSE); digest(paste(x[-1], collapse = "\n"), algo = "sha256", serialize = FALSE) }
    body <- function(p) { if (!file.exists(p)) return("MISSING"); digest(paste(readLines(p, warn = FALSE), collapse = "\n"), algo = "sha256", serialize = FALSE) }
    d1 <- file.path(R, "arms", arms$arm[1])
    extra <- c("## Timing", sprintf("- median SER wall %.1f s; median PAR wall %.1f s; ratio %.3f", ser, par, par / ser), "",
               "## INFO (not gating): gate rows vs frozen stage4_extract_run.log (all non-note fields found on a log line naming the check)", if (nrow(logcmp)) md(logcmp) else "- frozen log not found",
               "", "## INFO (not gating): extract outputs vs frozen source CSV data rows (header dropped; line-normalised digest)",
               sprintf("- E1 vs src_open_candidates.csv: %s", body(file.path(d1, "E1.tsv")) == strip(file.path(FZ, "data/source/src_open_candidates.csv"))),
               sprintf("- E2 vs src_peer_stats.csv: %s", body(file.path(d1, "E2.tsv")) == strip(file.path(FZ, "data/source/src_peer_stats.csv"))),
               "", sprintf("CHECKSUM bracket (all arms, pre and post): %s", paste(ck, collapse = " || ")))
    fin(cid, tab, conds, extra, halt); next }
}
writeLines(summ, file.path(W, "RUN_SUMMARY.txt"))
