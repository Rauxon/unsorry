"""Triviality-probe tests (ADR-035 / SPEC-035-A). Hermetic — a mocked runner
stands in for lake+mathlib, so the orchestration/classification logic is covered
without elaboration. The one real-build path is exercised separately at sourcing
and in CI."""
from __future__ import annotations

import subprocess
from pathlib import Path

import pytest

from tools.sourcing.check_triviality import (
    TACTIC_BATTERY,
    audit,
    classify,
    main,
    override_reason,
    probe,
    probe_module,
    render_audit,
)


def _goal(tmp_path: Path, gid: str, decl: str, *, opens: str = "") -> Path:
    (tmp_path / "goals").mkdir(exist_ok=True)
    body = "import Mathlib\n\n"
    if opens:
        body += opens + "\n"
    body += f"{decl} := by\n  sorry\n"
    path = tmp_path / "goals" / f"{gid}.lean"
    path.write_text(body, encoding="utf-8")
    return path


def _manifest(tmp_path: Path, rev: str = "deadbeef") -> None:
    (tmp_path / "lake-manifest.json").write_text(
        '{"packages": [{"name": "mathlib", "rev": "%s"}]}' % rev, encoding="utf-8"
    )


class FakeRunner:
    """Mimics subprocess.run: returns a CompletedProcess with a chosen
    returncode/output, recording the lean files it was asked to compile."""

    def __init__(self, returncode: int = 1, output: str = "unsolved goals",
                 *, by_source=None):
        self.returncode = returncode
        self.output = output
        self.by_source = by_source or {}  # predicate(source)->(rc, output)
        self.sources: list[str] = []

    def __call__(self, argv, *, cwd=None, capture_output=True, text=True, timeout=None):
        src = Path(argv[-1]).read_text(encoding="utf-8")
        self.sources.append(src)
        rc, out = self.returncode, self.output
        for predicate, result in self.by_source.items():
            if predicate in src:
                rc, out = result
                break
        return subprocess.CompletedProcess(argv, rc, stdout=out, stderr="")


# ---- probe module construction (byte-exact, reuses lean_sig) ----

def test_probe_module_is_canonical(tmp_path):
    g = _goal(tmp_path, "g", "theorem g (n : Nat) : n + 0 = n")
    mod = probe_module(g.read_text(encoding="utf-8"))
    assert mod == (
        "import Mathlib\n\n"
        "set_option linter.unusedVariables false in\n"
        "theorem g_triviality_probe : ∀ (n : Nat), n + 0 = n := by\n"
        "  first | " + " | ".join(TACTIC_BATTERY) + "\n"
    )


def test_probe_module_carries_open_commands(tmp_path):
    g = _goal(tmp_path, "g", "theorem g (n : ℕ) : True", opens="open Finset")
    mod = probe_module(g.read_text(encoding="utf-8"))
    assert "open Finset\n" in mod
    assert mod.index("open Finset") < mod.index("theorem g_triviality_probe")


def test_per_tactic_module_uses_single_tactic(tmp_path):
    g = _goal(tmp_path, "g", "theorem g : True")
    mod = probe_module(g.read_text(encoding="utf-8"), tactic="simp")
    assert mod.rstrip().endswith(":= by\n  simp")
    assert "first |" not in mod


# ---- classification trichotomy ----

def test_classify_success_is_trivial():
    assert classify(0, "") == "trivial"


def test_classify_unsolved_is_non_trivial():
    assert classify(1, "error: unsolved goals\n⊢ n + 0 = n") == "non-trivial"


def test_classify_elaboration_error_is_probe_error():
    assert classify(1, "error: unknown identifier 'foo'") == "probe-error"
    assert classify(1, "error: unexpected token ':'") == "probe-error"
    # #410: an unresolved typeclass in the statement is an elaboration error,
    # not a non-trivial goal — it must be surfaced, never admitted.
    assert classify(
        1, "error: failed to synthesize instance\n  Inv ℕ"
    ) == "probe-error"
    assert classify(1, "error: failed to synthesize\n  OfNat") == "probe-error"


# ---- probe() orchestration with a mocked runner ----

def test_build_success_is_trivial(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "triv", "theorem triv (n : Nat) : n + 0 = n")
    rep = probe(g, runner=FakeRunner(0, ""), root=tmp_path)
    assert rep["verdict"] == "trivial"
    assert rep["mathlib_rev"] == "deadbeef"


def test_build_failure_unsolved_is_non_trivial(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "hard", "theorem hard (n : Nat) : P n")
    rep = probe(g, runner=FakeRunner(1, "error: unsolved goals"), root=tmp_path)
    assert rep["verdict"] == "non-trivial"


def test_elaboration_error_is_probe_error(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "broken", "theorem broken : Nope")
    rep = probe(g, runner=FakeRunner(1, "error: unknown identifier 'Nope'"), root=tmp_path)
    assert rep["verdict"] == "probe-error"


def test_per_tactic_reports_closer(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "g", "theorem g : True")
    # Only the single-tactic `simp` module compiles; all earlier tactics fail.
    runner = FakeRunner(1, "unsolved goals", by_source={":= by\n  simp\n": (0, "")})
    rep = probe(g, runner=runner, root=tmp_path, per_tactic=True)
    assert rep["verdict"] == "trivial"
    assert rep["closed_by"] == "simp"


def test_timeout_is_non_trivial(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "loop", "theorem loop : Q")

    def timing_out(argv, **kw):
        raise subprocess.TimeoutExpired(argv, kw.get("timeout"))

    rep = probe(g, runner=timing_out, root=tmp_path)
    assert rep["verdict"] == "non-trivial"


