@echo off
set "CACHE_DIR=%~dp0.pcb-devops-cache"
if not exist "%CACHE_DIR%" (
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git "%CACHE_DIR%" --quiet >nul 2>&1
) else (
    git -C "%CACHE_DIR%" pull origin master --quiet >nul 2>&1
)

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
