# platonic-solids-combinatorial

The combinatorial/Euler form of Freek #50: for an abstract regular polyhedron (V,E,F with a p-gon at every face, degree q at every vertex, the two handshakes p·F=2E / q·V=2E, and Euler V+F=E+2), such a structure with face/vertex parameters (m,n) EXISTS iff (m,n) ∈ {(3,3),(3,4),(4,3),(3,5),(5,3)}. NOT the geometric Freek #50 — no ℝ³ (ADR-031, Track 1).

- **Source:** Freek 100 (#50), combinatorial form (ADR-031 / SPEC-031-A, Track 1)
- **Reference:** Freek Wiedijk's 100 Theorems #50 (The Number of Platonic Solids); the faithful ℝ³ bar is HOL Light `PLATONIC_SOLIDS`. This target is the honest combinatorial shadow that reuses the proved `platonic_schlafli_pairs` (`library/Unsorry/PlatonicSchlafliCore.lean`) as keystone. Coxeter, Regular Polytopes, Ch. 1 (the {p,q} Schläfli counting).
- **Absence:** to be machine-checked (ADR-012) before seeding; the statement defines its own `AbstractRegularPolyhedron` structure, so absence is about the assembled biconditional, not the arithmetic core (already proved here).
- **Difficulty:** 3
- **Decomposition sketch:** L1 from the two handshakes + Euler (and 0<E from p≥3, 0<F) derive over ℚ that 1/p+1/q = 1/2 + 1/E > 1/2. L2 apply the proved `platonic_schlafli_pairs` (dependency reuse, ADR-014) for the ⟹ direction. L3 exhibit the five concrete witnesses — tetra (4,6,4), cube (8,12,6), octa (6,12,8), dodeca (20,30,12), icosa (12,30,20) — each field obligation by decide/norm_num, for the ⟸ direction. L4 assemble the biconditional. NON-VACUOUS: the five witnesses are concrete, so ⟸ has real content. LABEL: combinatorial/Euler form, explicitly not the geometric Freek #50 (which is Track 2, gated on a mathlib polytope face lattice + Euler–Poincaré; see SPEC-031-A).
