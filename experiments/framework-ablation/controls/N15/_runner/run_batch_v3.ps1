# N15 ablation runner v3 (Chicago 311 frozen pack). Unattended; Windows PowerShell 5.1.
# v3 = v2 + Stage-5-only arms (seeds\<CID>\S5ONLY) and serial-vs-concurrent arms (seeds\C45\PARALLEL); summarizer eval_b3.R.
# v2 = v1 + optional Stage-4 receipt / workflow gate / Stage-5 step for controls with seeds\<CID>\STAGE45, + those outputs hashed.
# Usage: powershell -ExecutionPolicy Bypass -File "<WORK>\runner\run_batch_v3.ps1" -Batch b3 -Controls C32,C35,C36,C15,C45
# Reads the frozen pack read-only and writes ONLY under <WORK>. No git, no network, no DB writes; MySQL gets one read-only COUNT.
# Fixes the C27_C33 manifest defect: the RUN_* filter is now case-sensitive (-clike), so run_RA.R/run_RB.R stay in MANIFEST_inputs.
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
foreach ($c in $Controls) { if (Test-Path (Join-Path $W "$c\arms")) { throw "$c\arms already exists - this runner never overwrites; move it aside to rerun." } }
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
}
$ok = $true
foreach ($k in $expect.Keys) { $p = Join-Path $Frozen $k; $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $expect[$k]); if (-not $m) { $ok = $false }; $pf.Add(("frozen {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $k)) }
foreach ($line in Get-Content (Join-Path $Runner "SEEDS_$Batch.sha256")) { if (-not $line.Trim()) { continue }
  $hh, $rel = $line -split '  ', 2; $p = Join-Path $Runner ($rel -replace '/', '\'); $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $hh); if (-not $m) { $ok = $false }; $pf.Add(("seed   {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $rel)) }
$ErrorActionPreference = 'Continue'
$rv = & $Rscript -e "cat(R.version.string); for (p in c('dplyr','readr','lubridate','stringr','tidyr','tibble','digest')) cat(' |', p, as.character(packageVersion(p)))" 2>&1
$pf.Add("R: $rv"); if ("$rv" -notmatch 'digest') { $ok = $false; $pf.Add('FAIL: R package digest missing') }
try { $q = & $Mysql --login-path=chicago311 -N -B -e "SELECT 'src_open_candidates', COUNT(*) FROM chicago311.src_open_candidates UNION ALL SELECT 'src_peer_stats', COUNT(*) FROM chicago311.src_peer_stats;" 2>&1
  $pf.Add("mysql (INFO, read-only; expect 245193 / 104): " + (($q | ForEach-Object { "$_" }) -join ' ; ')) } catch { $pf.Add("mysql (INFO): not run: $($_.Exception.Message)") }
$ErrorActionPreference = 'Stop'
$pf.Add("preflight gating result: $(if ($ok) {'PASS'} else {'FAIL'})")
Set-Content -Path (Join-Path $W 'PREFLIGHT.txt') -Value $pf -Encoding UTF8; $pf | ForEach-Object { Log $_ }
if (-not $ok) { Log 'PREFLIGHT FAIL - stopping; nothing executed.'; exit 2 }
# ---------------- Source variants (deterministic, from the frozen source) ----------------
$VD = Join-Path $W '_variants'
$needVar = @($Controls | Where-Object { -not ((Test-Path (Join-Path $Runner "seeds\$_\S5ONLY")) -or (Test-Path (Join-Path $Runner "seeds\$_\PARALLEL"))) }).Count -gt 0
if (-not $needVar) { Log 'source variants: not used by these controls (S5ONLY/PARALLEL); skipped' }
if ($needVar -and -not (Test-Path (Join-Path $VD 'VARIANTS.tsv'))) {
  $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'source_variants.R')`"", "`"$Frozen`"", "`"$VD`"") -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput (Join-Path $W "VARIANTS_stdout_$Batch.txt") -RedirectStandardError (Join-Path $W "VARIANTS_stderr_$Batch.txt")
  Log "source_variants exit=$($p.ExitCode)"; if ($p.ExitCode -ne 0) { throw 'source_variants.R failed' }
}
if ($needVar) { foreach ($v in Import-Csv -Delimiter "`t" -Path (Join-Path $VD 'VARIANTS.tsv')) { $h = Get-Sha (Join-Path $VD "$($v.variant)\$($v.file)")
  if ($h -ne $v.sha256) { throw "variant hash mismatch $($v.variant)/$($v.file)" }; Log ("variant OK {0} {1} {2} {3}" -f $v.variant, $v.file, $h, $v.note) } }
# ---------------- Arm helpers ----------------
function New-Arm([string]$cid, [string]$arm, [bool]$withRA, [bool]$withRB, [string]$srcVariant) {
  $root = Join-Path $W "$cid\arms\$arm"; New-Item -ItemType Directory -Force -Path (Join-Path $root 'data\source') | Out-Null
  foreach ($f in 'src_open_candidates.csv','src_peer_stats.csv','src_extract_lineage.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
  if ($srcVariant -ne 'FROZEN') { foreach ($f in 'src_open_candidates.csv','src_peer_stats.csv') { Copy-Item -LiteralPath (Join-Path $VD "$srcVariant\$f") -Destination (Join-Path $root "data\source\$f") -Force } }
  if ($withRA) { New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-A') | Out-Null; Copy-Item -LiteralPath (Join-Path $Frozen 'R-A\run_RA.R') -Destination (Join-Path $root 'R-A\run_RA.R') }
  if ($withRB) { New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-B\R') | Out-Null
    Copy-Item -LiteralPath (Join-Path $Frozen 'R-B\run_RB.R') -Destination (Join-Path $root 'R-B\run_RB.R')
    foreach ($f in '00_config.R','10_io_parse.R','20_integrity_and_classify.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") } }
  return $root
}
function Manifest([string]$root, [string]$name) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' }
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
function Run-Path([string]$root, [string]$path) {
  $script = if ($path -eq 'RA') { Join-Path $root 'R-A\run_RA.R' } else { Join-Path $root 'R-B\run_RB.R' }
  $env:CHICAGO311_ROOT = $root; $s = Get-Date
  $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$script`"", 'all') -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput (Join-Path $root "RUN_$path.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$path.stderr.txt")
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1)
  Set-Content -Path (Join-Path $root "RUN_$path.exit") -Value ("{0},{1},{2}" -f $p.ExitCode, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3}" -f (Split-Path $root -Leaf), $path, $p.ExitCode, $secs); Remove-Item Env:\CHICAGO311_ROOT
}
function Hash-Outputs([string]$root) {
  $o = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' -or $_.Name -clike 'FRZ_*' -or $_.Name -in @('VALIDATION_FREEZE.sha256','ARM_SCRIPTS.txt','PERF.csv') -or $_.FullName -like '*\stage-05\*' -or $_.FullName -like '*\validation\*' -or $_.FullName -like '*\docs\*' }
  $lines = $o | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root 'MANIFEST_outputs.sha256') -Value $lines -Encoding UTF8
}
function Run-R([string]$root, [string]$tag, [string[]]$rargs) {
  $env:CHICAGO311_ROOT = $root; $s = Get-Date
  $p = Start-Process -FilePath $Rscript -ArgumentList $rargs -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput (Join-Path $root "RUN_$tag.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$tag.stderr.txt")
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1)
  Set-Content -Path (Join-Path $root "RUN_$tag.exit") -Value ("{0},{1},{2}" -f $p.ExitCode, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3}" -f (Split-Path $root -Leaf), $tag, $p.ExitCode, $secs); Remove-Item Env:\CHICAGO311_ROOT
}
function Stage45([string]$root) {   # ablated regime: Stage 5 runs whatever the gate says; the gate result is recorded
  $H = Join-Path $Runner 'stage45'
  Run-R $root 'S4VAL'  @("`"$(Join-Path $H 'build_validated_action_list.R')`"")
  Run-R $root 'S4RCPT' @("`"$(Join-Path $H 'stage45_receipt.R')`"", "`"$root`"", "`"$Runner`"")
  Run-R $root 'GATE'   @("`"$(Join-Path $H 'workflow_gate.R')`"", "`"$root`"")
  Run-R $root 'S5'     @("`"$(Join-Path $H 'run_deeper_analysis.R')`"")
}
# ---------------- v3: Stage-5-only arms ----------------
$VFILES = @('R-A\outputs\RA_classifications.csv', 'R-B\outputs\RB_kappa_grid_counts.csv', 'outputs\validated_action_list.csv')
function New-S5Arm([string]$cid, [string]$arm) {
  $root = Join-Path $W "$cid\arms\$arm"
  foreach ($vf in $VFILES) { $dst = Join-Path $root $vf; New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null; Copy-Item -LiteralPath (Join-Path $Frozen $vf) -Destination $dst }
  $fl = foreach ($vf in $VFILES) { $q = Join-Path $root $vf; "{0}  {1}  {2}" -f (Get-Sha $q), (Get-Item -LiteralPath $q).Length, $vf }
  Set-Content -Path (Join-Path $root 'VALIDATION_FREEZE.sha256') -Value $fl -Encoding UTF8
  return $root
}
function Freeze-Check([string]$root, [string]$tag) {
  $res = foreach ($fline in Get-Content (Join-Path $root 'VALIDATION_FREEZE.sha256')) { $parts = $fline.Trim([char]0xFEFF) -split '  ', 3; $q = Join-Path $root $parts[2]
    $h2 = if (Test-Path -LiteralPath $q) { Get-Sha $q } else { 'MISSING' }; "{0}  {1}  {2}" -f $(if ($h2 -eq $parts[0]) {'UNCHANGED'} else {'CHANGED'}), $h2, $parts[2] }
  Set-Content -Path (Join-Path $root "FRZ_$tag.txt") -Value $res -Encoding UTF8
  Log ("  {0} FRZ_{1} changed={2}" -f (Split-Path $root -Leaf), $tag, @($res | Where-Object { $_ -like 'CHANGED*' }).Count)
}
function Run-S5Arm([string]$cid, [string]$arm, [string]$pre, [string]$s5) {
  $root = New-S5Arm $cid $arm
  $sl = @(); if ($pre -ne '-') { $sl += ("{0}  PRE  runner/{1}" -f (Get-Sha (Join-Path $Runner ($pre -replace '/', '\'))), $pre) }
  $sl += ("{0}  S5  runner/{1}" -f (Get-Sha (Join-Path $Runner ($s5 -replace '/', '\'))), $s5); Set-Content -Path (Join-Path $root 'ARM_SCRIPTS.txt') -Value $sl -Encoding UTF8
  Manifest $root 'MANIFEST_inputs.sha256'
  if ($pre -ne '-') { Run-R $root 'PRE' @("`"$(Join-Path $Runner ($pre -replace '/', '\'))`"") }
  Freeze-Check $root 'PRE'
  Run-R $root 'S5' @("`"$(Join-Path $Runner ($s5 -replace '/', '\'))`"")
  Freeze-Check $root 'POST'
  Hash-Outputs $root
  foreach ($vf in 'R-A\outputs\RA_classifications.csv', 'outputs\validated_action_list.csv') { $q = Join-Path $root $vf   # hashed above; drop unchanged big copies
    if ((Test-Path -LiteralPath $q) -and ((Get-Sha $q) -eq (Get-Sha (Join-Path $Frozen $vf)))) { Remove-Item -LiteralPath $q } }
}
# ---------------- v3: serial vs concurrent R-A/R-B ----------------
function Mem-Sample { $pl = Get-Process -Name Rscript, Rterm, R -ErrorAction SilentlyContinue; if ($pl) { [double](($pl | Measure-Object -Property WorkingSet64 -Sum).Sum) } else { 0.0 } }
function Start-RPath([string]$root, [string]$path) {
  $script = if ($path -eq 'RA') { Join-Path $root 'R-A\run_RA.R' } else { Join-Path $root 'R-B\run_RB.R' }
  $env:CHICAGO311_ROOT = $root
  $pr = Start-Process -FilePath $Rscript -ArgumentList @("`"$script`"", 'all') -NoNewWindow -PassThru `
        -RedirectStandardOutput (Join-Path $root "RUN_$path.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$path.stderr.txt")
  $null = $pr.Handle; return @{ P = $pr; T0 = (Get-Date); Path = $path }
}
function Finish-RPath([string]$root, $st) {
  $st.P.WaitForExit(); $secs = [math]::Round(($st.P.ExitTime - $st.T0).TotalSeconds, 1)
  Set-Content -Path (Join-Path $root "RUN_$($st.Path).exit") -Value ("{0},{1},{2}" -f $st.P.ExitCode, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3}" -f (Split-Path $root -Leaf), $st.Path, $st.P.ExitCode, $secs)
}
function Run-Pair([string]$root, [string]$mode) {
  $free0 = [int]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024); $peak = 0.0; $t1 = Get-Date
  if ($mode -eq 'SER') {
    foreach ($pth in 'RA', 'RB') { $st = Start-RPath $root $pth; while (-not $st.P.HasExited) { $m = Mem-Sample; if ($m -gt $peak) { $peak = $m }; Start-Sleep -Milliseconds 500 }; Finish-RPath $root $st }
  } else {
    $sa = Start-RPath $root 'RA'; $sb = Start-RPath $root 'RB'
    while (-not ($sa.P.HasExited -and $sb.P.HasExited)) { $m = Mem-Sample; if ($m -gt $peak) { $peak = $m }; Start-Sleep -Milliseconds 500 }
    Finish-RPath $root $sa; Finish-RPath $root $sb
  }
  Remove-Item Env:\CHICAGO311_ROOT -ErrorAction SilentlyContinue
  $wall = [math]::Round(((Get-Date) - $t1).TotalSeconds, 1); $pk = [math]::Round($peak / 1MB, 0)
  Set-Content -Path (Join-Path $root 'PERF.csv') -Value @('mode,wall_s,peak_ws_mb,free_mb_before', ("{0},{1},{2},{3}" -f $mode, $wall, $pk, $free0)) -Encoding ASCII
  Log ("  {0} {1} wall_s={2} peak_ws_mb={3} free_mb_before={4}" -f (Split-Path $root -Leaf), $mode, $wall, $pk, $free0)
  return $pk
}
# ---------------- Arms ----------------
foreach ($cid in $Controls) {
  Log "$cid arms"
  if (Test-Path (Join-Path $Runner "seeds\$cid\S5ONLY")) {
    Run-S5Arm $cid 'B' '-' 'stage45/run_deeper_analysis.R'
    foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) { Run-S5Arm $cid $a.arm $a.pre $a.s5 }
    continue
  }
  if (Test-Path (Join-Path $Runner "seeds\$cid\PARALLEL")) {
    $r = New-Arm $cid 'B' $true $true 'FROZEN'; Manifest $r 'MANIFEST_inputs.sha256'; $serPeak = Run-Pair $r 'SER'; Hash-Outputs $r
    Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')
    $freeNow = [int]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024); $need = 2 * $serPeak + 2048
    $memok = ($freeNow -ge $need)
    Set-Content -Path (Join-Path $W "$cid\MEMCHECK.txt") -Value ("declared rule: free physical memory >= 2 x serial peak working set + 2048 MB before any concurrent arm; serial peak {0} MB, need {1} MB, free {2} MB -> {3}" -f $serPeak, $need, $freeNow, $(if ($memok) {'PASS'} else {'FAIL'})) -Encoding UTF8
    Log ("  MEMCHECK serial_peak={0} need={1} free={2} {3}" -f $serPeak, $need, $freeNow, $(if ($memok) {'PASS'} else {'FAIL'}))
    foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) {
      if ($a.mode -eq 'PAR' -and -not $memok) { Log "  $($a.arm) skipped: MEMCHECK FAIL"; continue }
      $r = New-Arm $cid $a.arm $true $true 'FROZEN'; Manifest $r 'MANIFEST_inputs.sha256'; $null = Run-Pair $r $a.mode; Hash-Outputs $r
      Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')
    }
    continue
  }
  $s45 = Test-Path (Join-Path $Runner "seeds\$cid\STAGE45")
  $r = New-Arm $cid 'B' $true $true 'FROZEN'; Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RA'; Run-Path $r 'RB'; if ($s45) { Stage45 $r }; Hash-Outputs $r
  Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')
  foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) {
    $runs = $a.paths -split '\+'; $withRA = $runs -contains 'RA'; $withRB = $runs -contains 'RB'
    if ($withRA -and $withRB -and $a.ra_source -ne $a.rb_source) { throw "$cid $($a.arm): both paths must read the same source" }
    $src = if ($withRB) { $a.rb_source } else { $a.ra_source }
    $r = New-Arm $cid $a.arm $withRA $withRB $src
    if ($a.code_seeds -ne '-') { foreach ($s in $a.code_seeds -split ';') { $from, $to = $s -split '>', 2; Copy-Item -LiteralPath (Join-Path $Runner ($from -replace '/', '\')) -Destination (Join-Path $r $to) -Force } }
    Manifest $r 'MANIFEST_inputs.sha256'
    foreach ($p in $runs) { Run-Path $r $p }
    if ($s45) { if (-not ($withRA -and $withRB)) { throw "$cid $($a.arm): STAGE45 arms must run both paths" }; Stage45 $r }
    Hash-Outputs $r
    Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')   # hashed in MANIFEST_inputs; saves ~118 MB per arm
  }
}
# ---------------- Summarize ----------------
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'eval_b3.R')`"", "`"$W`"", "`"$Frozen`"", ($Controls -join ',')) -NoNewWindow -Wait -PassThru `
      -RedirectStandardOutput (Join-Path $W "SUMMARIZE_stdout_$Batch.txt") -RedirectStandardError (Join-Path $W "SUMMARIZE_stderr_$Batch.txt")
Log ("summarize exit=" + $p.ExitCode)
if (Test-Path (Join-Path $W 'RUN_SUMMARY.txt')) { Copy-Item (Join-Path $W 'RUN_SUMMARY.txt') (Join-Path $W "RUN_SUMMARY_$Batch.txt") -Force }
foreach ($cid in $Controls) {
  $ev = Join-Path $W "$cid\evidence"; New-Item -ItemType Directory -Force -Path $ev | Out-Null
  $lines = foreach ($arm in Get-ChildItem -Directory (Join-Path $W "$cid\arms")) { foreach ($mf in 'MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { Get-Content (Join-Path $arm.FullName $mf) | ForEach-Object { "$($arm.Name)/$mf :: $_" } } }
  Set-Content -Path (Join-Path $ev "$($cid)_ARM_MANIFESTS.txt") -Value $lines -Encoding UTF8
  $l2 = Get-ChildItem -File $ev | Where-Object { $_.Name -ne "$($cid)_EVIDENCE.sha256" } | Sort-Object Name | ForEach-Object { "{0}  {1}" -f (Get-Sha $_.FullName), $_.Name }
  Set-Content -Path (Join-Path $ev "$($cid)_EVIDENCE.sha256") -Value $l2 -Encoding UTF8
}
Log ("DONE batch=$Batch elapsed_min=" + [math]::Round(((Get-Date) - $t0).TotalMinutes, 2))
