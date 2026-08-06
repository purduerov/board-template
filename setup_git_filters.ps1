# Delegate to central pcb-devops setup_git_filters script
$cacheDir = Join-Path $PSScriptRoot ".pcb-devops-cache"
if (-not (Test-Path $cacheDir)) {
    Write-Host "Cloning central pcb-devops tools..." -ForegroundColor Cyan
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git $cacheDir
} else {
    git -C $cacheDir pull origin master --quiet
}

$setupScript = Join-Path $cacheDir "scripts\setup_git_filters.ps1"
if (Test-Path $setupScript) {
    & $setupScript
} else {
    Write-Host "Central setup_git_filters.ps1 not found in pcb-devops cache." -ForegroundColor Red
}
