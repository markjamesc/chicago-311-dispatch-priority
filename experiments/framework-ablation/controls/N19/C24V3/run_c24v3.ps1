# C24 v3 runner (catalog #24): COLLAPSED arm R-A/R-B run CHUNKED. R phase only; SQL extracts and arm B are carried from C24V2 (N18) unchanged.
# Windows PowerShell 5.1. Reads N18 evidence read-only (extract is hard-linked, not copied); writes ONLY under <WORK>\C24V3 and <WORK>\RUNNER_LOG_C24V3.txt. No git, no network, no MySQL.
param(
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311',
  [string]$V2      = 'C:\Users\Mark\Documents\R Working Directory\ablation-runs\N18\C24V2',
  [int]$ChunkRows  = 250000
)
$ErrorActionPreference = 'Stop'
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path; $W = Split-Path -Parent $Runner; $C = Join-Path $W 'C24V3'
if (Test-Path (Join-Path $C 'arms')) { throw 'C24V3\arms already exists - this runner never overwrites.' }
New-Item -ItemType Directory -Force -Path $C | Out-Null
$LogF = Join-Path $W 'RUNNER_LOG_C24V3.txt'; $t0 = Get-Date
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path $LogF -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
Log "START C24V3 work=$W v2=$V2 chunk_rows=$ChunkRows"
# ---------------- Preflight (gating) ----------------
$pf = New-Object System.Collections.Generic.List[string]; $ok = $true
$ex = Import-Csv (Join-Path $V2 'EXTRACTS.csv'); $exB = $ex | Where-Object arm -eq 'B'; $exC = $ex | Where-Object arm -eq 'COLLAPSED'
$srcB = Join-Path $V2 'arms\B\data\source\src_open_candidates.csv'; $srcC = Join-Path $V2 'arms\COLLAPSED\data\source\src_open_candidates.csv'
$expect = [ordered]@{
  'data\source\src_peer_stats.csv'      = 'cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58'
  'R-B\R\00_config.R'                   = '6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b'
  'R-B\R\10_io_parse.R'                 = '40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a'
  'R-B\R\20_integrity_and_classify.R'   = '72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99'
  'R-B\R\40_fixtures.R'                 = '2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e'
  'R-A\run_RA.R'                        = 'f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587'
  'R-B\run_RB.R'                        = '6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd'
}
foreach ($k in $expect.Keys) { $p = Join-Path $Frozen $k; $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $expect[$k]); if (-not $m) { $ok = $false }; $pf.Add(("frozen {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $k)) }
foreach ($line in Get-Content (Join-Path $Runner 'SEEDS_C24V3.sha256')) { if (-not $line.Trim()) { continue }
  $hh, $rel = $line -split '  ', 2; $p = Join-Path $Runner ($rel -replace '/', '\'); $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $hh); if (-not $m) { $ok = $false }; $pf.Add(("seed   {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $rel)) }
foreach ($e in @(@($exB, $srcB), @($exC, $srcC))) { $h = if (Test-Path -LiteralPath $e[1]) { Get-Sha $e[1] } else { 'MISSING' }
  $m = ($h -eq $e[0].sha256); if (-not $m) { $ok = $false }; $pf.Add(("extract {0} {1} {2} (EXTRACTS.csv of C24V2: {3})" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $e[0].arm, $e[0].sha256)) }
$ck1 = (Get-Content (Join-Path $V2 'CK_PRE.tsv')) -join ' | '; $ck2 = (Get-Content (Join-Path $V2 'CK_POST.tsv')) -join ' | '
$m = ($ck1 -eq $ck2 -and $ck1); if (-not $m) { $ok = $false }; $pf.Add("C24V2 checksum bracket carried: $(if ($m) {'MATCH'} else {'MISMATCH'})")
$ErrorActionPreference = 'Continue'
$rv = & $Rscript -e "cat(R.version.string); for (p in c('dplyr','readr','digest')) cat(' |', p, as.character(packageVersion(p)))" 2>&1; $pf.Add("R: $rv")
$cs = Get-CimInstance Win32_ComputerSystem; $os = Get-CimInstance Win32_OperatingSystem; $dk = Get-PSDrive C
$pf.Add(("machine (INFO): {0}, logical processors {1}, RAM {2} MB, free {3} MB, C: free {4} GB" -f $env:COMPUTERNAME, $cs.NumberOfLogicalProcessors, [int]($os.TotalVisibleMemorySize/1024), [int]($os.FreePhysicalMemory/1024), [int]($dk.Free/1GB)))
$ErrorActionPreference = 'Stop'
$pf.Add("preflight gating result: $(if ($ok) {'PASS'} else {'FAIL'})")
Set-Content -Path (Join-Path $C 'PREFLIGHT_C24V3.txt') -Value $pf -Encoding UTF8; $pf | ForEach-Object { Log $_ }
if (-not $ok) { Log 'PREFLIGHT FAIL - stopping; nothing executed.'; exit 2 }
# ---------------- helpers ----------------
function Manifest([string]$root, [string]$name, [scriptblock]$filter) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object $filter
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
$InF  = { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' -and $_.Name -notlike '*.partial' }
$OutF = { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' }
function Run-R([string]$root, [string]$tag, [string]$script, [int]$capSec) {
  $gs = Get-Date   # v3 RAM pre-check: wait (not kill) until >= 6144 MB free (chunked run needs only a few GB); the 2048 MB kill guard below is UNCHANGED from v2
  while ($true) { $fr = [long]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024)
    if ($fr -ge 6144) { Log ("  RAM pre-check PASS before COLLAPSED {0}: free_MB={1} waited_s={2}" -f $tag, $fr, [int]((Get-Date) - $gs).TotalSeconds); break }
    if (((Get-Date) - $gs).TotalMinutes -gt 60) { Log ("  RAM pre-check TIMEOUT 60 min before {0}: free_MB={1}" -f $tag, $fr); break }
    Start-Sleep -Seconds 30 }
  $env:CHICAGO311_ROOT = $root; $env:C24_CHUNK_ROWS = [string]$ChunkRows; $s = Get-Date; $minFree = [long]1e12; $peak = [long]0; $kill = ''
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
  Remove-Item Env:\CHICAGO311_ROOT, Env:\C24_CHUNK_ROWS -ErrorAction SilentlyContinue
}
# ---------------- Carry-over from C24V2 (copies; originals untouched) ----------------
foreach ($f in 'EXTRACTS.csv','SQL_TIMES.csv','CK_PRE.tsv','CK_POST.tsv','Q_COUNTS.tsv','SQL_CK_PRE.err','SQL_CK_POST.err','SQL_Q_COUNTS.err','SQL_X_SEP.err','SQL_X_FULL.err') { Copy-Item -LiteralPath (Join-Path $V2 $f) -Destination (Join-Path $C $f) }
$bsrc = Join-Path $V2 'arms\B'; $bdst = Join-Path $C 'arms\B'
New-Item -ItemType Directory -Force -Path (Join-Path $bdst 'R-A\outputs'), (Join-Path $bdst 'R-B\outputs') | Out-Null
foreach ($f in 'R-A\outputs\RA_classifications.csv','R-A\outputs\RA_fixture_results.csv','R-A\outputs\RA_portfolio_counts.csv','R-B\outputs\RB_classifications.csv','R-B\outputs\RB_fixture_results.csv','R-B\outputs\RB_portfolio_counts.csv','R-B\outputs\RB_kappa_grid_counts.csv','RUN_RA.exit','RUN_RB.exit','RUN_RA.stdout.txt','RUN_RA.stderr.txt','RUN_RB.stdout.txt','RUN_RB.stderr.txt','MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { Copy-Item -LiteralPath (Join-Path $bsrc $f) -Destination (Join-Path $bdst $f) }
# ---------------- COLLAPSED arm (chunked) ----------------
$root = Join-Path $C 'arms\COLLAPSED'
New-Item -ItemType Directory -Force -Path (Join-Path $root 'data\source'), (Join-Path $root 'R-A'), (Join-Path $root 'R-B\R') | Out-Null
Copy-Item -LiteralPath (Join-Path $Runner 'code\run_RA_chunked.R') -Destination (Join-Path $root 'R-A\run_RA_chunked.R')
Copy-Item -LiteralPath (Join-Path $Runner 'code\run_RB_chunked.R') -Destination (Join-Path $root 'R-B\run_RB_chunked.R')
foreach ($f in '00_config.R','10_io_parse.R','20_integrity_and_classify.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") }
foreach ($f in 'src_peer_stats.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
Copy-Item -LiteralPath (Join-Path $V2 'arms\COLLAPSED\data\source\src_extract_lineage.csv') -Destination (Join-Path $root 'data\source\src_extract_lineage.csv')
$null = New-Item -ItemType HardLink -Path (Join-Path $root 'data\source\src_open_candidates.csv') -Target $srcC
Log 'R phase (COLLAPSED CHUNKED; R-A then R-B; cap 4 h each; kill if free RAM < 2048 MB - guard unchanged)'
Manifest $root 'MANIFEST_inputs.sha256' $InF
Run-R $root 'RA' (Join-Path $root 'R-A\run_RA_chunked.R') 14400
$ra = (Get-Content (Join-Path $root 'RUN_RA.exit'))[0].Split(',')[0]
if ($ra -eq 'MEMKILL' -or $ra -eq 'TIMEOUT') { Log "RA $ra - stopping, no retry, no RB" ; Manifest $root 'MANIFEST_outputs.sha256' $OutF; exit 5 }
Run-R $root 'RB' (Join-Path $root 'R-B\run_RB_chunked.R') 14400
Manifest $root 'MANIFEST_outputs.sha256' $OutF
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'eval_c24v3.R')`"", "`"$W`"", "`"$Frozen`"") -NoNewWindow -Wait -PassThru -RedirectStandardOutput (Join-Path $C 'SUMMARIZE_stdout.txt') -RedirectStandardError (Join-Path $C 'SUMMARIZE_stderr.txt')
Log ("summarize exit=" + $p.ExitCode)
$ev = Join-Path $C 'evidence'; New-Item -ItemType Directory -Force -Path $ev | Out-Null
$lines = foreach ($arm in Get-ChildItem -Directory (Join-Path $C 'arms') | Sort-Object Name) { foreach ($mf in 'MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { $q = Join-Path $arm.FullName $mf
  if (Test-Path $q) { Get-Content $q | ForEach-Object { "arms/$($arm.Name)/$mf :: $_" } } } }
Set-Content -Path (Join-Path $ev 'C24V3_ARM_MANIFESTS.txt') -Value $lines -Encoding UTF8
foreach ($f in 'C24V3_RESULTS.md','C24V3_arms.csv','EXTRACTS.csv','SQL_TIMES.csv','CK_PRE.tsv','CK_POST.tsv','Q_COUNTS.tsv','PREFLIGHT_C24V3.txt') { if (Test-Path (Join-Path $C $f)) { Copy-Item (Join-Path $C $f) $ev -Force } }
foreach ($t in 'RA','RB') { foreach ($x in 'stdout.txt','stderr.txt','exit') { Copy-Item (Join-Path $root "RUN_$t.$x") (Join-Path $ev "COLLAPSED_RUN_$t.$x") -Force } }
$l2 = Get-ChildItem -File $ev | Where-Object { $_.Name -ne 'C24V3_EVIDENCE.sha256' } | Sort-Object Name | ForEach-Object { "{0}  {1}" -f (Get-Sha $_.FullName), $_.Name }
Set-Content -Path (Join-Path $ev 'C24V3_EVIDENCE.sha256') -Value $l2 -Encoding UTF8
Log ("DONE C24V3 elapsed_min=" + [math]::Round(((Get-Date) - $t0).TotalMinutes, 2))
