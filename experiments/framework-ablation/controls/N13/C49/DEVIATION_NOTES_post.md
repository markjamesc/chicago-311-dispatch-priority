# C49 post-freeze deviation notes (b6)

## D-T1 Reply times written after the chats (coordinator ruling 2026-10-03 12:20 CT)
- No TIMES.txt was written at chat time. Under the ruling, the coordinator wrote them at ~12:25 CT:
  - `sent=` is the browser operator's logged send time (given in UTC, converted to CDT = UTC-5; both are in the file).
  - `reply_complete=` is an **UPPER BOUND**: the box mtime of the saved page (saved right after the END line appears).
  - Each file also records the page's own "Worked for" / "Thought for" indicator as a cross-check.
- Rule: if an upper bound makes a timing condition ambiguous, it is reported as ambiguous, not scored as met.
- Effect on condition 3: none so far. DS_ZIP is not usable: every file is OPENED: NO, because no zip reached the model. By the SPEC, condition 3 is then met whatever the DS_FILES time is, so an upper bound cannot make it ambiguous. Upper bounds: DS_ZIP 0.65 min, DS_FILES 2.48 min, GPT_FILES 5.00 min.
- The frozen `ABLATION_SPEC.md` is not edited (SPEC_FREEZE_b6.sha256). This note is the post-freeze deviation record.

## PD-3 SHA256SUMS was not delivered to the DS_FILES reviewer (harness delivery defect)
- **Evidence.** In the saved DS_FILES page (`C49/C49-DS_FILES/reply_deepseek.html`, 6f8681b3…), DeepSeek's thinking lists what it actually received: "That's 10 files provided, but SHA256SUMS missing". These 10 were `C49_R_DS_FILES.txt` plus the 9 evidence files, i.e. 9 of the 10 intended inputs. It also says: "SHA256SUMS not present. So we must inventory those 9. SHA256 cannot be provided."
- **Gaps in the page record.** The user turn's attachment chips are not in the saved DOM: DeepSeek's virtual list kept only 2 items. The `_files` assets hold only page JS/CSS, not the uploads. So the page cannot show whether an upload was attempted and refused.
- **Comparison with GPT_FILES.** The ChatGPT page lists `SHA256SUMS Document` among its 11 attachments, and the reply matches 9/9 SHA-256s. The same delivery set reached ChatGPT intact.
- **Likely cause (not proven).** DeepSeek does not take an extensionless file. The missing file sits in the middle of the alphabetical order, not at the end, which argues against a 10-attachment cap.
- **Ruling.** This is a harness delivery defect, not a model failure. The DS_FILES condition-2 result ("SHA256: UNAVAILABLE — SHA256SUMS not provided" for all 9 files) is **not scored as NOT MET**. It is recorded here as PD-3.
- **Fix: rerun the DS_FILES arm only.**
  - Delivery set `runner_b6/seeds/C49/delivery/FILES_PD3/`: the same 10 files, byte-identical, with `SHA256SUMS` renamed `SHA256SUMS.txt`.
  - Packet `C49/packets/C49_R_DS_FILES_PD3.txt`: identical to `C49_R_DS_FILES.txt` except that the two mentions of `SHA256SUMS` read `SHA256SUMS.txt`.
  - New DeepSeek chat (DeepThink). Before sending, the operator checks that 11 attachment chips are shown (packet + 10).
- **Other arms.**
  - GPT_FILES received SHA256SUMS, so no rerun.
  - DS_ZIP: only the packet reached the model (no zip chip; the reply says no zip was attached). That is the baseline observation the control measures (zip delivery to DeepSeek), not PD-3, and it is not rerun. The operator should confirm whether the zip upload was attempted and refused.
- **Scoring after the rerun.**
  - `c49_score.R` and `assemble_b6_bv.R` read `C49/C49-DS_FILES/` and the DS_FILES packet path in `ARMS.tsv`. The original DS_FILES record will be moved, not deleted, to `C49/_superseded_PD3/C49-DS_FILES/`, and the rerun placed at `C49/C49-DS_FILES/`.
  - The DS_FILES packet path will be pointed at `C49_R_DS_FILES_PD3.txt` by a disclosed post-freeze patch. The original hashes stay in `CAPTURE_FREEZE_b6.sha256`.
  - `C49/REPLY_FREEZE.json` and the C49 B/V packets are **not** written before the rerun. They would freeze the defective arm, and the assembler never overwrites a freeze.
