# SPEC-027-A: Proof / Harness PR Separation

Implements: [ADR-027](../ADR-027-Proof-Harness-PR-Separation.md) · Status: Living · Updated: 2026-06-13

## Surfaces

`tools/repo/pr_scope.py` classifies each changed repo-relative path:

- **proof** — `library/`, `goals/`, `translations/`, `decompositions/`, `proof-runs/`
- **harness** — `swarm/`, `tools/`, `.github/`, `AxiomAudit/`, `AuditFixtures/`, and the files `lakefile.toml`, `lean-toolchain`, `lake-manifest.json`
- **neutral** — everything else (docs, `CHANGELOG.md`, `README.md`, licence): may travel with either side.

A PR is **mixed** iff its changed set contains at least one `proof` path **and** at least one `harness` path.

## Gate

- `git diff --name-only base...head | python3 -m tools.repo.pr_scope check` (paths may also be passed as argv) exits `0` when not mixed, `1` otherwise, printing the offending proof and harness paths.
- `.github/workflows/pr-scope.yml` runs it on `pull_request_target` (`opened`, `synchronize`, `reopened`) against the base checkout with a read-only token; the changed-file list comes from the PR API (`gh pr view --json files`), so no PR-head code runs. Add `pr-scope / scope` to branch protection's required checks to make it blocking.

## Acceptance criteria

1. `surface()` classifies proof, harness, and neutral paths as specified.
2. `mixed()` is true only when both proof and harness paths are present.
3. A pure-proof PR (proof + neutral) and a pure-harness PR (harness + neutral) pass; a proof+harness PR fails with both offending lists.
4. An empty/neutral-only change passes.

## Out of scope (issue #302)

Title-vs-content consistency (does a `prove(...)` title only touch proof paths?), the harness-regression integration test, and the protocol-compliance gate ship as their own PRs.
