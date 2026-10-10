#!/usr/bin/env Rscript
# C40R state machine (N13 c40r). Usage: Rscript c40r_next.R <N13_ROOT> <INC|FRESH> <k>
# Cap regime (variant): after 2 failed incumbent rounds, a fresh builder (new chat) gets the original packet plus the incumbent's gate reports (no code); the fresh builder has the same cap (2 failed rounds), then escalation to the owner.
# Unlimited regime (baseline): the incumbent keeps repairing; experiment stop at r6 (usage), so a baseline without a valid build by r6 is censored.
# Writes the next message (C40R/C40R-<arm>/r<k+1>/MESSAGE.txt), the fresh-builder packet at divergence, and appends C40R/STATE_LOG.txt and C40R/ROUND_PACKETS.sha256.
suppressPackageStartupMessages(library(digest))
a <- commandArgs(trailingOnly = TRUE); W <- normalizePath(a[[1]], winslash = "/", mustWork = TRUE); arm <- a[[2]]; k <- as.integer(a[[3]])
C <- file.path(W, "C40R"); RMAX <- c(INC = 6L, FRESH = 2L); CAP <- 2L
gr <- function(arm, k) { p <- file.path(C, "arms", sprintf("%s_r%d", arm, k), "GATE_RESULT.txt"); if (!file.exists(p)) stop("missing ", p); sub("^gate=([A-Z]+).*$", "\\1", readLines(p, warn = FALSE)[1]) }
rep_of <- function(arm, k) readLines(file.path(C, "arms", sprintf("%s_r%d", arm, k), "GATE_REPORT.md"), warn = FALSE, encoding = "UTF-8")
now <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
logl <- function(s) { cat(s, "\n"); cat(paste0(now, " ", s, "\n"), file = file.path(C, "STATE_LOG.txt"), append = TRUE) }
wr <- function(p, x) { dir.create(dirname(p), recursive = TRUE, showWarnings = FALSE); if (file.exists(p)) stop(p, " exists; never overwritten")
  con <- file(p, open = "wb"); writeBin(charToRaw(enc2utf8(paste0(paste(x, collapse = "\n"), "\n"))), con); close(con)
  cat(sprintf("%s  %s\n", digest(file = p, algo = "sha256"), sub(paste0("^", W, "/"), "", p)), file = file.path(C, "ROUND_PACKETS.sha256"), append = TRUE); logl(paste("wrote", sub(paste0("^", W, "/"), "", p))) }
repair <- function(arm, k) c(sprintf("# C40R — repair round r%d (%s builder)", k + 1, if (arm == "INC") "incumbent" else "fresh"), "",
  sprintf("Your round r%d file `R-B/R/20_integrity_and_classify.R` was deployed on the frozen R-B path and FAILED the gate. The gate report follows.", k), "", rep_of(arm, k), "",
  "Fix the file. Return the COMPLETE corrected `R-B/R/20_integrity_and_classify.R` in ONE fenced ```r code block (no other code blocks), then at most 10 lines saying what you changed.",
  "Do not change any other file; the gate deploys only this file. Reply in full, in one message. End your reply with exactly this line:", sprintf("END C40R BUILD %s r%d", arm, k + 1))
g <- gr(arm, k)
if (arm == "INC") {
  if (g == "PASS") { logl(sprintf("INC r%d PASS -> %s", k, if (k <= CAP) "NOT_TRIGGERED (valid build within the cap; regimes identical; no fresh builder; no B/V/G chats)" else "INC_VALID")); quit(status = 0) }
  if (k == CAP && all(sapply(seq_len(CAP), function(i) gr("INC", i)) == "FAIL")) {
    tp <- readLines(file.path(C, "packets", "C40R_2_FRESH_BUILDER_ChatGPT.TEMPLATE.txt"), warn = FALSE, encoding = "UTF-8"); j <- which(tp == "@@HANDOVER@@"); if (length(j) != 1) stop("placeholder")
    ho <- c("# HANDOVER FROM THE PREVIOUS BUILDER (cap reached after 2 failed rounds; gate reports only, no code)", unlist(lapply(seq_len(CAP), function(i) c("", sprintf("## Previous builder, round r%d", i), rep_of("INC", i)))))
    wr(file.path(C, "packets", "C40R_2_FRESH_BUILDER_ChatGPT.txt"), c(tp[seq_len(j - 1)], ho, tp[-seq_len(j)]))
    logl(sprintf("DIVERGED after INC r%d FAIL: variant = fresh builder (packet C40R/packets/C40R_2_FRESH_BUILDER_ChatGPT.txt, new chat); baseline = INC continues", k)) }
  if (k < RMAX[["INC"]]) wr(file.path(C, "C40R-INC", sprintf("r%d", k + 1), "MESSAGE.txt"), repair("INC", k)) else logl(sprintf("INC r%d FAIL at the experiment stop -> INC_CENSORED (no valid build by r%d)", k, k))
} else {
  if (g == "PASS") { logl(sprintf("FRESH r%d PASS -> FRESH_VALID", k)); quit(status = 0) }
  if (k < RMAX[["FRESH"]]) wr(file.path(C, "C40R-FRESH", sprintf("r%d", k + 1), "MESSAGE.txt"), repair("FRESH", k)) else logl(sprintf("FRESH r%d FAIL -> FRESH_ESCALATED (cap reached again; escalate to the owner)", k))
}
