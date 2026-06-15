# cauchy-schwarz-three-term

For all real a,b,c,x,y,z, (ax+by+cz)² ≤ (a²+b²+c²)(x²+y²+z²) — the 3-term Cauchy–Schwarz inequality.

- **Source:** Classic real inequality (library-growth batch, #400 plan Phase 3). The project had almost no inequalities; this seeds the SOS/nlinarith family.
- **Reference:** For all real a,b,c,x,y,z, (ax+by+cz)² ≤ (a²+b²+c²)(x²+y²+z²) — the 3-term Cauchy–Schwarz inequality. mathlib has the abstract Cauchy–Schwarz / power-mean lemmas but not this concrete polynomial form as a named lemma.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but **not** `nlinarith`/`positivity`, so the SOS gap is not one-shot-closable.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 3
- **Decomposition sketch:** `nlinarith [sq_nonneg (a*y-b*x), sq_nonneg (b*z-c*y), sq_nonneg (a*z-c*x)] (Lagrange identity SOS terms)`. Verified to build (lake env lean).
