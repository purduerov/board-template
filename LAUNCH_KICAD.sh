#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.pcb-devops-cache"

if [ ! -d "$CACHE_DIR" ]; then
    git clone https://github.com/purduerov/pcb-devops.git "$CACHE_DIR" --quiet >/dev/null 2>&1 || true
fi
git -C "$CACHE_DIR" fetch origin 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >/dev/null 2>&1 || true
git -C "$CACHE_DIR" checkout 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >/dev/null 2>&1 || true

if [ -f "$CACHE_DIR/scripts/LAUNCH_KICAD.sh" ]; then
    bash "$CACHE_DIR/scripts/LAUNCH_KICAD.sh" "$SCRIPT_DIR"
    exit $?
fi

# Offline Backup Fallback: If central cache is unavailable, launch local project directly
echo "ℹ️ Offline Fallback: Opening local KiCad project directly..."
PROJ=$(find "$SCRIPT_DIR" -maxdepth 1 -name "*.kicad_pro" | head -n 1)

if [ -z "$PROJ" ]; then
    echo "⚠️ No .kicad_pro project found in $SCRIPT_DIR."
    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "/Applications/KiCad/KiCad.app" ]; then
        open -a "/Applications/KiCad/KiCad.app" "$PROJ"
    elif [ -d "/Applications/KiCad.app" ]; then
        open -a "/Applications/KiCad.app" "$PROJ"
    else
        open "$PROJ"
    fi
elif command -v kicad >/dev/null 2>&1; then
    kicad "$PROJ" &
else
    echo "⚠️ Please open '$PROJ' directly in KiCad."
fi
