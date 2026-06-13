# SPEC-026-A: PR Convention Enforcement and Trunk-Based Workflow

Implements: [ADR-026](../ADR-026-PR-Convention-Enforcement.md) · Status: Living · Updated: 2026-06-13

## Taxonomy (one source of truth)

`tools/repo/pr_labels.py` is the single source of truth. A PR title matches at
most one shape; the same `classify()` drives both labelling and the gate.

| Kind | Title shape | Label | Theorem outcome |
|---|---|---|---|
| Feature (machinery) | `feat: …` / `feat(scope): …` | `feat` | — |
| Fix (machinery) | `fix: …` | `fix` | — |
| Docs / ADR / spec | `docs: …` | `docs` (+ `metrics` for run/round evidence) | — |
| Release housekeeping | `docs(vX.Y.Z): …` | `release` | — |
| CI / automation | `ci: …` | `ci` | — |
| Tests | `test: …` | `test` | — |
| Refactor / perf / build | `refactor:` / `perf:` / `build:` | same | — |
| Chore | `chore: …` | `chore` | — |
| **Theorem proved** | `prove(<goal>): <thm> by <agent>` | `swarm:prove` | **passed** |
| **Theorem not proved (split)** | `decompose(<goal>): …` | `swarm:decompose` | **did not pass** |
| **Theorem not proved (demoted)** | `affinity(<goal>): …` | `swarm:demote` | **did not pass** |
| Translation / convergence | `tr(<goal>): …` / `converge(<goal>): …` | `swarm:translate` | — |
| Red-team | `redteam<n>(<vector>): …` | `red-team` | — |

Conventional prefixes require the `:` (an optional `(scope)` and breaking-change
`!` are allowed), so a prose title such as `fixed the flaky test` is **not**
accepted.

## Enforcement gate

- `python3 -m tools.repo.pr_labels enforce "<title>"` exits `0` when the title
  matches a shape, `1` otherwise, printing the accepted shapes.
- `.github/workflows/pr-conventions.yml` runs it on `pull_request_target`
  (`opened`, `edited`, `reopened`, `synchronize`) against the **base** checkout
  with a read-only token (fork-safe; never runs PR-head code). The job is a
  required status check, so a nonconforming title blocks merge.
- `is_conforming(title)` is the library entry point; the gate is exactly
  `is_conforming(title)`.

## Trunk-based workflow (canonical)

Documented in `CONTRIBUTING.md` and `docs/pr-labels.md`:

- One short-lived branch per **single logical change**, branched off `main`.
- A proof is a proof; a fix is a fix; a feature is a feature — do **not** bundle
  unrelated changes (e.g. a harness fix riding along a proof PR).
- Branch prefixes mirror the title kind: `feat/`, `fix/`, `docs/`, `ci/`,
  `test/`; the swarm uses `feature/goal-<id>-<verb>-<agent>-<hash>`.
- Squash-merge to `main` on green gates; the branch is deleted after merge.

## Acceptance criteria

1. `classify` recognises the full Conventional-Commits set and the swarm/
   red-team/release shapes; conventional prefixes require the `:`.
2. `is_conforming` / `enforce` accept every shape in the table and reject prose.
3. The `pr-conventions` workflow fails a PR with a nonconforming title and
   passes a conforming one.
4. Labelling behaviour for pre-existing shapes is unchanged.

## Out of scope (tracked in issue #302)

Title-vs-content (mixed proof/harness) blocking, a harness-regression
integration test for the `run_proof` path guard, a protocol-compliance gate
(CHANGELOG/ADR/SPEC presence), and a mock-provider end-to-end smoke. Each ships
as its own PR per the workflow above.
