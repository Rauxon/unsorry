import json
import subprocess
from pathlib import Path

from tools.gate_a.parallel_modules import (
    audit,
    forces_full_replay,
    import_graph,
    library_module_for_path,
    module_names,
    replay,
    replay_scope,
    split_evenly,
)


def completed(
    argv: tuple[str, ...],
    returncode: int = 0,
    stdout: str = "",
    stderr: str = "",
) -> subprocess.CompletedProcess[str]:
    return subprocess.CompletedProcess(argv, returncode, stdout, stderr)


def test_module_names_and_balanced_chunks(tmp_path: Path):
    (tmp_path / "library" / "Unsorry").mkdir(parents=True)
    (tmp_path / "goals").mkdir()
    (tmp_path / "library" / "Unsorry" / "One.lean").write_text("")
    (tmp_path / "library" / "Unsorry" / "Two.lean").write_text("")
    (tmp_path / "goals" / "three-four.lean").write_text("")

    assert module_names(tmp_path, "library") == ["Unsorry.One", "Unsorry.Two"]
    assert module_names(tmp_path, "goals") == ["goals.three-four"]
    assert split_evenly(["a", "b", "c", "d", "e"], 2) == [
        ["a", "b", "c"],
        ["d", "e"],
    ]


def test_audit_combines_parallel_json_reports(tmp_path: Path):
    (tmp_path / "library" / "Unsorry").mkdir(parents=True)
    (tmp_path / "goals").mkdir()
    (tmp_path / "library" / "Unsorry" / "One.lean").write_text("")
    (tmp_path / "library" / "Unsorry" / "Two.lean").write_text("")
    (tmp_path / "goals" / "three.lean").write_text("")
    output = tmp_path / "report.json"
    calls = []

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        calls.append(argv)
        if argv[:3] == ("lake", "build", "axiom_audit"):
            return completed(argv)
        modules = [arg for arg in argv if "." in arg]
        report = [{"decl": module, "axioms": []} for module in modules]
        return completed(argv, stdout=json.dumps(report))

    assert audit(tmp_path, 4, output, runner) == 0
    assert json.loads(output.read_text()) == [
        {"decl": "Unsorry.One", "axioms": []},
        {"decl": "Unsorry.Two", "axioms": []},
        {"decl": "goals.three", "axioms": []},
    ]
    assert any("--allow-sorry" in call for call in calls)


def test_replay_propagates_a_chunk_failure(tmp_path: Path):
    (tmp_path / "library" / "Unsorry").mkdir(parents=True)
    (tmp_path / "library" / "Unsorry" / "One.lean").write_text("")
    (tmp_path / "library" / "Unsorry" / "Two.lean").write_text("")

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        return completed(argv, returncode=1 if "Unsorry.Two" in argv else 0)

    assert replay(tmp_path, 2, runner) == 1


def test_replay_is_serial_regardless_of_jobs(tmp_path: Path):
    # leanchecker holds mathlib resident per process, so concurrent invocations
    # OOM-kill a standard CI runner (exit 143). A small library fits one serial
    # leanchecker; chunking only kicks in past REPLAY_CHUNK_SIZE. Either way the
    # --jobs request is ignored — replay never runs two leancheckers at once.
    (tmp_path / "library" / "Unsorry").mkdir(parents=True)
    for name in ("One", "Two", "Three", "Four", "Five"):
        (tmp_path / "library" / "Unsorry" / f"{name}.lean").write_text("")

    calls: list[tuple[str, ...]] = []

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        calls.append(argv)
        return completed(argv, returncode=0)

    assert replay(tmp_path, 4, runner) == 0
    # one chunk → one leanchecker process → every module checked in it
    assert len(calls) == 1
    assert calls[0][:3] == ("lake", "env", "leanchecker")
    assert {"Unsorry.One", "Unsorry.Five"} <= set(calls[0])


def test_replay_chunks_a_large_library_serially(tmp_path: Path):
    # As the library grows past REPLAY_CHUNK_SIZE, one leanchecker over every
    # module OOMs even serially (#294 was not enough). Replay splits into
    # bounded chunks run one at a time, and every module is still replayed.
    from tools.gate_a.parallel_modules import REPLAY_CHUNK_SIZE
    (tmp_path / "library" / "Unsorry").mkdir(parents=True)
    names = [f"M{i}" for i in range(REPLAY_CHUNK_SIZE * 2 + 5)]
    for n in names:
        (tmp_path / "library" / "Unsorry" / f"{n}.lean").write_text("")

    calls: list[tuple[str, ...]] = []

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        calls.append(argv)
        return completed(argv, returncode=0)

    assert replay(tmp_path, 4, runner) == 0
    assert len(calls) >= 3  # split into multiple chunks
    assert all(c[:3] == ("lake", "env", "leanchecker") for c in calls)
    covered = {m for c in calls for m in c[3:]}
    assert covered == {f"Unsorry.{n}" for n in names}  # every module replayed


