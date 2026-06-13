# Upstream packet: `pow-four-add-sq-add-one-not-prime`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem pow_four_add_sq_add_one_not_prime (n : ℕ) (hn : 1 < n) :
    ¬ Nat.Prime (n ^ 4 + n ^ 2 + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PowFourAddSqAddOneNotPrime.lean` (theorem `pow_four_add_sq_add_one_not_prime`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`pow-four-add-sq-add-one-not-prime.patch`](pow-four-add-sq-add-one-not-prime.patch). The target path
`Mathlib/Unsorry/PowFourAddSqAddOneNotPrime.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

theorem pow_four_add_sq_add_one_not_prime (n : ℕ) (hn : 1 < n) :
    ¬ Nat.Prime (n ^ 4 + n ^ 2 + 1) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 2 := ⟨n - 2, by omega⟩
  have h : (m + 2) ^ 4 + (m + 2) ^ 2 + 1
      = (m ^ 2 + 5 * m + 7) * (m ^ 2 + 3 * m + 3) := by ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bpow_four_add_sq_add_one_not_prime\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (compositeness-via-factorization — the **capstone**; compounds on `pow-four-add-sq-add-one-factor`) |
| reference | Classic olympiad compositeness result, the x⁴+x²+1 analogue of the proved `not-prime-pow-four-add-four` (Sophie Germain). Engel, Problem-Solving Strategies (divisibility/compositeness). |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 3 |
| decomposition sketch | Apply the factorization leaf `pow-four-add-sq-add-one-factor` (over ℕ: n⁴+n²+1 = (n²+n+1)(n²−n+1)); for n > 1 both factors exceed 1 (n²−n+1 = n(n−1)+1 ≥ 3, n²+n+1 ≥ 7), so the number is a product of two factors > 1, hence not prime (`Nat.not_prime_mul` / `Nat.Prime` def). 2 steps, reusing the factorization leaf. Mirrors the proved `not-prime-pow-four-add-four`. |
| title | For every natural n > 1, n⁴ + n² + 1 is not prime; it factors as (n²+n+1)(n²−n+1) with both factors exceeding 1. |

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
   python3 -m tools.upstream.raise_pr --goal pow-four-add-sq-add-one-not-prime --fork <your-github-user> --understood
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
