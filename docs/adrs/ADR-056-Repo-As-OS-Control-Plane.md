# ADR-056: Repo-as-OS Control Plane and Operator Interface

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-056 |
| **Initiative** | unsorry repo-as-OS operator interface |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-050 through ADR-055 describe a repo-as-OS architecture for autonomous
work: the repository stores symbolic state, agents transform it, verifier
tiers govern acceptance, claims/identity manage scale, and a reconciler applies
runtime actions. What remains is the human-facing control plane.

If the repository is the symbolic operating system, the operator interface must
not be a pile of disconnected scripts. It should expose the repository's state
as a coherent control surface: what work exists, what is claimed, what agents
are doing, what gates are blocked, what risks are accepted, what evidence
exists, and which actions are safe.

The control plane should let humans express intent and supervise automation
without making them manually reconstruct state from shell commands, workflow
logs, and branch history.

## WH(Y) Decision Statement

**In the context of** unsorry evolving toward a repository-backed operating
model for autonomous work,

**facing** the need for contributors and operators to understand and steer the
system without becoming accidental system administrators of every underlying
workflow, runner, lease, and verifier,

**we decided for** planning a **Repo-as-OS Control Plane**: a role-based
operator interface that projects repository state, live reconciler state,
claims, agents, verification tiers, evidence, incidents, and settings drift
into one coherent view; operators may express high-level intent such as pause
volunteer claims, inspect blocked work, approve an `APPROVAL` tier change, or
refresh stale artifacts, but every meaningful action must resolve into a
recorded repository transition, approval, or evidence event,

**and neglected** making the control plane the source of truth (rejected
because the repository remains canonical), hiding unsafe or degraded states
behind a polished dashboard (rejected because operators need honest status),
and exposing raw shell/procedure as the primary interface (rejected because the
goal is symbolic management),

**to achieve** a modern operator experience where the repository is the
semantic OS and the interface is a projection plus intent surface over that
state,

**accepting that** the first version may be generated Markdown/JSON and a
lightweight dashboard rather than a full interactive product, and that control
plane actions must be limited until identity, quotas, and reconciler policies
are implemented.

## Control Plane Layers

| Layer | Purpose |
|-------|---------|
| Repository state | Canonical symbolic world |
| Reconciler state | Current runtime actions and degraded states |
| Evidence state | Verifier outcomes, approvals, consensus, risks |
| Operator actions | Safe intents that become recorded transitions |
| Presentation | Dashboard, docs, CLI, or generated reports |

## Initial Operator Actions

- pause or resume volunteer claiming,
- inspect live claims and stale leases,
- inspect open PRs by verifier tier,
- view blocked work and failure reasons,
- view settings drift and trust-bearing warnings,
- record approval for `APPROVAL` tier work,
- trigger deterministic generated-artifact refresh,
- open an incident record,
- export an evidence pack.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Repo-as-OS control plane spec | Specification | specs/SPEC-056-A-Repo-As-OS-Control-Plane.md |
| REF-2 | Autonomous Trunk Experience Layer | Decision | ADR-051-Autonomous-Trunk-Experience-Layer.md |
| REF-3 | Repository Runtime Reconciler | Decision | ADR-055-Repository-Runtime-Reconciler.md |
| REF-4 | Agent Identity, Quotas, and Reputation | Decision | ADR-054-Agent-Identity-Quotas-And-Reputation.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
