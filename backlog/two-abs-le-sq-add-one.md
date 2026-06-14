# two-abs-le-sq-add-one

For all real x, 2

- **Source:** Classic elementary real inequality (#400 plan Phase 3 — library growth).
- **Reference:** For all real x, 2 Not a named mathlib lemma in this concrete polynomial/abs form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but not `nlinarith`/`positivity`, and `simp`/`aesop` over full Mathlib found no renamed duplicate.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** `x| ≤ x²+1 (the 1-variable AM-GM, abs form).|abs_cases x then nlinarith [sq_nonneg (x±1)]`. Verified to build (lake env lean).
