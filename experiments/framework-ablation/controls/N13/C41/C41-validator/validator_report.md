1. **Role attestation and ablation ID**  
   I am DeepSeek, acting only as Validator, with DeepThink on. I have not seen and have not asked for the Builder’s output. Ablation ID: C41, Addendum 01 candidate #41 “Fixture depth over count”, N13 batch 5. I do not return KEEP, REVERT, or HALT.
2. **Independent test plan: what I checked, and how**  
   I read the frozen SPEC, constitution excerpt, coordinator note N1/OF-1, preflight, run log, `C41_RESULTS.md`, `C41_arms.csv`, raw per-arm files, ARM MANIFESTS, and SEED DIFFS. I independently recomputed:

- run-exit completeness and exit codes for every arm/gate/run;
- gate outcomes from `GATE_count.txt`, `GATE_depth.txt`, `FIX_count.csv`, `FIX_depth.csv`;
- fixture pass counts, failing-fixture sets, and stub sets;
- portfolio-count identities from each `RB_portfolio_counts.csv`;
- portfolio deltas versus clean arm B;
- cross-arm SHA-256 equalities from ARM MANIFESTS;
- clean arm B’s four R-B key-output hashes against the frozen reference hashes;
- P1 condition 1–4 mechanically where the packet permits;
- whether N1/OF-1 could affect C41 clean arm B reconciliation.

3. **Independently recomputed hard facts**  
   **Run exits.** There are 6 arms × 3 runs = 18 required exit records. All are present in the manifests. All recorded `RUN_*.exit` first fields are `0`; no timeout is recorded. Clean arm B’s production run `RUN_RB.exit` is `0`.

**Gate outcomes recomputed from raw files.**

| arm | count gate | count n_pass | count failing | depth gate | depth n_pass | depth failing | depth stubs | depth error |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| B | PASS | 14 | none | PASS | 14 | none | none | none |
| P_DUPINT | PASS | 14 | none | FAIL | 13 | F07 | none | none |
| P_DATESWAP | PASS | 14 | none | FAIL | 10 | F03/F05/F10/F14 | none | none |
| STUB_F11 | PASS | 14 | none | FAIL | 14 | none | F11 | none |
| JUDGE_P50 | FAIL | 12 | F03/F10 | FAIL | 12 | F03/F10 | none | none |
| P_TZUTC | PASS | 14 | none | PASS | 14 | none | none | none |

**Portfolio-count identities.** For every arm, `n_ESCALATE + n_INCONCLUSIVE + n_STANDARD = n_decision`.

| arm | n_decision | n_ESCALATE | n_INCONCLUSIVE | n_STANDARD | sum ESC+INC+STD | n_out_of_set | total decision+out |
| --- | --- | --- | --- | --- | --- | --- | --- |
| B | 222002 | 131968 | 6377 | 83657 | 222002 | 23191 | 245193 |
| P_DUPINT | 245014 | 131968 | 29389 | 83657 | 245014 | 179 | 245193 |
| P_DATESWAP | 222002 | 120630 | 38605 | 62767 | 222002 | 23191 | 245193 |
| STUB_F11 | 222002 | 131968 | 6377 | 83657 | 222002 | 23191 | 245193 |
| JUDGE_P50 | 222002 | 148941 | 6377 | 66684 | 222002 | 23191 | 245193 |
| P_TZUTC | 222002 | 132072 | 6377 | 83553 | 222002 | 23191 | 245193 |

**Portfolio deltas versus clean B.**

| arm | Δn_decision | ΔESCALATE | ΔINCONCLUSIVE | ΔSTANDARD | Δout_of_set |
| --- | --- | --- | --- | --- | --- |
| P_DUPINT | +23012 | 0 | +23012 | 0 | -23012 |
| P_DATESWAP | 0 | -11338 | +32228 | -20890 | 0 |
| STUB_F11 | 0 | 0 | 0 | 0 | 0 |
| JUDGE_P50 | 0 | +16973 | 0 | -16973 | 0 |
| P_TZUTC | 0 | +104 | 0 | -104 | 0 |

