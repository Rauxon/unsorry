# ADR-036: Refresh the Targets Board Post-Merge, Not In-PR

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-036 |
| **Initiative** | unsorry — generated-artifact handling under a high merge cadence |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

`docs/targets.md` is a **generated** board (regenerated from `goals/` + `library/index/`
by `tools.sourcing.targets_board`). The #377/#378 board-sync fix regenerated it **in every
goal-mutating PR** (`submit_pr_tree`) and enforced freshness with a gate-b `--check` gate.

That made any two concurrent goal PRs conflict on the board: while the swarm proves rapidly,
every merged proof regenerates the board, so a freshly-sourced batch PR (e.g. #404, earlier
#376) repeatedly goes DIRTY and **cannot land during a proving burst** — reconciling just
resets the race (#415). A full regen has no union-merge, so the conflict is unavoidable as
long as PRs carry the board.

The proofs-and-contributors visualisation (#395, under ADR-032) already solved the analogous
problem the right way: it is **not** regenerated in PRs; a workflow on push to `main` refreshes
it post-merge and commits any drift back. The board should follow the same model.

## WH(Y) Decision Statement

**In the context of** a generated targets board and a swarm that merges proof PRs in rapid
bursts,
**facing** the #377/#378 design that regenerates the board in every goal-mutating PR plus a
gate-b `--check` gate, which makes any two concurrent goal PRs conflict on the board so a
newly-sourced batch cannot reach `main` during a proving burst (#415),
**we decided for** refreshing the board **post-merge** — a `targets-board.yml` workflow on
push to `main` runs `targets_board --check` and, on drift, regenerates `docs/targets.md` and
commits it back as a single docs-only `[skip ci]` commit (mirroring the proofs-visualisation
workflow, #395/ADR-032) — and **removing** the in-PR regen from `submit_pr_tree` and the
gate-b `--check` gate, so goal PRs no longer touch the board,
**and neglected** keeping the in-PR regen (the #415 conflict), a merge driver on the board
(no union for a full regen), and making `--check` merely advisory (PRs still conflict at the
git level on the file itself),
**to achieve** goal PRs that merge without board conflicts during proving bursts, while
`main`'s board stays fresh (refreshed within one workflow run of any merge),
**accepting that** the board on `main` is briefly stale between a merge and the refresh run
(acceptable — the board is a human worklist; `library/index` is the authoritative proved
marker, SPEC-007-A), and that the refresh requires the Actions token to be allowed to push to
`main` (the same requirement #395 already carries).

## Consequences

- **Positive.** Sourcing batches land cleanly during proving bursts; the recurring DIRTY churn
  (#376/#404) ends; the board joins the one consistent post-merge generated-artifact model.
- **Negative.** A brief window where `main`'s board lags a just-merged goal change (bounded by
  the workflow run); dependence on the Actions-token push-to-`main` permission.
- **Supersedes** the in-PR board-sync of #377/#378 (the `--check` gate + `submit_pr_tree` regen).

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Post-merge board-refresh spec | Specification | specs/SPEC-036-A-Targets-Board-Post-Merge-Refresh.md |
| REF-2 | Board origin (the generated worklist) | Decision | ADR-012-Backlog-Sourcing.md |
| REF-3 | The post-merge pattern this mirrors (proofs visualisation) | Decision/CI | ADR-032 / `.github/workflows/proofs-visualisation.yml` (#395) |
| REF-4 | Tracking issue (the churn) | Issue | https://github.com/agenticsnz/unsorry/issues/415 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
