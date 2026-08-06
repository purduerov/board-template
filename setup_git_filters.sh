#!/usr/bin/env bash
set -e

# Delegate to central pcb-devops setup_git_filters script
CACHE_DIR="$(dirname "$0")/.pcb-devops-cache"
if [ ! -d "$CACHE_DIR" ]; then
    echo "Cloning central pcb-devops tools..."
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git "$CACHE_DIR"
else
    git -C "$CACHE_DIR" pull origin master --quiet
fi

SETUP_SCRIPT="$CACHE_DIR/scripts/setup_git_filters.sh"
if [ -f "$SETUP_SCRIPT" ]; then
    bash "$SETUP_SCRIPT"
else
    echo "Central setup_git_filters.sh not found in pcb-devops cache."
fi