# --- incremental replay (ADR-033) -------------------------------------------

def _write_lib(tmp_path: Path, modules: dict[str, list[str]]) -> None:
    """modules: {name: [imported Unsorry module names]}."""
    d = tmp_path / "library" / "Unsorry"
    d.mkdir(parents=True, exist_ok=True)
    for name, imports in modules.items():
        body = "".join(f"import Unsorry.{imp}\n" for imp in imports)
        (d / f"{name}.lean").write_text(body + "theorem t : True := trivial\n")


def _runner_for(tmp_path, changed_stdout, *, git_rc=0):
    """A runner that answers `git diff` with changed_stdout and records the
    module lists passed to leanchecker."""
    replayed: set[str] = set()

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        if argv[0] == "git" and "diff" in argv:
            return completed(argv, returncode=git_rc, stdout=changed_stdout)
        if argv[:3] == ("lake", "env", "leanchecker"):
            replayed.update(argv[3:])
        return completed(argv)

    return runner, replayed


def test_library_module_for_path():
    assert library_module_for_path("library/Unsorry/Foo.lean") == "Unsorry.Foo"
    assert library_module_for_path("library/Unsorry/Sub/Bar.lean") == "Unsorry.Sub.Bar"
    assert library_module_for_path("goals/x.lean") is None
    assert library_module_for_path("docs/readme.md") is None


def test_forces_full_replay():
    assert forces_full_replay(["library/Unsorry/A.lean"]) is None
    assert forces_full_replay(["lean-toolchain"]) == "lean-toolchain"
    assert forces_full_replay(["lakefile.toml"]) == "lakefile.toml"
    assert forces_full_replay(["x", "tools/gate_a/check.py"]) == "tools/gate_a/check.py"
    assert forces_full_replay([".github/workflows/gate-a.yml"]) == ".github/workflows/gate-a.yml"


def test_replay_scope_reverse_closure(tmp_path):
    _write_lib(tmp_path, {"A": [], "B": ["A"], "C": ["B"], "ABinding": ["A"], "Unrel": []})
    graph = import_graph(tmp_path)
    # changing A pulls in everything that transitively imports A (incl. its binding)
    assert set(replay_scope(["Unsorry.A"], graph)) == {
        "Unsorry.A", "Unsorry.B", "Unsorry.C", "Unsorry.ABinding"
    }
    # a leaf only replays itself
    assert replay_scope(["Unsorry.C"], graph) == ["Unsorry.C"]
    assert replay_scope(["Unsorry.Unrel"], graph) == ["Unsorry.Unrel"]


def test_replay_incremental_changed_plus_dependents_only(tmp_path):
    _write_lib(tmp_path, {"A": [], "B": ["A"], "C": [], "ABinding": ["A"]})
    runner, replayed = _runner_for(tmp_path, "library/Unsorry/A.lean\n")
    assert replay(tmp_path, 2, runner, base="origin/main") == 0
    # A changed -> A + B + ABinding (import A); C untouched and skipped
    assert replayed == {"Unsorry.A", "Unsorry.B", "Unsorry.ABinding"}


def test_replay_incremental_no_library_change_skips(tmp_path):
    _write_lib(tmp_path, {"A": []})
    runner, replayed = _runner_for(tmp_path, "docs/readme.md\nCHANGELOG.md\n")
    assert replay(tmp_path, 2, runner, base="origin/main") == 0
    assert replayed == set()  # leanchecker never invoked


def test_replay_global_impact_forces_full(tmp_path):
    _write_lib(tmp_path, {"A": [], "B": ["A"]})
    runner, replayed = _runner_for(tmp_path, "lean-toolchain\nlibrary/Unsorry/A.lean\n")
    assert replay(tmp_path, 2, runner, base="origin/main") == 0
    assert replayed == {"Unsorry.A", "Unsorry.B"}  # FULL replay


def test_replay_git_failure_falls_back_to_full(tmp_path):
    _write_lib(tmp_path, {"A": [], "B": []})
    runner, replayed = _runner_for(tmp_path, "", git_rc=128)
    assert replay(tmp_path, 2, runner, base="deadbeef") == 0
    assert replayed == {"Unsorry.A", "Unsorry.B"}  # FULL replay on git failure


def test_replay_without_base_is_full(tmp_path):
    _write_lib(tmp_path, {"A": [], "B": ["A"]})
    calls: list[tuple[str, ...]] = []

    def runner(argv, **_kwargs):
        argv = tuple(argv)
        if argv[0] == "git":
            raise AssertionError("full replay must not consult git")
        if argv[:3] == ("lake", "env", "leanchecker"):
            calls.append(argv)
        return completed(argv)

    assert replay(tmp_path, 2, runner) == 0  # no base -> full, no git
    replayed = {m for c in calls for m in c[3:]}
    assert replayed == {"Unsorry.A", "Unsorry.B"}
