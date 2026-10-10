# Locked fixture pack fixtures-v1-tcd-ig (synthetic; do not rewrite expectations)

rb_hours <- function(days) as.numeric(days) * 24

#' Build synthetic open rows + peer stats for F01–F14
rb_build_fixture_pack <- function(t_freeze = RB_T_FREEZE) {
  # Helper to shift freeze by -hours
  ago <- function(hours) t_freeze - as.difftime(hours, units = "hours")
  fmt <- function(ts) format(ts, "%Y-%m-%d %H:%M:%S")

  # Peer stats for fixture types
  peers <- data.frame(
    type_key = c("POTHOLE", "BUILDING", "FAST", "RARETYPE", "ADDRTYPE"),
    peer_n = c(500L, 200L, 120L, 8L, 80L),
    peer_p50_h = c(rb_hours(3), rb_hours(45), rb_hours(1.5), rb_hours(2), rb_hours(2)),
    peer_p75_h = c(rb_hours(7), rb_hours(90), rb_hours(3), rb_hours(4), rb_hours(3)),
    stringsAsFactors = FALSE
  )

  # F01 ESCALATE: pothole peer_p75=7d; dormant 20d; 20*24=480 >= 2*7*24=336
  # F02 STANDARD: same type; created 40d; mod 1d ago
  # F03 STANDARD: building peer_p75=90d; dormant 100d; 100 < 180
  # F04 INCONCLUSIVE: Open + CLOSED_DATE
  # F05 INCONCLUSIVE: mod before created
  # F06 INCONCLUSIVE: rare type peer_n=8
  # F07 OUT: DUPLICATE true
  # F08 OUT: LEGACY true
  # F09 INCONCLUSIVE: PARENT set
  # F10 STANDARD: peer_p75=3d; dormant 4d; 4 < 6
  # F11 ESCALATE: dormant 8d; 8 >= 6
  # F12 OUT: Completed
  # F13 INCONCLUSIVE: unparseable CREATED
  # F14: two independent STANDARD-ish rows (short dormancy)

  mk <- function(id, type_key, status, created_h_ago, mod_h_ago,
                 closed = "", dup = "false", leg = "false", parent = "",
                 created_raw = NULL, mod_raw = NULL) {
    created_ts <- if (is.null(created_h_ago)) as.POSIXct(NA, tz = "America/Chicago") else ago(created_h_ago)
    mod_ts <- if (is.null(mod_h_ago)) as.POSIXct(NA, tz = "America/Chicago") else ago(mod_h_ago)
    created_s <- if (!is.null(created_raw)) created_raw else if (is.na(created_ts)) "" else fmt(created_ts)
    mod_s <- if (!is.null(mod_raw)) mod_raw else if (is.na(mod_ts)) "" else fmt(mod_ts)
    data.frame(
      SR_NUMBER = id,
      STATUS = status,
      SR_TYPE = type_key,
      SR_SHORT_CODE = type_key,
      type_key = type_key,
      CREATED_DATE = created_s,
      LAST_MODIFIED_DATE = mod_s,
      CLOSED_DATE = closed,
      created_ts = created_ts,
      mod_ts = mod_ts,
      closed_ts = if (nzchar(closed)) rb_parse_ts(closed) else as.POSIXct(NA, tz = "America/Chicago"),
      DUPLICATE = dup,
      LEGACY_RECORD = leg,
      PARENT_SR_NUMBER = parent,
      stringsAsFactors = FALSE
    )
  }

  rows <- rbind(
    mk("SYN-F01", "POTHOLE", "Open", 25 * 24, 20 * 24),
    mk("SYN-F02", "POTHOLE", "Open", 40 * 24, 1 * 24),
    mk("SYN-F03", "BUILDING", "Open", 120 * 24, 100 * 24),
    mk("SYN-F04", "POTHOLE", "Open", 10 * 24, 10 * 24, closed = "2026-09-01 12:00:00"),
    # F05: created 10d ago, mod 20d ago (before created)
    {
      c_ts <- ago(10 * 24); m_ts <- ago(20 * 24)
      data.frame(
        SR_NUMBER = "SYN-F05", STATUS = "Open", SR_TYPE = "POTHOLE", SR_SHORT_CODE = "POTHOLE",
        type_key = "POTHOLE",
        CREATED_DATE = fmt(c_ts), LAST_MODIFIED_DATE = fmt(m_ts), CLOSED_DATE = "",
        created_ts = c_ts, mod_ts = m_ts,
        closed_ts = as.POSIXct(NA, tz = "America/Chicago"),
        DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = "",
        stringsAsFactors = FALSE
      )
    },
    mk("SYN-F06", "RARETYPE", "Open", 30 * 24, 30 * 24),
    mk("SYN-F07", "POTHOLE", "Open", 400 * 24, 400 * 24, dup = "true"),
    mk("SYN-F08", "POTHOLE", "Open", 25 * 24, 20 * 24, leg = "true"),
    mk("SYN-F09", "POTHOLE", "Open", 15 * 24, 15 * 24, parent = "PARENT-MISSING-999"),
    mk("SYN-F10", "FAST", "Open", 4 * 24, 4 * 24),
    mk("SYN-F11", "FAST", "Open", 8 * 24, 8 * 24),
    mk("SYN-F12", "POTHOLE", "Completed", 10 * 24, 5 * 24, closed = "2026-09-05 09:00:00"),
    # F13 unparseable created
    {
      m_ts <- ago(5 * 24)
      data.frame(
        SR_NUMBER = "SYN-F13", STATUS = "Open", SR_TYPE = "POTHOLE", SR_SHORT_CODE = "POTHOLE",
        type_key = "POTHOLE",
        CREATED_DATE = "NOT-A-DATE", LAST_MODIFIED_DATE = fmt(m_ts), CLOSED_DATE = "",
        created_ts = as.POSIXct(NA, tz = "America/Chicago"), mod_ts = m_ts,
        closed_ts = as.POSIXct(NA, tz = "America/Chicago"),
        DUPLICATE = "false", LEGACY_RECORD = "false", PARENT_SR_NUMBER = "",
        stringsAsFactors = FALSE
      )
    },
    mk("SYN-F14A", "ADDRTYPE", "Open", 2 * 24, 1 * 24),
    mk("SYN-F14B", "ADDRTYPE", "Open", 3 * 24, 1 * 24)
  )

  expected <- data.frame(
    fixture_id = c(
      "F01", "F02", "F03", "F04", "F05", "F06", "F07", "F08", "F09",
      "F10", "F11", "F12", "F13", "F14A", "F14B"
    ),
    SR_NUMBER = c(
      "SYN-F01", "SYN-F02", "SYN-F03", "SYN-F04", "SYN-F05", "SYN-F06",
      "SYN-F07", "SYN-F08", "SYN-F09", "SYN-F10", "SYN-F11", "SYN-F12",
      "SYN-F13", "SYN-F14A", "SYN-F14B"
    ),
    expected_classification = c(
      "ESCALATE", "STANDARD", "STANDARD", "INCONCLUSIVE", "INCONCLUSIVE", "INCONCLUSIVE",
      "OUT_OF_SET", "OUT_OF_SET", "INCONCLUSIVE",
      "STANDARD", "ESCALATE", "OUT_OF_SET",
      "INCONCLUSIVE", "STANDARD", "STANDARD"
    ),
    stringsAsFactors = FALSE
  )

  list(open = rows, peers = peers, expected = expected)
}

