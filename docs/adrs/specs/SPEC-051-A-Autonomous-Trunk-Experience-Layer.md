# SPEC-051-A: Autonomous Trunk Experience Layer

Implements: [ADR-051](../ADR-051-Autonomous-Trunk-Experience-Layer.md) | Status: Proposed | Updated: 2026-06-15

This spec plans the user, contributor, and operator experience layer for the
Autonomous Trunk Skeleton defined in ADR-050. It is a planning spec: it names
the surfaces and acceptance criteria before implementation begins.

## 1. Goals

The experience layer exists to make an autonomous trunk project:

- understandable to non-specialist observers,
- safe for new contributors,
- operable by maintainers who did not write the original system,
- scalable to more agents without relying on private maintainer knowledge,
- reusable by new projects adopting ADR-050.

It does not replace the verifier, gate model, or GitHub audit trail.

## 2. Audiences

| Audience | Needs |
|----------|-------|
| Observer | Understand what the system does and why it is safe enough to trust |
| Contributor | Propose work, run one agent, or open a safe PR |
| Agent operator | Launch, monitor, pause, and recover one or more agents |
| Maintainer | Manage trust-bearing settings, runners, gates, incidents, and releases |
| Project adopter | Instantiate the skeleton with a different verifier adapter |
| Auditor | See evidence for settings, changes, risks, and controls |

Each surface should identify which audience it serves.

## 3. Information Architecture

The first documentation layer SHOULD have:

```text
docs/
  overview.md                  # plain-English system explanation
  operating-model.md           # trunk, claims, gates, evidence
  roles/
    observer.md
    contributor.md
    operator.md
    maintainer.md
    adopter.md
  operations/
    runbooks.md
    incidents/
  compliance/
    settings-checklist.md
    evidence-pack.md
    risk-register.md
  diagrams/
    autonomous-trunk-flow.md
```

Existing docs may satisfy these paths if they are reorganized instead of
duplicated. The point is navigability, not a mandatory directory name.

## 4. Concept Map

The concept map MUST explain these terms in plain language:

- work unit,
- claim / lease,
- agent identity,
- isolated worktree,
- local verification,
- pull request,
- verifier gate,
- hygiene gate,
- protected trunk,
- auto-merge,
- post-merge artifact refresh,
- provenance / evidence,
- decomposition / demotion / release.

It SHOULD include an infographic-ready flow:

```text
Backlog -> Claim -> Isolated work -> Verify -> PR -> Gates -> Merge -> Evidence
                         |                                  |
                         +---------- fail ------------------+
                                      |
                         Release / Demote / Decompose
```

## 5. Role-Based Journeys

### 5.1 Observer

Must answer:

- What is unsorry?
- What is an autonomous trunk project?
- Why are agents allowed to contribute?
- What checks decide whether work is accepted?
- What is current progress?

### 5.2 Contributor

Must provide:

- prerequisites,
- one-command local sanity check,
- how to choose or propose work,
- how to run one safe local attempt,
- how to open a PR,
- what title/branch conventions are required,
- what to do when checks fail.

### 5.3 Agent Operator

Must provide:

- how to configure identity,
- how to run one agent vs a fleet,
- recommended budgets and rate limits,
- how to avoid duplicate identities,
- how to pause and resume safely,
- how to inspect claims and open PRs,
- how to recover stale worktrees and claims.

### 5.4 Maintainer

Must provide:

- required GitHub settings,
- trust-bearing paths,
- runner pool assumptions,
- secret/token ownership and rotation notes,
- required checks,
- emergency bypass policy,
- incident runbook index.

### 5.5 Project Adopter

Must provide:

- how to choose a verifier tier,
- how to write an adapter,
- how to define work units,
- which workflows to copy,
- which settings to enable,
- how to produce evidence,
- what not to claim until verified.

## 6. Diagnostics Command

A future `doctor` command or script SHOULD report:

- current branch and dirty state,
- local vs origin freshness,
- GitHub authentication and active account,
- required tools and versions,
- Lean/toolchain status for the Lean adapter,
- claims branch availability,
- agent identity uniqueness hints,
- expected required checks,
- presence of configured secrets by name only where accessible,
- known runner profile assumptions,
- common failure explanations.

The command MUST avoid printing secret values.

## 7. Dashboard / Generated Status

Before building a UI, the project SHOULD define a generated status model with:

- open work units by state,
- live claims and stale claims,
- open PRs by title class,
- pending/failing checks,
- recent merged contributions,
- generated-artifact drift,
- runner capacity and queue pressure where available,
- recent failed/decomposed/demoted attempts,
- accepted risks and disabled settings.

The first implementation MAY be Markdown/JSON committed under `docs/metrics/`.
A richer web dashboard is a later presentation layer over the same data.

## 8. Runbooks

The first runbook set SHOULD cover:

1. Gate A failing for all PRs.
2. Gate B or protocol validation failing.
3. Claims branch corruption or force-push.
4. Stale or missing `REFRESH_TOKEN`.
5. Generated artifacts remain stale.
6. Runner outage or capacity exhaustion.
7. Suspected workflow/gate bypass attempt.
8. Bad merge or verifier false positive suspected.
9. Agent identity collision.
10. Too many agents creating PR or API pressure.

Each runbook SHOULD include symptoms, immediate action, recovery steps,
evidence to preserve, and follow-up ADR/spec updates if policy changes.

## 9. Scale Guidance

Fleet guidance MUST state that hundreds of agents require explicit controls:

- per-agent identity,
- per-agent and global budgets,
- per-work-unit claim caps,
- runner-pool capacity awareness,
- API rate-limit backoff,
- branch and PR cleanup,
- retry jitter,
- queue sharding if claim contention rises,
- human pause switch for incident response.

The docs MUST make clear which controls are implemented today and which are
planned.

## 10. Compliance and Evidence

The experience layer SHOULD produce an evidence pack suitable for an ISMS owner:

- branch protection / required checks snapshot,
- CODEOWNER and trust-bearing path summary,
- workflow pinning status,
- recent merged PRs and gate outcomes,
- open risks / accepted exceptions,
- settings drift report,
- secret rotation metadata without values,
- incident and runbook updates.

This evidence supports auditability but does not itself certify ISO/IEC 27001
or any other standard.

## 11. Acceptance Criteria

ADR-051 is ready to move beyond planning when:

1. A new contributor can run one safe local attempt using docs alone.
2. A maintainer can identify all required GitHub settings from one page.
3. An operator can see or generate current claim/PR/gate health.
4. At least five high-risk incident runbooks exist.
5. The docs distinguish shipped behavior from planned behavior.
6. A non-Lean project adopter can understand the skeleton without reading all
   Lean-specific ADRs.

## 12. Out of Scope

- Replacing GitHub as the first merge/audit substrate.
- Building a hosted SaaS control plane.
- Changing Gate A soundness policy.
- Making subjective work auto-merge as if it were deterministically verified.
- Full ISO/IEC 27001 certification.
