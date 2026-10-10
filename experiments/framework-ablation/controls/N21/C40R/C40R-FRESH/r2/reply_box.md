# =============================================================================
# R-B/R/20_integrity_and_classify.R
#
# Chicago 311 — Stage 4 — Independent R-B judged path
# Design: stage3-v1-tcd-ig
# Construct: Type-Conditional Dormancy with Integrity Gate (TCD-IG)
#
# Responsibilities:
#   1. Preserve request-level grain and input order.
#   2. Establish decision-set membership.
#   3. Join empirical Completed-peer statistics.
#   4. Apply the integrity predicate matrix.
#   5. Assign exactly one classification to each decision-set row.
#   6. Produce portfolio and kappa-grid counts.
#
# Dependencies: base R and frozen R-B configuration/parsing helpers.
# No R-A imports, SQL queries, or additional package dependencies.
# =============================================================================


# =============================================================================
# 1. REQUEST-LEVEL INTEGRITY AND CLASSIFICATION
# =============================================================================

rb_judge_rows <- function(
    open_df,
    peer_df,
    kappa = RB_KAPPA_DEFAULT,
    t_freeze = RB_T_FREEZE
) {

  # ---------------------------------------------------------------------------
  # Parameter and input contracts
  # ---------------------------------------------------------------------------

  if (
    length(kappa) != 1L ||
    !is.numeric(kappa) ||
    is.na(kappa) ||
    !is.finite(kappa) ||
    kappa < 1
  ) {
    stop("kappa must be one finite numeric value >= 1", call. = FALSE)
  }

  required_open <- c(
    "SR_NUMBER",
    "STATUS",
    "type_key",
    "created_ts",
    "mod_ts",
    "closed_ts",
    "DUPLICATE",
    "LEGACY_RECORD",
    "PARENT_SR_NUMBER"
  )

  required_peer <- c(
    "type_key",
    "peer_n",
    "peer_p50_h",
    "peer_p75_h"
  )

  if (!all(required_open %in% names(open_df))) {
    stop(
      "open_df is missing required normalized columns",
      call. = FALSE
    )
  }

  if (!all(required_peer %in% names(peer_df))) {
    stop(
      "peer_df is missing required normalized columns",
      call. = FALSE
    )
  }

  n <- nrow(open_df)

  # Preserve source order. No aggregation or parent/child collapse.
  sr_number <- as.character(open_df$SR_NUMBER)
  type_key <- as.character(open_df$type_key)
  status <- as.character(open_df$STATUS)

  # ---------------------------------------------------------------------------
  # Frozen decision-set membership
  # ---------------------------------------------------------------------------

  status_normalized <- tolower(trimws(status))

  is_open <- !is.na(status_normalized) &
    status_normalized == "open"

  is_duplicate <- rb_truthy(open_df$DUPLICATE)
  is_legacy <- rb_truthy(open_df$LEGACY_RECORD)

  in_decision_set <- is_open &
    !is_duplicate &
    !is_legacy

  out_of_set_reason <- rep(NA_character_, n)

  out_of_set_reason[!is_open] <- "not_open"

  out_of_set_reason[is_open & is_duplicate] <-
    "duplicate"

  out_of_set_reason[
    is_open & !is_duplicate & is_legacy
  ] <- "legacy"

  # ---------------------------------------------------------------------------
  # Peer association: exactly one result per source request
  # ---------------------------------------------------------------------------

  peer_index <- match(
    type_key,
    as.character(peer_df$type_key)
  )

  peer_n <- as.integer(peer_df$peer_n[peer_index])

  peer_p50_h <- as.numeric(
    peer_df$peer_p50_h[peer_index]
  )

  peer_p75_h <- as.numeric(
    peer_df$peer_p75_h[peer_index]
  )

  # An absent type-level peer record represents zero available peers.
  # Its empirical percentiles remain undefined.
  peer_n[is.na(peer_n)] <- 0L

  # ---------------------------------------------------------------------------
  # Time measurements
  # ---------------------------------------------------------------------------

  created_ts <- open_df$created_ts
  mod_ts <- open_df$mod_ts
  closed_ts <- open_df$closed_ts

  open_age_h <- rb_hours_diff(
    t_freeze,
    created_ts
  )

  dormant_h <- rb_hours_diff(
    t_freeze,
    mod_ts
  )

  # ---------------------------------------------------------------------------
  # Integrity predicate matrix
  #
  # First applicable clause is authoritative.
  #
  # I01: Open request with a populated, parseable CLOSED_DATE
  # I02: Invalid required clocks or impossible timestamp order
  # I03: Missing request type
  # I04: Insufficient or missing empirical peer evidence
  # I05: Unresolved parent request
  # I06: Ambiguous duplicate flag on an otherwise retained row
  # ---------------------------------------------------------------------------

  i01_open_closed <- !is.na(closed_ts)

  i02_bad_clock <- (
    is.na(created_ts) |
    is.na(mod_ts) |
    (!is.na(created_ts) & created_ts > t_freeze) |
    (
      !is.na(created_ts) &
      !is.na(mod_ts) &
      mod_ts < created_ts
    )
  )

  i02_bad_clock[is.na(i02_bad_clock)] <- TRUE

  i03_blank_type <- rb_is_blank(type_key)

  i04_thin_peer <- (
    peer_n < RB_N_MIN |
    is.na(peer_p75_h) |
    !is.finite(peer_p75_h) |
    peer_p75_h < 0
  )

  i04_thin_peer[is.na(i04_thin_peer)] <- TRUE

  # Resolve parent references only against the supplied frozen extract.
  # A parent must resolve uniquely and have a known STATUS.
  # Request grain remains unchanged.
  parent_id <- trimws(
    as.character(open_df$PARENT_SR_NUMBER)
  )

  has_parent <- !rb_is_blank(parent_id)

  parent_index <- match(parent_id, sr_number)

  parent_status_known <- rep(FALSE, n)

  resolved_index <- which(
    has_parent & !is.na(parent_index)
  )

  if (length(resolved_index) > 0L) {

    matched_status <- status[
      parent_index[resolved_index]
    ]

    parent_status_known[resolved_index] <-
      !rb_is_blank(matched_status)
  }

  # A repeated parent ID is not an unambiguous resolution.
  repeated_sr <- duplicated(sr_number) |
    duplicated(sr_number, fromLast = TRUE)

  parent_unique <- rep(FALSE, n)

  if (length(resolved_index) > 0L) {
    parent_unique[resolved_index] <-
      !repeated_sr[parent_index[resolved_index]]
  }

  i05_unresolved_parent <- has_parent &
    !(parent_status_known & parent_unique)

  # The source flags are normally explicit true/false values.
  # A retained row with an ambiguous DUPLICATE value must not
  # silently receive a substantive priority classification.
  duplicate_text <- tolower(
    trimws(as.character(open_df$DUPLICATE))
  )

  valid_duplicate_false <- duplicate_text %in% c(
    "false", "f", "0", "no", "n"
  )

  valid_duplicate_flag <- is_duplicate |
    valid_duplicate_false

  i06_ambiguous_duplicate <- !valid_duplicate_flag

  i06_ambiguous_duplicate[
    is.na(i06_ambiguous_duplicate)
  ] <- TRUE

  # ---------------------------------------------------------------------------
  # First-failing-clause assignment
  # ---------------------------------------------------------------------------

  integrity_clause <- rep(NA_character_, n)

  assign_clause <- function(predicate, clause_id) {

    take <- in_decision_set &
      is.na(integrity_clause) &
      predicate

    take[is.na(take)] <- FALSE

    integrity_clause[take] <<- clause_id

    invisible(NULL)
  }

  assign_clause(
    i01_open_closed,
    "I01_open_closed_date"
  )

  assign_clause(
    i02_bad_clock,
    "I02_bad_clock"
  )

  assign_clause(
    i03_blank_type,
    "I03_blank_type_key"
  )

  assign_clause(
    i04_thin_peer,
    "I04_thin_peer_n"
  )

  assign_clause(
    i05_unresolved_parent,
    "I05_unresolved_parent"
  )

  assign_clause(
    i06_ambiguous_duplicate,
    "I06_ambiguous_duplicate"
  )

  # ---------------------------------------------------------------------------
  # Classification
  #
  # 0. Outside decision set => NA
  # 1. Integrity failure   => INCONCLUSIVE
  # 2. Dormancy >= kappa * empirical peer P75 => ESCALATE
  # 3. Remaining coherent requests => STANDARD
  # ---------------------------------------------------------------------------

  classification <- rep(NA_character_, n)
  evidence_reason <- rep(NA_character_, n)

  inconclusive <- in_decision_set &
    !is.na(integrity_clause)

  classification[inconclusive] <- "INCONCLUSIVE"

  evidence_reason[inconclusive] <-
    integrity_clause[inconclusive]

  coherent <- in_decision_set &
    is.na(integrity_clause)

  threshold_h <- kappa * peer_p75_h

  escalate <- coherent &
    !is.na(dormant_h) &
    !is.na(threshold_h) &
    dormant_h >= threshold_h

  escalate[is.na(escalate)] <- FALSE

  standard <- coherent & !escalate

  classification[escalate] <- "ESCALATE"
  classification[standard] <- "STANDARD"

  # ---------------------------------------------------------------------------
  # Evidence strings
  #
  # Locked reference-compatible reason codes and numeric precision.
  # ---------------------------------------------------------------------------

  if (any(escalate)) {

    evidence_reason[escalate] <- sprintf(
      paste0(
        "E_dormant_ge_kappa_p75 ",
        "(dormant_h=%.4f, kappa=%.2f, peer_p75_h=%.4f)"
      ),
      dormant_h[escalate],
      kappa,
      peer_p75_h[escalate]
    )
  }

  if (any(standard)) {

    evidence_reason[standard] <- sprintf(
      paste0(
        "S_dormant_lt_kappa_p75 ",
        "(dormant_h=%.4f, kappa=%.2f, peer_p75_h=%.4f)"
      ),
      dormant_h[standard],
      kappa,
      peer_p75_h[standard]
    )
  }

  # ---------------------------------------------------------------------------
  # Output contract
  # ---------------------------------------------------------------------------

  result <- data.frame(
    SR_NUMBER = sr_number,
    type_key = type_key,
    STATUS = status,
    in_decision_set = in_decision_set,
    out_of_set_reason = out_of_set_reason,
    classification = classification,
    evidence_reason = evidence_reason,
    dormant_h = as.numeric(dormant_h),
    open_age_h = as.numeric(open_age_h),
    peer_n = as.integer(peer_n),
    peer_p75_h = as.numeric(peer_p75_h),
    peer_p50_h = as.numeric(peer_p50_h),
    kappa = rep(as.numeric(kappa), n),
    integrity_clause = integrity_clause,
    rule_version = rep(RB_RULE_VERSION, n),
    design_version = rep(RB_DESIGN_VERSION, n),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )

  # Preserve input row count and row order.
  stopifnot(nrow(result) == n)

  # Every member of the decision set must receive exactly one label.
  valid_labels <- c(
    "ESCALATE",
    "STANDARD",
    "INCONCLUSIVE"
  )

  if (
    any(
      in_decision_set &
      (
        is.na(result$classification) |
        !(result$classification %in% valid_labels)
      )
    )
  ) {
    stop(
      "Decision-set row lacks a valid classification",
      call. = FALSE
    )
  }

  if (
    any(
      !in_decision_set &
      !is.na(result$classification)
    )
  ) {
    stop(
      "An out-of-set row received a classification",
      call. = FALSE
    )
  }

  rownames(result) <- NULL

  result
}


