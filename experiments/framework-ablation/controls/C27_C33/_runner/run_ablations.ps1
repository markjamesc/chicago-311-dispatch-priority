# C27 + C33 ablation runner (Chicago 311 frozen pack). Unattended; Windows PowerShell 5.1.
# Usage (from any prompt):  powershell -ExecutionPolicy Bypass -File "<WORK>\runner\run_ablations.ps1"
# Reads the frozen pack read-only; writes ONLY under <WORK> (the folder containing runner\).
# No git, no network, no DB writes. MySQL is touched only by one read-only SELECT COUNT preflight.
param(
  [string]$Rscript = 'C:\Program Files\R\R-4.6.1\bin\Rscript.exe',
  [string]$Frozen  = 'C:\Users\Mark\Documents\R Working Directory\chicago311',
  [string]$Mysql   = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe'
)
$ErrorActionPreference = 'Stop'
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path
$W = Split-Path -Parent $Runner
$t0 = Get-Date
$pf = New-Object System.Collections.Generic.List[string]
function Log($s) { $line = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s; Write-Host $line; Add-Content -Path (Join-Path $W 'RUNNER_LOG.txt') -Value $line -Encoding UTF8 }
function Get-Sha($p) { (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash.ToLower() }

foreach ($d in 'C33','C27') { if (Test-Path (Join-Path $W "$d\arms")) { throw "$d\arms already exists - this runner never overwrites; move it aside to rerun." } }
Log "START work=$W frozen=$Frozen"

# ---------------- Preflight (gating) ----------------
$expect = [ordered]@{
  'data\source\src_open_candidates.csv'   = 'ba089fcc51a0008bb1253ae6b8cdf8081af9562a2ad8bf3ff73e376fb83d81b9'
  'data\source\src_peer_stats.csv'        = 'cb78ae214891eaecd0cc3c48bffc52aef745ff14e5f666647d8abc215d79eb58'
  'R-A\run_RA.R'                          = 'f4e8993ca9c7d55a232795da6f2b84226ce8573b646521fa27fdf2029da58587'
  'R-B\run_RB.R'                          = '6786fcf5fbed21f4a7cae389ce90887dd08182fe2b8ba3e82e242f222336defd'
  'R-B\R\00_config.R'                     = '6c9b0e31772476db02c24cfe21335c6783b4b7adbebc8a74739c82a34c70450b'
  'R-B\R\10_io_parse.R'                   = '40e67d8360f3dc77c1c59455589a221ef1ade59d6c34f7c274ac0e9a5132154a'
  'R-B\R\20_integrity_and_classify.R'     = '72ac5def1875a6f695262fa74e9be446ebc1015f27368ef2b906dcfefb381d99'
  'R-B\R\40_fixtures.R'                   = '2ad4aa69cd3b3bd7dea5f08ef2e784dbdf53a64f8ff67b7622d4a4a1b6b7a07e'
  'R-A\outputs\RA_classifications.csv'    = 'c099e092feb237c8492feca12f0293c5875384e27375eb7a40991591d63ae0d9'
  'R-B\outputs\RB_classifications.csv'    = 'a0e42b8667b38baf6bc1e79090d06b1a7c62659926ea7a78185975b8fe6fe193'
}
$ok = $true
foreach ($k in $expect.Keys) {
  $p = Join-Path $Frozen $k
  $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $expect[$k]); if (-not $m) { $ok = $false }
  $pf.Add(("frozen {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $k))
}
foreach ($line in Get-Content (Join-Path $Runner 'SEEDS.sha256')) {
  if (-not $line.Trim()) { continue }
  $hh, $rel = $line -split '  ', 2
  $p = Join-Path $Runner ($rel -replace '/', '\')
  $h = if (Test-Path -LiteralPath $p) { Get-Sha $p } else { 'MISSING' }
  $m = ($h -eq $hh); if (-not $m) { $ok = $false }
  $pf.Add(("seed   {0} {1} {2}" -f $(if ($m) {'OK  '} else {'FAIL'}), $h, $rel))
}
$ErrorActionPreference = 'Continue'
$rv = & $Rscript -e "cat(R.version.string); for (p in c('dplyr','readr','lubridate','stringr','tidyr','tibble')) cat(' |', p, as.character(packageVersion(p)))" 2>&1
$pf.Add("R: $rv")
try {
  $q = & $Mysql --login-path=chicago311 -N -B -e "SELECT 'src_open_candidates', COUNT(*) FROM chicago311.src_open_candidates UNION ALL SELECT 'src_peer_stats', COUNT(*) FROM chicago311.src_peer_stats;" 2>&1
  $pf.Add("mysql (INFO, read-only; expect 245193 / 104): " + (($q | ForEach-Object { "$_" }) -join ' ; '))
} catch { $pf.Add("mysql (INFO): not run: $($_.Exception.Message)") }
$ErrorActionPreference = 'Stop'
$pf.Add("preflight gating result: $(if ($ok) {'PASS'} else {'FAIL'})")
Set-Content -Path (Join-Path $W 'PREFLIGHT.txt') -Value $pf -Encoding UTF8
$pf | ForEach-Object { Log $_ }
if (-not $ok) { Log 'PREFLIGHT FAIL - stopping; nothing executed.'; Set-Content (Join-Path $W 'RUN_SUMMARY.txt') (@('RUN_SUMMARY C27_C33: PREFLIGHT FAIL - no arms run') + $pf) -Encoding UTF8; exit 2 }

# ---------------- Arm helpers ----------------
function New-Arm([string]$cid, [string]$arm, [bool]$withRA, [bool]$withRB) {
  $root = Join-Path $W "$cid\arms\$arm"
  New-Item -ItemType Directory -Force -Path (Join-Path $root 'data\source') | Out-Null
  foreach ($f in 'src_open_candidates.csv','src_peer_stats.csv','src_extract_lineage.csv') { Copy-Item -LiteralPath (Join-Path $Frozen "data\source\$f") -Destination (Join-Path $root "data\source\$f") }
  if ($withRA) { New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-A') | Out-Null; Copy-Item -LiteralPath (Join-Path $Frozen 'R-A\run_RA.R') -Destination (Join-Path $root 'R-A\run_RA.R') }
  if ($withRB) {
    New-Item -ItemType Directory -Force -Path (Join-Path $root 'R-B\R') | Out-Null
    Copy-Item -LiteralPath (Join-Path $Frozen 'R-B\run_RB.R') -Destination (Join-Path $root 'R-B\run_RB.R')
    foreach ($f in '00_config.R','10_io_parse.R','20_integrity_and_classify.R','40_fixtures.R') { Copy-Item -LiteralPath (Join-Path $Frozen "R-B\R\$f") -Destination (Join-Path $root "R-B\R\$f") }
  }
  return $root
}
function Seed([string]$root, [string]$seedRel, [string]$destRel) {
  Copy-Item -LiteralPath (Join-Path $Runner $seedRel) -Destination (Join-Path $root $destRel) -Force
}
function Manifest([string]$root, [string]$name) {
  $files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.Name -notlike 'RUN_*' -and $_.Name -ne 'MANIFEST_inputs.sha256' -and $_.FullName -notlike '*\outputs\*' }
  $lines = $files | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root $name) -Value $lines -Encoding UTF8
}
function Run-Path([string]$root, [string]$path) {
  $script = if ($path -eq 'RA') { Join-Path $root 'R-A\run_RA.R' } else { Join-Path $root 'R-B\run_RB.R' }
  $env:CHICAGO311_ROOT = $root
  $s = Get-Date
  $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$script`"", 'all') -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput (Join-Path $root "RUN_$path.stdout.txt") -RedirectStandardError (Join-Path $root "RUN_$path.stderr.txt")
  $secs = [math]::Round(((Get-Date) - $s).TotalSeconds, 1)
  Set-Content -Path (Join-Path $root "RUN_$path.exit") -Value ("{0},{1},{2}" -f $p.ExitCode, $secs, (Get-Date -Format 'yyyy-MM-ddTHH:mm:sszzz')) -Encoding ASCII
  Log ("  {0} {1} exit={2} secs={3}" -f (Split-Path $root -Leaf), $path, $p.ExitCode, $secs)
  Remove-Item Env:\CHICAGO311_ROOT
}
function Hash-Outputs([string]$root) {
  $o = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.FullName -like '*\outputs\*' -or $_.Name -like 'RUN_*' }
  $lines = $o | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root 'MANIFEST_outputs.sha256') -Value $lines -Encoding UTF8
}

# ---------------- C33: Naive Clock Contract ----------------
Log 'C33 arms'
$r = New-Arm 'C33' 'B'  $true $true;  Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RA'; Run-Path $r 'RB'; Hash-Outputs $r
$r = New-Arm 'C33' 'X1' $false $true; Seed $r 'seeds\C33\X_RB_10_io_parse.R' 'R-B\R\10_io_parse.R'; Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RB'; Hash-Outputs $r
$r = New-Arm 'C33' 'X2' $true $false; Seed $r 'seeds\C33\X2_RA_run_RA.R' 'R-A\run_RA.R'; Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RA'; Hash-Outputs $r

# ---------------- C27: Fixtures on Both Paths ----------------
Log 'C27 arms'
$r = New-Arm 'C27' 'B' $true $true; Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RA'; Run-Path $r 'RB'; Hash-Outputs $r
$mut = Import-Csv -Delimiter "`t" -Path (Join-Path $Runner 'seeds\C27\MUTANTS.tsv')
foreach ($m in $mut) {
  $id = $m.mutant_id
  $r = New-Arm 'C27' $id $false $true; Seed $r "seeds\C27\$($id)_20_integrity_and_classify.R" 'R-B\R\20_integrity_and_classify.R'
  Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RB'; Hash-Outputs $r
  Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')   # input already hashed in MANIFEST_inputs; saves ~118 MB per mutant
}
foreach ($arm in 'C33\arms\B','C33\arms\X1','C33\arms\X2','C27\arms\B') { Remove-Item -LiteralPath (Join-Path $W "$arm\data\source\src_open_candidates.csv") }

# ---------------- Summarize ----------------
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'ablation_eval.R')`"", 'summarize', "`"$W`"", "`"$Frozen`"") -NoNewWindow -Wait -PassThru `
      -RedirectStandardOutput (Join-Path $W 'SUMMARIZE_stdout.txt') -RedirectStandardError (Join-Path $W 'SUMMARIZE_stderr.txt')
Log ("summarize exit=" + $p.ExitCode)
foreach ($cid in 'C33','C27') {
  $ev = Join-Path $W "$cid\evidence"
  $lines = foreach ($arm in Get-ChildItem -Directory (Join-Path $W "$cid\arms")) { foreach ($mf in 'MANIFEST_inputs.sha256','MANIFEST_outputs.sha256') { Get-Content (Join-Path $arm.FullName $mf) | ForEach-Object { "$($arm.Name)/$mf :: $_" } } }
  Set-Content -Path (Join-Path $ev "$($cid)_ARM_MANIFESTS.txt") -Value $lines -Encoding UTF8
  $l2 = Get-ChildItem -File $ev | Where-Object { $_.Name -ne "$($cid)_EVIDENCE.sha256" } | Sort-Object Name | ForEach-Object { "{0}  {1}" -f (Get-Sha $_.FullName), $_.Name }
  Set-Content -Path (Join-Path $ev "$($cid)_EVIDENCE.sha256") -Value $l2 -Encoding UTF8
}
Log ("DONE elapsed_min=" + [math]::Round(((Get-Date) - $t0).TotalMinutes, 2) + "  -> RUN_SUMMARY.txt")
