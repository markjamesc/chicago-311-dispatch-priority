#!/usr/bin/env Rscript
# Freeze the Builder + Validator replies for one control and write the Grok adjudicator packet.
# Usage: Rscript assemble_adjudicator.R <WORK_ROOT> <CID e.g. C26>
# Inputs : <WORK>/<CID>/<CID>-builder/builder_report.md, <WORK>/<CID>/<CID>-validator/validator_report.md,
#          <WORK>/<CID>/packets/<CID>_3_ADJUDICATOR_Grok.HEAD.txt
# Outputs: <WORK>/<CID>/EVIDENCE_FREEZE.json, <WORK>/<CID>/packets/<CID>_3_ADJUDICATOR_Grok.txt
# Refuses (exit 3) if a reply is missing, empty, already frozen differently, or lacks its END line.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2 || !grepl("^C[0-9]{2}$", args[[2]])) { cat("usage: Rscript assemble_adjudicator.R <WORK_ROOT> <CID e.g. C26>\n"); quit(status = 2) }
W <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE); cid <- args[[2]]
sha <- function(p) { z <- system2("certutil", c("-hashfile", shQuote(normalizePath(p, winslash = "\\")), "SHA256"), stdout = TRUE)
  if (length(z) >= 2 && grepl("^[0-9a-fA-F ]{64,}$", z[2])) return(tolower(gsub(" ", "", z[2])))
  if (requireNamespace("digest", quietly = TRUE)) return(digest::digest(file = p, algo = "sha256"))
  stop("cannot hash ", p) }
rdu <- function(p) { x <- readLines(p, warn = FALSE, encoding = "UTF-8"); if (length(x) && startsWith(x[1], "\ufeff")) x[1] <- substring(x[1], 2); x }
f_b <- file.path(W, cid, paste0(cid, "-builder"), "builder_report.md")
f_v <- file.path(W, cid, paste0(cid, "-validator"), "validator_report.md")
head_f <- file.path(W, cid, "packets", paste0(cid, "_3_ADJUDICATOR_Grok.HEAD.txt"))
fail <- function(...) { cat("REFUSED:", ..., "\n"); quit(status = 3) }
for (f in c(f_b, f_v, head_f)) if (!file.exists(f) || file.info(f)$size < 200) fail("missing or too small:", f)
b <- rdu(f_b); v <- rdu(f_v)
lastline <- function(x) { x <- trimws(x); x <- x[nzchar(x)]; if (length(x)) x[length(x)] else "" }
if (!grepl(paste0("END ", cid, " BUILDER REPORT"), lastline(b), fixed = TRUE)) fail("builder reply does not end with 'END ", cid, " BUILDER REPORT' (incomplete capture?)")
if (!grepl(paste0("END ", cid, " VALIDATOR REPORT"), lastline(v), fixed = TRUE)) fail("validator reply does not end with 'END ", cid, " VALIDATOR REPORT' (incomplete capture?)")
verdict_leak <- function(x) any(grepl("^\\s*(\\*\\*)?\\s*(TERMINAL[_ ]STATE|FINAL VERDICT|VERDICT)\\s*(\\*\\*)?\\s*[:=]\\s*(\\*\\*)?\\s*(KEEP|REVERT|HALT)\\b", x, ignore.case = TRUE))
fz_path <- file.path(W, cid, "EVIDENCE_FREEZE.json")
hb <- sha(f_b); hv <- sha(f_v)
if (file.exists(fz_path)) { old <- paste(readLines(fz_path, warn = FALSE), collapse = "")
  if (!grepl(hb, old, fixed = TRUE) || !grepl(hv, old, fixed = TRUE)) fail("EVIDENCE_FREEZE.json exists with different hashes - replies changed after freeze") }
now <- format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
js <- sprintf('{\n  "ablation_id": "%s",\n  "frozen_at_ct": "%s",\n  "constitution_version": "1.0",\n  "roles": {"Builder": "ChatGPT", "Validator": "DeepSeek", "Adjudicator": "Grok"},\n  "baseline_sha256_files": [\n    "70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md",\n    "24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md"\n  ],\n  "builder_pack": [{"path": "%s", "bytes": %d, "sha256": "%s", "verdict_token_leak": %s}],\n  "validator_pack": [{"path": "%s", "bytes": %d, "sha256": "%s", "verdict_token_leak": %s}],\n  "runner_evidence_sha256_file": "%s"\n}\n',
  cid, now, paste0(cid, "/", cid, "-builder/builder_report.md"), file.info(f_b)$size, hb, tolower(verdict_leak(b)),
  paste0(cid, "/", cid, "-validator/validator_report.md"), file.info(f_v)$size, hv, tolower(verdict_leak(v)),
  sha(file.path(W, cid, "evidence", paste0(cid, "_EVIDENCE.sha256"))))
if (!file.exists(fz_path)) writeLines(js, fz_path, useBytes = TRUE)
out <- c(rdu(head_f), "---", "# FREEZE RECORD (EVIDENCE_FREEZE.json)", rdu(fz_path), "",
         "---", "# BUILDER REPORT (ChatGPT) — frozen, verbatim", b, "",
         "---", "# VALIDATOR REPORT (DeepSeek) — frozen, verbatim", v, "",
         "---", paste0("Reminder: exactly one terminal state. Final two lines: 'TERMINAL_STATE: <KEEP|REVERT|HALT>' then 'END ", cid, " ADJUDICATION'."))
of <- file.path(W, cid, "packets", paste0(cid, "_3_ADJUDICATOR_Grok.txt"))
con <- file(of, open = "wb"); writeBin(charToRaw(enc2utf8(paste(out, collapse = "\n"))), con); close(con)
cat("frozen", cid, "builder", hb, "validator", hv, "\nverdict_token_leak builder=", verdict_leak(b), " validator=", verdict_leak(v), "\nwrote", of, file.info(of)$size, "bytes\n")
