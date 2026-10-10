1. Role attestation and ablation ID.  
   I am DeepSeek, acting as Validator only, with DeepThink on. I am blind to the Builder; I have not seen and will not ask for its output. I have no attachments or tools and did not rerun code. Ablation ID: C14. Batch: N15 batch 2 of 3. Role assignment per SPEC: Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Constitution version: 1.0.
2. Independent test plan: what you checked, and how.  
   I checked the frozen SPEC, Constitution, coordinator note N1, preflight hashes, run log, C14_RESULTS.md, C14_arms.csv, fixture result rows, arm manifests, seed diffs, and evidence hashes. I recomputed arithmetic from the source profile and the arm tables, reconstructed B’s decision-set size, reconstructed the harm set H and caught-without-control set D_abl from the frozen definitions, checked cross-arm SHA-256 equalities in the manifests, and checked exit/fixture/recon summaries against the raw arm rows. I did not independently re-execute R or MySQL and did not inspect row-level classification files.
3. Independently recomputed hard facts.

- Preflight/frozen hashes: source, frozen code, and seed hashes in the preflight match the SPEC and the arm manifests. No hash mismatch is visible in the packet.
- Source row identities: total rows 245,193. DUPLICATE false 222,176 + true 23,017 = 245,193. LEGACY false 245,014 + true 179 = 245,193. Peer_n bins: 6,443 + 27 + 35 + 14 + 19 + 238,655 = 245,193.
- B decision-set identity: B recon has n_ra = n_rb = n_inner = 222,002. Source 245,193 − 222,002 = 23,191 excluded. DUPLICATE+LEGACY union = 23,017 + 179 − overlap. Solving from B exclusion gives overlap = 5. Check: 23,017 + 179 − 5 = 23,191.
- Seed deltas consistent with overlap 5: SEM_DUPKEEP adds 23,017 − 5 = 23,012 per path; SEM_LEGACYIN adds 179 − 5 = 174 per path. SEM_NOPEER removes 6,315 per path; source no-peer rows 6,443, so 128 no-peer rows are already excluded by duplicate/legacy in B.
- Arm B repro vs frozen pack: R-A vs frozen RA all 0 for only_x, only_truth, label_diff, dormant_diff, open_age_diff; R-B vs frozen RB all 0. B recon key set/classification: 0/0/0. B full-field recon: dormant_h mismatch 1, open_age_h mismatch 2, matching N1.
- Harm set H recomputed from arm rows: {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_NOPEER_CM, SEM_LEGACYIN_CM}.
- Caught-without-control D_abl recomputed from frozen definition: {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_LEGACYIN_CM}.
- H \ D_abl = {SEM_NOPEER_CM}.
- Arms with no locked-field change = {SEM_OPENEXACT_CM}.
- Per-arm recomputation:

  - SEM_DUPKEEP_RB: RB adds 23,012 keys; recon only_rb=23,012; F07 fails; harm true; caught true.
  - SEM_DUPKEEP_CM: both paths add 23,012 each; total locked-field changes 46,024; recon 0/0/0; F07 fails on both; harm true; caught true by fixture failure.
  - SEM_NOPEER_RB: RB loses 6,315 keys; recon only_ra=6,315; fixtures 14/14 both; harm true; caught true by recon key mismatch.
  - SEM_NOPEER_CM: both paths lose 6,315 each; total locked-field changes 12,630; recon 0/0/0; fixtures 14/14 both; harm true; caught false.
  - SEM_LEGACYIN_CM: both paths add 174 each; total locked-field changes 348; recon 0/0/0; F08 fails on both; harm true; caught true by fixture failure.
  - SEM_OPENEXACT_CM: 0 locked-field changes; recon 0/0/0; fixtures 14/14 both; harm false; caught false.
