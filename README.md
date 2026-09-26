# Purdue ROV KiCad Board Template

Starter template for new PCB designs in Purdue ROV. Pre-configured with the team
component library submodule, declared KiCad clean filters, isolation rules, a
small project manifest, and CI/CD validation.

---

## Quickstart: Opening the Project (Recommended)

**Always open the project using the 1-click launcher:**

- **Windows:** Double-click `LAUNCH_KICAD.bat`
- **macOS / Linux:** Run `./LAUNCH_KICAD.sh`

### What the Launcher Does Automatically

1. **Makes a local copy of the shared tooling:** a shallow clone of
   `purduerov/pcb-devops` in `.pcb-devops-cache/`, which is disposable and never
   committed.
2. **Prepares the board:** renames the starter `board-template.kicad_*` files to
   your project name, writes `rov.project.json`, adds the standard library table
   entries, and installs the untracked `.rov-hooks/pre-commit` validation hook.
3. **Updates the component library:** fast-forwards `purdue-rov-kicad-lib` when
   the submodule is clean and the remote is reachable. It never resets, stashes,
   or overwrites your work.
4. **Opens KiCad:** launches the project with all 6 central library categories
   pre-linked.

If the shared tooling cannot be downloaded, the launcher says so and opens the
project directly instead of failing silently.

### Optional: KiCad clean filters

`.gitattributes` declares the KiCad clean/smudge filters, but the filter commands
themselves are local Git config. To strip GUI-only viewport/zoom noise from your
diffs and avoid merge conflicts, run the central setup script once per clone:

```bash
# macOS / Linux
bash .pcb-devops-cache/scripts/setup_git_filters.sh
```

```powershell
# Windows
.pcb-devops-cache\scripts\setup_git_filters.ps1
```

Run it after the first `LAUNCH_KICAD`, which creates the cache.

---

## Creating a New Board Repository

1. Create the repository with GitHub **Use this template**.
2. Clone the repository.
3. Run LAUNCH_KICAD once, or run python bootstrap.py.
4. Open future sessions with LAUNCH_KICAD.

```bash
git clone --recursive https://github.com/purduerov/<your-repo-name>.git
cd <your-repo-name>
```

If you cloned without `--recursive`, initialize the submodule:

```bash
git submodule update --init --recursive
```

To run the preparation step directly instead of through the launcher:

```bash
python bootstrap.py
```

You never rename `board-template.kicad_*` by hand. The bootstrap step does it,
records the result in `rov.project.json`, and is safe to run more than once.

`rov.project.json` is the board's contract with the platform:

```json
{
  "schema": 1,
  "project_name": "board-template",
  "kicad_version": "10",
  "platform_ref": "master",
  "library": {
    "path": "libs/purdue-rov-kicad-lib",
    "branch": "master",
    "update_policy": "pull-request"
  },
  "ci_profile": "standard"
}
```

## Central Component Library & Manager GUI

The template is pre-configured with project-level library tables
(`sym-lib-table` and `fp-lib-table`) pointing to `purdue-rov-kicad-lib`:

- `rov_passives`: Resistors, capacitors, inductors, crystals
- `rov_power`: Voltage regulators, buck/boost converters, MOSFETs, diodes
- `rov_logic`: MCUs, logic ICs, op-amps, level shifters, transceivers
- `rov_connectors`: Power terminals, XT60/XT30, headers, USB, JST connectors
- `rov_sensors`: IMUs, temperature, pressure sensors
- `rov_mech`: Mounting holes, standoffs, test points

### Launching the Library Manager GUI

To browse parts, inspect footprints, edit properties, or add/delete components in
the shared library:

- **Windows:** Double-click `libs\purdue-rov-kicad-lib\LIBRARY_MANAGER.bat`
- **macOS / Linux:** Run `./libs/purdue-rov-kicad-lib/LIBRARY_MANAGER.sh`

## Design Rules & Clearances

- Clearance rules are defined in `custom_rules.kicad_dru`.
- High-power thruster nets require a minimum 2.0 mm clearance from low-voltage
  logic (3.3V / 5V).

## Automated CI/CD & DevOps Preflight Checks

All CI/CD automation and tooling are centralized in
[`purduerov/pcb-devops`](https://github.com/purduerov/pcb-devops):

1. **Shared board validation:** `rov board validate` checks the manifest,
   project files, library tables, submodule state, and conflict markers. The
   same command runs in CI, so a local pass means that shared CI gate will pass.
   ERC, DRC, and the artifact exports are separate KiBot steps.
2. **KiCad Symbol Linting:** validates mandatory fields (`MPN`, `Manufacturer`,
   `Category`, `DigiKey`, `Datasheet`, `Temp_Range`) on all library components.
3. **ERC & DRC Validation:** executes Electrical and Design Rules Checks via
   KiBot in GitHub Actions.
4. **Artifact Generation:** automatically exports Schematic PDFs, Board Layout
   PDFs, and Interactive HTML BOMs on every pull request.
5. **Library Updates:** a scheduled or dispatched job opens a
   `chore/library-update` pull request against the approved library `master`. It
   never pushes your branch directly.

## Known Follow-Up

The tracked `.githooks/pre-commit` file shipped with this template is legacy. It
syncs the library submodule over the network and can stage a submodule change
during an ordinary `git commit`. Bootstrap installs the untracked
`.rov-hooks/pre-commit` instead, which only validates. The legacy file is
teammate-authored and has been left in place pending an owner-approved cleanup;
use `--no-verify` if it surprises you, and check `git status` before committing.
