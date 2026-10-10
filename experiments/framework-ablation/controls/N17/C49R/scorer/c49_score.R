#!/usr/bin/env Rscript
# C49 post-chat scorer (N13 b6). Usage: Rscript c49_score.R <C49R_ROOT>
# Reads the frozen delivery set (runner_b6/seeds/C49), the three extracted replies C49R-<arm>/reply.md and their TIMES.txt; writes C49/post/.
# Access proof per file = the reply's FIRST and LAST lines equal the file's first and last non-empty lines (whitespace-normalized). Mechanical; no judgment.
suppressPackageStartupMessages(library(digest))
a <- commandArgs(trailingOnly = TRUE); W <- normalizePath(a[[1]], winslash = "/", mustWork = TRUE)
S <- file.path(W, "scorer"); C <- W; OUT <- file.path(W, "post"); dir.create(OUT, showWarnings = FALSE)
rdl <- function(p) { x <- readLines(p, warn = FALSE, encoding = "UTF-8"); if (length(x) && startsWith(x[1], "\ufeff")) x[1] <- substring(x[1], 2); x }
nz <- function(x) x[nzchar(trimws(x))]
norm <- function(s) { s <- gsub("`", "", s); s <- gsub("\\\\\\|", "|", s); s <- gsub("\\*\\*", "", s); s <- gsub("[[:space:]]+", " ", s); trimws(s) }
arms <- read.delim(file.path(S, "ARMS.tsv"), colClasses = "character")
sums <- nz(rdl(file.path(W, "delivery", "FILES", "SHA256SUMS.txt"))); H <- setNames(sub("  .*$", "", sums), sub("^[0-9a-f]{64}  ", "", sums))
truth <- lapply(names(H), function(f) { x <- nz(rdl(file.path(W, "delivery", "FILES", f))); c(first = norm(x[1]), last = norm(x[length(x)])) }); names(truth) <- names(H)
ka <- read.csv(file.path(S, "KNOWN_ANSWERS.csv"), colClasses = "character")
tm <- function(p) { if (!file.exists(p)) return(NA_real_); x <- rdl(p); g <- function(k) { z <- grep(paste0("^", k, "="), x, value = TRUE); if (length(z)) as.POSIXct(sub(paste0("^", k, "="), "", z[1]), tz = "America/Chicago", format = "%Y-%m-%d %H:%M:%S") else as.POSIXct(NA) }
  s <- g("sent"); d <- g("reply_complete"); if (is.na(s) || is.na(d)) NA_real_ else as.numeric(difftime(d, s, units = "mins")) }
