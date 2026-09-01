# Purdue ROV KiCad Board Template

Starter template for new PCB designs in Purdue ROV. Pre-configured with the team component library submodule, automatic Git clean filters, isolation rules, and CI/CD validation.

---

## 🚀 Quickstart: Opening the Project (Recommended)

**Always open the project using the 1-click launcher:**

* **Windows:** Double-click `LAUNCH_KICAD.bat`
* **macOS / Linux:** Run `./LAUNCH_KICAD.sh`

### What the Launcher Does Automatically:
1. ⚙️ **Configures Git Hooks & Clean Filters:** Sets up Git to strip volatile viewport/zoom coordinates on every commit, preventing merge conflicts.
2. 🔄 **Auto-Updates Component Library:** Pulls the freshest symbols, footprints, and 3D models from `purdue-rov-kicad-lib` before opening.
3. 📐 **Opens KiCad:** Launches the project file with all 6 central library categories pre-linked.

---

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

4. Rename the project files (`board-template.kicad_*`) to match your project name.

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
- **macOS / Linux:** Run `./libs/purdue-rov-kicad-lib/LIBRARY_MANAGER.sh`

## Design Rules & Clearances

- Clearance rules are defined in `custom_rules.kicad_dru`.
- High-power thruster nets require a minimum 2.0 mm clearance from low-voltage logic (3.3V / 5V).

## Automated CI/CD & DevOps Preflight Checks

All CI/CD automation and tooling are centralized in [`purduerov/pcb-devops`](https://github.com/purduerov/pcb-devops):
1. **Automated Git Clean Filters:** Configured automatically by `.githooks/pre-commit` to prevent viewport/zoom merge noise.
2. **KiCad Symbol Linting:** Validates mandatory fields (`MPN`, `Manufacturer`, `Category`, `DigiKey`, `Datasheet`, `Temp_Range`) on all library components.
3. **ERC & DRC Validation:** Executes Electrical and Design Rules Checks via KiBot in GitHub Actions.
4. **Artifact Generation:** Automatically exports Schematic PDFs, Board Layout PDFs, and Interactive HTML BOMs on every pull request.