**D-sets.**

- B: count ∅; depth ∅.
- P_DUPINT: count ∅; depth {F07}.
- P_DATESWAP: count ∅; depth {F03, F05, F10, F14}.
- STUB_F11: count ∅; depth failing fixtures ∅, but stub set {F11} causes depth gate FAIL.
- JUDGE_P50: count {F03, F10}; depth {F03, F10}.
- P_TZUTC: count ∅; depth ∅.

**Cross-arm hash equalities from ARM MANIFESTS.**

- `FIX_count.csv`: all arms except JUDGE_P50 share `d3997d15…`; JUDGE_P50 is `f80baac3…`.
- `GATE_count.txt`: all arms except JUDGE_P50 share `b554bfdf…`; JUDGE_P50 is `b36b5fe4…`.
- `FIX_depth.csv`: B and P_TZUTC share `721067c0…`; STUB_F11 `0954e7fe…`; P_DUPINT `1cc1af4e…`; P_DATESWAP `aeba7b97…`; JUDGE_P50 `c6168122…`.
- `GATE_depth.txt`: B and P_TZUTC share `e3464b6b…`; STUB_F11 `8c9912f7…`; P_DUPINT `423e0255…`; P_DATESWAP `bd450fa7…`; JUDGE_P50 `741e5da1…`.
- `RB_classifications.csv`: B and STUB_F11 share `a0e42b86…`; all other arms differ.
- `RB_fixture_results.csv`: B, P_DUPINT, P_DATESWAP, STUB_F11, P_TZUTC share `0d72245c…`; JUDGE_P50 is `6c4a4af1…`.
- `RB_portfolio_counts.csv`: B and STUB_F11 share `eb677bc1…`; all other arms differ.
- `RB_kappa_grid_counts.csv`: B and STUB_F11 share `7a18fcb1…`; all other arms differ.

**Clean arm B vs frozen R-B key outputs.** B’s four R-B hashes equal the frozen reference hashes:

- `RB_classifications.csv`: `a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193` = frozen.
- `RB_fixture_results.csv`: `0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9` = frozen.
- `RB_portfolio_counts.csv`: `eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c` = frozen.
- `RB_kappa_grid_counts.csv`: `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` = frozen.

**Internal inconsistency flags.** No numerical inconsistency was found in the portfolio identities, gate counts, or D-sets. Two apparent oddities are consistent with the design: STUB_F11 has depth `n_pass=14` but gate FAIL because `stubs=F11`; and P_DATESWAP/P_DUPINT production `RB_fixture_results.csv` equal frozen while their depth gates fail, because the count-gate fixtures bypass the loader. One spec-vs-code caveat remains: the depth harness code writes logical columns through `write.table`, while the SPEC says `DUPLICATE/LEGACY as true/false`; the packet does not include the generated TSV text, so exact casing cannot be verified from this packet.

4. **Facts that cannot be recomputed from this packet**

- Exact byte content of `FIXTURE_src_open_candidates.tsv` and `FIXTURE_src_peer_stats.tsv`; only hashes and sizes are given, so exact casing/layout of `DUPLICATE`/`LEGACY` and `*_DATE`/`*_ts` fields cannot be verified.
- Full source of `rb_build_fixture_pack`, `rb_read_csv_flex`, `rb_normalize_open`, `rb_normalize_peers`, `rb_judge_rows`, and `rb_score_fixtures`; only seed diffs and hashes are given.
- The actual chat count / “no extra chats” part of P1 condition 4.
- The exact `SPEC_FREEZE_b5.sha256` file hashes from the packet text alone.
- The pre-execution scratch run outcome independently; it is disclosed but not raw evidence here.
- The N1/OF-1 PC clock behavior independently; it is disclosed in the coordinator note.
- The effect of the concurrent MySQL batch on timing independently.
- Builder’s output and Builder–Validator agreement; I am blind to Builder.

