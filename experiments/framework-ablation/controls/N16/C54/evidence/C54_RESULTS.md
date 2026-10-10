# C54 RESULTS (mechanical replay; generated 2026-10-09 02:21:36 CT)

**Mechanical P1 result: NOT MET**
Replay only: byte-identity of a downloaded file vs the saved page, and intake minutes, are NOT measured (option 54-A, a live test, is not run). Chrome page saving is broken on the box; this replay does not need it.

## Conditions
| condition | result |
|---|---|
| 1. at least one reply-capture failure, with an established page-capture cause, on a download-capable site (ChatGPT or Grok) that a download would have avoided | NOT MET |
| 2. the sample is not trivial: at least 30 logged captures | MET |
| 3. dependency #43 = REVERT (full freeze scope stays), so every downloaded file would be hashed and logged under the existing scope; no saving is claimed | MET |

## Counts: 41 log entries, 3 incident entries (3 still incident in the final log entry for that capture), download-capable captures 25, avoidable incidents 0
C43 TERMINAL_STATE (frozen, N13): REVERT

## Incident entries
| log | control | file | site | md_bytes | incident | explanation (from coordinator notes) | download premise |
|---|---|---|---|---|---|---|---|
| CAPTURE_C49BV | C49 | validator_deepseek.html | deepseek | 12402 | reply did not end at its END line in the capture | DeepSeek reply stopped inside section 7, no END line (C49_NOTES.md) | not avoidable (DeepSeek: no download in UI, premise) |
| CAPTURE_b5 | C48 | ai2_grok.html | grok | 4078 | reply did not end at its END line in the capture | capture log flag ends_ok=false for the Grok page although the extracted reply's last line is its END line; the log does not record why (cause NOT established) | cause not established: not counted as avoidable |
| CAPTURE_b6 | C43 | validator_deepseek.html | deepseek |  | log entry has no extraction result (incomplete capture / harness incident) | DeepSeek stopped in thinking; incomplete page (C43_NOTES.md) | not avoidable (DeepSeek: no download in UI, premise) |

## Input-side incident (not a reply capture; listed, not scored)
- ## D-C1 Round-2 message: backticks arrived as U+001F control characters (judged NOT material)
- ## D-C2 r2 reply re-extracted with extract_reply_v3.py (tool fix)

## All captures
| log | control | file | site | md_bytes | incident |
|---|---|---|---|---|---|
| ADJ_GROK_B4 | C51 | adjudicator_grok.html | grok | 12861 |  |
| ADJ_GROK_B4 | C46 | adjudicator_grok.html | grok | 12536 |  |
| ADJ_GROK_B5 | C41 | adjudicator_grok.html | grok | 11291 |  |
| ADJ_GROK_B5 | C47 | adjudicator_grok.html | grok | 12009 |  |
| ADJ_GROK_B5 | C53 | adjudicator_grok.html | grok | 12307 |  |
| ADJ_GROK_B5 | C42 | adjudicator_grok.html | grok | 11873 |  |
| ADJ_GROK_C43 | C43 | adjudicator_grok.html | grok | 12372 |  |
| ADJ_GROK_C44 | C44 | adjudicator_grok.html | grok | 11804 |  |
| ADJ_GROK_C48 | C48 | adjudicator_grok.html | grok | 9593 |  |
| ADJ_GROK_C49 | C49 | adjudicator_grok.html | grok | 13650 |  |
| CAPTURE_C48BV | C48 | builder_chatgpt.html | chatgpt | 17840 |  |
| CAPTURE_C48BV | C48 | validator_deepseek.html | deepseek | 9332 |  |
| CAPTURE_C49BV | C49 | builder_chatgpt.html | chatgpt | 17860 |  |
| CAPTURE_C49BV | C49 | validator_deepseek.html | deepseek | 12402 | reply did not end at its END line in the capture |
| CAPTURE_C49V_r2 | C49 | validator_deepseek_r2.html | deepseek | 10269 |  |
| CAPTURE_b4 | C51 | builder_chatgpt.html | chatgpt | 19925 |  |
| CAPTURE_b4 | C51 | validator_deepseek.html | deepseek | 9966 |  |
| CAPTURE_b4 | C46 | builder_chatgpt.html | chatgpt | 24696 |  |
| CAPTURE_b4 | C46 | validator_deepseek.html | deepseek | 12131 |  |
| CAPTURE_b5 | C41 | builder_chatgpt.html | chatgpt | 17713 |  |
| CAPTURE_b5 | C41 | validator_deepseek.html | deepseek | 9611 |  |
| CAPTURE_b5 | C47 | builder_chatgpt.html | chatgpt | 17718 |  |
| CAPTURE_b5 | C47 | validator_deepseek.html | deepseek | 10593 |  |
| CAPTURE_b5 | C53 | builder_chatgpt.html | chatgpt | 19154 |  |
| CAPTURE_b5 | C53 | validator_deepseek.html | deepseek | 13725 |  |
| CAPTURE_b5 | C42 | builder_chatgpt.html | chatgpt | 16993 |  |
| CAPTURE_b5 | C42 | validator_deepseek.html | deepseek | 9846 |  |
| CAPTURE_b5 | C48 | ai2_grok.html | grok | 4078 | reply did not end at its END line in the capture |
| CAPTURE_b5 | C48 | ai3_deepseek.html | deepseek | 3053 |  |
| CAPTURE_b6 | C44 | delta_deepseek.html | deepseek | 2834 |  |
| CAPTURE_b6 | C49 | reply_deepseek.html | deepseek | 1842 |  |
| CAPTURE_b6 | C49 | reply_deepseek.html | deepseek | 2371 |  |
| CAPTURE_b6 | C49 | reply_chatgpt.html | chatgpt | 3724 |  |
| CAPTURE_b6 | C40 | inc_r1_chatgpt.html | chatgpt | 6684 |  |
| CAPTURE_b6 | C43 | builder_chatgpt.html | chatgpt | 19649 |  |
| CAPTURE_b6 | C43 | validator_deepseek.html | deepseek |  | log entry has no extraction result (incomplete capture / harness incident) |
| CAPTURE_b6b | C49 | reply_deepseek.html | deepseek | 2596 |  |
| CAPTURE_b6b | C40 | inc_r2_chatgpt.html | chatgpt | 6962 |  |
| CAPTURE_b6b | C44 | builder_chatgpt.html | chatgpt | 19696 |  |
| CAPTURE_b6b | C44 | validator_deepseek.html | deepseek | 11786 |  |
| CAPTURE_b6b_fix | C40 | inc_r2_chatgpt.html | chatgpt | 7706 |  |
