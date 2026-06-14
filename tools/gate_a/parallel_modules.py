"""Run Gate A's module-wide checks in bounded parallel chunks.

Usage:
  python3 -m tools.gate_a.parallel_modules audit --jobs 4 \
    --output axiom-report.json
  python3 -m tools.gate_a.parallel_modules replay --jobs 4
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Sequence

# Modules per serial leanchecker invocation in replay (ADR-006): bounds peak
# memory so the replay step does not OOM the runner as the library grows.
REPLAY_CHUNK_SIZE = 30

# Incremental replay (ADR-033): changing any of these invalidates the
# "unchanged module ⇒ unchanged olean" assumption, so we fall back to a FULL
# replay. Toolchain/lakefile/manifest changes can alter every olean; a change to
# the gate tooling itself must re-verify everything it now governs.
FULL_REPLAY_PATHS = frozenset(
    {"lean-toolchain", "lakefile.toml", "lakefile.lean", "lake-manifest.json"}
)
FULL_REPLAY_PREFIXES = ("tools/gate_a/",)
FULL_REPLAY_EXACT = (".github/workflows/gate-a.yml",)

_IMPORT_RE = re.compile(r"^\s*import\s+(Unsorry\.[A-Za-z0-9_.]+)", re.MULTILINE)


@dataclass(frozen=True)
class Command:
    argv: tuple[str, ...]
    label: str


Runner = Callable[..., subprocess.CompletedProcess[str]]


def available_memory_gb() -> float:
    """Return available physical memory in GB, defaulting to a safe fallback on failure."""
    try:
        # On Linux / Proc filesystem (covers GHA standard runners)
        proc_mem = Path("/proc/meminfo")
        if proc_mem.is_file():
            for line in proc_mem.read_text().splitlines():
                if line.startswith("MemAvailable:"):
                    parts = line.split()
                    if len(parts) >= 2:
                        return float(parts[1]) / (1024 * 1024)
        # On macOS (Darwin)
        if sys.platform == "darwin":
            output = subprocess.check_output(["sysctl", "-n", "hw.memsize"], text=True)
            return float(output.strip()) / (1024 * 1024 * 1024)
    except Exception:
        pass
    return 4.0


def max_safe_jobs(requested_jobs: int) -> int:
    """Cap parallel jobs based on available RAM to prevent OOM kills (exit code 143)."""
    # Each concurrent Lean 4 compiler, audit, or replay process consumes ~3.5 GB of RAM.
    free_ram = available_memory_gb()
    safe_cap = max(1, int(free_ram // 3.5))
    return min(requested_jobs, safe_cap)


def module_names(root: Path, source_dir: str) -> list[str]:
    """Return Lean module names for every source below source_dir."""
    base = root / source_dir
    if not base.is_dir():
        return []
    modules = []
    for path in sorted(base.rglob("*.lean")):
        relative = path.relative_to(root if source_dir == "goals" else base)
        modules.append(".".join(relative.with_suffix("").parts))
    return modules


def split_evenly(items: Sequence[str], chunks: int) -> list[list[str]]:
    """Split items into non-empty, size-balanced contiguous chunks."""
    if not items:
        return []
    count = min(max(chunks, 1), len(items))
    quotient, remainder = divmod(len(items), count)
    result = []
    offset = 0
    for index in range(count):
        size = quotient + (1 if index < remainder else 0)
        result.append(list(items[offset:offset + size]))
        offset += size
    return result


def run_commands(
    commands: Sequence[Command],
    jobs: int,
    runner: Runner = subprocess.run,
) -> list[subprocess.CompletedProcess[str]]:
    def run_one(command: Command) -> subprocess.CompletedProcess[str]:
        return runner(
            command.argv,
            check=False,
            text=True,
            capture_output=True,
        )

    with ThreadPoolExecutor(max_workers=min(jobs, len(commands))) as executor:
        return list(executor.map(run_one, commands))


def report_failures(
    commands: Sequence[Command],
    results: Sequence[subprocess.CompletedProcess[str]],
) -> bool:
    failed = False
    for command, result in zip(commands, results, strict=True):
        if result.stderr:
            print(result.stderr, end="", file=sys.stderr)
        if result.returncode != 0:
            failed = True
            print(
                f"{command.label} failed with exit code {result.returncode}",
                file=sys.stderr,
            )
            if result.stdout:
                print(result.stdout, end="", file=sys.stderr)
    return failed


def audit(
    root: Path,
    jobs: int,
    output: Path,
    runner: Runner = subprocess.run,
) -> int:
    library = module_names(root, "library")
    goals = module_names(root, "goals")
    if not library and not goals:
        print("no library or goal modules found", file=sys.stderr)
        return 2

    build = runner(
        ("lake", "build", "axiom_audit"),
        check=False,
        text=True,
        capture_output=True,
    )
    if build.returncode != 0:
        print(build.stdout, end="", file=sys.stderr)
        print(build.stderr, end="", file=sys.stderr)
        return build.returncode

    # axiom_audit is memory-intensive as it loads large Mathlib environment;
    # dynamically limit parallelism based on available memory to prevent OOM kills.
    audit_jobs = max_safe_jobs(jobs)
    library_jobs = max(1, audit_jobs // 2) if library and goals else audit_jobs
    goal_jobs = audit_jobs - library_jobs if library and goals else audit_jobs
    commands = [
        Command(
            ("lake", "exe", "axiom_audit", *chunk),
            f"library audit chunk {index}",
        )
        for index, chunk in enumerate(split_evenly(library, library_jobs), 1)
    ]
    commands.extend(
        Command(
            ("lake", "exe", "axiom_audit", "--allow-sorry", *chunk),
            f"goal audit chunk {index}",
        )
        for index, chunk in enumerate(split_evenly(goals, goal_jobs), 1)
    )

    results = run_commands(commands, audit_jobs, runner)
    if report_failures(commands, results):
        return 1

    combined: list[dict[str, object]] = []
    for command, result in zip(commands, results, strict=True):
        try:
            report = json.loads(result.stdout)
        except json.JSONDecodeError as exc:
            print(f"{command.label} returned invalid JSON: {exc}", file=sys.stderr)
            return 1
        if not isinstance(report, list):
            print(f"{command.label} returned a non-array report", file=sys.stderr)
            return 1
        combined.extend(report)

    combined.sort(key=lambda item: str(item.get("decl", "")))
    output.write_text(json.dumps(combined, indent=2) + "\n", encoding="utf-8")
    print(
        f"audited {len(library)} library and {len(goals)} goal module(s) "
        f"in {len(commands)} chunk(s)"
    )
    return 0


def library_module_for_path(path: str) -> str | None:
    """`library/Unsorry/Foo.lean` -> `Unsorry.Foo`; None if not a library Lean
    source. Matches module_names()'s library naming."""
    p = path.strip()
    if not (p.startswith("library/") and p.endswith(".lean")):
        return None
    return p[len("library/"):-len(".lean")].replace("/", ".")


