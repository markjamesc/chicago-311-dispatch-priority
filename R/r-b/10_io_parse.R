# I/O + clock/type parsing helpers (R-B)

rb_is_blank <- function(x) {
  xch <- as.character(x)
  is.na(x) | !nzchar(trimws(xch))
}

rb_truthy <- function(x) {
  v <- tolower(trimws(as.character(x)))
  v %in% c("true", "t", "1", "yes", "y")
}

#' Parse timestamps into America/Chicago POSIXct; unparseable → NA
rb_parse_ts <- function(x) {
  # If somehow POSIXct arrives, recover printed digits in its tagged tz then re-parse as Chicago
  if (inherits(x, "POSIXt")) {
    tz_src <- attr(x, "tzone")
    if (is.null(tz_src) || !nzchar(tz_src[[1]])) tz_src <- "UTC"
    xch <- format(x, format = "%Y-%m-%d %H:%M:%S", tz = tz_src[[1]])
  } else {
    xch <- trimws(as.character(x))
  }
  xch[rb_is_blank(xch)] <- NA_character_
  # Strip trailing Z / offset loosely; treat wall as Chicago per locked contract
  xch <- sub("T", " ", xch, fixed = TRUE)
  xch <- sub("Z$", "", xch)
  xch <- sub("([+-][0-9]{2}:[0-9]{2})$", "", xch)
  xch <- sub("\\.[0-9]+$", "", xch)

  out <- rep(as.POSIXct(NA, tz = "America/Chicago"), length(xch))
  ok <- !is.na(xch)
  if (!any(ok)) return(out)

  # Try several formats without lubridate dependency for core path
  formats <- c(
    "%Y-%m-%d %H:%M:%S",
    "%Y-%m-%d %H:%M",
    "%m/%d/%Y %I:%M:%S %p",
    "%m/%d/%Y %H:%M:%S",
    "%m/%d/%Y %H:%M"
  )
  for (fmt in formats) {
    still <- ok & is.na(out)
    if (!any(still)) break
    parsed <- suppressWarnings(as.POSIXct(xch[still], format = fmt, tz = "America/Chicago"))
    out[still] <- parsed
  }
  out
}

rb_type_key <- function(short_code, sr_type) {
  sc <- trimws(as.character(short_code))
  st <- trimws(as.character(sr_type))
  sc[rb_is_blank(sc)] <- NA_character_
  st[rb_is_blank(st)] <- NA_character_
  key <- ifelse(!is.na(sc), sc, st)
  key[rb_is_blank(key)] <- NA_character_
  key
}

rb_read_csv_flex <- function(path) {
  if (!file.exists(path)) stop("Missing required file: ", path, call. = FALSE)
  # MySQL --batch exports are tab-separated. Force clock cols to character so
  # rb_parse_ts owns America/Chicago wall-clock (never trust readr POSIXct/UTC).
  clock_cols <- readr::cols(
    created_ts = readr::col_character(),
    mod_ts = readr::col_character(),
    closed_ts = readr::col_character(),
    CREATED_DATE = readr::col_character(),
    LAST_MODIFIED_DATE = readr::col_character(),
    CLOSED_DATE = readr::col_character(),
    .default = readr::col_guess()
  )
  if (requireNamespace("readr", quietly = TRUE)) {
    df <- tryCatch(
      readr::read_tsv(path, col_types = clock_cols, show_col_types = FALSE, progress = FALSE, guess_max = 100000),
      error = function(e) readr::read_csv(path, col_types = clock_cols, show_col_types = FALSE, progress = FALSE)
    )
    return(as.data.frame(df, stringsAsFactors = FALSE))
  }
  utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE, na.strings = c("", "NA", "NULL"))
}

