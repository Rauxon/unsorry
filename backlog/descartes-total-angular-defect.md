# descartes-total-angular-defect

Descartes' theorem: the total angular defect of an abstract regular {p,q} polyhedron is 4π — V(2π − q·(p−2)/p·π) = 4π.

- **Source:** Freek #50 combinatorial classification, Track-1 completion (ADR-031; #400 plan Phase 1).
- **Reference:** Descartes' theorem: the total angular defect of an abstract regular {p,q} polyhedron is 4π — V(2π − q·(p−2)/p·π) = 4π. Not in mathlib (no abstract-regular-polyhedron theory).
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 4
- **Decomposition sketch:** derive V(2p+2q−pq)=4p from the constraints, then ℝ algebra (field_simp/ring). Concrete tetrahedron case verified.
- **Relationship to #365:** completes the Track-1 *combinatorial* classification of the Platonic solids. Geometric Freek #50 remains Track-2 (mathlib-substrate-gated).
