# C40R — Ablation specification (FROZEN)

**Ablation ID:** C40R (re-test of Addendum 01b candidate #40 "Repair-round cap"; successor to C40, N13 batch 6)
**Why C40R exists:** C40 ended NOT_TRIGGERED (2026-10-03): the incumbent builder's first build failed the gate and its second passed, so the cap of 2 failed rounds was never reached and the two regimes were identical. C40 produced no verdict. Owner instruction 2026-10-10: finish #40.
**Definition under test (unchanged from C40; owner's Addendum 01b text, `ADDENDUM_01_control_39.md` SHA-256 `a3bf8f6a6b27a670c8a3dde85e7fe51a53febfff298d2e70b2f3511e82de5b4f`):** Rule as it stands: unlimited repair rounds for one builder (PricePoint R-B reached r10). Variant: after 2 failed rounds (the owner text says "2–3"; 2 is used, as in C40), swap in a fresh builder, or escalate to the owner after the fresh builder's own cap. KEEP (adopt the cap) if a valid build arrives no later and no defect escapes. REVERT otherwise. HALT if evidence is incomplete.
**The cap is NOT redefined.** It stays at 2 failed rounds. Lowering it to 1 was considered and rejected (see "Design choice").
**Constitution:** 1.0, `CONSTITUTION_v1.md` (copy of the C40 file), SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`.
**Baseline frameworks (frozen pre-hardening, as in C40):**
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2. PC `C:\Users\Mark\Documents\R Working Directory\chicago311`, read only. No new data, no MySQL, no internet.
**Roles:** Builder (extra chats) = ChatGPT (incumbent chat INC; fresh chat FRESH) · Validator = DeepSeek · Adjudicator = Grok. No Grok chat is used for building (owner usage priority).

## Design choice (what is real, what is modelled)
- **REAL, reused as prior evidence only:** the C40 run (INC r1 FAIL, r2 PASS, NOT_TRIGGERED), the PricePoint R-B history (r1–r10, Addendum 02 #40 table, ~9 h 42 min to a valid build), and the frozen C40 gate and hidden check scripts. None of this is re-scored, edited or reconstructed. No evidence is fabricated or self-adjudicated. The C40 result stays NOT_TRIGGERED in the scorecard history.
- **Rejected options:** (a) *Replaying C40 with a cap of 1.* It changes the rule under test (owner text says 2–3) and the real r2 pass (1.19 active minutes) would make the fresh builder lose on time by construction. (b) *Counterfactually simulating a fresh builder from the saved PricePoint rounds.* That would be modelled evidence; the Addendum itself says that duration is not measured. (c) *Seeding a failure into a builder's output.* Fabricates the builder behaviour.
- **MODELLED (disclosed):** the task difficulty. Instead of the small I/O parsing module, the build task is the largest logic module of the frozen R-B path, `R-B/R/20_integrity_and_classify.R` (the integrity gate and κ classification, plus portfolio and κ-grid count functions). In PricePoint this is the kind of module whose byte-exact reconciliation took R-B many rounds. This raises the chance that the incumbent fails twice; it does not guarantee it. Every build, gate and hidden-check result is a real run on the PC. Difficulty is a design choice made BEFORE any builder chat and is not tuned afterwards.
- **If the incumbent again passes at r1 or r2:** the outcome is NOT_TRIGGERED a second time. No third design is run under this spec; #40 stays "no verdict, n=2 NOT_TRIGGERED" and the owner decides (accept the rule as-is, or define a different cap). This is pre-registered here to prevent hunting for a triggering task.

## Exact change being tested
- **Build task (identical for every builder):** write `R-B/R/20_integrity_and_classify.R` for the frozen R-B path. The packet gives every other R-B file verbatim, including the frozen `10_io_parse.R`, `00_config.R`, `40_fixtures.R`, `run_RB.R`, the locked design documents, source file samples, the output-column contract and reference output hashes. The frozen module itself is never shown.
- **Functions the module must define (called by `run_RB.R` and `40_fixtures.R`):** `rb_judge_rows(open_df, peer_df, kappa, t_freeze)`, `rb_portfolio_counts(judged, kappa)`, `rb_kappa_grid_counts(open_df, peer_df, grid, t_freeze)`.
- **Gate (valid build), `c40r_gate.R` (byte-copy of `c40_gate.R` except label text):** the frozen R-B tree with only `20_integrity_and_classify.R` replaced; `Rscript R-B/run_RB.R all` on the frozen extract exits 0, fixtures 14/14, and the 4 R-B key outputs are byte-identical to the frozen ones. A failed gate produces `GATE_REPORT.md` (exit status, failing fixtures, which outputs differ, per-column counts, up to 5 example rows; no frozen code), sent to the builder as the next repair message.
- **Hidden escape check:** on every gate-passing build, the ruling-41A depth gate `fixdepth.R depth` (byte-copy of the C40 file), never shown to builders. "No defect escapes" = the valid build passes it.
- **Regimes (`c40r_next.R` state machine; adapted copy of `c40_next.R`):** INC r1 → gate. PASS at r1 or r2 → **NOT_TRIGGERED**. INC r1 and r2 both FAIL → regimes diverge: **variant** = FRESH chat (new ChatGPT chat) with the original packet plus INC's r1–r2 gate reports (no code), cap 2 failed rounds, then escalation; **baseline** = INC continues repairing, experiment stop at r6. Neither reaches a valid build → **BOTH_CENSORED** (HALT-incomplete).
- **Time:** active minutes from divergence = Σ over rounds after r2 of (reply minutes from `TIMES.txt` + runner-measured gate minutes). `TIMES.txt` is written by the operator AT CHAT TIME, two lines `sent=YYYY-mm-dd HH:MM:SS` and `reply_complete=YYYY-mm-dd HH:MM:SS` (America/Chicago, operator's clock), with the reply-complete time read from the page when the END line appears, not from a file mtime. Baseline without a valid build by r6 counts as infinite. Minutes are operator-logged (disclosed). If an upper bound decides condition 2, report it as ambiguous (no scoring as met).
- **Chat protocol:** one INC chat; messages are rounds. Attach `MESSAGE.txt` as a file or verify the composer before sending (C40 note D-C1: backticks were garbled). Builder chats are blind to the ablation and are frozen round by round.

## Pre-freeze disclosure: validation attempt 1 (a seed defect, NOT a result)
On 2026-10-10 13:41-13:44 CT, before any builder chat, gate validation was run on the PC on the first freeze (SPEC_FREEZE hash 6a57ef586e97...). REF passed; SEED_REASONFMT and SEED_DUPLEAK failed as expected; the seed SEED_KAPPAGT (`dormant_h > thresh` instead of `>=`) PASSED the gate and hidden check, because no row lies exactly on the boundary, so it changed nothing. That is a defect of the seed, found before any builder round, and says nothing about the repair cap. Owner-approved on 2026-10-10: the seed was replaced. The first replacement, SEED_THINPEER (`peer_n <= RB_N_MIN` instead of `<`), was validated at 13:46 CT and ALSO passed, because the peer table has no type with peer_n = 50 (smallest values 1, 5, 8, 25, 32, 33, 58, 70). The second replacement is SEED_NOPARENT (the I05 clause `p_parent` forced FALSE; 23,014 source rows carry a PARENT_SR_NUMBER). The spec, ARMS.tsv, seeds and packet templates were re-frozen after each replacement (new freeze hashes). The failed first-attempt rows are kept verbatim in `VALIDATION_ATTEMPT1_ROUNDS_LOG.tsv`, the attempt-2 rows (REF PASS, SEED_THINPEER PASS, SEED_REASONFMT FAIL, SEED_DUPLEAK FAIL) in `VALIDATION_ATTEMPT2_ROUNDS_LOG.tsv`, and both old seeds and freeze files in `superseded_seed_v1/`. These are seed defects found before any builder round, not results. No other file was changed; the INC and FRESH builder packets are byte-identical to the first freeze.

## Verdict convention
**KEEP = adopt the cap (a valid build arrives no later and no defect escapes). REVERT otherwise. HALT if evidence is incomplete.**

## Operational benefit predicate P1 (mechanical; same as C40, module name changed only)
Evaluated only if the regimes diverged. **P1 satisfied (KEEP side)** when all hold:
0. (validity) gate validation before any chat: REF PASS with hidden PASS; every seeded module (SEED_NOPARENT, SEED_REASONFMT, SEED_DUPLEAK) FAIL the gate;
1. the variant (FRESH) reaches a valid build within its cap (2 failed rounds);
2. no later: the variant's active minutes from divergence ≤ the baseline's (baseline without a valid build by r6 = infinite);
3. no defect escapes: the variant's valid build passes the hidden check.
REVERT side: 1, 2 or 3 fails. HALT if 0 fails or a round record is missing. NOT_TRIGGERED and BOTH_CENSORED are reported as such (no verdict).
Disclosed limits: n = 1 task, one builder model; the FRESH builder gets the handover reports (that is the variant as defined); the hidden check is not shown to discriminate between gate-passing modules; the module-difficulty choice is modelled; timing is operator-logged.

## Regression / HALT rules
HALT if a gate run or exit record is missing, if gate validation fails, or if Builder and Validator disagree on a hard number in the RESULTS file.

## Chats (exact order; Grok only for adjudication)
1. INC builder (ChatGPT, new chat) packet `C40R_1_INC_BUILDER_ChatGPT.txt`, then repair messages in the same chat while gates fail (max r6).
2. Only if INC r1 and r2 FAIL: FRESH builder (ChatGPT, new chat) packet `C40R_2_FRESH_BUILDER_ChatGPT.txt` (generated), repairs in that chat (max r2).
3. Only if EVALUATED: Builder report (ChatGPT, new chat), Validator report (DeepSeek, new chat), Adjudicator (Grok, new chat), packets assembled by `c40r_assemble.py`.

## Frozen hashes (preflighted by `c40r_round.ps1` before every round; any mismatch = no round runs)
- `R-B/run_RB.R` SHA-256 `6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd`
- `R-B/R/00_config.R` SHA-256 `6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b`
- `R-B/R/10_io_parse.R (frozen, shown to builders)` SHA-256 `40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a`
- `R-B/R/20_integrity_and_classify.R (frozen, NEVER shown)` SHA-256 `72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99`
- `R-B/R/40_fixtures.R` SHA-256 `2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e`
- `R-B/outputs/RB_classifications.csv` SHA-256 `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193`
- `R-B/outputs/RB_fixture_results.csv` SHA-256 `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9`
- `R-B/outputs/RB_portfolio_counts.csv` SHA-256 `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c`
- `R-B/outputs/RB_kappa_grid_counts.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a`
- `data/source/src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9`
- `data/source/src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`

Runner files, seeds, scorer and packets are listed with SHA-256 in `SPEC_FREEZE_C40R.sha256` (written after this spec, before any PC execution).
