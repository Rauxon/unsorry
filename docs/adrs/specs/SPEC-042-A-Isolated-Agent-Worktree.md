# SPEC-042-A: Isolated Per-Agent Worktree

Implements: [ADR-042](../ADR-042-Isolated-Agent-Worktree.md) · Status: Living · Updated: 2026-06-14

## Behaviour

In `swarm/agent.sh`:

- **`relocate_into_agent_worktree`** runs in `main`, right after the mode is
  validated (`--translate-only` / `--prove` selected) and **before** any
  provider/auth/model resolution, gated `if [ "$PROVE_LOCAL" -eq 0 ]`:
  - Returns immediately (no-op) when `UNSORRY_IN_WT=1` (already relocated) or
    `UNSORRY_NO_ISOLATE=1` (opted out). `--self-test` exits earlier and never
    reaches this point; `--prove-local` is excluded by the gate.
  - Otherwise: `require_unsorry_origin`; `git fetch -q origin`; resolve
    `AGENT_ID` (if unset) and `workdir` (`UNSORRY_WORKDIR`, default
    `~/.unsorry/work`); compute the worktree path
    `${UNSORRY_AGENT_WORKTREE:-$workdir/agent-main-$AGENT_ID}`;
    `mkdir -p "$workdir"`; `ensure_agent_worktree`; then `cd` into it,
    `export UNSORRY_IN_WT=1`, and
    `exec "$wt/swarm/agent.sh" "${_ORIG_ARGV[@]}"` — the worktree's (origin/main)
    `agent.sh`, with the original argv (ADR-039 re-exec semantics).
- **`ensure_agent_worktree <wt>`**: if `<wt>` exists, assert it is a worktree of
  *this* clone (`git -C <wt> rev-parse --git-common-dir` equals ours), else
  `die_config`; if absent, `git worktree prune` then
  `git worktree add -q --detach "$wt" origin/main`. (Mirrors
  `ensure_claims_worktree`'s ownership guard.)
- **`sync_repo`** in the worktree (`UNSORRY_IN_WT=1`) advances by
  `git reset --hard -q origin/main` instead of `git merge -q --ff-only
  origin/main` — re-entrant for a throwaway detached checkout. The non-isolated
  path keeps the `--ff-only` merge. Both then call `require_main_matches_origin`
  and `ensure_claims_worktree`.
- **`require_main_checkout`** returns 0 when `UNSORRY_IN_WT=1` (the worktree is a
  detached HEAD that `sync_repo` pins to origin/main); otherwise unchanged
  (must be on branch `main`).

The worktree is **stable and reused** across cycles, so its `.lake/build` and
the mathlib cache are paid once. The launch dir is never fetched, merged, reset,
built, or claimed in when isolation is active.

## Acceptance criteria

1. `relocate_into_agent_worktree` is a no-op (returns 0, no git, no exec) when
   `UNSORRY_IN_WT=1` and when `UNSORRY_NO_ISOLATE=1`.
   (Self-test `test_relocate_into_worktree_noop`.)
2. `require_main_checkout` accepts a non-`main`/detached checkout iff
   `UNSORRY_IN_WT=1`, and still rejects it otherwise (exit 2).
   (Self-test `test_require_main_checkout_isolated`.)
3. `ensure_agent_worktree` creates a detached worktree at `origin/main`, reuses
   it idempotently on a second call, and rejects (exit 2) a path that is not a
   worktree of this clone. (Self-test `test_ensure_agent_worktree`.)
4. `./swarm/agent.sh --self-test` green; `shellcheck`/`bash -n` clean.

## Operational note

The worktree lives at `$UNSORRY_WORKDIR/agent-main-<agent-id>` (override
`UNSORRY_AGENT_WORKTREE`). Reset a corrupt one with
`git worktree remove --force <path>`; stale registrations are pruned on the next
`ensure_agent_worktree`. To run in the launch dir as before (e.g. a CI runner
that should not relocate), set `UNSORRY_NO_ISOLATE=1` — the launch dir must then
be on `main` and equal to `origin/main`. Concurrent agents on one host must
carry distinct `UNSORRY_AGENT_ID`s (already required for claims).
