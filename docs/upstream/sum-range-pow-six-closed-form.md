# Upstream packet: `sum-range-pow-six-closed-form`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_pow_six_closed_form (n : ℕ) : 42 * ∑ i ∈ Finset.range (n + 1), i ^ 6 = n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangePowSixClosedForm.lean` (theorem `sum_range_pow_six_closed_form`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-pow-six-closed-form.patch`](sum-range-pow-six-closed-form.patch). The target path
`Mathlib/Unsorry/SumRangePowSixClosedForm.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.LinearCombination

theorem sum_range_pow_six_closed_form (n : ℕ) :
    42 * ∑ i ∈ Finset.range (n + 1), i ^ 6
      = n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) := by
  -- The truncated subtraction inside the last factor is genuine.
  have hle : 3 * n ≤ 3 * n ^ 4 + 6 * n ^ 3 := by
    have h4 : n ≤ n ^ 4 := Nat.le_self_pow (by norm_num) n
    omega
  -- Prove the identity over `ℤ`, where the subtraction is honest, by induction.
  have key : ∀ m : ℕ, (42 : ℤ) * ∑ i ∈ Finset.range (m + 1), (i : ℤ) ^ 6
      = (m : ℤ) * (m + 1) * (2 * m + 1) * (3 * m ^ 4 + 6 * m ^ 3 - 3 * m + 1) := by
    intro m
    induction m with
    | zero => simp
    | succ k ih =>
      rw [Finset.sum_range_succ, mul_add, ih]
      push_cast
      ring
  -- Transfer the `ℤ` equality back to `ℕ`.
  have hZ : ((42 * ∑ i ∈ Finset.range (n + 1), i ^ 6 : ℕ) : ℤ)
      = ((n * (n + 1) * (2 * n + 1) * (3 * n ^ 4 + 6 * n ^ 3 - 3 * n + 1) : ℕ) : ℤ) := by
    push_cast [Nat.cast_sub hle]
    linear_combination key n
  exact_mod_cast hZ
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_pow_six_closed_form\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (power-sum tower — the next rung above proved p=2..p=5) |
| reference | Faulhaber's formula, p = 6; Conway & Guy, The Book of Numbers (sums of powers); D. E. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993); CRC Standard Mathematical Tables. |
| absence | machine-checked; the `i ^ 6` pattern flags only the Weierstrass ℘-function file (Analysis/SpecialFunctions/Elliptic), verified unrelated — no specific sixth-power Faulhaber closed form present. mathlib carries only the general Bernoulli-number formula (`NumberTheory/Bernoulli.lean`, over ℚ), not this factored ℕ closed form — the same precedent under which the proved `sum-range-pow-four-closed-form` and `sum-range-pow-five-closed-form` were admitted (rev c5ea00351c28, 2026-06-13). |
| difficulty | 3 |
| decomposition sketch | Induction on n over Finset.range (n+1) with Finset.sum_range_succ, mirroring the proved pow-four/pow-five goals; the step is a degree-7 polynomial identity closed by ring after rewriting 3(n+1)⁴+6(n+1)³−3(n+1)+1 to avoid the truncated subtraction (n=0 closes by rfl). 1–2 steps. |
| title | For every natural n, 42·(sum of i⁶ for i in 0..n) = n(n+1)(2n+1)(3n⁴+6n³−3n+1); Faulhaber's closed form for sixth powers, ∑k⁶ = (6n⁷+21n⁶+21n⁵−7n³+n)/42. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-pow-six-closed-form --fork <your-github-user> --understood
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
