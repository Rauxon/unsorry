# quartic-ge-cross

For all real a,b, a³b+ab³ ≤ a⁴+b⁴ (= (a−b)²(a²+ab+b²) ≥ 0).

- **Source:** Classic elementary real inequality (#400 plan Phase 3 — library growth).
- **Reference:** For all real a,b, a³b+ab³ ≤ a⁴+b⁴ (= (a−b)²(a²+ab+b²) ≥ 0). Not a named mathlib lemma in this concrete polynomial/abs form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but not `nlinarith`/`positivity`, and `simp`/`aesop` over full Mathlib found no renamed duplicate.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** `nlinarith with square hints`. Verified to build (lake env lean).
