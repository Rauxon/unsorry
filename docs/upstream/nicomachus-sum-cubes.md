# Upstream packet: `nicomachus-sum-cubes`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem nicomachus_sum_cubes (n : ℕ) :
    (∑ k ∈ Finset.range n, k ^ 3) = (∑ k ∈ Finset.range n, k) ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/NicomachusSumCubes.lean` (theorem `nicomachus_sum_cubes`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`nicomachus-sum-cubes.patch`](nicomachus-sum-cubes.patch). The target path
`Mathlib/Unsorry/NicomachusSumCubes.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

theorem nicomachus_sum_cubes (n : ℕ) :
    (∑ k ∈ Finset.range n, k ^ 3) = (∑ k ∈ Finset.range n, k) ^ 2 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, Finset.sum_range_succ, ih]
    cases n with
    | zero => simp
    | succ m =>
      set S := ∑ k ∈ Finset.range (m + 1), k
      have h : S * 2 = (m + 1) * m := by
        have h' := Finset.sum_range_id_mul_two (m + 1)
        rw [show (m + 1) - 1 = m from by omega] at h'
        exact h'
      have expand : (S + (m + 1)) ^ 2 = S ^ 2 + (m + 1) ^ 3 :=
        calc (S + (m + 1)) ^ 2
            = S ^ 2 + S * 2 * (m + 1) + (m + 1) ^ 2 := by ring
          _ = S ^ 2 + (m + 1) * m * (m + 1) + (m + 1) ^ 2 := by rw [h]
          _ = S ^ 2 + (m + 1) ^ 3 := by ring
      linarith
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bnicomachus_sum_cubes\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Phase-2 seeded target (pre-ADR-012) |
| reference | Nicomachus of Gerasa, *Introduction to Arithmetic* II.20; left as a reader exercise in *Mathematics in Lean* §5 |
| absence | machine-checked no-local-match (verified against pinned mathlib v4.30.0, 2026-06-10: only the general Bernoulli `sum_range_pow` exists — a different statement); normalized to the ADR-012 field format 2026-06-12, evidence unchanged |
| difficulty | 3 |
| title | Nicomachus's theorem: the sum of the first n cubes equals the square of the sum |

Proof produced by an autonomous Claude agent swarm (model policy ADR-013/ADR-015:
`fable`, progressive effort), merged with no human review through two CI gates
(ADR-006 soundness, Gate B hygiene). Full machine history: the goal's PR trail in
this repository.

## AI disclosure (paste-ready facts)

> The Lean proof in this PR was produced by an autonomous LLM agent
> (Anthropic Claude, model `fable`) operating in the `unsorry` proof swarm
> (github.com/agenticsnz/unsorry), and was machine-verified there by kernel
> replay, an axiom audit against the standard whitelist (`propext`,
> `Classical.choice`, `Quot.sound`), and a CI-regenerated statement-binding
> obligation. I have read and understood the proof in full and can justify
> each step without AI assistance. Label: `LLM-generated`.

## For the sponsor

1. Read the proof until you can justify every step **without AI assistance** —
   mathlib reviewers will expect exactly that.
2. **Zulip first**, in your own words: is the lemma wanted, where does it live,
   what should it be called? The PR-description narrative and every review reply
   likewise **must be rewritten in your own words** — mathlib policy forbids
   LLM-written conversation; only the lemma itself (disclosed) and the factual
   disclosure block above may be pasted.
3. One lemma per PR; apply the patch to a fresh mathlib branch; expect the
   linter to want golfing (binder names, line length) — that editing is yours.
4. Record the outcome on the targets board (`in-discussion → pr-open →
   merged | declined`). **Declined is a valid, recorded result.**
