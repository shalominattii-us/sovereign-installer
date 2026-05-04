# sovereign-installer

Master installer for SOVEREIGN. Supports Windows (PowerShell) and Linux (Bash).

## Windows — One-liner (after org/repos exist)

```powershell
irm https://raw.githubusercontent.com/SOVEREIGN/sovereign-installer/main/scripts/Install-SovereignOS.ps1 | iex
```

## Windows — Local

```powershell
.\scripts\Install-SovereignOS.ps1
```

## Linux

```bash
bash scripts/install.sh /opt/sovereign
```

## Base64 Payload Generation

```powershell
.\scripts\Encode-Installer.ps1
```
