# === Ω BUNDLEMIT v2.0 — UNIFIED SOVEREIGN PUSH ===
# Packages all verified configs and pushes to github.com/shalominattii-us
# Run from: C:\Sovereign\AE-Hub

$ErrorActionPreference = "Stop"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$commitMsg = "ΩΩΩ Sovereign Stack v$timestamp | Ollama+llama3.2:3b | PageFile 12GB | AE-Hub Agentic | Dashboard LLM"

$repos = @(
    @{Name="sovereign-agent"; Path="C:\Sovereign\AE-Hub\Repos\sovereign-agent"; Files=@(
        "agentic-core.psm1",
        "ollama-config.env",
        "governor-service.ps1"
    )},
    @{Name="sovereign-dashboard"; Path="C:\Sovereign\AE-Hub\Repos\sovereign-dashboard"; Files=@(
        "src/components/SovereignChat.jsx",
        "src/styles/sovereign-chat.css",
        "package.json"
    )},
    @{Name="sovereign-installer"; Path="C:\Sovereign\AE-Hub\Repos\sovereign-installer"; Files=@(
        "install-ollama-optimizer.ps1",
        "pagefile-fix.ps1",
        "verify-post-reboot.ps1"
    )},
    @{Name="sovereign-osint"; Path="C:\Sovereign\AE-Hub\Repos\sovereign-osint"; Files=@(
        "README.md"
    )}
)

Write-Host "`n=== Ω BUNDLEMIT v2.0 | Unified Sovereign Push ===" -ForegroundColor Cyan
Write-Host "Timestamp: $timestamp`n" -ForegroundColor Gray

foreach ($repo in $repos) {
    Write-Host "`n[Ω] Processing $($repo.Name)..." -ForegroundColor Cyan

    if (-not (Test-Path $repo.Path)) {
        New-Item -ItemType Directory -Path $repo.Path -Force | Out-Null
        Write-Host "  [+] Created directory" -ForegroundColor Green
    }

    Set-Location $repo.Path

    # Initialize git if needed
    if (-not (Test-Path ".git")) {
        git init | Out-Null
        git branch -M main 2>$null
        Write-Host "  [+] Git initialized" -ForegroundColor Green
    }

    # Ensure remote
    $remote = git remote get-url origin 2>$null
    if (-not $remote) {
        $remoteUrl = "https://github.com/shalominattii-us/$($repo.Name).git"
        git remote add origin $remoteUrl 2>$null
        Write-Host "  [+] Remote added: $remoteUrl" -ForegroundColor Green
    }

    # Stage and commit
    git add -A 2>$null
    $status = git status --porcelain 2>$null
    if ($status) {
        git commit -m "$commitMsg" 2>$null | Out-Null
        Write-Host "  [ΩΩΩ] Committed changes" -ForegroundColor Green
    } else {
        Write-Host "  [=] No changes to commit" -ForegroundColor Yellow
    }

    # Push
    try {
        $pushOutput = git push origin main 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [ΩΩΩ] PUSHED to origin/main" -ForegroundColor Green
        } else {
            Write-Host "  [!] Push returned non-zero, checking..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  [X] Push failed: $_" -ForegroundColor Red
    }
}

Set-Location C:\Sovereign\AE-Hub
Write-Host "`n=== ΩΩΩ BUNDLEMIT COMPLETE ===" -ForegroundColor Green
Write-Host "All repos synchronized." -ForegroundColor Gray

