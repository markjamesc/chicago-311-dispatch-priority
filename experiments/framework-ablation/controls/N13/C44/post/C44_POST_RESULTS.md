# C44 POST-CHAT RESULTS (mechanical; generated 2026-10-03 12:23:38 CDT)

**Mechanical predicate result: PARTIAL: mechanical conditions 2-3 MET; condition 1 is judged from the frozen replies**

## Predicate conditions
| condition | met |
|---|---|
| 1. every BLOCKING or MATERIAL finding the FULL re-review raises is also raised by the DELTA re-review (finding level; judged by Builder/Validator/Adjudicator from the frozen replies; key-level aid below) | PENDING (judged) |
| 2. the DELTA re-review catches the changed-file seed (V-3 not applied exactly, or a BLOCKING/MATERIAL finding on V-3) | MET |
| 3. round cost falls by >= 30%: PROXY (declared fallback; full-arm send time not logged): packet bytes | MET |

## Arms
| arm | reply_sha256 | reply_bytes | end_line | packet_bytes | packet_sha256 | V1 | V2 | V3 | V4 | V5 | V6 | n_findings | n_blocking_material | bm_keys | seed_V3_caught | minutes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| FULL | 8b473adf6fd7cfe4ba6b363fcb52f009561b26f4ca44d6295126ad9a96c2aed2 | 3053 | TRUE | 58214 | dab6e55f63eb67f6628ab05b3d5c3d52ab1301e804e8892ba22113735f6aeb96 | YES | YES | PARTIAL | YES | YES | YES | 1 | 1 | V-3 | TRUE | NA |
| DELTA | d0635883ab82f4bf5d1f3fc94200715d5d4b66746aaf2023a99c64b43a9cebfb | 2834 | TRUE | 18691 | a3c359dc253fd91224b811df2e1f0f14cde5827418da7166e0c8f628256508bb | YES | YES | NO | YES | YES | YES | 1 | 1 | V-3 | TRUE | 0.77 |

Key-level aid for condition 1 (not the predicate): FULL BLOCKING/MATERIAL relates_to keys = {V-3}; DELTA = {V-3}; every FULL key present in DELTA: TRUE.

Unchanged-file seed: NOT PLANTED (the full arm is the frozen b5 C48 audit; a second new full-scope chat would be needed). Reported as not measured.

## FINDINGS_FULL.csv (parsed table rows)
| arm | severity | relates_to | row |
|---|---|---|---|
| FULL | BLOCKING | V-3 | / F-1 / BLOCKING / V-3 / `WCA2 alone supplies 64,922 of these (42.9% of ESCALATE), so the ESCALATE volume is concentrated in one service type.` / Replace `42.9%` with `49.2%`. Recompute: `64,922 / 131,968 = 0.491952595`, i.e. `49.1953%`, rounded to `49.2%`. The count `64,922` and the concentration sentence are otherwise supported. / |

## FINDINGS_DELTA.csv (parsed table rows)
| arm | severity | relates_to | row |
|---|---|---|---|
| DELTA | MATERIAL | V-3 | / F1 / MATERIAL / V-3 / `WCA2 alone supplies 64,922 of these (42.9% of ESCALATE), so the ESCALATE volume is concentrated in one service type.` / Replace `42.9%` with `49.2%`. The required correction and arithmetic give `64,922 / 131,968 = 0.491952595 = 49.1953% ≈ 49.2%`. / |

