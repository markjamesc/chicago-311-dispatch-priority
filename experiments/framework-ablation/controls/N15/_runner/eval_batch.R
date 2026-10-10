#!/usr/bin/env Rscript
# N15 batch evaluator (read-only on inputs). Usage: Rscript eval_batch.R <WORK_ROOT> <FROZEN_ROOT> <CID,CID,...>
# For each control: arm B (frozen code, frozen source, both paths) is the truth reference. Each seeded arm replaces the
# outputs of the path(s) it runs; a path it does not run is taken from arm B. Writes <CID>/evidence/<CID>_RESULTS.md,
# <CID>_arms.csv (+ <CID>_resolution.csv for C29) and appends to RUN_SUMMARY.txt.
# Wording rule: summary lines state measured facts and their definitions. They make no claim beyond those definitions.
options(warn = 1)
suppressPackageStartupMessages({ library(readr); library(dplyr) })
a <- commandArgs(trailingOnly = TRUE); stopifnot(length(a) == 3)
W <- normalizePath(a[[1]], winslash = "/"); FZ <- normalizePath(a[[2]], winslash = "/"); CIDS <- strsplit(a[[3]], ",")[[1]]
TOL <- 1e-6
rd <- function(p) { if (!file.exists(p)) return(NULL)
  d <- read_csv(p, col_types = cols(.default = col_character()), progress = FALSE); names(d) <- tolower(names(d))
  d %>% transmute(sr_number, classification, dormant_h = suppressWarnings(as.numeric(dormant_h)), open_age_h = suppressWarnings(as.numeric(open_age_h))) }
recon <- function(ra, rb) {
  if (is.null(ra) || is.null(rb)) return(tibble(n_ra = NA, n_rb = NA, n_inner = NA, n_only_ra = NA, n_only_rb = NA, n_disagree = NA, n_dormant_mismatch = NA, n_open_age_mismatch = NA))
  j <- full_join(ra %>% rename_with(~paste0(.x, "_a"), -sr_number), rb %>% rename_with(~paste0(.x, "_b"), -sr_number), by = "sr_number")
  inn <- j %>% filter(!is.na(classification_a), !is.na(classification_b))
  tibble(n_ra = nrow(ra), n_rb = nrow(rb), n_inner = nrow(inn),
         n_only_ra = sum(!is.na(j$classification_a) & is.na(j$classification_b)), n_only_rb = sum(is.na(j$classification_a) & !is.na(j$classification_b)),
         n_disagree = sum(inn$classification_a != inn$classification_b),
         n_dormant_mismatch = sum(abs(inn$dormant_h_a - inn$dormant_h_b) > TOL | xor(is.na(inn$dormant_h_a), is.na(inn$dormant_h_b)), na.rm = TRUE),
         n_open_age_mismatch = sum(abs(inn$open_age_h_a - inn$open_age_h_b) > TOL | xor(is.na(inn$open_age_h_a), is.na(inn$open_age_h_b)), na.rm = TRUE)) }
vs_truth <- function(x, t) { r <- recon(x, t); tibble(n_only_x = r$n_only_ra, n_only_truth = r$n_only_rb, n_label_diff = r$n_disagree, n_dormant_diff = r$n_dormant_mismatch, n_open_age_diff = r$n_open_age_mismatch) }
fixt <- function(p) { if (!file.exists(p)) return(list(n_pass = NA, n = NA, failed = "MISSING_FILE"))
  f <- read_csv(p, col_types = cols(.default = col_character()), progress = FALSE); ps <- toupper(f$pass) == "TRUE"
  list(n_pass = sum(ps), n = nrow(f), failed = if (all(ps)) "" else paste(f$fixture_id[!ps], collapse = ";")) }
runinfo <- function(cid, arm, path) { p <- file.path(W, cid, "arms", arm, paste0("RUN_", path, ".exit"))
  if (!file.exists(p)) return(list(exit = NA, secs = NA)); v <- strsplit(trimws(readLines(p, warn = FALSE)[1]), ",")[[1]]; list(exit = as.integer(v[1]), secs = as.numeric(v[2])) }
