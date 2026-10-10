# N13 ablation runner v4 (Chicago 311 frozen pack). Unattended; Windows PowerShell 5.1.
# v4 arm types: seeds\C51\SMOKE (smoke runs at 1/16 and 1/4 scale + full run per path, with time caps),
#               seeds\C46\DETFIT (seeded glmnet fit per path + reconciliation under a declared comparator),
#               seeds\C52\SQLCONC (read-only extract + Source Gate SQL chains, serial vs concurrent, CHECKSUM TABLE bracket).
# Usage: powershell -ExecutionPolicy Bypass -File "<WORK>\runner\run_batch_v4.ps1" -Batch b4 -Controls C51,C46,C52
# Reads the frozen pack read-only and writes ONLY under <WORK>. No git, no network, no DB writes (MySQL: SELECT / CHECKSUM TABLE only).
param(
  [Parameter(Mandatory=$true)][string]$Batch,
  [Parameter(Mandatory=$true)][string[]]$Controls,
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311',
  [string]$Mysql   = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
if ($Controls.Count -eq 1 -and $Controls[0] -like '*,*') { $Controls = $Controls[0] -split ',' }
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path
$W = Split-Path -Parent $Runner
$t0 = Get-Date
$LogF = Join-Path $W "RUNNER_LOG_$Batch.txt"
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path $LogF -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
foreach ($cid in $Controls) { if (Test-Path (Join-Path $W "$cid\arms")) { throw "$cid\arms already exists - this runner never overwrites; move it aside to rerun." } }
Log "START batch=$Batch controls=$($Controls -join ',') work=$W frozen=$Frozen"
# ---------------- Preflight (gating) ----------------
$pf = New-Object System.Collections.Generic.List[string]
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
$ok = $true
foreach ($k in $expect.Keys) { $p = Join-Path $Frozen $k; $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $expect[$k]); if (-not $m) { $ok = $false }; $pf.Add(("frozen {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $k)) }
foreach ($line in Get-Content (Join-Path $Runner "SEEDS_$Batch.sha256")) { if (-not $line.Trim()) { continue }
  $hh, $rel = $line -split '  ', 2; $p = Join-Path $Runner ($rel -replace '/', '\'); $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $hh); if (-not $m) { $ok = $false }; $pf.Add(("seed   {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $rel)) }
$ErrorActionPreference = 'Continue'
$rv = & $Rscript -e "cat(R.version.string); for (p in c('dplyr','readr','glmnet','digest','jsonlite')) cat(' |', p, as.character(packageVersion(p)))" 2>&1
$pf.Add("R: $rv"); if ("$rv" -notmatch 'glmnet' -or "$rv" -notmatch 'digest') { $ok = $false; $pf.Add('FAIL: R package glmnet or digest missing') }
try { $q = & $Mysql --login-path=chicago311 -N -B -e "SELECT 'src_open_candidates', COUNT(*) FROM chicago311.src_open_candidates UNION ALL SELECT 'src_peer_stats', COUNT(*) FROM chicago311.src_peer_stats; SELECT VERSION();" 2>&1
  $pf.Add("mysql (INFO, read-only; expect 245193 / 104): " + (($q | ForEach-Object { "$_" }) -join ' ; ')) } catch { $pf.Add("mysql (INFO): not run: $($_.Exception.Message)") }
$cs = Get-CimInstance Win32_ComputerSystem; $os = Get-CimInstance Win32_OperatingSystem
$pf.Add(("machine (INFO): {0}, logical processors {1}, RAM {2} MB, free {3} MB" -f $env:COMPUTERNAME, $cs.NumberOfLogicalProcessors, [int]($os.TotalVisibleMemorySize/1024), [int]($os.FreePhysicalMemory/1024)))
$ErrorActionPreference = 'Stop'
$pf.Add("preflight gating result: $(if ($ok) {'PASS'} else {'FAIL'})")
Set-Content -Path (Join-Path $W 'PREFLIGHT.txt') -Value $pf -Encoding UTF8; $pf | ForEach-Object { Log $_ }
if (-not $ok) { Log 'PREFLIGHT FAIL - stopping; nothing executed.'; exit 2 }
# ---------------- helpers ----------------
function Manifest([string]$root, [string]$name, [scriptblock]$filter) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object $filter
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
$InF  = { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' }
$OutF = { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' -or $_.Name -in @('PERF.csv','RECON.csv','NON_REPORTING.txt') -or $_.Extension -in @('.tsv','.err') -or $_.Name -like 'times_*' -or $_.Name -in @('pred.csv','fit_info.csv') }
function Run-Timed([string]$root, [string]$tag, [string]$exe, [string[]]$al, [int]$capSec, [string]$envRoot) {
  if ($envRoot) { $env:CHICAGO311_ROOT = $envRoot }
  $s = Get-Date
  $p = Start-Process -FilePath $exe -ArgumentList $al -NoNewWindow -PassThru -RedirectStandardOutput (Join-Path $root "RUN_$tag.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$tag.stderr.txt")
  $null = $p.Handle; $to = 0
  if (-not $p.WaitForExit($capSec * 1000)) { $to = 1; & taskkill.exe /PID $p.Id /T /F | Out-Null; $p.WaitForExit() }
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1); $code = if ($to) { 'TIMEOUT' } else { $p.ExitCode }
  Set-Content -Path (Join-Path $root "RUN_$tag.exit") -Value ("{0},{1},{2},{3},{4}" -f $code, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz'), $to, $capSec) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3} timeout={4}" -f (Split-Path $root -Leaf), $tag, $code, $secs, $to)
  if ($envRoot) { Remove-Item Env:\CHICAGO311_ROOT -ErrorAction SilentlyContinue }
}
function New-CodeArm([string]$root, [bool]$withRA, [bool]$withRB) {
  New-Item -ItemType Directory -Force -Path (Join-Path $root 'data\source') | Out-Null
  if ($withRA) { New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-A') | Out-Null; Copy-Item -LiteralPath (Join-Path $Frozen 'R-A\run_RA.R') -Destination (Join-Path $root 'R-A\run_RA.R') }
  if ($withRB) { New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-B\R') | Out-Null
    Copy-Item -LiteralPath (Join-Path $Frozen 'R-B\run_RB.R') -Destination (Join-Path $root 'R-B\run_RB.R')
    foreach ($f in '00_config.R','10_io_parse.R','20_integrity_and_classify.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") } }
}
# ---------------- C51: smoke runs ----------------
$SMOKE_K = @(16, 4); $CAP_SMOKE = 600; $CAP_FULL = 1800
function Run-SmokeArm([string]$cid, [string]$arm, [string[]]$paths, [string]$seeds) {
  $root = Join-Path $W "$cid\arms\$arm"; New-CodeArm $root ($paths -contains 'RA') ($paths -contains 'RB')
  foreach ($f in 'src_open_candidates.csv','src_peer_stats.csv','src_extract_lineage.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
  if ($seeds -ne '-') { foreach ($s in $seeds -split ';') { $from, $to = $s -split '>', 2; Copy-Item -LiteralPath (Join-Path $Runner ($from -replace '/', '\')) -Destination (Join-Path $root $to) -Force } }
  Manifest $root 'MANIFEST_inputs.sha256' $InF
  foreach ($pth in $paths) {
    $dirn = if ($pth -eq 'RA') { 'R-A' } else { 'R-B' }; $scr = if ($pth -eq 'RA') { 'run_RA.R' } else { 'run_RB.R' }
    foreach ($k in $SMOKE_K) {
      $sr = Join-Path $W "$cid\smoke\$($arm)_$($pth)_k$k"; New-Item -ItemType Directory -Force -Path $sr | Out-Null
      Set-Content -Path (Join-Path $sr 'NON_REPORTING.txt') -Value "SMOKE RUN - NON-REPORTING. 1/$k subset of the frozen extract (declared rule in runner/seeds/common/make_subset.R). Never reconciled, never used as a result." -Encoding UTF8
      Copy-Item -Recurse -LiteralPath (Join-Path $root $dirn) -Destination (Join-Path $sr $dirn)
      $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'seeds\common\make_subset.R')`"", "`"$(Join-Path $Frozen 'data\source')`"", "`"$(Join-Path $sr 'data\source')`"", "$k") -NoNewWindow -Wait -PassThru -RedirectStandardOutput (Join-Path $sr 'SUBSET_stdout.txt') -RedirectStandardError (Join-Path $sr 'SUBSET_stderr.txt')
      if ($p.ExitCode -ne 0) { throw "make_subset failed $sr" }
      Manifest $sr 'MANIFEST_inputs.sha256' $InF
      Run-Timed $sr $pth $Rscript @("`"$(Join-Path $sr "$dirn\$scr")`"", 'all') $CAP_SMOKE $sr
      Manifest $sr 'MANIFEST_outputs.sha256' $OutF
    }
    Run-Timed $root $pth $Rscript @("`"$(Join-Path $root "$dirn\$scr")`"", 'all') $CAP_FULL $root
  }
  Manifest $root 'MANIFEST_outputs.sha256' $OutF
}
# ---------------- C46: seeded fits ----------------
function Run-FitArm([string]$cid, $a) {
  $root = Join-Path $W "$cid\arms\$($a.arm)"; New-Item -ItemType Directory -Force -Path $root | Out-Null
  foreach ($f in 'fit_path.R','recon_c46.R') { Copy-Item -LiteralPath (Join-Path $Runner "seeds\C46\$f") -Destination (Join-Path $root $f) }
  Set-Content -Path (Join-Path $root 'ARM.txt') -Value ("arm={0} ra_order={1} rb_order={2} thresh={3} rb_drop={4} regime={5}" -f $a.arm, $a.ra_order, $a.rb_order, $a.thresh, $a.rb_drop, $a.regime) -Encoding UTF8
  Manifest $root 'MANIFEST_inputs.sha256' $InF
  Run-Timed $root 'FIT_RA' $Rscript @("`"$(Join-Path $root 'fit_path.R')`"", "`"$Frozen`"", "`"$(Join-Path $root 'RA')`"", $a.ra_order, $a.thresh, '-') 3600 $null
  if ($a.arm -ne 'REF') {
    Run-Timed $root 'FIT_RB' $Rscript @("`"$(Join-Path $root 'fit_path.R')`"", "`"$Frozen`"", "`"$(Join-Path $root 'RB')`"", $a.rb_order, $a.thresh, $a.rb_drop) 3600 $null
    Run-Timed $root 'RECON' $Rscript @("`"$(Join-Path $root 'recon_c46.R')`"", "`"$root`"", $a.regime) 600 $null }
  Manifest $root 'MANIFEST_outputs.sha256' $OutF
}
# ---------------- C52: SQL chains ----------------
function Write-Chain([string]$root, [string]$name, [string[]]$qs) {
  $L = @('@echo off')
  foreach ($q in $qs) { $L += "echo $q start %TIME% >> `"$root\times_$name.txt`""
    $L += "`"$Mysql`" --login-path=chicago311 -N -B --raw < `"$root\$q.sql`" > `"$root\$q.tsv`" 2> `"$root\$q.err`""
    $L += "echo $q exit %ERRORLEVEL% %TIME% >> `"$root\times_$name.txt`"" }
  Set-Content -Path (Join-Path $root "chain_$name.cmd") -Value $L -Encoding ASCII
}
function Run-CK([string]$root, [string]$tag) {
  $p = Start-Process -FilePath $Mysql -ArgumentList @('--login-path=chicago311', '-N', '-B', '--raw') -NoNewWindow -Wait -PassThru -RedirectStandardInput (Join-Path $root 'CK.sql') `
        -RedirectStandardOutput (Join-Path $root "CK_$tag.tsv") -RedirectStandardError (Join-Path $root "CK_$tag.err")
  Log ("  {0} CHECKSUM {1} exit={2} :: {3}" -f (Split-Path $root -Leaf), $tag, $p.ExitCode, ((Get-Content (Join-Path $root "CK_$tag.tsv")) -join ' | '))
}
function Run-SqlArm([string]$cid, $a) {
  $root = Join-Path $W "$cid\arms\$($a.arm)"; New-Item -ItemType Directory -Force -Path $root | Out-Null
  foreach ($f in 'E1.sql','E2.sql','G.sql','CK.sql') { Copy-Item -LiteralPath (Join-Path $Runner "seeds\C52\$f") -Destination (Join-Path $root $f) }
  Write-Chain $root 'E' @('E1', 'E2'); Write-Chain $root 'G' @('G')
  Manifest $root 'MANIFEST_inputs.sha256' $InF
  Run-CK $root 'PRE'
  $t1 = Get-Date
  if ($a.mode -eq 'SER') {
    foreach ($ch in 'E', 'G') { $s = Get-Date; $p = Start-Process -FilePath 'cmd.exe' -ArgumentList @('/c', "`"$root\chain_$ch.cmd`"") -NoNewWindow -Wait -PassThru
      Set-Content -Path (Join-Path $root "RUN_$ch.exit") -Value ("{0},{1},{2}" -f $p.ExitCode, [math]::Round(((Get-Date) - $s).TotalSeconds, 1), (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
      Log ("  {0} chain {1} exit={2}" -f $a.arm, $ch, $p.ExitCode) }
  } else {
    $pe = Start-Process -FilePath 'cmd.exe' -ArgumentList @('/c', "`"$root\chain_E.cmd`"") -NoNewWindow -PassThru; $null = $pe.Handle
    $pg = Start-Process -FilePath 'cmd.exe' -ArgumentList @('/c', "`"$root\chain_G.cmd`"") -NoNewWindow -PassThru; $null = $pg.Handle
    $pe.WaitForExit(); $pg.WaitForExit()
    foreach ($z in @(@('E', $pe), @('G', $pg))) { $pp = $z[1]
      Set-Content -Path (Join-Path $root "RUN_$($z[0]).exit") -Value ("{0},{1},{2}" -f $pp.ExitCode, [math]::Round(($pp.ExitTime - $t1).TotalSeconds, 1), $pp.ExitTime.ToString('yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
      Log ("  {0} chain {1} exit={2}" -f $a.arm, $z[0], $pp.ExitCode) }
  }
  $wall = [math]::Round(((Get-Date) - $t1).TotalSeconds, 1)
  Set-Content -Path (Join-Path $root 'PERF.csv') -Value @('mode,wall_s', ("{0},{1}" -f $a.mode, $wall)) -Encoding ASCII
  Log ("  {0} {1} wall_s={2}" -f $a.arm, $a.mode, $wall)
  Run-CK $root 'POST'
  Manifest $root 'MANIFEST_outputs.sha256' $OutF
}
# ---------------- Arms ----------------
foreach ($cid in $Controls) {
  Log "$cid arms"
  if (Test-Path (Join-Path $Runner "seeds\$cid\SMOKE")) {
    Run-SmokeArm $cid 'B' @('RA', 'RB') '-'
    foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) { Run-SmokeArm $cid $a.arm @($a.paths -split '\+') $a.code_seeds }
    continue }
  if (Test-Path (Join-Path $Runner "seeds\$cid\DETFIT")) {
    Run-FitArm $cid ([pscustomobject]@{ arm = 'REF'; ra_order = 'canonical'; rb_order = '-'; thresh = '1e-14'; rb_drop = '-'; regime = '-' })
    foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) { Run-FitArm $cid $a }
    continue }
  if (Test-Path (Join-Path $Runner "seeds\$cid\SQLCONC")) {
    foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) { Run-SqlArm $cid $a }
    continue }
  throw "$cid has no v4 arm type marker"
}
# ---------------- Summarize ----------------
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'eval_b4.R')`"", "`"$W`"", "`"$Frozen`"", ($Controls -join ',')) -NoNewWindow -Wait -PassThru `
      -RedirectStandardOutput (Join-Path $W "SUMMARIZE_stdout_$Batch.txt") -RedirectStandardError (Join-Path $W "SUMMARIZE_stderr_$Batch.txt")
Log ("summarize exit=" + $p.ExitCode)
if (Test-Path (Join-Path $W 'RUN_SUMMARY.txt')) { Copy-Item (Join-Path $W 'RUN_SUMMARY.txt') (Join-Path $W "RUN_SUMMARY_$Batch.txt") -Force }
foreach ($cid in $Controls) {
  $ev = Join-Path $W "$cid\evidence"; New-Item -ItemType Directory -Force -Path $ev | Out-Null
  $lines = foreach ($sub in 'arms', 'smoke') { $d = Join-Path $W "$cid\$sub"; if (-not (Test-Path $d)) { continue }
    foreach ($arm in Get-ChildItem -Directory $d | Sort-Object Name) { foreach ($mf in 'MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { $q = Join-Path $arm.FullName $mf
      if (Test-Path $q) { Get-Content $q | ForEach-Object { "$sub/$($arm.Name)/$mf :: $_" } } } } }
  Set-Content -Path (Join-Path $ev "$($cid)_ARM_MANIFESTS.txt") -Value $lines -Encoding UTF8
  $l2 = Get-ChildItem -File $ev | Where-Object { $_.Name -ne "$($cid)_EVIDENCE.sha256" } | Sort-Object Name | ForEach-Object { "{0}  {1}" -f (Get-Sha $_.FullName), $_.Name }
  Set-Content -Path (Join-Path $ev "$($cid)_EVIDENCE.sha256") -Value $l2 -Encoding UTF8
}
Log ("DONE batch=$Batch elapsed_min=" + [math]::Round(((Get-Date) - $t0).TotalMinutes, 2))
