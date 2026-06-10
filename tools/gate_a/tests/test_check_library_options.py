"""TDD for the autoImplicit Gate A hole found by the W3 red team (PR #64)."""
from __future__ import annotations

from pathlib import Path

import pytest

from tools.gate_a.check_library_options import (
    findings_for_text,
    main,
    scan_library,
)

# The exact survivor: option split across two lines defeated the old per-line grep.
SPLIT_LINE = "import Mathlib\nset_option autoImplicit\n  true\n\ntheorem t (h : p) : p := h\n"
SAME_LINE = "set_option autoImplicit true\ntheorem t (h : p) : p := h\n"
RELAXED = "set_option relaxedAutoImplicit true\ntheorem t : True := trivial\n"
CLEAN = "import Mathlib.Algebra.Group.Basic\n\ntheorem ok (n : Nat) : 0 < n + 1 := Nat.succ_pos n\n"
EXPLICIT_FALSE = "set_option autoImplicit false\ntheorem ok : True := trivial\n"
TABS_AND_CR = "set_option\tautoImplicit\r\n\t\ttrue\ntheorem t (h : p) : p := h\n"


class TestTextDetection:
    def test_split_line_is_caught(self) -> None:
        assert findings_for_text(SPLIT_LINE) == ["autoImplicit"]

    def test_same_line_is_caught(self) -> None:
        assert findings_for_text(SAME_LINE) == ["autoImplicit"]

    def test_relaxed_is_caught(self) -> None:
        assert findings_for_text(RELAXED) == ["relaxedAutoImplicit"]

    def test_tabs_and_crlf_are_caught(self) -> None:
        assert findings_for_text(TABS_AND_CR) == ["autoImplicit"]

    def test_clean_file_has_no_findings(self) -> None:
        assert findings_for_text(CLEAN) == []

    def test_explicit_false_is_fine(self) -> None:
        assert findings_for_text(EXPLICIT_FALSE) == []

    def test_both_options_reported(self) -> None:
        text = SAME_LINE + RELAXED
        assert set(findings_for_text(text)) == {"autoImplicit", "relaxedAutoImplicit"}


class TestScanAndCli:
    def test_scan_walks_library_tree(self, tmp_path: Path) -> None:
        lib = tmp_path / "library" / "Unsorry"
        lib.mkdir(parents=True)
        (lib / "Good.lean").write_text(CLEAN, encoding="utf-8")
        (lib / "Bad.lean").write_text(SPLIT_LINE, encoding="utf-8")
        findings = scan_library(tmp_path / "library")
        assert [(p.name, opt) for p, opt in findings] == [("Bad.lean", "autoImplicit")]

    def test_main_exit_1_on_finding(self, tmp_path: Path, capsys) -> None:
        lib = tmp_path / "library"
        lib.mkdir()
        (lib / "Bad.lean").write_text(SPLIT_LINE, encoding="utf-8")
        assert main([str(lib)]) == 1
        assert "FORBIDDEN" in capsys.readouterr().out

    def test_main_exit_0_clean(self, tmp_path: Path) -> None:
        lib = tmp_path / "library"
        lib.mkdir()
        (lib / "Good.lean").write_text(CLEAN, encoding="utf-8")
        assert main([str(lib)]) == 0

    def test_missing_library_is_vacuously_clean(self, tmp_path: Path) -> None:
        assert main([str(tmp_path / "nope")]) == 0


class TestRealLibrary:
    def test_repo_library_is_clean(self) -> None:
        repo_root = Path(__file__).resolve().parents[3]
        assert main([str(repo_root / "library")]) == 0
