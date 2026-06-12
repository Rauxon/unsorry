# Upstream packet: `sum-range-pow-four-closed-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_four_closed (n : ℕ) : 30 * (∑ k ∈ Finset.range (n + 1), (k : ℤ) ^ 4) = n * (n + 1) * (2 * n + 1) * (3 * n ^ 2 + 3 * n - 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowFourClosedForm.lean` (theorem `sum_range_pow_four_closed`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-four-closed-form.patch`](sum-range-pow-four-closed-form.patch). The target path
`Mathlib/Unsorry/SumRangePowFourClosedForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring

theorem sum_range_pow_four_closed (n : ℕ) : 30 * (∑ k ∈ Finset.range (n + 1), (k : ℤ) ^ 4) = n * (n + 1) * (2 * n + 1) * (3 * n ^ 2 + 3 * n - 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bsum_range_pow_four_closed\b`
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
| reference | Faulhaber's formula, case p=4. Conway & Guy, The Book of Numbers, Ch. 2; Knuth, 'Johann Faulhaber and sums of powers', Math. Comp. 61 (1993). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 2 |
| decomposition sketch | Induction on n over ℤ. Base n=0 (both sides 0). Step via Finset.sum_range_succ then ring closes the polynomial identity. PRE-FLIGHT: before admission, confirm Finset.sum_range_pow specialization doesn't trivialize it; if it does, downgrade to a corollary-application rather than a fresh induction. |
| title | For every natural n, 30 * (sum of k^4 for k in 0..n) = n(n+1)(2n+1)(3n^2+3n-1), the integer (ℤ) form of the Faulhaber p=4 identity. |

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
