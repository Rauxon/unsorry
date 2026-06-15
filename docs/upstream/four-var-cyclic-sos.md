# Upstream packet: `four-var-cyclic-sos`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem four_var_cyclic_sos (a b c d : ℝ) : a * b + b * c + c * d + d * a ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/FourVarCyclicSos.lean` (theorem `four_var_cyclic_sos`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`four-var-cyclic-sos.patch`](four-var-cyclic-sos.patch). The target path
`Mathlib/Unsorry/FourVarCyclicSos.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

theorem four_var_cyclic_sos (a b c d : ℝ) : a * b + b * c + c * d + d * a ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 := by
  have h1 : 0 ≤ (a - b) ^ 2 := sq_nonneg (a - b)
  have h2 : 0 ≤ (b - c) ^ 2 := sq_nonneg (b - c)
  have h3 : 0 ≤ (c - d) ^ 2 := sq_nonneg (c - d)
  have h4 : 0 ≤ (d - a) ^ 2 := sq_nonneg (d - a)
  linarith
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `c0477ad6b77161888036499c30cfaaeb0b50d46f`
- patterns: `\bfour_var_cyclic_sos\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Classic real inequality (library-growth batch, #400 plan Phase 3). The project had almost no inequalities; this seeds the SOS/nlinarith family. |
| reference | For all real a,b,c,d, a²+b²+c²+d² ≥ ab+bc+cd+da — the four-variable cyclic sum-of-squares bound. mathlib has the abstract Cauchy–Schwarz / power-mean lemmas but not this concrete polynomial form as a named lemma. |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but **not** `nlinarith`/`positivity`, so the SOS gap is not one-shot-closable. |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14). |
| difficulty | 2 |
| decomposition sketch | `nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-d), sq_nonneg (d-a)]`. Verified to build (lake env lean). |
| title | For all real a,b,c,d, a²+b²+c²+d² ≥ ab+bc+cd+da — the four-variable cyclic sum-of-squares bound. |

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
   python3 -m tools.upstream.raise_pr --goal four-var-cyclic-sos --fork <your-github-user> --understood
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
