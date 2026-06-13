# Upstream packet: `sum-range-sq-odd-closed-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_sq_odd_closed_form (n : ℕ) : 3 * ∑ i ∈ Finset.range n, (2 * i + 1) ^ 2 = n * (2 * n - 1) * (2 * n + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeSqOddClosedForm.lean` (theorem `sum_range_sq_odd_closed_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-sq-odd-closed-form.patch`](sum-range-sq-odd-closed-form.patch). The target path
`Mathlib/Unsorry/SumRangeSqOddClosedForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

theorem sum_range_sq_odd_closed_form (n : ℕ) :
    3 * ∑ i ∈ Finset.range n, (2 * i + 1) ^ 2 = n * (2 * n - 1) * (2 * n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    cases m with
    | zero => norm_num
    | succ k =>
      have h1 : 2 * (k + 1) - 1 = 2 * k + 1 := by omega
      have h2 : 2 * (k + 1 + 1) - 1 = 2 * k + 3 := by omega
      rw [h1, h2]
      ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_sq_odd_closed_form\b`
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
| reference | Standard finite-sum identity ∑(2k-1)^2 = n(2n-1)(2n+1)/3; Concrete Mathematics §2.5 exercises; Gradshteyn & Ryzhik, Table of Integrals, Series, and Products (sums section). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 2 |
| decomposition sketch | Direct induction on n with Finset.sum_range_succ. Inductive step is a polynomial identity dischargeable by ring after clearing the 2*n-1 truncated subtraction (handle n=0 separately, or rewrite 2*(n+1)-1 = 2*n+1 which avoids truncation in the step). 1-2 steps. |
| title | For every natural n, 3 * (sum of (2i+1)^2 for i in 0..n-1) = n(2n-1)(2n+1); i.e. 1^2+3^2+...+(2n-1)^2 = n(2n-1)(2n+1)/3. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-sq-odd-closed-form --fork <your-github-user> --understood
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
