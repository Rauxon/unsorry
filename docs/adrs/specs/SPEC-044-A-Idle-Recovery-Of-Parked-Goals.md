# SPEC-044-A: Idle Recovery of Parked Goals

Implements: [ADR-044](../ADR-044-Idle-Recovery-Of-Parked-Goals.md) · Status: Living · Updated: 2026-06-15

## Behaviour

A `--prove` cycle that finds no claimable **viable** goal (the normal queue is empty or every
viable candidate is in flight / lost a claim race) does not immediately go idle. It re-surfaces
one goal **parked below the viability floor** (`affinity < TAU_V`) and runs it through the
existing `prove_goal` pipeline — which injects the goal's accumulated `⟦Δ:Lesson⟧` history
(ADR-024) into the attempt and decomposes on failure (ADR-009). No recovery-specific proof or
decomposition logic exists; recovery is only a second *source* for the cycle's claim+work step.

## Components (`swarm/agent.sh`)

- **`recovery-candidates <goals-dir> <claims-dir> <library-dir> <agent> [<at>]`** (py_helper) —
  the inverse of `prove-candidates`. Same hard claimability filter (phase≡prove, status≡open,
  NOT proved, `< PROVE_CLAIM_CAP` live other-agent claims, no live self-claim) but keeps **only**
  `affinity < TAU_V`, ordered least-buried first (`affinity` desc, then id).
- **`select_recovery_candidates`** — wraps the helper with the same `goal_in_scope` (`--goal`)
  and per-session `HANDLED` shaping `select_prove_candidates` applies.
- **`claim_from_pool <list>`** — walks a candidate list, skips prove goals with an open prove PR
  (in flight, ADR-017), claims the first free goal, and sets the global `CLAIMED_GOAL` (empty if
  none). Diagnostics go to stderr via `log`. Used for **both** the viable and recovery pools.
- **`main` step 4** — `claim_from_pool "$candidates"`; if `CLAIMED_GOAL` is empty and `PROVE=1`
  and `UNSORRY_RECOVERY != 0`, `claim_from_pool "$(select_recovery_candidates)"` and log the
  re-surfaced goal. A claimed goal (from either pool) runs the unchanged `prove_goal` work step.
- An empty viable queue is terminal only for translate mode; prove mode falls through to step 4.
  `--dry-run` reports the goal it would claim, or — with an empty viable queue — the parked pool
  it would recover from.

## Properties

- **No competition with proving.** Recovery runs only when no viable goal is workable.
- **Bounded.** One recovery goal per cycle; `HANDLED` prevents repeating a goal within a session;
  live-claim filtering stops two agents recovering the same goal. A recovered goal that fails
  again is demoted further and the next idle pass takes the next-least-buried goal.
- **Disjoint pools.** `recovery-candidates` (affinity `< TAU_V`) and `prove-candidates`
  (affinity `≥ TAU_V`) never overlap.
- **Opt-out.** `UNSORRY_RECOVERY=0` restores the previous "idle when no viable goal" behaviour.

## Acceptance criteria

- `test_recovery_candidates` (self-test): on a tree with one viable and two parked goals,
  `recovery-candidates` returns only the parked goals, least-buried first; a goal at exactly
  `TAU_V` is viable (excluded); a live other-agent claim on a parked goal excludes it.
- `recovery-candidates` is the exact inverse of `prove-candidates`: on any tree the two outputs
  are disjoint and partition the claimable open-prove goals by the `TAU_V` cut.
- `./swarm/agent.sh --self-test` green; `shellcheck`/`bash -n` clean.
