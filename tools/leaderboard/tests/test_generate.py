from pathlib import Path

from tools.leaderboard.generate import main, proofs, render


def _index(root: Path, sha: str, goal: str, provenance: str = "") -> None:
    path = root / "library" / "index"
    path.mkdir(parents=True, exist_ok=True)
    (path / f"{sha}.aisp").write_text(
        f"𝔸5.1.lemma.{sha[:12]}@2026-06-13\n"
        "γ≔unsorry.lemma.index\n"
        f"⟦Ω:Lemma⟧{{sha≜{sha}; goal≜{goal}; name≜{goal}}}\n"
        f"{provenance}"
        "⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩\n",
        encoding="utf-8",
    )


def _goal(root: Path, goal: str, difficulty: int) -> None:
    path = root / "goals"
    path.mkdir(parents=True, exist_ok=True)
    (path / f"{goal}.aisp").write_text(
        f"⟦Ω:Goal⟧{{id≜{goal}; difficulty≜{difficulty}}}\n",
        encoding="utf-8",
    )


def test_historical_entries_are_unknown_not_guessed(tmp_path):
    _goal(tmp_path, "old-goal", 4)
    _index(tmp_path, "a" * 64, "old-goal")
    data = proofs(tmp_path)
    assert data[0].solver is None
    assert "1 historical/unknown" in render(tmp_path)
    assert "No attributed proofs yet" in render(tmp_path)


def test_contributor_and_model_aggregation(tmp_path):
    provenance = (
        "⟦Π:Provenance⟧{solver≜perttu; agent≜oma-2-c50d; provider≜codex; "
        "model≜gpt-5.1-codex; effort≜xhigh; attempts≜2; solve_s≜90}\n"
    )
    for index, difficulty in enumerate((2, 4)):
        goal = f"goal-{index}"
        _goal(tmp_path, goal, difficulty)
        _index(tmp_path, str(index + 1) * 64, goal, provenance)
    out = render(tmp_path)
    assert "[@perttu](https://github.com/perttu) | 2 | 6 | 1m 30s" in out
    assert "`codex / gpt-5.1-codex` | 2 | 1 | 1m 30s" in out


def test_check_mode_detects_drift(tmp_path):
    _goal(tmp_path, "g", 1)
    _index(tmp_path, "a" * 64, "g")
    (tmp_path / "docs").mkdir()
    assert main(["--check", str(tmp_path)]) == 1
    (tmp_path / "docs" / "leaderboard.md").write_text(
        render(tmp_path), encoding="utf-8"
    )
    assert main(["--check", str(tmp_path)]) == 0
