<#
.SYNOPSIS
    Converts the installer to a base64 one-liner for paste-safe deployment.
#>
param(
    [string]$ScriptPath = ".\Install-SovereignOS.ps1",
    [string]$OutPath = ".\payloads\installer.b64"
)

$bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $ScriptPath))
$b64 = [System.Convert]::ToBase64String($bytes)
$b64 | Set-Content -Path $OutPath
Write-Host "[+] Base64 payload saved to $OutPath ($($b64.Length) chars)"
Write-Host "`nOne-liner deployment:"
Write-Host "powershell -EncodedCommand $b64.Substring(0,[Math]::Min(80,$b64.Length))..." -ForegroundColor Cyan
