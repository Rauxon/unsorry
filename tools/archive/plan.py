"""Plan immutable proof archive blocks (ADR-041 / SPEC-041-A).

This tool is intentionally report-only: it proposes the next block of proved
goals to archive, but does not move files or edit Lake configuration.
"""
from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable, Sequence

from tools.gate_b.records import parse_record, parse_utc_z, parse_vector
from tools.lean_sig import camel_name

DEFAULT_BLOCK_SIZE = 40
ARCHIVE_ROOT = Path("packages")
ARCHIVE_PREFIX = "unsorry-archive-"


@dataclass(frozen=True)
class ProvedGoal:
    goal: str
    sha: str
    theorem: str
    module: str
    module_path: str
    goal_path: str
    index_path: str
    proof_run_paths: tuple[str, ...]
    proved_at: str


@dataclass(frozen=True)
class ArchiveProposal:
    block_id: str
    target_size: int
    eligible_count: int
    selected_count: int
    selected_goals: tuple[ProvedGoal, ...]
    deferred_groups: tuple[tuple[str, ...], ...]

    def manifest(self) -> dict[str, object]:
        return {
            "block_id": self.block_id,
            "target_size": self.target_size,
            "proof_count": self.selected_count,
            "goals": [asdict(goal) for goal in self.selected_goals],
            "deferred_groups": [list(group) for group in self.deferred_groups],
        }


def _rel(root: Path, path: Path) -> str:
    return path.relative_to(root).as_posix()


def _record(path: Path):
    return parse_record(path.read_text(encoding="utf-8"))


def archive_manifests(root: Path) -> list[Path]:
    base = root / ARCHIVE_ROOT
    if not base.is_dir():
        return []
    return sorted(base.glob(f"{ARCHIVE_PREFIX}*/archive-manifest.json"))


def archived_goal_ids(root: Path) -> set[str]:
    archived: set[str] = set()
    for path in archive_manifests(root):
        data = json.loads(path.read_text(encoding="utf-8"))
        goals = data.get("goals", [])
        if not isinstance(goals, list):
            continue
        for item in goals:
            if isinstance(item, str):
                archived.add(item)
            elif isinstance(item, dict) and isinstance(item.get("goal"), str):
                archived.add(str(item["goal"]))
    return archived


def next_block_id(root: Path) -> str:
    existing = []
    for manifest in archive_manifests(root):
        suffix = manifest.parent.name.removeprefix(ARCHIVE_PREFIX)
        if suffix.isdigit():
            existing.append(int(suffix))
    return f"{ARCHIVE_PREFIX}{(max(existing, default=0) + 1):04d}"


def _module_declaring(root: Path, theorem: str, goal: str) -> tuple[str, str]:
    unsorry_dir = root / "library" / "Unsorry"
    decl = re.compile(rf"\b(?:theorem|lemma)\s+{re.escape(theorem)}\b")
    if unsorry_dir.is_dir():
        for path in sorted(unsorry_dir.glob("*.lean")):
            if decl.search(path.read_text(encoding="utf-8")):
                return f"Unsorry.{path.stem}", _rel(root, path)
    fallback = root / "library" / "Unsorry" / f"{camel_name(goal)}.lean"
    return f"Unsorry.{camel_name(goal)}", _rel(root, fallback)


def _proof_runs_for(root: Path, goal: str) -> tuple[str, ...]:
    proof_runs = root / "proof-runs"
    if not proof_runs.is_dir():
        return ()
    paths = []
    for path in sorted(proof_runs.glob(f"{goal}.*.aisp")):
        record = _record(path)
        if record.fields.get("goal") == goal and record.fields.get("outcome") == "proved":
            paths.append(_rel(root, path))
    return tuple(paths)


def _proved_at(root: Path, goal_record_path: Path, proof_run_paths: Sequence[str]) -> str:
    ended = []
    for rel_path in proof_run_paths:
        value = _record(root / rel_path).fields.get("ended")
        if value and parse_utc_z(value):
            ended.append(value)
    if ended:
        return min(ended)
    record = _record(goal_record_path)
    if record.header is not None:
        return f"{record.header.date}T00:00:00Z"
    return "9999-12-31T23:59:59Z"


