#!/bin/bash
# SOVEREIGN OS Linux Installer
set -euo pipefail

INSTALL_ROOT="${1:-/opt/sovereign}"
BRANCH="${2:-main}"
REPOS=(
    "shared-agentic-layer"
    "sovereign-os"
    "sovereign-osint"
    "sovereign-agent-mesh"
    "Sovereign-System"
    "sovereign-installer"
    "UNIVERSAL-LIFE-LIBERATION-TOOl"
)

echo "[+] SOVEREIGN OS Linux Installer"
mkdir -p "$INSTALL_ROOT"
cd "$INSTALL_ROOT"

for repo in "${REPOS[@]}"; do
    if [ -d "$repo" ]; then
        echo "[+] Pulling $repo..."
        cd "$repo" && git pull && cd ..
    else
        echo "[+] Cloning $repo..."
        git clone --depth 1 --branch "$BRANCH" "https://github.com/shalominattii-us/$repo.git"
    fi
done

echo "[+] Installing shared-agentic-layer..."
pip3 install -e "$INSTALL_ROOT/shared-agentic-layer" --quiet

echo "[+] Running sovereign-os bootstrap..."
bash "$INSTALL_ROOT/sovereign-os/boot/bootstrap.sh"

echo "[OK] Installation complete at $INSTALL_ROOT"
