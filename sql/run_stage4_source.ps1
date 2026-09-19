# Stage 4 Method B — run extract + Source Gate on DESKTOP-RPECRM9
$ErrorActionPreference = "Stop"
$Mysql = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
if (-not (Test-Path $Mysql)) {
  $found = Get-Command mysql -ErrorAction SilentlyContinue
  if ($found) { $Mysql = $found.Source } else { throw "mysql.exe not found" }
}

$Root = "C:\Users\Mark\Documents\R Working Directory\chicago311"
$SqlDir = Join-Path $Root "sql"
$DocsVal = Join-Path $Root "docs\stage-04-validation"
$DataDir = Join-Path $Root "data\source"
New-Item -ItemType Directory -Force -Path $SqlDir, $DocsVal, $DataDir | Out-Null

$Extract = Join-Path $SqlDir "01_source_extract.sql"
$Gate = Join-Path $SqlDir "02_source_gate_checks.sql"
$GateOut = Join-Path $DocsVal "source_gate_raw.tsv"
$LineageOut = Join-Path $DataDir "src_extract_lineage.tsv"
$PeerOut = Join-Path $DataDir "src_peer_stats.tsv"
$Ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "[$Ts CT] login-path probe..."
& $Mysql --login-path=chicago311 -e "SELECT 1 AS ok, DATABASE(); SELECT COUNT(*) AS raw_n, SUM(STATUS='Open') AS open_n FROM chicago311.raw_311_requests;" 
if ($LASTEXITCODE -ne 0) { throw "mysql --login-path=chicago311 failed exit=$LASTEXITCODE" }

Write-Host "Running 01_source_extract.sql (may take several minutes for peers)..."
Get-Content -Raw $Extract | & $Mysql --login-path=chicago311 --batch --raw
if ($LASTEXITCODE -ne 0) { throw "01_source_extract.sql failed exit=$LASTEXITCODE" }

Write-Host "Running 02_source_gate_checks.sql..."
Get-Content -Raw $Gate | & $Mysql --login-path=chicago311 --batch --raw | Tee-Object -FilePath $GateOut
if ($LASTEXITCODE -ne 0) { throw "02_source_gate_checks.sql failed exit=$LASTEXITCODE" }

& $Mysql --login-path=chicago311 --batch --raw -e "SELECT * FROM chicago311.src_extract_lineage;" | Set-Content -Encoding utf8 $LineageOut
& $Mysql --login-path=chicago311 --batch --raw -e "SELECT * FROM chicago311.src_peer_stats;" | Set-Content -Encoding utf8 $PeerOut

Write-Host "Export done. Gate raw: $GateOut"
Write-Host "Lineage: $LineageOut Peer: $PeerOut"
