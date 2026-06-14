"""ADR-020 / SPEC-020-A: upstream packet rendering."""
from __future__ import annotations

import json
from pathlib import Path

from tools.upstream.packet import render_packet, render_patch


def _mk_root(tmp_path: Path, *, with_unsorry_import: bool = False) -> Path:
    root = tmp_path / "repo"
    (root / "goals").mkdir(parents=True)
    (root / "library" / "index").mkdir(parents=True)
    (root / "library" / "Unsorry").mkdir(parents=True)
    (root / "backlog").mkdir()
    (root / "goals" / "novel-lemma.lean").write_text(
        "import Mathlib\n\ntheorem novel_lemma_thm (n : ℕ) : n + 0 = n := by\n  sorry\n",
        encoding="utf-8",
    )
    imports = "import Mathlib.Algebra.Group.Basic\n"
    if with_unsorry_import:
        imports += "import Unsorry.SiblingDep\n"
    (root / "library" / "Unsorry" / "NovelLemma.lean").write_text(
        f"{imports}\n/-! docs -/\n\n"
        "theorem novel_lemma_thm (n : ℕ) : n + 0 = n := Nat.add_zero n\n",
        encoding="utf-8",
    )
    (root / "library" / "index" / ("ab" * 32 + ".aisp")).write_text(
        "⟦Ω:Lemma⟧{sha≜" + "ab" * 32 + "; goal≜novel-lemma; name≜novel_lemma_thm}\n",
        encoding="utf-8",
    )
    (root / "backlog" / "novel-lemma.md").write_text(
        "# novel-lemma\n\nThe lemma.\n\n"
        "- **Source:** test batch\n"
        "- **Reference:** somewhere reputable\n"
        "- **Absence:** machine-checked no-local-match (rev c5ea003)\n"
        "- **Difficulty:** 2\n",
        encoding="utf-8",
    )
    return root


_DEDUP = {
    "goal": "novel-lemma",
    "mathlib_rev": "headrev123",
    "patterns": ["novel_lemma_thm"],
    "local_matches": [],
    "verdict": "no-local-match",
}


def test_packet_has_required_sections(tmp_path):
    root = _mk_root(tmp_path)
    md = render_packet(root, "novel-lemma", _DEDUP, sponsor="Chris Barlow")
    for needle in (
        "# Upstream packet: `novel-lemma`",
        "Status: packet-ready",
        "novel_lemma_thm",                      # the statement
        "## Proposed contribution",             # the mathlib-ready block
        "Copyright (c) 2026 Chris Barlow",      # human author header
        "## AI disclosure (paste-ready facts)", # factual block
        "## Dedup at mathlib HEAD",
        "headrev123",
        "## For the sponsor",                   # rewrite-in-own-words marker
        "must be rewritten in your own words",
    ):
        assert needle in md, f"missing: {needle}"


def test_packet_flags_unsorry_dependencies(tmp_path):
    root = _mk_root(tmp_path, with_unsorry_import=True)
    md = render_packet(root, "novel-lemma", _DEDUP, sponsor="Chris Barlow")
    assert "Unsorry.SiblingDep" in md
    assert "bundle or inline" in md


def test_clean_candidate_has_no_dependency_warning(tmp_path):
    root = _mk_root(tmp_path)
    md = render_packet(root, "novel-lemma", _DEDUP, sponsor="Chris Barlow")
    assert "bundle or inline" not in md


def test_patch_is_new_file_diff_with_header_and_proof(tmp_path):
    root = _mk_root(tmp_path)
    patch = render_patch(root, "novel-lemma", sponsor="Chris Barlow")
    assert patch.startswith("--- /dev/null\n")
    assert "+++ b/Mathlib/Unsorry/NovelLemma.lean" in patch
    assert "+Copyright (c) 2026 Chris Barlow" in patch
    assert "+theorem novel_lemma_thm" in patch
    # Our internal lint-ignore machinery and Unsorry imports must not leak.
    assert "unused_variables_ignore_fn" not in patch
    assert "import Unsorry" not in patch


def test_packet_reads_archived_module(tmp_path):
    root = _mk_root(tmp_path)
    archive = root / "packages" / "unsorry-archive-0001"
    (archive / "library" / "Unsorry").mkdir(parents=True)
    (archive / "library" / "index").mkdir(parents=True)
    (archive / "library" / "Unsorry" / "NovelLemma.lean").write_text(
        (root / "library" / "Unsorry" / "NovelLemma.lean").read_text(encoding="utf-8"),
        encoding="utf-8",
    )
    (archive / "library" / "index" / ("ab" * 32 + ".aisp")).write_text(
        (root / "library" / "index" / ("ab" * 32 + ".aisp")).read_text(encoding="utf-8"),
        encoding="utf-8",
    )
    (root / "library" / "Unsorry" / "NovelLemma.lean").unlink()
    (root / "library" / "index" / ("ab" * 32 + ".aisp")).unlink()

    md = render_packet(root, "novel-lemma", _DEDUP, sponsor="Chris Barlow")

    assert "`packages/unsorry-archive-0001/library/Unsorry/NovelLemma.lean`" in md
    assert "theorem novel_lemma_thm" in md


def test_dedup_hit_marks_packet_blocked(tmp_path):
    root = _mk_root(tmp_path)
    dedup = dict(_DEDUP, verdict="possible-duplicate",
                 local_matches=[{"pattern": "x", "file": "Mathlib/X.lean", "line": "thm"}])
    md = render_packet(root, "novel-lemma", dedup, sponsor="Chris Barlow")
    assert "Status: blocked-possible-duplicate" in md
