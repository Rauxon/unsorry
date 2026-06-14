# sum-four-sq-ge-two-cross

For all real a,b,c,d, a²+b²+c²+d² ≥ 2ab+2cd.

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3).
- **Reference:** For all real a,b,c,d, a²+b²+c²+d² ≥ 2ab+2cd. Not a named mathlib lemma in this form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [sq_nonneg (a−b), sq_nonneg (c−d)]. Verified to build (lake env lean).
