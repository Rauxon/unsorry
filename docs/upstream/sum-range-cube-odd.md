# Upstream packet: `sum-range-cube-odd`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_cube_odd (n : ℕ) : ∑ i ∈ Finset.range n, (2 * i + 1) ^ 3 = n ^ 2 * (2 * n ^ 2 - 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeCubeOdd.lean` (theorem `sum_range_cube_odd`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-cube-odd.patch`](sum-range-cube-odd.patch). The target path
`Mathlib/Unsorry/SumRangeCubeOdd.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

theorem sum_range_cube_odd (n : ℕ) :
    ∑ i ∈ Finset.range n, (2 * i + 1) ^ 3 = n ^ 2 * (2 * n ^ 2 - 1) := by
  induction n with
  | zero => norm_num
  | succ k ih =>
    have hsub : 2 * (k + 1) ^ 2 - 1 = 2 * k ^ 2 + 4 * k + 1 := by
      have h : 2 * (k + 1) ^ 2 = 2 * k ^ 2 + 4 * k + 1 + 1 := by ring
      rw [h, Nat.add_sub_cancel]
    rw [Finset.sum_range_succ, ih, hsub]
    cases k with
    | zero => norm_num
    | succ m =>
      have hsub' : 2 * (m + 1) ^ 2 - 1 = 2 * m ^ 2 + 4 * m + 1 := by
        have h : 2 * (m + 1) ^ 2 = 2 * m ^ 2 + 4 * m + 1 + 1 := by ring
        rw [h, Nat.add_sub_cancel]
      rw [hsub']
      ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `53e1c6c739e688b743937e039d9a1f0be7d27dc6`
- patterns: `\bsum_range_cube_odd\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities |
| reference | Standard finite-sum identity ∑(2k-1)^3 = n^2(2n^2-1); CRC Standard Mathematical Tables (sums of powers of odd integers); Gradshteyn & Ryzhik, Table of Integrals, Series, and Products (sums section). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12) |
| difficulty | 2 |
| decomposition sketch | Direct induction on n with Finset.sum_range_succ. Inductive step is a polynomial identity dischargeable by ring after rewriting 2*(n+1)^2 - 1 = 2*n^2 + 4*n + 1 to avoid truncated subtraction (n = 0 closes both sides to 0). 1-2 steps. |
| title | For every natural n, the sum of the cubes of the first n odd numbers equals n^2 * (2n^2 - 1); i.e. 1^3 + 3^3 + ... + (2n-1)^3 = n^2(2n^2 - 1). |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-cube-odd --fork <your-github-user> --understood
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
