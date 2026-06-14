# eight-dvd-consecutive-odd-sq-diff

For every integer n, 8 ∣ (2n+3)² − (2n+1)² (difference of consecutive odd squares).

- **Source:** Classic elementary inequality / number-theory fact (#400 plan Phase 3 — library growth).
- **Reference:** For every integer n, 8 ∣ (2n+3)² − (2n+1)² (difference of consecutive odd squares). Not a named mathlib lemma in this concrete form.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** the difference equals 8(n+1); ⟨n+1, by ring⟩. Verified to build (lake env lean).
