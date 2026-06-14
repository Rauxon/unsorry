"""Collate per-PR changelog fragments into the CHANGELOG (ADR-040/SPEC-040-A).

Each change ships a fragment file ``changelog.d/<category>-<slug>.md`` instead of
editing ``CHANGELOG.md``'s ``[Unreleased]`` section directly. Distinct filenames
per PR never collide, so concurrent PRs cannot conflict on the changelog. The
fragments are collated — into a preview during development and into a versioned
section at release — by this tool.

Usage:
  python3 -m tools.changelog --preview [<root>]            # render [Unreleased] body
  python3 -m tools.changelog --release <version> <date> [<root>]   # fold + clear
"""
from __future__ import annotations

import sys
from pathlib import Path

# Keep a Changelog section order; fragments are filed by these category prefixes.
CATEGORIES = ["added", "changed", "deprecated", "removed", "fixed", "security"]
CATEGORY_TITLES = {c: c.capitalize() for c in CATEGORIES}

FRAGMENTS_DIR = "changelog.d"
UNRELEASED_HEADER = "## [Unreleased]"


def fragment_category(path: Path) -> str | None:
    """The Keep-a-Changelog category from a fragment filename, e.g.
    ``changed-gemini-effort.md`` -> ``changed``. None if the prefix is unknown."""
    prefix = path.name.split("-", 1)[0].lower()
    return prefix if prefix in CATEGORIES else None


def read_fragments(root: Path) -> dict[str, list[str]]:
    """Map category -> list of entry bodies, read from ``changelog.d/*.md``
    (excluding README), grouped and deterministically ordered by filename."""
    base = root / FRAGMENTS_DIR
    grouped: dict[str, list[str]] = {c: [] for c in CATEGORIES}
    if not base.is_dir():
        return grouped
    for path in sorted(base.glob("*.md")):
        if path.name.lower() == "readme.md":
            continue
        category = fragment_category(path)
        if category is None:
            raise ValueError(
                f"{path.name}: filename must start with one of "
                f"{', '.join(CATEGORIES)} (e.g. changed-{path.stem}.md)"
            )
        body = path.read_text(encoding="utf-8").strip()
        if body:
            grouped[category].append(body)
    return grouped


def render_unreleased(root: Path) -> str:
    """The ``[Unreleased]`` body (``### Category`` blocks of ``- entry`` bullets)
    rendered from the fragments. Empty string when there are no fragments."""
    grouped = read_fragments(root)
    blocks: list[str] = []
    for category in CATEGORIES:
        entries = grouped[category]
        if not entries:
            continue
        lines = [f"### {CATEGORY_TITLES[category]}", ""]
        lines.extend(f"- {entry}" for entry in entries)
        blocks.append("\n".join(lines))
    return "\n\n".join(blocks)


def _split_changelog(text: str) -> tuple[str, str, str]:
    """Return (head, unreleased_block, rest) where head ends at the
    ``## [Unreleased]`` line, unreleased_block is that section up to the next
    ``## [`` version header, and rest is from that header onward."""
    marker = text.index(UNRELEASED_HEADER)
    head = text[:marker]
    after = text[marker:]
    next_version = after.index("\n## [", len(UNRELEASED_HEADER))
    return head, after[: next_version + 1], after[next_version + 1 :]


def release(root: Path, version: str, date: str) -> int:
    """Fold the fragments into a new ``## [version] - date`` section above the
    latest release, then delete the fragment files. Idempotent on the CHANGELOG
    layout; a no-op (exit 2) when there are no fragments to release."""
    body = render_unreleased(root)
    if not body:
        print("no changelog fragments to release", file=sys.stderr)
        return 2
    changelog = root / "CHANGELOG.md"
    text = changelog.read_text(encoding="utf-8")
    head, unreleased_block, rest = _split_changelog(text)
    section = f"## [{version}] - {date}\n\n{body}\n\n"
    changelog.write_text(head + unreleased_block + section + rest, encoding="utf-8")
    for path in sorted((root / FRAGMENTS_DIR).glob("*.md")):
        if path.name.lower() != "readme.md":
            path.unlink()
    print(f"released {version}: folded fragments into CHANGELOG.md and cleared {FRAGMENTS_DIR}/")
    return 0


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    if "--release" in argv:
        rest = [a for a in argv if a != "--release"]
        if len(rest) < 2:
            print("usage: --release <version> <date> [<root>]", file=sys.stderr)
            return 1
        version, date = rest[0], rest[1]
        root = Path(rest[2]) if len(rest) > 2 else Path.cwd()
        return release(root, version, date)
    # default / --preview
    rest = [a for a in argv if a != "--preview"]
    root = Path(rest[0]) if rest else Path.cwd()
    body = render_unreleased(root)
    sys.stdout.write((body + "\n") if body else "(no unreleased changelog fragments)\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
