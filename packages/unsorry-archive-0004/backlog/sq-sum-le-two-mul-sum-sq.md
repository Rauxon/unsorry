# sq-sum-le-two-mul-sum-sq

For all real a,b, (a+b)² ≤ 2(a²+b²).

- **Source:** Classic elementary real inequality (#400 plan Phase 3 — library growth).
- **Reference:** For all real a,b, (a+b)² ≤ 2(a²+b²). Not a named mathlib lemma in this concrete polynomial/abs form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but not `nlinarith`/`positivity`, and `simp`/`aesop` over full Mathlib found no renamed duplicate.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** `nlinarith [sq_nonneg (a-b)]`. Verified to build (lake env lean).
