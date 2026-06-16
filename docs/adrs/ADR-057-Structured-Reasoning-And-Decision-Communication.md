# ADR-057: Structured Reasoning and Decision Communication Protocol

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-057 |
| **Initiative** | unsorry agent communication and decision clarity |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-16 |
| **Status** | Proposed |

## Context

ADR-050 through ADR-056 move unsorry from a Lean-only research swarm toward a
repository-backed autonomous work platform: the trunk skeleton, experience
layer, verification tiers, volunteer-scale claims, agent identity, runtime
reconciliation, and repo-as-OS control plane.

As the system grows, a new failure mode becomes more important: unclear
reasoning. A small single-maintainer swarm can survive informal notes and long
agent transcripts. A larger system with multiple humans and many agents cannot.
It needs short, structured communication that distinguishes facts from
assumptions, separates recommendation from evidence, names risk, identifies
owners, and makes the next decision obvious.

Consulting patterns such as MECE decomposition, Pyramid Principle summaries,
issue trees, hypothesis-driven work, pre-mortems, one-page memos, decision
logs, and RACI/RAPID-style authority maps are useful here only if they are used
as lightweight reasoning protocols. They must not become corporate ceremony,
slide polish, or a substitute for deterministic verification.

## WH(Y) Decision Statement

**In the context of** unsorry becoming a multi-agent, multi-contributor,
repository-backed work system,

**facing** the risk that agent handoffs, ADRs, PR summaries, incident notes,
and operator reports become verbose, overlapping, ambiguous, or hard to audit
as participant count grows,

**we decided for** adopting a **Structured Reasoning and Decision
Communication Protocol**: humans and agents should use answer-first summaries,
explicit assumptions, MECE-style decomposition checks, issue trees,
hypothesis-driven plans, pre-mortems for high-risk changes, decision logs,
authority maps, and a "so what?" test when preparing ADRs, handoffs, PRs,
incidents, operator reports, and cross-agent coordination notes,

**and neglected** creating one ADR per business framework (rejected because the
value is the combined operating protocol), forcing rigid templates on trivial
work (rejected because communication should remain proportional to risk),
using structured language to hide uncertainty (rejected because uncertainty
must become more visible), and replacing verifier gates with persuasive
summaries (rejected because communication is not proof),

**to achieve** concise, auditable, non-overlapping decision communication that
scales from one maintainer to many contributors and agent fleets,

**accepting that** these tools can be overused, that real systems have
cross-cutting concerns that are not perfectly MECE, and that the protocol must
remain lightweight enough for agents to apply consistently.

## Protocol Elements

| Element | Purpose |
|---------|---------|
| Pyramid summary | Put the recommendation or finding first |
| MECE check | Reduce duplicate or missing categories in plans |
| Issue tree | Decompose unclear questions into answerable branches |
| Hypothesis plan | Tie work to a falsifiable claim and test |
| Pre-mortem | Surface likely failure modes before high-risk work |
| Decision log | Preserve why a choice was made and when to revisit it |
| Authority map | Clarify who recommends, decides, executes, and reviews |
| So-what test | Convert observations into implications and next actions |

## Consequences

- **Positive.** Agent handoffs become easier to scan and less dependent on
  reading full transcripts.
- **Positive.** ADRs and specs should expose decision drivers, rejected
  alternatives, risks, and validation plans more consistently.
- **Positive.** Operator reports can separate current state, risk, decision,
  and action instead of mixing them in narrative prose.
- **Positive.** Multi-agent work can assign ownership by branch of an issue
  tree or workstream, reducing duplicate effort and hidden gaps.
- **Negative.** Templates add friction if applied to very small changes.
- **Negative.** MECE-style decomposition can create false confidence if
  cross-cutting concerns are forced into artificial boxes.
- **Negative.** Polished summaries can mislead reviewers unless paired with
  evidence, links, verifier output, and explicit uncertainty.

## Guardrails

- Use the protocol as a clarity aid, not as a compliance claim.
- Keep reports proportional to risk and blast radius.
- Preserve uncertainty explicitly.
- Treat MECE as a review question, not as a law.
- Do not use persuasive summaries to bypass verifier tiers, approvals, or CI.
- Prefer one-page decision memos over long narrative reports for high-risk
  changes.
- Keep all trust-bearing claims linked to source files, PRs, logs, evidence
  packs, or verifier outputs.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Structured reasoning protocol spec | Specification | specs/SPEC-057-A-Structured-Reasoning-And-Decision-Communication.md |
| REF-2 | Autonomous Trunk Experience Layer | Decision | ADR-051-Autonomous-Trunk-Experience-Layer.md |
| REF-3 | Verification Tiers and Auditability | Decision | ADR-052-Verification-Tiers-And-Auditability.md |
| REF-4 | Repo-as-OS Control Plane | Decision | ADR-056-Repo-As-OS-Control-Plane.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-16 |
