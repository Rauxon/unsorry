# SPEC-056-A: Repo-as-OS Control Plane and Operator Interface

Implements: [ADR-056](../ADR-056-Repo-As-OS-Control-Plane.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the first control-plane contract for a repository-backed
autonomous work system.

## 1. Design Principles

- The repository is canonical.
- The interface is a projection, not a source of truth.
- Every mutating action must produce a recorded transition or evidence event.
- Degraded state must be visible.
- High-risk actions require identity policy and approval.
- Generated views must be reproducible from source state where possible.

## 2. Views

The control plane should provide:

- work queue by state,
- live claims by agent and work unit,
- PRs by title class and verifier tier,
- verifier health,
- runner capacity,
- generated-artifact drift,
- evidence pack status,
- open incidents,
- trust-bearing settings drift,
- agent quota and reputation summary.

## 3. Intent Actions

```text
pause_claims(scope, reason)
resume_claims(scope, reason)
approve(work_unit_or_pr, approver, reason)
request_refresh(artifact)
open_incident(type, summary)
export_evidence(range)
revoke_or_pause_agent(agent_id, reason)
```

The control plane must not execute these as hidden local mutations. Each action
must map to a PR, approval record, claim-substrate event, or evidence record.

## 4. Presentation Options

Valid first implementations:

- generated Markdown status pages,
- JSON evidence/state files,
- a static dashboard reading generated JSON,
- a CLI status command,
- a lightweight web console.

A hosted service is optional and out of scope for the first implementation.

## 5. Safety States

The UI must represent:

- green / normal,
- pending,
- degraded,
- paused,
- blocked,
- approval required,
- consensus pending,
- settings drift,
- incident active.

Unknown state must not be displayed as healthy.

## 6. Audit Requirements

Operator actions must record:

- actor,
- time,
- intent,
- affected work/agent/resource,
- reason,
- evidence references,
- resulting repository transition or live event id.

## 7. Out of Scope

- Replacing GitHub.
- Running arbitrary shell commands from the UI.
- Full infrastructure provisioning.
- Compliance certification.
- General-purpose personal operating-system replacement.
