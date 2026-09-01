#!/usr/bin/env bash
# 1-Click Launcher for Purdue ROV KiCad Board Project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "⚙️ Configuring local Git hooks and filters..."
git config core.hooksPath .githooks
git config submodule.recurse true

echo "🔄 Pulling latest board design updates..."
git pull --rebase --autostash --quiet || true

echo "🔄 Auto-fetching latest Purdue ROV component library..."
git -C libs/purdue-rov-kicad-lib pull origin master --quiet || true
echo "✅ Everything up to date! Launching KiCad..."

for PROJ in *.kicad_pro; do
    if [ -f "$PROJ" ]; then
        kicad "$PROJ" &
        break
    fi
done
