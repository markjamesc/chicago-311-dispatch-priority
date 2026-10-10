# C49R: clean redo of C49 "Individual-file evidence delivery" (FROZEN)
**Ablation ID:** C49R (redo of N13 C49, owner approval 2026-10-09 07:06 CT)  **Batch:** N17  **Roles:** Builder=ChatGPT, Validator=DeepSeek, Adjudicator=Grok. Extra chats: 3 blind reviewer chats (DS_ZIP, DS_FILES, GPT_FILES), no Grok arm.
**Target stage:** Stage 5 first-pass evidence delivery. **Capture mode:** text-only (owner-approved 2026-10-09 01:52 CT), `TEXTONLY_PROCEDURE.md` as in N16.
**Why redo:** N13 C49 ended HALT: the DS_FILES arm was rerun after freeze (checksum file renamed SHA256SUMS -> SHA256SUMS.txt because DeepSeek refused an extensionless file; packet and ARMS.tsv changed post-freeze). In C49R the checksum file is `SHA256SUMS.txt` in every arm (zip included) from the start. Nothing in the delivery, packets or scorer may change after this freeze.
**Verdict convention:** KEEP = deliver evidence as individual files plus checksum file with the inventory requirement. REVERT = not shown to help. HALT as in constitution §9.
**Constitution** `CONSTITUTION_v1.md` SHA-256 `e6c3b3489ad7315d8566dcd7e01c28cc311049722a306dea90c3dab6404fdae9`. Baseline frameworks (frozen pre-hardening):
70a14831aa41452651443b4561979aedd07cc08a43ace38d07d9c5c624600c4c  docs/three-ai-measurement-design-framework.md
24aec49c3cd1b12e4fafa85e7333874100fae9348f0d211c1df09eac893cdb2e  docs/three-ai-validation-and-analysis-framework.md

