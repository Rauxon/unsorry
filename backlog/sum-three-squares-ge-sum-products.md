# sum-three-squares-ge-sum-products

For all real a, b, c, the sum of squares dominates the sum of pairwise products: a² + b² + c² ≥ ab + bc + ca.

- **Source:** Classic three-variable inequality (a corollary of the rearrangement / sum-of-squares principle).
- **Reference:** ab + bc + ca ≤ a² + b² + c². mathlib has `inner_mul_le_norm_mul_norm` (Cauchy–Schwarz) and `sq_nonneg`, but no named three-variable "sum of squares ≥ sum of products" lemma.
- **Absence:** no-local-match (grep of pinned mathlib rev c5ea00351c, 2026-06-14); triviality-gate non-trivial (ADR-035) — the battery has `linarith` but not `nlinarith`, so the quadratic gap is not one-shot-closable.
- **Triviality:** machine-checked non-trivial (battery v1, rev c5ea00351c, 2026-06-14).
- **Difficulty:** 2
- **Decomposition sketch:** The difference equals ½[(a−b)² + (b−c)² + (c−a)²] ≥ 0. A single `nlinarith [sq_nonneg (a - b), sq_nonneg (b - c), sq_nonneg (c - a)]` closes it; the three square hints are exactly the SOS certificate.
