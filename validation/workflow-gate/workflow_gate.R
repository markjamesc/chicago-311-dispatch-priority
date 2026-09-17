#!/usr/bin/env Rscript

# Chicago 311 Five-Stage Workflow Gate
# ------------------------------------
# Purpose: verify that the required PROCEDURAL controls were actually completed
# before Stage 5 is allowed to begin.
#
# This script does NOT redo Stage 4 analytical validation. R-A / R-B, fixtures,
# exact reconciliation, and structural cross-review remain inside Stage 4.
# The gate checks the receipts proving those required steps happened against the
# same locked Stage 3 contract, with no unresolved validation failure.
#
# Usage from the repository root:
#   Rscript validation/workflow-gate/workflow_gate.R .
#
# Dependency:
#   install.packages("jsonlite")

suppressPackageStartupMessages(library(jsonlite))

args <- commandArgs(trailingOnly = TRUE)
project_root <- if (length(args) >= 1) normalizePath(args[[1]], mustWork = FALSE) else getwd()

paths <- list(
  stage1 = file.path(project_root, "docs", "stage-01-02-start-framing", "stage1_decision.json"),
  stage2 = file.path(project_root, "docs", "stage-01-02-start-framing", "stage2_framing.json"),
  stage3 = file.path(project_root, "docs", "stage-03-measurement-design", "stage3_locked_design.json"),
  stage4 = file.path(project_root, "docs", "stage-04-execution-validation", "stage4_validation_status.json"),
  gate   = file.path(project_root, "validation", "workflow-gate", "workflow_gate_status.json")
)

checks <- list()

add_check <- function(name, pass, detail) {
  checks[[length(checks) + 1]] <<- list(
    check = name,
    result = if (isTRUE(pass)) "PASS" else "FAIL",
    detail = detail
  )
}

read_json_safe <- function(path, label) {
  if (!file.exists(path)) {
    add_check(paste(label, "receipt exists"), FALSE, paste("Missing:", path))
    return(NULL)
  }

  out <- tryCatch(
    fromJSON(path, simplifyVector = TRUE),
    error = function(e) e
  )

  if (inherits(out, "error")) {
    add_check(paste(label, "receipt parses"), FALSE, conditionMessage(out))
    return(NULL)
  }

  add_check(paste(label, "receipt exists"), TRUE, path)
  add_check(paste(label, "receipt parses"), TRUE, "Valid JSON")
  out
}

has_fields <- function(x, fields) {
  !is.null(x) && all(fields %in% names(x))
}

is_value <- function(x, field, expected) {
  !is.null(x) && field %in% names(x) && identical(as.character(x[[field]]), as.character(expected))
}

stage1 <- read_json_safe(paths$stage1, "Stage 1")
stage2 <- read_json_safe(paths$stage2, "Stage 2")
stage3 <- read_json_safe(paths$stage3, "Stage 3")
stage4 <- read_json_safe(paths$stage4, "Stage 4")

# Stage 1 — locked decision receipt.
required_stage1 <- c("stage", "status", "decision_statement", "decision_owner")
add_check("Stage 1 required fields", has_fields(stage1, required_stage1), paste("Required:", paste(required_stage1, collapse = ", ")))
add_check("Stage 1 locked", is_value(stage1, "status", "LOCKED"), "status must equal LOCKED")

# Stage 2 — locked analytical question receipt.
required_stage2 <- c("stage", "status", "analytical_question")
add_check("Stage 2 required fields", has_fields(stage2, required_stage2), paste("Required:", paste(required_stage2, collapse = ", ")))
add_check("Stage 2 locked", is_value(stage2, "status", "LOCKED"), "status must equal LOCKED")

# Stage 3 — machine-readable measurement contract.
required_stage3 <- c(
  "stage", "status", "design_version", "population", "grain", "request_id",
  "decision_window", "open_definition", "urgency_definition", "decision_rules",
  "selected_definition", "locked_knob", "reconciliation_critical_fields",
  "source_delivery_contract", "fixture_version", "required_outputs"
)
add_check("Stage 3 required fields", has_fields(stage3, required_stage3), paste("Required:", paste(required_stage3, collapse = ", ")))
add_check("Stage 3 locked", is_value(stage3, "status", "LOCKED"), "status must equal LOCKED")

