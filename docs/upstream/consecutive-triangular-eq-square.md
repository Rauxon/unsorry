# Upstream packet: `consecutive-triangular-eq-square`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem consecutive_triangular_eq_square (n : ℕ) :
    (∑ i ∈ Finset.range (n + 1), i) + (∑ i ∈ Finset.range n, i) = n ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/ConsecutiveTriangularEqSquare.lean` (theorem `consecutive_triangular_eq_square`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`consecutive-triangular-eq-square.patch`](consecutive-triangular-eq-square.patch). The target path
`Mathlib/Unsorry/ConsecutiveTriangularEqSquare.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring

theorem consecutive_triangular_eq_square (n : ℕ) :
    (∑ i ∈ Finset.range (n + 1), i) + (∑ i ∈ Finset.range n, i) = n ^ 2 := by
  induction n with
  | zero => simp
  | succ k ih =>
    have e1 : (∑ i ∈ Finset.range (k + 1 + 1), i)
        = (∑ i ∈ Finset.range (k + 1), i) + (k + 1) := Finset.sum_range_succ _ _
    have e2 : (∑ i ∈ Finset.range (k + 1), i)
        = (∑ i ∈ Finset.range k, i) + k := Finset.sum_range_succ _ _
    have hk : (k + 1) ^ 2 = k ^ 2 + 2 * k + 1 := by ring
    omega
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bconsecutive_triangular_eq_square\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (triangular-number gems — compounds on the Gauss sum) |
| reference | Theon of Smyrna's classical observation that consecutive triangular numbers sum to a square (Tₙ₋₁ + Tₙ = n²). Conway & Guy, The Book of Numbers; Heath, A History of Greek Mathematics. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 2 |
| decomposition sketch | Tₙ = ∑_{i≤n} i = n(n+1)/2 and Tₙ₋₁ = ∑_{i<n} i = (n−1)n/2 (Gauss); their sum = n(n+1)/2 + n(n−1)/2 = n² by ring. The n=0 case (empty second sum) closes trivially. 1 step. |
| title | For every natural n, Tₙ + Tₙ₋₁ = n², where Tₙ = ∑_{i≤n} i; the sum of two consecutive triangular numbers is a perfect square. |

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
   python3 -m tools.upstream.raise_pr --goal consecutive-triangular-eq-square --fork <your-github-user> --understood
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
