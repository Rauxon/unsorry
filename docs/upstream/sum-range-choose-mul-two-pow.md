# Upstream packet: `sum-range-choose-mul-two-pow`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_choose_mul_two_pow (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), n.choose k * 2 ^ k = 3 ^ n := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeChooseMulTwoPow.lean` (theorem `sum_range_choose_mul_two_pow`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-choose-mul-two-pow.patch`](sum-range-choose-mul-two-pow.patch). The target path
`Mathlib/Unsorry/SumRangeChooseMulTwoPow.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Choose.Sum

theorem sum_range_choose_mul_two_pow (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), n.choose k * 2 ^ k = 3 ^ n := by
  rw [show (3 : ℕ) = 2 + 1 by norm_num, add_pow]
  simp only [one_pow, mul_one]
  exact Finset.sum_congr rfl fun k _ => Nat.mul_comm _ _
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsum_range_choose_mul_two_pow\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (binomial-moment tower — the weighted row sum) |
| reference | Specialisation of the binomial theorem (1+x)ⁿ = ∑C(n,k)xᵏ at x=2. Standard; Concrete Mathematics, Ch. 5. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); mathlib has the unweighted row sum `Nat.sum_range_choose` (∑C(n,k) = 2ⁿ) and the general `add_pow`, but not this x=2 specialisation as a named ℕ lemma. |
| difficulty | 2 |
| decomposition sketch | Apply `add_pow` / `Commute.add_pow` with x=2, y=1 (or induct with Pascal's rule); 3ⁿ = (2+1)ⁿ. 1–2 steps. |
| title | For every natural n, the sum over k in 0..n of C(n,k)·2ᵏ equals 3ⁿ; the binomial theorem at x=2: ∑C(n,k)2ᵏ = (1+2)ⁿ = 3ⁿ. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-choose-mul-two-pow --fork <your-github-user> --understood
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
