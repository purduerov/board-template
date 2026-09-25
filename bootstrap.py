#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def find_rov_script() -> Path:
    candidates = [
        Path(os.environ["ROV_DEVOPS_DIR"]) / "scripts" / "rov.py" if os.environ.get("ROV_DEVOPS_DIR") else None,
        ROOT / ".pcb-devops-cache" / "scripts" / "rov.py",
        ROOT.parent / "DevOps" / "scripts" / "rov.py",
    ]
    for candidate in candidates:
        if candidate and candidate.is_file():
            return candidate
    raise FileNotFoundError("rov.py not found; run LAUNCH_KICAD once or set ROV_DEVOPS_DIR")


def main() -> int:
    parser = argparse.ArgumentParser(description="Bootstrap a Purdue ROV board from the board template")
    parser.add_argument("--project-dir", type=Path, default=ROOT)
    parser.add_argument("--project-name")
    parser.add_argument("--non-interactive", action="store_true")
    args = parser.parse_args()
    command = [sys.executable, str(find_rov_script()), "board", "bootstrap",
               "--project-dir", str(args.project_dir.resolve())]
    if args.project_name:
        command.extend(["--project-name", args.project_name])
    if args.non_interactive:
        command.append("--non-interactive")
    return subprocess.run(command, cwd=args.project_dir).returncode


if __name__ == "__main__":
    raise SystemExit(main())
