"""Tests for the proof/harness PR-scope separation gate (ADR-027)."""
from __future__ import annotations

from tools.repo.pr_scope import mixed, surface


def test_surface_classification():
    assert surface("library/Unsorry/Foo.lean") == "proof"
    assert surface("library/index/abc.aisp") == "proof"
    assert surface("goals/foo.aisp") == "proof"
    assert surface("proof-runs/foo.a.r.aisp") == "proof"
    assert surface("swarm/agent.sh") == "harness"
    assert surface("tools/gate_b/validator.py") == "harness"
    assert surface(".github/workflows/gate-a.yml") == "harness"
    assert surface("lakefile.toml") == "harness"
    assert surface("lean-toolchain") == "harness"
    assert surface("docs/adrs/ADR-027-Proof-Harness-PR-Separation.md") == "neutral"
    assert surface("CHANGELOG.md") == "neutral"
    assert surface("README.md") == "neutral"


def test_pure_proof_pr_is_allowed():
    assert not mixed([
        "library/Unsorry/Foo.lean",
        "library/index/abc.aisp",
        "goals/foo.aisp",
        "docs/targets-board.md",  # neutral, fine
        "CHANGELOG.md",
    ])


def test_pure_harness_pr_is_allowed():
    assert not mixed([
        "swarm/agent.sh",
        "tools/repo/pr_scope.py",
        "docs/adrs/ADR-027-Proof-Harness-PR-Separation.md",
        "CHANGELOG.md",
    ])


def test_mixed_proof_and_harness_is_blocked():
    assert mixed(["goals/foo.aisp", "swarm/agent.sh"])
    assert mixed(["library/Unsorry/Foo.lean", "tools/gate_b/validator.py"])
    assert mixed(["proof-runs/x.a.r.aisp", ".github/workflows/gate-a.yml"])


def test_neutral_only_is_allowed():
    assert not mixed(["docs/x.md", "CHANGELOG.md", "README.md"])
    assert not mixed([])
