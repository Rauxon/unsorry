# Upstream packet: `sum-range-sq-mul-choose`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Intervals

open Finset

theorem sum_range_sq_mul_choose (n : ℕ) :
    4 * (∑ k ∈ range (n + 1), k^2 * n.choose k) = n * (n + 1) * 2^n := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeSqMulChoose.lean` (theorem `sum_range_sq_mul_choose`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-sq-mul-choose.patch`](sum-range-sq-mul-choose.patch). The target path
`Mathlib/Unsorry/SumRangeSqMulChoose.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Data.Nat.Choose.Sum
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

theorem sum_range_sq_mul_choose (n : ℕ) :
    4 * (∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k) = n * (n + 1) * 2 ^ n := by
  cases n with
  | zero => norm_num
  | succ m =>
    have hterm : ∀ i ∈ Finset.range (m + 1),
        (i + 1) ^ 2 * (m + 1).choose (i + 1)
          = (m + 1) * (i * m.choose i + m.choose i) := by
      intro i _
      have habs : (m + 1) * m.choose i = (m + 1).choose (i + 1) * (i + 1) :=
        Nat.add_one_mul_choose_eq m i
      calc (i + 1) ^ 2 * (m + 1).choose (i + 1)
          = (m + 1).choose (i + 1) * (i + 1) * (i + 1) := by ring
        _ = (m + 1) * m.choose i * (i + 1) := by rw [habs]
        _ = (m + 1) * (i * m.choose i + m.choose i) := by ring
    have h1 : ∑ k ∈ Finset.range (m + 1 + 1), k ^ 2 * (m + 1).choose k
        = (∑ i ∈ Finset.range (m + 1), (i + 1) ^ 2 * (m + 1).choose (i + 1))
          + 0 ^ 2 * (m + 1).choose 0 :=
      Finset.sum_range_succ' (fun k => k ^ 2 * (m + 1).choose k) (m + 1)
    have h2 : (∑ i ∈ Finset.range (m + 1), (i + 1) ^ 2 * (m + 1).choose (i + 1))
        = ∑ i ∈ Finset.range (m + 1), (m + 1) * (i * m.choose i + m.choose i) :=
      Finset.sum_congr rfl hterm
    have h3 : (∑ i ∈ Finset.range (m + 1), (m + 1) * (i * m.choose i + m.choose i))
        = (m + 1) * ∑ i ∈ Finset.range (m + 1), (i * m.choose i + m.choose i) :=
      (Finset.mul_sum _ _ _).symm
    have h4 : (∑ i ∈ Finset.range (m + 1), (i * m.choose i + m.choose i))
        = (∑ i ∈ Finset.range (m + 1), i * m.choose i)
          + ∑ i ∈ Finset.range (m + 1), m.choose i :=
      Finset.sum_add_distrib
    rw [h1, h2, h3, h4, Nat.sum_range_mul_choose, Nat.sum_range_choose]
    cases m with
    | zero => norm_num
    | succ j =>
      have hj : j + 1 - 1 = j := by omega
      rw [hj]
      ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_sq_mul_choose\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic combinatorial identities |
| reference | Standard combinatorial identity for the second moment of binomial coefficients, derived from differentiating the binomial theorem twice. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12) |
| difficulty | 3 |
| title | Weighted sum of squares of binomial coefficients: $4 \sum_{k=0}^n k^2 \binom{n}{k} = n(n+1)2^n$. |

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
3. **Raise the draft PR with one command** once you've done 1–2 — from the
   unsorry repo root:
   ```
   python3 -m tools.upstream.raise_pr --goal sum-range-sq-mul-choose --fork <your-github-user> --understood
   ```
   It clones mathlib master, applies the patch to a fresh branch, pushes to
   your fork, and opens a **draft** PR pre-filled with the factual disclosure
   and a placeholder where your narrative goes. (`--understood` is your
   attestation that you've read the proof; `--dry-run` shows the plan first.)
   The machine never marks it ready and never writes a review reply.
4. Write your narrative in the draft, apply the `LLM-generated` label, then
   **you** flip draft → ready. Expect the linter to want golfing (binder
   names, line length) — that editing is yours. See [docs/upstreaming.md](../upstreaming.md).
5. Record the outcome on the targets board (`in-discussion → pr-open →
   merged | declined`). **Declined is a valid, recorded result.**
