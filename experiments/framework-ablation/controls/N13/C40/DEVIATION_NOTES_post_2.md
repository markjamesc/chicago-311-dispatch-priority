# C40 post-freeze deviation notes, part 2 (b6, 2026-10-03 ~12:50 CT). Continues DEVIATION_NOTES_post.md (frozen, unchanged)

## D-C1 Round-2 message: backticks arrived as U+001F control characters (judged NOT material)
- Operator note: when `C40/C40-INC/r2/MESSAGE.txt` (202e6170…) was pasted, the ChatGPT composer showed the inline-code backticks as control placeholders.
- Check of the sent user turn in the saved page (`C40/C40-INC/r2/inc_r2_chatgpt.html`, 9e73d9fb…; the `whitespace-pre-wrap` user-message div):
  - Every backtick of MESSAGE.txt (19) arrived as the control character U+001F; the page holds 17 of them.
  - The one triple-backtick inside the instruction sentence (```` ```r ````) arrived as a single U+001F followed by `r`.
  - The two ``` fence lines around the stderr excerpt arrived as three U+001F each.
  - One blank line before "Fix the file." is absent.
  - With U+001F mapped back to a backtick, every other line equals MESSAGE.txt exactly: the gate result table, all 15 stderr lines including "Error: Open source missing required column(s): …", the instructions and the END line.
- Judgment: **not material**.
  - All information content reached the builder: the failure, the error text, the output table and the instructions.
  - Only markdown delimiters were garbled. The builder's r2 reply names the exact r1 cause ("The frozen `.csv` exports are tab-delimited; r1 incorrectly forced `read_csv()` comma parsing"), returns one code block, and ends with `END C40 BUILD INC r2`.
  - r2 PASSED the gate and the hidden depth check.
  - The garbling cannot have helped the builder. Any harm it did would have shown as a failed r2, which did not happen.
- Prevention for later rounds: attach MESSAGE.txt as a file, or check the composer before sending.

## D-C2 r2 reply re-extracted with extract_reply_v3.py (tool fix)
- `extract_reply_v2.py` rendered ChatGPT's code block, which this page draws as `<code class="… block CodeContent-…">` with no `<pre>`, as inline code. Indentation was lost and there was no fence, so `c40_extract.R` REFUSED ("no fenced code block") at 12:43:39. That attempt wrote nothing (no candidate, no arm); its logs are kept as `C40/round_INC_r2_attempt1_REFUSED.{out,err}.txt`.
- `runner_b6/tools/extract_reply_v3.py` (046f202d…) is v2 plus that one case. Its output is byte-identical to v2 on the other six b6 pages tested (C40 r1, C49 GPT_FILES, C43 Builder, C44 Builder, C49 DS_FILES_PD3, C44 Validator).
- The v2 output is kept, moved not deleted, as `C40/C40-INC/r2/reply.v2extract_superseded.md` (cfebf566…). `reply.md` is now the v3 output (eb0cd252…). The html is unchanged.
- The extracted module (`10_io_parse.R`, 72d49def…) equals the page's code text except that 9 doubled blank lines are collapsed to single ones. This is the same normalization as every v2 extraction, including r1.
- Freeze: `CAPTURE_FREEZE_b6b_fix.sha256`.

## Outcome
- INC r1 FAIL; INC r2 PASS at 12:46:31 CDT (gate 14/14 and 4/4 outputs byte-identical; hidden depth check PASS 14/14). `c40_next.R`: NOT_TRIGGERED.
- `c40_eval.R`: "NOT TRIGGERED (cap never reached; no verdict; no Builder/Validator/Adjudicator chats)".
- `assemble_b6_bv.R C40` refused with exit 4 by design. No ROUNDS_FREEZE.json and no B/V/G packets were written. Per the SPEC there are no C40 verdict, B, V or G chats.
- Times: r2 is operator-logged (0.73 min). r1 is the ruling's upper bound (7.12 min). Neither enters a predicate, because nothing diverged.
