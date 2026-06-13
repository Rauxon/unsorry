# Upstream packet: `sum-range-fall-mul-choose`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_fall_mul_choose (n : ℕ) :
    4 * ∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k = n * (n - 1) * 2 ^ n := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeFallMulChoose.lean` (theorem `sum_range_fall_mul_choose`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-fall-mul-choose.patch`](sum-range-fall-mul-choose.patch). The target path
`Mathlib/Unsorry/SumRangeFallMulChoose.lean` is a **placeholder** — file placement and the
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

theorem sum_range_fall_mul_choose (n : ℕ) :
    4 * ∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k = n * (n - 1) * 2 ^ n := by
  have hkey : ∀ k : ℕ, k * (k - 1) + k = k ^ 2 := by
    intro k
    cases k with
    | zero => norm_num
    | succ j => show (j + 1) * j + (j + 1) = (j + 1) ^ 2; ring
  have hsum : (∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k)
        + ∑ k ∈ Finset.range (n + 1), k * n.choose k
      = ∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro k _
    rw [← hkey k]
    ring
  have hB : ∑ k ∈ Finset.range (n + 1), k * n.choose k = n * 2 ^ (n - 1) :=
    Nat.sum_range_mul_choose n
  have hS : 4 * ∑ k ∈ Finset.range (n + 1), k ^ 2 * n.choose k = n * (n + 1) * 2 ^ n :=
    sum_range_sq_mul_choose n
  have hE : 4 * (∑ k ∈ Finset.range (n + 1), k * (k - 1) * n.choose k)
        + 4 * (n * 2 ^ (n - 1)) = n * (n + 1) * 2 ^ n := by
    rw [← hB, ← Nat.mul_add, hsum, hS]
  have hF : n * (n - 1) * 2 ^ n + 4 * (n * 2 ^ (n - 1)) = n * (n + 1) * 2 ^ n := by
    cases n with
    | zero => norm_num
    | succ m =>
      rw [Nat.add_sub_cancel, pow_succ]
      ring
  exact Nat.add_right_cancel (hE.trans hF.symm)
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.SumRangeSqMulChoose`

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_fall_mul_choose\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (binomial-moment tower) |
| reference | Second factorial moment of the binomial distribution; from double absorption k(k−1)C(n,k) = n(n−1)C(n−2,k−2). Graham, Knuth & Patashnik, Concrete Mathematics, Ch. 5. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); mathlib has the first moment `Nat.sum_range_mul_choose` (∑k·C(n,k)) but not this falling-factorial moment. |
| difficulty | 3 |
| decomposition sketch | Twofold absorption: k(k−1)·C(n,k) = n(n−1)·C(n−2,k−2); sum over k reindexes to n(n−1)·∑C(n−2,j) = n(n−1)·2^(n−2). Or induct with Pascal's rule and close by ring. The k(k−1) over ℕ is 0 for k ∈ {0,1} (no truncation issue). 2 steps. |
| title | For every natural n, 4·(sum of k(k−1)·C(n,k) for k in 0..n) = n(n−1)·2ⁿ; the second falling-factorial moment ∑k(k−1)C(n,k) = n(n−1)2^(n−2). |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-fall-mul-choose --fork <your-github-user> --understood
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
