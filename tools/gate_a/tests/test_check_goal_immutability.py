"""ADR-018 / SPEC-018-A: goal statements are create-only.

The pure cores (`violations`, `archive_retired`) are exercised over
`git diff --name-status` lines and injected archive context; integration tests
drive the CLI against real temporary git repositories to prove the wiring (diff
invocation, archive-manifest resolution, exit codes) end-to-end.
"""
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

from tools.gate_a.check_goal_immutability import archive_retired, violations


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


# --- ADR-041 archive retirement (pure core: archive_retired) ---------------

def _always(_goal_id, _block):  # statement_preserved stub: byte-identical
    return True


def _never(_goal_id, _block):  # statement_preserved stub: archived copy differs
    return False


def test_archive_delete_exempt_when_recorded_and_preserved():
    # A delete whose id is in a manifest AND whose archived statement matches
    # the base ref is a legitimate retirement — moved to `exempt`, not rejected.
    found = ["D goals/nat-add-comm.lean"]
    rejected, exempt = archive_retired(
        found, {"nat-add-comm": "packages/unsorry-archive-0001"}, _always
    )
    assert rejected == []
    assert exempt == ["D goals/nat-add-comm.lean"]


def test_archive_delete_rejected_when_not_in_manifest():
    # No manifest records the id → not an archive retirement, stays rejected.
    found = ["D goals/nat-add-comm.lean"]
    rejected, exempt = archive_retired(found, {}, _always)
    assert rejected == ["D goals/nat-add-comm.lean"]
    assert exempt == []


def test_archive_delete_rejected_when_statement_altered():
    # Recorded in a manifest but the archived copy differs from history — the
    # pin would change under the move; rejected (this is the tampering guard).
    found = ["D goals/nat-add-comm.lean"]
    rejected, exempt = archive_retired(
        found, {"nat-add-comm": "packages/unsorry-archive-0001"}, _never
    )
    assert rejected == ["D goals/nat-add-comm.lean"]
    assert exempt == []


def test_archive_exemption_never_applies_to_modify_or_rename():
    # Only deletes can relocate a preserved copy. Modify/typechange/rename of a
    # recorded id stay rejected even with a permissive preservation stub.
    found = [
        "M goals/nat-add-comm.lean",
        "T goals/nat-add-comm.lean",
        "R goals/nat-add-comm.lean -> goals/renamed.lean",
    ]
    rejected, exempt = archive_retired(
        found, {"nat-add-comm": "packages/unsorry-archive-0001"}, _always
    )
    assert rejected == found
    assert exempt == []


def test_archive_mixed_partitions_each_entry():
    found = [
        "D goals/archived-ok.lean",      # recorded + preserved -> exempt
        "D goals/archived-bad.lean",     # recorded but not preserved -> rejected
        "D goals/not-archived.lean",     # not recorded -> rejected
        "M goals/tampered.lean",         # modify -> rejected
    ]
    blocks = {
        "archived-ok": "packages/unsorry-archive-0001",
        "archived-bad": "packages/unsorry-archive-0001",
    }

    def preserved(goal_id, _block):
        return goal_id == "archived-ok"

    rejected, exempt = archive_retired(found, blocks, preserved)
    assert exempt == ["D goals/archived-ok.lean"]
    assert rejected == [
        "D goals/archived-bad.lean",
        "D goals/not-archived.lean",
        "M goals/tampered.lean",
    ]


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


def _init_repo_with_goal(tmp_path: Path) -> tuple[Path, str, str]:
    """A repo whose base ref has one pinned goal ``g`` with a known statement."""
    repo = tmp_path / "r"
    (repo / "goals").mkdir(parents=True)
    _git(repo.parent, "init", "-q", "r")
    _git(repo, "config", "user.email", "t@t")
    _git(repo, "config", "user.name", "t")
    statement = "theorem g : 1 = 1 := rfl\n"
    (repo / "goals" / "g.lean").write_text(statement)
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "base")
    return repo, _git(repo, "rev-parse", "HEAD"), statement


def _write_manifest(repo: Path, block: str, goals: list[str]) -> None:
    block_dir = repo / "packages" / block
    block_dir.mkdir(parents=True, exist_ok=True)
    (block_dir / "archive-manifest.json").write_text(
        json.dumps({"block_id": block, "goals": [{"goal": g} for g in goals]})
    )


def test_cli_archive_retirement_allowed(tmp_path):
    # ADR-041: deleting an active goal whose statement is preserved byte-identical
    # in a frozen archive block recorded in its manifest → exit 0.
    repo, base, statement = _init_repo_with_goal(tmp_path)
    block = "unsorry-archive-0001"
    archived = repo / "packages" / block / "goals"
    archived.mkdir(parents=True)
    (archived / "g.lean").write_text(statement)  # byte-identical relocation
    _write_manifest(repo, block, ["g"])
    (repo / "goals" / "g.lean").unlink()
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "retire g into archive 0001")
    proc = _run_cli(repo, base)
    assert proc.returncode == 0, proc.stdout + proc.stderr
    assert "retired into archive" in proc.stdout


def test_cli_archive_retirement_rejected_when_statement_differs(tmp_path):
    # Deleting an active goal but archiving a *weakened* statement → exit 1: the
    # pin must move unchanged, this is the tampering guard.
    repo, base, _ = _init_repo_with_goal(tmp_path)
    block = "unsorry-archive-0001"
    archived = repo / "packages" / block / "goals"
    archived.mkdir(parents=True)
    (archived / "g.lean").write_text("theorem g : True := trivial\n")  # altered
    _write_manifest(repo, block, ["g"])
    (repo / "goals" / "g.lean").unlink()
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "retire with altered statement")
    proc = _run_cli(repo, base)
    assert proc.returncode == 1
    assert "goals/g.lean" in proc.stdout + proc.stderr


def test_cli_archive_retirement_rejected_when_not_in_manifest(tmp_path):
    # Deleting an active goal with a matching archived copy on disk but NO
    # manifest entry → exit 1: retirement must be a recorded provenance event.
    repo, base, statement = _init_repo_with_goal(tmp_path)
    block = "unsorry-archive-0001"
    archived = repo / "packages" / block / "goals"
    archived.mkdir(parents=True)
    (archived / "g.lean").write_text(statement)
    _write_manifest(repo, block, [])  # manifest exists but does not list g
    (repo / "goals" / "g.lean").unlink()
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "delete g without recording it")
    proc = _run_cli(repo, base)
    assert proc.returncode == 1
    assert "goals/g.lean" in proc.stdout + proc.stderr
