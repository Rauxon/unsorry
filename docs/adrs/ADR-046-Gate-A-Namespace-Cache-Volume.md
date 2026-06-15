# ADR-046: Gate A `.lake` Cache on a Namespace Cache Volume

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-046 |
| **Initiative** | unsorry — Gate A performance |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Accepted |

## Context

ADR-045 cached the local `.lake/build` with `actions/cache`. In practice that approach hit
three independent failure modes on the Namespace runners, and it never covered the biggest cost:

1. **Caches never warmed on `main`.** A cache only helps other PRs if it is saved on
   `refs/heads/main`, but main's gate-a runs are usually **skipped** (non-Lean pushes) or
   **cancelled** (`cancel-in-progress` + frequent merges). The cache store only ever held
   PR-ref-scoped entries, so every PR got a cache miss.
2. **Reserve collisions.** The three parallel jobs (`prepare`/`audit`/`replay`) share one
   content-based cache key, so `actions/cache/save` raced — *"Unable to reserve cache … another
   job may be creating this cache. Cache save failed."*
3. **mathlib was never cached at all.** `actions/cache` only held `.lake/build` (~100 MB local
   oleans); mathlib's ~2.4 GB of oleans were re-downloaded from the Azure CDN **every run**, a
   measured **~19 minutes** (`Build (lean-action, mathlib binary cache)` step), because
   lean-action's own GHA cache suffered the same warm-on-main problem.

The net effect: the dominant gate-a costs (mathlib download + library build) were paid cold on
essentially every run.

## WH(Y) Decision Statement

**In the context of** Gate A on Namespace runners, where `actions/cache` never warmed on `main`,
the three parallel jobs collided on cache reservation, and the ~2.4 GB mathlib oleans were
re-downloaded (~19 min) every run,
**facing** the fact that the `actions/cache` model is fundamentally branch/PR-scoped, key-based,
and upload/download-driven — exactly the properties that break under "frequent merges + skipped
main runs + three concurrent jobs",
**we decided for** caching the **entire `.lake` tree** (mathlib oleans, resolved dependency
clones, and the `UnsorryLibrary`/`UnsorryGoals` oleans) on a **Namespace cache volume** via
`namespacelabs/nscloud-cache-action` (a keyless bind-mount of `.lake` to a persistent volume,
run after checkout in all three Lean jobs), with `continue-on-error: true` so gate-a **soft-fails
to today's cold behaviour** if no volume is attached, and with lean-action's `use-github-cache`
turned **off** (the volume replaces it, eliminating the reserve collisions),
**and neglected** keeping ADR-045's `actions/cache` (superseded — it never warmed, collided, and
ignored mathlib), Namespace `nsc artifact` upload/download (still key/transfer-based, same
warming problem), and a one-job-builds-then-shares restructure (larger change; the volume gives
build-once-share for free across jobs and runs),
**to achieve** a `.lake` that persists across runs on fast local storage: no ~19-min mathlib
re-download, no dependency re-clone, and an incremental library build — collapsing the cold
~25–40 min gate-a path to minutes, with no scoping, no key races, and no upload/download,
**accepting that** the cache volume is enabled in the **Namespace runner profile** (≥20 GB),
which is operator configuration outside this repository — until it is attached the cache step
soft-fails and gate-a simply runs cold (correct, just slow); and that this couples gate-a's
*performance* (never its *correctness*) to Namespace, while the soundness guarantees are
unchanged — Lake's content-hash traces recompile any changed source, and the axiom audit +
`leanchecker` kernel replay still validate every olean that reaches `main` (full replay on push
to `main`), whether the olean was built or restored from the volume.

## Soundness argument (unchanged from ADR-045)

1. Incrementality is **Lake's** content-hash trace system — a changed source always recompiles;
   identical to a local incremental build.
2. `--wfail` build, axiom audit, and `leanchecker` kernel replay all still run; replay
   kernel-checks olean proof terms regardless of provenance (built vs volume-restored).
3. A push to `main` runs the **full** audit + replay (no BASE_SHA), so every merged olean is
   kernel-replayed — a stale/corrupt volume cannot produce a false PASS (Lake would rebuild on a
   hash mismatch; a corrupt olean fails to load or fails replay).

## Operator prerequisite

Enable caching on the `namespace-profile-unsorry-1` and `namespace-profile-unsorry-2` runner
profiles (https://cloud.namespace.so/workspace/actions/profiles), sized ≥20 GB (the minimum;
`.lake` with mathlib is ~3–4 GB, so 20 GB is ample). No `runs-on` label or workflow change is
needed to attach it. Until enabled, the `continue-on-error` cache step soft-fails and gate-a
runs cold.

## Consequences

- **Positive.** Eliminates the ~19-min mathlib re-download and the cold library rebuild on every
  run; removes the reserve-collision warnings; no PR/main scoping to reason about.
- **Positive.** Concurrency-safe: Namespace cache volumes fork automatically across the three
  parallel jobs.
- **Negative.** Performance now depends on a Namespace-profile setting (operator-owned). A
  missing volume degrades gracefully (soft-fail → cold run).
- **Supersedes.** ADR-045's `actions/cache` mechanism (its `.github/workflows/gate-a.yml` cache
  steps are replaced). The ADR-045 cold-build timeout headroom (#599) remains relevant for the
  soft-fail/cold path.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Cache-volume spec | Specification | specs/SPEC-046-A-Gate-A-Namespace-Cache-Volume.md |
| REF-2 | Superseded: actions/cache build cache | Decision | ADR-045-Gate-A-Library-Build-Cache.md |
| REF-3 | nscloud-cache-action | External | https://namespace.so/docs/reference/github-actions/nscloud-cache-action |
| REF-4 | Namespace GitHub Actions caching | External | https://namespace.so/docs/solutions/github-actions/caching |
| REF-5 | Gate A workflow | Specification | specs/SPEC-006-B-Gate-A-Workflow.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
