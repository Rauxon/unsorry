import subprocess
import sys
from pathlib import Path

from tools.gate_a.archive_packages import (
    archive_roots_from_paths,
    changed_archive_roots,
    default_targets,
    forbidden_tokens,
    validate_archive_package,
    validate_changed,
)


def completed(
    argv: tuple[str, ...],
    returncode: int = 0,
    stdout: str = "",
    stderr: str = "",
) -> subprocess.CompletedProcess[str]:
    return subprocess.CompletedProcess(argv, returncode, stdout, stderr)


def _archive(root: Path) -> Path:
    package = root / "packages" / "unsorry-archive-0001"
    (package / "library" / "Unsorry").mkdir(parents=True)
    (package / "goals").mkdir()
    (package / "library" / "Unsorry" / "One.lean").write_text(
        "import Mathlib\n\ntheorem one : True := trivial\n",
        encoding="utf-8",
    )
    (package / "lakefile.toml").write_text(
        'defaultTargets = ["UnsorryArchive0001"]\n',
        encoding="utf-8",
    )
    (package / "lean-toolchain").write_text("leanprover/lean4:v4.30.0\n", encoding="utf-8")
    return package


def test_archive_roots_from_paths(tmp_path: Path):
    assert archive_roots_from_paths(
        tmp_path,
        [
            "packages/unsorry-archive-0001/library/Unsorry/Foo.lean",
            "packages/unsorry-archive-0001/archive-manifest.json",
            "packages/not-an-archive/file",
            "library/Unsorry/Foo.lean",
        ],
    ) == [tmp_path / "packages" / "unsorry-archive-0001"]


def test_changed_archive_roots_from_git_diff(tmp_path: Path):
    def runner(argv, **_kwargs):
        argv = tuple(argv)
        if argv[0] == "git":
            return completed(
                argv,
                stdout="packages/unsorry-archive-0002/library/Unsorry/A.lean\nREADME.md\n",
            )
        raise AssertionError(argv)

    assert changed_archive_roots(tmp_path, "origin/main", runner) == [
        tmp_path / "packages" / "unsorry-archive-0002"
    ]


def test_changed_archive_roots_git_failure_fails_closed(tmp_path: Path):
    def runner(argv, **_kwargs):
        return completed(tuple(argv), returncode=128)

    assert changed_archive_roots(tmp_path, "missing-base", runner) is None


def test_default_targets(tmp_path: Path):
    package = _archive(tmp_path)
    assert default_targets(package) == ["UnsorryArchive0001"]


def test_forbidden_tokens_scan_archive_library(tmp_path: Path):
    package = _archive(tmp_path)
    (package / "library" / "Unsorry" / "Bad.lean").write_text(
        "axiom bad : False\n",
        encoding="utf-8",
    )
    assert forbidden_tokens(package) == ["library/Unsorry/Bad.lean:1: axiom bad : False"]


def test_validate_archive_package_runs_soundness_steps(tmp_path: Path):
    package = _archive(tmp_path)
    calls: list[tuple[tuple[str, ...], str]] = []

    def runner(argv, **kwargs):
        argv = tuple(argv)
        calls.append((argv, kwargs.get("cwd", "")))
        if argv[:3] == (sys.executable, "-m", "tools.gate_a.check_statement_binding"):
            if argv[3] == "generate":
                (package / "library" / "Unsorry" / "OneBinding.lean").write_text(
                    "import Unsorry.One\n\ntheorem one_binding_check : True := one\n",
                    encoding="utf-8",
                )
            elif argv[3] == "clean":
                (package / "library" / "Unsorry" / "OneBinding.lean").unlink(missing_ok=True)
        return completed(argv)

    assert validate_archive_package(tmp_path, package, runner) == 0

    argv_only = [call[0] for call in calls]
    assert (
        sys.executable,
        "-m",
        "tools.gate_b",
        "validate",
        "packages/unsorry-archive-0001",
        "--goals-root",
        "packages/unsorry-archive-0001",
    ) in argv_only
    assert ("lake", "build", "UnsorryArchive0001", "--wfail") in argv_only
    assert ("lake", "env", "leanchecker", "Unsorry.One", "Unsorry.OneBinding") in argv_only


def test_validate_changed_no_archive_changes_is_noop(tmp_path: Path):
    def runner(argv, **_kwargs):
        argv = tuple(argv)
        if argv[0] == "git":
            return completed(argv, stdout="README.md\n")
        raise AssertionError(argv)

    assert validate_changed(tmp_path, "origin/main", runner) == 0
