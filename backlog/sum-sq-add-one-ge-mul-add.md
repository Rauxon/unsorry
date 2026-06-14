# sum-sq-add-one-ge-mul-add

For all real x,y, x²+y²+1 ≥ xy+x+y.

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3).
- **Reference:** For all real x,y, x²+y²+1 ≥ xy+x+y. Not a named mathlib lemma in this form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [sq_nonneg (x−y), sq_nonneg (x−1), sq_nonneg (y−1)]. Verified to build (lake env lean).
