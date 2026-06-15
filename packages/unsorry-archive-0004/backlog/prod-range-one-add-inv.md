# prod-range-one-add-inv

For all n, ∏_{k=1}^{n} (k+1)/k = n+1 over ℚ — a telescoping product.

- **Source:** Classic combinatorial / finite-sum identity (library-growth batch, #400 plan Phase 3).
- **Reference:** For all n, ∏_{k=1}^{n} (k+1)/k = n+1 over ℚ — a telescoping product. Not a named mathlib lemma (Vandermonde/Pascal are present but not these specific closed forms).
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — an unbounded ∑/∏ over a free n that the one-shot battery cannot close (and `simp`/`aesop` over full Mathlib did not find a renamed duplicate).
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 3
- **Decomposition sketch:** induction + Finset.prod_Icc_succ_top + field_simp (telescope). Fully verified to build.
