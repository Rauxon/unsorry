# Upstream packet: `alternating-sum-naturals`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem alternating_sum_naturals (n : ℕ) : ∑ i ∈ Finset.range n, (-1 : ℤ) ^ i * (i + 1) = if Even n then - (n / 2 : ℤ) else (n / 2 : ℤ) + 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/AlternatingSumNaturals.lean` (theorem `alternating_sum_naturals`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`alternating-sum-naturals.patch`](alternating-sum-naturals.patch). The target path
`Mathlib/Unsorry/AlternatingSumNaturals.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Ring.Int.Defs
import Mathlib.Algebra.Ring.Parity

theorem alternating_sum_naturals (n : ℕ) : ∑ i ∈ Finset.range n, (-1 : ℤ) ^ i * (i + 1) = if Even n then - (n / 2 : ℤ) else (n / 2 : ℤ) + 1 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rcases Nat.even_or_odd n with hn | hn
    · obtain ⟨k, rfl⟩ := hn
      have he : Even (k + k) := ⟨k, rfl⟩
      have ho : ¬Even (k + k + 1) := by rintro ⟨m, hm⟩; omega
      have hpow : (-1 : ℤ) ^ (k + k) = 1 := he.neg_one_pow (α := ℤ)
      rw [Finset.sum_range_succ, ih, if_pos he, if_neg ho, hpow]
      omega
    · obtain ⟨k, rfl⟩ := hn
      have hodd : Odd (2 * k + 1) := ⟨k, rfl⟩
      have ho : ¬Even (2 * k + 1) := by rintro ⟨m, hm⟩; omega
      have he : Even (2 * k + 1 + 1) := ⟨k + 1, by omega⟩
      have hpow : (-1 : ℤ) ^ (2 * k + 1) = -1 := hodd.neg_one_pow (α := ℤ)
      rw [Finset.sum_range_succ, ih, if_neg ho, if_pos he, hpow]
      omega
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\balternating_sum_naturals\b`
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
| reference | Standard arithmetic alternating-series partial sums (1-2+3-4+...); tabulated in Hardy, Divergent Series, Ch. 1; elementary induction exercise in discrete-math texts. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 3 |
| decomposition sketch | Two-step induction (n → n+2) collapsing each pair (-1)^i(i+1)+(-1)^(i+1)(i+2) = -1; base cases n=0,1. Reconcile Even/(n/2) with Nat.div via omega. ~3 sub-parts — the Even/ℕ-division bookkeeping is the only real friction (riskiest to PROVE of the set, though statement is type-confirmed). |
| title | For every natural n, the sum over i in 0..n-1 of (-1)^i (i+1) equals -(n/2) if n is even and (n/2)+1 if n is odd (integer division over ℤ). |

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
