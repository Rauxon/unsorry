# Upstream packet: `sum-range-pow-seven-closed-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_seven_closed_form (n : ℕ) : 24 * ∑ i ∈ Finset.range (n + 1), i ^ 7 = n ^ 2 * (n + 1) ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowSevenClosedForm.lean` (theorem `sum_range_pow_seven_closed_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-seven-closed-form.patch`](sum-range-pow-seven-closed-form.patch). The target path
`Mathlib/Unsorry/SumRangePowSevenClosedForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith

theorem sum_range_pow_seven_closed_form (n : ℕ) :
    24 * ∑ i ∈ Finset.range (n + 1), i ^ 7 =
      n ^ 2 * (n + 1) ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2) := by
  have key : ∀ m : ℕ,
      24 * ∑ i ∈ Finset.range (m + 1), i ^ 7 + m ^ 2 * (m + 1) ^ 2 * (m ^ 2 + 4 * m) =
        m ^ 2 * (m + 1) ^ 2 * (3 * m ^ 4 + 6 * m ^ 3 + 2) := by
    intro m
    induction m with
    | zero => simp
    | succ k ih =>
      rw [Finset.sum_range_succ, Nat.mul_add]
      set S := ∑ i ∈ Finset.range (k + 1), i ^ 7
      refine Nat.add_right_cancel (m := k ^ 2 * (k + 1) ^ 2 * (k ^ 2 + 4 * k)) ?_
      calc _ = (24 * S + k ^ 2 * (k + 1) ^ 2 * (k ^ 2 + 4 * k))
                + (24 * (k + 1) ^ 7
                  + (k + 1) ^ 2 * (k + 1 + 1) ^ 2 * ((k + 1) ^ 2 + 4 * (k + 1))) := by ring
        _ = k ^ 2 * (k + 1) ^ 2 * (3 * k ^ 4 + 6 * k ^ 3 + 2)
                + (24 * (k + 1) ^ 7
                  + (k + 1) ^ 2 * (k + 1 + 1) ^ 2 * ((k + 1) ^ 2 + 4 * (k + 1))) := by rw [ih]
        _ = _ := by ring
  have hle : n ^ 2 + 4 * n ≤ 3 * n ^ 4 + 6 * n ^ 3 := by
    rcases n with _ | k
    · norm_num
    · nlinarith [Nat.zero_le k, sq_nonneg k]
  have hB : 3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2 + (n ^ 2 + 4 * n) =
      3 * n ^ 4 + 6 * n ^ 3 + 2 := by
    rw [Nat.sub_sub]; omega
  have hmul : n ^ 2 * (n + 1) ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2)
        + n ^ 2 * (n + 1) ^ 2 * (n ^ 2 + 4 * n)
      = n ^ 2 * (n + 1) ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 + 2) := by
    rw [← Nat.mul_add, hB]
  exact Nat.add_right_cancel ((key n).trans hmul.symm)
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_pow_seven_closed_form\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (power-sum tower — the harder odd-power rung) |
| reference | Faulhaber's formula, p = 7; Conway & Guy, The Book of Numbers; D. E. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993). Faulhaber's own result: odd-power sums are polynomials in the triangular number T = n(n+1)/2. |
| absence | machine-checked; the `i ^ 7` pattern flags only elliptic-curve / modular-form files (AlgebraicGeometry/EllipticCurve, NumberTheory/ModularForms/DedekindEta), verified unrelated — no specific seventh-power Faulhaber closed form present (general Bernoulli formula only; rev c5ea00351c28, 2026-06-13). |
| difficulty | 4 |
| decomposition sketch | Induction on n over Finset.range (n+1) with Finset.sum_range_succ; the step is a degree-8 polynomial identity closed by ring after clearing the truncated subtractions in 3(n+1)⁴+6(n+1)³−(n+1)²−4(n+1)+2 (the factor is ≥ 0 for all n; n=0 closes by rfl). 1–2 steps. Feeds the crown identity `sum-range-pow-five-add-pow-seven`. |
| title | For every natural n, 24·(sum of i⁷ for i in 0..n) = n²(n+1)²(3n⁴+6n³−n²−4n+2); Faulhaber's closed form for seventh powers, ∑k⁷ = (3n⁸+12n⁷+14n⁶−7n⁴+2n²)/24. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-seven-closed-form --fork <your-github-user> --understood
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
