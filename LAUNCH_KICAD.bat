@echo off
set "CACHE_DIR=%~dp0.pcb-devops-cache"
if not exist "%CACHE_DIR%" (
    git clone --depth 1 https://github.com/purduerov/pcb-devops.git "%CACHE_DIR%" --quiet
) else (
    git -C "%CACHE_DIR%" pull origin master --quiet
)
call "%CACHE_DIR%\scripts\LAUNCH_KICAD.bat" "%~dp0"
