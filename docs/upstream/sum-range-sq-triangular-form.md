# Upstream packet: `sum-range-sq-triangular-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_sq_triangular_form (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 2
      = (∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeSqTriangularForm.lean` (theorem `sum_range_sq_triangular_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-sq-triangular-form.patch`](sum-range-sq-triangular-form.patch). The target path
`Mathlib/Unsorry/SumRangeSqTriangularForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring

theorem sum_range_sq_triangular_form (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 2
      = (∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1) := by
  have h2 : 6 * ∑ i ∈ Finset.range (n + 1), i ^ 2 = n * (n + 1) * (2 * n + 1) :=
    sum_range_sq_closed_form n
  have h1 : (∑ i ∈ Finset.range (n + 1), i) * 2 = (n + 1) * n := by
    rw [Finset.sum_range_id_mul_two, Nat.add_sub_cancel]
  have lhs2 : 2 * (3 * ∑ i ∈ Finset.range (n + 1), i ^ 2) = n * (n + 1) * (2 * n + 1) := by
    rw [← h2]; ring
  have rhs2 : 2 * ((∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1))
      = n * (n + 1) * (2 * n + 1) := by
    have e : 2 * ((∑ i ∈ Finset.range (n + 1), i) * (2 * n + 1))
        = ((∑ i ∈ Finset.range (n + 1), i) * 2) * (2 * n + 1) := by ring
    rw [e, h1]; ring
  exact Nat.eq_of_mul_eq_mul_left (by omega) (lhs2.trans rhs2.symm)
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangeSqClosedForm`

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_sq_triangular_form\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (Faulhaber-in-T tower — power sums as polynomials in the triangular number) |
| reference | Faulhaber's theorem: ∑kᵖ is a polynomial in T = n(n+1)/2; the even-power cases carry a factor (2n+1). ∑k² = n(n+1)(2n+1)/6 = T(2n+1)/3. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); mathlib carries only the general Bernoulli-number formula (`NumberTheory/Bernoulli.lean`, `sum_range_pow`), not the triangular-number form. |
| difficulty | 2 |
| decomposition sketch | Compounds on the proved `sum-range-sq-closed-form` (6∑k² = n(n+1)(2n+1)) plus the Gauss sum ∑k = n(n+1)/2 (mathlib `Finset.sum_range_id`): substitute both and close by ring. Or direct induction. 1–2 steps. **This rung re-expresses a proved closed form in terms of T — the first step of revealing the Faulhaber structure.** |
| title | For every natural n, 3·(sum of i² for i in 0..n) = (sum of i for i in 0..n)·(2n+1); i.e. ∑k² = T·(2n+1)/3 where T = ∑k = n(n+1)/2 is the n-th triangular number. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-sq-triangular-form --fork <your-github-user> --understood
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
