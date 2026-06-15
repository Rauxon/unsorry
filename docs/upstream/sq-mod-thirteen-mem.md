# Upstream packet: `sq-mod-thirteen-mem`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem sq_mod_thirteen_mem (n : ℕ) : n ^ 2 % 13 = 0 ∨ n ^ 2 % 13 = 1 ∨ n ^ 2 % 13 = 3 ∨ n ^ 2 % 13 = 4 ∨ n ^ 2 % 13 = 9 ∨ n ^ 2 % 13 = 10 ∨ n ^ 2 % 13 = 12 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/SqModThirteenMem.lean` (theorem `sq_mod_thirteen_mem`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`sq-mod-thirteen-mem.patch`](sq-mod-thirteen-mem.patch). The target path
`Mathlib/Unsorry/SqModThirteenMem.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Tactic.IntervalCases

theorem sq_mod_thirteen_mem (n : ℕ) : n ^ 2 % 13 = 0 ∨ n ^ 2 % 13 = 1 ∨ n ^ 2 % 13 = 3 ∨ n ^ 2 % 13 = 4 ∨ n ^ 2 % 13 = 9 ∨ n ^ 2 % 13 = 10 ∨ n ^ 2 % 13 = 12 := by
  have h : n ^ 2 % 13 = (n % 13) ^ 2 % 13 := by rw [Nat.pow_mod]
  rw [h]
  have hlt : n % 13 < 13 := Nat.mod_lt _ (by norm_num)
  interval_cases (n % 13) <;> decide
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `c0477ad6b77161888036499c30cfaaeb0b50d46f`
- patterns: `\bsq_mod_thirteen_mem\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | #400 Identity Engine (ADR-043) — power-residue family; promoted from candidate backlog (#610). |
| reference | The quadratic residues modulo 13 are exactly {0,1,3,4,9,10,12}. Not a named mathlib lemma in this form. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-15); generic-lemma instances dropped via direct mathlib grep (sub_dvd_pow_sub_pow / Odd.add_dvd_pow_add_pow / add_pow / centralBinom / Vandermonde / fib_add). |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-15). |
| difficulty | 3 |
| decomposition sketch | Nat.pow_mod, case-split on n%13, decide each branch. Verified to build (lake env lean). |
| title | The quadratic residues modulo 13 are exactly {0,1,3,4,9,10,12}. |

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
   python3 -m tools.upstream.raise_pr --goal sq-mod-thirteen-mem --fork <your-github-user> --understood
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
