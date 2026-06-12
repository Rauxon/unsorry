# Upstream packet: `not-prime-pow-four-add-four`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem not_prime_pow_four_add_four {n : ℕ} (hn : 1 < n) : ¬ Nat.Prime (n ^ 4 + 4) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/NotPrimePowFourAddFour.lean` (theorem `not_prime_pow_four_add_four`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`not-prime-pow-four-add-four.patch`](not-prime-pow-four-add-four.patch). The target path
`Mathlib/Unsorry/NotPrimePowFourAddFour.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

theorem not_prime_pow_four_add_four {n : ℕ} (hn : 1 < n) : ¬ Nat.Prime (n ^ 4 + 4) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 2 := ⟨n - 2, by omega⟩
  have h : (m + 2) ^ 4 + 4 = (m ^ 2 + 2 * m + 2) * (m ^ 2 + 6 * m + 10) := by
    ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `53e1c6c739e688b743937e039d9a1f0be7d27dc6`
- patterns: `\bnot_prime_pow_four_add_four\b`
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
| reference | Sophie Germain's identity, compositeness corollary. Sierpiński, Elementary Theory of Numbers (PWN/North-Holland, 1988); standard olympiad result. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 3 |
| decomposition sketch | L1: instantiate pow_four_add_four_mul_pow_four with b=1 to get n^4+4 = (n^2-2n+2)*(n^2+2n+2). Watch ℕ subtraction — may need an ℤ instantiation or rewrite (n^2-2n+2 = (n-1)^2+1) to keep it well-defined. L2: show 1 < n^2-2n+2 when n>1 (both factors nontrivial, neither equals 1). L3: nontrivial factor |
| title | For every natural n with n > 1, n^4 + 4 is not prime, via the Sophie Germain factorization n^4+4 = (n^2-2n+2)(n^2+2n+2). |

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
   python3 -m tools.upstream.raise_pr --goal not-prime-pow-four-add-four --fork <your-github-user> --understood
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
