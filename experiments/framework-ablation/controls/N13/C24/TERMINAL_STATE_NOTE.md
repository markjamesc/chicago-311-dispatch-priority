# C24 terminal state: HALT (mechanical; recorded 2026-10-09 03:10 CT)
Owner ruling 2026-10-09 03:05 CT: record C24 as HALT; no v2, no adjudicator chats.
- Basis: C24_RESULTS.md "Mechanical predicate result: HALT"; spec HALT rule "arm B fails" (arm B R-B exit 1, invalid UTF-8 from the mysql client writing OEM-codepage byte 0x82 in 75 lines); COLLAPSED R-A and R-B MEMKILL.
- Recording path: record_terminal.R was NOT run, because it requires a Grok adjudicator reply (exactly one TERMINAL_STATE line plus END line) and none exists. TERMINAL_STATE.txt was written directly with the single word HALT, same format as C52/TERMINAL_STATE.txt. Source of the verdict: runner/owner ruling, not Grok.
- Builder/Validator/Grok packets stay on file, unused.
- A fixed v2 (--default-character-set=utf8mb4 plus enough free RAM) is possible later on owner request.
