# sum-sq-add-three-ge-two-sum

For all real a,b,c, a²+b²+c²+3 ≥ 2(a+b+c).

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3).
- **Reference:** For all real a,b,c, a²+b²+c²+3 ≥ 2(a+b+c). Not a named mathlib lemma in this form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** nlinarith [sq_nonneg (a−1), sq_nonneg (b−1), sq_nonneg (c−1)]. Verified to build (lake env lean).
