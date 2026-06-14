# Upstream packet: `sum-range-fib-odd-index`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_fib_two_mul_add_one (n : ℕ) :
    ∑ i ∈ Finset.range n, Nat.fib (2 * i + 1) = Nat.fib (2 * n) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeFibOddIndex.lean` (theorem `sum_range_fib_two_mul_add_one`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-fib-odd-index.patch`](sum-range-fib-odd-index.patch). The target path
`Mathlib/Unsorry/SumRangeFibOddIndex.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Fib.Basic

theorem sum_range_fib_two_mul_add_one (n : ℕ) :
    ∑ i ∈ Finset.range n, Nat.fib (2 * i + 1) = Nat.fib (2 * n) := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih, show 2 * (k + 1) = 2 * k + 2 from by ring,
      Nat.fib_add_two]
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_fib_two_mul_add_one\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Fibonacci identities |
| reference | Vajda, Fibonacci & Lucas Numbers and the Golden Section (1989), identity (5); Koshy, Fibonacci and Lucas Numbers with Applications, Thm 5.1. mathlib has single-term `Nat.fib_two_mul` and the all-index `Nat.fib_succ_eq_succ_sum`, but no odd-indexed Fibonacci sum. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-13) |
| difficulty | 2 |
| decomposition sketch | L1 base n=0 (both sides 0). L2 induction via `Finset.sum_range_succ`; the step uses F(2n)+F(2n+1)=F(2n+2) (`Nat.fib_add_two`). L3 simp/omega to stitch F(2(n+1)) = F(2n+2). |
| title | For every natural n, ∑_{i<n} F(2i+1) = F(2n): the sum of the first n odd-indexed Fibonacci numbers F₁ + F₃ + ⋯ + F_{2n−1} equals F(2n). |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-fib-odd-index --fork <your-github-user> --understood
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
