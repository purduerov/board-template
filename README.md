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
   - **Windows (PowerShell):** `.\scripts\setup_git_filters.ps1`
   - **macOS / Linux:** `./scripts/setup_git_filters.sh`

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
  .\scripts\run_validation.ps1
  ```
- **macOS / Linux:**
  ```bash
  ./scripts/run_validation.sh
  ```


Outputs are saved in `Generated_Outputs/`:
- Schematic PDF
- Interactive HTML BOM
- Gerbers and Drill files

## Central Component Library & Manager GUI

The template is pre-configured with project-level library tables (`sym-lib-table` and `fp-lib-table`) pointing to `purdue-rov-kicad-lib`:
- `rov_passives`: Resistors, capacitors, inductors, crystals
- `rov_power`: Voltage regulators, buck/boost converters, MOSFETs, diodes
- `rov_logic`: MCUs, logic ICs, op-amps, level shifters, transceivers
- `rov_connectors`: Power terminals, XT60/XT30, headers, USB, JST connectors
- `rov_sensors`: IMUs, temperature, pressure sensors
- `rov_mech`: Mounting holes, standoffs, test points

### Launching the Library Manager GUI
To browse parts, inspect footprints, edit properties, or add/delete components in the shared library:
- **Windows:** Double-click `libs\purdue-rov-kicad-lib\LIBRARY_MANAGER.bat`
- **macOS / Linux:** Run `./libs/purdue-rov-kicad-lib/LIBRARY_MANAGER.sh` (or `python3 libs/purdue-rov-kicad-lib/scripts/library_manager_gui.py`)

## Adding New Components

If a part is missing from the central library, add it to `purdue-rov-kicad-lib` rather than creating a local-only symbol:
1. Open the **Library Manager GUI** (or run `libs\purdue-rov-kicad-lib\IMPORT_PART_WIZARD.bat`).
2. Drag and drop your downloaded `.kicad_sym` / `.kicad_mod` / `.zip` file.
3. Ensure all 6 required fields (`Category`, `MPN`, `Manufacturer`, `DigiKey`, `Datasheet`, `Temp_Range`) are completed.
4. Click **Git Sync** in the GUI (or commit & push in `libs/purdue-rov-kicad-lib`).

## Design Rules & Clearances

- Clearance rules are defined in `custom_rules.kicad_dru`.
- High-power thruster nets require a minimum 2.0 mm clearance from low-voltage logic (3.3V / 5V).

## CI/CD Preflight Checks

GitHub Actions automatically runs preflight checks on pull requests and pushes:
1. **KiCad Symbol Linting:** Validates mandatory fields on all `.kicad_sym` files in the library.
2. **ERC & DRC Validation:** Executes Electrical and Design Rules Checks via KiBot.
3. **Artifact Generation:** Exports schematic PDFs, Interactive HTML BOMs, and fabrication Gerbers to workflow artifacts.