def changed_paths(root: Path, base: str, runner: Runner = subprocess.run) -> list[str] | None:
    """Repo-relative paths changed between `base` and HEAD, or None if git can't
    answer (shallow clone missing base, not a repo, …) — the caller then does a
    FULL replay rather than trusting an empty diff."""
    res = runner(
        ("git", "-C", str(root), "diff", "--name-only", base, "HEAD"),
        check=False,
        text=True,
        capture_output=True,
    )
    if res.returncode != 0:
        return None
    return [line.strip() for line in res.stdout.splitlines() if line.strip()]


def forces_full_replay(paths: Sequence[str]) -> str | None:
    """Return the offending path if any change forces a full replay, else None."""
    for p in paths:
        if (
            p in FULL_REPLAY_PATHS
            or p in FULL_REPLAY_EXACT
            or any(p.startswith(prefix) for prefix in FULL_REPLAY_PREFIXES)
        ):
            return p
    return None


def import_graph(root: Path) -> dict[str, set[str]]:
    """Map each on-disk library module to the set of `Unsorry.*` modules it
    imports (parsed from `import` lines)."""
    base = root / "library"
    graph: dict[str, set[str]] = {}
    if not base.is_dir():
        return graph
    for path in sorted(base.rglob("*.lean")):
        module = ".".join(path.relative_to(base).with_suffix("").parts)
        text = path.read_text(encoding="utf-8", errors="replace")
        graph[module] = set(_IMPORT_RE.findall(text))
    return graph


