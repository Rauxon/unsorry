"""Authoritative Gate A check: goal statements are create-only (ADR-018).

The #190 review's CRITICAL finding: every other integrity layer derives from
``goals/<id>.lean`` *as it exists in the PR's own tree* — the ADR-011 binding
obligation is regenerated FROM it, and Gate B's sha checks (GB006/GB016)
recompute AGAINST it — so a PR that consistently rewrites {goal ``.lean``
weakened, goal record sha, index entry, library proof} passes every layer.
Nothing pins a proved statement against history.

This check is that pin. Once a ``goals/*.lean`` exists at the PR base ref, no
PR may modify, delete, rename or typechange it — creation is the only
legitimate write (translate, decompose, backlog seeding). A wrong statement
gets a NEW goal id and the old goal is abandoned in place, never edited
(ADR-018 records why: an editable history is exactly the tampering surface).

Goal *records* (``goals/*.aisp``) are deliberately out of scope: they change
legitimately (status rewrites, affinity bumps) and Gate B recomputes their
statement shas from the pinned ``.lean``, so freezing the ``.lean`` closes
the chain.

Pure core (``violations``) over ``git diff --name-status`` lines; the CLI
wrapper runs the diff against ``--base``. Exit 0 = clean · 1 = violation(s)
printed · 2 = usage/error.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from typing import Iterable, List

_PINNED_SUFFIX = ".lean"
_PINNED_PREFIX = "goals/"


def _pinned(path: str) -> bool:
    return path.startswith(_PINNED_PREFIX) and path.endswith(_PINNED_SUFFIX)


def violations(lines: Iterable[str]) -> List[str]:
    """Offending entries from ``git diff --name-status`` output.

    Rejected on a pinned path: ``M`` (modify), ``D`` (delete), ``T``
    (typechange), and ``R*`` when the *old* side is pinned (the statement
    leaves its path; the new side is mere creation). ``A`` and ``C*`` are
    creation and are allowed.
    """
    found: List[str] = []
    for raw in lines:
        line = raw.rstrip("\n")
        if not line.strip():
            continue
        fields = line.split("\t")
        status = fields[0]
        if status.startswith(("M", "D", "T")) and len(fields) >= 2:
            path = fields[1]
            if _pinned(path):
                found.append(f"{status[0]} {path}")
        elif status.startswith("R") and len(fields) >= 3:
            old, new = fields[1], fields[2]
            if _pinned(old):
                found.append(f"R {old} -> {new}")
    return found


def main(argv: List[str]) -> int:
    parser = argparse.ArgumentParser(
        description="ADR-018: reject modification of existing goals/*.lean"
    )
    parser.add_argument("--base", required=True, help="PR base ref/sha")
    parser.add_argument("--repo", default=".", help="repository root (default: cwd)")
    args = parser.parse_args(argv)

    proc = subprocess.run(
        ["git", "-C", args.repo, "diff", "--name-status",
         f"{args.base}...HEAD", "--", "goals/"],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(f"check_goal_immutability: git diff failed: {proc.stderr.strip()}",
              file=sys.stderr)
        return 2

    found = violations(proc.stdout.splitlines())
    if found:
        for entry in found:
            print(f"goal statement is create-only (ADR-018): {entry}")
        print(
            "::error::existing goals/*.lean files must never be modified, "
            "deleted or renamed — a wrong statement gets a NEW goal id "
            "(ADR-018; the binding gate and Gate B shas all derive from "
            "these files, so they are the pin against history)"
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
