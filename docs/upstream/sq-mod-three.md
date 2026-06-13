# Upstream packet: `sq-mod-three`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sq_mod_three (n : ℕ) (h : n % 3 ≠ 0) : n ^ 2 % 3 = 1 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SqModThree.lean` (theorem `sq_mod_three`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sq-mod-three.patch`](sq-mod-three.patch). The target path
`Mathlib/Unsorry/SqModThree.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Tactic.Ring

theorem sq_mod_three (n : ℕ) (h : n % 3 ≠ 0) : n ^ 2 % 3 = 1 := by
  obtain ⟨q, r, hr, rfl⟩ : ∃ q r, r < 3 ∧ n = 3 * q + r :=
    ⟨n / 3, n % 3, Nat.mod_lt _ (by omega), by omega⟩
  have hr' : r = 1 ∨ r = 2 := by omega
  rcases hr' with rfl | rfl
  · have e : (3 * q + 1) ^ 2 = 3 * (3 * q * q + 2 * q) + 1 := by ring
    rw [e]; omega
  · have e : (3 * q + 2) ^ 2 = 3 * (3 * q * q + 4 * q + 1) + 1 := by ring
    rw [e]; omega
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bsq_mod_three\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (thread-B depth-chain leaf) |
| reference | Quadratic residues mod 3; Hardy & Wright, An Introduction to the Theory of Numbers (congruence preliminaries); standard elementary number theory. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12); ZMod character machinery exists but the Nat-arithmetic statement is not present |
| difficulty | 2 |
| decomposition sketch | n % 3 is 1 or 2 by omega from h; in each case write n = 3k + r and close n^2 % 3 by Nat.add_mul_mod_self / omega. 1 step. |
| title | The square of any natural number not divisible by 3 leaves remainder 1 on division by 3: if n % 3 ≠ 0 then n^2 % 3 = 1. |

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
   python3 -m tools.upstream.raise_pr --goal sq-mod-three --fork <your-github-user> --understood
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
