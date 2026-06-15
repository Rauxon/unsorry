# thirty-dvd-pow-five-sub-self

For every integer n, 30 ∣ n⁵ − n (Fermat: 2,3,5 each divide n⁵−n).

- **Source:** Classic elementary number theory (library-growth batch, #400 plan Phase 3).
- **Reference:** For every integer n, 30 ∣ n⁵ − n (Fermat: 2,3,5 each divide n⁵−n). mathlib has `ZMod.pow_card` (Fermat) but not these specific named divisibility lemmas.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — stated over **all of ℤ**, so `decide` cannot enumerate and `omega` cannot see the nonlinear/modular structure.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** ZMod 30: decide ∀ m, m⁵−m=0, then ZMod.intCast_zmod_eq_zero_iff_dvd. Verified to build (lake env lean).
