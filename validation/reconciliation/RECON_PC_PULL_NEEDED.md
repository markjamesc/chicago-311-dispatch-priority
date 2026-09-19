# Recon CSV pull needed

Exact recon **PASS** is attested in `EXACT_RECON_REPORT.md` (222002/222002 agree; 0 disagrees).

PC files not yet on box (this executor lacks CopyToBox / machineId Shell):
- `C:\Users\Mark\Documents\R Working Directory\chicago311\recon\RECON_SUMMARY.csv`
- `C:\Users\\Mark\\Documents\\R Working Directory\\chicago311\\recon\\RECON_DISAGREE_IDS.csv`
- `C:\Users\\Mark\\Documents\\R Working Directory\\chicago311\\RA_classifications.csv` (and RB twin)

machineId: `dc602624-137d-44ac-bac6-1c25377a1912`

Parent: CopyToBox those three paths into:
- `validation/reconciliation/RECON_SUMMARY.csv`
- `validation/reconciliation/RECON_DISAGREE_IDS.csv`
- `/workspace/chicago-311-run/stage-04/pc-pull/RA_classifications.csv`

Then re-run `scripts/build_validated_action_list.py` (or the filter step).
