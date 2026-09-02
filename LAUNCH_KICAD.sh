#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.pcb-devops-cache"
if [ ! -d "$CACHE_DIR" ]; then
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git "$CACHE_DIR" --quiet
else
    git -C "$CACHE_DIR" pull origin master --quiet || true
fi
bash "$CACHE_DIR/scripts/LAUNCH_KICAD.sh" "$SCRIPT_DIR"
