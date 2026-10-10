#!/usr/bin/env python3
"""N15 batch 3 (C32 C35 C36 C15 C45): build the Stage-5 seeds from the frozen-path harness copy of run_deeper_analysis.R
(runner/stage45/run_deeper_analysis.R, a path-only copy of the frozen stage-05 script, verified below). Every replacement must match
exactly once, or the script aborts. Writes seeds/<CID>/..., seeds/<CID>/ARMS.tsv, the seeds/<CID>/S5ONLY or seeds/C45/PARALLEL marker,
SEEDS_b3.sha256 and SEED_DIFFS_b3.txt. No source variants and no R-A/R-B code seeds in b3."""
import hashlib, difflib, pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parent
sha = lambda p: hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
H5 = ROOT/"stage45/run_deeper_analysis.R"; assert sha(H5) == "a2868ef5c28505145af2990c5a93df8869318af9b44949514f5b338f75b9cf94"
S5 = H5.read_text(encoding="utf-8")
def mut(t, pairs):
    for old, new in pairs:
        n = t.count(old)
        if n != 1: sys.exit(f"target found {n} times: {old!r}")
        t = t.replace(old, new)
    return t
AFTER = "stopifnot(all(chk$pass))\n"; BEFORE = "# Independent checks vs freeze\n"
END = 'cat("Stage 5 deeper analysis wrote to ", out, "\\n", sep = "")\n'
RA_P = 'file.path(root, "R-A/outputs/RA_classifications.csv")'; VAL_P = 'file.path(root, "outputs/validated_action_list.csv")'
after = lambda code: [(AFTER, AFTER + code)]; before = lambda code: [(BEFORE, code + BEFORE)]; atend = lambda code: [(END, code + END)]
PRE_HDR = 'suppressPackageStartupMessages({library(readr); library(dplyr)})\nroot <- Sys.getenv("CHICAGO311_ROOT"); f <- function(p) file.path(root, p)\n'
PRE = {  # C32: post-validation edits to Stage-5 inputs, made after the validation freeze and before Stage 5 runs
 "FB_KGRID": PRE_HDR + 'g <- read_csv(f("R-B/outputs/RB_kappa_grid_counts.csv"), show_col_types = FALSE)\ni <- which(g$kappa == 3); stopifnot(length(i) == 1)\n'
             'g$n_ESCALATE[i] <- g$n_ESCALATE[i] + 1500L; g$n_STANDARD[i] <- g$n_STANDARD[i] - 1500L  # [seed] R-B kappa grid regenerated after validation\n'
             'write_csv(g, f("R-B/outputs/RB_kappa_grid_counts.csv"))\n',
 "FB_TF24":  PRE_HDR + 'ra <- read_csv(f("R-A/outputs/RA_classifications.csv"), show_col_types = FALSE)\n'
             'ra$dormant_h <- ra$dormant_h + 24; ra$open_age_h <- ra$open_age_h + 24  # [seed] R-A timing re-derived at T_freeze+24 h; labels kept\n'
             'write_csv(ra, f("R-A/outputs/RA_classifications.csv"))\n',
 "FB_CLAUSE":PRE_HDR + 'ra <- read_csv(f("R-A/outputs/RA_classifications.csv"), show_col_types = FALSE)\n'
             'i <- ra$classification == "INCONCLUSIVE" & (is.na(ra$peer_n) | ra$peer_n < 30); stopifnot(any(i))\n'
             'ra$integrity_clause[i] <- "missing_or_sub30_peer"  # [seed] clause relabelled after validation (split of thin_type_or_missing_peer)\n'
             'write_csv(ra, f("R-A/outputs/RA_classifications.csv"))\n',
 "FB_ROUND": PRE_HDR + 'ra <- read_csv(f("R-A/outputs/RA_classifications.csv"), show_col_types = FALSE)\n'
             'ra$dormant_h <- round(ra$dormant_h)  # [seed] dormant_h rounded to whole hours after validation\n'
             'write_csv(ra, f("R-A/outputs/RA_classifications.csv"))\n',
 "FB_RECLASS":PRE_HDR + 'ra <- read_csv(f("R-A/outputs/RA_classifications.csv"), show_col_types = FALSE)\n'
             'i <- which(ra$classification == "INCONCLUSIVE")[1:10]; ra$classification[i] <- "ESCALATE"  # [seed] 10 labels edited after validation\n'
             'write_csv(ra, f("R-A/outputs/RA_classifications.csv"))\n',
 "FB_VALSORT":PRE_HDR + 'v <- read_csv(f("outputs/validated_action_list.csv"), show_col_types = FALSE)\n'
             'write_csv(arrange(v, desc(dormant_h)), f("outputs/validated_action_list.csv"))  # [seed] validated (unordered) list re-sorted; same rows\n',
}
VAR = {
 # C35: Stage-5 variants that write back into validated files
 "FV_VALSORT": atend(f'write_csv(arrange(val, desc(dormant_h)), {VAL_P})  # [seed] Stage 5 re-sorts the validated list in place\n'),
 "FV_ADDRANK": atend(f'ra_w <- read_csv({RA_P}, show_col_types = FALSE); ra_w$priority_rank <- rank(-ra_w$dormant_h, ties.method = "first")\nwrite_csv(ra_w, {RA_P})  # [seed] Stage 5 adds a column to the validated classifications in place\n'),
 "FV_ROUND":   atend(f'ra_w <- read_csv({RA_P}, show_col_types = FALSE); ra_w$dormant_h <- round(ra_w$dormant_h, 1)\nwrite_csv(ra_w, {RA_P})  # [seed] Stage 5 writes rounded dormant_h back into the validated classifications\n'),
 "FV_DROPTHIN":atend(f'write_csv(filter(val, peer_n >= 100), {VAL_P})  # [seed] Stage 5 overwrites the validated list with a filtered copy (peer_n >= 100)\n'),
 "FV_EARLY":   before(f'val <- val[-1, ]; write_csv(val, {VAL_P})  # [seed] Stage 5 drops a row from the validated list before its checks\n'),
 "FV_BENIGN":  atend('write_csv(count(ra, type_key, classification), file.path(out, "diag_type_by_class.csv"))  # [seed] benign: new diagnostic in stage-05 only\n'),
 # C36: Stage-5 variants that re-judge validated labels in the analysis
 "RJ_INC2ESC": after('ra <- ra %>% mutate(classification = ifelse(classification == "INCONCLUSIVE" & dormant_h >= 8760, "ESCALATE", classification))  # [seed] analyst re-judges long-dormant INCONCLUSIVE as ESCALATE\n'),
 "RJ_KAPPA3":  after('ra <- ra %>% mutate(classification = ifelse(classification == "ESCALATE" & dormant_h < 3 * peer_p75_h, "STANDARD", classification))  # [seed] analysis re-judges at kappa 3\n') + [("    kappa = 2\n", "    kappa = 3\n")],
 "RJ_OPENAGE": after('ra <- ra %>% mutate(classification = ifelse(classification == "ESCALATE" & open_age_h < 720, "STANDARD", classification))  # [seed] re-judged on open_age_h (diagnostic-only field)\n'),
 "RJ_PRECHECK":before('ra <- ra %>% mutate(classification = ifelse(classification == "INCONCLUSIVE" & dormant_h >= 8760, "ESCALATE", classification))  # [seed] re-judging before the independent checks\n'),
 "RJ_BENIGN":  atend('esc_bin <- ra %>% filter(classification == "ESCALATE") %>% mutate(peer_n_bin = cut(peer_n, c(0, 99, 999, 9999, Inf))) %>% count(peer_n_bin, name = "n_ESCALATE")\nwrite_csv(esc_bin, file.path(out, "escalate_by_peer_n_bin.csv"))  # [seed] benign: adds insight, labels unchanged\n'),
 # C15: late ranking / capacity introduced at Stage 5
 "RK_CAP200":  atend('fal <- ra %>% filter(classification == "ESCALATE") %>% arrange(desc(dormant_h / peer_p75_h)) %>% head(200) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification, priority_rank = row_number())\nwrite_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late hard cap of 200 by urgency ratio\n'),
 "RK_TYPECAP": atend('fal <- ra %>% filter(classification == "ESCALATE") %>% group_by(type_key) %>% slice_max(dormant_h, n = 100, with_ties = FALSE) %>% ungroup() %>% transmute(SR_NUMBER = sr_number, type_key, action = classification)\nwrite_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late per-type cap of 100\n'),
 "RK_KAPPACAP":atend('fal <- ra %>% filter(classification == "ESCALATE", dormant_h >= 8 * peer_p75_h) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification)\nwrite_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] capacity via a raised kappa (8) at Stage 5\n'),
 "RK_RANKONLY":atend('fal <- ra %>% filter(classification == "ESCALATE") %>% arrange(desc(dormant_h / peer_p75_h)) %>% transmute(SR_NUMBER = sr_number, type_key, action = classification, priority_rank = row_number())\nwrite_csv(fal, file.path(out, "final_action_list.csv"))  # [seed] late ranking, same set, no cap\n'),
 "RK_PRECAP":  before('ra <- ra %>% mutate(classification = ifelse(classification == "ESCALATE" & rank(-dormant_h / peer_p75_h, ties.method = "first") > 1000, "STANDARD", classification))  # [seed] cap applied to labels before the checks\n'),
 "RK_BENIGN":  [('  label = c("illustrative_shift_50", "illustrative_shift_200", "illustrative_shift_1000", "full_escalate_portfolio"),\n  attention_slots = c(50, 200, 1000, 131968),',
                 '  label = c("illustrative_shift_50", "illustrative_shift_200", "illustrative_shift_500", "illustrative_shift_1000", "full_escalate_portfolio"),  # [seed] benign: extra illustrative budget row, FLAG only\n  attention_slots = c(50, 200, 500, 1000, 131968),')],
}
HARN = "stage45/run_deeper_analysis.R"
ARMS = {
 "C32": [("FB_KGRID", "FB_KGRID", HARN, "R-B kappa grid regenerated after validation (kappa=3 row moves 1,500 rows)"),
         ("FB_TF24", "FB_TF24", HARN, "R-A timing fields re-derived at T_freeze+24 h after validation; labels kept"),
         ("FB_CLAUSE", "FB_CLAUSE", HARN, "INCONCLUSIVE clause relabelled after validation (missing or <30-peer rows split out)"),
         ("FB_ROUND", "FB_ROUND", HARN, "dormant_h rounded to whole hours after validation"),
         ("FB_RECLASS", "FB_RECLASS", HARN, "10 INCONCLUSIVE labels edited to ESCALATE after validation"),
         ("FB_VALSORT", "FB_VALSORT", HARN, "validated list re-sorted after validation (same rows; benign for Stage-5 outputs)")],
 "C35": [(a, "-", f"seeds/C35/{a}__run_deeper_analysis.R", d) for a, d in [
         ("FV_VALSORT", "Stage 5 re-sorts the validated list in place"), ("FV_ADDRANK", "Stage 5 adds priority_rank to the validated classifications in place"),
         ("FV_ROUND", "Stage 5 writes rounded dormant_h back into the validated classifications"), ("FV_DROPTHIN", "Stage 5 overwrites the validated list with peer_n>=100 rows only"),
         ("FV_EARLY", "Stage 5 drops one validated-list row before its own checks"), ("FV_BENIGN", "benign: Stage 5 writes one extra diagnostic under stage-05 only")]],
 "C36": [(a, "-", f"seeds/C36/{a}__run_deeper_analysis.R", d) for a, d in [
         ("RJ_INC2ESC", "analysis re-judges INCONCLUSIVE with dormant_h >= 8760 as ESCALATE"), ("RJ_KAPPA3", "analysis re-judges ESCALATE at kappa 3 and reports kappa 3"),
         ("RJ_OPENAGE", "analysis demotes ESCALATE with open_age_h < 720 (diagnostic-only field)"), ("RJ_PRECHECK", "re-judging placed before Stage 5's own checks"),
         ("RJ_BENIGN", "benign: adds an ESCALATE-by-peer_n-bin table; labels unchanged")]],
 "C15": [(a, "-", f"seeds/C15/{a}__run_deeper_analysis.R", d) for a, d in [
         ("RK_CAP200", "late hard cap: final_action_list = top 200 ESCALATE by dormant_h/peer_p75_h"), ("RK_TYPECAP", "late per-type cap of 100 ESCALATE"),
         ("RK_KAPPACAP", "late capacity via a raised kappa (8)"), ("RK_RANKONLY", "late ranking of the full ESCALATE set (same set, no cap)"),
         ("RK_PRECAP", "cap of 1,000 applied to labels before Stage 5's own checks"), ("RK_BENIGN", "benign: one extra illustrative budget row in the FLAG-only capacity note")]],
}
lines, diffs = [], []
def emit(path, text):
    p = ROOT/path; p.parent.mkdir(parents=True, exist_ok=True); p.write_bytes(text.encode("utf-8")); lines.append(f"{sha(p)}  {path}")
