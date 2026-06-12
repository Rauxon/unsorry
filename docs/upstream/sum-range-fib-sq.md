# Upstream packet: `sum-range-fib-sq`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_succ_fib_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), Nat.fib i ^ 2 = Nat.fib n * Nat.fib (n + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeFibSq.lean` (theorem `sum_range_succ_fib_sq`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-fib-sq.patch`](sum-range-fib-sq.patch). The target path
`Mathlib/Unsorry/SumRangeFibSq.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Fib.Basic
import Mathlib.Tactic.Ring

theorem sum_range_succ_fib_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), Nat.fib i ^ 2 = Nat.fib n * Nat.fib (n + 1) := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih, Nat.fib_add_two]
    ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bsum_range_succ_fib_sq\b`
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
| reference | Standard Fibonacci telescoping identity; Koshy, Fibonacci and Lucas Numbers with Applications, §5; Vajda, Fibonacci & Lucas Numbers, and the Golden Section. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 2 |
| decomposition sketch | Induction on n with Finset.sum_range_succ; step adds F_{n+1}^2: F_n F_{n+1} + F_{n+1}^2 = F_{n+1}(F_n + F_{n+1}) = F_{n+1} F_{n+2}, using Nat.fib_add_two : fib(n+2)=fib(n)+fib(n+1). One supporting rewrite (fib_add_two), no separate lemma. |
| title | For every natural n, the sum over i in 0..n of (fib i)^2 equals fib n * fib (n+1) (the telescoping identity F_0^2+...+F_n^2 = F_n F_{n+1}). |

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
