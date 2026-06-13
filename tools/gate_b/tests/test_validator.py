"""Gate B validator acceptance tests (SPEC-003-A/B/C acceptance criteria, PR-3).

Fixture-driven: every tree under fixtures/ is named for the behaviour it must
produce. Clock injection (`--at` / `at=`) keeps every assertion deterministic.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
import time
from pathlib import Path

import pytest

from tools.gate_b.records import parse_utc_z
from tools.gate_b.validator import validate_tree

REPO_ROOT = Path(__file__).resolve().parents[3]
FIXTURES = Path(__file__).resolve().parent / "fixtures"
VALID_TREE = FIXTURES / "valid_tree"
CLAIMS_VALID = FIXTURES / "claims_valid"

AT_LIVE = "2026-06-10T01:00:00Z"
AT_EXPIRED = "2026-06-10T03:00:01Z"


def run_validate(root: Path, at: str | None = None, goals_root: Path | None = None):
    clock = parse_utc_z(at) if at is not None else parse_utc_z(AT_LIVE)
    assert clock is not None
    return validate_tree(root, at=clock, goals_root=goals_root)


def run_cli(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, "-m", "tools.gate_b", *args],
        cwd=REPO_ROOT,
        capture_output=True,
    )


# ---------------------------------------------------------------- valid trees


def test_valid_tree_is_clean():
    assert run_validate(VALID_TREE) == []


def test_repo_root_is_clean():
    assert run_validate(REPO_ROOT) == []


def test_claims_valid_is_clean_while_live():
    assert run_validate(CLAIMS_VALID, at=AT_LIVE) == []


def test_claims_valid_reports_gb013_for_both_claims_once_expired():
    violations = run_validate(CLAIMS_VALID, at=AT_EXPIRED)
    assert {v.code for v in violations} == {"GB013"}
    assert sorted(v.path for v in violations) == [
        "claims/nat-add-comm.agent-alpha.aisp",
        "claims/nat-add-comm.agent-beta.aisp",
    ]


# -------------------------------------------------------------- invalid trees

# (fixture dir, expected violation codes, injected clock, goals_root = fixture itself)
INVALID_CASES = [
    ("invalid_bad_enum", {"GB003"}, None, False),
    ("invalid_unpaired_prove", {"GB004"}, None, False),
    ("invalid_id_mismatch", {"GB002"}, None, False),
    ("invalid_missing_sha", {"GB005"}, None, False),
    ("invalid_sha_mismatch", {"GB006"}, None, False),
    ("invalid_dangling_dep", {"GB007"}, None, False),
    ("invalid_missing_src", {"GB008"}, None, False),
    ("invalid_prose_density", {"GB009"}, None, False),
    ("invalid_claim_filename", {"GB010"}, AT_LIVE, False),
    ("invalid_claim_ttl", {"GB012"}, "2026-06-10T00:01:00Z", False),
    ("invalid_triple_claim", {"GB014"}, AT_LIVE, False),
    ("invalid_claim_dupe_agent", {"GB011", "GB015"}, AT_LIVE, False),
    ("invalid_orphan_translation", {"GB016"}, None, True),
    ("invalid_claims_on_main", {"GB018"}, None, False),
]


@pytest.mark.parametrize(
    "tree,expected,at,self_goals_root",
    INVALID_CASES,
    ids=[c[0] for c in INVALID_CASES],
)
def test_invalid_tree_fails_with_its_named_codes(tree, expected, at, self_goals_root):
    root = FIXTURES / tree
    violations = run_validate(root, at=at, goals_root=root if self_goals_root else None)
    assert violations, f"{tree} must fail validation"
    assert {v.code for v in violations} == expected


def test_orphan_translation_passes_without_goals_root():
    # No goals/ dir in the tree and no --goals-root: goal-reference checks
    # are skipped (SPEC-003-B/C), so the tree is vacuously valid.
    assert run_validate(FIXTURES / "invalid_orphan_translation") == []


# ----------------------------------------------------------------- CLI surface


def test_cli_valid_tree_exits_zero():
    result = run_cli("validate", str(VALID_TREE), "--at", AT_LIVE)
    assert result.returncode == 0
    assert result.stdout == b""


def test_cli_repo_root_exits_zero():
    result = run_cli("validate", ".", "--at", AT_LIVE)
    assert result.returncode == 0, result.stdout + result.stderr


def test_cli_violations_exit_one_with_one_line_per_violation():
    result = run_cli("validate", str(CLAIMS_VALID), "--at", AT_EXPIRED)
    assert result.returncode == 1
    lines = result.stdout.decode("utf-8").splitlines()
    assert len(lines) == 2
    for line in lines:
        assert re.fullmatch(r"GB\d{3} \S+\.aisp: .+", line), line


def test_cli_goals_root_flag():
    root = FIXTURES / "invalid_orphan_translation"
    result = run_cli("validate", str(root), "--goals-root", str(root), "--at", AT_LIVE)
    assert result.returncode == 1
    assert b"GB016" in result.stdout


def test_cli_missing_root_is_internal_error():
    result = run_cli("validate", "/nonexistent/tree", "--at", AT_LIVE)
    assert result.returncode == 2


def test_cli_bad_at_is_internal_error():
    result = run_cli("validate", str(VALID_TREE), "--at", "not-a-timestamp")
    assert result.returncode == 2


def test_cli_json_report_is_deterministic_and_machine_readable():
    args = ("validate", str(CLAIMS_VALID), "--at", AT_EXPIRED, "--json")
    first = run_cli(*args)
    second = run_cli(*args)
    assert first.returncode == second.returncode == 1
    assert first.stdout == second.stdout  # byte-identical
    report = json.loads(first.stdout)
    assert report["ok"] is False
    assert report["at"] == AT_EXPIRED
    assert [v["code"] for v in report["violations"]] == ["GB013", "GB013"]
    paths = [v["path"] for v in report["violations"]]
    assert paths == sorted(paths)


def test_cli_json_clean_run():
    result = run_cli("validate", str(VALID_TREE), "--at", AT_LIVE, "--json")
    assert result.returncode == 0
    report = json.loads(result.stdout)
    assert report["ok"] is True
    assert report["violations"] == []


# ------------------------------------------------- determinism and performance


def test_api_results_are_deterministic():
    first = run_validate(CLAIMS_VALID, at=AT_EXPIRED)
    second = run_validate(CLAIMS_VALID, at=AT_EXPIRED)
    assert first == second


def test_validating_valid_tree_100_times_under_one_second():
    clock = parse_utc_z(AT_LIVE)
    start = time.perf_counter()
    for _ in range(100):
        assert validate_tree(VALID_TREE, at=clock) == []
    assert time.perf_counter() - start < 1.0


# ---------------------------------------- decomposition guardrails (ADR-009)

from tools.gate_b.validator import _has_cycle  # noqa: E402

_DECOMP_TMPL = """𝔸5.1.decomp.{parent}.agent-x@2026-06-10
γ≔unsorry.decomposition
⟦Ω:Decomp⟧{{parent≜{parent}; agent≜agent-x}}
⟦Σ:Subs⟧{{
{subs}
}}
⟦Γ:Edges⟧{{
{edges}
}}
⟦Λ:Requeue⟧{{∀s∈subs:goal(s)≫status≔open}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
"""

_GOAL_TMPL = """𝔸5.1.goal.{id}@2026-06-10
γ≔unsorry.goal
⟦Ω:Goal⟧{{
  id≜{id}
  phase≜prove
  status≜{status}
  difficulty≜1
}}
⟦Σ:Source⟧{{
  src≜{src}
}}
⟦Γ:Deps⟧{{
  deps≜⟨⟩
}}
⟦Λ:Artifact⟧{{
  lean≜goals/{id}.lean
  sha≜∅
}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
"""


def _write_goal(tree: Path, gid: str, status: str = "open", src: str = "backlog/x.md"):
    (tree / "goals").mkdir(parents=True, exist_ok=True)
    (tree / "goals" / f"{gid}.aisp").write_text(
        _GOAL_TMPL.format(id=gid, status=status, src=src), encoding="utf-8"
    )
    (tree / "goals" / f"{gid}.lean").write_text(
        f"theorem {gid.replace('-', '_')} : True := by sorry\n", encoding="utf-8"
    )
    (tree / "backlog").mkdir(parents=True, exist_ok=True)
    (tree / "backlog" / "x.md").write_text("# x\n\nx\n", encoding="utf-8")


def test_has_cycle_unit():
    assert not _has_cycle([("a", "p"), ("b", "p")])  # subs → parent: a DAG
    assert _has_cycle([("a", "b"), ("b", "a")])  # 2-cycle
    assert _has_cycle([("a", "b"), ("b", "c"), ("c", "a")])  # 3-cycle
    assert not _has_cycle([])


def _sub_sha(tree: Path, gid: str) -> str:
    from tools.lean_sig import statement_sha

    return statement_sha((tree / "goals" / f"{gid}.lean").read_text(encoding="utf-8"))


def test_decomposition_cycle_is_rejected(tmp_path):
    tree = tmp_path / "t"
    for gid in ("parent", "sa", "sb"):
        _write_goal(tree, gid, src="decompositions/parent.agent-x.aisp")
    (tree / "decompositions").mkdir(parents=True, exist_ok=True)
    (tree / "decompositions" / "parent.agent-x.aisp").write_text(
        _DECOMP_TMPL.format(
            parent="parent",
            subs=f"  sub₁≜⟨id≜sa,sha≜{_sub_sha(tree, 'sa')}⟩\n"
            f"  sub₂≜⟨id≜sb,sha≜{_sub_sha(tree, 'sb')}⟩",
            # a cycle among the subs: sub₁→sub₂→sub₁
            edges="  Post(sub₁)⊆Pre(sub₂); Post(sub₂)⊆Pre(sub₁)",
        ),
        encoding="utf-8",
    )
    report = run_validate(tree)
    assert any(v.code == "GB016" and "cycle" in v.message for v in report)


def test_decomposition_sub_re_emitting_parent_is_rejected(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "parent", src="decompositions/parent.agent-x.aisp")
    _write_goal(tree, "sb", src="decompositions/parent.agent-x.aisp")
    (tree / "decompositions").mkdir(parents=True, exist_ok=True)
    (tree / "decompositions" / "parent.agent-x.aisp").write_text(
        _DECOMP_TMPL.format(
            parent="parent",
            subs=f"  sub₁≜⟨id≜parent,sha≜{_sub_sha(tree, 'parent')}⟩\n"
            f"  sub₂≜⟨id≜sb,sha≜{_sub_sha(tree, 'sb')}⟩",
            edges="  Post(sub₁)⊆Pre(parent); Post(sub₂)⊆Pre(parent)",
        ),
        encoding="utf-8",
    )
    report = run_validate(tree)
    assert any(v.code == "GB016" and "re-emits the parent" in v.message for v in report)


def test_decomposition_brace_statement_round_trips(tmp_path):
    # The regression from the first real decomposition (platonic-schlafli-core):
    # the record grammar reserves {} for block delimiters, so a sub whose Lean
    # statement contains a Finset literal like ({(3,3),(3,4)} : Finset _) used
    # to break the Σ-block parse when statements were embedded inline. Records
    # now reference statements by sha; any statement round-trips.
    tree = tmp_path / "t"
    _write_goal(tree, "parent", src="decompositions/parent.agent-x.aisp")
    _write_goal(tree, "sa", src="decompositions/parent.agent-x.aisp")
    (tree / "goals" / "sa.lean").write_text(
        "theorem sa_enum (p q : ℕ) : (p, q) ∈ ({(3,3),(3,4)} : Finset (ℕ × ℕ))"
        " := by\n  sorry\n",
        encoding="utf-8",
    )
    (tree / "decompositions").mkdir(parents=True, exist_ok=True)
    (tree / "decompositions" / "parent.agent-x.aisp").write_text(
        _DECOMP_TMPL.format(
            parent="parent",
            subs=f"  sub₁≜⟨id≜sa,sha≜{_sub_sha(tree, 'sa')}⟩",
            edges="  Post(sub₁)⊆Pre(parent)",
        ),
        encoding="utf-8",
    )
    report = run_validate(tree)
    decomp_violations = [v for v in report if "decompositions/" in str(v.path)]
    assert decomp_violations == [], [str(v) for v in decomp_violations]


def test_decomposition_sha_mismatch_is_rejected(tmp_path):
    # The sha must be the content address of the sub's actual statement —
    # a stale or fabricated sha is a GB016 integrity failure.
    tree = tmp_path / "t"
    _write_goal(tree, "parent", src="decompositions/parent.agent-x.aisp")
    _write_goal(tree, "sa", src="decompositions/parent.agent-x.aisp")
    (tree / "decompositions").mkdir(parents=True, exist_ok=True)
    (tree / "decompositions" / "parent.agent-x.aisp").write_text(
        _DECOMP_TMPL.format(
            parent="parent",
            subs=f"  sub₁≜⟨id≜sa,sha≜{'0' * 64}⟩",
            edges="  Post(sub₁)⊆Pre(parent)",
        ),
        encoding="utf-8",
    )
    report = run_validate(tree)
    assert any(v.code == "GB016" and "does not match" in v.message for v in report)


def test_decomposition_malformed_sha_is_rejected(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "parent", src="decompositions/parent.agent-x.aisp")
    _write_goal(tree, "sa", src="decompositions/parent.agent-x.aisp")
    (tree / "decompositions").mkdir(parents=True, exist_ok=True)
    (tree / "decompositions" / "parent.agent-x.aisp").write_text(
        _DECOMP_TMPL.format(
            parent="parent",
            subs="  sub₁≜⟨id≜sa,sha≜nothex⟩",
            edges="  Post(sub₁)⊆Pre(parent)",
        ),
        encoding="utf-8",
    )
    report = run_validate(tree)
    assert any(v.code == "GB016" for v in report)


# ------------------------------------------- index records (statement by sha)

_INDEX_TMPL = """𝔸5.1.lemma.{sha12}@2026-06-10
γ≔unsorry.lemma.index
⟦Ω:Lemma⟧{{sha≜{sha}; goal≜{goal}; name≜{name}}}
⟦Σ:Source⟧{{src≜goals/{goal}.lean}}
⟦Γ:Tags⟧{{tags≜⟨⟩}}
⟦Λ:Meta⟧{{use≜0; aff≜0}}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
"""


def _write_index(tree: Path, goal: str, sha: str, name: str = "thm"):
    (tree / "library" / "index").mkdir(parents=True, exist_ok=True)
    (tree / "library" / "index" / f"{sha}.aisp").write_text(
        _INDEX_TMPL.format(sha=sha, sha12=sha[:12], goal=goal, name=name),
        encoding="utf-8",
    )


def test_index_brace_statement_round_trips(tmp_path):
    # Index surface of the platonic-schlafli-core regression: a proved goal
    # whose statement carries braces must index cleanly — the statement is
    # referenced by content address, never embedded.
    tree = tmp_path / "t"
    _write_goal(tree, "bg")
    (tree / "goals" / "bg.lean").write_text(
        "theorem bg (p q : ℕ) : (p, q) ∈ ({(3,3),(3,4)} : Finset (ℕ × ℕ))"
        " := by\n  sorry\n",
        encoding="utf-8",
    )
    sha = _sub_sha(tree, "bg")
    _write_index(tree, "bg", sha, name="bg")
    report = run_validate(tree)
    idx = [v for v in report if "library/index" in str(v.path)]
    assert idx == [], [str(v) for v in idx]


def test_index_sha_mismatch_with_goal_file_is_rejected(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "g1")
    _write_index(tree, "g1", "0" * 64, name="g1")
    report = run_validate(tree)
    assert any(
        v.code == "GB006" and "does not match the statement" in v.message
        for v in report
    )


def test_index_without_goal_file_is_grandfathered(tmp_path):
    # Translate-era entries (e.g. nat-zero-lt-succ) have no goals/<g>.lean —
    # the filename≡sha≜ check still applies, recomputation is skipped.
    tree = tmp_path / "t"
    _write_goal(tree, "other")  # tree must be a goals tree
    _write_index(tree, "ghost", "a" * 64, name="ghost")
    report = run_validate(tree)
    idx_sha = [
        v for v in report
        if "library/index" in str(v.path) and v.code == "GB006"
    ]
    assert idx_sha == [], [str(v) for v in idx_sha]


def test_index_optional_provenance_is_backward_compatible_and_validated(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "g1")
    sha = _sub_sha(tree, "g1")
    _write_index(tree, "g1", sha, name="g1")
    path = tree / "library" / "index" / f"{sha}.aisp"

    # Historical entry without provenance remains valid.
    assert not [v for v in run_validate(tree) if v.code == "GB019"]

    text = path.read_text(encoding="utf-8").replace(
        "⟦Ε⟧",
        "⟦Π:Provenance⟧{solver≜perttu; agent≜oma-2-c50d; "
        "provider≜codex; model≜gpt-5.1-codex; effort≜xhigh; "
        "attempts≜2; solve_s≜842}\n⟦Ε⟧",
    )
    path.write_text(text, encoding="utf-8")
    assert not [v for v in run_validate(tree) if v.code == "GB019"]

    path.write_text(text.replace("attempts≜2", "attempts≜zero"), encoding="utf-8")
    assert any(v.code == "GB019" and "attempts" in v.message
               for v in run_validate(tree))


# ---------------------------------------------------------- proof-run records

_RUN_ID = "20260613t120000000000z-1234abcd"


def _write_proof_run(
    tree: Path,
    goal: str,
    outcome: str,
    *,
    attempts: str = "2",
    sha: str = "∅",
) -> Path:
    agent = "oma-2-c50d"
    path = tree / "proof-runs" / f"{goal}.{agent}.{_RUN_ID}.aisp"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        f"𝔸5.1.run.{goal}.{agent}.{_RUN_ID}@2026-06-13\n"
        "γ≔unsorry.proof.run\n"
        f"⟦Ω:Run⟧{{id≜{_RUN_ID}; goal≜{goal}; agent≜{agent}; "
        f"outcome≜{outcome}}}\n"
        "⟦Π:Provenance⟧{solver≜perttu; provider≜codex; "
        "model≜gpt-5.1-codex; effort≜xhigh}\n"
        f"⟦Λ:Metrics⟧{{attempts≜{attempts}; solve_s≜90; "
        "ended≜2026-06-13T12:00:00Z}\n"
        f"⟦Σ:Artifact⟧{{sha≜{sha}}}\n"
        "⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩\n",
        encoding="utf-8",
    )
    return path


def test_valid_proof_run_links_to_goal_and_proved_artifact(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "g1")
    sha = _sub_sha(tree, "g1")
    _write_index(tree, "g1", sha, name="g1")
    _write_proof_run(tree, "g1", "proved", sha=sha)
    assert not [v for v in run_validate(tree) if v.code == "GB020"]


def test_failed_proof_run_requires_valid_attempts_and_empty_artifact(tmp_path):
    tree = tmp_path / "t"
    _write_goal(tree, "g1")
    _write_proof_run(tree, "g1", "failed", attempts="zero", sha="a" * 64)
    violations = [v for v in run_validate(tree) if v.code == "GB020"]
    assert any("attempts" in v.message for v in violations)
    assert any("requires sha≜∅" in v.message for v in violations)
