# Upstream packet: `sum-range-pow-five-closed-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_five_closed_form (n : ℕ) : 12 * ∑ i ∈ Finset.range (n + 1), i ^ 5 = n ^ 2 * (n + 1) ^ 2 * (2 * n ^ 2 + 2 * n - 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowFiveClosedForm.lean` (theorem `sum_range_pow_five_closed_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-five-closed-form.patch`](sum-range-pow-five-closed-form.patch). The target path
`Mathlib/Unsorry/SumRangePowFiveClosedForm.lean` is a **placeholder** — file placement and the
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

theorem sum_range_pow_five_closed_form (n : ℕ) :
    12 * ∑ i ∈ Finset.range (n + 1), i ^ 5 = n ^ 2 * (n + 1) ^ 2 * (2 * n ^ 2 + 2 * n - 1) := by
  induction n with
  | zero => norm_num
  | succ k ih =>
    have hsub : 2 * (k + 1) ^ 2 + 2 * (k + 1) - 1 = 2 * k ^ 2 + 6 * k + 3 := by
      have h : 2 * (k + 1) ^ 2 + 2 * (k + 1) = 2 * k ^ 2 + 6 * k + 3 + 1 := by ring
      rw [h, Nat.add_sub_cancel]
    rw [Finset.sum_range_succ, Nat.mul_add, ih, hsub]
    cases k with
    | zero => norm_num
    | succ m =>
      have hsub' : 2 * (m + 1) ^ 2 + 2 * (m + 1) - 1 = 2 * m ^ 2 + 6 * m + 3 := by
        have h : 2 * (m + 1) ^ 2 + 2 * (m + 1) = 2 * m ^ 2 + 6 * m + 3 + 1 := by ring
        rw [h, Nat.add_sub_cancel]
      rw [hsub']
      ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_pow_five_closed_form\b`
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
| reference | Faulhaber's formula, p = 5 case; Conway & Guy, The Book of Numbers (sums of powers); D. E. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993); CRC Standard Mathematical Tables. |
| absence | machine-checked; the `^ 5` pattern flags only Szemerédi-regularity bound files (Combinatorics/SimpleGraph/Regularity), verified unrelated — no Faulhaber p=5 closed form present (rev c5ea00351c28, 2026-06-12). Companion of the proved sum-range-pow-four-closed-form. |
| difficulty | 3 |
| decomposition sketch | Induction on n over Finset.range (n+1) with Finset.sum_range_succ, mirroring the proved pow-four goal; the step is a degree-6 polynomial identity closed by ring after rewriting 2*(n+1)^2 + 2*(n+1) - 1 = 2*n^2 + 6*n + 3 to avoid truncated subtraction. 1-2 steps. |
| title | For every natural n, 12 * (sum of i^5 for i in 0..n) = n^2 (n+1)^2 (2n^2 + 2n - 1); Faulhaber's closed form for fifth powers, ∑k^5 = (2n^6 + 6n^5 + 5n^4 - n^2)/12. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-five-closed-form --fork <your-github-user> --understood
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
