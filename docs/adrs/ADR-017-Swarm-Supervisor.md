# ADR-017: Swarm Supervisor and In-Flight-Work Guard

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-017 |
| **Initiative** | unsorry Phase 3 — operational resilience |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-11 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** an agent loop that is deliberately fail-fast — it exits 3 on infrastructure failure (ADR-016) and exits 0 on an empty pool even while the tree is still in flight (open PRs awaiting gates, blocked parents awaiting the unblock sweep) — leaving "keep the tree moving" to a human-attended orchestrator,
**facing** a day of production incidents in which (a) every outage required a human to notice, diagnose, and relaunch; (b) an agent re-claimed a goal whose prove PR was already open (the claim is released at PR-open, so the claims branch cannot see in-flight work), producing the #168 demote that silently conflicted the real proof PR #166 — and a conflicted PR gets **no** CI runs, so its armed auto-merge waits forever without a single red signal; and (c) a claim-race window let two agents prove the same leaf and open duplicate PRs (#184/#185),
**we decided for** a supervisor wrapper (`swarm/supervise.sh`) owning the retry loop — exponential backoff on infra exits (300s ×2 capped 3600s), short retry on cycle failures, in-flight waits on empty-pool-with-open-scope, terminating only when the scoped goal tree is fully proved — plus scope-limited PR hygiene on every wait (close duplicate prove PRs keeping the oldest; loudly flag CONFLICTING PRs), plus an agent-side claim guard that skips any candidate with an open prove PR,
**and neglected** auto-resolving conflicted PRs (goal-record conflicts can need semantic judgement — the supervisor shouts, the maintainer resolves), fixing the claim-race window itself (the interleave is not yet reproducible; the PR-level dedupe bounds its cost to one redundant run), and moving supervision into CI cron (the supervisor needs the local clones, caches, and claude CLI),
**to achieve** a swarm where one command drives a goal tree to closure across quota outages, merge latency, and queue races — outages cost wall-clock, not maintainer attention,
**accepting that** the supervisor adds a second script to keep shellcheck-clean and self-tested, PR hygiene depends on best-effort `gh` calls (it degrades to logging when the API is down), and the claim guard spends one API call per candidate per pass.

## Context

Builds directly on ADR-016: the agent now *stops cleanly* on infrastructure failure; this ADR makes something *restart it intelligently*. The supervisor's whole policy is a pure function (`next_action`) and the tree-closure test (`scope_closed`) reads only goal records — both hermetically tested. The duplicate-PR closer encodes exactly the #184/#185 resolution a maintainer performed by hand.

## Options Considered

### Option 1: Local supervisor script + claim guard + PR hygiene (Selected)
**Pros:** one command to closure; policy pure and testable; uses existing local environment; hygiene encodes proven manual fixes.
**Cons:** still a local process (dies with the machine — the orchestrator restarts it, but that is one level up, not zero).

### Option 2: CI-cron supervision (Rejected)
A scheduled workflow that relaunches agents. Rejected: CI runners have neither the mathlib caches, the clones, nor the claude CLI session; granting them all three rebuilds the local environment in a worse place.

### Option 3: Make the agent loop itself retry forever (Rejected)
Fold backoff into agent.sh. Rejected: fail-fast agents are the ADR-016 design — a sleeping agent holds claims and is indistinguishable from a hang; separating loop policy (supervisor) from cycle mechanics (agent) keeps both testable.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Depends On | ADR-016 | Infrastructure-Failure Guard | Exit 3 is the supervisor's backoff signal |
| Amends | ADR-007 | Agent Identity and Budgets | Selection skips goals with open prove PRs |
| Relates To | ADR-004 | Claims Branch | Claim release at PR-open is why the guard is needed |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-017-A — Supervisor and in-flight guard | Specification | specs/SPEC-017-A-Swarm-Supervisor.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-11 |
| Accepted | unsorry maintainers | 2026-06-11 |
