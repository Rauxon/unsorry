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

The one sanctioned way a pinned ``goals/<id>.lean`` may leave the active tree
is **archive retirement** (ADR-041): the statement is *relocated*, byte for
byte, into a frozen, fully-validated archive package. A ``D goals/<id>.lean``
is exempt iff ``<id>`` is recorded in an archive manifest in the PR's own tree
AND the archived ``packages/<block>/goals/<id>.lean`` is byte-identical to the
deleted statement at the base ref — the pin moves into the archive block, it
does not vanish. Modify/rename/typechange, a delete with no matching archive
copy, or an archived copy that differs from history all stay rejected.

Pure cores (``violations``, ``archive_retired``) over ``git diff
--name-status`` lines; the CLI wrapper runs the diff against ``--base`` and
resolves the archive context from git. Exit 0 = clean · 1 = violation(s)
printed · 2 = usage/error.
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from typing import Callable, Iterable, List, Mapping, Tuple

_PINNED_SUFFIX = ".lean"
_PINNED_PREFIX = "goals/"
_ARCHIVE_PREFIX = "packages/unsorry-archive-"
_ARCHIVE_MANIFEST = "archive-manifest.json"


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


def _deleted_goal_id(entry: str) -> str | None:
    """Goal id for a ``D goals/<id>.lean`` violation entry, else ``None``.

    Only a *delete* of a pinned path can be an archive retirement; modify,
    typechange, and rename entries never qualify (they leave no preserved copy
    behind, or mutate the statement in place).
    """
    if not entry.startswith("D "):
        return None
    path = entry[2:]
    if _pinned(path):
        return path[len(_PINNED_PREFIX):-len(_PINNED_SUFFIX)]
    return None


def archive_retired(
    found: List[str],
    archived_blocks: Mapping[str, str],
    statement_preserved: Callable[[str, str], bool],
) -> Tuple[List[str], List[str]]:
    """Split structural ``violations`` into (still rejected, exempt).

    ``archived_blocks`` maps a goal id to the archive package dir (e.g.
    ``packages/unsorry-archive-0001``) that records it in its manifest.
    ``statement_preserved(goal_id, block_dir)`` is True iff the archived
    ``<block_dir>/goals/<goal_id>.lean`` is byte-identical to the deleted
    statement at the base ref.

    A ``D goals/<id>.lean`` is exempt (archive retirement, ADR-041) iff its id
    is in ``archived_blocks`` AND ``statement_preserved`` holds — the pin
    relocates, unchanged, into a frozen archive block. Every other entry
    (modify, typechange, rename, delete with no/altered archive copy) stays
    rejected.
    """
    rejected: List[str] = []
    exempt: List[str] = []
    for entry in found:
        goal_id = _deleted_goal_id(entry)
        block = archived_blocks.get(goal_id) if goal_id is not None else None
        if block is not None and statement_preserved(goal_id, block):
            exempt.append(entry)
        else:
            rejected.append(entry)
    return rejected, exempt


def _git_show(repo: str, ref_path: str) -> bytes | None:
    """``git show <ref_path>`` raw bytes, or ``None`` if the object is absent."""
    proc = subprocess.run(
        ["git", "-C", repo, "show", ref_path],
        capture_output=True,
    )
    return proc.stdout if proc.returncode == 0 else None


def _archived_blocks(repo: str, ref: str) -> Mapping[str, str]:
    """Map goal id -> archive package dir, from every archive manifest at ``ref``.

    Reads ``packages/unsorry-archive-*/archive-manifest.json`` as it exists in
    the PR's own tree; a goal id appears iff a manifest's ``goals[].goal`` lists
    it. A malformed/unreadable manifest contributes nothing (the retirement is
    then not exempt and falls back to rejection — fail safe).
    """
    listing = subprocess.run(
        ["git", "-C", repo, "ls-tree", "-r", "--name-only", ref, "--", "packages/"],
        capture_output=True,
        text=True,
    )
    blocks: dict[str, str] = {}
    if listing.returncode != 0:
        return blocks
    for path in listing.stdout.splitlines():
        path = path.strip()
        if not (path.startswith(_ARCHIVE_PREFIX) and path.endswith("/" + _ARCHIVE_MANIFEST)):
            continue
        block_dir = path[: -len("/" + _ARCHIVE_MANIFEST)]
        raw = _git_show(repo, f"{ref}:{path}")
        if raw is None:
            continue
        try:
            manifest = json.loads(raw.decode("utf-8"))
            entries = manifest.get("goals", [])
        except (ValueError, AttributeError):
            continue
        for entry in entries:
            goal_id = entry.get("goal") if isinstance(entry, dict) else None
            if isinstance(goal_id, str) and goal_id:
                blocks[goal_id] = block_dir
    return blocks


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
    if not found:
        return 0

    # ADR-041 archive retirement: a delete is exempt iff the statement is
    # relocated, byte-identical, into a frozen archive block recorded in a
    # manifest in this same tree. Resolve that context from git and split.
    blocks = _archived_blocks(args.repo, "HEAD")

    def statement_preserved(goal_id: str, block_dir: str) -> bool:
        base_stmt = _git_show(args.repo, f"{args.base}:{_PINNED_PREFIX}{goal_id}{_PINNED_SUFFIX}")
        archived_stmt = _git_show(
            args.repo, f"HEAD:{block_dir}/{_PINNED_PREFIX}{goal_id}{_PINNED_SUFFIX}"
        )
        return base_stmt is not None and base_stmt == archived_stmt

    rejected, exempt = archive_retired(found, blocks, statement_preserved)

    for entry in exempt:
        print(f"goal statement retired into archive (ADR-041, allowed): {entry}")

    if rejected:
        for entry in rejected:
            print(f"goal statement is create-only (ADR-018): {entry}")
        print(
            "::error::existing goals/*.lean files must never be modified, "
            "deleted or renamed — a wrong statement gets a NEW goal id "
            "(ADR-018; the binding gate and Gate B shas all derive from "
            "these files, so they are the pin against history). The only "
            "exception is ADR-041 archive retirement: deleting a goal whose "
            "statement is recorded byte-identical in a frozen archive block's "
            "manifest."
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
