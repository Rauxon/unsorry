"""Tests for the protocol-compliance gate (ADR-028)."""
from __future__ import annotations

from tools.repo.pr_protocol import check


def test_adr_with_spec_in_same_pr_passes():
    added = [
        "docs/adrs/ADR-099-Thing.md",
        "docs/adrs/specs/SPEC-099-A-Thing.md",
    ]
    assert check(added, []) == []


def test_adr_without_any_spec_is_flagged():
    added = ["docs/adrs/ADR-099-Thing.md"]
    out = check(added, [])
    assert len(out) == 1 and "ADR-099" in out[0] and "SPEC-099" in out[0]


def test_adr_paired_with_preexisting_spec_passes():
    # spec already on the base tree (e.g. an ADR reusing/extending an existing spec)
    added = ["docs/adrs/ADR-099-Thing.md"]
    existing = ["docs/adrs/specs/SPEC-099-A-Thing.md"]
    assert check(added, existing) == []


def test_orphan_spec_is_flagged():
    added = ["docs/adrs/specs/SPEC-099-A-Thing.md"]
    out = check(added, [])
    assert len(out) == 1 and "SPEC-099" in out[0] and "ADR-099" in out[0]


def test_historical_unpaired_adrs_are_not_flagged():
    # Only ADDED paths are checked; a pre-existing unpaired ADR (e.g. ADR-001)
    # in `existing` must not produce a violation.
    added = ["docs/adrs/ADR-100-New.md", "docs/adrs/specs/SPEC-100-A-New.md"]
    existing = ["docs/adrs/ADR-001-Protocols.md"]  # no SPEC-001 anywhere
    assert check(added, existing) == []


def test_non_adr_changes_are_ignored():
    assert check(["swarm/agent.sh", "CHANGELOG.md", "README.md"], []) == []
