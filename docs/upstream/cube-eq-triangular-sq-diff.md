# Upstream packet: `cube-eq-triangular-sq-diff`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem cube_eq_triangular_sq_diff (n : ℕ) :
    (∑ i ∈ Finset.range n, i) ^ 2 + n ^ 3 = (∑ i ∈ Finset.range (n + 1), i) ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/CubeEqTriangularSqDiff.lean` (theorem `cube_eq_triangular_sq_diff`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`cube-eq-triangular-sq-diff.patch`](cube-eq-triangular-sq-diff.patch). The target path
`Mathlib/Unsorry/CubeEqTriangularSqDiff.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.Ring

theorem cube_eq_triangular_sq_diff (n : ℕ) :
    (∑ i ∈ Finset.range n, i) ^ 2 + n ^ 3 = (∑ i ∈ Finset.range (n + 1), i) ^ 2 := by
  rw [Finset.sum_range_succ]
  cases n with
  | zero => simp
  | succ k =>
    have h : (∑ i ∈ Finset.range (k + 1), i) * 2 = (k + 1) * k := by
      rw [Finset.sum_range_id_mul_two, Nat.add_sub_cancel]
    have expand : ((∑ i ∈ Finset.range (k + 1), i) + (k + 1)) ^ 2
        = (∑ i ∈ Finset.range (k + 1), i) ^ 2
          + (k + 1) * ((∑ i ∈ Finset.range (k + 1), i) * 2) + (k + 1) ^ 2 := by ring
    rw [expand, h]; ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bcube_eq_triangular_sq_diff\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (triangular-number gems — the term-wise Nicomachus; compounds on `nicomachus-sum-cubes`) |
| reference | The telescoping core of Nicomachus's identity ∑k³ = (∑k)² = Tₙ²: each cube n³ = Tₙ² − Tₙ₋₁². Conway & Guy, The Book of Numbers; Mathematics in Lean §5 (the Nicomachus exercise). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 2 |
| decomposition sketch | Tₙ = Tₙ₋₁ + n, so Tₙ² − Tₙ₋₁² = (Tₙ₋₁ + n)² − Tₙ₋₁² = 2n·Tₙ₋₁ + n²; with Tₙ₋₁ = (n−1)n/2 (Gauss) this is n²(n−1) + n² = n³ by ring. Reuses the proved `nicomachus-sum-cubes` as the global statement this refines. 1–2 steps. |
| title | For every natural n, Tₙ₋₁² + n³ = Tₙ², where Tₙ = ∑_{i≤n} i; equivalently n³ = Tₙ² − Tₙ₋₁², the per-term form of Nicomachus's theorem (the n-th cube is the n-th difference of squared triangular numbers). |

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
   python3 -m tools.upstream.raise_pr --goal cube-eq-triangular-sq-diff --fork <your-github-user> --understood
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
