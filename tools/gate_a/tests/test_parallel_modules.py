import json
import subprocess
from pathlib import Path

from tools.gate_a.parallel_modules import audit, module_names, replay, split_evenly


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