def replay_scope(changed_modules: Sequence[str], graph: dict[str, set[str]]) -> list[str]:
    """The replay set: every changed module plus the transitive *reverse*-import
    closure (every on-disk module that imports, directly or transitively, a
    changed module). A module outside this set has an unchanged source AND only
    depends on unchanged modules, so its rebuilt olean is byte-identical to the
    one already kernel-replayed on `main` (ADR-033). Generated `*Binding` modules
    `import Unsorry.<Base>`, so a changed base pulls its binding in here too.
    Intersected with `graph` so deleted modules (no olean to check) drop out."""
    importers: dict[str, set[str]] = {}
    for module, imports in graph.items():
        for imported in imports:
            importers.setdefault(imported, set()).add(module)
    seen: set[str] = set()
    stack = list(changed_modules)
    while stack:
        module = stack.pop()
        if module in seen:
            continue
        seen.add(module)
        stack.extend(importers.get(module, ()))
    return sorted(seen & set(graph))


def scoped_targets(
    root: Path, base: str, runner: Runner = subprocess.run
) -> list[str] | None:
    """Modules to replay for an incremental run, or None to fall back to FULL
    replay (git unavailable, or a global-impact change). An empty list means
    "no library change — nothing to replay"."""
    paths = changed_paths(root, base, runner)
    if paths is None:
        print(
            f"incremental replay: cannot diff against {base!r} — FULL replay",
            file=sys.stderr,
        )
        return None
    offender = forces_full_replay(paths)
    if offender is not None:
        print(
            f"incremental replay: global-impact change {offender!r} — FULL replay",
            file=sys.stderr,
        )
        return None
    changed = [m for m in (library_module_for_path(p) for p in paths) if m]
    if not changed:
        return []
    return replay_scope(changed, import_graph(root))


def replay(
    root: Path,
    jobs: int,
    runner: Runner = subprocess.run,
    base: str | None = None,
) -> int:
    library = module_names(root, "library")
    if not library:
        print("no library modules found", file=sys.stderr)
        return 2

    # Incremental replay (ADR-033): when a PR base is supplied, replay only the
    # changed library modules and their reverse-import closure; the rest are
    # byte-identical to (and already verified on) main. Falls back to FULL replay
    # whenever the incremental assumption cannot be trusted.
    targets = library
    if base is not None:
        scoped = scoped_targets(root, base, runner)
        if scoped is None:
            pass  # reason already logged; full replay below
        elif not scoped:
            print("kernel replay: no changed library modules — nothing to verify")
            return 0
        else:
            targets = scoped
            print(
                f"incremental kernel replay: {len(targets)} of {len(library)} "
                "module(s) (changed + reverse-import closure)"
            )
    # leanchecker re-checks every declaration against the kernel and holds
    # ~all of mathlib resident per process, so its memory cost is essentially
    # fixed regardless of how few library modules a chunk carries. Two
    # concurrent invocations therefore OOM-kill a standard CI runner (the
    # replay step died with exit 143 repo-wide after #264 set --jobs 4 — the
    # earlier min(jobs, 2) cap was not enough). Replay runs serially: one
    # leanchecker over the whole library, one mathlib image in memory. The
    # `jobs` argument is accepted for CLI symmetry with `audit` but ignored
    # here; audit (collectAxioms, far lighter) keeps its parallelism.
    _ = jobs
    n_chunks = max(1, (len(targets) + REPLAY_CHUNK_SIZE - 1) // REPLAY_CHUNK_SIZE)
    commands = [
        Command(
            ("lake", "env", "leanchecker", *chunk),
            f"kernel replay chunk {index}/{n_chunks}",
        )
        for index, chunk in enumerate(split_evenly(targets, n_chunks), 1)
    ]
    # parallelism 1: chunks run one after another, never concurrently.
    results = run_commands(commands, 1, runner)
    if report_failures(commands, results):
        return 1
    print(f"replayed {len(targets)} library module(s) serially in {len(commands)} chunk(s)")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("audit", "replay"))
    parser.add_argument("--jobs", type=int, default=4)
    parser.add_argument("--output", type=Path, default=Path("axiom-report.json"))
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument(
        "--base",
        default=None,
        help="replay only: PR base ref/sha. Replays just the changed library "
        "modules and their reverse-import closure (ADR-033). Omit for a full "
        "replay (the post-merge backstop on main).",
    )
    args = parser.parse_args(argv)
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    if args.command == "audit":
        return audit(args.root, args.jobs, args.output)
    return replay(args.root, args.jobs, base=args.base)


if __name__ == "__main__":
    raise SystemExit(main())
