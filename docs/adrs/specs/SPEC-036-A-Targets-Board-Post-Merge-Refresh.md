# SPEC-036-A: Targets Board Post-Merge Refresh

Implements: [ADR-036](../ADR-036-Targets-Board-Post-Merge-Refresh.md) · Amends [SPEC-012-A](SPEC-012-A-Backlog-Sourcing.md) (§Board) · Status: Living · Updated: 2026-06-14

## What changed

`docs/targets.md` is no longer regenerated or gated **in PRs**. It is refreshed **post-merge**.

- **Removed (from #377/#378):**
  - `swarm/agent.sh::submit_pr_tree` no longer runs `targets_board "$prwt" > docs/targets.md` and no longer stages `docs/targets.md`. Goal PRs (prove/decompose/affinity/recompose/sourcing) carry only their goal-state files.
  - `.github/workflows/gate-b.yml` no longer runs `targets_board --check .`.
- **Added:** `.github/workflows/targets-board.yml` — on push to `main` touching `goals/**`, `library/index/**`, `backlog/**`, `tools/sourcing/targets_board.py`, or itself:
  1. `targets_board --check .` → if in sync, stop.
  2. on drift: `targets_board > docs/targets.md`, commit as `github-actions[bot]` with `docs: refresh targets board [skip ci]`, push to `main`.
  - `concurrency: { group: targets-board-refresh, cancel-in-progress: false }` coalesces a burst of merges into one refresh and never cancels a push mid-commit. `permissions: contents: write`; pinned action SHAs (ADR-019). The `[skip ci]` + docs-only path keep the refresh from re-firing CI.

The `targets_board` tool itself is unchanged (`--check` / stdout-render); only *where* it runs moves. Its tests (`tools/sourcing/tests/test_targets_board.py`) are unaffected.

## Behaviour

| event | board action |
|---|---|
| goal PR opened/merged | PR does **not** touch `docs/targets.md`; no `--check` gate |
| push to `main` changing goal state | `targets-board.yml` regenerates + commits the board if drifted |
| board already in sync | workflow is a no-op |

`main`'s board is therefore fresh within one workflow run of any goal change; PRs never conflict on it.

## Acceptance criteria

1. `submit_pr_tree` contains no `targets_board` call and does not stage `docs/targets.md`; `./swarm/agent.sh --self-test` stays green.
2. `gate-b.yml` has no `targets_board --check` step; gate-b passes on a PR whose board is stale relative to its goals.
3. `targets-board.yml` is valid, pinned, `permissions: contents: write`, triggers on the goal-state paths, and on drift commits `docs/targets.md` with `[skip ci]`.
4. Two concurrent goal PRs no longer conflict on `docs/targets.md` (neither carries it).

## Operational note

Same requirement as `proofs-visualisation.yml` (#395): the Actions token must be allowed to push to `main`. If branch protection blocks it, allow `github-actions[bot]` to bypass for this path (or swap the final step for a PAT-driven refresh).
