# Upstream packet: `sum-range-three-consecutive-product`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_mul_succ_mul_succ_succ (n : ℕ) :
    4 * ∑ i ∈ Finset.range n, i * (i + 1) * (i + 2)
      = (n - 1) * n * (n + 1) * (n + 2) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeThreeConsecutiveProduct.lean` (theorem `sum_range_mul_succ_mul_succ_succ`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-three-consecutive-product.patch`](sum-range-three-consecutive-product.patch). The target path
`Mathlib/Unsorry/SumRangeThreeConsecutiveProduct.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

theorem sum_range_mul_succ_mul_succ_succ_aux (m : ℕ) :
    4 * ∑ i ∈ Finset.range (m + 1), i * (i + 1) * (i + 2)
      = m * (m + 1) * (m + 2) * (m + 3) := by
  induction m with
  | zero => simp
  | succ j ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_mul_succ_mul_succ_succ\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | falling-factorial telescoping |
| reference | Graham, Knuth & Patashnik, Concrete Mathematics, §2.6 (summation by parts on falling factorials); ∑_{i=1}^{m} i(i+1)(i+2) = m(m+1)(m+2)(m+3)/4. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-13) |
| difficulty | 2 |
| decomposition sketch | L1 per-term telescoping identity 4·i(i+1)(i+2) = (i−1)i(i+1)(i+2) − (i−2)(i−1)i(i+1) (work in ℤ, cast to avoid ℕ-subtraction). L2 induction via `Finset.sum_range_succ`. L3 `ring`. |
| title | For every natural n, 4·∑_{i<n} i(i+1)(i+2) = (n−1)·n·(n+1)·(n+2): the telescoping sum of products of three consecutive integers (the tetrahedral-by-4 closed form). |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-three-consecutive-product --fork <your-github-user> --understood
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
