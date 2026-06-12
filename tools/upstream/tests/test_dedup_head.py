"""ADR-020 / SPEC-020-A: dedup against mathlib HEAD."""
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

from tools.upstream.dedup_head import dedup, default_patterns


def _mk_root(tmp_path: Path, goal: str, name: str) -> Path:
    root = tmp_path / "repo"
    (root / "library" / "index").mkdir(parents=True)
    sha = f"{abs(hash(goal)):064x}"[:64]
    (root / "library" / "index" / f"{sha}.aisp").write_text(
        f"⟦Ω:Lemma⟧{{sha≜{sha}; goal≜{goal}; name≜{name}}}\n", encoding="utf-8"
    )
    return root


def _mk_mathlib(tmp_path: Path, content: str) -> Path:
    ml = tmp_path / "mathlib" / "Mathlib"
    ml.mkdir(parents=True)
    (ml / "Some.lean").write_text(content, encoding="utf-8")
    return ml


def test_default_patterns_use_index_theorem_name(tmp_path):
    root = _mk_root(tmp_path, "novel-lemma", "novel_lemma_thm")
    pats = default_patterns(root, "novel-lemma")
    assert any("novel_lemma_thm" in p for p in pats)


def test_clean_head_reports_no_local_match(tmp_path):
    root = _mk_root(tmp_path, "novel-lemma", "novel_lemma_thm")
    ml = _mk_mathlib(tmp_path, "theorem unrelated : 1 = 1 := rfl\n")
    report = dedup(root, "novel-lemma", ml, rev="abc123", extra_patterns=[])
    assert report["verdict"] == "no-local-match"
    assert report["mathlib_rev"] == "abc123"
    assert report["goal"] == "novel-lemma"


def test_planted_duplicate_is_found(tmp_path):
    root = _mk_root(tmp_path, "novel-lemma", "novel_lemma_thm")
    ml = _mk_mathlib(tmp_path, "theorem novel_lemma_thm : 1 = 1 := rfl\n")
    report = dedup(root, "novel-lemma", ml, rev="abc123", extra_patterns=[])
    assert report["verdict"] == "possible-duplicate"
    assert report["local_matches"]


def test_extra_patterns_are_applied(tmp_path):
    root = _mk_root(tmp_path, "novel-lemma", "novel_lemma_thm")
    ml = _mk_mathlib(tmp_path, "theorem other_name (n : Nat) : distinctive_shape n\n")
    report = dedup(root, "novel-lemma", ml, rev="r", extra_patterns=["distinctive_shape"])
    assert report["verdict"] == "possible-duplicate"


def test_cli_emits_json(tmp_path):
    root = _mk_root(tmp_path, "novel-lemma", "novel_lemma_thm")
    ml = _mk_mathlib(tmp_path, "theorem unrelated : 1 = 1 := rfl\n")
    proc = subprocess.run(
        [sys.executable, "-m", "tools.upstream.dedup_head",
         "--goal", "novel-lemma", "--root", str(root),
         "--mathlib", str(ml), "--rev", "deadbeef"],
        capture_output=True, text=True,
        cwd=Path(__file__).resolve().parents[3],
    )
    assert proc.returncode == 0, proc.stderr
    report = json.loads(proc.stdout)
    assert report["verdict"] == "no-local-match"
    assert report["mathlib_rev"] == "deadbeef"


def test_index_name_is_not_fooled_by_subgoal_prefix(tmp_path):
    # goal≜parent must not match goal≜parent-s1's entry (a substring scan made
    # the sub's theorem name leak into the parent's packet on the real tree).
    # Deterministic regardless of glob order: only the sub exists, so the
    # parent must find NOTHING.
    root = tmp_path / "repo"
    (root / "library" / "index").mkdir(parents=True)
    (root / "library" / "index" / ("aa" * 32 + ".aisp")).write_text(
        "⟦Ω:Lemma⟧{sha≜" + "aa" * 32 + "; goal≜parent-s1; name≜sub_thm}\n",
        encoding="utf-8")
    assert default_patterns(root, "parent") == []
