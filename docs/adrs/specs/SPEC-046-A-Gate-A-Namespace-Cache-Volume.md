# SPEC-046-A: Gate A `.lake` Cache on a Namespace Cache Volume

Implements: [ADR-046](../ADR-046-Gate-A-Namespace-Cache-Volume.md) · Status: Living · Updated: 2026-06-15

Supersedes the `actions/cache` mechanism of [SPEC-045-A](SPEC-045-A-Gate-A-Library-Build-Cache.md).

## Behaviour

Each Gate A Lean job (`gate-a-prepare`, `gate-a-audit`, `gate-a-replay`) bind-mounts the whole
`.lake` directory from a Namespace cache volume, so across runs it persists:

- `.lake/packages/**` — resolved dependency clones (no re-clone) and **mathlib oleans** (no
  ~19-min Azure re-download);
- `.lake/build/**` — the `UnsorryLibrary`/`UnsorryGoals` oleans (incremental build, not a cold
  rebuild).

## Implementation (`.github/workflows/gate-a.yml`)

In all three Lean jobs, immediately after `actions/checkout` (which wipes the workspace):

```yaml
- name: Cache .lake on Namespace volume (mathlib + deps + library) (ADR-046)
  uses: namespacelabs/nscloud-cache-action@15799a6b54e5765f85b2aac25b3f0df43ed571c0 # v1.4.3
  continue-on-error: true
  with:
    path: .lake
```

- **Keyless bind-mount.** No `key`/`restore-keys`; the action links `.lake` to the cache volume,
  so there is no upload/download and no per-key reservation (eliminating the
  `prepare`/`audit`/`replay` reserve collisions).
- **After checkout.** Required — checkout wipes the workspace, so the mount must follow it.
- **`continue-on-error: true`.** Soft-fail: if no cache volume is attached the step errors but
  the job continues and runs cold (lean-action downloads mathlib, library builds from scratch).
- **lean-action `use-github-cache: false`.** The volume replaces the GHA cache; this also removes
  the reserve-collision warnings.

## Operator prerequisite (outside the repo)

Enable caching on the `namespace-profile-unsorry-1` and `-2` runner profiles
(https://cloud.namespace.so/workspace/actions/profiles), size ≥20 GB. No `runs-on` label change.
Until enabled, the cache step soft-fails and gate-a runs cold (the #599 45-min timeout covers it).

## Soundness invariants (unchanged)

- Lake's content-hash traces recompile any module whose source changed.
- `--wfail` build, axiom audit, and `leanchecker` kernel replay still run; replay kernel-checks
  oleans whether built or volume-restored.
- A push to `main` runs the **full** audit + replay (no BASE_SHA) — every merged olean is
  kernel-replayed, so a stale/corrupt volume cannot produce a false PASS.

## Acceptance criteria

- `.github/workflows/gate-a.yml` parses; all three Lean jobs use `nscloud-cache-action`
  (pinned by commit SHA) with `path: .lake` and `continue-on-error: true`; no `actions/cache`
  step and no `use-github-cache: true` remain.
- With a cache volume attached, a second gate-a run restores `.lake` from the volume: the mathlib
  step and the library build drop to ~minutes (no Azure re-download, no cold rebuild).
- With no volume attached, the cache step soft-fails and gate-a still completes (cold).
- Gate A's required result and its audit/replay verdicts are unchanged by the cache.
