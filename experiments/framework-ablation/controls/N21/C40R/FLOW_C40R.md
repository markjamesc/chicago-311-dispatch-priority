# C40R operator flow (nothing has been run yet)
Copy `runs/N21/C40R/*` (incl. `runner_c40r/`) to `<WORK>` on the PC so that `<WORK>\runner_c40r\...` and `<WORK>\C40R\packets\...` exist. Frozen pack path is the c40r_round.ps1 default.
0. Validation (no chat): `c40r_round.ps1 -Arm REF -Round 0 -Candidate <frozen 20_ module> -Validation`, and the same for the 3 SEED_* files. REF must PASS with hidden PASS; seeds must FAIL (P1 condition 0). Otherwise stop = HALT.
1. Chat 1 — ChatGPT, NEW chat "INC": paste `packets/C40R_1_INC_BUILDER_ChatGPT.txt`. Write TIMES.txt at chat time. Save reply to `C40R\C40R-INC\r1\reply.md`, run `c40r_round.ps1 -Arm INC -Round 1`. It writes the next MESSAGE.txt (attach as file) or logs NOT_TRIGGERED.
2. Chat 1 continued — INC repair rounds r2, r3 ... r6 (same chat) while the gate FAILS. Stop at first PASS or after r6.
3. Chat 2 — only if INC r1 and r2 both FAILED: ChatGPT, NEW chat "FRESH": `packets/C40R_2_FRESH_BUILDER_ChatGPT.txt` (auto-generated at divergence). Repair rounds r2 in same chat (max 2 rounds total).
4. If EVALUATED/INC and FRESH finished: `python3 c40r_assemble.py <WORK>`, then Chat 3 — ChatGPT NEW chat Builder report (`C40R_3_BUILDER_ChatGPT.txt`); Chat 4 — DeepSeek NEW chat Validator (`C40R_4_VALIDATOR_DeepSeek.txt`, blind); Chat 5 — Grok NEW chat Adjudicator (`C40R_5_ADJUDICATOR_Grok.HEAD.txt`), after freezing chats 3 and 4.
Outcomes NOT_TRIGGERED or BOTH_CENSORED: no chats 3-5; no third design (pre-registered).
