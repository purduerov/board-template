@echo off
title Purdue ROV - Launch KiCad Project
echo ⚙️ Configuring local Git hooks and filters...
git config core.hooksPath .githooks
git config submodule.recurse true
echo 🔄 Auto-fetching latest Purdue ROV component library...
git -C libs/purdue-rov-kicad-lib pull origin master --quiet
echo ✅ Library up to date! Launching KiCad...
for %%f in (*.kicad_pro) do (
    start "" "%%f"
    exit /b 0
)
