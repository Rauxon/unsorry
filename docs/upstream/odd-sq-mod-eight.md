# Upstream packet: `odd-sq-mod-eight`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem odd_sq_mod_eight (n : ℕ) (h : Odd n) : n ^ 2 % 8 = 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/OddSqModEight.lean` (theorem `odd_sq_mod_eight`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`odd-sq-mod-eight.patch`](odd-sq-mod-eight.patch). The target path
`Mathlib/Unsorry/OddSqModEight.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.Group.Nat.Even
import Mathlib.Tactic.Ring

theorem odd_sq_mod_eight (n : ℕ) (h : Odd n) : n ^ 2 % 8 = 1 := by
  obtain ⟨k, rfl⟩ := h
  obtain ⟨m, hm⟩ : Even (k * (k + 1)) := Nat.even_mul_succ_self k
  have hsq : (2 * k + 1) ^ 2 = 4 * (k * (k + 1)) + 1 := by ring
  rw [hsq, hm]
  omega
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bodd_sq_mod_eight\b`
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
| reference | Odd squares are ≡ 1 (mod 8); Hardy & Wright, An Introduction to the Theory of Numbers (quadratic-residue preliminaries); standard elementary number theory. |
| absence | machine-checked; `% 8 = 1` flags only a local hypothesis inside NumberTheory/Fermat.lean and the χ₈ quadratic-character machinery in LegendreSymbol/JacobiSymbol — neither states the odd-square fact; targeted re-grep (sq_mod_eight, mod_eight_eq_one) no-local-match (rev c5ea00351c28, 2026-06-12). |
| difficulty | 2 |
| decomposition sketch | From Odd n obtain n = 2k+1; n^2 = 4k(k+1) + 1; L1: 2 ∣ k(k+1) (mathlib's Nat.even_mul_succ_self), hence 8 ∣ 4k(k+1); close by omega/Nat.add_mul_mod_self_left. 1-2 steps. |
| title | The square of every odd natural number leaves remainder 1 on division by 8: if n is odd then n^2 % 8 = 1. |

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
   python3 -m tools.upstream.raise_pr --goal odd-sq-mod-eight --fork <your-github-user> --understood
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