o_ra <- function(cid, arm) file.path(W, cid, "arms", arm, "R-A", "outputs", "RA_classifications.csv")
o_rb <- function(cid, arm) file.path(W, cid, "arms", arm, "R-B", "outputs", "RB_classifications.csv")
f_ra <- function(cid, arm) file.path(W, cid, "arms", arm, "R-A", "outputs", "RA_fixture_results.csv")
f_rb <- function(cid, arm) file.path(W, cid, "arms", arm, "R-B", "outputs", "RB_fixture_results.csv")
man <- function(cid, arm) { p <- file.path(W, cid, "arms", arm, "MANIFEST_inputs.sha256"); if (!file.exists(p)) return(NULL)
  l <- readLines(p, warn = FALSE, encoding = "UTF-8"); l <- sub("^\ufeff", "", l); l <- l[nzchar(l)]
  s <- strsplit(l, "  ", fixed = TRUE); tibble(sha = vapply(s, `[`, "", 1), path = vapply(s, `[`, "", 3)) }
md_tbl <- function(df) { df <- as.data.frame(df, stringsAsFactors = FALSE)
  c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"),
    apply(df, 1, function(z) paste0("| ", paste(ifelse(is.na(z), "NA", trimws(format(z, scientific = FALSE))), collapse = " | "), " |"))) }
set_s <- function(x) paste0("{", paste(x, collapse = ","), "}")
frozen_ra <- rd(file.path(FZ, "R-A", "outputs", "RA_classifications.csv")); frozen_rb <- rd(file.path(FZ, "R-B", "outputs", "RB_classifications.csv"))
REG <- list(
  C26 = list(title = "Frozen Source Package (catalog #26)", with = "crash, source-file SHA-256 differs from the frozen source, recon key/label mismatch, or fixture failure on any path",
             without = "crash, recon key/label mismatch, or fixture failure on any path (no source checksum check)"),
  C31 = list(title = "Lineage Attestation (catalog #31)", with = "crash, any input file SHA-256 (source or code) differs from the frozen record, recon key/label mismatch, or fixture failure",
             without = "crash, recon key/label mismatch, or fixture failure on any path (no lineage/manifest attestation)"),
  C39 = list(title = "Reconciliation scope & tolerance (addendum #39)", with = "crash, full-field recon mismatch (key set, classification, dormant_h, open_age_h; |d| > 1e-6), or fixture failure",
             without = "crash, decision-field recon mismatch (key set, classification only), or fixture failure"),
  C30 = list(title = "Structural Cross-Review (catalog #30)", with = "not simulated mechanically (the structural review is a reading of both implementations)",
             without = "crash, recon key/label mismatch, or fixture failure on any path (matching totals accepted)"),
  C29 = list(title = "Reconciliation Investigation (catalog #29)", with = "investigation and rerun with the defect removed = arm B (by construction)",
             without = "crash, recon key/label mismatch, or fixture failure on any path"),
  C14 = list(title = "Explicit Semantics, Open/Eligibility (catalog #14)", with = "locked definitions = arm B (by construction)",
             without = "crash, recon key/label mismatch, or fixture failure on any path"),
  C11 = list(title = "Method Constants vs Knobs (catalog #11)", with = "crash, a method constant (n_min) in the run code differs from the locked value 50, recon key/label mismatch, or fixture failure",
             without = "crash, recon key/label mismatch, or fixture failure on any path (n_min treated as a tunable knob)"),
  C16 = list(title = "Spec-to-Builder Packet Completeness (catalog #16)", with = "complete packet = arm B (by construction)",
             without = "crash, recon key/label mismatch, or fixture failure on any path"),
  C18 = list(title = "No Fixture Rewrite on Fail (catalog #18)", with = "frozen fixtures (FX_ arms): crash, recon key/label mismatch, or fixture failure",
             without = "rewritten fixtures (RW_ arms): crash, recon key/label mismatch, or fixture failure after the rewrite"),
  C34 = list(title = "Deterministic Workflow Gate (catalog #34)", with = "workflow gate result FAIL, or Stage 5 exits non-zero",
             without = "Stage 5 exits non-zero (its own independent count checks or a missing input); the gate result is ignored"))
S5_FILES <- c("independent_checks_critical_counts.csv", "portfolio_summary.csv", "escalate_by_type.csv", "escalate_by_type_top25.csv",
              "inconclusive_by_clause.csv", "escalate_dormancy_summary.csv", "kappa_sensitivity.csv", "capacity_coverage_note.csv")
