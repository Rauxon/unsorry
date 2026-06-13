# Upstream packet: `pow-four-add-sq-add-one-factor`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem pow_four_add_sq_add_one_factor (n : ℤ) :
    n ^ 4 + n ^ 2 + 1 = (n ^ 2 + n + 1) * (n ^ 2 - n + 1) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/PowFourAddSqAddOneFactor.lean` (theorem `pow_four_add_sq_add_one_factor`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`pow-four-add-sq-add-one-factor.patch`](pow-four-add-sq-add-one-factor.patch). The target path
`Mathlib/Unsorry/PowFourAddSqAddOneFactor.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Algebra.Ring.Basic
import Mathlib.Tactic.Ring

theorem pow_four_add_sq_add_one_factor (n : ℤ) :
    n ^ 4 + n ^ 2 + 1 = (n ^ 2 + n + 1) * (n ^ 2 - n + 1) := by
  ring
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `dab4b77c11870a1b54bd22fa185abdbf74bada85`
- patterns: `\bpow_four_add_sq_add_one_factor\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | classic identities (compositeness-via-factorization — the factorization leaf) |
| reference | Standard algebra: x⁴+x²+1 = (x²+1)²−x² = (x²+x+1)(x²−x+1). Appears throughout olympiad number theory as the lever for showing n⁴+n²+1 is composite. Engel, Problem-Solving Strategies; Andreescu & Andrica, Number Theory. |
| absence | machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13); mathlib's `Algebra/Ring/Identities` has the Sophie Germain a⁴+4b⁴ and Brahmagupta identities but not this one. |
| difficulty | 2 |
| decomposition sketch | A polynomial identity over ℤ — `ring` closes it directly. 1 step. Feeds the compositeness corollary `pow-four-add-sq-add-one-not-prime`. |
| title | For every integer n, n⁴ + n² + 1 = (n² + n + 1)(n² − n + 1); the classic Aurifeuillian-style factorization of x⁴+x²+1 (a product of the two "cyclotomic-like" quadratics). |

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
   python3 -m tools.upstream.raise_pr --goal pow-four-add-sq-add-one-factor --fork <your-github-user> --understood
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
