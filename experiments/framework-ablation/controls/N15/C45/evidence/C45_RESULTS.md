# C45 RESULTS — Parallel R-A/R-B runs (Addendum 02 #45) (runner output, mechanical facts only)

Arm B is the serial reference run. SER_* run R-A then R-B. PAR_* launch R-A and R-B concurrently on the same arm copy of the frozen package.
Wall-clock = first launch to last exit, as measured by the runner. Peak memory = maximum summed working set of R processes, sampled every 0.5 s.

## Declared memory check (before the first concurrent arm)
declared rule: free physical memory >= 2 x serial peak working set + 2048 MB before any concurrent arm; serial peak 718 MB, need 3484 MB, free 15399 MB -> PASS

## Arms (C45_arms.csv)
| arm | mode | ra_exit | rb_exit | ra_secs | rb_secs | wall_s | peak_ws_mb | free_mb_before | outputs_equal_frozen | differing | outputs_equal_serial |
|---|---|---|---|---|---|---|---|---|---|---|---|
| B | SER | 0 | 0 | 10.7 | 25.0 | 36.4 | 718 | 15511 | 7/7 |  | TRUE |
| PAR_1 | PAR | 0 | 0 | 13.4 | 28.5 | 29.4 | 1011 | 15286 | 7/7 |  | TRUE |
| SER_2 | SER | 0 | 0 | 11.3 | 26.0 | 37.8 | 714 | 15508 | 7/7 |  | TRUE |
| PAR_2 | PAR | 0 | 0 | 12.1 | 26.9 | 27.1 | 1006 | 15443 | 7/7 |  | TRUE |
| SER_3 | SER | 0 | 0 | 11.5 | 25.7 | 37.8 | 718 | 15431 | 7/7 |  | TRUE |
| PAR_3 | PAR | 0 | 0 | 11.9 | 26.4 | 26.6 | 997 | 15464 | 7/7 |  | TRUE |

## Facts
- H1 runs with a non-zero exit or no exit record: none
- H2 every concurrent arm's 7 key outputs byte-identical to the serial arms and to the frozen outputs: YES
- H3 median wall-clock: serial 37.8 s (n=3), concurrent 27.1 s (n=3); ratio 0.717
- H4 peak memory: serial max 718 MB, concurrent max 1011 MB

## Proposed predicate P1 (Addendum 02 #45 wording)
KEEP-side if outputs are byte-identical to serial runs and wall-clock falls (median concurrent < median serial) with no run failure; REVERT-side if any output differs or a run fails.
P1 satisfied: identical=TRUE, failure=FALSE, median concurrent/serial=0.717
