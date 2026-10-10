# C49 post-freeze deviation notes, part 2 (b6, 2026-10-03 ~12:45 CT). Continues DEVIATION_NOTES_post.md (frozen, unchanged)

## PD-3 resolved by the DS_FILES rerun
- Rerun: new DeepSeek chat https://chat.deepseek.com/a/chat/s/2bfdcf06-8c20-4656-abbd-e89c99776213, packet `C49/packets/C49_R_DS_FILES_PD3.txt` (89ac5ab5…), delivery `runner_b6/seeds/C49/delivery/FILES_PD3/`. The operator confirmed 11/11 attachment chips uploaded before send; the END line was seen. TIMES.txt was written at chat time: sent 12:30:32, reply_complete 12:31:22 CDT.
- Result: all 9 files listed with the SHA-256 from SHA256SUMS.txt (9/9 equal to the frozen sums), OPENED: YES, Q1–Q5 = 131968 / 64922 / 49.2 / 25 / 118246.
- Record handling (nothing deleted):
  - The original DS_FILES record was moved to `C49/_superseded_PD3/C49-DS_FILES/`; its hashes are unchanged and still match `CAPTURE_FREEZE_b6.sha256`.
  - The rerun capture stays in `C49/C49-DS_FILES_PD3/` (`CAPTURE_FREEZE_b6b.sha256`). Its reply.md and TIMES.txt are copied byte-identically to `C49/C49-DS_FILES/`, the path the frozen scorer reads (see SOURCE.txt there).
- Post-freeze runner patch (disclosed): `runner_b6/seeds/C49/ARMS.tsv` DS_FILES row:
  - `packet` changed to `C49/packets/C49_R_DS_FILES_PD3.txt`.
  - `delivery` label changed to "FILES (PD-3 rerun: FILES_PD3, SHA256SUMS.txt)".
  - The original is kept as `ARMS.v1_prePD3.tsv`. `c49_score.R` is unchanged; it reads the sums from `delivery/FILES/SHA256SUMS`, which is byte-identical to `FILES_PD3/SHA256SUMS.txt`.
- Limit: the assembler's fixed sentence in the B/V packets says the FILES arms got "the 10 files of `FILES/`". For DS_FILES the files were the byte-identical `FILES_PD3/` set (one file renamed); this note and the ARMS delivery label disclose it.
- Times: DS_FILES now has an operator-logged reply_complete (not an upper bound). DS_ZIP still has the page-mtime upper bound (0.65 min). DS_ZIP is unusable, so condition 3 is met regardless and is not ambiguous.

## DS_ZIP: operator account (recorded 2026-10-03 12:41 CT)
- The operator says the zip upload was attempted and accepted: no refusal was shown.
- Yet the page shows only the packet in the user turn (`C49_R_DS_ZIP.txt TXT 2.78KB`). DeepSeek's reply/thinking says no zip was attached or openable ("Missing evidence files"), and lists all 9 files as OPENED: NO.
- This is the baseline observation the control measures: a zip "accepted" by the DeepSeek UI did not reach the model as readable evidence. It is not PD-3 and not rerun.
- Scorer note: the DS_ZIP Q2–Q4 parse picks up "25" from the file name `escalate_by_type_top25.csv` in the UNAVAILABLE text. facts_answered=3 / correct=1 should be 0 / 0. There is no effect on P1, because DS_ZIP is unusable either way. The frozen scorer is not changed.
