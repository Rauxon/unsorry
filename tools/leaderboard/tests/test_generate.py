import json
import os
from pathlib import Path
import subprocess

from tools.leaderboard.generate import (
    attribution_gaps_payload,
    base_stats,
    main,
    proofs,
    provenance_phantoms,
    render,
    render_attribution_gaps_json,
    render_json,
    render_svg,
    render_ui_json,
    ui_payload,
)


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


def _goal(root: Path, goal: str, difficulty: int, status: str = "open") -> None:
    path = root / "goals"
    path.mkdir(parents=True, exist_ok=True)
    (path / f"{goal}.aisp").write_text(
        f"⟦Ω:Goal⟧{{id≜{goal}; status≜{status}; difficulty≜{difficulty}}}\n",
        encoding="utf-8",
    )


def _git(root: Path, *args: str, author: str | None = None) -> None:
    env = os.environ.copy()
    if author:
        name, email = author.rsplit(" <", 1)
        email = email.rstrip(">")
        env.update({
            "GIT_AUTHOR_NAME": name,
            "GIT_AUTHOR_EMAIL": email,
            "GIT_COMMITTER_NAME": name,
            "GIT_COMMITTER_EMAIL": email,
        })
    subprocess.run(
        ["git", "-C", str(root), *args],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=env,
    )


def _alias(root: Path, git_author: str, github: str, display_name: str) -> None:
    path = root / "docs" / "metrics"
    path.mkdir(parents=True, exist_ok=True)
    (path / "contributor-aliases.json").write_text(
        json.dumps(
            {
                "schema_version": 1,
                "git_authors": {
                    git_author: {
                        "github": github,
                        "display_name": display_name,
                        "evidence": "test fixture",
                    }
                },
            },
            indent=2,
            sort_keys=True,
        )
        + "\n",
        encoding="utf-8",
    )


def _run(
    root: Path,
    goal: str,
    run_id: str,
    outcome: str,
    *,
    attempts: int,
    solve_s: int,
    solver: str = "perttu",
    provider: str = "codex",
    model: str = "gpt-5.1-codex",
    lessons: int | None = None,
    lesson_sig: str | None = None,
) -> None:
    agent = "oma-2-c50d"
    path = root / "proof-runs"
    path.mkdir(parents=True, exist_ok=True)
    sha = "a" * 64 if outcome == "proved" else "∅"
    metrics = f"attempts≜{attempts}; solve_s≜{solve_s}; ended≜2026-06-13T12:00:00Z"
    if lessons is not None:
        metrics += f"; lessons≜{lessons}"
    lesson_block = "" if lesson_sig is None else f"⟦Δ:Lesson⟧{{sig≜{lesson_sig}}}\n"
    (path / f"{goal}.{agent}.{run_id}.aisp").write_text(
        f"𝔸5.1.run.{goal}.{agent}.{run_id}@2026-06-13\n"
        "γ≔unsorry.proof.run\n"
        f"⟦Ω:Run⟧{{id≜{run_id}; goal≜{goal}; agent≜{agent}; "
        f"outcome≜{outcome}}}\n"
        f"⟦Π:Provenance⟧{{solver≜{solver}; provider≜{provider}; model≜{model}; "
        "effort≜xhigh}\n"
        f"⟦Λ:Metrics⟧{{{metrics}}}\n"
        f"⟦Σ:Artifact⟧{{sha≜{sha}}}\n"
        f"{lesson_block}"
        "⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩\n",
        encoding="utf-8",
    )


def test_historical_entries_are_unknown_not_guessed(tmp_path):
    _goal(tmp_path, "old-goal", 4)
    _index(tmp_path, "a" * 64, "old-goal")
    data = proofs(tmp_path)
    assert data[0].solver is None
    assert "1 historical/unknown" in render(tmp_path)
    assert "No credited work yet" in render(tmp_path)
    assert ui_payload(tmp_path)["contributors"] == []


