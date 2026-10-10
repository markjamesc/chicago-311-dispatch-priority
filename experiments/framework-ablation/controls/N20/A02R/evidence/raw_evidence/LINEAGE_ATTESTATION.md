# Lineage attestation — Stage 4 validated freeze (pending owner Validation Gate)

**As-of:** 2026-09-19 13:46 CT (post clock-parse fix re-run)  
**design_version:** `stage3-v1-tcd-ig`  
**fixture_version:** `fixtures-v1-tcd-ig`  
**T_freeze:** 2026-09-12 23:59:59 America/Chicago  
**κ:** 2.0

## SHA-256 (DESKTOP-RPECRM9)

| File | Bytes | SHA-256 |
|------|------:|---------|
| src_open_candidates.csv | 118,671,837 | BA089FCC51A0008BB1253AE6B8CDF8081AF9562A2AD8BF3FF73E376FB83D81B9 |
| src_peer_stats.csv | 16,276 | CB78AE214891EAECD0CC3C48BFFC52AEF745FF14E5F666647D8ABC215D79EB58 |
| RA_classifications.csv | 22,271,481 | C099E092FEB237C8492FECA12F0293C5875384E27375EB7A40991591D63AE0D9 |
| RB_classifications.csv | 41,963,733 | A0E42B8667B38BAF6BC1E79090D06B1A7C62659926EA7A78185975B8FE6FE193 |
| RA_fixture_results.csv | 985 | 33696CD1C6DF7EEFA62B07B078CFC554A661120D8B7685887FF3FFBCD82B6110 |
| RB_fixture_results.csv | 1,792 | 0D72245CAC95555E32A3E6073E3EA9CC0A97DE97F18C82965DFF21F49052E9E9 |
| RECON_SUMMARY.csv | 91 | 110CABAD9BA44BC69C1E2525EA014378E01CAB9F17561779D8D7EA0648640B09 |

## Portfolio (frozen candidate)

| Path | n_decision | ESCALATE | INCONCLUSIVE | STANDARD |
|------|-----------:|---------:|-------------:|---------:|
| R-A / R-B (agree) | 222,002 | 131,968 | 6,377 | 83,657 |

validated_action_list.csv = unordered ESCALATE set, n=131,968 (from R-A; identical labels to R-B after recon).

## Clock-parse fix recorded

Naive SQL wall clocks re-parsed as America/Chicago character → POSIXct (no `force_tz` / no trusted readr POSIXct). First production run had 104 ESCALATE/STANDARD disagrees (~5h skew); post-fix recon = 0 disagrees.
