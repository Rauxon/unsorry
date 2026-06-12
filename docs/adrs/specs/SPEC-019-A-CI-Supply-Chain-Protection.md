# SPEC-019-A: CI Supply-Chain & Workflow Protection

Implements: [ADR-019](../ADR-019-CI-Supply-Chain-Protection.md) · Status: Living · Updated: 2026-06-12

## Action pinning

Every `uses:` in `.github/workflows/*.yml` references a **commit SHA** with the release tag in a trailing comment (`@<sha> # vX.Y.Z`), pinned at the latest stable release of the major already in use (verified against the upstream repo on 2026-06-12):

| Action | Pinned |
|---|---|
| actions/checkout v4 / v6 | `34e11487…` # v4.3.1 / `df4cb1c0…` # v6.0.3 |
| actions/setup-python v5 / v6 | `a26af69b…` # v5.6.0 / `a309ff8b…` # v6.2.0 |
| actions/setup-node v6 | `48b55a01…` # v6.4.0 |
| dorny/paths-filter v3 | `d1c1ffe0…` # v3.0.3 |
| actions/upload-artifact v4 | `ea165f8d…` # v4.6.2 |
| leanprover/lean-action v1 | `38fbc41a…` # v1.5.0 |

Refresh procedure: resolve the new tag's commit via `gh api repos/<owner>/<repo>/commits/<tag> --jq .sha`, update sha + comment together. New workflows must arrive pinned (review item; noted in the checklist).

## Ownership

`.github/CODEOWNERS` assigns the trust-bearing paths — `.github/`, `tools/gate_a/`, `tools/gate_b/`, `AxiomAudit/`, `AuditFixtures/`, `swarm/`, `lakefile.toml`, `lean-toolchain` — to @cgbarlow. Inert until the repository setting "require review from Code Owners" is enabled; `docs/security-checklist.md` records that setting, the force-push/tag-protection rules, the honest solo-maintainer trade-off (GitHub ignores self-approval), and the enablement condition (**before** opening to untrusted contributors). Swarm prove/decompose/affinity PRs touch none of the owned paths.

## Audit corpus

`AuditFixtures/Opaque.lean`: an `opaque` constant plus a theorem depending on it. Sound by construction (the kernel demands an `Inhabited` witness; no new assumption enters the environment), so the acceptance bar is **exit 0** — no false positive, no crash. Wired into `tools/gate_a/test_audit.sh` (which CI runs as "Audit self-test"), so a future Lean or audit change that mishandles `opaque` goes red.

## Acceptance criteria

1. `grep -rn "uses:" .github/workflows/ | grep -v "# v"` is empty (every action pinned, version-commented).
2. `tools/gate_a/test_audit.sh` passes with the new Opaque case (17 cases).
3. CODEOWNERS parses (GitHub UI shows owners on a touched path).
4. `docs/security-checklist.md` exists and names every setting with its status honestly.
