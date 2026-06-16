# SPEC-057-A: Structured Reasoning and Decision Communication Protocol

Implements: [ADR-057](../ADR-057-Structured-Reasoning-And-Decision-Communication.md) | Status: Proposed | Updated: 2026-06-16

This spec defines the first lightweight communication protocol for unsorry
agents, maintainers, contributors, and operators.

## 1. Purpose

The protocol gives humans and agents a shared way to communicate decisions,
plans, risks, handoffs, and operator state without relying on long transcripts
or informal maintainer memory.

The protocol is not a replacement for Lean verification, CI, approvals, or
audit evidence. It is a structure for making reasoning reviewable.

## 2. General Rules

- Start with the answer, recommendation, or current state.
- Separate facts, assumptions, decisions, risks, and open questions.
- Use decomposition to find gaps and overlaps, not to create artificial
  certainty.
- Make uncertainty explicit.
- Link evidence for trust-bearing claims.
- End with the implication and next action.
- Keep the format proportional to risk.

## 3. Agent Handoff Template

Agents SHOULD use this shape when handing work to another agent or human:

```text
Summary:
Decision or recommendation:
Evidence:
Changes made:
Risks:
Open questions:
Next action:
```

For trivial work, the same fields MAY be collapsed into a short paragraph.

## 4. ADR Proposal Memo Template

High-risk or platform-level ADRs SHOULD be preceded by a one-page memo:

```text
Recommendation:
Context:
Hypothesis:
Options considered:
Decision drivers:
Rejected alternatives:
Risks:
Validation plan:
Review trigger:
```

The memo may become the ADR context and decision-driver material.

## 5. Issue Tree Template

Use an issue tree when a question is broad, ambiguous, or likely to split
across multiple agents.

```text
Root question:
- Branch:
  - Sub-question:
  - Evidence needed:
  - Owner:
- Branch:
  - Sub-question:
  - Evidence needed:
  - Owner:
```

Branches SHOULD be as non-overlapping as practical. Cross-cutting concerns
such as security, compliance support, cost, or user experience may be tracked
as separate review lenses rather than forced into one branch.

## 6. Hypothesis-Driven Work Template

Use a hypothesis template when work depends on an uncertain claim.

```text
Hypothesis:
Why it matters:
Test:
Pass/fail threshold:
Decision if true:
Decision if false:
```

Examples:

- "A local doctor command will reduce setup failures."
- "A claim substrate outside Git is required before volunteer-scale agents."
- "A generated evidence pack is enough for first-pass auditability support."

## 7. Pre-Mortem Template

High-risk roadmap items, verifier changes, identity changes, claim substrate
changes, and control-plane actions SHOULD include a pre-mortem.

```text
If this failed six months after launch, why?
Failure mode:
Signal:
Mitigation:
Owner:
Review date:
```

The pre-mortem is meant to expose likely failure paths before implementation,
not to block all risk.

## 8. Decision Log Template

Use a decision log when an operator, maintainer, or agent makes a meaningful
choice outside a full ADR.

```text
Decision:
Owner:
Date:
Context:
Alternatives rejected:
Evidence:
Impact:
Review trigger:
```

Decision logs SHOULD be linked from PRs, incidents, generated evidence packs,
or ADR follow-up specs when the decision affects platform behavior.

## 9. Authority Mapping

Use a small authority map when work has multiple humans or agents.

```text
Decision:
Recommend:
Agree:
Perform:
Input:
Decide:
Informed:
```

For simpler work, RACI terms are acceptable:

```text
Responsible:
Accountable:
Consulted:
Informed:
```

Authority maps do not grant permission to bypass repository protections,
CODEOWNERS, verifier tiers, or approval gates.

## 10. So-What Test

Every non-trivial report SHOULD include the implication of its findings.

```text
Finding:
So what:
Action:
Owner:
```

Reports that only list observations without an implication or action are
considered incomplete unless the report is explicitly exploratory.

## 11. When To Use This Protocol

Use the protocol for:

- ADRs and ADR planning,
- PR summaries that change platform behavior,
- multi-agent handoffs,
- incident records,
- operator status reports,
- audit and compliance-support evidence packs,
- roadmap proposals,
- high-risk verifier, identity, claim, or reconciler changes.

Do not require the full protocol for:

- typo fixes,
- generated leaderboard refreshes,
- small deterministic documentation edits,
- routine dependency-free proof additions with standard verifier coverage.

## 12. Anti-Patterns

- Long reports with no recommendation.
- Hiding assumptions inside confident prose.
- Treating MECE decomposition as proof that the plan is complete.
- Assigning the same ownership to every branch of an issue tree.
- Using an authority map to override verifier policy.
- Creating polished summaries that are not backed by source links or evidence.
- Turning every small change into a consulting exercise.

## 13. Acceptance Criteria

ADR-057 is ready to move from planning to implementation when:

- a handoff template exists for agents and maintainers,
- high-risk ADRs include rejected alternatives, risks, and validation plans,
- multi-agent work can assign issue-tree branches to owners,
- operator reports include current state, risk, implication, and next action,
- evidence packs can link decision logs or pre-mortems where relevant,
- the protocol can be used without changing verifier semantics.

## 14. Out of Scope

- Formal compliance certification.
- Replacing ADRs.
- Replacing Lean verification or CI.
- Mandatory full-length templates for trivial work.
- General management-process adoption outside repository-backed autonomous
  work.
