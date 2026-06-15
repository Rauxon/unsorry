# SPEC-047-A: RAM-Capped Parallel Kernel Replay

Implements: [ADR-047](../ADR-047-Parallel-Kernel-Replay.md) · Status: Living · Updated: 2026-06-15

## Behaviour

`tools/gate_a/parallel_modules.py::replay` now honours the requested `--jobs`, capped by available
RAM, instead of the previous hard-coded serial (`effective_jobs = 1`). A FULL replay (forced by
any gate/infra change, ADR-033) therefore scales with cores+RAM rather than crawling serially.

## Implementation

- **`max_safe_replay_jobs(requested_jobs, mem_gb=None)` → serial (1) by default.** No RAM
  auto-detection: in a container `/proc/meminfo` reports the host's memory, not the cgroup limit, so
  a RAM heuristic over-counted and ran 7 concurrent `leancheckers` → OOM, exit 137. Replay returns 1
  unless **`UNSORRY_REPLAY_JOBS`** is set (operator opt-in for a runner with known RAM).
  `requested_jobs`/`mem_gb` are accepted for CLI/test symmetry but never auto-parallelise.
- **`replay(..., mem_gb=None)`**: `effective_jobs = max_safe_replay_jobs(jobs)`; chunk count
  `n_chunks = min(n, max(ceil(n / REPLAY_CHUNK_SIZE), effective_jobs))` — so by default
  (`effective_jobs == 1`) it's `ceil(n / REPLAY_CHUNK_SIZE)` bounded chunks run **serially** via
  `run_commands`; an opt-in `UNSORRY_REPLAY_JOBS` fans them out.
- **Workflow** (`gate-a.yml`): replay passes `--jobs 1` (the tool is serial-by-default regardless),
  and `gate_a_replay` `timeout-minutes` is raised **60 → 120** — the actual win for memory-bound
  runners, so the serial full replay completes.

## Safety

Concurrency changes only wall-clock, never per-module verdicts (each chunk independently
kernel-checks its modules). The only parallelism-induced failure is OOM → exit 137/143 → a red gate
(false negative, never a false pass). Serial-by-default removes that risk entirely on unknown/cgroup
runners; opt-in `UNSORRY_REPLAY_JOBS` puts the RAM judgement in the hands of an operator who knows
their runner.

## Operator note

Replay is serial by default and the 120-min timeout covers it. Parallelism is opt-in: an operator
with a runner of known RAM sets `UNSORRY_REPLAY_JOBS=N` (size RAM ≈ `~10 GB × N`); on the standard
16 GB runner, leave it unset (one `leanchecker` already fills the box). The complementary lever for
keeping the serial full replay short is ADR-041 archiving (small active set).

## Acceptance criteria

- `max_safe_replay_jobs`: serial by default — returns 1 regardless of `requested_jobs`/`mem_gb`.
  (`test_max_safe_replay_jobs_serial_by_default`.)
- `UNSORRY_REPLAY_JOBS` pins the count (opt-in parallelism); a bad value falls back to serial.
  (`test_replay_jobs_env_override`.)
- `replay` default: small library → 1 chunk (serial); `UNSORRY_REPLAY_JOBS=4` → 4 chunks, all
  modules covered. (`test_replay_is_serial_unless_opted_in`.)
- `replay` past `REPLAY_CHUNK_SIZE` still splits into bounded chunks covering every module.
  (`test_replay_chunks_a_large_library`.)
- A chunk failure still fails the replay. (`test_replay_propagates_a_chunk_failure`.)
- `.github/workflows/gate-a.yml` parses; replay step uses `--jobs 1`; `gate-a-replay` timeout is 120.
