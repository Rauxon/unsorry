# Upstream packet: `descartes-total-angular-defect`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem descartes_total_angular_defect (p q V E F : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (hV : 0 < V) (hF : 0 < F) (h1 : p * F = 2 * E) (h2 : q * V = 2 * E) (h3 : V + F = E + 2) :
    (V : ℝ) * (2 * Real.pi - (q : ℝ) * (((p : ℝ) - 2) / (p : ℝ)) * Real.pi) = 4 * Real.pi := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/DescartesTotalAngularDefect.lean` (theorem `descartes_total_angular_defect`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`descartes-total-angular-defect.patch`](descartes-total-angular-defect.patch). The target path
`Mathlib/Unsorry/DescartesTotalAngularDefect.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Tactic.FieldSimp

theorem descartes_total_angular_defect (p q V E F : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (hV : 0 < V) (hF : 0 < F) (h1 : p * F = 2 * E) (h2 : q * V = 2 * E)
    (h3 : V + F = E + 2) :
    (V : ℝ) * (2 * Real.pi - (q : ℝ) * (((p : ℝ) - 2) / (p : ℝ)) * Real.pi) =
      4 * Real.pi := by
  have hp_pos : (0 : ℝ) < p := by
    exact_mod_cast (Nat.lt_of_lt_of_le (by norm_num) hp)
  have hq_pos : (0 : ℝ) < q := by
    exact_mod_cast (Nat.lt_of_lt_of_le (by norm_num) hq)
  have hV_pos : (0 : ℝ) < V := by
    exact_mod_cast hV
  have hF_pos : (0 : ℝ) < F := by
    exact_mod_cast hF
  have h1R : (p : ℝ) * F = 2 * E := by
    exact_mod_cast h1
  have h2R : (q : ℝ) * V = 2 * E := by
    exact_mod_cast h2
  have h3R : (V : ℝ) + F = E + 2 := by
    exact_mod_cast h3
  have hdefect :
      (V : ℝ) * (2 - (q : ℝ) * (((p : ℝ) - 2) / (p : ℝ))) = 4 := by
    field_simp [ne_of_gt hp_pos]
    nlinarith [h1R, h2R, h3R, hq_pos, hV_pos, hF_pos]
  calc
    (V : ℝ) *
        (2 * Real.pi - (q : ℝ) * (((p : ℝ) - 2) / (p : ℝ)) * Real.pi) =
        ((V : ℝ) * (2 - (q : ℝ) * (((p : ℝ) - 2) / (p : ℝ)))) *
          Real.pi := by
      ring
    _ = 4 * Real.pi := by
      rw [hdefect]
```

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\bdescartes_total_angular_defect\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Freek #50 combinatorial classification, Track-1 completion (ADR-031; #400 plan Phase 1). |
| reference | Descartes' theorem: the total angular defect of an abstract regular {p,q} polyhedron is 4π — V(2π − q·(p−2)/p·π) = 4π. Not in mathlib (no abstract-regular-polyhedron theory). |
| absence | no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035). |
| triviality | machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14). |
| difficulty | 4 |
| decomposition sketch | derive V(2p+2q−pq)=4p from the constraints, then ℝ algebra (field_simp/ring). Concrete tetrahedron case verified. |
| title | Descartes' theorem: the total angular defect of an abstract regular {p,q} polyhedron is 4π — V(2π − q·(p−2)/p·π) = 4π. |

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
   python3 -m tools.upstream.raise_pr --goal descartes-total-angular-defect --fork <your-github-user> --understood
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
