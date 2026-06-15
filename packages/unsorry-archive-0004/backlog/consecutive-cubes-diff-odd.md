# consecutive-cubes-diff-odd

For every integer n, (n+1)³ − n³ is odd.

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3 — library growth).
- **Reference:** For every integer n, (n+1)³ − n³ is odd. Not a named mathlib lemma in this concrete form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** (n+1)³−n³ = 3n(n+1)+1; n(n+1) is even (Int.even_mul_succ_self), so the result is odd. Verified to build (lake env lean).
