# ADR-053: Volunteer-Scale Claim Substrate

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-053 |
| **Initiative** | unsorry volunteer-scale orchestration |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-004 chose a dedicated `claims` branch with first-push-wins semantics. That
was the right primitive for a controlled swarm: it kept coordination inside the
repository, avoided a queue service, and made claims cheap enough for the
current agent population.

ADR-050 and ADR-051 move unsorry toward a reusable autonomous trunk skeleton
that may be adopted by larger volunteer fleets. At that scale the `claims`
branch becomes the wrong write path. Hundreds of independent nodes pushing
claim commits to one branch will spend too much time fetching, rebasing, and
retrying, even when they are claiming different work units. Git remains a good
audit and merge substrate; it is not a high-throughput lease database.

The system therefore needs a claim substrate contract that preserves the
current semantics while allowing the backing implementation to evolve from a
git branch to a sharded or service-backed lease layer.

**Two dimensions, not one.** This ADR addresses claim **contention** — too many
*write-capable* nodes on one hot branch. It does **not**, on its own, solve claim
**access**: a contributor running from a **fork** has no write access to
`origin/claims` at all, and every backend enumerated in SPEC-053-A (single
branch, sharded branches, lease API, signed log) is an *upstream-write*
substrate, so a contention fix does not make a fork able to claim. The fork
onramp is handled separately and earlier by **ADR-068 (Fork-Native Contribution
Mode)**, which proves *claimless* (no pre-claim + merge-time dedup, the ADR-060
pattern) and submits via cross-repo PR — the degenerate "no-lease" point of this
contract, where the "one live owner" guarantee is satisfied by the kernel +
first-merge-wins rather than by a lease. A fork-*writable* lease (a GitHub-App
broker or an append-only claim log forks can append to) is a future backend under
this contract, justified only when measured duplicate-verifier waste warrants it
and paired with ADR-054 identity/quota.

## WH(Y) Decision Statement

**In the context of** unsorry's repository-native autonomous trunk model and
the goal of scaling from a controlled agent swarm to volunteer-scale fleets,

**facing** the fact that the current `claims` branch is elegant and auditable
but will become a write-contention bottleneck when many uncoordinated nodes
claim work concurrently,

**we decided for** defining a **pluggable claim substrate**: the repository
continues to own canonical work units and accepted results, but claim leases
move behind a contract with atomic acquire, renew, release, expire, inspect,
and evidence-export operations; the current git branch remains the default
small-swarm implementation, while volunteer-scale deployments may use sharded
git branches, a lightweight lease API, or an append-only claim log so long as
lease decisions are exported back into auditable repository evidence,

**and neglected** keeping the single git branch as the only future substrate
(rejected because push contention is predictable at volunteer scale), moving
canonical work state out of the repository (rejected because it breaks the
repo-as-OS source-of-truth model), and letting workers self-assign without an
atomic lease (rejected because duplicate work and hostile leases become
unbounded),

**to achieve** high-throughput work assignment without giving up repository
auditability,

**accepting that** a service-backed lease layer introduces operational
dependencies that ADR-004 intentionally avoided, that different deployments may
choose different backends, and that claim evidence must be carefully exported
or the live substrate becomes an invisible source of truth.

## Substrate Contract

Every implementation must provide:

- atomic claim acquisition,
- lease TTL and expiry,
- renewal with ownership proof,
- explicit release,
- work-unit and agent identifiers,
- per-agent and per-work-unit caps,
- idempotent retry behavior,
- inspect/list for operators,
- append-only event history or periodic evidence export,
- fail-closed behavior when the substrate is unavailable.

## Rollout

1. Keep the current `claims` branch as the reference implementation.
2. Define the substrate interface and evidence schema in SPEC-053-A.
3. Add metrics for claim retries, contention, stale leases, and failed pushes.
4. Pilot a sharded or API-backed substrate only when measured contention
   justifies it.
5. Export claim events back into repo evidence packs so the repository remains
   auditable.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Volunteer-scale claim substrate spec | Specification | specs/SPEC-053-A-Volunteer-Scale-Claim-Substrate.md |
| REF-2 | Claims on a dedicated branch | Decision | ADR-004-Claims-Branch-First-Push-Wins.md |
| REF-3 | Autonomous Trunk Skeleton | Decision | ADR-050-Autonomous-Trunk-Skeleton.md |
| REF-4 | Autonomous Trunk Experience Layer | Decision | ADR-051-Autonomous-Trunk-Experience-Layer.md |
| REF-5 | Verification Tiers and Auditability | Decision | ADR-052-Verification-Tiers-And-Auditability.md |
| REF-6 | Fork-Native Contribution Mode (claimless fork onramp) | Decision | ADR-068-Fork-Native-Contribution-Mode.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