rows <- list(); halt <- character(0)
for (arm in arms$arm) { f <- file.path(C, paste0("C49R-", arm), "reply.md"); endl <- arms$end_line[arms$arm == arm]
  if (!file.exists(f)) { halt <- c(halt, paste("reply missing:", arm)); next }
  x <- rdl(f); last <- tail(nz(trimws(x)), 1); end_ok <- length(last) == 1 && grepl(endl, last, fixed = TRUE)
  if (!end_ok) halt <- c(halt, paste("reply has no END line as last line:", arm))
  st <- grep("^[[:space:]>*`-]*FILE:", x); inv <- list()
  for (i in seq_along(st)) { blk <- x[st[i]:min(length(x), if (i < length(st)) st[i + 1] - 1 else st[i] + 12)]
    g <- function(k) { z <- grep(paste0("^[[:space:]>*`-]*", k, ":"), blk, value = TRUE); if (length(z)) norm(sub(paste0("^[[:space:]>*`-]*", k, ":\\**"), "", z[1])) else NA_character_ }
    inv[[length(inv) + 1]] <- data.frame(file = g("FILE"), sha256 = g("SHA256"), opened = toupper(g("OPENED")), lines = g("LINES"), first = g("FIRST"), last = g("LAST"), stringsAsFactors = FALSE) }
  inv <- if (length(inv)) do.call(rbind, inv) else data.frame(file = character(), sha256 = character(), opened = character(), lines = character(), first = character(), last = character())
  inv$file <- basename(gsub("[`*]", "", inv$file))
  ev <- data.frame(file = names(H), listed = names(H) %in% inv$file, stringsAsFactors = FALSE)
  ev$sha_match <- sapply(ev$file, function(fn) { z <- inv$sha256[inv$file == fn]; length(z) > 0 && any(tolower(gsub("[^0-9a-fA-F]", "", z)) == H[[fn]]) })
  ev$first_ok <- sapply(ev$file, function(fn) any(inv$first[inv$file == fn] == truth[[fn]][["first"]], na.rm = TRUE))
  ev$last_ok <- sapply(ev$file, function(fn) any(inv$last[inv$file == fn] == truth[[fn]][["last"]], na.rm = TRUE))
  ev$said_opened <- sapply(ev$file, function(fn) any(grepl("^YES", inv$opened[inv$file == fn])))
  ev$opened_proven <- ev$first_ok & ev$last_ok
  write.csv(ev, file.path(OUT, paste0("INVENTORY_", arm, ".csv")), row.names = FALSE)
  qa <- sapply(ka$q, function(q) { z <- grep(paste0("^[[:space:]>*`-]*", q, "[:.)]"), x, value = TRUE); if (!length(z)) return(NA_character_)
    s <- sub(paste0("^.*?", q, "[:.)]"), "", z[1], perl = TRUE); v <- regmatches(s, gregexpr("[0-9][0-9,]*\\.?[0-9]*", s))[[1]]; if (length(v)) gsub(",", "", v[1]) else NA_character_ })
  fa <- data.frame(q = ka$q, expected = ka$answer, reply = unname(qa), correct = !is.na(qa) & suppressWarnings(abs(as.numeric(qa) - as.numeric(ka$answer)) < 1e-9), stringsAsFactors = FALSE)
  write.csv(fa, file.path(OUT, paste0("FACTS_", arm, ".csv")), row.names = FALSE)
  mins <- tm(file.path(C, paste0("C49R-", arm), "TIMES.txt"))
  if (is.na(mins)) halt <- c(halt, paste("TIMES.txt missing or incomplete:", arm))
  usable <- end_ok && all(ev$opened_proven) && all(!is.na(fa$reply))
  rows[[arm]] <- data.frame(arm = arm, model = arms$model[arms$arm == arm], delivery = arms$delivery[arms$arm == arm], reply_sha256 = digest(file = f, algo = "sha256"), end_line = end_ok,
    files_listed = sum(ev$listed), files_opened_proven = sum(ev$opened_proven), n_files = nrow(ev), files_said_opened = sum(ev$said_opened), sha_match = sum(ev$sha_match),
    facts_answered = sum(!is.na(fa$reply)), facts_correct = sum(fa$correct), usable = usable, minutes = round(mins, 2), time_to_usable_min = if (usable) round(mins, 2) else Inf, stringsAsFactors = FALSE) }
tab <- if (length(rows)) do.call(rbind, rows) else NULL
g <- function(arm, col) if (!is.null(tab) && arm %in% tab$arm) tab[[col]][tab$arm == arm] else NA
v <- c("DS_FILES", "GPT_FILES")
conds <- data.frame(condition = c("1. variant access: DS_FILES and GPT_FILES each prove access to every evidence file (FIRST and LAST lines match)",
                                  "2. inventory hashes: in DS_FILES and GPT_FILES every evidence file is listed with the SHA-256 in SHA256SUMS.txt",
                                  "3. delay no worse: DS_FILES time to a usable first pass <= DS_ZIP time to a usable first pass + 2 min (DS_ZIP not usable = met)"),
                    met = c(isTRUE(all(sapply(v, g, col = "files_opened_proven") == sapply(v, g, col = "n_files"))),
                            isTRUE(all(sapply(v, g, col = "sha_match") == sapply(v, g, col = "n_files"))),
                            isTRUE(g("DS_FILES", "time_to_usable_min") <= g("DS_ZIP", "time_to_usable_min") + 2)))
verdict <- if (length(halt)) "HALT" else if (all(conds$met)) "P1 MET" else "P1 NOT MET"
md <- function(df) c(paste0("| ", paste(names(df), collapse = " | "), " |"), paste0("|", paste(rep("---", ncol(df)), collapse = "|"), "|"), apply(df, 1, function(r) paste0("| ", paste(gsub("\\|", "/", r), collapse = " | "), " |")))
L <- c(paste0("# C49 POST-CHAT RESULTS (mechanical; generated ", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"), ")"), "", paste0("**Mechanical predicate result: ", verdict, "**"), "",
       if (length(halt)) c("HALT reasons:", paste0("- ", halt), ""), "## Predicate conditions", md(transform(conds, met = ifelse(conds$met, "MET", "NOT MET"))), "", "## Arms", if (is.null(tab)) "(none)" else md(tab), "")
for (arm in arms$arm) for (k in c("INVENTORY_", "FACTS_")) { p <- file.path(OUT, paste0(k, arm, ".csv")); if (file.exists(p)) L <- c(L, paste0("## ", k, arm, ".csv"), md(read.csv(p, colClasses = "character")), "") }
writeLines(L, file.path(OUT, "C49_POST_RESULTS.md")); if (!is.null(tab)) write.csv(tab, file.path(OUT, "C49_POST_arms.csv"), row.names = FALSE)
cat("C49:", verdict, "\n")
