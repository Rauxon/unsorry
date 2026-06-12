"""Re-verify mathlib absence at HEAD (ADR-020, SPEC-020-A — pipeline stage 2).

Our absence claims date from the pinned mathlib (ADR-012); mathlib moves, so
a packet must carry evidence against **master at packet time**. This tool
re-greps a master checkout with the same engine the sourcing check uses
(`tools.sourcing.check_absence.grep_mathlib` — one implementation, §13) and
records the revision it ran against.

Honesty note: a name-grep is a *pre-filter*, exactly as in ADR-012 — mathlib
would state the lemma under its own name. The strong evidence is the kernel
build at HEAD (`verify_head.sh`); this stage catches the cheap "someone added
exactly this" case and stamps the rev the packet's claims are relative to.

Default patterns: the proved theorem's name from the goal's `library/index`
entry (the authoritative name), plus any caller-supplied ``--pattern`` extras
(distinctive statement fragments).

Usage:
  python3 -m tools.upstream.dedup_head --goal <id> --mathlib <dir>
      [--root <repo>] [--pattern <regex> ...] [--rev <sha>]

Prints a JSON report; exit 0 always on a completed scan (the verdict is data,
not an error), 2 on usage/IO problems.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path
from typing import List

from tools.sourcing.check_absence import grep_mathlib

_NAME_RE = re.compile(r"name≜([A-Za-z0-9_.']+)")


def _index_name(root: Path, goal: str) -> str | None:
    """The proved theorem's name from the goal's index entry. Index files are
    keyed by statement sha, not goal id — scan for the goal≜ field. The match
    must be delimiter-anchored: `goal≜parent` is a prefix of
    `goal≜parent-s1`, and a bare substring scan leaked a sub-lemma's name
    into the parent's packet on the real tree."""
    index = root / "library" / "index"
    if not index.is_dir():
        return None
    goal_rx = re.compile(rf"goal≜{re.escape(goal)}(?=[;}}\s])")
    for entry in sorted(index.glob("*.aisp")):
        text = entry.read_text(encoding="utf-8")
        if goal_rx.search(text):
            m = _NAME_RE.search(text)
            return m.group(1) if m else None
    return None


def default_patterns(root: Path, goal: str) -> List[str]:
    name = _index_name(root, goal)
    return [rf"\b{re.escape(name)}\b"] if name else []


def _git_rev(mathlib: Path) -> str | None:
    # The checkout root may be the package dir or its Mathlib/ subdir.
    for candidate in (mathlib, mathlib.parent):
        proc = subprocess.run(
            ["git", "-C", str(candidate), "rev-parse", "HEAD"],
            capture_output=True, text=True,
        )
        if proc.returncode == 0:
            return proc.stdout.strip()
    return None


def dedup(root: Path, goal: str, mathlib: Path, rev: str | None,
          extra_patterns: List[str]) -> dict:
    patterns = default_patterns(root, goal) + list(extra_patterns)
    hits = grep_mathlib(mathlib, patterns) if patterns else []
    return {
        "goal": goal,
        "mathlib_rev": rev or _git_rev(mathlib) or "unknown",
        "patterns": patterns,
        "local_matches": [
            {"pattern": p, "file": f, "line": ln} for p, f, ln in hits
        ],
        "verdict": "possible-duplicate" if hits else "no-local-match",
    }


def main(argv: List[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="tools.upstream.dedup_head")
    parser.add_argument("--goal", required=True)
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--mathlib", type=Path, required=True)
    parser.add_argument("--pattern", action="append", default=[])
    parser.add_argument("--rev")
    args = parser.parse_args(argv)

    if not args.mathlib.is_dir():
        print(f"error: mathlib source not found at {args.mathlib}", file=sys.stderr)
        return 2
    report = dedup(args.root, args.goal, args.mathlib, args.rev, args.pattern)
    print(json.dumps(report, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    sys.exit(main())
