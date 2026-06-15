# Upstream packet: `dvd-264-pow-thirteen-sub-pow-three`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_264_pow_thirteen_sub_pow_three (n : ℤ) : (264 : ℤ) ∣ n ^ 13 - n ^ 3 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/Dvd264PowThirteenSubPowThree.lean` (theorem `dvd_264_pow_thirteen_sub_pow_three`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`dvd-264-pow-thirteen-sub-pow-three.patch`](dvd-264-pow-thirteen-sub-pow-three.patch). The target path
`Mathlib/Unsorry/Dvd264PowThirteenSubPowThree.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Int.ModEq
import Mathlib.Data.ZMod.Basic

theorem dvd_264_pow_thirteen_sub_pow_three (n : ℤ) : (264 : ℤ) ∣ n ^ 13 - n ^ 3 := by
  let x := n ^ 13 - n ^ 3
  have h8d : (8 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 8).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 8, a ^ 13 - a ^ 3 = 0) (n : ZMod 8)
  have h3d : (3 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 3).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 3, a ^ 13 - a ^ 3 = 0) (n : ZMod 3)
  have h11d : (11 : ℤ) ∣ x := (ZMod.intCast_zmod_eq_zero_iff_dvd x 11).mp <| by
    dsimp [x]
    simpa using (by decide : ∀ a : ZMod 11, a ^ 13 - a ^ 3 = 0) (n : ZMod 11)
  have h8 : x ≡ 0 [ZMOD (8 : ℤ)] := h8d.modEq_zero_int
  have h3 : x ≡ 0 [ZMOD (3 : ℤ)] := h3d.modEq_zero_int
  have h11 : x ≡ 0 [ZMOD (11 : ℤ)] := h11d.modEq_zero_int
  have h24 : x ≡ 0 [ZMOD (8 : ℤ) * 3] :=
    (Int.modEq_and_modEq_iff_modEq_mul (a := x) (b := 0) (m := 8) (n := 3) (by decide)).mp
      ⟨h8, h3⟩
  have h264 : x ≡ 0 [ZMOD ((8 : ℤ) * 3) * 11] :=
    (Int.modEq_and_modEq_iff_modEq_mul (a := x) (b := 0) (m := (8 : ℤ) * 3) (n := 11)
        (by decide)).mp
      ⟨h24, h11⟩
  have h264d : ((8 : ℤ) * 3) * 11 ∣ x := Int.modEq_zero_iff_dvd.mp h264
  change (264 : ℤ) ∣ x at h264d
  change (264 : ℤ) ∣ x
  exact h264d
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `c0477ad6b77161888036499c30cfaaeb0b50d46f`
- patterns: `\bdvd_264_pow_thirteen_sub_pow_three\b`
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
| reference | The integer 264 = 2^3·3·11 divides n^13 - n^3 for every integer n. Not a named mathlib lemma in this form. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-15); generic-lemma instances dropped via direct mathlib grep (sub_dvd_pow_sub_pow / Odd.add_dvd_pow_add_pow / add_pow / centralBinom / Vandermonde / fib_add). |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-15). |
| difficulty | 3 |
| decomposition sketch | ZMod 264 decide bridge on x^13 - x^3 = 0; 2^3 forces the n^3 factor, λ(odd part)=10 divides 10 for the n^10 lift. Verified to build (lake env lean). |
| title | The integer 264 = 2^3·3·11 divides n^13 - n^3 for every integer n. |

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
   python3 -m tools.upstream.raise_pr --goal dvd-264-pow-thirteen-sub-pow-three --fork <your-github-user> --understood
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
