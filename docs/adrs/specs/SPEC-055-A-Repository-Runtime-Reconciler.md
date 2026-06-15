# SPEC-055-A: Repository Runtime Reconciler

Implements: [ADR-055](../ADR-055-Repository-Runtime-Reconciler.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the runtime reconciler contract for repo-as-OS projects.

## 1. Responsibilities

The reconciler is responsible for:

- observing repository state,
- observing live coordination events where available,
- detecting drift between desired and observed state,
- planning safe actions,
- invoking adapters,
- enforcing claim and identity policy,
- invoking verifier policy,
- writing evidence and status,
- surfacing degraded states.

## 2. Reconcile Cycle

```text
Reconcile(input_state) -> Plan
Execute(plan) -> Effects
Verify(effects) -> Evidence
Publish(evidence) -> RepositoryTransition
```

Each cycle must have a correlation id so logs, claims, PRs, and evidence can
be connected.

## 3. State Sources

| Source | Role |
|--------|------|
| repository trunk | canonical work, policy, accepted results |
| claim substrate | live lease state |
| CI/verifier | acceptance result |
| generated status | human/operator projection |
| event bus or webhooks | live acceleration, not canonical truth |

Live events can speed up reconciliation, but the repository remains the
authoritative durable source.

## 4. Action Types

- claim work,
- release/expire claim,
- run adapter generation,
- run local verification,
- open or update PR,
- write evidence,
- refresh generated artifacts,
- pause or resume workers,
- report drift or incident.

## 5. Idempotency

Every action must be retry-safe:

- duplicate claim attempts return existing lease or conflict,
- duplicate PR creation detects an existing PR,
- duplicate evidence writes use stable ids,
- generated artifacts are deterministic,
- failed cycles can resume from repository state.

## 6. Degraded States

The reconciler must report:

- claim substrate unavailable,
- verifier unavailable,
- GitHub/API rate limited,
- runner capacity exhausted,
- evidence export failing,
- settings drift detected,
- emergency pause active.

## 7. Out of Scope

- Replacing the domain adapter.
- Replacing GitHub branch protection.
- Selecting a specific event bus or service runtime.
- Autonomous execution of work without verifier policy.
