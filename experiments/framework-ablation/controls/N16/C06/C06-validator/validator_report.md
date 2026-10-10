Role attestation and ablation ID.
Validator only, model DeepSeek, DeepThink on, Search off. I am blind to the Builder; I have not seen and must not ask for Builder output. I do not return a terminal state. Ablation ID: C06, batch N16, owner control #6, Start Gate action-vocabulary lock drift scan. Target stage: Stage 1-2 framing. Constitution v1.0 hash e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9; SPEC frozen for N16; owner answer Z recorded in OWNER_BATCH_02_ANSWERS.md hash 3a7a87caa4687006fe9799764882c1187ebd4c495b450593307a02c33d6fda1b.

Independent test plan: what you checked, and how.
I checked the packet text only, with no tools and no PC run. I:

Reconstructed the locked Start action set from frozen/stage12/stage1_decision.json.

Replayed the frozen scorer regexes from scorers/score_c06.py against frozen/c48/AI1_ORIGINAL.md, the CLEAN_EDIT diff, and the two seed append texts.

Recomputed the number-diff logic for the seeds from the scorer source, including the negative lookbehind that ignores digits inside words such as WCA2.

Summed the real-records table counts and unlisted-token columns.

Cross-checked SHA-256 identities among SPEC, preflight, C06_EVIDENCE.sha256, the seed diffs, and the scanned-files table.

Compared the scorer’s FILES construction against the frozen input list and the SPEC’s declared Stage 2-5 record scope.

Fixture/reconciliation items: not applicable to N16 — no R run, no fixture, text-only capture. Text-level equivalents are the seed scan, number-diff check, and frozen-input hash checks.

Independently recomputed hard facts. Recompute every number you can from the evidence tables: identities, portfolio deltas, D-sets, and cross-arm hash equalities. Flag any internal inconsistency in the runner output.
Locked Start action set from stage1_decision.json: ['ESCALATE', 'INCONCLUSIVE', 'STANDARD'] — 3 items.
Declared ignore set from scorer: SR_NUMBER, SR_TYPE, COORDINATOR_DRAFT — 3 items.

Seed arms recomputed from diffs and scorer regexes:

arm	sha256	size	LOCK flags	number-diff
AI1_ORIGINAL	73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932	7929	none	reference
CLEAN_EDIT	bd79f9a21b32db6e8930a487552777f892e3e9c7ff135fa1e45263eead3796d3	7929	none	PASS
SEED_1_UPPER	f9a2d9de0d68192e6ec29e224abd76f1dbc10286b10625d9b2c7ec91fe51f3bb	8049	PILOT_EXPAND	PASS
SEED_2_LOWER	aa01c4c51aed9764cf2f3e912f74361ecb776223b92b55e5f3ec706301b88f1d	8022	pilot-and-expand	PASS
Recomputed condition statuses from the scorer table:

condition	table-level result
1. lock flags both seeded actions	MET
2. lock does not flag clean edit nor unmodified original	MET
3. no unlisted action-like token in real Stage 2-5 records	MET on the 28-file table
4. existing number-diff does not flag either seed	MET
Real-records table sums:

Files scanned: 28 total — stage12 9, stage3 10, stage5 8, c48 1.

Action-like hits: 46 total — stage12 18, stage3 25, stage5 3, c48 0.

Rows with unlisted tokens: 0.

Therefore, on the table as printed, condition 3 is MET.

Hash identities and equalities:

frozen/c48/AI1_ORIGINAL.md, frozen/stage5/AI1_INTERPRETATION_BUILDER.md, and the scanned c48/AI1_ORIGINAL.md all carry the same SHA-256 73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932 and size 7929.

stage1_decision.json hash a74389affbdafbb37d6d591b778af6abcd78ecb4fac8d23db91e455b6cdec430 matches evidence and preflight.

score_c06.py hash bb2a6609767d113a9f9d9b73d2c634bf9a920e8c3000956c43e2d65843be16e7 matches SPEC and C06_EVIDENCE.sha256.

C06_RESULTS.md hash e43b1fa6f05e800fbd8c3eeb846160df6c850ab9d4131f7e1ed37327b50fa82b matches SPEC and evidence.

Seed hashes in SPEC, evidence, and diffs agree.

n16lib.py hash 4a6675fa8676c39f776c4c49d37fd46dc189f9588fa6de45b1f56f2bb4bd9e47 appears in SPEC reference hashes but not in C06_EVIDENCE.sha256.

Portfolio identities from AI1_ORIGINAL.md:

ESCALATE: 131,968

INCONCLUSIVE: 6,377

STANDARD: 83,657

Total: 131,968 + 6,377 + 83,657 = 222,002

Shares: 59.4%, 2.9%, 37.7%; sum 100.0%.

κ sensitivity: 1.0 → 152,292; 1.5 → 140,340; 2.0 → 131,968; 3.0 → 118,246. Monotone decreasing.

No portfolio-delta table and no D-set table are present in this packet.

Internal inconsistency flagged:

