# ADR-019: CI Supply-Chain & Workflow Protection

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-019 |
| **Initiative** | unsorry Phase 3 — soundness hardening (issue #190) |
| **Proposed By** | unsorry maintainers (findings: external review, issue #190) |
| **Date** | 2026-06-12 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a repository whose whole trust story is "two CI gates, no human review", which makes the gates' own execution environment — the workflow files, the audit tooling, and the third-party actions they invoke — part of the trusted computing base,
**facing** issue #190's remaining findings: HIGH, a same-repo PR runs the *PR head's* copy of `gate-a.yml` and can neuter it (`continue-on-error`, dropped steps) with no ownership over `.github/workflows/`, `tools/gate_a/`, or `AxiomAudit/`; MEDIUM, third-party actions referenced by mutable tags (`@v1`, `@v4`) are a supply-chain surface (a compromised tag rewrites the gate's runtime); LOW, the audit's acceptance corpus never covers `opaque` declarations,
**we decided for** a three-part hardening: (1) **every action pinned to a commit SHA** (`@<sha> # vX.Y.Z`) at the latest stable release of its current major, across all five workflows; (2) **CODEOWNERS** over the trust-bearing paths (`.github/`, `tools/gate_a/`, `tools/gate_b/`, `AxiomAudit/`, `AuditFixtures/`, `swarm/`, lakefile, toolchain) plus `docs/security-checklist.md` recording the repository *settings* half (require-codeowner-review, force-push blocks, tag protection) with the honest solo-maintainer trade-off and the explicit recommendation to flip the review requirement **before** opening to untrusted contributors; and (3) an **`Opaque.lean` fixture** pinning that `opaque` constants (sound — the kernel demands an `Inhabited` witness) neither trip nor crash the audit,
**and neglected** bumping actions across majors while hardening (a behaviour change is the wrong passenger on a security PR; §11 currency is satisfied at the latest stable of each major in use), an in-repo workflow-hash self-check (a PR that can edit the workflow can edit the self-check — only platform settings sit outside the PR's reach), and enabling require-codeowner-review immediately (GitHub does not count self-approval, so under the current solo flow it blocks the maintainer's own tooling PRs for zero adversary benefit today),
**to achieve** a gate runtime that cannot be silently swapped from inside a PR or from a compromised upstream tag, with the residual platform-settings work visible as a checklist instead of assumed,
**accepting that** pinned SHAs need periodic manual refresh (the comment carries the version for auditability), CODEOWNERS is inert until the corresponding setting is enabled (recorded, with the enablement condition stated), and the settings half remains unverifiable from the tree.

## Context

Completes the #190 fixes alongside ADR-018. The review's framing is kept: the HIGH item is a *deployment configuration* gap, not a code defect — so its fix is split honestly into what git can carry (CODEOWNERS, pins) and what only the repository admin can flip (the checklist).

## Options Considered

### Option 1: SHA pins + CODEOWNERS + settings checklist + corpus fixture (Selected)
**Pros:** everything reviewable is in-tree; the unreviewable remainder is named, owned, and dated; zero behaviour change to the swarm's auto-merge flow.
**Cons:** checklist discipline required; pins go stale without refresh.

### Option 2: Move the gates to `pull_request_target` so PRs run the base ref's workflow (Rejected)
Closes the neuter vector but hands the PR head's code a token with write scope — a worse hole than the one closed (the pr-labels workflow uses it safely only because it never executes PR-head code).

### Option 3: Required-review on everything (Rejected)
Kills the project's premise (autonomous merge on gate-green). Ownership is scoped to the trusted computing base precisely so the swarm's surfaces stay autonomous.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Relates To | ADR-018 | Goal-Statement Immutability | The other #190 fix; this ADR protects the layer that runs it |
| Amends | ADR-006 | Gate A Soundness Enforcement | The gate's runtime joins the trusted computing base explicitly |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-019-A — Supply-chain hardening | Specification | specs/SPEC-019-A-CI-Supply-Chain-Protection.md |
| REF-2 | External review | Issue | https://github.com/agenticsnz/unsorry/issues/190 |
| REF-3 | Settings checklist | Documentation | ../security-checklist.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-12 |
| Accepted | unsorry maintainers | 2026-06-12 |
