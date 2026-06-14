# ADR-042: Run the Agent in an Isolated Per-Agent Worktree

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-042 |
| **Initiative** | unsorry — swarm-agent isolation |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

`swarm/agent.sh` operates on the **directory it is launched from**.
`require_main_checkout` demands that dir be on a clean `main`, and every cycle
`sync_repo` runs `git merge --ff-only origin/main` into it. Two consequences
follow from sharing the launch dir:

1. **The operator can't use the checkout while an agent runs.** An uncommitted
   harness or proof edit in the launch dir makes `merge --ff-only` fail
   (`Your local changes … would be overwritten by merge`), so the cycle dies —
   the operator cannot edit `swarm/agent.sh` or experiment with a proof in the
   same checkout an agent is driving.
2. **Two agents in one checkout race.** Both `fetch`/`merge`/operate on the same
   working tree and `.git` index; concurrent cycles interfere.

The *proof work* is already isolated — `prove`/`decompose`/`converge`/`pr`
steps and the `claims` branch each run in their own worktree under
`$UNSORRY_WORKDIR` (`~/.unsorry/work`). The gap is the **launch dir itself**: the
per-cycle sync and the `main`-checkout requirement bind the agent to the
operator's working copy.

## WH(Y) Decision Statement

**In the context of** `swarm/agent.sh` syncing and requiring `main` in the
directory it is launched from, while the operator wants to edit proofs and the
harness in that same checkout and run more than one agent per host,
**facing** the fact that a shared launch dir makes `sync_repo`'s `--ff-only`
merge fail on any uncommitted edit (killing the cycle) and makes two agents race
on one working tree,
**we decided for** relocating the agent, at startup and before any provider /
auth / model resolution, into a **dedicated per-agent worktree**
(`$UNSORRY_WORKDIR/agent-main-<agent-id>`, override `UNSORRY_AGENT_WORKTREE`) —
a detached checkout of `origin/main` created with `git worktree add --detach`
and **reused across cycles** so its `.lake`/mathlib build cache is paid once,
not per run; the agent `cd`s in and `exec`s the worktree's `agent.sh` with a
`UNSORRY_IN_WT=1` marker, after which `sync_repo` advances that worktree by
`git reset --hard origin/main` (re-entrant, like the claims worktree) and
`require_main_checkout` accepts the detached HEAD (the real invariant,
HEAD == origin/main, is still enforced by `require_main_matches_origin`),
**and neglected** a fresh worktree per run (rejected — every run would repay the
~10-min cold `.lake`/mathlib cache we measured; a stable reused worktree pays it
once), checking out the literal `main` branch in the worktree (rejected — git
forbids the same branch in two worktrees, so the operator's `main` and a second
agent would both collide; a detached HEAD has no such limit), and making
isolation opt-in (rejected — the operator's stated need is to *always* be able
to work alongside agents, so isolation is the default with `UNSORRY_NO_ISOLATE=1`
to run in place),
**to achieve** an agent whose every git/build/claim action happens in its own
tree — the operator edits the launch dir freely and runs several agents per host
without interference,
**accepting that** each agent worktree carries its own `.lake/build` (disk per
agent; the mathlib olean cache is still shared via Lake's global cache), that —
like the ADR-039 re-exec — the agent runs `origin/main`'s `agent.sh` rather than
the operator's working copy (correct: the swarm loop must act on merged code;
`--prove-local` remains the in-place path for testing a working copy), and that
concurrent same-host agents must carry distinct identities (already required —
`UNSORRY_AGENT_ID`; sharing an id collides on claims regardless).

## Consequences

- **Positive.** The operator can edit the harness and proofs, and run
  `--prove-local`, in the launch dir while agents run; multiple agents per host
  no longer share a working tree; a stale/dirty worktree self-heals each cycle
  via `reset --hard` (matching the claims-worktree re-entrancy bar).
- **Negative.** Disk cost of one `.lake/build` per agent worktree. A stale
  `git worktree` registration is pruned on the next `ensure_agent_worktree`;
  a corrupt worktree is reset with `git worktree remove --force <path>` (no
  dedicated flag — kept out of scope). CI/remote runners now relocate too; set
  `UNSORRY_NO_ISOLATE=1` where running in place is wanted.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Isolation spec | Specification | specs/SPEC-042-A-Isolated-Agent-Worktree.md |
| REF-2 | The cycle's repo sync | Code | `swarm/agent.sh::sync_repo` |
| REF-3 | Relocation | Code | `swarm/agent.sh::relocate_into_agent_worktree` |
| REF-4 | Re-exec on harness update | ADR | ADR-039-Self-Updating-Harness.md |
| REF-5 | Claims live off main, in their own worktree | ADR | ADR-004 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
