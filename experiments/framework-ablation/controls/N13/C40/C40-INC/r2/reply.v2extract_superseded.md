R

`# R-B I/O + parsing helpers — Stage 4 TCD-IG
# Independent path; base R + readr only.
#
# Clock semantics:
# - All source clocks are America/Chicago wall-clock times.
# - Any timezone-looking suffix is non-authoritative and is ignored.
# - Repeated fall-back-hour wall times use base as.POSIXct() resolution;
# on the locked Windows/R build this is the first occurrence (CDT).
# - Blank, NULL-like, or unparseable clocks become NA.
RB_CLOCK_TZ <- "America/Chicago"
rb_is_blank <- function(x) {
z <- as.character(x)
is.na(z) | trimws(z) == ""
}
rb_truthy <- function(x) {
z <- tolower(trimws(as.character(x)))
!is.na(z) & z %in% c("true", "t", "yes", "y", "1")
}
rb_strip_clock_suffix <- function(x) {
z <- trimws(as.character(x))
# The source clocks are Chicago wall clocks regardless of any supplied
# timezone marker. Remove such markers before interpretation.
z <- sub(
"\\s*(?:Z|UTC|GMT|CDT|CST|[+-][0-9]{2}:?[0-9]{2})\\s*$",
"",
z,
perl = TRUE,
ignore.case = TRUE
)
trimws(z)
}
rb_parse_ts <- function(x) {
tz <- RB_CLOCK_TZ
z <- rb_strip_clock_suffix(x)
null_like <- is.na(z) |
z == "" |
toupper(z) %in% c("NULL", "NA", "N/A")
z[null_like] <- NA_character_
if (!length(z)) {
return(as.POSIXct(character(0), tz = tz))
}
out <- rep(as.POSIXct(NA_character_, tz = tz), length(z))
# %OS accepts both integral and fractional seconds.
# Formats cover the raw Chicago 311 clocks, SQL-export clock text,
# and the locked fixture strings.
formats <- c(
"%m/%d/%Y %I:%M:%OS %p",
"%m/%d/%Y %I:%M %p",
"%Y-%m-%d %H:%M:%OS",
"%Y-%m-%d %H:%M",
"%Y-%m-%dT%H:%M:%OS",
"%Y-%m-%dT%H:%M",
"%Y/%m/%d %H:%M:%OS",
"%Y/%m/%d %H:%M",
"%m/%d/%Y %H:%M:%OS",
"%m/%d/%Y %H:%M"
)
for (fmt in formats) {
idx <- which(is.na(out) & !is.na(z))
if (!length(idx)) break
parsed <- suppressWarnings(
as.POSIXct(z[idx], format = fmt, tz = tz)
)
good <- !is.na(parsed)
if (any(good)) {
out[idx[good]] <- parsed[good]
}
}
out
}
rb_type_key <- function(short_code, sr_type) {
sc <- as.character(short_code)
st <- as.character(sr_type)
if (!length(sc) && !length(st)) {
return(character(0))
}
n <- max(length(sc), length(st))
if (!length(sc)) sc <- rep(NA_character_, n)
if (!length(st)) st <- rep(NA_character_, n)
if (length(sc) != n) sc <- rep_len(sc, n)
if (length(st) != n) st <- rep_len(st, n)
sc <- trimws(sc)
st <- trimws(st)
out <- ifelse(!rb_is_blank(sc), sc, st)
out[rb_is_blank(out)] <- NA_character_
as.character(out)
}
rb_read_csv_flex <- function(path) {
if (!file.exists(path)) {
stop("Source file not found: ", path, call. = FALSE)
}
# Frozen source files carry .csv names but are tab-delimited exports.
# Detect from the header so this helper remains tolerant of an ordinary
# comma-delimited CSV without allowing readr to guess column types.
header <- readLines(path, n = 1L, warn = FALSE)
if (!length(header)) {
stop("Source file is empty: ", path, call. = FALSE)
}
n_tabs <- lengths(regmatches(header, gregexpr("\t", header, fixed = TRUE)))
if (identical(n_tabs, 1L) &&
identical(regmatches(header, gregexpr("\t", header, fixed = TRUE))[[1]], -1L)) {
n_tabs <- 0L
}
n_commas <- lengths(regmatches(header, gregexpr(",", header, fixed = TRUE)))
if (identical(n_commas, 1L) &&
identical(regmatches(header, gregexpr(",", header, fixed = TRUE))[[1]], -1L)) {
n_commas <- 0L
}
delim <- if (n_tabs > n_commas) "\t" else ","
if (requireNamespace("readr", quietly = TRUE)) {
dat <- suppressMessages(
readr::read_delim(
file = path,
delim = delim,
col_types = readr::cols(.default = readr::col_character()),
na = "NA",
trim_ws = FALSE,
progress = FALSE,
show_col_types = FALSE
)
)
return(as.data.frame(dat, stringsAsFactors = FALSE))
}
utils::read.table(
file = path,
header = TRUE,
sep = delim,
quote = "\"",
comment.char = "",
colClasses = "character",
stringsAsFactors = FALSE,
check.names = FALSE,
na.strings = "NA",
strip.white = FALSE
)
}
rb_normalize_open <- function(raw) {
required <- c(
"SR_NUMBER",
"STATUS",
"SR_TYPE",
"SR_SHORT_CODE",
"CREATED_DATE",
"LAST_MODIFIED_DATE",
"CLOSED_DATE",
"DUPLICATE",
"LEGACY_RECORD",
"PARENT_SR_NUMBER"
)
missing_cols <- setdiff(required, names(raw))
if (length(missing_cols)) {
stop(
"Open source missing required column(s): ",
paste(missing_cols, collapse = ", "),
call. = FALSE
)
}
chr <- function(nm) as.character(raw[[nm]])
created_raw <- chr("CREATED_DATE")
mod_raw <- chr("LAST_MODIFIED_DATE")
closed_raw <- chr("CLOSED_DATE")
out <- data.frame(
SR_NUMBER = chr("SR_NUMBER"),
STATUS = chr("STATUS"),
SR_TYPE = chr("SR_TYPE"),
SR_SHORT_CODE = chr("SR_SHORT_CODE"),
type_key = rb_type_key(
chr("SR_SHORT_CODE"),
chr("SR_TYPE")
),
CREATED_DATE = created_raw,
LAST_MODIFIED_DATE = mod_raw,
CLOSED_DATE = closed_raw,
created_ts = rb_parse_ts(created_raw),
mod_ts = rb_parse_ts(mod_raw),
closed_ts = rb_parse_ts(closed_raw),
DUPLICATE = chr("DUPLICATE"),
LEGACY_RECORD = chr("LEGACY_RECORD"),
PARENT_SR_NUMBER = chr("PARENT_SR_NUMBER"),
stringsAsFactors = FALSE,
check.names = FALSE
)
rownames(out) <- NULL
out
}
rb_normalize_peers <- function(raw) {
required <- c("type_key", "peer_n", "peer_p75_h")
missing_cols <- setdiff(required, names(raw))
if (length(missing_cols)) {
stop(
"Peer source missing required column(s): ",
paste(missing_cols, collapse = ", "),
call. = FALSE
)
}
type_key <- trimws(as.character(raw$type_key))
type_key[rb_is_blank(type_key)] <- NA_character_
peer_n_raw <- trimws(as.character(raw$peer_n))
peer_p75_raw <- trimws(as.character(raw$peer_p75_h))
peer_n <- suppressWarnings(as.integer(peer_n_raw))
peer_p75_h <- suppressWarnings(as.numeric(peer_p75_raw))
if ("peer_p50_h" %in% names(raw)) {
peer_p50_h <- suppressWarnings(
as.numeric(trimws(as.character(raw$peer_p50_h)))
)
} else {
peer_p50_h <- rep(NA_real_, nrow(raw))
}
bad_type <- is.na(type_key)
bad_n <- rb_is_blank(peer_n_raw) | is.na(peer_n)
bad_p75 <- rb_is_blank(peer_p75_raw) | is.na(peer_p75_h)
if (any(bad_type)) {
stop("Peer source contains missing/blank type_key", call. = FALSE)
}
if (any(bad_n)) {
stop("Peer source contains missing/unparseable peer_n", call. = FALSE)
}
if (any(bad_p75)) {
stop("Peer source contains missing/unparseable peer_p75_h", call. = FALSE)
}
out <- data.frame(
type_key = type_key,
peer_n = peer_n,
peer_p50_h = peer_p50_h,
peer_p75_h = peer_p75_h,
stringsAsFactors = FALSE,
check.names = FALSE
)
rownames(out) <- NULL
out
}
rb_hours_diff <- function(t_end, t_start) {
as.numeric(difftime(t_end, t_start, units = "hours"))
}`

Changed only the source-file ingestion logic implicated by the r1 gate failure.  
The frozen `.csv` exports are tab-delimited; r1 incorrectly forced `read_csv()` comma parsing, so the entire header became one field.  
`rb_read_csv_flex()` now detects tab vs comma from the header and uses `readr::read_delim()` with all columns forced to character.  
The base-R fallback now uses the same detected delimiter.  
Fixture-sensitive parsing/classification helpers are otherwise unchanged; r1 already achieved 14/14 fixture PASS and byte-identical fixture output.  
END C40 BUILD INC r2
