# ADR-013: Model & Effort Policy for Proof Runs

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-013 |
| **Initiative** | unsorry Phase 3 — harder targets |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-11 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** pointing the swarm at genuinely hard targets (difficulty 3–4), where `phase2-run-002` showed the default model one-shots the easy band but stalled on all three hard targets it attempted,
**facing** the fact that a failed prove attempt wastes a full `UNSORRY_WALL` window plus a Lean build, so success-probability-per-attempt — not per-token speed — dominates end-to-end time-to-proved,
**we decided for** defaulting all proof-surface `claude` calls (prove, decompose) to the most capable available model (`fable`) at maximum effort (`max`), env-overridable via `UNSORRY_MODEL`/`UNSORRY_EFFORT`, with the `--effort` flag dropped fail-soft when the installed CLI does not advertise it, and translation staying on the cheaper default (it is not a proof run),
**and neglected** a CI gate on model identity, difficulty-routed model selection, and keeping the old flat default,
**to achieve** the best attainable per-attempt success rate on the hard band — fewer wasted wall+build cycles, faster effective time-to-proved, and stronger decomposition quality when budget exhaustion triggers ADR-009,
**accepting that** per-attempt latency may rise (more reasoning tokens; the 5–10 min Lean build floor is model-independent anyway), subscription credit burn increases on easy goals the cheaper model already closes (user-approved trade), and enforcement is by defaults plus metrics-recorded run config rather than CI — the kernel and gates make model choice a performance knob, never a soundness one, so a model gate is neither possible nor needed.

## Context

Phase 3 threads A and B drive the swarm at difficulty-3/4 targets. The evidence from run-002: `sonnet` proved the easy Faulhaber k=4 directly but made no terminal progress on `platonic-schlafli-core`, `not-prime-pow-four-add-four`, or `alternating-sum-naturals` within their walls. On hard targets the binding constraint is whether an attempt *succeeds*, because every failure costs the full wall plus a mathlib-cache build before the next try (or before decomposition fires).

Honest expectations, stated up front: this policy does **not** make individual attempts faster — max effort spends more reasoning tokens and the Lean build floor is unchanged. It raises the probability that an attempt (or a decomposition proposal) is *good*, which is what actually moves wall-clock-to-proved on the hard band. Soundness is untouched either way: Gate A, the axiom audit, kernel replay, and the ADR-011 binding obligation judge the output identically whatever model produced it.

## Options Considered

### Option 1: Fable + max effort on all proof-surface calls, env-overridable, fail-soft (Selected)
Defaults in `agent.sh` (`resolve_model_effort`), recorded in the startup log and run metrics; contributors can override or run older CLIs without breakage.
**Pros:** maximum capability where it counts; simple, predictable policy; zero soundness coupling; degrades gracefully.
**Cons:** credit burn on easy goals; slower single attempts.

### Option 2: Difficulty-routed selection (Rejected)
`fable` for difficulty ≥3, `sonnet` below. Better credit economics, but a second policy axis to maintain and the user explicitly chose uniform maximum capability for proof runs; revisit if credit limits bite.

### Option 3: CI enforcement of model identity (Rejected)
Impossible and unnecessary: nothing in a merged proof attests which model wrote it, and nothing needs to — the gates decide soundness. Enforcement-by-gate would be security theatre.

### Option 4: Keep flat `sonnet` default (Rejected)
Demonstrably stalls on the hard band (run-002); the whole point of Phase 3 is that band.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Relates To | ADR-009 | Goal Decomposition | Decomposition quality benefits directly |
| Relates To | ADR-007 | Agent Identity & Budgets | `UNSORRY_*` env surface extended |
| Evidence | — | phase2-run-002 | The hard-band stall this answers |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-013-A — Model/effort plumbing | Specification | specs/SPEC-013-A-Model-Effort-Policy.md |
| REF-2 | phase2-run-002 metrics | Evidence | ../metrics/phase2-run-002.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-11 |
| Accepted | unsorry maintainers | 2026-06-11 |
