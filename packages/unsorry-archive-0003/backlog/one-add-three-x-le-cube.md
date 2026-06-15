# one-add-three-x-le-cube

For x ≥ 0, 1+3x ≤ (1+x)³ (a Bernoulli instance, n=3).

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3 — library growth).
- **Reference:** For x ≥ 0, 1+3x ≤ (1+x)³ (a Bernoulli instance, n=3). Not a named mathlib lemma in this concrete form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [sq_nonneg x, mul_nonneg hx hx, x³≥0 hint]. Verified to build (lake env lean).