# =============================================================================
# 2. PORTFOLIO COUNTS
# =============================================================================

rb_portfolio_counts <- function(
    judged,
    kappa = RB_KAPPA_DEFAULT
) {

  if (
    !all(
      c("in_decision_set", "classification") %in%
        names(judged)
    )
  ) {
    stop(
      "judged is missing required classification columns",
      call. = FALSE
    )
  }

  labels <- judged$classification

  n_decision <- sum(
    judged$in_decision_set,
    na.rm = TRUE
  )

  n_out_of_set <- nrow(judged) - n_decision

  n_escalate <- sum(
    labels == "ESCALATE",
    na.rm = TRUE
  )

  n_inconclusive <- sum(
    labels == "INCONCLUSIVE",
    na.rm = TRUE
  )

  n_standard <- sum(
    labels == "STANDARD",
    na.rm = TRUE
  )

  if (
    n_decision !=
    n_escalate + n_inconclusive + n_standard
  ) {
    stop(
      "Portfolio counts do not partition the decision set",
      call. = FALSE
    )
  }

  if (
    nrow(judged) != n_decision + n_out_of_set
  ) {
    stop(
      "Portfolio counts do not reconcile to input rows",
      call. = FALSE
    )
  }

  # The production portfolio reference contains n_out_of_set
  # as its sixth column. The kappa-grid export intentionally
  # retains only the first five columns.

  data.frame(
    kappa = as.numeric(kappa),
    n_decision = as.integer(n_decision),
    n_ESCALATE = as.integer(n_escalate),
    n_INCONCLUSIVE = as.integer(n_inconclusive),
    n_STANDARD = as.integer(n_standard),
    n_out_of_set = as.integer(n_out_of_set),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}


# =============================================================================
# 3. KAPPA GRID — COUNTS-ONLY DIAGNOSTIC
# =============================================================================

rb_kappa_grid_counts <- function(
    open_df,
    peer_df,
    grid = RB_KAPPA_GRID,
    t_freeze = RB_T_FREEZE
) {

  grid <- as.numeric(grid)

  if (
    anyNA(grid) ||
    any(!is.finite(grid)) ||
    any(grid < 1)
  ) {
    stop(
      "All kappa-grid values must be finite and >= 1",
      call. = FALSE
    )
  }

  if (length(grid) == 0L) {

    return(
      data.frame(
        kappa = numeric(0),
        n_decision = integer(0),
        n_ESCALATE = integer(0),
        n_INCONCLUSIVE = integer(0),
        n_STANDARD = integer(0)
      )
    )
  }

  counts <- lapply(
    grid,
    function(current_kappa) {

      judged <- rb_judge_rows(
        open_df = open_df,
        peer_df = peer_df,
        kappa = current_kappa,
        t_freeze = t_freeze
      )

      rb_portfolio_counts(
        judged = judged,
        kappa = current_kappa
      )
    }
  )

  result <- do.call(rbind, counts)

  rownames(result) <- NULL

  # The diagnostic reports exactly five count columns.
  result <- result[, c(
    "kappa",
    "n_decision",
    "n_ESCALATE",
    "n_INCONCLUSIVE",
    "n_STANDARD"
  ), drop = FALSE]

  result
}


Changes:
- Added n_out_of_set as the sixth portfolio column, matching the supplied reference SHA-256 for the reported counts.
- Added an explicit portfolio row-count reconciliation check.
- Preserved the previously matching classification logic, evidence formatting, and five-column κ-grid.
- No frozen files were modified.
- Verification status: Portfolio serialization is hash-supported; classification and κ-grid matching are supported by the prior gate report. The fixture CSV mismatch remains unresolved without reference-side differences. Full gate PASS is not claimed.
END C40R BUILD FRESH r2