# ---- allowlist + override downgrades ----

def test_allowlist_downgrades_trivial(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "canary", "theorem canary : True")
    allow = tmp_path / "allow.txt"
    allow.write_text("canary  # intentional fixture\n", encoding="utf-8")
    rep = probe(g, runner=FakeRunner(0, ""), root=tmp_path, allowlist=allow)
    assert rep["verdict"] == "allowlisted"


def test_override_field_downgrades_trivial(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "ringy", "theorem ringy : True")
    (tmp_path / "backlog").mkdir()
    (tmp_path / "backlog" / "ringy.md").write_text(
        "# ringy\n\n- **Nontrivial-override:** tedious but genuine ring identity "
        "(approved-by chris, 2026-06-14)\n", encoding="utf-8")
    rep = probe(g, runner=FakeRunner(0, ""), root=tmp_path,
                allowlist=tmp_path / "nonexistent.txt")
    assert rep["verdict"] == "override"
    assert "tedious" in rep["override_reason"]


def test_override_reason_absent(tmp_path):
    (tmp_path / "backlog").mkdir()
    (tmp_path / "backlog" / "x.md").write_text("# x\n\n- **Source:** foo\n", encoding="utf-8")
    assert override_reason("x", tmp_path) is None


# ---- CLI exit codes + determinism ----

def test_main_exit_codes(tmp_path, monkeypatch, capsys):
    _manifest(tmp_path)
    g = _goal(tmp_path, "triv", "theorem triv : True")
    monkeypatch.setattr("tools.sourcing.check_triviality.subprocess.run", FakeRunner(0, ""))
    assert main([str(g), "--root", str(tmp_path)]) == 1  # trivial → reject
    assert "TRIVIAL" in capsys.readouterr().out

    g2 = _goal(tmp_path, "hard", "theorem hard : P")
    monkeypatch.setattr("tools.sourcing.check_triviality.subprocess.run",
                        FakeRunner(1, "unsolved goals"))
    assert main([str(g2), "--root", str(tmp_path)]) == 0  # non-trivial → admit


def test_json_verdict_deterministic(tmp_path):
    _manifest(tmp_path)
    g = _goal(tmp_path, "g", "theorem g (n : Nat) : n + 0 = n")
    a = probe(g, runner=FakeRunner(1, "unsolved goals"), root=tmp_path)
    b = probe(g, runner=FakeRunner(1, "unsolved goals"), root=tmp_path)
    assert a == b
    assert a["battery"] == list(TACTIC_BATTERY)


# ---- audit() two-pass efficiency (#411) ----

def test_audit_combined_first_reprobes_only_trivial(tmp_path):
    # Pass 1 is the combined `first | …` probe (one build/goal); only a goal that
    # comes back trivial is re-probed per-tactic to recover closed_by.
    _manifest(tmp_path)
    _goal(tmp_path, "hard", "theorem hard (n : Nat) : n + 1 = n + 1")
    _goal(tmp_path, "triv", "theorem triv : True")
    runner = FakeRunner(1, "unsolved goals", by_source={
        "theorem hard": (1, "unsolved goals"),  # combined fails → non-trivial
        "first |": (0, ""),                     # triv combined closes → trivial
        "triv": (0, ""),                        # triv per-tactic re-probe closes
    })
    reports = {r["goal"]: r for r in audit(tmp_path, runner=runner)}
    assert reports["hard"]["verdict"] == "non-trivial"
    assert reports["triv"]["verdict"] == "trivial"
    assert reports["triv"]["closed_by"] is not None          # recovered via re-probe
    # hard ran exactly one build (combined; no per-tactic re-probe).
    assert sum("theorem hard" in s for s in runner.sources) == 1
    # triv ran the combined build + at least one per-tactic re-probe build.
    assert sum("theorem triv" in s for s in runner.sources) >= 2


# ---- retro-audit report rendering (#387 PR2) ----

def test_render_audit_md_and_json():
    reports = [
        {"goal": "t1", "verdict": "trivial", "closed_by": "simp"},
        {"goal": "n1", "verdict": "non-trivial", "closed_by": None},
        {"goal": "e1", "verdict": "probe-error", "closed_by": None},
    ]
    md, payload = render_audit(reports, "deadbeef")
    assert "Triviality retro-audit" in md
    assert "| trivial | 1 |" in md
    assert "| non-trivial | 1 |" in md
    assert "`t1`" in md and "`simp`" in md   # flagged trivial table
    assert "`e1`" in md                       # probe-error listed
    import json as _json
    data = _json.loads(payload)
    assert data["counts"]["trivial"] == 1
    assert data["counts"]["non-trivial"] == 1
    assert data["mathlib_rev"] == "deadbeef"
    assert len(data["reports"]) == 3


def test_render_audit_clean_library():
    md, _ = render_audit([{"goal": "n1", "verdict": "non-trivial", "closed_by": None}], "x")
    assert "the library is clean" in md


def test_classify_decide_decidable_noise_not_probe_error():
    # #410 follow-up: `decide` can't synthesize Decidable for a ∀ over an infinite
    # type — that tactic-limitation message must NOT read as a statement error.
    out = "error: failed to synthesize\n  Decidable (∀ (n : ℕ), n + 0 = n)\n"
    assert classify(1, out) == "non-trivial"
    # a genuine statement typeclass gap still surfaces:
    assert classify(1, "error: failed to synthesize instance\n  Inv ℕ") == "probe-error"
