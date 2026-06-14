# ADR-044: Idle Recovery of Goals Parked Below the Viability Floor

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-044 |
| **Initiative** | unsorry — swarm throughput / goal lifecycle |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Accepted |

## Context

A prove goal carries an affinity score (⟦Γ:Affinity⟧, ADR-010). `select_prove_candidates`
ranks the claimable pool and `_rank` drops everything with `affinity < TAU_V` (−5) as
"below viability — awaiting re-decomposition." A failed prove attempt demotes a goal by
−10 (`demote_goal`), so a goal that fails its first claim's attempt ladder drops from 0 to
−10 in one step — below the floor — and `select_prove_candidates` can **never surface it
again**.

The intended recovery (ADR-009) is decomposition into sub-lemmas, but decomposition only
fires **at failure-time inside `prove_goal`**. If that one decomposition does not happen
(decompose disabled, the provider produced no usable split, the depth cap, or simply a run
that demoted instead of decomposing), the goal is **orphaned**: parked below the floor, no
sub-lemmas, and nothing ever revisits it. ADR-024 cross-cycle lesson memory records a
`⟦Δ:Lesson⟧` for each failed attempt, but lessons are only injected when a goal is
re-selected for proving — which never happens for a parked goal.

Observed on `main` (2026-06-15): of 58 `phase=prove, status=open` goals, **48 were parked
below `TAU_V`** (46 at −10, 2 at −20) with no decomposition, while the **10 viable** ones
all had open prove PRs in flight. The swarm reported "nothing claimable" despite 48 open,
recoverable goals — and `prove --once` runs exited immediately. The pool was starved.

## WH(Y) Decision Statement

**In the context of** a prove queue that drops goals below `TAU_V` and only ever
decomposes a goal at failure-time, while ADR-024 now carries each failed attempt's lesson
forward so a re-attempt need not start from an empty board,
**facing** the fact that a goal demoted to −10 on its first failed claim is parked below
the floor with no decomposition and no path back — never re-selected, its accumulated
lessons never reused — so the working pool drains to "only in-flight goals remain" and the
swarm idles while dozens of open goals sit recoverable,
**we decided for** an **idle recovery pass**: when a `--prove` cycle finds no claimable
*viable* goal, re-surface one goal parked below `TAU_V` (the `recovery-candidates`
selector — the exact inverse of `prove-candidates`, least-buried first) and run it through
the **same `prove_goal` pipeline**, which retries with its lessons injected (ADR-024) and
decomposes on failure (ADR-009) — no duplicated recovery logic, just a second source for
the existing claim+work step (`UNSORRY_RECOVERY=0` disables it),
**and neglected** a dedicated re-decomposition sweep that splits parked goals directly
(rejected — it duplicates `prove_goal`'s decompose path and skips the cheaper
retry-with-lessons stage the maintainer specifically wanted first), lowering/removing
`TAU_V` so parked goals stay in the normal queue (rejected — the floor's whole purpose is
to keep the *normal* queue focused on viable work; recovery is the explicit, idle-only
exception), and re-promoting parked goals' affinity in place (rejected — it loses the
"these already failed once" signal and lets a hard goal crowd the viable queue every
cycle),
**to achieve** a swarm that, instead of idling, spends an otherwise-empty prove cycle
giving an orphaned goal a lessons-armed retry and then a decomposition — so the pool keeps
making progress until goals are genuinely proved or split,
**accepting that** a recovered goal that fails again is demoted further (−20, …) and the
next idle pass takes the next-least-buried goal (bounded: one recovery goal per cycle,
`HANDLED` prevents repeats within a session, and live-claim filtering avoids two agents
recovering the same goal), and that recovery deliberately runs only when no viable work
exists, so it never competes with normal proving.

## Consequences

- **Positive.** Orphaned goals re-enter the prove pipeline with their lesson history, so
  the swarm no longer falsely reports "nothing to do" while open goals remain. Reuses
  `prove_goal` wholesale — retry-with-lessons (ADR-024) then decompose-on-failure
  (ADR-009) — with no parallel recovery code path.
- **Positive.** The "no viable prove work" log now distinguishes in-flight/collided viable
  goals from the recovery attempt, and `--dry-run` reports the parked pool it would
  recover.
- **Negative.** A genuinely intractable goal will be retried (once per session, lessons
  growing) and eventually decomposed; until it is proved or split it consumes one idle
  cycle per session. `UNSORRY_RECOVERY=0` opts out.
- **Residue.** Recovery reduces idle starvation but does not change `TAU_V`, the demote
  magnitude, or the decomposition caps — those remain ADR-010/ADR-009 territory.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Recovery spec | Specification | specs/SPEC-044-A-Idle-Recovery-Of-Parked-Goals.md |
| REF-2 | Affinity ranking & viability floor | ADR | ADR-010-Affinity-Gap-Selection.md |
| REF-3 | Decomposition on prove failure | ADR | ADR-009-Goal-Decomposition.md |
| REF-4 | Cross-cycle lesson memory | ADR | ADR-024-Cross-Cycle-Lesson-Memory.md |
| REF-5 | Claim released at PR-open (in-flight skip) | ADR | ADR-017-Swarm-Supervisor.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
