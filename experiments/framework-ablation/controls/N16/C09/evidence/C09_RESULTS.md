# C09 RESULTS (mechanical replay; generated 2026-10-09 02:21:35 CT)

**Mechanical P1 result: REVERT side (the attack found 5 ambiguities that later needed a ruling)**
Declared rule: KEEP-side iff 0 substantive ledger ambiguities needed a later ruling; otherwise REVERT-side. Weak test (replay of the coordinator's ledger; the ledger is the coordinator's record of the Start/Framing dialogue, and the independent AI 2 / AI 3 Start and Framing reviews are listed below as the attack record).

## Counts
| measure | value |
|---|---|
| 1. ledger ambiguities (substantive, Blocking/Material/Framing/Deferred) that needed a later ruling: count | 5 |
| 2. Design Gate checklist items already named by the ledger or the Start lock (topic regexes declared in the scorer): count / items | 8 / 16 |

## Ambiguity ledger (all rows)
| id | point | severity | substantive | later ruling needed | resolution (abridged) |
|---|---|---|---|---|---|
| A001 | Request-level vs ward vs policy | Blocking | yes | no | **Resolved (T002):** request-level elevated vs normal |
| A002 | Available actions | Blocking | yes | no | **Resolved (T004/T010):** ESCALATE / INCONCLUSIVE / STANDARD |
| A003 | “This period” timing | Material | yes | yes | **Resolved principle (T006):** frozen window; **exact dates OPEN → Sta |
| A004 | Cannot-classify path | Material | yes | no | **Resolved (T004):** INCONCLUSIVE required |
| A005 | Live dispatch vs simulation | Material | yes | no | **Resolved (T008):** portfolio simulation only |
| A006 | Official City SLA | Material | yes | yes | **Resolved (T008):** no invented City SLA; portfolio urgency later |
| A007 | Eligible definition (what “open eligible” excludes) | Framing→Stage 3 | yes | yes | **Principle resolved (T012):** open = unresolved at frozen cutoff; eli |
| A008 | Urgency / lateness evidence rules | Deferred | yes | yes | **Open — Stage 3** |
| A009 | Independent AI 2/AI 3 Start review | Process | no (process) | no | **Resolved:** AI2 Pass (Grok Comprehensive); AI3 Revise noted; Start L |
| A010 | Human-owner Start Gate approval | Process | no (process) | no | **Resolved:** Start LOCKED; capacity/ranking later |
| A011 | Capacity / ranking if ESCALATE exceeds attention | Material (Framing note) | yes | yes | **Resolved for Framing question (T014):** three-way classification eno |
| A012 | Independent AI 2/AI 3 Framing reviews | Blocking (process) | yes | no | **Open — PENDING_COMPUTERUSE** |
| A013 | Human-owner Framing Gate approval | Blocking (governance) | no (process) | no | **Open — PENDING_OWNER** |

## Design Gate checklist items vs the ledger
| item | text (abridged) | named by ledger / Start lock |
|---|---|---|
| 1 | Lock candidate = B-leaning hybrid (TCD-IG); not Design A confidence-age as prima | no |
| 2 | Single knob = **κ**; default **2.0**; grid {1.0, 1.5, 2.0, 3.0} | no |
| 3 | Method constants W=365d, n_min=50 (not knobs) | no |
| 4 | First-pass window = snapshot as-of **T** (historical as-of without status histor | yes |
| 5 | Open = locked Open-token list (default `Open`); other statuses out of decision s | yes |
| 6 | Open + parseable CLOSED_DATE → INCONCLUSIVE (~24-row class) | yes |
| 7 | Default exclude DUPLICATE true-like and LEGACY_RECORD true-like; require type_ke | yes |
| 8 | Unresolved PARENT_SR_NUMBER → INCONCLUSIVE; no cluster collapse | no |
| 9 | Lock date-parse + timezone rule (date-level OK; hour-level deferred until tz loc | no |
| 10 | `open_age_h` diagnostic only — not escalate trigger | yes |
| 11 | Peer P75 labeled **empirical, not City SLA** on all outputs | yes |
| 12 | Fixture outline F01–F14 (esp. F03) as construct sign-off | no |
| 13 | Capacity/ranking **out of Stage 3**; excess ESCALATE → return to Framing | yes |
| 14 | SQL may emit peer aggregates; SQL must not emit labels | no |
| 15 | Prior coordinator MEASUREMENT_DESIGN = **superseded scratch** | no |
| 16 | Accept AI2 produced under **Grok Auto** (not Comprehensive) for this pass, **or* | yes |

## Independent attack record: counts of 'Blocking / Material / Revise / Tighten / required revision' words in the four AI 2 / AI 3 Start and Framing reviews
| review | word count |
|---|---|
| ai2_start | 2 |
| ai3_start | 1 |
| ai2_framing | 7 |
| ai3_framing | 4 |
