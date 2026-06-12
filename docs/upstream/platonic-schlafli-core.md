# Upstream packet: `platonic-schlafli-core`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem platonic_schlafli_pairs (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q) (h : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ > 2⁻¹) : (p, q) ∈ ({(3,3),(3,4),(4,3),(3,5),(5,3)} : Finset (ℕ × ℕ)) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PlatonicSchlafliCore.lean` (theorem `platonic_schlafli_pairs`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`platonic-schlafli-core.patch`](platonic-schlafli-core.patch). The target path
`Mathlib/Unsorry/PlatonicSchlafliCore.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/


theorem platonic_schlafli_pairs (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (h : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ > 2⁻¹) :
    (p, q) ∈ ({(3,3),(3,4),(4,3),(3,5),(5,3)} : Finset (ℕ × ℕ)) :=
  platonic_schlafli_pairs_of_bounds p q hp hq
    (platonic_schlafli_fst_lt_six p q hp hq h)
    (platonic_schlafli_snd_lt_six p q hp hq h) h
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.PlatonicSchlafliCoreS2`
- `Unsorry.PlatonicSchlafliCoreS3`
- `Unsorry.PlatonicSchlafliCoreS4`

## Dedup at mathlib HEAD

- mathlib revision scanned: `68c609a0f0fdc49ba2e09efa25146c80e28bc895`
- patterns: `\bplatonic_schlafli_pairs\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Freek 100 (#50) |
| reference | Freek Wiedijk's 100 Theorems #50 (The Number of Platonic Solids) — EMPTY in the Lean column (only HOL Light). Euclid, Elements XIII; Coxeter, Regular Polytopes, Ch. 1. The 1/p+1/q>1/2 reduction is… |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities |
| difficulty | 4 |
| decomposition sketch | Pure number-theory reduction (sidesteps geometry): L1: from h derive p < 6 (if p≥6,q≥3 then 1/p+1/q ≤ 1/6+1/3 = 1/2, contradiction); symmetric q < 6. L2: with 3≤p,q≤5 enumerate via interval_cases/decide. L3: check each of ≤9 pairs, keep the 5. CAVEAT: proves the combinatorial classification ONLY, no |
| title | For p,q >= 3, the only solutions to 1/p + 1/q > 1/2 are the five Schläfli pairs {3,3},{3,4},{4,3},{3,5},{5,3} — the bounded-arithmetic core of 'there are exactly five Platonic solids'. |

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
3. One lemma per PR; apply the patch to a fresh mathlib branch; expect the
   linter to want golfing (binder names, line length) — that editing is yours.
4. Record the outcome on the targets board (`in-discussion → pr-open →
   merged | declined`). **Declined is a valid, recorded result.**
