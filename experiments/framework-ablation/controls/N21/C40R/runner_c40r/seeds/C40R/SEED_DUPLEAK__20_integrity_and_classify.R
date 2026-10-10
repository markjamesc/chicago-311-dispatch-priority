# Integrity gate + κ classification (predicate-matrix style)

#' Apply locked decision rules independently (R-B).
#' Returns one row per input SR with classification or OUT_OF_SET.
rb_judge_rows <- function(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE) {
  peers <- peer_df[!duplicated(peer_df$type_key), , drop = FALSE]
  joined <- merge(open_df, peers, by = "type_key", all.x = TRUE, sort = FALSE)

  # Preserve original row order via SR_NUMBER match when possible
  if ("SR_NUMBER" %in% names(open_df)) {
    ord <- match(open_df$SR_NUMBER, joined$SR_NUMBER)
    # merge can scramble; rebuild by left join manually
    joined <- open_df
    peer_idx <- match(joined$type_key, peers$type_key)
    joined$peer_n <- peers$peer_n[peer_idx]
    joined$peer_p50_h <- peers$peer_p50_h[peer_idx]
    joined$peer_p75_h <- peers$peer_p75_h[peer_idx]
  }

  n <- nrow(joined)
  status_norm <- trimws(as.character(joined$STATUS))
  is_open <- tolower(status_norm) == "open"

  dup_flag <- rb_truthy(joined$DUPLICATE)
  leg_flag <- rb_truthy(joined$LEGACY_RECORD)
  parent_nonblank <- !rb_is_blank(joined$PARENT_SR_NUMBER)

  created_ts <- joined$created_ts
  mod_ts <- joined$mod_ts
  closed_ts <- joined$closed_ts

  # Prefer CLOSED_DATE string presence for contradiction when closed_ts NA but string set
  closed_str_set <- !rb_is_blank(joined$CLOSED_DATE)

  peer_n <- joined$peer_n
  peer_n[is.na(peer_n)] <- 0L
  peer_p75 <- joined$peer_p75_h

  dormant_h <- rep(NA_real_, n)
  open_age_h <- rep(NA_real_, n)
  has_created <- !is.na(created_ts)
  has_mod <- !is.na(mod_ts)
  ok_clocks <- has_created & has_mod & (mod_ts >= created_ts) & (created_ts <= t_freeze)
  dormant_h[ok_clocks] <- rb_hours_diff(t_freeze, mod_ts[ok_clocks])
  open_age_h[has_created] <- rb_hours_diff(t_freeze, created_ts[has_created])

  # Integrity predicates (first-pass codes; earliest wins for reason)
  # I01 Open+CLOSED_DATE set
  # I02 bad clocks (unparseable created/mod, mod<created, created>T)
  # I03 blank type_key
  # I04 peer_n < n_min (incl missing peer)
  # I05 nonblank PARENT_SR_NUMBER
  # I06 missing dormant clocks (mod missing → cannot compute dormant)

  p_closed_contra <- is_open & (closed_str_set | !is.na(closed_ts))
  p_bad_clock <- is.na(created_ts) | is.na(mod_ts) | (!is.na(created_ts) & !is.na(mod_ts) & mod_ts < created_ts) |
    (!is.na(created_ts) & created_ts > t_freeze)
  p_blank_type <- rb_is_blank(joined$type_key)
  p_thin <- peer_n < RB_N_MIN
  p_parent <- parent_nonblank
  p_missing_dormant <- is.na(mod_ts) | is.na(dormant_h)

  integrity_clause <- rep(NA_character_, n)
  integrity_clause[p_closed_contra] <- "I01_open_closed_date"
  integrity_clause[is.na(integrity_clause) & p_bad_clock] <- "I02_bad_clocks"
  integrity_clause[is.na(integrity_clause) & p_blank_type] <- "I03_blank_type_key"
  integrity_clause[is.na(integrity_clause) & p_thin] <- "I04_thin_peer_n"
  integrity_clause[is.na(integrity_clause) & p_parent] <- "I05_parent_sr_present"
  integrity_clause[is.na(integrity_clause) & p_missing_dormant] <- "I06_missing_dormant_clock"

  integrity_fail <- !is.na(integrity_clause)

  # Decision-set membership
  # Open already filtered in SQL for production; still enforce for fixtures.
  # Exclude: not Open; DUPLICATE true-like; LEGACY true-like
  in_decision <- is_open & !leg_flag

  classification <- rep(NA_character_, n)
  evidence_reason <- rep(NA_character_, n)

  # OUT_OF_SET markers for audit (not written as production labels)
  out_reason <- rep(NA_character_, n)
  out_reason[!is_open] <- "OUT_not_open"
  out_reason[is_open & dup_flag] <- "OUT_duplicate"
  out_reason[is_open & !dup_flag & leg_flag] <- "OUT_legacy"

  classification[in_decision & integrity_fail] <- "INCONCLUSIVE"
  evidence_reason[in_decision & integrity_fail] <- integrity_clause[in_decision & integrity_fail]

  # κ rule among coherent decision rows
  eligible_coherent <- in_decision & !integrity_fail
  thresh <- kappa * peer_p75
  escalate <- eligible_coherent & !is.na(dormant_h) & !is.na(thresh) & (dormant_h >= thresh)
  standard <- eligible_coherent & !escalate

  classification[escalate] <- "ESCALATE"
  evidence_reason[escalate] <- sprintf("E_dormant_ge_kappa_p75 (dormant_h=%.4f, kappa=%.2f, peer_p75_h=%.4f)",
                                       dormant_h[escalate], kappa, peer_p75[escalate])
  classification[standard] <- "STANDARD"
  evidence_reason[standard] <- sprintf("S_dormant_lt_kappa_p75 (dormant_h=%.4f, kappa=%.2f, peer_p75_h=%.4f)",
                                       dormant_h[standard], kappa, peer_p75[standard])

  data.frame(
    SR_NUMBER = joined$SR_NUMBER,
    type_key = joined$type_key,
    STATUS = joined$STATUS,
    classification = classification,
    evidence_reason = evidence_reason,
    dormant_h = dormant_h,
    open_age_h = open_age_h,
    peer_n = as.integer(peer_n),
    peer_p75_h = peer_p75,
    peer_p50_h = joined$peer_p50_h,
    kappa = rep(kappa, n),
    integrity_clause = integrity_clause,
    in_decision_set = in_decision,
    out_of_set_reason = out_reason,
    rule_version = RB_RULE_VERSION,
    design_version = RB_DESIGN_VERSION,
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

rb_portfolio_counts <- function(judged, kappa = RB_KAPPA_DEFAULT) {
  lab <- judged$classification[judged$in_decision_set %in% TRUE]
  data.frame(
    kappa = kappa,
    n_decision = length(lab),
    n_ESCALATE = sum(lab == "ESCALATE", na.rm = TRUE),
    n_INCONCLUSIVE = sum(lab == "INCONCLUSIVE", na.rm = TRUE),
    n_STANDARD = sum(lab == "STANDARD", na.rm = TRUE),
    n_out_of_set = sum(!judged$in_decision_set, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}

rb_kappa_grid_counts <- function(open_df, peer_df, grid = RB_KAPPA_GRID, t_freeze = RB_T_FREEZE) {
  rows <- lapply(grid, function(k) {
    j <- rb_judge_rows(open_df, peer_df, kappa = k, t_freeze = t_freeze)
    rb_portfolio_counts(j, kappa = k)
  })
  do.call(rbind, rows)
}
