"""PR scope separation (ADR-027): a proof is a proof; a fix is a fix.

A PR must not mix the **proof surface** (the verified content the swarm produces)
with the **harness surface** (the trust-bearing machinery that decides whether a
proof is accepted). Bundling the two is how a harness regression hides inside a
proof PR — and vice versa — and it tangles the queue (issue #302). This module
classifies a PR's changed paths and rejects a mixed PR; documentation and other
neutral paths may travel with either side.

Usage:
  git diff --name-only base...head | python3 -m tools.repo.pr_scope check
  python3 -m tools.repo.pr_scope check path1 path2 ...
"""
from __future__ import annotations

import sys

#: The verified-content surface the swarm produces.
PROOF_PREFIXES = (
    "library/",
    "goals/",
    "translations/",
    "decompositions/",
    "proof-runs/",
    "packages/unsorry-archive-",
)
#: The trust-bearing machinery that decides whether a proof is accepted.
HARNESS_PREFIXES = (
    "swarm/",
    "tools/",
    ".github/",
    "AxiomAudit/",
    "AuditFixtures/",
)
HARNESS_FILES = ("lakefile.toml", "lean-toolchain", "lake-manifest.json")


def surface(path: str) -> str:
    """Classify one repo-relative path as 'proof', 'harness', or 'neutral'.

    Neutral covers docs, CHANGELOG, README, licence, etc. — they may accompany
    either side."""
    path = path.strip()
    if not path:
        return "neutral"
    if path in HARNESS_FILES or path.startswith(HARNESS_PREFIXES):
        return "harness"
    if path.startswith(PROOF_PREFIXES):
        return "proof"
    return "neutral"


def mixed(paths: list[str]) -> bool:
    """True iff the changed set spans both the proof and harness surfaces."""
    surfaces = {surface(p) for p in paths if p.strip()}
    return "proof" in surfaces and "harness" in surfaces


def _split(paths: list[str]) -> tuple[list[str], list[str]]:
    proof = sorted(p for p in paths if p.strip() and surface(p) == "proof")
    harness = sorted(p for p in paths if p.strip() and surface(p) == "harness")
    return proof, harness


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    if not argv or argv[0] != "check":
        print("usage: pr_scope.py check [path ...]   # paths also read from stdin", file=sys.stderr)
        return 2
    paths = argv[1:] or [line for line in sys.stdin.read().splitlines()]
    if not mixed(paths):
        return 0
    proof, harness = _split(paths)
    print(
        "PR mixes the proof surface with the harness surface (ADR-027) — split it "
        "into separate PRs (a proof is a proof; a fix is a fix).\n"
        f"  proof:   {', '.join(proof)}\n"
        f"  harness: {', '.join(harness)}\n"
        "See CONTRIBUTING.md and issue #302.",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
