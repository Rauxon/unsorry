# ADR-047: RAM-Capped Parallel Kernel Replay

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-047 |
| **Initiative** | unsorry — Gate A performance |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Accepted |

> **Revised before merge (2026-06-15): replay is SERIAL by default; parallelism is opt-in.**
> The first cut auto-detected available RAM (`max_safe_replay_jobs` over `/proc/meminfo`) to choose
> the chunk concurrency. That is unsafe in a **container**: `/proc/meminfo` reports the **host's**
> memory, not the cgroup limit, so on a 16 GB runner it read ~74 GB, ran **7 concurrent**
> `leancheckers`, and OOM-killed every chunk (exit 137). Since one `leanchecker` already needs
> ~7–10 GB, parallelism cannot help a typical (16 GB) runner anyway. So replay now stays **serial**
> unless an operator explicitly sets `UNSORRY_REPLAY_JOBS` (a runner they *know* has the RAM). The
> durable win for memory-bound runners is the **60 → 120 min timeout** (so the serial full replay
> completes) plus keeping the active set small via archiving (ADR-041). The sections below describe
> the original RAM-cap intent; the shipped behaviour is serial-by-default + opt-in override.

## Context

A change to any gate/infra file (`tools/gate_a/**`, `.github/workflows/gate-a.yml`,
`lean-toolchain`, lakefiles, manifest) forces a **FULL** kernel replay of the whole active
library (ADR-033) — the conservative backstop when the incremental "unchanged ⇒ already verified"
assumption can't be trusted. Full replay runs on the `namespace-profile-unsorry-2` profile.

`tools/gate_a/parallel_modules.py::replay` **hard-coded `effective_jobs = 1`** (`_ = jobs`): it
ignored `--jobs` entirely and ran every `leanchecker` chunk serially. The reason was real — each
`leanchecker` holds ~all of mathlib resident (~7 GB), and an earlier unbounded `--jobs 4`
OOM-killed runners (exit 143, #264). So replay was pinned serial.

The consequence: a full replay is bound by **serial** per-chunk time, and as the active library
grew it crept past the 60-min `gate-a-replay` timeout and was killed on **every** run — including
PRs that only touch CI config (e.g. the cache-volume work). Adding CPU did nothing, because the
work was `--jobs 1`; adding RAM did nothing, because the workflow still requested `--jobs 1`.

## WH(Y) Decision Statement

**In the context of** a FULL kernel replay (forced by any gate/infra change, ADR-033) that ran
strictly serially because two concurrent `leanchecker` processes had OOM-killed runners,
**facing** the fact that the serial full replay now exceeds the 60-min timeout and that neither
more CPU nor more RAM helped — the workflow requested `--jobs 1` and the tool ignored `jobs`
anyway,
**we decided for** making replay **honor `--jobs`, capped conservatively by available RAM**:
budget `GB_PER_REPLAY_PROC = 10 GB` per `leanchecker` and reserve `RAM_RESERVE_GB = 4 GB`, so a new
`max_safe_replay_jobs(jobs, mem_gb)` returns `min(jobs, (free_ram − 4) // 10)` (floored at 1; a
first cut at 7 GB with no reserve OOM-killed chunks at exit 137), with an `UNSORRY_REPLAY_JOBS`
override to pin the count; the workflow now passes `--jobs "$(nproc)"`, and replay
splits into `max(ceil(n/REPLAY_CHUNK_SIZE), effective_jobs)` chunks run up to `effective_jobs` at a
time — so it stays **serial on a small runner** (one mathlib image, exactly the condition that
prevents the #264 OOM) and **scales on a high-RAM one**; we also raised `gate-a-replay`
`timeout-minutes` 60 → 120 as a safety net for the still-serial low-RAM path,
**and neglected** a blanket timeout bump alone (treats the symptom — a serial full replay just
crawls), a fixed `--jobs N` (OOMs whenever the runner is too small for N mathlib images — the
exact #264 failure), and relaxing ADR-033 so gate/infra changes skip full replay (weakens the
soundness backstop),
**to achieve** a full replay whose wall-clock drops with cores+RAM (e.g. ~8 concurrent chunks on
an 8 vCPU / 64 GB profile turns a ~60+ min serial replay into ~minutes), unblocking gate/infra
PRs without removing any validation,
**accepting that** the speed-up requires sizing `namespace-profile-unsorry-2` with enough RAM
(operator config; ~10 GB × desired concurrency + 4 GB reserve), that on a small runner replay stays serial (slow
but correct, covered by the 120-min headroom), and that the RAM estimate is a heuristic — set
conservatively so it under-subscribes rather than risk an OOM (a false *negative*, never a false
*positive*).

## Soundness

Parallelism changes **only wall-clock**, not verdicts: each `leanchecker` chunk independently
kernel-checks its modules; running chunks concurrently produces identical per-module results. The
only failure mode parallelism can introduce is OOM → exit 143 → a *red* gate (false negative,
never a false pass). The RAM cap (`(free_ram − 4) // 10`, floored at 1) is precisely what bounds
concurrency to what fits, so it cannot silently admit an unsound proof.

## Operator note

To realise the speed-up, size `namespace-profile-unsorry-2` (the full-replay/infra profile) with
RAM ≈ `10 GB × desired concurrency + 4` — e.g. **8 vCPU / 64 GB** for ~6-way replay. Without it, replay
runs serially within available RAM and relies on the 120-min timeout. (Per ADR-046, the same
profile also benefits from the `.lake` cache volume.)

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Replay-parallelism spec | Specification | specs/SPEC-047-A-Parallel-Kernel-Replay.md |
| REF-2 | Incremental kernel replay (full-replay fallback) | Decision | ADR-033-Incremental-Kernel-Replay.md |
| REF-3 | Gate A soundness enforcement | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |
| REF-4 | Namespace cache volume (same profile) | Decision | ADR-046-Gate-A-Namespace-Cache-Volume.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
