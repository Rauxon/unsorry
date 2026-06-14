# Upstream packet: `prod-range-one-add-inv`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem prod_range_one_add_inv (n : ℕ) : ∏ k ∈ Finset.Icc 1 n, ((k : ℚ) + 1) / k = (n : ℚ) + 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/ProdRangeOneAddInv.lean` (theorem `prod_range_one_add_inv`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`prod-range-one-add-inv.patch`](prod-range-one-add-inv.patch). The target path
`Mathlib/Unsorry/ProdRangeOneAddInv.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.Positivity

theorem prod_range_one_add_inv (n : ℕ) : ∏ k ∈ Finset.Icc 1 n, ((k : ℚ) + 1) / k = (n : ℚ) + 1 := by
  induction n with
  | zero => simp
  | succ n ih =>
    have h1 : 1 ≤ n + 1 := Nat.succ_le_succ (Nat.zero_le n)
    rw [Finset.prod_Icc_succ_top h1]
    rw [ih]
    have h2 : (n + 1 : ℚ) ≠ 0 := by positivity
    push_cast
    have h3 : (n : ℚ) + 1 = (n + 1 : ℚ) := by rfl
    rw [h3]
    rw [mul_comm]
    exact div_mul_cancel₀ _ h2
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bprod_range_one_add_inv\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Classic combinatorial / finite-sum identity (library-growth batch, #400 plan Phase 3). |
| reference | For all n, ∏_{k=1}^{n} (k+1)/k = n+1 over ℚ — a telescoping product. Not a named mathlib lemma (Vandermonde/Pascal are present but not these specific closed forms). |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — an unbounded ∑/∏ over a free n that the one-shot battery cannot close (and `simp`/`aesop` over full Mathlib did not find a renamed duplicate). |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14). |
| difficulty | 3 |
| decomposition sketch | induction + Finset.prod_Icc_succ_top + field_simp (telescope). Fully verified to build. |
| title | For all n, ∏_{k=1}^{n} (k+1)/k = n+1 over ℚ — a telescoping product. |

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
   python3 -m tools.upstream.raise_pr --goal prod-range-one-add-inv --fork <your-github-user> --understood
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