def test_git_add_author_is_historical_visibility_not_solver_credit(tmp_path):
    _git(tmp_path, "init")
    _goal(tmp_path, "old-goal", 4)
    _index(tmp_path, "a" * 64, "old-goal")
    _git(tmp_path, "add", "goals", "library/index")
    _git(
        tmp_path,
        "commit",
        "-m",
        "add historical proof",
        author="Ada Lovelace <ada@example.test>",
    )
    _alias(tmp_path, "Ada Lovelace <ada@example.test>", "ada", "Ada Lovelace")

    stats = base_stats(tmp_path)
    assert stats["contributors"] == []
    historical = stats["historical_attribution"]
    assert historical["git_attributed_index_files"] == 1
    assert historical["author_count"] == 1
    assert historical["authors"][0]["display_name"] == "Ada Lovelace"
    assert historical["authors"][0]["github"] == "ada"
    assert historical["authors"][0]["missing_solver_provenance"] == 1
    assert historical["authors"][0]["solver_credit"] is False

    payload = ui_payload(tmp_path)
    assert payload["summary"]["git_attributed_index_files"] == 1
    assert payload["summary"]["historical_contributors"] == 1
    assert payload["summary"]["credited_proofs"] == 1
    assert payload["summary"]["explicit_solver_proofs"] == 0
    assert payload["summary"]["inferred_git_proofs"] == 1
    assert payload["summary"]["uncredited_proofs"] == 0
    assert payload["contributors"][0]["display_name"] == "@ada"
    assert payload["contributors"][0]["verified_proofs"] == 1
    assert payload["contributors"][0]["credited_proofs"] == 1
    assert payload["contributors"][0]["explicit_solver_proofs"] == 0
    assert payload["contributors"][0]["inferred_git_proofs"] == 1
    assert payload["contributors"][0]["credit_source_summary"] == "inferred"
    assert payload["contributors"][0]["score"] == 425
    assert payload["historical_contributors"][0]["profile_url"] == "https://github.com/ada"
    assert payload["historical_contributors"][0]["solver_credit"] is False

    gaps = attribution_gaps_payload(tmp_path)
    assert gaps["summary"] == {
        "git_attributed_missing_solver": 1,
        "mapped_missing_solver": 1,
        "missing_solver_provenance": 1,
        "unmapped_missing_solver": 0,
    }
    assert gaps["missing_solver_provenance"][0]["mapped_github"] == "ada"
    assert json.loads(render_attribution_gaps_json(tmp_path)) == gaps
    svg = render_svg(tmp_path)
    assert "@ada" in svg
    assert "1 proofs" in svg
    assert "0 explicit" in svg
    assert "1 inferred" in svg


def test_base_stats_derive_failure_and_efficiency_metrics(tmp_path):
    provenance = (
        "⟦Π:Provenance⟧{solver≜perttu; agent≜oma-2-c50d; provider≜codex; "
        "model≜gpt-5.1-codex; effort≜xhigh; attempts≜2; solve_s≜90}\n"
    )
    _goal(tmp_path, "goal-ok", 4, "proved")
    _goal(tmp_path, "goal-hard", 5, "blocked")
    _index(tmp_path, "a" * 64, "goal-ok", provenance)
    _run(
        tmp_path,
        "goal-ok",
        "20260613t120000000000z-11111111",
        "proved",
        attempts=2,
        solve_s=90,
    )
    _run(
        tmp_path,
        "goal-hard",
        "20260613t120100000000z-22222222",
        "decomposed",
        attempts=3,
        solve_s=210,
    )

    stats = base_stats(tmp_path)
    assert stats["outcomes"] == {
        "runs": 2,
        "successes": 1,
        "failures": 1,
        "run_success_rate": 0.5,
        "attempts": 5,
        "failed_attempts": 4,
        "attempt_yield": 0.2,
        "total_solve_s": 300,
        "median_solve_s": 150,
        "p90_solve_s": 210,
        "successes_per_recorded_hour": 12.0,
    }
    assert stats["contributors"][0]["verified_proofs"] == 1
    assert stats["contributors"][0]["difficulty_points"] == 4
    assert stats["models"][0]["runs"] == 2
    assert stats["queue"]["status_counts"] == {"blocked": 1, "proved": 1}
    assert json.loads(render_json(tmp_path))["schema_version"] == 1

    out = render(tmp_path)
    assert "Run success rate | 50.0%" in out
    assert "Failed attempts | 4" in out
    assert "[@perttu](https://github.com/perttu) | 1 | 1 | 0 | 2 | 50.0% | 4 | 425" in out
    assert "`codex / gpt-5.1-codex` | 1 | 2 | 50.0% | 4" in out


