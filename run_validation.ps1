<#
.SYNOPSIS
    Runs local KiBot hardware validation and fabrication generation using Docker.
.DESCRIPTION
    This script runs ERC (Electrical Rules Check), DRC (Design Rules Check),
    and generates the schematic PDFs, Interactive BOMs, and Gerbers locally.
.EXAMPLE
    .\run_validation.ps1
#>

# Ensure Git clean filters are configured
$schClean = git config --get filter.kicad_sch_cleaner.clean
if (-not $schClean) {
    Write-Host "KiCad Git clean filters are not configured. Running setup_git_filters.ps1..." -ForegroundColor Yellow
    & .\setup_git_filters.ps1
}

# Ensure Docker is running
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Error "Docker is not installed or not in the system PATH. Please install Docker Desktop to run local validation."
    exit 1
}

# Resolve paths
$projectDir = Get-Location
$pcbFiles = Get-ChildItem -Path $projectDir -Filter "*.kicad_pcb"
$schFiles = Get-ChildItem -Path $projectDir -Filter "*.kicad_sch"

if ($schFiles.Count -eq 0) {
    Write-Warning "No .kicad_sch file found in the root directory. Using wildcard detection."
    $schName = "*.kicad_sch"
} else {
    $schName = $schFiles[0].Name
}

if ($pcbFiles.Count -eq 0) {
    Write-Warning "No .kicad_pcb file found in the root directory. Using wildcard detection."
    $pcbName = "*.kicad_pcb"
} else {
    $pcbName = $pcbFiles[0].Name
}

# Path to the master kibot config (local copy or relative to submodule)
$kibotConfig = "libs/pcb-devops/kibot_master.yaml"

if (-not (Test-Path $kibotConfig)) {
    Write-Host "Local master config not found in submodules. Fetching latest from GitHub..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/purduerov/pcb-devops/b6839c5ff1d7cdca9c342276352930b5d787c8f9/kibot_master.yaml" -OutFile "local_kibot.yaml"
    $kibotConfig = "local_kibot.yaml"
}

Write-Host "Starting KiBot Local Validation for: $schName / $pcbName" -ForegroundColor Cyan

# Run KiBot container
docker run --rm -v "${projectDir}:/workspace" -w /workspace setsoft/kibot:latest kibot -c $kibotConfig -s all -d Generated_Outputs

if ($LASTEXITCODE -eq 0) {
    Write-Host "Validation and generation completed successfully! Outputs are in the 'Generated_Outputs' directory." -ForegroundColor Green
} else {
    Write-Error "KiBot validation failed. Please check the logs above for ERC/DRC failures."
}
