# ADR-051: Autonomous Trunk Experience Layer for Contributors, Operators, and Agent Fleets

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-051 |
| **Initiative** | unsorry platform generalization / contributor and operator experience |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Proposed |

## Context

ADR-050 defines the Autonomous Trunk Skeleton: a reusable repo-native pattern
for many agents contributing through protected trunk, claims, isolated work,
machine gates, auto-merge, post-merge generated artifacts, and evidence. That
decision captures the control model, but it does not yet make the system easy
to understand, operate, or adopt.

The current unsorry repository is powerful but dense. A maintainer can infer
the system by reading ADRs, specs, workflows, `swarm/agent.sh`, generated
boards, and issue history. That is acceptable for the original builder; it is
not enough for a wider contributor base, a new project adopting the skeleton,
or an operator supervising tens or hundreds of agents. The next constraint is
not only correctness. It is **legibility**: people and agents need to know what
to do next, why the system is blocked, which controls are authoritative, and
how to recover when automation stalls.

Unsorry therefore needs a deliberate experience layer over the skeleton. That
layer should help three audiences:

1. **Non-specialist observers** who need a plain-English picture of the swarm.
2. **Contributors** who want to run an agent, propose work, or sponsor an
   upstream without learning the whole architecture first.
3. **Operators** who manage claims, runners, secrets, gates, incidents, and
   agent capacity.

## WH(Y) Decision Statement

**In the context of** ADR-050's reusable Autonomous Trunk Skeleton and the goal
of making unsorry suitable for more contributors, more agents, and new
projects beyond Lean,

**facing** a system whose core mechanics are strong but whose operating model
is still spread across ADRs, workflow comments, scripts, generated docs, and
maintainer knowledge, making it harder for new humans and agent fleets to
onboard safely,

**we decided for** planning an **Autonomous Trunk Experience Layer**: a
documentation, diagnostics, dashboard, and guided-operations layer that makes
the skeleton understandable and operable through role-based journeys,
plain-language system maps, setup/doctor commands, operator runbooks, fleet
health views, settings-drift evidence, and contributor-safe guidance; this
layer is additive and must sit above the existing verifier/gate model rather
than weakening or hiding it,

**and neglected** adding more CI gates as the primary response (rejected
because the current gap is operator clarity, not only enforcement), turning
unsorry into a hosted service now (premature before the skeleton has multiple
adopters), replacing GitHub as the first operator surface (rejected because
GitHub remains the audit and merge substrate), and writing marketing-only
documentation without executable checks or runbooks (rejected because the
experience layer must reduce real operational ambiguity),

**to achieve** a system that remains rigorous while becoming easier to explain,
bootstrap, supervise, troubleshoot, and scale to many participants and agents,

**accepting that** this creates a product-experience backlog for what was
previously a research swarm, that dashboards and guides can drift unless backed
by generated data and checks, that not every operator task can be automated in
the first phase, and that the Lean proof path remains the soundness reference
even as the user experience becomes friendlier.

## Consequences

- **Positive.** New contributors get clear entry points instead of needing to
  read the entire ADR tree. Operators get a smaller set of trusted views and
  runbooks for day-to-day supervision.
- **Positive.** The reusable skeleton becomes easier to adopt because its
  concepts are visible as product surfaces: work queue, claims, gates,
  evidence, runners, settings, incidents, and capacity.
- **Positive.** Agentic-system builders can understand unsorry as a platform
  pattern rather than only a Lean project.
- **Negative.** The repo gains another maintained surface: docs, diagrams,
  generated evidence, diagnostics, and dashboards must remain accurate.
- **Negative.** A polished experience can create false confidence if it hides
  warnings. The design must surface uncertainty, stale data, and accepted
  risks explicitly.

## Planned Experience Surfaces

The experience layer should introduce these surfaces incrementally:

- **Concept map.** A plain-English overview and infographic-ready flow:
  backlog -> claim -> isolated work -> local verify -> PR -> gates ->
  merge -> evidence.
- **Role-based onboarding.** Separate paths for observer, contributor, agent
  operator, maintainer, and project adopter.
- **Project bootstrap guide.** A checklist for applying ADR-050 to a new
  project: required settings, workflows, adapter contract, verifier policy,
  evidence outputs, and runbooks.
- **Operator dashboard.** A generated or lightweight UI view of claims, open
  PRs, gate state, runner capacity, stale generated artifacts, blocked work,
  and recent agent outcomes.
- **Doctor/diagnostics command.** A local check that reports GitHub auth,
  branch state, required tools, secrets presence, claims branch health, runner
  assumptions, and known blockers.
- **Settings-drift report.** A periodic evidence artifact comparing documented
  GitHub settings with live settings where available.
- **Runbook index.** Concrete recovery steps for gate failures, claims branch
  corruption, missing refresh tokens, runner outages, stale artifacts, and
  suspected verifier bypass.
- **Fleet guidance.** Capacity and safety guidance for running many agents:
  per-agent identity, budgets, rate limits, worktree isolation, retry/backoff,
  and when to pause automation.
- **Narrative package.** Short non-technical descriptions and diagrams that
  explain the system without overstating what is shipped.

## Guardrails

- The experience layer must distinguish **current implementation** from
  **planned skeleton capability**.
- It must not represent subjective or weak verification as Lean-style
  deterministic correctness.
- It must surface stale data, missing secrets, disabled settings, pending
  checks, and accepted risks as first-class states.
- It must keep trust-bearing controls visible: protected trunk, required
  checks, CODEOWNER paths, workflow pins, runner configuration, and admin
  tokens.
- It must remain useful when automation is partially degraded.

## Rollout

1. **Information architecture.** Create the role-based docs and concept map.
2. **Operator runbooks.** Add the first recovery guides for the highest-risk
   incidents.
3. **Diagnostics.** Add a `doctor`/settings-audit style report before adding
   more UI.
4. **Generated status.** Produce a periodic evidence/status pack from repo and
   GitHub state.
5. **Dashboard.** Build the dashboard once the generated status model is
   stable.
6. **Template adoption guide.** Use the experience layer to bootstrap a
   non-Lean pilot of ADR-050.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Experience layer specification | Specification | specs/SPEC-051-A-Autonomous-Trunk-Experience-Layer.md |
| REF-2 | Autonomous Trunk Skeleton | Decision | ADR-050-Autonomous-Trunk-Skeleton.md |
| REF-3 | Domain-agnostic distributed-workload engine | Decision | ADR-030-Distributed-Workload-Engine.md |
| REF-4 | CI supply-chain and workflow protection | Decision | ADR-019-CI-Supply-Chain-Protection.md |
| REF-5 | Decentralised CI runner architecture | Decision | ADR-049-Decentralised-CI-Runner-Architecture.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
