# Upstream packet: `one-add-four-b-fourth-not-prime`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem one_add_four_b_fourth_not_prime (b : ℕ) (hb : 1 < b) :
    ¬ Nat.Prime (1 + 4 * b ^ 4) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/OneAddFourBFourthNotPrime.lean` (theorem `one_add_four_b_fourth_not_prime`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`one-add-four-b-fourth-not-prime.patch`](one-add-four-b-fourth-not-prime.patch). The target path
`Mathlib/Unsorry/OneAddFourBFourthNotPrime.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

theorem one_add_four_b_fourth_not_prime (b : ℕ) (hb : 1 < b) :
    ¬ Nat.Prime (1 + 4 * b ^ 4) := by
  obtain ⟨m, rfl⟩ : ∃ m, b = m + 2 := ⟨b - 2, by omega⟩
  have h : 1 + 4 * (m + 2) ^ 4
      = (2 * m ^ 2 + 6 * m + 5) * (2 * m ^ 2 + 10 * m + 13) := by ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bone_add_four_b_fourth_not_prime\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (compositeness-via-factorization — the Sophie Germain a=1 corollary) |
| reference | The a=1 case of Sophie Germain's identity a⁴+4b⁴ = (a²−2ab+2b²)(a²+2ab+2b²); a companion to the proved `not-prime-pow-four-add-four` (which is the b=1 case n⁴+4). Sierpiński, Elementary Theory of Numbers. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). mathlib has the Sophie Germain *identity* (`Algebra/Ring/Identities.pow_four_add_four_mul_pow_four'`) but not this compositeness corollary. |
| difficulty | 3 |
| decomposition sketch | Specialise mathlib's `pow_four_add_four_mul_pow_four'` at a=1 (or `ring`-derive) to 1+4b⁴ = (2b²−2b+1)(2b²+2b+1); for b > 1 both factors exceed 1 (2b²−2b+1 = 2b(b−1)+1 ≥ 5), so the number is composite (`Nat.not_prime_mul`). 2 steps. |
| title | For every natural b > 1, 1 + 4b⁴ is not prime; by the Sophie Germain factorization 1 + 4b⁴ = (2b²+2b+1)(2b²−2b+1), with both factors exceeding 1. |

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
   python3 -m tools.upstream.raise_pr --goal one-add-four-b-fourth-not-prime --fork <your-github-user> --understood
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