# Stage 4 — receipt for the existing analytical validation chain.
required_stage4 <- c(
  "stage", "status", "design_version_used", "fixture_version_used",
  "sql_source_gate", "r_a_fixtures", "r_b_fixtures", "r_a_status", "r_b_status",
  "reconciliation", "structural_cross_review", "lineage_attestation",
  "validation_gate", "unresolved_issues", "artifact_paths"
)
add_check("Stage 4 required fields", has_fields(stage4, required_stage4), paste("Required:", paste(required_stage4, collapse = ", ")))

if (!is.null(stage3) && !is.null(stage4) &&
    "design_version" %in% names(stage3) && "design_version_used" %in% names(stage4)) {
  same_version <- identical(as.character(stage3$design_version), as.character(stage4$design_version_used))
  add_check(
    "Stage 4 used locked Stage 3 version",
    same_version,
    paste0("Stage 3=", stage3$design_version, "; Stage 4=", stage4$design_version_used)
  )
} else {
  add_check("Stage 4 used locked Stage 3 version", FALSE, "Version fields unavailable")
}

if (!is.null(stage3) && !is.null(stage4) &&
    "fixture_version" %in% names(stage3) && "fixture_version_used" %in% names(stage4)) {
  same_fixture <- identical(as.character(stage3$fixture_version), as.character(stage4$fixture_version_used))
  add_check(
    "Stage 4 used frozen fixture version",
    same_fixture,
    paste0("Stage 3=", stage3$fixture_version, "; Stage 4=", stage4$fixture_version_used)
  )
} else {
  add_check("Stage 4 used frozen fixture version", FALSE, "Fixture version fields unavailable")
}

for (field in c(
  "sql_source_gate", "r_a_fixtures", "r_b_fixtures", "r_a_status", "r_b_status",
  "reconciliation", "structural_cross_review", "lineage_attestation", "validation_gate"
)) {
  add_check(
    paste("Stage 4", field),
    is_value(stage4, field, "PASS"),
    paste(field, "must equal PASS")
  )
}

issues_ok <- !is.null(stage4) &&
  "unresolved_issues" %in% names(stage4) &&
  !is.na(suppressWarnings(as.numeric(stage4$unresolved_issues))) &&
  as.numeric(stage4$unresolved_issues) == 0
add_check("Stage 4 unresolved issues", issues_ok, "unresolved_issues must equal 0")
add_check("Stage 4 overall status", is_value(stage4, "status", "PASS"), "status must equal PASS")

# Verify that Stage 4 did not merely claim PASS: its declared evidence artifacts must exist.
if (!is.null(stage4) && "artifact_paths" %in% names(stage4)) {
  artifact_paths <- unlist(stage4$artifact_paths, use.names = FALSE)
  artifact_paths <- artifact_paths[!is.na(artifact_paths) & nzchar(artifact_paths)]

  add_check("Stage 4 artifact list nonempty", length(artifact_paths) > 0, "artifact_paths must contain preserved evidence files")

  if (length(artifact_paths) > 0) {
    missing_artifacts <- artifact_paths[!file.exists(file.path(project_root, artifact_paths))]
    add_check(
      "Stage 4 declared artifacts exist",
      length(missing_artifacts) == 0,
      if (length(missing_artifacts) == 0) "All declared artifacts exist" else paste("Missing:", paste(missing_artifacts, collapse = ", "))
    )
  }
} else {
  add_check("Stage 4 artifact list nonempty", FALSE, "artifact_paths unavailable")
  add_check("Stage 4 declared artifacts exist", FALSE, "artifact_paths unavailable")
}

all_pass <- length(checks) > 0 && all(vapply(checks, function(x) identical(x$result, "PASS"), logical(1)))

dir.create(dirname(paths$gate), recursive = TRUE, showWarnings = FALSE)

gate_output <- list(
  gate = "chicago_311_five_stage_workflow_gate",
  result = if (all_pass) "PASS" else "FAIL",
  stage5_allowed = all_pass,
  checked_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE),
  project_root = project_root,
  checks = checks
)

write_json(gate_output, paths$gate, pretty = TRUE, auto_unbox = TRUE, null = "null")

cat("\nChicago 311 Five-Stage Workflow Gate\n")
cat("====================================\n")
for (x in checks) {
  cat(sprintf("%-50s %s\n", x$check, x$result))
}
cat("------------------------------------\n")
cat("OVERALL:", gate_output$result, "\n")
cat("STAGE 5 ALLOWED:", if (gate_output$stage5_allowed) "YES" else "NO", "\n")
cat("REPORT:", paths$gate, "\n\n")

if (!all_pass) quit(status = 1, save = "no")
quit(status = 0, save = "no")