for cid in ("C32", "C35", "C36", "C15"):
    (ROOT/f"seeds/{cid}").mkdir(parents=True, exist_ok=True); (ROOT/f"seeds/{cid}/S5ONLY").write_text("stage-5-only arms (validated state copied from the frozen pack)\n")
    rows = ["arm\tpre\ts5\tdesc"]
    for arm, pre, s5, d in ARMS[cid]:
        prep = "-"
        if pre != "-":
            prep = f"seeds/{cid}/{arm}__pre_edit.R"; emit(prep, PRE[pre])
            diffs.append(f"### {prep} (new file; runs after the validation freeze, before Stage 5)\n" + PRE[pre] + "\n")
        if s5 != HARN:
            t = mut(S5, VAR[arm]); emit(s5, t)
            diffs.append("".join(difflib.unified_diff(S5.splitlines(True), t.splitlines(True), f"frozen-harness/{HARN}", s5)))
        rows.append(f"{arm}\t{prep}\t{s5}\t{d}")
    emit(f"seeds/{cid}/ARMS.tsv", "\n".join(rows) + "\n"); lines.append(f"{sha(ROOT/f'seeds/{cid}/S5ONLY')}  seeds/{cid}/S5ONLY")
(ROOT/"seeds/C45").mkdir(parents=True, exist_ok=True); (ROOT/"seeds/C45/PARALLEL").write_text("serial vs concurrent R-A/R-B runs on the frozen package\n")
emit("seeds/C45/ARMS.tsv", "arm\tmode\tdesc\nPAR_1\tPAR\tR-A and R-B launched concurrently\nSER_2\tSER\tR-A then R-B\nPAR_2\tPAR\tR-A and R-B launched concurrently\n"
     "SER_3\tSER\tR-A then R-B\nPAR_3\tPAR\tR-A and R-B launched concurrently\n"); lines.append(f"{sha(ROOT/'seeds/C45/PARALLEL')}  seeds/C45/PARALLEL")
for h in ("run_deeper_analysis.R",): lines.append(f"{sha(ROOT/'stage45'/h)}  stage45/{h}")
lines.append(f"{sha(ROOT/'s5_freeze_check.ps1')}  s5_freeze_check.ps1") if (ROOT/"s5_freeze_check.ps1").exists() else None
(ROOT/"SEEDS_b3.sha256").write_text("\n".join(lines) + "\n"); (ROOT/"SEED_DIFFS_b3.txt").write_text("\n".join(diffs))
print(len(lines), "seed lines;", len(diffs), "diff blocks")
