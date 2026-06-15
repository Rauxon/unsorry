# two-abs-mul-le-sq-add-sq

For all real a,b, 2

- **Source:** Classic elementary real inequality (#400 plan Phase 3 — library growth).
- **Reference:** For all real a,b, 2 Not a named mathlib lemma in this concrete polynomial/abs form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but not `nlinarith`/`positivity`, and `simp`/`aesop` over full Mathlib found no renamed duplicate.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** `ab| ≤ a²+b² (the abs-form AM-GM).|abs_cases (a*b) then nlinarith [sq_nonneg (a±b)]`. Verified to build (lake env lean).
