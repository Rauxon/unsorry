# Upstream packet: `three-cubes-div-nine`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem three_cubes_div_nine (n : ℕ) : 9 ∣ n ^ 3 + (n + 1) ^ 3 + (n + 2) ^ 3 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/ThreeCubesDivNine.lean` (theorem `three_cubes_div_nine`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`three-cubes-div-nine.patch`](three-cubes-div-nine.patch). The target path
`Mathlib/Unsorry/ThreeCubesDivNine.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Tactic.Ring

theorem three_cubes_div_nine (n : ℕ) : 9 ∣ n ^ 3 + (n + 1) ^ 3 + (n + 2) ^ 3 := by
  obtain ⟨q, r, hr, rfl⟩ : ∃ q r, r < 3 ∧ n = 3 * q + r :=
    ⟨n / 3, n % 3, Nat.mod_lt _ (by omega), by omega⟩
  have hr' : r = 0 ∨ r = 1 ∨ r = 2 := by omega
  rcases hr' with rfl | rfl | rfl
  · exact ⟨9 * q ^ 3 + 9 * q ^ 2 + 5 * q + 1, by ring⟩
  · exact ⟨9 * q ^ 3 + 18 * q ^ 2 + 14 * q + 4, by ring⟩
  · exact ⟨9 * q ^ 3 + 27 * q ^ 2 + 29 * q + 11, by ring⟩
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bthree_cubes_div_nine\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities |
| reference | Classic introductory number-theory / olympiad exercise; Engel, Problem-Solving Strategies (divisibility chapter); Sierpiński, Elementary Theory of Numbers (PWN/North-Holland, 1988). |
| absence | machine-checked; the `9 ∣` pattern flags only Data/Nat/Digits/Div.lean (the digit-sum divisibility rule nine_dvd_iff), verified to be a different theorem — the consecutive-cubes fact is not present (rev c5ea00351c28, 2026-06-12). |
| difficulty | 2 |
| decomposition sketch | Expand to 3n^3 + 9n^2 + 15n + 9 (ring_nf), reduce 9 ∣ · to arithmetic mod 9 or mod 3 (the quotient is 3 ∣ n^3 + 2n = (n-1)n(n+1) mod 3, a product of three consecutive integers); alternatively cast to ZMod 9 and close by decide over the 9 residues via Nat.mod cases / omega. 1-2 steps. |
| title | For every natural n, 9 divides n^3 + (n+1)^3 + (n+2)^3; the sum of any three consecutive cubes is divisible by 9. |

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
   python3 -m tools.upstream.raise_pr --goal three-cubes-div-nine --fork <your-github-user> --understood
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
