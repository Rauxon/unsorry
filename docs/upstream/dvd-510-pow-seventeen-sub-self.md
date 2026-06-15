# Upstream packet: `dvd-510-pow-seventeen-sub-self`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_510_pow_seventeen_sub_self (n : ℤ) : (510 : ℤ) ∣ n ^ 17 - n := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/Dvd510PowSeventeenSubSelf.lean` (theorem `dvd_510_pow_seventeen_sub_self`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`dvd-510-pow-seventeen-sub-self.patch`](dvd-510-pow-seventeen-sub-self.patch). The target path
`Mathlib/Unsorry/Dvd510PowSeventeenSubSelf.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Int.ModEq
import Mathlib.Data.ZMod.Basic

theorem dvd_510_pow_seventeen_sub_self (n : ℤ) : (510 : ℤ) ∣ n ^ 17 - n := by
  let x := n ^ 17 - n
  have h2d : (2 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 2).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 2, a ^ 17 - a = 0) (n : ZMod 2)
  have h3d : (3 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 3).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 3, a ^ 17 - a = 0) (n : ZMod 3)
  have h5d : (5 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 5).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 5, a ^ 17 - a = 0) (n : ZMod 5)
  have h17d : (17 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 17).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 17, a ^ 17 - a = 0) (n : ZMod 17)
  have h2 : x ≡ 0 [ZMOD (2 : ℤ)] := h2d.modEq_zero_int
  have h3 : x ≡ 0 [ZMOD (3 : ℤ)] := h3d.modEq_zero_int
  have h5 : x ≡ 0 [ZMOD (5 : ℤ)] := h5d.modEq_zero_int
  have h17 : x ≡ 0 [ZMOD (17 : ℤ)] := h17d.modEq_zero_int
  have h6 : x ≡ 0 [ZMOD (2 : ℤ) * 3] :=
    (Int.modEq_and_modEq_iff_modEq_mul (a := x) (b := 0) (m := 2) (n := 3) (by decide)).mp
      ⟨h2, h3⟩
  have h30 : x ≡ 0 [ZMOD ((2 : ℤ) * 3) * 5] :=
    (Int.modEq_and_modEq_iff_modEq_mul (a := x) (b := 0) (m := (2 : ℤ) * 3) (n := 5)
        (by decide)).mp
      ⟨h6, h5⟩
  have h510 : x ≡ 0 [ZMOD (((2 : ℤ) * 3) * 5) * 17] :=
    (Int.modEq_and_modEq_iff_modEq_mul (a := x) (b := 0) (m := ((2 : ℤ) * 3) * 5)
        (n := 17) (by decide)).mp
      ⟨h30, h17⟩
  have h510d : (((2 : ℤ) * 3) * 5) * 17 ∣ x := Int.modEq_zero_iff_dvd.mp h510
  change (510 : ℤ) ∣ x at h510d
  change (510 : ℤ) ∣ x
  exact h510d
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `c0477ad6b77161888036499c30cfaaeb0b50d46f`
- patterns: `\bdvd_510_pow_seventeen_sub_self\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | #400 Identity Engine (ADR-043) — divisibility family; promoted from candidate backlog (#610). |
| reference | 510 divides n^17 minus n for every integer n. Not a named mathlib lemma in this form. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-15); generic-lemma instances dropped via direct mathlib grep (sub_dvd_pow_sub_pow / Odd.add_dvd_pow_add_pow / add_pow / centralBinom / Vandermonde / fib_add). |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-15). |
| difficulty | 3 |
| decomposition sketch | ∀ x : ZMod 510, x^17 - x = 0 by decide; ZMod.intCast_zmod_eq_zero_iff_dvd. 510 = 2·3·5·17. Verified to build (lake env lean). |
| title | 510 divides n^17 minus n for every integer n. |

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
   python3 -m tools.upstream.raise_pr --goal dvd-510-pow-seventeen-sub-self --fork <your-github-user> --understood
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
