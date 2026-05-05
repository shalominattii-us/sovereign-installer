# SOVEREIGN Installer
param([string]$Profile='full', [string]$Path='C:\SOVEREIGN')
$repos = @('SOVEREIGN','UNIVERSAL-LIFE-LIBERATION-TOOL','Sovereign-System','shared-agentic-layer','sovereign-installer','sovereign-agent-mesh','sovereign-eagleshield','2scalexe')
if(!(Test-Path $Path)){New-Item -ItemType Directory -Path $Path|Out-Null}
foreach($r in $repos){
    $d=Join-Path $Path $r
    if(!(Test-Path $d)){git clone "https://github.com/shalominattii-us/$r.git" $d 2>$null}
    Write-Host "[+] $r" -ForegroundColor Green
}
Write-Host "[OK] SOVEREIGN installed" -ForegroundColor Yellow
