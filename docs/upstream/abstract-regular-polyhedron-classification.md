# Upstream packet: `abstract-regular-polyhedron-classification`

Status: packet-ready · generated mechanically (ADR-020 / SPEC-020-A) · sponsor: Chris Barlow

## The statement (as proved here)

```lean
import Mathlib

theorem abstract_regular_polyhedron_classification
    (p q V E F : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q) (hV : 0 < V) (hF : 0 < F)
    (hpF : p * F = 2 * E) (hqV : q * V = 2 * E) (hEuler : V + F = E + 2) :
    (p, q) ∈ ({(3, 3), (3, 4), (4, 3), (3, 5), (5, 3)} : Finset (ℕ × ℕ)) := by
  sorry
```

Kernel-verified on `main`: `library/Unsorry/AbstractRegularPolyhedronClassification.lean` (theorem `abstract_regular_polyhedron_classification`),
through Gate A (build `--wfail`, axiom audit against the standard whitelist, leanchecker
kernel replay, regenerated ADR-011 binding obligation).

## Proposed contribution

The `git apply`-able new-file diff is at [`abstract-regular-polyhedron-classification.patch`](abstract-regular-polyhedron-classification.patch). The target path
`Mathlib/Unsorry/AbstractRegularPolyhedronClassification.lean` is a **placeholder** — file placement and the
final name are Zulip questions, not ours to decide. Content:

```lean
/-
Copyright (c) 2026 Chris Barlow. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Chris Barlow
-/
import Mathlib

theorem abstract_regular_polyhedron_classification
    (p q V E F : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q) (hV : 0 < V) (hF : 0 < F)
    (hpF : p * F = 2 * E) (hqV : q * V = 2 * E) (hEuler : V + F = E + 2) :
    (p, q) ∈ ({(3, 3), (3, 4), (4, 3), (3, 5), (5, 3)} : Finset (ℕ × ℕ)) := by
  -- E > 0, since 2E = p·F ≥ 3·1.
  have hE : 0 < E := by
    have h0 : 0 < p * F := Nat.mul_pos (by omega) hF
    rw [hpF] at h0; omega
  -- The combinatorial heart: 2E·(2p + 2q − pq) = 4pq > 0, so 2p + 2q > pq.
  have key_ineq : (p : ℤ) * q < 2 * p + 2 * q := by
    have A : (p : ℤ) * F = 2 * E := by exact_mod_cast hpF
    have B : (q : ℤ) * V = 2 * E := by exact_mod_cast hqV
    have C : (V : ℤ) + F = E + 2 := by exact_mod_cast hEuler
    have hEZ : (0 : ℤ) < E := by exact_mod_cast hE
    have hpZ : (0 : ℤ) < p := by exact_mod_cast (show 0 < p by omega)
    have hqZ : (0 : ℤ) < q := by exact_mod_cast (show 0 < q by omega)
    -- 4pE + 4qE = 2pqE + 4pq  (from 2pq·Euler, substituting the handshakes)
    have ident : 4 * (p : ℤ) * E + 4 * q * E = 2 * p * q * E + 4 * p * q := by
      linear_combination (2 * (p : ℤ) * q) * C - (2 * (q : ℤ)) * A - (2 * (p : ℤ)) * B
    nlinarith [ident, hEZ, mul_pos hpZ hqZ]
  -- Convert 2p + 2q > pq into the inverse form the core consumes.
  have key : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ > 2⁻¹ := by
    have hpQ : (0 : ℚ) < (p : ℚ) := by exact_mod_cast (show 0 < p by omega)
    have hqQ : (0 : ℚ) < (q : ℚ) := by exact_mod_cast (show 0 < q by omega)
    have hpne : (p : ℚ) ≠ 0 := ne_of_gt hpQ
    have hqne : (q : ℚ) ≠ 0 := ne_of_gt hqQ
    have hpq : (p : ℚ) * q < 2 * p + 2 * q := by exact_mod_cast key_ineq
    rw [gt_iff_lt, ← sub_pos]
    have hrw : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ - 2⁻¹
        = (2 * (p : ℚ) + 2 * q - p * q) / (2 * (p * q)) := by
      field_simp
      ring
    rw [hrw]
    apply div_pos
    · linarith [hpq]
    · positivity
  exact platonic_schlafli_pairs p q hp hq key
```

## Dependencies on sibling lemmas

The proof imports unsorry library modules that mathlib does not have —
the sponsor must **bundle or inline** them (or upstream the dependency
first):

- `Unsorry.PlatonicSchlafliCore`

## Dedup at mathlib HEAD

- mathlib revision scanned: `6923f2f17585e9f2ef76e10ad91efe1b9cb8500d`
- patterns: `\babstract_regular_polyhedron_classification\b`
- verdict: **no-local-match**
- matches:
- none

A name-grep is a pre-filter, not a proof of absence; the kernel build at HEAD
(`tools/upstream/verify_head.sh`) is the strong evidence and its result belongs in the
PR conversation.

## Provenance dossier

| Field | Value |
|---|---|
| source | Freek 100 (#50), combinatorial form (ADR-031 / SPEC-031-A, Track 1) |
| reference | The classification half of 'there are exactly five Platonic solids', reusing the proved `platonic_schlafli_pairs` as keystone (Euler + handshake ⟹ 1/p+1/q > 1/2 ⟹ the five pairs). Coxeter, Regular Polytopes, Ch. 1. NOT the geometric Freek #50 (that is Track 2, gated on a mathlib polytope face lattice + Euler–Poincaré). |
| absence | no-local-match — a novel composite statement; the keystone `platonic_schlafli_pairs` lives in this library, not mathlib (grep of pinned mathlib rev c5ea00351c, 2026-06-13) |
| difficulty | 3 |
| decomposition sketch | L1 from the two handshakes (with 0<E from p≥3, F>0) and Euler derive over ℚ that 1/p + 1/q = 1/2 + 1/E > 1/2. L2 apply the proved `platonic_schlafli_pairs` (dependency reuse, ADR-014). NON-VACUOUS: the five solids (e.g. tetra V4 E6 F4) satisfy the hypotheses. This is the ⟹ direction only — existence (the five witnesses) is a separate target. |
| title | For an abstract regular polyhedron — V vertices, E edges, F faces that are p-gons, vertices of degree q — with the two handshakes p·F = 2E and q·V = 2E and Euler's relation V + F = E + 2, the pair (p, q) is one of the five Platonic Schläfli pairs {(3,3),(3,4),(4,3),(3,5),(5,3)}. The classification (⟹) half of Freek #50 in combinatorial/Euler form. |

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
   python3 -m tools.upstream.raise_pr --goal abstract-regular-polyhedron-classification --fork <your-github-user> --understood
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
