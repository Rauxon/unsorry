"""ADR-018 / SPEC-018-A: goal statements are create-only.

The pure core (`violations`) is exercised over `git diff --name-status`
lines; one integration test drives the CLI against a real temporary git
repository to prove the wiring (diff invocation, exit codes) end-to-end.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

from tools.gate_a.check_goal_immutability import violations


def test_modify_rejected():
    got = violations(["M\tgoals/nat-add-comm.lean"])
    assert got == ["M goals/nat-add-comm.lean"]


def test_delete_rejected():
    got = violations(["D\tgoals/nat-add-comm.lean"])
    assert got == ["D goals/nat-add-comm.lean"]


def test_rename_rejected():
    # A rename removes the statement from its pinned path — the old side is
    # the violation, whatever the new side is called.
    got = violations(["R100\tgoals/old-goal.lean\tgoals/new-goal.lean"])
    assert got == ["R goals/old-goal.lean -> goals/new-goal.lean"]


def test_typechange_rejected():
    got = violations(["T\tgoals/nat-add-comm.lean"])
    assert got == ["T goals/nat-add-comm.lean"]


def test_add_allowed():
    # Creation is the legitimate path (translate, decompose, backlog seeding).
    assert violations(["A\tgoals/brand-new-goal.lean"]) == []


def test_copy_allowed():
    # A copy leaves the original statement untouched; the new side is creation.
    assert violations(["C75\tgoals/nat-add-comm.lean\tgoals/derived.lean"]) == []


def test_aisp_edits_allowed():
    # Goal records legitimately change (status rewrites, affinity bumps);
    # only the .lean statement is pinned — Gate B recomputes shas FROM it.
    assert violations(["M\tgoals/nat-add-comm.aisp", "D\tgoals/stale.aisp"]) == []


def test_non_goal_paths_ignored():
    # Defensive: the diff is path-scoped to goals/, but the parser must not
    # fire on other trees if a caller widens it.
    assert violations(["M\tlibrary/Unsorry/NatAddComm.lean"]) == []


def test_mixed_diff_reports_only_violations():
    got = violations(
        [
            "A\tgoals/new-sub.lean",
            "M\tgoals/new-sub.aisp",
            "M\tgoals/tampered.lean",
            "",  # blank lines tolerated
        ]
    )
    assert got == ["M goals/tampered.lean"]


def _git(repo: Path, *args: str) -> str:
    return subprocess.run(
        ["git", "-C", str(repo), *args],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def _run_cli(repo: Path, base: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, "-m", "tools.gate_a.check_goal_immutability",
         "--base", base, "--repo", str(repo)],
        capture_output=True,
        text=True,
        cwd=Path(__file__).resolve().parents[3],
    )


def test_cli_against_real_repository(tmp_path):
    repo = tmp_path / "r"
    (repo / "goals").mkdir(parents=True)
    _git(repo.parent, "init", "-q", "r")
    _git(repo, "config", "user.email", "t@t")
    _git(repo, "config", "user.name", "t")
    (repo / "goals" / "g.lean").write_text("theorem g : 1 = 1 := rfl\n")
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "base")
    base = _git(repo, "rev-parse", "HEAD")

    # Creation only → exit 0.
    (repo / "goals" / "h.lean").write_text("theorem h : 2 = 2 := by sorry\n")
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "add h")
    assert _run_cli(repo, base).returncode == 0

    # Tampering with the existing statement → exit 1, file named.
    (repo / "goals" / "g.lean").write_text("theorem g : True := trivial\n")
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "tamper")
    proc = _run_cli(repo, base)
    assert proc.returncode == 1
    assert "goals/g.lean" in proc.stdout + proc.stderr
