# ADR-055: Repository Runtime Reconciler

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-055 |
| **Initiative** | unsorry repo-as-OS runtime model |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-050 makes the repository the symbolic substrate for autonomous work:
work units, claims, protocols, evidence, and accepted results live in git.
ADR-051 plans the operator experience, ADR-052 defines verifier policy, and
ADR-053/054 plan volunteer-scale coordination and identity.

The next missing piece is the runtime loop. Today the repo is reconciled by a
mix of GitHub Actions, agent scripts, reapers, generated-artifact refreshers,
and human intervention. That works, but it is not yet named as a coherent
component. In a repo-as-OS architecture, something must observe symbolic state,
derive required actions, execute those actions through adapters, and write
evidence back.

That component is the repository runtime reconciler.

## WH(Y) Decision Statement

**In the context of** unsorry treating repository state as the canonical
symbolic world for autonomous work,

**facing** a fragmented runtime where multiple scripts and workflows reconcile
pieces of state without a single contract for observe/plan/apply/verify/evidence,

**we decided for** defining a **Repository Runtime Reconciler**: an idempotent
runtime role that watches repository state and live coordination events,
computes desired actions, invokes domain adapters and infrastructure actions,
checks verifier policy, and writes outcomes back as PRs, commits, generated
status, or evidence records; the reconciler may be implemented by GitHub
Actions, local workers, scheduled jobs, or future services, but it must obey
the same contract and must not bypass protected-trunk or verifier gates,

**and neglected** treating every workflow as a one-off script forever
(rejected because operators need a common mental model), letting the reconciler
commit arbitrary changes directly to trunk (rejected because protected trunk
and gates remain authoritative), and making the reconciler a hidden service
whose state is not reflected in the repository (rejected because it breaks
auditability),

**to achieve** a clear runtime model for repo-as-OS projects where symbolic
state is continuously reconciled into verified repository transitions,

**accepting that** the first implementation remains distributed across
existing scripts and workflows, and that this ADR names the contract before a
single binary or service exists.

## Reconciler Loop

```text
observe repository + live events
-> plan state transitions
-> acquire lease / authority
-> execute adapter action
-> verify according to ADR-052
-> submit PR or evidence
-> update generated status
-> repeat
```

All steps must be safe to retry.

## Safety Rules

- The reconciler must not treat local state as canonical.
- It must not bypass verifier gates.
- It must write durable evidence for externally visible actions.
- It must expose degraded state when it cannot reconcile.
- It must keep human emergency pause paths available.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Repository runtime reconciler spec | Specification | specs/SPEC-055-A-Repository-Runtime-Reconciler.md |
| REF-2 | Autonomous Trunk Skeleton | Decision | ADR-050-Autonomous-Trunk-Skeleton.md |
| REF-3 | Autonomous Trunk Experience Layer | Decision | ADR-051-Autonomous-Trunk-Experience-Layer.md |
| REF-4 | Verification Tiers and Auditability | Decision | ADR-052-Verification-Tiers-And-Auditability.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
