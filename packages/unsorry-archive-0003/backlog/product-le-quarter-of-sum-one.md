# product-le-quarter-of-sum-one

For nonneg reals a,b with a+b=1, ab ≤ 1/4.

- **Source:** Classic real inequality (library-growth batch, #400 plan Phase 3). The project had almost no inequalities; this seeds the SOS/nlinarith family.
- **Reference:** For nonneg reals a,b with a+b=1, ab ≤ 1/4. mathlib has the abstract Cauchy–Schwarz / power-mean lemmas but not this concrete polynomial form as a named lemma.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but **not** `nlinarith`/`positivity`, so the SOS gap is not one-shot-closable.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** `nlinarith [sq_nonneg (a-b)] (4ab = (a+b)²−(a−b)²)`. Verified to build (lake env lean).
