# A02R mechanical facts (script-derived; no verdict)

Source: `evidence/` files only. Script: `runner/a02r_facts.py`.

| # | Check | Result |
|---|-------|--------|
| 1 | R-A fixtures 14/14 in pre-fix run | TRUE |
| 2 | R-B fixtures 14/14 in pre-fix run | TRUE |
| 3 | R-A fixtures 14/14 in post-fix run | TRUE |
| 4 | R-B fixtures 14/14 in post-fix run | TRUE |
| 5 | F03 expected=observed=STANDARD (R-B, both runs) | TRUE |
| 6 | F03 STANDARD/STANDARD TRUE (R-A table, both runs) | TRUE |
| 7 | Pre-fix: ESC differs RB-RA = 104 | TRUE |
| 8 | Pre-fix: STD differs RA-RB = 104 | TRUE |
| 9 | Pre-fix: INC equal 6377 and decision equal 222002 | TRUE |
| 10 | Post-fix portfolios identical (131968/6377/83657) | TRUE |
| 11 | Post-fix RECON_SUMMARY.csv: agree 222002, disagree 0, only_ra 0, only_rb 0 | TRUE |
| 12 | RECON_DISAGREE_IDS.csv has 0 data rows | TRUE |
| 13 | All four R exits 0 | TRUE |
| 14 | Fixture CSVs 14 rows all pass | TRUE |
| 15 | Fixture Gate lock time precedes first production run (2026-09-19 10:26:37 CT < 12:56:16 CT) | TRUE |

## Extracted values
```json
{
  "run1_pre_fix": {
    "ra_fix_pass": "14/14",
    "rb_fix_pass": "14/14",
    "rb_F03": [
      "STANDARD",
      "STANDARD"
    ],
    "ra_F03_observed_pass": true,
    "ra_portfolio": {
      "decision": 222002,
      "ESC": 131968,
      "INC": 6377,
      "STD": 83657
    },
    "rb_portfolio": {
      "decision": 222002,
      "ESC": 132072,
      "INC": 6377,
      "STD": 83553
    },
    "recon_in_log": null,
    "exit_ra": [
      "0"
    ],
    "exit_rb": [
      "0"
    ]
  },
  "rerun_post_fix": {
    "ra_fix_pass": "14/14",
    "rb_fix_pass": "14/14",
    "rb_F03": [
      "STANDARD",
      "STANDARD"
    ],
    "ra_F03_observed_pass": true,
    "ra_portfolio": {
      "decision": 222002,
      "ESC": 131968,
      "INC": 6377,
      "STD": 83657
    },
    "rb_portfolio": {
      "decision": 222002,
      "ESC": 131968,
      "INC": 6377,
      "STD": 83657
    },
    "recon_in_log": [
      "222002",
      "222002",
      "222002",
      "0",
      "0",
      "222002",
      "0"
    ],
    "exit_ra": [
      "0"
    ],
    "exit_rb": [
      "0"
    ]
  },
  "recon_summary_csv": {
    "n_ra": "222002",
    "n_rb": "222002",
    "n_inner": "222002",
    "n_only_ra": "0",
    "n_only_rb": "0",
    "n_agree": "222002",
    "n_disagree": "0"
  },
  "fixture_csvs": {
    "RA": {
      "n": 14,
      "all_pass": true,
      "F03": [
        [
          "STANDARD",
          "STANDARD"
        ]
      ]
    },
    "RB": {
      "n": 14,
      "all_pass": true,
      "F03": [
        [
          null,
          null
        ]
      ]
    }
  },
  "fixture_gate_locked_at": "2026-09-19 10:26:37 CT",
  "run1_started_at": "2026-09-19T12:56:16.7553084-05:00"
}
```

Note: Fixture runs in both the pre-fix and post-fix logs are 14/14 PASS. The 104-row disagreement was therefore invisible to the Fixture Gate and visible to exact recon (portfolio ESC 131,968 vs 132,072).
