# Upstream packet: `odd-fourth-power-mod-sixteen`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem odd_fourth_power_mod_sixteen (n : ℕ) (h : Odd n) : n ^ 4 % 16 = 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/OddFourthPowerModSixteen.lean` (theorem `odd_fourth_power_mod_sixteen`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`odd-fourth-power-mod-sixteen.patch`](odd-fourth-power-mod-sixteen.patch). The target path
`Mathlib/Unsorry/OddFourthPowerModSixteen.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Tactic.Ring

theorem odd_fourth_power_mod_sixteen (n : ℕ) (h : Odd n) : n ^ 4 % 16 = 1 := by
  have h8 : n ^ 2 % 8 = 1 := odd_sq_mod_eight n h
  obtain ⟨j, hj⟩ : ∃ j, n ^ 2 = 8 * j + 1 := ⟨n ^ 2 / 8, by omega⟩
  have hpow : n ^ 4 = 16 * (4 * j ^ 2 + j) + 1 := by
    have e : n ^ 4 = (n ^ 2) ^ 2 := by ring
    rw [e, hj]; ring
  rw [hpow]
  omega
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.OddSqModEight`

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bodd_fourth_power_mod_sixteen\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (fourth-power congruence tower — leaf; compounds on `odd-sq-mod-eight`) |
| reference | Standard elementary number theory: odd squares are ≡ 1 (mod 8), so odd fourth powers are ≡ 1 (mod 16). Hardy & Wright, An Introduction to the Theory of Numbers (quadratic-residue preliminaries). One power up from the proved `odd-sq-mod-eight`. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13). |
| difficulty | 2 |
| decomposition sketch | n⁴ = (n²)². Reuse the proved library lemma `odd-sq-mod-eight` (n² ≡ 1 mod 8 ⇒ n² = 8k+1), then n⁴ = (8k+1)² = 16(4k²+k)+1 ≡ 1 mod 16; close by omega / Nat.add_mul_mod_self_left. 1–2 steps. |
| title | The fourth power of every odd natural number leaves remainder 1 on division by 16: if n is odd then n⁴ % 16 = 1. |

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
   python3 -m tools.upstream.raise_pr --goal odd-fourth-power-mod-sixteen --fork <your-github-user> --understood
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
