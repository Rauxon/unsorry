# Upstream packet: `prime-sq-mod-twenty-four`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem prime_sq_mod_twenty_four (p : ℕ) (hp : Nat.Prime p) (h : 3 < p) : p ^ 2 % 24 = 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PrimeSqModTwentyFour.lean` (theorem `prime_sq_mod_twenty_four`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`prime-sq-mod-twenty-four.patch`](prime-sq-mod-twenty-four.patch). The target path
`Mathlib/Unsorry/PrimeSqModTwentyFour.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Prime.Basic

theorem prime_sq_mod_twenty_four (p : ℕ) (hp : Nat.Prime p) (h : 3 < p) : p ^ 2 % 24 = 1 := by
  have hodd : Odd p := hp.odd_of_ne_two (by omega)
  have h8 : p ^ 2 % 8 = 1 := odd_sq_mod_eight p hodd
  have h3 : p % 3 ≠ 0 := by
    intro h0
    rcases (hp.eq_one_or_self_of_dvd 3 (Nat.dvd_of_mod_eq_zero h0)) with h1 | h1 <;> omega
  have h3' : p ^ 2 % 3 = 1 := sq_mod_three p h3
  omega
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.OddSqModEight`
- `Unsorry.SqModThree`

## Dedup at mathlib HEAD

- mathlib revision scanned: `53e1c6c739e688b743937e039d9a1f0be7d27dc6`
- patterns: `\bprime_sq_mod_twenty_four\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (thread-B depth-chain mid; deps: odd-sq-mod-eight, sq-mod-three) |
| reference | Classic chestnut "24 divides p² − 1 for every prime p > 3"; Sierpiński, Elementary Theory of Numbers; standard olympiad/intro-NT result via CRT from the mod-8 and mod-3 facts. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12) |
| difficulty | 3 |
| decomposition sketch | p prime > 3 is odd (hp.odd_of_ne_two) and not divisible by 3 (else p = 3); apply dependency odd-sq-mod-eight to get p^2 % 8 = 1 and dependency sq-mod-three to get p^2 % 3 = 1; combine the coprime moduli 8 and 3 to p^2 % 24 = 1 (Nat.mod_mod_of_dvd / Nat.chineseRemainder or direct omega on the two congruences). 2-3 steps, reusing both proved leaves. |
| title | The square of every prime p > 3 leaves remainder 1 on division by 24: if p is prime and p > 3 then p^2 % 24 = 1. |

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
   python3 -m tools.upstream.raise_pr --goal prime-sq-mod-twenty-four --fork <your-github-user> --understood
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
