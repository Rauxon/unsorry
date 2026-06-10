# Backlog Sourcing: keeping the queue full

Status: accepted (ADR-012) · 2026-06-10

Now that the swarm can prove an unformalised-in-mathlib theorem (Nicomachus, phase2-run-001), the bottleneck shifts from *can it prove* to *what should it prove next*. This is the plan for a steady stream of worthwhile targets.

## What belongs in the backlog — and what doesn't

unsorry proves theorems against the Lean kernel; it does not discover new mathematics. So the backlog is a **formalisation worklist**: theorems that are *already proven on paper but not yet in mathlib*. Two consequences:

- **In scope:** the formalisation gap — Freek's *100 Theorems* (unformalised in Lean), mathlib's undergraduate gaps, *Mathematics in Lean* `sorry` exercises, classic identities not yet named in mathlib.
- **Out of scope:** open conjectures (Riemann, P≠NP, Erdős open problems). There is no proof to formalise and no cheap oracle; the design doc ranks these last for exactly this reason.

Stating that boundary up front is part of the plan — it keeps the contributor invitation honest about what unsorry is.

## The hard part is absence, not discovery

Finding candidate theorems is easy; verifying a candidate is *not already in mathlib* is the hard, error-prone step. Nicomachus is the cautionary tale: capable models confidently "recall" a `Finset.sum_range_cube` lemma that does not exist (its real status: a `sorry` exercise in *Mathematics in Lean* §5). **Absence must be a machine check**, not a memory call — `tools/sourcing/check_absence.py` greps the pinned mathlib source (authoritative) plus best-effort Loogle, and records the mathlib revision so every absence claim is dated.

## The pipeline

Five stages (full detail in SPEC-012-A):

1. **Source** — curated lists + a `propose-target` issue template for contributors.
2. **Absence-verify** — `check_absence` against the pinned mathlib; a pre-filter that keeps obvious duplicates out cheaply (the definitive signal is downstream: an in-mathlib target gets a one-line citation, not a real proof).
3. **State** — lower to a `goals/<id>.lean` that type-checks (the translate/fidelity gate for contributor English).
4. **Band & dedup** — difficulty + decomposition sketch feed affinity/gap routing.
5. **Admit** — a gated PR adds the backlog markdown (with provenance) + the goal record + statement; the board (`docs/targets.md`) is regenerated.

It rides everything already built: the translate/fidelity gate produces statements, affinity/gap routes the reachable ones, decomposition splits the hard ones, and the ADR-011 binding gate guarantees a proof proves *that* statement.

## The contributor front door

The worklist *is* the `goals/` queue, surfaced as [`docs/targets.md`](../targets.md) — open targets with difficulty, source, and reference. A researcher (or agent) claims one, opens a PR, and the gates decide. Proposing a new target is an issue (`propose-target`); a maintainer or agent runs absence-verify + statement-lowering and admits it.

## What this does not solve

Curation at the top of the funnel stays a human judgement (which proven theorems are *worth* formalising). And grep-absence is a pre-filter, not a proof — mathlib moves, so a target admitted today may be upstreamed tomorrow; the recorded revision makes that detectable, not impossible.
