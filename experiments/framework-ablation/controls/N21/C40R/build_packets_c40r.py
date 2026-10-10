#!/usr/bin/env python3
"""Builds C40R builder packets from the frozen C40 INC packet (re-sectioned) and the frozen R-B files. Deterministic."""
import re, hashlib, os
W = os.path.dirname(os.path.abspath(__file__)); P = os.path.join(W, "packets"); os.makedirs(P, exist_ok=True)
OLD = open("/workspace/ablation_plan/runs/N13/C40/packets/C40_1_INC_BUILDER_ChatGPT.txt", encoding="utf-8").read().split("\n")
IO = open("/workspace/chicago-311-run/stage-04/R-B/R/10_io_parse.R", encoding="utf-8").read()
H_IO = hashlib.sha256(IO.encode("utf-8")).hexdigest(); assert H_IO == "40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a", H_IO
def idx(prefix, start=0):
    for i in range(start, len(OLD)):
        if OLD[i].startswith(prefix): return i
    raise KeyError(prefix)
i_samples = idx("# SOURCE FILE SAMPLES") - 1          # the '---' line before
i_20 = idx("# FROZEN FILE `R-B/R/20_integrity_and_classify.R`") - 1
i_40 = idx("# FROZEN FILE `R-B/R/40_fixtures.R`") - 1
assert OLD[i_samples] == "---" and OLD[i_20] == "---" and OLD[i_40] == "---"
last = len(OLD) - 1
while not OLD[last].startswith("Reminder:"): last -= 1
body_a = OLD[i_samples:i_20]                          # samples + run_RB + config
body_b = OLD[i_40:last]                               # fixtures + locked docs + build notes
HASHES = [
 ("R-B/outputs/RB_classifications.csv", "a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193", "reference output"),
 ("R-B/outputs/RB_fixture_results.csv", "0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9", "reference output"),
 ("R-B/outputs/RB_portfolio_counts.csv", "eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c", "reference output"),
 ("R-B/outputs/RB_kappa_grid_counts.csv", "7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a", "reference output"),
 ("data/source/src_open_candidates.csv", "ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9", "245,193 data rows; frozen source extract, read-only"),
 ("data/source/src_peer_stats.csv", "cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58", "104 data rows; frozen source extract, read-only"),
 ("R-B/run_RB.R", "6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd", "frozen, given verbatim below"),
 ("R-B/R/00_config.R", "6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b", "frozen, given verbatim below"),
 ("R-B/R/10_io_parse.R", H_IO, "frozen, given verbatim below"),
 ("R-B/R/40_fixtures.R", "2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e", "frozen, given verbatim below")]
