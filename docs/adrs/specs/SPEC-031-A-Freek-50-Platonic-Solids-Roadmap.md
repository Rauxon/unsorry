# SPEC-031-A: Roadmap to Freek #50 (The Number of Platonic Solids)

Implements: [ADR-031](../ADR-031-Freek-50-Platonic-Solids-Roadmap.md) · Status: Living · Updated: 2026-06-13

## The accepted bar (reference)

HOL Light `PLATONIC_SOLIDS` (Freek #50), paraphrased:

```
∀ m n.
  (∃ p : ℝ³ → Prop. polytope p ∧ aff_dim p = 3 ∧
     (∀ f. f face_of p ∧ aff_dim f = 2 → #{e | e face_of p ∧ aff_dim e = 1 ∧ e ⊆ f} = m) ∧
     (∀ v. v face_of p ∧ aff_dim v = 0 → #{e | e face_of p ∧ aff_dim e = 1 ∧ v ⊆ e} = n))
  ↔ (m,n) ∈ {(3,3),(4,3),(3,4),(5,3),(3,5)}
```

An **existence biconditional** over ℝ³ convex polytopes. Closing Freek #50 in Lean means
a kernel-checked statement of this shape over a real-geometry face lattice. Track 2 builds it;
Track 1 is its honest combinatorial shadow.

---

## Track 1 — abstract regular-polyhedron biconditional (swarm now)

A self-contained, definition-light statement that captures the *counting* heart of #50
without any real geometry, reusing the proved arithmetic core as its keystone.

### Statement (target `platonic-solids-combinatorial`)

```lean
/-- Incidence data of a regular polyhedron: `V` vertices, `E` edges, `F` faces, each face a
`p`-gon, each vertex of degree `q`, satisfying the two handshakes and Euler's relation.
This is the combinatorial skeleton of a Platonic solid — no ℝ³ geometry (ADR-031, Track 1). -/
structure AbstractRegularPolyhedron where
  V : ℕ
  E : ℕ
  F : ℕ
  p : ℕ
  q : ℕ
  hp : 3 ≤ p
  hq : 3 ≤ q
  hV : 0 < V
  hF : 0 < F
  hpF : p * F = 2 * E      -- face–edge handshake
  hqV : q * V = 2 * E      -- vertex–edge handshake
  hEuler : V + F = E + 2   -- Euler's relation

theorem abstract_platonic_pairs
    (m n : ℕ) :
    (∃ R : AbstractRegularPolyhedron, R.p = m ∧ R.q = n)
      ↔ (m, n) ∈ ({(3,3),(3,4),(4,3),(3,5),(5,3)} : Finset (ℕ × ℕ))
```

### Proof shape (decomposition sketch — a 2–4 leaf tree, reuses the core)

- **L1 (classification → arithmetic).** From `hpF`, `hqV` (with `hp`, `hF` giving `0 < E`)
  and `hEuler`: `F = 2E/p`, `V = 2E/q`, so `2E/p + 2E/q = E + 2`, hence over ℚ
  `1/p + 1/q = 1/2 + 1/E > 1/2`.
- **L2 (forward direction).** Feed L1's inequality into the proved
  `platonic_schlafli_pairs` (dependency reuse, ADR-014) ⇒ `(R.p, R.q)` is one of the five.
- **L3 (existence direction).** Exhibit the five witnesses (each obligation closed by
  `decide` / `norm_num`):

  | pair `(p,q)` | solid | `V` | `E` | `F` |
  |---|---|---|---|---|
  | (3,3) | tetrahedron | 4 | 6 | 4 |
  | (4,3) | cube | 8 | 12 | 6 |
  | (3,4) | octahedron | 6 | 12 | 8 |
  | (5,3) | dodecahedron | 20 | 30 | 12 |
  | (3,5) | icosahedron | 12 | 30 | 20 |

- **L4 (assembly).** Combine L2 (⟹) and L3 (⟸) into the biconditional.

### Acceptance criteria

1. `AbstractRegularPolyhedron` and `abstract_platonic_pairs` type-check under
   `lake build UnsorryGoals`; the target passes the ADR-012 absence pre-filter.
2. **Non-vacuity (phase-2 §0(3)).** The structure is inhabited — the five L3 witnesses
   are concrete and `decide`-checkable, so the ⟸ direction has real content, not a vacuous `∀`.
3. The ⟹ direction is discharged through `platonic_schlafli_pairs` (recorded as a reused
   dependency in the decomposition/library records), not re-proved from scratch.
4. The goal closes through Gate A (build `--wfail`, axiom audit, leanchecker replay, ADR-011
   binding) like any other proof.
5. **Labelling.** The board row, library entry, and any announcement describe this as the
   *combinatorial/Euler form* of the Platonic-solids count, explicitly **not** Freek #50.

---

## Track 2 — faithful ℝ³ port (staged, gated on mathlib)

Each is a milestone, not a leaf; most are mathlib-grade infrastructure. Ordered by dependency.

| ID | Milestone | Depends on | Nature |
|----|-----------|-----------|--------|
| **I1** | Convex-polytope **face lattice** in ℝ³ — `face_of`, `aff_dim`, vertices/edges/faces as faces of given dimension | mathlib `Convex`/extremePoints | mathlib infrastructure (sponsored/upstream) |
| **I2** | **Euler–Poincaré** for a 3-polytope ⇒ `V − E + F = 2` | I1 | mathlib infrastructure |
| **I3** | **Geometric handshake** — for a `{p,q}`-regular 3-polytope, `p·F = 2E`, `q·V = 2E`; with I2 ⇒ `1/p + 1/q > 1/2`, then apply the proved core | I1, I2 | bridge lemma(s); some swarm-leaf-sized |
| **I4** | **Existence** — construct tetra/cube/octa/dodeca/icosa as explicit ℝ³ polytopes and compute their face counts | I1 | hard constructions (sponsored) |
| **I5** | **Assembly** — the existence-biconditional matching HOL Light `PLATONIC_SOLIDS`; *this* is the Freek #50 closure | I3, I4 | assembly |

### Acceptance criteria

6. Track 2 milestones are tracked (board/issue) with the dependency edges above; I3's final
   step reuses `platonic_schlafli_pairs`.
7. **#50 closure ⟺ I5 through Gate A.** Until then no artifact claims Freek #50 closed in Lean.
8. I1/I2/I4 are pursued as **mathlib contributions** (human-sponsored, per the AI-contribution
   policy) or held pending mathlib growth; they are not forced into the autonomous goal pool as
   if they were leaf lemmas.

## Out of scope

The faithful Track-2 constructions' detailed proofs; the upstreaming narrative for the
arithmetic core (already packet-ready, `docs/upstream/platonic-schlafli-core.md`); any
angle-defect / Gauss–Bonnet alternative route (a different decomposition of #50, not chosen).
