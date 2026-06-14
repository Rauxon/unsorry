# Upstream packet: `eight-triangular-add-one-eq-odd-sq`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem eight_triangular_add_one_eq_odd_sq (n : ℕ) :
    8 * (∑ i ∈ Finset.range (n + 1), i) + 1 = (2 * n + 1) ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/EightTriangularAddOneEqOddSq.lean` (theorem `eight_triangular_add_one_eq_odd_sq`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`eight-triangular-add-one-eq-odd-sq.patch`](eight-triangular-add-one-eq-odd-sq.patch). The target path
`Mathlib/Unsorry/EightTriangularAddOneEqOddSq.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Linarith

theorem eight_triangular_add_one_eq_odd_sq (n : ℕ) :
    8 * (∑ i ∈ Finset.range (n + 1), i) + 1 = (2 * n + 1) ^ 2 := by
  have h : (∑ i ∈ Finset.range (n + 1), i) * 2 = (n + 1) * n := by
    rw [Finset.sum_range_id_mul_two, Nat.add_sub_cancel]
  nlinarith [h]
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\beight_triangular_add_one_eq_odd_sq\b`
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
| reference | The triangular-number characterisation: m is triangular iff 8m+1 is a perfect square (the forward direction). Conway & Guy, The Book of Numbers; standard recreational/elementary number theory. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 2 |
| decomposition sketch | Substitute the Gauss sum Tₙ = ∑_{i≤n} i = n(n+1)/2 (mathlib `Finset.sum_range_id` / `Gauss_sum`), then 8·n(n+1)/2 + 1 = 4n(n+1)+1 = (2n+1)² by ring. 1 step. **Compounds directly on the Gauss closed form.** |
| title | For every natural n, 8·Tₙ + 1 = (2n+1)², where Tₙ = ∑_{i≤n} i is the n-th triangular number; the classic "8T+1 is a perfect (odd) square" test for triangular numbers. |

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
   python3 -m tools.upstream.raise_pr --goal eight-triangular-add-one-eq-odd-sq --fork <your-github-user> --understood
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
