## 1. Role attestation and ablation ID

I am the Validator for ablation **C51**, first pass, acting as **DeepSeek**. I am blind to the Builder and have not seen or requested its output. I have no attachments or tools and rely only on the packet content. I do not return a terminal verdict. Ablation ID: **C51 (Addendum 02, candidate #51)**. Constitution version: **1.0**, SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`.

## 2. Independent test plan: what I checked, and how

I checked the packet by manual string comparison and arithmetic only:

- compared every quoted preflight frozen/seed hash line against the frozen reference and runner-side seed lists;
- recomputed all arm time sums from `k16_s`, `k4_s`, `full_s`, `baseline_s`, `variant_s`;
- recomputed portfolio count identities from stderr lines;
- recomputed subset row counts from `SUBSET_stdout.txt` and `make_subset.R`;
- applied the frozen smoke detection rule to exits, caps, and `ratio_k4_k16`;
- checked all arm/smoke exit records and fixture pass rows;
- compared cross-arm output SHA-256 values in `C51_ARM_MANIFESTS.txt` and the B-full-vs-frozen table;
- checked seeded diffs against stderr failure modes;
- checked whether any full-run manifest references a smoke path.

## 3. Independently recomputed hard facts

### 3.1 Preflight and hash identities

- All 17 frozen pack hash lines in `PREFLIGHT` match the `FROZEN REFERENCE HASHES` section line-for-line.
- All 9 runner-side seed hash lines in `PREFLIGHT` match the `runner/SEEDS_b4.sha256` / runner-side file list line-for-line.
- `preflight gating result: PASS`.
- MySQL preflight counts: `src_open_candidates 245193`, `src_peer_stats 104`; expected `245193 / 104`; match.

### 3.2 Time recomputation

| arm | path | recomputed baseline | recomputed variant | check |
| --- | --- | --- | --- | --- |
| B | RA | 11.0 | 2.4+4.4+11.0 = 17.8 | matches |
| B | RB | 25.0 | 3.1+7.8+25.0 = 35.9 | matches |
| SM_QUADLOOP | RB | 1800.4+25.0 = 1825.4 | 19.4+357.7+3.1+7.8+25.0 = 413.0 | matches |
| SM_MIDCRASH | RB | 18.5+25.0 = 43.5 | 2.4+3.1+7.8+25.0 = 38.3 | matches |
| SM_OUTCRASH | RB | 25.6+25.0 = 50.6 | 3.4+3.1+7.8+25.0 = 39.3 | matches |
| SM_RARECRASH | RB | 5.8+25.0 = 30.8 | 2.9+7.9+5.8+3.1+7.8+25.0 = 52.5 | matches |

Totals:

- baseline sum = 11.0 + 25.0 + 1825.4 + 43.5 + 50.6 + 30.8 = **1986.3**
- variant sum = 17.8 + 35.9 + 413.0 + 38.3 + 39.3 + 52.5 = **596.8**
- variant minus baseline = **−1389.5 s** lower.

Minor note: the runner records SM_QUADLOOP full timeout as `1800.4` despite the spec saying the 1800 s capped time is used. If exactly 1800.0 were used, baseline total would be 1985.9 and variant still lower by 1389.1 s. Direction unchanged.

### 3.3 Portfolio identities and deltas

- Full R-A: `open_n=245193`; `RA_classifications.csv n=222002`; excluded = 245193 − 222002 = **23191**.
- Full R-B: `decision=222002`; ESCALATE 131968 + INCONCLUSIVE 6377 + STANDARD 83657 = **222002**. This equals full R-A classification `n=222002`.
- k16: `open_n=15325`; `RA_classifications n=13891`; `decision=13891`; 8185 + 394 + 5312 = **13891**; excluded = 15325 − 13891 = **1434**.
- k4: `open_n=61299`; `RA_classifications n=55482`; `decision=55482`; 32905 + 1610 + 20967 = **55482**; excluded = 61299 − 55482 = **5817**.
- k4/k16 open rows: 61299 / 15325 ≈ 4.0; decision counts: 55482 / 13891 ≈ 3.994.

### 3.4 D-sets / smoke detection sets

From the frozen rule:

- detected at k16: `{SM_MIDCRASH, SM_OUTCRASH}` — both exit 1 at k16.
- detected at k4: `{SM_QUADLOOP}` — k16 exit 0 and under cap, k4 exit 0 and under cap, but `357.7 / 19.4 = 18.44 > 6`.
- not detected by smoke: `{SM_RARECRASH}` — k16/k4 exit 0 and `7.9 / 2.9 = 2.72 ≤ 6`.
- clean B: R-A and R-B smoke k16/k4 exit 0; ratios `4.4/2.4 = 1.83` and `7.8/3.1 = 2.52`, both ≤ 6; no smoke flag.
- Full exits: B RA/RB = 0; SM_QUADLOOP = TIMEOUT; SM_MIDCRASH = 1; SM_OUTCRASH = 1; SM_RARECRASH = 1.

### 3.5 Cross-arm hash equalities

- `RA_fixture_results.csv`: hash `33696cd1...` in B full, B_RA_k16, B_RA_k4.
- `RB_fixture_results.csv`: hash `0d72245c...` across B full, all seeded full arms, and all smoke roots listed.
- k16 RB classifications/portfolio: `B_RB_k16`, `SM_QUADLOOP_RB_k16`, `SM_OUTCRASH_RB_k16`, `SM_RARECRASH_RB_k16` share `RB_classifications.csv` hash `52746de0...` and `RB_portfolio_counts.csv` hash `0f952192...`.
- k16 RB kappa grid: `B_RB_k16`, `SM_QUADLOOP_RB_k16`, `SM_RARECRASH_RB_k16` share hash `53201f75...`; `SM_OUTCRASH_RB_k16` has no kappa-grid output.
- k4 RB classifications/portfolio: `B_RB_k4`, `SM_QUADLOOP_RB_k4`, `SM_OUTCRASH_RB_k4`, `SM_RARECRASH_RB_k4` share `RB_classifications.csv` hash `52b3224d...` and `RB_portfolio_counts.csv` hash `13cfb1e1...`.
- k4 RB kappa grid: `B_RB_k4`, `SM_QUADLOOP_RB_k4`, `SM_RARECRASH_RB_k4` share hash `9d92bc77...`; `SM_OUTCRASH_RB_k4` has no kappa-grid output.
- B full 7 key outputs match frozen hashes exactly: RA classifications `c099e092...`, RB classifications `a0e42b86...`, RA fixture results `33696cd1...`, RB fixture results `0d72245c...`, RA portfolio counts `b5888db2...`, RB portfolio counts `eb677bc1...`, RB kappa grid counts `7a18fcb1...`.
- SM_OUTCRASH full wrote RB classifications `a0e42b86...` and RB portfolio counts `eb677bc1...` before failing at the kappa grid; no RB kappa grid output.
- SM_MIDCRASH full, SM_QUADLOOP full, and SM_RARECRASH full have only `RB_fixture_results.csv` plus exit/stderr, not the later outputs.

### 3.6 Internal inconsistencies flagged

- Minor rounding/floating point: `C51_arms.csv` has SM_QUADLOOP `variant_s=412.99999999999994`; `C51_RESULTS.md` reports `413.0`. This is rounding, not a factual conflict.
- Minor cap overshoot: SM_QUADLOOP full timeout is `1800.4` while the spec says the 1800 s capped time is used. This slightly increases the baseline, favoring the variant; it does not change the lower-time direction.
- No other arithmetic, hash, exit-record, or identity inconsistency was found in the recomputable packet. The known OF-1 / N1 clean R-A vs R-B 1.000 h difference is disclosed and does not enter C51’s B-vs-frozen comparison.

## 4. Facts that cannot be recomputed from this packet

- Actual byte-level SHA-256 of `C51_ARM_MANIFESTS.txt`, `C51_arms.csv`, `C51_RESULTS.md`, `SPEC_FREEZE_b4.sha256`, the constitution file, the baseline framework files, and the large CSV outputs: only quoted hashes are available.
- Independent MySQL counts, R version, package versions, machine RAM/CPU, and read-only PC state.
- Exact R runtime behavior beyond the quoted diffs, stderr, exit records, and hashes.
- `src_extract_lineage.csv` is shown in manifests with hash `eaa9a76d...` and identical across roots, but it is not in the quoted preflight/frozen reference hash list, so its frozen preflight immutability cannot be independently confirmed from this packet.
- The baseline framework hashes are listed, but the quoted preflight does not re-hash them.
- The batch-end evaluator comparison is not in this packet; only the coordinator’s interim byte-copy evaluation is provided.
- Builder output is unavailable by design.

## 5. P1 assessment against the frozen predicate in the SPEC

Facts only, no terminal state:

| P1 condition | recomputed facts |
| --- | --- |
| 1. smoke detects SM_QUADLOOP, SM_MIDCRASH and SM_OUTCRASH, each before its full run | SM_MIDCRASH detected at k16 (exit 1); SM_OUTCRASH detected at k16 (exit 1); SM_QUADLOOP detected at k4 because `357.7/19.4 = 18.44 > 6`. All three detected before full run. |
| 2. no false smoke flag on clean arm B (R-A and R-B) | B RA k16/k4 exit 0, ratio 1.83; B RB k16/k4 exit 0, ratio 2.52; `smoke_detects=none` for both. |
| 3. summed time over all units lower under variant | Recomputed baseline total = 1986.3 s; variant total = 596.8 s; variant lower by 1389.5 s. Disclosed limitation: SM_QUADLOOP baseline is capped at 1800.4 s, so saving is a lower bound. |
| 4. B full-run 7 key outputs equal frozen hashes and no full-run manifest references a smoke path | All 7 B-full output hashes equal frozen hashes. `arms/B` manifest lines do not reference `smoke/`. |

Additional regression facts: B full exit 0 for R-A and R-B; RA/RB fixture results pass 14/14; all arm and smoke exit records are present; no smoke path appears in the `arms/B` manifest sections.

## 6. Blocking objections

None found in the recomputable evidence. Non-blocking caveats are noted in §3.6 and §4: minor SM_QUADLOOP cap/time rounding, coordinator interim evaluation on a byte-copy, `src_extract_lineage.csv` not in the quoted frozen preflight list, and baseline framework hashes not re-hashed in the quoted preflight.

## 7. Claim → evidence map

| claim | evidence |
| --- | --- |
| Preflight gating passed and frozen/seed hashes match | `PREFLIGHT` lines; frozen reference list; runner-side seed list; `preflight gating result: PASS`. |
| B full-run 7 key outputs equal frozen | `C51_RESULTS.md` B-full-vs-frozen table; `C51_ARM_MANIFESTS.txt` `arms/B out` hashes. |
| Smoke detects the three required seeded arms | `RUN LOG`; `C51_arms.csv`; stderr for SM_MIDCRASH, SM_OUTCRASH, SM_QUADLOOP; ratio `357.7/19.4=18.44`. |
| No false smoke flag on clean B | `RUN LOG`; `C51_arms.csv`; B RA/RB k16/k4 exits 0; ratios 1.83 and 2.52. |
| Variant total time lower | `C51_arms.csv` `baseline_s` and `variant_s`; recomputed totals 1986.3 vs 596.8. |
| No full-run receipt references smoke path | `C51_ARM_MANIFESTS.txt` `arms/B in/out` lines; smoke roots are separate prefixes. |
| Fixtures pass | Raw `RA_fixture_results.csv` and `RB_fixture_results.csv`; 14 rows each, all `pass=TRUE`; hash `33696cd1...` and `0d72245c...`. |
| Portfolio identities hold | stderr lines for B full, B_RB_k16, B_RB_k4; sums recomputed to 222002, 13891, 55482. |
| OF-1 does not affect C51 B-vs-frozen | `COORDINATOR NOTE N1 / OF-1`; SPEC known open finding; C51 compares B to frozen key outputs, not R-A vs R-B. |

END C51 VALIDATOR REPORT
