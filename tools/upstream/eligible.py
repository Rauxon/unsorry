"""Packet-eligibility scan (ADR-020, SPEC-020-A).

A goal is upstream-packet-eligible iff all three hold:

1. **proved** — it has a `library/index` entry (the authoritative marker);
2. **absence-verified** — its `backlog/<id>.md` carries a structured
   ``- **Absence:** …`` field (the ADR-012 provenance). Shakedown-era trivia
   have backlog prose but no field (they exist in mathlib already), and
   machine-minted decomposition subs have no backlog entry at all (no absence
   check was ever run on them) — both are excluded by the same rule;
3. **unpacketed** — `docs/upstream/<id>.md` does not exist yet.

The nightly workflow iterates this list; everything downstream of it
(dedup-at-HEAD, packet, patch) is per-goal and idempotent.

Usage: python3 -m tools.upstream.eligible [<repo-root>]
"""
from __future__ import annotations

import sys
from pathlib import Path
from typing import List

# Same project, single source of truth for provenance parsing (protocol §13);
# the underscore is a module-internal hint, not an API boundary we redraw here.
from tools.sourcing.targets_board import _backlog_fields, _proved


def eligible(root: Path) -> List[str]:
    out: List[str] = []
    for goal in sorted(_proved(root)):
        fields = _backlog_fields(root, goal)
        if "absence" not in fields:  # keys are lowercased by the parser
            continue
        if (root / "docs" / "upstream" / f"{goal}.md").is_file():
            continue
        out.append(goal)
    return out


def main(argv: List[str] | None = None) -> int:
    args = argv if argv is not None else sys.argv[1:]
    root = Path(args[0]) if args else Path(".")
    for goal in eligible(root):
        print(goal)
    return 0


if __name__ == "__main__":
    sys.exit(main())
