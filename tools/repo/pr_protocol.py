"""Protocol-compliance gate (ADR-028): every implementation ADR ships with a spec.

`docs/protocols.md` requires a spec per ADR. This gate enforces it for *newly
added* decision records only — historical ADRs that predate the convention (or
reuse another ADR's spec) are untouched. An added `ADR-<n>-*.md` must have a
matching `SPEC-<n>-*.md` (added in the same PR or already present), and an added
`SPEC-<n>` must have a matching `ADR-<n>`.

Usage:
  gh api .../pulls/<n>/files --jq '.[]|select(.status=="added")|.filename' \
    | python3 -m tools.repo.pr_protocol check
The added paths are read from stdin (or argv after `check`); existing ADRs/specs
are scanned from the working tree under docs/adrs/.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ADR_RE = re.compile(r"(?:^|/)docs/adrs/ADR-(\d+)-[^/]+\.md$")
SPEC_RE = re.compile(r"(?:^|/)docs/adrs/specs/SPEC-(\d+)-[^/]+\.md$")


def _numbers(paths: list[str], pattern: re.Pattern) -> set[str]:
    out: set[str] = set()
    for p in paths:
        m = pattern.search(p.strip())
        if m:
            out.add(m.group(1))
    return out


def check(added: list[str], existing: list[str]) -> list[str]:
    """Violations for the added paths given everything present after the merge.

    `existing` should be the post-merge file set (base tree ∪ added), so a PR that
    adds both ADR-<n> and SPEC-<n> passes."""
    pool = list(existing) + list(added)
    have_adr = _numbers(pool, ADR_RE)
    have_spec = _numbers(pool, SPEC_RE)
    violations: list[str] = []
    for n in sorted(_numbers(added, ADR_RE)):
        if n not in have_spec:
            violations.append(f"ADR-{n} added without a matching docs/adrs/specs/SPEC-{n}-*.md")
    for n in sorted(_numbers(added, SPEC_RE)):
        if n not in have_adr:
            violations.append(f"SPEC-{n} added without a matching docs/adrs/ADR-{n}-*.md")
    return violations


def _scan_tree(root: Path) -> list[str]:
    adrs = root / "docs" / "adrs"
    if not adrs.is_dir():
        return []
    return [str(p.relative_to(root)) for p in adrs.rglob("*.md")]


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    if not argv or argv[0] != "check":
        print("usage: pr_protocol.py check [added_path ...]   # added also read from stdin", file=sys.stderr)
        return 2
    added = argv[1:] or [line for line in sys.stdin.read().splitlines() if line.strip()]
    violations = check(added, _scan_tree(Path.cwd()))
    if not violations:
        return 0
    print(
        "Protocol violation (ADR-028) — every implementation ADR needs a spec:\n  "
        + "\n  ".join(violations)
        + "\nAdd the matching ADR/spec in this PR (see docs/protocols.md).",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
