from __future__ import annotations

from tools.repo.pr_decompose_guard import conflicting_prove_titles, title_goal


def test_title_goal_parses_exact_swarm_kinds():
    assert title_goal("prove(parent-goal): theorem by agent", "prove") == "parent-goal"
    assert title_goal("decompose(parent-goal): 2 sub-lemmas by agent", "decompose") == "parent-goal"
    assert title_goal("prove(parent-goal): theorem by agent", "decompose") is None
    assert title_goal("fix: not a swarm title", "prove") is None


def test_decompose_conflicts_with_open_direct_proof_same_goal():
    conflicts = conflicting_prove_titles(
        "decompose(parent-goal): 2 sub-lemmas by agent-b",
        [
            "prove(parent-goal): theorem_name by agent-a",
            "prove(parent-goal-s1): sub theorem by agent-c",
            "decompose(parent-goal): 2 sub-lemmas by agent-b",
            "fix: harness change",
        ],
    )
    assert conflicts == ["prove(parent-goal): theorem_name by agent-a"]


def test_non_decomposition_pr_never_conflicts():
    assert conflicting_prove_titles(
        "prove(parent-goal): theorem_name by agent-a",
        ["prove(parent-goal): theorem_name by agent-a"],
    ) == []


def test_sibling_and_parent_titles_do_not_cross_match():
    assert conflicting_prove_titles(
        "decompose(parent-goal): split by agent-b",
        ["prove(parent-goal-s1): theorem by agent-a"],
    ) == []
    assert conflicting_prove_titles(
        "decompose(parent-goal-s1): split by agent-b",
        ["prove(parent-goal): theorem by agent-a"],
    ) == []
