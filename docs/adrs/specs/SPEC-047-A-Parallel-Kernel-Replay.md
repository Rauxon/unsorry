# SPEC-047-A: RAM-Capped Parallel Kernel Replay

Implements: [ADR-047](../ADR-047-Parallel-Kernel-Replay.md) · Status: Living · Updated: 2026-06-15

## Behaviour

`tools/gate_a/parallel_modules.py::replay` now honours the requested `--jobs`, capped by available
RAM, instead of the previous hard-coded serial (`effective_jobs = 1`). A FULL replay (forced by
any gate/infra change, ADR-033) therefore scales with cores+RAM rather than crawling serially.

## Implementation

- **`GB_PER_REPLAY_PROC = 7.0`** — each `leanchecker` holds ~all of mathlib resident.
- **`max_safe_replay_jobs(requested_jobs, mem_gb=None)`** → `min(requested_jobs, free_ram // 7)`,
  floored at 1. `mem_gb` overrides the measured RAM (used by tests for determinism).
- **`replay(..., mem_gb=None)`**: `effective_jobs = max_safe_replay_jobs(jobs, mem_gb)`; chunk count
  `n_chunks = min(n, max(ceil(n / REPLAY_CHUNK_SIZE), effective_jobs))` so there are enough chunks
  to use the parallelism while each stays bounded by `REPLAY_CHUNK_SIZE`; chunks run up to
  `effective_jobs` at a time via the existing `run_commands` ThreadPoolExecutor.
- **Workflow** (`gate-a.yml`): the replay step passes `--jobs "$(nproc)"` (both incremental and
  full branches); the tool's RAM cap does the actual limiting. `gate_a_replay` `timeout-minutes`
  raised 60 → 120 as a safety net for the still-serial low-RAM path.

## Safety

Parallelism changes only wall-clock, never per-module verdicts (each chunk independently
kernel-checks its modules). The only parallelism-induced failure is OOM → exit 143 → a red gate
(false negative), never a false pass. The `free_ram // 7` cap (floored at 1) bounds concurrency to
what fits, set conservatively to under-subscribe rather than risk OOM.

## Operator note

Realising the speed-up needs `namespace-profile-unsorry-2` sized with RAM ≈ `7 GB × concurrency`
(e.g. 8 vCPU / 64 GB → ~8-way). Without it, replay stays serial within available RAM, covered by
the 120-min timeout.

## Acceptance criteria

- `max_safe_replay_jobs`: caps by RAM (`mem_gb=8 → 1`, `16 → 2`, `64 → min(req,9)`), never below 1,
  never above requested. (`test_max_safe_replay_jobs_caps_by_ram`.)
- `replay` with a small library: `mem_gb=8` → 1 chunk (serial); `mem_gb=64, jobs=4` → 4 chunks, all
  modules covered. (`test_replay_parallelism_capped_by_ram`.)
- `replay` past `REPLAY_CHUNK_SIZE` still splits into bounded chunks covering every module.
  (`test_replay_chunks_a_large_library`.)
- A chunk failure still fails the replay. (`test_replay_propagates_a_chunk_failure`.)
- `.github/workflows/gate-a.yml` parses; replay step uses `--jobs "$(nproc)"`; `gate-a-replay`
  timeout is 120.
