# SPEC-099-A: Per-Suite Mathlib Pin — Verifier Context, Segregated Verification, Toolchain Selection

Implements: [ADR-099](../ADR-099-Per-Suite-Mathlib-Pin-For-Benchmark-Ingestion.md) · Status: Proposed · Updated: 2026-06-25 · Builds on [SPEC-092-A](SPEC-092-A-Benchmark-Track.md), [SPEC-081-A](SPEC-081-A-Skeleton-Validate.md)

This SPEC fixes the *how* of ADR-099: a suite-scoped lake project pinned to each suite's
native `(toolchain, mathlib rev)`, used by ingestion, by Gate A verification, and by the
swarm prover. It reuses the archive-package machinery (`tools/archive/apply.py::cut()`,
`tools/gate_a/archive_packages.py`) rather than minting a parallel one.

**CODEOWNERS / human review.** Parts §2 (`.github/workflows/gate-a.yml`,
`tools/gate_a/`) and §3 (`swarm/`) are CODEOWNERS trust surfaces (ADR-019) and require a
human code-owner review; §1 (`tools/intake/`) auto-merges on green gates. Delivered as
separate feature branches (one logical change each, protocols §4).

---

## 1. Ingestion under the suite pin — `tools/intake/`

### Goal
`import_benchmark --build` elaborates and builds each suite at its **native** pin in a
suite-scoped lake project, records that native pin, and quarantines only genuine
non-builds — not pin-drift survivors.

