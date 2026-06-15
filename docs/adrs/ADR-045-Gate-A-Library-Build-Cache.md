# ADR-045: Persistent Library Build Cache for Gate A

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-045 |
| **Initiative** | unsorry — Gate A performance |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Superseded by [ADR-046](ADR-046-Gate-A-Namespace-Cache-Volume.md) |

> **Superseded (2026-06-15):** the `actions/cache` mechanism here never warmed on `main`
> (skipped/cancelled main runs), the three parallel jobs collided on cache reservation, and it
> never cached mathlib (~19-min Azure re-download every run). ADR-046 replaces it with a
> Namespace cache volume that bind-mounts the whole `.lake` tree. The cold-build timeout headroom
> from #599 still applies to the soft-fail/cold path.

## Context

Gate A's three Lean jobs — `gate-a-prepare`, `gate-a-audit`, `gate-a-replay` — each check out a
fresh tree and each run `lake build UnsorryLibrary --wfail` before their own step (cheap
checks, axiom audit, kernel replay). mathlib arrives fast as a binary olean cache
(`lean-action`'s `use-github-cache`, ~1 min), but the **local `UnsorryLibrary` oleans are not
persisted across runs**, so the library is recompiled from scratch every job.

Measured on a representative prove PR (run 27512269673):

- `gate-a-prepare` library build: **~21 min** (`21:16:37 → 21:37:36`).
- `gate-a-replay` library build: **~16 min** (`22:04:39 → 22:21:08`).
- `gate-a-audit` does the identical build before its (already-incremental, ADR-033) audit.

So a one-proof change pays a full cold library compile **three times** per gate-a run, while the
axiom audit and kernel replay — the actually-authoritative steps — are already incremental and
fast. The build is the long pole and it is pure waste: the unchanged modules are byte-identical
to `main`.

## WH(Y) Decision Statement

**In the context of** a Gate A whose three jobs each cold-build the whole `UnsorryLibrary`
(~16-21 min apiece) on every run because only mathlib — not the local oleans — is cached, while
the audit and replay are already incremental,
**facing** the fact that this triples the dominant cost of every prove PR for no soundness
benefit (the unchanged modules are identical to main and were already verified there),
**we decided for** caching the repository-local Lake build directory **`.lake/build`** with
`actions/cache` (the GitHub Actions cache protocol, which the Namespace runners already back
with high-performance storage — proven by `lean-action`'s working mathlib cache): a key of
`lake-build-<os>-hashFiles(lean-toolchain, lake-manifest.json, lakefile.toml)-<sha>` with a
`restore-keys` prefix dropping the sha, added to all three jobs — so a new commit restores the
most recent oleans and `lake build` recompiles only the changed modules, and within one run
`gate-a-prepare` saves under the commit sha while `gate-a-audit`/`gate-a-replay` (which `need`
prepare) restore that exact key, building the library **once per run instead of three times**,
**and neglected** Namespace-native caching (`nsc artifact`, cache volumes) — rejected for this
PR: `actions/cache` is portable, is the same mechanism already in use, and what we cache
(`.lake/build`, the local oleans — not mathlib) is small enough that raw cache throughput is not
the bottleneck; a Namespace cache volume in the runner profile is a cleaner *follow-up* the
maintainer can layer on outside the repo — and caching mathlib here (already handled by
`lean-action`) or restructuring the three jobs into one build + two artifact-consumers (larger
change; the cache already gives the build-once benefit),
**to achieve** Gate A library builds dropping from ~16-21 min × 3 to one incremental build of
the changed module(s) — minutes, not the better part of an hour — on every prove PR and on
re-runs of a cancelled run,
**accepting that** the cache is keyed advisory state, not trust-bearing: it is invalidated by
any toolchain / mathlib / lakefile change (forcing a full cold rebuild), and the soundness
guarantees are unchanged — Lake's content-hash traces recompile any module whose source
changed (the same incrementality the project already trusts for local `lake build`), the
authoritative axiom audit and `leanchecker` kernel replay still run, and the kernel replay
validates an olean's proof term against the kernel whether the olean was just built or restored;
every olean that reaches `main` is kernel-replayed by the **full** post-merge replay (push to
`main` runs with no BASE_SHA), so a stale or poisoned cache can never produce a false PASS.

## Soundness argument (explicit)

1. **Incrementality is Lake's, not ours.** Restoring `.lake/build` and running `lake build`
   triggers Lake's standard trace check: any source file whose content hash differs from the
   cached trace is recompiled. This is identical to a local incremental build across a `git
   checkout` — already trusted throughout the project.
2. **The authoritative checks are untouched.** `--wfail` build, axiom audit (ADR-006/011), and
   `leanchecker` kernel replay (ADR-033) all still run. Replay kernel-checks olean proof terms
   regardless of their provenance (built vs restored).
3. **Every merged olean is fully kernel-replayed.** A push to `main` runs audit + replay with
   no BASE_SHA → the full library is re-audited and re-replayed. A cache that ever drifted from
   source would surface there (or fail to load), so it cannot silently admit an unsound proof.
4. **Key invalidation.** Toolchain / mathlib / lakefile changes change the key prefix → cold
   rebuild, so oleans are never reused across an incompatible compiler or dependency set.

## Consequences

- **Positive.** Gate A's long pole (the library build) goes from ~16-21 min × 3 to one
  incremental build; re-runs of a cancelled run are near-instant (exact-key hit on the sha).
- **Positive.** Lower runner-minute spend; faster autonomous merge loop (ADR-005).
- **Negative.** First run after a toolchain/mathlib bump (or the very first run introducing the
  cache) pays one cold build. A cache miss degrades gracefully to today's behaviour.
- **Follow-up.** A Namespace cache volume mounted at `.lake` in the runner profile would remove
  even the restore/save step; this PR's cache step becomes redundant and removable if adopted.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Build-cache spec | Specification | specs/SPEC-045-A-Gate-A-Library-Build-Cache.md |
| REF-2 | Gate A workflow | Specification | specs/SPEC-006-B-Gate-A-Workflow.md |
| REF-3 | Incremental kernel replay | Decision | ADR-033-Incremental-Kernel-Replay.md |
| REF-4 | Gate A soundness enforcement | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
