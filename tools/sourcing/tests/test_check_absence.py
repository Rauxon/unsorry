"""Absence-check tests (ADR-012). Fixture mathlib tree — no network, no real mathlib."""
from __future__ import annotations

from pathlib import Path

from tools.sourcing.check_absence import grep_mathlib, main, manifest_rev


def _fixture_mathlib(tmp_path: Path) -> Path:
    mathlib = tmp_path / "Mathlib"
    (mathlib / "Algebra").mkdir(parents=True)
    (mathlib / "Algebra" / "Sums.lean").write_text(
        "theorem sum_range_id (n : ℕ) : ∑ i ∈ range n, i = n * (n - 1) / 2 := by\n  sorry\n",
        encoding="utf-8",
    )
    return mathlib


def test_grep_finds_present_lemma(tmp_path):
    mathlib = _fixture_mathlib(tmp_path)
    hits = grep_mathlib(mathlib, [r"theorem sum_range_id\b"])
    assert len(hits) == 1
    assert "Sums.lean" in hits[0][1]


def test_grep_no_match_for_absent(tmp_path):
    mathlib = _fixture_mathlib(tmp_path)
    assert grep_mathlib(mathlib, [r"sum_range_cube", r"nicomachus"]) == []


def test_main_exit_1_on_possible_duplicate(tmp_path, capsys):
    mathlib = _fixture_mathlib(tmp_path)
    rc = main(["--mathlib", str(mathlib), "--pattern", r"theorem sum_range_id\b"])
    assert rc == 1
    assert "POSSIBLE DUPLICATE" in capsys.readouterr().out


def test_main_exit_0_when_absent(tmp_path, capsys):
    mathlib = _fixture_mathlib(tmp_path)
    rc = main(["--mathlib", str(mathlib), "--pattern", r"sum_range_cube"])
    assert rc == 0
    assert "no local match" in capsys.readouterr().out


def test_main_usage_error_without_pattern(tmp_path):
    assert main(["--mathlib", str(_fixture_mathlib(tmp_path))]) == 2


def test_main_error_on_missing_mathlib(tmp_path):
    assert main(["--mathlib", str(tmp_path / "nope"), "--pattern", "x"]) == 2


def test_manifest_rev(tmp_path):
    (tmp_path / "lake-manifest.json").write_text(
        '{"packages":[{"name":"mathlib","rev":"abc123"}]}', encoding="utf-8")
    assert manifest_rev(tmp_path) == "abc123"
    assert manifest_rev(tmp_path / "empty") is None


def test_json_report_is_deterministic(tmp_path, capsys):
    mathlib = _fixture_mathlib(tmp_path)
    main(["--mathlib", str(mathlib), "--pattern", r"sum_range_cube", "--rev", "r1", "--json"])
    a = capsys.readouterr().out
    main(["--mathlib", str(mathlib), "--pattern", r"sum_range_cube", "--rev", "r1", "--json"])
    b = capsys.readouterr().out
    assert a == b
    assert '"verdict": "no-local-match"' in a
