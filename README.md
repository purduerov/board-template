# Purdue ROV KiCad Board Template

This is the central base template for starting any new hardware board project at Purdue ROV.

---

## ⚡ Recommended Daily Workflow: 1-Click KiCad Launcher

To ensure your local library is **always 100% up-to-date with new parts added by teammates** without ever needing to run manual Git commands:

### 🎯 **Double-Click `LAUNCH_KICAD.bat` to Start Work**
* **Windows:** Double-click **`LAUNCH_KICAD.bat`** in your project folder.
* **Mac / Linux:** Double-click **`LAUNCH_KICAD.sh`** (or run `./LAUNCH_KICAD.sh` in terminal).

#### **What this script does for you automatically:**
1. **Auto-Fetches Central Library Parts (0.5 seconds):** Silently connects to `purdue-rov-kicad-lib` on GitHub and pulls any new symbols, footprints, or 3D models added by teammates while you were away.
2. **Eliminates Missing Symbol Question Marks:** Guarantees you never open KiCad with outdated or missing component definitions.
3. **Launches KiCad:** Immediately opens your `.kicad_pro` project in KiCad.

---

## 🔄 How Automated Library Syncing Works

Even if you are working solo on your board repository and rarely run `git pull`, your central component library stays updated automatically through **3 layers of protection**:

1. 🚀 **On KiCad Launch (`LAUNCH_KICAD.bat`):** Pulls the latest library symbols & footprints before opening your project.
2. 🔄 **On Git Commit (`.githooks/pre-commit`):** Automatically fetches latest library commits right before completing any commit, updating your project's submodule pointer automatically.
3. ☁️ **In GitHub Cloud (`auto-update-submodule.yml`):** GitHub Actions automatically syncs the library submodule on daily schedule or whenever new library parts are published.

---

## 🚀 How to Start a New Project

1. Click the **"Use this template"** button at the top of the GitHub repository.
2. Name your new repository (e.g., `thruster-control-board`) and click **Create repository**.
3. Clone your repository locally using the recursive flag:
   ```bash
   git clone --recursive https://github.com/purduerov/YOUR-BOARD-REPO.git
   ```
   > [!TIP]
   > **Forgot `--recursive` or seeing missing symbol question marks?** Run:
   > ```bash
   > git submodule update --init --recursive
   > ```
4. Configure local Git clean filters and auto-sync hooks:
   * **Windows (PowerShell):** `.\setup_git_filters.ps1`
   * **Linux / macOS:** `./setup_git_filters.sh`

---

## 🧪 Local One-Click Validation (Docker Jobset)

Test your board locally with a single command to generate outputs inside Docker:
* **Windows:** `.\run_validation.ps1`
* **Linux / macOS:** `./run_validation.sh`

Outputs generate in `Generated_Outputs/` (Schematic PDF, Interactive BOM, Gerbers).

---

## ➕ Adding New Parts to the Central Library

To add a new component downloaded online (SnapEDA, DigiKey, Ultra Librarian, LCSC, etc.):
1. Open `libs/purdue-rov-kicad-lib` and double-click **`IMPORT_PART_WIZARD.bat`** (or `IMPORT_PART_WIZARD.sh`).
2. Use the 1-Click Desktop GUI / Downloads Watcher to import, validate, and push to master!