same_csv <- function(f1, f2) { if (!file.exists(f1) || !file.exists(f2)) return(FALSE)
  x <- read_csv(f1, col_types = cols(.default = col_character()), progress = FALSE); y <- read_csv(f2, col_types = cols(.default = col_character()), progress = FALSE)
  if (!identical(dim(x), dim(y)) || !identical(names(x), names(y))) return(FALSE)
  for (k in names(x)) { a <- x[[k]]; b <- y[[k]]; na <- suppressWarnings(as.numeric(a)); nb <- suppressWarnings(as.numeric(b))
    if (!identical(is.na(a), is.na(b))) return(FALSE)
    num <- !is.na(na) & !is.na(nb); if (any(abs(na[num] - nb[num]) > 1e-9)) return(FALSE)
    txt <- !num & !is.na(a); if (any(a[txt] != b[txt])) return(FALSE) }
  TRUE }
s45 <- function(cid, arm) { d <- file.path(W, cid, "arms", arm); ex <- function(tag) runinfo(cid, arm, tag)$exit
  jr <- function(f) if (file.exists(f)) tryCatch(jsonlite::fromJSON(f, simplifyVector = TRUE), error = function(e) NULL) else NULL
  g <- jr(file.path(d, "validation", "workflow-gate", "workflow_gate_status.json")); rc <- jr(file.path(d, "docs", "stage-04-execution-validation", "stage4_validation_status.json"))
  mf <- c("r_a_status", "r_b_status", "r_a_fixtures", "r_b_fixtures", "reconciliation")
  s5 <- file.path(d, "stage-05", "deeper"); b5 <- file.path(W, cid, "arms", "B", "stage-05", "deeper")
  dif <- S5_FILES[!vapply(S5_FILES, function(f) same_csv(file.path(s5, f), file.path(b5, f)), TRUE)]
  tibble(arm = arm, receipt_status = if (is.null(rc)) "MISSING" else rc$status, receipt_unresolved = if (is.null(rc)) NA else rc$unresolved_issues,
         receipt_fail_fields = if (is.null(rc)) "" else paste(mf[vapply(mf, function(k) !identical(rc[[k]], "PASS"), TRUE)], collapse = ";"),
         gate_exit = ex("GATE"), gate_result = if (is.null(g)) "MISSING" else g$result,
         validated_list_exit = ex("S4VAL"), stage5_exit = ex("S5"), stage5_files_differing_from_B = paste(dif, collapse = ";"), n_stage5_files_differing = length(dif)) }
SEV <- c(STANDARD = 1, INCONCLUSIVE = 2, ESCALATE = 3)
resolve <- function(ra, rb, rule) {
  j <- full_join(ra %>% select(sr_number, a = classification), rb %>% select(sr_number, b = classification), by = "sr_number")
  if (rule == "copy_RA") return(j %>% filter(!is.na(a)) %>% transmute(sr_number, classification = a))
  if (rule == "copy_RB") return(j %>% filter(!is.na(b)) %>% transmute(sr_number, classification = b))
  j %>% transmute(sr_number, classification = ifelse(is.na(a), b, ifelse(is.na(b), a, ifelse(SEV[a] >= SEV[b], a, b)))) }
summary_lines <- c(paste0("RUN_SUMMARY N15 ", paste(CIDS, collapse = ","), "  written ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")), "",
                   "## PREFLIGHT", if (file.exists(file.path(W, "PREFLIGHT.txt"))) readLines(file.path(W, "PREFLIGHT.txt"), warn = FALSE) else "PREFLIGHT.txt MISSING", "")
