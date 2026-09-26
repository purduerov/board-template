#!/usr/bin/env python3
"""Resolve and run the shared ``rov`` CLI for a board created from this template.

The template does not vendor the platform tools. This script finds the CLI the
same way ``LAUNCH_KICAD`` and the generated hook do, and hands the work to it, so
there is exactly one implementation of board bootstrap.

Exit codes are the CLI's own, except for ``2`` which is also used here for a
missing CLI: a member who runs ``python bootstrap.py`` before ``LAUNCH_KICAD``
must get one actionable line naming what to do, never a traceback.
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent

MISSING_CLI_HINT = (
    "The Purdue ROV DevOps CLI (rov.py) was not found. Run LAUNCH_KICAD once to "
    "cache it, or set ROV_DEVOPS_DIR to your KiCad/DevOps checkout, then run "
    "this command again."
)


def find_rov_script() -> Path:
    candidates = [
        Path(os.environ["ROV_DEVOPS_DIR"]) / "scripts" / "rov.py" if os.environ.get("ROV_DEVOPS_DIR") else None,
        ROOT / ".pcb-devops-cache" / "scripts" / "rov.py",
        ROOT.parent / "DevOps" / "scripts" / "rov.py",
    ]
    for candidate in candidates:
        if candidate and candidate.is_file():
            return candidate
    raise FileNotFoundError(MISSING_CLI_HINT)


def main() -> int:
    parser = argparse.ArgumentParser(description="Bootstrap a Purdue ROV board from the board template")
    parser.add_argument("--project-dir", type=Path, default=ROOT)
    parser.add_argument("--project-name")
    parser.add_argument("--non-interactive", action="store_true")
    args = parser.parse_args()
    try:
        rov_script = find_rov_script()
    except FileNotFoundError as exc:
        # A missing CLI is BLOCKED, the same state the CLI itself uses for a
        # missing prerequisite, so a caller can treat the two alike.
        print(f"[BLOCKED] bootstrap: {exc}", file=sys.stderr)
        return 2
    command = [sys.executable, str(rov_script), "board", "bootstrap",
               "--project-dir", str(args.project_dir.resolve())]
    if args.project_name:
        command.extend(["--project-name", args.project_name])
    if args.non_interactive:
        command.append("--non-interactive")
    return subprocess.run(command, cwd=args.project_dir).returncode


if __name__ == "__main__":
    raise SystemExit(main())
