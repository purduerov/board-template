#!/usr/bin/env bash
# local validation script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/.pcb-devops-cache"

if [ ! -d "$CACHE_DIR" ]; then
    echo "Cloning central pcb-devops tools..."
    git clone https://github.com/purduerov/pcb-devops.git "$CACHE_DIR" --quiet >/dev/null 2>&1 || true
fi
git -C "$CACHE_DIR" fetch origin 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >/dev/null 2>&1 || true
git -C "$CACHE_DIR" checkout 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >/dev/null 2>&1 || true

echo "Running central KiCad symbol library linter..."
find libs -name "*.kicad_sym" -exec python3 "$CACHE_DIR/scripts/linter_validator.py" {} +
