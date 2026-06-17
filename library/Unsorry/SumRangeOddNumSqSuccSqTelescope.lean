import Mathlib

/-!
# A telescoping sum identity

This module proves that the partial sums of `(2k+3) / ((k+1)^2 (k+2)^2)` telescope:
each summand equals the difference `1/(k+1)^2 - 1/(k+2)^2`, so the sum over
`Finset.range n` collapses to `1 - 1/(n+1)^2`.
-/

theorem sum_range_odd_num_sq_succ_sq_telescope (n : ℕ) :
    ∑ k ∈ Finset.range n, (2 * (k : ℚ) + 3) / ((((k : ℚ) + 1) ^ 2) * (((k : ℚ) + 2) ^ 2)) =
      1 - 1 / (((n : ℚ) + 1) ^ 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : ((m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : ((m : ℚ) + 2) ≠ 0 := by positivity
    push_cast
    field_simp
    ring
