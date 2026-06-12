# Upstream packet: `nicomachus-sum-cubes-triangular`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_cube_eq_triangular_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i ^ 3 = (n * (n + 1) / 2) ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/NicomachusSumCubesTriangular.lean` (theorem `sum_range_cube_eq_triangular_sq`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`nicomachus-sum-cubes-triangular.patch`](nicomachus-sum-cubes-triangular.patch). The target path
`Mathlib/Unsorry/NicomachusSumCubesTriangular.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals

theorem sum_range_cube_eq_triangular_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i ^ 3 = (n * (n + 1) / 2) ^ 2 := by
  rw [nicomachus_sum_cubes (n + 1), Finset.sum_range_id, Nat.add_sub_cancel,
    Nat.mul_comm (n + 1) n]
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.NicomachusSumCubes`

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bsum_range_cube_eq_triangular_sq\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Freek 100 / classic |
| reference | Nicomachus of Gerasa, Introduction to Arithmetic, Book II, in explicit closed form; Graham, Knuth & Patashnik, Concrete Mathematics, §2.5 (∑k^3 = (n(n+1)/2)^2). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 3 |
| decomposition sketch | Path A: prove the Nicomachus form ∑ i^3 = (∑ i)^2 (mirror the active goal), then rewrite ∑ i over range(n+1) as n(n+1)/2 via the Finset.sum_range_id closed form. Path B: direct induction, but the ℕ division means you must discharge 2 ∣ n*(n+1) via Nat.even_mul_succ_self so squaring commutes with /2. |
| title | For every natural n, the sum over i in 0..n of i^3 equals (n(n+1)/2)^2 (the explicit triangular-number form of Nicomachus' theorem). |

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
   python3 -m tools.upstream.raise_pr --goal nicomachus-sum-cubes-triangular --fork <your-github-user> --understood
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
