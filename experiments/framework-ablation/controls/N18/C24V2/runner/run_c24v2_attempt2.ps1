# C24 v2 ATTEMPT 2 of the COLLAPSED R steps only (wrapper; same Run-R/guard/Manifest/summarize code as run_c24v2.ps1, extracted verbatim). SQL/B arm not rerun.
param(
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311',
  [string]$Mysql   = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path; $W = Split-Path -Parent $Runner; $C = Join-Path $W 'C24V2'; $SD = Join-Path $Runner 'seeds\C24'
$LogF = Join-Path $W 'RUNNER_LOG_C24V2.txt'; $t0 = Get-Date
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path $LogF -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }
Log "START C24V2 ATTEMPT2 (collapsed R-A, R-B only) work=$W"
# ---------------- helpers ----------------
function Manifest([string]$root, [string]$name, [scriptblock]$filter) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object $filter
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
$InF  = { $_.Name -cnotlike 'RUN_*' -and $_.Name -notlike 'MANIFEST_*' -and $_.FullName -notlike '*\outputs\*' }
$OutF = { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' }
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
function Wait-Ram([string]$what) { $s = Get-Date
  while ($true) { $fr = [long]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1024)
    if ($fr -ge 21500) { Log ("  attempt2 pre-check PASS before {0}: free_MB={1}" -f $what, $fr); return $true }
    if (((Get-Date) - $s).TotalSeconds -gt 300) { Log ("  attempt2 pre-check FAIL before {0}: free_MB={1} (need 21500) after 5 min wait; stopping" -f $what, $fr); return $false }
    Start-Sleep -Seconds 15 } }
$root = Join-Path $C 'arms\COLLAPSED'
Log 'attempt2 R phase (COLLAPSED only; R-A then R-B; cap 4 h each; kill if free RAM < 2048 MB)'
if (-not (Wait-Ram 'RA')) { exit 4 }
Run-R $root 'RA' (Join-Path $root 'R-A\run_RA.R') 14400
$ra = (Get-Content (Join-Path $root 'RUN_RA.exit'))[0].Split(',')[0]
if ($ra -eq 'MEMKILL' -or $ra -eq 'TIMEOUT') { Log "attempt2 RA $ra - stopping, no retry, no RB"; exit 5 }
if (-not (Wait-Ram 'RB')) { exit 4 }
Run-R $root 'RB' (Join-Path $root 'R-B\run_RB.R') 14400
Manifest $root 'MANIFEST_outputs.sha256' $OutF
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
