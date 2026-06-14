# four-consecutive-product-add-one-square

For every natural n, the product of four consecutive integers n(n+1)(n+2)(n+3), plus one, is a perfect square.

- **Source:** Classic elementary-number-theory identity (the "four consecutive integers" square).
- **Reference:** n(n+1)(n+2)(n+3) + 1 = (n² + 3n + 1)². mathlib has no lemma that the product of four consecutive integers plus one is square; it is not a named result.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the existential hides the witness from the one-shot battery.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14) — no battery tactic synthesises the witness m = n²+3n+1.
- **Difficulty:** 2
- **Decomposition sketch:** Provide the witness m = n² + 3n + 1 (i.e. `refine ⟨n^2 + 3*n + 1, ?_⟩`), then the residual goal is a polynomial identity over ℕ closed by `ring`. The pairing (n)(n+3) = n²+3n and (n+1)(n+2) = n²+3n+2 makes the product u(u+2) with u = n²+3n, so +1 = (u+1)².