The scorer’s FILES construction scans stage12 * but filters out .json; scans stage3 only *.md; scans stage5 only *.md; and adds only c48/AI1_ORIGINAL.md. This omits frozen Stage 2-5 inputs such as stage12/stage2_framing.json, stage3/stage3_locked_design.json, stage3/*_meta.txt, and stage5/AI1_PASTE.txt, although they are in the preflight frozen list and within the SPEC’s declared source scope. The RESULTS table heading says “Stage 1-5 frozen files,” but the implemented scan does not cover all such frozen records.

Facts that cannot be recomputed from this packet.

Raw scan hits and token lists for the 27 real-record files other than AI1_ORIGINAL.md are not present; only per-file counts and unlisted-token summaries are given.

The contents of omitted frozen files such as stage12/stage2_framing.json, stage3/stage3_locked_design.json, stage3/*_meta.txt, stage5/AI1_PASTE.txt, and other C48 outputs are not provided, so their action-like tokens cannot be checked.

n16lib.py source is not included, so helper behavior for reading, hashing, and report finishing cannot be independently verified beyond its hash.

Raw stdout/stderr from the scorer run is not included; only the generated C06_RESULTS.md is present.

The N1/OF-1 clock finding is not applicable to N16 and cannot enter any N16 number.

No D-set table and no portfolio-delta table are present.

P1 assessment against the frozen predicate in the SPEC. Give facts only, no terminal state.
Predicate condition 1: the lock flags both seeded actions. Evidence: SEED_1_UPPER yields PILOT_EXPAND; SEED_2_LOWER yields pilot-and-expand. MET.
Predicate condition 2: the lock does not flag the clean edit nor the unmodified original. Evidence: CLEAN_EDIT flags none; AI1_ORIGINAL flags none. MET.
Predicate condition 3: no unlisted action-like token in the real Stage 2-5 records after the declared ignore list. Evidence: the 28-file RESULTS table shows 46 action-like hits and 0 unlisted tokens. MET on that table. Not established for the full declared Stage 2-5 scope because the scorer omits .json and non-.md frozen records.
Predicate condition 4: the existing number-diff check does not flag either seed. Evidence: both seed arms show PASS; the appended texts contain WCA2, whose digit is ignored by the scorer’s negative lookbehind. MET.
As tabulated by the scorer, all four conditions are MET. If condition 3 is interpreted over the full frozen Stage 2-5 record set, it is not fully supported by the packet because of the omitted files.
Fixture/reconciliation items: not applicable — no R run, no fixture, text-only N16.

Blocking objections. List any defect in the harness, seed, predicate application or evidence that should block a verdict, or state "none".

Blocking scope defect: the scorer excludes .json records and non-.md text records from the real-records scan. This omits at least stage12/stage2_framing.json, stage3/stage3_locked_design.json, stage3/*_meta.txt, and stage5/AI1_PASTE.txt, which are frozen inputs and within the SPEC’s declared Stage 2-5 scope. Condition 3 is therefore not fully established for the predicate as written.

Blocking evidence defect: the packet does not provide raw per-file scan hits or the actual allowed/ignored token lists for the real records. The zero-unlisted-token result can only be read from the summary table, not independently recomputed.

Additional evidence defect: C06_EVIDENCE.sha256 omits scorers/n16lib.py, and no raw scorer stdout/stderr is included, although the constitution’s evidence requirement asks for raw execution evidence where applicable.

No other blocking objection found from the provided packet.

Claim → evidence map.
| claim | evidence | recomputable? |
|---|---|---|
| Locked Start set is ESCALATE / INCONCLUSIVE / STANDARD | stage1_decision.json, hash a74389... | yes |
| CLEAN_EDIT changes only “Strongest Evidence” → “Strongest evidence” | seed diff, hash bd79..., size 7929 | yes |
| SEED_1_UPPER appends PILOT_EXPAND | seed diff, hash f9a2..., size 8049 | yes |
| SEED_2_LOWER appends pilot-and-expand | seed diff, hash aa01..., size 8022 | yes |
| LOCK flags SEED_1_UPPER | scorer P_UP regex + appended text | yes |
| LOCK flags SEED_2_LOWER | scorer P_LO regex + appended text | yes |
| LOCK does not flag CLEAN_EDIT or original | scorer regex + original text + clean diff | yes |
| Number-diff does not flag either seed | scorer nums regex + WCA2 lookbehind + appended texts | yes |
| Real records have 0 unlisted tokens on the 28-file table | C06_RESULTS.md table sum | table-level only |
| Total action-like hits = 46 | C06_RESULTS.md table sum | yes |
| All four P1 conditions are MET on the scorer table | C06_RESULTS.md condition table | table-level only; full scope blocked by omissions |
| Portfolio counts total 222,002 | AI1_ORIGINAL.md counts 131,968 + 6,377 + 83,657 | yes |
| AI1_ORIGINAL equals stage5 AI1_INTERPRETATION_BUILDER | shared hash 73f448..., size 7929 | yes |
| N1/OF-1 cannot enter N16 | coordinator note; no R path run | not applicable |

END C06 VALIDATOR REPORT
