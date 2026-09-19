# R-B config — Stage 4 TCD-IG (independent path; no R-A imports)
# design_version: stage3-v1-tcd-ig | fixture_version: fixtures-v1-tcd-ig

RB_RULE_VERSION <- "RB-tcd-ig-v1"
RB_DESIGN_VERSION <- "stage3-v1-tcd-ig"
RB_FIXTURE_VERSION <- "fixtures-v1-tcd-ig"
RB_SNAPSHOT_ID <- "chicago311-raw-frozen-2026-09-12"

# Locked freeze instant (America/Chicago wall clock)
RB_T_FREEZE <- as.POSIXct("2026-09-12 23:59:59", tz = "America/Chicago")

# Owner-tunable production knob
RB_KAPPA_DEFAULT <- 2.0

# Method constants (not knobs)
RB_N_MIN <- 50L
RB_KAPPA_GRID <- c(1.0, 1.5, 2.0, 3.0)

# Path resolution: R-B lives at <project>/R-B/
rb_project_root <- function() {
  env <- Sys.getenv("CHICAGO311_ROOT", unset = "")
  if (nzchar(env) && dir.exists(env)) return(normalizePath(env, winslash = "/", mustWork = FALSE))
  # Prefer script location when sourced via Rscript
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) == 1) {
    script_path <- normalizePath(sub("^--file=", "", file_arg), winslash = "/", mustWork = FALSE)
    rb_dir <- dirname(script_path)
    return(normalizePath(file.path(rb_dir, ".."), winslash = "/", mustWork = FALSE))
  }
  # Fallback: cwd / parent
  if (basename(getwd()) == "R-B") {
    return(normalizePath("..", winslash = "/", mustWork = FALSE))
  }
  if (dir.exists("R-B")) {
    return(normalizePath(".", winslash = "/", mustWork = FALSE))
  }
  normalizePath(getwd(), winslash = "/", mustWork = FALSE)
}

rb_paths <- function(root = rb_project_root()) {
  list(
    root = root,
    rb_dir = file.path(root, "R-B"),
    open_csv = file.path(root, "data", "source", "src_open_candidates.csv"),
    peer_csv = file.path(root, "data", "source", "src_peer_stats.csv"),
    out_dir = file.path(root, "R-B", "outputs"),
    notes = file.path(root, "R-B", "RB_BUILD_NOTES.md")
  )
}
