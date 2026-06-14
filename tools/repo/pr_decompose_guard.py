"""Guard decomposition PRs from racing direct proof PRs for the same goal.

The agent refuses to decompose when an open ``prove(<goal>):`` PR exists. This
module backs the trusted PR gate so manually opened or already-generated
``decompose(<goal>):`` PRs cannot auto-merge over an open direct proof PR.

Usage:
  gh pr list ... --json title --jq '.[].title' |
    python3 -m tools.repo.pr_decompose_guard check "<current title>"
"""
from __future__ import annotations

import re
import sys

_TITLE_RE = re.compile(r"^(?P<kind>prove|decompose)\((?P<goal>[a-z0-9][a-z0-9-]*)\):")


def title_goal(title: str, kind: str) -> str | None:
    """Return the scoped goal for a swarm title of ``kind``."""
    match = _TITLE_RE.match(title.strip())
    if match is None or match.group("kind") != kind:
        return None
    return match.group("goal")


def conflicting_prove_titles(decompose_title: str, open_titles: list[str]) -> list[str]:
    """Open direct proof PR titles that conflict with this decomposition PR.

    Non-decomposition titles never conflict. Matching is exact on the parsed
    goal, so ``prove(parent-s1):`` does not block ``decompose(parent):``.
    """
    goal = title_goal(decompose_title, "decompose")
    if goal is None:
        return []
    conflicts: list[str] = []
    for title in open_titles:
        if title_goal(title, "prove") == goal:
            conflicts.append(title.strip())
    return conflicts


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    if len(argv) != 2 or argv[0] != "check":
        print("usage: pr_decompose_guard.py check '<current title>'", file=sys.stderr)
        return 2

    title = argv[1]
    open_titles = [line for line in sys.stdin.read().splitlines() if line.strip()]
    conflicts = conflicting_prove_titles(title, open_titles)
    if not conflicts:
        return 0

    print(
        "decomposition PR races an open direct proof PR for the same goal; "
        "wait for the proof PR to merge/close before decomposing:",
        file=sys.stderr,
    )
    for conflict in conflicts:
        print(f"  {conflict}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
