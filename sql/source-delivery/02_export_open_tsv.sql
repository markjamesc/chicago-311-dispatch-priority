-- Export Open envelope to TSV for R handoff (run on PC).
-- Example (PowerShell / cmd):
--   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --login-path=chicago311 --batch --raw --quick < 01_source_extract_open_envelope.sql > ..\..\data\source_open_envelope.tsv
-- Prefer the companion run_source_delivery.ps1 which also writes lineage + checksum.

SELECT 1 AS placeholder_see_run_script;
