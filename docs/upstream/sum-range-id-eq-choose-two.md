# Upstream packet: `sum-range-id-eq-choose-two`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sum_range_id_eq_choose_two (n : ℕ) :
    ∑ i ∈ Finset.range n, i = Nat.choose n 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SumRangeIdEqChooseTwo.lean` (theorem `sum_range_id_eq_choose_two`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sum-range-id-eq-choose-two.patch`](sum-range-id-eq-choose-two.patch). The target path
`Mathlib/Unsorry/SumRangeIdEqChooseTwo.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Nat.Choose.Basic

theorem sum_range_id_eq_choose_two (n : ℕ) :
    ∑ i ∈ Finset.range n, i = Nat.choose n 2 := by
  rw [Finset.sum_range_id, Nat.choose_two_right]
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bsum_range_id_eq_choose_two\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Gauss summation as a binomial coefficient |
| reference | The handshake identity ∑k = C(n,2); Graham, Knuth & Patashnik, Concrete Mathematics, §1. mathlib has `Finset.sum_range_id` and `Nat.choose_two_right` as separate closed forms (both n(n-1)/2) but not the theorem equating them. |
| absence | no-local-match — the two closed forms exist separately, the equating bridge does not (grep of pinned mathlib rev c5ea00351c, 2026-06-13) |
| difficulty | 2 |
| decomposition sketch | L1 rw `Finset.sum_range_id` (or Gauss_sum) to n(n-1)/2. L2 rw `Nat.choose_two_right` to n(n-1)/2. L3 close by rfl/omega — a genuine Post(A) ⊆ Pre(B) bridge between two existing mathlib closed forms (a clean compounding canary). |
| title | For every natural n, ∑_{i<n} i = C(n, 2): the Gauss sum 0 + 1 + ⋯ + (n−1) equals the binomial coefficient 'n choose 2'. |

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
   python3 -m tools.upstream.raise_pr --goal sum-range-id-eq-choose-two --fork <your-github-user> --understood
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
