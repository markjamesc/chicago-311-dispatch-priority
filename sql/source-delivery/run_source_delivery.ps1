# Stage 4 Method B — SQL source delivery (PC)
# Requires: MySQL client + login-path=chicago311
# Working dir expected: ...\chicago311\ (creates data\, sql\source-delivery\, validation\source-gate\)

$ErrorActionPreference = "Stop"
$Mysql = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if (-not (Test-Path $Mysql)) {
  $found = Get-Command mysql -ErrorAction SilentlyContinue
  if ($found) { $Mysql = $found.Source } else { throw "mysql.exe not found" }
}

$Root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path (Join-Path $Root "data"))) {
  # Prefer repo-local or PC workdir layout
  $Root = $PSScriptRoot
  while ($Root -and -not (Test-Path (Join-Path $Root "sql\source-delivery"))) {
    $Root = Split-Path -Parent $Root
  }
}
$OutDir = Join-Path $Root "data"
$SqlDir = Join-Path $Root "sql\source-delivery"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$ExtractSql = Join-Path $SqlDir "01_source_extract_open_envelope.sql"
$OutTsv = Join-Path $OutDir "source_open_envelope.tsv"
$Lineage = Join-Path $OutDir "source_package_lineage.json"
$Ts = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"

Write-Host "Exporting Open envelope via $Mysql ..."
& $Mysql --login-path=chicago311 --batch --raw --quick chicago311 -e "SOURCE $($ExtractSql -replace '\\','/')" 2>$null
# Fallback: feed file via stdin
Get-Content -Raw $ExtractSql | & $Mysql --login-path=chicago311 --batch --raw --quick | Set-Content -Encoding utf8 $OutTsv

$Hash = (Get-FileHash -Algorithm SHA256 $OutTsv).Hash.ToLower()
$Rows = (Get-Content $OutTsv | Measure-Object -Line).Lines - 1
$LineageObj = [ordered]@{
  snapshot_id = "chicago311-raw-frozen-2026-09-12"
  source_table = "chicago311.raw_311_requests"
  mechanical_envelope = "STATUS='Open'"
  judged_fields_forbidden = $true
  extract_timestamp_ct = $Ts
  output_path = $OutTsv
  rowcount_data_rows = $Rows
  sha256 = $Hash
  design_version = "stage3-v0.1"
  contract = "SOURCE_DELIVERY_CONTRACT.md"
}
$LineageObj | ConvertTo-Json | Set-Content -Encoding utf8 $Lineage
Write-Host "Wrote $OutTsv rows=$Rows sha256=$Hash"
Write-Host "Lineage: $Lineage"
