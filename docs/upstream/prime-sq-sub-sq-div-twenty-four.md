# Upstream packet: `prime-sq-sub-sq-div-twenty-four`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem prime_sq_sub_sq_div_twenty_four (p q : ℕ) (hp : Nat.Prime p) (hq : Nat.Prime q) (hp3 : 3 < p) (hq3 : 3 < q) : (24 : ℤ) ∣ (p : ℤ) ^ 2 - (q : ℤ) ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PrimeSqSubSqDivTwentyFour.lean` (theorem `prime_sq_sub_sq_div_twenty_four`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`prime-sq-sub-sq-div-twenty-four.patch`](prime-sq-sub-sq-div-twenty-four.patch). The target path
`Mathlib/Unsorry/PrimeSqSubSqDivTwentyFour.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/


theorem prime_sq_sub_sq_div_twenty_four (p q : ℕ) (hp : Nat.Prime p) (hq : Nat.Prime q) (hp3 : 3 < p) (hq3 : 3 < q) : (24 : ℤ) ∣ (p : ℤ) ^ 2 - (q : ℤ) ^ 2 := by
  have h1 : p ^ 2 % 24 = 1 := prime_sq_mod_twenty_four p hp hp3
  have h2 : q ^ 2 % 24 = 1 := prime_sq_mod_twenty_four q hq hq3
  have c1 : (p : ℤ) ^ 2 % 24 = 1 := by exact_mod_cast h1
  have c2 : (q : ℤ) ^ 2 % 24 = 1 := by exact_mod_cast h2
  omega
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.PrimeSqModTwentyFour`

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bprime_sq_sub_sq_div_twenty_four\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (thread-B depth-chain root; deps: prime-sq-mod-twenty-four) |
| reference | Standard corollary of "p² ≡ 1 (mod 24) for primes p > 3"; Sierpiński, Elementary Theory of Numbers; common olympiad exercise. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12) |
| difficulty | 2 |
| decomposition sketch | Apply dependency prime-sq-mod-twenty-four to both p and q (p^2 % 24 = 1, q^2 % 24 = 1), lift to ℤ congruences (Int.emod_emod_of_dvd / Int.natCast_mod), and conclude 24 ∣ p^2 - q^2 since both squares are ≡ 1 (mod 24) (Int.ModEq.sub / dvd_sub of the two congruences). 1-2 steps, reusing the mid-level dependency. |
| title | For any two primes p, q both greater than 3, 24 divides p^2 - q^2 (stated over ℤ). |

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
   python3 -m tools.upstream.raise_pr --goal prime-sq-sub-sq-div-twenty-four --fork <your-github-user> --understood
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
