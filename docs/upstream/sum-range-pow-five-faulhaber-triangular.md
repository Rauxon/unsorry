# Upstream packet: `sum-range-pow-five-faulhaber-triangular`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_five_faulhaber_triangular (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 5
      = (∑ i ∈ Finset.range (n + 1), i) ^ 2 * (4 * (∑ i ∈ Finset.range (n + 1), i) - 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowFiveFaulhaberTriangular.lean` (theorem `sum_range_pow_five_faulhaber_triangular`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-five-faulhaber-triangular.patch`](sum-range-pow-five-faulhaber-triangular.patch). The target path
`Mathlib/Unsorry/SumRangePowFiveFaulhaberTriangular.lean` is a **placeholder** — file placement and the
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
import Mathlib.Tactic.NormNum

theorem sum_range_pow_five_faulhaber_triangular (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 5
      = (∑ i ∈ Finset.range (n + 1), i) ^ 2
        * (4 * (∑ i ∈ Finset.range (n + 1), i) - 1) := by
  -- The proved closed form for the fifth-power sum.
  have hdep := sum_range_pow_five_closed_form n
  -- Twice the triangular number equals `(n + 1) * n` (Gauss's summation).
  have hgauss : 2 * (∑ i ∈ Finset.range (n + 1), i) = (n + 1) * n := by
    have h := Finset.sum_range_id_mul_two (n + 1)
    rw [Nat.add_sub_cancel] at h
    linarith [h]
  set S := ∑ i ∈ Finset.range (n + 1), i with hSdef
  set P := ∑ i ∈ Finset.range (n + 1), i ^ 5 with hPdef
  -- Rewrite the data attached to `S` in terms of `n`.
  have h4S : 4 * S = 2 * n ^ 2 + 2 * n := by
    have e : 4 * S = 2 * (2 * S) := by ring
    rw [e, hgauss]; ring
  have h4S2 : 4 * S ^ 2 = n ^ 2 * (n + 1) ^ 2 := by
    have e : 4 * S ^ 2 = (2 * S) ^ 2 := by ring
    rw [e, hgauss]; ring
  have hsub : 4 * S - 1 = 2 * n ^ 2 + 2 * n - 1 := by rw [h4S]
  -- Multiply the goal through by `4` and cancel.
  have hcancel : 4 * (3 * P) = 4 * (S ^ 2 * (4 * S - 1)) := by
    calc 4 * (3 * P)
        = 12 * P := by ring
      _ = n ^ 2 * (n + 1) ^ 2 * (2 * n ^ 2 + 2 * n - 1) := hdep
      _ = (4 * S ^ 2) * (2 * n ^ 2 + 2 * n - 1) := by rw [← h4S2]
      _ = (4 * S ^ 2) * (4 * S - 1) := by rw [← hsub]
      _ = 4 * (S ^ 2 * (4 * S - 1)) := by ring
  exact Nat.eq_of_mul_eq_mul_left (by norm_num) hcancel
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangePowFiveClosedForm`

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_pow_five_faulhaber_triangular\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (Faulhaber-in-T tower — odd-power rung; compounds on `sum-range-pow-five-closed-form`) |
| reference | Faulhaber's 1631 result that odd-power sums are polynomials in T = n(n+1)/2: ∑k⁵ = (4T³−T²)/3 = T²(4T−1)/3. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); the `i^5` flag resolves only to the general Bernoulli formula, not the T-form. |
| difficulty | 3 |
| decomposition sketch | Substitute the proved `sum-range-pow-five-closed-form` (12∑k⁵ = n²(n+1)²(2n²+2n−1)) and the Gauss sum T = n(n+1)/2 — then T²(4T−1) = n²(n+1)²(2n²+2n−1)/4 = 3∑k⁵, a polynomial identity closed by ring (cleanest over ℚ, or ℕ with the proved form). The `4T−1` truncation is safe (T≥1 for n≥1; n=0 both sides 0). 1–2 steps. **Together with `sum-range-pow-seven-faulhaber-triangular`, this explains the power tower's crown: 3(∑k⁵+∑k⁷) = T²(4T−1)+T²(6T²−4T+1) = 6T⁴, i.e. ∑k⁵+∑k⁷ = 2T⁴.** |
| title | For every natural n, 3·(sum of i⁵ for i in 0..n) = (sum of i for i in 0..n)²·(4·(sum of i for i in 0..n)−1); i.e. ∑k⁵ = T²(4T−1)/3 where T = ∑k. Faulhaber's theorem made concrete: the fifth-power sum is a pure polynomial in the triangular number T. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-five-faulhaber-triangular --fork <your-github-user> --understood
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