5. **P1 assessment against the frozen predicate in the SPEC**  
   Facts only, no terminal state.

- Condition 1, superset: count gate caught JUDGE_P50; depth gate caught JUDGE_P50. Count gate caught no other seeded arm. Therefore every seeded arm the count gate caught is also caught by the depth gate. Facts support condition 1.
- Condition 2, ruled targets: depth gate FAIL for P_DUPINT (F07), P_DATESWAP (F03/F05/F10/F14), and STUB_F11 (stub F11). Facts support condition 2.
- Condition 3, clean arm B: count gate PASS 14/14; depth gate PASS 14/14; B’s four R-B key outputs match the frozen hashes byte-for-byte. Facts support condition 3.
- Condition 4, cost: clean arm B depth-gate wall time `1.2 s` ≤ count-gate wall time `0.5 s` + `60 s` = `60.5 s`. The “no extra chats” part is by construction and not independently recomputable from this packet. Timing facts support condition 4.
- P_TZUTC is reported, not scored: count PASS, depth PASS, `rb_outputs_equal_frozen=1/4`, real effect “production outputs differ from frozen”.

6. **Blocking objections**  
   None. I found no defect in the harness, seed, predicate application, or evidence that should block a verdict from this packet. Non-blocking caveat: exact casing of the generated fixture TSV `DUPLICATE`/`LEGACY` fields cannot be verified from the packet, but the recomputed gate outcomes do not depend on resolving that caveat.
7. **Claim → evidence map**  
   | claim | evidence |  
   |---|---|  
   | Preflight gating PASS | PREFLIGHT section: all frozen/seed lines `OK`; `preflight gating result: PASS` |  
   | Clean B count PASS, depth PASS | `C41_RESULTS.md` arm B row; `arms/B/outputs/GATE_count.txt`; `arms/B/outputs/GATE_depth.txt` |  
   | Clean B 4/4 R-B outputs equal frozen | `C41_RESULTS.md` Arm B R-B outputs vs frozen; ARM MANIFESTS hashes; frozen reference hashes |  
   | Count gate catches JUDGE_P50 only | `C41_RESULTS.md` Counts; `arms/JUDGE_P50/outputs/GATE_count.txt`; `arms/JUDGE_P50/outputs/FIX_count.csv` F03/F10 |  
   | Depth gate catches P_DUPINT | `arms/P_DUPINT/outputs/GATE_depth.txt`; `arms/P_DUPINT/outputs/FIX_depth.csv` F07 |  
   | Depth gate catches P_DATESWAP | `arms/P_DATESWAP/outputs/GATE_depth.txt`; `arms/P_DATESWAP/outputs/FIX_depth.csv` F03/F05/F10/F14 |  
   | Depth gate catches STUB_F11 | `arms/STUB_F11/outputs/GATE_depth.txt` `stubs=F11`; `arms/STUB_F11/outputs/FIX_depth.csv` F11 stub TRUE |  
   | Depth gate catches JUDGE_P50 | `arms/JUDGE_P50/outputs/GATE_depth.txt`; `arms/JUDGE_P50/outputs/FIX_depth.csv` F03/F10 |  
   | P_TZUTC reported, not scored | `C41_RESULTS.md` INFO probe line; `arms/P_TZUTC/outputs/GATE_count.txt`; `arms/P_TZUTC/outputs/GATE_depth.txt`; `RB_portfolio_counts.csv` differs |  
   | Portfolio identities | raw `RB_portfolio_counts.csv` per arm; sums recomputed above |  
   | Cross-arm hash equalities | ARM MANIFESTS hashes listed for each arm |  
   | N1/OF-1 cannot cause C41 clean B mismatch | COORDINATOR NOTE N1 / OF-1; clean B R-B hashes equal frozen |  
   | Seed diffs match declared seeds | SEED DIFFS section; preflight seed hashes |

END C41 VALIDATOR REPORT
