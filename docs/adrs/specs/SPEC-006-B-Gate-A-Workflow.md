# SPEC-006-B: Gate A Workflow (`.github/workflows/gate-a.yml`)

Implements: [ADR-006](../ADR-006-Gate-A-Soundness-Enforcement.md) · Status: Living · Updated: 2026-06-10

Lands with PR-9. `gate-a` joins `gate-b` as a **required status check** on `main` (ADR-005).

## Jobs

### 1. `detect` (always runs, seconds)
Determines whether the PR touches Lean-relevant paths: `library/**`, `goals/**/*.lean`, `lakefile.toml`, `lake-manifest.json`, `lean-toolchain`, `AxiomAudit/**`, `AuditFixtures/**`, `.github/workflows/gate-a.yml`. Output feeds the build job's `if:`.

**Why not `on.paths`:** a required check that is path-filtered never reports on non-matching PRs, leaving them permanently blocked on an "expected" status. The `detect`-job pattern keeps `gate-a` required while letting claims/docs/coordination PRs pass in ~30 s.

### 2. `gate-a` (the required context)
- Runs on a Namespace managed (ephemeral) runner via the `namespace-profile-unsorry-1` profile (currently 4 vCPU / 16 GB). At 16 GB this is memory parity with the GitHub-hosted runner, so the `leanchecker` replay stays **serial** and the swap-headroom step is **best-effort** (Namespace disallows `swapon`; its RAM covers the replay). Sizing the profile up (e.g. 8x32) would let replay re-parallelize. Profile-backed keeps the runner ephemeral (no self-hosted tampering surface). `detect` and the non-Lean gates stay on free GitHub-hosted runners.
- If `detect` says non-Lean: exits green immediately (the *job* still reports, which is the point).
- Else: `leanprover/lean-action@v1` (`use-mathlib-cache: auto`, `use-github-cache: true`, `build-args: "UnsorryGoals"`) — the action installs elan per `lean-toolchain` and restores the mathlib olean cache (guaranteed published for release tags, ADR-002).
- `lake build UnsorryLibrary --wfail` — verified: exits 1 on a sorried library module, fresh **and** replayed from Lake's warning cache; exits 0 clean.
- `python3 -m tools.gate_a.parallel_modules audit --jobs 4` enumerates every library and goal module, runs the same authoritative `axiom_audit` in bounded parallel chunks (goals retain `--allow-sorry`), and merges the per-chunk results into one valid JSON report. Any chunk failure fails the step (SPEC-006-A).
- `python3 -m tools.gate_a.parallel_modules replay --jobs 4` enumerates and kernel-replays every library module in bounded parallel chunks. Scope remains full-library; only execution is parallelized (anti-tampering).
- **Forbidden elaboration options** (`python3 -m tools.gate_a.check_library_options library`) — **authoritative** for the autoImplicit vector, not a belt. The build, axiom audit and leanchecker all *pass* a vacuous theorem enabled by `set_option autoImplicit true` (it is sound, merely meaningless — verified in sandbox and by W3 red-team PR #64), so the scan is the only layer that catches it. It scans every `library/**/*.lean` whole-file with all whitespace collapsed, so splitting the option across lines cannot evade it (the exact #64 bypass). `autoImplicit`/`relaxedAutoImplicit` have no legitimate use in the verified library. Self-tested by `tools/gate_a/tests/`.
- Textual lint (belt only): fail if the PR diff under `library/` matches `\b(sorry|admit|sorryAx|native_decide|axiom|unsafe|implemented_by|extern)\b`. Findings duplicate the audit; the value is a faster, louder failure.
- Footprint publishing: upload the audit JSON as artifact `axiom-report` (durable evidence) and upsert a sticky PR comment (HTML marker `<!-- axiom-report -->`) with a per-declaration footprint table.

## Required-check configuration

Branch protection on `main` requires contexts `gate-b` and `gate-a` exactly (job names are load-bearing; renaming a job without updating protection blocks all merges — ADR-005 trade-off).

## Acceptance criteria (PR-9)

1. A docs-only PR goes green in under a minute (detect short-circuit) with `gate-a` reported.
2. A PR adding a sorried theorem to `library/` fails `gate-a` (wfail layer) — exercised for real in the Stage-4 red-team (W3).
3. A clean library PR gets the axiom-report artifact and the sticky footprint comment.
4. Warm-cache wall time ≤ ~10 min.

Superseded runs for the same PR or `main` ref are cancelled so stale commits do
not occupy runners while a newer Gate A result is pending.
