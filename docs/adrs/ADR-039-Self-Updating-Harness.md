# ADR-039: Re-exec the Agent When the Harness Updates

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-039 |
| **Initiative** | unsorry — swarm-agent freshness |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

`swarm/agent.sh` runs an unbounded cycle (`while :`). Step 1 of each cycle is
`sync_repo`, which `git fetch`es and `git merge --ff-only origin/main`, advancing
the **working tree** to `origin/main` and asserting the checkout matches origin
(`require_main_matches_origin`). So the *files* on disk — `library/`, `goals/`,
the Python `tools/` (re-imported per subprocess, hence always current) — are
fresh each cycle.

But the running process still executes the `swarm/agent.sh` it was **launched
with**: bash parses the script's functions once at start, so a newer `agent.sh`
arriving via `sync_repo` lands on disk yet not in memory. A long-lived agent can
therefore keep running stale harness logic (an old prove flow, an old gate
shim) indefinitely while believing it is "on latest main" (#428).

## WH(Y) Decision Statement

**In the context of** a long-lived `agent.sh` cycle that `sync_repo`s the working
tree to `origin/main` every iteration,
**facing** the fact that the running bash process keeps the `agent.sh` it was
launched with — a harness update merged to `main` is on disk but never executed,
so the agent silently runs stale code (#428),
**we decided for** recording, at startup, the argv and the `git hash-object` of
the running `agent.sh`, and — at the **top of each cycle, right after
`sync_repo` and before any goal is claimed** — re-`exec`ing the script with the
original argv when its on-disk sha has changed (`maybe_reexec_on_harness_update`;
a git-hash failure yields `unknown` and never triggers a re-exec),
**and neglected** re-execing on *any* `main` advance (rejected — `main` moves on
every proof merge; only a change to `agent.sh` itself matters, since `tools/`
Python is re-imported per call), a mid-cycle re-exec (rejected — re-exec only at
the cycle top, before a claim, so no in-flight proof/PR is lost), and a
warn-only signal (rejected — the goal is to *run* the latest code, not just
notice it is stale),
**to achieve** an agent that actually executes the latest harness within one
cycle of any merge, without operator restarts,
**accepting that** the re-exec restarts the process (cheap; cycle-top state is
disposable) and that it keys only on `agent.sh` (sufficient — Python tooling and
all proof/goal content are read fresh from the synced tree each cycle).

## Consequences

- **Positive.** A merged harness fix (a new gate shim, a changed prove flow)
  reaches running agents automatically; no stale-code drift across a fleet.
- **Negative.** A cycle that coincides with a self-merging harness change does an
  extra process restart (negligible). Keys on `agent.sh` only — a future harness
  helper sourced from another shell file would need adding to the sha set.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Re-exec spec | Specification | specs/SPEC-039-A-Self-Updating-Harness.md |
| REF-2 | The cycle's repo sync | Code | `swarm/agent.sh::sync_repo` |
| REF-3 | Tracking issue | Issue | https://github.com/agenticsnz/unsorry/issues/428 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
