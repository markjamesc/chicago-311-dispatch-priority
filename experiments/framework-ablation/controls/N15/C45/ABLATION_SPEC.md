# C45 — Ablation specification (FROZEN)

**Ablation ID:** C45 (Addendum 02, candidate #45 "Parallel R-A/R-B runs")
**Batch:** N15 batch 3 of 3 (controls C36, C35, C32, C15, C45)
**Constitution version:** 1.0
**Baseline frameworks (frozen pre-hardening, same as A01–A08):**
- `three-ai-measurement-design-framework.md` SHA-256 `70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c`
- `three-ai-validation-and-analysis-framework.md` SHA-256 `24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e`
**Frozen data pack:** Chicago 311 Dataset 2, `stage3-v1-tcd-ig`, `fixtures-v1-tcd-ig`, T_freeze 2026-09-12 23:59:59 America/Chicago, κ=2.
`src_open_candidates.csv` SHA-256 `ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9` (245,193 rows); `src_peer_stats.csv` SHA-256 `cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58`.
**Roles:** Builder=ChatGPT · Validator=DeepSeek · Adjudicator=Grok (owner instruction 2026-10-03 04:26 CT)
**Target stage:** Stage 4 execution scheduling (cut/relax candidate)
**Frozen at CT:** 2026-10-03, before the runner executed

## Control under test
R-A and R-B runs are serialized at the coordinator's discretion. In PricePoint, R-A r2 was queued behind R-B r10 for "memory".

## Exact change being tested (ablation)
Both paths' preflight, fixtures and pipeline (`run_RA.R all`, `run_RB.R all`) are launched concurrently on the same arm copy of the frozen package. A declared memory check runs first.
Under the Addendum 02 verdict convention for cut/relax candidates, KEEP = the control can be relaxed as described (concurrent runs allowed).

## Known open finding N1 (disclosed before execution; not changed)
In the frozen pack, clean R-A and R-B differ by exactly 1.000 h on three ESCALATE rows: SR22-01936870 (dormant_h) and SR25-02017553, SR25-02017556 (open_age_h). Their labels agree. The likely cause is a daylight-saving ambiguous-hour clock read that differs between the paths; this is not confirmed. A full-field R-A vs R-B recon therefore shows dormant_h 1 and open_age_h 2 on the frozen pack itself. Every "B recon 0/0/0" rule in this batch uses the frozen recon definition: key set (only-RA, only-RB) and classification disagreements. It does not include dormant_h or open_age_h. Stage-5-only controls (C36, C35, C32, C15) do not rerun R-A or R-B; they start from the frozen validated state.

## Arms (runner v3, `seeds/C45/PARALLEL`; every arm = frozen code + frozen source, both paths, full run with fixtures)
- **B**: serial (R-A, then R-B). This is the serial reference, and it gives the serial peak memory used in the memory check.
- **PAR_1**: R-A and R-B launched concurrently (PAR).
- **SER_2**: R-A then R-B (SER).
- **PAR_2**: R-A and R-B launched concurrently (PAR).
- **SER_3**: R-A then R-B (SER).
- **PAR_3**: R-A and R-B launched concurrently (PAR).
Arms are interleaved (PAR, SER, PAR, SER, PAR) to spread machine drift. The ARMS file is `runner/seeds/C45/ARMS.tsv`, SHA-256 `699a7f34ccd8e1102c8dfa5e4bfa50cd82d113c6bc4ed19bff6cefd16b37fc53`.

**Declared memory check (before the first concurrent arm):**
- Rule: free physical memory ≥ 2 × the serial peak working set + 2,048 MB.
- If it fails, no concurrent arm runs and the result is HALT (evidence incomplete).
- Peak memory is the maximum summed working set of processes named Rscript/Rterm/R, sampled every 0.5 s. That covers every R process on the PC, and no other R job runs during this batch.

**Measured:**
- Wall-clock from first launch to last exit.
- Each path's exit code and seconds.
- Peak memory.
- SHA-256 of the 7 key outputs: RA/RB classifications, RA/RB fixture results, RA/RB portfolio counts, RB kappa grid. These are compared with the serial arms and with the frozen outputs.

## Operational benefit predicate P1 (Addendum 02 #45 wording, made mechanical before execution)
- **P1 satisfied (KEEP side):** both of these hold:
  - every arm exits 0 on both paths;
  - every concurrent arm's 7 key outputs are byte-identical to the serial arms' and the frozen outputs, and the median concurrent wall-clock is below the median serial wall-clock.
- **REVERT side:** any output differs, or any run fails from contention.
- **HALT:** the memory check fails, or an exit record is missing.

The concurrent/serial wall-clock ratio is reported. No other threshold is applied.

## Allowed source/data scope
Frozen PC pack, read only and copied into the work folder. MySQL is used only for a read-only COUNT preflight.

## Regression / HALT rules
- HALT if arm B does not reproduce the frozen RA/RB classifications byte-for-byte, if arm B fixtures are not 14/14 on both paths, or if the memory check fails.
- HALT if Builder and Validator disagree on a hard number in the RESULTS file.

## Builder task
Make an independent first pass: role attestation, conceptual diff, a hard-facts table recomputed from the evidence, the P1 assessment, risks, and a claim→evidence map. No KEEP/REVERT/HALT.

## Validator task
Independently recompute the same hard facts. Blind to the Builder. List blocking objections. No KEEP/REVERT/HALT.
