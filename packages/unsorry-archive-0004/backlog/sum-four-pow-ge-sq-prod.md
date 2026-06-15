# sum-four-pow-ge-sq-prod

For all real a,b,c, a⁴+b⁴+c⁴ ≥ a²b²+b²c²+c²a².

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3).
- **Reference:** For all real a,b,c, a⁴+b⁴+c⁴ ≥ a²b²+b²c²+c²a². Not a named mathlib lemma in this form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [sq_nonneg (a²−b²), sq_nonneg (b²−c²), sq_nonneg (a²−c²)]. Verified to build (lake env lean).
