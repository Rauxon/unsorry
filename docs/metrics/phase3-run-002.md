# Phase-3 run 002 — first compounding (Nicomachus reused as a dependency)

**run_id:** `phase3-run-002` · **date:** 2026-06-11 (UTC) · **trial:** thread B — merged work reused as an importable dependency.

Machine record: [`phase3-run-002.json`](phase3-run-002.json).

## Exit-metric verdict (read this first)

**The exit metric is: did merged work get *reused* as an importable dependency — a proof that imports an `Unsorry.*` module and uses its lemma?**

**MET.** PR #154's module proves the triangular closed form `∑_{i≤n} i³ = (n(n+1)/2)²` like this — in full:

```lean
import Unsorry.NicomachusSumCubes
import Mathlib.Algebra.BigOperators.Intervals

theorem sum_range_cube_eq_triangular_sq (n : ℕ) :
    ∑ i ∈ Finset.range (n + 1), i ^ 3 = (n * (n + 1) / 2) ^ 2 := by
  rw [nicomachus_sum_cubes (n + 1), Finset.sum_range_id, Nat.add_sub_cancel,
    Nat.mul_comm (n + 1) n]
```

The first rewrite is `nicomachus_sum_cubes` — the swarm's own phase-2 lemma (#133), **invoked, not re-derived**. "Every merged lemma makes the next one cheaper" was the README's headline aspiration; this is the first time it happened by mechanism.

## The numbers

| Dimension | Value |
|---|---|
| machinery + seeded dep edge | ADR-014, PR #153 (merged 05:20:25Z) |
| claim → proved | **4 min 57 s**, first attempt (`fable`, pre-ladder static `max`) |
| proof size | one 4-step `rw` |
| reuse PR | #154 (merged 05:35:08Z) — seed-to-merged in **15 minutes** |
| binding held | yes (gate-a regenerated obligation green) |
| reuse edges, this run | 1 declared (`triangular → nicomachus-sum-cubes`) |
| reuse edges incl. run-001's recompositions | **5** (each recomposing parent imported its own proved subs via the same surfacing) |

## The mechanism (ADR-014)

`proved-deps` resolves a goal's declared `deps≜⟨…⟩` plus its own decomposition's subs through the library index (the authoritative proved marker) to their declaring modules; `run_proof` appends a `PROVED DEPENDENCIES` section to the prove prompt — import lines with statements — and amends the import-tightness rule to allow exactly these. **Advisory only**: the prover may ignore it, and the kernel, axiom audit and binding gate judge the result identically either way. Soundness never depends on the hint.

The corroboration matters as much as the headline: [run-001](phase3-run-001.md)'s four recompositions are four more reuse instances of the same mechanism — each recomposing parent (`s1-s1`, `s2`, `s1`, the root) imported its proved subs rather than re-deriving them. Reuse is now how the chain closes, not a special case.

## What this run proves, and what it doesn't

- **Proved:** the compounding *mechanism* — a merged lemma, surfaced to a later prover, gets imported and used, turning a target into near-mechanical composition (4m57s, one attempt, two-line module body).
- **Not proved:** deep dependency routing. This was a depth-1 tree with one declared edge; roadmap thread B's full ambition — a chosen *result* reached through a several-lemma dependency tree, routed bottom-up by affinity/gap selection — remains open, as does transitive closure (deliberately deferred until a tree needs it).
- The honest framing for the README: the queue now *compounds*; whether it compounds **at depth, on hard targets** is the next question.