for (cid in CIDS) {
  ev <- file.path(W, cid, "evidence"); dir.create(ev, recursive = TRUE, showWarnings = FALSE)
  arms <- read_tsv(file.path(W, "runner", "seeds", cid, "ARMS.tsv"), col_types = cols(.default = col_character()), progress = FALSE)
  B_ra <- rd(o_ra(cid, "B")); B_rb <- rd(o_rb(cid, "B")); mB <- man(cid, "B")
  fxBa <- fixt(f_ra(cid, "B")); fxBb <- fixt(f_rb(cid, "B")); riBa <- runinfo(cid, "B", "RA"); riBb <- runinfo(cid, "B", "RB")
  repro <- bind_rows(vs_truth(B_ra, frozen_ra) %>% mutate(cmp = "B R-A vs frozen RA_classifications", .before = 1),
                     vs_truth(B_rb, frozen_rb) %>% mutate(cmp = "B R-B vs frozen RB_classifications", .before = 1))
  recB <- recon(B_ra, B_rb)
  rows <- lapply(seq_len(nrow(arms)), function(i) {
    A <- arms[i, ]; arm <- A$arm; runs <- strsplit(A$paths, "+", fixed = TRUE)[[1]]
    xa <- if ("RA" %in% runs) rd(o_ra(cid, arm)) else B_ra; xb <- if ("RB" %in% runs) rd(o_rb(cid, arm)) else B_rb
    ri <- lapply(runs, function(p) runinfo(cid, arm, p)); names(ri) <- runs
    fa <- if ("RA" %in% runs) fixt(f_ra(cid, arm)) else fxBa; fb <- if ("RB" %in% runs) fixt(f_rb(cid, arm)) else fxBb
    crashed <- any(vapply(ri, function(z) is.na(z$exit) || z$exit != 0, TRUE)) || is.null(xa) || is.null(xb)
    r <- recon(xa, xb)
    ta <- if ("RA" %in% runs) vs_truth(xa, B_ra) else vs_truth(B_ra, B_ra); tb <- if ("RB" %in% runs) vs_truth(xb, B_rb) else vs_truth(B_rb, B_rb)
    harm_n <- sum(unlist(ta), unlist(tb), na.rm = TRUE); dec_n <- sum(ta$n_only_x, ta$n_only_truth, ta$n_label_diff, tb$n_only_x, tb$n_only_truth, tb$n_label_diff, na.rm = TRUE)
    m <- man(cid, arm); dif <- if (is.null(m) || is.null(mB)) "MANIFEST_MISSING" else { k <- left_join(m, mB, by = "path", suffix = c("", "_B")); k$path[is.na(k$sha_B) | k$sha != k$sha_B] }
    fx_fail <- isTRUE(is.na(fa$n_pass) || fa$n_pass < fa$n) || isTRUE(is.na(fb$n_pass) || fb$n_pass < fb$n)
    rec_flag <- isTRUE((r$n_only_ra + r$n_only_rb + r$n_disagree) > 0); full_flag <- rec_flag || isTRUE((r$n_dormant_mismatch + r$n_open_age_mismatch) > 0)
    src_flag <- any(grepl("^data\\\\source\\\\", dif)); any_flag <- length(dif) > 0
    const_ok <- function(f, pat) { p <- file.path(W, cid, "arms", arm, f); !file.exists(p) || any(grepl(pat, readLines(p, warn = FALSE))) }
    const_flag <- !(const_ok("R-A/run_RA.R", "^N_MIN <- 50L$") && const_ok("R-B/R/00_config.R", "^RB_N_MIN <- 50L$"))
    d_with <- switch(cid, C26 = crashed || src_flag || rec_flag || fx_fail, C31 = crashed || any_flag || rec_flag || fx_fail,
                     C39 = crashed || full_flag || fx_fail, C11 = crashed || const_flag || rec_flag || fx_fail, NA)
    d_abl <- crashed || rec_flag || fx_fail
    tibble(arm = arm, paths_run = A$paths, change = A$description,
           exit = paste(vapply(names(ri), function(p) paste0(p, "=", ri[[p]]$exit), ""), collapse = " "),
           fx_RA = paste0(fa$n_pass, "/", fa$n, if (nzchar(fa$failed)) paste0(" (", fa$failed, ")") else ""),
           fx_RB = paste0(fb$n_pass, "/", fb$n, if (nzchar(fb$failed)) paste0(" (", fb$failed, ")") else ""),
           recon_only_ra = r$n_only_ra, recon_only_rb = r$n_only_rb, recon_disagree = r$n_disagree,
           recon_dormant_mismatch = r$n_dormant_mismatch, recon_open_age_mismatch = r$n_open_age_mismatch,
           RA_vs_B = with(ta, sprintf("only_x=%s only_B=%s label=%s dormant=%s open_age=%s", n_only_x, n_only_truth, n_label_diff, n_dormant_diff, n_open_age_diff)),
           RB_vs_B = with(tb, sprintf("only_x=%s only_B=%s label=%s dormant=%s open_age=%s", n_only_x, n_only_truth, n_label_diff, n_dormant_diff, n_open_age_diff)),
           locked_field_changes_vs_B = harm_n, decision_changes_vs_B = dec_n, harm = harm_n > 0,
           inputs_differing_from_B = if (length(dif)) paste(dif, collapse = "; ") else "",
           caught_with_control = d_with, caught_without_control = d_abl)
  })
  at <- bind_rows(rows); write_csv(at, file.path(ev, paste0(cid, "_arms.csv")))
  repro_ok <- isTRUE(all(unlist(repro[, -1]) == 0) && recB$n_only_ra == 0 && recB$n_only_rb == 0 && recB$n_disagree == 0)
  H <- at$arm[at$harm]; Dab <- at$arm[at$caught_without_control]
  mech <- c(paste0("H1 arm B: R-A exit ", riBa$exit, ", R-B exit ", riBb$exit, "; fixtures R-A ", fxBa$n_pass, "/", fxBa$n, ", R-B ", fxBb$n_pass, "/", fxBb$n),
            paste0("H2 arm B reproduces the frozen pack (0 key/label/dormant/open_age differences vs frozen RA and RB) and B recon is 0/0/0: ", repro_ok,
                   "; B full-field recon mismatches: dormant_h ", recB$n_dormant_mismatch, ", open_age_h ", recB$n_open_age_mismatch),
            paste0("H3 seeded arms with every run recorded: ", sum(vapply(seq_len(nrow(at)), function(i) !grepl("NA", at$exit[i]), TRUE)), "/", nrow(at)),
            paste0("H4 harm set H (arms whose output differs from arm B on any locked field: key set, classification, dormant_h, open_age_h): ", set_s(H)),
            paste0(if (cid == "C29") "H5 mismatch visible to the remaining checks (the ablated regime then auto-resolves it instead of rerunning) [" else "H5 caught without the control [", REG[[cid]]$without, "]: ", set_s(Dab)),
            paste0(if (cid == "C29") "H6 H minus mismatch-visible: " else "H6 H minus caught-without-control: ", set_s(setdiff(H, Dab))),
            paste0("H7 arms with no locked-field change: ", set_s(setdiff(at$arm, H))))
  if (cid %in% c("C26", "C31", "C39", "C11")) {
    Dw <- at$arm[at$caught_with_control]
    mech <- c(mech, paste0("H8 caught with the control [", REG[[cid]]$with, "]: ", set_s(Dw)),
              paste0("H9 caught with the control but no locked-field change: ", set_s(setdiff(Dw, H))))
  }
  extra <- character()
  if (cid == "C18") {
    rw <- at$arm[startsWith(at$arm, "RW_")]; fxa <- at$arm[startsWith(at$arm, "FX_")]
    mech[5] <- paste0("H5 caught without the control [", REG[[cid]]$without, "]: ", set_s(intersect(Dab, rw)))
    mech[6] <- paste0("H6 RW arms in H minus caught-without-control: ", set_s(setdiff(intersect(H, rw), Dab)))
    mech <- c(mech, paste0("H8 caught with the control [", REG[[cid]]$with, "]: ", set_s(intersect(Dab, fxa))),
              paste0("H9 FX arms in H not caught with the control: ", set_s(setdiff(intersect(H, fxa), Dab))))
  }
  if (cid == "C34") {
    s5t <- bind_rows(lapply(c("B", at$arm), function(z) s45(cid, z))); write_csv(s5t, file.path(ev, "C34_stage45.csv"))
    fz5 <- file.path(FZ, "stage-05", "deeper"); b5 <- file.path(W, cid, "arms", "B", "stage-05", "deeper")
    b5rep <- S5_FILES[!vapply(S5_FILES, function(f) same_csv(file.path(b5, f), file.path(fz5, f)), TRUE)]
    s5a <- s5t %>% filter(arm != "B")
    H5 <- s5a$arm[!is.na(s5a$stage5_exit) & s5a$stage5_exit == 0 & s5a$n_stage5_files_differing > 0]
    crash5 <- s5a$arm[is.na(s5a$stage5_exit) | s5a$stage5_exit != 0]; gatef <- s5a$arm[s5a$gate_result != "PASS"]
    bB <- s5t %>% filter(arm == "B")
    mech <- c(mech[1:3],
      paste0("H2b arm B Stage 4->5: receipt ", bB$receipt_status, ", gate ", bB$gate_result, " (exit ", bB$gate_exit, "), Stage 5 exit ", bB$stage5_exit,
             "; Stage 5 files differing from the frozen stage-05/deeper: ", if (length(b5rep)) set_s(b5rep) else "none"),
      paste0("H4 Stage-5 harm set H (Stage 5 completed with exit 0 and at least one Stage-5 output differs from arm B): ", set_s(H5)),
      paste0("H4b arms with any classification locked-field change vs arm B (context): ", set_s(H)),
      paste0("H5 caught without the control [", REG[[cid]]$without, "]: ", set_s(crash5)),
      paste0("H6 H minus caught-without-control: ", set_s(setdiff(H5, crash5))),
      paste0("H7 arms with Stage 5 exit 0 and no Stage-5 output difference: ", set_s(setdiff(s5a$arm[!s5a$arm %in% crash5], H5))),
      paste0("H8 caught with the control [", REG[[cid]]$with, "]: ", set_s(union(gatef, crash5))),
      paste0("H9 gate FAIL, Stage 5 exit 0, no Stage-5 output difference: ", set_s(setdiff(intersect(gatef, s5a$arm[!s5a$arm %in% crash5]), H5))))
    extra <- c("## Stage 4 -> gate -> Stage 5 per arm (C34_stage45.csv)", md_tbl(s5t), "")
  }
  if (cid == "C29") {
    rs <- bind_rows(lapply(seq_len(nrow(arms)), function(i) { A <- arms[i, ]; runs <- strsplit(A$paths, "+", fixed = TRUE)[[1]]
      xa <- if ("RA" %in% runs) rd(o_ra(cid, A$arm)) else B_ra; xb <- if ("RB" %in% runs) rd(o_rb(cid, A$arm)) else B_rb
      bind_rows(lapply(c("copy_RA", "copy_RB", "max_severity"), function(rule) { v <- vs_truth(resolve(xa, xb, rule), B_ra)
        tibble(scenario = A$arm, rule = rule, n_only_resolved = v$n_only_x, n_only_truth = v$n_only_truth, n_label_diff = v$n_label_diff,
               equals_truth = (v$n_only_x + v$n_only_truth + v$n_label_diff) == 0) })) }))
    write_csv(rs, file.path(ev, "C29_resolution.csv"))
    mech <- c(mech, paste0("H8 auto-resolution results equal to arm B (key set and classification): ", sum(rs$equals_truth), "/", nrow(rs)),
              paste0("H9 scenario x rule pairs whose resolution differs from arm B: ", set_s(paste0(rs$scenario[!rs$equals_truth], ":", rs$rule[!rs$equals_truth]))))
    extra <- c("## Auto-resolution (rules frozen in the SPEC; truth = arm B R-A labels)", md_tbl(rs), "")
  }
  res <- c(paste0("# ", cid, " RESULTS — ", REG[[cid]]$title, " ablation (runner output, mechanical facts only)"), "",
           "Truth reference = arm B (frozen code, frozen source, both paths). Locked fields compared: key set (SR_NUMBER), classification, dormant_h, open_age_h (|d| > 1e-6 counts).",
           "In a seeded arm, a path that is not run is taken from arm B. Fixture columns show the seeded path's own result, or arm B's if that path is not run.", "",
           "## Mechanical facts", paste0("- ", mech), "", "## Arm B repro vs frozen pack", md_tbl(repro), "", "## Arm B recon (R-A vs R-B)", md_tbl(recB), "",
           "## Seeded arms", md_tbl(at), "", extra)
  writeLines(res, file.path(ev, paste0(cid, "_RESULTS.md")), useBytes = TRUE)
  summary_lines <- c(summary_lines, paste0("## ", cid), mech, "")
}
writeLines(summary_lines, file.path(W, "RUN_SUMMARY.txt"), useBytes = TRUE); cat(summary_lines, sep = "\n")
