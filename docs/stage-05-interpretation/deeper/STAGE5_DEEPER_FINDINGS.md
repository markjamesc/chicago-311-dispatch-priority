# Stage 5 — Deeper findings (frozen pack)

**When:** 2026-09-19 CT  
**Inputs:** Validation Gate freeze + workflow_gate PASS  
**ML mode:** None

## Independent checks

All critical counts match freeze: decision 222,002 · ESCALATE 131,968 · INCONCLUSIVE 6,377 · STANDARD 83,657 · validated_action_list 131,968.

## Portfolio (κ = 2)

| Label | n | Share of decision set |
|-------|--:|----------------------:|
| ESCALATE | 131,968 | 59.4% |
| INCONCLUSIVE | 6,377 | 2.9% |
| STANDARD | 83,657 | 37.7% |

## ESCALATE concentration by type

Top type_keys (share of ESCALATE):

| type_key | n | share | cum |
|----------|--:|------:|----:|
| WCA2 | 64,922 | 49.2% | 49.2% |
| SED | 17,254 | 13.1% | 62.3% |
| SKA | 7,316 | 5.5% | 67.8% |
| PBD | 3,937 | 3.0% | 70.8% |
| PHF | 3,371 | 2.6% | 73.4% |

WCA2 alone is about half of all ESCALATE rows. Cumulatively the top 3 types are ~68% of ESCALATE.

## INCONCLUSIVE

100% of INCONCLUSIVE (6,377) are `thin_type_or_missing_peer` (peer_n < n_min or missing peer). No other integrity clause appears in the frozen production labels.

## κ sensitivity (descriptive; κ=2 remains locked)

| κ | ESCALATE | STANDARD |
|--:|---------:|---------:|
| 1.0 | 152,292 | 63,333 |
| 1.5 | 140,340 | 75,285 |
| 2.0 | 131,968 | 83,657 |
| 3.0 | 118,246 | 97,379 |

INCONCLUSIVE stays 6,377 across the grid (integrity, not κ).

## Capacity note (Framing flag only)

ESCALATE = 131,968. Under illustrative shift budgets of 50 / 200 / 1,000 slots, coverage is near zero. Per locked Stage 3: **RANKING_NOT_IN_SCOPE** — if the owner needs a hard attention cap, return to Framing with a new question; do not invent ranking inside this design.

## Method caveats for interpretation

- Labels are portfolio-simulation under TCD-IG, **not** City SLA or live dispatch.
- High ESCALATE share is expected if many Open tickets are dormant relative to type peers at κ=2; it is not proof of operational backlog severity without peer-context review of dominant types (esp. WCA2).
