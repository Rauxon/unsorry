# SPEC-033-A: Incremental (Diff-Scoped) Kernel Replay

Implements: [ADR-033](../ADR-033-Incremental-Kernel-Replay.md) · Status: Living · Updated: 2026-06-14

Amends the replay scope described in [SPEC-006-B](SPEC-006-B-Gate-A-Workflow.md):
the **audit** remains full-library; the **kernel replay** is diff-scoped on PRs
and full on `main`.

## 1. Inputs

`python3 -m tools.gate_a.parallel_modules replay [--base <ref>]`

- **`--base <ref>` present** (PR builds, and push to `main` as of ADR-048
  Phase 2): incremental replay against `<ref>` —
  `github.event.pull_request.base.sha` on a PR, `github.event.before` (the
  previous `main` tip) on a push.
- **`--base` absent** (manual runs, the scheduled `gate-a-full-replay` backstop,
  or a push with a zero/empty base): **full** replay. Per ADR-048 Phase 2 the
  per-push full replay is replaced by an incremental push + a daily scheduled
  full replay; the workflow passes the zero-SHA case through to this full path.

The `gate-a` job checks out with `fetch-depth: 0`, so `<ref>` is present for the
`git diff`.

## 2. Replay-set algorithm (PR builds)

1. `paths = git -C <root> diff --name-only <base> HEAD`.
   - If git exits non-zero (missing base / not a repo) → **full replay**.
2. If any path is **olean-invalidating** → **full replay**
   (`forces_full_replay`):
   - exact: `lean-toolchain`, `lakefile.toml`, `lakefile.lean`,
     `lake-manifest.json`.
   These change the toolchain/dependency set and so can change any olean, so the
   "unchanged ⇒ identical olean" invariant no longer holds. `tools/gate_a/**` and
   `.github/workflows/gate-a.yml` are **no longer** full-replay triggers (#792):
   they change no olean, so they run an incremental replay (covered by the gate's
   own unit tests + the scheduled full-replay backstop). The axiom audit keeps the
   wider `forces_full_audit` set (`tools/gate_a/**`, `AxiomAudit/`,
   `AuditFixtures/`, `gate-a.yml`), since those can change which axioms it accepts.
3. `changed = { library/Unsorry/<…>.lean in paths } → module names`.
   - If empty (the PR touched no library module) → **replay nothing**, exit 0.
4. Build the import graph by parsing `^\s*import\s+(Unsorry\.\S+)` from every
   on-disk `library/**/*.lean` (this includes the generated `*Binding` modules,
   which `import Unsorry.<Base>`).
5. **Replay set** = `changed` ∪ its transitive **reverse-import closure** (every
   module that imports, directly or transitively, a changed module), intersected
   with on-disk modules (so a *deleted* module — no olean — drops out).
6. Replay the set with `leanchecker`, serially, chunked by `REPLAY_CHUNK_SIZE`
   exactly as the full path (the set is normally tiny, so one chunk).
   `REPLAY_CHUNK_SIZE` defaults to 30 and is overridable via the
   `UNSORRY_REPLAY_CHUNK` env var (bad value → 30), so a full replay can fit a
   smaller (8 GB) runner with a smaller chunk (ADR-048 Phase 2).

## 3. Soundness argument

In CI every olean is **rebuilt from the PR's `.lean` sources** (the build step),
so a PR cannot smuggle a pre-built olean. An olean differs from `main` only if
its module's source changed **or** a module it imports changed (recompiled
against the new dependency). The replay set is exactly *changed ∪ reverse-import
closure*, so:

> **Invariant.** Any module **not** in the replay set has an unchanged source
> **and** an entirely unchanged transitive import closure ⇒ its rebuilt olean is
> byte-identical to the one already kernel-replayed when it merged ⇒ re-replaying
> it is redundant.

Corollaries:
- An interface change to `M` recompiles every dependent `D`; `D` imports `M` ⇒
  `D` is in the closure ⇒ replayed. (If the change instead breaks `D`, the
  `--wfail` build fails first.)
- A `*Binding` module imports its base ⇒ a changed base pulls its binding into
  the closure ⇒ the ADR-011 statement-binding obligation is re-replayed.
- mathlib is a pinned, verified cache (ADR-002); it is loaded as trusted context
  but is not the swarm's output and is not the threat surface.

Every uncertainty resolves **toward** full replay (§2.1, §2.2). Post-merge,
`main` runs the **same incremental** replay on the pushed diff (ADR-048 Phase 2),
and the scheduled `gate-a-full-replay` workflow re-runs the **full** replay daily
as the defense-in-depth backstop — so the change can only ever replay *more* than
strictly necessary, never less, and the whole library is still re-derived on a
schedule.

## 4. Implementation

`tools/gate_a/parallel_modules.py`:
- `library_module_for_path` — `library/…/Foo.lean → Unsorry…Foo` (None otherwise).
- `changed_paths` — `git diff --name-only <base> HEAD`; `None` on git failure.
- `forces_full_replay` — returns the offending global-impact path, or `None`.
- `import_graph` — `{module: {imported Unsorry modules}}` over on-disk library.
- `replay_scope` — changed ∪ transitive reverse-import closure ∩ on-disk.
- `scoped_targets` — orchestrates the above; returns the target list, `[]` (no
  library change), or `None` (fall back to full).
- `replay(root, jobs, runner, base=None)` — full when `base is None` or
  `scoped_targets` returns `None`; skip when it returns `[]`; else replay the set.

CI (`.github/workflows/gate-a.yml`): the replay step passes
`--base ${{ github.event.pull_request.base.sha }}` on `pull_request`, nothing on
`push`.

## 5. Validation

`tools/gate_a/tests/test_parallel_modules.py`:
- `test_library_module_for_path`, `test_forces_full_replay` — path/trigger logic.
- `test_replay_scope_reverse_closure` — `C→B→A`, `ABinding→A`: changing `A`
  replays `{A,B,C,ABinding}`; a leaf replays only itself.
- `test_replay_incremental_changed_plus_dependents_only` — only the changed
  module + dependents reach `leanchecker`; unrelated modules are skipped.
- `test_replay_incremental_no_library_change_skips` — a docs-only PR replays
  nothing (exit 0).
- `test_replay_global_impact_forces_full` — a `lean-toolchain` change → full.
- `test_replay_git_failure_falls_back_to_full` — git non-zero → full.
- `test_replay_without_base_is_full` — no `--base` → full, and git is never
  consulted.
