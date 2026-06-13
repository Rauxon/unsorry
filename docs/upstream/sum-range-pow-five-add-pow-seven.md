# Upstream packet: `sum-range-pow-five-add-pow-seven`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_five_add_pow_seven (n : ℕ) :
    (∑ i ∈ Finset.range (n + 1), i ^ 5) + (∑ i ∈ Finset.range (n + 1), i ^ 7)
      = 2 * (∑ i ∈ Finset.range (n + 1), i) ^ 4 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowFiveAddPowSeven.lean` (theorem `sum_range_pow_five_add_pow_seven`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-five-add-pow-seven.patch`](sum-range-pow-five-add-pow-seven.patch). The target path
`Mathlib/Unsorry/SumRangePowFiveAddPowSeven.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

theorem sum_range_pow_five_add_pow_seven (n : ℕ) :
    (∑ i ∈ Finset.range (n + 1), i ^ 5) + (∑ i ∈ Finset.range (n + 1), i ^ 7)
      = 2 * (∑ i ∈ Finset.range (n + 1), i) ^ 4 := by
  -- A clean, subtraction-free combined identity, proved by induction.
  have key : ∀ m : ℕ,
      8 * ((∑ i ∈ Finset.range (m + 1), i ^ 5) + (∑ i ∈ Finset.range (m + 1), i ^ 7))
        = m ^ 4 * (m + 1) ^ 4 := by
    intro m
    induction m with
    | zero => simp
    | succ k ih =>
      rw [Finset.sum_range_succ (fun i => i ^ 5) (k + 1),
        Finset.sum_range_succ (fun i => i ^ 7) (k + 1)]
      generalize ha : (∑ i ∈ Finset.range (k + 1), i ^ 5) = a at *
      generalize hb : (∑ i ∈ Finset.range (k + 1), i ^ 7) = b at *
      have step : 8 * (a + b) + (8 * (k + 1) ^ 5 + 8 * (k + 1) ^ 7)
          = (k + 1) ^ 4 * (k + 1 + 1) ^ 4 := by
        rw [ih]; ring
      rw [← step]; ring
  -- Gauss summation: twice the linear sum is n * (n + 1).
  have gauss : (∑ i ∈ Finset.range (n + 1), i) * 2 = (n + 1) * n := by
    simpa using Finset.sum_range_id_mul_two (n + 1)
  -- Hence sixteen times the fourth power of the linear sum is the same polynomial.
  have h16 : 16 * (∑ i ∈ Finset.range (n + 1), i) ^ 4 = n ^ 4 * (n + 1) ^ 4 := by
    calc 16 * (∑ i ∈ Finset.range (n + 1), i) ^ 4
        = ((∑ i ∈ Finset.range (n + 1), i) * 2) ^ 4 := by ring
      _ = ((n + 1) * n) ^ 4 := by rw [gauss]
      _ = n ^ 4 * (n + 1) ^ 4 := by ring
  -- Combine and cancel the common positive factor.
  have h8 : 8 * ((∑ i ∈ Finset.range (n + 1), i ^ 5) + (∑ i ∈ Finset.range (n + 1), i ^ 7))
      = 8 * (2 * (∑ i ∈ Finset.range (n + 1), i) ^ 4) := by
    rw [key n, ← h16]; ring
  exact Nat.eq_of_mul_eq_mul_left (by norm_num) h8
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_pow_five_add_pow_seven\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (power-sum tower — the **crown**: compounds on `sum-range-pow-five-closed-form` + `sum-range-pow-seven-closed-form`) |
| reference | A classic Faulhaber curiosity: the sum of the fifth- and seventh-power sums is exactly twice the fourth power of the triangular number, generalising Nicomachus's ∑k³ = (∑k)² = T² one octave up. Verified ∀ n; see Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993) for the triangular-number structure of odd-power sums. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13) |
| difficulty | 4 |
| decomposition sketch | **Two routes, both compounding.** (a) Substitute the proved/sourced closed forms for ∑k⁵ (`sum-range-pow-five-closed-form`) and ∑k⁷ (`sum-range-pow-seven-closed-form`) together with the Gauss sum ∑k = n(n+1)/2, then the goal is a polynomial identity in n closed by ring. (b) Direct induction on n: the step needs ∑_{≤n} k = n(n+1)/2 (Gauss) substituted into 2((T+(n+1))⁴ − T⁴) = (n+1)⁵+(n+1)⁷, then ring. Route (a) is the headline stack — it consumes two lower rungs of this very batch. No truncated subtraction in the statement (all terms are sums of positive powers), so `ring` over ℕ applies once the sums are unfolded. |
| title | For every natural n, (sum of i⁵ for i in 0..n) + (sum of i⁷ for i in 0..n) = 2·(sum of i for i in 0..n)⁴; i.e. ∑k⁵ + ∑k⁷ = 2(∑k)⁴ = 2T⁴ where T = n(n+1)/2 is the n-th triangular number. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-five-add-pow-seven --fork <your-github-user> --understood
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
