# =============================================================================
# Chicago 311 — independent R-B integrity gate and TCD-IG decision rule
# Design: stage3-v1-tcd-ig | One row per input SR_NUMBER; input order retained
# Dependencies supplied by frozen 00_config.R and 10_io_parse.R
# =============================================================================

rb_judge_rows <- function(open_df, peer_df,
                          kappa = RB_KAPPA_DEFAULT,
                          t_freeze = RB_T_FREEZE) {
  required_open <- c(
    "SR_NUMBER", "STATUS", "type_key", "CREATED_DATE", "CLOSED_DATE",
    "created_ts", "mod_ts", "closed_ts", "DUPLICATE",
    "LEGACY_RECORD", "PARENT_SR_NUMBER"
  )
  required_peer <- c("type_key", "peer_n", "peer_p50_h", "peer_p75_h")

  if (!is.data.frame(open_df) || !is.data.frame(peer_df)) {
    stop("open_df and peer_df must be data.frames", call. = FALSE)
  }
  if (!all(required_open %in% names(open_df))) {
    stop("Missing normalized open columns: ",
         paste(setdiff(required_open, names(open_df)), collapse = ", "),
         call. = FALSE)
  }
  if (!all(required_peer %in% names(peer_df))) {
    stop("Missing normalized peer columns: ",
         paste(setdiff(required_peer, names(peer_df)), collapse = ", "),
         call. = FALSE)
  }
  if (length(kappa) != 1L || is.na(kappa) ||
      !is.finite(kappa) || kappa < 1) {
    stop("kappa must be a finite scalar >= 1", call. = FALSE)
  }
  if (length(t_freeze) != 1L || is.na(t_freeze)) {
    stop("t_freeze must be a single nonmissing timestamp", call. = FALSE)
  }

  n <- nrow(open_df)
  sr <- trimws(as.character(open_df$SR_NUMBER))
  status_raw <- trimws(as.character(open_df$STATUS))
  status <- tolower(status_raw)
  status[is.na(status)] <- ""
  type_key <- trimws(as.character(open_df$type_key))
  type_key[rb_is_blank(type_key)] <- NA_character_
  parent <- trimws(as.character(open_df$PARENT_SR_NUMBER))

  # Enforce the locked Open token.
  is_open <- status == "open"
  open_like <- grepl("^open($|[^[:alnum:]])", status)

  duplicate <- rb_truthy(open_df$DUPLICATE)
  legacy <- rb_truthy(open_df$LEGACY_RECORD)
  in_decision_set <- open_like & !duplicate & !legacy

  out_of_set_reason <- rep(NA_character_, n)
  out_of_set_reason[!open_like] <- "NOT_OPEN"
  out_of_set_reason[open_like & duplicate] <- "DUPLICATE"
  out_of_set_reason[open_like & !duplicate & legacy] <- "LEGACY_RECORD"

  flag_unknown <- function(x) {
    raw <- tolower(trimws(as.character(x)))
    good_false <- raw %in% c("false", "f", "0", "no", "n")
    !(rb_truthy(x) | good_false)
  }

  duplicate_unknown <- flag_unknown(open_df$DUPLICATE)
  legacy_unknown <- flag_unknown(open_df$LEGACY_RECORD)

  created_ts <- open_df$created_ts
  mod_ts <- open_df$mod_ts
  closed_ts <- open_df$closed_ts

  if (!inherits(created_ts, "POSIXt")) {
    created_ts <- rb_parse_ts(created_ts)
  }
  if (!inherits(mod_ts, "POSIXt")) {
    mod_ts <- rb_parse_ts(mod_ts)
  }
  if (!inherits(closed_ts, "POSIXt")) {
    closed_ts <- rb_parse_ts(closed_ts)
  }

  open_age_h <- rb_hours_diff(t_freeze, created_ts)
  dormant_h <- rb_hours_diff(t_freeze, mod_ts)

  # Keyed lookup preserves input order and row cardinality.
  peer_key <- trimws(as.character(peer_df$type_key))
  peer_i <- match(type_key, peer_key)

  peer_n <- rep(NA_integer_, n)
  peer_p50_h <- rep(NA_real_, n)
  peer_p75_h <- rep(NA_real_, n)

  has_peer <- !is.na(peer_i)

  peer_n[has_peer] <- suppressWarnings(
    as.integer(peer_df$peer_n[peer_i[has_peer]])
  )
  peer_p50_h[has_peer] <- suppressWarnings(
    as.numeric(peer_df$peer_p50_h[peer_i[has_peer]])
  )
  peer_p75_h[has_peer] <- suppressWarnings(
    as.numeric(peer_df$peer_p75_h[peer_i[has_peer]])
  )

  # No matching Completed peers means a peer count of zero.
  # Percentiles remain unavailable for those types.
  peer_n[!has_peer] <- 0L

  repeated_peer <- unique(peer_key[
    duplicated(peer_key) | duplicated(peer_key, fromLast = TRUE)
  ])
  peer_ambiguous <- !is.na(type_key) &
    type_key %in% repeated_peer

  # Resolve parent references only against unique, known-status requests.
  valid_sr <- !rb_is_blank(sr)
  repeated_sr <- unique(sr[valid_sr &
    (duplicated(sr) | duplicated(sr, fromLast = TRUE))])

  parent_present <- !rb_is_blank(parent)
  parent_i <- match(parent, sr)
  parent_status <- rep("", n)
  parent_found <- !is.na(parent_i)
  parent_status[parent_found] <- status[parent_i[parent_found]]

  parent_known <- parent_status %in% c(
    "open", "completed", "closed", "canceled", "cancelled"
  )

  orphan_parent <- parent_present & (
    !parent_found | parent %in% repeated_sr | !parent_known
  )

  # Open with populated CLOSED_DATE contradicts the Open status.
  closed_raw <- toupper(trimws(as.character(open_df$CLOSED_DATE)))
  closed_raw_set <- !rb_is_blank(closed_raw) &
    !(closed_raw %in% c("NULL", "NA", "N/A"))
  has_closed <- !is.na(closed_ts) | closed_raw_set

  # Integrity predicate matrix: first violated clause wins.
  integrity_clause <- rep(NA_character_, n)

  put_clause <- function(test, code) {
    test[is.na(test)] <- FALSE
    at <- in_decision_set & is.na(integrity_clause) & test
    integrity_clause[at] <<- code
  }

  put_clause(!is_open, "I06_open_token")
  put_clause(has_closed, "I01_open_closed_date")
  put_clause(is.na(created_ts), "I02_bad_clock")
  put_clause(is.na(mod_ts), "I02_bad_clock")

  put_clause(
    !is.na(created_ts) & created_ts > t_freeze,
    "I02_bad_clock"
  )
  put_clause(
    !is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts,
    "I02_bad_clock"
  )
  put_clause(
    !is.na(mod_ts) & mod_ts > t_freeze,
    "I02_bad_clock"
  )

  put_clause(is.na(type_key), "I03_blank_type_key")
  put_clause(duplicate_unknown, "I06_bad_flag")
  put_clause(legacy_unknown, "I06_bad_flag")
  put_clause(orphan_parent, "I05_unresolved_parent")

  put_clause(
    rb_is_blank(sr) | sr %in% repeated_sr,
    "I06_invalid_grain"
  )

  put_clause(
    !has_peer | peer_ambiguous | is.na(peer_n) |
      (!is.na(peer_n) & peer_n < RB_N_MIN),
    "I04_thin_peer_n"
  )

  put_clause(
    !is.finite(peer_p75_h) | peer_p75_h < 0,
    "I06_invalid_peer_p75"
  )

  integrity_fail <- in_decision_set & !is.na(integrity_clause)
  threshold_h <- as.numeric(kappa) * peer_p75_h
  coherent <- in_decision_set & !integrity_fail

  escalate <- coherent & !is.na(dormant_h) &
    !is.na(threshold_h) & dormant_h >= threshold_h

  classification <- rep(NA_character_, n)
  classification[integrity_fail] <- "INCONCLUSIVE"
  classification[coherent & !escalate] <- "STANDARD"
  classification[escalate] <- "ESCALATE"

  # Reason text for classified rows follows the reference convention.
  evidence_reason <- rep(NA_character_, n)
  evidence_reason[integrity_fail] <- integrity_clause[integrity_fail]

  # Retain an explicit exclusion audit reason without assigning a label.
  # This affects only out-of-set rows, which production does not export.
  outside <- which(!in_decision_set)
  if (length(outside)) {
    evidence_reason[outside] <- paste0(
      "X_", tolower(out_of_set_reason[outside])
    )
  }

  accepted <- which(coherent)

  if (length(accepted)) {
    reason_code <- ifelse(
      escalate[accepted],
      "E_dormant_ge_kappa_p75",
      "S_dormant_lt_kappa_p75"
    )

    evidence_reason[accepted] <- sprintf(
      "%s (dormant_h=%.4f, kappa=%.2f, peer_p75_h=%.4f)",
      reason_code,
      dormant_h[accepted],
      as.numeric(kappa),
      peer_p75_h[accepted]
    )
  }

  data.frame(
    SR_NUMBER = sr,
    type_key = type_key,
    classification = classification,
    evidence_reason = evidence_reason,
    dormant_h = dormant_h,
    open_age_h = open_age_h,
    peer_n = peer_n,
    peer_p75_h = peer_p75_h,
    peer_p50_h = peer_p50_h,
    kappa = rep(as.numeric(kappa), n),
    integrity_clause = integrity_clause,
    rule_version = rep(RB_RULE_VERSION, n),
    design_version = rep(RB_DESIGN_VERSION, n),
    STATUS = as.character(open_df$STATUS),
    is_open = is_open,
    is_eligible = in_decision_set & is_open &
      !is.na(created_ts) & created_ts <= t_freeze &
      !is.na(type_key),
    integrity_fail = integrity_fail,
    in_decision_set = in_decision_set,
    out_of_set_reason = out_of_set_reason,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

rb_portfolio_counts <- function(judged, kappa = RB_KAPPA_DEFAULT) {
  if (!is.data.frame(judged) ||
      !all(c("in_decision_set", "classification") %in% names(judged))) {
    stop(
      "judged must contain in_decision_set and classification",
      call. = FALSE
    )
  }

  in_set <- !is.na(judged$in_decision_set) &
    judged$in_decision_set

  labels <- as.character(judged$classification[in_set])
  allowed <- c("ESCALATE", "INCONCLUSIVE", "STANDARD")

  if (anyNA(labels) || any(!labels %in% allowed)) {
    stop(
      "Every decision-set row must have exactly one locked label",
      call. = FALSE
    )
  }

  data.frame(
    kappa = as.numeric(kappa),
    n_decision = as.integer(sum(in_set)),
    n_ESCALATE = as.integer(sum(labels == "ESCALATE")),
    n_INCONCLUSIVE = as.integer(sum(labels == "INCONCLUSIVE")),
    n_STANDARD = as.integer(sum(labels == "STANDARD")),
    n_out_of_set = as.integer(sum(!in_set)),
    stringsAsFactors = FALSE
  )
}

rb_kappa_grid_counts <- function(open_df, peer_df,
                                 grid = RB_KAPPA_GRID,
                                 t_freeze = RB_T_FREEZE) {
  if (!is.numeric(grid) || !length(grid) ||
      anyNA(grid) || any(!is.finite(grid)) || any(grid < 1)) {
    stop(
      "grid must contain finite kappa values >= 1",
      call. = FALSE
    )
  }

  per_kappa <- lapply(grid, function(k) {
    judged <- rb_judge_rows(
      open_df,
      peer_df,
      kappa = k,
      t_freeze = t_freeze
    )
    rb_portfolio_counts(judged, kappa = k)
  })

  out <- do.call(rbind, per_kappa)
  rownames(out) <- NULL
  out
}


Round r3 changes: Added exclusion audit reasons for F07, F08, and F12 while retaining their NA classifications. No changes were made to the production classification rules, peer calculations, or portfolio/grid functions.
Verification: This is a candidate repair, not a certified PASS. The supplied gate report lacks reference fixture values or per-column differences, so the exact remaining mismatch cannot be determined conclusively.
Download complete r3 R file
END C40R BUILD INC r3
