# C24 v2 — Ablation specification (FROZEN)

**Ablation ID:** C24 v2 (catalog #24 "Mechanical vs Judged Population"), batch N18, owner-authorised rerun 2026-10-09 ("sure do it, finish 24"), owner reconfirmed 2026-10-10.
**Supersedes nothing:** N13 C24 stays on file as terminal state HALT (owner ruling 2026-10-09 03:05 CT; harness defect). Its evidence is untouched. v2's verdict, once adjudicated, is the C24 verdict that replaces it.
**Design: identical to N13 C24** (`runs/N13/C24/ABLATION_SPEC.md`: control, KEEP/REVERT convention, arms X_SEP/X_FULL, predicate P1, HALT rules, frozen data pack hashes, constitution and baseline hashes, SQL seeds). Read that file for the full text; only the changes below differ.

## Changes in v2 (harness fixes only; the control and predicate are not changed)
1. **Client character set:** every mysql call adds `--default-character-set=utf8mb4`, so output is UTF-8 and not the Windows OEM codepage (N13 defect: byte 0x82 in 75 lines made arm B R-B fail with invalid UTF-8).
2. **RAM gate (wait, not kill):** before each COLLAPSED R run the runner waits until free physical memory >= 19,968 MB (19.5 GB) and logs the wait (max 12 h). The 2,048 MB MEMKILL watchdog is unchanged. N13 COLLAPSED R-A/R-B peaked at 15.3/17.2 GB and were MEMKILLed. A MEMKILL in v2 still counts as failure of P1 condition 2 / HALT per the original rules.
3. **Names:** work dir `...\ablation-runs\N18`, output folder `C24V2`, log `RUNNER_LOG_C24V2.txt`, result files `C24V2_RESULTS.md`, `C24V2_arms.csv`, `C24V2_EVIDENCE.sha256`; runner `run_c24v2.ps1`, evaluator `eval_c24v2.R`, seeds list `SEEDS_C24V2.sha256`.
4. R version: `C:\Program Files\R\R-4.6.1\bin\Rscript.exe` (same as N13, found installed). MySQL: `C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`, service MySQL80 running. Local only, no internet, no downloads.

## Known disclosures carried over
N1/OF-1 (1.000 h on three ESCALATE rows between R-A and R-B) does not affect COLLAPSED vs B comparison. Arm B vs frozen outputs is INFO only; with utf8mb4 export, arm B may now differ from the frozen extract on the 109 SR_TYPE rows (frozen file has '?' there) and arm B R-A/R-B outputs may differ from the frozen outputs accordingly (INFO, not gating).

## Frozen runner-side hashes (`runner/SEEDS_C24V2.sha256`, verified by preflight)
See that file; contents quoted in the packet. Spec hashed in `SPEC_FREEZE_C24V2.sha256`.

## Roles / tasks
Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok, same tasks as N13 C24 spec. Verdict convention unchanged: KEEP = collapse the envelope into R; REVERT = separation stays; HALT per constitution §9.
