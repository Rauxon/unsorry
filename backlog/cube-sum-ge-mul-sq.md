# cube-sum-ge-mul-sq

For nonneg reals a,b, a³+b³ ≥ a²b+ab² (since a³+b³−a²b−ab² = (a+b)(a−b)²).

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3).
- **Reference:** For nonneg reals a,b, a³+b³ ≥ a²b+ab² (since a³+b³−a²b−ab² = (a+b)(a−b)²). Not a named mathlib lemma in this form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [mul_nonneg (add_nonneg ha hb) (sq_nonneg (a−b))]. Verified to build (lake env lean).
