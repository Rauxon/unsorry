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

| Backend | Suitable scale | Notes |
|---------|----------------|-------|
| Single `claims` branch | controlled swarm | Current ADR-004 behavior; simplest audit story |
| Sharded claims branches | medium fleets | Reduces branch hot-spotting but keeps git write contention |
| Lease API + durable store | volunteer fleets | Better concurrency; requires auth, uptime, evidence export |
| Append-only signed log | high auditability | Good for later reconstruction; needs compaction/read model |

The backend is an implementation detail. The contract and evidence are the
portable surface.

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
