#!/usr/bin/env bash
# Runs local KiBot validation and fabrication package generation using Docker.

set -e

# Ensure Git clean filters are configured
SCH_CLEAN=$(git config --get filter.kicad_sch_cleaner.clean || true)
if [ -z "$SCH_CLEAN" ]; then
    echo "KiCad Git clean filters are not configured. Running setup_git_filters.sh..."
    bash ./setup_git_filters.sh
fi

# Verify docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed. Please install Docker to run local validation."
    exit 1
fi

PROJECT_DIR=$(pwd)
KIBOT_CONFIG="libs/pcb-devops/kibot_master.yaml"

if [ ! -f "$KIBOT_CONFIG" ]; then
    echo "Local master config not found in submodules. Fetching latest from GitHub..."
    curl -sSL https://raw.githubusercontent.com/purduerov/pcb-devops/master/kibot_master.yaml -o local_kibot.yaml
    KIBOT_CONFIG="local_kibot.yaml"
fi

echo "Starting KiBot Local Validation..."
docker run --rm -v "${PROJECT_DIR}:/workspace" -w /workspace setsoft/kicad_auto:ki10@sha256:493666a06d900ed3352c50b0f75a76ccdfe194999c097d455021cab9e3c723fa kibot -c "$KIBOT_CONFIG" -s all -d Generated_Outputs

echo "Validation completed successfully! Outputs are in the 'Generated_Outputs' directory."
