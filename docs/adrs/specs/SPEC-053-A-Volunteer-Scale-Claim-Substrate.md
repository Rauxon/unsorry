# SPEC-053-A: Volunteer-Scale Claim Substrate

Implements: [ADR-053](../ADR-053-Volunteer-Scale-Claim-Substrate.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the claim/lease contract for volunteer-scale autonomous
trunk projects. It preserves ADR-004 semantics while allowing implementations
other than a single git branch.

## 1. Goals

- Preserve one live owner per constrained claim slot.
- Avoid duplicate work where policy says only one worker should proceed.
- Scale lease acquisition beyond one hot git branch.
- Keep canonical work state and accepted results in the repository.
- Export claim evidence for audit and incident review.

## 2. Required Operations

```text
acquire(work_unit_id, agent_id, ttl, metadata) -> Lease | Conflict | Denied
renew(lease_id, agent_id, ttl) -> Lease | Expired | Denied
release(lease_id, agent_id, reason) -> Released | Denied
expire(now) -> [ExpiredLease]
inspect(work_unit_id) -> LeaseState
list(filter) -> [LeaseState]
export_events(range) -> ClaimEventBatch
```

All operations must be idempotent where a caller may retry after a timeout.

## 3. Lease Record

```text
Lease {
  lease_id
  work_unit_id
  agent_id
  acquired_at
  expires_at
  generation
  substrate
  metadata
}
```

`generation` increments on successful renewal and prevents stale release or
renew operations from overwriting newer state.

## 4. Event Record

```text
ClaimEvent {
  schema_version
  event_id
  event_type        # acquired | renewed | released | expired | denied
  lease_id
  work_unit_id
  agent_id
  occurred_at
  substrate
  reason
  metadata_hash
}
```

Events should be append-only. If a live service is used, periodic event batches
must be exported into repository evidence.

## 5. Backends

| Backend | Suitable scale | Write access | Notes |
|---------|----------------|--------------|-------|
| **Claimless + merge-time dedup** | forks / Tier 0 | none (read-only) | No lease; the degenerate point of this contract. `acquire` always succeeds; "one live owner" is enforced by the upstream kernel + first-merge-wins, not by a lease. The **fork onramp** (ADR-068 / SPEC-068-A): a fork that cannot write `origin/claims` proves claimless and submits by cross-repo PR. Cost: duplicate verifier work, never soundness. |
| Single `claims` branch | controlled swarm | upstream write | Current ADR-004 behavior; simplest audit story |
| Sharded claims branches | medium fleets | upstream write | Reduces branch hot-spotting but keeps git write contention |
| Lease API + durable store | volunteer fleets | broker-mediated | Better concurrency; requires auth, uptime, evidence export. A **fork-writable** broker (GitHub App / token-scoped endpoint) is what lets forks *claim* rather than go claimless — a Phase-2 backend, paired with ADR-054 identity/quota. |
| Append-only signed log | high auditability | fork-appendable | Forks can append claim events (e.g. via PR / API) for later reconstruction; needs compaction/read model |

The backend is an implementation detail. The contract and evidence are the
portable surface. **Access vs contention:** the upstream-write backends solve
*contention*; the claimless and fork-writable rows solve *access* for
contributors with no upstream write (ADR-068 ships the claimless row now; the
fork-writable lease is justified only when measured duplicate-verifier waste
warrants it).

## 6. Failure Behavior

- If lease acquisition is unavailable, workers must not start new claimed work.
- If renewal fails, workers must stop before submitting results unless policy
  allows best-effort completion.
- If evidence export fails, operators must see degraded auditability.
- If the substrate forks or loses state, repository evidence and accepted
  results remain canonical; live leases can be discarded and rebuilt.

## 7. Metrics

Implementations should report:

- claim attempts,
- conflicts,
- denied claims,
- acquisition latency,
- renewals,
- expirations,
- stale leases,
- backend errors,
- per-agent live leases,
- per-work-unit contention.

## 8. Out of Scope

- Agent identity and reputation policy.
- Verification tier policy.
- Replacing GitHub as merge authority.
- Defining a hosted claim service implementation.
