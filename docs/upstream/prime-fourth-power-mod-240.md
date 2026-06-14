# Upstream packet: `prime-fourth-power-mod-240`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem prime_fourth_power_mod_240 (p : ℕ) (hp : Nat.Prime p) (h : 5 < p) : p ^ 4 % 240 = 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PrimeFourthPowerMod240.lean` (theorem `prime_fourth_power_mod_240`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`prime-fourth-power-mod-240.patch`](prime-fourth-power-mod-240.patch). The target path
`Mathlib/Unsorry/PrimeFourthPowerMod240.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Data.Nat.ModEq

theorem prime_fourth_power_mod_240 (p : ℕ) (hp : Nat.Prime p) (h : 5 < p) :
    p ^ 4 % 240 = 1 := by
  -- `p` avoids each prime factor of `240`.
  have hodd : Odd p := hp.odd_of_ne_two (by omega)
  have h3 : p % 3 ≠ 0 := by
    intro hmod
    rcases hp.eq_one_or_self_of_dvd 3 (Nat.dvd_of_mod_eq_zero hmod) with h' | h' <;> omega
  have h5 : p % 5 ≠ 0 := by
    intro hmod
    rcases hp.eq_one_or_self_of_dvd 5 (Nat.dvd_of_mod_eq_zero hmod) with h' | h' <;> omega
  -- The congruence modulo each factor of `240`.
  have e16 : p ^ 4 ≡ 1 [MOD 16] := by
    show p ^ 4 % 16 = 1 % 16
    rw [odd_fourth_power_mod_sixteen p hodd]
  have e3 : p ^ 4 ≡ 1 [MOD 3] := by
    show p ^ 4 % 3 = 1 % 3
    rw [fourth_power_mod_three p h3]
  have e5 : p ^ 4 ≡ 1 [MOD 5] := by
    show p ^ 4 % 5 = 1 % 5
    rw [fourth_power_mod_five p h5]
  -- Combine across the pairwise-coprime factors.
  have e48 : p ^ 4 ≡ 1 [MOD 48] :=
    (Nat.modEq_and_modEq_iff_modEq_mul (by decide)).mp ⟨e16, e3⟩
  have e240 : p ^ 4 ≡ 1 [MOD 240] :=
    (Nat.modEq_and_modEq_iff_modEq_mul (by decide)).mp ⟨e48, e5⟩
  have h240 : p ^ 4 % 240 = 1 % 240 := e240
  omega
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.OddFourthPowerModSixteen`
- `Unsorry.FourthPowerModThree`
- `Unsorry.FourthPowerModFive`

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bprime_fourth_power_mod_240\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (fourth-power congruence tower — **root**; deps: the mod-16, mod-3, mod-5 leaves) |
| reference | Classic competition gem "240 ∣ p⁴ − 1 for every prime p > 5", one power up from the proved-here "24 ∣ p² − 1 for primes p > 3" (binto-labs, `prime-sq-mod-twenty-four`). 240 = 16·3·5; the result is CRT over the three coprime moduli. Sierpiński, Elementary Theory of Numbers; standard olympiad result. |
| absence | machine-checked; the `240` pattern flags only numeric literals in analysis / modular-forms code (the E₄ Eisenstein-series coefficient `240`), verified unrelated — no p⁴-mod-240 congruence present (rev c5ea00351c28, 2026-06-13). |
| difficulty | 4 |
| decomposition sketch | p prime > 5 is odd (not 2), not divisible by 3 (not 3), not divisible by 5 (not 5) — each from primality + the bound. Apply the three leaves: `odd-fourth-power-mod-sixteen` (p⁴ ≡ 1 mod 16), `fourth-power-mod-three` (p⁴ ≡ 1 mod 3), `fourth-power-mod-five` (p⁴ ≡ 1 mod 5). Combine over the pairwise-coprime moduli 16, 3, 5 (lcm 240) to p⁴ ≡ 1 mod 240 — same CRT shape as `prime-sq-mod-twenty-four`, closable by omega on the three congruences. 3 steps, reusing all three leaves. |
| title | The fourth power of every prime p > 5 leaves remainder 1 on division by 240: if p is prime and p > 5 then p⁴ % 240 = 1. |

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
   python3 -m tools.upstream.raise_pr --goal prime-fourth-power-mod-240 --fork <your-github-user> --understood
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
