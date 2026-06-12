# Security checklist — repository settings (ADR-019)

The in-tree half of the #190 hardening (pinned actions, CODEOWNERS, the
ADR-018 statement pin, the audit corpus) lives in git and is reviewable.
This page is the **other half**: GitHub settings that are invisible from the
tree, so they are documented here and must be checked rather than assumed.
Owner: the repository admin (@cgbarlow).

## The threat these settings close (#190 HIGH)

`pull_request` workflows run the **PR head's** copy of the workflow file: a
same-repo PR can edit `gate-a.yml` itself (add `continue-on-error`, drop the
audit step) and then auto-merge on its own neutered gate. CODEOWNERS only
bites when the corresponding setting is on.

## Settings to enable

| # | Setting | Where | Status |
|---|---------|-------|--------|
| 1 | Branch protection on `main`: require status checks `gate-a`, `gate-b`, `agent-lint` to pass | Settings → Branches | assumed on (auto-merge implies it) — verify the *list* includes all three |
| 2 | **Require review from Code Owners** on `main` | same rule as 1 | ☐ — see trade-off below |
| 3 | Block force pushes + deletions on `main` and `claims` | rulesets | ☐ |
| 4 | Restrict who can edit Actions settings / disable "Allow all actions" in favour of allow-list | Settings → Actions | ☐ optional belt |
| 5 | Tag protection on `v*` (releases are the public record) | rulesets | ☐ |

## The honest trade-off on #2

With "require review from Code Owners" on, any PR touching the owned paths
(`.github/`, `tools/gate_a|gate_b/`, `AxiomAudit/`, `AuditFixtures/`,
`swarm/`, lakefile, toolchain) needs an approving review from a code owner —
**and GitHub does not count the PR author's own approval**. For the current
solo-maintainer flow, where the maintainer's agents author most
gate/tooling PRs under the maintainer's account, that means each such PR
needs either a second maintainer account, an org team, or an admin
"bypass branch protections" merge. Swarm prove/decompose/affinity PRs touch
none of the owned paths and auto-merge exactly as today.

Recommendation: enable it **before** opening the repository to untrusted
contributors (the threat model it serves); until then it is friction with no
adversary. The date of enablement should be recorded here.

## Standing items

- New workflows must pin third-party actions to commit SHAs (`@<sha> # vX.Y.Z`)
  — agent-lint does not currently enforce this; check in review.
- CODEOWNERS changes are themselves owned (the file lives under `/.github/`).
