# Purdue ROV KiCad Board Template

This is the central base template for starting any new hardware board project at Purdue ROV.

---

## ✨ Features

*   **Zero-Setup Library Loading**: Automatically references the 6 categorized central symbol and footprint libraries via the submodule in `libs/purdue-rov-kicad-lib`.
*   **Automated Submodule Auto-Sync**: Pre-configured Git hooks (`post-merge`, `post-checkout`) and GitHub Actions workflows (`auto-update-submodule.yml`) keep library files updated automatically when pulling or pushing.
*   **Merge Conflict Prevention**: Pre-configured `.gitattributes` filter scrub volatile KiCad GUI metadata (zoom, scroll, viewports) before commits.
*   **CI/CD Integration Ready**: Pre-configured workflows for Electrical Rules Check (ERC), relaxed early-stage preflights (`run_drc: false`), and manufacturing package exports (Schematic PDF, Interactive HTML BOM, Gerbers).

---

## 🚀 How to Start a New Project

1.  Click the **"Use this template"** button at the top of the GitHub repository.
2.  Name your new repository (e.g., `depth-sensor-board`) and click **Create repository**.
3.  Clone your repository locally using the recursive flag:
    ```bash
    git clone --recursive https://github.com/purduerov/YOUR-BOARD-REPO.git
    ```
    > [!TIP]
    > **Forgot `--recursive` or seeing missing symbol question marks?** Run:
    > ```bash
    > git submodule update --init --recursive
    > ```

4.  Configure local Git clean filters and auto-sync hooks:
    * **Windows (PowerShell):** `.\setup_git_filters.ps1`
    * **Linux / macOS:** `./setup_git_filters.sh`

---

## 🔄 Automated Library Submodule Auto-Update System

This repository automates keeping central component libraries updated:

1. **Local Auto-Sync on Pull / Branch Switch:** Running `git pull` or `git checkout` triggers `.githooks/post-merge` and `.githooks/post-checkout` to auto-fetch the latest `purdue-rov-kicad-lib` master branch in the background.
2. **GitHub Cloud Auto-Update:** The `.github/workflows/auto-update-submodule.yml` workflow automatically updates the library submodule when `purdue-rov-kicad-lib` publishes new components or on daily cron schedule.

---

## 🧪 Local One-Click Validation (Docker Jobset)

Test your board locally with a single command to generate outputs inside Docker:
* **Windows:** `.\run_validation.ps1`
* **Linux / macOS:** `./run_validation.sh`

Outputs generate in `Generated_Outputs/` (Schematic PDF, Interactive BOM, Gerbers).

---

## ➕ Adding New Parts to the Central Library

To add a new component downloaded online or created from scratch:
1. Open `libs/purdue-rov-kicad-lib` and double-click **`IMPORT_PART_WIZARD.bat`** (or `IMPORT_PART_WIZARD.sh`).
2. Use the 1-Click Desktop GUI / Downloads Watcher to import, validate, and push to master!
