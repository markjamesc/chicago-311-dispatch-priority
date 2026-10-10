# C40R status note (added after publication; documentation only)

Control #40 (repair-round cap, re-run as C40R) is **inconclusive**. Its recorded state is HALT, and the existing rule stays by default.

1. **Scorer's HALT reason.** A timing record (`TIMES.txt`) is missing for a post-divergence round, INC round 3. Its send time and reply-complete time are unrecoverable and are recorded as unknown (`None` in the round table). The timing was not reconstructed.
2. **Observed outcome.** BOTH_CENSORED. The continuing builder (INC) had no valid build through round 6, and the fresh builder had none within its two-round cap. Neither builder produced a valid build within its experimental limit.
3. **Conclusion.** No advantage is demonstrated for either repair strategy. The result shows neither that a repair cap helps nor that unlimited repair is better. The result is not labelled REVERT. Even with the INC round-3 timing recovered, neither strategy would have a successful build in this experiment.
4. **Status source.** The state comes from the scorer report, `post/C40R_POST_RESULTS.md`. C40R has no `TERMINAL_STATE.txt`. It is the one exception to the statement that every recorded state comes from a control's own terminal-state file.

No evidence file was altered. The original evidence and its hashes in `MANIFEST.tsv` are unchanged. This note is not original evidence and is not listed in `MANIFEST.tsv`.
