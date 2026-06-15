# ADR-050: Autonomous Trunk Skeleton for Reusable Agentic Work Orchestration

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-050 |
| **Initiative** | unsorry platform generalization / reusable project bootstrap |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-030 defines a domain-agnostic distributed-workload engine behind a plugin
seam. That seam separates the reusable engine concerns from Lean-specific
proof work: work-unit shape, candidate generation, verification,
decomposition, and assimilation. It deliberately rejected extracting a
separate package before a second domain proves the boundary.

Since then, the reusable part of unsorry has become clearer. The valuable
pattern is not only "a Lean proof swarm"; it is a repo-native autonomous
trunk flow:

1. keep a protected trunk as the canonical corpus,
2. publish machine-readable work units,
3. let agents claim units by lease,
4. do isolated work in short-lived branches,
5. submit one logical change per PR,
6. accept only objective machine gates,
7. auto-merge on green where the verifier is authoritative,
8. refresh generated artifacts post-merge,
9. preserve provenance, metrics, and audit evidence.

That pattern is useful outside Lean. It can coordinate many agents around any
workload with a bounded task record and a verifier: tests, contract checks,
benchmarks, screenshots, fuzzers, security scanners, formal proofs, or
risk-tiered human approvals. The Lean implementation remains the strongest
example because the Lean kernel gives a deterministic truth oracle, but the
coordination skeleton should be reusable without copying Lean-specific gate
logic or theorem vocabulary into every new project.

## WH(Y) Decision Statement

**In the context of** unsorry operating as a successful autonomous swarm where
agents and humans contribute through protected trunk, claims, short-lived PRs,
objective gates, auto-merge, post-merge generated artifacts, ADR/spec
discipline, and provenance,

**facing** the need to reuse that operating model for new projects and new
domains without forking Lean-specific assumptions, and facing the risk that
future users copy the current repository wholesale instead of understanding
which parts are generic orchestration and which parts are Lean proof policy,

**we decided for** defining an **Autonomous Trunk Skeleton**: an in-repository
template and reference contract that documents the reusable flow, required
repository settings, state-machine vocabulary, workflow lanes, trust-bearing
paths, compliance evidence hooks, and adapter boundaries; the skeleton is
extracted first as documentation plus copyable templates/specs, not as a
separate product package, and the existing Lean swarm becomes the flagship
adapter that proves the skeleton can host a high-trust VERIFIED workload,

**and neglected** extracting a standalone framework repository now (premature
until the skeleton is exercised by at least one non-Lean project), treating
GitFlow as the reusable model (rejected because long-lived integration/release
branches weaken the high-throughput agent loop), copying unsorry's Lean gates
verbatim into new projects (rejected because each domain needs its own
verifier), and hiding GitHub branch protection / secret / CODEOWNER settings
inside prose only (rejected because project bootstrap must name auditable
settings and drift checks explicitly),

**to achieve** a reusable setup path for "many agents contributing to one
cause" where a new project can adopt the trunk/claim/gate/post-merge pattern by
choosing adapters and verifier policy rather than rediscovering the
coordination model from unsorry's Lean-specific implementation,

**accepting that** the skeleton is not yet a product, that its first version is
documentation and templates rather than a polished CLI, that GitHub remains the
initial coordination and audit substrate with known scaling limits, that weak
or subjective verifiers must use SCORED, CONSENSUS, or human-approval policies
instead of pretending to be Lean-style VERIFIED workloads, and that no
refactoring may reduce the soundness guarantees of the current Lean path.

## Consequences

- **Positive.** New projects get a clear bootstrap model: protected trunk,
  task records, claims, PR taxonomy, gate policy, post-merge artifacts,
  provenance, evidence, and adapter contracts. Unsorry's generic orchestration
  can be discussed and improved independently from Lean proof policy.
- **Positive.** The template gives owner/operators a compliance-oriented view
  of the flow: what settings must exist outside git, what evidence is produced,
  what controls are trust-bearing, and where human override is allowed.
- **Negative.** The skeleton adds a second documentation layer that must stay
  honest with the running swarm. If it drifts, it becomes worse than no
  template because new projects will copy stale guarantees.
- **Negative.** GitHub as the first implementation substrate is practical but
  not infinite. Hundreds of agents will need capacity controls, queue
  sharding, API-rate handling, runner-pool awareness, and possibly a later
  coordination-service ADR.

## Initial Skeleton Boundaries

The skeleton owns the reusable orchestration contract:

- repository layout for work units, claims, evidence, generated artifacts, and
  adapter-specific outputs,
- work-unit lifecycle: `open -> claimed -> in_progress -> pr_opened -> gated
  -> merged` plus `failed -> released | demoted | decomposed`,
- claim lease semantics and reaper responsibilities,
- PR title taxonomy and one-logical-change rule,
- protected-trunk settings and trust-bearing CODEOWNER paths,
- gate categories: verifier, hygiene, supply-chain, policy, and advisory,
- post-merge generated-artifact refresh model,
- provenance and metrics requirements,
- incident/runbook and settings-drift evidence hooks,
- adapter contract aligned with ADR-030.

The skeleton does **not** own domain truth. Each adapter must define its own
verifier and acceptance policy:

- Lean adapter: deterministic kernel verification, `VERIFIED`.
- Test-suite adapter: deterministic tests, normally `VERIFIED` only when tests
  are comprehensive enough for the risk.
- Benchmark adapter: score comparison, `SCORED`.
- Human-review adapter: risk-tiered approval, not autonomous correctness.
- Consensus adapter: redundant submissions and quorum, `CONSENSUS`.

## Rollout

1. **Document first.** Land SPEC-050-A as the skeleton contract and keep it
   tied to ADR-030's plugin seam.
2. **Extract templates in-tree.** Add copyable workflow snippets, settings
   checklists, task-record examples, and adapter stubs under a future
   `templates/autonomous-trunk/` or equivalent path.
3. **Prove with one non-Lean pilot.** Bootstrap a small non-Lean workload using
   only the skeleton plus an adapter. Engine edits required by that pilot are
   evidence that ADR-030's seam is incomplete.
4. **Only then consider packaging.** A separate CLI or template repository is a
   follow-up decision after the second domain validates the boundary.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Autonomous trunk skeleton specification | Specification | specs/SPEC-050-A-Autonomous-Trunk-Skeleton.md |
| REF-2 | Domain-agnostic distributed-workload engine | Decision | ADR-030-Distributed-Workload-Engine.md |
| REF-3 | Claims on a dedicated branch | Decision | ADR-004-Claims-Branch-First-Push-Wins.md |
| REF-4 | Autonomous merge policy | Decision | ADR-005-Autonomous-Merge-Policy.md |
| REF-5 | PR convention enforcement | Decision | ADR-026-PR-Convention-Enforcement.md |
| REF-6 | Targets board post-merge refresh | Decision | ADR-036-Targets-Board-Post-Merge-Refresh.md |
| REF-7 | CI supply-chain and workflow protection | Decision | ADR-019-CI-Supply-Chain-Protection.md |
| REF-8 | Decentralised CI runner architecture | Decision | ADR-046-Decentralised-CI-Runner-Architecture.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
