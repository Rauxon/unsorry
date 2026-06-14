# SPEC-039-A: Self-Updating Harness (Re-exec on agent.sh change)

Implements: [ADR-039](../ADR-039-Self-Updating-Harness.md) · Status: Living · Updated: 2026-06-14

## Behaviour

In `swarm/agent.sh`:

- **Startup (`main`)** captures, before `parse_args`:
  - `_ORIG_ARGV=("$@")` — the launch argv (re-used verbatim on re-exec; argv is
    consumed by `parse_args`, so it must be saved first).
  - `_HARNESS_SHA="$(git hash-object "${BASH_SOURCE[0]}" 2>/dev/null || echo unknown)"`
    — the content sha of the script this process is running.
- **Each cycle**, immediately after `sync_repo` (which `--ff-only`-advances the
  tree to `origin/main`) and before candidate selection / any claim:
  `maybe_reexec_on_harness_update` recomputes `git hash-object` of the script and,
  if it differs from `_HARNESS_SHA` (and the recompute succeeded), logs and
  `exec "${BASH_SOURCE[0]}" "${_ORIG_ARGV[@]}"`.
- **Decision predicate** `harness_is_stale <running-sha> <current-sha>`: true iff
  `current != "unknown"` **and** `running != current`. A git-hash failure
  (`unknown`) never re-execs — a transient git error must not restart the agent.

Only `agent.sh` is tracked: Python `tools/` are re-imported per subprocess (always
fresh), and all goal/library/proof content is read from the synced working tree.

## Acceptance criteria

1. `harness_is_stale a a` → false; `harness_is_stale a unknown` → false;
   `harness_is_stale a b` → true. (Self-test `test_harness_is_stale`.)
2. `./swarm/agent.sh --self-test` green; `shellcheck`/`bash -n` clean.
3. The re-exec call sits after `sync_repo` at the cycle top (before a claim) and
   passes the original argv; `_ORIG_ARGV` is captured before `parse_args`.

## Operational note

A re-exec is visible in the agent log as `harness updated on origin/main (<old> →
<new>) — re-exec'ing…`. Re-exec restarts the process cleanly; cycle-top state
(`HANDLED`/`SWEPT` maps) is per-run and disposable.