def proved_goals(root: Path) -> list[ProvedGoal]:
    goals_dir = root / "goals"
    result: list[ProvedGoal] = []
    for goal_path in sorted(goals_dir.glob("*.aisp")) if goals_dir.is_dir() else []:
        goal_record = _record(goal_path)
        if goal_record.fields.get("status") != "proved":
            continue
        goal = goal_path.stem
        sha = goal_record.fields.get("sha")
        if not sha:
            continue
        index_path = root / "library" / "index" / f"{sha}.aisp"
        if not index_path.is_file():
            continue
        index_record = _record(index_path)
        theorem = index_record.fields.get("name", "")
        module, module_path = _module_declaring(root, theorem, goal)
        proof_run_paths = _proof_runs_for(root, goal)
        result.append(
            ProvedGoal(
                goal=goal,
                sha=sha,
                theorem=theorem,
                module=module,
                module_path=module_path,
                goal_path=_rel(root, goal_path),
                index_path=_rel(root, index_path),
                proof_run_paths=proof_run_paths,
                proved_at=_proved_at(root, goal_path, proof_run_paths),
            )
        )
    return sorted(result, key=lambda item: (item.proved_at, item.goal))


def _union_find(items: Iterable[str]):
    parent = {item: item for item in items}

    def find(item: str) -> str:
        parent.setdefault(item, item)
        while parent[item] != item:
            parent[item] = parent[parent[item]]
            item = parent[item]
        return item

    def union(left: str, right: str) -> None:
        lroot = find(left)
        rroot = find(right)
        if lroot != rroot:
            parent[rroot] = lroot

    return parent, find, union


def dependency_groups(root: Path, goals: Sequence[str]) -> list[tuple[str, ...]]:
    goal_set = set(goals)
    _parent, find, union = _union_find(goal_set)

    for goal in goal_set:
        path = root / "goals" / f"{goal}.aisp"
        if not path.is_file():
            continue
        deps = parse_vector(_record(path).fields.get("deps", "⟨⟩")) or []
        for dep in deps:
            if dep in goal_set:
                union(goal, dep)

    decomp_dir = root / "decompositions"
    if decomp_dir.is_dir():
        for path in sorted(decomp_dir.glob("*.aisp")):
            record = _record(path)
            parent = record.fields.get("parent")
            if parent not in goal_set:
                continue
            for key, value in record.fields.items():
                if not key.startswith("sub"):
                    continue
                match = re.search(r"id≜([^,⟩\s]+)", value)
                if match and match.group(1) in goal_set:
                    union(parent, match.group(1))

    groups: dict[str, list[str]] = defaultdict(list)
    for goal in sorted(goal_set):
        groups[find(goal)].append(goal)
    return tuple(tuple(group) for group in sorted(groups.values(), key=lambda g: (len(g), g)))


def propose_archive(root: Path, size: int = DEFAULT_BLOCK_SIZE) -> ArchiveProposal:
    archived = archived_goal_ids(root)
    all_goals = [goal for goal in proved_goals(root) if goal.goal not in archived]
    by_goal = {goal.goal: goal for goal in all_goals}
    groups = dependency_groups(root, list(by_goal))
    group_for = {goal: group for group in groups for goal in group}

    selected: list[ProvedGoal] = []
    selected_ids: set[str] = set()
    deferred: list[tuple[str, ...]] = []
    deferred_ids: set[tuple[str, ...]] = set()
    for candidate in all_goals:
        if candidate.goal in selected_ids:
            continue
        group = group_for.get(candidate.goal, (candidate.goal,))
        group_goals = [by_goal[goal] for goal in group if goal in by_goal]
        group_goals.sort(key=lambda item: (item.proved_at, item.goal))
        if selected and len(selected) + len(group_goals) > size:
            group_id = tuple(goal.goal for goal in group_goals)
            if group_id not in deferred_ids:
                deferred.append(group_id)
                deferred_ids.add(group_id)
            continue
        selected.extend(group_goals)
        selected_ids.update(goal.goal for goal in group_goals)
        if len(selected) >= size:
            break

    return ArchiveProposal(
        block_id=next_block_id(root),
        target_size=size,
        eligible_count=len(all_goals),
        selected_count=len(selected),
        selected_goals=tuple(selected),
        deferred_groups=tuple(deferred),
    )


def render_text(proposal: ArchiveProposal) -> str:
    lines = [
        f"archive block proposal: {proposal.block_id}",
        f"target size: {proposal.target_size}",
        f"eligible proved goals: {proposal.eligible_count}",
        f"selected goals: {proposal.selected_count}",
        "",
    ]
    for index, goal in enumerate(proposal.selected_goals, 1):
        lines.append(
            f"{index:02d}. {goal.goal} -> {goal.module} "
            f"({goal.sha[:12]}, proved_at={goal.proved_at})"
        )
    if proposal.deferred_groups:
        lines.extend(("", "deferred dependency groups:"))
        for group in proposal.deferred_groups:
            lines.append("- " + ", ".join(group))
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--size", type=int, default=DEFAULT_BLOCK_SIZE)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args(argv)
    if args.size < 1:
        parser.error("--size must be positive")
    proposal = propose_archive(args.root, args.size)
    if args.json:
        print(json.dumps(proposal.manifest(), indent=2, sort_keys=True))
    else:
        print(render_text(proposal), end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
