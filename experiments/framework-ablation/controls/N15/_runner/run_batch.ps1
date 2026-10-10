# N15 ablation runner (Chicago 311 frozen pack). Unattended; Windows PowerShell 5.1.
# Usage: powershell -ExecutionPolicy Bypass -File "<WORK>\runner\run_batch.ps1" -Batch b1 -Controls C26,C31,C39,C30,C29
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
if (-not (Test-Path (Join-Path $VD 'VARIANTS.tsv'))) {
  $p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'source_variants.R')`"", "`"$Frozen`"", "`"$VD`"") -NoNewWindow -Wait -PassThru `
        -RedirectStandardOutput (Join-Path $W "VARIANTS_stdout_$Batch.txt") -RedirectStandardError (Join-Path $W "VARIANTS_stderr_$Batch.txt")
  Log "source_variants exit=$($p.ExitCode)"; if ($p.ExitCode -ne 0) { throw 'source_variants.R failed' }
}
foreach ($v in Import-Csv -Delimiter "`t" -Path (Join-Path $VD 'VARIANTS.tsv')) { $h = Get-Sha (Join-Path $VD "$($v.variant)\$($v.file)")
  if ($h -ne $v.sha256) { throw "variant hash mismatch $($v.variant)/$($v.file)" }; Log ("variant OK {0} {1} {2} {3}" -f $v.variant, $v.file, $h, $v.note) }
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
  $o = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object { $_.FullName -like '*\outputs\*' -or $_.Name -clike 'RUN_*' }
  $lines = $o | Sort-Object FullName | ForEach-Object { "{0}  {1}  {2}" -f (Get-Sha $_.FullName), $_.Length, $_.FullName.Substring($root.Length + 1) }
  Set-Content -Path (Join-Path $root 'MANIFEST_outputs.sha256') -Value $lines -Encoding UTF8
}
# ---------------- Arms ----------------
foreach ($cid in $Controls) {
  Log "$cid arms"
  $r = New-Arm $cid 'B' $true $true 'FROZEN'; Manifest $r 'MANIFEST_inputs.sha256'; Run-Path $r 'RA'; Run-Path $r 'RB'; Hash-Outputs $r
  Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')
  foreach ($a in Import-Csv -Delimiter "`t" -Path (Join-Path $Runner "seeds\$cid\ARMS.tsv")) {
    $runs = $a.paths -split '\+'; $withRA = $runs -contains 'RA'; $withRB = $runs -contains 'RB'
    if ($withRA -and $withRB -and $a.ra_source -ne $a.rb_source) { throw "$cid $($a.arm): both paths must read the same source" }
    $src = if ($withRB) { $a.rb_source } else { $a.ra_source }
    $r = New-Arm $cid $a.arm $withRA $withRB $src
    if ($a.code_seeds -ne '-') { foreach ($s in $a.code_seeds -split ';') { $from, $to = $s -split '>', 2; Copy-Item -LiteralPath (Join-Path $Runner ($from -replace '/', '\')) -Destination (Join-Path $r $to) -Force } }
    Manifest $r 'MANIFEST_inputs.sha256'
    foreach ($p in $runs) { Run-Path $r $p }
    Hash-Outputs $r
    Remove-Item -LiteralPath (Join-Path $r 'data\source\src_open_candidates.csv')   # hashed in MANIFEST_inputs; saves ~118 MB per arm
  }
}
# ---------------- Summarize ----------------
Log 'summarize'
$p = Start-Process -FilePath $Rscript -ArgumentList @("`"$(Join-Path $Runner 'eval_batch.R')`"", "`"$W`"", "`"$Frozen`"", ($Controls -join ',')) -NoNewWindow -Wait -PassThru `
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
