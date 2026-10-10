1. **Role attestation and ablation ID**  
   I am the Validator only for ablation **C44** (Addendum 02, candidate #44, “Changed-files-only re-review”), N13 batch b6. I am blind to the Builder and have not seen or requested Builder output. This is an independent first pass. I have no attachments and no tools; I used only the packet text. Roles per SPEC: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Ablation ID: C44.
2. **Independent test plan: what I checked, and how**  
   I checked:

- Frozen hashes and byte counts in the SPEC, preflight, runner-side file list, REREVIEW_FREEZE.json, and post-chat scorer output.
- Static scope validity: full packet vs delta packet bytes, delta/full ratio, unchanged-input count, unchanged inputs listed by SHA-256, revised text verbatim, unchanged bodies absent.
- The 13 unchanged-input hashes in `UNCHANGED_HASH_LIST_CHECK.csv` against the DELTA packet inventory and the FULL packet inventory.
- The Stage 5 portfolio identities and arithmetic from `portfolio_summary.csv`, `independent_checks_critical_counts.csv`, `escalate_by_type_top25.csv`, `kappa_sensitivity.csv`, and `capacity_coverage_note.csv`.
- Cross-arm reply hashes, END lines, V-1..V-6 statuses, finding tables, BLOCKING/MATERIAL key sets, and condition 2/3 scorer results.
- Timing file `C44/C44-rereview-delta/TIMES.txt`: sent/reply_complete difference and whether condition 3 could use wall-clock or the declared packet-byte proxy.
- The logic of `c44_static.R` and `c44_score.R` as supplied in the packet.

3. **Independently recomputed hard facts**  
   **Static / scope**

- FULL packet bytes: 58,214. DELTA packet bytes: 18,691.
- DELTA/FULL = 18,691 / 58,214 = 0.3210739… ≈ 0.3211. Reduction = 67.8926…% ≈ 67.89%.
- Unchanged inputs: 13. Unchanged inputs listed by hash in DELTA: 13/13 TRUE.
- Revised text verbatim: TRUE. Unchanged bodies absent: TRUE.
- FULL packet SHA-256 `dab6e55f63eb67f6628ab05b3d5c3d52ab1301e804e8892ba22113735f6aeb96` matches preflight, SPEC, REREVIEW_FREEZE, and post-chat scorer output.
- DELTA packet SHA-256 `a3c359dc253fd91224b811df2e1f0f14cde5827418da7166e0c8f628256508bb` matches preflight, SPEC, REREVIEW_FREEZE, and post-chat scorer output.
- REVISED_SEED SHA-256 `c1ac310a7c77ab4228ac14ebb6c56e58b408e4e64cdf74fae8f1f68b9a720b63` matches preflight, SPEC, FULL packet inventory, and DELTA packet inventory for the revised interpretation.

**Unchanged-input hash check**  
The 13 rows in `UNCHANGED_HASH_LIST_CHECK.csv` are all marked `listed_by_hash_in_delta = TRUE`. The names match the 13 unchanged inputs in the FULL packet inventory:  
`STAGE5_EVIDENCE_PACKAGE.md`; `deeper/STAGE5_DEEPER_FINDINGS.md`; `deeper/capacity_coverage_note.csv`; `deeper/escalate_by_type_top25.csv`; `deeper/inconclusive_by_clause.csv`; `deeper/independent_checks_critical_counts.csv`; `deeper/kappa_sensitivity.csv`; `deeper/portfolio_summary.csv`; `reviews/AI2_DECISION_METHOD_CRITIC.md`; `reviews/AI3_CLAIM_EVIDENCE_AUDITOR.md`; `reviews/CROSS_REVIEW.md`; `reviews/INTERPRETATION_RECONCILIATION.md`; `AI1_INTERPRETATION (original, before revision)`.

**Stage 5 portfolio identities**

- Decision rows: 222,002.
- ESCALATE + INCONCLUSIVE + STANDARD = 131,968 + 6,377 + 83,657 = 222,002.
- ESCALATE share = 131,968 / 222,002 = 0.5944450950892334 = 59.4445% ≈ 59.4%.
- INCONCLUSIVE share = 6,377 / 222,002 = 0.028724966441743768 = 2.8725% ≈ 2.9%.
- STANDARD share = 83,657 / 222,002 = 0.3768299384690228 = 37.6830% ≈ 37.7%.
- Share sum = 1.0000000000000000.
- WCA2 share of ESCALATE = 64,922 / 131,968 = 0.4919525945683802 = 49.1953% ≈ 49.2%.
- SED share of ESCALATE = 17,254 / 131,968 = 0.1307438166828322 = 13.0744% ≈ 13.1%.
- SKA share of ESCALATE = 7,316 / 131,968 = 0.05543768186226964 = 5.5438% ≈ 5.5%.
- Top 3 cumulative WCA2+SED+SKA = 0.678134093113482 = 67.8134% ≈ 67.8%.
- PBD share = 3,937 / 131,968 = 0.0298329898157129 = 2.9833% ≈ 3.0%.
- PHF share = 3,371 / 131,968 = 0.0255440712900097 = 2.5544% ≈ 2.6%.

**κ sensitivity identities**

- κ=1: 152,292 + 6,377 + 63,333 = 222,002.
- κ=1.5: 140,340 + 6,377 + 75,285 = 222,002.
- κ=2: 131,968 + 6,377 + 83,657 = 222,002.
- κ=3: 118,246 + 6,377 + 97,379 = 222,002.
- ESCALATE sequence is monotone decreasing: 152,292 > 140,340 > 131,968 > 118,246.
- INCONCLUSIVE remains 6,377 across the grid.

**Capacity coverage arithmetic**

- 50 / 131,968 = 0.00037887972841901065.
- 200 / 131,968 = 0.0015155189136760426.
- 1000 / 131,968 = 0.0075775945683802136.
- 131,968 / 131,968 = 1.  
  All match `capacity_coverage_note.csv`.

**Cross-arm reply and finding facts**

- FULL reply SHA-256 `8b473adf6fd7cfe4ba6b363fcb52f009561b26f4ca44d6295126ad9a96c2aed2`, bytes 3,053, END line present. Matches REREVIEW_FREEZE and post-chat scorer.
- DELTA reply SHA-256 `d0635883ab82f4bf5d1f3fc94200715d5d4b66746aaf2023a99c64b43a9cebfb`, bytes 2,834, END line present. Matches REREVIEW_FREEZE and post-chat scorer.
- DELTA TIMES.txt SHA-256 `69f5275511e873b072369fc4beb09e84711ad8c21444c29bad02dc0979048590`. Sent 11:40:34, reply_complete 11:41:20; difference = 46 s = 0.7666… min ≈ 0.77 min. This is an upper bound, not an observed completion time.
- FULL V-1..V-6 = YES, YES, PARTIAL, YES, YES, YES.
- DELTA V-1..V-6 = YES, YES, NO, YES, YES, YES.
- FULL findings: 1 total, 1 BLOCKING/MATERIAL, key `V-3`.
- DELTA findings: 1 total, 1 BLOCKING/MATERIAL, key `V-3`.
- FULL BLOCKING/MATERIAL key set = {V-3}. DELTA BLOCKING/MATERIAL key set = {V-3}. Set difference = empty.
- FULL finding F-1: BLOCKING, V-3, quote `WCA2 alone supplies 64,922 of these (42.9% of ESCALATE)...`, correction to `49.2%`, arithmetic `64,922 / 131,968 = 0.491952595 = 49.1953%`.
- DELTA finding F1: MATERIAL, V-3, same quote, same correction, same arithmetic.
- Condition 2 fact: DELTA marks V-3 `NO` and raises a MATERIAL finding on V-3, so the changed-file seed is caught by the DELTA reply.
- Condition 3 fact: wall-clock for both arms is not available because FULL minutes = NA. The declared proxy is packet bytes. DELTA/FULL = 0.3211, so reduction = 67.89% ≥ 30%.
- Condition 1 fact: the only FULL BLOCKING/MATERIAL finding is also raised by DELTA. The scorer leaves condition 1 as `PENDING (judged)` because it is a finding-level judgment, not a purely mechanical key comparison.

**Internal inconsistency check**  
I found no inconsistency in the recomputable numbers. Minor observations that are not inconsistencies: FULL grades V-3 as PARTIAL while DELTA grades it NO; both catch the same defect. FULL severity is BLOCKING and DELTA severity is MATERIAL; the predicate compares raised findings, not identical severity labels. The scorer’s condition 1 remains pending by design. The timing record is an upper bound and is not used for condition 3 because the packet-byte proxy is declared and used.

4. **Facts that cannot be recomputed from this packet**

- Raw Stage 5 source rows, classifications, eligibility filters, unique-request grain, and T_freeze row-level timestamps.
- The actual TCD-IG clause-by-clause application and peer P75 computation.
- Fixture actuals beyond the stated 14/14 both paths.
- LINEAGE_ATTESTATION.md SHA values, beyond the statement that they exist on disk and were not inline.
- The content of `C48/AUDIT_FREEZE.json`; only its SHA-256 is given. I cannot independently rerun the scorer’s FULL-reply freeze check against that file’s contents from this packet alone.
- The content of `C44_ARM_MANIFESTS.txt`, `C44_EVIDENCE.sha256`, and other referenced files beyond the hashes and excerpts supplied.
- The real operator send/reply clock beyond the supplied TIMES.txt; the reply_complete time is explicitly an upper bound.
- Whether the DELTA reply was not changed after its freeze, beyond the REREVIEW_FREEZE hash record.
- The N1/OF-1 PC probe and R-A/R-B clock behavior beyond the coordinator note.

5. **P1 assessment against the frozen predicate in the SPEC**  
   Facts only, no terminal state.

- **Condition 0 (validity: static scope check passes):** STATIC exit=0, status=PASS. FULL packet 58,214 bytes; DELTA packet 18,691 bytes; delta/full=0.3211. Unchanged inputs=13; unchanged listed by hash=13; revised text verbatim=TRUE; unchanged bodies absent=TRUE. Mechanically MET by the runner output.
- **Condition 1 (no lost findings: every FULL BLOCKING/MATERIAL finding also raised by DELTA):** FULL BLOCKING/MATERIAL set = {V-3}; DELTA BLOCKING/MATERIAL set = {V-3}. The FULL F-1 BLOCKING finding and DELTA F1 MATERIAL finding quote the same revised-text sentence and give the same correction/arithmetic. The scorer leaves condition 1 as `PENDING (judged)`; the key-level aid says every FULL key present in DELTA = TRUE. Factually, the only FULL BLOCKING/MATERIAL finding is raised by DELTA.
- **Condition 2 (DELTA catches changed-file seed V-3):** DELTA V-3 = NO; DELTA has a MATERIAL finding with relates_to V-3; `seed_V3_caught = TRUE`. Mechanically MET.
- **Condition 3 (cost falls by ≥30%):** Both arms are not wall-clock logged; FULL minutes = NA. The declared proxy is packet bytes. DELTA/FULL = 0.3211; reduction = 67.89% ≥ 30%. Mechanically MET via the declared proxy.
- **Unchanged-file seed:** The SPEC discloses that the unchanged-file seed is not planted and is reported as not measured. The post-chat scorer repeats: “Unchanged-file seed: NOT PLANTED … Reported as not measured.”
- **N1/OF-1:** The coordinator note says N1 does not enter any C44 number; C44 reads only Stage 5 text and frozen Stage 5 evidence and reruns no R path.

6. **Blocking objections**  
   None. I found no defect in the harness, seed, predicate application, or evidence that should block a verdict from this packet. Non-blocking caveats: the FULL arm is a reused frozen b5 reply; the unchanged-file seed is not measured; the timing record is an upper bound and condition 3 uses the declared packet-byte proxy; the N1 note is excluded from the DELTA packet by disclosed SPEC deviation.
7. **Claim → evidence map**  
   | Claim | Evidence |  
   |---|---|  
   | C44 static scope check passed | `arms/STATIC/outputs/STATIC_CHECK.txt`; `C44_arms.csv`; `C44_RESULTS.md` |  
   | DELTA packet is 32.11% of FULL packet size | 18,691 / 58,214 = 0.3211; `STATIC_CHECK.txt`; `C44_arms.csv` |  
   | 13 unchanged inputs listed by SHA-256 | `UNCHANGED_HASH_LIST_CHECK.csv`; DELTA packet inventory |  
   | Revised text sent verbatim | `STATIC_CHECK.txt` `revised_text_verbatim=TRUE`; REVISED_SEED hash `c1ac310a…` matches inventory |  
   | Unchanged bodies absent | `STATIC_CHECK.txt` `unchanged_bodies_absent=TRUE`; `c44_static.R` |  
   | FULL reply frozen | `REREVIEW_FREEZE.json`; post-chat scorer table; SHA-256 `8b473adf…` |  
   | DELTA reply frozen | `REREVIEW_FREEZE.json`; post-chat scorer table; SHA-256 `d0635883…` |  
   | FULL catches V-3 | FULL reply V-3=PARTIAL; F-1 BLOCKING V-3 |  
   | DELTA catches V-3 | DELTA reply V-3=NO; F1 MATERIAL V-3 |  
   | No lost FULL BLOCKING/MATERIAL finding | FULL key set {V-3}; DELTA key set {V-3}; same quote/correction |  
   | Condition 2 mechanically met | Post-chat scorer `seed_V3_caught=TRUE`; DELTA V-3=NO and MATERIAL V-3 |  
   | Condition 3 mechanically met by proxy | Packet bytes 58,214 vs 18,691; reduction 67.89%; post-chat scorer `MET` |  
   | Stage 5 portfolio identities | `portfolio_summary.csv`; `independent_checks_critical_counts.csv`; `kappa_sensitivity.csv` |  
   | WCA2 share recomputation | 64,922 / 131,968 = 0.4919525945683802 ≈ 49.2% |  
   | Unchanged-file seed not measured | SPEC deviation 1; post-chat scorer note |  
   | N1 does not enter C44 numbers | Coordinator note N1; SPEC known open finding |  
   | Timing is upper-bound only | `C44/C44-rereview-delta/TIMES.txt`; 11:40:34 to 11:41:20 = 0.77 min upper bound |

END C44 VALIDATOR REPORT