### Behaviour
1. **Suite-scoped verifier context** — new module `tools/intake/verifier_context.py`:
   - `verifier_dir(root, suite_id) -> Path` → `root/targets/<suite>/_verify` (a
     leading-underscore dir; inert to the repo `lakefile.toml` `goals.+`/`Unsorry.+`
     globs and to `skeleton-validate`'s `validate_package`).
   - `scaffold(root, suite_id, *, toolchain, mathlib, manifest_src) -> Path` — writes
     `_verify/lean-toolchain` (= the `toolchain` arg), `_verify/lakefile.toml` (the
     archive `cut()` template with `rev = "<mathlib>"` substituted and a name derived
     from `suite_id`), and copies `manifest_src` → `_verify/lake-manifest.json`.
     Idempotent + deterministic (byte-identical re-write).
   - `warm_cache(vctx, *, runner) -> int` — runs `lake exe cache get` at `cwd=vctx`
     (the single subprocess seam; injectable for tests).
   - `ensure_verifier_context(root, suite_id, *, toolchain, mathlib, manifest_src,
     runner, warm=True) -> Path` — scaffold then optionally warm; raises a typed error
     on nonzero warmup (a failed warmup must abort ingest, never silently fall back to
     the repo pin).
2. **`import_benchmark.py` CLI** — add `--manifest <path>` (required with `--build`;
   the suite's native `lake-manifest.json`, operator-supplied per ADR-099 decision A)
   and `--no-warm-cache` (offline re-run where `_verify/.lake` is already populated).
   `--build` flow becomes: `ensure_verifier_context(...)` → **pin guard** →
   `classify_problems(problems, verdict_of=build_verdict_of(vctx, runner=subprocess.run))`.
3. **Pin guard** — `manifest_rev(_verify) == args.mathlib` (reuse
   `tools/sourcing/check_absence.py::manifest_rev`); on mismatch print an error and exit
   2 **before** `assemble_package`, so the recorded pin can never diverge from the pin
   that classified the suite. `--mathlib` is the **concrete rev**.
4. **Real-build hardening** — `build_verdict_of(vctx)` runs the **actual statement**
   through `lake env lean` at `cwd=vctx` first (`_build_verdict`, no `--wfail` so the
   trailing `sorry` is a warning, not an error); a nonzero rc quarantines with reason
   "does not build under the suite pin". Survivors go to the existing
   `_probe_verdict(text, vctx)` `foralltype` battery, which classifies glue (trivial) vs
   credited. This closes the probe-vs-build gap that passed 4 non-building goals in #6371.
5. **Twin-bug fix** — `tools/intake/skeleton_validate.py::_check_build` has the same
   repo-pin bug (`probe(lean, root=pkg)`); point it at `_verify` via `verifier_context`.
6. **Metadata** — `assemble_package` already records `mathlib`/`toolchain` verbatim into
   both `.aisp` files; the guard guarantees they equal the verifier-context pin. No
   change to the writer.
7. `.gitignore` adds `targets/*/_verify/.lake/` (never commit the built mathlib image).

### Verification (acceptance criteria — `tools/intake/tests/`)
1. `test_scaffold_writes_toolchain_lakefile_manifest` — the three files exist with the
   declared toolchain string, `rev = "<mathlib>"`, and a byte-identical copied manifest.
2. `test_scaffold_is_idempotent` / `test_scaffold_lakefile_name_derived_from_suite` —
   re-scaffold is byte-identical; two suites get distinct lakefile names.
3. `test_warm_cache_runs_lake_cache_get_in_vctx` / `test_warm_cache_nonzero_raises` /
   `test_ensure_verifier_context_skips_warm` — warmup argv + `cwd==vctx`; nonzero aborts;
   `warm=False` never calls the runner.
4. `test_build_verdict_runs_real_build_in_suite_context` (keystone) — `_build_verdict`
   runs `lake env lean` with `cwd==vctx`, **not** the repo root.
5. `test_build_error_quarantines` — the `Finset.toSet` evidence case quarantines.
6. `test_real_build_gap_closed` — a statement the `foralltype` proxy passes but the real
   build fails is quarantined.
7. `test_native_pin_recorded_in_both_aisp_files` — `skeleton.aisp` and `target.aisp`
   record the native rev (not the repo pin).
8. `test_main_build_guards_pin_mismatch` — pin mismatch returns 2 and writes no goals.
9. `test_main_build_uses_suite_context_not_repo_root` — every lake call's `cwd` is
   `_verify`; idempotent re-run reports "nothing new"; verdict deterministic.
10. Existing `classify_problems` / `test_build_flow_*` regress green.

---

## 2. Segregated verification at the suite pin — Gate A

### Goal
Benchmark proofs (at a non-repo pin, so they cannot enter `UnsorryLibrary`) are
kernel-verified at the suite's pin and recorded under `cohort:benchmark`, excluded from
the organic board.

### Behaviour
1. **Pinned-package validator** — generalise
   `tools/gate_a/archive_packages.py::validate_archive_package()` (the `cwd=package_root`
   + `lake exe cache get` + `lake build --wfail` + axiom-audit pattern) to a validator
   parameterised by `(toolchain, mathlib rev)`, reused for both archive packages (repo
   pin) and benchmark suite packages (native pin). A discovery pass enumerates the
   distinct pins across `targets/*/`.
2. **Gate A leg** — `.github/workflows/gate-a.yml` gains a benchmark-suite build leg
   that, for each distinct suite pin, warms that pin's cache (`lake exe cache get` — **N
   mathlib caches**; release-tag pins have published FRO caches) and builds the suite
   verification package with `--wfail` + axiom audit at that pin.
3. **Recording** — a proved benchmark obligation lands as a zero-sorry module + index
   entry in its **suite verification package** (`targets/<suite>/_verify/library/` +
   index), not the repo `library/Unsorry/`. The discharge is tagged `cohort:benchmark`.
4. **Surfacing** — `tools/leaderboard/registered_targets.py` already emits `mathlib_pin`;
   add the per-suite proved-at-pin count + verification status. The `benchmark_goal_ids`
   exclusion in `tools/leaderboard/generate.py` continues to keep these discharges out of
   the organic `community-stats`/`_score`.

### Verification (acceptance criteria)
1. `test_pinned_package_validator_uses_declared_pin` — validator builds at the declared
   toolchain/rev (`cwd`/toolchain asserted via runner double), for both repo-pin and
   native-pin packages.
2. `test_registered_targets_surfaces_pin_and_proved` — `registered-targets.json` reports
   the native pin + proved-at-pin per suite; deterministic (`--check` no-op after
   `--write`).
3. `test_cohort_benchmark_excluded_from_organic` — a benchmark discharge at a non-repo
   pin leaves the organic headline counts unchanged (the SPEC-092-A §3 invariant).
4. A live Gate A build of one non-repo-pin suite package proves the N-cache path
   end-to-end: kernel-verified, "0 false positives" at the suite pin (ADR-048/049).

---

## 3. `run.sh --goal` toolchain selection — `swarm/`

### Goal
`./swarm/run.sh --goal <slug>` proves a benchmark-suite goal in the suite-scoped project
at the suite's pin; non-benchmark goals are unaffected.

### Behaviour
1. **Suite-context resolution** — a goal slug resolves to its suite via
   `targets/<suite>/skeleton.aisp` subs (or `registered-targets.json`), yielding the
   suite `(toolchain, mathlib rev)`. Slugs not in any suite resolve to the repo pin.
2. **Prover build context** — `open_pr_worktree()`/`run_proof()` build/verify a
   benchmark goal in the suite verification package (its toolchain + manifest +
   `lake exe cache get` for that pin) instead of the repo-wide
   `lake build UnsorryLibrary --wfail`; the proof lands per §2's recording contract.
3. The repo-pin path is the default and is byte-for-byte unchanged for non-benchmark
   goals.

### Verification (acceptance criteria)
1. `./swarm/agent.sh --self-test` extended: `--goal <benchmark-slug>` resolves the suite
   pin and selects the suite toolchain/project; `--goal <organic-slug>` keeps the repo
   pin.
2. A `tools/` Python test for the slug→suite→pin resolver if it is factored into Python.
3. Plain `shellcheck` clean on the changed swarm scripts (warnings fail).

---

## 4. Out of scope (for this SPEC)
- One-time re-pin of already-imported suites' metadata to their true native rev (the
  existing suites recorded the repo pin) — tracked separately.
- The unsorry-guild goals-page rendering of the per-suite pin (separate repo; consumes
  the `registered-targets.json` contract).
- Automated fetching of suite `lake-manifest.json` (decision C in ADR-099) — deferred;
  operator supplies it (decision A).
