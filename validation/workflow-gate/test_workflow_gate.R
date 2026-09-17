#!/usr/bin/env Rscript

suppressPackageStartupMessages(library(jsonlite))

repo_root <- normalizePath(file.path(dirname(commandArgs(trailingOnly = FALSE)[grep("--file=", commandArgs(trailingOnly = FALSE))]), "..", ".."), mustWork = FALSE)
repo_root <- sub("^--file=", "", repo_root)

# More reliable script path resolution for Rscript.
full_args <- commandArgs(trailingOnly = FALSE)
file_arg <- full_args[grepl("^--file=", full_args)]
script_path <- normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = TRUE)
repo_root <- normalizePath(file.path(dirname(script_path), "..", ".."), mustWork = TRUE)
gate_script <- file.path(repo_root, "validation", "workflow-gate", "workflow_gate.R")

write_receipts <- function(root, reconciliation = "PASS") {
  dirs <- c(
    file.path(root, "docs", "stage-01-02-start-framing"),
    file.path(root, "docs", "stage-03-measurement-design"),
    file.path(root, "docs", "stage-04-execution-validation"),
    file.path(root, "validation", "workflow-gate"),
    file.path(root, "evidence")
  )
  invisible(lapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE))

  artifacts <- c(
    "evidence/source_gate.txt",
    "evidence/r_a.txt",
    "evidence/r_b.txt",
    "evidence/reconciliation.txt",
    "evidence/cross_review.txt"
  )
  invisible(lapply(file.path(root, artifacts), writeLines, text = "test evidence"))

  write_json(list(
    stage = 1,
    status = "LOCKED",
    decision_statement = "test decision",
    decision_owner = "test owner"
  ), file.path(root, "docs", "stage-01-02-start-framing", "stage1_decision.json"), auto_unbox = TRUE, pretty = TRUE)

  write_json(list(
    stage = 2,
    status = "LOCKED",
    analytical_question = "test question"
  ), file.path(root, "docs", "stage-01-02-start-framing", "stage2_framing.json"), auto_unbox = TRUE, pretty = TRUE)

  write_json(list(
    stage = 3,
    status = "LOCKED",
    design_version = "stage3-v1",
    population = "test",
    grain = "one row per request",
    request_id = "SR_NUMBER",
    decision_window = list(start = "2026-01-01", end = "2026-02-01"),
    open_definition = "test",
    urgency_definition = "test",
    decision_rules = list(ESCALATE = "x", INCONCLUSIVE = "y", STANDARD = "z"),
    selected_definition = "test",
    locked_knob = list(name = "k", value = 1),
    reconciliation_critical_fields = c("SR_NUMBER", "action"),
    source_delivery_contract = "test",
    fixture_version = "fixtures-v1",
    required_outputs = c("action list")
  ), file.path(root, "docs", "stage-03-measurement-design", "stage3_locked_design.json"), auto_unbox = TRUE, pretty = TRUE)

  write_json(list(
    stage = 4,
    status = if (reconciliation == "PASS") "PASS" else "FAIL",
    design_version_used = "stage3-v1",
    fixture_version_used = "fixtures-v1",
    sql_source_gate = "PASS",
    r_a_fixtures = "PASS",
    r_b_fixtures = "PASS",
    r_a_status = "PASS",
    r_b_status = "PASS",
    reconciliation = reconciliation,
    structural_cross_review = "PASS",
    lineage_attestation = "PASS",
    validation_gate = if (reconciliation == "PASS") "PASS" else "FAIL",
    unresolved_issues = if (reconciliation == "PASS") 0 else 1,
    artifact_paths = artifacts
  ), file.path(root, "docs", "stage-04-execution-validation", "stage4_validation_status.json"), auto_unbox = TRUE, pretty = TRUE)
}

run_gate <- function(root) {
  system2("Rscript", c(shQuote(gate_script), shQuote(root)), stdout = TRUE, stderr = TRUE)
  attr(system2("Rscript", c(shQuote(gate_script), shQuote(root)), stdout = FALSE, stderr = FALSE), "status")
}

# PASS case.
pass_root <- tempfile("chicago311_gate_pass_")
dir.create(pass_root)
write_receipts(pass_root, reconciliation = "PASS")
pass_status <- system2("Rscript", c(shQuote(gate_script), shQuote(pass_root)), stdout = FALSE, stderr = FALSE)
stopifnot(identical(pass_status, 0L))
pass_report <- fromJSON(file.path(pass_root, "validation", "workflow-gate", "workflow_gate_status.json"))
stopifnot(identical(pass_report$result, "PASS"), isTRUE(pass_report$stage5_allowed))

# Deliberate FAIL case.
fail_root <- tempfile("chicago311_gate_fail_")
dir.create(fail_root)
write_receipts(fail_root, reconciliation = "FAIL")
fail_status <- system2("Rscript", c(shQuote(gate_script), shQuote(fail_root)), stdout = FALSE, stderr = FALSE)
stopifnot(!identical(fail_status, 0L))
fail_report <- fromJSON(file.path(fail_root, "validation", "workflow-gate", "workflow_gate_status.json"))
stopifnot(identical(fail_report$result, "FAIL"), !isTRUE(fail_report$stage5_allowed))

cat("Chicago 311 workflow-gate tests passed.\n")