def head(arm_label, r1_note):
    return f"""# C40R — Builder (ChatGPT) — Chicago 311 R-B path — write `R-B/R/20_integrity_and_classify.R` — round r1{r1_note}

Role: R-B builder (independent path). Use the highest reasoning setting. Everything you need is in this message; there are no attachments.

## Task
Write the complete file `R-B/R/20_integrity_and_classify.R`. Every other R-B file is frozen and given verbatim below (including the I/O and clock helpers `10_io_parse.R`); the gate deploys only your file.

## The file you write: `R-B/R/20_integrity_and_classify.R` (integrity gate, κ classification, portfolio and κ-grid counts)
It must define exactly these functions, which `run_RB.R` and `40_fixtures.R` (verbatim below) call:
| function | contract |
|---|---|
| `rb_judge_rows(open_df, peer_df, kappa = RB_KAPPA_DEFAULT, t_freeze = RB_T_FREEZE)` | `open_df` is the output of `rb_normalize_open`, `peer_df` the output of `rb_normalize_peers`. Returns a data.frame with ONE ROW PER INPUT ROW, in input order, with the locked output columns (MEASUREMENT_DESIGN_LOCKED §9 and the column list in `run_RB.R`, plus the audit columns the callers use: `STATUS`, `in_decision_set`, `out_of_set_reason`, `design_version`, `rule_version`). Classification is exactly one of ESCALATE, STANDARD, INCONCLUSIVE, or NA for rows outside the decision set. |
| `rb_portfolio_counts(judged, kappa = RB_KAPPA_DEFAULT)` | one-row data.frame of portfolio counts for the κ in use (decision-set size and the three label counts; see §9 of the locked design and how `run_RB.R` writes it) |
| `rb_kappa_grid_counts(open_df, peer_df, grid = RB_KAPPA_GRID, t_freeze = RB_T_FREEZE)` | counts-only diagnostic: one row per κ in the grid, built by judging the rows at each κ |

Locked rules that bind this file are in MEASUREMENT_DESIGN_LOCKED (§3 population, open and eligible; §5 INCONCLUSIVE rules, integrity gate first; §6 decision rules, exactly one label; §9 R judged logic contract), `stage3_locked_design.json`, the fixture pack in `40_fixtures.R` (F01–F14, expectations are authoritative, do not change them), and `RB_BUILD_NOTES.md`. Clock helpers (`rb_parse_ts`, `rb_hours_diff`, `rb_truthy`, `rb_is_blank`, ...) are in the frozen `10_io_parse.R`; use them, do not redefine them. Use base R and `readr` only (R 4.6.1 on Windows; `readr` and `dplyr` are installed; do not rely on other packages). Reason-text wording and number formatting that the documents do not fix are for you to choose; the gate will tell you whether the four outputs match.

## The gate (mechanical; the same for every round)
The coordinator copies the frozen R-B tree, replaces ONLY `R-B/R/20_integrity_and_classify.R` with your file, and runs `Rscript R-B/run_RB.R all` on the frozen source extract (R 4.6.1, Windows). The build is VALID (gate PASS) only if all hold:
1. the run exits 0;
2. the fixture results are 14/14 pass;
3. the four outputs are byte-identical to the reference outputs (SHA-256 below):
""" + "\n".join(f"   - `{n}` SHA-256 `{h}`" for n, h, _ in HASHES[:4]) + f"""
If the gate fails you receive a gate report (exit status, failing fixtures, which outputs differ, and per column how many rows differ with up to 5 example rows) and are asked for a corrected file.

## Reply format
Return the COMPLETE file in ONE fenced ```r code block (no other code blocks), then at most 10 lines of notes.
Reply in full, in one message. End your reply with exactly this line:
END C40R BUILD {arm_label} r1
"""
def hashblock():
    return ["---", "# FROZEN REFERENCE HASHES (what the gate checks against; re-verified by the runner preflight before every round)"] + [f"- `{n}` SHA-256 `{h}` ({d})" for n, h, d in HASHES]
def iofile():
    return ["---", f"# FROZEN FILE `R-B/R/10_io_parse.R` (sha256 {H_IO})", "```r"] + IO.rstrip("\n").split("\n") + ["```"]
def packet(arm, extra_head=""):
    h = head(arm, " (fresh builder: replaces a previous builder whose first 2 builds failed the gate)" if arm == "FRESH" else "").rstrip("\n").split("\n")
    if arm == "FRESH": h += ["", "@@HANDOVER@@"]
    out = h + [""] + hashblock() + [""] + body_a + [""] + iofile() + [""] + body_b + ["", "---", f"Reminder: one fenced ```r block with the complete `R-B/R/20_integrity_and_classify.R`, then at most 10 lines of notes. Finish with the line: END C40R BUILD {arm} r1"]
    return "\n".join(out) + "\n"
open(os.path.join(P, "C40R_1_INC_BUILDER_ChatGPT.txt"), "w", encoding="utf-8", newline="\n").write(packet("INC"))
open(os.path.join(P, "C40R_2_FRESH_BUILDER_ChatGPT.TEMPLATE.txt"), "w", encoding="utf-8", newline="\n").write(packet("FRESH"))
print("ok")
