#!/usr/bin/env bash
# Runs local KiCad validation and fabrication package generation using Docker.

set -e

# Ensure Git clean filters are configured
SCH_CLEAN=$(git config --get filter.kicad_sch_cleaner.clean || true)
if [ -z "$SCH_CLEAN" ]; then
    echo "KiCad Git clean filters are not configured. Running setup_git_filters.sh..."
    bash ./setup_git_filters.sh
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/.pcb-devops-cache"

if [ ! -d "$CACHE_DIR" ]; then
    echo "Cloning central pcb-devops tools..."
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git "$CACHE_DIR"
else
    echo "Updating central pcb-devops tools..."
    git -C "$CACHE_DIR" pull origin master --quiet
fi

echo "Running central KiCad symbol library linter..."
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

SYM_FILES=$(find "${SCRIPT_DIR}/libs" -name "*.kicad_sym" 2>/dev/null || true)
if [ -n "$SYM_FILES" ]; then
    find "${SCRIPT_DIR}/libs" -name "*.kicad_sym" -exec $PYTHON_CMD "$CACHE_DIR/scripts/linter_validator.py" {} +
else
    echo "No symbol files found in libs/ to lint."
fi

# Run KiBot container using central kibot_master.yaml if docker daemon is running
if command -v docker &> /dev/null && docker info &> /dev/null; then
    PROJECT_DIR=$(pwd)
    echo "Starting KiBot Local Validation..."
    docker run --rm -v "${PROJECT_DIR}:/workspace" -w /workspace setsoft/kicad_auto:ki10@sha256:493666a06d900ed3352c50b0f75a76ccdfe194999c097d455021cab9e3c723fa kibot -c ".pcb-devops-cache/kibot_master.yaml" -s all -d Generated_Outputs
    echo "Validation completed successfully! Outputs are in the 'Generated_Outputs' directory."
else
    echo "Docker engine is not running. Skipping KiBot container validation."
fi
