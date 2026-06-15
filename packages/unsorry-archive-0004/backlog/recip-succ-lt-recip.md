# recip-succ-lt-recip

For n ≥ 1, 1/(n+1) < 1/n over ℝ — the harmonic sequence is strictly decreasing.

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3 — library growth).
- **Reference:** For n ≥ 1, 1/(n+1) < 1/n over ℝ — the harmonic sequence is strictly decreasing. Not a named mathlib lemma in this concrete form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** one_div_lt_one_div_of_lt with the positivity side-goal. Verified to build (lake env lean).
