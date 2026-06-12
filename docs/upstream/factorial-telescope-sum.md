# Upstream packet: `factorial-telescope-sum`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_mul_factorial_telescope (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i * Nat.factorial i = Nat.factorial (n + 1) - 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/FactorialTelescopeSum.lean` (theorem `sum_range_mul_factorial_telescope`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`factorial-telescope-sum.patch`](factorial-telescope-sum.patch). The target path
`Mathlib/Unsorry/FactorialTelescopeSum.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic.Ring

theorem sum_range_mul_factorial_telescope (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i * Nat.factorial i = Nat.factorial (n + 1) - 1 := by
  induction n with
  | zero => simp
  | succ k ih =>
    have h1 : 1 ≤ Nat.factorial (k + 1) := Nat.factorial_pos (k + 1)
    rw [Finset.sum_range_succ, ih, Nat.factorial_succ (k + 1)]
    have h2 : (k + 1 + 1) * Nat.factorial (k + 1) =
        Nat.factorial (k + 1) + (k + 1) * Nat.factorial (k + 1) := by ring
    rw [h2]
    omega
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bsum_range_mul_factorial_telescope\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities |
| reference | Classic telescoping identity from i·i! = (i+1)! - i!; exercise in Graham, Knuth & Patashnik, Concrete Mathematics, 2nd ed., Ch. 2 (perturbation/telescoping). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 2 |
| decomposition sketch | Key sub-lemma: i * i! = (i+1)! - i! (from Nat.factorial_succ = (i+1)*i!). Then induction with Finset.sum_range_succ telescopes. Manage ℕ truncated subtraction with (i+1)! ≥ 1 so omega/Nat.sub lemmas apply. ~2 sub-steps; a real Post⊆Pre dependency on Nat.factorial_succ. |
| title | For every natural n, the sum over i in 0..n of i * (i!) equals (n+1)! - 1. |

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
