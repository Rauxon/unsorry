# ADR-034: Recompose Failure Must Not Bury a Proved Subtree

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-034 |
| **Initiative** | unsorry swarm reliability — auto-recompose recovery |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-14 |
| **Status** | Accepted |

## Context

When all of a decomposed parent's sub-lemmas are proved, the unblock sweep (ADR-009) re-opens
the parent for **recomposition** — a fresh prove attempt that assembles the proved subs into the
parent. If that attempt fails, `prove_goal()` falls through to the uniform `AFFINITY_FAIL = -10`
demote (`swarm/agent.sh`, `demote_goal`). Crucially, `decompose_goal` is now idempotent (#368):
it **refuses** to re-decompose a goal that already has a decomposition record, so a failed
recompose can no longer split further — it lands on the demote.

Two failed recomposes (−20) push the parent below `TAU_V = -5`, where ADR-010 ranking (`_rank`)
drops it as "non-viable, awaiting re-decomposition." But re-decomposition is exactly what #368
forbids. The parent can then be neither re-decomposed **nor** auto-selected — the proved subtree
is stranded and only an operator can recover it (the #380 `--goal` viability override, or the
#379 affinity restore). The `euclid-perfect-numbers` recompose (#370) failed its first attempt
and would have buried all six proved leaves had it failed twice; `sq-add-sq-eq-three-mul-sq-s4`
was stranded at `aff≜-10`.

The demote-on-fail and the #368 idempotency guard are in direct tension for the recompose case.
ADR-016 already establishes the principle that a failure carrying **no real evidence against the
goal** (an infrastructure failure) must not demote it — "twice now a quota outage has demoted a
whole tree below τ_v." A failed recompose is the analogous "recoverable work, don't bury it" case
for a *real* failure: the subs are proved, the parent is genuinely provable, it just needs another
attempt (a stronger rung, a different model).

## WH(Y) Decision Statement

**In the context of** the ADR-009 unblock→recompose sweep that re-opens a fully-proved-subtree
parent for assembly and the ADR-010 affinity demote that deprioritises failed goals,
**facing** the fact that a failed recompose lands on the uniform −10 demote which can drop the
parent below `TAU_V`, where ADR-010 marks it non-viable "awaiting re-decomposition" — yet the #368
idempotency guard forbids re-decomposing it, so the proved subtree can never auto-close and needs
operator intervention (#379/#380),
**we decided for** detecting a recompose attempt with a new `recompose-candidate` predicate (the
goal has a decomposition record whose subs are all proved — the same subs-⊆-proved check
`unblockable` already computes, minus the status filter) and **flooring the demote at `TAU_V`** for
it (`new = max(aff − 10, τ_v)`), so the parent sinks to lowest-but-viable priority and the sweep
keeps auto-retrying it,
**and neglected** skipping the demote entirely (leaves a genuinely-stuck recompose at *normal*
priority — a budget-poisoning loop), leaving it as-is (operator-only recovery defeats the point of
an *automatic* sweep), and raising `TAU_V` globally (weakens the viability floor for every goal),
**to achieve** automatic closure of a proved subtree without an operator un-burying it, while still
deprioritising a recompose the current model cannot yet assemble,
**accepting that** a floored recompose stays in the retry pool indefinitely (bounded: it ranks
lowest, so real work always goes first), that this is a heuristic over the merged decomposition/
index state (read at the synced repo root), and that an ordinary leaf/undecomposed failure is
unchanged (still the full −10).

## Options Considered

### Option 1: Floor the recompose demote at τ_v (Selected)
Detect the recompose candidate; apply −10 but clamp at `TAU_V`. **Pros:** parent stays selectable
(criterion 1) *and* is deprioritised to lowest priority, so a stuck recompose can't hog the budget.
**Cons:** a permanently-unprovable recompose stays in the pool (at lowest priority).

### Option 2: Skip the demote entirely (Rejected)
No penalty (mirror ADR-016 exactly). **Rejected:** a recompose the model genuinely can't close
stays at *normal* priority and is re-attempted every cycle — a poison goal that wastes the budget,
since nothing deprioritises it.

### Option 3: Leave as-is — operator recovery only (Rejected)
Keep the uniform −10; recover stranded parents via #379/#380. **Rejected:** the unblock→recompose
sweep exists to drive a proved subtree to closure *automatically*; requiring a human un-bury defeats
its purpose.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Refines | ADR-010 | Affinity-Gap Selection | Adds a floored-demote case to the −10/τ_v policy |
| Refines | ADR-009 | Goal Decomposition | Makes the unblock→recompose sweep self-recovering |
| Relates To | ADR-016 | Infrastructure Failure Guard | Same "don't bury recoverable work" principle, distinct condition |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Recompose no-bury spec | Specification | specs/SPEC-034-A-Recompose-Failure-No-Bury.md |
| REF-2 | Decompose idempotency guard (the tension) | Issue/PR | <https://github.com/agenticsnz/unsorry/issues/366> |
| REF-3 | Tracking issue | Issue | <https://github.com/agenticsnz/unsorry/issues/388> |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-14 |
| Accepted | unsorry maintainers | 2026-06-14 |
