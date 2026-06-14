import json
from pathlib import Path

from tools.archive.plan import archived_goal_ids, next_block_id, propose_archive, render_text


def _goal(root: Path, goal: str, sha: str, *, deps: str = "⟨⟩", date: str = "2026-06-10") -> None:
    (root / "goals").mkdir(parents=True, exist_ok=True)
    (root / "goals" / f"{goal}.aisp").write_text(
        f"""𝔸5.1.goal.{goal}@{date}
γ≔unsorry.goal
⟦Ω:Goal⟧{{id≜{goal}; phase≜prove; status≜proved; difficulty≜1}}
⟦Γ:Deps⟧{{deps≜{deps}}}
⟦Λ:Artifact⟧{{lean≜goals/{goal}.lean; sha≜{sha}; aff≜1}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
""",
        encoding="utf-8",
    )


def _index(root: Path, goal: str, sha: str, theorem: str) -> None:
    (root / "library" / "index").mkdir(parents=True, exist_ok=True)
    (root / "library" / "index" / f"{sha}.aisp").write_text(
        f"""𝔸5.1.lemma.{sha[:12]}@2026-06-10
γ≔unsorry.lemma.index
⟦Ω:Lemma⟧{{sha≜{sha}; goal≜{goal}; name≜{theorem}}}
⟦Σ:Source⟧{{src≜goals/{goal}.lean}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
""",
        encoding="utf-8",
    )


def _module(root: Path, stem: str, theorem: str) -> None:
    (root / "library" / "Unsorry").mkdir(parents=True, exist_ok=True)
    (root / "library" / "Unsorry" / f"{stem}.lean").write_text(
        f"import Mathlib\n\ntheorem {theorem} : True := trivial\n",
        encoding="utf-8",
    )


def _run(root: Path, goal: str, ended: str) -> None:
    (root / "proof-runs").mkdir(parents=True, exist_ok=True)
    (root / "proof-runs" / f"{goal}.agent.20260610t000000z-00000000.aisp").write_text(
        f"""𝔸5.1.run.{goal}.agent.20260610t000000z-00000000@2026-06-10
γ≔unsorry.proof.run
⟦Ω:Run⟧{{id≜20260610t000000z-00000000; goal≜{goal}; agent≜agent; outcome≜proved}}
⟦Λ:Metrics⟧{{attempts≜1; solve_s≜1; ended≜{ended}; lessons≜0}}
⟦Σ:Artifact⟧{{sha≜{"a" * 64}}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
""",
        encoding="utf-8",
    )


def _proved(root: Path, goal: str, number: int, *, deps: str = "⟨⟩", ended: str | None = None) -> None:
    sha = f"{number:064x}"
    theorem = goal.replace("-", "_")
    stem = "".join(part.capitalize() for part in goal.split("-"))
    _goal(root, goal, sha, deps=deps)
    _index(root, goal, sha, theorem)
    _module(root, stem, theorem)
    if ended:
        _run(root, goal, ended)


def test_archive_plan_selects_oldest_block(tmp_path: Path):
    _proved(tmp_path, "newer", 1, ended="2026-06-12T00:00:00Z")
    _proved(tmp_path, "older", 2, ended="2026-06-10T00:00:00Z")
    _proved(tmp_path, "middle", 3, ended="2026-06-11T00:00:00Z")

    proposal = propose_archive(tmp_path, size=2)

    assert proposal.block_id == "unsorry-archive-0001"
    assert [goal.goal for goal in proposal.selected_goals] == ["older", "middle"]
    assert "01. older -> Unsorry.Older" in render_text(proposal)


def test_archive_plan_excludes_existing_manifest(tmp_path: Path):
    _proved(tmp_path, "one", 1)
    _proved(tmp_path, "two", 2)
    manifest = tmp_path / "packages" / "unsorry-archive-0001" / "archive-manifest.json"
    manifest.parent.mkdir(parents=True)
    manifest.write_text(json.dumps({"goals": [{"goal": "one"}]}), encoding="utf-8")

    assert archived_goal_ids(tmp_path) == {"one"}
    assert next_block_id(tmp_path) == "unsorry-archive-0002"
    proposal = propose_archive(tmp_path, size=2)
    assert [goal.goal for goal in proposal.selected_goals] == ["two"]


def test_archive_plan_keeps_dependency_group_together(tmp_path: Path):
    _proved(tmp_path, "dep", 1, ended="2026-06-10T00:00:00Z")
    _proved(tmp_path, "parent", 2, deps="⟨dep⟩", ended="2026-06-11T00:00:00Z")
    _proved(tmp_path, "other", 3, ended="2026-06-12T00:00:00Z")

    proposal = propose_archive(tmp_path, size=2)

    assert [goal.goal for goal in proposal.selected_goals] == ["dep", "parent"]


def test_archive_plan_reports_deferred_group_once(tmp_path: Path):
    _proved(tmp_path, "first", 1, ended="2026-06-10T00:00:00Z")
    _proved(tmp_path, "second", 2, ended="2026-06-11T00:00:00Z")
    _proved(tmp_path, "dep", 3, ended="2026-06-12T00:00:00Z")
    _proved(tmp_path, "parent", 4, deps="⟨dep⟩", ended="2026-06-13T00:00:00Z")

    proposal = propose_archive(tmp_path, size=3)

    assert [goal.goal for goal in proposal.selected_goals] == ["first", "second"]
    assert proposal.deferred_groups == (("dep", "parent"),)