- Cross-arm hash equalities from manifests: B RA outputs equal SEM_OPENEXACT_CM RA outputs for RA_classifications, RA_fixture_results, RA_portfolio_counts. B RB outputs equal SEM_OPENEXACT_CM RB outputs for RB_classifications, RB_fixture_results, RB_kappa_grid_counts, RB_portfolio_counts. SEM_DUPKEEP_RB RB outputs equal SEM_DUPKEEP_CM RB outputs for RB_classifications, RB_fixture_results, RB_kappa_grid_counts, RB_portfolio_counts. SEM_NOPEER_RB RB outputs equal SEM_NOPEER_CM RB outputs for RB_classifications, RB_fixture_results, RB_kappa_grid_counts, RB_portfolio_counts. SEM_NOPEER_CM RB_fixture_results equals B RB_fixture_results. These equalities support the table’s no-change / shared-change labels.
- Internal inconsistency flags: I found none in the runner output. The H2 wording “B recon is 0/0/0” alongside “full-field recon mismatches dormant_h 1, open_age_h 2” is consistent with the frozen recon definition and N1. The H5 caught set for SEM_DUPKEEP_CM and SEM_LEGACYIN_CM is caught by fixture failure, not recon mismatch, which matches the frozen D_abl definition. All six seeded arms have recorded exits. Fixture rows match the summary fixture columns.

4. Facts that cannot be recomputed from this packet.

- Actual row-level classifications, labels, and key lists behind the summary counts.
- Actual portfolio count values; only file hashes and byte sizes are present.
- Full fixture input definitions and expecteds beyond the provided fixture result rows.
- Whether N1’s 1.000 h mismatches are caused by a daylight-saving ambiguous-hour read; this is explicitly unconfirmed.
- Whether the Builder’s independently recomputed hard numbers agree; I am blind to the Builder.
- Whether the MySQL read-only count is true beyond the preflight statement.
- Exact stdout/stderr content; only hashes and sizes are present.
- Whether any unlisted file changed; manifests are authoritative in the packet but I cannot rehash the actual files.

5. P1 assessment against the frozen predicate in the SPEC.  
   Frozen P1: satisfied iff H ⊆ D_abl; failed iff H \ D_abl is non-empty. Recomputed H = {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_NOPEER_CM, SEM_LEGACYIN_CM}. Recomputed D_abl = {SEM_DUPKEEP_RB, SEM_DUPKEEP_CM, SEM_NOPEER_RB, SEM_LEGACYIN_CM}. H \ D_abl = {SEM_NOPEER_CM}. SEM_NOPEER_CM changes locked fields: both paths lose 6,315 keys vs B, total 12,630 locked-field changes; harm true; caught_without_control false because recon key/label is 0/0/0 and fixtures are 14/14 on both paths. Therefore the frozen P1 failed condition is met because H \ D_abl is non-empty. Arms with no locked-field change: SEM_OPENEXACT_CM; per SPEC they do not count for or against P1. No terminal state is returned.
6. Blocking objections.  
   None. Known open finding N1 is disclosed, frozen, and excluded by the frozen recon definition. All seeded runs have recorded exits. The visible hashes match. I found no hard mechanical disagreement, missing required evidence, or predicate-application defect in the packet. The SEM_NOPEER_CM miss is a P1 result under the frozen predicate, not a harness defect supported as blocking by this evidence.
7. Claim → evidence map.

- Ablation ID and roles: SPEC header and role line; Constitution §1.
- Frozen hashes and source/code versions: SPEC, preflight, arm manifests.
- Source row counts and profile: source profile; preflight MySQL counts; B recon identity.
- B reproduces frozen pack: C14_RESULTS “Arm B repro vs frozen pack” table; H1/H2.
- B recon 0/0/0 and full-field 1/2: C14_RESULTS arm B recon table; N1.
- All seeded runs recorded: run log; C14_arms.csv exits; H3.
- H set: C14_RESULTS H4; C14_arms.csv; recomputed per-arm locked-field changes.
- D_abl set: C14_RESULTS H5; C14_arms.csv; recomputed crash/recon/fixture conditions.
- H \ D_abl: H4 and H5; SEM_NOPEER_CM row in C14_arms.csv.
- No locked-field change: H7; SEM_OPENEXACT_CM row; manifest hash equalities vs B.
- Fixture failures F07/F08: raw fixture result rows for SEM_DUPKEEP_* and SEM_LEGACYIN_CM.
- Cross-arm hash equalities: arm manifests SHA-256 entries.
- P1 predicate: SPEC P1; recomputed H and D_abl.
- N1: coordinator note N1; B recon table; H2.

END C14 VALIDATOR REPORT
