@echo off
setlocal
title Nocturne Visuals HWID Tool

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$machineGuid = ''; " ^
  "try { $machineGuid = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography' -Name 'MachineGuid' -ErrorAction Stop).MachineGuid } catch { } " ^
  "$build = 0; try { $build = [int](Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'CurrentBuildNumber' -ErrorAction Stop).CurrentBuildNumber } catch { } " ^
  "$osName = if ($IsWindows -or $env:OS -eq 'Windows_NT') { if ($build -ge 22000) { 'Windows 11' } else { 'Windows 10' } } else { [System.Runtime.InteropServices.RuntimeInformation]::OSDescription }; " ^
  "$osArch = if ([Environment]::Is64BitOperatingSystem) { 'amd64' } else { 'x86' }; " ^
  "$parts = @($machineGuid, $osName, $osArch, $env:PROCESSOR_IDENTIFIER, $env:COMPUTERNAME, $env:USERNAME); " ^
  "$source = 'NocturneVisuals:' + ($parts -join '|'); " ^
  "$bytes = [System.Text.Encoding]::UTF8.GetBytes($source); " ^
  "$sha = [System.Security.Cryptography.SHA256]::Create(); " ^
  "$hwid = -join ($sha.ComputeHash($bytes) | ForEach-Object { $_.ToString('x2') }); " ^
  "Write-Host 'Nocturne Visuals HWID'; Write-Host ''; Write-Host $hwid; Write-Host ''; " ^
  "try { Set-Clipboard -Value $hwid; Write-Host 'HWID copied to clipboard.' } catch { Write-Host 'Copy failed. Select and copy the HWID manually.' } " ^
  "Write-Host 'Send this HWID to the administrator.'"

echo.
pause
