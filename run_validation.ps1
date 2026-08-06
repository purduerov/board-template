<#
.SYNOPSIS
    Runs local KiCad symbol validation and KiBot hardware generation.
.DESCRIPTION
    This script dynamically clones/pulls pcb-devops to run symbol linting
    and KiBot validation/fabrication outputs locally.
.EXAMPLE
    .\run_validation.ps1
#>

# Ensure Git clean filters are configured
$schClean = git config --get filter.kicad_sch_cleaner.clean
if (-not $schClean) {
    Write-Host "KiCad Git clean filters are not configured. Running setup_git_filters.ps1..." -ForegroundColor Yellow
    & .\setup_git_filters.ps1
}

# Auto-fetch/pull pcb-devops tools into .pcb-devops-cache
$cacheDir = Join-Path $PSScriptRoot ".pcb-devops-cache"
if (-not (Test-Path $cacheDir)) {
    Write-Host "Cloning central pcb-devops tools..." -ForegroundColor Cyan
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git $cacheDir
} else {
    Write-Host "Updating central pcb-devops tools..." -ForegroundColor Cyan
    git -C $cacheDir pull origin master --quiet
}

# Run central symbol linter on all *.kicad_sym files in libs/
$symFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot "libs") -Recurse -Filter "*.kicad_sym" -ErrorAction SilentlyContinue
if ($symFiles) {
    Write-Host "`nRunning central KiCad symbol library linter..." -ForegroundColor Cyan
    $linterScript = Join-Path $cacheDir "scripts\linter_validator.py"
    python $linterScript $symFiles.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Symbol library linter failed."
        exit $LASTEXITCODE
    }
} else {
    Write-Host "No symbol files found in libs/ to lint." -ForegroundColor Yellow
}

# Run KiBot container using central kibot_master.yaml if docker engine is running
$dockerAvailable = $false
try {
    $null = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        $dockerAvailable = $true
    }
} catch {}

if ($dockerAvailable) {
    $projectDir = Get-Location
    $pcbFiles = Get-ChildItem -Path $projectDir -Filter "*.kicad_pcb"
    $schFiles = Get-ChildItem -Path $projectDir -Filter "*.kicad_sch"

    $schName = if ($schFiles.Count -gt 0) { $schFiles[0].Name } else { "*.kicad_sch" }
    $pcbName = if ($pcbFiles.Count -gt 0) { $pcbFiles[0].Name } else { "*.kicad_pcb" }

    Write-Host "`nStarting KiBot Local Validation for: $schName / $pcbName" -ForegroundColor Cyan
    docker run --rm -v "${projectDir}:/workspace" -w /workspace setsoft/kicad_auto:ki10@sha256:493666a06d900ed3352c50b0f75a76ccdfe194999c097d455021cab9e3c723fa kibot -c ".pcb-devops-cache/kibot_master.yaml" -s all -d Generated_Outputs

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Validation and generation completed successfully! Outputs are in the 'Generated_Outputs' directory." -ForegroundColor Green
    } else {
        Write-Error "KiBot validation failed. Please check the logs above for ERC/DRC failures."
        exit $LASTEXITCODE
    }
} else {
    Write-Host "`nDocker engine is not running. Skipping KiBot container validation." -ForegroundColor Yellow
}
