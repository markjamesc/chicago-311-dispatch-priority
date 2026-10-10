# N13 C24 runner (catalog #24 Mechanical vs Judged Population: collapse the SQL envelope into R). Unattended; Windows PowerShell 5.1.
# Usage: powershell -ExecutionPolicy Bypass -File "<WORK>\runner\run_c24.ps1"
# Reads the frozen pack read-only, MySQL read-only (SELECT / CHECKSUM TABLE via the CLI, --login-path=chicago311); writes ONLY under <WORK>\C24. No git, no network.
param(
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311',
  [string]$Mysql   = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path; $W = Split-Path -Parent $Runner; $C = Join-Path $W 'C24V2'; $SD = Join-Path $Runner 'seeds\C24'
if (Test-Path (Join-Path $C 'arms')) { throw 'C24\arms already exists - this runner never overwrites.' }
New-Item -ItemType Directory -Force -Path $C | Out-Null
$LogF = Join-Path $W 'RUNNER_LOG_C24V2.txt'; $t0 = Get-Date
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path $LogF -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
Log "START C24V2 work=$W frozen=$Frozen"
# ---------------- Preflight (gating) ----------------
$pf = New-Object System.Collections.Generic.List[string]; $ok = $true
$expect = [ordered]@{
  'data\source\src_open_candidates.csv' = 'ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9'
  'data\source\src_peer_stats.csv'      = 'cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58'
  'R-A\run_RA.R'                        = 'f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587'
  'R-B\run_RB.R'                        = '6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd'
  'R-B\R\00_config.R'                   = '6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b'
  'R-B\R\10_io_parse.R'                 = '40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a'
  'R-B\R\20_integrity_and_classify.R'   = '72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99'
  'R-B\R\40_fixtures.R'                 = '2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e'
  'R-A\outputs\RA_classifications.csv'  = 'c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9'
  'R-B\outputs\RB_classifications.csv'  = 'a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193'
  'R-A\outputs\RA_fixture_results.csv'  = '33696cd1c6df7eefa62b07b078cfc554a661120d8b7685887ff3ffbcd82b6110'
  'R-B\outputs\RB_fixture_results.csv'  = '0d72245cac95555e32a3e6073e3ea9cc0a97de97f18c82965dff21f49052e9e9'
  'R-A\outputs\RA_portfolio_counts.csv' = 'b5888db21b184e5c929ffbe424c38340de39ded1313f9f892354fee4635e22e3'
  'R-B\outputs\RB_portfolio_counts.csv' = 'eb677bc1a831fad4b91d6b9ebe73b10310c5dc521dd779cdc1102b9157d7673c'
  'R-B\outputs\RB_kappa_grid_counts.csv'= '7a18fcb12f5f9795a3273d3f0bbb6334e83c4eb9cecfa185314a7d8883352c8a'
  'sql\01_source_extract.sql'           = 'f365e84a7e5d95f39a5fc19133d068e53a3aa5898f619e39db4dc6e0ba3a57b5'
  'sql\02_source_gate_checks.sql'       = 'ae26edb6af074a1a61e92d241fffef0730c893fef0c8c7ae6929d3f2d50aef59'
}
foreach ($k in $expect.Keys) { $p = Join-Path $Frozen $k; $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $expect[$k]); if (-not $m) { $ok = $false }; $pf.Add(("frozen {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $k)) }
foreach ($line in Get-Content (Join-Path $Runner 'SEEDS_C24V2.sha256')) { if (-not $line.Trim()) { continue }
  $hh, $rel = $line -split '  ', 2; $p = Join-Path $Runner ($rel -replace '/', '\'); $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $hh); if (-not $m) { $ok = $false }; $pf.Add(("seed   {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $rel)) }
$busy = @(Get-Process mysql -ErrorAction SilentlyContinue).Count; $pf.Add("other mysql client processes running (must be 0): $busy"); if ($busy -ne 0) { $ok = $false }
$ErrorActionPreference = 'Continue'
$rv = & $Rscript -e "cat(R.version.string); for (p in c('dplyr','readr','digest')) cat(' |', p, as.character(packageVersion(p)))" 2>&1; $pf.Add("R: $rv")
$cs = Get-CimInstance Win32_ComputerSystem; $os = Get-CimInstance Win32_OperatingSystem; $dk = Get-PSDrive C
$pf.Add(("machine (INFO): {0}, logical processors {1}, RAM {2} MB, free {3} MB, C: free {4} GB" -f $env:COMPUTERNAME, $cs.NumberOfLogicalProcessors, [int]($os.TotalVisibleMemorySize/1024), [int]($os.FreePhysicalMemory/1024), [int]($dk.Free/1GB)))
$ErrorActionPreference = 'Stop'
$pf.Add("preflight gating result: $(if ($ok) {'PASS'} else {'FAIL'})")
Set-Content -Path (Join-Path $C 'PREFLIGHT_C24V2.txt') -Value $pf -Encoding UTF8; $pf | ForEach-Object { Log $_ }
if (-not $ok) { Log 'PREFLIGHT FAIL - stopping; nothing executed.'; exit 2 }
# ---------------- helpers ----------------
function Manifest([string]$root, [string]$name, [scriptblock]$filter) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object $filter
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
$InF  = { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' }
$OutF = { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' }
function Sql([string]$sqlFile, [string]$outFile, [string]$tag, [bool]$append) {
  $s = Get-Date; $errF = Join-Path $C "SQL_$tag.err"; $tmp = if ($append) { "$outFile.part" } else { $outFile }
  $p = Start-Process -FilePath $Mysql -ArgumentList @('--login-path=chicago311', '--default-character-set=utf8mb4', '-N', '-B', '--raw') -NoNewWindow -Wait -PassThru -RedirectStandardInput $sqlFile -RedirectStandardOutput $tmp -RedirectStandardError $errF
  if ($append) {   # declared file layout: frozen header line (bytes, incl. BOM, up to and incl. LF) + mysql -N -B --raw output
    $fs = [IO.File]::Open($outFile, 'Append'); $in = [IO.File]::OpenRead($tmp); $in.CopyTo($fs); $in.Close(); $fs.Close()
    Rename-Item -LiteralPath $tmp -NewName ((Split-Path $tmp -Leaf) + '.appended') }
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1)
  Add-Content -Path (Join-Path $C 'SQL_TIMES.csv') -Value ("{0},{1},{2},{3}" -f $tag, $p.ExitCode, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
  Log ("  SQL {0} exit={1} secs={2} err_bytes={3}" -f $tag, $p.ExitCode, $secs, (Get-Item $errF).Length)
}
function Header-Bytes { $fs = [IO.File]::OpenRead((Join-Path $Frozen 'data\source\src_open_candidates.csv')); $buf = New-Object System.Collections.Generic.List[byte]
  while (($x = $fs.ReadByte()) -ge 0) { $buf.Add([byte]$x); if ($x -eq 10) { break } }; $fs.Close(); return ,$buf.ToArray() }
function Count-Lines([string]$p) { $fs = [IO.File]::OpenRead($p); $buf = New-Object byte[] 16777216; $n = [long]0
  while (($r = $fs.Read($buf, 0, $buf.Length)) -gt 0) { $i = 0; while (($j = [Array]::IndexOf($buf, [byte]10, $i, $r - $i)) -ge 0) { $n++; $i = $j + 1 } }; $fs.Close(); return $n }
function Run-R([string]$root, [string]$tag, [string]$script, [int]$capSec) {
  if ((Split-Path $root -Leaf) -eq 'COLLAPSED') {   # v2 RAM gate: wait (not kill) until >= 19968 MB (19.5 GB) free before starting the full-table R run; 2048 MB kill guard below is unchanged
    $gs = Get-Date; $logged = $false
    while ($true) { $fr = [long]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024)
      if ($fr -ge 19968) { Log ("  RAM gate PASS before COLLAPSED {0}: free_MB={1} waited_s={2}" -f $tag, $fr, [int]((Get-Date) - $gs).TotalSeconds); break }
      if (-not $logged -or ((Get-Date) - $gs).TotalSeconds % 600 -lt 31) { Log ("  RAM gate WAIT before COLLAPSED {0}: free_MB={1} (need 19968)" -f $tag, $fr); $logged = $true }
      if (((Get-Date) - $gs).TotalHours -gt 12) { Log '  RAM gate TIMEOUT 12 h'; break }
      Start-Sleep -Seconds 30 } }
  $env:CHICAGO311_ROOT = $root; $s = Get-Date; $minFree = [long]1e12; $peak = [long]0; $kill = ''
  $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$script`"", 'all') -NoNewWindow -PassThru -RedirectStandardOutput (Join-Path $root "RUN_$tag.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$tag.stderr.txt")
  $null = $p.Handle
  while (-not $p.WaitForExit(2000)) {
    $free = [long]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024); if ($free -lt $minFree) { $minFree = $free }
    $ws = [long]((Get-Process -Name Rscript, Rterm, R -ErrorAction SilentlyContinue | Measure-Object WorkingSet64 -Sum).Sum / 1MB); if ($ws -gt $peak) { $peak = $ws }
    if ($free -lt 2048) { $kill = 'MEMKILL' } elseif (((Get-Date) - $s).TotalSeconds -gt $capSec) { $kill = 'TIMEOUT' }
    if ($kill) { & taskkill.exe /PID $p.Id /T /F | Out-Null; $p.WaitForExit(); break } }
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1); $code = if ($kill) { $kill } else { $p.ExitCode }
  Set-Content -Path (Join-Path $root "RUN_$tag.exit") -Value ("{0},{1},{2},{3},{4},{5}" -f $code, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'), $capSec, $minFree, $peak) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3} min_free_MB={4} peak_R_MB={5}" -f (Split-Path $root -Leaf), $tag, $code, $secs, $minFree, $peak)
  Remove-Item Env:\CHICAGO311_ROOT -ErrorAction SilentlyContinue
}
# ---------------- Arms ----------------
$hdr = Header-Bytes; Log ("header line bytes from frozen extract: {0}" -f $hdr.Length)
foreach ($arm in 'B', 'COLLAPSED') { $root = Join-Path $C "arms\$arm"
  New-Item -ItemType Directory -Force -Path (Join-Path $root 'data\source'), (Join-Path $root 'R-A'), (Join-Path $root 'R-B\R') | Out-Null
  Copy-Item -LiteralPath (Join-Path $Frozen 'R-A\run_RA.R') -Destination (Join-Path $root 'R-A\run_RA.R')
  Copy-Item -LiteralPath (Join-Path $Frozen 'R-B\run_RB.R') -Destination (Join-Path $root 'R-B\run_RB.R')
  foreach ($f in '00_config.R','10_io_parse.R','20_integrity_and_classify.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") }
  foreach ($f in 'src_peer_stats.csv','src_extract_lineage.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
  foreach ($f in 'X_SEP.sql','X_FULL.sql','CK.sql','Q_COUNTS.sql') { Copy-Item -LiteralPath (Join-Path $SD $f) -Destination (Join-Path $C $f) -Force }
  [IO.File]::WriteAllBytes((Join-Path $root 'data\source\src_open_candidates.csv'), $hdr) }
Log 'SQL phase (serial, single session at a time)'
Sql (Join-Path $C 'CK.sql') (Join-Path $C 'CK_PRE.tsv') 'CK_PRE' $false
Sql (Join-Path $C 'Q_COUNTS.sql') (Join-Path $C 'Q_COUNTS.tsv') 'Q_COUNTS' $false
Sql (Join-Path $C 'X_SEP.sql') (Join-Path $C 'arms\B\data\source\src_open_candidates.csv') 'X_SEP' $true
Sql (Join-Path $C 'X_FULL.sql') (Join-Path $C 'arms\COLLAPSED\data\source\src_open_candidates.csv') 'X_FULL' $true
Sql (Join-Path $C 'CK.sql') (Join-Path $C 'CK_POST.tsv') 'CK_POST' $false
$ex = foreach ($arm in 'B', 'COLLAPSED') { $p = Join-Path $C "arms\$arm\data\source\src_open_candidates.csv"
  "{0},{1},{2},{3}" -f $arm, (Get-Sha $p), (Get-Item $p).Length, ((Count-Lines $p) - 1) }
Set-Content -Path (Join-Path $C 'EXTRACTS.csv') -Value (@('arm,sha256,bytes,data_rows') + $ex) -Encoding ASCII; $ex | ForEach-Object { Log "  extract $_" }
$ck1 = (Get-Content (Join-Path $C 'CK_PRE.tsv')) -join ' | '; $ck2 = (Get-Content (Join-Path $C 'CK_POST.tsv')) -join ' | '; Log "  CK_PRE  $ck1"; Log "  CK_POST $ck2"
if ($ck1 -ne $ck2 -or -not $ck1) { Log 'HALT: checksum bracket changed or empty - R phase not run'; Set-Content (Join-Path $C 'HALT.txt') 'checksum bracket changed or empty'; exit 3 }
Log 'R phase (B then COLLAPSED; R-A then R-B; cap 4 h each; kill if free RAM < 2048 MB)'
foreach ($arm in 'B', 'COLLAPSED') { $root = Join-Path $C "arms\$arm"; Manifest $root 'MANIFEST_inputs.sha256' $InF
  Run-R $root 'RA' (Join-Path $root 'R-A\run_RA.R') 14400; Run-R $root 'RB' (Join-Path $root 'R-B\run_RB.R') 14400
  Manifest $root 'MANIFEST_outputs.sha256' $OutF }
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'eval_c24v2.R')`"", "`"$W`"", "`"$Frozen`"") -NoNewWindow -Wait -PassThru -RedirectStandardOutput (Join-Path $C 'SUMMARIZE_stdout.txt') -RedirectStandardError (Join-Path $C 'SUMMARIZE_stderr.txt')
Log ("summarize exit=" + $p.ExitCode)
$ev = Join-Path $C 'evidence'; New-Item -ItemType Directory -Force -Path $ev | Out-Null
$lines = foreach ($arm in Get-ChildItem -Directory (Join-Path $C 'arms') | Sort-Object Name) { foreach ($mf in 'MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { $q = Join-Path $arm.FullName $mf
  if (Test-Path $q) { Get-Content $q | ForEach-Object { "arms/$($arm.Name)/$mf :: $_" } } } }
Set-Content -Path (Join-Path $ev 'C24V2_ARM_MANIFESTS.txt') -Value $lines -Encoding UTF8
foreach ($f in 'C24V2_RESULTS.md','C24V2_arms.csv','EXTRACTS.csv','SQL_TIMES.csv','CK_PRE.tsv','CK_POST.tsv','Q_COUNTS.tsv','PREFLIGHT_C24V2.txt') { if (Test-Path (Join-Path $C $f)) { Copy-Item (Join-Path $C $f) $ev -Force } }
$l2 = Get-ChildItem -File $ev | Where-Object { $_.Name -ne 'C24V2_EVIDENCE.sha256' } | Sort-Object Name | ForEach-Object { "{0}  {1}" -f (Get-Sha $_.FullName), $_.Name }
Set-Content -Path (Join-Path $ev 'C24V2_EVIDENCE.sha256') -Value $l2 -Encoding UTF8
Log ("DONE C24V2 elapsed_min=" + [math]::Round(((Get-Date) - $t0).TotalMinutes, 2))
