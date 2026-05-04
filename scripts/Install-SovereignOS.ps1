#Requires -RunAsAdministrator
<#
.SYNOPSIS
    SOVEREIGN OS Master Installer
    Deploys EagleShield, OSINT stack, AgentMesh, and System integration.
    Base64-compatible for paste-safe deployment.
#>
param(
    [string]$InstallRoot = "C:\Sovereign",
    [string]$Branch = "main",
    [switch]$SkipEagleShield,
    [switch]$SkipOSINT,
    [switch]$SkipAgentMesh
)

$ErrorActionPreference = "Stop"
$repos = @{
    "shared-agentic-layer" = "https://github.com/shalominattii-us/shared-agentic-layer.git"
    "sovereign-eagleshield" = "https://github.com/shalominattii-us/sovereign-eagleshield.git"
    "sovereign-osint" = "https://github.com/shalominattii-us/sovereign-osint.git"
    "sovereign-os" = "https://github.com/shalominattii-us/sovereign-os.git"
    "Sovereign-System" = "https://github.com/shalominattii-us/Sovereign-System.git"
    "sovereign-installer" = "https://github.com/shalominattii-us/sovereign-installer.git"
    "sovereign-agent-mesh" = "https://github.com/shalominattii-us/sovereign-agent-mesh.git"
    "UNIVERSAL-LIFE-LIBERATION-TOOl" = "https://github.com/shalominattii-us/UNIVERSAL-LIFE-LIBERATION-TOOl.git"
}

function Write-Banner {
    Write-Host @"
   _____                 _                  _       ____   _____ 
  / ____|               | |                | |     / __ \ / ____|
 | (___  _   _ _ __ ___ | |__   ___ _ __ __| | ___| |  | | (___  
  \___ \| | | | '_ ` _ \| '_ \ / _ \ '__/ _` |/ _ \ |  | |\___ \ 
  ____) | |_| | | | | | | |_) |  __/ | | (_| |  __/ |__| |____) |
 |_____/ \__,_|_| |_| |_|_.__/ \___|_|  \__,_|\___|\____/|_____/ 
"@ -ForegroundColor Cyan
}

function Install-Repo($name, $url, $dest) {
    Write-Host "[+] Installing $name..." -ForegroundColor Green
    if (Test-Path $dest) {
        Write-Host "    Already exists. Pulling latest..." -ForegroundColor Yellow
        Push-Location $dest
        git pull
        Pop-Location
    } else {
        git clone --depth 1 --branch $Branch $url $dest
    }
}

function Install-EagleShield {
    $dest = "$InstallRoot\sovereign-eagleshield"
    Install-Repo "sovereign-eagleshield" $repos["sovereign-eagleshield"] $dest
    Write-Host "[+] Running EagleShield hardening..." -ForegroundColor Cyan
    & "$dest\scripts\EagleShield-Hardening.ps1"
}

function Install-OSINT {
    $dest = "$InstallRoot\sovereign-osint"
    Install-Repo "sovereign-osint" $repos["sovereign-osint"] $dest
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        Write-Host "[+] Building OSINT Docker images..." -ForegroundColor Cyan
        Push-Location "$dest\docker"
        docker compose pull
        Pop-Location
    } else {
        Write-Host "[!] Docker not found. Skipping OSINT Docker build." -ForegroundColor Red
    }
}

function Install-AgentMesh {
    $dest = "$InstallRoot\sovereign-agent-mesh"
    Install-Repo "sovereign-agent-mesh" $repos["sovereign-agent-mesh"] $dest
    python -m pip install -e "$dest" --quiet
}

Write-Banner
New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is required. Install Git for Windows first."
}

Install-Repo "shared-agentic-layer" $repos["shared-agentic-layer"] "$InstallRoot\shared-agentic-layer"
python -m pip install -e "$InstallRoot\shared-agentic-layer" --quiet

if (-not $SkipEagleShield) { Install-EagleShield }
if (-not $SkipOSINT) { Install-OSINT }
if (-not $SkipAgentMesh) { Install-AgentMesh }

Install-Repo "Sovereign-System" $repos["Sovereign-System"] "$InstallRoot\Sovereign-System"

Write-Host "`n[OK] SOVEREIGN OS installation complete at $InstallRoot" -ForegroundColor Green
Write-Host "    Restart your terminal to refresh PATH." -ForegroundColor Cyan
