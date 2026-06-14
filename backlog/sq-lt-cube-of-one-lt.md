# sq-lt-cube-of-one-lt

For x > 1, x² < x³.

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3 — library growth).
- **Reference:** For x > 1, x² < x³. Not a named mathlib lemma in this concrete form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [mul_pos (mul_pos x x) (x-1)] — x³−x² = x²(x−1) > 0. Verified to build (lake env lean).
