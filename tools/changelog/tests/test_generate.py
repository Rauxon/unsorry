import pytest

from tools.changelog.generate import (
    fragment_category,
    read_fragments,
    release,
    render_unreleased,
)


def _frag(root, name, body):
    d = root / "changelog.d"
    d.mkdir(exist_ok=True)
    (d / name).write_text(body, encoding="utf-8")


def test_fragment_category():
    from pathlib import Path

    assert fragment_category(Path("changed-foo.md")) == "changed"
    assert fragment_category(Path("added-x-y-z.md")) == "added"
    assert fragment_category(Path("fixed-bar.md")) == "fixed"
    assert fragment_category(Path("nonsense-baz.md")) is None


def test_render_groups_and_orders_by_keepachangelog(tmp_path):
    _frag(tmp_path, "fixed-z.md", "z fix")
    _frag(tmp_path, "added-a.md", "a add")
    _frag(tmp_path, "added-b.md", "b add")
    _frag(tmp_path, "changed-c.md", "c change")
    _frag(tmp_path, "changelog.d-readme-not-a-frag", "ignored")  # not *.md
    body = render_unreleased(tmp_path)
    # Keep-a-Changelog order: Added, Changed, … Fixed; within a category by filename.
    assert body == (
        "### Added\n\n- a add\n- b add\n\n"
        "### Changed\n\n- c change\n\n"
        "### Fixed\n\n- z fix"
    )


def test_readme_is_ignored(tmp_path):
    _frag(tmp_path, "README.md", "# how to add fragments")
    _frag(tmp_path, "added-real.md", "real entry")
    assert render_unreleased(tmp_path) == "### Added\n\n- real entry"


def test_unknown_category_is_rejected(tmp_path):
    _frag(tmp_path, "improved-thing.md", "nope")
    with pytest.raises(ValueError):
        read_fragments(tmp_path)


def test_empty_dir_renders_nothing(tmp_path):
    (tmp_path / "changelog.d").mkdir()
    assert render_unreleased(tmp_path) == ""


def test_release_folds_fragments_and_clears_dir(tmp_path):
    (tmp_path / "CHANGELOG.md").write_text(
        "# Changelog\n\n## [Unreleased]\n\n"
        "<!-- fragments live in changelog.d/ -->\n\n"
        "## [1.0.0] - 2026-01-01\n\n### Added\n\n- first\n",
        encoding="utf-8",
    )
    _frag(tmp_path, "added-new.md", "shiny new thing")
    _frag(tmp_path, "fixed-bug.md", "squashed bug")
    (tmp_path / "changelog.d" / "README.md").write_text("keep me", encoding="utf-8")

    assert release(tmp_path, "1.1.0", "2026-02-02") == 0
    text = (tmp_path / "CHANGELOG.md").read_text(encoding="utf-8")

    # New version section sits between [Unreleased] and the prior release.
    assert "## [1.1.0] - 2026-02-02" in text
    assert text.index("## [Unreleased]") < text.index("## [1.1.0]") < text.index("## [1.0.0]")
    assert "- shiny new thing" in text and "- squashed bug" in text
    # The [Unreleased] pointer survives; only version sections accrete.
    assert "<!-- fragments live in changelog.d/ -->" in text
    # Fragments cleared, README kept.
    remaining = {p.name for p in (tmp_path / "changelog.d").glob("*")}
    assert remaining == {"README.md"}


def test_release_with_no_fragments_is_a_noop(tmp_path):
    (tmp_path / "CHANGELOG.md").write_text(
        "# Changelog\n\n## [Unreleased]\n\n## [1.0.0] - 2026-01-01\n\n- x\n",
        encoding="utf-8",
    )
    (tmp_path / "changelog.d").mkdir()
    assert release(tmp_path, "1.1.0", "2026-02-02") == 2
