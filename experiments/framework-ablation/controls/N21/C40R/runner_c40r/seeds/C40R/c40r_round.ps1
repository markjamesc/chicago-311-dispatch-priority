# C40R one gate round (N13 c40r). R only; no MySQL, no network, no git. Windows PowerShell 5.1.
# Builder round : powershell -ExecutionPolicy Bypass -File "<WORK>\runner_c40r\seeds\C40R\c40r_round.ps1" -Arm INC -Round 1
#                 (expects <WORK>\C40R\C40R-<Arm>\r<Round>\reply.md = extracted reply text, and TIMES.txt with sent= / reply_complete=)
# Validation arm: ... -Arm REF -Round 0 -Candidate <path to a module file> -Validation
# Writes ONLY under <WORK>\C40R (arms\<Arm>_r<Round>\, C40R-<Arm>\r<k>\, ROUNDS_LOG.tsv, STATE_LOG.txt, ROUND_PACKETS.sha256). Never overwrites an arm.
param(
  [Parameter(Mandatory=$true)][string]$Arm,
  [Parameter(Mandatory=$true)][int]$Round,
  [string]$Candidate = '',
  [switch]$Validation,
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311'
)
$ErrorActionPreference = 'Stop'
$SD = Split-Path -Parent $MyInvocation.MyCommand.Path          # runner_c40r\seeds\C40R
$W = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $SD))
$C = Join-Path $W 'C40R'; New-Item -ItemType Directory -Force -Path $C | Out-Null
$LogF = Join-Path $W 'RUNNER_LOG_c40r.txt'
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path $LogF -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
function Q([string]$s) { "`"$s`"" }
function Manifest([string]$root, [string]$name, [scriptblock]$filter) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object $filter
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8 }
$InF  = { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' -and $_.Name -notlike 'GATE_*' }
$OutF = { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' -or $_.Name -like 'GATE_*' }
function Run-Timed([string]$root, [string]$tag, [string]$exe, [string[]]$al, [int]$capSec, [string]$envRoot) {
  if ($envRoot) { $env:CHICAGO311_ROOT = $envRoot }
  $s = Get-Date
  $p = Start-Process -FilePath $exe -ArgumentList $al -NoNewWindow -PassThru -RedirectStandardOutput (Join-Path $root "RUN_$tag.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$tag.stderr.txt")
  $null = $p.Handle; $to = 0
  if (-not $p.WaitForExit($capSec * 1000)) { $to = 1; & taskkill.exe /PID $p.Id /T /F | Out-Null; $p.WaitForExit() }
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1); $code = if ($to) { 'TIMEOUT' } else { $p.ExitCode }
  Set-Content -Path (Join-Path $root "RUN_$tag.exit") -Value ("{0},{1},{2},{3},{4}" -f $code, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'), $to, $capSec) -Encoding ASCII
  Log ("  C40R {0} {1} exit={2} secs={3} timeout={4}" -f (Split-Path $root -Leaf), $tag, $code, $secs, $to)
  if ($envRoot) { Remove-Item Env:\CHICAGO311_ROOT -ErrorAction SilentlyContinue }
  return $code }
$FZH = [ordered]@{
  'R-B\run_RB.R'='6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd'
  'R-B\R\00_config.R'='6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b'
  'R-B\R\10_io_parse.R'='40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a'
  'R-B\R\20_integrity_and_classify.R'='72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99'
  'R-B\R\40_fixtures.R'='2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e'
  'R-B\outputs\RB_classifications.csv'='a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193'
  'R-B\outputs\RB_fixture_results.csv'='0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9'
  'R-B\outputs\RB_portfolio_counts.csv'='eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c'
  'R-B\outputs\RB_kappa_grid_counts.csv'='7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a'
  'data\source\src_open_candidates.csv'='ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9'
  'data\source\src_peer_stats.csv'='cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58' }
foreach ($k in $FZH.Keys) { $h = Get-Sha (Join-Path $Frozen $k); if ($h -ne $FZH[$k]) { Log "C40R PREFLIGHT FAILED: $k $h"; throw "preflight hash mismatch: $k" } }
Log 'C40R preflight: frozen pack hashes verified'
if (-not $Validation) {
  if ($Arm -notin @('INC','FRESH')) { throw "builder rounds use -Arm INC or FRESH" }
  $rd = Join-Path $C ("C40R-{0}\r{1}" -f $Arm, $Round); $reply = Join-Path $rd 'reply.md'
  if (-not (Test-Path -LiteralPath $reply)) { throw "missing $reply (save the extracted reply text there first)" }
  if (-not (Test-Path -LiteralPath (Join-Path $rd 'TIMES.txt'))) { throw "missing $rd\TIMES.txt (sent= / reply_complete=)" }
  $Candidate = Join-Path $rd '20_integrity_and_classify.R'
  if (Test-Path -LiteralPath $Candidate) { throw "$Candidate exists; extraction never overwrites" }
  & $Rscript (Join-Path $SD 'c40r_extract.R') $reply ("END C40R BUILD {0} r{1}" -f $Arm, $Round) $Candidate
  if ($LASTEXITCODE -ne 0) { Log "C40R $Arm r$Round extraction REFUSED"; exit 3 }
}
if (-not (Test-Path -LiteralPath $Candidate)) { throw "candidate module not found: $Candidate" }
$root = Join-Path $C ("arms\{0}_r{1}" -f $Arm, $Round)
if (Test-Path -LiteralPath $root) { throw "$root exists - never overwritten" }
Log "C40R round $Arm r$Round candidate=$Candidate sha256=$(Get-Sha $Candidate)"
New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-B\R'), (Join-Path $root 'data\source') | Out-Null
Copy-Item -LiteralPath (Join-Path $Frozen 'R-B\run_RB.R') -Destination (Join-Path $root 'R-B\run_RB.R')
foreach ($f in '00_config.R','10_io_parse.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") }
Copy-Item -LiteralPath $Candidate -Destination (Join-Path $root 'R-B\R\20_integrity_and_classify.R')
foreach ($f in 'src_open_candidates.csv','src_peer_stats.csv','src_extract_lineage.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
Manifest $root 'MANIFEST_inputs.sha256' $InF
$null = Run-Timed $root 'RB' $Rscript @((Q (Join-Path $root 'R-B\run_RB.R')), 'all') 1800 $root
$null = Run-Timed $root 'GATE' $Rscript @((Q (Join-Path $SD 'c40r_gate.R')), (Q $root), (Q $Frozen), (Q ("{0} r{1}" -f $Arm, $Round))) 900 $null
$g = (Get-Content (Join-Path $root 'GATE_RESULT.txt') -TotalCount 1)
$hid = 'not run (gate FAIL)'
if ($g -like 'gate=PASS*') {
  Copy-Item -LiteralPath (Join-Path $SD 'fixdepth.R') -Destination (Join-Path $root 'fixdepth.R')
  $null = Run-Timed $root 'HIDDEN' $Rscript @((Q (Join-Path $root 'fixdepth.R')), (Q $root), 'depth', (Q (Join-Path $Frozen 'data\source'))) 600 $null
  $hp = Join-Path $root 'outputs\GATE_depth.txt'; $hid = if (Test-Path $hp) { (Get-Content $hp -TotalCount 1) } else { 'MISSING' } }
Manifest $root 'MANIFEST_outputs.sha256' $OutF
$lf = Join-Path $C 'ROUNDS_LOG.tsv'; if (-not (Test-Path $lf)) { Set-Content -Path $lf -Value "time`tarm`tround`tvalidation`tcandidate_sha256`tgate`thidden" -Encoding UTF8 }
Add-Content -Path $lf -Value ("{0}`t{1}`t{2}`t{3}`t{4}`t{5}`t{6}" -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'), $Arm, $Round, [bool]$Validation, (Get-Sha $Candidate), $g, $hid) -Encoding UTF8
Log "C40R $Arm r$Round : $g | hidden: $hid"
if (-not $Validation) {
  & $Rscript (Join-Path $SD 'c40r_next.R') $W $Arm $Round
  if ($LASTEXITCODE -ne 0) { throw "c40r_next.R failed" }
}
