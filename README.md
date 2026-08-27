# Purdue ROV KiCad Board Template

Starter template for new PCB designs in Purdue ROV. Pre-configured with the team component library submodule, Git clean filters, isolation rules, and CI/CD validation.

## Creating a New Board Repository

1. In GitHub, click **Use this template** > **Create a new repository**.
2. Name the repo to match the board function (e.g. `thruster-interface-board`).
3. Clone recursively so submodules are pulled:
   ```bash
   git clone --recursive https://github.com/purduerov/<your-repo-name>.git
   cd <your-repo-name>
   ```
   If cloned without `--recursive`, initialize the submodule:
   ```bash
   git submodule update --init --recursive
   ```

4. Configure local Git clean filters and hooks:
   - **Windows (PowerShell):** `.\setup_git_filters.ps1`
   - **macOS / Linux:** `./setup_git_filters.sh`

5. Rename the project files (`board-template.kicad_*`) to match your project name.

## Daily Workflow

You can open the project in KiCad directly, or use the launcher scripts:
- **Windows:** Double-click `LAUNCH_KICAD.bat`
- **macOS / Linux:** Run `./LAUNCH_KICAD.sh`

The launcher pulls the latest symbols and footprints from `purdue-rov-kicad-lib` before opening your `.kicad_pro` project.

## Local Validation (KiBot / Docker)

Run ERC, DRC, and manufacturing output generation locally before pushing:
- **Windows (PowerShell):**
  ```powershell
  .\run_validation.ps1
  ```
- **macOS / Linux:**
  ```bash
  ./run_validation.sh
  ```

Outputs are saved in `Generated_Outputs/`:
- Schematic PDF
- Interactive HTML BOM
- Gerbers and Drill files

## Design Rules & Clearances

- Clearance rules are defined in `custom_rules.kicad_dru`.
- High-power thruster nets require a minimum 2.0 mm clearance from low-voltage logic (3.3V / 5V).

## Adding New Components

If a part is missing from the central library, add it to `purdue-rov-kicad-lib` rather than creating a local-only symbol. See the [central library README](libs/purdue-rov-kicad-lib/README.md) for details on importing parts and required symbol fields.
