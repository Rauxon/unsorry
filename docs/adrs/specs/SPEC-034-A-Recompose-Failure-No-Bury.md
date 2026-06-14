# SPEC-034-A: Recompose Failure Must Not Bury a Proved Subtree

Implements: [ADR-034](../ADR-034-Recompose-Failure-No-Bury.md) · Refines [SPEC-009-A](SPEC-009-A-Goal-Decomposition.md) / [SPEC-010-A](SPEC-010-A-Affinity-Gap-Selection.md) · Status: Living · Updated: 2026-06-14

## Detection — `recompose-candidate`

`py_helper recompose-candidate <goal> <decompositions-dir> <library-dir>` exits **0** iff `<goal>`
has a decomposition record whose sub-lemmas are **all proved**, else **1**. It reuses the
subs-⊆-proved predicate of `unblockable` (factored into the shared `_decomp_subs(decomp_dir) ->
{parent: set(sub_ids)}`) and `_proved_goals(library_dir)` (a goal is proved iff a
`library/index/<sha>.aisp` names it, SPEC-007-A). Unlike `unblockable` it does **not** filter on
`status` — by recompose time the parent is `open` (the unblock sweep re-opened it), not `blocked`.

## Floored demote

`demote_goal <goal> [<floor>]` and `aff-bump <goal.aisp> <delta> [<floor>]` take an optional floor.
The bump computes `new = max(aff + delta, floor)`. `prove_goal`, on a non-infra, non-decomposable
failure, branches:

```
if recompose-candidate <goal>:   demote_goal <goal> $(tau-v)   # floored at τ_v
else:                            demote_goal <goal>            # ordinary -10
```

A new `tau-v` helper prints `config.TAU_V` so the shell never hardcodes `-5`. The floored demote
opens an `affinity(<goal>): failed recompose, demote floored at τ_v` PR and records the failed
proof-run (telemetry, unchanged). The decompose path is unchanged — `decompose_goal` still refuses
(idempotency, #368) on an already-decomposed parent, which is exactly why control reaches here.

## Behaviour

| failed goal | recompose-candidate | demote | viable after? |
|---|:--:|---|:--:|
| leaf / undecomposed | no (exit 1) | `aff += -10` | only if aff stays ≥ τ_v (unchanged) |
| decomposed parent, **all** subs proved | yes (exit 0) | `aff = max(aff-10, τ_v)` | **always** (≥ τ_v) |
| decomposed parent, some subs unproved | no (exit 1) | n/a (not claimable while blocked) | — |

A floored parent ranks at τ_v = lowest-but-viable, so the unblock→recompose sweep auto-retries it
only when no better work exists — recoverable, never buried, never hogging the budget.

## Acceptance criteria (#388)

1. A failed recompose of a parent with a decomposition record + all-proved subs does **not** push
   its affinity below `TAU_V` (`aff = max(aff-10, τ_v) ≥ τ_v`) — `test_recompose_fail_floors_at_viability`.
2. Ordinary prove-fail demotes (leaves / undecomposed goals) are **unchanged** (full −10) — same test.
3. Hermetic self-test covering both: `recompose-candidate` exit 0 only when all subs proved, exit 1
   for a leaf; floored bump lands at τ_v, ordinary bump at −10. `./swarm/agent.sh --self-test` green.