## Exact change tested (same as N13 C49 except the checksum filename and END marker)
Evidence identical in all arms: the 9 frozen Chicago Stage 5 files used by the C48 audits (`STAGE5_EVIDENCE_PACKAGE.md`, `STAGE5_DEEPER_FINDINGS.md`, 6 deeper CSVs, `AI1_INTERPRETATION.md`; byte-identical to N13) plus `SHA256SUMS.txt`. Arms: **DS_ZIP** (DeepSeek, DeepThink ON, Search OFF; ONE attachment `evidence_pkg.zip` holding the same 10 files), **DS_FILES** (DeepSeek, DeepThink ON, Search OFF; 10 individual files), **GPT_FILES** (ChatGPT, highest reasoning; 10 individual files). Each reply: part 1 FILE INVENTORY (FILE/SHA256/OPENED/LINES/FIRST/LAST per file), part 2 hard facts Q1..Q5 (131968, 64922, 49.2, 25, 118246: reported, not scored), part 3 findings; last line `END C49R FIRST PASS`.
Access proof (mechanical): a file counts as accessed when the reply's FIRST and LAST lines equal the file's first and last non-empty lines (whitespace-normalized). Usable first pass = END line + all 9 files proven + all 5 facts answered. Time to usable = reply_complete - sent from `TIMES.txt` (operator-logged at chat time, America/Chicago, two lines `sent=YYYY-mm-dd HH:MM:SS`, `reply_complete=YYYY-mm-dd HH:MM:SS`); unusable = infinite.
## Operational benefit predicate P1
KEEP side when all hold: 0. delivery sets pass `c49_check` (zip holds byte-identical copies; checksum file matches); 1. DS_FILES and GPT_FILES each prove access to all 9 files; 2. in both, every evidence file is listed with the SHA-256 from SHA256SUMS.txt; 3. DS_FILES time <= DS_ZIP time + 2 min (DS_ZIP unusable = met). REVERT if 1, 2 or 3 fails. HALT if 0 fails, a reply or TIMES.txt is missing or lacks its END line, any frozen file differs from this freeze, or Builder and Validator disagree on a hard number. DS_ZIP access is the baseline observation and does not decide P1.
## No-rerun rule (the N13 defect)
No arm may be rerun, no file renamed, no packet or ARMS.tsv edited after this freeze. Operator checks before sending: DS_FILES shows 10 evidence attachment chips (11 if the packet is also attached as a file); DS_ZIP shows the one zip chip. If an upload fails or is refused, the arm is recorded as it happened (e.g. OPENED: NO) and is NOT repaired; a model refusing a file type is a finding. A chat interrupted before END may be retried once in a new chat with the identical frozen packet and attachments (retry disclosed in TIMES.txt); no other change is allowed.
## Known open finding N1 / OF-1
Disclosed in each packet as in N13 (repeated fall-back hour; owner ruling 53A); frozen pack not changed.
## Scoring harness
Scorers: `scorer/c49_check.R` and `scorer/c49_score.R` (N13 scripts; only changes: checksum filename, paths to the C49R layout, `C49R-<arm>` folders). They are the authoritative logic. No Rscript exists on the box and the PC may be offline, so the box may run an equivalent Python port; any port, its parity proof against the N13 R outputs, and the pipeline are recorded in post-freeze addendum notes (`C49R_HARNESS_NOTES.md`), never by editing this spec. Disclosed limits: n = 1 per arm and model; ChatGPT zip handling untested; Grok untested.
## FROZEN FILES (SHA-256; the freeze file `C49R_SPEC_FREEZE.sha256` repeats them with this spec's own hash)
- `delivery/FILES/AI1_INTERPRETATION.md` SHA-256 `73f448d4526c4779886fb3034cd04f5296fcf5db9edd02ab9362f763ad3d7932` (7929 bytes)
- `delivery/FILES/SHA256SUMS.txt` SHA-256 `1f2aad88d78e4c4a582e39d0745af8d710d1fcdedb69a35982e245b213ddec75` (833 bytes)
- `delivery/FILES/STAGE5_DEEPER_FINDINGS.md` SHA-256 `49ab09c26c86e4a0abcd2031745e0c4bc786dffc8fe6cf4066e9c3afa93c70e6` (2007 bytes)
- `delivery/FILES/STAGE5_EVIDENCE_PACKAGE.md` SHA-256 `c8e191d861a71097b4bc2ebaaab2626633617350e39f130e1c7d148a3379bfb7` (4051 bytes)
- `delivery/FILES/capacity_coverage_note.csv` SHA-256 `4bf4523047a87a3c95f5a869dc5ebd2e0c2c4e36535dc2d438afd9c6e1711609` (644 bytes)
- `delivery/FILES/escalate_by_type_top25.csv` SHA-256 `6d3bd20808cd49c4e8313a12e1c8d481a159a0d47a08b654f774c2fd6597c176` (1264 bytes)
- `delivery/FILES/inconclusive_by_clause.csv` SHA-256 `f29e33c70c4182b86643f262c6199b247e9193fc8e2d5440ea61330e853dd32d` (58 bytes)
- `delivery/FILES/independent_checks_critical_counts.csv` SHA-256 `4aca9c33be586932a38a7e28a00523fb09e1bde4a72639f634a08c8d263fd146` (190 bytes)
- `delivery/FILES/kappa_sensitivity.csv` SHA-256 `7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a` (164 bytes)
- `delivery/FILES/portfolio_summary.csv` SHA-256 `b58fc40fc46ec1532b687d2597bc285f1d684a285a9443a02c4daa03582f3167` (183 bytes)
- `delivery/ZIP/evidence_pkg.zip` SHA-256 `dffa057583a1b75bef9eadb961f9fb900a96a910aba9309cabb07d8f56648435` (9600 bytes)
- `packets/C49R_R_DS_FILES.txt` SHA-256 `685f9fdd864205f57bb40b4476c619625dcee4de5328931ed5d19c693aaeab86` (2817 bytes)
- `packets/C49R_R_DS_ZIP.txt` SHA-256 `b93a174e38bf8de8fe964981c1370dc5c9d71019cc867a1c52c381c49ae8a349` (2852 bytes)
- `packets/C49R_R_GPT_FILES.txt` SHA-256 `07ef2b4e759313ff37695378f2b94c541eef00bbb009de3b41f0f421c3fa7683` (2830 bytes)
- `scorer/ARMS.tsv` SHA-256 `1d50bf212e415318069c29cd4dde311635f2d8fc39bd6340a2db40489d74d46b` (280 bytes)
- `scorer/DELIVCHK` SHA-256 `0d355b20e2fcd5c9919546c26d92506826769042a463ed05693fc7c36f110b30` (189 bytes)
- `scorer/KNOWN_ANSWERS.csv` SHA-256 `13d57bb9d40392186ba8f423482c20d9121b56796c5b35c61494b3ee1b4303c2` (248 bytes)
- `scorer/c49_check.R` SHA-256 `5f52e7d0629b97666920b627ca896983a74f67bd5cc6f5112581b867fa2dd410` (1955 bytes)
- `scorer/c49_score.R` SHA-256 `64b10c401930dda3fb2ffb8e4ebe52e75b15f516eae96c58601c4aecb5fd114e` (7258 bytes)
