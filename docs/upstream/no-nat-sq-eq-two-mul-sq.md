# Upstream packet: `no-nat-sq-eq-two-mul-sq`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem no_nat_sq_eq_two_mul_sq : ¬ ∃ a b : ℕ, 0 < b ∧ a ^ 2 = 2 * b ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/NoNatSqEqTwoMulSq.lean` (theorem `no_nat_sq_eq_two_mul_sq`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`no-nat-sq-eq-two-mul-sq.patch`](no-nat-sq-eq-two-mul-sq.patch). The target path
`Mathlib/Unsorry/NoNatSqEqTwoMulSq.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/


theorem no_nat_sq_eq_two_mul_sq : ¬ ∃ a b : ℕ, 0 < b ∧ a ^ 2 = 2 * b ^ 2 := by
  classical
  rintro ⟨a, b, hbpos, hsq⟩
  let P : ℕ → Prop := fun n => ∃ a : ℕ, 0 < n ∧ a ^ 2 = 2 * n ^ 2
  have hPb : P b := ⟨a, hbpos, hsq⟩
  let m := Nat.find ⟨b, hPb⟩
  have hmP : P m := Nat.find_spec ⟨b, hPb⟩
  obtain ⟨x, hmpos, hxm⟩ := hmP
  obtain ⟨c, hc⟩ := square_eq_two_mul_square_left_even x m hxm
  obtain ⟨d, hd⟩ := square_eq_two_mul_square_right_even x m hxm
  have hhalf : c ^ 2 = 2 * d ^ 2 :=
    square_eq_two_mul_square_halves x m c d hc hd hxm
  have hdposlt : 0 < d ∧ d < m := positive_half_lt_of_even_nat m d hmpos hd
  have hdlt : d < Nat.find ⟨b, hPb⟩ := by
    simpa [m] using hdposlt.2
  exact (Nat.find_min ⟨b, hPb⟩ hdlt) ⟨c, hdposlt.1, hhalf⟩
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.NoNatSqEqTwoMulSqS1`
- `Unsorry.NoNatSqEqTwoMulSqS2`
- `Unsorry.NoNatSqEqTwoMulSqS3`
- `Unsorry.NoNatSqEqTwoMulSqS4`

## Dedup at mathlib HEAD

- mathlib revision scanned: `c0477ad6b77161888036499c30cfaaeb0b50d46f`
- patterns: `\bno_nat_sq_eq_two_mul_sq\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Freek 100 (#1, irrationality of √2), infinite-descent / parity form |
| reference | Classic infinite descent: a²=2b² ⟹ a even ⟹ b even ⟹ a strictly smaller solution. mathlib proves `irrational_sqrt_two` over ℝ via prime factorisation; this self-contained ℕ descent statement (no reals, no `sqrt`) is absent and is the elementary heart of Freek #1. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14) — the ℝ irrationality is a different, heavier statement; triviality-gate non-trivial (ADR-035) |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14) |
| difficulty | 4 |
| decomposition sketch | L1 lemma n² even ↔ n even (parity case split mod 2). L2 take a minimal witness a (Nat.find / strong induction). L3 a²=2b² ⟹ a even, set a=2c ⟹ b²=2c². L4 b<a contradicts minimality, closing by descent. Genuine well-founded descent — not one-shot. |
| title | There are no positive naturals a, b with a² = 2·b² — ¬∃ a b, 0 < b ∧ a² = 2b²: the irrationality of √2 in elementary infinite-descent form. |

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
   python3 -m tools.upstream.raise_pr --goal no-nat-sq-eq-two-mul-sq --fork <your-github-user> --understood
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
