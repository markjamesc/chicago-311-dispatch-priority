# Waits until the b4 batch (C52 SQL) has finished, then starts run_c24.ps1, so the two never compete for MySQL. Writes only RUNNER_LOG_C24_wait.txt.
$Runner = Split-Path -Parent $MyInvocation.MyCommand.Path; $W = Split-Path -Parent $Runner; $L = Join-Path $W 'RUNNER_LOG_C24_wait.txt'
function Log($s) { Add-Content -Path $L -Value ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + ' ' + $s) -Encoding UTF8 }
Log 'waiting for "DONE batch=b4" in RUNNER_LOG_b4.txt and no mysql.exe process'
while ($true) {
  $done = Select-String -Path (Join-Path $W 'RUNNER_LOG_b4.txt') -Pattern 'DONE batch=b4' -Quiet
  $my = @(Get-Process mysql -ErrorAction SilentlyContinue).Count
  if ($done -and $my -eq 0) { break }
  Start-Sleep -Seconds 60 }
Log 'b4 done; starting run_c24.ps1'
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Runner 'run_c24.ps1') *> (Join-Path $W 'RUNNER_stdout_C24.txt')
Log ("run_c24.ps1 finished exit=" + $LASTEXITCODE)
