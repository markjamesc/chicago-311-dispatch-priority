# FLOW — N20 A02R (2026-10-10). Builder ChatGPT -> Validator DeepSeek -> Adjudicator Grok. Built, NOT run.
| # | Step | Who | Input | Output saved to | Status |
|---|------|-----|-------|-----------------|--------|
| 1 | Builder | ChatGPT (new chat, highest reasoning) | packets/A02R_1_BUILDER_ChatGPT.txt | A02R-builder/builder_report.md | DONE |
| 2 | Validator | DeepSeek (new chat, DeepThink) | packets/A02R_2_VALIDATOR_DeepSeek.txt | A02R-validator/validator_report.md | DONE |
| 3 | assemble | box (no chat) | python3 runner/assemble_adjudicator.py /workspace/ablation_plan/runs/N20 A02R | packets/A02R_3_ADJUDICATOR_Grok.txt + EVIDENCE_FREEZE.json | DONE |
| 4 | Adjudicator | Grok (new chat, Expert) | packets/A02R_3_ADJUDICATOR_Grok.txt | A02R-adjudicator/adjudicator_raw.md | DONE |
| 5 | record | box (no chat) | python3 runner/record_terminal.py /workspace/ablation_plan/runs/N20 A02R | TERMINAL_STATE.txt | DONE |
Steps 1 and 2 are independent and must be separate chats (blind). No PC step. Do not push to GitHub until the owner says so.
