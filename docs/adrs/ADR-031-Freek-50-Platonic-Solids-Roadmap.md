# ADR-031: Roadmap to Freek #50 (The Number of Platonic Solids)

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-031 |
| **Initiative** | unsorry — driving a tracked-list result (Freek's 100) to closure |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## Context

We have proved and merged `platonic_schlafli_pairs`
(`library/Unsorry/PlatonicSchlafliCore.lean`):

```lean
theorem platonic_schlafli_pairs (p q : ℕ) (hp : 3 ≤ p) (hq : 3 ≤ q)
    (h : (p : ℚ)⁻¹ + (q : ℚ)⁻¹ > 2⁻¹) :
    (p, q) ∈ ({(3,3),(3,4),(4,3),(3,5),(5,3)} : Finset (ℕ × ℕ))
```

Issue #365 asks us to plan and build toward **Freek's 100 Theorems #50, "The Number of
Platonic Solids,"** whose Lean column is empty (only HOL Light). Scoping established three
facts that force this decision:

1. **The accepted bar is geometric.** Freek's list accepts HOL Light's `PLATONIC_SOLIDS`,
   a **biconditional over ℝ³ convex polytopes** — for a real 3-polytope `p` (`polytope p`,
   `aff_dim p = 3`) whose every 2-face has `m` edges and every vertex meets `n` edges, such
   a `p` **exists ⟺ `(m,n)` is one of the five pairs**. Both a *classification* direction
   and an *existence* direction, stated over a real-geometry face lattice (`face_of`,
   `aff_dim`, Euler–Poincaré).

2. **Our proved core is the keystone but only ~5% of that bar.** `platonic_schlafli_pairs`
   is exactly the final arithmetic step of the classification direction. The backlog entry
   already records the caveat: *"proves the combinatorial classification ONLY, no
   geometry."*

3. **mathlib lacks essentially the entire substrate.** A full source map of mathlib (pinned
   `c5ea0035`) found: no stated Euler polyhedron formula (`V − E + F = 2`), no convex-polytope
   face lattice (`face_of`/`aff_dim`), no regularity/Schläfli notion, no angle-defect /
   Gauss–Bonnet, and none of the five solids as objects. A faithful port therefore means
   **building a polytope face-lattice + Euler–Poincaré theory** — genuine mathlib-grade
   infrastructure, not the self-contained leaf lemmas the swarm is good at.

The project's product is **honesty** (ADR-024 lineage; the "honesty is the product" mandate).
Claiming #50 closed by a combinatorial surrogate would violate it.

## WH(Y) Decision Statement

**In the context of** an autonomous swarm that has proved the arithmetic core of Freek #50
and a project goal of moving tracked lists (Freek's 100) honestly,
**facing** a faithful bar that is a biconditional over ℝ³ convex polytopes whose entire
substrate (face lattice, Euler–Poincaré, the five constructions) is absent from mathlib and
is multi-file definitional infrastructure rather than swarm-sized leaves, together with the
honesty mandate that forbids claiming #50 via a combinatorial stand-in,
**we decided for** a **two-track staged roadmap**: **Track 1** seeds a self-contained
*abstract regular polyhedron* existence-biconditional (handshake + Euler ⟹ our proved core
for classification; five concrete `(V,E,F)` witnesses for existence) as a **labelled
combinatorial milestone** the swarm can close now and which reuses `platonic_schlafli_pairs`
as keystone; **Track 2** is the faithful ℝ³ port, decomposed into infrastructure milestones
(I1 face lattice, I2 Euler–Poincaré, I3 geometric handshake, I4 the five constructions, I5
assembly), sequenced behind a mathlib polytope substrate and pursued human-sponsored /
upstream,
**and neglected** (a) claiming #50 via Track 1 alone — dishonest, it sidesteps geometry;
(b) building the full ℝ³ polytope theory inside unsorry's goal pool now — it is multi-file
definitional infrastructure, the wrong tool for a leaf-lemma swarm, and duplicates work
mathlib should own; (c) abandoning #50 as out of reach — it discards the compounding value
of the proved core,
**to achieve** an honest, incremental path that banks a real citable result now, keeps the
keystone reused, and leaves a clearly-sequenced route to the faithful theorem,
**accepting that** Freek #50's Lean column stays **unclaimed** until Track 2's faithful ℝ³
biconditional passes Gate A; Track 1 ships labelled "combinatorial/Euler form — not the
geometric #50"; Track 2 is gated on infrastructure that may arrive on mathlib's own timeline;
and the realistic near-term public good remains the already-packet-ready arithmetic core
upstreamed under mathlib's AI policy (human-sponsored).

## Consequences

- **Positive.** A concrete, non-vacuous result ships within weeks and reuses the proved core
  (closing the phase-3 roadmap's open "drive a *result* through a dependency tree at depth"
  residue, Thread B). The path to the real #50 is written down and sequenced rather than
  hand-waved. Honesty is preserved by construction.
- **Negative / cost.** #50 is not closed by this ADR; Track 2 is large and partly outside
  the swarm's competence, dependent on mathlib growth or sponsored upstream work.
- **Guardrail.** No artifact (board, README, leaderboard, upstream packet) may state or imply
  that Freek #50 is closed in Lean until I5 lands through Gate A. Track-1 outputs are labelled
  "combinatorial/Euler form."

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Freek #50 roadmap spec (Track-1 criteria + Track-2 milestones) | Specification | specs/SPEC-031-A-Freek-50-Platonic-Solids-Roadmap.md |
| REF-2 | Arithmetic core (proved keystone) | Library | ../../library/Unsorry/PlatonicSchlafliCore.lean |
| REF-3 | Arithmetic-core upstream packet | Packet | ../upstream/platonic-schlafli-core.md |
| REF-4 | Backlog sourcing pipeline | Decision | ADR-012-Backlog-Sourcing.md |
| REF-5 | Dependency reuse across goals | Decision | ADR-014-Dependency-Reuse.md |
| REF-6 | Phase-3 roadmap (Threads B and C) | Proposal | ../proposals/phase3-roadmap.md |
| REF-7 | HOL Light `PLATONIC_SOLIDS` (the accepted bar) | External | https://www.cs.ru.nl/~freek/100/hol.html |
| REF-8 | Tracking issue | Issue | https://github.com/agenticsnz/unsorry/issues/365 |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-13 |
| Accepted | unsorry maintainers | 2026-06-13 |