#' Normalize open-candidate frame; recompute type_key / clocks if needed
rb_normalize_open <- function(raw) {
  nm <- names(raw)
  pick <- function(cands) {
    hit <- intersect(cands, nm)
    if (length(hit)) hit[[1]] else NA_character_
  }
  col_sr <- pick(c("SR_NUMBER", "sr_number"))
  col_status <- pick(c("STATUS", "status"))
  col_type <- pick(c("SR_TYPE", "sr_type"))
  col_short <- pick(c("SR_SHORT_CODE", "sr_short_code"))
  col_created <- pick(c("CREATED_DATE", "created_date", "created_ts"))
  col_mod <- pick(c("LAST_MODIFIED_DATE", "last_modified_date", "mod_ts"))
  col_closed <- pick(c("CLOSED_DATE", "closed_date", "closed_ts"))
  col_dup <- pick(c("DUPLICATE", "duplicate"))
  col_leg <- pick(c("LEGACY_RECORD", "legacy_record"))
  col_parent <- pick(c("PARENT_SR_NUMBER", "parent_sr_number"))
  col_tk <- pick(c("type_key"))
  col_created_ts <- pick(c("created_ts"))
  col_mod_ts <- pick(c("mod_ts"))
  col_closed_ts <- pick(c("closed_ts"))

  n <- nrow(raw)
  getc <- function(col) if (is.na(col)) rep(NA_character_, n) else as.character(raw[[col]])

  created_raw <- getc(col_created)
  mod_raw <- getc(col_mod)
  closed_raw <- getc(col_closed)

  # Always character → America/Chicago wall parse (no POSIXct shortcut / force_tz)
  created_ts <- if (!is.na(col_created_ts)) rb_parse_ts(raw[[col_created_ts]]) else rb_parse_ts(created_raw)
  if (!is.na(col_created) && any(is.na(created_ts) & !rb_is_blank(created_raw))) {
    miss <- is.na(created_ts)
    created_ts[miss] <- rb_parse_ts(created_raw[miss])
  }
  mod_ts <- if (!is.na(col_mod_ts)) rb_parse_ts(raw[[col_mod_ts]]) else rb_parse_ts(mod_raw)
  if (!is.na(col_mod) && any(is.na(mod_ts) & !rb_is_blank(mod_raw))) {
    miss <- is.na(mod_ts)
    mod_ts[miss] <- rb_parse_ts(mod_raw[miss])
  }
  closed_ts <- if (!is.na(col_closed_ts)) rb_parse_ts(raw[[col_closed_ts]]) else rb_parse_ts(closed_raw)
  if (!is.na(col_closed) && any(is.na(closed_ts) & !rb_is_blank(closed_raw))) {
    miss <- is.na(closed_ts)
    closed_ts[miss] <- rb_parse_ts(closed_raw[miss])
  }

  type_key <- if (!is.na(col_tk)) {
    tk <- as.character(raw[[col_tk]])
    tk[rb_is_blank(tk)] <- NA_character_
    # Fill blanks via coalesce rule
    fill <- rb_type_key(getc(col_short), getc(col_type))
    ifelse(is.na(tk), fill, tk)
  } else {
    rb_type_key(getc(col_short), getc(col_type))
  }

  data.frame(
    SR_NUMBER = getc(col_sr),
    STATUS = getc(col_status),
    SR_TYPE = getc(col_type),
    SR_SHORT_CODE = getc(col_short),
    type_key = type_key,
    CREATED_DATE = created_raw,
    LAST_MODIFIED_DATE = mod_raw,
    CLOSED_DATE = closed_raw,
    created_ts = created_ts,
    mod_ts = mod_ts,
    closed_ts = closed_ts,
    DUPLICATE = getc(col_dup),
    LEGACY_RECORD = getc(col_leg),
    PARENT_SR_NUMBER = getc(col_parent),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

rb_normalize_peers <- function(raw) {
  nm <- names(raw)
  pick <- function(cands) {
    hit <- intersect(cands, nm)
    if (length(hit)) hit[[1]] else NA_character_
  }
  col_tk <- pick(c("type_key", "TYPE_KEY"))
  col_n <- pick(c("peer_n", "PEER_N", "n"))
  col_p50 <- pick(c("peer_p50_h", "PEER_P50_H"))
  col_p75 <- pick(c("peer_p75_h", "PEER_P75_H"))
  if (is.na(col_tk) || is.na(col_n) || is.na(col_p75)) {
    stop("src_peer_stats missing type_key / peer_n / peer_p75_h", call. = FALSE)
  }
  tk <- as.character(raw[[col_tk]])
  data.frame(
    type_key = tk,
    peer_n = as.integer(raw[[col_n]]),
    peer_p50_h = if (!is.na(col_p50)) as.numeric(raw[[col_p50]]) else NA_real_,
    peer_p75_h = as.numeric(raw[[col_p75]]),
    stringsAsFactors = FALSE,
    check.names = FALSE
  )
}

rb_hours_diff <- function(t_end, t_start) {
  as.numeric(difftime(t_end, t_start, units = "hours"))
}
