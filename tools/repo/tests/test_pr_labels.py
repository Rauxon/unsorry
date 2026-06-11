"""PR label classifier tests — the taxonomy is empirical (every shape below
exists in the repo's PR history)."""
from __future__ import annotations

from tools.repo.pr_labels import classify


def test_swarm_surfaces():
    assert classify("tr(nat-add-assoc): translation by trial-alpha") == ["swarm:translate"]
    assert classify("converge(nat-mul-one): matched by trial-bravo") == ["swarm:translate"]
    assert classify("prove(nicomachus-sum-cubes): nicomachus_sum_cubes by e-alpha") == ["swarm:prove"]
    assert classify("decompose(platonic-schlafli-core): split into 3 subs by p3-alpha") == ["swarm:decompose"]
    assert classify("affinity(platonic-schlafli-core): -10 after a failed prove attempt by p3-alpha") == ["swarm:demote"]


def test_red_team_rounds():
    assert classify("redteam(bare-sorry): attempt to bypass Gate A") == ["red-team"]
    assert classify("redteam2(vacuous-true): probe the binding gate") == ["red-team"]


def test_release_and_docs():
    assert classify("docs(v1.2.0): first mathlib-absent lemma proved") == ["release"]
    assert classify("docs: mathlib upstream path plan (thread C)") == ["docs"]
    assert classify("docs: Phase-2 target run (run 001)") == ["docs", "metrics"]
    assert classify("docs: Phase-0 trial metrics (run 001)") == ["docs", "metrics"]
    assert classify("docs: Gate A red-team round 001 evidence") == ["docs", "metrics"]
    assert classify("docs: binding red-team round 002") == ["docs", "metrics"]


def test_conventional():
    assert classify("feat: model/effort policy for proof runs (ADR-013)") == ["feat"]
    assert classify("fix: decomposition records reference statements by sha (brace-safe)") == ["fix"]
    assert classify("chore: restore platonic-schlafli-core affinity (spurious demote)") == ["chore"]


def test_unknown_title_gets_no_labels():
    assert classify("something nonconforming entirely") == []