def test_lesson_telemetry_is_ignored_by_leaderboard(tmp_path):
    # ADR-024: the optional lessons count and ⟦Δ:Lesson⟧ sig are advisory; the
    # leaderboard must derive identical statistics with or without them.
    plain = tmp_path / "plain"
    laden = tmp_path / "laden"
    for root in (plain, laden):
        _goal(root, "g", 4, "blocked")
    _run(plain, "g", "20260613t120000000000z-11111111", "failed", attempts=3, solve_s=90)
    _run(
        laden,
        "g",
        "20260613t120000000000z-11111111",
        "failed",
        attempts=3,
        solve_s=90,
        lessons=2,
        lesson_sig="unsolved goals ⊢ n + 0 = n",
    )
    assert base_stats(plain) == base_stats(laden)


def test_ui_payload_is_stable_browser_contract(tmp_path):
    perttu_provenance = (
        "⟦Π:Provenance⟧{solver≜perttu; agent≜oma-2-c50d; provider≜codex; "
        "model≜gpt-5.1-codex; effort≜xhigh; attempts≜2; solve_s≜90}\n"
    )
    ada_provenance = (
        "⟦Π:Provenance⟧{solver≜ada; agent≜oma-2-c50d; provider≜codex; "
        "model≜gpt-5.1-codex; effort≜xhigh; attempts≜1; solve_s≜30}\n"
    )
    _goal(tmp_path, "goal-hard", 4, "proved")
    _goal(tmp_path, "goal-easy", 1, "proved")
    _index(tmp_path, "a" * 64, "goal-hard", perttu_provenance)
    _index(tmp_path, "b" * 64, "goal-easy", ada_provenance)
    _run(
        tmp_path,
        "goal-hard",
        "20260613t120000000000z-11111111",
        "proved",
        attempts=2,
        solve_s=90,
        solver="perttu",
    )

    payload = ui_payload(tmp_path)
    assert payload["schema_version"] == 1
    assert payload["generated_from"] == "docs/metrics/community-stats.json"
    assert payload["generated_at"] == "2026-06-13T12:00:00Z"
    assert payload["summary"]["verified_proofs"] == 2
    assert payload["summary"]["historical_unknown_proofs"] == 0
    assert payload["summary"]["credited_proofs"] == 2
    assert payload["summary"]["explicit_solver_proofs"] == 2
    assert payload["summary"]["inferred_git_proofs"] == 0
    assert payload["summary"]["uncredited_proofs"] == 0
    assert payload["summary"]["git_attributed_index_files"] == 0
    assert payload["summary"]["historical_contributors"] == 0

    first = payload["contributors"][0]
    assert first["rank"] == 1
    assert first["solver"] == "perttu"
    assert first["display_name"] == "@perttu"
    assert first["profile_url"] == "https://github.com/perttu"
    assert first["avatar_url"] == "https://github.com/perttu.png?size=96"
    assert first["score"] == 425
    assert first["credited_proofs"] == 1
    assert first["explicit_solver_proofs"] == 1
    assert first["inferred_git_proofs"] == 0
    assert first["credit_source_summary"] == "explicit"
    assert first["badges"] == {
        "proofs": 1,
        "difficulty": 4,
        "success_rate_percent": 100.0,
    }

    second = payload["contributors"][1]
    assert second["solver"] == "ada"
    assert second["score"] == 125
    assert second["badges"]["success_rate_percent"] is None

    # Model distribution for the "Model distribution" section (ADR-023 cohort).
    models = payload["models"]
    assert isinstance(models, list)
    codex = next(m for m in models if m["provider_model"] == "codex / gpt-5.1-codex")
    # Both indexed proofs carry model≜gpt-5.1-codex provenance.
    assert codex["verified_proofs"] == 2
    assert codex["runs"] == 1
    assert set(codex.keys()) == {
        "provider_model",
        "verified_proofs",
        "runs",
        "run_success_rate",
    }

    assert json.loads(render_ui_json(tmp_path)) == payload
    svg = render_svg(tmp_path)
    assert "Unsorry Leaderboard" in svg
    assert "@perttu" in svg
    assert "425 pts" in svg
    assert "href=\"https://github.com/perttu\"" in svg


def test_svg_has_empty_state(tmp_path):
    _goal(tmp_path, "old-goal", 4)
    _index(tmp_path, "a" * 64, "old-goal")
    svg = render_svg(tmp_path)
    assert "No credited proofs yet." in svg
    assert "0 credited proofs" in svg


