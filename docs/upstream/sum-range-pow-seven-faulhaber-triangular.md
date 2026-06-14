# Upstream packet: `sum-range-pow-seven-faulhaber-triangular`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_seven_faulhaber_triangular (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 7
      = (∑ i ∈ Finset.range (n + 1), i) ^ 2
        * (6 * (∑ i ∈ Finset.range (n + 1), i) ^ 2 - 4 * (∑ i ∈ Finset.range (n + 1), i) + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowSevenFaulhaberTriangular.lean` (theorem `sum_range_pow_seven_faulhaber_triangular`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-seven-faulhaber-triangular.patch`](sum-range-pow-seven-faulhaber-triangular.patch). The target path
`Mathlib/Unsorry/SumRangePowSevenFaulhaberTriangular.lean` is a **placeholder** — file placement and the
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

theorem sum_range_pow_seven_faulhaber_triangular (n : ℕ) :
    3 * ∑ i ∈ Finset.range (n + 1), i ^ 7
      = (∑ i ∈ Finset.range (n + 1), i) ^ 2
        * (6 * (∑ i ∈ Finset.range (n + 1), i) ^ 2 - 4 * (∑ i ∈ Finset.range (n + 1), i) + 1) := by
  have hdep := sum_range_pow_seven_closed_form n
  have hgauss : 2 * (∑ i ∈ Finset.range (n + 1), i) = (n + 1) * n := by
    have h := Finset.sum_range_id_mul_two (n + 1)
    rw [Nat.add_sub_cancel] at h
    linarith [h]
  have hle : ∀ m : ℕ, 4 * m ≤ 6 * m ^ 2 := by
    intro m
    rcases m with _ | k
    · simp
    · nlinarith [Nat.zero_le k, Nat.zero_le (k ^ 2)]
  have hCle : ∀ m : ℕ, m ^ 2 + 4 * m ≤ 3 * m ^ 4 + 6 * m ^ 3 := by
    intro m
    rcases m with _ | k
    · simp
    · nlinarith [Nat.zero_le k, Nat.zero_le (k ^ 2), Nat.zero_le (k ^ 3), Nat.zero_le (k ^ 4)]
  set S := ∑ i ∈ Finset.range (n + 1), i with hSdef
  set P := ∑ i ∈ Finset.range (n + 1), i ^ 7 with hPdef
  set B := 6 * S ^ 2 - 4 * S + 1 with hBdef
  have e1 : 12 * S ^ 2 = 3 * n ^ 4 + 6 * n ^ 3 + 3 * n ^ 2 := by
    have e : 12 * S ^ 2 = 3 * (2 * S) ^ 2 := by ring
    rw [e, hgauss]; ring
  have e2 : 8 * S = 4 * n ^ 2 + 4 * n := by
    have e : 8 * S = 4 * (2 * S) := by ring
    rw [e, hgauss]; ring
  have h4S2 : 4 * S ^ 2 = n ^ 2 * (n + 1) ^ 2 := by
    have e : 4 * S ^ 2 = (2 * S) ^ 2 := by ring
    rw [e, hgauss]; ring
  have hleS : 4 * S ≤ 6 * S ^ 2 := hle S
  have hClen : n ^ 2 + 4 * n ≤ 3 * n ^ 4 + 6 * n ^ 3 := hCle n
  have hCB : 3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2 = 2 * B := by
    rw [hBdef]; omega
  have hcancel : 8 * (3 * P) = 8 * (S ^ 2 * B) := by
    calc 8 * (3 * P)
        = 24 * P := by ring
      _ = n ^ 2 * (n + 1) ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2) := hdep
      _ = 4 * S ^ 2 * (3 * n ^ 4 + 6 * n ^ 3 - n ^ 2 - 4 * n + 2) := by rw [← h4S2]
      _ = 4 * S ^ 2 * (2 * B) := by rw [hCB]
      _ = 8 * (S ^ 2 * B) := by ring
  exact Nat.eq_of_mul_eq_mul_left (by norm_num) hcancel
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangePowSevenClosedForm`

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_pow_seven_faulhaber_triangular\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (Faulhaber-in-T tower — the **capstone** odd-power rung; compounds on `sum-range-pow-seven-closed-form`) |
| reference | Faulhaber's theorem for p=7: ∑k⁷ = (6T⁴−4T³+T²)/3 = T²(6T²−4T+1)/3. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993). |
| absence | machine-checked; the `i^7` flag resolves only to elliptic-curve coefficient code (Weierstrass normal forms), not a power-sum identity (rev c5ea00351c28, 2026-06-13). |
| difficulty | 4 |
| decomposition sketch | Substitute the sourced `sum-range-pow-seven-closed-form` (24∑k⁷ = n²(n+1)²(3n⁴+6n³−n²−4n+2)) and the Gauss sum T = n(n+1)/2, then close the polynomial identity by ring (cleanest over ℚ). The nested truncations in 6T²−4T+1 are safe for all n. 1–2 steps. **The other half of the crown's explanation:** 3∑k⁵ + 3∑k⁷ = T²(4T−1) + T²(6T²−4T+1) = 6T⁴, recovering `sum-range-pow-five-add-pow-seven` (∑k⁵+∑k⁷ = 2T⁴) as a corollary. |
| title | For every natural n, 3·(sum of i⁷ for i in 0..n) = (sum of i for i in 0..n)²·(6·(sum of i for i in 0..n)²−4·(sum of i for i in 0..n)+1); i.e. ∑k⁷ = T²(6T²−4T+1)/3 where T = ∑k. The seventh-power sum as a pure polynomial in the triangular number. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-seven-faulhaber-triangular --fork <your-github-user> --understood
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