rb_score_fixtures <- function(kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE) {
  pack <- rb_build_fixture_pack(t_freeze = t_freeze)
  judged <- rb_judge_rows(pack$open, pack$peers, kappa = kappa, t_freeze = t_freeze)

  # Map OUT_OF_SET
  got <- judged$classification
  got[!judged$in_decision_set] <- "OUT_OF_SET"

  exp <- pack$expected
  m <- merge(exp, data.frame(
    SR_NUMBER = judged$SR_NUMBER,
    observed_classification = got,
    dormant_h = judged$dormant_h,
    peer_p75_h = judged$peer_p75_h,
    peer_n = judged$peer_n,
    integrity_clause = judged$integrity_clause,
    evidence_reason = judged$evidence_reason,
    stringsAsFactors = FALSE
  ), by = "SR_NUMBER", all.x = TRUE, sort = FALSE)

  # Restore fixture order
  m <- m[match(exp$SR_NUMBER, m$SR_NUMBER), ]
  m$pass <- m$expected_classification == m$observed_classification
  m$kappa <- kappa
  m$fixture_version <- RB_FIXTURE_VERSION

  # Compact F14 report: also emit F14 summary row? Deliverable says F01–F14.
  # Provide F14 as combined note while keeping F14A/F14B detail rows + F14 rollup
  f14 <- m[m$fixture_id %in% c("F14A", "F14B"), ]
  f14_pass <- all(f14$pass)
  rollup <- data.frame(
    fixture_id = "F14",
    SR_NUMBER = "SYN-F14A|SYN-F14B",
    expected_classification = "STANDARD|STANDARD",
    observed_classification = paste(f14$observed_classification, collapse = "|"),
    dormant_h = NA_real_,
    peer_p75_h = NA_real_,
    peer_n = NA_integer_,
    integrity_clause = NA_character_,
    evidence_reason = "grain=SR_NUMBER two independent labels",
    pass = f14_pass,
    kappa = kappa,
    fixture_version = RB_FIXTURE_VERSION,
    stringsAsFactors = FALSE
  )
  # Primary deliverable rows F01–F13 + F14 rollup (drop A/B from main export? keep both)
  primary_ids <- c("F01", "F02", "F03", "F04", "F05", "F06", "F07", "F08", "F09",
                   "F10", "F11", "F12", "F13")
  primary <- m[m$fixture_id %in% primary_ids, ]
  out <- rbind(primary, rollup)
  rownames(out) <- NULL
  out
}