def test_check_and_write_modes_cover_markdown_json_ui_json_and_svg(tmp_path):
    _goal(tmp_path, "g", 1)
    _index(tmp_path, "a" * 64, "g")
    assert main(["--check", str(tmp_path)]) == 1
    assert main(["--write", str(tmp_path)]) == 0
    assert main(["--check", str(tmp_path)]) == 0
    assert (tmp_path / "docs" / "metrics" / "community-stats.json").is_file()
    ui_path = tmp_path / "docs" / "metrics" / "leaderboard-ui.json"
    assert ui_path.is_file()
    gaps_path = tmp_path / "docs" / "metrics" / "attribution-gaps.json"
    assert gaps_path.is_file()
    assert (tmp_path / "docs" / "leaderboard.svg").is_file()
    ui_path.write_text("{}\n", encoding="utf-8")
    assert main(["--check", str(tmp_path)]) == 1


def test_docs_leaderboard_html_consumes_generated_ui_json():
    root = Path(__file__).resolve().parents[3]
    html = (root / "docs" / "leaderboard.html").read_text(encoding="utf-8")
    assert "metrics/leaderboard-ui.json" in html
    assert "schema_version" in html
    assert "leaderboardData = normalizeRows(payload.contributors)" in html
    assert "explicit_solver_proofs" in html
    assert "inferred_git_proofs" in html
    assert "renderHistoricalContributors" not in html
    # Model distribution section consumes payload.models.
    assert "renderModels" in html
    assert "models-section" in html
    assert "payload.models" in html
    assert "LocalDataStore" not in html
    assert "seedData" not in html
    assert "pravatar" not in html


# --- Phantom-solver guard (ADR-037) ------------------------------------------

_PHANTOM = (
    "⟦Π:Provenance⟧{{solver≜{solver}; agent≜x; provider≜manual; "
    "model≜m; effort≜manual; attempts≜1}}\n"
)


def test_phantom_solver_is_flagged(tmp_path):
    # solver≜ matches no proof-run, no alias, and not the git author → phantom.
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="ghost"))
    _git(tmp_path, "add", "goals", "library/index")
    _git(tmp_path, "commit", "-m", "prove(some-goal)", author="Real Solver <real@e.com>")
    phantoms = provenance_phantoms(tmp_path)
    assert [p["solver"] for p in phantoms] == ["ghost"]
    assert phantoms[0]["goal"] == "some-goal"
    assert phantoms[0]["git_author_name"] == "Real Solver"


def test_solver_corroborated_by_proof_run(tmp_path):
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="realboy"))
    _run(tmp_path, "some-goal", "r1", "proved", attempts=1, solve_s=10, solver="realboy")
    _git(tmp_path, "add", "goals", "library/index", "proof-runs")
    _git(tmp_path, "commit", "-m", "prove", author="Someone Else <e@e.com>")
    assert provenance_phantoms(tmp_path) == []


def test_solver_corroborated_by_alias(tmp_path):
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="octocat"))
    _alias(tmp_path, "Git Name <g@e.com>", "octocat", "Octo Cat")
    _git(tmp_path, "add", "goals", "library/index", "docs")
    _git(tmp_path, "commit", "-m", "prove", author="Git Name <g@e.com>")
    assert provenance_phantoms(tmp_path) == []


def test_solver_corroborated_by_git_author(tmp_path):
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="binto"))
    _git(tmp_path, "add", "goals", "library/index")
    _git(tmp_path, "commit", "-m", "prove", author="binto <b@e.com>")
    assert provenance_phantoms(tmp_path) == []


def test_missing_solver_is_not_a_phantom(tmp_path):
    # No solver≜ at all is a *missing-provenance* gap, not a phantom.
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal")
    _git(tmp_path, "add", "goals", "library/index")
    _git(tmp_path, "commit", "-m", "prove", author="Real <r@e.com>")
    assert provenance_phantoms(tmp_path) == []


def test_audit_provenance_cli_exit_codes(tmp_path):
    _git(tmp_path, "init")
    _goal(tmp_path, "some-goal", 3, status="proved")
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="ghost"))
    _git(tmp_path, "add", "goals", "library/index")
    _git(tmp_path, "commit", "-m", "prove", author="Real <r@e.com>")
    assert main(["--audit-provenance", str(tmp_path)]) == 1
    # Correct the attribution → audit is clean.
    _index(tmp_path, "b" * 64, "some-goal", provenance=_PHANTOM.format(solver="real"))
    assert main(["--audit-provenance", str(tmp_path)]) == 0
