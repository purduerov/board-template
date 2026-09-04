@echo off
set "CACHE_DIR=%~dp0.pcb-devops-cache"
if not exist "%CACHE_DIR%" (
    git clone https://github.com/purduerov/pcb-devops.git "%CACHE_DIR%" --quiet >nul 2>&1
)
git -C "%CACHE_DIR%" fetch origin 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >nul 2>&1
git -C "%CACHE_DIR%" checkout 16695b691ba73fef6db2073b55c0e9f680a56682 --quiet >nul 2>&1

if exist "%CACHE_DIR%\scripts\LAUNCH_KICAD.bat" (
    call "%CACHE_DIR%\scripts\LAUNCH_KICAD.bat" "%~dp0"
    exit /b %ERRORLEVEL%
)

:: Offline Backup Fallback: If central cache is unavailable, launch local project directly
echo ℹ️ Offline Fallback: Opening local KiCad project directly...
for %%f in ("%~dp0"*.kicad_pro) do (
    start "" "%%f"
    exit /b 0
)
echo ⚠️ No .kicad_pro project file found in this directory.
pause
