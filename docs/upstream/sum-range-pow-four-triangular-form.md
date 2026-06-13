# Upstream packet: `sum-range-pow-four-triangular-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_four_triangular_form (n : ℕ) :
    15 * ∑ i ∈ Finset.range (n + 1), i ^ 4
      = (∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1) * (3 * n ^ 2 + 3 * n - 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowFourTriangularForm.lean` (theorem `sum_range_pow_four_triangular_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-four-triangular-form.patch`](sum-range-pow-four-triangular-form.patch). The target path
`Mathlib/Unsorry/SumRangePowFourTriangularForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination

theorem sum_range_pow_four_triangular_form (n : ℕ) : 15 * ∑ i ∈ Finset.range (n + 1), i ^ 4 = (∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1) * (3 * n ^ 2 + 3 * n - 1) := by
  rcases n with _ | m
  · simp
  · set N := m + 1 with hN
    have hpos : 1 ≤ 3 * N ^ 2 + 3 * N := by nlinarith [Nat.zero_le m]
    have key := sum_range_pow_four_closed N
    have gauss : (∑ i ∈ Finset.range (N + 1), i) * 2 = (N + 1) * N := by
      rw [Finset.sum_range_id_mul_two, Nat.add_sub_cancel]
    have gaussZ : (∑ i ∈ Finset.range (N + 1), (i : ℤ)) * 2 = ((N : ℤ) + 1) * N := by
      have h : (((∑ i ∈ Finset.range (N + 1), i) * 2 : ℕ) : ℤ) = (((N + 1) * N : ℕ) : ℤ) := by
        rw [gauss]
      push_cast at h
      linear_combination h
    apply Nat.eq_of_mul_eq_mul_left (show 0 < 2 by norm_num)
    have cast_eq : (((2 * (15 * ∑ i ∈ Finset.range (N + 1), i ^ 4)) : ℕ) : ℤ)
        = (((2 * ((∑ i ∈ Finset.range (N + 1), i) * (2 * N + 1) * (3 * N ^ 2 + 3 * N - 1))) : ℕ) : ℤ) := by
      push_cast [Nat.cast_sub hpos]
      linear_combination key - (2 * (N : ℤ) + 1) * (3 * (N : ℤ) ^ 2 + 3 * (N : ℤ) - 1) * gaussZ
    exact_mod_cast cast_eq
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangePowFourClosedForm`

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_pow_four_triangular_form\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (Faulhaber-in-T tower — even-power rung) |
| reference | Faulhaber's theorem, even-power case: ∑k⁴ = n(n+1)(2n+1)(3n²+3n−1)/30 = T(2n+1)(3n²+3n−1)/15. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993); CRC Standard Mathematical Tables. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); only the general Bernoulli formula is present. |
| difficulty | 3 |
| decomposition sketch | Compounds on the proved `sum-range-pow-four-closed-form` plus the Gauss sum; substitute and close by ring after clearing the (3n²+3n−1) truncated subtraction (n=0 closes by rfl). 1–2 steps. Contrasts the odd-power rungs: even powers keep the extra (2n+1) factor, odd powers reduce to pure powers of T. |
| title | For every natural n, 15·(sum of i⁴ for i in 0..n) = (sum of i for i in 0..n)·(2n+1)·(3n²+3n−1); i.e. ∑k⁴ = T(2n+1)(3n²+3n−1)/15 where T = ∑k. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-four-triangular-form --fork <your-github-user> --understood
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
