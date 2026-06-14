# Upstream packet: `sum-range-cube-mul-choose`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_cube_mul_choose (n : ℕ) :
    8 * ∑ k ∈ Finset.range (n + 1), k ^ 3 * n.choose k = n ^ 2 * (n + 3) * 2 ^ n := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeCubeMulChoose.lean` (theorem `sum_range_cube_mul_choose`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-cube-mul-choose.patch`](sum-range-cube-mul-choose.patch). The target path
`Mathlib/Unsorry/SumRangeCubeMulChoose.lean` is a **placeholder** — file placement and the
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

theorem sum_range_cube_mul_choose (n : ℕ) :
    8 * ∑ k ∈ Finset.range (n + 1), k ^ 3 * n.choose k
      = n ^ 2 * (n + 3) * 2 ^ n := by
  cases n with
  | zero => norm_num
  | succ m =>
    have hterm : ∀ i ∈ Finset.range (m + 1),
        (i + 1) ^ 3 * (m + 1).choose (i + 1)
          = (m + 1) * (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i) := by
      intro i _
      have habs : (m + 1) * m.choose i = (m + 1).choose (i + 1) * (i + 1) :=
        Nat.add_one_mul_choose_eq m i
      calc (i + 1) ^ 3 * (m + 1).choose (i + 1)
          = (m + 1).choose (i + 1) * (i + 1) * (i + 1) ^ 2 := by ring
        _ = (m + 1) * m.choose i * (i + 1) ^ 2 := by rw [habs]
        _ = (m + 1) * (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i) := by ring
    have h1 : ∑ k ∈ Finset.range (m + 1 + 1), k ^ 3 * (m + 1).choose k
        = (∑ i ∈ Finset.range (m + 1), (i + 1) ^ 3 * (m + 1).choose (i + 1))
          + 0 ^ 3 * (m + 1).choose 0 :=
      Finset.sum_range_succ' (fun k => k ^ 3 * (m + 1).choose k) (m + 1)
    have h2 : (∑ i ∈ Finset.range (m + 1), (i + 1) ^ 3 * (m + 1).choose (i + 1))
        = ∑ i ∈ Finset.range (m + 1),
            (m + 1) * (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i) :=
      Finset.sum_congr rfl hterm
    have h3 : (∑ i ∈ Finset.range (m + 1),
            (m + 1) * (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i))
        = (m + 1) * ∑ i ∈ Finset.range (m + 1),
            (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i) :=
      (Finset.mul_sum _ _ _).symm
    have h4 : (∑ i ∈ Finset.range (m + 1),
            (i ^ 2 * m.choose i + 2 * (i * m.choose i) + m.choose i))
        = (∑ i ∈ Finset.range (m + 1), i ^ 2 * m.choose i)
          + 2 * (∑ i ∈ Finset.range (m + 1), i * m.choose i)
          + ∑ i ∈ Finset.range (m + 1), m.choose i := by
      rw [Finset.sum_add_distrib, Finset.sum_add_distrib, ← Finset.mul_sum]
    rw [h1, h2, h3, h4, Nat.sum_range_mul_choose, Nat.sum_range_choose]
    cases m with
    | zero => norm_num [Finset.sum_range_succ, Finset.sum_range_zero]
    | succ j =>
      have hT2 := sum_range_sq_mul_choose (j + 1)
      have hj : j + 1 - 1 = j := by omega
      rw [hj]
      have e1 : (2 : ℕ) ^ (j + 1) = 2 * 2 ^ j := by rw [pow_succ]; ring
      have e2 : (2 : ℕ) ^ (j + 1 + 1) = 4 * 2 ^ j := by rw [pow_succ, pow_succ]; ring
      rw [e1] at hT2
      rw [e1, e2]
      set P := (2 : ℕ) ^ j with hP
      set S := ∑ k ∈ Finset.range (j + 1 + 1), k ^ 2 * (j + 1).choose k with hS
      have key2 : 8 * (j + 1 + 1) * S = 4 * (j + 1 + 1) ^ 2 * (j + 1) * P := by
        calc 8 * (j + 1 + 1) * S = 2 * (j + 1 + 1) * (4 * S) := by ring
          _ = 2 * (j + 1 + 1) * ((j + 1) * (j + 1 + 1) * (2 * P)) := by rw [hT2]
          _ = 4 * (j + 1 + 1) ^ 2 * (j + 1) * P := by ring
      calc 8 * ((j + 1 + 1) * (S + 2 * ((j + 1) * P) + 2 * P))
          = 8 * (j + 1 + 1) * S
              + (16 * (j + 1 + 1) * (j + 1) * P + 16 * (j + 1 + 1) * P) := by ring
        _ = 4 * (j + 1 + 1) ^ 2 * (j + 1) * P
              + (16 * (j + 1 + 1) * (j + 1) * P + 16 * (j + 1 + 1) * P) := by rw [key2]
        _ = (j + 1 + 1) ^ 2 * (j + 1 + 1 + 3) * (4 * P) := by ring
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangeSqMulChoose`

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_cube_mul_choose\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (binomial-moment tower — compounds on the proved `sum-range-sq-mul-choose`) |
| reference | The third moment of the binomial distribution scaled by 2ⁿ; Graham, Knuth & Patashnik, Concrete Mathematics, Ch. 5 (binomial coefficients / generating-function moments); Riordan, Combinatorial Identities. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 3 |
| decomposition sketch | One power up from the proved `sum-range-sq-mul-choose` (4∑k²C(n,k) = n(n+1)2ⁿ). Write k³ = k·k², use the absorption identity k·C(n,k) = n·C(n−1,k−1), reindex, or induct with `Finset.sum_range_succ` and Pascal's rule; close the resulting polynomial-in-n identity by ring. 2–3 steps. |
| title | For every natural n, 8·(sum of k³·C(n,k) for k in 0..n) = n²(n+3)·2ⁿ; the third binomial moment ∑k³C(n,k) = n²(n+3)2^(n−3). |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-cube-mul-choose --fork <your-github-user> --understood
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
