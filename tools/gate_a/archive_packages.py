"""Validate ADR-041 archive packages touched by a PR.

Archive packages live under ``packages/unsorry-archive-*``. They are separate
Lake packages, so active-library replay/audit scoping does not see their
``library/`` trees. This helper gives Gate A an explicit archive-boundary check.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path
from typing import Callable, Sequence

from tools.gate_a.parallel_modules import REPLAY_CHUNK_SIZE, module_names, split_evenly

ARCHIVE_PREFIX = "packages/unsorry-archive-"
FORBIDDEN_RE = re.compile(
    r"\b(sorry|admit|sorryAx|native_decide|axiom|unsafe|implemented_by|extern)\b"
)

Runner = Callable[..., subprocess.CompletedProcess[str]]


def changed_paths(root: Path, base: str, runner: Runner = subprocess.run) -> list[str] | None:
    res = runner(
        ("git", "-C", str(root), "diff", "--name-only", base, "HEAD"),
        check=False,
        text=True,
        capture_output=True,
    )
    if res.returncode != 0:
        return None
    return [line.strip() for line in res.stdout.splitlines() if line.strip()]


def archive_root_for_path(root: Path, path: str) -> Path | None:
    parts = Path(path).parts
    if len(parts) < 2 or parts[0] != "packages":
        return None
    package = parts[1]
    if not package.startswith("unsorry-archive-"):
        return None
    return root / "packages" / package


def archive_roots_from_paths(root: Path, paths: Sequence[str]) -> list[Path]:
    roots = {archive_root for path in paths if (archive_root := archive_root_for_path(root, path))}
    return sorted(roots)


def archive_roots(root: Path) -> list[Path]:
    packages = root / "packages"
    if not packages.is_dir():
        return []
    return sorted(path for path in packages.glob("unsorry-archive-*") if path.is_dir())


def changed_archive_roots(
    root: Path, base: str | None, runner: Runner = subprocess.run
) -> list[Path] | None:
    if base is None:
        return archive_roots(root)
    paths = changed_paths(root, base, runner)
    if paths is None:
        return None
    return archive_roots_from_paths(root, paths)


def default_targets(package_root: Path) -> list[str]:
    lakefile = package_root / "lakefile.toml"
    if not lakefile.is_file():
        return []
    match = re.search(
        r"^defaultTargets\s*=\s*\[([^\]]*)\]",
        lakefile.read_text(encoding="utf-8"),
        re.MULTILINE,
    )
    if not match:
        return []
    return re.findall(r'"([^"]+)"', match.group(1))


def forbidden_tokens(package_root: Path) -> list[str]:
    findings: list[str] = []
    library = package_root / "library"
    if not library.is_dir():
        return findings
    for path in sorted(library.rglob("*.lean")):
        for line_no, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if FORBIDDEN_RE.search(line):
                findings.append(f"{path.relative_to(package_root)}:{line_no}: {line.strip()}")
    return findings


def run_step(
    label: str,
    argv: tuple[str, ...],
    *,
    cwd: Path,
    runner: Runner = subprocess.run,
) -> int:
    print(f"[archive] {label}: {' '.join(argv)}")
    result = runner(argv, cwd=str(cwd), check=False, text=True, capture_output=True)
    if result.stdout:
        print(result.stdout, end="")
    if result.stderr:
        print(result.stderr, end="", file=sys.stderr)
    if result.returncode != 0:
        print(f"[archive] {label} failed with exit code {result.returncode}", file=sys.stderr)
    return result.returncode


def validate_archive_package(
    repo_root: Path,
    package_root: Path,
    runner: Runner = subprocess.run,
) -> int:
    rel = package_root.relative_to(repo_root)
    if not (package_root / "lakefile.toml").is_file():
        print(f"[archive] {rel}: missing lakefile.toml", file=sys.stderr)
        return 1
    if not (package_root / "lean-toolchain").is_file():
        print(f"[archive] {rel}: missing lean-toolchain", file=sys.stderr)
        return 1
    modules = module_names(package_root, "library")
    if not modules:
        print(f"[archive] {rel}: no archive library modules", file=sys.stderr)
        return 1

    findings = forbidden_tokens(package_root)
    if findings:
        print(f"[archive] forbidden token(s) in {rel}/library:", file=sys.stderr)
        for finding in findings:
            print(f"  {finding}", file=sys.stderr)
        return 1

    gate_b = run_step(
        f"{rel} Gate B metadata",
        (
            sys.executable,
            "-m",
            "tools.gate_b",
            "validate",
            str(rel),
            "--goals-root",
            str(rel),
        ),
        cwd=repo_root,
        runner=runner,
    )
    if gate_b != 0:
        return gate_b

    generate = run_step(
        f"{rel} statement bindings",
        (sys.executable, "-m", "tools.gate_a.check_statement_binding", "generate", str(rel)),
        cwd=repo_root,
        runner=runner,
    )
    if generate != 0:
        return generate

    modules = module_names(package_root, "library")
    targets = default_targets(package_root)
    build_argv = ("lake", "build", *targets, "--wfail") if targets else ("lake", "build", "--wfail")
    try:
        cache = run_step(f"{rel} Mathlib cache", ("lake", "exe", "cache", "get"), cwd=package_root, runner=runner)
        if cache != 0:
            return cache
        build = run_step(f"{rel} Lake build", build_argv, cwd=package_root, runner=runner)
        if build != 0:
            return build
        # leanchecker holds ~all of mathlib resident per process, so replaying
        # every package module in one invocation OOM-kills a memory-bound runner
        # (exit 137 on a 30-proof block ≈ 60 modules with bindings). Chunk it like
        # the active replay (REPLAY_CHUNK_SIZE), run serially.
        n_chunks = max(1, (len(modules) + REPLAY_CHUNK_SIZE - 1) // REPLAY_CHUNK_SIZE)
        for index, chunk in enumerate(split_evenly(modules, n_chunks), 1):
            replay = run_step(
                f"{rel} leanchecker replay chunk {index}/{n_chunks}",
                ("lake", "env", "leanchecker", *chunk),
                cwd=package_root,
                runner=runner,
            )
            if replay != 0:
                return replay
    finally:
        run_step(
            f"{rel} clean generated bindings",
            (sys.executable, "-m", "tools.gate_a.check_statement_binding", "clean", str(rel)),
            cwd=repo_root,
            runner=runner,
        )

    print(f"[archive] {rel}: validated {len(modules)} module(s)")
    return 0


def validate_changed(
    root: Path,
    base: str | None,
    runner: Runner = subprocess.run,
) -> int:
    roots = changed_archive_roots(root, base, runner)
    if roots is None:
        print("[archive] cannot compute changed archive packages; validating all archives")
        roots = archive_roots(root)
    if not roots:
        print("[archive] no changed archive packages")
        return 0
    for package_root in roots:
        result = validate_archive_package(root, package_root, runner)
        if result != 0:
            return result
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("validate-changed",))
    parser.add_argument("--root", type=Path, default=Path("."))
    parser.add_argument("--base", default=None)
    args = parser.parse_args(argv)
    root = args.root.resolve()
    if args.command == "validate-changed":
        return validate_changed(root, args.base)
    raise AssertionError(args.command)


if __name__ == "__main__":
    raise SystemExit(main())
