# C44 post-freeze deviation notes (b6)

## D-T1 Reply times written after the chats (coordinator ruling 2026-10-03 12:20 CT)
- No TIMES.txt was written at chat time. Under the ruling, the coordinator wrote them at ~12:25 CT:
  - `sent=` is the browser operator's logged send time (given in UTC, converted to CDT = UTC-5; both are in the file).
  - `reply_complete=` is an **UPPER BOUND**: the box mtime of the saved page (saved right after the END line appears). It is not an observed completion time.
  - Each file also records the page's own "Worked for" / "Thought for" indicator as a cross-check.
- Rule: if an upper bound makes a timing condition ambiguous, it is reported as ambiguous, not scored as met.
- The frozen `ABLATION_SPEC.md` is not edited (SPEC_FREEZE_b6.sha256 and the B/V/G packets carry it). This note is the post-freeze deviation record. Each TIMES.txt carries the same disclosure and is quoted verbatim in the B/V/G packets.

## Effect on C44
- Condition 3 stays on the declared fallback (packet bytes): the FULL arm (b5 C48 AI 3 second audit) has no logged send time, so `TIMES_FULL.txt` does not exist and the wall-clock comparison cannot be made. The DELTA upper bound (0.77 min) is reported only, not scored.
